/* xxpoporcm.i - PURCHASE ORDER RECEIPT HEADER FRAME MANIPULATION       */
/* poporcm.i - PURCHASE ORDER RECEIPT HEADER FRAME MANIPULATION               */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.41 $                                                        */
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
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* Revision: 1.28       BY: Satish Chavan       DATE:06/27/00  ECO: *N0DK*  */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* Revision: 1.29    BY: Rajiv Ramaiah      DATE: 09/17/01  ECO: *N12L*     */
/* Revision: 1.30    BY: B Gnanasekar       DATE: 03/13/02  ECO: *N1CW*     */
/* Revision: 1.31    BY: Ashwini G.         DATE: 04/26/02  ECO: *M1XB*     */
/* Revision: 1.32    BY: Jeff Wootton       DATE: 05/16/02  ECO: *P03G*     */
/* Revision: 1.33    BY: Ashish M.          DATE: 06/03/02  ECO: *N1K6*     */
/* Revision: 1.35    BY: Pawel Grzybowski   DATE: 03/03/27  ECO: *P0NT*     */
/* Revision: 1.37    BY: Paul Donnelly (SB) DATE: 06/28/03  ECO: *Q00J*     */
/* Revision: 1.39    BY: Kirti Desai        DATE: 11/05/03  ECO: *P18G*     */
/* Revision: 1.40    BY: Mandar Gawde       DATE: 06/21/04  ECO: *P270*     */
/* $Revision: 1.41 $   BY: Dan Herman       DATE: 11/04/04  ECO: *M1V1*  */
/* SSIVAN 07122701 BY:Ivan Yang Date:12/27/07				*/
/*                   1. Display Vendor Chinese Name(vd_rmks) for TW Ver Only*/
/*                   2. Check Effective Date by xxicindate.p                */
/*                   3. Disable Receive All function fill-all               */
/*                   4. Disable Exchange Rate input                         */
/*		     5. Add variable to control if xxicindate.p should be executed            */
/*-Revision end---------------------------------------------------------------*/


/*****************************************************************************/
/* THIS INCLUDE WAS CLONED TO kbporcm.i 05/16/02, REMOVING UI.      */
/* CHANGES TO THIS INCLUDE MAY ALSO NEED TO BE APPLIED TO kbporcm.i */
/*****************************************************************************/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

/* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO          */
/* WHEREVER MISSING AND REPLACED FIND STATEMENTS WITH FOR FIRST           */
/* STATEMENTS FOR ORACLE PERFORMANCE.                                     */

{pxmaint.i}
{cxcustom.i "POPORCM.I"}

if c-application-mode <> "API" then
   view frame {&frame}.

/*@EVENT POReceipt-create*/
{pxrun.i &PROC='assignDefaultsForNewReceipt' &PROGRAM='porcxr.p'
         &PARAM="(input-output receivernbr,
                  input-output eff_date,
                  output receipt_date,
                  output move)"
         &NOAPPERROR=true
         &CATCHERROR=true
}

cmmt_yn = no.
/*SSIVAN 07122701 add*/	   fill-all = no.

if c-application-mode <> "API" then
   display
      receivernbr
      eff_date
      move          when (porec)
      fill-all
      cmmt_yn
   with frame {&frame}.

receivernbr = "".
/*SSIVAN 07122701 add*/       vndname = "".

seta:
do on error undo, retry:
   if c-application-mode = "API" and retry
      then return error return-value.

   if c-application-mode <> "API" then
   set ordernum
      with frame {&frame}
   editing:
      if frame-field = "ordernum"
      then do:
         /* FIND NEXT/PREVIOUS RECORD */
         /* Do not scroll thru RTS for PO or PO for RTS */
         /* CHANGED '"input ordernum"' to 'frame-value' BELOW */
         /* PROVIDING A STARTING POINT FOR SCROLLING)         */
         {mfnp06.i
            po_mstr
            po_nbr
            " po_mstr.po_domain = global_domain and po_type  <> ""B"" and
            po_fsm_type = ports"
            po_nbr
            frame-value
            yes
            yes }

         if recno <> ?
         then do:
            vndname = "".
