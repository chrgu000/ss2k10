/* GUI CONVERTED from gppiqty1.p (converter v1.69) Wed Jul 17 15:46:52 1996 */
/* gppiqty1.p - QTY ACCUMULATION WORKFILES INITIALIZATION AND PREPAREATION  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/*V8:ConvertMode=Maintenance                                                */
/* REVISION: 8.5      LAST MODIFIED: 02/09/95   BY: tjm *J042*              */
/* REVISION: 8.5      LAST MODIFIED: 04/05/96   BY: DAH *J0H8*              */
/* REVISION: 8.5      LAST MODIFIED: 04/26/96   BY: DAH *J0KJ*              */
/* REVISION: 8.5      LAST MODIFIED: 07/09/96   BY: DAH *J0XR*              */
/* REVISION: 8.5      LAST MODIFIED: 07/15/96   BY: ajw *J0Z6*              */
/* REVISION: 8.5      LAST MODIFIED: 11/17/03    BY: *LB01* Long Bo         */

/* This subroutine is called once per sales order whether it is created     */
/* first time or even if the sales order has been called in the maintenance */
/* mode. This subroutine basically clears the workfiles when a different    */
/* sales order has been entered and prepares them with data from the sod_det*/
/* file.                                                                    */


/********** INPUT PARAMETERS

1. doc_type - if 1 then it is for Sales Order
              if 2 then it is for Quotes

2. doc_nbr  - Document number i.e. either Sales Order number or Quote number.

3. incl_ret - Include returns. Yes if this routine is called from Sales Order
              Maintenance or Repricing without Combining Orders.
              No, if this routine is called from Repricing with Combined
              Orders.

4. init_wkfl - Initialize workfiles. Yes, whenever it is called for new
               document. No, when this routine is called from Repricing.

                                                                **************/

/*J0H8**     For all calls to gppiqty2.p replace the last parameter with
             init_wkfl. This will allow gppiqty2.p to maintain the wrep_wkfl.*/

         {mfdeclre.i}

         define input parameter doc_type  as character format "x(1)".
         define input parameter doc_nbr   like so_nbr.
         define input parameter incl_ret  like mfc_logical.
         define input parameter init_wkfl like mfc_logical.

         define variable ext_list like sod_list_pr.
         define variable conv as integer.
         define variable vsodqtyord like sod_qty_ord.

         {pppiwqty.i}    /* Define workfile for item quantities */

         /***** INITIALIZE WORKFILES *****/
         if init_wkfl then do:
            for each wqty_wkfl exclusive-lock:
               delete wqty_wkfl.
            end.

            for each wrep_wkfl exclusive-lock:
               delete wrep_wkfl.
            end.
         end.

         /********  PREPARE WORKFILES  **********/

                if doc_type = "1" then do:

            /* Sales Order */
            for each sod_det where sod_nbr = doc_nbr
/*J0KJ*/                       and sod_fsm_type <> "RMA-RCT" no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


               /* Do not include returns when combining S.O. */
               if sod_qty_ord < 0 and incl_ret = no  then next.


               /* UPDATE ACCUM QTY WORKFILE. TEST FOR CONFIGURED
               PRODUCT, IF SO, DETERMINE LIST PRICE USED IN EXTENSION
               FROM pih_hist LIST PRICE RECORD */

               if can-find(first sob_det where sob_nbr  = sod_nbr
                                           and sob_line = sod_line) then do:
                  find first pih_hist where pih_doc_type = 1     and
                                            pih_nbr       = sod_nbr  and
                                            pih_line      = sod_line and
                                            pih_parent    = ""       and
                                            pih_feature   = ""       and
                                            pih_option    = ""       and
                                            pih_amt_type  = "1"
                                no-lock no-error.
                  if available pih_hist then
                     ext_list = pih_amt * sod_qty_ord.
                  else do:
                     ext_list = 0.
                     for each sob_det where sob_nbr  = sod_nbr
                                        and sob_line = sod_line
                                  no-lock:
                        ext_list = ext_list + sob_tot_std.
                     end.
                     ext_list = (sod_list_pr - ext_list) * sod_qty_ord.
                  end.
               end.
               else
                  ext_list = sod_list_pr * sod_qty_ord.

