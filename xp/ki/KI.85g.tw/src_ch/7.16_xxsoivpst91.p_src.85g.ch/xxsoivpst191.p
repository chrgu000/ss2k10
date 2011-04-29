/* soivpst1.p - POST INVOICES TO AR AND GL REPORT                         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.   */
/*F0PN*/ /*V8:ConvertMode=Report                                          */
/* REVISION: 1.0      LAST MODIFIED: 03/11/86   BY: pml                   */
/* REVISION: 6.0      LAST MODIFIED: 04/20/90   BY: ftb *D002*            */
/* REVISION: 6.0      LAST MODIFIED: 07/11/90   BY: wug *D051*            */
/* REVISION: 6.0      LAST MODIFIED: 08/17/90   BY: mlb *D055*            */
/* REVISION: 6.0      LAST MODIFIED: 08/24/90   BY: wug *D054*            */
/* REVISION: 6.0      LAST MODIFIED: 11/01/90   BY: mlb *D162*            */
/* REVISION: 6.0      LAST MODIFIED: 12/21/90   BY: mlb *D238*            */
/* REVISION: 6.0      LAST MODIFIED: 12/06/90   BY: afs *D279*            */
/* REVISION: 6.0      LAST MODIFIED: 02/18/91   BY: afs *D354*            */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: afs *D387*            */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: afs *D424*            */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: afs *D425*            */
/* REVISION: 6.0      LAST MODIFIED: 03/28/91   BY: afs *D464*            */
/* REVISION: 6.0      LAST MODIFIED: 04/04/91   BY: afs *D478* (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 04/29/91   BY: afs *D586* (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 05/08/91   BY: afs *D628* (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 08/12/91   BY: afs *D824* (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 08/14/91   BY: mlv *D825*            */
/* REVISION: 6.0      LAST MODIFIED: 10/09/91   BY: dgh *D892*            */
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: mlv *F029*            */
/* REVISION: 6.0      LAST MODIFIED: 11/26/91   BY: wug *D953*            */
/* REVISION: 7.0      LAST MODIFIED: 11/30/91   BY: sas *F017*            */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: afs *F356*            */
/* REVISION: 7.0      LAST MODIFIED: 06/18/92   BY: tmd *F458*            */
/* REVISION: 7.0      LAST MODIFIED: 08/13/92   BY: sas *F850*            */
/* REVISION: 7.3      LAST MODIFIED: 09/04/92   BY: afs *G047*            */
/* REVISION: 7.3      LAST MODIFIED: 10/23/92   BY: afs *G230*            */
/* REVISION: 7.3      LAST MODIFIED: 12/21/92   BY: mpp *G484*            */
/* REVISION: 7.3      LAST MODIFIED: 01/21/93   BY: sas *G585*            */
/* REVISION: 7.3      LAST MODIFIED: 04/05/93   BY: tjs *G858*            */
/* REVISION: 7.3      LAST MODIFIED: 05/11/93   BY: tjs *GA65*            */
/* REVISION: 7.4      LAST MODIFIED: 07/21/93   BY: jjs *H050*            */
/* REVISION: 7.4      LAST MODIFIED: 08/19/93   BY: pcd *H009*            */
/* REVISION: 7.4      LAST MODIFIED: 10/23/93   BY: cdt *H184*            */
/* REVISION: 7.4      LAST MODIFIED: 11/16/93   BY: bcm *H226*            */
/* REVISION: 7.4      LAST MODIFIED: 03/01/94   BY: dpm *H075*            */
/* REVISION: 7.4      LAST MODIFIED: 04/13/94   BY: bcm *H338*            */
/* REVISION: 7.4      LAST MODIFIED: 04/15/94   BY: cdt *H353*            */
/* REVISION: 7.4      LAST MODIFIED: 04/29/94   BY: dpm *FN83*            */
/* REVISION: 7.4      LAST MODIFIED: 05/18/94   BY: dpm *FO10*            */
/* REVISION: 7.3      LAST MODIFIED: 06/02/94   BY: dpm *GK02*            */
/* REVISION: 7.4      LAST MODIFIED: 06/07/94   BY: dpm *FO66*            */
/* REVISION: 7.4      LAST MODIFIED: 09/13/94   BY: rwl *FR31*            */
/* REVISION: 7.4      LAST MODIFIED: 11/06/94   BY: qzl *FT41*            */
/* REVISION: 7.4      LAST MODIFIED: 11/08/94   BY: bcm *GO14*            */
/* REVISION: 7.4      LAST MODIFIED: 11/17/94   BY: rxm *FT54*            */
/* REVISION: 7.4      LAST MODIFIED: 03/13/95   BY: jxz *F0M3*            */
/* REVISION: 8.5      LAST MODIFIED: 03/29/95   BY: dpm *J044*            */
/* REVISION: 8.5      LAST MODIFIED: 08/23/95   BY: jym *F0TR*            */
/* REVISION: 8.5      LAST MODIFIED: 10/02/95   BY: jym *G0XY*            */
/* REVISION: 8.5      LAST MODIFIED: 11/07/95   BY: ais *F0VT*            */
/* REVISION: 8.5      LAST MODIFIED: 07/25/95   BY: taf *J053*            */
/* REVISION: 8.5      LAST MODIFIED: 04/03/96   BY: *J04C* Sue Poland     */
/* REVISION: 8.5      LAST MODIFIED: 04/24/96   BY: *G1LW* Robin McCarthy */
/* REVISION: 8.5      LAST MODIFIED: 05/14/96   BY: *G1SG* Walt Koetke    */
/* REVISION: 8.5      LAST MODIFIED: 07/09/96   BY: *G1YS* Dwight Kahng   */
/* REVISION: 8.5      LAST MODIFIED: 08/01/96   BY: *J0ZZ* T. Farnsworth  */
/* REVISION: 8.5      LAST MODIFIED: 09/30/96   BY: *G2G2* Aruna P. Patil */
/* REVISION: 8.5      LAST MODIFIED: 10/22/96   BY: *H0MY* Aruna P. Patil */
/* REVISION: 8.5      LAST MODIFIED: 11/12/96   BY: *H0N9* Aruna P. Patil */
/* REVISION: 8.5      LAST MODIFIED: 01/02/97   BY: *J1D7* Sue Poland     */
/* REVISION: 8.5      LAST MODIFIED: 05/29/97   BY: *J1S9* Aruna P. Patil */
/* REVISION: 8.5      LAST MODIFIED: 08/14/97   BY: *J1Z0* Ajit Deodhar */
/* REVISION: 8.5      LAST MODIFIED: 09/23/97   BY: *H1FM* Seema Varma  */
/* REVISION: 8.5      LAST MODIFIED: 11/20/97   BY: *J26P* Mandar K.      */
/* REVISION: 8.5      LAST MODIFIED: 11/27/97   BY: *J273* Nirav Parikh   */
/* REVISION: 8.5      LAST MODIFIED: 01/06/98   BY: *J297* Mandar K.      */
/* REVISION: 8.5      LAST MODIFIED: 12/30/97   BY: *J29S* Jim Williams */
/* REVISION: 8.5      LAST MODIFIED: 03/27/98   BY: *J2J6* Manish K.    */



