/* GUI CONVERTED from poporcm.i (converter v1.71) Thu Jul 16 13:58:29 1998 */
/* poporcm.i - PURCHASE ORDER RECEIPT HEADER FRAME MANIPULATION         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*J2MG*/ /*V8:WebEnabled=No                                             */
/*  CREATED: 7.4     LAST MODIFIED: 01/20/95    by: smp *F0F5*          */
/*  CREATED: 7.4     LAST MODIFIED: 03/10/95    by: jpm *H0BZ*          */
/*  MODIFIED 7.4     LAST MODIFIED: 03/29/95    by: aed *G0JV*          */
/*  MODIFIED 7.5     LAST MODIFIED: 05/12/95    by: mwd *J034*          */
/*                                  08/24/95    by: wjk *H0FM*          */
/*  MODIFIED 7.3                    09/05/95    BY: ais *G0W5*          */
/*  MODIFIED 8.5     LAST MODIFIED: 03/29/95    BY: taf *J053*          */
/*  REVISION: 8.5    LAST MODIFIED: 03/08/96    BY: *J0CV* Robert Wachowicz */
/*  REVISION: 8.5    LAST MODIFIED: 04/15/96    BY: *J0J8* Robert Wachowicz */
/*  REVISION: 8.5    LAST MODIFIED: 05/01/96    BY: *J04C* Sue Poland       */
/*  REVISION: 8.5    LAST MODIFIED: 06/20/96    BY: *J0VF* Robert Wachowicz */
/*  REVISION: 8.5    LAST MODIFIED: 06/28/96    BY: *J0WQ* Robert Wachowicz */
/*  REVISION: 8.5    LAST MODIFIED: 07/03/96    BY: *J0WY* Robert Wachowicz */
/*  REVISION: 8.5    LAST MODIFIED: 07/18/96    BY: *J0ZS* T. Farnsworth    */
/*  REVISION: 8.6    LAST MODIFIED: 10/22/96    BY: *K004* Kurt De Wit      */
/*  REVISION: 8.5    LAST MODIFIED: 11/12/96    BY: *J17Y* Sue Poland       */
/*  REVISION: 8.5    LAST MODIFIED: 04/04/97    BY: *J1MR* Sue Poland       */
/*  REVISION: 8.6    LAST MODIFIED: 11/06/97    BY: *H1GJ* Seema Varma      */
/*  REVISION: 8.6E   LAST MODIFIED: 04/29/98    BY: *K1NS* A. Licha         */
/*  REVISION: 8.6E   LAST MODIFIED: 06/26/98    BY: *J2MG* Samir Bavkar     */
/*  REVISION: 8.6E   LAST MODIFIED: 06/30/98    BY: *J2P8* Niranjan R.      */
/*  REVISION: 8.6E   LAST MODIFIED: 07/09/98    BY: *L020* Charles Yen      */

            do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


                   find first poc_ctrl no-lock.
                   fill-all = poc_rcv_all.
                   rcv_type  = poc_rcv_type.

                view frame {&frame}.

                if receivernbr = ? then receivernbr = "".
                if eff_date = ? then eff_date = today.
                move = yes.
                cmmt_yn = no.
                display
                   receivernbr
                   eff_date
                   move          when (porec)
                   fill-all
                   cmmt_yn
                with frame {&frame}.
                receivernbr = "".

                seta:
                do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                   set ordernum
                   with frame {&frame} editing:
                      if frame-field = "ordernum" then do:
                         /* FIND NEXT/PREVIOUS RECORD */
                         /* Do not scroll thru RTS for PO or PO for RTS */
                         /* CHANGED '"input ordernum"' to 'frame-value' BELOW */
                         /* PROVIDING A STARTING POINT FOR SCROLLING)         */
                         {mfnp06.i
                             po_mstr
                             po_nbr
                             "po_type <> ""B"" and po_fsm_type = ports"
                             po_nbr
                             frame-value
                             yes
                             yes }

                         if recno <> ? then do:
                            find ad_mstr
                            where ad_addr = po_vend no-lock no-error.
                            if available ad_mstr then
                               vndname = ad_name.
                            else
                               vndname = "".
                            display po_nbr      @ ordernum
                                    receivernbr
                                    po_vend
                                    po_stat
                                    "" @ ps_nbr
                            with frame {&frame}.
                         end.
                      end.  /* if frame-field = "ordernum" then */
                      else do:
                         status input.
                         readkey.
                         apply lastkey.
                      end.
                   end. /* editing */
                   /* END EDITING PORTION OF HEADER FRAME */

                   find po_mstr where po_nbr = ordernum
                        exclusive-lock no-error.

                   if not available po_mstr then do:
                      if ports = "RTS" then do:
                        {mfmsg.i 7499 3}    /* RTS MASTER RECORD NOT FOUND */
                      end.
                      else do:
                        {mfmsg.i 343 3}
                        /* PURCHASE ORDER DOES NOT EXIST */
                      end.
                      next-prompt ordernum with frame {&frame}.
                      undo seta, retry.
                   end.

                   if po_is_btb then do:
