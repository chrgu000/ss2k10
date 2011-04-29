         /* INITIALIZE VARIABLES */
         assign
           qty_open = 0
           qty_vph  = 0
           invoiceTaxAmount = 0
           openTaxAmount = 0
           totalTransQty = 0.

         /* Set open quantity to the sum of the                            */
         /* transaction qty on the pending voucher records for the receiver*/
         /* This is being done because for supplier consignment a pending  */
         /* a pending voucher doesn't get created until a usage occurs against*/
         /* the consigned inventory that was received.                     */

         for each tt_pvoddet exclusive-lock where
                  tt_pvoddet.pvod_domain = global_domain:
            delete tt_pvoddet.
         end.
         /* Process all vouchers which are linked to the receiver
          * before the as of date */
         for each pvo_mstr
            where pvo_domain            = global_domain
            and   pvo_order_type        = {&TYPE_PO}
            and   pvo_order             = prh_nbr
            and   pvo_internal_ref_type = {&TYPE_POReceiver}
            and   pvo_internal_ref      = prh_receiver
            and   pvo_line              = prh_line
            and   pvo_eff_date         <= effdate
            and   pvo_lc_charge         = ""
         no-lock:

            if pvo_consignment
            then do:

               for first pod_det
                  fields (pod_domain pod_line pod_nbr pod_site)
                  where pod_det.pod_domain = global_domain
                  and   pod_nbr            = pvo_order
                  and   pod_line           = pvo_line
               no-lock:

               end. /* FOR FIRST pod_det */

               if available pod_det
               then
                  for first si_mstr
                     fields (si_domain si_db si_site)
                     where si_mstr.si_domain = global_domain
                     and   si_site           = pod_site
                  no-lock:

                  end. /* FOR FIRST si_mstr */

               if available si_mstr
                  and si_db = global_db
               then do:

                   for each cnsu_mstr no-lock
                      where cnsu_domain     = prh_domain
                      and   cnsu_po_nbr     = prh_nbr
                      and   cnsu_pod_line   = prh_line
                      and   cnsu_part       = prh_part
                      and   cnsu_site       = prh_site
                      and   cnsu_eff_date  <= effdate
                      use-index cnsu_order,
                      each cnsud_det no-lock
                         where cnsud_domain    = cnsu_domain
                         and   cnsud_cnsu_pkey = cnsu_pkey
                         and   cnsud_receiver  = prh_receiver
                      break by cnsu_po_nbr
                            by cnsu_pod_line
                            by cnsud_receiver
                            by cnsu_part:

                      accumulate cnsud_qty_used (total by cnsu_part).
                      qty_open = (accum total cnsud_qty_used).

                   end. /* FOR EACH cnsu_mstr */

               end. /* IF si_db = global_db */

               else do:

                  l_old_db = global_db.

                  {gprun.i ""gpmdas.p"" "(si_db, output err-flag)" }

                  if err-flag <> 0
                  then do:

                  /* DOMAIN # IS NOT AVAILABLE */
                  {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4 &MSGARG1=si_db}
                   undo, leave.

                  end. /* IF err-flag <> 0 */

                  {gprun.i ""poporp12.p""
                           "(input prh_nbr,
                             input prh_line,
                             input prh_part,
                             input prh_site,
                             input effdate,
                             input prh_receiver,
                             output qty_open)"}

                  if l_old_db <> global_db
                  then do:

                     /* SWITCH BACK TO THE ORIGINAL DOMAIN  */
                     {gprun.i ""gpmdas.p""
                              "(input  l_old_db,
                                output err-flag)"}

                     if err-flag <> 0
                     then do:

                        /* DOMAIN # IS NOT AVAILABLE */
                        {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4 &MSGARG1=si_db}
                        undo , leave.

                     end. /* IF err-flag <> 0 */

                  end.  /* IF l_old_db <> global_db */

               end. /* ELSE DO */

               qty_open = qty_open / prh_um_conv.

            end. /* IF pvo_consignment */

            else

               /* SET OPEN QTY  */
               qty_open = qty_open + pvo_trans_qty.

            for each pvod_det no-lock where
                     pvod_domain = global_domain
                 and pvod_id = pvo_id:

               {gpextget.i &OWNER     = 'ADG'
                           &TABLENAME = 'pvod_det'
                           &REFERENCE = '10074a'
                           &KEY1      = pvod_domain
                           &KEY2      = string(pvod_id)
                           &KEY3      = string(pvod_id_line)
                           &DEC1      = l_pvod_trans_qty
                           &DATE2     = l_pvod_eff_date}

               if l_pvod_eff_date > effdate then next.
               qty_vph = 0.

               for each vph_hist where
                        vph_domain       = global_domain and
                        vph_pvo_id       = pvod_id       and
                        vph_pvod_id_line = pvod_id_line  and
                        vph_inv_date    <= effdate
               no-lock:

                  /* Skip the unconfirmed vouchers */
                  if excl_unconfirmed then do:
                     for first vo_mstr no-lock where
                               vo_domain = global_domain
                           and vo_ref = vph_ref:
                     end.
                     if available vo_mstr and vo_confirmed = false then
                     next.
                  end.

                  /* Determine vouchered taxes by getting tax type 22 records*/
                  /* corresponding to the vph_hist records                   */
                  for each tx2d_det
                     where tx2d_domain = global_domain
                     and   tx2d_ref = vph_ref
                     and   tx2d_nbr = prh_receiver
                     and   tx2d_line = prh_line
                     and   tx2d_tr_type = "22"
                     and not tx2d_tax_in
                     and   tx2d_rcpt_tax_point = yes
                  no-lock:
                     invoiceTaxAmount = invoiceTaxAmount + tx2d_cur_tax_amt.
                  end.

                  /* SET VOUCHERED QUANTITY */
                  qty_vph = qty_vph + vph_inv_qty.

                  /* If this voucher closes the receipt recalculate
                   * vouchered quantity to account for closing the line
                   * when not all items are vouchered
                   * Voucher quantity = receipt quantity -
                   *                    invoice quantity of other vouchers */

                  if pvo_last_voucher = vph_ref
                  then
                     qty_vph = qty_vph + (pvo_trans_qty - pvo_vouchered_qty).

               end. /* for each vph_hist*/

               buffer-copy pvod_det to b_tt_pvod_det.

               b_tt_pvod_det.pvoddet_trans_qty = l_pvod_trans_qty.

               /* GET EXTENDED TABLE RECORDS */
               /* THIS CODE CAN BE REMOVED ONCE THE FIELDS ARE ADDED IN eB3*/
               {poporpcn.i}

               if b_tt_pvod_det.pvoddet_trans_qty - qty_vph <= 0 and
                  prh_rcvd > 0
               then do:
                  delete b_tt_pvod_det.
                  next.
               end.
               else
                  if b_tt_pvod_det.pvoddet_trans_qty - qty_vph >= 0 and
                     prh_rcvd < 0
                  then do:
                     delete b_tt_pvod_det.
                     next.
                  end.

               assign
                  b_tt_pvod_det.pvoddet_id = pvod_det.pvod_id
                  b_tt_pvod_det.pvoddet_id_line = pvod_det.pvod_id_line
                  b_tt_pvod_det.pvoddet_open_qty =
                       b_tt_pvod_det.pvoddet_trans_qty - qty_vph
                  totalTransQty = totalTransQty
                                + b_tt_pvod_det.pvoddet_trans_qty
                                - qty_vph.
            end. /* FOR EACH pvod_det */
         end. /* for each pvo_mstr */

         qty_open = (qty_open / prh_um_conv) - (qty_vph / prh_um_conv).

         /* NEGATIVE PO RECEIPTS SHOULD DISPLAY A NEGATIVE OPEN QTY. */
         /* POSITIVE RECEIPTS WHOSE QTY OPEN IS LESS THAN OR EQUAL   */
         /* TO ZERO SHOULD NOT DISPLAY.                              */
         if (prh_rcvd        >  0
             and qty_open    <= 0)
            or (prh_rcvd     <  0
                and qty_open >= 0)
         then
            next.


         run getSupplierDefaults.
         run getReceiptAccounts.

         if not(receiptacc >= acc and receiptacc <= acc1
            and receiptsub >= sub and receiptsub <= sub1
            and receiptcc >= cc   and receiptcc  <= cc1)
         then
            next.

         /* Determine rounding method */
         if (oldcurr <> prh_curr) or (oldcurr = "") then do:

            if prh_curr = gl_base_curr then
               rndmthd = gl_rnd_mthd.
            else do:
               /* GET ROUNDING METHOD FROM CURRENCY MASTER */
               {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                         "(input prh_curr,
                           output rndmthd,
                           output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
                  leave.
               end.
            end.

            oldcurr = prh_curr.

         end.

         /*GET THE TAX AMOUNT IN PENDING VOUCHER CURRENCY*/
         for each tx2d_det
            where tx2d_domain   = global_domain
            and   tx2d_ref      = prh_receiver
            and   tx2d_nbr      = prh_nbr
            and   tx2d_line     = prh_line
            and   (tx2d_tr_type = "21"
            or    (tx2d_tr_type = "25"
            and   prh_rcp_type  = "R"))
            and not tx2d_tax_in
            and   tx2d_rcpt_tax_point = yes
         no-lock:
            openTaxAmount = openTaxAmount + tx2d_cur_tax_amt.
         end.

         /* Display header */
/* SS - 100715.1 - B 
         do with frame bhead:

            setFrameLabels(frame bhead:handle).

            if (prh_nbr <> last_nbr or prh_vend <> last_vend)
               and not l-summary
               and can-find( first tt_pvoddet where
                            tt_pvoddet.pvod_domain = global_domain
                        and pvoddet_open_qty <> 0)
            then do:
               put skip(1).
               display
                  prh_nbr  column-label "Order"
                  prh_vend
                  descname no-label
               with frame bhead no-box width 132.
               put skip(1).
            end.

            assign
               last_nbr = prh_nbr
               last_vend = prh_vend.

            if page-size - line-counter < 0
               and not l-summary
               and can-find(tt_pvoddet where
                            tt_pvoddet.pvod_domain = global_domain
                        and pvoddet_open_qty <> 0)
            then do:

               page.
               put skip(1).

               display
                  prh_nbr  column-label "Order"
                  prh_vend
                  descname +
                     " *** " + getTermLabelRt("CONTINUE", 4) + " *** "
                     format "x(64)" @ descname no-label
               with frame bhead no-box width 132.

            end.

         end.  /* do with frame bhead */
   SS - 100715.1 - E */
/* SS - 100715.1 - B */
            assign
               last_nbr = prh_nbr
               last_vend = prh_vend.
/* SS - 100715.1 - E */         

         /* CALCULATE THE ACCRUED TAX */
         totalTaxAccrued = openTaxAmount - invoiceTaxAmount.

         for each tt_pvoddet where
            tt_pvoddet.pvod_domain = global_domain and
            tt_pvoddet.pvoddet_open_qty <> 0
         no-lock:

            /* Calculate standard cost */
            std_cost = pvoddet_pur_std.

         if prh_type = "" then

               std_cost = pvoddet_pur_std - pvoddet_ovh_std.
            if use_tot = yes or prh_type = "S"  then
               std_cost = pvoddet_pur_std.

         base_std_cost = std_cost.

         if base_rpt <> "" and prh_curr <> base_curr then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
                      "(input base_curr,
                        input prh_curr,
                        input pvoddet_ex_rate2,
                        input pvoddet_ex_rate,
                        input std_cost,
                        input false, /* DO NOT ROUND */
                        output std_cost,
                        output mc-error-number)"}
         end.
            /* CONVERT pvod_pur_cost TO TRANSACTION CURR */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
                      "(input  base_curr,
                        input  prh_curr,
                        input  pvoddet_ex_rate2,
                        input  pvoddet_ex_rate,
                        input  pvoddet_pur_cost,
                        input  false,
                        output pvod-trx-cost,
                        output mc-error-number)"}

            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.

         assign
            base_cost = pvod-trx-cost
            disp_curr = "".

         if base_rpt = "" and prh_curr <> base_curr then
            assign
               base_cost = pvoddet_pur_cost
               disp_curr = "Y".

         /* Calculate extended GL cost */
         assign
            qty_open = pvoddet_open_qty * prh_um_conv
            std_ext = base_std_cost * qty_open.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output std_ext,
                     input gl_rnd_mthd,
                     output mc-error-number)"}

         if base_rpt <> "" and prh_curr <> base_curr then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
                      "(input base_curr,
                        input prh_curr,
                        input pvoddet_ex_rate2,
                        input pvoddet_ex_rate,
                        input std_ext,
                        input true, /* DO ROUND */
                        output std_ext,
                        output mc-error-number)"}

            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end.

         /* Calculate extended PO cost */
         pur_ext = pvod-trx-cost * qty_open.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output pur_ext,
                     input rndmthd,
                     output mc-error-number)"}

         if base_rpt = "" and prh_curr <> base_curr then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
                      "(input prh_curr,
                        input base_curr,
                        input pvoddet_ex_rate,
                        input pvoddet_ex_rate2,
                        input pur_ext,
                        input true, /* DO ROUND */
                        output pur_ext,
                        output mc-error-number)"}

            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end.

         /* Calculate the accrued tax */
         tax_accrued = totalTaxAccrued * qty_open / totalTransQty.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output tax_accrued,
                     input rndmthd,
                     output mc-error-number)"}

         if base_rpt = "" and prh_curr <> base_curr then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
                      "(input prh_curr,
                        input base_curr,
                        input pvoddet_ex_rate,
                        input pvoddet_ex_rate2,
                        input tax_accrued,
                        input true, /* DO ROUND */
                        output tax_accrued,
                        output mc-error-number)"}

            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end.

         /* Calculate PO-GL variance */
         std_var = pur_ext - std_ext.

         if prh_type <> "" and prh_type <> "S" then
            assign
               std_cost = 0
               std_ext  = 0
               std_var  = 0.

         accumulate std_ext (total).
         accumulate pur_ext (total).
         accumulate std_var (total).
         accumulate tax_accrued (total).

         /* Display receiver details */
