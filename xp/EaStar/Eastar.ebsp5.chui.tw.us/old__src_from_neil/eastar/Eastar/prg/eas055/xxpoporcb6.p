/* poporcb6.p - PURCHASE ORDER RECEIPT W/ SERIAL NUMBER CONTROL               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/*L020*/ /*V8:RunMode=Character,Windows                                       */
/* REVISION: 7.4      LAST MODIFIED: 03/25/94   BY: dpm *FM94*                */
/* REVISION: 7.4      LAST MODIFIED: 04/12/94   BY: bcm *H336*                */
/* REVISION: 7.4      LAST MODIFIED: 08/01/94   BY: dpm *H466*                */
/* REVISION: 7.4      LAST MODIFIED: 09/26/94   BY: bcm *H539*                */
/* REVISION: 7.4      LAST MODIFIED: 10/31/94   BY: ame *GN82*                */
/* REVISION: 8.5      LAST MODIFIED: 10/31/94   BY: taf *J038*                */
/* REVISION: 7.4      LAST MODIFIED: 11/17/94   BY: bcm *GO37*                */
/* REVISION: 7.4      LAST MODIFIED: 02/16/95   BY: jxz *F0JC*                */
/* REVISION: 7.4      LAST MODIFIED: 10/09/95   BY: ais *G0YP*                */
/* REVISION: 7.4      LAST MODIFIED: 11/09/95   BY: jym *G1BR*                */
/* REVISION: 8.5      LAST MODIFIED: 10/09/95   BY: taf *J053*                */
/* REVISION: 7.4      LAST MODIFIED: 01/09/96   BY: emb *G1GX*                */
/* REVISION: 7.4      LAST MODIFIED: 01/09/96   BY: ais *G1JL*                */
/* REVISION: 8.5      LAST MODIFIED: 02/15/96   BY: tjs *J0CZ*                */
/* REVISION: 8.6      LAST MODIFIED: 09/03/96   BY: jzw *K008*                */
/* REVISION: 8.6      LAST MODIFIED: 10/18/96   BY: *K003* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 11/25/96   BY: *K01X* Jeff Wootton       */
/* REVISION: 8.6      LAST MODIFIED: 01/08/97   BY: *H0QF* Sue Poland         */
/* REVISION: 8.6      LAST MODIFIED: 03/05/97   BY: *H0SW* Robin McCarthy     */
/* REVISION: 8.6      LAST MODIFIED: 04/18/97   BY: *H0Y5* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 04/24/97   BY: *H0YF* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 02/09/98   BY: *H1JJ* Sandesh Mahagaokar */
/* REVISION: 8.6E     LAST MODIFIED: 04/21/98   BY: *H1KV* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 06/17/98   BY: *L020* Charles Yen        */
/* REVISION: 8.6E     LAST MODIFIED: 08/18/98   BY: *J2WM* Aruna Patil        */
/* REVISION: 8.6E     LAST MODIFIED: 09/30/98   BY: *H1NB* Seema Varma        */
/* REVISION: 8.6E     LAST MODIFIED: 11/02/98   BY: *H1N8* Felcy D'Souza      */
/* REVISION: 9.0      LAST MODIFIED: 04/16/99   BY: *J2DG* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 06/30/99   BY: *J3HK* Kedar Deherkar     */
/* REVISION: 9.0      LAST MODIFIED: 09/03/99   BY: *K22C* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* PATTI GAULTNEY     */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *M0F5* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 11/17/99   BY: *N04H* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 01/11/00   BY: *J3N7* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Thelma Stronge     */
/* REVISION: 9.1      LAST MODIFIED: 04/11/00   BY: *N090* Luke Pokic         */
/* REVISION: 9.1      LAST MODIFIED: 06/08/00   BY: *M0ND* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *N0RF* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/04/00   BY: *M0SQ* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 10/12/00   BY: *N0H2* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 10/06/00   BY: *N0WT* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 01/19/01   BY: *L17B* Nikita Joshi       */
/* REVISION: 9.1      LAST MODIFIED: 10/22/01   BY: *M1N4* Irine Fernandes    */
/* REVISION: 9.1      LAST MODIFIED: 12/22/01   BY: *M1S7* Dipesh Bector      */
/* REVISION: 9.1      LAST MODIFIED: 02/22/02   BY: *N19Y* Kirti Desai        */
/* REVISION: 9.1      LAST MODIFIED: 06/23/02   BY: *N1KB* Rajiv Ramaiah      */
/* REVISION: eB(SP5)     LAST MODIFIED: 08/16/06    BY: Apple      *EAS055A*   */

/*J2DG*/ /* ADDED NO-UNDO  AND ASSIGN  WHEREVER MISSING                    */
/*J2DG*/ /* REPLACED FIND STATEMENTS WITH FOR FIRST FOR ORACLE PERFORMANCE */

/*N19Y*/ /* ADDED FIELD sr__qadc01 IN EXISITING FIELDLIST FOR sr_wkfl      */

         {mfdeclre.i}
/*N0WT*/ {cxcustom.i "POPORCB6.P"}

/*L020*/ define variable mc-error-number like msg_nbr no-undo.
         {porcdef.i}

         define input parameter shipnbr        like tr_ship_id      no-undo.
         define input parameter ship_date      like tr_ship_date    no-undo.
         define input parameter inv_mov        like tr_ship_inv_mov no-undo.

         define shared variable rndmthd         like rnd_rnd_mthd.
         define variable glamt as decimal             no-undo.
         define variable docamt as decimal            no-undo.
         define variable tmp_amt as decimal           no-undo.
         define variable l_ro_routing like ro_routing no-undo.

         define new shared variable totl_qty_this_rcpt like pod_qty_chg no-undo.
         define new shared variable last_sr_wkfl as logical no-undo.
         define new shared variable accum_taxamt like tx2d_tottax no-undo.

         define shared variable trqty           like tr_qty_chg.
         define shared variable qty_ord         like pod_qty_ord.
         define shared variable stdcst          like tr_price.
         define shared variable old_status      like pod_status.
         define shared variable receivernbr     like prh_receiver.
         define shared variable lotser          like sod_serial.
         define shared variable conv_to_stk_um  as decimal.
         define shared variable gl_amt          like trgl_gl_amt extent 6.
         define shared variable dr_acct         like trgl_dr_acct extent 6.
/*N014*/ define shared variable dr_sub          like trgl_dr_sub extent 6.
         define shared variable dr_cc           like trgl_dr_cc extent 6.
         define shared variable dr_proj         like trgl_dr_proj extent 6.
         define shared variable cr_acct         like trgl_cr_acct extent 6.
/*N014*/ define shared variable cr_sub          like trgl_cr_sub extent 6.
         define shared variable cr_cc           like trgl_cr_cc extent 6.
         define shared variable cr_proj         like trgl_cr_proj extent 6.
         define shared variable price           like tr_price.
         define shared variable qty_oh          like in_qty_oh.
         define shared variable openqty         like mrp_qty.
         define shared variable rcv_type        like poc_rcv_type.
         define shared variable wr_recno        as recid.
         define        variable i               as integer no-undo.
         define shared variable entity          like si_entity extent 6.
         define shared variable pod_entity      like si_entity.
         define shared variable pod_po_entity   like si_entity.
         define shared variable project         like prh_project.
         define shared variable sct_recno       as recid.
         define shared variable rct_site        like pod_site.
         define shared variable poddb           like pod_po_db.
         define shared variable podpodb         like pod_po_db.
         define shared variable new_db          like si_db.
         define shared variable old_db          like si_db.
         define shared variable new_site        like si_site.
         define shared variable old_site        like si_site.
         define buffer poddet for pod_det.
         define shared variable yes_char        as character format "x(1)".
         define shared variable undo_all        like mfc_logical no-undo.
         define shared variable newmtl_tl       as decimal.
         define shared variable newlbr_tl       as decimal.
         define shared variable newbdn_tl       as decimal.
         define shared variable newovh_tl       as decimal.
         define shared variable newsub_tl       as decimal.
         define shared variable newmtl_ll       as decimal.
         define shared variable newlbr_ll       as decimal.
         define shared variable newbdn_ll       as decimal.
         define shared variable newovh_ll       as decimal.
         define shared variable newsub_ll       as decimal.
         define shared variable newcst          as decimal.
         define shared variable glx_mthd        like cs_method.
         define shared variable reavg_yn        as logical.
         define        variable line_tax        like trgl_gl_amt   no-undo.
         define        variable type_tax        like trgl_gl_amt   no-undo.
         define        variable accum_type_tax  like type_tax      no-undo.
         define shared variable crtint_amt      like trgl_gl_amt.
/*N014* *****************************BEGIN DELETE******************************
 *          define shared variable poc_crtacc_acct like gl_crterms_acct.
 *          define shared variable poc_crtacc_cc   like gl_crterms_cc.
 *          define shared variable poc_crtapp_acct like gl_crterms_acct.
 *          define shared variable poc_crtapp_cc   like gl_crterms_cc.
 *N014* *****************************END DELETE***************************** */
         define new shared variable srvendlot   like tr_vend_lot no-undo.
         define shared variable msg-nbr         like tr_msg.
         define        variable l_ppv_amt       like trgl_gl_amt   no-undo.
/*H1N8*/ define shared variable nrecov_tax_avg  like tx2d_tottax   no-undo.
/*J3HK*/ define variable l_extbase_amt          like trgl_gl_amt   no-undo.
/*N05Q*/ define shared variable prm-avail       like mfc_logical   no-undo.
/*M1N4*/ define shared variable s_base_amt      like base_amt      no-undo.
/*M1N4*/ define shared variable cur_mthd        like cs_method.
/*M1N4*/ define shared variable cur_set         like cs_set.
/*M1N4*/ define shared variable glx_set         like cs_set.
/*M1N4*/ define shared variable msg-num         like tr_msg.
/*N05Q*/ define variable invntry-trnbr          like trgl_trnbr    no-undo.
/*M0ND*/ define variable l_glxcst               like glxcst        no-undo.
/*L17B*/ define variable l_base_amt             like base_amt      no-undo.
/*L17B*/ define variable l_sct_cst_tot          like sct_cst_tot   no-undo.
/*L17B*/ define variable l_sct_ovh_tl           like sct_ovh_tl    no-undo.
/*L17B*/ define variable l_newcst               like sct_cst_tot   no-undo.
/*L17B*/ define variable l_newovh_tl            like sct_ovh_tl    no-undo.
/*L17B*/ define variable l_total_cost           like sct_cst_tot   no-undo.
/*N1KB** /*L17B*/ define variable l_tmpamt      like trgl_gl_amt   no-undo. */
/*M1N4*/ define variable l_assay                like tr_assay      no-undo.
/*M1N4*/ define variable l_expire               like tr_expire     no-undo.
/*M1N4*/ define variable l_glcost               like sct_cst_tot   no-undo.
/*M1N4*/ define variable l_grade                like tr_grade      no-undo.
/*N1KB*/ define variable l_tv_amt               like trgl_gl_amt   no-undo.

/*N1KB** /*L17B*/ define stream disp_cst. */

         define shared workfile posub
                           field    posub_nbr       as character
                           field    posub_line      as integer
                           field    posub_qty       as decimal
                           field    posub_wolot     as character
                           field    posub_woop      as integer
                           field    posub_gl_amt    like glt_amt
                           field    posub_cr_acct   as character
/*N014*/                   field    posub_cr_sub    as character
                           field    posub_cr_cc     as character
                           field    posub_effdate   as date
