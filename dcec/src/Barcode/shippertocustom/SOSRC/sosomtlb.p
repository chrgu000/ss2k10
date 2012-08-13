/* sosomtlb.p  - SALES ORDER MAINTENANCE LINE DETAIL SUBROUTINE              */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*V8:ConvertMode=Maintenance                                                 */
/*V8:RunMode=Character,Windows                                               */
/* REVISION: 6.0      LAST MODIFIED: 01/31/91   BY: afs *D327*               */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*               */
/* REVISION: 6.0      LAST MODIFIED: 11/13/91   BY: WUG *D887*               */
/* REVISION: 7.0      LAST MODIFIED: 01/13/92   BY: afs *F042*               */
/* REVISION: 7.0      LAST MODIFIED: 02/21/92   BY: afs *F223*               */
/* REVISION: 7.0      LAST MODIFIED: 03/24/92   BY: dld *F297*               */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: afs *F356*               */
/* REVISION: 7.0      LAST MODIFIED: 04/16/92   BY: dld *F382*               */
/* REVISION: 7.0      LAST MODIFIED: 06/12/92   BY: tjs *F504*               */
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: afs *F519*               */
/* REVISION: 7.0      LAST MODIFIED: 06/26/92   BY: afs *F711*               */
/* REVISION: 7.0      LAST MODIFIED: 07/27/92   BY: tjs *F765*               */
/* REVISION: 7.0      LAST MODIFIED: 07/27/92   BY: tjs *F802*               */
/* REVISION: 7.3      LAST MODIFIED: 09/17/92   BY: tjs *G035*               */
/* REVISION: 7.3      LAST MODIFIED: 10/06/92   BY: mpp *G013*               */
/* REVISION: 7.3      LAST MODIFIED: 01/26/93   BY: bcm *G429*               */
/* REVISION: 7.3      LAST MODIFIED: 02/08/93   BY: bcm *G415*               */
/* REVISION: 7.3      LAST MODIFIED: 04/05/93   BY: bcm *G889*               */
/* REVISION: 7.3      LAST MODIFIED: 04/15/93   BY: tjs *G948*               */
/* REVISION: 7.4      LAST MODIFIED: 06/21/93   BY: pcd *H008*               */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*               */
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184*               */
/* REVISION: 7.4      LAST MODIFIED: 02/11/94   BY: dpm *FM10*               */
/* REVISION: 7.4      LAST MODIFIED: 03/18/94   BY: dpm *FM25*               */
/* REVISION: 7.4      LAST MODIFIED: 06/10/94   BY: qzl *H380*               */
/* REVISION: 7.4      LAST MODIFIED: 07/11/94   BY: bcm *H438*               */
/* REVISION: 7.4      LAST MODIFIED: 08/17/94   BY: dpm *FQ29*               */
/* REVISION: 7.4      LAST MODIFIED: 08/29/94   BY: bcm *H494*               */
/* REVISION: 7.4      LAST MODIFIED: 09/02/94   BY: dpm *FQ53*               */
/* REVISION: 7.4      LAST MODIFIED: 10/28/94   BY: dpm *FR95*               */
/* REVISION: 7.4      LAST MODIFIED: 11/07/94   BY: str *FT44*               */
/* REVISION: 7.4      LAST MODIFIED: 11/16/94   BY: qzl *FT43*               */
/* REVISION: 7.4      LAST MODIFIED: 11/21/94   BY: afs *H605*               */
/* REVISION: 7.4      LAST MODIFIED: 01/13/95   BY: dpm *F0DR*               */
/* REVISION: 7.4      LAST MODIFIED: 01/17/95   BY: srk *G0C1*               */
/* REVISION: 7.4      LAST MODIFIED: 01/31/95   BY: bcm *F0G8*               */
/* REVISION: 7.4      LAST MODIFIED: 02/23/95   BY: jzw *H0BM*               */
/* REVISION: 7.4      LAST MODIFIED: 03/06/95   BY: wjk *H0BT*               */
/* REVISION: 7.4      LAST MODIFIED: 03/09/95   BY: kjm *F0K6*               */
/* REVISION: 7.4      LAST MODIFIED: 03/31/95   BY: rxm *F0PR*               */
/* REVISION: 7.4      LAST MODIFIED: 04/17/95   BY: jpm *H0CJ*               */
/* REVISION: 8.5      LAST MODIFIED: 03/05/95   BY: DAH *J042*               */
/* REVISION: 7.4      LAST MODIFIED: 10/23/95   BY: rxm *G19G*               */
/* REVISION: 7.4      LAST MODIFIED: 11/22/95   BY: ais *H0H2*               */
/* REVISION: 8.5      LAST MODIFIED: 11/07/95   BY: taf *J053*               */
/* REVISION: 8.5      LAST MODIFIED: 12/01/95   BY: *J04C* Sue Poland        */
/* REVISION: 8.5      LAST MODIFIED: 12/04/95   BY: *J04C* Tom Vogten        */
/* REVISION: 8.6      LAST MODIFIED: 09/27/96   BY: svs *K007*               */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Elke Van Maele    */
/* REVISION: 8.6      LAST MODIFIED: 11/05/96   BY: *H0NR* Suresh Nayak      */
/* REVISION: 8.6      LAST MODIFIED: 12/31/96   BY: *K03Y* Jean Miller       */
/* REVISION: 8.6      LAST MODIFIED: 06/16/97   BY: *J1SY* Suresh Nayak      */
/* REVISION: 8.6      LAST MODIFIED: 06/25/97   BY: *K0FM* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 07/15/97   BY: *K0G6* Arul Victoria     */
/* REVISION: 8.6      LAST MODIFIED: 07/01/97   BY: *K0DH* Jim Williams      */
/* REVISION: 8.6      LAST MODIFIED: 08/06/97   BY: *J1YG* Seema Varma       */
/* REVISION: 8.6      LAST MODIFIED: 07/22/97   BY: *H1B1* Suresh Nayak      */
/* REVISION: 8.6      LAST MODIFIED: 09/09/97   BY: *H1F2* Todd Runkle       */
/* REVISION: 8.6      LAST MODIFIED: 09/29/97   BY: *K0HB* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 10/08/97   BY: *K0N5* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 11/18/97   BY: *J25B* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 12/18/97   BY: *K15N* Jerry Zhou        */
/* REVISION: 8.6      LAST MODIFIED: 01/23/98   BY: *J2BW* Nirav Parikh      */
/* REVISION: 8.6      LAST MODIFIED: 01/31/98   BY: *J2D6* Seema Varma       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 03/21/98   BY: *K1KQ* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* Old ECO marker removed, but no ECO header exists *G501*                   */
/* REVISION: 8.6E     LAST MODIFIED: 08/03/98   BY: *L024* Sami Kureishy     */
/* REVISION: 8.6E     LAST MODIFIED: 03/11/99   BY: *J3C5* Anup Pereira      */
/* REVISION: 8.6E     LAST MODIFIED: 01/19/2000 BY: *L0PY* Kedar Deherkar    */
/* REVISION: 8.6E     LAST MODIFIED: 09/25/2000 BY: *L121* Gurudev C         */
/* REVISION: 9.0      LAST MODIFIED: 12/18/00   BY: *M0TZ* Veena Lad         */
/* REVISION: 9.0      LAST MODIFIED: 02/22/01   BY: *M126* Sandeep P         */
/* REVISION: 9.0      LAST MODIFIED: 03/14/01   BY: *M13J* Sandeep P         */
/* REVISION: 9.0      LAST MODIFIED: 04/21/01   BY: *M11Z* Jean Miller       */

         /*!
            SOSOMTLB.P is called by SOSOMTLA.P to maintain data elements in the
            larger line item data entry frame in SO and RMA Maintenance.
          */

         /*!
            Input parameters are:

            this-is-rma:    Will be yes in RMA Maintenance and no in Sales
                            Order Maintenance.
            rma-recno:      When processing an RMA, this is the rma_mstr (the
                            RMA header) recid.
            rma-issue-line: When processing RMA's, this will be yes when
                            maintaining the issue (outgoing) lines, and no
                            when maintaining the receipt (incoming) lines.
                            In SO Maintenance, this will be yes.
            rmd-recno:      In RMA Maintenance, this will contain the recid
                            for rmd_det (the RMA line).  For SO Maintenance,
                            this will be ?.
            l_prev_um_conv: When the User changes the type to "M" on sales
                            Order or RMA Maintenance then the Inventory will
                            be correctly de-allocated using correct Um
          */

         {mfdeclre.i}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE sosomtlb_p_1 "RMA 收货的虚的事务类型"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtlb_p_2 "推销员 4"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtlb_p_3 "推销员 3"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtlb_p_4 "推销员 2"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosomtlb_p_5 "推销员 1"
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */

         define input parameter this-is-rma     as  logical.
         define input parameter rma-recno       as  recid.
         define input parameter rma-issue-line  as  logical.
         define input parameter rmd-recno       as  recid.
         define input parameter l_prev_um_conv  like sod_um_conv no-undo.
         define shared  variable prev_type like sod_type .

         /* DEFINE RNDMTHD FOR CALL TO GPFRLWT.P */
         define shared variable rndmthd like rnd_rnd_mthd.
         define shared variable all_days as integer.
         define shared variable clines as integer.
         define shared variable desc1 like pt_desc1.
         define shared variable line like sod_line.
         define shared variable sngl_ln like soc_ln_fmt.
         define shared variable sod_recno as recid.
         define shared variable sodcmmts like soc_lcmmts.
         define shared variable sod-detail-all like soc_det_all.
         define shared variable so_recno as recid.
         define shared variable totallqty like sod_qty_all.
         define variable old_site like sod_site.
         define variable continue like mfc_logical no-undo.
         define variable prev_qty_all like sod_qty_all no-undo.
         define variable warn like mfc_logical no-undo.
         define shared variable so_db like dc_name.
         define shared variable inv_db like dc_name.
         define shared variable undo_all2 like mfc_logical.
         define shared variable mult_slspsn like mfc_logical no-undo.
         define variable sort as character format "x(28)" extent 4 no-undo.
         define variable counter as integer no-undo.
         define shared variable new_line like mfc_logical.
         define variable tax_date like tax_effdate.
         define variable valid_acct like mfc_logical.
         define new shared variable vtclass as character extent 3.
         define buffer sod_buff for sod_det.
         define variable j as integer.
         define shared variable old_sod_site like sod_site no-undo.

         define new shared variable zone_to   like txz_tax_zone.
         define new shared variable zone_from like txz_tax_zone.
         define new shared variable tax_usage like so_tax_usage no-undo.
         define new shared variable tax_env   like so_tax_env no-undo.

         define shared variable freight_ok   like mfc_logical.
         define shared variable calc_fr      like mfc_logical.
         define shared variable disp_fr      like mfc_logical.
         define variable detqty              like sod_qty_ord.
         define shared variable soc_pc_line  like mfc_logical.
         define variable glvalid             like mfc_logical.
         define shared variable err-flag as integer.
         define shared variable sonbr like sod_nbr.
         define shared variable soline like sod_line.
