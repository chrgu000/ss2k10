/*Program: xxbkflh02.p   回冲事务处理        */
/*CIM LOAD for Cummins, 8.5f03 Character*/
/* Project:                                */
/* Author: Sunny Zhou                        */
/* Copy Right:  Atos Origin                */
/*Date:         Aug 15,2002                */


DEFINE VARIABLE Source_file as character format "x(60)".
DEFINE VARIABLE log_file    as character format "x(60)".
DEFINE VARIABLE work_file   as character format "x(60)".
DEFINE VARIABLE bak_log	    as character format "x(60)".
DEFINE VARIABLE xRunning    as logic initial no.
DEFINE VARIABLE xText	    as character format "x(200)".
DEFINE VARIABLE i	    as integer initial 1.
DEFINE VARIABLE err-status AS INTEGER.

&SCOPED-DEFINE xxbkflh_10 "回冲事务控制文件没有设置!"
&SCOPED-DEFINE xxbkflh_11 "前一进程仍旧没完,请与 IT 人员联系!"

def stream Sourcedata.
def stream outLog.
def stream cimfile.
def stream logfile.

FOR first usrw_wkfl where usrw_key1 = "BKFLH-CTRL" exclusive-lock: END.
IF available usrw_wkfl THEN
DO:
/*  usrw_charfld[10] colon 15  label "工作路径\文件"   format "x(60)" skip
    usrw_charfld[11] colon 15  label "输入路径\文件"   format "x(60)" skip
    usrw_charfld[12] colon 15  label "LOG 路径\文件"   format "x(60)" skip(1)
*/
    work_file = usrw_charfld[10].
    Source_file = usrw_charfld[11].
    log_file = usrw_charfld[12].
END.
ELSE DO:
/*        message {&xxbkflh_10} view-as alert-box warning buttons ok. */
/*	PUT "ERROR: "  {&xxbkflh_10}  skip. */
/*	message {&xxbklfh_10} .  */
/*	pause 10. */
	return.
END.

OUTPUT close.
OUTPUT to value(log_file) Append.
put skip(1).
put "=======================  Run Date: " today   "   Run Time: " string(time,"HH:MM:SS") "================" skip (1).

if search(work_file) <> ? then xRunning = yes. 
i = 1.
do while xRunning:
    pause 10 no-message.
    if Search(work_file) <> ? then xRunning = yes.
                              else xRunning = no.
    i = i + 1 .
    if xRunning then do:
	OS-DELETE value(work_file).
	err-status = OS-ERROR.
	IF err-status <> 0 THEN
	CASE err-status:
		WHEN 1 THEN DO:
			PUT  "ERROR: You are not the owner of work file or directory." skip(1).
			return.
			END.
		WHEN 2 THEN DO:
			PUT "ERROR: Work file you want to delete does not exist." skip(1).
			return.
			END.
		OTHERWISE DO:
			PUT "OS Error #" + STRING(OS-ERROR,"99") + trim(work_file) 
			FORMAT "x(80)" skip(1).
			END.
	END CASE.
     end. /*if xRunning */

    IF i = 60 THEN
    DO:
/*        message {&xxbkflh_11} view-as alert-box warning buttons ok. */
	PUT "ERROR: "  {&xxbkflh_11}  skip.
	return.
    END.
end.

/* mfg/pro batch job 
"batch" "batch"
"mgbatch.p"
"setqty"
.
.
"Y"
*/
  output stream cimfile close .
  output stream cimfile to value(work_file) no-echo no-map.

   put stream cimfile  '"' usrw_key2  '"'  " "
	    '"' usrw_charfld[1] '"'  skip.

    output stream cimfile close.

IF search(source_file) <> ? THEN
DO:
  input stream Sourcedata close .
  input stream Sourcedata from value(source_file) .
  import stream Sourcedata UNFORMATTED xText.
  input stream Sourcedata close.
  IF  (xText matches ("*rebkfl.p*")) THEN
  DO:
   os-append value(source_file) value(work_file).
   if search(work_file) <> ? then os-delete value(source_file).
  END.
  ELSE DO:
      PUT "ERROR: Source File: " + trim(source_file) + "  FORMAT INCORRECT !!!!" format "x(80)" skip(1) .
      return.
  END.

END.
ELSE DO: 
      PUT "ERROR: can not find Source File: " + trim(source_file) + " !!!!" format "x(80)" skip(1) .
      return.
END.

INPUT CLOSE.
INPUT from value(work_file).
PAUSE 0 BEFORE-HIDE.
RUN MF.P.
INPUT CLOSE.
OUTPUT CLOSE.
