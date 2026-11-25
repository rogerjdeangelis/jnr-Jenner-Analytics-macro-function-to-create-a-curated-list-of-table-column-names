/*---
c:/utl/jnr-Jenner-Analytics-macro-function-to-create-a-curated-list-of-table-column-names.sas
---*/
Jenner Analytics macro function to create a curated list of table column names

Too long to post, see
https://tinyurl.com/mrp6dapy
https://github.com/rogerjdeangelis/jnr-Jenner-Analytics-macro-function-to-create-a-curated-list-of-table-column-names

PROBLEM
  SELECT FILTERED LIST OF COLUMN NAMES

CONTENTS
  1 INPUT
  2 PROCESS & OUTPUT
  3 JNR_VARLIST MACRO

/**************************************************************************************************************************/
/* 1 INPUT                                                                                                                */
/**************************************************************************************************************************/

GIVEN JENHELP.CLASS
Obs    Name       Sex    Age    Height    Weight
LIST: 25NOV2026:10:32:14

  1    Amir        M      13     61.2       95.0
  2    Bethany     F      14     63.8      105.0
  3    Carlos      M      12     58.5       88.0
 ...
 19    Samuel      M      14     66.0      120.0

/**************************************************************************************************************************/
/* 2 PROCESS & OUTPUT                                                                                                     */
/**************************************************************************************************************************/

USAGE CREATE CURATED LISTS OF COLUMN NAMES

%put vars=%jnr_varlist(libname=SASHELP,memname=CLASS,prx='/GHT|AGE/i');
vars=AGE HEIGHT WEIGHT

%put vars=%jnr_varlist(libname=SASHELP,memname=CLASS);
vars=NAME SEX AGE HEIGHT WEIGHT

%put vars=%jnr_varlist(libname=SASHELP,memname=CLASS,function=quote);
vars="NAME" "SEX" "AGE" "HEIGHT" "WEIGHT"

%put vars=%jnr_varlist(libname=SASHELP,memname=CLASS
  ,keep=name sex age,function=quote,od=',');
vars="NAME","SEX","AGE"

%put vars=%jnr_varlist(libname=SASHELP,memname=CLASS,keep=_numeric_);
vars=AGE HEIGHT WEIGHT

%put vars=%jnr_varlist(libname=SASHELP,memname=CLASS,keep=_char_);
vars=NAME SEX

/**************************************************************************************************************************/
/* 3 JNR_VARLIST MACRO                                                                                                    */
/**************************************************************************************************************************/

filename ft15f001 "c:/otojnr/jnr_varlist.sas"; /*--- save in autocall library ---*/
parmcards4;
/******************************************************************************************************************/
/*  INPUT JENHELP.CLASS WITH COLUMNS NAME SEX AGE HEIGHT WEIGHT                                                   */
/*                                                                                                                */
/*  USAGE NAME MATCHING                                                                                           */
/*  %put vars=%jnr_varlist(libname=SASHELP,memname=CLASS,prx='/GHT|AGE/i');                                       */
/*  vars=AGE HEIGHT WEIGHT                                                                                        */
/*                                                                                                                */
/*  %put vars=%jnr_varlist(libname=SASHELP,memname=CLASS);                                                        */
/*  vars=NAME SEX AGE HEIGHT WEIGHT                                                                               */
/*                                                                                                                */
/*  %put vars=%jnr_varlist(libname=SASHELP,memname=CLASS,function=quote);                                         */
/*  vars="NAME" "SEX" "AGE" "HEIGHT" "WEIGHT"                                                                     */
/*                                                                                                                */
/*  %put vars=%jnr_varlist(libname=SASHELP,memname=CLASS                                                          */
/*    ,keep=name sex age,function=quote,od=',');                                                                  */
/*  vars="NAME","SEX","AGE"                                                                                       */
/*                                                                                                                */
/*  %put vars=%jnr_varlist(libname=SASHELP,memname=CLASS,keep=_numeric_);                                         */
/*  vars=AGE HEIGHT WEIGHT                                                                                        */
/*                                                                                                                */
/*  %put vars=%jnr_varlist(libname=SASHELP,memname=CLASS,keep=_char_);                                            */
/*  vars=NAME SEX                                                                                                 */
/******************************************************************************************************************/
%macro jnr_varlist(
    libname=jenhelp
   ,memname=class
   ,function=    /*--- lowcase, quote... ---*/
   ,od=' '       /*--- delimiter         ---*/
   ,prx='/^/'    /*-- "/^/" always match ---*/
   ,keep=_all_
   ,drop=
 ) / des='Curated list of variable names';
%global varlist;          /*--- drops keeps      ---*/
%let rc=%sysfunc(dosubl(  /*--- reduce meta data ---*/
   data __keepdrop__ %str(;)
    set &libname..&memname(obs=1 keep=&keep) %str(;)
    drop &drop %str(;)
run %str(;)
proc sql %str(;)
    select &function(name) into :varlist separated by &od
    from sashelp.vcolumn
    where upcase(libname) = 'WORK'
    and upcase(memname) = upcase('__keepdrop__' )
    and prxmatch(&prx, name) > 0
    order by varnum
%str(;) quit %str(;)
));
&varlist
%mend jnr_varlist;
;;;;
run;

/*--- END ---*/
