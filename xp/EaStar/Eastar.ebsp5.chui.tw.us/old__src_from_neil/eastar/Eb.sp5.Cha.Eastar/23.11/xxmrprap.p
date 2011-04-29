/* mrprap.p - COMPUTER PLANNED PURCHASE ORDER (REQUISITION) APPROVAL    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 1.0      LAST MODIFIED: 06/26/86   BY: EMB                 */
/* REVISION: 1.0      LAST MODIFIED: 12/23/87   BY: EMB                 */
/* REVISION: 4.0      LAST MODIFIED: 05/30/89   BY: EMB *A740           */
/* REVISION: 6.0      LAST MODIFIED: 09/12/90   BY: emb *D040           */
/* REVISION: 6.0      LAST MODIFIED: 08/15/91   BY: ram *D832           */
/* REVISION: 6.0      LAST MODIFIED: 12/17/91   BY: emb *D966*          */
/* REVISION: 7.3      LAST MODIFIED: 01/06/93   BY: emb *G508*          */
/* REVISION: 7.3      LAST MODIFIED: 09/13/93   BY: emb *GF09* (rev)    */
/* REVISION: 7.5      LAST MODIFIED: 08/09/94   BY: tjs *J014*          */
/* REVISION: 7.3      LAST MODIFIED: 11/09/94   BY: srk *GO05*          */
/* REVISION: 7.5      LAST MODIFIED: 01/01/95   BY: mwd *J034*          */
/* REVISION: 8.5      LAST MODIFIED: 02/11/97   BY: *J1YW* Patrick Rowan    */
/* REVISION: 8.5      LAST MODIFIED: 10/14/97   BY: *G2PT* Felcy D'Souza    */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 07/10/98   BY: *J2QS* Samir Bavkar     */
/* REVISION: 8.5      LAST MODIFIED: 08/12/98   BY: *J2V2* Patrick Rowan    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb              */
/* REVISION: 9.1      LAST MODIFIED: 05/02/01   BY: *M162* Reetu Kapoor     */
/* REVISION: 9.1      LAST MODIFIED: 08/24/01   BY: *M1J7* Sandeep P.       */
/* REVISION: 9.1      LAST MODIFIED: 09/10/01   BY: *M1KJ* Sandeep P.       */
/* REVISION: 9.1      LAST MODIFIED: 07/03/02   BY: *M1BY* Rajaneesh S.     */

         {mfdtitle.i "b+ "} /*GF09*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mrprap_p_1 "Include Manufactured Items"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrprap_p_2 "Include Phantoms"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrprap_p_3 "Default Approve"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define new shared variable release_all like mfc_logical
                        label {&mrprap_p_3}.
         define new shared variable numlines as integer initial 10.
         define variable show_phantom like mfc_logical
                      label {&mrprap_p_2} initial no.
         define variable show_mfg like mfc_logical initial no
                                      label {&mrprap_p_1}.
         define variable buyer like pt_buyer.
         define variable nbr like req_nbr.
         define variable part like mrp_part.
         define variable part2 like mrp_part.
         define variable rel_date like mrp_rel_date.
         define variable rel_date2 like mrp_rel_date.
         define variable dwn as integer.
         define new shared variable mindwn as integer.
         define new shared variable maxdwn as integer.
         define new shared variable worecno as recid extent 10 no-undo.
         define variable yn like mfc_logical.
/*D040*/ define variable site like si_site.
/*D040*/ define variable site2 like si_site.
/*M1BY** /*J1YW*/ define shared variable using_grs like mfc_logical no-undo. */
/*J1YW*/ define new shared variable grs_req_nbr like req_nbr no-undo.
/*J1YW*/ define new shared variable grs_approval_cntr as integer no-undo.

/*M162*/ define variable l_part like pt_part no-undo.
/*M162*/ define variable l_vend like pt_vend no-undo.
/*M162*/ define variable l_cnt  as   integer no-undo.
/*M1BY*/ define variable using_grs like mfc_logical no-undo.

/*M162*/ define new shared temp-table tt-rqm-mstr no-undo
/*M162*/     field tt-vend   like rqm_mstr.rqm_vend
/*M162*/     field tt-nbr    like rqm_mstr.rqm_nbr
/*M162*/     field tt-line   like rqd_det.rqd_line
/*M162*/     field tt-part   like rqd_det.rqd_part
/*M162*/     field tt-yn     like mfc_logical
/*M1J7*/     field tt-wo-nbr like wo_nbr
/*M1J7*/     field tt-wo-lot like wo_lot
/*M162*/     index vend is primary
/*M162*/        tt-vend
/*M162*/        tt-nbr
/*M162*/        tt-line
/*M1J7*/     index ttnbrlot
/*M1J7*/        tt-wo-nbr
/*M1J7*/        tt-wo-lot
/*M162*/     index ttnbr
/*M162*/        tt-nbr.

         /* INPUT OPTION FORM */
         form
            part                     colon 15
        part2 label {t001.i}     colon 45