/*L024*  define shared variable  exch-rate like exd_ent_rate. */
/*L024*/ define shared variable  exch-rate like exr_rate.
/*L024* /*L00Y*/ define shared variable  exch-rate2 like exd_ent_rate. */
/*L024*/ define shared variable  exch-rate2 like exr_rate2.
         define shared variable discount as decimal.
         define shared variable reprice_dtl like mfc_logical.
         define new shared      variable temp_zone like txz_tax_zone.
         define        variable rma-receipt-line   as  logical.
         define        variable frametitle         as character format "x(20)".
         /* TAX_IN IS USED BY FSRMAVAT.P */
         define shared variable new_order       like  mfc_logical.
         define shared variable tax_in          like  cm_tax_in.
/*L024*/ define variable sodstdcost like sod_std_cost no-undo.
/*L024*/ define variable mc-error-number like msg_nbr no-undo.

         /* EMT VARIABLES */
         define shared variable s-btb-so        as   logical.
         define shared variable s-sec-due       as   date.
         define        variable exp-del         as   date.
         define        variable pri-due         as   date.
         define        variable transnbr        like cmf_trans_nbr.
         define        variable prev-per-date   like sod_per_date.
         define shared variable prev-due-date   like sod_due_date.
         define shared variable po-ack-wait     as logical no-undo.
         define        variable p-edi-rollback  as logical no-undo
                                                initial no.
         define variable net_avail like sod_qty_all no-undo.
         define variable new_record as logical no-undo.

         define new shared variable l_loop_seta like mfc_logical no-undo.

