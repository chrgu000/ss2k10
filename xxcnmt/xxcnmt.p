/* xxcnmt.p - Container List MAINT                                           */
/* revision: 110314.1   created on: 20110314   by: zhang yun                 */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 0CYH LAST MODIFIED: 03/23/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110323.1"}

define variable del-yn like mfc_logical initial no.
define variable vdsort like vd_sort.

/* DISPLAY SELECTION FORM */
form
   xxcn_vend format "x(8)" colon 25 vdsort no-label
   xxcn_spc  format "x(20)" colon 25 skip(1)
   xxcn_type format "x(4)" colon 25
   xxcn_desc format "x(40)" colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.
repeat with frame a:

   prompt-for xxcn_vend xxcn_spc editing:

      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i xxcn_det xxcn_vend xxcn_vend xxcn_spc xxcn_spc xxcn_vend_spc}

      if recno <> ? then do:
         display xxcn_vend xxcn_spc xxcn_type xxcn_desc.
         find first vd_mstr no-lock where vd_addr = input xxcn_vend no-error.
         if available vd_mstr then do:
            display vd_sort @ vdsort with frame a.
         end.
         else do:
            display "" @ vdsort with frame a.
         end.
      end.
   end.
   if not can-find(first vd_mstr no-lock where vd_addr = input xxcn_vend)
     then do:
     {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}
      undo, retry.
   end.
   find first vd_mstr no-lock where vd_addr = input xxcn_vend no-error.
   if available vd_mstr then do:
      display vd_sort @ vdsort with frame a.
   end.
   else do:
      display "" @ vdsort with frame a.
   end.
   /* ADD/MOD/DELETE  */
   find xxcn_det using xxcn_vend where xxcn_spc = input xxcn_spc no-error.
   if not available xxcn_det then do:
      {mfmsg.i 1 1}
      create xxcn_det.
      assign xxcn_vend xxcn_spc.
   end.
   recno = recid(xxcn_det).

   display xxcn_vend xxcn_spc xxcn_type xxcn_desc.

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   do on error undo, retry:
      set xxcn_type xxcn_desc go-on("F5" "CTRL-D" ).

      /* DELETE */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      then do:
         del-yn = yes.
         {mfmsg01.i 11 1 del-yn}
         if not del-yn then undo, retry.
         delete xxcn_det.
         clear frame a.
         del-yn = no.
      end.
   end.
end.
status input.