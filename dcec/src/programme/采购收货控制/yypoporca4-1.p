/* GUI CONVERTED from poporca4.p (converter v1.76) Tue Jan 28 03:41:12 2003 */
/* poporca4.p - PURCHASE ORDER RECEIPT OVER RECEIPT TOLERANCE CHECKS          */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.17 $                                                          */
/*                                                                            */
/*                                                                            */
/* REVISION: 7.3     LAST MODIFIED: 09/14/93    BY: tjs *GE59*                */
/* REVISION: 7.3     LAST MODIFIED: 05/27/93    BY: tjs *FO47*                */
/* REVISION: 7.3     LAST MODIFIED: 02/14/95    BY: WUG *G0F7*                */
/* REVISION: 7.3     LAST MODIFIED: 03/29/95    BY: bcm *G0JN*                */
/* REVISION: 7.3     LAST MODIFIED: 08/07/95    BY: jym *G0TP*                */
/* REVISION: 7.3     LAST MODIFIED: 09/12/95    BY: vrn *G0X3*                */
/* REVISION: 7.4     LAST MODIFIED: 10/06/95    BY: vrn *G0XW*                */
/* REVISION: 8.5     LAST MODIFIED: 09/09/95    by: mwd *J053*                */
/* REVISION: 8.5     LAST MODIFIED: 04/09/96    by: rxm *H0KH*                */
/* REVISION: 8.5     LAST MODIFIED: 07/16/96    BY: rxm *G1SV*                */
/* REVISION: 8.6E    LAST MODIFIED: 05/09/98    BY: *L00Y* Jeff Wootton       */
/* REVISION: 8.6E    LAST MODIFIED: 06/17/98    BY: *L020* Charles Yen        */
/* REVISION: 8.6E    LAST MODIFIED: 11/12/98    BY: *J30M* Seema Varma        */
/* REVISION: 9.0     LAST MODIFIED: 04/16/99    BY: *J2DG* Reetu Kappor       */
/* REVISION: 9.1     LAST MODIFIED: 09/03/99    BY: *J3L4* Kedar Deherkar     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* REVISION: 9.1     LAST MODIFIED: 06/29/00    BY: *N0DK* Mugdha Tambe       */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KQ* myb                */
/* $Revision: 1.17 $    BY: Deepali Kotavadekar   DATE: 01/21/03  ECO: *N23Y* */
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */
/* $Revision: eb2+sp7  BY: Steve judy Liu       DATE: 05/08/12  ECO: *judy*   */
/*$Revision:eb2+sp7    By: Willy Song           Date: 07/03/06  ECO: *S777*   */

/*!
    poporca4.p - PERFORM TOLERANCE CHECKING FOR PO RECEIPTS
    Last change:  SMC  26 May 2000   12:33 pm
*/

/*!
    NOT USED IN PO RETURNS (porvis.p)
*/

{mfdeclre.i}

/* SHARED VARIABLES */
define shared variable base_amt            like pod_pur_cost.
define shared variable conv_to_pod_um      like pod_um_conv.
define shared variable eff_date            like glt_effdate.
define shared variable exch_rate           like exr_rate.
define shared variable exch_rate2          like exr_rate.
define shared variable exch_ratetype       like exr_ratetype.
define shared variable exch_exru_seq       like exru_seq.
define shared variable total_lotserial_qty like pod_qty_chg.
define shared variable total_received      like pod_qty_rcvd.
define shared variable updt_blnkt          like mfc_logical.
define shared variable po_recno            as   recid.
define shared variable pod_recno           as   recid.
define shared variable updt_blnkt_list     as   character no-undo.

/* LOCAL VARIABLES AND BUFFERS */
define variable divisor         like schd_discr_qty no-undo.
define variable newprice        like pod_pur_cost   no-undo.
define variable overage_qty     like pod_qty_rcvd   no-undo.
define variable qty_open        like pod_qty_rcvd   no-undo.
define variable dummy_disc      like pod_disc_pct   no-undo.
define variable mc-error-number like msg_nbr        no-undo.
define variable price_qty       as   decimal        no-undo.
define variable w-int1          as   integer        no-undo.
define variable w-int2          as   integer        no-undo.
define variable pc_recno        as   recid          no-undo.

