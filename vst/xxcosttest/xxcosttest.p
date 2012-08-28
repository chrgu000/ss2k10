/* REVISION: ADM1    LAST MODIFIED: 01/08/03   BY: *Derek                   */
/*           - update material cost in cost set (SIM) from last po price    */
/* copied from scptup.p - DIRECT COSTS MASS UPDATE                          */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*F0PN*/ /*V8:ConvertMode=Report                                            */

/* REVISION: ADM1.1  LAST MODIFIED: 02/20/03   BY: *Derek                   */
/*                   - enhanced version 1.1                                 */
/* REVISION: ADM1a  LAST MODIFIED: 07/15/03   BY: *Derek                    */
/*                   - allow select po price from po order or po receive    */
/* REVISION: ADM1b  LAST MODIFIED: 31/03/04   BY: *Derek                    */
/*                   - add range for Effective date                         */
/*                   - add option "Use STD Mat. Cost when zero"             */
/* REVISION: sdma  LAST MODIFIED: 02/10/07   BY: carflat                    */
/*                   - add sdm1 sdm2 sdm3                                   */
/*                   - add po_price * 1.27 not RMB                          */

/*a-flag*: 20090805 */
/*a-flag*: 20100418 */ /*get po price without tax amt eco:*A0418*           */
/*a-flag*: 20110304 */ /* update from : 1.std_cost 2.pc_list 3.po 4.voucher */
/*a-flag*: 20110415 */ /* remove 1.27, copy all element of standard cost,   */

     {mfdtitle.i "120828.0"}
     {pxmaint.i}
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE scptup_p_1 "Change"
/* MaxLen: Comment: */

&SCOPED-DEFINE scptup_p_2 "Item Number"
/* MaxLen: Comment: */

&SCOPED-DEFINE scptup_p_3 "OLD_PO_PRICE"
/* MaxLen: Comment: */

&SCOPED-DEFINE scptup_p_4 "NEW_PO_PRICE"
/* MaxLen: Comment: */

&SCOPED-DEFINE scptup_p_5 "PO_DATE"
/* MaxLen: Comment: */

&SCOPED-DEFINE scptup_p_6 "PURCH_UNIT"
/* MaxLen: Comment: */

&SCOPED-DEFINE scptup_p_7 "LOCATION_UNIT"
/* MaxLen: Comment: */

&SCOPED-DEFINE scptup_p_8 "UNIT_CONVERT_RATE"
/* MaxLen: Comment: */

&SCOPED-DEFINE scptup_p_11 "ITEM_NUMBER"
/* MaxLen: Comment: */

&SCOPED-DEFINE scptup_p_12 "DESCRIPTION"
/* MaxLen: Comment: */

&SCOPED-DEFINE scptup_p_13 "PURCHASE_ORDER"
/* MaxLen: Comment: */

&SCOPED-DEFINE scptup_p_14 "COST_ELEMENT"
/* MaxLen: Comment: */

&SCOPED-DEFINE scptup_p_15 "QUANTITY_ORDERED"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*ADM1   define variable prod_ln1 like pt_prod_line.
         define variable prod_ln2 like pt_prod_line.
         define variable type1 like pt_part_type.
         define variable type2 like pt_part_type.
         define variable element1 like sc_element.
         define variable element2 like sc_element. */
/*ADM1   define variable pct_chg as decimal format "->>9.99%" label {&scptup_p_1}.  */
     define variable costsim1 like sc_sim.
     define variable part like pt_part.
     define variable part2 like pt_part.
     define variable v1 as character format "x(16)".
     define variable v2 as character format "x(16)".
     define variable v3 as character format "x(16)".
     define variable v4 as character format "x(16)".
     define variable qty as decimal.
     define variable amt as decimal.
     define variable i as integer.
/*A0304*/
define var v_from as integer format "9" no-undo.
define temp-table temp1
    field t1_vend   like pt_vend
    field t1_start  like pc_start
    field t1_days   as integer
    field t1_amt    like pod_pur_cost
    field t1_from   as char format "x(30)".
    .

define var v_base_amt like pod_pur_cost .
define var v_conv like um_conv .
define var v_um1 as char .
define var v_um2 as char .

define var v_curr1 like po_curr .
define var v_curr2 like po_curr .
define var v_ratetype like exr_ratetype .
define var v_r1 like exr_rate .
define var v_r2 like exr_rate2.
define var v_seq as integer .
define var v_error as integer .