/*SSIVAN 07122701 add */                   find vd_mstr
/*SSIVAN 07122701 add */                   where vd_mstr.vd_domain = global_domain and vd_addr = po_vend no-lock no-error.
/*SSIVAN 07122701 add */                   find ad_mstr
/*SSIVAN 07122701 add */                   where ad_mstr.ad_domain = global_domain and ad_addr = po_vend no-lock no-error.

/*SSIVAN 07122701 rmk begin*
*            {pxrun.i &PROC='getName' &PROGRAM='adadxr.p'
*                     &PARAM="(input po_vend,
*                              output vndname)"
*                     &NOAPPERROR=true
*                     &CATCHERROR=true
*            }
*SSIVAN 07122701 rmk end*/
/*SSIVAN 07122701 add */                   if vd_rmks <> "" then vndname = vd_rmks.
/*SSIVAN 07122701 add */                                    else vndname = ad_name.

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

   if c-application-mode = "API" then
      ordernum = ttPurchaseOrderTrans.nbr.

   /* READ po_mstr WITH A NO-LOCK WHEN A CLOSED, CANCELLED, BLANKET   */
   /* EMT PO IS ACCESSED AND WHEN ACCESSING AN RTS PO VIA PO RECEIPTS */
   /* AND VICE VERSA AND FOR A PURCHASE ORDER WITH NO DETAIL LINES.   */
   /* READ IT WITH AN EXCLUSIVE-LOCK OTHERWISE                        */

   if can-find (first po_mstr
                    where po_mstr.po_domain = global_domain and (  po_nbr
                      = ordernum
                   and (   (po_stat     = "C" or
                            po_stat     = "X")
                        or  po_type     = "B"
                        or  po_is_btb   = yes
                        or  po_fsm_type <> ports)))
   or not can-find(first pod_det
                       where pod_det.pod_domain = global_domain and  pod_nbr =
                       ordernum)
   then do:
      /*@EVENT PO-read*/
      {pxrun.i &PROC='processRead' &PROGRAM='popoxr.p'
               &PARAM="(input ordernum,
                        buffer po_mstr,
                        input {&NO_LOCK_FLAG},
                        input {&NO_WAIT_FLAG})"
               &NOAPPERROR=True
               &CATCHERROR=True
      }
   end. /* IF CAN-FIND FIRST po_mstr */

   else do:
      /*@EVENT PO-read*/
      {pxrun.i &PROC='processRead' &PROGRAM='popoxr.p'
               &PARAM="(input ordernum,
                        buffer po_mstr,
                        input {&LOCK_FLAG},
                        input {&WAIT_FLAG})"
               &NOAPPERROR=True
               &CATCHERROR=True
      }
   end. /* ELSE DO */

   if not available po_mstr
   then do:
      if ports = "RTS"
      then do:
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
            &NOAPPERROR=true
            &CATCHERROR=true
   }
   if return-value <> {&SUCCESS-RESULT}
   then do:
      next-prompt po_nbr with frame a.
      undo, retry.
   end.

   /*@EVENT POReceipt-create*/
   {pxrun.i &PROC='validatePOStatus' &PROGRAM='porcxr.p'
            &PARAM="(input po_stat)"
            &NOAPPERROR=true
            &CATCHERROR=true
   }
   if return-value <> {&SUCCESS-RESULT}
   then do:
      next-prompt ordernum with frame {&frame}.
      undo seta, retry.
   end. /* IF pOrderStatus = "C" */

   /*@EVENT POReceipt-create*/
   {pxrun.i &PROC='validateBlanketReceipt' &PROGRAM='porcxr.p'
            &PARAM="(input po_type)"
            &NOAPPERROR=true
            &CATCHERROR=true
   }
   if return-value <> {&SUCCESS-RESULT}
   then do:
      next-prompt ordernum with frame {&frame}.
      undo seta, retry.
   end. /* IF pPurchaseOrderType = "B" */

   /*@MODULE RTS BEGIN*/
   if  ports       =  "RTS"
   and po_fsm_type <> ports
   then do:
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
            &NOAPPERROR=true
            &CATCHERROR=true
   }
   if return-value <> {&SUCCESS-RESULT}
   then do:
      next-prompt ordernum with frame {&frame}.
      undo seta, retry.
   end. /* IF PORTS = "" AND pFSMType <> PORTS */

   /*@EVENT POReceipt-create*/
   {pxrun.i &PROC='getRoundingMethod' &PROGRAM='mcexxr.p'
            &PARAM="(input po_curr,
                     output rndmthd)"
            &NOAPPERROR=true
            &CATCHERROR=true
   }
   if return-value <> {&SUCCESS-RESULT}
   then do:
      next-prompt ordernum with frame {&frame}.
      undo seta, retry.
   end.

   /* SET CURRENCY DEPENDENT FORMATS */
   {pocurfmt.i }



   vndname = "".