/* SS - 100715.1 - B 
         if not l-summary then do with frame b:

            setFrameLabels(frame b:handle).

            display
               prh_receiver       format "x(12)"
               prh_line           column-label "Pur"
               prh_part
               prh_rcp_date       column-label "Rcpt Dt"
               qty_open           column-label "Qty Open"
                                  format "->>>>>>9.9<<<<<<"
               prh_rcp_type
               std_cost           when (base_rpt <> "")
                                  column-label "GL Cost"
               base_std_cost      when (base_rpt = "" ) @ std_cost
                                  column-label "GL Cost"
               disp_curr          column-label "C"
               base_cost          column-label "Purchase Cost"
               std_ext            column-label "Ext GL Cost"
               pur_ext            column-label "Ext PO Cost!Accrued Tax"
               std_var            column-label "PO-GL Var"
            with frame b.

            down 1 with frame b.

            display
               tax_accrued         @ pur_ext
            with frame b.
            down 1 with frame b.
         end.
   SS - 100715.1 - E */
/* SS - 100715.1 - B */
        find first temp1 
            where t1_nbr  = prh_nbr
            and   t1_line = prh_line 
            and   t1_lot  = prh_receiver 
            and   t1_date = prh_rcp_date 
        no-error .
        if not avail temp1 then do:
            create temp1.
            assign t1_nbr  = prh_nbr        
                   t1_line = prh_line       
                   t1_lot  = prh_receiver   
                   t1_date = prh_rcp_date   
                   t1_part = prh_part
                   t1_price = base_cost
                   .
        end.
        t1_qty = t1_qty + qty_open .
        t1_amt = t1_amt + pur_ext  .