/*K22C*/                   field    posub_site      like sr_site
/*K22C*/                   field    posub_loc       like sr_loc
/*K22C*/                   field    posub_lotser    like sr_lotser
/*K22C*/                   field    posub_ref       like sr_ref
                           field    posub_move      as logical.

/*J2DG** BEGIN DELETE **
 *       find pod_det where pod_recno = recid(pod_det) no-error.
 *       find po_mstr where po_nbr    = pod_nbr no-error.
 *       find pt_mstr where pt_recno  = recid(pt_mstr) no-lock no-error.
 *       find sct_det where sct_recno = recid(sct_det) no-error.
 *
 *       find first gl_ctrl  no-lock.
 *       find first icc_ctrl no-lock.
 *J2DG** END DELETE */

/*J2DG*/ /* DOWN GRADED TO A NO-LOCK SEE NO REASON FOR SHARE-LOCK */

/*J2DG*/ for first pod_det
/*J2DG*/    fields (pod_acct
/*N014*/            pod_sub
/*M0ND*/            pod_sod_line pod_um_conv
/*J2DG*/            pod_cc pod_line pod_nbr pod_op pod_part
/*J2DG*/            pod_project pod_qty_chg pod_qty_rcvd pod_rma_type
/*J2DG*/            pod_site pod_taxable pod_type pod_wo_lot)
/*J2DG*/    where pod_recno = recid(pod_det) no-lock:
/*J2DG*/ end. /* FOR FIRST POD_DET */

/*J2DG*/ for first po_mstr
/*M0ND** /*J2DG*/ fields (po_curr po_nbr po_tax_pct) */
/*M0ND*/    fields (po_curr po_is_btb po_nbr po_so_nbr po_tax_pct)
/*J2DG*/    where po_nbr    = pod_nbr no-lock:
/*J2DG*/ end. /* FOR FIRST PO_MSTR */

/*J2DG*/ for first pt_mstr
/*M0ND** /*J2DG*/ fields (pt_part pt_prod_line pt_routing) */
/*M0ND*/    fields (pt_part pt_pm_code pt_prod_line pt_routing)
/*J2DG*/    where pt_recno  = recid(pt_mstr) no-lock:
/*J2DG*/ end. /*FOR FIRST PT_MSTR */

/*J2DG*/ for first sct_det
/*J2DG*/    where sct_recno = recid(sct_det) no-lock:
/*J2DG*/ end. /*FOR FIRST SCT_DET */


/*J2DG*/ for first gl_ctrl
/*J2DG*/    fields (gl_can gl_rcptx_acct
/*N014*/            gl_rcptx_sub
/*J2DG*/            gl_rcptx_cc gl_rnd_mthd gl_vat)
/*J2DG*/    no-lock:
/*J2DG*/ end. /* FOR FIRST Gl_CTRL */


/*J2DG*/ for first icc_ctrl
/*J2DG*/    fields ( icc_ico_acct
/*N014*/             icc_ico_sub
/*J2DG*/             icc_ico_cc) no-lock:
/*J2DG*/ end. /* FOR FIRST ICC_CTRL */

         if {txnew.i} then do:
            assign
               last_sr_wkfl = no
               accum_type_tax = 0
               accum_taxamt = 0
               totl_qty_this_rcpt = 0.

            for each sr_wkfl
/*J2DG*/       fields (sr_lineid sr_loc sr_lotser sr_qty sr_ref
/*J2DG*/               sr_site sr_userid sr_vend_lot sr__qadc01) no-lock
               where sr_userid = mfguser
               and sr_lineid = string(pod_line) :
               assign totl_qty_this_rcpt = totl_qty_this_rcpt
                                  + if is-return then ( - sr_qty) else sr_qty.
            end.
         end.

         srloop:
         for each sr_wkfl
/*J2DG*/    fields (sr_lineid sr_loc sr_lotser sr_qty sr_ref
/*J2DG*/            sr_site sr_userid sr_vend_lot sr__qadc01)
            where sr_userid = mfguser
              and sr_lineid = string(pod_line) no-lock
            break by sr_userid:

            if last(sr_userid) then
/*M0F5*/       last_sr_wkfl = yes.

/*J3N7*/    /* DURING EMT, WHEN CONFIRMING THE PO SHIPPER IMPORTED FROM    */
/*J3N7*/    /* SBU AT THE PBU, RETREIVING THE QUANTITY IN INVENTORY UM FOR */
/*J3N7*/    /* ORDER IN ALTERNATE UM TO AVOID ROUNDING ERRORS IN LD_DET    */
/*J3N7*/    if execname = "rsporc.p" then
/*J3N7*/    do:
/*J3N7*/       if pod_um_conv <> 1 then
/*J3N7*/          trqty = decimal(sr__qadc01).
/*J3N7*/       else
/*J3N7*/          trqty = sr_qty.
/*J3N7*/    end. /* IF EXECNAME = "RSPORC.P" */
/*J3N7*/    else do:
/*J3N7*/       if is-return then
/*J3N7*/          trqty = (- sr_qty) * conv_to_stk_um.
/*J3N7*/       else
/*J3N7*/          trqty = sr_qty * conv_to_stk_um.
/*J3N7*/    end. /* ELSE DO */

            assign
/*M1N4*/       l_assay    = 0
/*M1N4*/       l_expire   = ?
/*M1N4*/       l_glcost   = 0
/*M1N4*/       l_grade    = ""
/*M0F5**       last_sr_wkfl = yes  */
/*J3N7**       trqty      = if is-return then ( - sr_qty) else sr_qty */
               site       = sr_site
               location   = sr_loc
               lotser     = sr_lotser
               lotref     = sr_ref
               srvendlot  = sr_vend_lot
/*L17B**       base_amt   = price. */
/*J3N7**       trqty      = trqty * conv_to_stk_um. */
/*L17B*/       base_amt   = price
/*L17B*/       l_base_amt = base_amt.

            do i = 1 to 6:
               assign
                      dr_acct[i] = ""
/*N014*/              dr_sub[i]  = ""
                      dr_cc[i]   = ""
                      dr_proj[i] = ""
                      cr_acct[i] = ""
/*N014*/              cr_sub[i]  = ""
                      cr_cc[i]   = ""
                      cr_proj[i] = ""
                      entity[i]  = ""
                      gl_amt[i]  = 0.
            end.
            assign line_tax = 0.

            /* IN ORDER TO ENSURE ACCURATE CALCULATIONS, IF AMOUNT BEING  */
            /* MULTIPLIED IS STORED IN DOCUMENT CURRENCY THEN CALCULATE   */
            /* IN DOCUMENT CURRENCY THEN PERFORM CONVERSION AND ROUND PER */
            /* BASE CURRENCY. */

            /* BASE_AMT IS IN DOCUMENT CURRENCY */
            /* CALCULATE GLAMT BASED UNIT PRICE AND TRQTY */
            assign glamt = base_amt * trqty.
/*H1N8**    assign glamt = base_amt * trqty. */

/*H1N8*/    assign glamt = (base_amt + if (pod_type = "S" and
/*H1N8*/                                   glx_mthd = "AVG") then
/*H1N8*/                                   nrecov_tax_avg
/*H1N8*/                               else 0) * trqty.

            /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
/*L020*     {gprun.i ""gpcurrnd.p"" "(input-output glamt, */
/*L020*/    {gprunp.i "mcpl" "p" "mc-curr-rnd"
             "(input-output glamt,
               input rndmthd,
/*L020*/       output mc-error-number)"}
            assign docamt = glamt.   /* SAVE IN DOC CURRENCY */

            /* IF NECESSARY CONVERT GLAMT TO BASE */
            if po_curr <> base_curr
            then do:
/*L020*        glamt = glamt / exch_rate.
*L020*/
/*L020*/       /* CONVERT GLAMT TO BASE */
/*L020*/       {gprunp.i "mcpl" "p" "mc-curr-conv"
                "(input po_curr,
                  input base_curr,
                  input exch_rate,
                  input exch_rate2,
                  input glamt,
                  input true, /* DO ROUND */
                  output glamt,
                  output mc-error-number)"}.
/*L020*/       if mc-error-number <> 0 then do:
/*L020*/          {mfmsg.i mc-error-number 2}
/*L020*/       end.

               /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*        {gprun.i ""gpcurrnd.p"" "(input-output glamt,
*               input gl_rnd_mthd)"}
*L020*/
            end.

            /* BASE_AMT IS THE UNIT PRICE */
            /* IF NECESSARY CONVERT BASE_AMT TO BASE CURRENCY */
            if po_curr <> base_curr then
/*L020*        base_amt = base_amt / exch_rate.
*L020*/

/*L020*/       do:
/*L020*/       {gprunp.i "mcpl" "p" "mc-curr-conv"
                "(input po_curr,
                  input base_curr,
                  input exch_rate,
                  input exch_rate2,
                  input base_amt,
                  input false, /* DO NOT ROUND */
                  output base_amt,
                  output mc-error-number)"}.
/*L020*/       end.

/*N0WT*/    {&POPORCB6-P-TAG1}
            /*INVENTORY ITEM RECEIPTS*/
            if available pt_mstr and pod_type = "" then do:

/*J2DG**   find pl_mstr where pl_prod_line = pt_prod_line no-lock no-error. **/

/*J2DG*/       for first pl_mstr
/*J2DG*/          fields (pl_cop_acct
/*N014*/                  pl_cop_sub
/*J2DG*/                  pl_cop_cc
/*J2DG*/                  pl_inv_acct
/*N014*/                  pl_inv_sub
/*J2DG*/                  pl_inv_cc
/*J2DG*/                  pl_ovh_acct
/*N014*/                  pl_ovh_sub
/*J2DG*/                  pl_ovh_cc
/*J2DG*/                  pl_ppv_acct
/*N014*/                  pl_ppv_sub
/*J2DG*/                  pl_ppv_cc
/*J2DG*/                  pl_prod_line
/*J2DG*/                  pl_rcpt_acct
/*N014*/                  pl_rcpt_sub
/*J2DG*/                  pl_rcpt_cc)
/*J2DG*/          where pl_prod_line = pt_prod_line no-lock:
/*J2DG*/       end. /* FOR FIRST PL_MSTR  */
/*N0WT*/       {&POPORCB6-P-TAG2}
               assign
                      dr_acct[1]    = pl_inv_acct
/*N014*/              dr_sub[1]     = pl_inv_sub
                      dr_cc[1]      = pl_inv_cc
                      dr_proj[1]    = pod_proj
                      cr_acct[1]    = pl_rcpt_acct
/*N014*/              cr_sub[1]     = pl_rcpt_sub
                      cr_cc[1]      = pl_rcpt_cc
                      cr_proj[1]    = pod_proj
                      entity[1]     = pod_entity
/*L17B**              gl_amt[1]     = trqty * (sct_cst_tot - sct_ovh_tl). */
/*N1KB*/              gl_amt[1]     = trqty * (sct_cst_tot - sct_ovh_tl)
/*L17B*/              l_sct_cst_tot = sct_cst_tot
/*L17B*/              l_sct_ovh_tl  = sct_ovh_tl.
/*N0WT*/       {&POPORCB6-P-TAG3}

/*N1KB*/       /* TO OBTAIN DEFAULT UNIT PRICE (l_total_cost) IN PO CURRENCY */
/*L17B*/       run p-costconv(input l_sct_cst_tot, input l_sct_ovh_tl).