/*----rev history-------------------------------------------------------------------------------------*/

/* SS - 090707.1 By: Roger Xiao */  /*顺便删除了标准程式的旧ECO,整理了格式.*/



     {mfdeclre.i }

define new shared variable convertmode as character no-undo
  initial "report".

define new shared variable rndmthd like rnd_rnd_mthd.

/* SS - 090707.1 - B 
{soivpst.i "shared"}
 SS - 090707.1 - E */
/* SS - 090707.1 - B */
{xxsoivpst91.i "shared"}
/* SS - 090707.1 - E */


{fsdeclr.i}
define new shared frame sotot.
{mfsotrla.i "NEW"}
define variable w-first-key like so_mstr.so_inv_nbr no-undo.
define variable w-first-pass like mfc_logical no-undo.
define variable bill_name like ad_name.
define variable ship_name like ad_name.
define variable col-80 like mfc_logical initial false.
{soivtot1.i "NEW"}  /* Define variables for invoice totals. */
define new shared variable new_order like mfc_logical.
define new shared variable consolidate like mfc_logical initial true.

define new shared variable undo_trl2 like mfc_logical.
define new shared variable undo_txdetrp like mfc_logical.
define new shared variable crtint_amt      like trgl_gl_amt.
define new shared variable soc_crtacc_acct like gl_crterms_acct.
define new shared variable soc_crtacc_cc   like gl_crterms_cc.
define new shared variable soc_crtapp_acct like gl_crterms_acct.
define new shared variable soc_crtapp_cc   like gl_crterms_cc.

