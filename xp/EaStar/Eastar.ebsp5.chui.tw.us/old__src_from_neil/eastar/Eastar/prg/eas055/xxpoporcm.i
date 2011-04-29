/* poporcm.i - PURCHASE ORDER RECEIPT HEADER FRAME MANIPULATION               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.28.1.4 $                                                     */
/*                                                                            */
/*                                                                            */
/*  CREATED: 7.4     LAST MODIFIED: 01/20/95    by: smp *F0F5*                */
/*  CREATED: 7.4     LAST MODIFIED: 03/10/95    by: jpm *H0BZ*                */
/*  MODIFIED 7.4     LAST MODIFIED: 03/29/95    by: aed *G0JV*                */
/*  MODIFIED 7.5     LAST MODIFIED: 05/12/95    by: mwd *J034*                */
/*                                  08/24/95    by: wjk *H0FM*                */
/*  MODIFIED 7.3                    09/05/95    BY: ais *G0W5*                */
/*  MODIFIED 8.5     LAST MODIFIED: 03/29/95    BY: taf *J053*                */
/*  REVISION: 8.5    LAST MODIFIED: 03/08/96    BY: *J0CV* Robert Wachowicz   */
/*  REVISION: 8.5    LAST MODIFIED: 04/15/96    BY: *J0J8* Robert Wachowicz   */
/*  REVISION: 8.5    LAST MODIFIED: 05/01/96    BY: *J04C* Sue Poland         */
/*  REVISION: 8.5    LAST MODIFIED: 06/20/96    BY: *J0VF* Robert Wachowicz   */
/*  REVISION: 8.5    LAST MODIFIED: 06/28/96    BY: *J0WQ* Robert Wachowicz   */
/*  REVISION: 8.5    LAST MODIFIED: 07/03/96    BY: *J0WY* Robert Wachowicz   */
/*  REVISION: 8.5    LAST MODIFIED: 07/18/96    BY: *J0ZS* T. Farnsworth      */
/*  REVISION: 8.6    LAST MODIFIED: 10/22/96    BY: *K004* Kurt De Wit        */
/*  REVISION: 8.5    LAST MODIFIED: 11/12/96    BY: *J17Y* Sue Poland         */
/*  REVISION: 8.5    LAST MODIFIED: 04/04/97    BY: *J1MR* Sue Poland         */
/*  REVISION: 8.6    LAST MODIFIED: 11/06/97    BY: *H1GJ* Seema Varma        */
/*  REVISION: 8.6E   LAST MODIFIED: 04/29/98    BY: *K1NS* A. Licha           */
/*  REVISION: 8.6E   LAST MODIFIED: 06/26/98    BY: *J2MG* Samir Bavkar       */
/*  REVISION: 8.6E   LAST MODIFIED: 06/30/98    BY: *J2P8* Niranjan R.        */
/*  REVISION: 8.6E   LAST MODIFIED: 07/09/98    BY: *L020* Charles Yen        */
/*  REVISION: 9.0    LAST MODIFIED: 04/16/99    BY: *J2DG* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 06/24/99   BY: *N00N* Jean Miller        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/*  REVISION: 9.1    LAST MODIFIED: 06/10/00    BY: *L0Z4* Abhijeet Thakur  */
/*  REVISION: 9.1    LAST MODIFIED: 07/10/00    BY: *N0FS* Arul Victoria    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* Revision: 1.28     BY: Satish Chavan         DATE:06/27/00    ECO: *N0DK*  */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb                */
/* Revision: 1.28.1.1 BY: Rajiv Ramaiah         DATE:09/17/01   ECO: *N12L*   */
/* Revision: 1.28.1.2 BY: B Gnanasekar          DATE:03/13/02   ECO: *N1CW*   */
/* Revision: 1.28.1.3 BY: Ashwini G.            DATE:04/15/02   ECO: *M1XB*   */
/* $Revision: 1.28.1.4 $ BY: Ashish M.             DATE:06/03/02   ECO: *N1K6*   */
/* REVISION: eB(SP5)     LAST MODIFIED: 08/16/06    BY: Apple      *EAS055A*   */
/*V8:ConvertMode=Maintenance                                                  */

/* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO          */
/* WHEREVER MISSING AND REPLACED FIND STATEMENTS WITH FOR FIRST           */
/* STATEMENTS FOR ORACLE PERFORMANCE.                                     */

/*M1XB*/ /* CODE COMMENTED HAS BEEN MOVED TO poporcm.p TO SOLVE TRANSACTION */
/*M1XB*/ /* SCOPING ISSUE IN ORACLE                                         */

{pxmaint.i}


   view frame {&frame}.

   /*@EVENT POReceipt-create*/
   {pxrun.i &PROC='assignDefaultsForNewReceipt' &PROGRAM='porcxr.p'
            &PARAM="(input-output receivernbr,
                     input-output eff_date,
                     output receipt_date,
                     output move)"
            &NOAPPERROR=True
            &CATCHERROR=True
   }

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
              vndname = "".

              {pxrun.i &PROC='getName' &PROGRAM='adadxr.p'
                       &PARAM="(input po_vend,
                                output vndname)"
                       &NOAPPERROR=True
                       &CATCHERROR=True
              }

               display
                  po_nbr      @ ordernum
                  receivernbr
                  po_vend
                  po_stat
                  vndname
                  "" @ ps_nbr
               with frame {&frame}.
            end. /* IF RECNO <> ? */
         end.  /* IF FRAME-FIELD = "ORDERNUM" */
         else do:
            status input.
            readkey.
            apply lastkey.
         end. /* ELSE DO: */
      end. /* EDITING */


/*N1K6*/ /* READ po_mstr WITH A NO-LOCK WHEN A CLOSED, CANCELLED, BLANKET   */
/*N1K6*/ /* EMT PO IS ACCESSED, WHEN ACCESSING AN RTS PO VIA PO RECEIPTS    */
/*N1K6*/ /* AND VICE VERSA AND FOR A PURCHASE ORDER WITH NO DETAIL LINES.   */
/*N1K6*/ /* READ IT WITH AN EXCLUSIVE-LOCK OTHERWISE                        */

/*N1K6*/ if can-find (first po_mstr
/*N1K6*/                 where po_nbr       = ordernum
/*N1K6*/                 and (   (po_stat   = "C" or
/*N1K6*/                          po_stat   = "X")
/*N1K6*/                      or  po_type   = "B"
/*N1K6*/                      or  po_is_btb = yes
/*N1K6*/                      or  po_fsm_type <> ports))
/*N1K6*/ or not can-find (first pod_det
/*N1K6*/                     where pod_nbr = ordernum)
/*N1K6*/ then do:

/*N1K6*/    /*@EVENT PO-read*/
/*N1K6*/    {pxrun.i &PROC='processRead' &PROGRAM='popoxr.p'
/*N1K6*/             &PARAM="(input ordernum,
/*N1K6*/                      buffer po_mstr,
/*N1K6*/                      input {&NO_LOCK_FLAG},
/*N1K6*/                      input {&NO_WAIT_FLAG})"
/*N1K6*/             &NOAPPERROR=True
/*N1K6*/             &CATCHERROR=True
/*N1K6*/    }
/*N1K6*/ end. /* IF CAN-FIND ( FIRST po_mstr ... */

/*N1K6*/ else do:
            /*@EVENT PO-read*/
            {pxrun.i &PROC='processRead' &PROGRAM='popoxr.p'
                     &PARAM="(input ordernum,
                              buffer po_mstr,
                              input {&LOCK_FLAG},
                              input {&WAIT_FLAG})"
                     &NOAPPERROR=True
                     &CATCHERROR=True
            }
