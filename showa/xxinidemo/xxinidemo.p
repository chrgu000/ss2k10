/* xxinidemo.p - initial demo information                                    */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy                             */
/* REVISION END                                                              */

{mfdtitle.i "120627.1"}
define variable yn like mfc_logical no-undo.
define variable dte as date.
define variable vfile as character.
{gpcdget.i "UT"}

Form yn colon 40
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

repeat with frame a:
update yn.
if not yn then leave.

assign vfile = "xxinidemo.p." + string(today,"99999999") + string(time).
output to value(vfile + ".bpi").
  put unformat "admin" skip.
  put unformat "-" skip.
  put unformat "- - - 321" skip.
  put unformat "321" skip.
  put unformat "." skip.
  put unformat "yes" skip.
  put unformat "." skip.
output close.

batchrun = yes.
input from value(vfile + ".bpi").
output to value(vfile + ".bpo") keep-messages.
hide message no-pause.
cimrunprogramloop:
do on stop undo cimrunprogramloop,leave cimrunprogramloop:
   {gprun.i ""mgurmt.p""}
end.
hide message no-pause.
output close.
input close.
batchrun = no.

assign dte = today.
output to value(vfile + ".bpi").
  put unformat "~~screens" skip.
  find last tr_hist no-error.
  if available tr_hist then do:
     assign dte = tr_date.
  end.
  put unformat '"GZ SHOWA TEST ' + string(dte,"9999-99-99") + '"' SKIP.
  put unformat "-" skip.
  put unformat "." skip.
  put unformat "." skip.
output close.

batchrun = yes.
input from value(vfile + ".bpi").
output to value(vfile + ".bpo") keep-messages.
hide message no-pause.
cimrunprogramloop1:
do on stop undo cimrunprogramloop1,leave cimrunprogramloop1:
   {gprun.i ""admgmt06.p""}
end.
hide message no-pause.
output close.
input close.
batchrun = no.
os-delete value(vfile + ".bpi").
os-delete value(vfile + ".bpo").
end.  /* repeat with frame a: */
status input.