define new shared variable customer_sched like mfc_logical.
define new shared variable so_db like dc_name.
define variable err_flag as integer.
define new shared variable sonbr like sod_nbr.
define new shared variable soline like sod_line.
define new shared variable sopart like sod_part.
define new shared variable tot_inv_comm as decimal format "->>,>>9.99"
       extent 4 no-undo.
define new shared variable line_pricing like mfc_logical.
define     shared variable prog_name as character no-undo.
define variable connect_db like dc_name no-undo.
define variable base_total like base_price no-undo.
define variable marg_total like base_margin no-undo.
define variable base_total_fmt as character no-undo.
define variable base_total_old as character no-undo.
define variable marg_total_fmt as character no-undo.
define variable marg_total_old as character no-undo.
define variable ext_price_fmt as character no-undo.
define variable ext_price_old as character no-undo.
define variable ext_gr_marg_fmt as character no-undo.
define variable ext_gr_marg_old as character no-undo.
define variable totstr as character no-undo.
define variable gltwdr_fmt as character no-undo.
define variable gltwdr_old as character no-undo.
define variable gltwdr as decimal format "->>>>,>>>,>>9.99" no-undo.
define variable gltwcr_fmt as character no-undo.
define variable gltwcr_old as character no-undo.
define variable gltwcr as decimal format "->>>>,>>>,>>9.99" no-undo.
define variable oldsession as character no-undo.
define variable oldcurr like so_curr no-undo.
define variable base_cost as decimal no-undo.
define variable l_consolidate like mfc_logical initial no no-undo.
define variable l_so_nbr      like so_nbr           no-undo.


/* FORMS NEEDED FOR SOIVTRL2.P */
define new shared frame d.

define buffer somstr for so_mstr.
define new shared workfile invoice_err no-undo
               field  inv_nbr  like so_inv_nbr
               field  ord_nbr  like so_nbr
               field  db_name  like dc_name.

         /* DEFINE VARIABLES USED IN GPGLEF1.P (GL CALENDAR VALIDATION) */
{gpglefv.i}

form
    so_cr_init     colon 15
    so_inv_nbr     colon 40
    so_ar_acct     colon 63 so_ar_cc no-label
    so_cr_card     colon 15
    so_to_inv      colon 40
    so_print_so    colon 63
    so_stat        colon 15
    so_invoiced    colon 40
    so_print_pl    colon 63
    so_rev         colon 15
    so_prepaid     colon 40
    so_fob         colon 15
with frame d side-labels width 80.

form
    space(3)
    sod_line
    sod_part format "x(26)"
    sod_um
    sod_acct  sod_cc
    sod_qty_inv label "交运"
    qty_bo label "欠交量"
    sod_taxable  sod_taxc no-label
    sod_price
                    format "->>>,>>>,>>9.99<<<"
    ext_price label "总价"
    ext_gr_margin 
with frame e width 132 down.

form
   skip(1)
   totstr format "x(19)" to 60
   base_total to 117
   marg_total to 130
   skip(1)
with frame rpttot no-labels width 132.

/*DEFINE FRAME FOR DISPLAYING GL TOTALS */
form
   gltw_entity format "X(4)" label "个体"
   gltw_acct
   gltw_cc
   gltw_date
   dr_amt label "借方汇总"
   cr_amt label "贷方汇总"
with frame gltwtot width 132 down no-labels.


/* ASSIGN ORIGINAL FORMAT TO _OLD VARIABLES */
assign
  nontax_old = nontaxable_amt:format
  taxable_old = taxable_amt:format
  line_tot_old = line_total:format
  line_pst_old = line_pst:format
  disc_old     = disc_amt:format
  trl_amt_old = so_trl1_amt:format
  tax_amt_old = tax_amt:format
  tot_pst_old = total_pst:format
  tax_old     = tax[1]:format
  amt_old     = amt[1]:format
  ord_amt_old = ord_amt:format.

assign
   ext_price_old = ext_price:format
   ext_gr_marg_old = ext_gr_margin:format
   gltwcr_old = cr_amt:format
   gltwdr_old = dr_amt:format
   marg_total_old = marg_total:format
   base_total_old = base_total:format.