define var v_shipto as char .
define var v_tax_env like po_tax_env.
/*A0304*/

         define variable new_cost like spt_cst_tl.
         define variable desc1 like pt_desc1 format "x(49)".
/*G032*/ define variable site like spt_site.

/*ADM1*/ define variable eff_date like po_ord_date initial today no-undo.
/*ADM1b*/ define variable eff_date1 like po_ord_date no-undo.
/*ADM1*/ define variable xxtmp_price like pod_pur_cost.
/*ADM1*/ define variable xxtmp_podate as date.
/*ADM1*/ define variable xxtmp_ponbr as char label {&scptup_p_13}.
/*ADM1*/ define variable xxtmp_poqty like tr_qty_loc label {&scptup_p_15}.
/*ADM1.1*/ define variable xx_element as char label {&scptup_p_14}.
/*ADM1.1*/ define variable xxtmp_pum like pod_um.
/*ADM1.1*/ define variable xxtmp_sum like pt_um.
/*ADM1.1*/ define variable xxtmp_umconv as decimal label {&scptup_p_8}.
/*ADM1a*/ define variable xxuse_rct like mfc_logical label "Using Receive Cost"
    initial no.
/*ADM1b*/ define variable xxuse_std like mfc_logical
    label "Using Std Mat. Cost if Zero" initial no.
/*ADM1b*/ define variable xxuse_pct as decimal format "9.99"
    label "Factor for Std Mat." initial 1.00.
/*ADM1b*/ define variable xxstdcst like spt_cst_tl.
/*sdma*/ DEF TEMP-TABLE a
            FIELD a-part LIKE pt_part
            FIELD a-um   LIKE pt_um
            FIELD a-desc AS CHAR FORMAT "x(49)"
                        field a-pm_code like pt_pm_code .
        form
            skip (1)
            part      label {&scptup_p_2} colon 15
            part2     label {t001.i} colon 49 SKIP
/*ADM1*/    skip (1)
/*ADM1*/    eff_date  colon 30
/*ADM1b*/   eff_date1 label {t001.i} colon 49 skip
/*G032*/    site      colon 30 skip
            costsim1  colon 30
            skip
/*A0304*
/*ADM1a*/   xxuse_rct colon 30 skip
/*ADM1b*/   xxuse_std colon 30 skip
/*ADM1b*/   xxuse_pct colon 30 skip
*A0304*/

            v_from    colon 30  label "UPDATE_METHOD" /*A0304*/
            v1        colon 35 no-label skip /*A0304*/
            v2        colon 35 no-label skip /*A0304*/
            v3        colon 35 no-label skip /*A0304*/
            v4        colon 35 no-label skip /*A0304*/
           xxuse_rct  colon 30 skip /*A0304*/
           xxuse_pct  colon 30 skip /*A0304*/


         with frame a side-labels /*GL65*/ width 80.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         form
            spt_part   label {&scptup_p_11}
            desc1      label {&scptup_p_12}
            xx_element label {&scptup_p_14}
            xxtmp_pum label {&scptup_p_6}
            xxtmp_sum label {&scptup_p_7}
            xxtmp_umconv label {&scptup_p_8}
            spt_cst_tl label {&scptup_p_3}
            new_cost   label {&scptup_p_4}
            xxtmp_podate label {&scptup_p_5}
            xxtmp_ponbr label {&scptup_p_13}
            xxtmp_poqty label {&scptup_p_15}
         with frame det2 width 170 no-attr-space.

assign v1 = "1." + getTermLabel("STANDARD_COST",16)
       v2 = "2." + getTermLabel("PRICE_LIST",16)
       v3 = "3." + getTermLabel("PRICE_ORDER",16)
       v4 = "4." + getTermLabel("DR",16).

display v1 v2 v3 v4 with frame a.


mainloop:
repeat:

    if part2 = hi_char then part2 = "".
    if eff_date1 = hi_date then eff_date1 = ?.


    update
       part part2

       eff_date
       eff_date1
       site
       costsim1
       v_from /*A0304*/
 /*A0304*
       xxuse_rct
       xxuse_std
       xxuse_pct
 *A0304*/
    with frame a.

/*A0304*/
if v_from < 1 or v_from > 4 then do:
    {mfmsg.i 7765 3}
    undo,retry.
