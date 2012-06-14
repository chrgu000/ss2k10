/* xxlnmt.p - Pack / Send parameter maintenance                              */
/* revision: 110422.1   created on: 20110422   by: zhang yun                 */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 0CYH LAST MODIFIED: 04/22/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

{mfdtitle.i "110422.1"}

define variable del-yn like mfc_logical initial no.

/* DISPLAY SELECTION FORM */
form
   xxlnm_site colon 25 skip
   xxlnm_line colon 25 label "Key" format "x(18)" skip(1)
   xxlnm_plead colon 20
   xxlnm_pmins colon 50
   xxlnm_slead colon 20
   xxlnm_smins colon 50
   xxlnm_desc colon 20
with frame a side-labels width 80 attr-space.
display "gsa01" @ xxlnm_site with frame a.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.
repeat with frame a:

   prompt-for xxlnm_line
   with frame a
   editing:
      if frame-field = "xxlnm_line" then do:
         {mfnp.i xxlnm_det xxlnm_line xxlnm_line xxlnm_site xxlnm_site xxlnm_linesite}
         if recno <> ? then do:
            display  xxlnm_site xxlnm_line xxlnm_plead xxlnm_pmins xxlnm_slead
                     xxlnm_smins xxlnm_desc
            with frame a.
         end.
      end. /* if frame-field */
      else if frame-field = "xxlnm_site" then do:
         {mfnp.i si_mstr xxlnm_site si_site xxlnm_site si_site si_site}
         if recno <> ? then do:
            display si_site @ xxlnm_site with frame a.
         end.
      end. /* else if */
      else do:
         readkey.
         apply lastkey.
      end.
   end. /* prompt-for */
   if input xxlnm_line <> "*" and
      not can-find(first pt_mstr no-lock where pt_part = input xxlnm_line
                     and pt_site = input xxlnm_site) and
      not can-find(first ln_mstr no-lock where ln_site = input xxlnm_site
                     and ln_line = input xxlnm_line) then do:
      {pxmsg.i &ERRORLEVEL=3
               &MSGTEXT=""输入错误,请确认资料""}

      undo,retry.
    end.
   /* ADD/MOD/DELETE  */
   find xxlnm_det where xxlnm_site = input xxlnm_site and
                  xxlnm_line = input xxlnm_line no-error.
   if not available xxlnm_det then do:
      {mfmsg.i 1 1}
      create xxlnm_det.
      assign xxlnm_site xxlnm_line.
   end.
   recno = recid(rsn_ref).

   display xxlnm_site xxlnm_line.

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   do on error undo, retry:
      set xxlnm_plead xxlnm_pmins xxlnm_slead
          xxlnm_smins xxlnm_desc go-on("F5" "CTRL-D" ).

      /* DELETE */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      then do:
         del-yn = yes.
         {mfmsg01.i 11 1 del-yn}
         if not del-yn then undo, retry.
         delete xxlnm_det.
         clear frame a.
         display "gsa01" @ xxlnm_site with frame a.
         del-yn = no.
      end.
   end.
end.
status input.
