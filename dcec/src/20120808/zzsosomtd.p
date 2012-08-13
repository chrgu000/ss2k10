/* GUI CONVERTED from sosomtd.p (converter v1.69) Wed Sep 10 15:19:36 1997 */
/* sosomtd.p  - SALES ORDER MAINTENANCE - Delete Block                  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 04/27/90   BY: MLB *D021*          */
/* REVISION: 6.0      LAST MODIFIED: 08/30/90   BY: EMB *D040*          */
/* REVISION: 6.0      LAST MODIFIED: 11/13/91   BY: WUG *D887*          */
/* REVISION: 7.0      LAST MODIFIED: 09/19/91   BY: afs *F040*          */
/* REVISION: 7.0      LAST MODIFIED: 04/15/92   BY: afs *F398*          */
/* REVISION: 7.0      LAST MODIFIED: 06/04/92   BY: tjs *F504*          */
/* REVISION: 7.0      LAST MODIFIED: 07/24/92   BY: tjs *F802*          */
/* REVISION: 7.0      LAST MODIFIED: 08/20/92   BY: afs *F862*          */
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247*          */
/* REVISION: 7.3      LAST MODIFIED: 02/04/93   BY: bcm *G415*          */
/* REVISION: 7.3      LAST MODIFIED: 02/24/93   BY: sas *G457*          */
/* REVISION: 7.3      LAST MODIFIED: 04/20/93   BY: tjs *G948*          */
/* REVISION: 7.3      LAST MODIFIED: 04/20/93   BY: afs *G970*          */
/* REVISION: 7.3      LAST MODIFIED: 03/28/94   BY: WUG *GJ21*          */
/* REVISION: 7.4      LAST MODIFIED: 05/05/94   BY: afs *FN92*          */
/* REVISION: 7.4      LAST MODIFIED: 09/15/94   BY: dpm *FR43*          */
/* REVISION: 7.4      LAST MODIFIED: 11/01/94   BY: ame *GN90*          */
/* REVISION: 8.5      LAST MODIFIED: 11/29/94   BY: mwd *J034*          */
/* REVISION: 7.4      LAST MODIFIED: 01/28/95   BY: ljm *G0D7*          */
/* REVISION: 7.4      LAST MODIFIED: 02/24/95   BY: smp *F0H4*          */
/* REVISION: 8.5      LAST MODIFIED: 02/27/95   BY: dpm *J044*          */
/* REVISION: 8.5      LAST MODIFIED: 03/05/95   BY: DAH *J042*          */
/* REVISION: 7.4      LAST MODIFIED: 03/20/95   BY: smp *F0ND*          */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: bcm *H0CB*          */
/* REVISION: 7.4      LAST MODIFIED: 05/30/95   BY: tvo *H0BJ*          */
/* REVISION: 7.4      LAST MODIFIED: 09/20/95   BY: ais *G0XN*          */
/* REVISION: 7.4      LAST MODIFIED: 10/05/95   BY: ais *G0YK*          */
/* REVISION: 8.5      LAST MODIFIED: 03/22/96   BY: vrn *G1R5*                */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: *J04C* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: *J04C* Markus Barone */
/* REVISION: 8.5      LAST MODIFIED: 10/14/96   BY: *H0N7* Sue Poland    */
/* REVISION: 8.5      LAST MODIFIED: 10/29/96   BY: *G2H6* Suresh Nayak  */
/* REVISION: 8.5      LAST MODIFIED: 06/05/97   BY: *J1RY* Tim Hinds     */
/* REVISION: 8.5      LAST MODIFIED: 11/14/03   BY: *LB01* Long Bo         */

         {mfdeclre.i}


         define shared variable line like sod_line.
         define shared variable del-yn like mfc_logical.
         define shared variable prev_due like sod_due_date.
         define shared variable prev_qty_ord like sod_qty_ord.
         define shared variable prev_abnormal like sod_abnormal.
         define shared variable prev_consume like sod_consume.
         define shared variable so_recno as recid.
         define shared variable qty_req like in_qty_req.
         define shared variable merror like mfc_logical initial no.
         define shared variable trnbr like tr_trnbr.
         define shared variable eff_date as date.