define buffer poddet for pod_det.

define output parameter undotran like mfc_logical no-undo.
/*S777* /*judy  05/08/12 */  DEFINE VARIABLE xxallover AS LOGICAL INIT NO. */
{pxmaint.i}
/*S777*         07/03/06 *
undotran = yes. */
undotran = NO.
do on error undo, retry:

   for first poc_ctrl
      fields(poc_tol_cst poc_tol_pct) no-lock:
   end. /* FOR FIRST POC_CTRL */

   /** DOWN GRADE TO A NO-LOCK, NO UPDATE NEEDED **/


   for first po_mstr
      fields(po_curr po_vend)
      where recid(po_mstr) = po_recno no-lock:
   end. /* FOR FIRST PO_MSTR */

   find pod_det where recid(pod_det) = pod_recno exclusive-lock.

   if pod_sched then do:


/*S777*   added 07/02/28 */

     for first in_mstr fields (in_part in_site in_abc) where in_part = pod_part and in_site = pod_site no-lock:
     end.

      IF trim(pod_pkg_code) <> "X" and available in_mstr THEN DO:
         IF in_abc = "A" OR in_abc = "B" THEN DO:
            {pxrun.i &PROC='getOpenScheduleQuantity' &PROGRAM='rsscxr.p'
                      &PARAM="(output divisor,
                               output qty_open,
                               input eff_date,
                               buffer pod_det)"
                      &NOAPPERROR=True
                      &CATCHERROR=True
             }
                    IF total_lotserial_qty > qty_open  THEN DO:
                        {pxmsg.i
                           &MSGNUM=8305
                           &ERRORLEVEL= 3
                           &MSGARG1=string(eff_date) }
                        /*S777*/  undotran  = YES.
                    END.
         end.
         ELSE IF in_abc = "C" THEN DO:
              {pxrun.i &PROC='checkMaxOrderQty' &PROGRAM='porcxr1.p'
               &PARAM="(buffer pod_det,
                       input total_lotserial_qty)"
               &NOAPPERROR=True
               &CATCHERROR=True
               }

              if return-value <> {&SUCCESS-RESULT} then do:
                 if not batchrun then pause.
              end.

              {pxrun.i &PROC='getScheduleReceiptCost' &PROGRAM='porcxr1.p'
               &PARAM="(input eff_date,
                        input po_curr,
                        input po_vend,
                        input total_lotserial_qty,
                        buffer pod_det)"
               &NOAPPERROR=True
               &CATCHERROR=True
              }
      /* TOLERANCE CHECKING FOR SCHEDULED ORDERS */


              {pxrun.i &PROC='getOpenScheduleQuantity' &PROGRAM='rsscxr.p'
               &PARAM="(output divisor,
                        output qty_open,
                        input eff_date,
                        buffer pod_det)"
               &NOAPPERROR=True
               &CATCHERROR=TRUE 
               }

             {pxrun.i &PROC='checkScheduleQtyTolerance' &PROGRAM='porcxr1.p' 
  	          &PARAM="(input divisor,
                       input qty_open,
                       input total_lotserial_qty,
                       input conv_to_pod_um,
                       input poc_tol_pct,
                       input eff_date)"
               &NOAPPERROR=True
               &CATCHERROR=True
              }

              if return-value <> {&SUCCESS-RESULT} then do:
                 if not batchrun then pause.
/*S777*/         undotran  = YES.
              end.

             {pxrun.i &PROC='checkScheduleCostTolerance' &PROGRAM='porcxr1.p' 
	           &PARAM="(input exch_rate,
                        input exch_rate2,
                        input qty_open,
                        input conv_to_pod_um,
                        input total_lotserial_qty,
                        input poc_tol_cst,
                        input eff_date,
                        input po_curr,
                        buffer pod_det)"
               &NOAPPERROR=True
               &CATCHERROR=True
             } 

            if return-value <> {&SUCCESS-RESULT} then do:
               if not batchrun then pause.