/*D040*/    site                     colon 15
        site2 label {t001.i}     colon 45
            rel_date                 colon 15
        rel_date2 label {t001.i} colon 45 skip(1)
            release_all              colon 36
            buyer                    colon 36
            show_phantom             colon 36
            show_mfg                 colon 36
         with frame a side-labels width 80 attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

/*J034*/ assign release_all = yes
                site = global_site
                site2 = global_site.

         main-loop:
         repeat:
/*J034*/    assign worecno = ?
                   dwn = 0
                   mindwn = 1
                   maxdwn = 0.

            ststatus = stline[1].
            status input ststatus.

            if part2 = hi_char then part2 = "".
/*D040*/    if site2 = hi_char then site2 = "".
            if  rel_date = low_date then rel_date = ?.
            if rel_date2 = hi_date  then rel_date2 = ?.

/*J1YW*/    /* GRS INITIALIZATION */
/*M162*/    assign
/*M162*/       l_cnt             = 0
/*J1YW*/       grs_req_nbr       = ""
/*J1YW*/       grs_approval_cntr = 0.

            update part part2
/*D040*/           site site2
                   rel_date rel_date2
                   release_all
                   buyer show_phantom show_mfg
            with frame a editing:

               if frame-field = "part" then do:

              /* FIND NEXT/PREVIOUS RECORD */
              {mfnp.i wo_mstr part wo_part part wo_part wo_part}

              if recno <> ? then do:
/*J014*/  if available wo_mstr and wo_joint_type = "" then do:
                 part = wo_part.
                 display part with frame a.
                 recno = ?.
/*J014*/  end.
              end.
               end.
               else if frame-field = "part2" then do:

              /* FIND NEXT/PREVIOUS RECORD */
              {mfnp.i wo_mstr part2 wo_part part2 wo_part wo_part}

              if recno <> ? then do:

/*J014*/  if available wo_mstr and wo_joint_type = "" then do:
                 part2 = wo_part.
                 display part2 with frame a.
                 recno = ?.
/*J014*/  end.
              end.
               end.
               else if frame-field = "site" then do:

              /* FIND NEXT/PREVIOUS RECORD */
              {mfnp.i si_mstr site si_site site si_site si_site}

              if recno <> ? then display si_site @ site with frame a.
               end.
               else if frame-field = "site2" then do:

              /* FIND NEXT/PREVIOUS RECORD */
              {mfnp.i si_mstr site2 si_site site2 si_site si_site}

              if recno <> ? then display si_site @ site2 with frame a.
               end.
               else do:
              ststatus = stline[3].
              status input ststatus.
              readkey.
              apply lastkey.
               end.
            end. /* EDITING */

            status input "".

            if part2 = "" then part2 = hi_char.
/*D040*/    if site2 = "" then site2 = hi_char.
            if  rel_date = ? then  rel_date = low_date.
            if rel_date2 = ? then rel_date2 = hi_date.

/*J034*/    {gprun.i ""gpsirvr.p""
         "(input site, input site2, output return_int)"}
/*J034*/    if return_int = 0 then do:
/*J034*/       next-prompt site with frame a.
/*J034*/       undo main-loop, retry main-loop.
/*J034*/    end.

