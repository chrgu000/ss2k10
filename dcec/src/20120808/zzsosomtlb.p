/* GUI CONVERTED from sosomtlb.p (converter v1.69) Tue Sep  9 11:32:09 1997 */
/* sosomtlb.p  - SALES ORDER MAINTENANCE LINE DETAIL SUBROUTINE         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*H0CJ*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 01/31/91   BY: afs *D327*          */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*          */
/* REVISION: 6.0      LAST MODIFIED: 11/13/91   BY: WUG *D887*          */
/* REVISION: 7.0      LAST MODIFIED: 01/13/92   BY: afs *F042*          */
/* REVISION: 7.0      LAST MODIFIED: 02/21/92   BY: afs *F223*          */
/* REVISION: 7.0      LAST MODIFIED: 03/24/92   BY: dld *F297*          */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: afs *F356*          */
/* REVISION: 7.0      LAST MODIFIED: 04/16/92   BY: dld *F382*          */
/* REVISION: 7.0      LAST MODIFIED: 06/12/92   BY: tjs *F504*          */
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: afs *F519*          */
/* REVISION: 7.0      LAST MODIFIED: 06/26/92   BY: afs *F711*          */
/* REVISION: 7.0      LAST MODIFIED: 07/27/92   BY: tjs *F765*          */
/* REVISION: 7.0      LAST MODIFIED: 07/27/92   BY: tjs *F802*          */
/* REVISION: 7.3      LAST MODIFIED: 09/17/92   BY: tjs *G035*          */
/* REVISION: 7.3      LAST MODIFIED: 10/06/92   BY: mpp *G013*          */
/* REVISION: 7.3      LAST MODIFIED: 01/26/93   BY: bcm *G429*          */
/* REVISION: 7.3      LAST MODIFIED: 02/08/93   BY: bcm *G415*          */
/* REVISION: 7.3      LAST MODIFIED: 04/05/93   BY: bcm *G889*          */
/* REVISION: 7.3      LAST MODIFIED: 04/15/93   BY: tjs *G948*          */
/* REVISION: 7.4      LAST MODIFIED: 06/21/93   BY: pcd *H008*          */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*          */
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184*          */
/* REVISION: 7.4      LAST MODIFIED: 02/11/94   BY: dpm *FM10*          */
/* REVISION: 7.4      LAST MODIFIED: 03/18/94   BY: dpm *FM25*          */
/* REVISION: 7.4      LAST MODIFIED: 06/10/94   BY: qzl *H380*          */
/* REVISION: 7.4      LAST MODIFIED: 07/11/94   BY: bcm *H438*          */
/* REVISION: 7.4      LAST MODIFIED: 08/17/94   BY: dpm *FQ29*          */
/* REVISION: 7.4      LAST MODIFIED: 08/29/94   BY: bcm *H494*          */
/* REVISION: 7.4      LAST MODIFIED: 09/02/94   BY: dpm *FQ53*          */
/* REVISION: 7.4      LAST MODIFIED: 10/28/94   BY: dpm *FR95*          */
/* REVISION: 7.4      LAST MODIFIED: 11/07/94   BY: str *FT44*          */
/* REVISION: 7.4      LAST MODIFIED: 11/16/94   BY: qzl *FT43*          */
/* REVISION: 7.4      LAST MODIFIED: 11/21/94   BY: afs *H605*          */
/* REVISION: 7.4      LAST MODIFIED: 01/13/95   BY: dpm *F0DR*          */
/* REVISION: 7.4      LAST MODIFIED: 01/17/95   BY: srk *G0C1*          */
/* REVISION: 7.4      LAST MODIFIED: 01/31/95   BY: bcm *F0G8*          */
/* REVISION: 7.4      LAST MODIFIED: 02/23/95   BY: jzw *H0BM*          */
/* REVISION: 7.4      LAST MODIFIED: 03/06/95   BY: wjk *H0BT*          */
/* REVISION: 7.4      LAST MODIFIED: 03/09/95   BY: kjm *F0K6*          */
/* REVISION: 7.4      LAST MODIFIED: 03/31/95   BY: rxm *F0PR*          */
/* REVISION: 7.4      LAST MODIFIED: 04/17/95   BY: jpm *H0CJ*          */
/* REVISION: 8.5      LAST MODIFIED: 03/05/95   BY: DAH *J042*          */
/* REVISION: 7.4      LAST MODIFIED: 10/23/95   BY: rxm *G19G*          */
/* REVISION: 7.4      LAST MODIFIED: 11/22/95   BY: ais *H0H2*          */
/* REVISION: 8.5      LAST MODIFIED: 11/07/95   BY: taf *J053*          */
/* REVISION: 8.5      LAST MODIFIED: 12/01/95   BY: *J04C* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 12/04/95   BY: *J04C* Tom Vogten   */
/* REVISION: 8.5      LAST MODIFIED: 11/05/96   BY: *H0NR* Suresh Nayak */
/* REVISION: 8.5      LAST MODIFIED: 06/16/97   BY: *J1SY* Suresh Nayak */
/* REVISION: 8.5      LAST MODIFIED: 08/06/97   BY: *J1YG* Seema Varma  */
/* REVISION: 8.5      LAST MODIFIED: 08/22/97   BY: *H1B1* Suresh Nayak */
/* REVISION: 8.5      LAST MODIFIED: 09/09/97   BY: *H1F2* Todd Runkle  */
/* REVISION: 8.5      LAST MODIFIED: 11/14/03   BY: *LB01* Long Bo         */
/*!

    SOSOMTLB.P is called by SOSOMTLA.P to maintain data elements in the
    larger line item data entry frame in SO and RMA Maintenance.
*/
/*!
    Input parameters are:

    this-is-rma: Will be yes in RMA Maintenance and no in
                 Sales Order Maintenance.
    rma-recno  : When processing an RMA, this is the rma_mstr
                 (the RMA header) recid.
    rma-issue-line:  When processing RMA's, this will be yes
                 when maintaining the issue (outgoing) lines, and
                 no when maintaining the receipt (incoming) lines.
                 In SO Maintenance, this will be yes.
    rmd-recno  : In RMA Maintenance, this will contain the recid
                 for rmd_det (the RMA line).  For SO Maintenance,
                 this will be ?.
   l_prev_um_conv: when the User changes the type to "M" on sales Order or
           RMA Maintenance then the Inventory will be correctly
           de-allocated using correct Um
*/
/*H1B1*/ /* ADDED INPUT PARAMETER l_prev_um_conv . */

         {mfdeclre.i}