maint = no.

for each gltw_wkfl exclusive-lock where gltw_userid = mfguser:
   delete gltw_wkfl.
end.

/* GET CREDIT TERMS INTEREST ACCOUNTS FROM MFC_CTRL */
assign
   soc_crtacc_acct = ""
   soc_crtacc_cc   = ""
   soc_crtapp_acct = ""
   soc_crtapp_cc   = "".
find first mfc_ctrl where mfc_field = "soc_crtacc_acct"
no-lock no-error.
if available mfc_ctrl then
   soc_crtacc_acct =  mfc_char.
find first mfc_ctrl where mfc_field = "soc_crtacc_cc"
no-lock no-error.
if available mfc_ctrl then
   soc_crtacc_cc =  mfc_char.
find first mfc_ctrl where mfc_field = "soc_crtapp_acct"
no-lock no-error.
if available mfc_ctrl then
   soc_crtapp_acct =  mfc_char.
find first mfc_ctrl where mfc_field = "soc_crtapp_cc"
no-lock no-error.
if available mfc_ctrl and mfc_char <> "" then
   soc_crtapp_cc =  mfc_char.


oldsession = SESSION:numeric-format.
mainloop:
do on error undo, leave:

        form
           header
           "销售分录参考号: "
           ref
           "AR 批处理: "
           batch   
        with frame jrnl width 80 page-top.


        assign w-first-pass = yes
               w-first-key = inv.

/* SS - 090707.1 - B 
repeat:

       if w-first-pass then do:
                find first somstr where (so_inv_nbr > "")
                and (so_inv_nbr >= w-first-key)
                and (so_inv_nbr <= inv1)
                and (so_invoiced = yes)
                and (so_cust >= cust and so_cust <= cust1)
                and (so_bill >= bill and so_bill <= bill1)
                and (so_to_inv = no)
                use-index so_invoice
                no-lock no-error.
                w-first-pass = no.
       end.
       else
            find first somstr where (so_inv_nbr > "")
                        and (so_inv_nbr > w-first-key)
                        and (so_inv_nbr <= inv1)
                        and (so_invoiced = yes)
                        and (so_cust >= cust and so_cust <= cust1)
                        and (so_bill >= bill and so_bill <= bill1)
                        and (so_to_inv = no)
            use-index so_invoice
            no-lock no-error.
   SS - 090707.1 - E */
/* SS - 090707.1 - B */
for each temp1 where t1_ok = yes :

        find first somstr 
            use-index so_invoice
            where so_inv_nbr = t1_inv_nbr
            and  so_nbr = t1_nbr 
            and (so_invoiced = yes)
            and (so_to_inv = no)
        no-lock no-error.