/*M0ND*/      /* CALCULATING GL_AMT FOR ATO/KIT ITEMS FOR AN EMT PO */
/*M0ND*/      /* TO REFLECT ENTIRE CONFIGURATION COST               */
/*M0ND*/      if po_is_btb and
/*M0ND*/         pt_pm_code = "c" then
/*M0ND*/      do:
/*M0ND*/         run p-price-configuration.
/*M0ND*/         gl_amt[1] = gl_amt[1] + l_glxcst.
/*M0ND*/      end. /* IF PO_IS_BTB AND PT_PM_CODE = "C" */

/*L17B** BEGIN DELETE **
 *             /* ROUND PER BASE CURRENCY ROUND METHOD */
 * /*L020*     {gprun.i ""gpcurrnd.p"" "(input-output gl_amt[1], */
 * /*L020*/    {gprunp.i "mcpl" "p" "mc-curr-rnd"
 *              "(input-output gl_amt[1],
 *                input gl_rnd_mthd,
 * /*L020*/       output mc-error-number)"}
 *L17B** END DELETE */

/*N1KB** /*L17B*/ run p-poconv(input-output gl_amt[1]). */

/*N1KB*/       /* ROUND PER BASE CURRENCY ROUND METHOD */
/*N1KB*/       {gprunp.i "mcpl" "p" "mc-curr-rnd"
                  "(input-output gl_amt[1],
                    input        gl_rnd_mthd,
                    output       mc-error-number)"}

/*J2DG**  BEGIN DELETE **
 *               find pld_det
 *                   where pld_prodline = pt_prod_line
 *                   and pld_site = pod_site and pld_loc = location
 *                   no-lock no-error.
 *J2DG**  END DELETE **/

/*J2DG*/       for first pld_det
/*J2DG*/          fields (pld_inv_acct
/*N014*/                  pld_inv_sub
/*J2DG*/                  pld_inv_cc pld_loc pld_prodline pld_site)
/*J2DG*/          where pld_prodline = pt_prod_line
/*J2DG*/          and   pld_site     = pod_site
/*J2DG*/          and   pld_loc      = location no-lock:
/*J2DG*/       end. /* FOR FIRST PLD_DET */

               if not available pld_det then do:

/*J2DG**  BEGIN DELETE **
 *                find pld_det
 *                where pld_prodline = pt_prod_line and pld_site = pod_site
 *                   and pld_loc = "" no-lock no-error.
 *J2DG**  END DELETE **/

/*J2DG*/          for first pld_det
/*J2DG*/             fields (pld_inv_acct
/*N014*/                     pld_inv_sub
/*J2DG*/                     pld_inv_cc pld_loc
/*J2DG*/                     pld_prodline pld_site)
/*J2DG*/             where pld_prodline = pt_prod_line
/*J2DG*/             and   pld_site     = pod_site
/*J2DG*/             and   pld_loc      = "" no-lock:
/*J2DG*/          end. /* FOR FIRST PLD_DET */

                  if not available pld_det then do:

/*J2DG**  BEGIN DELETE **
 *                   find pld_det
 *                   where pld_prodline = pt_prod_line and pld_site = ""
 *                   and pld_loc = "" no-lock no-error.
 *J2DG**  END DELETE **/

/*J2DG*/             for first pld_det
/*J2DG*/                fields (pld_inv_acct
/*N014*/                        pld_inv_sub
/*J2DG*/                        pld_inv_cc pld_loc
/*J2DG*/                        pld_prodline pld_site)
/*J2DG*/                where pld_prodline = pt_prod_line
/*J2DG*/                and   pld_site     = ""
/*J2DG*/                and   pld_loc      = "" no-lock:
/*J2DG*/             end. /* FOR FIRST PLD_DET */

                  end.
               end.

               if available pld_det then
                  assign
                         dr_acct[1] = pld_inv_acct
/*N014*/                 dr_sub[1]  = pld_inv_sub
                         dr_cc[1]   = pld_inv_cc.

               /*OVERHEAD RECEIPT*/
               assign
                      dr_acct[2] = pl_inv_acct
/*N014*/              dr_sub[2]  = pl_inv_sub
                      dr_cc[2]   = pl_inv_cc
                      dr_proj[2] = pod_proj
                      cr_acct[2] = pl_ovh_acct