/*J04C*/ define input parameter this-is-rma     like mfc_logical.
/*J04C*/ define input parameter rma-recno       as  recid.
/*J04C*/ define input parameter rma-issue-line  like mfc_logical.
/*J04C*/ define input parameter rmd-recno       as  recid.
/*H1B1*/ define input parameter l_prev_um_conv  like sod_um_conv no-undo.
/*H1B1*/ define shared  variable prev_type like sod_type .

/*J053*/ /* DEFINE RNDMTHD FOR CALL TO GPFRLWT.P */
/*J053*/ define shared variable rndmthd like rnd_rnd_mthd.
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
/*G19G*/ define variable continue like mfc_logical no-undo.
/*G19G*/ define variable prev_qty_all like sod_qty_all no-undo.
/*G19G*/ define variable warn like mfc_logical no-undo.
/*F040*/ define shared variable so_db like dc_name.
/*F040*/ define shared variable inv_db like dc_name.
/*F040*/ define shared variable undo_all2 like mfc_logical.
/*F297*/ define shared variable mult_slspsn like mfc_logical no-undo.
/*F297*/ define variable sort as character format "x(28)" extent 4 no-undo.
/*F297*/ define variable counter as integer no-undo.
/*F519*/ define shared variable new_line like mfc_logical.
/*F765*/ define variable tax_date like tax_effdate.
/*G013*/ define variable valid_acct like mfc_logical.
/*G889*/ define new shared variable vtclass as character extent 3.
/*G889*/ define buffer sod_buff for sod_det.
/*G889*/ define variable j as integer.
/*H008*/ define shared variable old_sod_site like sod_site no-undo.

/*H0NR**
* /*H008*/ define variable zone_to             like txz_tax_zone.
* /*H008*/ define variable zone_from           like txz_tax_zone.
* /*H008*/ define variable tax_usage           like so_tax_usage no-undo.
* /*H008*/ define variable tax_env             like so_tax_env no-undo.
*H0NR**/

/*H0NR*/ define new shared variable zone_to   like txz_tax_zone.
/*H0NR*/ define new shared variable zone_from like txz_tax_zone.
/*H0NR*/ define new shared variable tax_usage like so_tax_usage no-undo.
/*H0NR*/ define new shared variable tax_env   like so_tax_env no-undo.

/*H049*/ define shared variable freight_ok   like mfc_logical.
/*H049*/ define shared variable calc_fr      like mfc_logical.
/*H049*/ define shared variable disp_fr      like mfc_logical.
/*H049*/ define variable detqty              like sod_qty_ord.
/*H184*/ define shared variable soc_pc_line  like mfc_logical.
/*FM10*/ define variable glvalid             like mfc_logical.
/*FQ53*/ define shared variable err-flag as integer.
/*FQ53*/ define shared variable sonbr like sod_nbr.
/*FQ53*/ define shared variable soline like sod_line.
/*F0DR*/ define shared variable  exch-rate like exd_ent_rate.
/*J042*/ define shared variable discount as decimal.
/*J042*/ define shared variable reprice_dtl like mfc_logical.
/*H0NR** /*J04C*/ define        variable temp_zone like txz_tax_zone. */
/*H0NR*/ define new shared      variable temp_zone like txz_tax_zone.
/*J04C*/ define        variable rma-receipt-line   like mfc_logical.
/*J04C*/ define        variable frametitle         as character format "x(20)".
         /* TAX_IN IS USED BY FSRMAVAT.P */
/*J04C*/ define shared variable tax_in          like  cm_tax_in.
/*H0NR*/ define new shared variable l_loop_seta like mfc_logical no-undo.

/*G429*/    {gptxcdec.i}    /* DECLARATIONS FOR gptxcval.i */


/*G0C1*/ /*IT WAS NECESSARY TO MOVE THIS DEFINITION OF SHARED FRAME AND */
/*G0C1*/ /*STREAM TO A LOCATION BEFORE THE DEFS OF SHARED FRAMES C AND D*/
/*G0C1*/ /*BECAUSE IT DOES NOT BEHAVE CORRECTLY IN PROGRESS v7          */
/*G0C1*/ define shared stream bi.
/*G0C1*/ define shared frame bi.
         define shared frame c.
         define shared frame d.
/*G0C1* *F504* define shared stream bi. */
/*G0C1* *F504* define shared frame bi. */
/*FT43*/ /* This overlap frame bi sets the display format of those */
/*FT43*/ /* fields to what have been re-formatted in solinfrm.i    */
/*FT43*/ FORM /*GUI*/ 
/*FT43*/    sod_qty_ord                    format "->>>>,>>9.9<<<<"
/*FT43*/    sod_list_pr                    format ">>>,>>>,>>9.99<<<"
/*FT43*/    sod_disc_pct label "折扣%"     format "->>>>9.99"
/*FT43*/ with frame bi width 80 THREE-D /*GUI*/.

/*F504*/ FORM /*GUI*/  sod_det with frame bi width 80 THREE-D /*GUI*/.


/*J1YG*/ /* THE SHARED VARIABLE current_fr_terms IS DEFINED IN pppivar.i, BUT */
/*J1YG*/ /* SINCE ONLY THIS VARIABLE IS REQUIRED, TO AVOID OVERHEADS IT HAS   */
/*J1YG*/ /* BEEN EXPLICITLY DEFINED HERE, INSTEAD OF CALLING PPPIVAR.I        */
/*J1YG*/ define shared variable current_fr_terms   like so_fr_terms.

         /*DEFINE SHARED FORMS*/
/*LB01*/ {zzsolinfrm.i}

