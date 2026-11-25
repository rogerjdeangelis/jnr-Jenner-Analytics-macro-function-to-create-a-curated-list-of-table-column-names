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