/*N1K6*/ end. /* ELSE DO */

      if not available po_mstr then do:
         if ports = "RTS" then do:
            /* MESSAGE #7499 - RTS MASTER RECORD IS MISSING */
            {pxmsg.i
               &MSGNUM=7499
               &ERRORLEVEL={&APP-ERROR-RESULT}}
         end. /* IF PORTS = "RTS" */
         else do:
            /* MESSAGE #343 - PURCHASE ORDER DOES NOT EXIST */
            {pxmsg.i
               &MSGNUM=343
               &ERRORLEVEL={&APP-ERROR-RESULT}}
         end. /* ELSE DO: */

         next-prompt ordernum with frame {&frame}.
         undo seta, retry.
      end. /* IF NOT AVAILABLE PO_MSTR */

      /*@EVENT POReceipt-create*/
      {pxrun.i &PROC='validateEMTReceipt' &PROGRAM='porcxr.p'
               &PARAM="(input po_is_btb)"
               &NOAPPERROR=True
               &CATCHERROR=True
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt po_nbr with frame a.
         undo, retry.
      end.

      /*@EVENT POReceipt-create*/
      {pxrun.i &PROC='validatePOStatus' &PROGRAM='porcxr.p'
               &PARAM="(input po_stat)"
               &NOAPPERROR=True
               &CATCHERROR=True
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt ordernum with frame {&frame}.
         undo seta, retry.
      end. /* IF pOrderStatus = "C" */

      /*@EVENT POReceipt-create*/
      {pxrun.i &PROC='validateBlanketReceipt' &PROGRAM='porcxr.p'
               &PARAM="(input po_type)"
               &NOAPPERROR=True
               &CATCHERROR=True
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt ordernum with frame {&frame}.
         undo seta, retry.
      end. /* IF pPurchaseOrderType = "B" */

      /*@MODULE RTS BEGIN*/
      if ports = "RTS" and po_fsm_type <> ports then do:
         /* MESSAGE #7363 - CANNOT PROCESS PURCHASE ORDERS WITH */
         /* RTS ORDER PROGRAMS */
         {pxmsg.i
            &MSGNUM=7363
            &ERRORLEVEL={&APP-ERROR-RESULT}}
         next-prompt ordernum with frame {&frame}.
         undo seta, retry.
      end. /* IF PORTS = "RTS" AND PO_FSM_TYPE <> PORTS */
      /*@MODULE RTS END*/

      /*@EVENT POReceipt-create*/
      {pxrun.i &PROC='validateRTSReceipt' &PROGRAM='porcxr.p'
               &PARAM="(input po_fsm_type,
                        input ports)"
               &NOAPPERROR=True
               &CATCHERROR=True
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt ordernum with frame {&frame}.
         undo seta, retry.
      end. /* IF PORTS = "" AND pFSMType <> PORTS */

      /*@EVENT POReceipt-create*/
      {pxrun.i &PROC='getRoundingMethod' &PROGRAM='mcexxr.p'
               &PARAM="(input po_curr,
                        output rndmthd)"
               &NOAPPERROR=True
               &CATCHERROR=True
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt ordernum with frame {&frame}.
         undo seta, retry.
      end.


      /* SET CURRENCY DEPENDENT FORMATS */
      {pocurfmt.i }

        vndname = "".

      /*@EVENT PO-read*/
      {pxrun.i &PROC='getName' &PROGRAM='adadxr.p'
               &PARAM="(input po_vend,
                        output vndname)"
               &NOAPPERROR=True
               &CATCHERROR=True
      }

      display
         receivernbr
         po_vend
         po_stat
         vndname
         "" @ ps_nbr
      with frame {&frame}.

      pook = no.

      /*@EVENT POReceipt-create*/
      {pxrun.i &PROC='validateReceiptLines' &PROGRAM='porcxr.p'
               &PARAM="(input po_nbr)"
               &NOAPPERROR=True
               &CATCHERROR=True
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         next-prompt ordernum with frame {&frame}.
         undo seta, retry.
      end.

/*N12L*/ if ports = "RTS"
/*N12L*/ then do:
            /*@EVENT POReceipt-create*/
            {pxrun.i &PROC='validateSiteSecurity' &PROGRAM='porcxr.p'
                     &PARAM="(input po_nbr)"
                     &NOAPPERROR=True
                     &CATCHERROR=True
            }

            if return-value <> {&SUCCESS-RESULT} then do:
               next-prompt ordernum with frame {&frame}.
               undo seta, retry.
            end.
/*N12L*/ end. /* IF ports = "RTS" */

      /*@EVENT POReceipt-create*/
      {pxrun.i &PROC='validateDbConnected' &PROGRAM='porcxr.p'
               &PARAM="(input po_nbr)"
               &NOAPPERROR=True
               &CATCHERROR=True
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         undo seta, retry.
      end.
      /* MAKE SURE THAT CENTRAL DATABASE IS CONNECTED */


   end. /* SETA: DO ON ERROR UNDO */

   seta1:
   /* THE DO WHILE TRUE IS REQUIRED FOR CORRECT CIM PROCESSING */
   do while true on error undo, retry:
      /*@EVENT POReceipt-create*/
      /*@TO-DO - need to call setGlobalCharacter in POReceipt DTC*/
      global_addr = po_vend.

      /* SPLIT OUT THE SET STATEMENT TO PREVENT "SHIP DATE" FROM */
      /* DISPLAYING ON THE RTS SHIPMENT SCREEN */
      if porec then
         set ps_nbr
             receivernbr
             eff_date
             move
             fill-all
             cmmt_yn
             ship_date
         with frame a1.
      else
         set
             /*THESE FIELDS NOT USED IN SHIPPING*/
             eff_date
             fill-all
             cmmt_yn
         with frame a2.

      /*@EVENT POReceipt-write*/
      {pxrun.i &PROC='validateERSPackingSlip' &PROGRAM='aperxr.p'
               &PARAM="(input ps_nbr)"
               &NOAPPERROR=True
               &CATCHERROR=True
      }
      if return-value <> {&SUCCESS-RESULT} then do:
         pause.
      end.

      /*@EVENT POReceipt-write*/
      {pxrun.i &PROC='setEffectiveDate' &PROGRAM='porcxr.p'
               &PARAM="(input-output eff_date,
                        input-output ship_date)"
               &NOAPPERROR=True
               &CATCHERROR=True
      }

      /*@MODULE RCV-ALL BEGIN*/
      /* VERIFY OPEN GL PERIOD FOR LINE ITEM SITE/ENTITY, */
      /* NOT PRIMARY ENTITY                               */

      /* IF RECEIVE ALL IS YES, VERIFY OPEN GL PERIOD FOR EACH */
      /* LINE ITEM SITE/ENTITY                                 */

      if fill-all and available po_mstr then
         for each pod_det
            fields ( pod_assay pod_bo_chg pod_expire pod_fsm_type
                     pod_grade pod_line pod_loc pod_nbr pod_part
                     pod_po_db pod_pr_list pod_ps_chg pod_pur_cost
                     pod_qty_chg pod_qty_ord pod_qty_rcvd
                     pod_rctstat pod_rctstat_active pod_rma_type
                     pod_rum pod_rum_conv pod_sched pod_serial
                     pod_site pod_status pod_type pod_um
                     pod_um_conv)
            where pod_nbr = po_nbr and pod_line >= 0
              and pod_status <> "c" and pod_status <> "x"
            no-lock use-index pod_nbrln:

            if porec then do:
               if pod_rma_type <> "I" and
                  pod_rma_type <> "" then
                  next.
            end. /* IF POREC */
            else do:
               if pod_rma_type <> "O" then
                  next.
            end. /* IF NOT POREC */

/*N1CW*/    /* REPLACED INPUT PARAMETER &LOCK_FLAG BY &NO_LOCK_FLAG AND */
/*N1CW*/    /* INPUT PARAMETER &WAIT_FLAG BY &NO_WAIT_FLAG IN ORDER TO  */
/*N1CW*/    /* AVOID LOCKING OF si_mstr                                 */

            {pxrun.i &PROC='processRead' &PROGRAM='icsixr.p'
                     &PARAM="(input pod_site,
                              buffer si_mstr,
                              input {&NO_LOCK_FLAG},
                              input {&NO_WAIT_FLAG})"
                     &NOAPPERROR=True
                     &CATCHERROR=True
            }

            if return-value = {&SUCCESS-RESULT} then do:
               /* CHECK GL EFFECTIVE DATE */
               {gpglef02.i
                  &module = ""IC""
                  &entity = si_entity
                  &date   = eff_date
                  &prompt = "eff_date"
                  &frame  = "{&frame}"
                  &loop   = "seta1"}
            end. /* IF AVAILABLE SI_MSTR */
         end. /* FOR EACH POD_DET */
      /*@MODULE RCV-ALL END*/

      exch_ratetype = po_ex_ratetype.
      /*@EVENT POReceipt-create*/
      {pxrun.i &PROC='getExchangeRate' &PROGRAM='porcxr.p'
               &PARAM="(buffer po_mstr,
                        input exch_ratetype,
                        input eff_date,
                        output exch_rate,
                        output exch_rate2,
                        output exch_exru_seq)"
               &NOAPPERROR=True
               &CATCHERROR=True
      }
      if return-value <> {&SUCCESS-RESULT} then do:
          undo, retry.
      end.

/*sqc** ADDED BY SQC */
      /*TO DO: Leave this for CHUI mode since this method displays a frame.*/
      /*       For API Mode, Call the Exchange Rate ROP as Apporriate for  */
      /*       Read/Write                                                  */

/*M1XB** BEGIN DELETE **
 *
 *     if base_curr <> po_curr then do:
 *        if not po_fix_rate then do:
 *            seta1_sub:
 *           do on error undo, retry:
 *               {gprunp.i "mcui" "p" "mc-ex-rate-input"
 *                        "(input po_curr,
 *                         input base_curr,
 *                        input eff_date,
 *                           input exch_exru_seq,
 *                           input false,
 *                           input frame-row(a) + 4,
 *                           input-output exch_rate,
 *                           input-output exch_rate2,
 *                           input-output po_fix_rate)"}
 *
 *               if keyfunction(lastkey) = "end-error" then
 *                  undo seta1_sub, retry seta1_sub.
 *            end. /* SETA1_SUB */
 *         end. /*IF  NOT FIXED RATE */
 *      end. /* IF BASE_CURR <> PO_CURR */
 *
 *M1XB** END DELETE *   */

/*sqc** END ADDED BY SQC */

      /*@EVENT POReceipt-write*/
/*eas055      {pxrun.i &PROC='validateReceiverId' &PROGRAM='porcxr.p'*/
/*eas055*/      {pxrun.i &PROC='validateReceiverId' &PROGRAM='xxporcxr.p'
               &PARAM="(input receivernbr,
                        input rcv_type)"
               &NOAPPERROR=True
               &CATCHERROR=True
      }
      if return-value <> {&SUCCESS-RESULT} then do:

