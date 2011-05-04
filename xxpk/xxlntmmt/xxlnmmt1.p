/* xxlnmt.p - Line shift MAINT                                               */
/* revision: 110422.1   created on: 20110422   by: zhang yun                 */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 0CYH LAST MODIFIED: 04/22/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

{mfdtitle.i "110422.1"}
{pxmaint.i}
{xxtimestr.i}
{pxphdef.i lnlnxr}

define new shared variable cmtindx  like lnd_cmtindx.
define variable del-yn as logical.
define variable flow      as logical no-undo.
define variable ln_recid  as recid   no-undo.
define variable lnm_recid as recid   no-undo.
define variable rpc_allow_rate like mfc_logical no-undo.
define variable lnmtpdesc as character no-undo.

/* Display Forms */
form
   ln_line colon 20 label "Production Line"
   ln_site colon 20 si_desc no-label
   skip(1)
   ln_desc colon 20 label "Description"
   ln_rate colon 20
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   xxlnm_type colon 20 lnmtpdesc no-label
   xxlnm_time colon 20 skip(1)
   xxlnm_desc colon 20
with frame bb side-labels width 80
title color normal (getFrameTitle("REPLENISHMENT_TIME",14)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame bb:handle).
view frame a.
view frame bb.

mainloop:
repeat:

   prompt-for
      ln_line
      ln_site
   with frame a
   editing:
       clear frame bb no-pause.
      if frame-field = "ln_line" then do:
         {mfnp.i ln_mstr ln_line ln_line ln_site ln_site ln_linesite}
         if recno <> ? then do:
            display ln_line ln_site ln_desc ln_rate
            with frame a.
         end.
      end. /* if frame-field */
      else if frame-field = "ln_site" then do:
         {mfnp.i si_mstr ln_site si_site ln_site si_site si_site}
         if recno <> ? then do:
            display si_site @ ln_site si_desc with frame a.
         end.
      end. /* else if */
      else do:
         readkey.
         apply lastkey.
      end.
   end. /* prompt-for */

   find si_mstr where si_site = input ln_site no-lock no-error.
   if not available si_mstr then do:
      next-prompt ln_site with frame a.
      {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3} /* SITE DOES NOT EXISTS */
      undo, retry.
   end.

   for first mfc_ctrl
      field(mfc_field mfc_logical)
      where mfc_field = "rpc_allow_rate"
   no-lock:
   end. /* FOR FIRST mfc_ctrl */

   if available mfc_ctrl
   then
      rpc_allow_rate = mfc_logical.

   do transaction with frame a:

      find ln_mstr using ln_line and ln_site exclusive-lock no-error.
      if not available ln_mstr
      then do:

         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} /* ADDING NEW RECORD */
         create ln_mstr.
         assign
            ln_line = input ln_line
            ln_site = input ln_site.
         if recid(ln_mstr) = -1 then .

      end. /* IF NOT AVAILABLE ln_mstr */

      ln_recid = recid(ln_mstr).

      /* LOCK THE ln_mstr RECORD WHILE ITEMS DETAILS ARE MODIFIED */

      for first ln_mstr
         fields(ln_desc ln_line ln_rate ln_site)
         where recid(ln_mstr) = ln_recid
      exclusive-lock:
      end. /* FOR FIRST ln_mstr */

      display ln_desc ln_rate with frame a.

      set1:
      do on error undo, retry:

         del-yn = no.

         ststatus = stline[2].
         status input ststatus.

         set
            ln_desc
            ln_rate
         go-on (F5 CTRL-D) with frame a.

         if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
            del-yn = no.
            /* Please confirm delete */
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
            if del-yn = no then undo set1.
         end.

      end. /* set1 */

   end. /* DO TRANSACTION */

   /* delete */
   if del-yn
   then do transaction :

      for first ln_mstr
         fields(ln_desc ln_line ln_rate ln_site)
         where recid(ln_mstr) = ln_recid
      exclusive-lock:
      end. /* FOR FIRST ln_mstr */

      /* Ensure production line is not in use in a Flow Schedule,      */
      /* Repetitive Schedule, Ops Planning module, or Schedule Record. */
      {pxrun.i &PROC='checkLineOnSchedules' &PROGRAM='lnlnxr.p'
               &HANDLE=ph_lnlnxr
         &PARAM="(input ln_site,
                  input ln_line)"
         &NOAPPERROR=true
         &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT} then
         undo mainloop, retry mainloop.

      for each xxlnm_det where xxlnm_line = ln_line
                         and xxlnm_site = ln_site
      exclusive-lock:

         delete xxlnm_det.

      end. /* for each lnd_det */

      /* Determine if any associated flow detail records to ln_mstr exist. */
      {pxrun.i &PROC='checkForFlowLineDetailRecords' &PROGRAM='lnlnxr.p'
               &HANDLE=ph_lnlnxr
         &PARAM="(input ln_site,
                  input ln_line,
                  output flow)"
         &NOAPPERROR=true
         &CATCHERROR=true}

      /* Flow production line detail exists.  Not deleted. */
      if flow then
         {pxmsg.i &MSGNUM=5567 &ERRORLEVEL={&INFORMATION-RESULT}}
      else
         delete ln_mstr.
      clear frame a.
      next mainloop.

   end. /* if del-yn */

   status input.

   repeat with frame bb:

      for first ln_mstr
         fields(ln_desc ln_line ln_rate ln_site)
         where recid(ln_mstr) = ln_recid
      exclusive-lock:
      end. /* FOR FIRST ln_mstr */

      prompt-for
         xxlnm_type xxlnm_time
      editing:

         if frame-field = "xxlnm_type" then do:
            {mfnp06.i xxlnm_det xxlnm_line
               "xxlnm_line = input ln_line and xxlnm_site = input ln_site"
               xxlnm_type "input xxlnm_type" """" """"}

            if recno <> ? then do:
               assign lnmtpdesc = "".
               find first code_mstr no-lock where
                          code_fldname = "xxlnm_type" and
                          code_value = xxlnm_type no-error.
               if available code_mstr then do:
                  assign lnmtpdesc = code_cmmt.
               end.
               display
                    xxlnm_type lnmtpdesc
                    xxlnm_time
                    xxlnm_desc
               with frame bb.
            end. /* if recno */
            else do:
               assign lnmtpdesc = "".
               find first code_mstr no-lock where
                          code_fldname = "xxlnm_type" and
                          code_value = input xxlnm_type no-error.
               if available code_mstr then do:
                  assign lnmtpdesc = code_cmmt.
               end.
               display "" @ xxlnm_time lnmtpdesc with frame bb.
            end.

         end. /* frame-field */

         else do:
            readkey.
            apply lastkey.
         end.
      end. /* editing */

      find xxlnm_det
         where xxlnm_line = ln_line
           and xxlnm_site = ln_site
           and xxlnm_type = input xxlnm_type
           and xxlnm_time = input xxlnm_time
      exclusive-lock no-error.

      if not available xxlnm_det then do:
         create xxlnm_det.
         assign
                xxlnm_line = ln_line
                xxlnm_site = ln_site
                xxlnm_type
                xxlnm_time.
         assign xxlnm_itime = s2t(xxlnm_time).

      end.

      display
              xxlnm_type
              xxlnm_time
              xxlnm_desc
      with frame bb.

      set2:
      do on error undo, retry:

         del-yn = no.
         ststatus = stline[2].
         status input ststatus.

         set xxlnm_desc
         go-on (F5 CTRL-D) with frame bb.
         display
              xxlnm_type
              xxlnm_time
              xxlnm_desc
         with frame bb.
         if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
            del-yn = no.
            /*CHECK FOR EXISTENCE OF REPETITIVE SCHEDULE FOR AN ITEM BEFORE  */
            /*  DELETING IT.                                                 */
            hide message.
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

            if del-yn = no then undo set2.
            else do:
                delete xxlnm_det.
                clear frame bb no-pause.
            end.
         end.  /* if lastkey */

      end. /* set2 */

      /* RELEASE THE RECORDS TO AVOID DEAD-LOCK SITUATION */
      release xxlnm_det.
      status input.

   end. /* with frame bb */
   release ln_mstr.

end. /* mainloop */