/*SSIVAN 07122701 add */                   find vd_mstr
/*SSIVAN 07122701 add */                   where vd_mstr.vd_domain = global_domain and vd_addr = po_vend no-lock no-error.
/*SSIVAN 07122701 add */                   find ad_mstr
/*SSIVAN 07122701 add */                   where ad_mstr.ad_domain = global_domain and ad_addr = po_vend no-lock no-error.

/*SSIVAN 07122701 rmk begin*
*   /*@EVENT PO-read*/
*   {pxrun.i &PROC='getName' &PROGRAM='adadxr.p'
*            &PARAM="(input po_vend,
*                     output vndname)"
*            &NOAPPERROR=true
*            &CATCHERROR=true
*   }
*SSIVAN 07122701 rmk end*/

/*SSIVAN 07122701 add */          if vd_rmks <> "" then vndname = vd_rmks.
/*SSIVAN 07122701 add */                           else vndname = ad_name.


   if c-application-mode <> "API" then
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
            &NOAPPERROR=true
            &CATCHERROR=true
   }
   if return-value <> {&SUCCESS-RESULT}
   then do:
      next-prompt ordernum with frame {&frame}.
      undo seta, retry.
   end.

   if ports = "RTS"
   then do:
      /*@EVENT POReceipt-create*/
      {pxrun.i &PROC='validateSiteSecurity' &PROGRAM='porcxr.p'
               &PARAM="(input po_nbr)"
               &NOAPPERROR=true
               &CATCHERROR=true
      }
      if return-value <> {&SUCCESS-RESULT}
      then do:
         next-prompt ordernum with frame {&frame}.
         undo seta, retry.
      end.
   end. /* IF ports = "RTS" */

   /*@EVENT POReceipt-create*/
   {pxrun.i &PROC='validateDbConnected' &PROGRAM='porcxr.p'
            &PARAM="(input po_nbr)"
            &NOAPPERROR=true
            &CATCHERROR=true
   }
   if return-value <> {&SUCCESS-RESULT}
   then do:
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
   if c-application-mode <> "API" then do:
      if porec
      then
         set
         ps_nbr
         receivernbr
         {&POPORCM-I-TAG1}
         eff_date
         move
/*SSIVAN 07122701 rmk*/  /*       fill-all    */
         cmmt_yn
         ship_date
      with frame a1.
      else
      set
         /*THESE FIELDS NOT USED IN SHIPPING*/
         eff_date
/*SSIVAN 07122701 rmk*/  /*       fill-all    */
         cmmt_yn
      with frame a2.
   end.

   if c-application-mode = "API" then do:
      if porec then
         assign
            {mfaiset.i ps_nbr      ttPurchaseOrderTrans.psNbr}
            {mfaiset.i receivernbr ttPurchaseOrderTrans.receiver}
            {mfaiset.i eff_date    ttPurchaseOrderTrans.effDate}
            move     = yes
            fill-all = no
            cmmt_yn  = yes
            {mfaiset.i ship_date   ttPurchaseOrderTrans.shipDate}.
      else
         assign
            {mfaiset.i eff_date    ttPurchaseOrderTrans.rcpDate}
            fill-all = yes
            cmmt_yn  = yes.
   end.

   if ps_nbr = ?
   then do:
      /* PACKING SLIP NUMBER CANNOT BE ? */
      {pxmsg.i &MSGNUM=6595 &ERRORLEVEL=3}
      next-prompt ps_nbr with frame {&frame}.
      undo seta1, retry.
   end. /* IF ps_nbr = ? */

   if ports <> "RTS"
   then do:
      /*@EVENT POReceipt-write*/
      {pxrun.i &PROC='validateERSPackingSlip' &PROGRAM='aperxr.p'
               &PARAM="(input ps_nbr)"
               &NOAPPERROR=true
               &CATCHERROR=true
      }
      if return-value <> {&SUCCESS-RESULT}
      then do:
         if c-application-mode <> "API" then
            pause.
      end.
   end. /* IF ports <> "RTS" */

   /*@EVENT POReceipt-write*/
   {pxrun.i &PROC='setEffectiveDate' &PROGRAM='porcxr.p'
            &PARAM="(input-output eff_date,
                     input-output ship_date)"
            &NOAPPERROR=true
            &CATCHERROR=true
   }