/*M13J*/ define variable l_use_edi        like mfc_logical initial yes no-undo.
/*M13J*/ define variable l_update_qty_all like mfc_logical initial no  no-undo.

         {sobtbvar.i}    /* BACK TO BACK SHARED WORKFILES AND VARIABLES */

         {gptxcdec.i}    /* DECLARATIONS FOR gptxcval.i */

         /*IT WAS NECESSARY TO MOVE THIS DEFINITION OF SHARED FRAME AND */
         /*STREAM TO A LOCATION BEFORE THE DEFS OF SHARED FRAMES C AND D*/
         /*BECAUSE IT DOES NOT BEHAVE CORRECTLY IN PROGRESS v7          */
         define shared stream bi.
         define shared frame bi.
         define shared frame c.
         define shared frame d.

         /* This overlap frame bi sets the display format of those */
         /* Fields to what have been re-formatted in solinfrm.i    */
         /* FORM DEFINITION FOR HIDDEN FRAME BI */
         {sobifrm.i}

         form sod_det with frame bi width 80.

         /* THE SHARED VARIABLE current_fr_terms IS DEFINED IN pppivar.i, BUT */
         /* SINCE ONLY THIS VARIABLE IS REQUIRED, TO AVOID OVERHEADS IT HAS   */
         /* BEEN EXPLICITLY DEFINED HERE, INSTEAD OF CALLING PPPIVAR.I        */
         define shared variable current_fr_terms   like so_fr_terms.

         /*DEFINE SHARED FORMS*/
         {solinfrm.i}

         /* ENSURE NECESSARY CODE_MSTR RECORDS EXIST */
         if this-is-rma and
            not can-find(code_mstr where code_fldname = "tr_type"
            and code_value = "ISS-RMA") then do:
             create code_mstr.
             code_fldname = "tr_type".
             code_value   = "ISS-RMA".
             code_cmmt    = {&sosomtlb_p_1}.
             if recid(code_mstr) = -1 then .
         end.      /* if this-is-rma... */

         find so_mstr where recid(so_mstr) = so_recno no-lock no-error.
         find sod_det where recid(sod_det) = sod_recno no-lock no-error.
         find first soc_ctrl no-lock no-error.
         find first gl_ctrl no-lock no-error.

         rma-receipt-line = no.
         if this-is-rma then do:
            find rma_mstr where recid(rma_mstr) = rma-recno
                exclusive-lock no-error.
            find rmd_det where recid(rmd_det) = rmd-recno
                exclusive-lock no-error.
            find first rmc_ctrl no-lock no-error.
            if not rma-issue-line then
                rma-receipt-line = yes.
         end.

         old_site = input frame bi sod_site.
         if sod_site <> old_site and  new_line = no   then do:
            find si_mstr where si_site = old_site no-lock no-error.
               assign
               sonbr  = sod_nbr
               soline = sod_line .
            /* WE DON'T CREATE THE REMOTE LINES UNLESS THE LINE IS CONFIRMED */
            if si_db <> so_db and sod_confirm then do:
               {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }
               if err-flag = 0 or err-flag = 9 then do:
/*L121*           {gprun.i ""solndel.p""}  */

/*L121*/          /* ADDED INPUT PARAMETER no TO NOT EXECUTE MFSOFC01.I   */
/*L121*/          /* AND MFSOFC02.I WHEN CALLED FROM DETAIL LINE          */

/*L121*/          {gprun.i ""solndel.p""
                           "(input no)"}
               end.
               /* Reset the db alias to the sales order database */
               {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }
               sod_recno = recid(sod_det).
            end.
            else do:
               {gprun.i ""solndel1.p""}
            end.
         end.
         find si_mstr where si_site = sod_site no-lock no-error.

         /* SET SLS, DISC ACCTS BASED ON PRODUCT LINE, SITE, CUST TYPE, CHANNEL */
         find pt_mstr where pt_part = sod_part no-lock no-error.
         if available pt_mstr then pt_recno = recid(pt_mstr).
                     else pt_recno = ?.
         if new_line then do:
            {gprun.i ""soplsd.p""}
         end.

         sodcmmts = (sod_cmtindx <> 0 or (new_line and soc_lcmmts)).
         if this-is-rma and new_line then
            sodcmmts = rmc_lcmmts.