/* SS - 090707.1 - E */
       if available somstr then do:

            w-first-key = somstr.so_inv_nbr.


            if (oldcurr <> so_curr) or (oldcurr = "") then do:
                    {gpcurmth.i
                        "so_curr"
                        "3"
                        "next"
                        "pause 0" }

                    find rnd_mstr where rnd_rnd_mthd = rndmthd no-lock no-error.
                    if not available rnd_mstr then do:
                        {mfmsg.i 863 3}    /* ROUND METHOD RECORD NOT FOUND */
                        next.
                    end.
                    /* RND_DEC_PT = COMMA FOR DECIMAL POINT */
                    /* THIS IS THE EUROPEAN METHOD */
                    if (rnd_dec_pt = ",")
                    then SESSION:numeric-format = "European".
                    else SESSION:numeric-format = "American".

                    {socurfmt.i} /* SET CURRENCY DEPENDENT FORMATS */
                    /* SET CURRENCY FORMAT FOR EXT_PRICE */
                    ext_price_fmt = ext_price_old.
                    {gprun.i ""gpcurfmt.p"" "(input-output ext_price_fmt,
                    input rndmthd)"}

                    /* SET CURRENCY FORMAT FOR EXT_GR_MARGIN */
                    ext_gr_marg_fmt = ext_gr_marg_old.
                    {gprun.i ""gpcurfmt.p"" "(input-output ext_gr_marg_fmt,
                    input rndmthd)"}
                    oldcurr = so_curr.
            end. /* IF (OLDCURR <> SO_CURR) */

        invoiceloop:
        do transaction on error undo , leave:

            for each so_mstr where so_mstr.so_inv_nbr = somstr.so_inv_nbr
            no-lock
            use-index so_invoice
            break by so_inv_nbr:

                 find first invoice_err where inv_nbr = so_inv_nbr
                            no-lock no-error.
                 if available invoice_err then leave.

                 so_recno = recid(so_mstr).
                 view frame jrnl.

                 assign
                    already_posted  = 0
                    tot_curr_amt    = 0
                    tot_line_disc   = 0
                    name            = "" .
                 if first-of(so_inv_nbr) then do:
                       assign l_so_nbr      = so_nbr
                              l_consolidate = no.
                       {soivtot2.i}  /*Initialize variables for invoice totals*/
                 end.

                find ad_mstr where ad_addr = so_cust
                no-lock no-wait no-error.
                if available ad_mstr then name = ad_name.
                find ad_mstr where ad_addr = so_bill
                no-lock no-wait no-error.
                if available ad_mstr then bill_name = ad_name.
                find ad_mstr where ad_addr = so_ship
                no-lock no-wait no-error.
                if available ad_mstr then ship_name = ad_name.

                find first si_mstr where si_site = so_site
                no-lock no-error.
                if available si_mstr then post_entity = si_entity.
                else post_entity = glentity.

                if first-of(so_inv_nbr) then do:
                    if page-size - line-counter <= 11 then page.
                    display so_inv_nbr so_bill bill_name so_cust name
                    so_slspsn[1] label "业务员" so_slspsn[2] no-label
                    so_slspsn[3] no-label so_slspsn[4] no-label
                    with frame h1 width 132.
                end.
                if page-size - line-counter <= 6 then page.
                display skip(1) space(3) so_nbr so_ship ship_name no-label
                so_ord_date so_po label "PO"
                with frame h2 side-labels width 132 no-box.

                         /* VERIFY OPEN GL PERIOD FOR SITE ENTITY */
                 {gpglef2.i &module  = ""SO""
                                    &entity  = post_entity
                                    &date    = eff_date
                                    &loop    = "invoiceloop" }

                 if base_curr <> so_curr then do:
                        if so_mstr.so_fix_rate = no then do:
                              {gpgtex5.i &ent_curr = base_curr
                                  &curr = so_curr
                                  &date = eff_date
                                  &exch_from = exd_rate
                                  &exch_to = exch_rate}
                           if available exd_det then
                           if exd_from_curr = base_curr then
                              ent_exch = exd_ent_rate.
                           else
                              ent_exch = 1 / exd_ent_rate.

                        end.
                        else do:
                           exch_rate = so_mstr.so_ex_rate.
                           ent_exch  = so_mstr.so_ent_ex.
                        end.
                end. /* if base_curr <> so_curr */
                else do:
                   exch_rate = 1.0.
                   ent_exch  = 1.0.
                end.

                 /* TOTAL THE ORDER FOR TRAILER AND GL DETAIL */
                 so_recno = recid(so_mstr).
                 if not {txnew.i} then do:
                        {gprun.i ""soivtrl.p""}
                 end.
                 else do:

                        undo_trl2 = true.


                        {gprun.i ""txdelete.p""
                           "( input '16',
                                          input so_inv_nbr,
                                          input so_nbr      )" }

                        {gprun.i ""txdetcpy.p""
                         "(input so_nbr,
                           input '',
                                           input '13',
                           input so_inv_nbr,
                           input so_nbr,
                           input '16')"}

                        {gprun.i ""soivtrl2.p""
                         "(input so_inv_nbr,
                           input so_nbr,
                           input col-80 /* REPORT WIDTH */,
                           input '16'   /* TRANSACTION TYPE */)"}

                        if undo_trl2 then return.
                 end.

                 assign crtint_amt = 0.

             /* GET ORDER DETAIL  */
            for each sod_det where (sod_nbr = so_nbr)
            and (sod_qty_inv <> 0)
            break by sod_line with frame e width 132:

                    sod_recno = recid(sod_det).
                    if so_fsm_type = "FSM-RO" then
                        qty_bo = 0.
                    else
                        if sod_qty_ord >= 0 then
                            qty_bo = max(sod_qty_ord - sod_qty_ship, 0).
                        else
                            qty_bo = min(sod_qty_ord - sod_qty_ship, 0).

                    net_list = sod_list_pr.
                    net_price = sod_price.
                    /*IF TAX INCLUDED IN PRICE FIND PRICES NET OF TAX*/
                    if (gl_can or gl_vat) and sod_tax_in then do:
                             /* GET TAX RECORD BY TAX DATE IF EXISTS, ELSE SHIP DATE */
                              if so_tax_date <> ? then tax_date = so_tax_date.
                              else tax_date = so_ship_date.
                              find last vt_mstr where vt_class =  sod_taxc
                                                     and vt_start <= tax_date
                                                     and vt_end   >= tax_date
                                              no-lock no-error.
                               if not available vt_mstr then
                               find last vt_mstr where vt_class = sod_taxc
                               no-lock no-error.
                               if available vt_mstr then do:
                                     net_price = net_price * 100 / (100 + vt_tax_pct).
                                     net_list  = net_list  * 100 / (100 + vt_tax_pct).

                               end.
                    end.

                   ext_price = net_price * sod_qty_inv.
                   {gprun.i ""gpcurrnd.p"" "(input-output ext_price,
                                          input rndmthd)"}

                    ext_list  = net_list  * sod_qty_inv.
                    {gprun.i ""gpcurrnd.p"" "(input-output ext_list,
                                          input rndmthd)"}

                    ext_disc = ext_list - ext_price.
                    tot_line_disc = tot_line_disc + ext_disc.


                    base_cost = sod_std_cost.

                    if base_curr <> so_curr then do:
                                base_cost = base_cost * exch_rate.

                    end.
                                gr_margin = net_price - base_cost.

                    ext_gr_margin = sod_qty_inv * gr_margin.
                    /* ROUND PER DOCUMENT CURR ROUND METHOD */
                    {gprun.i ""gpcurrnd.p"" "(input-output ext_gr_margin,
                                          input rndmthd)"}

                    base_price = ext_price.
                    base_margin = ext_gr_margin.
                    if base_curr <> so_curr then do:

                           base_price = base_price / exch_rate.
                           /* ROUND PER BASE CURR ROUND METHOD */
                           {gprun.i ""gpcurrnd.p"" "(input-output base_price,
                                        input gl_rnd_mthd)"}

                           base_margin = base_margin / exch_rate.
                           /* ROUND PER BASE CURR ROUND METHOD */
                           {gprun.i ""gpcurrnd.p"" "(input-output base_margin,
                                                 input gl_rnd_mthd)"}
                    end. /* IF BASE_CURR <> SO_CURR */

                    /* ACCUMULATE CREDIT TERMS INTEREST */
                    if sod_crt_int <> 0 then do:

                       crtint_amt = crtint_amt + (ext_price -
                             (ext_price / ((sod_crt_int + 100) / 100))).
                       /* ROUND PER CURR ROUND METHOD */
                       {gprun.i ""gpcurrnd.p"" "(input-output crtint_amt,
                                     input rndmthd)"}
                    end.

                    accumulate (base_price) (total).
                    accumulate (base_margin) (total).

                    accumulate (ext_price) (total).
                    accumulate (ext_gr_margin) (total).

                    /* BASE_COST IS ACTUALLY STORED IN FOREIGN CURRENCY */
                    ext_cost = base_cost * sod_qty_inv.
                    /* ROUND PER FOREIGN CURR ROUND METHOD */
                    {gprun.i ""gpcurrnd.p"" "(input-output ext_cost,
                                      input rndmthd)"}


                    accumulate (ext_cost)  (total).

                    desc1 = sod_desc.
                    find pt_mstr where pt_part = sod_part
                    no-lock no-wait no-error.
                    if desc1 = "" and available pt_mstr then
                    desc1 = pt_desc1 + " " + pt_desc2.

                    /* UPDATE GL WORKFILE */
                    undo_all = no.
                    {gprun.i ""sosoglb.p""}
                    if undo_all then undo invoiceloop , leave.



                    ext_price:format = ext_price_fmt.
                    ext_gr_margin:format = ext_gr_marg_fmt.

                    display
                       sod_line
                       sod_part
                       sod_um
                       sod_acct sod_cc
                       sod_qty_inv
                       qty_bo
                       sod_taxable sod_taxc
                       net_price @ sod_price
                       ext_price
                       ext_gr_margin with frame e.

                    down 1 with frame e.

                    if desc1 <> "" then do:
                       put desc1 at 8.
                    end.
                    if gl_can then do:
                       put "PST: " + string(sod_pst) at 73.
                    end.
                    if desc1 <> "" or gl_can then put skip.

                    /* Print Lot/Serial Numbers */
                    if print_lotserials then do:

                          /* CHANGE DATABASES IF USING MULTI-DATABASES TO LOCATE tr_hist */
                          so_db = global_db.
                          find si_mstr where si_site = sod_site no-lock.
                          if si_db <> so_db then do:
                           {gprun.i ""gpalias3.p"" "(si_db, output err_flag)" }
                           {soivconn.i invoiceloop yes}
                          end.
                          assign
                             sonbr = sod_nbr
                             soline = sod_line
                             sopart = sod_part.


                          undo_all = no.
                          {gprun.i ""soivpste.p""}
                          if undo_all then undo invoiceloop , leave.

                          /* RESET THE DB ALIAS TO THE SALES ORDER DATABASE */
                          if si_db <> so_db then do:
                           {gprun.i ""gpalias3.p"" "(so_db, output err_flag)" }
                           {soivconn.i invoiceloop no}
                          end.
                    end.

                    /* UPDATE AR DETAIL */
                    undo_all = no.
                    {gprun.i ""soivpstb.p""}
                    if undo_all then undo invoiceloop , leave.

             end. /* for each sod_det */

                    tot_ext_cost = accum total (ext_cost).

                    if not {txnew.i} then do:
                       {soivtot3.i}  /* Accumulate invoice totals */
                    end.
                    else do:
                       {soivtot7.i}
                    end.

                     /* Display Trailer */
                     if last-of(so_inv_nbr) then do:
                        if so_nbr <> l_so_nbr then
                           l_consolidate = yes.
                        if not {txnew.i} then do:
                           {soivtot4.i}
                        end.
                        else do:
                           /* PRINT TAX DETAIL FOR ALL SALES ORDERS */
                           /* FOR THIS INVOICE NUMBER USING 132 COL */
                           /* AND NO FORCED PAGE BREAK              */
                               undo_txdetrp = true.
                               {gprun.i ""txdetrp.p"" "(input '16',
                                      input so_inv_nbr,
                                      input '*',
                                      input col-80,
                                      input 0)"}
                               if undo_txdetrp then undo invoiceloop, leave.
                               {soivtot8.i}
                        end.

                     end. /* if last-of(so_inv_nbr) */

                     /* GLTRANS WORKFILE POST */
                     undo_all = no.
                     {gprun.i ""sosogla.p""}
                     if undo_all then undo invoiceloop , leave.

                     /* Check to see if we should create installed base  */
                     /* SERVICE CONTRACT ORDERS AND CALL INVOICE (REPAIR */
                     /* ORDERS) DO NOT UPDATE THE INSTALLED BASE.        */
                     if insbase then do:
                        if so_fsm_type begins "SC"
                        or so_fsm_type = "FSM-RO"
                        then . /*nothing*/
                        else do:
                           undo_all = no.
                           {gprun.i ""fsivpcfa.p""}
                           if undo_all then undo invoiceloop , leave.
                        end.
                     end.

                     /* FOR CALL INVOICES, CREATE GL TRANSACTIONS TO */
                     /* CREDIT WIP AND DEBIT COGS.                   */
                     if so_fsm_type = "FSM-RO" then do:
                        if not available sac_ctrl then
                            find first sac_ctrl no-lock.
                        {gprun.i ""fsivpcfb.p""
                            "(input so_nbr,
                              input sac_sa_pre,
                              input eff_date)"}
                     end.   /* if so_fsm_type= "FSM-RO" */


                     /* UPDATE AR MASTER FILE AND DELETE ORDER */
                     undo_all = no.
                     {gprun.i ""soivpsta.p""}
                     if undo_all then do:
                            display
                            skip(3)
                            "发生错误, 停止发票过帐."
                            skip(3)
                            with frame unpost width 80.
                            undo invoiceloop , leave.
                     end.

          end. /*for each so_mstr*/

        end. /*invoiceloop*/

       end. /* if avail somstr */

       else leave.   /* not avail somstr */

