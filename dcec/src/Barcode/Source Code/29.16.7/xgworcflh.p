/*Program: xgworcflh.p   BACKFLUSH CIM LOAD */
/* Author: Jane Wang date: 08/16/2005 */
/* Last Modified BY: Li Wei Date:2005-11-28 ECO *lw01*  */

{mfdeclre.i}
define input  parameter iWoLot   like wo_lot.
define input  parameter iEffDate like wo_due_date.
define input  parameter iloc     like loc_loc.
define input  parameter isite     like loc_site.
define input  parameter iproqty   as dec.
/*lw01*/
define shared stream source_str.
define shared variable source_file as character .

&IF OPSYS = 'UNIX' &THEN
   &SCOPED-DEFINE DIRSEP /
&ELSE 
   &SCOPED-DEFINE DIRSEP ~\
&ENDIF


output stream source_str to value(source_file) append .

put stream source_str unformatted "@@batchload wowoisrc.p" skip.
put stream source_str '" ' + " " + '" ' at 1 
                   "~"" + iWolot + "~"" format "x(10)" 
		" ~"" + string(iEffDate) + "~"" format "x(11)"
		" yes" + " yes"  skip.
put stream source_str iproqty at 1 " - - - - -"
                 " ~"" + isite + "~"" format "x(11)"
                 " ~"" + iloc + "~" -" format "x(11)"
                 skip.
put stream source_str unformatted  '"'  "WO" '" ' "Yes" skip . /*remark & close wo*/
/****lw01 ***/
if opsys = "unix" then put stream source_str "no" at 1 skip. /* display detail*/ 
/**lw01**/
put stream source_str "Yes" at 1 skip. /*Is all information correct*/ 
/*put stream source_str "yes" at 1 skip. */
put stream source_str "-" at 1 skip. /*Backflush QTY*/
put stream source_str "-" at 1 skip. /*Qty Calculation Method*/ 
put stream source_str "-" at 1 skip. /*Backflush Method*/   /*******
put stream source_str "-" at 1 skip. /*use the default parts*/   *************/
put stream source_str "." at 1 skip. /*use the default parts*/
put stream source_str "no" at 1 skip. /*Display items being issued*/
put stream source_str "yes" at 1 skip. /*Is all information correct*/   
if opsys = "unix" then  put stream source_str "yes" at 1 skip. /*Please confirm update*/
/****
IF opsys = "WIN32" or opsys = "MSDOS" then  put stream source_str "@@end" skip.
********/
put stream source_str "." skip "." skip "@@end" skip.
output stream source_str close.