end.
if v_from = 1 then update xxuse_pct with frame a.
else if v_from = 3 then update xxuse_rct with frame a.
/*A0304*/

    if not can-find(cs_mstr where cs_set = costsim1 and cs_type = "SIM")
    then do:
        {pxmsg.i &MSGNUM=4074 &ERRORLEVEL=3}
        next-prompt costsim1 with frame a.
        undo, retry.
    end.

    if not can-find (si_mstr where si_site = site) then do:
       {mfmsg.i 708 3} /* SITE DOES NOT EXIST */
       next-prompt site with frame a.
       undo, retry.
    end.

    if not batchrun then do:
       {gprun.i ""gpsiver.p""
        "(input site, input ?, output return_int)"}
       if return_int = 0 then do:
          {mfmsg.i 725 3} /*USER DOES NOT HAVE ACCESS TO THIS SITE */
          next-prompt site with frame a.
          undo mainloop, retry.
       end.
    end.

    bcdparm = "".
    {mfquoter.i part      }
    {mfquoter.i part2      }
    {mfquoter.i eff_date   }
    {mfquoter.i eff_date1  }
    {mfquoter.i site       }
    {mfquoter.i costsim1   }
    {mfquoter.i xxuse_rct  }
    {mfquoter.i xxuse_std  }
    {mfquoter.i xxuse_pct  }


    if part2 = "" then part2 = hi_char.
    if eff_date1 = ? then eff_date1 = hi_date.


    /* Select printer */
    {mfselbpr.i "printer" 132}
    {mfphead.i}


/*a-flag*/
    for each a : delete a . end.

    IF site = 'vst1' OR site = 'sdm1' THEN DO:
        FOR each pt_mstr no-lock
            where (pt_part >= part and pt_part <= part2)
            /*AND pt_pm_code = "P"*/
            AND pt_site = site :
                CREATE a.
                ASSIGN a-part = pt_part
                a-um   = pt_um
                a-pm_code = pt_pm_code
                a-desc = pt_desc1 + " " + pt_desc2.
        END.
    END. /*sdm1*/
    ELSE iF site = 'sdm2' OR site = 'sdm3' OR  site ='vst2'THEN DO:
        FOR each ptp_det no-lock
            where (ptp_part >= part and ptp_part <= part2)
            /*AND ptp_pm_code = "P" */
            AND ptp_site = site :

            FIND FIRST pt_mstr WHERE pt_part = ptp_part NO-LOCK NO-ERROR.
            CREATE a.
            ASSIGN a-part = ptp_part
                a-um   = pt_um
                a-pm_code = ptp_pm_code
                a-desc = pt_desc1 + " " + pt_desc2.
        END.
    END. /*sdm2 or sdm3*/

define var v_cst_1 like sct_mtl_tl .
define var v_cst_2 like sct_lbr_tl .
define var v_cst_3 like sct_bdn_tl .
define var v_cst_4 like sct_ovh_tl .
define var v_cst_5 like sct_sub_tl .

define var vv_element as char .
/*a-flag*/

FOR EACH a WHERE a-part <> '' NO-LOCK:


    assign
        vv_element = "Material"
        v_cst_1    = 0
        v_cst_2    = 0
        v_cst_3    = 0
        v_cst_4    = 0
        v_cst_5    = 0
        .

    if a-pm_code = "M" then do:
        find first sct_det
            where sct_sim = "Standard"
            and sct_part = a-part
            and sct_site = site
        no-lock no-error.
        if avail sct_det and sct_lbr_tl = 0 then vv_element = "Subcontr".

        if avail sct_det and sct_lbr_tl <> 0 then next .
    end.

    for each spt_det
        where spt_site = site
        and spt_sim = "Standard"
        and spt_part = a-part:
        if spt_element = "Material"  then v_cst_1 = spt_cst_tl .
        if spt_element = "Labor"     then v_cst_2 = spt_cst_tl .
        if spt_element = "Burden"    then v_cst_3 = spt_cst_tl .
        if spt_element = "Overhead"  then v_cst_4 = spt_cst_tl .
        if spt_element = "Subcontr"  then v_cst_5 = spt_cst_tl .
    end.


    xxstdcst = 0.
    find spt_det where spt_site = site
        and spt_sim = "Standard"
        and spt_part = a-part
        and spt_element = vv_element
    no-lock no-error.
    if available spt_det then
        xxstdcst = spt_cst_tl * xxuse_pct. /*A0304*/

    find sct_det where sct_sim = costsim1 and sct_part = a-part
        and sct_site = site no-lock no-error.
    if not available sct_det then do:
        create sct_det.
        assign
            sct_sim = costsim1
            sct_part = a-part
            sct_site = site
            sct_user1 = "xxscptup".

        /*check for spt_det*/
        find spt_det where spt_sim = costsim1 and spt_part = a-part and
            spt_site = site and spt_element = vv_element
        no-lock no-error.
        if not available spt_det then do:
            create spt_det. /*Create Material Record only*/
            assign
                spt_sim = costsim1
                spt_part = a-part
                spt_site = site
                spt_user1 = "xxscptup"
                spt_element = vv_element
                spt_pct_ll = 1.00.
        end. /*not available spt_det*/
    end. /*not available sct_det*/
    else do:
        find sct_det where sct_sim = costsim1 and sct_part = a-part
            and sct_site = site
        exclusive-lock.
    end.

    sct_mtl_tl = 0.
    sct_lbr_tl = 0.
    sct_bdn_tl = 0.
    sct_ovh_tl = 0.
    sct_sub_tl = 0.