/*G247** define shared variable mfguser as character. **/
         define shared variable qty as decimal.
         define variable i as integer.
         define shared variable sod_recno as recid.
         define shared variable part as character format "x(18)".
/*G970*/ define  new shared  variable prev_site like sod_site.
         define variable week as integer.
/*F040*/ define variable so_db like si_db.
/*F040*/ define variable err_flag as integer.
/*F040*/ define new shared variable sonbr like sod_nbr.
/*F040*/ define new shared variable soline like sod_line.
/*F862*/ define new shared variable prev_type like sod_type.
/*G415*/ define variable tax_nbr like tx2d_nbr initial "".
/*G415*/ define variable tax_tr_type like tx2d_tr_type initial "11".
/*G948*/ define new shared variable delete_line like mfc_logical.
/*FN92*/ define            variable qty_all     like in_qty_all.

/*J04C*/ define buffer seoc_buf for seoc_ctrl.
/*J04C*/ define buffer rmdbuff  for rmd_det.

/*G2H6*/ define variable shipper_found as integer no-undo.
/*G2H6*/ define variable save_abs like abs_par_id no-undo.

/*J1RY*/ define shared variable cfexists like mfc_logical.
/*J1RY*/ define shared workfile cf_sod_rm
/*J1RY*/    field cf_ccq_name as character.

         find first soc_ctrl no-lock.
         find so_mstr where recid(so_mstr) = so_recno.
/*F040*/ so_db = global_db.
         line = 0.

/*H0BJ*/ if so_fsm_type = 'RMA'
/*H0BJ*/ then assign tax_tr_type = '36'.

         for each sod_det where sod_nbr = so_mstr.so_nbr:
/*GUI*/ if global-beam-me-up then undo, leave.


            line = line + 1.
            assign
/*F862*/          prev_type = sod_type
                  prev_due      = sod_due_date
                  prev_qty_ord  = sod_qty_ord * sod_um_conv
                  prev_abnormal = sod_abnormal
                  prev_consume  = sod_consume
                  prev_site     = sod_site .

            if sod_qty_inv <> 0 then do:
/*J04C*/       if so_fsm_type = "SEO" then do:
/*J04C*/            {mfmsg.i 986 3}
                    /* CANNOT DELETE PARTIALLY PROCESSED SERVICE ENGINEER ORDER */
/*J04C*/       end.
/*J04C*/       else do:
                    {mfmsg.i 604 3}
                    /* Outstanding qty to invoice, delete not allowed. */
/*J04C*/       end.
               merror = yes.
               return. /*undo order-header.*/
            end.   /* if sod_qty_inv <> 0 */

/*J04C*/    if sod_fsm_type = "SEO" and
/*J04C*/       sod_qty_ship - sod_qty_cons
/*J04C*/                 - sod_qty_ret <> 0 then do:
/*J04C*/        {mfmsg.i 7307 3}
                /* OUTSTANDING QTY TO BE CONSUMED OR RETURNED */
/*J04C*/        merror = yes.
/*J04C*/        return. /*undo order-header.*/
/*J04C*/    end.

/*G2H6*/         shipper_found = 0.
/*G2H6*/         {gprun.i ""rcsddelb.p"" "(input sod_nbr, input sod_line,
                 input sod_site, output shipper_found, output save_abs)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G2H6*/         if shipper_found > 0 then do:
