/* xxvpcmt.p - vender po part ctrl maintance                                 */
/* revision: 110826.1   created on: 20110826   by: zhang yun                 */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110826.1"}

define variable del-yn like mfc_logical initial no.
define variable vdsort like vd_sort.

/* DISPLAY SELECTION FORM */
form
   xvp_vend colon 25 vdsort no-label
   xvp_part colon 25 skip(1)
   xvp_rule colon 25
   xvp_ord_min colon 25
   xvp_week colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.
repeat with frame a:

   prompt-for xvp_vend xvp_part editing:

      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i xvp_ctrl xvp_vend xvp_vend xvp_part xvp_part xvp_vend_part}

      if recno <> ? then do:
         display xvp_vend xvp_part xvp_rule xvp_ord_min xvp_week.
         find first vd_mstr no-lock where vd_addr = input xvp_vend no-error.
         if available vd_mstr then do:
            display vd_sort @ vdsort with frame a.
         end.
         else do:
            display "" @ vdsort with frame a.
         end.
      end.
   end.
   if not can-find(first vd_mstr no-lock where vd_addr = input xvp_vend)
     then do:
     {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}
      undo, retry.
   end.
   find first vd_mstr no-lock where vd_addr = input xvp_vend no-error.
   if available vd_mstr then do:
      display vd_sort @ vdsort with frame a.
   end.
   else do:
      display "" @ vdsort with frame a.
   end.
   /* ADD/MOD/DELETE  */
   find xvp_ctrl using xvp_vend where xvp_part = input xvp_part no-error.
   if not available xvp_ctrl then do:
      {mfmsg.i 1 1}
      create xvp_ctrl.
      assign xvp_vend xvp_part.
   end.
   recno = recid(xvp_ctrl).

   display xvp_vend xvp_part xvp_rule xvp_ord_min xvp_week.

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   do on error undo, retry:
      set xvp_rule xvp_ord_min xvp_week go-on("F5" "CTRL-D" ).

      /* DELETE */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      then do:
         del-yn = yes.
         {mfmsg01.i 11 1 del-yn}
         if not del-yn then undo, retry.
         delete xvp_ctrl.
         clear frame a.
         del-yn = no.
      end.
   end.
end.
status input.