for each spt_det
    where spt_sim = costsim1
    and spt_part = a-part
    and spt_site = site
with frame det2 down width 170 no-box no-attr-space:

if (spt_element = vv_element)
then do:
    xxtmp_price = 0.
    xxtmp_podate = ?.
    xxtmp_ponbr = "".
    xxtmp_poqty = 0.

    if v_from = 1 then do:
                xxtmp_price = xxstdcst.
                new_cost = xxtmp_price.
                xxtmp_ponbr  = "STD MAT".
    end. /*if v_from = 1 then do:*/
    if v_from = 2 then do:

            for each temp1 : delete temp1 . end.

            find first poc_ctrl no-lock no-error .
            v_shipto = if avail poc_ctrl then poc_ship else "VST" .

            for each pc_mstr
                use-index pc_part
                where pc_part = a-part
                and (pc_start <= eff_date)
                and (pc_expir >= eff_date or pc_expir = ?)
                and (pc_amt_type = "L" or pc_amt_type = "P")
                no-lock
                break by pc_part by pc_start by pc_amt[1]:

                v_base_amt = 0.
                assign qty = 0.
                assign amt = 0.
                if last-of(pc_part) then do:
                    if pc_um <> a-um then do:
                        v_um1  = pc_um .
                        v_um2  = a-um .
                        v_conv = 0 .
                        {gprun.i ""gpumcnv.p""
                        "(input v_um1 , input v_um2  , input a-part  , output v_conv)"}
                        if v_conv = ? then v_conv = 0.
                    end.
                    else v_conv = 1.

                    if pc_curr <> base_curr then do:

                            v_curr1    = pc_curr .
                            v_curr2    = base_curr .
                            v_ratetype = "" .
                            v_r1       = 1 .
                            v_r2       = 0 .

                            {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                                                "(input v_curr1,
                                                  input v_curr2,
                                                  input v_ratetype ,
                                                  input today ,
                                                  output v_r1,
                                                  output v_r2,
                                                  output v_seq,
                                                  output v_error)"}
                            if v_error <> 0 then do:
                                v_r2       = 0 .
                            end.
                    end.
                    else v_r2       = 1.

                    if pc_amt_type = "L" then do:
                       v_base_amt = pc_amt[1] * v_conv * v_r2 .
                    end.
                    else do:
                         do i = 1 to 15:
                            assign qty = qty + pc_min_qty[i]
                                   amt = amt + pc_amt[i] * v_conv * v_r2 * pc_min_qty[i].
                         end.
                         if qty <> 0 then do:
                            v_base_amt = (amt / qty).
                         end.
                    end.
                    find first ad_mstr where ad_addr = pc_list and ad_type = "supplier" no-lock no-error.
                    if avail ad_mstr then do:
                        {pxrun.i &PROC='getTaxEnvironment'
                                 &PROGRAM='xxcostpopoxr.p'
                                 &PARAM="(input ad_addr,
                                          input site,
                                          input v_shipto,
                                          input ad_taxc,
                                          output v_tax_env)"}
                        if v_tax_env = "" then  v_tax_env = "CHN".


                        find first txed_det where txed_tax_env = v_tax_env no-lock no-error .
                        if avail txed_det then do:
                            find last tx2_mstr
                                use-index tx2_type_taxc
                                where tx2_tax_type = txed_tax_type
                                and tx2_pt_taxc    = ad_taxc
                                and tx2_tax_usage  = ad_tax_usage
                                and tx2_effdate   <= today
                            no-lock no-error .
                            if avail tx2_mstr then do:
                                v_base_amt = v_base_amt / (1 + tx2_tax_pct / 100) .
                            end.
                        end.
                    end.

                    find first temp1
                        where t1_vend = pc_list
                    no-error.
                    if not avail temp1 then do:
                        create temp1 .
                        assign t1_vend   = pc_list
                               t1_amt    = v_base_amt
                               t1_start  = pc_start
                               t1_days = if pc_expir = ? then hi_date - pc_start else pc_expir - pc_start
                               t1_from   = pc_user1 + "@" + pc_list + "@"
                                         + pc_curr + "@"
                                         + pc_prod_line + "@"
                                         + pc_um + "@"
                                         + if pc_start = ? then "?" else string(pc_list)
                                         .
                    end.
                    else do:
                        if pc_start >= t1_start and v_base_amt > t1_amt then do:
                        assign
                               t1_amt    = v_base_amt
                               t1_start  = pc_start
                               t1_from   = pc_user1 + "@" + pc_list + "@"
                                         + pc_curr + "@"
                                         + pc_prod_line + "@"
                                         + pc_um + "@"
                                         + if pc_start = ? then "?" else string(pc_list)
                                         .
                        end.
                    end.

                end. /*if last-of(pc_list)*/
            end. /*for each pc_mstr*/

            for each temp1 break by t1_days by t1_amt:
                if last(t1_amt) then do:
                    xxtmp_price = t1_amt.
                    new_cost = xxtmp_price.
                    xxtmp_ponbr  = "PC@" + t1_from.
                end.
            end.

    end. /*if v_from = 2 then do:*/
    if v_from = 3 then do:
            if xxuse_rct = Yes then do:
                for each tr_hist where
                    (tr_part = a-part) and
                    (tr_effdate >= eff_date)
                    and (tr_effdate <= eff_date1)
                    and (tr_type = "RCT-PO")
                    use-index tr_part_eff no-lock
                    break by tr_effdate descending by tr_trnbr descending :
                        xxtmp_pum = tr_um.
                        xxtmp_poqty  = tr_qty_loc.
                        xxtmp_price = tr_price.
                        xxtmp_podate = tr_effdate.
                        xxtmp_ponbr  = tr_nbr.

                        /*A0418*/
                        find first prh_hist
                            where prh_nbr    = tr_nbr
                            and prh_receiver = tr_lot
                            and prh_line     = tr_line
                            and prh_part     = tr_part
                        no-lock no-error .
                        if avail prh_hist and prh_tax_in then do:
                            find first txed_det where txed_tax_env = prh_tax_env no-lock no-error .
                            if avail txed_det then do:
                                find last tx2_mstr
                                    use-index tx2_type_taxc
                                    where tx2_tax_type = txed_tax_type
                                    and tx2_pt_taxc    = prh_taxc
                                    and tx2_tax_usage  = prh_tax_usage
                                    and tx2_effdate   <= prh_rcp_date
                                no-lock no-error .
                                if avail tx2_mstr then do:
                                    xxtmp_price = tr_price / (1 + tx2_tax_pct / 100) .
                                end.
                            end.
                        end.
                        /*A0418*/

                        leave.
                end.
            end.
            else do:
                for each pod_det no-lock
                        where pod_part = a-part /*and pod_type = "" */,
                    each po_mstr no-lock
                        where po_nbr = pod_nbr and
                        po_ord_date >= eff_date
                        and po_ord_date <= eff_date1
                    by po_ord_date descending by po_nbr descending:
                    if available pod_det then
                    do:
                        xxtmp_umconv = pod_um_conv.
                        xxtmp_pum = pod_um.
                        xxtmp_poqty  = pod_qty_ord.
                        if po_curr <> "rmb" then
                            xxtmp_price =pod_pur_cost * po_ex_rate2 /*  * 1.27  */.
                        ELSE
                            xxtmp_price = pod_pur_cost / po_ex_rate .
                            xxtmp_price = xxtmp_price / xxtmp_umconv.

                        /*A0418*/
                        if pod_taxable and pod_tax_in then do:
                            find first txed_det where txed_tax_env = pod_tax_env no-lock no-error .
                            if avail txed_det then do:
                                find last tx2_mstr
                                    use-index tx2_type_taxc
                                    where tx2_tax_type = txed_tax_type
                                    and tx2_pt_taxc    = pod_taxc
                                    and tx2_tax_usage  = pod_tax_usage
                                    and tx2_effdate   <= (if po_tax_date <> ? then po_tax_date
                                                          else if pod_due_date <> ? then pod_due_date
                                                          else if po_ord_date  <> ? then po_ord_date
                                                          else today)
                                no-lock no-error .
                                if avail tx2_mstr then do:
                                    xxtmp_price = xxtmp_price / (1 + tx2_tax_pct / 100) .
                                end.
                            end.
                        end.
                        /*A0418*/


                    end.
                    if available po_mstr then
                    do:
                        xxtmp_podate = po_ord_date.
                        xxtmp_ponbr  = po_nbr.
                    end.
                    leave.
                end.
            end. /*else*/

            if xxtmp_price <> 0 then
                new_cost = xxtmp_price. /*Get From Last PO Cost */

    end. /*if v_from = 3 then do:*/
    if v_from = 4 then do:

            for each prh_hist
                    use-index prh_part
                    where prh_part = a-part
                no-lock,
                each vph_hist
                    use-index vph_nbr
                    where vph_nbr = prh_nbr
                    and   vph_receiver = prh_receiver
                    and   vph_line     = prh_line
                    no-lock
                break by prh_part by vph_inv_date :

                if last-of(prh_part)then do:
                    xxtmp_price  = vph_inv_cost .
                    new_cost = xxtmp_price.
                    xxtmp_ponbr  = "Voucher".
                    xxtmp_podate = vph_inv_date .

                    if prh_tax_in then do:
                        find first txed_det where txed_tax_env = prh_tax_env no-lock no-error .
                        if avail txed_det then do:
                            find last tx2_mstr
                                use-index tx2_type_taxc
                                where tx2_tax_type = txed_tax_type
                                and tx2_pt_taxc    = prh_taxc
                                and tx2_tax_usage  = prh_tax_usage
                                and tx2_effdate   <= prh_rcp_date
                            no-lock no-error .
                            if avail tx2_mstr then do:
                                xxtmp_price = xxtmp_price / (1 + tx2_tax_pct / 100) .
                            end.
                        end.
                    end. /*if prh_tax_in*/

                end. /*if last-of(prh_part)*/

            end. /* for each prh_hist */

    end. /*if v_from = 4 then do:*/

    if xxtmp_price <> 0 then do:
        xxtmp_sum = a-um.
        display
                spt_part
                a-desc @ desc1
                spt_element @ xx_element
                xxtmp_pum
                xxtmp_sum
                xxtmp_umconv
                spt_cst_tl
                new_cost
                xxtmp_podate
                xxtmp_ponbr  format "x(14)"
                xxtmp_poqty.
        down 1 .
        spt_cst_tl = new_cost.
        sct_cst_date = xxtmp_podate.
        sct_user1 = xxtmp_ponbr.
    end.

    new_cost = 0.