/*N014*/              cr_sub[2]  = pl_ovh_sub
                      cr_cc[2]   = pl_ovh_cc
                      cr_proj[2] = pod_proj
                      entity[2]  = pod_entity
                      gl_amt[2]  = trqty * sct_ovh_tl.

               /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*        {gprun.i ""gpcurrnd.p"" "(input-output gl_amt[2], */
/*L020*/       {gprunp.i "mcpl" "p" "mc-curr-rnd"
                "(input-output gl_amt[2],
                  input gl_rnd_mthd,
/*L020*/          output mc-error-number)"}

               if available pld_det then
                  assign
                         dr_acct[2] = pld_inv_acct
/*N014*/                 dr_sub[2]  = pld_inv_sub
                         dr_cc[2]   = pld_inv_cc.

               if {txnew.i} then do:
/*J2WM*/          assign type_tax = 0
                         line_tax = 0.
                  /* NON-RECOVERABLE TAXES GO INTO PPV */
                  for each tx2d_det
/*J2DG*/          fields (tx2d_cur_recov_amt tx2d_cur_tax_amt tx2d_line tx2d_nbr
                          tx2d_rcpt_tax_point tx2d_ref tx2d_tax_in tx2d_tr_type)
          where tx2d_tr_type = tax_tr_type and
                        tx2d_ref = receivernbr and tx2d_nbr = po_nbr and
/*J2WM**                tx2d_line = pod_line no-lock: */
/*J2WM*/                tx2d_line = pod_line no-lock break by tx2d_line:

/*J2WM**             type_tax = 0. */

                        if tx2d_rcpt_tax_point then do:
                           /* ACCRUE TAX AT RECEIPT */
                           /* TAX INCLUDED = NO */
                           if not tx2d_tax_in then
                           do:

/*J2WM*/            /* ACCUMULATE TAXES FOR MULTIPLE TAX TYPES */
/*J2WM*/                    if last_sr_wkfl then
/*J2WM**                      type_tax = */
/*J2WM*/                      assign type_tax = type_tax +
                                 tx2d_cur_tax_amt - tx2d_cur_recov_amt.
/*J2WM*/                else
/*J2WM*/                      assign type_tax = type_tax *
/*J2WM*/                        (totl_qty_this_rcpt / trqty) +
/*J2WM*/                                        (tx2d_cur_tax_amt -
/*J2WM*/                                         tx2d_cur_recov_amt).

                             /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
                                TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS
                                NOT BEEN ASSIGNED TO OTHER TRANSACTIONS. */
                              if last_sr_wkfl then do:
/*J2WM**                         if type_tax <> 0 then */
/*J2WM*/                         if type_tax <> 0 and last-of(tx2d_line) then
                                    assign type_tax = type_tax - accum_type_tax.
                              end.
                              else
                                 if totl_qty_this_rcpt <> 0 then do:
                                    assign type_tax = type_tax
                                       * (trqty / totl_qty_this_rcpt).
                                    /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                             {gprun.i ""gpcurrnd.p"" */
/*L020*/                            {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                       "(input-output type_tax,
                                       input gl_rnd_mthd,
/*L020*/                               output mc-error-number)"}
                                 end.
                           end.
                           else
                              /* TAX INCLUDED = YES */
                           do:
                              assign type_tax = - tx2d_cur_recov_amt.
                             /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
                                TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS
                                NOT BEEN ASSIGNED TO OTHER TRANSACTIONS. */
                              if last_sr_wkfl then do:
                                 if type_tax <> 0 then
                                    assign type_tax = type_tax - accum_type_tax.
                                 else
                                    if totl_qty_this_rcpt <> 0 then do:
                                       assign type_tax = type_tax
                                                * (trqty / totl_qty_this_rcpt).
                                      /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                                {gprun.i ""gpcurrnd.p"" */
/*L020*/                               {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                          "(input-output type_tax,
                                          input gl_rnd_mthd,
/*L020*/                                  output mc-error-number)"}
                                    end.
                              end.
                              else
                                 if totl_qty_this_rcpt <> 0 then do:
                                    assign type_tax = type_tax
                                             * (trqty / totl_qty_this_rcpt).
                                    /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                             {gprun.i ""gpcurrnd.p"" */
/*L020*/                            {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                       "(input-output type_tax,
                                       input gl_rnd_mthd,
/*L020*/                               output mc-error-number)"}
                                 end.
                           end.
                        end.
                        else
                           /* ACCRUE TAX AT VOUCHER */
                           if tx2d_tax_in then
                              /* TAX INCLUDED = YES */
                           do:
                              assign type_tax = - tx2d_cur_tax_amt.
                             /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
                                TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS
                                NOT BEEN ASSIGNED TO OTHER TRANSACTIONS. */
                              if last_sr_wkfl then do:
                                 if type_tax <> 0 then
                                    assign type_tax = type_tax - accum_type_tax.
                                 else
                                    if totl_qty_this_rcpt <> 0 then do:
                                       assign type_tax = type_tax
                                                * (trqty / totl_qty_this_rcpt).
                                      /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                                {gprun.i ""gpcurrnd.p"" */
/*L020*/                               {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                          "(input-output type_tax,
                                          input gl_rnd_mthd,
/*L020*/                                  output mc-error-number)"}
                                    end.
                              end.
                              else
                                 if totl_qty_this_rcpt <> 0 then do:
                                    assign type_tax = type_tax
                                             * (trqty / totl_qty_this_rcpt).
                                    /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                             {gprun.i ""gpcurrnd.p"" */
/*L020*/                            {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                       "(input-output type_tax,
                                       input gl_rnd_mthd,
/*L020*/                               output mc-error-number)"}
                                 end.
                           end.

/*H1NB** BEGIN DELETE **
 *                         if base_curr <> po_curr then
 *                         do:
/*L020                     type_tax = type_tax / exch_rate.
*L020*/
 *
 * /*L020*/           /* CONVERT TYPE_TAX TO BASE CURRENCY */
 * /*L020*/               {gprunp.i "mcpl" "p" "mc-curr-conv"
 *                         "(input po_curr,
 *                           input base_curr,
 *                           input exch_rate,
 *                           input exch_rate2,
 *                           input type_tax,
 *                           input true, /* DO ROUND */
 *                           output type_tax,
 *                           output mc-error-number)"}.
 * /*L020*/               if mc-error-number <> 0 then do:
 * /*L020*/                  {mfmsg.i mc-error-number 2}
 * /*L020*/               end.
 *
/*L020*                    {gprun.i ""gpcurrnd.p"" "(input-output type_tax,
*                             input gl_rnd_mthd)"}
*L020*/
 *                         end.
 *H1NB** END DELETE   */

/*J2WM*/                /* FOR MULTIPLE TAX TYPES, POPULATE accum_type_tax */
/*J2WM*/                /* AT LAST TAX TYPE */
/*J2WM*/                if last-of(tx2d_line) then
/*H1NB*/                do:
/*J2WM*/                   assign
/*H1NB**                     line_tax = line_tax + type_tax */
                             accum_type_tax = accum_type_tax + type_tax.
/*H1NB*/                   if base_curr <> po_curr then
/*H1NB*/                   do:

/*H1NB*/                      /* CONVERT TYPE_TAX TO BASE CURRENCY */
/*H1NB*/                      {gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input po_curr,
                                          input base_curr,
                                          input exch_rate,
                                          input exch_rate2,
                                          input type_tax,
                                          input true, /* DO ROUND */
                                          output type_tax,
                                          output mc-error-number)"}.
/*H1NB*/                      if mc-error-number <> 0 then do:
/*H1NB*/                         {mfmsg.i mc-error-number 2}
/*H1NB*/                      end.
/*H1NB*/                   end. /* IF BASE_CURR <> PO_CURR  */
/*H1NB*/                   assign line_tax = line_tax + type_tax.
/*H1NB*/                end. /* IF LAST-OF(TX2D_LINE)  */

                  end.
               end.
               /* If U.S. taxes, add taxes to total PPV */
               else if pod_taxable and not gl_vat and not gl_can
               then do:
                  assign line_tax = 0.
                  do i = 1 to 3:
                     /* DOCAMT IS (trqty * base_amt) IN DOCUMENT CURRENCY */
                     /* FIRST CALCULATE IN DOC CURRENCY THEN CONVERT IF NEEDED*/
                     assign tmp_amt = docamt * (po_tax_pct[i] / 100).
                     /* ROUND PER DOC CURRENCY ROUND METHOD */
/*L020*              {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt, */
/*L020*/             {gprunp.i "mcpl" "p" "mc-curr-rnd"
                      "(input-output tmp_amt,
                        input rndmthd,
/*L020*/                output mc-error-number)"}
                     /* CONVERT TMP_AMT IF NECESSARY */
                     if (base_curr <> po_curr)
                     then do:
/*L020*                 tmp_amt = tmp_amt / exch_rate.
*L020*/

/*L020*/        /* CONVERT TMP_AMT TO BASE CURRENCY */
/*L020*/            {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input po_curr,
                       input base_curr,
                       input exch_rate,
                       input exch_rate2,
                       input tmp_amt,
                       input true, /* DO ROUND */
                       output tmp_amt,
                       output mc-error-number)"}.
/*L020*/            if mc-error-number <> 0 then do:
/*L020*/               {mfmsg.i mc-error-number 2}
/*L020*/            end.

                        /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                 {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt,
*                        input gl_rnd_mthd)"}
*L020*/
                     end.
                     assign line_tax = line_tax + tmp_amt.
                  end.
               end.
/*H1KV** /*H1JJ*/  l_ppv_amt = trqty * (sct_cst_tot + sct_ovh_tl). */
/*L17B** /*H1KV*/  assign l_ppv_amt = trqty * (sct_cst_tot - sct_ovh_tl). */

/*N1KB*/       /* l_total_cost   :  THE DEFAULT UNIT PRICE IN PO MAINTENANCE */
/*N1KB*/       /* l_base_amt     :  PO PRICE                                 */
/*N1KB*/       /* l_extbase_amt  :  TOTAL EXTENDED AMOUNT                    */
/*N1KB*/       /* l_tv_amt       :  TOTAL VARIANCE                           */
/*N1KB*/       /* l_ppv_amt      :  PURCHASE PRICE VARIANCE                  */
/*N1KB*/       /* gl_amt[5]      :  EXCHANGE ROUNDING VARIANCE               */

/*N1KB*/       /* PURCHASE PRICE VARIANCE WILL EXIST ONLY IF THERE IS ANY    */
/*N1KB*/       /* DIFFERENCE BETWEEN l_total_cost AND l_base_amt.            */

/*N1KB*/       /* 1.  CALCULATE THE TOTAL VARIANCE USING THE UNROUNDED COST  */
/*N1KB*/       /*     (sct_cst_tot- sct_ovh_tl) AND THE PO PRICE.            */
/*N1KB*/       /* 2.  CALCULATE THE PPV USING l_total_cost AND PO PRICE.     */
/*N1KB*/       /* 3.  CALCULATE THE EXCHANGE ROUNDING VARIANCE USING THE     */
/*N1KB*/       /*     FOLLOWING FORMULA:                                     */
/*N1KB*/       /*     gl_amt[5] = l_tv_amt - l_ppv_amt                       */

/*N1KB*/       assign
/*N1KB*/          l_tv_amt  = trqty * (sct_cst_tot - sct_ovh_tl)
/*L17B*/          l_ppv_amt = trqty * l_total_cost.

/*M0ND*/       /* CALCULATING L_PPV_AMT FOR ATO/KIT ITEMS FOR AN EMT PO  */
/*M0ND*/       /* TO REFLECT ENTIRE CONFIGURATION COST                   */
/*M0ND*/       if pt_pm_code = "c" and
/*M0ND*/          po_is_btb then
/*M0ND*/       do:
/*M0ND*/          run p-price-configuration.
/*M0ND*/          l_ppv_amt = l_ppv_amt + l_glxcst.
/*M0ND*/       end. /* IF PT_PM_CODE - "C" ... */

/*L17B** BEGIN DELETE **
 *             /* ROUND PER BASE CURRENCY ROUND METHOD */
 * /*L020*        {gprun.i ""gpcurrnd.p"" "(input-output l_ppv_amt, */
 * /*L020*/    {gprunp.i "mcpl" "p" "mc-curr-rnd"
 *              "(input-output l_ppv_amt,
 *                input gl_rnd_mthd,
 * /*L020*/       output mc-error-number)"}
 *L17B** END DELETE */

/*N1KB*/       /* ROUND PER BASE CURRENCY ROUND METHOD */
/*N1KB*/       {gprunp.i "mcpl" "p" "mc-curr-rnd"
                  "(input-output l_tv_amt,
                    input        gl_rnd_mthd,
                    output       mc-error-number)"}

/*L17B*/       run p-poconv(input-output l_ppv_amt).

/*L17B** /*J3HK*/ l_extbase_amt = trqty * base_amt.   */
/*L17B*/       l_extbase_amt = trqty * l_base_amt.

/*L17B** BEGIN DELETE **
 * /*J3HK*/    {gprunp.i "mcpl" "p" "mc-curr-rnd"
 *              "(input-output l_extbase_amt,
 *                input gl_rnd_mthd,
 *                output mc-error-number)"}
 *L17B** END DELETE */

/*L17B*/       run p-poconv(input-output l_extbase_amt).

/*J3HK**       assign l_ppv_amt = (trqty * base_amt) - l_ppv_amt. */

/*N1KB*/       assign
/*N1KB*/          l_tv_amt   = l_extbase_amt - l_tv_amt
/*J3HK*/          l_ppv_amt  = l_extbase_amt - l_ppv_amt.

/*N1KB** BEGIN DELETE **
 *             /* ROUND PER BASE CURRENCY ROUND METHOD */
 * /*L020*        {gprun.i ""gpcurrnd.p"" "(input-output l_ppv_amt, */
 * /*L020*/       {gprunp.i "mcpl" "p" "mc-curr-rnd"
 *              "(input-output l_ppv_amt,
 *                input gl_rnd_mthd,
 * /*L020*/          output mc-error-number)"}
 *N1KB** END DELETE */

               /*PPV RECEIPT*/
/*N0WT*/       {&POPORCB6-P-TAG4}
               assign
                      dr_acct[3] = pl_ppv_acct
/*N014*/              dr_sub[3]  = pl_ppv_sub
                      dr_cc[3]   = pl_ppv_cc
                      dr_proj[3] = pod_proj
                      cr_acct[3] = pl_rcpt_acct
/*N014*/              cr_sub[3]  = pl_rcpt_sub
                      cr_cc[3]   = pl_rcpt_cc
                      cr_proj[3] = pod_proj
                      entity[3]  = pod_entity
                      gl_amt[3]  = line_tax + l_ppv_amt.
/*N0WT*/       {&POPORCB6-P-TAG5}
               /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*        {gprun.i ""gpcurrnd.p"" "(input-output gl_amt[3], */
/*L020*/       {gprunp.i "mcpl" "p" "mc-curr-rnd"
                "(input-output gl_amt[3],
                  input gl_rnd_mthd,
/*L020*/          output mc-error-number)"}

               if pod_entity <> pod_po_entity
                  or poddb <> podpodb then do:
                  /*INTERCOMPANY POSTING - INTERCO ACCT*/
/*N0WT*/          {&POPORCB6-P-TAG6}
                  assign
                         dr_acct[4] = pl_rcpt_acct
/*N014*/                 dr_sub[4]  = pl_rcpt_sub
                         dr_cc[4]   = pl_rcpt_cc
                         dr_proj[4] = pod_proj
                         cr_acct[4] = icc_ico_acct
/*N014*/                 cr_sub[4]  = icc_ico_sub
                         cr_cc[4]   = icc_ico_cc
                         cr_proj[4] = pod_proj
                         entity[4]  = pod_entity
                         gl_amt[4]  = glamt + line_tax.
                  /* G1JL logic incoporated into J0CZ during Feb '96 merge tjs*/

                         /* GLAMT WAS CALCULATED AND CONVERTED IN THE */
                         /* BEGINNING, NO NEED TO RECALCULATE. */

                  /*INTERCOMPANY POSTING - PO RECEIPTS ACCT*/
                  assign
                         dr_acct[6] = icc_ico_acct
/*N014*/                 dr_sub[6]  = icc_ico_sub
                         dr_cc[6]   = icc_ico_cc
                         dr_proj[6] = pod_proj
                         cr_acct[6] = pl_rcpt_acct
/*N014*/                 cr_sub[6]  = pl_rcpt_sub
                         cr_cc[6]   = pl_rcpt_cc
                         cr_proj[6] = pod_proj
                         entity[6]  = pod_po_entity
                         gl_amt[6]  = glamt + line_tax.
/*N0WT*/          {&POPORCB6-P-TAG7}

                         /* GLAMT WAS CALCULATED AND CONVERTED IN THE */
                         /* BEGINNING, NO NEED TO RECALCULATE. */
               end.

/*N1KB*/       /* BEGIN ADD */

               /* IN STANDARD GL COST ENVIRONMENT, FOR NON-BASE CURRENCY THE  */
               /* GL AMOUNT FOR INVENTORY ACCOUNT IS UPDATED CORRECTLY BASED  */
               /* ON THE (TOTAL COST - OVERHEAD COST) & QTY RECEIVED FOR AN   */
               /* ITEM. ALSO, THE ROUNDING DIFFERENCES BETWEEN THE INVENTORY  */
               /* ACCOUNT AND PO RECEIPT ACCOUNT ARE POSTED TO EXCHANGE       */
               /* ROUNDING ACCOUNT.                                           */

               if  glx_mthd               =  "STD"
               and po_curr                <> base_curr
               and (l_tv_amt - l_ppv_amt) <> 0
               then do:

                  for first cu_mstr
                     fields (cu_curr cu_ex_rnd_acct cu_ex_rnd_cc cu_ex_rnd_sub)
                     where cu_curr = po_curr
                  no-lock:
                  end. /* FOR FIRST cu_mstr */

                  if available cu_mstr
                  then
                     assign
                        dr_acct[5] = cu_ex_rnd_acct
                        dr_sub[5]  = cu_ex_rnd_sub
                        dr_cc[5]   = cu_ex_rnd_cc
                        dr_proj[5] = pod_proj
                        cr_acct[5] = pl_rcpt_acct
                        cr_sub[5]  = pl_rcpt_sub
                        cr_cc[5]   = pl_rcpt_cc
                        cr_proj[5] = pod_proj
                        entity[5]  = pod_entity
                        gl_amt[5]  = l_tv_amt - l_ppv_amt.

               end. /* IF glx_mthd = "STD" ... */
/*N1KB*/       /* END ADD */

/*M1N4*/      /* PO RETURNS AND NEGATIVE PO RECEIPTS UPDATE THE AVERAGE GL   */
/*M1N4*/      /* COST INCORRECTLY WHEN THE RETURN IS FROM A SITE DIFFERENT   */
/*M1N4*/      /* FROM THE PO LINE SITE.                                      */
/*M1N4*/      /* THE QOH AND CURRENT GL COST ARE INCORRECT, IF THE RETURN    */
/*M1N4*/      /* TRANSACTION IS PRIOR TO THE TRANSFER. TO CORRECT THIS,      */
/*M1N4*/      /* THE SEQUENCE OF TRANSFER TRANSACTION (ISS-TR & RCT-TR) AND  */
/*M1N4*/      /* RECEIPT TRANSACTION (RCT-PO/ISS-PRV) ARE NOW EXCHANGED      */

/*M1N4*/      /* icxfer1.p IS MOVED FROM poporcc.p TO poporcb6.p FOR         */
/*M1N4*/      /* NEGATIVE RECEIPT OF INVENTORY ITEMS                         */

/*M1N4*/       /* BEGIN ADD CODE */
               if  pod_type                = ""
               and site                    <> rct_site
               and trqty                   < 0
               and right-trim(po_fsm_type) = ""
               then do:

                  assign
                     global_part = pod_part
                     global_addr = po_vend.

                  if available pt_mstr
                  then do:

                     for first ld_det
                        fields (ld_assay ld_expire ld_grade ld_loc ld_lot
                                ld_part ld_qty_all ld_qty_frz ld_qty_oh ld_ref
                                ld_site ld_status)
                        where ld_site = site
                        and   ld_loc  = location
                        and   ld_part = pt_part
                        and   ld_lot  = lotser
                        and   ld_ref  = lotref
                        no-lock:

                        assign
                           l_assay  = ld_assay
                           l_grade  = ld_grade
                           l_expire = ld_expire.

                     end. /* FOR FIRST ld_det */

                  end. /* IF AVAILABLE pt_mstr */


                  {gprun.i ""icxfer1.p"" "(input receivernbr,
                                           input lotser,
                                           input lotref,
                                           input lotref,
                                           input trqty,
                                           input pod_nbr,
                                           input pod_line,
                                           input pod_so_job,
                                           input """",
                                           input cr_proj[1],
                                           input eff_date,
                                           input rct_site,
                                           input pt_loc,
                                           input site,
                                           input location,
                                           input no,
                                           input """",
                                           input ?,
                                           input """",
                                           output l_glcost,
                                           input-output l_assay,
                                           input-output l_grade,
                                           input-output l_expire)" }


                  if glx_mthd = "AVG"
                  or cur_mthd = "AVG"
                  or cur_mthd = "LAST"
                  then do:

                     {gprun.i ""csavg02.p""
                              "(input  pt_part,
                                input  pod_site,
                                input  transtype,
                                input  recid(pt_mstr),
                                input  po_nbr,
                                input  trqty,
                                input  s_base_amt,
                                input  glx_set,
                                input  glx_mthd,
                                input  cur_set,
                                input  cur_mthd,
                                output newmtl_tl,
                                output newlbr_tl,
                                output newbdn_tl,
                                output newovh_tl,
                                output newsub_tl,
                                output newmtl_ll,
                                output newlbr_ll,
                                output newbdn_ll,
                                output newovh_ll,
                                output newsub_ll,
                                output newcst,
                                output reavg_yn,
                                output msg-num)" }

                  end. /* IF glx_mthd = "AVG".... */

               end. /* IF pod_type = "" AND site <> rct_site  */
/*M1N4*/       /* END ADD CODE */

               /*RE-CALCULATE AVERAGE COST*/
               if glx_mthd = "AVG"
               then do:

                  if reavg_yn then do:
                     {gprun.i ""csavg03.p"" "(input recid(sct_det),
                                              input trqty,
                                              input newmtl_tl,
                                              input newlbr_tl,
                                              input newbdn_tl,
                                              input newovh_tl,
                                              input newsub_tl,
                                              input newmtl_ll,
                                              input newlbr_ll,
                                              input newbdn_ll,
                                              input newovh_ll,
                                              input newsub_ll)"
                     }
                   end.

/*L17B**          assign gl_amt[1]  = trqty * (newcst - newovh_tl). */

/*L17B*/          assign
/*L17B*/             l_newcst    =  newcst
/*L17B*/             l_newovh_tl = newovh_tl.

/*L17B*/          run p-costconv(input l_newcst, input l_newovh_tl).

/*L17B** BEGIN DELETE **
 *                /* ROUND PER BASE CURR ROUND METHOD */
 * /*L020*        {gprun.i ""gpcurrnd.p"" "(input-output gl_amt[1], */
 * /*L020*/       {gprunp.i "mcpl" "p" "mc-curr-rnd"
 *                 "(input-output gl_amt[1],
 *                   input gl_rnd_mthd,
 * /*L020*/          output mc-error-number)"}
 *L17B** END DELETE */

/*L17B*/ run p-poconv(input-output gl_amt[1]).

                  assign gl_amt[2]  = trqty * newovh_tl.
                  /* ROUND PER BASE CURR ROUND METHOD */
/*L020*           {gprun.i ""gpcurrnd.p"" "(input-output gl_amt[2], */
/*L020*/          {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output gl_amt[2],
                     input gl_rnd_mthd,
/*L020*/             output mc-error-number)"}

/*N05Q*/        /* INITIALISE gl_amt[3] TO ZERO SINCE PPV SHOULD NOT BE   */
/*N05Q*/        /* GENERATED AND POSTED IN AN AVERAGE COSTING ENVIRONMENT */
                  assign gl_amt[3]  = 0.

                  end. /* IF glx_mthd = "AVG" */

            end. /*if pod_type = ""*/

            /*SUBCONTRACT RECEIPTS*/
            else if available pt_mstr and pod_type = "S" then do:
/*J2DG**     find pl_mstr where pl_prod_line = pt_prod_line no-lock no-error. */
/*J2DG*/        for first pl_mstr
/*J2DG*/           fields(pl_cop_acct
/*N014*/                  pl_cop_sub
/*J2DG*/                  pl_cop_cc
/*J2DG*/                  pl_inv_acct
/*N014*/                  pl_inv_sub
/*J2DG*/                  pl_inv_cc
/*J2DG*/                  pl_ovh_acct
/*N014*/                  pl_ovh_sub
/*J2DG*/                  pl_ovh_cc
/*J2DG*/                  pl_ppv_acct
/*N014*/                  pl_ppv_sub
/*J2DG*/                  pl_ppv_cc
/*J2DG*/                  pl_prod_line
/*J2DG*/                  pl_rcpt_acct
/*N014*/                  pl_rcpt_sub
/*J2DG*/                  pl_rcpt_cc )
/*J2DG*/           where pl_prod_line = pt_prod_line no-lock:
/*J2DG*/        end. /* FOR FIRST PL_MSTR */

/*N0WT*/       {&POPORCB6-P-TAG8}
               assign
                      dr_acct[1] = pl_cop_acct
/*N014*/              dr_sub[1]  = pl_cop_sub
                      dr_cc[1]   = pl_cop_cc
                      dr_proj[1] = pod_proj
                      cr_acct[1] = pl_rcpt_acct
/*N014*/              cr_sub[1]  = pl_rcpt_sub
                      cr_cc[1]   = pl_rcpt_cc
                      cr_proj[1] = pod_proj
                      entity[1]  = pod_entity
                      gl_amt[1]  = glamt.
/*N0WT*/       {&POPORCB6-P-TAG9}
                      /* GLAMT WAS CALCULATED AND CONVERTED IN THE */
                      /* BEGINNING, NO NEED TO RECALCULATE. */

               assign wolot = pod_wo_lot
                      woop  = pod_op.

               if can-find(first wr_route
               where wr_lot = wolot and wr_op = woop)
               then do:
/*J2DG**          find wo_mstr where wo_lot = wolot.                  */
/*J2DG*/          for first wo_mstr
/*J2DG*/             fields(wo_lot wo_nbr wo_part wo_routing wo_status wo_type)
/*J2DG*/             where wo_lot = wolot no-lock:
/*J2DG*/          end. /* FOR FIRST WO_MSTR */

/*J2DG**          find wr_route where wr_lot = wolot and wr_op = woop. */
/*J2DG*/          find wr_route
/*J2DG*/             where wr_lot = wolot
/*J2DG*/             and   wr_op = woop exclusive-lock no-error.

                  assign wr_recno = recid(wr_route).

/* WHEN wo_type = 'c' and wo_nbr = "" AND wo_status = "r" THEN THIS     */
/* WORK ORDER WAS CREATED BY THE ADVANCED REPETETIVE MODULE.  THE       */
/* COSTING WILL BE DONE LATER IN removea.p WHICH HAS THE WORKFILE       */
                  if index ("FPC",wo_status) = 0 then do:
                     if wo_type = "c" and wo_nbr = ""
                     and wo_status = "r" then do:
                        create posub.

                        assign
                           posub_nbr     = po_nbr
                           posub_line    = pod_line
                           posub_qty     = trqty
                           posub_wolot   = pod_wo_lot
                           posub_woop    = pod_op
                           posub_gl_amt  = gl_amt[1]
                           posub_cr_acct = dr_acct[1]
/*N014*/                   posub_cr_sub  = dr_sub[1]
                           posub_cr_cc   = dr_cc[1]
                           posub_effdate = eff_date
/*K22C*/                   posub_site    = site
/*K22C*/                   posub_loc     = location
/*K22C*/                   posub_lotser  = lotser
/*K22C*/                   posub_ref     = lotref
                           posub_move    = move.

/*J2DG**  BEGIN DELETE **
 *                        find ro_det no-lock where ro_routing =
 *                        (if wo_routing <> "" then wo_routing
 *                          else wo_part)
 *                        and ro_op = woop no-error.
 *J2DG** END DELETE */

/*J2DG*/                   for first ro_det
/*J2DG*/                      fields( ro_mv_nxt_op ro_op ro_routing ro_sub_cost)
/*J2DG*/                      where ro_routing = ( if wo_routing <> "" then
/*J2DG*/                                              wo_routing
/*J2DG*/                                           else
/*J2DG*/                                              wo_part )
/*J2DG*/                      and ro_op = woop no-lock:
/*J2DG*/                   end. /* FOR FIRST RO_DET */

/*N0H2*/ /* REPLACED ro_sub_cost WITH wr_sub_cost AS THE LATTER BEING FREEZED */
/*N0H2*/ /* COST WOULD BE USED FOR CALCULATING SUBCONTRACT RATE VARIANCE      */

                        /* Added section */
/*N0H2**                stdcst = 0.               */
/*N0H2*/                stdcst = wr_sub_cost.
                        if available ro_det then do:

/*N04H** BEGIN DELETE SECTION
 *                         {rerosdef.i}
 *                         {rerosget.i
 *                            &routing=ro_routing
 *                            &op=ro_op
 *                            &start=ro_start
 *                            &lock=no-lock}
 *N04H** END DELETE SECTION */

                           assign
/*N0H2**                      stdcst = ro_sub_cost      */
                              posub_move = ro_mv_nxt_op.
                        end. /* IF AVAILABLE RO_DET ... */
                        else do:

/*N04H** BEGIN DELETE SECTION
 *                      {rewrsdef.i}
 *                      {rewrsget.i
 *                         &lot=wr_lot
 *                         &op=wr_op
 *                         &lock=no-lock}
 *N04H** END DELETE SECTION */

/*N0H2**                 assign                        */
/*N0H2**                    posub_move = wr_mv_nxt_op  */
/*N0H2**                    stdcst = wr_sub_cost.      */

/*N0H2*/                   posub_move = wr_mv_nxt_op.
                        end. /* ELSE DO */
                        /* End of added section */
                   end.
                     else do:
                        assign wr_po_nbr = pod_nbr.
                        {gprun.i ""porcsub.p""}
                     end.
                  end.
               end.
               else do:
                  assign l_ro_routing = "".

/*J2DG**          find ptp_det where ptp_part = pod_part and     */
/*J2DG**          ptp_site = pod_site no-lock no-error.          */
/*J2DG*/          for first ptp_det
/*J2DG*/             fields( ptp_part ptp_routing ptp_site )
/*J2DG*/             where ptp_part = pod_part
/*J2DG*/             and   ptp_site = pod_site no-lock:
/*J2DG*/          end. /* FOR FIRST PTP_DET */



                  if available ptp_det then do:
                     if ptp_routing <> "" then
                        assign l_ro_routing = ptp_routing.
                     else
                        assign l_ro_routing = pod_part.
                  end.
                  else do:
/*J2DG**             find pt_mstr where pt_part = pod_part no-lock no-error. */
/*J2DG*/             for first pt_mstr
/*M0ND** /*J2DG*/       fields( pt_part pt_prod_line pt_routing ) */
/*M0ND*/                fields(pt_part pt_pm_code pt_prod_line pt_routing)
/*J2DG*/                where pt_part = pod_part no-lock:
/*J2DG*/             end. /* FOR FIRST PT_MSTR */
                     if available pt_mstr then do:
                        if pt_routing <> "" then
                           assign l_ro_routing = pt_routing.
                        else
                           assign l_ro_routing = pod_part.
                     end.
                  end. /* not available ptp_det */
/*J2DG**                  find ro_det where ro_routing = l_ro_routing and */
/*J2DG**                  ro_op = woop no-lock no-error.                */

/*J2DG*/          for first ro_det
/*J2DG*/             fields(ro_mv_nxt_op ro_op ro_routing ro_sub_cost)
/*J2DG*/             where ro_routing = l_ro_routing
/*J2DG*/             and   ro_op = woop no-lock:
/*J2DG*/          end. /* FOR FIRST RO_DET */
                  if available ro_det then
                     assign stdcst = ro_sub_cost.
                  else
                     assign stdcst = 0.
               end. /* IF WORKORDER IS NOT AVAILABLE */

               if {txnew.i} then do:
/*J2WM*/          assign type_tax = 0
                         line_tax = 0.
                  /* NON-RECOVERABLE TAXES GO INTO PPV */
                  for each tx2d_det
/*J2DG*/          fields (tx2d_cur_recov_amt tx2d_cur_tax_amt tx2d_line tx2d_nbr
                          tx2d_rcpt_tax_point tx2d_ref tx2d_tax_in tx2d_tr_type)
          where tx2d_tr_type = tax_tr_type and
                     tx2d_ref = receivernbr and tx2d_nbr = po_nbr and
/*J2WM**             tx2d_line = pod_line no-lock: */
/*J2WM*/             tx2d_line = pod_line no-lock break by tx2d_line:

/*J2WM**             type_tax = 0. */

                        if tx2d_rcpt_tax_point then do:
                           /* ACCRUE TAX AT RECEIPT */
                           if not tx2d_tax_in then
                              /* TAX INCLUDED = NO */
                           do:
/*J2WM*/            /* ACCUMULATE TAXES FOR MULTIPLE TAX TYPES */
/*J2WM*/                      if last_sr_wkfl then
/*J2WM**                         type_tax = */
/*J2WM*/                         assign type_tax = type_tax +
                                 tx2d_cur_tax_amt - tx2d_cur_recov_amt.
/*J2WM*/                  else
/*J2WM*/                         assign type_tax = type_tax *
/*J2WM*/                        (totl_qty_this_rcpt / trqty) +
/*J2WM*/                                        (tx2d_cur_tax_amt -
/*J2WM*/                                         tx2d_cur_recov_amt).

                             /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
                                TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS
                                NOT BEEN ASSIGNED TO OTHER TRANSACTIONS. */
                              if last_sr_wkfl then do:
/*J2WM**                         if type_tax <> 0 then */
/*J2WM*/                         if type_tax <> 0 and last-of(tx2d_line) then
                                    assign type_tax = type_tax - accum_type_tax.
                              end.
                              else
                                 if totl_qty_this_rcpt <> 0 then do:
                                    assign type_tax = type_tax
                                       * (trqty / totl_qty_this_rcpt).
                                    /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                             {gprun.i ""gpcurrnd.p"" */
/*L020*/                            {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                       "(input-output type_tax,
                                       input gl_rnd_mthd,
/*L020*/                               output mc-error-number)"}
                                 end.
                           end.
                           else
                              /* TAX INCLUDED = YES */
                           do:
                              assign type_tax = - tx2d_cur_recov_amt.
                             /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
                                TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS
                                NOT BEEN ASSIGNED TO OTHER TRANSACTIONS. */
                              if last_sr_wkfl then do:
                                 if type_tax <> 0 then
                                    assign type_tax = type_tax - accum_type_tax.
                                 else
                                    if totl_qty_this_rcpt <> 0 then do:
                                       assign type_tax = type_tax
                                                * (trqty / totl_qty_this_rcpt).
                                      /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                                {gprun.i ""gpcurrnd.p"" */
/*L020*/                               {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                          "(input-output type_tax,
                                          input gl_rnd_mthd,
/*L020*/                                  output mc-error-number)"}
                                    end.
                              end.
                              else
                                 if totl_qty_this_rcpt <> 0 then do:
                                    assign type_tax = type_tax
                                             * (trqty / totl_qty_this_rcpt).
                                    /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                             {gprun.i ""gpcurrnd.p"" */
/*L020*/                            {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                       "(input-output type_tax,
                                       input gl_rnd_mthd,
/*L020*/                               output mc-error-number)"}
                                 end.
                           end.
                        end.
                        else
                           /* ACCRUE TAX AT VOUCHER */
                           if tx2d_tax_in then
                              /* TAX INCLUDED = YES */
                           do:
                              assign type_tax = - tx2d_cur_tax_amt.
                             /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
                                TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS
                                NOT BEEN ASSIGNED TO OTHER TRANSACTIONS. */
                              if last_sr_wkfl then do:
                                 if type_tax <> 0 then
                                    assign type_tax = type_tax - accum_type_tax.
                                 else
                                    if totl_qty_this_rcpt <> 0 then do:
                                       assign type_tax = type_tax
                                                * (trqty / totl_qty_this_rcpt).
                                      /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                                {gprun.i ""gpcurrnd.p"" */
/*L020*/                               {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                          "(input-output type_tax,
                                          input gl_rnd_mthd,
/*L020*/                                  output mc-error-number)"}
                                    end.
                              end.
                              else
                                 if totl_qty_this_rcpt <> 0 then do:
                                    assign type_tax = type_tax
                                             * (trqty / totl_qty_this_rcpt).
                                    /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                             {gprun.i ""gpcurrnd.p"" */
/*L020*/                            {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                       "(input-output type_tax,
                                       input gl_rnd_mthd,
/*L020*/                               output mc-error-number)"}
                                 end.
                           end.

/*H1NB** BEGIN DELETE **
 *                         if base_curr <> po_curr then
 *                         do:
/*L020*                    type_tax = type_tax / exch_rate.
*L020*/
 *
 * /*L020*/           /* CONVERT TYPE_TAX TO BASE CURRENCY */
 * /*L020*/               {gprunp.i "mcpl" "p" "mc-curr-conv"
 *                         "(input po_curr,
 *                           input base_curr,
 *                           input exch_rate,
 *                           input exch_rate2,
 *                           input type_tax,
 *                           input true, /* DO ROUND */
 *                           output type_tax,
 *                           output mc-error-number)"}.
 * /*L020*/               if mc-error-number <> 0 then do:
 * /*L020*/                  {mfmsg.i mc-error-number 2}
 * /*L020*/               end.
 *
 *                            /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                    {gprun.i ""gpcurrnd.p"" "(input-output type_tax,
 *                           input gl_rnd_mthd)"}
 *L020*/
 *                         end.
 *H1NB** END DELETE   */

/*J2WM*/                /* FOR MULTIPLE TAX TYPES, POPULATE accum_type_tax */
/*J2WM*/                /* AT LAST TAX TYPE */
/*J2WM*/                if last-of(tx2d_line) then
/*H1NB*/                do:
/*J2WM*/                   assign
/*H1NB**                     line_tax = line_tax + type_tax */
                             accum_type_tax = accum_type_tax + type_tax.
/*H1NB*/                   if base_curr <> po_curr then
/*H1NB*/                   do:

/*H1NB*/                      /* CONVERT TYPE_TAX TO BASE CURRENCY */
/*H1NB*/                      {gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input po_curr,
                                          input base_curr,
                                          input exch_rate,
                                          input exch_rate2,
                                          input type_tax,
                                          input true, /* DO ROUND */
                                          output type_tax,
                                          output mc-error-number)"}.
/*H1NB*/                      if mc-error-number <> 0 then do:
/*H1NB*/                         {mfmsg.i mc-error-number 2}
/*H1NB*/                      end.
/*H1NB*/                   end. /* IF BASE_CURR <> PO_CURR  */
/*H1NB*/                   assign line_tax = line_tax + type_tax.
/*H1NB*/                end. /* IF LAST-OF(TX2D_LINE)  */
                  end.
               end.
               /* If U.S. taxes, add taxes to total PPV */
               else if pod_taxable and not gl_vat and not gl_can
               then do:
                  assign line_tax = 0.
                  do i = 1 to 3:
                     /* DOCAMT IS (trqty * base_amt) IN DOCUMENT CURRENCY */
                     /* FIRST CALCULATE IN DOC CURRENCY THEN CONVERT IF NEEDED*/
                     assign tmp_amt = docamt * (po_tax_pct[i] / 100).
                     /* ROUND PER DOC CURRENCY ROUND METHOD */
/*L020*              {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt, */
/*L020*/             {gprunp.i "mcpl" "p" "mc-curr-rnd"
                      "(input-output tmp_amt,
                        input rndmthd,
/*L020*/                output mc-error-number)"}
                     /* CONVERT TO BASE CURRENCY */
                     if (base_curr <> po_curr)
                     then do:
/*L020*                 tmp_amt = tmp_amt / exch_rate.
*L020*/

/*L020*/        /* CONVERT TMP_AMT TO BASE CURRENCY */
/*L020*/            {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input po_curr,
                       input base_curr,
                       input exch_rate,
                       input exch_rate2,
                       input tmp_amt,
                       input true, /* DO ROUND */
                       output tmp_amt,
                       output mc-error-number)"}.
/*L020*/            if mc-error-number <> 0 then do:
/*L020*/               {mfmsg.i mc-error-number 2}
/*L020*/            end.

                        /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                 {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt,
*                        input gl_rnd_mthd)"}
*L020*/
                     end.
                     assign line_tax = line_tax + tmp_amt.
                  end.
               end.
               /*PPV RECEIPT*/
/*N0WT*/       {&POPORCB6-P-TAG10}
               assign
                      dr_acct[3] = pl_ppv_acct
/*N014*/              dr_sub[3]  = pl_ppv_sub
                      dr_cc[3]   = pl_ppv_cc
                      dr_proj[3] = pod_proj
                      cr_acct[3] = pl_rcpt_acct
/*N014*/              cr_sub[3]  = pl_rcpt_sub
                      cr_cc[3]   = pl_rcpt_cc
                      cr_proj[3] = pod_proj
                      entity[3]  = pod_entity.
/*N0WT*/       {&POPORCB6-P-TAG11}
/*H1N8**              gl_amt[3]  = line_tax. */

/*H1N8*/      /* IN AVERAGE COSTING ENVIRONMENT THERE SHOULD NOT BE ANY */
/*H1N8*/      /* PPV GENERATED AND POSTED. HENCE gl_amt[3] WHICH HOLDS  */
/*H1N8*/      /* TAX AMOUNT IS INITIALISED TO ZERO.                     */
/*H1N8*/      if glx_mthd = "AVG" then
/*H1N8*/          assign gl_amt[3]  = 0.
/*H1N8*/      else
/*H1N8*/          assign gl_amt[3]  = line_tax.

               if entity[1] <> pod_po_entity or poddb <> podpodb
               then do:
                  /*INTERCOMPANY POSTING - INTERCO ACCT*/
/*N0WT*/          {&POPORCB6-P-TAG12}
                  assign
                         dr_acct[2] = pl_rcpt_acct
/*N014*/                 dr_sub[2]  = pl_rcpt_sub
                         dr_cc[2]   = pl_rcpt_cc
                         dr_proj[2] = project
                         cr_acct[2] = icc_ico_acct
/*N014*/                 cr_sub[2]  = icc_ico_sub
                         cr_cc[2]   = icc_ico_cc
                         cr_proj[2] = project
                         entity[2]  = entity[1]
                         gl_amt[2]  = glamt.
                         /* GLAMT WAS CALCULATED AND CONVERTED IN THE */
                         /* BEGINNING, NO NEED TO RECALCULATE. */

                  /*INTERCOMPANY POSTING - PO RECEIPTS ACCT*/
                  assign
                         dr_acct[6] = icc_ico_acct
/*N014*/                 dr_sub[6]  = icc_ico_sub
                         dr_cc[6]   = icc_ico_cc
                         dr_proj[6] = project
                         cr_acct[6] = pl_rcpt_acct
/*N014*/                 cr_sub[6]  = pl_rcpt_sub
                         cr_cc[6]   = pl_rcpt_cc
                         cr_proj[6] = project
                         entity[6]  = pod_po_entity
                         gl_amt[6]  = glamt.
/*N0WT*/          {&POPORCB6-P-TAG13}
                         /* GLAMT WAS CALCULATED AND CONVERTED IN THE */
                         /* BEGINNING, NO NEED TO RECALCULATE. */
               end.
            end. /*if pod_type = "S"*/

            /*MEMO ITEM RECEIPTS*/
            else do:
/*N0WT*/       {&POPORCB6-P-TAG14}
               assign
                      dr_acct[1] = pod_acct
/*N014*/              dr_sub[1]  = pod_sub
                      dr_cc[1]   = pod_cc
                      dr_proj[1] = pod_proj
                      cr_acct[1] = gl_rcptx_acct
/*N014*/              cr_sub[1]  = gl_rcptx_sub
                      cr_cc[1]   = gl_rcptx_cc
                      cr_proj[1] = pod_proj
                      entity[1]  = pod_entity
                      gl_amt[1]  = glamt.
/*N0WT*/       {&POPORCB6-P-TAG15}
                      /* GLAMT WAS CALCULATED AND CONVERTED IN THE */
                      /* BEGINNING, NO NEED TO RECALCULATE. */

               if {txnew.i} then do:
/*J2WM*/          assign type_tax = 0
                         line_tax = 0.
                  /* NON-RECOVERABLE TAXES GO INTO PPV */
                  for each tx2d_det
/*J2DG*/          fields (tx2d_cur_recov_amt tx2d_cur_tax_amt tx2d_line tx2d_nbr
/*J2DG*/                  tx2d_rcpt_tax_point tx2d_ref tx2d_tax_in tx2d_tr_type)
          where tx2d_tr_type = tax_tr_type and
                     tx2d_ref = receivernbr and tx2d_nbr = po_nbr and
/*J2WM**             tx2d_line = pod_line no-lock: */
/*J2WM*/             tx2d_line = pod_line no-lock break by tx2d_line:

/*J2WM**                type_tax = 0. */

                        if tx2d_rcpt_tax_point then do:
                           /* ACCRUE TAX AT RECEIPT */
                           if not tx2d_tax_in then
                              /* TAX INCLUDED = NO */
                           do:
/*J2WM*/            /* ACCUMULATE TAXES FOR MULTIPLE TAX TYPES */
/*J2WM*/                      if last_sr_wkfl then
/*J2WM*/                         assign type_tax = type_tax +
/*J2WM**                         type_tax = */
                                    tx2d_cur_tax_amt - tx2d_cur_recov_amt.
/*J2WM*/                  else
/*J2WM*/                         assign type_tax = type_tax *
/*J2WM*/                        (totl_qty_this_rcpt / trqty) +
/*J2WM*/                                        (tx2d_cur_tax_amt -
/*J2WM*/                                         tx2d_cur_recov_amt).

                             /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
                                TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS
                                NOT BEEN ASSIGNED TO OTHER TRANSACTIONS. */
                              if last_sr_wkfl then do:
/*J2WM**                         if type_tax <> 0 then */
/*J2WM*/                         if type_tax <> 0 and last-of(tx2d_line) then
                                    assign type_tax = type_tax - accum_type_tax.
                              end.
                              else
                                 if totl_qty_this_rcpt <> 0 then do:
                                    assign type_tax = type_tax
                                       * (trqty / totl_qty_this_rcpt).
                                    /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                             {gprun.i ""gpcurrnd.p"" */
/*L020*/                            {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                       "(input-output type_tax,
                                       input gl_rnd_mthd,
/*L020*/                               output mc-error-number)"}
                                 end.
                           end.
                           else
                              /* TAX INCLUDED = YES */
                           do:
                              assign type_tax = - tx2d_cur_recov_amt.
                             /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
                                TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS
                                NOT BEEN ASSIGNED TO OTHER TRANSACTIONS. */
                              if last_sr_wkfl then do:
                                 if type_tax <> 0 then
                                    assign type_tax = type_tax - accum_type_tax.
                                 else
                                    if totl_qty_this_rcpt <> 0 then do:
                                       assign type_tax = type_tax
                                                * (trqty / totl_qty_this_rcpt).
                                      /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                                {gprun.i ""gpcurrnd.p"" */
/*L020*/                               {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                          "(input-output type_tax,
                                          input gl_rnd_mthd,
/*L020*/                                  output mc-error-number)"}
                                    end.
                              end.
                              else
                                 if totl_qty_this_rcpt <> 0 then do:
                                    assign type_tax = type_tax
                                             * (trqty / totl_qty_this_rcpt).
                                    /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                             {gprun.i ""gpcurrnd.p"" */
/*L020*/                            {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                       "(input-output type_tax,
                                       input gl_rnd_mthd,
/*L020*/                               output mc-error-number)"}
                                 end.
                           end.
                        end.
                        else
                           /* ACCRUE TAX AT VOUCHER */
                           if tx2d_tax_in then
                              /* TAX INCLUDED = YES */
                           do:
                              assign type_tax = - tx2d_cur_tax_amt.
                             /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
                                TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS
                                NOT BEEN ASSIGNED TO OTHER TRANSACTIONS. */
                              if last_sr_wkfl then do:
                                 if type_tax <> 0 then
                                    assign type_tax = type_tax - accum_type_tax.
                                 else
                                    if totl_qty_this_rcpt <> 0 then do:
                                       assign type_tax = type_tax
                                                * (trqty / totl_qty_this_rcpt).
                                      /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                                {gprun.i ""gpcurrnd.p"" */
/*L020*/                               {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                          "(input-output type_tax,
                                          input gl_rnd_mthd,
/*L020*/                                  output mc-error-number)"}
                                    end.
                              end.
                              else
                                 if totl_qty_this_rcpt <> 0 then do:
                                    assign type_tax = type_tax
                                             * (trqty / totl_qty_this_rcpt).
                                    /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                             {gprun.i ""gpcurrnd.p"" */
/*L020*/                            {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                       "(input-output type_tax,
                                       input gl_rnd_mthd,
/*L020*/                               output mc-error-number)"}
                                 end.
                           end.

/*H1NB** BEGIN DELETE **
 *                         if base_curr <> po_curr then
 *                         do:
/*L020*                    type_tax = type_tax / exch_rate.
*L020*/
 *
 * /*L020*/           /* CONVERT TYPE_TAX TO BASE CURRENCY */
 * /*L020*/               {gprunp.i "mcpl" "p" "mc-curr-conv"
 *                         "(input po_curr,
 *                           input base_curr,
 *                           input exch_rate,
 *                           input exch_rate2,
 *                           input type_tax,
 *                           input true, /* DO ROUND */
 *                           output type_tax,
 *                           output mc-error-number)"}.
 * /*L020*/               if mc-error-number <> 0 then do:
 * /*L020*/                  {mfmsg.i mc-error-number 2}
 * /*L020*/               end.
 *
 *                            /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                    {gprun.i ""gpcurrnd.p"" "(input-output type_tax,
*                           input gl_rnd_mthd)"}
*L020*/
 *                         end.
 *H1NB** END DELETE   */

/*J2WM*/                /* FOR MULTIPLE TAX TYPES, POPULATE accum_type_tax */
/*J2WM*/                /* AT LAST TAX TYPE */
/*J2WM*/                if last-of(tx2d_line) then
/*H1NB*/                do:
/*J2WM*/                   assign
/*H1NB**                     line_tax = line_tax + type_tax */
                             accum_type_tax = accum_type_tax + type_tax.
/*H1NB*/                   if base_curr <> po_curr then
/*H1NB*/                   do:

/*H1NB*/                      /* CONVERT TYPE_TAX TO BASE CURRENCY */
/*H1NB*/                      {gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input po_curr,
                                          input base_curr,
                                          input exch_rate,
                                          input exch_rate2,
                                          input type_tax,
                                          input true, /* DO ROUND */
                                          output type_tax,
                                          output mc-error-number)"}.
/*H1NB*/                      if mc-error-number <> 0 then do:
/*H1NB*/                         {mfmsg.i mc-error-number 2}
/*H1NB*/                      end.
/*H1NB*/                   end. /* IF BASE_CURR <> PO_CURR  */
/*H1NB*/                   assign line_tax = line_tax + type_tax.
/*H1NB*/                end. /* IF LAST-OF(TX2D_LINE)  */

                  end.
               end.
               /* If U.S. taxes, add taxes to total PPV */
               else if pod_taxable and not gl_vat and not gl_can
               then do:
                  assign line_tax = 0.
                  do i = 1 to 3:
                     /* DOCAMT IS (trqty * base_amt) IN DOCUMENT CURRENCY */
                     /* FIRST CALCULATE IN DOC CURRENCY THEN CONVERT IF NEEDED*/
                     assign tmp_amt = docamt * (po_tax_pct[i] / 100).
                     /* ROUND PER DOC CURRENCY ROUND METHOD */
/*L020*              {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt, */
/*L020*/             {gprunp.i "mcpl" "p" "mc-curr-rnd"
                      "(input-output tmp_amt,
                        input rndmthd,
/*L020*/                output mc-error-number)"}
                     /* CONVERT TO BASE CURRENCY */
                     if (base_curr <> po_curr)
                     then do:
/*L020*                 tmp_amt = tmp_amt / exch_rate.
*L020*/

/*L020*/        /* CONVERT TMP_AMT TO BASE CURRENCY */
/*L020*/            {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input po_curr,
                       input base_curr,
                       input exch_rate,
                       input exch_rate2,
                       input tmp_amt,
                       input true, /* DO ROUND */
                       output tmp_amt,
                       output mc-error-number)"}.
/*L020*/            if mc-error-number <> 0 then do:
/*L020*/               {mfmsg.i mc-error-number 2}
/*L020*/            end.

                        /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                 {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt,
*                        input gl_rnd_mthd)"}
*L020*/
                     end.
                     assign line_tax = line_tax + tmp_amt.
                  end.
               end.
               /* COMPONENTS ALREADY ROUNDED */
               assign gl_amt[1] = gl_amt[1] + line_tax.

               if pod_entity <> pod_po_entity or poddb <> podpodb
               then do:
                  /*INTERCOMPANY POSTING - INTERCO ACCT*/
/*N0WT*/          {&POPORCB6-P-TAG16}
                  assign
                         dr_acct[2] = gl_rcptx_acct
/*N014*/                 dr_sub[2]  = gl_rcptx_sub
                         dr_cc[2]   = gl_rcptx_cc
                         dr_proj[2] = pod_proj
                         cr_acct[2] = icc_ico_acct
/*N014*/                 cr_sub[2]  = icc_ico_sub
                         cr_cc[2]   = icc_ico_cc
                         cr_proj[2] = pod_proj
                         entity[2]  = pod_entity
                         gl_amt[2]  = glamt + line_tax.

                         /* GLAMT WAS CALCULATED AND CONVERTED IN THE */
                         /* BEGINNING, NO NEED TO RECALCULATE. */

                  /*INTERCOMPANY POSTING - PO RECEIPTS ACCT*/
                  assign
                         dr_acct[6] = icc_ico_acct
/*N014*/                 dr_sub[6]  = icc_ico_sub
                         dr_cc[6]   = icc_ico_cc
                         dr_proj[6] = pod_proj
                         cr_acct[6] = gl_rcptx_acct
/*N014*/                 cr_sub[6]  = gl_rcptx_sub
                         cr_cc[6]   = gl_rcptx_cc
                         cr_proj[6] = pod_proj
                         entity[6]  = pod_po_entity
                         gl_amt[6]  = glamt + line_tax.
/*N0WT*/          {&POPORCB6-P-TAG17}

                         /* GLAMT WAS CALCULATED AND CONVERTED IN THE */
                         /* BEGINNING, NO NEED TO RECALCULATE. */
               end.
            end. /*else do (memo items)*/

            /* CREATE TRAN HISTORY RECORD FOR EACH LOT/SERIAL/PART */
            assign
                   pt_recno  = recid(pt_mstr)
                   pod_recno = recid(pod_det)
                   po_recno  = recid(po_mstr)
                   wr_recno  = recid(wr_route).

/*N05Q*     {gprun.i ""poporcc.p"" "(input shipnbr, input ship_date,*/
/*N05Q*              input inv_mov)"}                               */

/*eas055*    {gprun.i ""poporcc.p""*/
/*eas055*/    {gprun.i ""xxpoporcc.p""
               "(input shipnbr,
                 input ship_date,
                 input inv_mov,
                 output invntry-trnbr)"}

            if (pod_rma_type = "I"   or
               pod_rma_type = "O")
            then do:
               {gprun.i ""fsrtvtrn.p""}
               if undo_all then leave .
            end.

/*N05Q*/    /* **** BEGIN NEW CODE **** */
            if porec
            and prm-avail
            then do:
               /* PERFORM PRM PROCESSING ON PO LINE RECEIPT.    */
               /* OCCURRANCE OF PRM PROCESSING FOR EACH SR_WKFL */
               /* NEEDED FOR INVENTORY ITEMS                    */
/*N090*/       /* ADDED PARAMETER LINE_TAX */
               {gprunmo.i
                  &program=""pjporprm.p""
                  &module="PRM"
                  &param="""(input eff_date,
                             input invntry-trnbr,
                             buffer sr_wkfl,
                             buffer pod_det,
                             input line_tax)"""}
            end.  /* IF POREC AND PRM-ENABLED */
/*N05Q*/    /* **** END NEW CODE **** */

     end.  /* for each sr_wkfl */

         for each sr_wkfl exclusive-lock where sr_userid = mfguser
             and sr_lineid = string(pod_line):
            delete sr_wkfl.
         end.

         if pod_qty_chg <> 0 then do:

/*J2DG** BEGIN DELETE **
 *            find rmd_det
 *               where rmd_nbr  = pod_nbr and   rmd_prefix   = "V"
 *               and   rmd_line = pod_line no-error.
 *J2DG** END DELETE */

/*J2DG*/    for first rmd_det
/*J2DG*/       where rmd_nbr    = pod_nbr
/*J2DG*/       and   rmd_prefix = "V"
/*J2DG*/       and   rmd_line   = pod_line exclusive-lock:
/*J2DG*/    end. /* FOR FIRST RMD_DET */
                   /*******************************************/
                   /* Update receive/ship date and qty in rma */
                   /*******************************************/
            if  available rmd_det then do:
               if  rmd_type = "O" then
                   assign  rmd_qty_acp  = - (pod_qty_rcvd + pod_qty_chg).
               else assign rmd_qty_acp  =   pod_qty_rcvd + pod_qty_chg.
               if rmd_qty_acp <> 0 then
                    assign rmd_cpl_date =   eff_date.
               else assign rmd_cpl_date = ?.
            end.
         end. /**********end pod_qty_chg*************/

/*M0ND*/ /* PROCEDURE TO OBTAIN COST OF COMPONENT ITEMS FOR AN EMT PO */

/*M0ND*/ procedure p-price-configuration:

/*M0ND*/   define variable l_qty_req like sob_qty_req no-undo.

/*M0ND*/   l_glxcst = 0.

/*M0SQ*/   /* ADDED FIELD sod_qty_ord IN THE FIELD LIST FOR sod_det */
/*M0ND*/   for first sod_det
/*M0ND*/      fields (sod_line sod_nbr sod_qty_ord)
/*M0ND*/      where sod_nbr  = po_mstr.po_so_nbr
/*M0ND*/        and sod_line = pod_det.pod_sod_line no-lock:
/*M0ND*/   end. /* FOR FIRST SOD_DET */
/*M0ND*/   if available sod_det then
/*M0ND*/   do:
/*M0ND*/      for each sob_det
/*M0ND*/         fields (sob_line sob_nbr sob_part sob_qty_req
/*M0ND*/                 sob_serial sob_site)
/*M0ND*/         where sob_nbr  = sod_nbr
/*M0ND*/           and sob_line = sod_line no-lock
/*M0ND*/          break by sob_part:

/*M0ND*/          if first-of(sob_part) then
/*M0ND*/             l_qty_req = 0.

/*M0ND*/          if substring(sob_serial,15,1) = "o" then
/*M0ND*/             l_qty_req = l_qty_req + sob_qty_req.

/*M0ND*/          if last-of(sob_part) and
/*M0ND*/             l_qty_req <> 0 then
/*M0ND*/          do:
/*M0ND*/             {gprun.i ""gpsct05.p""
/*M0ND*/                       "(input sob_part, sob_site, input 1,
/*M0ND*/                         output glxcst, output curcst)"}
/*M0SQ*/             glxcst = glxcst * (sob_qty_req / sod_qty_ord).
/*M0ND*/             l_glxcst = l_glxcst + glxcst.
/*M0ND*/          end. /* IF LAST-OF (SOB_PART) ... */

/*M0ND*/      end. /* FOR EACH SOB_DET */
/*M0SQ*/      l_glxcst = l_glxcst * absolute(trqty).
/*M0ND*/   end. /* IF AVAILABLE SOD_DET */

/*M0ND*/ end. /* PROCEDURE P-PRICE-CONFIGURATION */

/*L17B*/ /* PROCEDURE p-poconv TO ROUND AMOUNT ACCORDING TO PO CURRENCY */
/*L17B*/ /* AND CONVERT IT TO BASE CURRENCY                             */

/*L17B*/ PROCEDURE p-poconv:

            define input-output parameter  l_tmpamt like trgl_gl_amt no-undo.

               /* ROUND PER PO CURRENCY ROUND METHOD */
               {gprunp.i "mcpl" "p" "mc-curr-rnd"
                  "(input-output l_tmpamt,
                    input rndmthd,
                    output mc-error-number)"}

            if po_mstr.po_curr <> base_curr
            then do:
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input  po_mstr.po_curr,
                    input  base_curr,
                    input  exch_rate,
                    input  exch_rate2,
                    input  l_tmpamt,
                    input  true, /* DO ROUND */
                    output l_tmpamt,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {mfmsg.i mc-error-number 2}
               end. /* IF mc-error-number <> 0 */
            end. /* IF po_curr <> base_curr */
/*L17B*/ end procedure. /* PROCEDURE p-poconv */

/*L17B*/ /* PROCEDURE p-costconv TO CONVERT COST TO PO CURRENCY AND   */
/*L17B*/ /* ASSIGN THE DISPLAYED COST BACK TO MAKE IT IN SYNC         */
/*L17B*/ /* WITH VOUCHER MAINTENANCE PROGRAM                          */

/*L17B*/ PROCEDURE p-costconv:

            define input parameter l_sct_cst_tot like sct_cst_tot no-undo.
            define input parameter l_sct_ovh_tl  like sct_ovh_tl  no-undo.

            if po_mstr.po_curr <> base_curr
            then do:
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input  base_curr,
                    input  po_mstr.po_curr,
                    input  exch_rate2,
                    input  exch_rate,
                    input  l_sct_cst_tot,
                    input  false, /* DO NOT ROUND */
                    output l_sct_cst_tot,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {mfmsg.i mc-error-number 2}
               end. /* IF mc-error-number <> 0 */

               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input  base_curr,
                    input  po_mstr.po_curr,
                    input  exch_rate2,
                    input  exch_rate,
                    input  l_sct_ovh_tl,
                    input  false, /* DO NOT ROUND */
                    output l_sct_ovh_tl,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {mfmsg.i mc-error-number 2}
               end. /* IF mc-error-number <> 0 */
            end. /* IF po_curr <> base_curr */

/*M1S7** BEGIN DELETE
 *
 *          l_total_cost = l_sct_cst_tot - l_sct_ovh_tl.
 *
 *          /* DISPLAYING THE COST l_total_cost AND THEN ASSIGNING IT   */
 *          /* BACK TO MAKE IT IN SYNC WITH VOUCHER MAINTENANCE PROGRAM */
 *
 *          output stream disp_cst to value(mfguser + ".cst").
 *          display stream disp_cst l_total_cost with frame a no-label.
 *          output stream disp_cst close.
 *
 *          input from value(mfguser + ".cst").
 *          repeat:
 *             import l_total_cost.
 *          end. /* REPEAT */
 *          input close.
 *
 *M1S7** END DELETE */

/*M1S7*/    assign
/*M1S7*/       l_total_cost = l_sct_cst_tot - l_sct_ovh_tl
/*M1S7*/       l_total_cost = round(l_total_cost,5).

/*N1KB*/       if glx_mthd = "AVG"
/*N1KB*/       then
                  gl_amt[1] = trqty * l_total_cost.

/*L17B*/ end procedure. /* PROCEDURE p-costconv */