/*G2H6*/            {mfmsg03.i 1118 3 shipper_found save_abs """"}
/*G2H6*/            /* # Shippers/Containers exists for order, including # */
/*G2H6*/             merror = yes.
/*G2H6*/             return. /* undo order-header */
/*G2H6*/         end.

            /*!**************************************************
               Call GPSIVER.P to validate sod_site.
            *****************************************************/
/*J034*/    {gprun.i ""gpsiver.p"" "(input sod_site,
                                     input ?,
                                     output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/    if return_int = 0 then do:
/*J034*/       {mfmsg.i 2709 4} /* DELETE NOT ALLOWED; USER DOES NOT */
/*J034*/                        /* HAVE ACCESS TO DETAIL SITE(S)     */
/*J034*/       merror = yes.
/*J034*/       return.  /* undo order header */
/*J034*/    end.

/*F802*/    if sod_sched and
/*F802*/       (can-find(first sch_mstr where sch_type = 1
/*F802*/       and sch_nbr = sod_nbr and sch_line = sod_line) or
/*F802*/       can-find(first sch_mstr where sch_type = 2
/*F802*/       and sch_nbr = sod_nbr and sch_line = sod_line) or
/*F802*/       can-find(first sch_mstr where sch_type = 3
/*F802*/    and sch_nbr = sod_nbr and sch_line = sod_line)) then do:
/*F802*/       {mfmsg.i 6022 3} /* Schedule exists, delete not allowed */
/*F802*/       merror = yes.
/*F802*/       return.
/*F802*/    end.

/*F504*     if so_conf_date <> ? then do: */
/*F504*/    if sod_confirm then do:

/*F0H4*        TO FIX PROBLEMS WITH ALLOCATION UPDATES, RMA ALLOCATIONS AND
 *             SHIPPING OVERAGES, TELL MFSOTR.I HOW MUCH TO MODIFY ALLOCATIONS
 *             BY INSTEAD OF LETTING IT DECIDE FOR ITSELF.         */
/*F0ND* *F0H4* assign qty_all = - (sod_qty_all).  */
/*G0YK* *F0ND* assign qty_all = - (sod_qty_all + sod_qty_pick).  */
/*G0YK*/       assign qty_all = - (sod_qty_all + sod_qty_pick) * sod_um_conv.
               /*!***********************************************
                   Use MFSOTR.I (with DELETE option) to reverse
                   inventory transaction history records.
               **************************************************/
               {mfsotr.i "DELETE"}

               sod_recno = recid(sod_det).

               /* BACK OUT QTYS FORECASTED FOR ALL EXCEPT RMA RECEIPT LINES */
/*H0N7*/       if sod_rma_type <> "I" then do:
                   /* FORECAST RECORD */
/*G0XN*/           /* CHANGED '- sod_qty_ord' to                                */
                   /* '- (sod_qty_ord - (sod_qty_ship - sod_qty_inv)'           */
                   /* TO TAKE PREVIOUS SHIPMENTS INTO ACCOUNT                   */
                   {mfsofc01.i
                       &part=sod_part
                       &site=sod_site
                       &date=sod_due_date
                       &quantity="- (sod_qty_ord - (sod_qty_ship - sod_qty_inv))
                            * sod_um_conv"
                       &consume=sod_consume
                       &type=sod_type}

                   {mfsofc02.i
                       &nbr=sod_nbr
                       &line=string(sod_line)
                       &consume=sod_consume}
/*H0N7*/       end.

               {mfmrw.i "sod_det" sod_part sod_nbr string(sod_line) """"
                        ? sod_due_date "0" "DEMAND" "客户订单" sod_site}

          /*!*******************************************************
               Use SOLNEDL.P (surrounded by GPALIAS3.P calls) to
               delete line information that might exist in other
               databases.
          **********************************************************/