/*K1NS** /*K004*/      {mfmsg.i 2827 3}              */
/*K1NS** /*K004*/      /* BTB PO ARE NOT ALLOWED */  */

/*K1NS*/              /* EMT PO CANNOT BE RECEIVED HERE, USE PO SHIPPER */
/*K1NS*/              {mfmsg.i 2828 3}
                      next-prompt po_nbr with frame a.
                      undo, retry.
                   end.

                   if available po_mstr and po_stat = "c" then do:
                      /* PURCHASE ORDER CLOSED */
                      {mfmsg.i 326 3}
                      next-prompt ordernum with frame {&frame}.
                      undo seta, retry.
                   end.
                   if available po_mstr and po_stat = "x" then do:
                      /* PURCHASE ORDER CANCELLED */
                      {mfmsg.i 395 3}
                      next-prompt ordernum with frame {&frame}.
                      undo seta, retry.
                   end.

                   if available po_mstr and po_type = "B" then do:
                      /* BLANKET ORDER NOT ALLOWED */
                      {mfmsg.i 385 3}
                      next-prompt ordernum with frame {&frame}.
                      undo seta, retry.
                   end.

                   if available po_mstr and ports = "RTS"
                    and po_fsm_type <> ports then do:
                      /* Can not process PO's with RTS programs. */
                      {mfmsg.i 7363 3}
                      next-prompt ordernum with frame {&frame}.
                      undo seta, retry.
                   end.

                   if available po_mstr and ports = ""
                    and po_fsm_type <> ports then do:
                      /* Can not process RTS orders with PO programs. */
                      {mfmsg.i 7364 3}
                      next-prompt ordernum with frame {&frame}.
                      undo seta, retry.
                   end.

/*L020*            {gpcurmth.i */
/*L020*         "po_curr" */
/*L020*         "3" */
/*L020*         "undo seta, retry" */
/*L020*         "next-prompt ordernum with frame {&frame}" } */
/*L020*/           if po_curr = base_curr then
/*L020*/              rndmthd = gl_rnd_mthd.
/*L020*/           else do:
/*L020*/              /* GET ROUNDING METHOD FROM CURRENCY MASTER */
/*L020*/              {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                       "(input po_curr,
                         output rndmthd,
                         output mc-error-number)"}
/*L020*/              if mc-error-number <> 0 then do:
/*L020*/                 {mfmsg.i mc-error-number 3}
/*L020*/                 next-prompt ordernum with frame {&frame}.
/*L020*/                 undo seta, retry.
/*L020*/              end.
/*L020*/           end.

/*J2MG*/           /* SET CURRENCY DEPENDENT FORMAT FOR PO_PREPAID IN FRAME */
/*J2MG*/           /* POMTD                                                 */
/*J2MG*/           do with frame pomtd :
                   /* SET CURRENCY DEPENDENT FORMATS */
                   {pocurfmt.i }
/*J2MG*/           end. /* DO WITH FRAME POMTD */

                   find ad_mstr where ad_addr = po_vend no-lock no-error.
                   if available ad_mstr then
                      vndname = ad_name.
                   else
                      vndname = "".

                   display
                      receivernbr
                      po_vend
                      po_stat
                      vndname
                      "" @ ps_nbr
                   with frame {&frame}.

                   if available po_mstr then do:
                      pook = no.

