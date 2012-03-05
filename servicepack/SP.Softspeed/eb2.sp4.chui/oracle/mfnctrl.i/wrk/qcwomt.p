/* qcwomt.p - QC ORDER MAINTENANCE                                         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.8.1.7 $                                                            */
/*V8:ConvertMode=Maintenance                                               */
/* REVISION: 7.0     LAST MODIFIED: 07/31/91    BY: smm                    */
/* REVISION: 7.0     LAST MODIFIED: 04/04/92    BY: smm                    */
/* REVISION: 7.0     LAST MODIFIED: 06/06/92    BY: ram *F744*             */
/* REVISION: 7.3     LAST MODIFIED: 09/27/92    BY: jcd *G247*             */
/* REVISION: 7.3     LAST MODIFIED: 11/10/92    BY: ram *G305*             */
/* REVISION: 7.3     LAST MODIFIED: 01/20/93    BY: rwl *G572*             */
/* REVISION: 7.3     LAST MODIFIED: 09/01/94    BY: ljm *FQ67*             */
/* Oracle changes (share-locks)     09/12/94    BY: rwl *GM43*             */
/* REVISION: 7.5     LAST MODIFIED: 10/20/94    BY: mwd *J034*             */
/* REVISION: 8.6     LAST MODIFIED: 06/11/96    BY: aal *K001*             */
/* REVISION: 8.5     LAST MODIFIED: 07/30/96    BY: *G2B2* Julie Milligan  */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane       */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan      */
/* REVISION: 9.1      LAST MODIFIED: 08/25/99   BY: *N014* Murali Ayyagari */
/* REVISION: 9.1      LAST MODIFIED: 01/19/00   BY: *J3NL* Mark Christian  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb              */
/* REVISION: 9.1      LAST MODIFIED: 12/21/00   BY: *M0XH* Mugdha Tambe     */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.8.1.6     BY: Kaustubh K.    DATE: 05/04/01 ECO: *L18W*        */
/* $Revision: 1.8.1.7 $          BY: John Corda     DATE: 08/09/02 ECO: *N1QP*        */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "2+ "}

/* STANDARD INCLUDE FOR USING PROJ-X ROUTINES */
{pxmaint.i}
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE qcwomt_p_1 "Ref"
/* MaxLen: Comment: */

&SCOPED-DEFINE qcwomt_p_3 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE qcwomt_p_4 "From Location"
/* MaxLen: Comment: */

&SCOPED-DEFINE qcwomt_p_5 "Effective Date"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i new}
{gldynrm.i new}
{gpglefdf.i}

define new shared variable comp like ps_comp.
define new shared variable qty like qc_qty_ord.
define new shared variable eff_date as date
   label {&qcwomt_p_5} no-undo.
define new shared variable qc_recno as recid.
define new shared variable leadtime like pt_mfg_lead.
define new shared variable prev_status like qc_status.
define new shared variable prev_release like qc_rel_date.
define new shared variable prev_due like qc_due_date.
define new shared variable prev_qty like qc_qty_ord.
define new shared variable any_issued like mfc_logical.
define new shared variable del-yn like mfc_logical initial no.
define new shared variable deliv like wod_deliver.
define new shared variable cmtindx like qc_cmtindx.
define new shared variable undo_all like mfc_logical no-undo.
define new shared variable qcinspect like qc_insp_loc.
define new shared variable qcstat    like qc_inv_stat.
define new shared variable qcsite   like qcc_site.
define            variable nonwdays as integer.
define            variable workdays as integer.
define            variable overlap as integer.
define            variable know_date as date.
define            variable find_date as date.
define            variable i as integer.
define            variable interval as integer.
define            variable frwrd as integer.
define            variable yn like mfc_logical initial no.
define            variable wonbr like qc_nbr.
define            variable wolot like qc_lot.
define            variable wocmmts like qcc_wcmmts label {&qcwomt_p_3}.
define            variable new_wo like mfc_logical initial no.

define new shared variable del_ok like mfc_logical.
define new shared variable undo-input like mfc_logical
   initial no no-undo.
define            variable valid-proj like mfc_logical initial no
   no-undo.
define variable l_ErrorNo as integer no-undo.


/* GET DEFAULT INFO FROM qcc_ctrl FILE */

find first qcc_ctrl no-lock no-error.
if available qcc_ctrl then do:
   assign
      wocmmts   = qcc_wcmmts
      qcinspect = qcc_inspect
      qcsite    = qcc_site.

   find loc_mstr where loc_loc  = qcc_inspect
                   and loc_site = qcc_site no-error.
   if available loc_mstr then
      qcstat = loc_status.