/* SS - 100715.1 - E */

         /* Update totals */
         for first tt_summary
            where tt_acc = receiptacc and
                  tt_sub = receiptsub and
                  tt_cc  = receiptcc
         exclusive-lock: end.

         if not available tt_summary then do:
            create tt_summary.
            assign
               tt_acc = receiptacc
               tt_sub = receiptsub
               tt_cc  = receiptcc.
         end.

         assign tt_pur_ext = tt_pur_ext + pur_ext + tax_accrued.

         end. /* FOR EACH tt_pvoddet... */
      end. /*for each prh_hist*/

/* SS - 100715.1 - B 
      if page-size - line-counter < 4 then do:
         page.
         put skip(1).
      end.
   SS - 100715.1 - E */

      rep_tot_with_tax = (accum total pur_ext) + (accum total tax_accrued).

      /* Display summary */
/* SS - 100715.1 - B 
      if not l-summary then
         display
            "--------------- --------------- ------------" to 131
            (if base_rpt = "" then GetTermLabelRtColon("BASE_REPORT_TOTAL", 18)
             else base_rpt + " " + GetTermLabelRtColon("REPORT_TOTAL", 13))
            format "x(18)"   to 84
            accum total std_ext format "->>>>>>>>>>9.99<<<<"  to 102
            accum total pur_ext format "->>>>>>>>>>9.99<<<<"  to 118
            accum total std_var format "->>>>>>>9.99<<<<"  to 131
            (if base_rpt = ""
             then
                GetTermLabelRtColon("BASE_REPORT_TOTAL_WITH_TAX", 27)
             else
                base_rpt +
                " "      +
                GetTermLabelRtColon("REPORT_TOTAL_WITH_TAX", 22))
             format "x(27)"   to 84
             rep_tot_with_tax format "->>>>>>>>>>9.99<<<<"  to 118
             "=============== =============== ============" to 131
         with frame g width 132 no-labels no-box.

      if page-size - line-counter < 6 then page.

      put skip(1).

      display
         getTermLabel("SUMMARY", 15) format "x(15)"
         skip
         "---------------"
         skip.

      put skip (1).

      for each tt_summary use-index tt_acc_cc
      with frame b1 down width 132 no-box:

         setFrameLabels(frame b1:handle).

         display
            tt_acc
            tt_sub
            tt_cc
            tt_pur_ext (total) column-label "Unvouchered Amount".
      end.
   SS - 100715.1 - E */

   end.  /* do on endkey */