/*H0NR** FOLLOWING SECTION COMMENTED AND MOVED TO PROGRAM sosomtlc.p **
* /*G415**** BEGIN ADD ******/
*     /* DEFINE OTHER FORMS */
*     form
*         sod_tax_usage   colon 25
* /*H008*/   /* sod_taxc        colon 25 */
*         sod_tax_env     colon 25
* /*H0CJ*/      space(2)
* /*H0BT*/      sod_taxc        colon 25
* /*H0BT*/      sod_taxable     colon 25
* /*H008*/      sod_tax_in      colon 25
* /*H0BT*/  with frame set_tax row 13 overlay centered
*     side-labels attr-space.
* /*G415***** END ADD *******/
*H0NR**/
/*J04C*  ADDED THE FOLLOWING */
         /* ENSURE NECESSARY CODE_MSTR RECORDS EXIST (G0X0) */
     if this-is-rma and
        not can-find(code_mstr where code_fldname = "tr_type"
        and code_value = "ISS-RMA") then do:
             create code_mstr.
             code_fldname = "tr_type".
             code_value   = "ISS-RMA".
             code_cmmt    = "RMA 收货的虚的事务类型".
             if recid(code_mstr) = -1 then .
     end.      /* if this-is-rma... */
/*J04C*  END ADDED CODE */

         find so_mstr where recid(so_mstr) = so_recno no-lock no-error.
         find sod_det where recid(sod_det) = sod_recno no-lock no-error.
         find first soc_ctrl no-lock no-error.
         find first gl_ctrl no-lock no-error.

/*J04C*/ rma-receipt-line = no.
/*J04C*/ if this-is-rma then do:
/*J04C*/    find rma_mstr where recid(rma_mstr) = rma-recno
/*J04C*/        exclusive-lock no-error.
/*J04C*/    find rmd_det where recid(rmd_det) = rmd-recno
/*J04C*/        exclusive-lock no-error.
/*J04C*/    find first rmc_ctrl no-lock no-error.
/*J04C*/    if not rma-issue-line then
/*J04C*/        rma-receipt-line = yes.
/*J04C*/ end.

/*H0NR** /*FR95*/ hide frame set_tax no-pause. */
/*FQ53***
 *       /* If site change delete allocations at old site */
 *       if sod_site <> input frame bi sod_site
 *        and can-find(first lad_det
 *             where lad_dataset = "sod_det"
 *               and lad_nbr = sod_nbr
 *               and lad_line = string(sod_line)) then do:
 *          for each lad_det where lad_nbr = sod_nbr
 *                             and lad_line = string(sod_line)
 *                             and lad_dataset = "sod_det":
 *             find ld_det where ld_site = lad_site
 *                           and ld_loc = lad_loc
 *                           and ld_lot = lad_lot
 *                           and ld_ref = lad_ref
 *                           and ld_part = lad_part exclusive.
 *             ld_qty_all = ld_qty_all - (lad_qty_all + lad_qty_pick).
 *             delete lad_det.
 *          end.
 *       end.
 *FQ53*******/