end.

/* DISPLAY SELECTION FORM */
eff_date = today.

form
   qc_nbr         colon 25
   qc_lot
   qc_part        colon 25
   pt_desc1       at 47 no-label
   pt_um          colon 25
   pt_desc2       at 47 no-label
   qc_type        colon 25
   qc_site        colon 25
   qc_autoissue   colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   qc_qty_ord     colon 25
   qc_ord_date    colon 55
   qc_qty_comp    colon 25
   qc_rel_date    colon 55
   qc_qty_rjct    colon 25
   qc_due_date    colon 55
   eff_date       colon 55
   skip(1)
   qc_status      colon 25
   qc_teststep    colon 55
   qc_job         colon 25
   qc_project     colon 25
   qc_rmks        colon 25
with frame b side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

form
   qc_loc         colon 25 label {&qcwomt_p_4}
   qc_serial      colon 25
   qc_ref         colon 25 label {&qcwomt_p_1}
   skip(1)
   qc_insp_loc    colon 25
   qc_inv_stat    colon 25
   wocmmts        colon 25
with frame c  side-labels centered title color normal
   (getFrameTitle("INSPECTION_TRANSFER",28)) width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

/* DISPLAY */
view frame a.
view frame b.

mainloop:
repeat:
   do transaction with frame a:

      assign
         eff_date     = today
         prev_status  = ""
         prev_release = ?
         prev_due     = ?
         prev_qty     = 0
         leadtime     = 0
         new_wo       = no.

      prompt-for
         qc_nbr
         qc_lot
      editing:
         if frame-field = "qc_nbr" then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i qc_mstr qc_nbr qc_nbr qc_nbr qc_nbr qc_nbr}

            if recno <> ? then do:
               find pt_mstr where pt_part = qc_part
                  no-lock no-error no-wait.
               if available pt_mstr
               then
                  display
                     pt_desc1
                     pt_desc2
                     pt_um.
               else
                  display
                     " " @ pt_desc1
                     " " @ pt_desc2
                     " " @ pt_um.

               display
                  qc_nbr
                  qc_lot
                  qc_part
                  qc_type
                  qc_site
                  qc_autoissue
               with frame a.
               display
                  qc_qty_ord
                  qc_qty_comp
                  qc_qty_rjct
                  qc_ord_date
                  qc_rel_date
                  qc_due_date
                  eff_date
                  qc_status
                  qc_teststep
                  qc_job
                  qc_project
                  qc_rmks
               with frame b.
            end.

         end.
         else if frame-field = "qc_lot" then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i qc_mstr qc_lot qc_lot qc_nbr qc_nbr qc_lot}

            if recno <> ? then do:
               find pt_mstr where pt_part = qc_part
                  no-lock no-error no-wait.
               if available pt_mstr
               then
                  display
                     pt_desc1
                     pt_desc2
                     pt_um.
               else
                  display
                     " " @ pt_desc1
                     " " @ pt_desc2
                     " " @ pt_um.

               display
                  qc_nbr
                  qc_lot
                  qc_part
                  qc_type
                  qc_site
                  qc_autoissue
               with frame a.
               display
                  qc_qty_ord
                  qc_qty_comp
                  qc_qty_rjct
                  qc_ord_date
                  qc_rel_date
                  qc_due_date
                  eff_date
                  qc_status
                  qc_teststep
                  qc_job
                  qc_project
                  qc_rmks
               with frame b.
            end.
         end.
         else do:
            ststatus = stline[3].
            status input ststatus.
            readkey.
            apply lastkey.
         end.
      end. /* PROMPT-FOR */
   end.
   /* transaction */

   do transaction:

      /* ADD/MOD/DELETE */
      if available qc_mstr then release qc_mstr.
      assign
         wonbr = ""
         wolot = "".

      /* SECTION TO GET QC ORDER NUMBER FROM WORK ORDER CONTROL FILE;
      STOLE CODE FROM wowomt.p */

      if input qc_nbr <> "" and input qc_lot <> "" then
         find qc_mstr use-index qc_lot using qc_lot and qc_nbr
            no-error.

      if input qc_nbr = "" and input qc_lot <> "" then
         find qc_mstr use-index qc_lot using qc_lot no-error.

      if input qc_nbr <> "" and input qc_lot = "" then
         find first qc_mstr use-index qc_nbr using qc_nbr no-error.

      if not available qc_mstr then
         if input qc_lot <> "" then
            find qc_mstr use-index qc_lot using qc_lot no-error.
      if not available qc_mstr then do:

         if input qc_nbr <> "" then
            wonbr = input qc_nbr.
         else do:
            find first qcc_ctrl no-lock no-error.
            if not available qcc_ctrl then
               create qcc_ctrl.
            if not qcc_auto_nbr then
               undo mainloop, retry mainloop.
            {mfnctrl.i qcc_ctrl qcc_nbr qc_mstr qc_nbr wonbr}
         end.

         if input qc_lot <> "" then
            wolot = input qc_lot.
         else do:
            /* GET NEXT LOT NUMBER */
            {mfnctrl.i qcc_ctrl qcc_lot qc_mstr qc_lot wolot}
         end.
         if wonbr = "" or wolot = "" then
            undo, retry.
         display wonbr @ qc_nbr wolot @ qc_lot with frame a.
      end.
      else do:
         if qc_nbr <> input qc_nbr and input qc_nbr <> "" then do:
            {pxmsg.i &MSGNUM=508 &ERRORLEVEL=3}
            /* LOT NUMBER ENTERED BELONGS TO DIFFERENT WORK ORDER */
            undo mainloop, retry mainloop.
         end.
         wolot = qc_lot.

         {gprun.i ""gpsiver.p""
                   "(input qc_site, input ?,
                     output return_int)"}
         if return_int = 0 then do:
            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
            /* USER DOES NOT HAVE ACCESS TO SITE */
            undo mainloop, retry mainloop.
         end.

         {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1}

         /* GET INSPECTION LEADTIME FROM pt_mstr OR ptp_det */
         find pt_mstr where pt_part = qc_part no-lock no-error.
         if available pt_mstr then do:
            leadtime = pt_insp_lead.
            find ptp_det no-lock where ptp_part = qc_part
                                   and ptp_site = qc_site no-error.
            if available ptp_det then do:
               leadtime = ptp_ins_lead.
            end.
         end.
      end.
   end.

   do transaction:

      find qc_mstr use-index qc_lot where qc_lot = wolot no-error.
      if not available qc_mstr then do with frame a:
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
         new_wo = yes.
         create qc_mstr.
         assign
            qc_nbr      = wonbr
            qc_insp_loc = qcinspect
            qc_inv_stat = qcstat
            qc_lot      = wolot
            qc_type     = "I"
            qc_recno    = recid(qc_mstr).

         display
            qc_nbr
            qc_lot
            qc_type
            qcsite @ qc_site
            yes    @ qc_autoissue.

         do on error undo, retry:
            set
               qc_part
               qc_type
               qc_site
               qc_autoissue
               editing:
               if frame-field = "qc_part" then do:

                  /* FIND NEXT/PREVIOUS RECORD */
                  {mfnp.i
                      pt_mstr
                      qc_part
                      pt_part
                      qc_part
                      pt_part
                      pt_part}

                  if recno <> ? then
                     display
                        pt_part @ qc_part
                        pt_desc1
                        pt_desc2
                        pt_um.
               end.
               else if frame-field = "qc_site" then do:

                  /* FIND NEXT/PREVIOUS RECORD */
                  {mfnp.i
                      si_mstr
                      qc_site
                      si_site
                      qc_site
                      si_site
                      si_site}

                  if recno <> ? then
                     display si_site @ qc_site.
               end.
               else do:
                  ststatus = stline[3].
                  status input ststatus.
                  readkey.
                  apply lastkey.
               end.
            end. /* EDITING */
            assign
               qc_part
               qc_site
               qc_type = upper(input qc_type).

            /* GET INSPECTION LEADTIME FROM pt_mstr OR ptp_det */

            find pt_mstr no-lock where pt_part = qc_part no-error.
            if available pt_mstr then do:
               assign
                  leadtime = pt_insp_lead
                  qc_loc = pt_loc
                  qc_teststep = pt_routing.

               find ptp_det no-lock where ptp_part = qc_part
                                      and ptp_site = qc_site no-error.
               if available ptp_det then do:
                  assign
                     leadtime    = ptp_ins_lead
                     qc_teststep = ptp_routing.
               end.
            end.

            /* QC ORDER'S MUST BE INSPECTION OR SAMPLE */

            if index("DI",qc_type) = 0 then do:
               {pxmsg.i &MSGNUM=7002 &ERRORLEVEL=3}
               /* TYPE MUST BE (I)NPECTION OR (D)ESTRUCTIVE */
               next-prompt qc_type.
               undo, retry.
            end.
            {gprun.i ""gpsiver.p""
                     "(input qc_site,
                       input ?,
                       output return_int)"}
            if return_int = 0 then do:
               {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3} /* USER DOES NOT HAVE  */
               /* ACCESS TO THIS SITE */
               next-prompt qc_site with frame a.
               undo, retry.
            end.
         end.

         assign
            qc_status   = "".
            qc_ord_date = today.
            qc_rel_date = today.
            qc_due_date = ?.

         {mfdate.i qc_rel_date qc_due_date leadtime qc_site}

      end.  /* if not available qc_mstr */
      assign
         recno    = recid(pt_mstr)
         qc_recno = recid(qc_mstr).

      if qc_qty_comp = 0 and qc_qty_rjct = 0 then do:
         ststatus = stline[2].
         status input ststatus.
      end.

      del-yn = no.
      prev_qty = qc_qty_ord.
      /* SET GLOBAL ITEM VARIABLE */
      global_part = qc_part.
      global_site = qc_site.

      display
         qc_nbr
         qc_lot
         qc_part
         qc_type
         qc_site
         qc_autoissue
      with frame a.

      display
         qc_qty_ord
         qc_qty_comp
         qc_qty_rjct
         qc_ord_date
         qc_rel_date
         qc_due_date
         eff_date
         qc_job
         qc_status
         qc_teststep
         qc_project
         qc_rmks
      with frame b.

      if available pt_mstr
      then
         display
            pt_desc1
            pt_desc2
            pt_um
         with frame a.
      else
         display
            " " @ pt_desc1
            " " @ pt_desc2
            " " @ pt_um
         with frame a.

      detail-loop:
      do on error undo, retry with frame b:

         set
            qc_qty_ord
            qc_ord_date
            qc_rel_date
            qc_due_date
            eff_date
            qc_status
            qc_teststep
            qc_job
            qc_project
            qc_rmks
            go-on(F5 CTRL-D).

         /* DELETE */
         if lastkey = keycode("F5")
         or lastkey = keycode("CTRL-D")
         then do:
            del_ok = yes.
            for each qr_test where qr_lot = qc_lot no-lock:
               if qr_act_op    <> 0
               or qr_qty_accpt <> 0
               or qr_qty_rjct  <> 0 then do:
                  del_ok = no.
                  leave.
               end.
            end.

            if qc_qty_comp <> 0 or qc_qty_rjct <> 0
               or can-find(first mph_hist where mph_lot = qc_lot)
               or not del_ok
            then do:
               {pxmsg.i &MSGNUM=7012 &ERRORLEVEL=4}
               undo detail-loop, retry.
            end.

            del-yn = yes.
            {mfmsg01.i 11 1 del-yn}
            if del-yn = no then
               undo detail-loop, retry.

            if qc_qty_ord <> 0 then do:
               assign
                  qc_qty_ord = 0
                  qc_autoissue = yes.
               {gprun.i ""qcinvtr.p""}
               {gprun.i ""qcwomta.p""}
            end.

            for each qcd_det exclusive-lock where qcd_lot = qc_lot:
               for each cmt_det exclusive-lock where cmt_indx = qcd_cmtindx:
                  delete cmt_det.
               end.
               delete qcd_det.
            end.
            for each qr_test exclusive-lock where qr_lot = qc_lot:
               for each cmt_det exclusive-lock where cmt_indx = qr_cmtindx:
                  delete cmt_det.
               end.
               delete qr_test.
            end.
            for each cmt_det exclusive-lock where cmt_indx = qc_cmtindx:
               delete cmt_det.
            end.
            delete qc_mstr.
            {pxmsg.i &MSGNUM=22 &ERRORLEVEL=1}
            clear frame b no-pause.
            clear frame a no-pause.
         end.

         if not del-yn then do:
            if qc_ord_date = ? then
               qc_ord_date = today.
            if qc_rel_date = ? and qc_due_date = ? then
               qc_rel_date = max(today,qc_ord_date).
            if qc_rel_date = ? or qc_due_date = ? then do:
               {mfdate.i qc_rel_date qc_due_date leadtime qc_site}
            end.
            display qc_rel_date qc_due_date.
            if qc_due_date < qc_rel_date then do:
               {pxmsg.i &MSGNUM=514 &ERRORLEVEL=3}
               /* DUE DATE BEFORE RELEASE DATE NOT ALLOWED.*/
               next-prompt qc_rel_date.
               undo, retry.
            end.

            /* ADDED LOGIC TO DO CLOSED GL PERIOD VALIDATION ON QUALITY    */
            /* ORDER SITE ENTITY                                           */

            for first gl_ctrl
               fields (gl_verify) no-lock:
            end. /* FOR FIRST gl_ctrl */
            if not available gl_ctrl then
               create gl_ctrl.

            for first si_mstr
               fields (si_entity si_site)
               where si_site = qc_site no-lock:
            end. /* FOR FIRST si_mstr */
            if available si_mstr and gl_verify
            then do:
               {gpglef.i ""IC"" si_entity eff_date}
            end. /* IF AVAILABLE si_mstr ... */

            /* VALIDATE qc_status */
            if qc_status <> "" and qc_status <> "C" then do:
               {pxmsg.i &MSGNUM=19 &ERRORLEVEL=3}
               next-prompt qc_status.
               undo, retry.
            end.

            /* VALIDATE TEST STEP AGAINST TEST STEP FILE */
            if not can-find(first qro_det
               where qro_routing = (if qc_teststep <> "" then
                                       qc_teststep
                                    else
                                       qc_part))
            then do:
               {pxmsg.i &MSGNUM=7001 &ERRORLEVEL=3}
               /* TEST STEP DOES NOT EXIST */
               next-prompt qc_teststep.
               undo, retry.
            end.

            /* VALIDATE qa_project */

            /* INITIALIZE SETTINGS */
            {gprunp.i "gpglvpl" "p" "initialize"}

            /* VALIDATE  PROJECT */
            {gprunp.i "gpglvpl" "p" "validate_project"
                      "(input qc_project,
                        output valid-proj)"}
            if not valid-proj then do:
               next-prompt qc_project.
               undo, retry.
            end.
            /* CREATE LOCATION TRANSACTION OF INVENTORY
            TO THE QUALITY CONTROL STATION */

            pause 0.
            display
               qc_loc
               qc_serial
               qc_ref
               qc_insp_loc
               qc_inv_stat
               wocmmts
            with frame c.
            pause before-hide.
            ststatus = stline[3].
            status input ststatus.

            do on error undo, retry:
               set
                  qc_loc
                  qc_serial
                  qc_ref
                  qc_insp_loc when (new qc_mstr)
                  qc_inv_stat
                  wocmmts
               with frame c.

               /* VALIDATING ATTRIBUTES WITH INSPECTION LOCATION BEFORE */
               /* TRANSFERRING THE QUANTITY                             */
               /* TRANSFER NOT ALLOWED IF CONFLICT FOUND                */

               /* VALUES PASSED HERE AS LOTSERIAL AND REFERENCE SHOULD     */
               /* MATCH WITH THE VALUES WHICH WILL BE EVENTUALLY PASSED TO */
               /* ICTRANS.I VIA ICXFER.P WHILE TRANSFERRING THE INVENTORY  */

               {pxrun.i &PROC='validateAttributes' &PROGRAM='ictrxr.p'
                        &PARAM="(
                                 input qc_loc,
                                 input qc_insp_loc,
                                 input qc_site,
                                 input qc_site,
                                 input qc_serial,
                                 input qc_serial ,
                                 input qc_ref,
                                 input qc_ref,
                                 input qc_part,
                                 input qc_ord_date ,
                                 input qc_qty_ord  ,
                                 output l_ErrorNo
                                )"
                        &NOAPPERROR=true
                        &CATCHERROR=true
               }

               if (l_ErrorNo <> 0 ) and
                  ( return-value = {&APP-ERROR-RESULT})
               then do:

                  /* MESSAGE # 1918 - ASSAY,GRADE,EXPIRATION CONFLICT.*/
                  /*                  XFER NOT ALLOWED                */
                  {pxmsg.i   &MSGNUM=l_ErrorNo
                             &ERRORLEVEL = {&APP-ERROR-RESULT}
                  }
                  undo , retry .

               end. /* IF L_ERRORNO <> 0 */

               if prev_qty <> qc_qty_ord then do:
                  {gprun.i ""qcinvtr.p""}
               end.

               if undo-input then undo, retry.
            end.

            /* CREATE qr_test AND qcd_det FILES FROM MASTER RECORD */
            {gprun.i ""qcwomta.p""}

            /* TRANSACTION COMMENTS */
            if not available qcc_ctrl
               then find first qcc_ctrl no-lock.
            if wocmmts = yes then do:
               assign
                  global_ref = qc_part
                  cmtindx    = qc_cmtindx.
               hide frame a no-pause.
               hide frame b no-pause.
               hide frame c no-pause.
               {gprun.i ""gpcmmt01.p"" "(input ""qc_mstr"")"}
               view frame a.
               view frame b.
               qc_cmtindx = cmtindx.
            end.

            undo_all = no.

         end.  /* if not del-yn */
      end.  /* detail-loop */

   end.  /* transaction */
end.  /* mainloop */

status input.
