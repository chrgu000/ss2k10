/* xxlblinp.p - import label to system.                                      */
/* REVISION: 1.0      LAST MODIFIED: 09/20/10   BY: zy                       */

/* DISPLAY TITLE */
{mfdtitle.i "09Y1"}
define variable filefrom as character format "x(56)".
define variable onlyfile as logical.
define variable cimfile  as character format "x(56)".
define variable tmpfile  as character.
define variable msgtxt   as character format "x(60)".
DEFINE TEMP-TABLE xxlbl
    FIELDS xx_fields AS CHARACTER
    FIELDS xx_term   LIKE lbl_term
    FIELDS xx_long   LIKE lbl_long
    FIELDS xx_medium LIKE lbl_medium
    FIELDS xx_short  LIKE lbl_short.

form
   filefrom colon 14 label "原文件" skip
   onlyfile colon 14 label "只产生文件" skip
   cimfile  colon 14 label "cim_load文件" skip(1)
   "文件格式：忽略#开头以逗号隔开的文本文件" colon 12 skip
   "#Fields,term,long,medium,short" colon 12
with frame a no-underline side-label width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

on "leave":u of filefrom do:
  assign filefrom.
  assign cimfile:screen-value = substring(filefrom,1,index(filefrom,"."))
                    + "cim".
end.

find qad_wkfl no-lock where qad_key1 = global_userid
 and qad_key2 = "xxlblinp.p" no-error.
if avail qad_wkfl then do:
   assign filefrom = qad_charfld[1]
          onlyfile = qad_logfld[1]
          cimfile  = qad_charfld[2].
end.

repeat:

   if c-application-mode <> 'web' then
   update filefrom onlyfile cimfile
      with frame a.

  if filefrom = "" then do:
      {pxmsg.i &MSGTEXT=""原文件不可为空。"" &ERRORLEVEL=3}
      undo,retry.
  end.

  if onlyfile and cimfile = "" then do:
      {pxmsg.i &MSGTEXT=""你选中了只产生文件，产生的文件不可为空。""
               &ERRORLEVEL=3}
      undo,retry.
  end.
   {wbrp06.i &command = update &fields = " filefrom onlyfile cimfile "
      &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      hide frame b.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 80
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

INPUT FROM value(filefrom).
    REPEAT:
        CREATE xxlbl.
        IMPORT DELIMITER "," xxlbl.
    END.
INPUT CLOSE.
assign tmpfile = "xlbl" + string(time) + ".cim".
if cimfile <> "" then do:
  assign tmpfile = cimfile.
end.

for each xxlbl exclusive-lock:
    if xx_fields BEGINS "#" or xx_fields = ""
    then do:
        delete xxlbl.
        next.
    end.
    find first lbl_mstr no-lock where lbl_term= xx_term no-error.
    if avail lbl_mstr then do:
       assign xx_long = lbl_long
              xx_medium = lbl_medium
              xx_short = lbl_short.
    end.
end.

OUTPUT TO value(tmpfile).
FOR EACH xxlbl NO-LOCK WHERE NOT xx_fields BEGINS "#":
     if not can-find(first lbl_mstr no-lock where lbl_lang = "CH" and
                           lbl_term = xx_term) then do:
       PUT UNFORMAT "@@batchload gplblmt.p" SKIP.
       PUT UNFORMAT "CH" SKIP.
       PUT UNFORMAT xx_term SKIP.
       PUT UNFORMAT '"' trim(xx_long) '" "' trim(xx_medium) '" "'
                        trim(xx_short) '"' SKIP.
       PUT UNFORMAT "@@END" skip.
     END.
     if not can-find(first lbld_det no-lock where lbld_fieldname = xx_fields
              and lbld_execname= '' and lbld_term = xx_term) then do:
       PUT UNFORMAT "@@batchload gplbldmt.p" SKIP.
       PUT UNFORMAT '"' trim(xx_fields) '"' SKIP.
       PUT UNFORMAT '"' trim(xx_term) '"' SKIP.
       PUT UNFORMAT "@@end" skip.
     end.
END.
OUTPUT CLOSE.

if not onlyfile then do:
{gprun.i ""xxcimpro.p"" "(INPUT tmpfile,output msgtxt)"}
display msgtxt column-label "装入结果：" with frame c.
os-delete value(tmpfile) no-error.
end.

FOR EACH xxlbl NO-LOCK WHERE NOT xx_fields BEGINS "#" with frame b:

  /* SET EXTERNAL LABELS */
  setFrameLabels(frame b:handle).

display xx_fields column-label "字段名"
        xx_term   column-label "项目"
        xx_long   column-label "长标签"
        xx_medium column-label "中标签"
        xx_short  column-label "短标签" with width 200 stream-io.
  {mfrpexit.i "false"}
end.

	{mfreset.i}
	{pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

	find qad_wkfl no-lock where qad_key1 = global_userid
	 and qad_key2 = "xxlblinp.p" no-error.
	if avail qad_wkfl then do:
	   assign filefrom = qad_charfld[1]
	          onlyfile = qad_logfld[1]
	          cimfile  = qad_charfld[2].
	end.
	else do:
	   create qad_wkfl.
	   assign qad_key1 = global_userid
	          qad_key2 = "xxlblinp.p"
	          filefrom = qad_charfld[1]
	          onlyfile = qad_logfld[1]
	          cimfile  = qad_charfld[2].
	end.

end.

{wbrp04.i &frame-spec = a}
