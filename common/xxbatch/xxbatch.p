/* xxbatch.p - batchrun status maintance                                     */
/* REVISION:101020.2 LAST MODIFIED: 10/20/10 BY: zy                          */
/*V8:ConvertMode=NoConvert                                                   */
/*-Revision end--------------------------------------------------------------*/
{mfdtitle.i "130304.1"}
define variable yn like mfc_logical no-undo.
define variable stat as character format "x(20)".
{gpcdget.i "UT"}

Form 
      stat colon 40 skip(2)
      yn colon 40
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

assign stat = "batchrun = " + string(batchrun).
assign yn = not batchrun.
display stat yn with frame a.

repeat with frame a:
update yn.
assign batchrun = yn.
assign stat = "batchrun = " + string(yn).
display stat with frame a.
leave.
end.  /* repeat with frame a: */
{pxmsg.i &MSGTEXT=stat &ERRORLEVEL=1}
pause.
status input.