/*F398*/       find si_mstr where si_site = sod_site no-lock.
               if si_db <> so_db then do:
                  {gprun.i ""gpalias3.p"" "(si_db, output err_flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

                  assign
                        sonbr  = so_nbr
                        soline = sod_line .
                  {gprun.i ""solndel.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

                  /* Reset the db alias to the sales order database */
                  {gprun.i ""gpalias3.p"" "(so_db, output err_flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

               end.

            end.

            /* DELETE LINE ITEM COMMENTS */
/*GN90*     for each cmt_det where cmt_indx = sod_cmtindx:*/
/*GN90*/    for each cmt_det exclusive-lock where cmt_indx = sod_cmtindx:
               delete cmt_det.
            end.

            /* DELETE ALLOCATION DETAIL*/
/*GN90*     for each lad_det where lad_dataset = "sod_det"*/
/*GN90*/    for each lad_det exclusive-lock where lad_dataset = "sod_det"
                      and lad_nbr     = sod_nbr
                      and lad_line    = string(sod_line):
               find ld_det where ld_site = lad_site
                    and ld_loc  = lad_loc
                    and ld_lot  = lad_lot
/*D887*/            and ld_ref  = lad_ref
                    and ld_part = lad_part.
               ld_qty_all = ld_qty_all - (lad_qty_all + lad_qty_pick).
               delete lad_det.
            end.

            /*!********************************************
               Call SOSOMTK.P to delete any Sales Order
               Bill (sob_det) records.
            **********************************************/
            sod_recno = recid(sod_det).
            if can-find (first sob_det where sob_nbr  = sod_nbr
                                and sob_line = sod_line)
            then do:

/*G948*/       delete_line = yes.
/*LB01*/       {gprun.i ""zzsosomtk.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.

            /*!***************************************************
                Use MFMRW.I to update the MRP Workfile
            *****************************************************/
            {mfmrw.i "sod_fas" sod_part sod_nbr string(sod_line) """"
                     ? sod_due_date 0 "SUPPLYF" "计划总装加工单" sod_site}

/*J04C*     SOD_SV_CODE HAS BEEN MOVED FROM QAD_WKFL TO SOD_DET...
./*G457*/    find qad_wkfl
./*G457*/       where qad_key1  = "sod_sv_code"
./*G457*/       and   qad_key2  = sod_nbr + "+" + string(sod_line)
./*G457*/       no-error.
./*G457*/    if available qad_wkfl then
./*G457*/       delete qad_wkfl.
.*J04C*/
            /*GJ21 ADDED FOLLOWING BLOCK*/
            if sod_sched then do:
               find scx_ref
                  where scx_type = 1
                  and scx_order = sod_nbr
                  and scx_line = sod_line
                  exclusive-lock.

               delete scx_ref.
            end.

/*J044******
 *          /*GJ21 ADDED FOLLOWING BLOCK*/
 *          if sod_sched then do:
 *             find scx_ref where scx_type = 1
 *                and scx_order = sod_nbr
 *                and scx_line = sod_line
 *                exclusive-lock.
 *
 *             delete scx_ref.
 *          end.
 *J044*/

/*J04C*     ADDED THE FOLLOWING */
            /*!****************************************** **********
                Kits  were not included in the initial 8.5 SSM
                release, but, when they're reincorporated into
                8.5, we'll need to reset the kit file for type "K"
                order lines.
                Reset the kit master, making it available for other
                engineers to use/check out.
            *******************************************************/
            if sod_type = "K" then do:
                find fkt_mstr where fkt_serial = sod_serial
                            exclusive-lock no-error.
                if available fkt_mstr
                then assign
                    fkt_in_use   = no
                    fkt_eng_code = "".
            end.
/*J04C*     END ADDED CODE */

/*J1RY*/    if cfexists  and sod__qadc01 <> "" then do:
/*J1RY*/       /*copy the contenets of the field sod__qadc01 into a workfile*/
/*J1RY*/       /*the filenames that this field relates to will be deleted in*/
/*J1RY*/       /*sosomtp.p                                                  */
/*J1RY*/       create cf_sod_rm.
/*J1RY*/       assign cf_ccq_name = sod__qadc01.
/*J1RY*/       if recid(cf_sod_rm) = -1 then.
/*J1RY*/    end.

            delete sod_det.

         end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*G1R5*/ do on endkey undo, leave:
            {mfmsg02.i 24 1 line} /* line item record(s) deleted. */
            hide message.
/*G1R5*/ end.

/*J044*/ /*!************************************************
            Delete all Import/Export records for this S.O.
          **************************************************/
/*J044*/ for each ied_det exclusive-lock where
/*J044*/    ied_type = "1" and ied_nbr = so_nbr  :
/*J044*/    delete ied_det.
/*J044*/ end.

/*J044*/ for each ie_mstr exclusive-lock  where
/*J044*/    ie_type = "1" and ie_nbr = so_nbr  :
/*J044*/    delete ie_mstr.
/*J044*/ end.

         /*!******************************************
               Delete Comments associated with so_mstr
        ********************************************** */

/*GN90*  for each cmt_det where cmt_indx = so_cmtindx:*/
/*GN90*/ for each cmt_det exclusive-lock where cmt_indx = so_cmtindx:
            delete cmt_det.
         end.

         /*! *************************************************
            Call TXDELETE.P to delete tax records for the S.O.
          ****************************************************/
         if {txnew.i} then do:
            {gprun.i ""txdelete.p"" "(input tax_tr_type,
                                      input so_nbr,
                                      input tax_nbr)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.
/*G415*** END****/

/*FR43*/ /*!*****************************************************
           If this SO was created with a temporary ship-to address,
           delete that address.
         *********************************************************/
/*FR43*/ if so_mstr.so_ship = "qadtemp" + mfguser       then do:
/*FR43*/    find ad_mstr where ad_addr = so_mstr.so_ship exclusive-lock.
/*FR43*/    delete ad_mstr.
/*FR43*/ end.

/*J042*/ /*!************************************************
            Call GPPIHDEL.P to delete Price List History
          **************************************************/
/*J042*/ {gprun.i ""gppihdel.p"" "(
                                   1,
                                   so_nbr,
                                   0
                                  )"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J04C*  ADDED THE FOLLOWING */
         /*!******************************************************
            For RMA's, delete the rma_mstr and rmd_det records also.
            If this RMA has been attached to an RTS (Return To
            Supplier), or has been associated with any Calls, clear
            those links also.
         **********************************************************/
         if so_fsm_type = "RMA" then do:
                find rma_mstr where rma_nbr = so_nbr and rma_prefix = "C"
                    exclusive-lock.

               for each rmd_det exclusive-lock
                   where rmd_nbr     = rma_nbr
                   and   rmd_prefix  = "C":

                   /* CLEAR RMA_NBR AND RMA_LINE IN ANY LINKED-TO RTS'S */
                   if rmd_det.rmd_rma_nbr <> " " then
                        for each rmdbuff where rmd_rma_nbr = rmd_det.rmd_rma_nbr
                            exclusive-lock:
                            assign rmdbuff.rmd_rma_nbr = ""
                                   rmdbuff.rmd_rma_line = 0.
                        end.     /* for each rmdbuff */

                   delete rmd_det.
               end.    /* for each rmd_det */

               /* IF A CALL IS ATTACHED TO THE RMA, CLEAR THE CALL'S RMA NUMBER */
               if rma_ca_nbr <> " " then do:
                   find ca_mstr where ca_nbr = rma_ca_nbr and
                       ca_category = "0" exclusive-lock no-error.
                   if available ca_mstr then
                       assign ca_rma_nbr = " ".
               end.    /* if rma_ca_nbr <> " " */

               delete rma_mstr.

         end.   /* if this-is-rma */
/*J04C*  END ADDED CODE */

         delete so_mstr.
/*G0D7   clear frame a. */
/*G0D7   clear frame sold_to. */
/*G0D7   clear frame ship_to. */
/*G0D7   clear frame b. */
         del-yn = no.