/* SS - 100715.1 - B 
   {mfrtrail.i}

   hide message no-pause.
   {pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
   SS - 100715.1 - E */
/* SS - 100715.1 - B */
leave .
/* SS - 100715.1 - E */
end.

{wbrp04.i &frame-spec = a}

PROCEDURE ip-quoter:

   {mfquoter.i vendor    }
   {mfquoter.i vendor1   }
   {mfquoter.i part      }
   {mfquoter.i part1     }
   {mfquoter.i site      }
   {mfquoter.i site1     }
   {mfquoter.i acc       }
   {mfquoter.i acc1      }
   {mfquoter.i sub       }
   {mfquoter.i sub1      }
   {mfquoter.i cc        }
   {mfquoter.i cc1       }
   {mfquoter.i effdate   }
   {mfquoter.i rcpt_from }
   {mfquoter.i sel_inv   }
   {mfquoter.i sel_sub   }
   {mfquoter.i sel_mem   }
   {mfquoter.i excl_unconfirmed}
   {mfquoter.i use_tot   }
   {mfquoter.i base_rpt  }
   {mfquoter.i l-summary }

END PROCEDURE.


PROCEDURE getSupplierDefaults:

   /* Determine the PO Receipts and the Expensed Items Receipts Account
    * of the supplier */

   vendor_type = "".

   for first vd_mstr
      where vd_domain = global_domain
      and   vd_addr   = prh_hist.prh_vend
   no-lock:

      assign
         descname    = vd_sort
         vendor_type = vd_type.

      for first acdf_mstr
         where acdf_domain = global_domain
         and   acdf_module = "VD"
         {&POPORP11-P-TAG1}
         and   acdf_type   = "VD_RCPT_ACC"
         {&POPORP11-P-TAG2}
         and   acdf_key1   = vd_addr
      no-lock:
         assign
            rcptacct  = acdf_acct
            rcptsub   = acdf_sub
            rcptcc    = acdf_cc.
      end.

      for first acdf_mstr
         where acdf_domain = global_domain
         and   acdf_module = "VD"
         {&POPORP11-P-TAG1}
         and   acdf_type = "VD_RCPTX_ACC"
         {&POPORP11-P-TAG3}
         and   acdf_key1 = vd_addr
      no-lock:
         assign
            rcptxacct  = acdf_acct
            rcptxsub   = acdf_sub
            rcptxcc    = acdf_cc.
      end.

   end.