/*G2PT* BEGIN OF COMMENTED CODE.                                            */
/*      FOLLOWING CODE IS COMMENTED AND RESTRUCTURED BELOW SINCE THIS LOGIC */
/*      SEARCHES THROUGH THE WORK ORDER TABLE FOR ORDERS WITH PLANNED       */
/*      STATUS AND THEN VALIDATES THE BUYER/PLANNER FOR THAT ITEM TO CHECK  */
/*      WHETHER IT MATCHES WITH THAT OF SELECTION CRITERIA. THIS RESULTS IN */
/*      A LONG PROCESS OF READING AND DISPLAY OF THE APPROPRIATE RECORDS.   */
/*G2PT**     find first wo_mstr where (wo_part >= part and wo_part <= part2)
 * /*D040*/    and (wo_site >= site and wo_site <= site2)
 *            and (wo_rel_date >= rel_date and wo_rel_date <= rel_date2)
 *           and wo_status = "P"
 * /*J014*/    and wo_joint_type = ""
 *          no-lock use-index wo_part_rel no-error.
 *
 *           repeat:
 *
 *              if not available wo_mstr then leave.
 *             find pt_mstr where pt_part = wo_part no-lock no-error.
 *
 * /*D040*/       find ptp_det no-lock where ptp_part = wo_part
 * /*D040*/       and ptp_site = wo_site no-error.
 *
 * /*D040*/       if (available ptp_det
 * /*D040*/       and (ptp_phantom = no or show_phantom = yes)
 * /*D040*/       and (ptp_buyer = buyer or buyer = "")
 * /*D040*/       and (ptp_pm_code = "P" or show_mfg = yes))
 * /*D040*/       or (not available ptp_det and available pt_mstr
 * /*D040*/       and (pt_phantom = no or show_phantom = yes)
 * /*D040*/       and (pt_buyer = buyer or buyer = "")
 * /*D040*/       and (pt_pm_code = "P" or show_mfg = yes))
 * /*D040*/       then do:
 *
 * /*D040*
 *              if available pt_mstr then
 *              if (pt_phantom = no or show_phantom = yes) then
 *              if (pt_buyer = buyer or buyer = "") then
 *              if (pt_pm_code = "P" or show_mfg = yes) then do: */
 *
 * /*J034*/          assign
 *           dwn = dwn + 1
 *                   maxdwn = maxdwn + 1
 *                   worecno[dwn] = recid(wo_mstr).
 *            if dwn = numlines then do:
 * /*GO05*/             hide frame a.
 *                {gprun.i ""mrprapa.p""}
 *                if worecno[1] = ? then do:
 *                   worecno = ?.
 *                   dwn = 0.
 *                   undo main-loop, next main-loop.
 *                end.
 *                find wo_mstr where recid(wo_mstr) = worecno[numlines]
 *                no-lock no-error.
 * /*J034*/             assign
 *                worecno = ?
 *                       dwn = 0
 *                       mindwn = maxdwn + 1.
 *             end.
 *              end.
 *
 *              find next wo_mstr where (wo_part >= part and wo_part <= part2)
 * /*D040*/       and (wo_site >= site and wo_site <= site2)
 *              and (wo_rel_date >= rel_date and wo_rel_date <= rel_date2)
 *              and wo_status = "P"
 * /*J014*/       and wo_joint_type = ""
 *          no-lock use-index wo_part_rel no-error.
 *
 *           end.
 *G2PT*     END OF COMMENTED CODE                                          */

/*M162*/     for each tt-rqm-mstr
/*M162*/        exclusive-lock:
/*M162*/        delete tt-rqm-mstr.
/*M162*/     end. /* FOR EACH tt-rqm-mstr */

/*G2PT*      BEGIN OF ADDED CODE */
/*           BELOW CODE STARTS WITH THE PT_MSTR AND IN_MSTR TABLES,         */
/*           SELECTING THE RECORDS WITHIN THE SELECTION CRITERIA OF ITEM    */
/*           AND SITE FOR WHICH WO EXISTS. THEN A CHECK IS MADE FOR PURCHASE*/
/*           MANUFACTURE, PHANTOM, BUYER/PLANNER VALUES BEFORE SEARCHING FOR*/
/*           WORK ORDERS WITH A PLANNED STATUS CODE. THIS IS SIGNIFICANTLY  */
/*           FASTER WHEN THERE ARE LARGE NUMBER OF WORK ORDERS AND WHEN     */
/*           BUYER/PLANNER FIELD IS ENTERED IN THE SELECTION CRITERIA.      */

         for each pt_mstr no-lock where (pt_part >= part
                        and  pt_part <= part2),
             each in_mstr no-lock where  in_part  = pt_part
                                    and (in_site >= site
                        and  in_site <= site2)
                                    and can-find (first wo_mstr where
                         wo_part = in_part
                                         and wo_site = in_site):

              find ptp_det no-lock where ptp_part = in_part
                                     and ptp_site = in_site no-error.

              if (available ptp_det
                  and (ptp_phantom = no    or show_phantom   = yes)
                  and (ptp_buyer   = buyer or buyer          = "" )
                  and (ptp_pm_code = "P"   or show_mfg       = yes))
                 or
             (not available ptp_det
                  and (pt_phantom  = no    or show_phantom   = yes)
                  and (pt_buyer    = buyer or buyer          = "" )
                  and (pt_pm_code  = "P"   or show_mfg       = yes)) then
              do:

                  for each wo_mstr no-lock where wo_part      = in_part
                                             and wo_site      = in_site
                                             and wo_rel_date >= rel_date
                                             and wo_rel_date <= rel_date2
                                             and wo_status    = "P"
                                             and wo_joint_type = ""
                                             use-index wo_part_rel:

                      assign
                         dwn          = dwn + 1
                         maxdwn       = maxdwn + 1
                         worecno[dwn] = recid(wo_mstr)