/*M1XB*/ /* RECEIVER NUMBER ALREADY EXISTS */
/*M1XB*/ {pxmsg.i
            &MSGNUM=355
            &ERRORLEVEL={&APP-ERROR-RESULT}}

         next-prompt receivernbr with frame {&frame}.
         undo seta1, retry.
      end. /* IF CAN-FIND(FIRST PRH_HIST */

/*eas055*****************************************/
        if receivernbr = "" then do:
	      message "Error: Invalid Receiver Number.Please re-enter.".
              next-prompt receivernbr with frame {&frame}.
              undo seta1, retry.
	end.
	if length(receivernbr) = 1 then do:
	   find first xxdn_ctrl where xxdn_code = receivernbr no-lock no-error.
	   if not available xxdn_ctrl then do:
	      message "Error: Invalid Code.Please re-enter.".
              next-prompt receivernbr with frame {&frame}.
              undo seta1, retry.
	   end.
	end.
/*eas055*****************************************/

/*M1XB** BEGIN DELETE *
 *    if cmmt_yn then do: /* ADD COMMENTS, IF DESIRED */
 *       hide frame {&frame} no-pause.
 *       /*@TO-DO - need to check how these defaults get into comments in XUI*/
 *       assign
 *          cmtindx    = po_cmtindx
 *          global_ref = cmmt-prefix + " " + po_nbr.
 *
 *       {gprun.i ""gpcmmt01.p"" "(input ""po_mstr"")"}
 *       po_cmtindx = cmtindx.
 *    end. /* IF CMMT_YN */
 *
 *M1XB** END DELETE */

      hide frame b no-pause.
      leave seta1.
   end. /* SETA1: */
