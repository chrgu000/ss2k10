/*Program: xgworcflh.p   BACKFLUSH CIM LOAD */
/* Author: Jane Wang date: 08/16/2005 */
/* Last Modified BY: Li Wei Date:2005-11-28 ECO *lw01* */

         /* DISPLAY TITLE */
/*         {mfdeclre.i}*/
{mfdtitle.i}
define input  parameter iWoLot   like wo_lot.
define input  parameter iEffDate like wo_due_date.
define input  parameter iloc     like loc_loc.

/*lw01*/ define variable errors as integer.

for first wo_mstr where wo_lot = iwolot no-lock: end.

&IF OPSYS = 'UNIX' &THEN
   &SCOPED-DEFINE DIRSEP /
&ELSE 
   &SCOPED-DEFINE DIRSEP ~\
&ENDIF

DEFINE VARIABLE Source_file as character init "bkflh.txt" .
DEFINE VARIABLE log_file    as character init "bkflh.log" .

/***
Source_file = "." + "{&DIRSEP}" + "xworc" + mfguser + ".cim".
log_file    = "." + "{&DIRSEP}" + "xworc" + mfguser + ".log".
***/

if opsys = "WIN32" or opsys = "MSDOS" then 
assign source_file = "c:\bkflh.txt"
       log_file    = "c:\bkflh.log".

if search(Source_file) <> ? then
      os-delete value(Source_file).
   if search(log_file) <> ? then
      os-delete value(log_file).

/*lw01*/ def new shared stream Sourcedata.
/*lw01
def stream outLog.
output stream SourceData close.
*/
output stream SourceData to value(Source_file) no-echo no-map .
/*lw01
output close.
output to value(log_file) no-echo no-map .
*/
/****
if opsys = "WIN32" or opsys = "MSDOS" then 
  do:
    put stream Sourcedata "@@batchload wowoisrc.p" at 1 skip.
  end.
  **************/
/*lw01*/ put stream Sourcedata unformatted "@@batchload wowoisrc.p" skip.
put stream Sourcedata '" ' + " " + '" ' at 1 
                   "~"" + iWolot + "~"" format "x(10)" 
		" ~"" + string(iEffDate) + "~"" format "x(11)"
		" yes" + " yes"  skip.
put stream Sourcedata wo_qty_ord - wo_qty_comp at 1 " - - - - -"
                 " ~"" + wo_site + "~"" format "x(11)"
                 " ~"" + iloc + "~"" format "x(11)" skip.

put stream Sourcedata "-" + " yes" at 1 skip. /*remark & close wo*/

put stream Sourcedata "no" at 1 skip. /* display detail*/ 

put stream Sourcedata "yes" at 1 skip. /*Is all information correct*/ 
/*put stream Sourcedata "yes" at 1 skip. */
put stream Sourcedata "-" at 1 skip. /*Backflush QTY*/
put stream Sourcedata "-" at 1 skip. /*Qty Calculation Method*/ 
put stream Sourcedata "-" at 1 skip. /*Backflush Method*/   
put stream Sourcedata "-" at 1 skip. /*use the default parts*/   
put stream Sourcedata "." at 1 skip. /*use the default parts*/
put stream Sourcedata "no" at 1 skip. /*Display items being issued*/
put stream Sourcedata "yes" at 1 skip. /*Is all information correct*/   
put stream Sourcedata "yes" at 1 skip. /*Please confirm update*/ 
/*lw01*/ put stream Sourcedata  "." skip "." skip "@@end" skip.
output stream Sourcedata close.

/*lw01
/*CimLoad file for 17.1*/
{gprun.i ""xgsfcim.p"" "(input source_file,input iWolot,input proQty)" }
*/
/********* Delete By lw01 *****************************
if opsys = "UNIX" then do:
    output close .  
    output to value(log_file) .
    input from value(Source_file) no-echo.
	 do /*transaction*/ on error undo, retry:       /* TRANSACTION xw*/
	    {gprun.i ""wowoisrc.p""}
	 end. /*do transaction on error undo, retry*/   /* TRANSACTION xw*/
    input close.
    output close.
end.
else do:
    output close .
         batchrun = yes.
    input from value(Source_file) .
    output to  value(log_file) keep-messages.
	
	 do on error undo, retry:       /* TRANSACTION xw*/
	    {gprun.i ""wowoisrc.p""}
	 end. /*do transaction on error undo, retry*/       /* TRANSACTION xw*/
   hide message no-pause.
   input  close.
   batchrun = no.
end.
******************************************************/


/****** This section added by lw01 ************/
       {xgcmdef.i "new"}
       do transaction on error undo,leave:
          {gprun.i ""xgcm001.p""
          "(INPUT Source_file,
          output errors)"}
           if errors > 0 then do:
               {mfselprt.i "terminal" 132}
               for each cim_mstr break by cim_group:
                   disp cim_desc with width 200 stream-io.
               end.
               {mfreset.i}
               undo , leave.
           end.
           else do:
              message "INF:数据导入成功!".
              pause 3.
              os-delete silent value(Source_file).
           end.
           release xwck_mstr.
       end. /*do transaction*/
/****** This section added by lw01 ************/
