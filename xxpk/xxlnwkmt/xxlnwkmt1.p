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
define variable sw_reset    like mfc_logical.
define new shared variable cmtindx     like lnd_cmtindx.
define variable del-yn as logical.
define variable shiftdesc like code_cmmt label "COMMENT".
define variable flow      as logical no-undo.
define variable ln_recid  as recid   no-undo.
define variable rpc_allow_rate like mfc_logical no-undo.
define variable xxlnwsn like xxlnw_sn.
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
   xxlnw_sn format "->>9"
   xxlnw_Start
   xxlnw_End
   xxlnw_rstmin
   xxlnw_shift format "x(4)"
   shiftdesc format "x(6)"
   xxlnw_wktime
   with frame bb down width 80 attr-space.
/* with frame bb side-labels width 80                           */
/* title color normal (getFrameTitle("PRODUCTION_HOURS",14)).   */

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

      for each xxlnw_det where xxlnw_line = ln_line
                         and xxlnw_site = ln_site
      exclusive-lock:

         delete xxlnw_det.

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

      if not batchrun then do:

         {mpscrad4.i
            xxlnw_det
            xxlnw_linesite
            xxlnw_sn
            "xxlnw_sn xxlnw_Start xxlnw_End
            xxlnw_rstmin xxlnw_shift shiftdesc xxlnw_wktime"
            xxlnw_sn
            bb
            "xxlnw_line = input ln_line and xxlnw_site = input ln_site"
            8808
            yes
            }

         if recno = ?
         and keyfunction(lastkey) <> "insert-mode"
         and keyfunction(lastkey) <> "go"
         and keyfunction(lastkey) <> "return"
         then leave.
         if keyfunction(lastkey) <> "end-error"
         then do on error undo, retry:
         do  transaction:

            if false then do:
               update xxlnw_sn validate (true,"") with frame bb.
            end.

            if recno = ? then do:
               create xxlnw_det.
               set xxlnw_sn with frame bb.
               xxlnwsn = xxlnw_sn.
               delete xxlnw_det.
               find first xxlnw_det where xxlnw_line = input ln_line and
                          xxlnw_site = input ln_site and
                          xxlnw_sn = xxlnwsn no-lock no-error.
               if available xxlnw_det then do:
                  recno = recid(xxlnw_det).
               end.
               else do:
                  create xxlnw_det.
                  assign xxlnw_line = ln_line
                         xxlnw_site = ln_site
                         xxlnw_sn   = xxlnwsn.
                  recno = recid(xxlnw_det).
               end.
            end.

            find xxlnw_det exclusive-lock where recid(xxlnw_det) = recno.
            assign shiftdesc = "".
            find first code_mstr no-lock where code_fldname = "xxlnw_shift"
                   and code_value = xxlnw_shift no-error.
            if available code_mstr then do:
               assign shiftdesc = code_cmmt.
            end.
            display xxlnw_sn xxlnw_Start xxlnw_End xxlnw_rstmin xxlnw_shift
                    shiftdesc xxlnw_wktime
            with frame bb.

            set xxlnw_Start xxlnw_End xxlnw_rstmin xxlnw_shift
            with frame bb
            editing:
            assign xxlnw_stime = s2t(xxlnw_start)
                xxlnw_etime = s2t(xxlnw_end).
           if xxlnw_stime > xxlnw_etime and xxlnw_shift = "N" then do:
              assign xxlnw_etime = xxlnw_etime + con24h.
           end.
            assign xxlnw_wktime =
                howLong(input (xxlnw_etime - xxlnw_stime - xxlnw_rstmin * 60),
                        input "H").
               ststatus = stline[2].
               status input ststatus.
               readkey.
               /* DELETE */
               del-yn = no.
               if lastkey = keycode("F5")
                  or lastkey = keycode("CTRL-D")
               then do:
                  del-yn = yes.
                  {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
                  if del-yn then do:
                     leave.
                  end.
               end.
               else do:
                  apply lastkey.
               end.
            end.
       end.
     end. /*if keyfunction(lastkey) <> "end-error"  then do on error undo */
    end. /*if not batchrun then do: */
   end. /* with frame bb */
   release ln_mstr.

end. /* mainloop */