/*S777*/         undotran  = YES.
            end.


       END.  /* in_abc = C */

    END. /* pod_pkg_code <> X */
 



   end. /* IF POD_SCHED */

/* this is the end tag that will be only in API mode (not an extraction tag) */

   else do:
      /*! TOLERANCE CHECKING FOR NON-SCHEDULED ORDERS */
      if (total_received > pod_qty_ord and pod_qty_ord >= 0)
         or (total_received < pod_qty_ord and pod_qty_ord < 0)
      then do:

         overage_qty = total_received - pod_qty_ord.
         /*! CHECK PERCENT OVERSHIP*/
         {pxrun.i &PROC='checkQtyTolerance' &PROGRAM='porcxr1.p'
                  &PARAM="(input overage_qty,
                           input pod_qty_ord,
                           input poc_tol_pct)"
                   &NOAPPERROR=True
                   &CATCHERROR=True
         }
         if return-value <> {&SUCCESS-RESULT} then
            undo, retry.
         {pxrun.i &PROC='checkCostTolerance' &PROGRAM='porcxr1.p'
                  &PARAM="(input exch_rate,
                           input exch_rate2,
                           input poc_tol_cst,
                           input po_curr,
                           input overage_qty ,
                           buffer pod_det)"
                 &NOAPPERROR=True
                 &CATCHERROR=True
         }

         if return-value <> {&SUCCESS-RESULT} then
            undo, retry.

         /*! If overshipment and a blanket order, give user option of
             updating blanket order's release quantity */
         if pod_blanket <> "" then do for poddet:

            for first poddet
               where poddet.pod_nbr  = pod_det.pod_blanket
                 and poddet.pod_line = pod_det.pod_blnkt_ln no-lock:
            end. /* FOR FIRST PODDET */

            if available poddet and
               poddet.pod_status <> "C" and
               poddet.pod_status <> "X" then do:
               /* Update blanket order release quantity? */
               {mfmsg01.i 389 1 updt_blnkt}

               /* UPDT_BLNKT_LIST IS A COMMA SEPARATED LIST OF ALL POD_LINE     */
               /* NUMBERS WHICH MUST HAVE THE BLANK PO RELEASE QUANTITY UPDATED */
               if updt_blnkt then do:

                  if not can-do(updt_blnkt_list,string(poddet.pod_line))
                  then do:
                     updt_blnkt_list = updt_blnkt_list
                                     + string(poddet.pod_line) + ",".
                  end. /* IF NOT CAN-DO(UPDT_BLNKT_LIST,... */
               end. /* IF UPDT_BLNKT */

              /* W-INT1 = THE POSITION THE LINE NUMBER NEEDING REMOVAL STARTS ON */
              /* W-INT2 = THE POSITION THE COMMA AFTER THE LINE NUMBER IS ON     */
               else do:

                  if can-do(updt_blnkt_list,string(poddet.pod_line))then do:
                     assign
                        w-int1 = index(updt_blnkt_list,string(poddet.pod_line))
                        w-int2 = (index(substring(updt_blnkt_list,w-int1),
                                  ",")) + w-int1 - 1
                        updt_blnkt_list =
                                 substring(updt_blnkt_list,1,w-int1 - 1) +
                                 substring(updt_blnkt_list,w-int2 + 1).
                  end. /* IF CAN-DO(UPDT_BLNKT_LIST,STRING... */
               end. /* IF UPDT_BLNKT = NO */

            end. /* if available poddet */
         end. /* if pod_blanket <> "" */
      end. /* IF (TOTAL_RECEIVED > POD_QTY_ORD AND POD_QTY_ORD > 0) */
   end. /* ELSE DO: */
  /*S777*         07/03/06 *
   undotran = not undotran.  */
   leave.
end. /* DO ON ERROR UNDO, RETRY: */