/*M162*/                 l_part       = pt_part
/*M162*/                 l_vend       = if available ptp_det
/*M162*/                                then ptp_vend
/*M162*/                                else pt_vend.

/*J2QS*/            /* RESTRICTING maxdwn TO 999 AND REASSIGNING dwn TO 0 */
/*J2QS*/            /* SO THAT DETAIL LINES TO APPROVE WOULD START FROM   */
/*J2QS*/            /* 1 - 999 FOR THE NEXT SET OF LINES ABOVE 999        */
/*J2QS**            if dwn = numlines then */

/*M162*/            /* CREATING TEMP-TABLE tt-rqm-mstr. BASED ON THE RECORDS */
/*M162*/            /* CREATED, CORESSPONDING GRS WILL BE CREATED FOR EACH   */
/*M162*/            /* VENDOR (SUPPLIER)                                     */

/*M1BY*/            using_grs = can-find(mfc_ctrl
/*M1BY*/                           where mfc_field   = "grs_installed"
/*M1BY*/                             and mfc_logical = yes).

/*M162*/            if using_grs
/*M162*/            then do:
/*M162*/               create tt-rqm-mstr.
/*M162*/               assign
/*M1J7*/                  tt-wo-nbr = wo_nbr
/*M1J7*/                  tt-wo-lot = wo_lot
/*M162*/                  tt-vend   = l_vend
/*M162*/                  tt-line   = dwn
/*M162*/                  tt-part   = l_part.
/*M1KJ*/               release tt-rqm-mstr.
/*M162*/            end. /* IF using_grs */

/*J2QS*/            if dwn = numlines or maxdwn = 999  then
                    do:

                      hide frame a.
                      {gprun.i ""xxmrprapa.p""}       /*add-by-davild20051128*/

/*J2QS*/               if maxdwn = 999 then
/*J2QS*/               do:
/*J2QS*/                  assign
/*J2QS*/                     mindwn = 1
/*J2QS*/                     maxdwn = 0.
/*J2QS*/               end. /* IF maxdwn = 999 */

                       if worecno[1] = ? then
                       do:
                           worecno = ?.
                           dwn = 0.
                           undo main-loop, next main-loop.
                       end.

                       assign
                       worecno = ?
                       dwn = 0
                       mindwn = maxdwn + 1.
                  end. /* IF DWN = NUMLINES */

              end. /* FOR EACH WO_MSTR */
              end. /* IF AVAILABLE PTP_DET */
             end. /* FOR EACH PT_MSTR */

/*G2PT*      END OF ADDED CODE */

             if dwn <> 0 then do:
/*GO05*/        hide frame a.
                {gprun.i ""xxmrprapa.p""}        /*add-by-davild20051128*/
                if worecno[1] = ? then undo main-loop, next main-loop.
             end.
             else do:
                {mfmsg.i 307 1}
                /* NO MORE PLANNED PURCHASE ORDERS SATISFY CRITERIA */
             end.

/*J2V2*/     if using_grs and grs_req_nbr <> "" then do:
/*M162*/        for each tt-rqm-mstr
/*M162*/           where tt-nbr <> ""
/*M162*/             and tt-yn
/*M162*/        no-lock break by tt-vend:
/*M162*/           if last-of(tt-vend)
/*M162*/           then
/*M162*/              l_cnt = l_cnt + 1.
/*M162*/        end. /* FOR EACH tt-rqm-mstr */

/*M162*/        /* PROCEDURE COMPLETE. # REQUISITIONS CREATED */
/*M162*/        {mfmsg03.i 4640 1 l_cnt """" """"}

/*M162*/        for last tt-rqm-mstr
/*M162*/          where tt-nbr <> ""
/*M162*/            and tt-yn
/*M162*/          use-index ttnbr no-lock:
/*M162*/        end. /* FOR LAST tt-rqm-mstr */
/*M162*/        if  available tt-rqm-mstr
/*M162*/        and l_cnt > 0
/*M162*/        then do:
/*M162*/           if l_cnt = 1
/*M162*/           then do:
/*M162** /*J2V2*/     {mfmsg02.i 2765 1 grs_req_nbr} */
/*M162*/              {mfmsg02.i 2765 1 tt-rqm-mstr.tt-nbr}
/*J2V2*/            /* REQUISITION CREATED. REQUISITION NUMBER IS */
/*M162*/           end. /* IF l_cnt = 1 */
/*M162*/           else do:
/*M162*/              /* LAST REQUISITION CREATED: */
/*M162*/              {mfmsg02.i 4641 1 tt-rqm-mstr.tt-nbr}
/*M162*/           end. /* ELSE DO */
/*M162*/        end. /* IF AVAILABLE tt-rqm-mstr AND l_cnt > 0 */

/*J2V2*/     end.

         end.