/*SSIVAN 07122701 add*/          if check-eff = yes then do:
/*SSIVAN 07122701 add*/          {gprun.i ""xxicindate.p""}
/*SSIVAN 07122701 add*/          if dummy then do:
/*SSIVAN 07122701 add*/             undo, retry.
/*SSIVAN 07122701 add*/          end.
/*SSIVAN 07122701 add*/          end.

   /*@MODULE RCV-ALL BEGIN*/
   /* VERIFY OPEN GL PERIOD FOR LINE ITEM SITE/ENTITY, */
   /* NOT PRIMARY ENTITY                               */

   /* IF RECEIVE ALL IS YES, VERIFY OPEN GL PERIOD FOR EACH */
   /* LINE ITEM SITE/ENTITY                                 */

   if fill-all
   and available po_mstr
   then
   for each pod_det
      fields( pod_domain  pod_assay pod_bo_chg pod_expire pod_fsm_type
               pod_grade pod_line pod_loc pod_nbr pod_part
               pod_po_db pod_pr_list pod_ps_chg pod_pur_cost
               pod_qty_chg pod_qty_ord pod_qty_rcvd
               pod_rctstat pod_rctstat_active pod_rma_type
               pod_rum pod_rum_conv pod_sched pod_serial
               pod_site pod_status pod_type pod_um
               pod_um_conv)
       where pod_det.pod_domain = global_domain and  pod_nbr  =  po_nbr
      and pod_line   >= 0
      and pod_status <> "c"
      and pod_status <> "x"
      no-lock use-index pod_nbrln:

      if porec
      then do:
         if  pod_rma_type <> "I"
         and pod_rma_type <> ""
         then
            next.
      end. /* IF POREC */
      else do:
         if pod_rma_type <> "O"
         then
            next.
      end. /* IF NOT POREC */

      /* REPLACED INPUT PARAMETER &LOCK_FLAG BY &NO_LOCK_FLAG AND */
      /* INPUT PARAMETER &WAIT_FLAG BY &NO_WAIT_FLAG IN ORDER TO  */
      /* AVOID LOCKING OF si_mstr                                 */

      {pxrun.i &PROC='processRead' &PROGRAM='icsixr.p'
               &PARAM="(input pod_site,
                        buffer si_mstr,
                        input {&NO_LOCK_FLAG},
                        input {&NO_WAIT_FLAG})"
               &NOAPPERROR=true
               &CATCHERROR=true
      }

      if return-value = {&SUCCESS-RESULT}
      then do:

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
            &NOAPPERROR=true
            &CATCHERROR=true
   }
   if return-value <> {&SUCCESS-RESULT}
   then do:
      undo, retry.
   end.

   {&POPORCM-I-TAG2}
   /*@EVENT POReceipt-write*/
   {pxrun.i &PROC='validateReceiverId' &PROGRAM='porcxr.p'
            &PARAM="(input receivernbr,
                     input rcv_type)"
            &NOAPPERROR=true
            &CATCHERROR=true
   }
   if return-value <> {&SUCCESS-RESULT}
   then do:

      /* RECEIVER NUMBER ALREADY EXISTS */
      {pxmsg.i
         &MSGNUM=355
         &ERRORLEVEL={&APP-ERROR-RESULT}}

      next-prompt receivernbr with frame {&frame}.
      undo seta1, retry.
   end. /* IF CAN-FIND(FIRST PRH_HIST */

   {&POPORCM-I-TAG3}
   if c-application-mode <> "API" then
      hide frame b no-pause.
   leave seta1.
end. /* SETA1: */
