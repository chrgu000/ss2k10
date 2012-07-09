/*xxpt04rp.p - Item pack status Report                                       */
/*revision: 120612.1   created on: 20110831   by: zhang yun                  */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

{mfdtitle.i "120709.1"}

define variable part  like pt_part no-undo.
define variable part1 like pt_part no-undo.

form
   skip(.2)
   part  colon 15
   part1 colon 49 label {t001.i} skip(2)
with frame a  side-labels width 80 attr-space.
setframelabels(frame a:handle).

{wbrp01.i}
repeat:
    if part1 = hi_char then part1 = "".
    update part part1 with frame a.

    if part1 = "" then part1 = hi_char.

{gpselout.i &printtype = "printer"
            &printwidth = 80
            &pagedflag = "nopage"
            &stream = " "
            &appendtofile = " "
            &streamedoutputtoterminal = " "
            &withbatchoption = "yes"
            &displaystatementtype = 1
            &withcancelmessage = "yes"
            &pagebottommargin = 6
            &withemail = "yes"
            &withwinprint = "yes"
            &definevariables = "yes"}

 {mfphead2.i}  /* PRINT PAGE HEADING FOR REPORTS 80 COLUMNS */
mainloop:
do on error undo, return error on endkey undo, return error:

   for each pt_mstr no-lock where pt_part >= part and pt_part <= part1
       with frame b width 240:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
            display  pt_part
                     pt_desc1
                     pt__chr10
                     pt__qad20
                     pt__qad19.
       {mfrpchk.i}
   end.
end. /* mainloop: */
 {mftrl080.i}  /* REPORT TRAILER */
{pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.  /* repeat */
{wbrp04.i &frame-spec = a}