/*FQ53*/ old_site = input frame bi sod_site.
/*FQ53*/ if sod_site <> old_site and  new_line = no   then do:
/*FQ53*/    find si_mstr where si_site = old_site no-lock no-error.
/*FQ53*/       assign
/*FQ53*/       sonbr  = sod_nbr
/*FQ53*/       soline = sod_line .
/*F0G8** /*FQ53*/    if si_db <> so_db then do: **/
/*F0G8*/    /* WE DON'T CREATE THE REMOTE LINES UNLESS THE LINE IS CONFIRMED */
/*F0G8*/    if si_db <> so_db and sod_confirm then do:
/*FQ53*/       {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*F0G8*/       if err-flag = 0 or err-flag = 9 then do:
/*FQ53*/          {gprun.i ""solndel.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*F0G8*/       end.
/*FQ53*/       /* Reset the db alias to the sales order database */
/*FQ53*/       {gprun.i ""gpalias3.p"" "(so_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*FQ53*/       sod_recno = recid(sod_det).
/*FQ53*/    end.
/*FQ53*/    else do:
/*FQ53*/       {gprun.i ""solndel1.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*FQ53*/    end.
/*FQ53*/ end.
/*FQ53*/ find si_mstr where si_site = sod_site no-lock no-error.

/*F042* - SET SLS, DISC ACCTS BASED ON PRODUCT LINE, SITE, CUST TYPE, CHANNEL */
         find pt_mstr where pt_part = sod_part no-lock no-error.
         if available pt_mstr then pt_recno = recid(pt_mstr).
             else pt_recno = ?.
/*F519*/ if new_line then do:
        {gprun.i ""soplsd.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*F519*/ end.

/*F519*/ sodcmmts = (sod_cmtindx <> 0 or (new_line and soc_lcmmts)).
/*J04C*/ if this-is-rma and new_line then
/*J04C*/    sodcmmts = rmc_lcmmts.
/*F040 - Rearranged order of display and set statements to match new form */
         if sngl_ln then
            display
                sod_site sod_loc sod_serial
/*G948*         sod_qty_all when sod_type <> "F" */
/*G948*         sod_qty_pick when sod_type <> "F" */
/*G948*/        sod_qty_all sod_qty_pick
/*J042*/        sod_pricing_dt
/*F0DR*         sod_std_cost  */
/*LB01**F0DR*/     /*   sod_std_cost * exch-rate @ sod_std_cost */
                sod_due_date sod_req_date sod_per_date
/*G035*/        sod_fr_list
                sod_acct sod_cc sod_dsc_acct sod_dsc_cc
/*F356*/        sod_project sod_confirm
                sod_type sod_um_conv
/*G948*         sod-detail-all when sod_type <> "F"  */
/*G948*/        sod-detail-all
/*G415* *H008*/
/*H008*/        sod_taxable
/*H008*/        sod_taxc /* when (not {txnew.i}) */
/*H008*/        sodcmmts
             with frame d.
         seta:
/* Prompt for the rest of the line information on the single line screen */
/*H008*  do on error undo, leave: */
/*H008*/ do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


/*F765*/    if so_tax_date <> ? then tax_date = so_tax_date.
/*F765*/    else if so_due_date <> ? then tax_date = so_due_date.
/*F765*/    else tax_date = so_ord_date.


            if sngl_ln then do:
/*F0K6*/ /* ADD EDITING TO SET GLOBAL LOC FOR LOT/SER LOOKUP */
/*G19G*/       if new sod_det then
/*G19G*/          prev_qty_all = 0.
/*G19G*/        else
/*G19G*/          prev_qty_all = sod_qty_all.
/*J04C*/        /* RMA RECEIPT LINES DO NOT GET ALLOCATIONS. */
/*G501*/        set
/*G501*/            sod_loc sod_serial
/*G501**            sod_qty_all  when sod_confirm = yes **/
/*G501*/            sod_qty_all
/*J04C*/                 when (not rma-receipt-line)
/*G19G /*F0PR*/ with frame d.
 *
 * /*F0PR*/    find in_mstr where in_part = sod_part and in_site = sod_site
 * /*F0PR*/    no-lock no-error.
 * /*F0PR*/    if soc_all_avl and sod_qty_all > 0
 * /*F0PR*/    and available in_mstr
 * /*F0PR*/    and in_qty_avail - in_qty_all < sod_qty_all
 * /*F0PR*/    and sod_type = ""
 * /*F0PR*/    then do:
 * /*F0PR*/       /* QTY AVAILABLE FOR ITEM */
 * /*F0PR*/       {mfmsg02.i 237 2
 *        " sod_part + "": "" + string(in_qty_avail - in_qty_all) "}
 * /*F0PR*/    end.
 * /*F0PR*/       set
 *G19G*/
/*F382*/       /*     sod_std_cost when (not available pt_mstr)*/
                sod_comm_pct[1] when (sod_slspsn[1] <> "")
/*G501*/            sod_confirm when (sod_confirm = no or new_line)
                sod_req_date sod_per_date
/*H184*/         /* sod_due_date */
/*H605*/            sod_due_date /* when not soc_pc_line */
/*G035*/            sod_fr_list
/*H184*/            sod_fix_pr
                sod_acct sod_cc sod_dsc_acct sod_dsc_cc
/*F356*/            sod_project
/*F504*             sod_type when (sod_qty_inv = 0 and sod_qty_ship = 0) */
/*F504*/            sod_type when (sod_qty_inv = 0 and sod_qty_ship = 0 and
/*F504*/                            sod_type = "")
               sod_um_conv
               /* RMA RECEIPT LINES DO NOT GET TO CONSUME FORECAST */
               /* NOR DO THEY GET ALLOCATIONS */
               sod_consume
/*J04C*/                 when (not rma-receipt-line)
               sod-detail-all
/*J04C*/                 when (not rma-receipt-line)
/*G415* *H008*/
/*H008*/           sod_taxable
/*H008*/           sod_taxc /* when (not {txnew.i}) */
/*H008*/           sodcmmts

/*F0K6*         with frame d. */
/*F0K6*/        with frame d editing:
/*F0K6*/            if frame-field = "sod_serial" and
/*F0K6*/                input sod_loc <> global_loc then
/*F0K6*/                global_loc = input sod_loc.
/*F0K6*/            readkey.
/*F0K6*/            apply lastkey.
/*F0K6*/        end. /* END EDITING */

/*J04C*         ADDED THE FOLLOWING */
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
/*J04C*        END ADDED CODE */

/*G19G*/       continue = yes.
/*G19G*/       warn = no.
/*G19G*/       find in_mstr where in_part = sod_part
/*G19G*/            and in_site = sod_site no-lock no-error.
/*G19G*/       if soc_all_avl and sod_qty_all > 0
/*G19G*/       and sod_type = ""
/*G19G*/       and available in_mstr then do:
/*G19G*/          if new sod_det
/*G19G*/          and in_qty_avail - in_qty_all < sod_qty_all then
/*G19G*/             warn = yes.
/*G19G*/          else
/*G19G*/             if (not new sod_det) and sod_qty_all <> prev_qty_all
/*G19G*/             and in_qty_avail - in_qty_all < sod_qty_all - prev_qty_all
/*G19G*/                then warn = yes.
/*G19G*/          if warn then do:
/*G19G*/             /* QTY AVAILABLE FOR ITEM */
/*G19G*/             {mfmsg02.i 237 2
                 " sod_part + "": "" + string(in_qty_avail - in_qty_all) "}
/*G19G*/             /* DO YOU WISH TO CONTINUE? */
/*G19G*/             {mfmsg01.i 7734 2 continue}
/*G19G*/             next-prompt sod_qty_all with frame d.
/*G19G*/             if not continue then do:
/*G19G*/                hide message.
/*G19G*/                undo, retry.
/*G19G*/             end.
/*G19G*/             else hide message.
/*G19G*/          end.
/*G19G*/       end.

/*FQ29*/       /* Allow only zero or positive quantity for allocation */
/*FQ29*/       if sod_qty_all < 0 then do:
/*FQ29*/            {mfmsg.i 6230 3} /* Qty allocated  cannot be < 0 */
/*FQ29*/            next-prompt sod_qty_all  with frame d.
/*FQ29*/            undo, retry.
/*FQ29*/       end.

/*G501*/       /* Allow allocations only for confirmed lines */
/*G501*/       if sod_qty_all <> 0 and not sod_confirm then do:
/*G501*/            {mfmsg.i 688 3}  /* Allocs not allowed for unconfirmed lines */
/*G501*/            next-prompt sod_confirm with frame d.
/*G501*/            undo, retry.
/*G501*/       end.

/*F0G8*/       /* VALIDATE THE AVAILABILITY OF THE REMOTE DATABASE */
/*F0G8*/       if sod_confirm and global_db <> "" then do:
/*F0G8*/            find si_mstr where si_site = sod_site no-lock no-error.
/*F0G8*/            if not connected(si_db) then do:
/*F0G8*/                {mfmsg.i 2505 3}
/*F0G8*/                next-prompt sod_confirm with frame d.
/*F0G8*/                undo, retry.
/*F0G8*/            end.
/*F0G8*/       end.

/*G035*/       /* VALIDATE FREIGHT LIST */
/*G035*/       if sod_fr_list <> "" then do:
/*J042** /*G035*/ sod_fr_list = caps(sod_fr_list).**/
/*G035*/            find fr_mstr where fr_list = sod_fr_list and
/*G035*/                fr_site = sod_site and fr_curr = so_curr no-lock no-error.
/*G035*/            if not available fr_mstr then
/*G035*/                find fr_mstr where fr_list = sod_fr_list and
/*G035*/                    fr_site = sod_site and fr_curr = gl_base_curr no-lock no-error.
/*G035*/            if not available fr_mstr then do:
/*G035*/                /* FREIGHT LIST # NOT FOUND FOR SITE # CURRENCY */
/*G035*/                {mfmsg03.i 670 4 sod_fr_list sod_site so_curr}
/*G035*/                next-prompt sod_fr_list with frame d.
/*G035*/                undo, retry.
/*G035*/            end.
/*G035*/       end.     /* if sod_fr_list <> "" */


/*G013*/       {gpglver1.i &acc = sod_acct
             &sub = ?
             &cc  = sod_cc
             &frame = d}
/*G013*/       {gpglver1.i &acc = sod_dsc_acct
             &sub = ?
             &cc  = sod_dsc_cc
             &frame = d}

/*FT44*/       if so_curr <> base_curr then do:
/*FT44*/            find ac_mstr where
/*FT44*/                ac_code = substring(sod_acct,1,(8 - global_sub_len))
/*FT44*/                no-lock no-error.
/*FT44*/            if available ac_mstr and ac_curr <> so_curr
/*FT44*/                         and ac_curr <> base_curr then do:
/*FT44*/                {mfmsg.i 134 3}
                        /*ACCT CURR MUST EITHER BE TRANS OR BASE CURR*/
/*FT44*/                next-prompt sod_acct with frame d.
/*FT44*/                undo, retry.
/*FT44*/            end.
/*FT44*/            find ac_mstr where
/*FT44*/                ac_code = substring(sod_dsc_acct,1,(8 - global_sub_len))
/*FT44*/                no-lock no-error.
/*FT44*/            if available ac_mstr and ac_curr <> so_curr
/*FT44*/                         and ac_curr <> base_curr then do:
/*FT44*/                {mfmsg.i 134 3}
                        /*ACCT CURR MUST EITHER BE TRANS OR BASE CURR*/
/*FT44*/                next-prompt sod_dsc_acct with frame d.
/*FT44*/                undo, retry.
/*FT44*/            end.
/*FT44*/       end.

               /* VALIDATE TAXABLE AND TAXCODE*/
/*F765*        {gptxcval.i &code=sod_taxc &taxable=sod_taxable &date=so_ord_date */
/*F765*         &frame="d"} */

/*F765*/       {gptxcval.i &code=sod_taxc &taxable=sod_taxable &date=tax_date
            &frame="d"}

/*G889*/       /* VALIDATE FEWER THAN 4 TAX CLASSES */
/*G889*/       if gl_vat or gl_can then do:
/*G889*/            {gpvatchk.i &counter = j   &buffer = sod_buff  &ref = so_nbr
                 &buffref = sod_nbr        &file = sod_det     &taxc = sod_taxc
                 &frame = d                &undo_yn = true     &undo_label = seta}
/*G889*/       end.

               /* FOLLOWING TESTS NOT NEEDED FOR RMA RECEIPT LINES BECAUSE */
               /* ALLOCATIONS ON THEM WILL ALWAYS BE ZERO.                 */
               /* VALIDATE IF QTY ORD > 0 */
               if sod_qty_ord >= 0 and
               sod_qty_ord < sod_qty_all + sod_qty_pick + sod_qty_ship
/*F802*/           and not sod_sched
/*J04C*/           and not rma-receipt-line
               then do:
               repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

                   {mfmsg.i 4999 3}
                   /* Ord qty cannot be < alloc+pick+ship */
                   update sod_qty_all with frame d.
/*G19G*/               continue = yes.
/*G19G*/               warn = no.
/*G19G*/               find in_mstr where in_part = sod_part
/*G19G*/                    and in_site = sod_site no-lock no-error.
/*G19G*/               if soc_all_avl and sod_qty_all > 0
/*G19G*/               and sod_type = ""
/*G19G*/               and available in_mstr then do:
/*G19G*/                    if new sod_det
/*G19G*/                    and in_qty_avail - in_qty_all < sod_qty_all then
/*G19G*/                        warn = yes.
/*G19G*/                    else
/*G19G*/                        if (not new sod_det) and sod_qty_all <> prev_qty_all
/*G19G*/                        and in_qty_avail - in_qty_all
/*G19G*/                            < sod_qty_all - prev_qty_all then
/*G19G*/                            warn = yes.
/*G19G*/                    if warn then do:
/*G19G*/                        /* QTY AVAILABLE FOR ITEM */
/*G19G*/                        {mfmsg02.i 237 2
                               " sod_part + "": "" + string(in_qty_avail - in_qty_all) "}
/*G19G*/                        /* DO YOU WISH TO CONTINUE? */
/*G19G*/                        {mfmsg01.i 7734 2 continue}
/*G19G*/                        if not continue then
/*G19G*/                            undo, retry.
/*G19G*/                    end.    /* if warn */
/*G19G*/               end.     /* if soc_all_avl and ... */

/*FQ29*/               if sod_qty_all < 0 then do:
/*FQ29*/                    {mfmsg.i 6230 3}
                            /* Qty allocated  cannot be < 0 */
/*FQ29*/                    next-prompt sod_qty_all  with frame d.
/*FQ29*/                    undo, retry.
/*FQ29*/               end.
                   if sod_qty_ord >= sod_qty_all + sod_qty_pick + sod_qty_ship
                   then leave.
               end.
/*GUI*/ if global-beam-me-up then undo, leave.
    /* repeat */
               if keyfunction(lastkey) = "end-error" then undo, retry.
                end.   /* if sod_qty_ord >= 0 ... */

/*J1SY*/       /* FOLLOWING TESTS NOT NEEDED FOR RMA RECEIPT LINES BECAUSE */
/*J1SY*/       /* ALLOCATIONS ON THEM WILL ALWAYS BE ZERO.                 */
/*J1SY*/       /* VALIDATE IF QTY ORD < 0 */

/*J1SY*/        if sod_qty_ord < 0
/*J1SY*/        and not sod_sched
/*J1SY*/        and not rma-receipt-line
/*J1SY*/        then do:
/*J1SY*/           repeat on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


/*J1SY*/              if (sod_qty_all<> 0 or sod_qty_ship > 0 or
/*J1SY*/          sod_qty_pick > 0)
/*J1SY*/              then do:
/*J1SY*/                 /* ORD QTY CANNOT BE < ALLOC+PICK+SHIP */
/*J1SY*/                 {mfmsg.i 4999 3}
/*J1SY*/                 update sod_qty_all with frame d.
/*J1SY*/              end.
/*J1SY*/              else leave.

/*J1SY*/           end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* END OF REPEAT ON ERROR, UNDO RETRY */
/*J1SY*/       if keyfunction(lastkey) = "end-error" then undo, retry.
/*J1SY*/        end. /* END OF IF sod_qty_ord < 0  */

/*F297*         Update commission percentages if there are multiple salespersons. */
/*F297*/        if mult_slspsn
/*F711*/        and sngl_ln then set_comm:
/*FR95          do on error undo, retry: */
/*FR95*/        do on error undo, retry on endkey undo, leave seta:
/*GUI*/ if global-beam-me-up then undo, leave.

/*F297*/            FORM /*GUI*/ 
/*F297*/                
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
sod_slspsn[1]     colon 15 label "推销员 1"
/*F297*/                sod_comm_pct[1]   colon 26 no-label
/*F297*/                sort[1]           colon 35 no-label
/*F297*/                sod_slspsn[2]     colon 15 label "推销员 2"
/*F297*/                sod_comm_pct[2]   colon 26 no-label
/*F297*/                sort[2]           colon 35 no-label
/*F297*/                sod_slspsn[3]     colon 15 label "推销员 3"
/*F297*/                sod_comm_pct[3]   colon 26 no-label
/*F297*/                sort[3]           colon 35 no-label
/*F297*/                sod_slspsn[4]     colon 15 label "推销员 4"
/*F297*/                sod_comm_pct[4]   colon 26 no-label
/*F297*/                sort[4]           colon 35 no-label
/*F297*/             SKIP(.4)  /*GUI*/
with frame set_comm overlay side-labels
/*F297*/            centered row 16 width 66 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-set_comm-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame set_comm = F-set_comm-title.
 RECT-FRAME-LABEL:HIDDEN in frame set_comm = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame set_comm =
  FRAME set_comm:HEIGHT-PIXELS - RECT-FRAME:Y in frame set_comm - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME set_comm = FRAME set_comm:WIDTH-CHARS - .5.  /*GUI*/

/*F297*/            sort = "".
/*F297*/            do counter = 1 to 4:
/*F297*/                find sp_mstr where sp_addr = sod_slspsn[counter]
/*F297*/                no-lock no-error.
/*F297*/                if available sp_mstr then
/*F297*/                    sort[counter] = sp_sort.
/*F297*/            end.
/*F297*/            display sod_slspsn
/*F297*/                    sod_comm_pct
/*F297*/                    sort
/*F297*/            with frame set_comm.
/*F297*/            update sod_comm_pct with frame set_comm.
/*F297*/            hide frame set_comm no-pause.
/*F297*/        end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*H049*/        /* FREIGHT WEIGHTS */
/*H049*/        if sod_fr_list <> "" then do:
/*H049*/            set_wt:
/*H049*/            do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

/*H049*/                freight_ok = yes.
/*H494** /*H049*/       if sngl_ln and calc_fr then do: **/
/*H494*/                if sngl_ln and (calc_fr or disp_fr) then do:

/*J1YG*/                    /* ASSIGN so_fr_terms WITH THE FREIGHT TERMS FROM */
/*J1YG*/                    /* THE BEST PRICING ROUTINE TO PREVENT ANY ERROR  */
/*J1YG*/                    /* OR WARNING MESSAGES FROM BEING DISPLAYED AT    */
/*J1YG*/                    /* THE LINE LEVEL                                 */
/*J1YG*/                    so_fr_terms = current_fr_terms.

/*H049*/                    detqty = sod_qty_ord - sod_qty_ship.
/*H0H2*/          /* IF IT IS A VALID DATE, USE THE DUE DATE.  OTHERWISE, USE */
/*H0H2*/          /* THE CURRENT DATE.                                        */
/*H049*/                    {gprun.i ""gpfrlwt.p"" "(input so_curr, input so_ex_rate,
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
/*GUI*/ if global-beam-me-up then undo, leave.


/*H049*/                end.    /* if sngl_ln and... */
/*H049*/                if not freight_ok then
/*H0H2*/                do:
/*H0H2*/            /* FREIGHT ERROR DETECTED - CHARGES MAY BE INCOMPLETE */
/*H0H2*/                    {mfmsg.i 669 2}
/*H0H2*/                    pause.
/*H0H2*/                    undo set_wt, leave set_wt.
/*H0H2*/                end.
/*H0H2*  /*H049*/       undo set_wt, retry. */
/*H049*/            end.
/*GUI*/ if global-beam-me-up then undo, leave.

/*H049*/        end.    /* if sod_fr_lst <> "" */

            /* Determine total quantity allocated */
/*FQ53******** Logic is in soladqty.p
 *              totallqty = 0.
 *              for each lad_det where lad_dataset = "sod_det"
 *              for each lad_det no-lock where lad_dataset = "sod_det"
 *                       and lad_nbr  = sod_nbr
 *                       and lad_line = string(sod_line):
 *                  totallqty = totallqty + (lad_qty_all / sod_um_conv).
 *              end.
 *FQ53*******/
/*FQ53*/        {gprun.i ""gpalias3.p"" "( si_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*F0G8*/        if err-flag = 0 or err-flag = 9 then do:
/*FQ53*/            {gprun.i ""soladqty.p"" "(sod_nbr, sod_line,
                      sod_um_conv, output totallqty )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*F0G8*/        end.
/*FQ53*/        {gprun.i ""gpalias3.p"" "(so_db, output err-flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.


           if (sod-detail-all or sod_qty_ord entered
/*FQ53*         and can-find(first lad_det where lad_dataset = "sod_det"        */
/*FQ53*                                and lad_nbr = sod_nbr              */
/*FQ53*                                and lad_line = string(sod_line)) ) */
/*FQ53*/        and totallqty <> 0 )
/*F504*/        and (sod_qty_all > 0
/*F504*/        or (sod_qty_all = 0 and input frame bi sod_qty_all > 0))
            and sod_type = "" then do:
               /* DO DETAIL ALLOCATIONS */
/*FQ53*            {gprun.i ""solcal.p""} */
/*FQ53*/           {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*F0G8*/           if err-flag = 0 or err-flag = 9 then do:
/*H1F2*
./*FQ53*/               {gprun.i ""solcal1.p"" "( Input sod_site, Input sod_nbr,
.                 Input sod_line , Input sod_part,
.                 Input sod_um_conv , Input sod_loc,
.                 Input sod_serial, Input sod_qty_ord ,
.                 Input sod_qty_all, Input sod_qty_pick,
.                 Input sod_qty_ship, Input sod_due_date,
.                 Input-Output totallqty) "}
*H1F2*/
/*H1F2*/       {gprun.i ""solcal1.p"" "( input sod_site, input sod_nbr,
                 input sod_line , input sod_part,
                 input sod_um_conv , input sod_loc,
                 input sod_serial, input sod_qty_ord ,
                 input sod_qty_all, input sod_qty_pick,
                 input sod_qty_ship, input sod_due_date,
                 input-output totallqty )"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*F0G8*/           end.
/*FQ53*/           {gprun.i ""gpalias3.p"" "(so_db, output err-flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

           end.    /* if sod-detail-all or... */

           if sod_qty_all < totallqty then sod_qty_all = totallqty.

/*G415********************** BEGIN *********************/

/*H008* Replacement - Begin */
     /* GET TAX MANAGEMENT DATA */

/*H0NR*/        {gprun.i ""sosomtlc.p"" "(input this-is-rma)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H0NR*/        if not l_loop_seta then leave seta.

/*H0NR** FOLLOWING SECTION MOVED TO sosomtlc.p **
*     if {txnew.i} and sod_taxable then do:      /* tax92 */
*
*    /* TEST FOR CHANGE IN SITE */
*    if old_sod_site <> sod_site then do:
* /*H0BM*         {mfmsg03.i 922 2 """Site""" """" """" } */
* /*H0BM*/       {mfmsg.i 955 2} /* NEW SITE SPECIFIED; CHECK TAX ENVIRONMENT */
*       sod_tax_env = "".
*    end.
*
*    /* INITIALIZE TEMPORARY NO-UNDO VARS */
*    tax_usage = sod_tax_usage.
*    tax_env   = sod_tax_env.
*
*    taxloop:
* /*FR95*  do on error undo, retry: */
* /*FR95*/ do on error undo, retry on endkey undo, leave seta:
*
*        sod_tax_usage = tax_usage.
*        sod_tax_env   = tax_env.
*
*        /* SUGGEST TAX ENVIRONMENT */
*        if sod_tax_env = "" then do:
*
*       /* LOAD DEFAULTS */
*       find ad_mstr where ad_addr = so_ship
*       no-lock no-error.
*       if available ad_mstr then
*           zone_to = ad_tax_zone.
*       else do:
*           find ad_mstr where ad_addr = so_cust
*           no-lock no-error.
*           if available(ad_mstr) then
*           zone_to = ad_tax_zone.
*       end.
*
*       /* CHECK FOR SITE ADDRESS */
*       find ad_mstr where ad_addr = sod_site no-lock
*       no-error.
*       if available(ad_mstr) then
*           zone_from = ad_tax_zone.
*       else do:
* /*H0BM*             {mfmsg03.i 902 2 """Site Address""" """" """"} */
* /*H0BM*/            {mfmsg.i 864 2} /* SITE ADDRESS DOES NOT EXIST */
*           zone_from = "".
*       end.
*
* /*J04C*/        /* SWITCH ZONE_FROM AND ZONE_TO WHEN RMA-RECEIPT   *TVO*/
* /*J04C*/        /* BECAUSE THEN WE SHIP FROM THE CUST/SHIP TO OUR SITE */
* /*J04C*/        if this-is-rma and sod_fsm_type = "RMA-RCT" then assign
*                    temp_zone = zone_from
*                    zone_from = zone_to
*                    zone_to   = temp_zone.
*
*       {gprun.i ""txtxeget.p"" "(input  zone_to,
*                   input  zone_from,
*                   input  so_taxc,
*                   output sod_tax_env)"}
*
*        end. /* sod_tax_env = "" */
*
*        display
*        sod_tax_usage
*        sod_tax_env
*        sod_tax_in
*        with frame set_tax.
*
*        update
*        sod_tax_usage
*        sod_tax_env
* /*H0BT*/         sod_taxc
* /*H0BT*/         sod_taxable
*        sod_tax_in
*        with frame set_tax.
*
*        tax_usage = sod_tax_usage.
*
*        /* VALIDATE TAX ENVIRONMENT */
*        /* IF BLANK - SUGGEST AGAIN */
*        if sod_tax_env = "" then do:
* /*H0BM*         {mfmsg03.i 906 3 """Tax Environment""" """" """"}. */
* /*H0BM*/        {mfmsg.i 944 3}. /* BLANK TAX ENVIRONMENT NOT ALLOWED */
*       tax_env = "".
*       next-prompt sod_tax_env with frame set_tax.
*       undo taxloop, retry.
*        end.
*
*        /* ELSE UNDO TAXLOOP */
*        if not {gptxe.v "input sod_tax_env" ""no""}
*        then do:
* /*H0BM*          {mfmsg03.i 902 3 """Tax Environment""" */
* /*H0BM*          """" """"}                             */
* /*H0BM*/         {mfmsg.i 869 3} /* TAX ENVIRONMENT DOES NOT EXIST */
*        next-prompt sod_tax_env with frame set_tax.
*        undo taxloop, retry.
*        end.
*        hide frame set_tax.
*    end.
*    end.
*H0NR**/

/*H008* Replacement - End. */


/*H008* Code replaced - Begin:
 *   /* GET TAX MANAGEMENT DATA */
 *   if {txnew.i} and sod_taxable then do:      /* tax92 */
 *
 *
 *       taxloop:
 *       do on error undo, retry:
 *           if {txnew.i} then do:
 *               display
 *               sod_tax_usage
 *               sod_taxc
 *               sod_tax_env
 *               with frame set_tax.
 *
 *               update sod_tax_usage sod_taxc
 *               sod_tax_env with frame set_tax overlay centered.
 *
 *               /* VALIDATE TAX CLASS */
 *               if not {gptaxc.v "input sod_taxc" ""yes""}
 *               then do:
 *                   {mfmsg03.i 902 3 """Tax Class""" """" """"}
 *                   next-prompt sod_taxc with frame set_tax.
 *                   undo taxloop, retry.
 *               end.
 *
 *
 *               if not {gptxe.v "input sod_tax_env" ""no""}
 *               then do:
 *                   {mfmsg03.i 902 3 """Tax Environment"""
 *                   """" """"}
 *                   next-prompt sod_tax_env with frame set_tax.
 *                   undo taxloop, retry.
 *               end.
 *               hide frame set_tax.
 *           end.
 *       end.
 *
 *  end.
**H008* Code replaced - End. */

/*G415******************** END *********************/
            end.    /* if sngl_ln */
/*F765*/    else do: /* multi line */

/*H438** MOVED TO SOSOMTA.P **
 ** /*H380*/    sod_fr_class = pt_fr_class.
 ** /*H380*/    sod_fr_wt = pt_ship_wt. **/

/*F765*/        {gptxcval.i &code=sod_taxc &taxable=sod_taxable &date=tax_date
               &frame="NO-FRAME"}

/*FM10*/        /* validate accounts and cost centers as they don't get validated */
/*FM10*/        /* in multi line format */
/*FM10*/        {gprun.i ""gpglver.p"" "(input sod_acct, input sod_cc,
                             output glvalid)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*FM10*/        if glvalid = no then  undo seta , leave.
/*FM10*/        {gprun.i ""gpglver.p"" "(input sod_dsc_acct, input sod_dsc_cc,
                             output glvalid)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*FM10*/        if glvalid = no then  undo seta , leave.

/*FT44*/        if so_curr <> base_curr then do:
/*FT44*/            find ac_mstr where
/*FT44*/                ac_code = substring(sod_acct,1,(8 - global_sub_len))
/*FT44*/                no-lock no-error.
/*FT44*/            if available ac_mstr and ac_curr <> so_curr
/*FT44*/                            and ac_curr <> base_curr then do:
/*FT44*/                {mfmsg.i 134 3}
/*FT44*/                /*ACCT CURR MUST EITHER BE TRANS OR BASE CURR*/
/*FT44*/                undo seta, leave.
/*FT44*/            end.
/*FT44*/            find ac_mstr where
/*FT44*/                ac_code = substring(sod_dsc_acct,1,(8 - global_sub_len))
/*FT44*/                no-lock no-error.
/*FT44*/            if available ac_mstr and ac_curr <> so_curr
/*FT44*/                            and ac_curr <> base_curr then do:
/*FT44*/                {mfmsg.i 134 3}
/*FT44*/                /*ACCT CURR MUST EITHER BE TRANS OR BASE CURR*/
/*FT44*/                undo seta, leave.
/*FT44*/            end.
/*FT44*/        end.    /* if so_curr <> base_curr */

/*FQ29*/        /* VALIDATE IF QTY ORD > 0 */
/*J1SY**BEGIN DELETE**
 * /*FQ29*/        if sod_qty_ord >= 0 and sod_qty_ord < sod_qty_all
 * /*FQ29*/           + sod_qty_pick + sod_qty_ship and not sod_sched
 *J1SY**END DELETE**/

/*J1SY*/        if ((sod_qty_ord >= 0 and sod_qty_ord < sod_qty_all
/*J1SY*/             + sod_qty_pick + sod_qty_ship)
/*J1SY*/            or (sod_qty_ord < 0 and
/*J1SY*/           (sod_qty_all <>0 or sod_qty_pick >0 or sod_qty_ship > 0))
/*J1SY*/            and not sod_sched)
/*FQ29*/        then do:
/*FQ29*/            {mfmsg.i 4999 3} /* Ord qty cannot be < alloc+pick+ship */
/*FQ29*/            undo seta, leave.
/*FQ29*/        end.
/*F765*/    end. /* multi line */

/*J04C*     ADDED THE FOLLOWING */
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
/*GUI*/ if global-beam-me-up then undo, leave.

            end.
/*J04C*     END ADDED CODE */

            /* Delete allocations if the ship_type is not blank */
/*FQ53******
 * if sod_type <> ""
 *       and can-find(first lad_det
 *       where lad_dataset = "sod_det"
 *         and lad_nbr = sod_nbr
 *         and lad_line = string(sod_line)) then do:
 *    for each lad_det where lad_nbr = sod_nbr
 *                       and lad_line = string(sod_line)
 *                       and lad_dataset = "sod_det":
 *       find ld_det where ld_site = lad_site
 *                     and ld_loc = lad_loc
 *                     and ld_lot = lad_lot
 *                     and ld_ref = lad_ref
 *                     and ld_part = lad_part exclusive.
 *       ld_qty_all = ld_qty_all - (lad_qty_all + lad_qty_pick).
 *       delete lad_det.
 *    end.
 * end.
 *FQ53******/

/*H1B1** /*FQ53*/ if sod_type <> "" then do: */
/*H1B1*/    if sod_type <> "" and (prev_type <> sod_type) then do:
/*FQ53*/        {gprun.i ""gpalias3.p"" "( si_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*F0G8*/        if err-flag = 0 or err-flag = 9 then do:

/*H1B1*/
/* ADDITIONAL PARAMETERS prev_qty_all old_sod_site l_prev_um_conv PASSED TO  */
/* soladdel.p SO THAT INVENTORY WILL BE CORRECTLY DE-ALLOCATED WHEN THE SHIP */
/* TYPE IS CHANGED TO "M" ON EXISTING SALES ORDERS.                          */
/*H1B1*/

/*FQ53*/            {gprun.i ""soladdel.p"" "(sod_nbr, sod_line,
                prev_qty_all, old_sod_site, l_prev_um_conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*F0G8*/        end.
/*FQ53*/        {gprun.i ""gpalias3.p"" "(so_db, output err-flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*FQ53*/    end.
            undo_all2 = false.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* seta: set up for update block */

/*FR95*/ hide frame set_comm no-pause.
/*H0NR** /*FR95*/ hide frame set_tax no-pause.    */
