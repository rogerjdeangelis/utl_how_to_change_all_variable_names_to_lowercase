How to Change all Variable Names to Lowercase

Same results in SAS and WPS
  (WPS cannot modify a SAS dataset. I created the upper case WPS dataset
   input)

github
https://github.com/rogerjdeangelis/utl_how_to_change_all_variable_names_to_lowercase

sas forum
https://communities.sas.com/t5/Base-SAS-Programming/How-to-Change-Variable-name/m-p/459023

RENAMEL MACRO
Ian Whitlock <whitloi1@westat.com>

VARLIST MACRO
Author: Søren Lassen, s.lassen@post.tele.dk


INPUT
=====

 WORK.CLASS total obs=19

  Obs    NAME       SEX    AGE    HEIGHT    WEIGHT  ** UPERCASE NAMES;

    1    Alfred      M      14     69.0      112.5
    2    Alice       F      13     56.5       84.0
    3    Barbara     F      13     65.3       98.0
  ...

WANT
====

 WORK.CLASS total obs=19

 Obs    name       sex    age    height    weight   ** CHANGE TO LOWER CASE

   1    Alfred      M      14     69.0      112.5
   2    Alice       F      13     56.5       84.0
   3    Barbara     F      13     65.3       98.0
   4    Carol       F      14     62.8      102.5
 ...


PROCESS
=======

* you cannot run this twice unless you recreate with uppercase names;

options validvarname=v7;

%let vars=%utl_varlist(class);

proc datasets lib=work;
 modify class;
 rename %utl_renamel(&vars,%lowcase(%lowcase(&vars)));
run;quit;

LOG

NOTE: Renaming variable NAME to name.
NOTE: Renaming variable SEX to sex.
NOTE: Renaming variable AGE to age.
NOTE: Renaming variable HEIGHT to height.
NOTE: Renaming variable WEIGHT to weight.


OUTPUT
======

p to 40 obs WORK.CLASS total obs=19

bs    name       sex    age    height    weight

 1    Alfred      M      14     69.0      112.5
 2    Alice       F      13     56.5       84.0
 3    Barbara     F      13     65.3       98.0
 4    Carol       F      14     62.8      102.5
 5    Henry       M      14     63.5      102.5
 6    James       M      12     57.3       83.0

 ...

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;


options validvarname=upcase;
data class;
 retain %utl_varlist(sashelp.class);
 set sashelp.class;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

*SAS;
options validvarname=v7;
%let vars=%utl_varlist(class);
proc datasets lib=work;
 modify class;
 rename %utl_renamel(&vars,%lowcase(&vars));
run;quit;

/*
NOTE: Renaming variable NAME to name.
NOTE: Renaming variable SEX to sex.
NOTE: Renaming variable AGE to age.
NOTE: Renaming variable HEIGHT to height.
NOTE: Renaming variable WEIGHT to weight.
*/


* WPS;
%utl_submit_wps64('
libname wrk sas7bdat "%sysfunc(pathname(work))";
proc print data=wrk.class;
run;quit;
data class;set wrk.class;run;quit;
%let vars=%utl_varlist(class);
options validvarname=v7;
proc datasets lib=work;
 modify class;
 rename %utl_renamel(&vars,%lowcase(&vars));
run;quit;
proc print data=class;
run;quit;
');