/*J2P8*/              if not can-find(first pod_det where pod_nbr = po_nbr)
/*J2P8*/              then do:
/*J2P8*/                 /* ORDER HAS NO LINE ITEMS */
/*J2P8*/                 {mfmsg.i 611 3}
/*J2P8*/                 next-prompt ordernum with frame {&frame}.
/*J2P8*/                 undo seta, retry.
/*J2P8*/              end. /* IF NOT CAN-FIND */


                      chkpodsite:
                      for each pod_det where pod_nbr = po_nbr no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

                         find si_mstr where si_site = pod_site no-lock no-error.
                         if available si_mstr and si_db = global_db then do:
                           {gprun.i ""gpsiver.p""
              "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                           if return_int = 1 then do:
                              pook = yes.
                              leave chkpodsite.
                           end. /* IF RETURN_INT = 1  */
                         end.
                      end.
/*GUI*/ if global-beam-me-up then undo, leave.

                      if not pook then do:
                         {mfmsg.i 2328 3} /* NOT AUTHORIZED FOR THIS SITE*/
                         next-prompt ordernum with frame {&frame}.
                         undo seta, retry.
                      end.
                      /* MAKE SURE THAT CENTRAL DATABASE IS CONNECTED */

                     if available po_mstr then do:
                        find first pod_det
                            where pod_nbr = po_nbr no-lock no-error.
                        /* CURRENTLY, FOR RTS'S, POD_PO_DB IS BLANK (AS
                            RTS'S DON'T SUPPORT MULTIPLE-DB ENVIRONMENTS)
                            SO PREVENT THIS ERROR CONDITION IN THAT CASE. */
                        if global_db <> ""
                        and pod_po_db <> ""
                        and not connected(pod_po_db) then do:
                            /* Database not available */
                            {mfmsg03.i 2510 3 pod_po_db """" """"}
                            undo seta, retry.
                         end.
                     end.  /* if available po_mstr then do: */
                   end.  /* if available po_mstr then do: */
                end.
/*GUI*/ if global-beam-me-up then undo, leave.


                seta1:
                /* THE DO WHILE TRUE IS REQUIRED FOR CORRECT CIM PROCESSING */
                do while true on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                   global_addr = po_vend.

                   /* SPLIT OUT THE SET STATEMENT TO PREVENT "SHIP DATE" FROM */
                   /* DISPLAYING ON THE RTS SHIPMENT SCREEN */
                   if porec then
                        set ps_nbr
                            receivernbr
                           /* eff_date*/
                            move
                            fill-all
                            cmmt_yn
                            ship_date
                        with frame a1.

                    else
                        set
                                       /*THESE FIELDS NOT USED IN SHIPPING*/
                            /*eff_date*/
                            fill-all
                            cmmt_yn
                        with frame a2.

         /*CKECK TO SEE IF ERS ENABLED AND PACK SLIP FLAG SET IF BLANK PSNBR*/
                if ps_nbr = "" then do:
                   find first apc_ctrl no-lock no-error.
                   find first poc_ctrl no-lock no-error.
                   if (available apc_ctrl and apc_ers_ps_err) and
                      (available poc_ctrl and poc_ers_proc) then do:
                      {mfmsg.i 2305 2} /*ERS WON'T VOUCHER W/O A PACK SLIP*/
                      pause.
                   end.
                end. /*PS NBR BLANK*/

                   if eff_date = ? then eff_date = today.
                   if ship_date = ? then ship_date = eff_date.

/*J2MG*/           /* VERIFY OPEN GL PERIOD FOR LINE ITEM SITE/ENTITY, */
/*J2MG*/           /* NOT PRIMARY ENTITY                               */

/*J2MG**BEGIN DELETE**
 *                 /* CHECK GL EFFECTIVE DATE */
 *                 {gpglef02.i &module = ""IC""
 *                             &entity = glentity
 *                             &date   = eff_date
 *                             &prompt = "eff_date"
 *                             &frame  = "{&frame}"
 *                             &loop   = "seta1"}
 *J2MG**END DELETE*/

 /*J2MG*/           /* IF RECEIVE ALL IS YES, VERIFY OPEN GL PERIOD FOR EACH */
 /*J2MG*/           /* LINE ITEM SITE/ENTITY                                 */

 /*J2MG*/           if fill-all and available po_mstr then
 /*J2MG*/              for each pod_det
 /*J2MG*/                 fields ( pod_assay pod_bo_chg pod_expire pod_fsm_type
 /*J2MG*/                          pod_grade pod_line pod_loc pod_nbr pod_part
 /*J2MG*/                          pod_po_db pod_pr_list pod_ps_chg pod_pur_cost
 /*J2MG*/                          pod_qty_chg pod_qty_ord pod_qty_rcvd
 /*J2MG*/                          pod_rctstat pod_rctstat_active pod_rma_type
 /*J2MG*/                          pod_rum pod_rum_conv pod_sched pod_serial
 /*J2MG*/                          pod_site pod_status pod_type pod_um
 /*J2MG*/                          pod_um_conv )
 /*J2MG*/                 where pod_nbr = po_nbr and pod_line >= 0 and
 /*J2MG*/                       pod_status <> "c" and pod_status <> "x"
 /*J2MG*/                       no-lock use-index pod_nbrln:

 /*J2MG*/                 if porec then do:
 /*J2MG*/                    if pod_rma_type <> "I" and
 /*J2MG*/                       pod_rma_type <> "" then
 /*J2MG*/                       next.
 /*J2MG*/                 end. /* IF POREC */
 /*J2MG*/                 else do:
 /*J2MG*/                    if pod_rma_type <> "O" then
 /*J2MG*/                       next.
 /*J2MG*/                 end. /* IF NOT POREC */

 /*J2MG*/                 for first si_mstr
 /*J2MG*/                    fields ( si_db si_entity si_site )
 /*J2MG*/                    where si_site = pod_site no-lock:
 /*J2MG*/                 end. /* FOR FIRST SI_MSTR */

 /*J2MG*/                 if available si_mstr then do:
 /*J2MG*/                    /* CHECK GL EFFECTIVE DATE */
 /*J2MG*/                    {gpglef02.i &module = ""IC""
                     &entity = si_entity
                     &date   = eff_date
                     &prompt = "eff_date"
                     &frame  = "{&frame}"
                     &loop   = "seta1"}
 /*J2MG*/                 end. /* IF AVAILABLE SI_MSTR */

 /*J2MG*/              end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH POD_DET */

                   /* FIND EXCH RATE IF CURRENCY NOT BASE */
/*L020*/           exch_ratetype = po_ex_ratetype.
                   if base_curr <> po_curr then do:
                      if po_fix_rate then do:
                         exch_rate = po_ex_rate.
/*L020*/                 exch_rate2 = po_ex_rate2.
                         ent_exch  = po_ent_ex.
/*L020*/                 {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
                  "(input po_exru_seq,
                output exch_exru_seq)"}
                      end.
                      else do:  /*IF NOT FIXED RATE ALLOW FOR SPOT RATE*/
/*L020*                  {gpgtex5.i &ent_curr = base_curr */
/*L020*                             &curr = po_curr */
/*L020*                             &date = eff_date */
/*L020*                             &exch_from = exd_rate */
/*L020*                             &exch_to = exch_rate} */
/*L020*/                 /* CREATE EXCHANGE RATE USAGE */

/*L020*/                 {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                          "(input po_curr,
                            input base_curr,
                            input exch_ratetype,
                            input eff_date,
                            output exch_rate,
                            output exch_rate2,
                            output exch_exru_seq,
                            output mc-error-number)"}
/*L020*/                 if mc-error-number <> 0 then do:
/*L020*/                    {mfmsg.i mc-error-number 3}
/*L020*/                    undo, retry.
/*L020*/                 end.

/*L020*                  if exd_rate = exch_rate then
*                           ent_exch = exd_ent_rate.
*                        else
*                           ent_exch = 1 / exd_ent_rate.
*L020*/

                         seta1_sub:
                         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


/*L020*                     update ent_exch with frame seta1_sub.
*                           if ent_exch = 0  then do:
*                              {mfmsg.i 317 3}
*                              /*ZERO NOT ALLOWED*/
*                              undo seta1_sub, retry.
*                           end.
*                           hide frame seta1_sub.
*                           /* SET THE EX_RATE FROM THE ENTERED EXCHANGE RATE */
*                           if ent_exch entered then do:
*                              {gpgtex7.i  &ent_curr=base_curr
*                                          &curr = po_curr
*                                          &exch_from=ent_exch
*                                          &exch_to=exch_rate}
*                              assign exch_rate = ent_exch
*                                     exch_rate2 = ent_exch2.
*                           end.
*L020*/

/*L020*/               {gprunp.i "mcui" "p" "mc-ex-rate-input"
                        "(input po_curr,
                          input base_curr,
                          input eff_date,
                          input exch_exru_seq,
                          input false,
                          input frame-row(a) + 4,
                          input-output exch_rate,
                          input-output exch_rate2,
                          input-output po_fix_rate)"}
/*L020*/                if keyfunc(lastkey) = "end-error" then
               undo seta1_sub, retry seta1_sub.
                         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*seta1_sub*/

/*L020*                 /* TRANSACT'N TO BASE, MAKE (INTERNALLY) BASE TO TRANS*/
*                        if ent_exch entered
*                        and exr_rate <> exd_ent_rate then
*                        exch_rate = 1 / ent_exch.
*L020*/
                      end. /*not fixed rate*/
                   end.
/*L020*/           else assign exch_rate = 1.0
/*L020*/                       exch_rate2 = 1.0
/*L020*/                       exch_exru_seq = 0.

                   if receivernbr <> "" and rcv_type = 2 then do:
                     {mfmsg.i 354 4} /*Rcvr # is system assgnd for rcvr type 2*/
                      next-prompt receivernbr with frame {&frame}.
                      undo seta1, retry.
                   end.

                   if can-find(first prh_hist where prh_receiver = receivernbr)
                   then do:
                      {mfmsg.i 355 3}
                      next-prompt receivernbr with frame {&frame}.
                      undo seta1, retry.
                   end.

                   if cmmt_yn then do: /* ADD COMMENTS, IF DESIRED */
                      hide frame {&frame} no-pause.
                      cmtindx = po_cmtindx.
                      global_ref = cmmt-prefix + " " + po_nbr.
                      {gprun.i ""gpcmmt01.p"" "(input ""po_mstr"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

                      po_cmtindx = cmtindx.
                   end.

                   hide frame b no-pause.
                   leave seta1.
                end.
/*GUI*/ if global-beam-me-up then undo, leave.

             end.
