/*xxhdrp.p                                                                  */
/* revision: 110831.1   created on: 20110831   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

{mfdtitle.i "110831.1"}

define variable site like si_site no-undo.
define variable yr  as integer no-undo format "9999".
define variable mth as integer no-undo initial 1.
define variable mth1 as integer no-undo initial 12.
define variable weeks as integer no-undo.

form
   skip(.2)
   site colon 15
   yr   colon 15
   mth  colon 15
   mth1 colon 39 label {t001.i}
skip(1)
with frame a  side-labels width 80 attr-space.
setframelabels(frame a:handle).
assign yr = year(today).
find first si_mstr no-lock where si_site <> "" no-error.
if available(si_mstr) then assign site = si_site.
{wbrp01.i}
repeat:
    update site yr mth mth1 with frame a.
 
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
mainloop:
do on error undo, return error on endkey undo, return error:
  {mfphead.i}
  for each hd_mstr no-lock where (hd_site = site or site = "") and
     year(hd_date) = yr and
     month(hd_date) >= mth and month(hd_date) <= mth1 with frame x:
     setframelabels(frame x:handle).
     display hd_site hd_date weekday(hd_date) - 1 @ weeks hd_desc.
     {mfrpchk.i}
  end.
end. /* mainloop: */
 {mfrtrail.i}  /*REPORT TRAILER*/

{pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.  /* repeat */
{wbrp04.i &frame-spec = a}