/*L024*  if sngl_ln then */
/*L024*/ if sngl_ln then do:
/*L024*/    /* Convert cost from remote base currency to local base currency */
/*L024*/    {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input  """",
                 input  base_curr,
                 input  exch-rate,
                 input  exch-rate2,
                 input  sod_std_cost,
                 input  false,
                 output sodstdcost,
                 output mc-error-number)" }
/*L024*/    if mc-error-number <> 0 then do:
/*L024*/       {mfmsg.i mc-error-number 2}
/*L024*/    end.
            display
               sod_site sod_loc sod_serial
               sod_qty_all sod_qty_pick
               sod_pricing_dt
/*L024*        sod_std_cost * exch-rate @ sod_std_cost */
/*L024*/       sodstdcost @ sod_std_cost
               sod_due_date sod_req_date sod_per_date
               sod_fr_list
               sod_acct sod_cc sod_dsc_acct sod_dsc_cc
               sod_project sod_confirm
               sod_type sod_um_conv
               sod-detail-all
               sod_taxable
               sod_taxc
               sodcmmts
            with frame d.
/*L024*/ end. /* if sngl_ln */

         seta:
         /* Prompt for rest of the line information on single line screen */
         do on error undo, retry:

            if so_tax_date <> ? then tax_date = so_tax_date.
            else if so_due_date <> ? then tax_date = so_due_date.
            else tax_date = so_ord_date.

            if sngl_ln then do:

               /* ADD EDITING TO SET GLOBAL LOC FOR LOT/SER LOOKUP */
               if new sod_det then
                  prev_qty_all = 0.
               else
                  prev_qty_all = sod_qty_all.

               assign
                  prev-per-date = sod_per_date
                  prev-due-date = sod_due_date.

               if not so_secondary and soc_use_btb then
               rollback:
               do on error undo, retry:

                  find first cm_mstr where cm_addr = so_cust no-lock no-error.

                  /* CONVERT A DATE TO A STRING VARIABLE */
                  s-cmdval = string ( sod_due_date ).

                  /* ROLL-BACK */
                  {gprun.i ""sobtbrb.p""
                           "(input recid(so_mstr),
                             input sod_line,
                             input ""pod_det"",
                             input ""pod_due_date"",
                             input p-edi-rollback,
                             output return-msg)" }

                  /* DISPLAY ERROR MESSAGE RETURN FROM SOBTBRB.P */
                  if return-msg <> 0 then do:
                     {mfmsg.i return-msg 4}
                     return-msg = 0.
                     if not batchrun then pause.
                     undo rollback, leave rollback.
                  end.

                  /* CONVERT A STRING VARIABLE TO A DATE */
                  sod_due_date = date(s-cmdval).

               end.  /* rollback */

               display sod_due_date with frame d.

/*M13J*/       for first po_mstr
/*M13J*/          fields(po_inv_mthd)
/*M13J*/          where po_nbr = sod_btb_po
/*M13J*/          no-lock:
/*M13J*/       end. /* FOR FIRST po_mstr */
/*M13J*/       if available po_mstr
/*M13J*/          and (right-trim(substring(po_inv_mthd,2,24)) = "")
/*M13J*/       then
/*M13J*/          l_use_edi = no.
/*M13J*/       if (sod_btb_type = "02"
/*M13J*/          and sod_qty_all > 0
/*M13J*/          and not l_use_edi)
/*M13J*/       then
/*M13J*/          l_update_qty_all = yes.

               /* RMA RECEIPT LINES DO NOT GET ALLOCATIONS. */
               set
                  sod_loc WHEN sod_loc <> '8888'
                  sod_serial
                  sod_qty_all     when (not rma-receipt-line)
/*M13J*        /* EMT LINES DO NOT GET ALLOCATIONS IN THE PBU */            */
/*M13J*/       /* EMT DIR-SHIP LINES DO NOT GET ALLOCATIONS IN PBU AND      */
/*M13J*/       /* EMT TRANSHIP WITH EDI LINES DO NOT GET ALLOCATIONS IN PBU */
/*M13J*                             and (not s-btb-so)                      */
/*M13J*/                            and (not s-btb-so or l_update_qty_all)
                  sod_std_cost    when (not available pt_mstr)
                  sod_comm_pct[1] when (sod_slspsn[1] <> "")
                  sod_confirm     when (sod_confirm = no or new_line)
                  sod_req_date
                  sod_per_date    when (not po-ack-wait or so_primary)
                  sod_due_date    when (not po-ack-wait or not so_primary)
                  sod_fr_list
                  sod_fix_pr
                  sod_acct sod_cc
                  sod_dsc_acct    when (new_line or reprice_dtl)
                  sod_dsc_cc      when (new_line or reprice_dtl)
                  sod_project
                  sod_type        when (sod_qty_inv = 0 and
                                        sod_qty_ship = 0 and
                                        sod_type = "")
/*K1KQ*/          sod_um_conv     when (sod_btb_type = "01")

                  /* RMA RECEIPT LINES DO NOT GET TO CONSUME FORECAST */
                  /* NOR DO THEY GET ALLOCATIONS */
                  sod_consume     when (not rma-receipt-line)
                  sod-detail-all  when (not rma-receipt-line)
                  /* DETAIL ALLOCATIONS ARE NOT ALLOWED ON BTB SO LINES */
                                  and  (not s-btb-so)
                  sod_taxable
                  sod_taxc
                  sodcmmts
               with frame d editing:

                  if frame-field = "sod_serial" and
                       input sod_loc <> global_loc then
                       global_loc = input sod_loc.
                   readkey.
                   apply lastkey.
               end. /* END EDITING */

               /* FOR RMA RECEIPT LINES, BECAUSE WE'RE EXPECTING     */
               /* TO RECEIVE THESE ITEMS INTO THE SPECIFIED SITE     */
               /* LOC, BE SURE IT'S VALID.                           */
               if this-is-rma and not rma-issue-line then do:
                    /* SOD_SITE IS SCHEMA-VALIDATED */
                    find si_mstr where si_site = sod_site no-lock no-error.
                    if  not can-find(loc_mstr
                       where loc_site  = sod_site
                       and   loc_loc   = sod_loc)
                    then do:
                      /* WARN USER OF MISSING LOC IF AUTOLOCATIONS FOR SITE */
                      if si_auto_loc then do:
                         {mfmsg.i 229 2}
                         /* LOCATION MASTER DOES NOT EXIST */
                      end.
                      /* IF SITE DOESN'T HAVE AUTOLOCATIONS, GIVE ERROR */
                      else do:
                         {mfmsg.i 229 3}
                         next-prompt sod_loc with frame d.
                         undo, retry.
                      end.
                    end.     /* if not can-find loc_mstr */
                    else do:

                    /* ENSURE THIS SITE/LOCATION VALID FOR ISS-RMA */
                     find loc_mstr where loc_site = sod_site
                        and loc_loc = sod_loc
                        no-lock no-error.

                     find ld_det where ld_site = sod_site
                        and ld_loc = sod_loc
                        and ld_lot = sod_serial
                        and ld_ref = string(sod_ref)
                        and ld_part = sod_part
                        no-lock no-error.

                     if can-find(isd_det where isd_tr_type = "ISS-RMA"
                        and isd_status =
                            (if available ld_det then ld_status else
                                if available loc_mstr then loc_status else
                                si_status)) then do:
                                /* RESTRICTED TRANSACTION FOR STATUS CODE: */
                                    {mfmsg02.i 373 3
                                        "if available ld_det then ld_status
                                        else
                                        if available loc_mstr then loc_status
                                        else si_status"}
                                    if sngl_ln then next-prompt sod_loc
                                        with frame d.
                                    undo, retry.
                                end.
                    end.  /* else can-find loc_mstr, do */
               end.  /* if this-is-rma and ... */

               continue = yes.
               warn = no.

               find si_mstr where si_site = sod_site no-lock no-error.
               if si_db <> so_db then do:
                 {gprun.i ""gpalias2.p"" "(sod_site,output err-flag)" }
               end.

               if err-flag = 0 or err-flag = 9 then do:
                  if soc_all_avl and sod_qty_all > 0
                     and sod_type = ""
                  then do:
                     assign new_record = new sod_det.

/*J3C5*/             /* CONVERTED THIRD PARAMETER PREV_QTY_ALL AND FOURTH */
/*J3C5*/             /* PARAMETER SOD_QTY_ALL TO INVENTORY UM             */
                     {gprun.i ""soallchk.p""
                              "(sod_part,
                                sod_site,
                                prev_qty_all * l_prev_um_conv,
                                sod_qty_all * sod_um_conv,
                                new_record,
                                output warn,
                                output net_avail)" }

                  end. /* if soc_all_avl */
               end. /* if err-flag */

               if si_db <> so_db then do:
                 {gprun.i ""gpalias3.p"" "(so_db,output err-flag)" }
               end.  /* if si_db <> so_db */

               if warn then do:
                  /* QTY AVAILABLE FOR ITEM */
                  {mfmsg02.i 237 2
                     " sod_part + "": "" + string(net_avail) "}
/*M126*/          if not batchrun
/*M126*/          then do:
                     /* DO YOU WISH TO CONTINUE? */
                     {mfmsg01.i 7734 2 continue}
/*M126*/          end. /* IF NOT BATCHRUN */
                  next-prompt sod_qty_all with frame d.
                  if not continue then do:
                     hide message.
                     undo, retry.
                  end.
                  else hide message.
               end.

               /* Allow only zero or positive quantity for allocation */
               if sod_qty_all < 0 then do:
                    {mfmsg.i 6230 3} /* Qty allocated  cannot be < 0 */
                    next-prompt sod_qty_all  with frame d.
                    undo, retry.
               end.

               /* Allow allocations only for confirmed lines */
               if sod_qty_all <> 0 and not sod_confirm then do:
                    {mfmsg.i 688 3}  /* Allocs not allowed for unconfirmed lines */
                    next-prompt sod_confirm with frame d.
                    undo, retry.
               end.

               /* VALIDATE THE AVAILABILITY OF THE REMOTE DATABASE */
               if sod_confirm and global_db <> "" then do:
                    find si_mstr where si_site = sod_site no-lock no-error.
                    if not connected(si_db) then do:
                        {mfmsg.i 2505 3}
                        next-prompt sod_confirm with frame d.
                        undo, retry.
                    end.
               end.

               /* MULTI EMT DO NOT ALLOW DATE CHANGE AT THE SBU */
               if so_secondary and not new_line
               and sod_per_date <> prev-per-date
               and (sod_btb_type = "03" or sod_btb_type = "02") then do:
                  {mfmsg.i 2825 3}  /* NO CHANGE IS ALLOWED ON EMT SO */
                  next-prompt sod_per_date with frame d.
                  undo, retry.
               end.

               if so_secondary and not new_line
               and sod_due_date <> prev-due-date
               and (sod_btb_type = "03" or sod_btb_type = "02") then do:
                  {mfmsg.i 2825 3}    /* NO CHANGE IS ALLOWED ON EMT SO */
                  next-prompt sod_due_date with frame d.
                  undo, retry.
               end.

               /* VALIDATE FREIGHT LIST */
               if sod_fr_list <> "" then do:
                    find fr_mstr where
                         fr_list = sod_fr_list and
                         fr_site = sod_site and
                         fr_curr = so_curr
                    no-lock no-error.
                    if not available fr_mstr then
                        find fr_mstr where
                             fr_list = sod_fr_list and
                             fr_site = sod_site and
                             fr_curr = base_curr
                        no-lock no-error.
                    if not available fr_mstr then do:
                        /* FREIGHT LIST # NOT FOUND FOR SITE # CURRENCY */
                        {mfmsg03.i 670 4 sod_fr_list sod_site so_curr}
                        next-prompt sod_fr_list with frame d.
                        undo, retry.
                    end.
               end.     /* if sod_fr_list <> "" */

               {gpglver1.i &acc = sod_acct
                     &sub = ?
                     &cc  = sod_cc
                     &frame = d}
               {gpglver1.i &acc = sod_dsc_acct
                     &sub = ?
                     &cc  = sod_dsc_cc
                     &frame = d}

               if so_curr <> base_curr then do:
                    find ac_mstr where
                        ac_code = substring(sod_acct,1,(8 - global_sub_len))
                        no-lock no-error.
                    if available ac_mstr and ac_curr <> so_curr
                                 and ac_curr <> base_curr then do:
                        {mfmsg.i 134 3}
                        /*ACCT CURR MUST EITHER BE TRANS OR BASE CURR*/
                        next-prompt sod_acct with frame d.
                        undo, retry.
                    end.
                    find ac_mstr where
                        ac_code = substring(sod_dsc_acct,1,(8 - global_sub_len))
                        no-lock no-error.
                    if available ac_mstr and ac_curr <> so_curr
                                 and ac_curr <> base_curr then do:
                        {mfmsg.i 134 3}
                        /*ACCT CURR MUST EITHER BE TRANS OR BASE CURR*/
                        next-prompt sod_dsc_acct with frame d.
                        undo, retry.
                    end.
               end.

               /* VALIDATE TAXABLE AND TAXCODE*/

               {gptxcval.i &code=sod_taxc &taxable=sod_taxable &date=tax_date
                &frame="d"}

               /* VALIDATE FEWER THAN 4 TAX CLASSES */
               if gl_vat or gl_can then do:
                    {gpvatchk.i &counter = j   &buffer = sod_buff  &ref = so_nbr
                     &buffref = sod_nbr        &file = sod_det     &taxc = sod_taxc
                     &frame = d                &undo_yn = true     &undo_label = seta}
               end.

               /* FOLLOWING TESTS NOT NEEDED FOR RMA RECEIPT LINES BECAUSE */
               /* ALLOCATIONS ON THEM WILL ALWAYS BE ZERO.                 */
               /* VALIDATE IF QTY ORD > 0 */
               if sod_qty_ord >= 0 and
                   sod_qty_ord < sod_qty_all + sod_qty_pick + sod_qty_ship
                   and not sod_sched
                   and not rma-receipt-line
                   /* ALLOCATIONS ON BTB SO LINES ARE ZERO */
                   and not s-btb-so
               then do:
                   repeat:
                       {mfmsg.i 4999 3}
                       /* Ord qty cannot be < alloc+pick+ship */
                       update sod_qty_all with frame d.
                       continue = yes.
                       warn = no.

                       find si_mstr where si_site = sod_site no-lock no-error.
                       if si_db <> so_db then do:
                          {gprun.i ""gpalias2.p"" "(sod_site,output err-flag)" }
                       end.

                       if err-flag = 0 or err-flag = 9 then do:
                          if soc_all_avl and sod_qty_all > 0
                             and sod_type = ""
                          then do:
                             assign new_record = new sod_det.

/*J3C5*/                     /* CONVERTED THIRD PARAMETER PREV_QTY_ALL AND   */
/*J3C5*/                     /* FOURTH PARAMETER SOD_QTY_ALL TO INVENTORY UM */
                             {gprun.i ""soallchk.p""
                                      "(sod_part,
                                        sod_site,
                                        prev_qty_all * l_prev_um_conv,
                                        sod_qty_all * sod_um_conv,
                                        new_record,
                                        output warn,
                                        output net_avail)" }

                          end. /* if soc_all_avl */
                       end. /* if err-flag */

                       if si_db <> so_db then do:
                          {gprun.i ""gpalias3.p"" "(so_db,output err-flag)" }
                       end.  /* if si_db <> so_db */

                       if warn then do:
                          /* QTY AVAILABLE FOR ITEM */
                          {mfmsg02.i 237 2
                           " sod_part + "": "" + string(net_avail) "}
/*M126*/                  if not batchrun
/*M126*/                  then do:
                             /* DO YOU WISH TO CONTINUE? */
                             {mfmsg01.i 7734 2 continue}
/*M126*/                  end. /* IF NOT BATCHRUN */
                          if not continue then
                             undo, retry.
                       end.    /* if warn */

                       if sod_qty_all < 0 then do:
                            {mfmsg.i 6230 3}
                            /* Qty allocated  cannot be < 0 */
                            next-prompt sod_qty_all  with frame d.
                            undo, retry.
                       end.
                       if sod_qty_ord >= sod_qty_all + sod_qty_pick + sod_qty_ship
                       then leave.
                   end.    /* repeat */
                   if keyfunction(lastkey) = "end-error" then undo, retry.
                end.   /* if sod_qty_ord >= 0 ... */

               /* FOLLOWING TESTS NOT NEEDED FOR RMA RECEIPT LINES BECAUSE */
               /* ALLOCATIONS ON THEM WILL ALWAYS BE ZERO.                 */
               /* VALIDATE IF QTY ORD < 0                                  */

                if sod_qty_ord < 0
                and not sod_sched
                and not rma-receipt-line
                then do:
                   repeat on error undo, retry:

                      if (sod_qty_all<> 0 or sod_qty_ship > 0 or
                  sod_qty_pick > 0)
                      then do:
                         /* ORD QTY CANNOT BE < ALLOC+PICK+SHIP */
                         {mfmsg.i 4999 3}
                         update sod_qty_all with frame d.
                      end.
                      else leave.

                   end. /* END OF REPEAT ON ERROR, UNDO RETRY */
               if keyfunction(lastkey) = "end-error" then undo, retry.
                end. /* END OF IF sod_qty_ord < 0  */

                /* Update commission percentages if there are multiple salespersons. */
                if mult_slspsn
                   and sngl_ln then set_comm:
                do on error undo, retry on endkey undo, leave seta:
                    form
                        sod_slspsn[1]     colon 15 label {&sosomtlb_p_5}
                        sod_comm_pct[1]   colon 26 no-label
                        sort[1]           colon 35 no-label
                        sod_slspsn[2]     colon 15 label {&sosomtlb_p_4}
                        sod_comm_pct[2]   colon 26 no-label
                        sort[2]           colon 35 no-label
                        sod_slspsn[3]     colon 15 label {&sosomtlb_p_3}
                        sod_comm_pct[3]   colon 26 no-label
                        sort[3]           colon 35 no-label
                        sod_slspsn[4]     colon 15 label {&sosomtlb_p_2}
                        sod_comm_pct[4]   colon 26 no-label
                        sort[4]           colon 35 no-label
                    with frame set_comm overlay side-labels
                    centered row 16 width 66.
                    sort = "".
                    do counter = 1 to 4:
                        find sp_mstr where sp_addr = sod_slspsn[counter]
                        no-lock no-error.
                        if available sp_mstr then
                            sort[counter] = sp_sort.
                    end.
                    display sod_slspsn
                            sod_comm_pct
                            sort
                    with frame set_comm.
                    update sod_comm_pct with frame set_comm.
                    hide frame set_comm no-pause.
                end.

                /* FREIGHT WEIGHTS */
                if sod_fr_list <> "" then do:
                    set_wt:
                    do on error undo, retry:
                        freight_ok = yes.
                        if sngl_ln and (calc_fr or disp_fr) then do:
                            detqty = sod_qty_ord - sod_qty_ship.

                            /* ASSIGN so_fr_terms WITH THE FREIGHT TERMS FROM */
                            /* THE BEST PRICING ROUTINE TO PREVENT ANY ERROR  */
                            /* OR WARNING MESSAGES FROM BEING DISPLAYED AT    */
                            /* THE LINE LEVEL                                 */
/*M0TZ**                    if current_fr_terms <> "" then */
/*M0TZ*/                    if current_fr_terms <> ""
/*M0TZ*/                       and so_fr_terms  =  ""
/*M0TZ*/                    then
                               so_fr_terms = current_fr_terms.

                  /* IF IT IS A VALID DATE, USE THE DUE DATE.  OTHERWISE, USE */
                  /* THE CURRENT DATE.                                        */
/*L00Y*/                    /* ADDED SECOND EXCHANGE RATE BELOW */
                            {gprun.i ""gpfrlwt.p""
                                        "(input so_curr,
                                          input so_ex_rate,
                                          input so_ex_rate2,
                                          input so_fr_min_wt, input so_fr_terms,
                                          input so_ship,
                                          if sod_due_date <> ?
                                          then sod_due_date
                                          else today,
                                          input sod_fr_list, input sod_part,
                                          input detqty, input sod_site,
                                          input sod_type, input sod_um,
                                          input calc_fr,
                                          input disp_fr,
                                          input-output sod_fr_wt,
                                          input-output sod_fr_wt_um,
                                          input-output sod_fr_class,
                                          input-output sod_fr_chg,
                                          input-output freight_ok)"}
                        end.    /* if sngl_ln and... */
                        if not freight_ok then
                        do:
                    /* FREIGHT ERROR DETECTED - CHARGES MAY BE INCOMPLETE */
                            {mfmsg.i 669 2}
                            pause.
                            undo set_wt, leave set_wt.
                        end.
                    end.
                end.    /* if sod_fr_lst <> "" */

                /* Determine total quantity allocated */
                {gprun.i ""gpalias3.p"" "( si_db, output err-flag)" }
                if err-flag = 0 or err-flag = 9 then do:
                    {gprun.i ""soladqty.p"" "(sod_nbr, sod_line,
                                          sod_um_conv, output totallqty )"}
                end.
                {gprun.i ""gpalias3.p"" "(so_db, output err-flag)"}

               if (sod-detail-all or sod_qty_ord entered
                and totallqty <> 0 )
                and (sod_qty_all > 0
                or (sod_qty_all = 0 and input frame bi sod_qty_all > 0))
                and sod_type = "" then do:
                   /* DO DETAIL ALLOCATIONS */
                   {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }
                   if err-flag = 0 or err-flag = 9 then do:
                       {gprun.i ""solcal1.p"" "( input sod_site, input sod_nbr,
                             input sod_line , input sod_part,
                             input sod_um_conv , input sod_loc,
                             input sod_serial, input sod_qty_ord ,
                             input sod_qty_all, input sod_qty_pick,
                             input sod_qty_ship, input sod_due_date,
                             input-output totallqty )"}
                   end.
                   {gprun.i ""gpalias3.p"" "(so_db, output err-flag)"}
               end.    /* if sod-detail-all or... */

/*M13J**       if sod_qty_all < totallqty then sod_qty_all = totallqty. */
/*M13J*/       if sod_qty_all < totallqty
/*M13J*/          and not l_update_qty_all
/*M13J*/       then
/*M13J*/          sod_qty_all = totallqty.

               /* GET TAX MANAGEMENT DATA */
               {gprun.i ""sosomtlc.p"" "(input this-is-rma)"}
               if not l_loop_seta then leave seta.

            end.    /* if sngl_ln */
            else do: /* multi line */

                {gptxcval.i &code=sod_taxc &taxable=sod_taxable &date=tax_date
                   &frame="NO-FRAME"}
                /* Validate accounts and cost centers as they don't get validated */
                /* In multi line format */
                {gprun.i ""gpglver.p"" "(input sod_acct, input sod_cc,
                                                     output glvalid)" }
                if glvalid = no then  undo seta , leave.
                {gprun.i ""gpglver.p"" "(input sod_dsc_acct, input sod_dsc_cc,
                                                         output glvalid)" }
                if glvalid = no then  undo seta , leave.

                if so_curr <> base_curr then do:
                    find ac_mstr where
                        ac_code = substring(sod_acct,1,(8 - global_sub_len))
                        no-lock no-error.
                    if available ac_mstr and ac_curr <> so_curr
                                    and ac_curr <> base_curr then do:
                        {mfmsg.i 134 3}
                        /*ACCT CURR MUST EITHER BE TRANS OR BASE CURR*/
                        undo seta, leave.
                    end.
                    find ac_mstr where
                        ac_code = substring(sod_dsc_acct,1,(8 - global_sub_len))
                        no-lock no-error.
                    if available ac_mstr and ac_curr <> so_curr
                                    and ac_curr <> base_curr then do:
                        {mfmsg.i 134 3}
                        /*ACCT CURR MUST EITHER BE TRANS OR BASE CURR*/
                        undo seta, leave.
                    end.
                end.    /* if so_curr <> base_curr */

                /* VALIDATE IF QTY ORD > 0 */

                if ((sod_qty_ord >= 0 and sod_qty_ord < sod_qty_all
                     + sod_qty_pick + sod_qty_ship)
                   or (sod_qty_ord < 0 and
                      (sod_qty_all <>0 or sod_qty_pick >0 or sod_qty_ship > 0))
                   and not sod_sched)
                then do:
                    {mfmsg.i 4999 3} /* Ord qty cannot be < alloc+pick+ship */
                    undo seta, leave.
                end.
            end. /* multi line */

            /* FOR RMA'S, UPDATE RMD_DET SPECIFIC DATA ELEMENTS.  */
            /* IF THIS ISN'T SINGLE-LINE MODE, FSRMALIN.P WILL    */
            /* NOT GIVE THE USER A POPUP WINDOW...                */
            if this-is-rma then do:
                {gprun.i ""fsrmalin.p""
                     "(input rma-issue-line,
                      input new_line,
                      input rma-recno,
                      input rmd-recno,
                      input sod_recno,
                      input tax_in,
                      input so_db)"}
            end.

            /* SECUNDARY SO */
            /* VALIDATE MODIFICATION OF SOD_DUE_DATE                   */

            if so_secondary and not new_line
            and sod_per_date <> prev-per-date then do:

               /* TRANSMIT CHANGES ON SECUNDARY SO TO PRIMARY PO AND SO */
               {gprun.i ""sosobtb2.p""
                        "(input recid(sod_det),
                          input ""sod_per_date"",
                          input string(prev-per-date) ,
                          output return-msg)"}

               /* DISPLAY ERROR MESSAGE RETURN FROM SOSOBTB2.P */
               if return-msg <> 0 then do:
                  {mfmsg.i return-msg 3}
                  if not batchrun then pause.
                  undo seta, retry seta.
               end.

            end. /* not so_primary and change of sod_due_date */

            /* PRIMARY SO */
            /* CALCULATE DUE DATE WHEN CHANGING SOD_REQ_DATE OR AT CREATION */
            if    s-btb-so and not so_secondary
            and (new_line or sod_due_date <> prev-due-date)
/*L0PY*/    and soc_due_calc
            then do:

               {gprun.i ""sodueclc.p""
                        "(input sod_due_date,
                          input sod_part,
                          input so_cust,
                          input sod_btb_type,
                          input sod_site,
                          output s-sec-due,
                          output pri-due,
                          output exp-del,
                          input yes)" }

               if keyfunction(lastkey) = "end-error" then
                  undo seta, retry seta.

               assign sod_per_date = exp-del
                  sod_exp_del = exp-del
                  sod_due_date = pri-due.

            end. /* due date calculation */

            /* Delete allocations if the ship_type is not blank */
            if sod_type <> "" and (prev_type <> sod_type) then do:
                {gprun.i ""gpalias3.p"" "( si_db, output err-flag)" }
                if err-flag = 0 or err-flag = 9 then do:

                   /* ADDITIONAL PARAMETERS prev_qty_all old_sod_site       */
                   /* l_prev_um_conv PASSED TO SOLADDEL.P SO THAT INVENTORY */
                   /* WILL BE CORRECTLY DE-ALLOCATED WHEN THE SHIP TYPE IS  */
                   /* CHANGED TO "M" ON EXISTING SALES ORDERS.              */

                   {gprun.i ""soladdel.p"" "(sod_nbr, sod_line,
                   prev_qty_all, old_sod_site, l_prev_um_conv)"}

                end.
                {gprun.i ""gpalias3.p"" "(so_db, output err-flag)"}
            end.
            undo_all2 = false.
         end. /* seta: set up for update block */

         hide frame set_comm no-pause.
