/* xxinitrloc.p - Initial assbline location                                  */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120605.1 LAST MODIFIED: 06/05/12 BY: zy                         */
/* REVISION END                                                              */

{mfdtitle.i "120605.1"}
define variable yn like mfc_logical no-undo.
{gpcdget.i "UT"}

Form yn colon 40
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

repeat with frame a:
update yn.
if not yn then leave.

   output to x.bpi.
   for each wc_mstr no-lock,
       each loc_mstr no-lock where loc_site = "gsa01" and
            loc_loc = wc_wkctr:
       put unformat wc_wkctr skip.
       put unformat '50 -' skip.
   end.
   put unformat 'P-ALL' skip.
   put unformat '50 -' skip.
   output close.

   batchrun = yes.
   input from "x.bpi".
   output to "x.bpo" keep-messages.
   hide message no-pause.
   cimrunprogramloop:
   do on stop undo cimrunprogramloop,leave cimrunprogramloop:
      {gprun.i ""xxtrlocmt.p""}
   end.
   hide message no-pause.
   output close.
   input close.
   batchrun = no.
   os-delete "x.bpi" no-error.
   os-delete "x.bpo" no-error.
leave.
end.  /* repeat with frame a: */
status input.