/* SS - 090707.1 - B 
    end. /* repeat: find first somstr */
   SS - 090707.1 - E */
/* SS - 090707.1 - B */
end. /*for each temp1*/
/* SS - 090707.1 - E */
        SESSION:numeric-format = oldsession.

        if not undo_all then do:
              /* SET CURRENCY FORMAT FOR BASE_TOTAL */
              base_total_fmt = base_total_old.
              {gprun.i ""gpcurfmt.p"" "(input-output base_total_fmt,
                        input gl_rnd_mthd)"}
              base_total:format = base_total_fmt.

              /* SET CURRENCY FORMAT FOR MARG_TOTAL */
              marg_total_fmt = marg_total_old.
              {gprun.i ""gpcurfmt.p"" "(input-output marg_total_fmt,
                        input gl_rnd_mthd)"}
              marg_total:format = marg_total_fmt.

              base_total = accum total (base_price).
              marg_total = accum total (base_margin).

              underline base_total base_margin with frame rpttot.
              down 1 with frame rpttot.
              display
                 skip(1)
                 base_curr + " 报表总计: " @ totstr
                 base_total
                 marg_total
              with frame rpttot.

        end.

        /* PRINT GL RECAP */
        page.
        /* SET CURRENCY FORMAT FOR GLTWDR ACCORDING TO BASE */
        gltwdr_fmt = gltwdr_old.
        {gprun.i ""gpcurfmt.p"" "(input-output gltwdr_fmt,
                              input gl_rnd_mthd)"}
        /* SET CURRENCY FORMAT FOR GLTWCR ACCORDING TO BASE */
        gltwcr_fmt = gltwcr_old.
        {gprun.i ""gpcurfmt.p"" "(input-output gltwcr_fmt,
                                          input gl_rnd_mthd)"}

        for each gltw_wkfl exclusive-lock where gltw_userid = mfguser
            break by gltw_entity by gltw_acct by gltw_cc
        with frame gltwtot:


                view frame jrnl.

                dr_amt:format = gltwdr_fmt.
                cr_amt:format = gltwcr_fmt.

                cr_amt = 0.
                dr_amt = 0.
                if gltw_amt < 0 then cr_amt = - gltw_amt.
                else dr_amt = gltw_amt.
                accumulate (dr_amt) (total by gltw_cc).
                accumulate (cr_amt) (total by gltw_cc).

                if not gl_sum then do:
                    display gltw_entity
                    gltw_acct gltw_cc gltw_project gltw_date gltw_desc
                    with frame gltwtot.
                    if dr_amt <> 0 then display dr_amt.
                    if cr_amt <> 0 then display cr_amt.
                    down 1 with frame gltwtot.
                end.
                if last-of(gltw_cc) then do:
                    if gl_sum then
                        display gltw_entity
                        gltw_acct gltw_cc gltw_date
                        with frame gltwtot.
                    if (accum total by gltw_cc dr_amt) <> 0 then
                    do:
                        gltwdr = accum total by gltw_cc dr_amt.
                        display gltwdr @ dr_amt with frame gltwtot.
                    end.
                    if (accum total by gltw_cc cr_amt) <> 0 then do:
                        gltwcr = accum total by gltw_cc cr_amt.
                        display gltwcr @ cr_amt with frame gltwtot.
                    end.
                    down 1 with frame gltwtot.
                end.

                if last-of(gltw_entity) then do:
                    underline dr_amt cr_amt with frame gltwtot.
                    down 1 with frame gltwtot.
                    display
                    accum total (dr_amt) @ dr_amt
                    accum total (cr_amt) @ cr_amt with frame gltwtot.
                    down 1 with frame gltwtot.
                end.

               delete gltw_wkfl.

        end. /*for each gltw_wkfl*/

        /* Display unposted invoices */
        find first invoice_err no-lock no-error.
        if available invoice_err then do:
           page.
           display "作业期间未过帐发票" with frame c width 80.
           for each invoice_err no-lock,
               each so_mstr where so_inv_nbr = inv_nbr no-lock
               with frame err width 80:
              display
                 inv_nbr so_nbr db_name column-label "资料库未连接"
              with frame err.
           end.
        end.
        SESSION:numeric-format = oldsession.
        return.

end. /*mainloop*/
SESSION:numeric-format = oldsession.
undo_all = yes.