end. /*if (spt_element = vv_element)*/

if v_from = 1 then do:

    if spt_element = "Material"  then spt_cst_tl = v_cst_1 .
    if spt_element = "Labor"     then spt_cst_tl = v_cst_2 .
    if spt_element = "Burden"    then spt_cst_tl = v_cst_3 .
    if spt_element = "Overhead"  then spt_cst_tl = v_cst_4 .
    if spt_element = "Subcontr"  then spt_cst_tl = v_cst_5 .

end. /*if v_from = 1 then do:*/

         if truncate(spt_pct_ll,0) = 1
            then sct_mtl_tl = sct_mtl_tl + spt_cst_tl.
         else if truncate(spt_pct_ll,0) = 2
            then sct_lbr_tl = sct_lbr_tl + spt_cst_tl.
         else if truncate(spt_pct_ll,0) = 3
            then sct_bdn_tl = sct_bdn_tl + spt_cst_tl.
         else if truncate(spt_pct_ll,0) = 4
            then sct_ovh_tl = sct_ovh_tl + spt_cst_tl.
         else if truncate(spt_pct_ll,0) = 5
            then sct_sub_tl = sct_sub_tl + spt_cst_tl.

         sct_cst_tot = sct_mtl_tl + sct_mtl_ll
                       + sct_lbr_tl + sct_lbr_ll
                       + sct_bdn_tl + sct_bdn_ll
                       + sct_ovh_tl + sct_ovh_ll
                       + sct_sub_tl + sct_sub_ll.
         sct_cst_date = today.

        {mfrpexit.i "false"}

end. /*for each spt_det*/
{mfrpexit.i}

end. /*FOR EACH a*/

{mfrtrail.i}

end. /*mainloop*/