END PROCEDURE.

PROCEDURE getReceiptAccounts:

   if prh_hist.prh_type <> "M" then
      assign
         receiptacc = rcptacct
         receiptsub = rcptsub
         receiptcc  = rcptcc.
   else
      assign
         receiptacc = rcptxacct
         receiptsub = rcptxsub
         receiptcc  = rcptxcc.

   if receiptacc = ""
      and receiptsub = ""
      and receiptcc = ""
   then do:

      if prh_type <> "M" then do:
         for first pt_mstr
            where pt_domain = global_domain
            and   pt_part = prh_part
         no-lock,
         first pl_mstr
            where pl_domain = global_domain
            and   pl_prod_line = pt_prod_line
         no-lock:
            {gprun.i ""glactdft.p""
                     "(input ""PO_RCPT_ACCT"",
                       input if available pt_mstr then pt_prod_line
                             else """",
                       input prh_site,
                       input vendor_type,
                       input """",
                       input yes,
                       output receiptacc,
                       output receiptsub,
                       output receiptcc)"}
         end.
      end.
   end.

   if receiptacc = ""
      and receiptsub = ""
      and receiptcc = ""
   then
      assign
         receiptacc  = gl_ctrl.gl_rcptx_acct
         receiptsub  = gl_ctrl.gl_rcptx_sub
         receiptcc   = gl_ctrl.gl_rcptx_cc.

END PROCEDURE.
