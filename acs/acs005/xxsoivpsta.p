/* xxsoivpsta.p - SALES ORDER HEADER INVOICE POST                            */
/* REVISION: 1.0      LAST MODIFIED: 09/25/10   BY: zy                       */
/*-Revision end--------------------------------------------------------------*/

{mfdeclre.i}
{cxcustom.i "xxSOIVPSTA.P"}
{&SOIVPSTA-P-TAG1}
{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */
{ieconsdf.i}   /* INTRASTAT PRE-PROCESSOR CONSTANTS DEFINITION */

{gldydef.i}
{gldynrm.i}
/* DEFINITION FOR TEMP TABLE  t_tr_hist1 */
{sotrhstb.i}

define input        parameter l_consolidate    as   logical            no-undo.
define input        parameter l_po_schd_nbr    like sod_contr_id       no-undo.
define output       parameter viar_recno       as   recid              no-undo.
define output       parameter vinvtamt         like ar_amt             no-undo.
define input-output parameter l_tot_amt1       like ar_base_amt        no-undo.
define input-output parameter l_tot_ramt1      like ar_base_amt        no-undo.

define new shared variable sonbr               like sod_nbr.
define new shared variable soline              like sod_line.
define new shared variable tax_recno           as   recid.
define new shared variable soinv               like so_inv_nbr.
define new shared variable using_seq_schedules like mfc_logical        no-undo.

define shared variable rndmthd                 like rnd_rnd_mthd.
define shared variable so_recno                as   recid.
define shared variable sod_recno               as   recid.
define shared variable ord_amt                 like sod_price.
define shared variable disc_amt                like sod_price.
define shared variable tax                     like ord_amt extent 3.
define shared variable eff_date                like ar_date.
define shared variable line_total              as   decimal.
define shared variable undo_all                like mfc_logical        no-undo.
define shared variable batch                   like ar_batch.
define shared variable base_amt                like ar_amt.
define shared variable exch_rate               like exr_rate.
define shared variable exch_rate2              like exr_rate.
define shared variable exch_ratetype           like exr_ratetype.
define shared variable exch_exru_seq           like exru_seq.
define shared variable tot_inv_comm            as   decimal format "->>,>>9.99"
                                               extent 4                no-undo.
define shared variable tot_line_comm           as   decimal
                                               format "->>,>>>,>>9.999999"
                                               extent 4.
define shared variable tot_ext_cost            like sod_price.
define shared variable post_entity             like ar_entity.
define shared variable batch_tot               like ord_amt.
define shared variable customer_sched          like mfc_logical.
define shared variable prog_name               as   character          no-undo.

define variable line_amt                       like ord_amt            no-undo.
define variable i                              as   integer            no-undo.
define variable net_price                      like sod_price          no-undo.
define variable so_db                          like si_db              no-undo.
define variable err_flag                       as   integer            no-undo.
define variable cmtindx                        like so_cmtindx         no-undo.
define variable deleterma                      like mfc_logical        no-undo.
define variable prepaid_amt                    like ord_amt            no-undo.
define variable restock-pct                    like rma_rstk_pct       no-undo.
define variable connect_db                     like dc_name            no-undo.
define variable mc-error-number                like msg_nbr            no-undo.
define variable return_status                  as   integer            no-undo.
define variable save_sbinfo                    as   logical            no-undo.
define variable create_tax_trailer_line        as   logical            no-undo.
define variable v_par_id                       like tr_ship_id         no-undo.
define variable account_code                   like ac_code            no-undo.
define variable ord_amt_corr                   like ord_amt            no-undo.
define variable ord_amt_ptax                   like so_prep_tax        no-undo.
define variable ord_amt_prep                   like so_prepaid         no-undo.
define variable l_invnbr                       like so_inv_nbr         no-undo.
define variable use-log-acctg                  as   logical            no-undo.
define variable tax_type                       like tx2d_tr_type       no-undo.
define variable end_of_month                   as   date               no-undo.
define variable auth_price                     like sod_price          no-undo
                                               format "->>>>,>>>,>>9.99".
define variable auth_found                     as   logical            no-undo.

/* CONSIGNMENT VARIABLES */
{socnvars.i}
define variable proc_id                        as   character          no-undo.
define variable l_consigned_line_item          as   logical            no-undo.

/* Logistics orders can be invoiced before shipping. */
define variable ExtInvoicing                   as   logical            no-undo.
{gpfilev.i}

define shared temp-table t_absr_det            no-undo
   field t_absr_id        like absr_id
   field t_absr_reference like absr_reference
   field t_absr_qty       as decimal format "->>>>,>>>,>>9.99"
   field t_absr_ext       as decimal format "->>>>,>>>,>>9.99".

define shared workfile invoice_err             no-undo
   field  inv_nbr  like so_inv_nbr
   field  ord_nbr  like so_nbr
   field  db_name  like dc_name.

define buffer cmtdet for cmt_det.
define buffer soddet for sod_det.

{soexlnxr.i}        /*  LOAD PL INVOICE INCLUDE FILE  */

/* THE TEMP-TABLE WORK_TRNBR STORES THE VALUES OF FIRST AND LAST  */
/* TRANSACTION NUMBER WHICH IS USED WHEN INVOICE IS POSTED VIA    */
/* SHIPPER CONFIRM, FOR ASSIGNING THE TR_RMRKS AND TR_GL_DATE     */
/* FIELDS. PREVIOUSLY, THIS WAS BEING DONE IN RCSOISB1.P PRIOR TO */
/* INVOICE POST.                                                  */
define shared temp-table work_trnbr no-undo
   field work_sod_nbr  like sod_nbr
   field work_sod_line like sod_line
   field work_tr_recid like tr_trnbr
index
   work_sod_nbr
   work_sod_nbr
ascending.

/* CREATE TEMP-TABLE TO STORE SALES ORDER/SHIPPER INFO */
/* WHEN THE INVOICE POST IS POSTING AGAINST MULTIPLE   */
/* SHIPPERS.                                           */
define new shared temp-table so_shipper_info no-undo
   field tt_ship_id like tr_ship_id
   field tt_nbr     like so_nbr
   field tt_line    like sod_line
   field tt_inv_nbr like so_inv_nbr
index
   tt_ship_id
   tt_nbr tt_line
   tt_inv_nbr.

/* DETERMINE IF SEQUENCE SCHEDULES IS INSTALLED */
{gpfile.i &file_name = """"rcf_ctrl""""}
if can-find (mfc_ctrl
    where mfc_ctrl.mfc_domain = global_domain and  mfc_field =
    "enable_sequence_schedules"
     and mfc_logical)
     and file_found
then
   using_seq_schedules = yes.
else
   using_seq_schedules = no.

/* CHECK TO SEE IF CONTAINER/LINE CHARGES ARE ACTIVATED */
{cclc.i}

/* CHECK TO SEE IF CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input  ENABLE_CUSTOMER_CONSIGNMENT,
           input  10,
           input  ADG,
           input  CUST_CONSIGN_CTRL_TABLE,
           output using_cust_consignment)"}

/* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

procesloop:
do transaction on error undo, leave:

   {gprun.i ""gldydft.p""
            "(input  ""SO"",
              input  ""I"",
              input  post_entity,
              output dft-daybook,
              output daybook-desc)"}

   for first soc_ctrl
      fields (soc_domain soc_ar soc_margin)
      where soc_domain = global_domain
   no-lock: end.

   if not available soc_ctrl then do:
      create soc_ctrl.
      soc_domain = global_domain.
   end.
   if recid(soc_ctrl) = -1 then .

   for first so_mstr
      where recid(so_mstr) = so_recno
   no-lock: end.

   /* If for any reason the invoice number is blank then LEAVE.
    * This causes UNDO_ALL to be set TRUE and the SO posting
    * is rolled back. */
   if so_inv_nbr = "" then
      undo procesloop, leave procesloop.

   /* UNLIKE DATA CAPTURE FOR TAXES AND TRAILER, WE UPDATE THE      */
   /* INVOICE# IRRESPECTIVE OF WHETHER THE BILL-TO HAS SELF-BILLING */
   /* TURNED ON OR NOT                                              */
   run p-self-bill-control
      (input so_nbr,
       input so_inv_nbr,
       input so_bill).

   /* IF THE CONTROL FILE EXIST THEN SHOW THAT THE WORK FILE RECORD */
   /* HAS BEEN POSTED.                                              */
   run mark-as-posted
      (input so_nbr,
       input so_inv_nbr).

   /* CREATE AR DISTRIBUTION DETAIL */
   if soc_ar = yes then
      run create-ar-distribution.

   /* UPDATE TRANSACTION HISTORY WITH INVOICE NUMBER */
   /* WHEN so_inv_mthd = "y" THEN rcsois.p UPDATES tr_remarks DIRECTLY */
   /* WHEN POSTING INVOICE.                                            */
   if substring(so_inv_mthd,2,1) <> "y"
      or prog_name = "soivpst.p"
      or prog_name = "socnpst.p"
   then do:

      /* IN CASE OF SINGLE-DB THE tr_hist BELONGING ONLY TO THE CURRENT
       * DB IS TO BE UPDATED. THERE IS NO NEED TO GO THRU sod_det'S THAT
       * CAUSES A PERFORMANCE OVERHEAD */
      if global_db = "" then do:

         {&SOIVPSTA-P-TAG2}

         for each tr_hist
            where tr_domain = global_domain
            and   tr_nbr    = so_nbr
            and   tr_type   = "ISS-SO"
            and   tr_rmks   = ""
            {&SOIVPSTA-P-TAG3}
         use-index tr_nbr_eff
         exclusive-lock:

            assign
               tr_rmks    = so_inv_nbr
               v_par_id   = "s" + tr_ship_id
               tr_gl_date = eff_date.

            if using_cust_consignment then do:
               /* CHECK TO SEE IF LINE IS CONSIGNED. IF SO, THEN DISPLAY */
               /* A WARNING.                                             */
               l_consigned_line_item = no.
               {gprunmo.i &module = "ACN" &program = "socnsod1.p"
                          &param  = """(input  tr_nbr,
                                        input  tr_line,
                                        output l_consigned_line_item,
                                        output consign_loc,
                                        output intrans_loc,
                                        output max_aging_days,
                                        output auto_replenish)"""}

               if l_consigned_line_item then do:
                  {gprunmo.i &module = "ACN" &program = "socncuup.p"
                             &param  = """(input tr_trnbr,
                                           input so_inv_nbr)"""}
               end.
            end.  /* if using_cust_consignment */

            if using_seq_schedules then do:
               create so_shipper_info.
               assign
                  tt_ship_id = v_par_id
                  tt_nbr     = tr_nbr
                  tt_line    = tr_line
                  tt_inv_nbr = so_inv_nbr.

               if recid(so_shipper_info) = -1 then .
            end.
         end. /* for each tr_hist */
      end. /* if global_db */
      else do:

         so_db = global_db.

         for each sod_det
            fields (sod_domain sod_cmtindx sod_fa_nbr sod_fsm_type sod_line
                    sod_lot sod_nbr sod_part sod_price sod_qty_all
                    sod_qty_inv sod_site sod_status sod_sched
                    sod_qty_ord sod_qty_pick sod_qty_ship sod_cum_qty
                    sod_taxable sod_taxc sod_tax_in sod_type sod_um_conv)
            where sod_domain = global_domain
            and   sod_nbr    = so_nbr
         no-lock:

            for first si_mstr
               fields (si_domain si_db si_site)
               where si_domain = global_domain
               and   si_site   = sod_site
            no-lock: end.

            /* CHANGE DATABASES IF USING MULTI-DATABASES TO LOCATE tr_hist */
            if si_db <> so_db then do:
               {gprun.i ""gpalias3.p""
                        "(input  si_db,
                          output err_flag)"}

               {soivconn.i procesloop yes}
            end.

            assign
               sonbr  = so_nbr
               soline = sod_line
               soinv  = so_inv_nbr.

            {gprun.i ""soivpstf.p""}

            /* RESET THE DB ALIAS TO THE ORIGINAL DATABASE */
            if si_db <> so_db then do:
               {gprun.i ""gpalias3.p""
                        "(input  so_db,
                          output err_flag)"}

               {soivconn.i procesloop no}
            end.
         end. /* for each sod_det */
      end. /* else of if global_db = "" */
   end. /* if substr(so_inv_mthd...*/
   else do:

      for each work_trnbr
         where work_sod_nbr = so_nbr
      no-lock
      break by work_sod_nbr
            by work_sod_line:

         if first-of(work_sod_line) then do:
            so_db = global_db.

            for first sod_det
               fields (sod_domain sod_cmtindx sod_fa_nbr sod_fsm_type sod_line
                       sod_cum_qty sod_lot sod_nbr sod_part sod_price
                       sod_qty_all sod_qty_inv sod_qty_ord sod_qty_pick
                       sod_qty_ship sod_sched sod_site sod_status
                       sod_taxable sod_taxc sod_tax_in sod_type sod_um_conv)
               where sod_domain = global_domain
               and   sod_nbr    = work_sod_nbr
               and   sod_line   = work_sod_line
            no-lock: end.

            for first si_mstr
               fields (si_domain si_db si_site)
               where si_domain = global_domain
               and   si_site   = sod_site
            no-lock: end.

            if si_db <> so_db then do:
               {gprun.i ""gpalias3.p""
                        "(input  si_db,
                          output err_flag)"}

               {soivconn.i procesloop yes}
            end.

            {gprun.i ""soivpsti.p""
                     "(input sod_nbr,
                       input sod_line,
                       input so_inv_nbr,
                       input eff_date)"}

            if si_db <> so_db then do:
               {gprun.i ""gpalias3.p""
                        "(input  so_db,
                          output err_flag)"}

               {soivconn.i procesloop no}
            end.
         end. /* if first-of(work_sod_line) */
      end. /* FOR EACH WORK_TRNBR */
   end. /* ELSE OF IF SUBSTR(SO_INV_MTHD,2,1) = Y OR PROG NAME .. */

   /* CALL SEQUENCE SCHEDULE PROGRAM TO STORE THE INVOICE NUMBER */
   /* IF SEQUENCE SCHEDULES IS INSTALLED                         */
   if using_seq_schedules then do:
      for each so_shipper_info exclusive-lock:
         {gprunmo.i &module = "ASQ" &program = ""rcabssiv.p""
                    &param  = """(input tt_ship_id,
                                  input tt_nbr,
                                  input tt_line,
                                  input tt_inv_nbr)"""}

         delete so_shipper_info.
      end.
   end.

   /* Second find for so_mstr with exclusive lock */
   find so_mstr
      where recid(so_mstr) = so_recno exclusive-lock.

   /* If for any reason the invoice number is blank then LEAVE.
    * This causes UNDO_ALL to be set TRUE and the SO posting
    * is rolled back. */
   if so_inv_nbr = "" then
      undo procesloop, leave procesloop.

   /* Save the prepaid amount for invoice history */
   prepaid_amt = so_prepaid.
   /*
   * Only adjust the prepaid amount here when the invoice does
   * not have any credit card details from an external system
   * associated with it. The prepaid amount is adjusted for
   * these orders in the deleteCreditCardDetails procedure.
   */
   if not can-find(first qad_wkfl
      where qad_domain = global_domain
      and   qad_key1 begins string(so_nbr,"x(8)")
      and   qad_key2 = "CreditCard")
   then do:
      if ord_amt >= 0 then
         so_prepaid = max(0, so_prepaid - ord_amt).
      else
         so_prepaid = min(0, so_prepaid - ord_amt).
   end.

   /*******************************************************/
   /*     Check to see if the whole rma is completed and  */
   /*     RMA status is blank.                            */
   /*******************************************************/
   deleterma = no.
   if so_fsm_type = "RMA" then do:
         {gprun.i ""fsivrmac.p""
                  "(input  so_recno,
                    output deleterma)"}
   end.

   if so_fsm_type = "RMA"
      and deleterma
   then do:
      {gprun.i ""fsivrhd.p""
               "(input  so_recno,
                 input  ""RMA"",
                 output restock-pct)"}
   end.
   else
      restock-pct = 0.

   /* Determine if external invoicing is active */
   /* If so, don't delete unless both shipped and invoiced */
   ExtInvoicing = no.
   if so_app_owner > "" then
      /* Check if external invoicing is enabled */
      ExtInvoicing = can-find (first lgs_mstr
          where lgs_domain   = global_domain
          and   lgs_app_id   = so_app_owner
          and   lgs_invc_imp = yes no-lock).

   if so_sched       = yes
      and so__qadc03 = "yes"
      and not can-find(first t_tr_hist1
      where t_tr_nbr = so_nbr)
   then do:
      /* sotrhstb.p CREATES TEMP-TABLE TO STORE tr_hist RECORDS AND RETRIEVE  */
      /* THE SAME IN soauthbl.p TO IMPROVE THE PERFORMANCE WHILE PRINTING     */
      /* AUTHORIZATION NUMBERS FOR SCHEDULE ORDERS.                           */
      {gprun.i ""sotrhstb.p""
               "(input so_nbr,
                 input so_inv_nbr,
                 input-output table t_tr_hist1)"}

   end.

   for each sod_det
      where sod_domain = global_domain
      and  (sod_nbr = so_nbr
      and  (sod_qty_inv <> 0
      /* CREATE HISTORY FOR 0 ORD-QTY LINES */
      or   (sod_qty_ord = 0 and sod_qty_ship = 0
      and   sod_qty_all = 0 and sod_qty_pick = 0
      and   substring(sod_fsm_type,1,3) <> "RMA"
      and   not sod_sched)
      /*And lines which had remaining bckord cancl'd*/
      or   (sod_qty_ord - sod_qty_ship = 0
      and   substring(sod_fsm_type,1,3) <> "RMA"
      and   not sod_sched)) )
   exclusive-lock:

      assign
         l_invnbr  = so_inv_nbr
         net_price = sod_price.

      if sod_tax_in then do:
         /* DETERMINE NET PRICE.  TAX BY TOTAL RECORDS    */
         /* (LINE 0) DO NOT NEED TO BE CONSIDERED BECAUSE */
         /* IF TAX IS INCLUDED IN A PRICE TAXES WILL ONLY */
         /* BE CALCULATED BY LINE AND NOT BY TOTAL.       */
         for each tx2d_det
            where tx2d_domain  = global_domain
            and   tx2d_ref     = so_inv_nbr
            and   tx2d_nbr     = so_nbr
            and   tx2d_line    = sod_line
            and   tx2d_tr_type = "16"
         no-lock:
            net_price = net_price - tx2d_cur_tax_amt.
         end.
      end.

      line_amt = (sod_qty_inv * net_price) * (1 - (so_disc_pct / 100)).

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
                "(input-output line_amt,
                  input  rndmthd,
                  output mc-error-number)" }
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

      /* CHECK AUTHORIZATION RECORDS FOR DIFFERENT EXTENDED PRICE */
      if sod_sched      = yes
         and so__qadc03 = "yes"
      then do:

         auth_found = no.
         {gprun.i ""soauthbl.p""
                  "(input  table t_tr_hist1,
                    input  so_inv_nbr,
                    input  so__qadc03,
                    input  sod_nbr,
                    input  sod_line,
                    input  net_price,
                    input  sod_site,
                    input  line_amt,
                    output auth_price,
                    output auth_found)"}

         line_amt = auth_price * (1 - (so_disc_pct / 100)).

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output line_amt,
                     input  rndmthd,
                     output mc-error-number)"}

         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.
      end. /* IF sod_sched */

      if sod_qty_inv <> 0
         and   can-find (iec_ctrl
         where iec_domain = global_domain
         and   iec_use_instat = yes)
      then do:
         /* CREATE IMPORT EXPORT HISTORY RECORD */
         {gprun.i ""iehistso.p""
                  "(buffer sod_det,
                    input sod_qty_inv,
                    input so_inv_date,
                    input ""POST"")"}
      end.

      /*CREATE HISTORY FOR SALES ORDER LINES sod_det */
      sod_recno = recid(sod_det).
      {gprun.i ""soivpstc.p""}

      /* SOD_QTY_IVCD REPRESENTS THE QUANTITY WHICH HAS BEEN */
      /* INVOICED. */
      assign
         sod_qty_ivcd = sod_qty_ivcd + sod_qty_inv
         sod_qty_inv  = 0.

      /* Update qty to inv in remote database */
      if global_db <> "" then do:

         for first si_mstr
            fields (si_domain si_db si_site)
            where si_domain = global_domain
            and   si_site   = sod_site
         no-lock: end.

         if si_db <> global_db then do:
            {gprun.i ""gpalias3.p""
                     "(input  si_db,
                       output err_flag)"}

            {soivconn.i procesloop yes}

            assign
               sonbr  = so_nbr
               soline = sod_line.

            {gprun.i ""soivpstu.p""}

            {gprun.i ""gpalias3.p""
                     "(input  so_db,
                       output err_flag)"}

            {soivconn.i procesloop no}
         end.
      end.

      /* CLOSING (AND DELETING) SALES ORDER LINES - A discussion:
       * We want to close a given line if it has been completely
       * shipped or overshipped.  This is complicated by the fact that
       * either the quantity ordered or the quantity shipped may be
       * negative.  Another way of looking at the problem is that the
       * line should be closed if the shipment has driven the
       * backordered quantity across zero (so that the result has a
       * different sign than the ordered quantity).  This is
       * complicated by the fact that Progress does not provide a sign
       * function.  HOWEVER, we know that the product of two numbers
       * is negative if and only if they have different signs and
       * multiplication is relatively cheap in terms of processing
       * time. */
      for each ecx_ref
         where ecx_domain = global_domain
         and   ecx_nbr    = sod_nbr
         and   ecx_line   = string(sod_line)
         and   ecx_order_type = "so"
      no-lock:
         create ecxref.
         assign
            orderType = ecx_order_type
            orderNbr  = ecx_nbr
            exHdrRef  = ecx_ext_ref
            exLnRef   = ecx_ext_line
            orderLn   = decimal(ecx_line).
      end.

      /*TEST TO SEE IF SALES ORDER LINE SHOULD BE DELETED (see above)*/
      l_consigned_line_item = no.

      if using_cust_consignment then do:
         l_consigned_line_item = no.
         {gprunmo.i &module = "ACN" &program = "socnsod1.p"
                    &param  = """(input  sod_nbr,
                                  input  sod_line,
                                  output l_consigned_line_item,
                                  output consign_loc,
                                  output intrans_loc,
                                  output max_aging_days,
                                  output auto_replenish)"""}
      end.

      /* IF THE LINE IS CONSIGNED, CHECK TO SEE IF IT HAS BEEN */
      /* COMPLETELY USED BEFORE DELETING IT.                   */
      if (l_consigned_line_item and (sod_qty_all = 0 and
          sod_qty_pick = 0 and sod_qty_ord <> 0) and not sod_sched and
         (sod_qty_ord * (sod_qty_ord - sod_cum_qty[4]) <= 0)) or
         (not l_consigned_line_item and (sod_qty_all = 0 and
          sod_qty_pick = 0 and sod_qty_ord <> 0) and not sod_sched and
         (sod_qty_ord * (sod_qty_ord - sod_qty_ship) <= 0))
         and (
         (ExtInvoicing = no) or /* the normal case is no */
         /* External Invoicing is active. */
         /* Check for invoiced not just shipped */
         (sod_qty_ord * (sod_qty_ord - sod_qty_ivcd) <= 0 ))
      then do:

         /* Delete line information that might exist in other dbs */
         for first si_mstr
            fields (si_domain si_db si_site)
            where si_domain = global_domain
            and   si_site = sod_site
         no-lock: end.

         if si_db <> so_db then do:
            {gprun.i ""gpalias3.p""
                     "(input  si_db,
                       output err_flag)"}

            {soivconn.i procesloop yes}

            assign
               sonbr  = so_nbr
               soline = sod_line.

            /* DO NOT EXECUTE MFSOFC01.I                   */
            /* AND MFSOFC02.I WHEN CALLED FROM DETAIL LINE */
            {gprun.i ""solndel.p""  "(input no)"}

            {gprun.i ""gpalias3.p""
                     "(input  so_db,
                       output err_flag)"}

            {soivconn.i procesloop no}
         end.

         for each sob_det
             where sob_domain = global_domain
             and   sob_nbr    = sod_nbr
             and   sob_line   = sod_line
         exclusive-lock:

            if sod_status <> "FAS"
               and sod_fa_nbr  = ""
               and sod_lot     = ""
               and sod_type    = ""
               and sob_qty_req <> 0
            then do:

               find pt_mstr
                   where pt_domain = global_domain
                   and  pt_part    = sob_part
               exclusive-lock no-error.

               if available pt_mstr then do:

                  pt_mrp = yes.
                  find in_mstr
                     where in_domain = global_domain
                     and   in_part   = pt_part
                     and   in_site = sob_site
                  exclusive-lock no-error.
                  if available in_mstr then do:

                     if sob_qty_req > 0 then
                        in_qty_req =
                           in_qty_req - max(sob_qty_req - sob_qty_iss,0).
                     if sob_qty_req < 0 then
                        in_qty_req =
                           in_qty_req - min(sob_qty_req - sob_qty_iss,0).
                  end.
               end. /* if available pt_mstr */
            end. /* if sod_status <> "FAS" */

            {mfmrwdel.i "sob_det" sob_part sob_nbr
                        "string(sob_line) + ""-"" + sob_feature" sob_parent}

            run del-cmt-det
               (input sob_cmtindx).

            delete sob_det.

         end. /* for each sob_det */

         /* Delete cost data */
         run del-sct-det
            (input sod_part,
             input sod_nbr,
             input sod_line).

         {mfmrwdel.i "sod_fas" sod_part sod_nbr string(sod_line) """" }

         if so_fsm_type <> "RMA" or deleterma then do:

            run del-cmt-det
               (input sod_cmtindx).

            /* DELETE IMPORT EXPORT RECORDS */
            run del-ied-det
               (input sod_nbr,
                input sod_line).

            /* Delete price history records */
            run del-pih-hist
               (input sod_nbr,
                input sod_line).

            /* DELETE BTB RECORDS */
            run del-btb-det.

            if using_line_charges then do:

               /* DELETE ANY ADDITIONAL LINE CHARGES FOR */
               /* THE SALES ORDER LINE */
               {gprunmo.i &module = "ACL" &program = ""sosodlcd.p""
                          &param  = """(input sod_nbr,
                                        input sod_line)"""}
            end.

            run del-sodr-det.

            if ExtInvoicing then
               run del_tx2d_13
                  (input sod_nbr).

            /* DELETE tx2d_det FOR FULLY SHIPPED LINES          */
            /* I.E. BEFORE sod_det LINES ARE DELETED            */
            run del_tx2d_line13
               (input so_inv_nbr,
                input sod_nbr,
                input sod_line,
                input '16').

            /* IF LOGISTICS ACCOUNTING IS ENABLED */
            if use-log-acctg then do:

               /* LOGISTICS ACCTG TAX TYPE 43 RECORDS ARE NEEDED DURING */
               /* VOUCHERING OF THE LOGISTICS CHARGE. THEREFORE TYPE 43 */
               /* tx2d_det RECORDS CREATED DURING SO SHIPMENT PROCESSES */
               /* ARE NOT DELETED HERE.                                 */
               tax_type = "41".
               if so_fsm_type = "RMA" then
                  tax_type = "46".

               /* DELETE LOGISTICS ACCOUNTING tx2d_det RECORDS FOR SO LINE */
               {gprunmo.i &module = "LA" &program = "lataxdel.p"
                          &param  = """(input tax_type,
                                        input sod_nbr,
                                        input sod_line)"""}
            end.   /* use-log-acctg */

            run deleteCreditCardDetails (input sod_nbr,input sod_line).

            {gprun.i ""gpxrdlln.p""
                     "(input sod_nbr,
                       input sod_line,
                       input 'so')"}
               assign sod_qty_inv = 0.   /* 将开票数量归零且保留SOD记录 */
/*             delete sod_det.    */

         end.
      end. /* if (sod_qty_all = 0 ... */
   end. /* for each sod_det */

   if (can-find(first lgs_mstr
      where lgs_domain = global_domain
      and   lgs_app_id = so_app_owner))
      and   (can-find(first esp_mstr
      where esp_domain = global_domain
      and   esp_app_id = so_app_owner
      and esp_doc_typ  = "LOAD_PLINVOICE"
      and esp_publ_flg))
   then
      {gprun.i ""lgplivex.p""
               "(input so_inv_nbr,
                 table ecxref,
                 input prepaid_amt)"}

   /*CREATE INVOICE HISTORY - FOR EVERY INVOICE CREATED */
   run create-invoice-history.

   for each sor_mstr
      where sor_domain = global_domain
      and   sor_nbr    = so_nbr
   no-lock:
      run create-inv-rel-history.
   end.

   assign
      so_invoiced = no
      so_inv_nbr  = "".
/*zy*/     assign so_trl1_amt = decimal(entry(1,so__chr06,";"))
/*zy*/                          when so__chr06 <> ""
/*zy*/            so_trl2_amt = decimal(entry(2,so__chr06,";"))
/*zy*/                          when so__chr06 <> ""
/*zy*/            so_trl3_amt = decimal(entry(3,so__chr06,";"))
/*zy*/                         when so__chr06 <> "".
   /* RESTORING THE ORIGINAL VALUE OF SO_SHIP WHICH GETS UPDATED */
   /* BY ABS_SHIPTO DURING SHIPPER CONFIRM                       */
   if so__qadc01 <> "" then
      assign
         so_ship    = so__qadc01
         so__qadc01 = "".
/*zy*/ /* acs005发票过账，出货单确认不删除so且保留SO尾 */
/*zy*/ /*   if not customer_sched then  */
/*zy*/ /*      assign                   */
/*zy*/ /*         so_trl1_amt = 0       */
/*zy*/ /*         so_trl2_amt = 0       */
/*zy*/ /*         so_trl3_amt = 0.      */
   /* For external invoicing, clean up tx2d det records */
   if ExtInvoicing then
      run Update_tx2d (input so_nbr).

   /* IF NO OPEN LINE REMAIN, DELETE THE SALES ORDER */
   /* (Lines with zero qty ord count as closed) */
   for last sod_det
      fields (sod_domain sod_cmtindx sod_fa_nbr sod_fsm_type sod_line sod_lot
              sod_nbr sod_part sod_price sod_qty_all sod_qty_inv sod_qty_ord
              sod_qty_pick sod_qty_ship sod_sched sod_site sod_status
              sod_taxable sod_taxc sod_tax_in sod_type sod_cum_qty sod_um_conv)
      where sod_domain    = global_domain
      and ( sod_nbr       = so_nbr
      and  (sod_qty_ord  <> 0
      or    sod_qty_ship <> 0
      or    sod_qty_all  <> 0
      or    sod_qty_pick <> 0
      or    sod_sched)
      and   sod_fsm_type <> "FSM-RO")
   no-lock: end.

   if available sod_det
   then do:
      /* DELETE tx2d_det FOR PARTIALLY SHIPPED LINES  */
      /* I.E. IF sod_det LINES EXISTS                 */
      for each soddet
         where soddet.sod_domain   = global_domain
         and ( soddet.sod_nbr      = sod_det.sod_nbr
         and  (soddet.sod_qty_ord  <> 0
         or    soddet.sod_qty_ship <> 0
         or    soddet.sod_qty_all  <> 0
         or    soddet.sod_qty_pick <> 0
         or    soddet.sod_sched)
         and   soddet.sod_fsm_type <> "FSM-RO")
      no-lock:

         run del_tx2d_line13
            (input l_invnbr,
             input soddet.sod_nbr,
             input soddet.sod_line,
             input '16').

      end. /* FOR EACH soddet */
   end. /* IF AVAILABLE sod_det */

   if not available sod_det
      or  so_fsm_type = "RMA"
      and deleterma
   then do:

      /* COMMENTS SHOULD NOT BE DELETED IN CASE OF CALL INVOICE */
      if so_fsm_type <> "fsm-ro" then
         run del-cmt-det (input so_cmtindx).

      for each sod_det
         where sod_domain = global_domain
         and   sod_nbr    = so_nbr
         and   sod_line   > 0
      exclusive-lock:

         /* FORCE USE OF sod_nbrln INDEX */
         /* Delete line information that might exist in other dbs */
         for first si_mstr
            fields (si_domain si_db si_site)
            where si_mstr.si_domain = global_domain and  si_site = sod_site
         no-lock: end.

         if si_db <> so_db then do:
            {gprun.i ""gpalias3.p""
                     "(input  si_db,
                       output err_flag)"}

            {soivconn.i procesloop yes}

            assign
               sonbr  = so_nbr
               soline = sod_line.

            /* DO NOT EXECUTE MFSOFC01.I                   */
            /* AND MFSOFC02.I WHEN CALLED FROM DETAIL LINE */
            {gprun.i ""solndel.p"" "(input no)"}

            /* Reset the DB Alias To the SO Database */
            {gprun.i ""gpalias3.p""
                     "(input  so_db,
                       output err_flag)"}

            {soivconn.i procesloop no}
         end.

         for each sob_det
            where sob_domain = global_domain
            and   sob_nbr    = so_nbr
            and   sob_line   = sod_line
         exclusive-lock:
            run del-cmt-det
               (input sob_cmtindx).
            delete sob_det.
         end.

         /* Delete cost data */
         run del-sct-det
            (input sod_part,
             input sod_nbr,
             input sod_line).

         if so_fsm_type <> "RMA" or deleterma then do:

            run del-cmt-det
               (input sod_cmtindx).

            /* DELETE IMPORT EXPORT RECORDS */
            run del-ied-det
               (input sod_nbr,
                input sod_line).

            /* DELETE BTB RECORDS */
            run del-btb-det.

            run del-sodr-det.

            /* IF LOGISTICS ACCOUNTING IS ENABLED */
            if use-log-acctg then do:

               /* LOGISTICS ACCTG TAX TYPE 43 RECORDS ARE NEEDED DURING */
               /* VOUCHERING OF THE LOGISTICS CHARGE. THEREFORE TYPE 43 */
               /* tx2d_det RECORDS CREATED DURING SO SHIPMENT PROCESSES */
               /* ARE NOT DELETED HERE.                                 */
               tax_type = "41".
               if so_fsm_type = "RMA" then
                  tax_type = "46".

               /* DELETE LOGISTICS ACCOUNTING tx2d_det RECORDS FOR SO LINE */
               {gprunmo.i &module = "LA" &program = "lataxdel.p"
                          &param  = """(input tax_type,
                                        input sod_nbr,
                                        input sod_line)"""}
            end.   /* use-log-acctg */

            run deleteCreditCardDetails
               (input sod_nbr,
                input sod_line).

            {gprun.i ""gpxrdlln.p""
                     "(input sod_nbr,
                       input sod_line,
                       input 'so')"}
              assign sod_qty_inv = 0.   /* 将开票数量归零且保留SOD记录 */
/*            delete sod_det.  */

         end.

      end. /* for each sod_det */

      empty temp-table t_tr_hist1.

      /* DELETE TAX DETAIL FOR SALES ORDER OR CALL INVOICE */
      run del-tx2d-det
         (input so_nbr,
          input so_quote).

      if so_fsm_type <> "RMA"  or deleterma then do:

         for each ie_mstr
            where ie_domain = global_domain
            and   ie_type = {&IE_TYPE_SO}
            and ie_nbr = so_nbr
         exclusive-lock:
            delete ie_mstr.
         end.

         {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                   "(input so_exru_seq)" }
         {&SOIVPSTA-P-TAG4}

         run del-sor-mstr.

         /* IF LOGISTICS ACCOUNTING IS ENABLED */
         if use-log-acctg then do:

            /* LOGISTICS ACCTG TAX TYPE 43 RECORDS ARE NEEDED DURING */
            /* VOUCHERING OF THE LOGISTICS CHARGE. THEREFORE TYPE 43 */
            /* tx2d_det RECORDS CREATED DURING SO SHIPMENT PROCESSES */
            /* ARE NOT DELETED HERE.                                 */
            tax_type = "41".
            if so_fsm_type = "RMA" then
               tax_type = "46".

            /* DELETE ALL LOGISTICS ACCOUNTING tx2d_det RECORDS FOR SO */
            {gprunmo.i &module = "LA" &program = "lataxdel.p"
                       &param  = """(input tax_type,
                                     input so_nbr,
                                     input 0)"""}

            /* DELETE THE LACD_DET (LOGISTICS ACCOUNTING CHARGE DETAIL)*/
            /* RECORDS REFERENCING THIS SALES ORDER.   */
            {gprunmo.i  &module = "LA" &program = "laosupp.p"
                        &param  = """(input 'DELETE',
                                      input '{&TYPE_SO}',
                                      input so_nbr,
                                      input ' ',
                                      input ' ',
                                      input ' ',
                                      input no,
                                      input no)"""}
         end. /* IF use-log-acctg */

         {gprun.i ""gpxrdlln.p""
              "(input so_nbr,
                input '',
                input 'so')"}
                /* 处理So并且不删除So_mstr 记录  */
          ASSIGN
               so_inv_nbr = ""
               so_invoiced = no
               so_to_inv = YES .
          /*       delete so_mstr.  */
      end.

   end. /* if not available sod-det */

   return.

end. /* do transaction on error undo, leave */

undo_all = yes.

PROCEDURE create-ar-distribution:

   define buffer arddet for ard_det.

   for first gl_ctrl
      fields (gl_domain gl_ar_acct gl_ar_sub gl_ar_cc gl_base_curr
              gl_disc_acct gl_disc_sub gl_disc_cc)
      where gl_domain = global_domain
   no-lock: end.

   if disc_amt <> 0 then do:

      find first ard_det
         where ard_domain = global_domain
         and   ard_nbr    = so_mstr.so_inv_nbr
         and   ard_acct   = gl_disc_acct
         and   ard_sub    = gl_disc_sub
         and   ard_cc     = gl_disc_cc
         and   ard_entity = post_entity
      exclusive-lock no-error.

      if not available ard_det then do:

         create ard_det.
         assign
            ard_domain  = global_domain
            ard_nbr     = so_inv_nbr
            ard_entity  = post_entity
            ard_acct    = gl_disc_acct
            ard_sub     = gl_disc_sub
            ard_cc      = gl_disc_cc
            recno       = recid(ard_det)
            ard_dy_code = dft-daybook
            ard_dy_num  = nrm-seq-num.

         if recid(ard_det) = -1 then .

      end.

      assign
         ard_amt      = ard_amt + disc_amt
         account_code = ard_acct.

      for first ac_mstr
         fields (ac_domain ac_code ac_desc)
         where ac_domain = global_domain
         and   ac_code = account_code
      no-lock:
         ard_desc = ac_desc.
      end.

      account_code = "".

   end.  /* if disc_amt <> 0*/

   /* CREATE AR DETAIL FOR TRAILER ITEMS */
   if so_trl1_amt <> 0 then do:

      for first trl_mstr
         fields (trl_domain trl_acct trl_sub trl_cc trl_code trl_taxable
                 trl_taxc)
         where trl_domain = global_domain
         and   trl_code   = so_trl1_cd
      no-lock: end.

      find first ard_det
         where ard_domain = global_domain
         and   ard_nbr    = so_inv_nbr
         and   ard_acct   = trl_acct
         and   ard_sub    = trl_sub
         and   ard_cc     = trl_cc
         and   ard_entity = post_entity
         and   ard_tax_at = trl_taxc
      exclusive-lock no-error.

      if not available ard_det then do:

         create ard_det.
         assign
            ard_domain   = global_domain
            ard_nbr      = so_inv_nbr
            ard_entity   = post_entity
            ard_acct     = trl_acct
            ard_sub      = trl_sub
            ard_cc       = trl_cc
            ard_dy_code  = dft-daybook
            ard_dy_num   = nrm-seq-num
            account_code = ard_acct.

         if recid(ard_det) = -1 then .

         for first ac_mstr
            fields (ac_domain ac_code ac_desc)
            where ac_domain = global_domain
            and   ac_code   = account_code
         no-lock:
            ard_desc = ac_desc.
         end.

         assign
            account_code = ""
            ard_tax_at   = trl_taxc
            /* ARD_TAX_AT IS IN A UNIQUE INDEX, */
            /*  ASSIGN BEFORE RECID FUNCTION */
            ard_taxc     = trl_taxc
            recno        = recid(ard_det).

      end.

      ard_amt = ard_amt + so_trl1_amt.

   end. /* if so_trl1_amt <> 0 */

   if so_trl2_amt <> 0 then do:

      for first trl_mstr
         fields (trl_domain trl_acct trl_sub trl_cc trl_code trl_taxable
                 trl_taxc)
         where trl_domain = global_domain
         and   trl_code   = so_trl2_cd
      no-lock: end.

      find first ard_det
         where ard_domain = global_domain
         and   ard_nbr    = so_inv_nbr
         and   ard_acct   = trl_acct
         and   ard_sub    = trl_sub
         and   ard_cc     = trl_cc
         and   ard_entity = post_entity
         and   ard_tax_at = trl_taxc
      exclusive-lock no-error.

      if not available ard_det then do:

         create ard_det.
         assign
            ard_domain   = global_domain
            ard_nbr      = so_inv_nbr
            ard_entity   = post_entity
            ard_acct     = trl_acct
            ard_sub      = trl_sub
            ard_cc       = trl_cc
            ard_dy_code  = dft-daybook
            ard_dy_num   = nrm-seq-num
            account_code = ard_acct.

         if recid(ard_det) = -1 then .

         for first ac_mstr
            fields (ac_domain ac_code ac_desc)
             where ac_mstr.ac_domain = global_domain and  ac_code = account_code
         no-lock:
            ard_desc = ac_desc.
         end.

         assign
            account_code = ""
            ard_tax_at = trl_taxc
            /*  ARD_TAX_AT IS IN A UNIQUE INDEX, */
            /*  ASSIGN BEFORE RECID FUNCTION */
            ard_taxc = trl_taxc
            recno = recid(ard_det).

      end.

      ard_amt = ard_amt + so_trl2_amt.

   end. /* if so_trl2_amt <> 0 */

   if so_trl3_amt <> 0 then do:

      for first trl_mstr
         fields (trl_domain trl_acct trl_sub trl_cc trl_code trl_taxable
                 trl_taxc)
         where trl_domain = global_domain
         and   trl_code   = so_trl3_cd
      no-lock: end.

      find first ard_det
         where ard_domain = global_domain
         and   ard_nbr    = so_inv_nbr
         and   ard_acct   = trl_acct
         and   ard_sub    = trl_sub
         and   ard_cc     = trl_cc
         and   ard_entity = post_entity
         and   ard_tax_at = trl_taxc
      exclusive-lock no-error.

      if not available ard_det then do:

         create ard_det.
         assign
            ard_domain  = global_domain
            ard_nbr     = so_inv_nbr
            ard_entity  = post_entity
            ard_acct    = trl_acct
            ard_sub     = trl_sub
            ard_cc      = trl_cc
            ard_dy_code = dft-daybook
            ard_dy_num  = nrm-seq-num
            account_code = ard_acct.

         if recid(ard_det) = -1 then .


         for first ac_mstr
            fields (ac_domain ac_code ac_desc)
             where ac_domain = global_domain
             and   ac_code   = account_code
         no-lock:
            ard_desc = ac_desc.
         end.

         assign
            account_code = ""
            ard_tax_at = trl_taxc
            /*  ARD_TAX_AT IS IN A UNIQUE INDEX, */
            /*  ASSIGN BEFORE RECID FUNCTION */
            ard_taxc = trl_taxc
            recno = recid(ard_det).

      end.

      ard_amt = ard_amt + so_trl3_amt.

   end. /* if so_trl3_amt */

   ord_amt_corr = ord_amt.

   if so_fsm_type = "PRM" then
      assign
         ord_amt_prep = so_prepaid
         ord_amt_ptax = so_prep_tax
         ord_amt_corr = ord_amt_corr - ord_amt_prep - ord_amt_ptax.

   /* SAVE TRAILER CHARGES INFORMATION IF NEEDED BY SELF-BILLING */
   if save_sbinfo then
      if so_trl1_amt <> 0 or so_trl2_amt <> 0 or so_trl3_amt <> 0 then
         run save_selfbill_info
            (input "C",
             input so_inv_nbr,
             input so_nbr,
             input (so_trl1_amt + so_trl2_amt + so_trl3_amt) ).

   /* SET TAX ACCOUNTS */
   /* CREATE ard_det FOR tx2d_det. txmkard.p WILL */
   /* FIND THE CORRECT ACCOUNT AND COST CENTER    */
   {gprun.i ""txmkard.p""
            "(input so_inv_nbr,
              input so_nbr,
              input '16'  /* TRXN TYPE */,
              input ''    /* ACCOUNT */,
              input ''    /* SUB ACCOUNT */,
              input ''    /* COST CENTER */,
              input ''    /* PROJECT */,
              input 't'   /* TAXCODE */)"}

   /* Because we might be consolidating multiple sales orders */
   /* Into this invoice, check to see whether it exists and   */
   /* Add on to it if it does.                                */
   find ar_mstr
      where ar_domain = global_domain
      and   ar_nbr    = so_inv_nbr
   exclusive-lock no-error.
   {&SOIVPSTA-P-TAG5}

   if not available ar_mstr then do:
      {&SOIVPSTA-P-TAG6}
      create ar_mstr.
      assign
         ar_domain      = global_domain
         ar_nbr         = so_inv_nbr
         ar_type        = "I"
         ar_batch       = batch
         ar_cust        = so_cust
         ar_bill        = so_bill
         ar_ship        = so_ship
         ar_so_nbr      = so_nbr
         ar_slspsn[1]   = so_slspsn[1]
         ar_slspsn[2]   = so_slspsn[2]
         ar_slspsn[3]   = so_slspsn[3]
         ar_slspsn[4]   = so_slspsn[4]
         ar_comm_pct[1] = so_comm_pct[1]
         ar_comm_pct[2] = so_comm_pct[2]
         ar_comm_pct[3] = so_comm_pct[3]
         ar_comm_pct[4] = so_comm_pct[4]
         ar_cr_terms    = so_cr_terms
         ar_po          = if so_sched then l_po_schd_nbr
                          else so_po
         ar_entity      = post_entity
         ar_contested   = no
         ar_tax_date    = so_inv_date
         ar_dy_code     = dft-daybook
         ar_curr        = so_curr
         ar_ex_rate     = exch_rate
         ar_ex_rate2    = exch_rate2
         ar_ex_ratetype = exch_ratetype
         ar_app_owner   = so_app_owner
         ar_fsm_type    = so_fsm_type.

      {&SOIVPSTA-P-TAG7}

      if recid(ar_mstr) = -1 then .

      /* Copy exchange rate usage records */
      {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
                "(input  exch_exru_seq,
                  output ar_exru_seq)" }

      assign
         tot_inv_comm[1] = 0
         tot_inv_comm[2] = 0
         tot_inv_comm[3] = 0
         tot_inv_comm[4] = 0
         recno = recid(ar_mstr).

      if eff_date = ? then
         ar_effdate = today.
      else
         ar_effdate = eff_date.

      if ar_tax_date = ? then
         ar_tax_date = ar_effdate.

      if so_inv_date = ? then
         ar_date = ar_effdate.
      else
         ar_date = so_inv_date.

      assign
         ar_acct = so_ar_acct
         ar_sub  = so_ar_sub
         ar_cc   = so_ar_cc.

      if ar_acct = "" then
         assign
            ar_acct = gl_ar_acct
            ar_sub  = if ar_sub = "" then gl_ar_sub else ar_sub
            ar_cc   = if ar_cc  = "" then gl_ar_cc  else ar_cc.

      for first ct_mstr
         fields (ct_domain ct_code ct_dating)
         where ct_domain = global_domain
         and   ct_code = so_cr_terms
      no-lock: end.

      if not available ct_mstr
         or ct_dating = no
      then do:
         /*CALCULATE CREDIT TERMS */
         {gprun.i ""adctrms.p""
                  "(input  ar_date,
                    input  so_cr_terms,
                    output ar_disc_date,
                    output ar_due_date)"}
      end.
      else do:
         /* IF MULTI-LEVEL CREDIT TERM, GET THE LAST DUE DATE */
         for last ctd_det
            fields (ctd_domain ctd_code ctd_date_cd)
            where ctd_domain = global_domain
            and   ctd_code   = so_cr_terms
         no-lock:

            /* CALCULATE DATES USING LAST CREDIT TERMS RECORD */
            {gprun.i ""adctrms.p""
                     "(input  ar_date,
                       input  ctd_date_cd,
                       output ar_disc_date,
                       output ar_due_date)"}
         end.
      end. /* IF AVAILABLE CT_MSTR OR ... */
   end. /* if not available ar_mstr */

   assign
      viar_recno = recid(ar_mstr)
      ar_amt     = ar_amt + ord_amt_corr
      vinvtamt   = ar_amt
      ar_open    = ar_amt <> 0 .

   /* UPDATE CUSTOMER BALANCE */
   find cm_mstr
      where cm_domain = global_domain
      and   cm_addr   = ar_bill
   exclusive-lock.

   /* AR_CURR IS NOT BASE CURR - CONVERT BASE AMOUNT TO BASE CURR*/
   if (ar_curr <> gl_base_curr) then do:

      /* REPLACED ord_amt WITH ord_amt_corr BELOW */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
                "(input  so_curr,
                  input  base_curr,
                  input  ar_ex_rate,
                  input  ar_ex_rate2,
                  input  ord_amt_corr,
                  input  true,  /* ROUND */
                  output base_amt,
                  output mc-error-number)" }
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.
   end.
   else
      base_amt = ord_amt_corr.

   assign
      l_tot_amt1  = l_tot_amt1  + ord_amt_corr
      l_tot_ramt1 = l_tot_ramt1 + base_amt.

   assign
      ar_base_amt  = ar_base_amt + base_amt
      cm_balance   = cm_balance + base_amt
      cm_sale_date = MAX(cm_sale_date,ar_date).

   if cm_sale_date = ? then
      cm_sale_date = ar_date.

  if cm_balance > cm_high_cr then do:
      if cm_high_date = ? or cm_high_date < ar_date then
         cm_high_date = ar_date.

      cm_high_cr = cm_balance.
   end.

   assign
      cm_invoices  = cm_invoices + 1
      ar_sales_amt = ar_sales_amt + line_total + disc_amt
      ar_mrgn_amt  = ar_mrgn_amt + line_total + disc_amt - tot_ext_cost
      tot_inv_comm[1] = tot_inv_comm[1]
                      + (tot_line_comm[1] * (100 - so_disc_pct)) / 100
      tot_inv_comm[2] = tot_inv_comm[2]
                      + (tot_line_comm[2] * (100 - so_disc_pct)) / 100
      tot_inv_comm[3] = tot_inv_comm[3]
                      + (tot_line_comm[3] * (100 - so_disc_pct)) / 100
      tot_inv_comm[4] = tot_inv_comm[4]
                      + (tot_line_comm[4] * (100 - so_disc_pct)) / 100.

   if soc_ctrl.soc_margin = yes then do:
      if ar_mrgn_amt <> 0 then
         /* ROUNDING IS DONE IF CONSOLIDATION HAS OCCURED ELSE */
         /* ASSIGN SALES ORDER COMMISSION PERCENTAGE           */
         assign
            ar_comm_pct[1] = if l_consolidate then
                                round(((tot_inv_comm[1] * 100)/ ar_mrgn_amt), 2)
                             else
                                so_comm_pct[1]
            ar_comm_pct[2] = if l_consolidate then
                                round(((tot_inv_comm[2] * 100)/ ar_mrgn_amt), 2)
                             else
                                so_comm_pct[2]
            ar_comm_pct[3] = if l_consolidate then
                                round(((tot_inv_comm[3] * 100)/ ar_mrgn_amt), 2)
                             else
                                so_comm_pct[3]
            ar_comm_pct[4] = if l_consolidate then
                                round(((tot_inv_comm[4] * 100)/ ar_mrgn_amt), 2)
                             else
                                so_comm_pct[4].
      else
         assign
            ar_comm_pct[1] = 0
            ar_comm_pct[2] = 0
            ar_comm_pct[3] = 0
            ar_comm_pct[4] = 0.
   end.
   else if soc_margin = no then do:
      if ar_sales_amt <> 0 then

         /* ROUNDING IS DONE IF CONSOLIDATION HAS OCCURED ELSE */
         /* ASSIGN SALES ORDER COMMISSION PERCENTAGE           */
         assign
            ar_comm_pct[1] = if l_consolidate then
                               round(((tot_inv_comm[1] * 100)/ ar_sales_amt), 2)
                             else
                               so_comm_pct[1]
            ar_comm_pct[2] = if l_consolidate then
                               round(((tot_inv_comm[2] * 100)/ ar_sales_amt), 2)
                             else
                               so_comm_pct[2]
            ar_comm_pct[3] = if l_consolidate then
                               round(((tot_inv_comm[3] * 100)/ ar_sales_amt), 2)
                             else
                               so_comm_pct[3]
            ar_comm_pct[4] = if l_consolidate then
                               round(((tot_inv_comm[4] * 100)/ ar_sales_amt), 2)
                             else
                               so_comm_pct[4].
      else
         assign
            ar_comm_pct[1] = 0
            ar_comm_pct[2] = 0
            ar_comm_pct[3] = 0
            ar_comm_pct[4] = 0.
   end.

   batch_tot = batch_tot + ord_amt.
end. /* procedure create-ar-distribution */

PROCEDURE create-invoice-history:

   /* Copy comments */
   if so_mstr.so_cmtindx <> 0 then do:
      {gpcmtcpy.i &old_index = so_cmtindx
                  &new_index = cmtindx
                  &counter   = i}
   end.
   else
      cmtindx = 0.

   create ih_hist.
   assign
      ih_domain       = global_domain
      ih_ar_acct      = so_ar_acct
      ih_ar_sub       = so_ar_sub
      ih_ar_cc        = so_ar_cc
      ih_bank         = so_bank
      ih_bill         = so_bill
      ih_bol          = so_bol
      ih_cartons      = so_cartons
      ih_ca_nbr       = so_ca_nbr
      ih_channel      = so_channel
      ih_cmtindx      = cmtindx
      ih_cncl_date    = so_cncl_date
      ih_comm_pct[1]  = so_comm_pct[1]
      ih_comm_pct[2]  = so_comm_pct[2]
      ih_comm_pct[3]  = so_comm_pct[3]
      ih_comm_pct[4]  = so_comm_pct[4]
      ih_conf_date    = so_conf_date
      ih_conrep       = so_conrep
      ih_credit       = so_credit
      ih_crprlist     = so_crprlist
      ih_cr_card      = so_cr_card
      ih_cr_init      = so_cr_init
      ih_cr_terms     = so_cr_terms
      ih_curr         = so_curr
      ih_cust         = so_cust
      ih_cust_po      = so_cust_po
      ih_disc_pct     = so_disc_pct
      ih_div          = so_div
      ih_due_date     = so_due_date
      ih_ex_rate      = exch_rate
      ih_ex_rate2     = exch_rate2
      ih_ex_ratetype  = exch_ratetype
      ih_fcg_code     = so_fcg_code
      ih_fix_pr       = so_fix_pr
      ih_fix_rate     = so_fix_rate
      ih_fob          = so_fob
      ih_fr_list      = so_fr_list
      ih_fr_terms     = so_fr_terms
      ih_fr_min_wt    = so_fr_min_wt
      ih_fsm_type     = so_fsm_type
      ih_fst_id       = so_fst_id
      ih_invoiced     = so_invoiced
      ih_inv_cr       = so_inv_cr
      ih_inv_date     = so_inv_date
      ih_inv_mthd     = so_inv_mthd
      ih_inv_nbr      = so_inv_nbr
      ih_lang         = so_lang
      ih_nbr          = so_nbr
      ih_ord_date     = so_ord_date
      ih_partial      = so_partial
      ih_po           = so_po
      ih_prepaid      = prepaid_amt
      ih_prep_tax     = so_prep_tax
      ih_priced_dt    = so_priced_dt
      ih_pricing_dt   = so_pricing_dt
      ih_primary      = so_primary
      ih_secondary    = so_secondary
      ih_print_bl     = so_print_bl
      ih_print_pl     = so_print_pl
      ih_print_so     = so_print_so
      ih_project      = so_project
      ih_pr_list      = so_pr_list
      ih_pr_list2     = so_pr_list2
      ih_pst          = so_pst
      ih_pst_id       = so_pst_id
      ih_pst_pct      = so_pst_pct
      ih_quote        = so_quote
      ih_req_date     = so_req_date
      ih_rev          = so_rev
      ih_rmks         = so_rmks
      ih_rstk_pct     = restock-pct
      ih_sa_nbr       = so_sa_nbr
      ih_sched        = so_sched
      ih_sch_mthd     = so_sch_mthd
      ih_ship         = so_ship
      ih_shipvia      = so_shipvia
      ih_ship_date    = so_ship_date
      ih_ship_eng     = so_ship_eng
      ih_ship_po      = so_ship_po
      ih_site         = so_site
      ih_size         = so_size
      ih_size_um      = so_size_um
      ih_slspsn[1]    = so_slspsn[1]
      ih_slspsn[2]    = so_slspsn[2]
      ih_slspsn[3]    = so_slspsn[3]
      ih_slspsn[4]    = so_slspsn[4]
      ih_source       = so_source
      ih_stat         = so_stat
      ih_taxable      = so_taxable
      ih_taxc         = so_taxc
      ih_tax_date     = so_tax_date
      ih_tax_env      = so_tax_env
      ih_tax_pct[1]   = so_tax_pct[1]
      ih_tax_pct[2]   = so_tax_pct[2]
      ih_tax_pct[3]   = so_tax_pct[3]
      ih_tax_usage    = so_tax_usage
      ih_to_inv       = so_to_inv
      ih_trl1_amt     = so_trl1_amt
      ih_trl1_cd      = so_trl1_cd
      ih_trl2_amt     = so_trl2_amt
      ih_trl2_cd      = so_trl2_cd
      ih_trl3_amt     = so_trl3_amt
      ih_trl3_cd      = so_trl3_cd
      ih_type         = so_type
      ih_user1        = so_user1
      ih_user2        = so_user2
      ih_userid       = so_userid
      ih_weight       = so_weight
      ih_weight_um    = so_weight_um
      ih_xcomm_pct[1] = so_xcomm_pct[1]
      ih_xcomm_pct[2] = so_xcomm_pct[2]
      ih_xslspsn[1]   = so_xslspsn[1]
      ih_xslspsn[2]   = so_xslspsn[2]
      ih__chr01       = so__chr01
      ih__chr02       = so__chr02
      ih__chr03       = so__chr03
      ih__chr04       = so__chr04
      ih__chr05       = so__chr05
      ih__chr06       = so__chr06
      ih__chr07       = so__chr07
      ih__chr08       = so__chr08
      ih__chr09       = so__chr09
      ih__chr10       = so__chr10
      ih__dec01       = so__dec01
      ih__dec02       = so__dec02
      ih__dte01       = so__dte01
      ih__dte02       = so__dte02
      ih__log01       = so__log01
      ih__qad01       = so__qad01
      ih__qad02       = so__qad02
      ih__qad03       = so__qad03
      ih__qad04       = so__qad04
      ih__qad05[1]    = so__qad05[1]
      ih__qad05[2]    = so__qad05[2]
      ih_custref_val  = so_custref_val
      recno           = recid(ih_hist).

   if ih_inv_date = ? then
      ih_inv_date = eff_date.

   if ih_tax_date = ? then
      ih_tax_date = ih_inv_date.

   /* Copy exchange rate usage records */
   {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
             "(input  exch_exru_seq,
               output ih_exru_seq)" }

END PROCEDURE.

/* New procedure added. The reason for making an internal procedure is
 * to hide the "gory" details of gprunmo from the main code. When
 * self-billing becomes std product the invocation of internal proc
 * can be replaced with invocation to the external proc */

/*****************************************************************
Capture selfbilling info
*****************************************************************/
PROCEDURE save_selfbill_info:
   define input parameter transtype    as   character no-undo.
   define input parameter invnbr       like ar_nbr    no-undo.
   define input parameter sonbr        like so_nbr    no-undo.
   define input parameter amt          like ar_amt    no-undo.

   {gprunmo.i &module = "ASB" &program = "arsixcr2.p"
              &param  = """(input  transtype,
                            input  invnbr,
                            input  sonbr,
                            input  amt)"""}

END PROCEDURE.

PROCEDURE mark-as-posted:
   define input parameter inpar_nbr4    like so_nbr     no-undo.
   define input parameter inpar_inv_nbr like so_inv_nbr no-undo.

   if can-find(mfc_ctrl
      where mfc_domain = global_domain
      and   mfc_module = "SO"
      and   mfc_seq    = 170)
   then do:

      for each qad_wkfl
         where qad_domain = global_domain
         and   qad_key1   = inpar_nbr4
         and   r-index(qad_key2,"utsoship") > 0
         and   qad_key3   = inpar_inv_nbr
      exclusive-lock:
         qad_charfld[4] = "posted".
      end.

   end. /* multiple bol print is turned on.  */

END PROCEDURE.

PROCEDURE del-cmt-det:
   define input parameter inpar_indx like so_cmtindx no-undo.

/*zy*/ /*  so过账不删除订单且不删除订单备注       */
/*zy*/ /*   for each cmt_det                      */
/*zy*/ /*      where cmt_domain = global_domain   */
/*zy*/ /*      and   cmt_indx   = inpar_indx      */
/*zy*/ /*   exclusive-lock:                       */
/*zy*/ /*      delete cmt_det.                    */
/*zy*/ /*   end.                                  */

END PROCEDURE.

PROCEDURE del-sct-det:
   define input parameter inpar_part  like sod_part no-undo.
   define input parameter inpar_nbr1  like sod_nbr  no-undo.
   define input parameter inpar_line1 like sod_line no-undo.

   define variable var_sim            like sct_sim  no-undo.

   var_sim  = string(inpar_nbr1) + "." + string(inpar_line1).

   for each sct_det
      where sct_domain = global_domain
      and   sct_part   = inpar_part
      and   sct_sim    = var_sim
   exclusive-lock:
      delete sct_det.
   end.

END PROCEDURE.

PROCEDURE del-ied-det:
   define input parameter inpar_nbr  like sod_nbr  no-undo.
   define input parameter inpar_line like sod_line no-undo.

   for each ied_det
      where ied_domain = global_domain
      and   ied_type   = "1"
      and   ied_nbr    = inpar_nbr
      and   ied_line   = inpar_line
   exclusive-lock:
      delete ied_det.
   end.

END PROCEDURE.

PROCEDURE del-pih-hist:
   define input parameter inpar_nbr2  like sod_nbr  no-undo.
   define input parameter inpar_line2 like sod_line no-undo.

   for each pih_hist
      where pih_domain   = global_domain
      and   pih_doc_type = 1
      and   pih_nbr      = inpar_nbr2
      and   pih_line     = inpar_line2
   exclusive-lock:
      delete pih_hist.
   end.

END PROCEDURE.

PROCEDURE del-tx2d-det:
   define input parameter inpar_nbr3 like so_nbr   no-undo.
   define input parameter l_quote    like so_quote no-undo.

   define variable l_par_recid       as   recid    no-undo.
   define variable l_ref             like tx2d_ref no-undo.

   define buffer   b_abs_mstr  for  abs_mstr.

      /* ENSURE THAT ALL THE TAX RECORDS FOR SALES ORDER      */
      /* RELEASED FROM SALES QUOTE ARE CORRECTLY DELETED      */
      for each tx2d_det
         where tx2d_domain  = global_domain
         and ( tx2d_ref     = inpar_nbr3
         and ( tx2d_nbr     = ""
         or    tx2d_nbr     = l_quote)
         and ( tx2d_tr_type = "38"
         or    tx2d_tr_type = "36"
         or    tx2d_tr_type = "11") )
      exclusive-lock:
         delete tx2d_det.
      end.

      /* OBTAINING SHIPPERS AGAINST THE SALES ORDER  */
      for each abs_mstr
         fields (abs_domain abs_id abs_order abs_shipfrom )
         where abs_domain = global_domain
         and   abs_order  = inpar_nbr3
      no-lock:

         /* FIND TOP LEVEL SHIPPER */
         {gprun.i ""gpabspar.p""
                  "(input  recid(abs_mstr),
                    input  'S',
                    input  false,
                    output l_par_recid)" }

         if l_par_recid <> ? then do:

            for first b_abs_mstr
               fields (abs_domain abs_shipfrom abs_id)
               where recid(b_abs_mstr) = l_par_recid
            no-lock: end.

            if available b_abs_mstr then do:
               l_ref = string(b_abs_mstr.abs_shipfrom, "x(8)")
                     + b_abs_mstr.abs_id.

               {gprun.i ""txdelete.p""
                        "(input '14',
                          input l_ref,
                          input inpar_nbr3 )"}
            end.
         end. /* IF L_PAR_RECID <> ? */
      end. /* FOR EACH ABS_MSTR */

END PROCEDURE.

PROCEDURE create-inv-rel-history:
   /* -----------------------------------------------------------
    * Purpose:     Creates the invoice history master relationship
    *              records for each associated sor_mstr record.
    * -------------------------------------------------------------*/

   create ihr_hist.
   assign
      ihr_domain  = global_domain
      ihr_div     = sor_mstr.sor_div
      ihr_group   = sor_mstr.sor_group
      ihr_inv_nbr = so_mstr.so_inv_nbr
      ihr_nbr     = sor_mstr.sor_nbr
      ihr_pricing = sor_mstr.sor_pricing
      ihr_seq     = sor_mstr.sor_seq
      ihr_type    = sor_mstr.sor_type
      ihr_user1   = sor_mstr.sor_user1
      ihr_user2   = sor_mstr.sor_user2
      ihr__qadc01 = sor_mstr.sor__qadc01
      ihr__qadc02 = sor_mstr.sor__qadc02
      ihr__qadc03 = sor_mstr.sor__qadc03
      ihr__qadd01 = sor_mstr.sor__qadd01
      ihr__qadd02 = sor_mstr.sor__qadd02
      ihr__qadi01 = sor_mstr.sor__qadi01
      ihr__qadi02 = sor_mstr.sor__qadi02
      ihr__qadl01 = sor_mstr.sor__qadl01
      ihr__qadl02 = sor_mstr.sor__qadl02
      ihr__qadt01 = sor_mstr.sor__qadt01
      ihr__qadt02 = sor_mstr.sor__qadt02.

   if recid(ihr_hist) = -1 then .

END PROCEDURE. /* create-inv-rel-history */

PROCEDURE del-sodr-det:
   /* -----------------------------------------------------------
    * Purpose:     Delete Sales Order Detail Relationship Records
    * -------------------------------------------------------------*/

   for each sodr_det
      where sodr_domain = global_domain
      and   sodr_nbr    = sod_det.sod_nbr
      and   sodr_line   = sod_det.sod_line
   exclusive-lock:
      delete sodr_det.
   end.

END PROCEDURE.  /* del-sodr-det */

PROCEDURE del-sor-mstr:
   /* -----------------------------------------------------------
    * Purpose:     Delete Sales Order Relationship Master Records
    * -------------------------------------------------------------*/

   for each sor_mstr
      where sor_domain = global_domain
      and   sor_nbr    = so_mstr.so_nbr
   exclusive-lock:
      delete sor_mstr.
   end.

END PROCEDURE. /* del-sor-mstr */

PROCEDURE del-btb-det:
   /* -----------------------------------------------------------
    * Purpose:     Delete BTB Recordsin internal procedure to overcome
    *              action segment error.
    * -------------------------------------------------------------*/

   for each btb_det
       where btb_domain   = global_domain
       and   btb_so       = sod_det.sod_nbr
       and   btb_sod_line = sod_det.sod_line
   exclusive-lock:
      delete btb_det.
   end.

END PROCEDURE. /* del-btb-det */

PROCEDURE p-self-bill-control:
   /* -----------------------------------------------------------
    * Purpose:     AR Self-Billing internal procedure to overcome
    *              action segment error.
    * Parameters:
    *   p-so-nbr  = so_nbr     Sales Order Number
    *   p-so-inv  = so_inv_nbr Invoice Number
    *   p-so-bill = so_bill   Bill To
    * Notes:
    * -------------------------------------------------------------*/
   define input parameter p-so-nbr  like so_mstr.so_nbr     no-undo.
   define input parameter p-so-inv  like so_mstr.so_inv_nbr no-undo.
   define input parameter p-so-bill like so_mstr.so_bill    no-undo.

   if can-find (first mfc_ctrl
       where mfc_domain = global_domain
       and   mfc_field  = "enable_self_bill"
       and   mfc_module  = "ADG"
       and   mfc_logical = yes)
   then do:

      {gprunmo.i &module = "ASB" &program = "arsixup.p"
                 &param  = """(input  p-so-nbr,
                               input  p-so-inv,
                               output return_status,
                               output create_tax_trailer_line)"""}

   end. /* END OF IF CAN-FIND(FIRST mfc_ctrl)  */

   /* CHECK WHETHER SELF-BILLING INFO IS TO BE CAPTURED */
   /* THE CONDITION OF create_tax_trailer_line IS PUT   */
   /* BECAUSE IN SELF-BILLING CROSS REFERENCE RECORDS (Six_ref) */
   /* FOR SHIPMENT LINES ARE NOT CAPTURED WHEN SHIPMENT IS DONE */
   /* FOR POSTING OF SO SHIPMENTS (sosois.p). SO WE DO NOT WANT */
   /* TO CAPTURE THE TAX / TRAILER INFORMATION WHEN SHIPMENTS   */
   /* ARE DONE USING DISCRETE SHIPMENTS */

   assign
      save_sbinfo = can-find(first mfc_ctrl
         where mfc_domain  = global_domain
         and   mfc_field   = "enable_self_bill"
         and   mfc_module  = "ADG"
         and   mfc_logical = yes)
         and can-find(first cm_mstr
         where cm_domain = global_domain
         and   cm_addr   = p-so-bill
         and   cm__qad06 = yes)
         and   create_tax_trailer_line = yes
      so_db = global_db.

   if save_sbinfo then do:
      if disc_amt <> 0 then
         run save_selfbill_info
            (input "D",
             input p-so-inv,
             input p-so-nbr,
             input disc_amt).
   end.

END PROCEDURE.

/* Delete tx2d_line record */
PROCEDURE del_tx2d_13:

   define input parameter sonbr like so_nbr.

   for each tx2d_det
      where tx2d_domain  = global_domain
      and   tx2d_ref     = sonbr
      and   tx2d_nbr     = ""
      and   tx2d_tr_type = "13"
   exclusive-lock:
      delete tx2d_det.
   end.

END PROCEDURE.

PROCEDURE Update_tx2d:
   define input parameter sonbr like so_nbr.

   define variable result_status as integer no-undo.

   for each sod_det
      where sod_domain = global_domain
      and   sod_nbr = sonbr
   exclusive-lock:

      sod_qty_chg = sod_qty_ord - sod_qty_ivcd.

      {gprun.i ""txcalc.p""
               "(input  '13',
                 input  sod_nbr,
                 input  '',
                 input  sod_line,
                 input  no,
                 output result_status)"}

      sod_qty_chg = 0.

   end.

END PROCEDURE.

/* DELETE TAX LINES, CREATED ACCORDING TO TAX-BY-LINE FLAG */
PROCEDURE del_tx2d_line13:
   define input parameter soinvnbr like so_inv_nbr   no-undo.
   define input parameter sodnbr   like sod_nbr      no-undo.
   define input parameter sodline  like sod_line     no-undo.
   define input parameter trtype   like tx2d_tr_type no-undo.

   /* CHECK tx2d_line = sod_line FOR TAX-BY-LINE = YES */
   /* ON POSTING OF INVOICE ALL THE 13 TYPE OF RECORDS FOR THE SALES ORDER   */
   /* SHOULD BE DELETED AS IN CONSOLIDATION THE tx2d_nbr WILL CONTAIN        */
   /* "CONSOL" INSTEAD OF SALES ORDER NO.                                    */
   if can-find (first tx2d_det
      where tx2d_domain  = global_domain
      and   tx2d_ref     = soinvnbr
      and   tx2d_nbr     <> ""
      and   tx2d_line    <> 0
      and   tx2d_tr_type = trtype)
   then
      run del_tx2d_13
         (input sodnbr).

   /* CHECK tx2d_line = 0 FOR TAX-BY-LINE = NO         */
   else
      if can-find (first tx2d_det
         where tx2d_domain  = global_domain
         and   tx2d_ref     = soinvnbr
         and   tx2d_nbr     <> ""
         and   tx2d_line    = 0
         and   tx2d_tr_type = trtype)
      then do:
         {gprun.i ""txdelete.p""
                  "(input '13',
                    input sodnbr,
                    input '')"}
      end.

END PROCEDURE.

PROCEDURE deleteCreditCardDetails:
/* -----------------------------------------------------------
 * Purpose:     Logic for deleting creditcard details from the
 *              qad_wkfl table when salesorder line is deleted.
 * Parameters:  so_nbr, sod_line
 * -------------------------------------------------------------*/
   define input parameter orderNumber like sod_nbr.
   define input parameter orderLine   like sod_line.

   for first qad_wkfl
      where qad_domain = global_domain
      and   qad_key1   = string(orderNumber, "x(8)")
                       + string(orderLine, "999")
      and   qad_key2   = "CreditCard"
   exclusive-lock:
      /*
       * MUST UPDATE so_prepaid
       * IF A qad_wkfl
       * STILL EXISTS
      */

      for first so_mstr
         where so_domain = global_domain
         and   so_nbr    = orderNumber
      exclusive-lock:
         so_prepaid = so_prepaid - qad_decfld[1].
      end.

      delete qad_wkfl.

   end.
END PROCEDURE.

{&SOIVPSTA-P-TAG8}