/*LB01*/          {gprun.i ""zzgppiqty2.p"" "(sod_line,
                                         sod_part,
                                         sod_qty_ord,
                                         ext_list,
                                         sod_um,
                                         yes,
/*J0Z6*/                                 init_wkfl,
/*J0Z6*/                                 no
/*J0Z6*/                                 )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J0Z6*                                  init_wkfl)"}            */

               /* Accumulate quantities for configured items */
               for each sob_det where sob_nbr = sod_nbr
                  and sob_line = sod_line
                  and substring(sob_serial,15,1) = "o" no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


/*J0XR*/          /*Qualified the qty (sob_qty_req) and extended list   */
/*J0XR*/          /*(sob_qty_req * sob_tot_std) parameters to divide by */
/*J0XR*/          /*u/m conversion ratio since these include this factor*/
/*J0XR*/          /*already.                                            */
/*LB01*/          {gprun.i ""zzgppiqty2.p"" "(sob_line,
                                            sob_part,
                                            sob_qty_req / sod_um_conv,
                                            sob_qty_req * sob_tot_std
                                                        / sod_um_conv,
                                            sod_um,
                                            no,
/*J0Z6*/                                    init_wkfl,
/*J0Z6*/                                    no
/*J0Z6*/                                    )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J0Z6*                                     init_wkfl)"}              */

               end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* For each sob_det   */
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
    /* For each sod_det   */
         end. /* sales order */
         else if doc_type = "2" then do:

            /* Quotes */
            for each qod_det where qod_nbr = doc_nbr no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


               /* UPDATE ACCUM QTY WORKFILE. TEST FOR CONFIGURED
               PRODUCT, IF SO, DETERMINE LIST PRICE USED IN EXTENSION
               FROM pih_hist LIST PRICE RECORD */

               if can-find(first sob_det where sob_nbr  = "qod_det" + qod_nbr
                                     and sob_line = qod_line) then do:
                  find first pih_hist where pih_doc_type  = 2        and
                                            pih_nbr       = qod_nbr  and
                                            pih_line      = qod_line and
                                            pih_parent    = ""       and
                                            pih_feature   = ""       and
                                            pih_option    = ""       and
                                            pih_amt_type  = "1"
                                no-lock no-error.
                  if available pih_hist then
                     ext_list = pih_amt * qod_qty_quot.
                  else do:
                     ext_list = 0.
                     for each sob_det where sob_nbr  = "qod_det" + qod_nbr
                                        and sob_line = qod_line
                                  no-lock:
                        ext_list = ext_list + sob_tot_std.
                     end.
                     ext_list = (qod_list_pr - ext_list) * qod_qty_quot.
                  end.
               end.
               else
                  ext_list = qod_list_pr * qod_qty_quot.

/*LB01*/       {gprun.i ""zzgppiqty2.p"" "(qod_line,
                                         qod_part,
                                         qod_qty_quot,
                                         ext_list,
                                         qod_um,
                                         yes,
/*J0Z6*/                                 init_wkfl,
/*J0Z6*/                                 no
/*J0Z6*/                                 )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J0Z6*                                  init_wkfl)"}       */

               /* Accumulate quantities for configured items */
               for each sob_det where sob_nbr = "qod_det" + qod_nbr
                  and sob_line = qod_line
                  and substring(sob_serial,15,1) = "o" no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


/*J0XR*/          /*Qualified the qty (sob_qty_req) and extended list   */
/*J0XR*/          /*(sob_qty_req * sob_tot_std) parameters to divide by */
/*J0XR*/          /*u/m conversion ratio since these include this factor*/
/*J0XR*/          /*already.                                            */
/*LB01*/          {gprun.i ""zzgppiqty2.p"" "(sob_line,
                                            sob_part,
                                            sob_qty_req / qod_um_conv,
                                            sob_qty_req * sob_tot_std
                                                        / qod_um_conv,
                                            qod_um,
                                            no,
/*J0Z6*/                                    init_wkfl,
/*J0Z6*/                                    no
/*J0Z6*/                                    )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J0Z6*                                     init_wkfl)"}          */

               end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* for each sob_det   */
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
    /* for each qod_det   */
         end.  /* Quotes */