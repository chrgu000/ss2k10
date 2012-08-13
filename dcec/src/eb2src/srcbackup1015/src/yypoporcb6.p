/* GUI CONVERTED from poporcb6.p (converter v1.77) Mon May 24 08:01:29 2004 */
/* poporcb6.p - PURCHASE ORDER RECEIPT W/ SERIAL NUMBER CONTROL               */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* REVISION: 7.4      LAST MODIFIED: 03/25/94   BY: dpm *FM94*                */
/* REVISION: 7.4      LAST MODIFIED: 04/12/94   BY: bcm *H336*                */
/* REVISION: 7.4      LAST MODIFIED: 08/01/94   BY: dpm *H466*                */
/* REVISION: 7.4      LAST MODIFIED: 09/26/94   BY: bcm *H539*                */
/* REVISION: 7.4      LAST MODIFIED: 10/31/94   BY: ame *GN82*                */
/* REVISION: 8.5      LAST MODIFIED: 10/31/94   BY: taf *J038*                */
/* REVISION: 7.4      LAST MODIFIED: 11/17/94   BY: bcm *GO37*                */
/* REVISION: 7.4      LAST MODIFIED: 02/16/95   BY: jxz *F0JC*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
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
/* Revision: 1.38     BY: Katie Hilbert            DATE: 04/01/01 ECO: *P002* */
/* Revision: 1.39     BY: Nikita Joshi             DATE: 04/20/01 ECO: *L17B* */
/* Revision: 1.40     BY: Niranjan Ranka           DATE: 07/12/01 ECO: *P00L* */
/* Revision: 1.41     BY: Irine Fernandes          DATE: 10/22/01 ECO: *M1N4* */
/* Revision: 1.43     BY: Dipesh Bector            DATE: 12/22/01 ECO: *M1S7* */
/* Revision: 1.44     BY: Kirti Desai              DATE: 02/22/02 ECO: *N19Y* */
/* Revision: 1.46     BY: Patrick Rowan            DATE: 04/17/02 ECO: *P043* */
/* Revision: 1.47     BY: Paul Donnelly            DATE: 01/27/02 ECO: *N16J* */
/* Revision: 1.48     BY: Paul Donnelly            DATE: 05/20/02 ECO: *M1YR* */
/* Revision: 1.49     BY: Jeff Wootton             DATE: 05/20/02 ECO: *P03G* */
/* Revision: 1.50     BY: Dan Herman               DATE: 05/24/02 ECO: *P018* */
/* Revision: 1.53     BY: Luke Pokic               DATE: 05/24/02 ECO: *P03Z* */
/* Revision: 1.54     BY: Steve Nugent             DATE: 06/10/02 ECO: *P07Y* */
/* Revision: 1.55     BY: Steve Nugent             DATE: 06/13/02 ECO: *P08K* */
/* Revision: 1.56     BY: Rajiv Ramaiah            DATE: 06/23/02 ECO: *N1KB* */
/* Revision: 1.57     BY: Tiziana Giustozzi        DATE: 07/07/02 ECO: *P0B5* */
/* Revision: 1.58     BY: Robin McCarthy           DATE: 07/15/02 ECO: *P0BJ* */
/* Revision: 1.59     BY: Tiziana Giustozzi        DATE: 07/17/02 ECO: *P0BG* */
/* Revision: 1.60     BY: Tiziana Giustozzi        DATE: 08/06/02 ECO: *P0CW* */
/* Revision: 1.65     BY: Tiziana Giustozzi        DATE: 08/26/02 ECO: *P0GV* */
/* Revision: 1.66     BY: Ashish Maheshwari        DATE: 09/09/02 ECO: *N1SN* */
/* Revision: 1.68     BY: Pawel Grzybowski         DATE: 03/27/03 ECO: *P0NT* */
/* Revision: 1.69     BY: Orawan S.                DATE: 05/26/03 ECO: *P0RG* */
/* Revision: 1.69.1.1 BY: Gnanasekar               DATE: 06/27/03 ECO: *P0WB* */
/* Revision: 1.69.1.2 BY: Sunil Fegade             DATE: 07/14/03 ECO: *P0X7* */
/* Revision: 1.69.1.3 BY: Dipesh Bector            DATE: 08/28/03 ECO: *P111* */
/* Revision: 1.69.1.4 BY: Vivek Gogte              DATE: 12/08/03 ECO: *P1D0* */
/* Revision: 1.69.1.5 BY: Mercy Chittilapilly      DATE: 01/16/04 ECO: *P1K4* */
/* Revision: 1.69.1.6 BY: Preeti Sattur            DATE: 05/03/04 ECO: *P1ZZ* */
/* $Revision: 1.69.1.7 $ BY: Russ Witt   DATE: 05/13/04  ECO: *P1CZ*   */
/*-Revision end---------------------------------------------------------------*/

/*V8:ConvertMode=Maintenance                                                  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ADDED NO-UNDO  AND ASSIGN  WHEREVER MISSING                             */
/* REPLACED FIND STATEMENTS WITH FOR FIRST FOR ORACLE PERFORMANCE          */
/* $Revision: eb2+sp7  BY: Steve judy Liu    DATE: 05/08/12  ECO: *judy*     */

{mfdeclre.i}
/*judy 05/0812*/ {cxcustom.i "yyPOPORCB6.P"}
{porcdef.i}
{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */
{kbconst.i}

define input parameter shipnbr        like tr_ship_id      no-undo.
define input parameter ship_date      like tr_ship_date    no-undo.
define input parameter inv_mov        like tr_ship_inv_mov no-undo.
define input parameter ip_consign_flag like mfc_logical no-undo.
define input parameter ip_is_usage     like mfc_logical no-undo.
define input parameter ip_usage_qty    as decimal       no-undo.
define input parameter ip_woiss_nbr    like tr_rmks     no-undo.
define output parameter op_rctpo_trnbr like tr_trnbr    no-undo.

/* INTER-COMPANY ACCOUNT PROCEDURES */
{pxpgmmgr.i}

define shared variable rndmthd         like rnd_rnd_mthd.
define variable glamt as decimal             no-undo.
define variable docamt as decimal            no-undo.
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
define shared variable dr_sub          like trgl_dr_sub extent 6.
define shared variable dr_cc           like trgl_dr_cc extent 6.
define shared variable dr_proj         like trgl_dr_proj extent 6.
define shared variable cr_acct         like trgl_cr_acct extent 6.
define shared variable cr_sub          like trgl_cr_sub extent 6.
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
define shared variable project         like pvo_project.
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

define new shared variable srvendlot   like tr_vend_lot   no-undo.
define shared variable msg-nbr         like tr_msg.
define        variable l_ppv_amt         like trgl_gl_amt no-undo.
define shared variable nrecov_tax_avg  like tx2d_tottax   no-undo.
define variable l_extbase_amt          like trgl_gl_amt   no-undo.
define shared variable prm-avail       like mfc_logical   no-undo.
define shared variable s_base_amt      like base_amt      no-undo.
define shared variable cur_mthd        like cs_method.
define shared variable cur_set         like cs_set.
define shared variable glx_set         like cs_set.
define shared variable msg-num         like tr_msg.
define variable invntry-trnbr          like trgl_trnbr    no-undo.
define variable l_glxcst               like glxcst        no-undo.
define variable mc-error-number        like msg_nbr       no-undo.
define variable l_base_amt             like base_amt      no-undo.
define variable l_sct_cst_tot          like sct_cst_tot   no-undo.
define variable l_sct_ovh_tl           like sct_ovh_tl    no-undo.
define variable l_newcst               like sct_cst_tot   no-undo.
define variable l_newovh_tl            like sct_ovh_tl    no-undo.
define variable l_total_cost           like sct_cst_tot   no-undo.
define variable dftRCPTAcct            like pl_rcpt_acct  no-undo.
define variable dftRCPTSubAcct         like pl_rcpt_sub   no-undo.
define variable dftRCPTCostCenter      like pl_rcpt_cc    no-undo.
define variable dftPPVAcct             like pl_ppv_acct   no-undo.
define variable dftPPVSubAcct          like pl_ppv_sub    no-undo.
define variable dftPPVCostCenter       like pl_ppv_cc     no-undo.
define variable dftCOPAcct             like pl_cop_acct   no-undo.
define variable dftCOPSubAcct          like pl_cop_sub    no-undo.
define variable dftCOPCostCenter       like pl_cop_cc     no-undo.
define variable dftWIPAcct             like pl_cop_acct   no-undo.
define variable dftWIPSubAcct          like pl_cop_sub    no-undo.
define variable dftWIPCostCenter       like pl_cop_cc     no-undo.
define variable dftOVHAcct             like pl_ovh_acct   no-undo.
define variable dftOVHSubAcct          like pl_ovh_sub    no-undo.
define variable dftOVHCostCenter       like pl_ovh_cc     no-undo.
define variable l_assay                like tr_assay      no-undo.
define variable l_expire               like tr_expire     no-undo.
define variable l_glcost               like sct_cst_tot   no-undo.
define variable l_grade                like tr_grade      no-undo.
define variable use-log-acctg          as   logical       no-undo.
define variable conversion_factor      as   decimal       no-undo.
define variable cat-list               as   character     no-undo.
define variable dummy-cost             as   decimal       no-undo.
define variable l_excrv_amt            like trgl_gl_amt   no-undo.
define variable useWIPAcct             as   logical       no-undo.

{&POPORCB6-P-TAG20}
/* KANBAN TRANSACTION NUMBER, SHARED FROM poporcm.p AND kbporcm.p */
define shared variable kbtransnbr as integer no-undo.

{&POPORCB6-P-TAG18}
define shared workfile posub
   field    posub_nbr       as character
   field    posub_line      as integer
   field    posub_qty       as decimal
   field    posub_wolot     as character
   field    posub_woop      as integer
   field    posub_gl_amt    like glt_amt
   field    posub_cr_acct   as character
   field    posub_cr_sub    as character
   field    posub_cr_cc     as character
   field    posub_effdate   as date
   field    posub_site      like sr_site
   field    posub_loc       like sr_loc
   field    posub_lotser    like sr_lotser
   field    posub_ref       like sr_ref
   field    posub_move      as logical.
/*judy 05/08/12*//*LB01*/ define variable isMpart        like mfc_logical.

{pocnvars.i}
/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_SUPPLIER_CONSIGNMENT,
     input 11,
     input ADG,
     input SUPPLIER_CONSIGN_CTRL_TABLE,
     output using_supplier_consignment)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/* DOWN GRADED TO A NO-LOCK SEE NO REASON FOR SHARE-LOCK */

for first pod_det
      fields (pod_acct pod_sub
      pod_sod_line pod_um_conv
      pod_cc pod_line pod_nbr pod_op pod_part
      pod_project pod_qty_chg pod_qty_rcvd pod_rma_type
      pod_site pod_taxable pod_type pod_wo_lot)
      where pod_recno = recid(pod_det) no-lock:
end. /* FOR FIRST POD_DET */

for first po_mstr
   fields (po_curr po_is_btb po_nbr po_so_nbr po_tax_pct po_vend po_tot_terms_code)
   where po_nbr    = pod_nbr no-lock:
end. /* FOR FIRST PO_MSTR */

for first pt_mstr
      fields (pt_part pt_pm_code pt_prod_line pt_routing)
      where pt_recno  = recid(pt_mstr) no-lock:
end. /*FOR FIRST PT_MSTR */

for first sct_det
      where sct_recno = recid(sct_det) no-lock:
end. /*FOR FIRST SCT_DET */

{&POPORCB6-P-TAG28}
for first gl_ctrl
      fields (gl_rcptx_acct gl_rcptx_sub
              gl_rcptx_cc gl_rnd_mthd)
      no-lock:
end. /* FOR FIRST Gl_CTRL */
{&POPORCB6-P-TAG29}

for first icc_ctrl
   fields (icc_gl_set)
   no-lock:
end. /* FOR FIRST ICC_CTRL */

if not available icc_ctrl then
   return.

assign
   last_sr_wkfl = no
   accum_type_tax = 0
   accum_taxamt = 0
   totl_qty_this_rcpt = 0.

for each sr_wkfl
      fields (sr_lineid sr_loc sr_lotser sr_qty sr_ref
              sr_site sr_userid sr_vend_lot sr__qadc01) no-lock
   where ((sr_userid = mfguser and ip_is_usage = no) or
          (sr_userid = mfguser + "cons" and ip_is_usage))
      and sr_lineid = string(pod_line):
   assign totl_qty_this_rcpt = totl_qty_this_rcpt
         + if is-return then ( - sr_qty) else sr_qty.
end.

{&POPORCB6-P-TAG19}
{&POPORCB6-P-TAG21}
srloop:
for each sr_wkfl
      fields (sr_lineid sr_loc sr_lotser sr_qty sr_ref
              sr_site sr_userid sr_vend_lot sr__qadc01)
   where ((sr_userid = mfguser and ip_is_usage = no) or
          (sr_userid = mfguser + "cons" and ip_is_usage))
         and sr_lineid = string(pod_line) no-lock
      {&POPORCB6-P-TAG22}
      break by sr_userid:
/*GUI*/ if global-beam-me-up then undo, leave.

      {&POPORCB6-P-TAG23}

   if last(sr_userid)
   then
      last_sr_wkfl = yes.

   /* DURING EMT, WHEN CONFIRMING THE PO SHIPPER IMPORTED FROM    */
   /* SBU AT THE PBU, RETREIVING THE QUANTITY IN INVENTORY UM FOR */
   /* ORDER IN ALTERNATE UM TO AVOID ROUNDING ERRORS IN LD_DET    */
   if execname = "rsporc.p"
   then do:

      if pod_um_conv <> 1
      then
         trqty = decimal(sr__qadc01).
      else
         trqty = sr_qty.
   end. /* IF EXECNAME = "RSPORC.P" */
   else do:

      if is-return
      then
         trqty = (- sr_qty) * conv_to_stk_um.
      else
         trqty = sr_qty * conv_to_stk_um.
   end. /* ELSE DO */

   {&POPORCB6-P-TAG24}
   assign
      l_assay    = 0
      l_expire   = ?
      l_glcost   = 0
      l_grade    = ""
      site       = sr_site
      location   = sr_loc
      lotser     = sr_lotser
      lotref     = sr_ref
      srvendlot  = sr_vend_lot
      l_base_amt = price
      base_amt   = price.

   do i = 1 to 6:
      assign
         dr_acct[i] = ""
         dr_sub[i]  = ""
         dr_cc[i]   = ""
         dr_proj[i] = ""
         cr_acct[i] = ""
         cr_sub[i]  = ""
         cr_cc[i]   = ""
         cr_proj[i] = ""
         entity[i]  = ""
         gl_amt[i]  = 0.
   end.
   line_tax = 0.

if using_supplier_consignment and ip_is_usage then
   trqty = ip_usage_qty.

   /* IN ORDER TO ENSURE ACCURATE CALCULATIONS, IF AMOUNT BEING  */
   /* MULTIPLIED IS STORED IN DOCUMENT CURRENCY THEN CALCULATE   */
   /* IN DOCUMENT CURRENCY THEN PERFORM CONVERSION AND ROUND PER */
   /* BASE CURRENCY. */

   /* BASE_AMT IS IN DOCUMENT CURRENCY */
   /* CALCULATE GLAMT BASED UNIT PRICE AND TRQTY */
   glamt = (base_amt + if (pod_type = "S" and
                           glx_mthd = "AVG")
                       then
                          nrecov_tax_avg
                       else 0) * trqty.

   /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output glamt,
        input rndmthd,
        output mc-error-number)"}

   docamt = glamt.   /* SAVE IN DOC CURRENCY */

   /* IF NECESSARY CONVERT GLAMT TO BASE */
   if po_curr <> base_curr
   then do:
      /* CONVERT GLAMT TO BASE */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input po_curr,
           input base_curr,
           input exch_rate,
           input exch_rate2,
           input glamt,
           input true, /* DO ROUND */
           output glamt,
           output mc-error-number)"}.
      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.
   end.

   /* BASE_AMT IS THE UNIT PRICE */
   /* IF NECESSARY CONVERT BASE_AMT TO BASE CURRENCY */
   if po_curr <> base_curr
   then do:
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input po_curr,
           input base_curr,
           input exch_rate,
           input exch_rate2,
           input base_amt,
           input false, /* DO NOT ROUND */
           output base_amt,
           output mc-error-number)"}.
   end.

   {&POPORCB6-P-TAG1}
   /*INVENTORY ITEM RECEIPTS*/
   if available pt_mstr
   and pod_type = ""
   then do:

      for first pl_mstr
            fields (pl_cop_acct pl_cop_sub pl_cop_cc pl_inv_acct pl_inv_sub
                    pl_inv_cc pl_ovh_acct pl_ovh_sub pl_ovh_cc pl_ppv_acct
                    pl_ppv_sub pl_ppv_cc pl_prod_line pl_rcpt_acct
                    pl_rcpt_sub pl_rcpt_cc)
            where pl_prod_line = pt_prod_line no-lock:
      end. /* FOR FIRST PL_MSTR  */
      /* Determine supplier type needed to get default gl account info */
      run getGLDefaults.
      {&POPORCB6-P-TAG2}
      assign
         dr_acct[1]    = pl_inv_acct
         dr_sub[1]     = pl_inv_sub
         dr_cc[1]      = pl_inv_cc
         dr_proj[1]    = pod_proj
         cr_acct[1]    = dftRCPTAcct
         cr_sub[1]     = dftRCPTSubAcct
         cr_cc[1]      = dftRCPTCostCenter
         cr_proj[1]    = pod_proj
         entity[1]     = pod_entity
         gl_amt[1]     = trqty * (sct_cst_tot - sct_ovh_tl)
         l_sct_cst_tot = sct_cst_tot
         l_sct_ovh_tl  = sct_ovh_tl.
       {&POPORCB6-P-TAG3}

      if use-log-acctg and po_tot_terms_code <> "" then do:

         cat-list = "1".
         run p-calc-charge
            (input cat-list,
             input-output l_sct_cst_tot,
             input-output gl_amt[1]).

      end.
      /* OBTAIN DEFAULT UNIT PRICE (l_total_cost) IN PO CURRENCY */
      run p-costconv(input l_sct_cst_tot, input l_sct_ovh_tl).

      /* CALCULATING GL_AMT FOR ATO/KIT ITEMS FOR AN EMT PO */
      /* TO REFLECT ENTIRE CONFIGURATION COST               */
      if po_is_btb and
         pt_pm_code = "c" then
      do:
         run p-price-configuration.
         gl_amt[1] = gl_amt[1] + l_glxcst.
      end. /* IF PO_IS_BTB AND PT_PM_CODE = "C" */

      /* ROUND PER BASE CURRENCY ROUND METHOD */
      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output gl_amt[1],
           input        gl_rnd_mthd,
           output       mc-error-number)"}

      for first pld_det
            fields (pld_inv_acct pld_inv_sub
            pld_inv_cc pld_loc pld_prodline pld_site)
            where pld_prodline = pt_prod_line
            and   pld_site     = pod_site
            and   pld_loc      = location no-lock:
      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR FIRST PLD_DET */

      if not available pld_det then do:

         for first pld_det
               fields (pld_inv_acct pld_inv_sub
               pld_inv_cc pld_loc pld_prodline pld_site)
               where pld_prodline = pt_prod_line
               and   pld_site     = pod_site
               and   pld_loc      = "" no-lock:
         end. /* FOR FIRST PLD_DET */

         if not available pld_det then do:

            for first pld_det
                  fields (pld_inv_acct pld_inv_sub
                  pld_inv_cc pld_loc pld_prodline pld_site)
                  where pld_prodline = pt_prod_line
                  and   pld_site     = ""
                  and   pld_loc      = "" no-lock:
            end. /* FOR FIRST PLD_DET */

         end.
      end.

      if available pld_det then
      assign
         dr_acct[1] = pld_inv_acct
         dr_sub[1]  = pld_inv_sub
         dr_cc[1]   = pld_inv_cc.

      if using_supplier_consignment and ip_consign_flag  and
         ip_is_usage = no then do:
         {gprunmo.i &module  = "ACN" &program = ""pocnacct.p""
            &param   = """(input pod_part,
                           input pod_site,
                           input po_vend,
                           output dr_acct[1],
                           output dr_sub[1],
                           output dr_cc[1],
                           output cr_acct[1],
                           output cr_sub[1],
                           output cr_cc[1])"""}
         gl_amt[1]  = base_amt * trqty.
      end. /*If using supplier consignment*/

      /*OVERHEAD RECEIPT*/
      if not(using_supplier_consignment
             and ip_consign_flag
             and ip_is_usage = no)
      then do:
/*judy 05/08/10 begin delete*/
     /*    assign
            dr_acct[2] = pl_inv_acct
            dr_sub[2]  = pl_inv_sub
            dr_cc[2]   = pl_inv_cc
            dr_proj[2] = pod_proj
            cr_acct[2] = dftOVHAcct
            cr_sub[2]  = dftOVHSubAcct
            cr_cc[2]   = dftOVHCostCenter
            cr_proj[2] = pod_proj
            entity[2]  = pod_entity
            gl_amt[2]  = trqty * sct_ovh_tl. */
/*judy 05/08/10 end delete*/

/*judy 05/08/10 begin add*/
 /*LB01*/  isMpart = no.
/*LB01*/  find ptp_det where ptp_part = pod_part and
/*LB01*/  ptp_site = pod_site no-lock no-error.
/*LB01*/  
/*LB01*/  if available ptp_det and ptp_pm_code = "m" then
/*LB01*/  	isMpart = yes.
/*LB01*/  else
/*LB01*/  	if pt_pm_code = "m" then
/*LB01*/  		isMpart = yes.
		
/*LB01*/	 if isMpart = yes then			 
/*LB01*/     assign
/*LB01*/          dr_acct[2] = pl_inv_acct
                  dr_sub[2]  = pl_inv_sub
/*LB01*/	      dr_cc[2]   = pl_inv_cc
/*LB01*/	      dr_proj[2] = pod_proj
/*LB01*/	      cr_acct[2] = dftPPVAcct
                  cr_sub[2]  = dftPPVSubAcct   
  /*LB01*/	      cr_cc[2]   = dftPPVCostCenter
/*LB01*/	      cr_proj[2] = pod_proj
/*LB01*/	      entity[2]  = pod_entity
/*LB01*/	      gl_amt[2]  = trqty * sct_ovh_tl.
/*LB01*/	 else
/*LB01*/      assign
            dr_acct[2] = pl_inv_acct
            dr_sub[2]  = pl_inv_sub
            dr_cc[2]   = pl_inv_cc
            dr_proj[2] = pod_proj
            cr_acct[2] = dftOVHAcct
            cr_sub[2]  = dftOVHSubAcct
            cr_cc[2]   = dftOVHCostCenter
            cr_proj[2] = pod_proj
            entity[2]  = pod_entity
            gl_amt[2]  = trqty * sct_ovh_tl. 
/*judy 05/08/10 end add*/
      end. /* IF NOT(USING_SUPPLIER_CONSIGNMENT AND IP_CONSIGN_FLAG AND ..... */

      {&POPORCB6-P-TAG25}
      if use-log-acctg and po_tot_terms_code <> "" then do:

         {gprunmo.i &module = "LA" &program = "lapoohc.p"
                    &param  = """(input sct_ovh_tl,
                                  input po_nbr,
                                  input pod_part,
                                  input pod_site,
                                  output gl_amt[2])"""}

         gl_amt[2] = trqty * gl_amt[2].
         {&POPORCB6-P-TAG26}

      end.

      /* ROUND PER BASE CURRENCY ROUND METHOD */
      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output gl_amt[2],
           input gl_rnd_mthd,
           output mc-error-number)"}

      if available pld_det then
      assign
         dr_acct[2] = pld_inv_acct
         dr_sub[2]  = pld_inv_sub
         dr_cc[2]   = pld_inv_cc.

      assign type_tax = 0
         line_tax = 0.
      /* NON-RECOVERABLE TAXES GO INTO PPV */
      for each tx2d_det
         fields (tx2d_cur_recov_amt tx2d_cur_tax_amt tx2d_line tx2d_nbr
                 tx2d_rcpt_tax_point tx2d_ref tx2d_tax_in
                 tx2d_tax_code tx2d_tr_type)
         where tx2d_tr_type = tax_tr_type
         and   tx2d_ref     = receivernbr
         and   tx2d_nbr     = po_nbr
         and   tx2d_line    = pod_line
         no-lock
         break by tx2d_line
               by tx2d_tax_code:

         if first-of(tx2d_tax_code)
         then
            accum_type_tax = 0.

         for first tx2_mstr no-lock
            where tx2_tax_code = tx2d_tax_code:
         end.

         if (tx2d_rcpt_tax_point) and             /* ACCRUE @ RECEIPT */
            ((not using_supplier_consignment or
              not ip_consign_flag) or
            (using_supplier_consignment  and      /* CONSIGNMENT OVERRIDES */
             ip_consign_flag             and
             tx2_usage_tax_point = no    and      /* DON'T ACCRUE @ USAGE */
             ip_is_usage = no ))  or              /* MATERIAL USAGE = NO  */
            (using_supplier_consignment  and
             ip_consign_flag             and
             tx2_usage_tax_point         and      /* ACCRUE @ USAGE */
             ip_is_usage)                         /* MATERIAL USAGE = YES */
            then do:

            /* ACCRUE TAX AT RECEIPT */
            /* TAX INCLUDED = NO */
            if not tx2d_tax_in then
            do:
               /* ACCUMULATE TAXES FOR MULTIPLE TAX TYPES */
               if last_sr_wkfl then
               assign type_tax = type_tax +
                     tx2d_cur_tax_amt - tx2d_cur_recov_amt.
               else
               assign type_tax = type_tax *
                     (totl_qty_this_rcpt / trqty) +
                     (tx2d_cur_tax_amt -
                     tx2d_cur_recov_amt).

               /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
               TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS
               NOT BEEN ASSIGNED TO OTHER TRANSACTIONS. */
               if last_sr_wkfl then do:
                  if type_tax <> 0 and last-of(tx2d_line) then
                     assign type_tax = type_tax - accum_type_tax.
               end.
               else
               if totl_qty_this_rcpt <> 0 then do:
                  assign type_tax = type_tax
                        * (trqty / totl_qty_this_rcpt).
                  /* ROUND PER BASE CURRENCY ROUND METHOD */
                  {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output type_tax,
                          input gl_rnd_mthd,
                          output mc-error-number)"}
               end.
            end.
            else
            /* TAX INCLUDED = YES */
            do:
               /* ADDED type_tax = type_tax - tx2d_cur_recov_amt INSTEAD  */
               /* OF type_tax = - tx2d_cur_recov_amt TO PREVENT type_tax  */
               /* TO BE OVER-WRITTEN WHEN TWO TAX CODES ARE USED AND      */
               /* INCLUDED TAX CODE IS AFTER NON-INCLUDED TAX CODE IN THE */
               /* ASCENDING ORDER.                                        */

               type_tax = type_tax - tx2d_cur_recov_amt.

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
                     {gprunp.i "mcpl" "p" "mc-curr-rnd"
                           "(input-output type_tax,
                             input gl_rnd_mthd,
                             output mc-error-number)"}
                  end.
               end.
               else
               if totl_qty_this_rcpt <> 0 then do:
                  assign type_tax = type_tax
                        * (trqty / totl_qty_this_rcpt).
                  /* ROUND PER BASE CURRENCY ROUND METHOD */
                  {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output type_tax,
                          input gl_rnd_mthd,
                          output mc-error-number)"}
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
                  {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output type_tax,
                          input gl_rnd_mthd,
                          output mc-error-number)"}
               end.
            end.
            else
            if totl_qty_this_rcpt <> 0 then do:
               assign type_tax = type_tax
                     * (trqty / totl_qty_this_rcpt).
               /* ROUND PER BASE CURRENCY ROUND METHOD */
               {gprunp.i "mcpl" "p" "mc-curr-rnd"
                     "(input-output type_tax,
                       input gl_rnd_mthd,
                       output mc-error-number)"}
            end.
         end.

         /* FOR MULTIPLE TAX TYPES, POPULATE accum_type_tax */
         /* AT LAST TAX TYPE */
         if last-of(tx2d_line)
            or not can-find(first tx2d_det
                               where tx2d_tr_type = tax_tr_type
                               and   tx2d_ref     = receivernbr
                               and   tx2d_nbr     = po_nbr
                               and   tx2d_line    = pod_line
                               and   tx2d_tax_in  = no)
         then do:

            accum_type_tax = accum_type_tax + type_tax.
            if base_curr <> po_curr then
            do:
               /* CONVERT TYPE_TAX TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input po_curr,
                       input base_curr,
                       input exch_rate,
                       input exch_rate2,
                       input type_tax,
                       input true, /* DO ROUND */
                       output type_tax,
                       output mc-error-number)"}.
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.
            end. /* IF BASE_CURR <> PO_CURR  */
            assign line_tax = line_tax + type_tax.
         end. /* IF LAST-OF(TX2D_LINE)  */

      end.

      /* l_total_cost   :  THE DEFAULT UNIT PRICE IN PO MAINTENANCE      */
      /* l_base_amt     :  PO PRICE                                      */
      /* l_extbase_amt  :  TOTAL EXTENDED AMOUNT                         */
      /* l_excrv_amt    :  EXCHANGE ROUNDING VARIANCE                    */
      /* l_ppv_amt      :  PURCHASE PRICE VARIANCE                       */

      /* PURCHASE PRICE VARIANCE WILL EXIST IF THERE IS ANY DIFFERENCE   */
      /* BETWEEN l_total_cost AND l_base_amt OR PO IS CREATED WITH       */
      /* NON-RECOVERABLE TAX ACCRUED AT RECEIPT.                         */
      /* EXCHANGE ROUNDING WILL EXIST WHEN l_total_cost IS EQUAL TO      */
      /* l_base_amt AND IF THERE IS VARIANCE DUE TO CURRENCY CONVERSION  */
      /* OR EXCHANGE RATE DIFFERENCE BETWEEN PO AND RECEIPT.             */

      /* 1. CALCULATE THE PURCHASE PRICE VARIANCE USING UNROUNDED        */
      /*    GL MATERIAL COST AND THE PO PRICE USING FORMULA:             */
      /*    (a) WHEN LOGISTICS ACCOUNTING = No.                          */
      /*    [(Total GL Cost - Overhead cost) * Qty] - [PO Cost * Qty].   */
      /*    (b) WHEN LOGISTICS ACCOUNTING = Yes.                         */
      /*    [(Total GL Cost - Overhead Cost - Logistics Charges  * Qty]  */
      /*      - [PO Cost * Qty].                                         */
      /* 2. WHEN DEFAULT PO COST <> PO COST, AND COSTING ENV IS NOT      */
      /*    AVERAGE CALCULATE PPV USING THE FORMULA:                     */
      /*    gl_amt[3] = l_ppv_amt + line_tax.                            */
      /* 3. WHEN DEFAULT PO COST = PO COST CALCULATE THE EXCHANGE        */
      /*    ROUNDING VARIANCE USING THE FORMULA:                         */
      /*    gl_amt[5] = l_excrv_amt.                                     */

      l_ppv_amt = sct_cst_tot.

      /* FOR LOGASTICS ACCOUNTING SUBSTRACT LOGASTICS CHARGES FROM PPV   */
      if use-log-acctg
         and po_tot_terms_code <> ""
      then do:

         cat-list = "1,4".

         run p-calc-charge
            (input        cat-list,
             input-output l_ppv_amt,
             input-output dummy-cost).
      end. /* IF use-log-acctg ... */

      l_ppv_amt = trqty * (l_ppv_amt - sct_ovh_tl).

      if pt_pm_code = "c"
         and po_is_btb
      then do:
         run p-price-configuration.
         l_ppv_amt = l_ppv_amt + l_glxcst.
      end. /* IF PT_PM_CODE - "C" ... */

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output l_ppv_amt,
           input        gl_rnd_mthd,
           output       mc-error-number)"}

      l_extbase_amt = trqty * l_base_amt.

      run p-poconv
         (input-output l_extbase_amt).

      assign
         l_ppv_amt   = l_extbase_amt - l_ppv_amt
         l_excrv_amt = l_ppv_amt.

      if l_total_cost = l_base_amt
      then
         l_ppv_amt   = 0.
      else
         l_excrv_amt = 0.

      if (using_supplier_consignment
         and ip_consign_flag)
      then
         l_ppv_amt = 0.

      /*PPV RECEIPT*/
      {&POPORCB6-P-TAG4}
      assign
         dr_acct[3] = dftPPVAcct
         dr_sub[3]  = dftPPVSubAcct
         dr_cc[3]   = dftPPVCostCenter
         dr_proj[3] = pod_proj
         cr_acct[3] = dftRCPTAcct
         cr_sub[3]  = dftRCPTSubAcct
         cr_cc[3]   = dftRCPTCostCenter
         cr_proj[3] = pod_proj
         entity[3]  = pod_entity
         gl_amt[3]  = line_tax + l_ppv_amt.
      {&POPORCB6-P-TAG5}

      /* ROUND PER BASE CURRENCY ROUND METHOD */
      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output gl_amt[3],
           input gl_rnd_mthd,
           output mc-error-number)"}

      if (not using_supplier_consignment) or
         (using_supplier_consignment and not ip_consign_flag) or
         (using_supplier_consignment and ip_consign_flag and ip_is_usage)
         then do:
         if pod_entity <> pod_po_entity
            or poddb <> podpodb then do:
            /*INTERCOMPANY POSTING - INTERCO ACCT*/
            {&POPORCB6-P-TAG6}
            /* GET THE INTER-COMPANY ACCOUNT */
            {glenacex.i &entity=pod_po_entity
                        &type='"CR"'
                        &module='"IC"'
                        &acct=cr_acct[4]
                        &sub=cr_sub[4]
                        &cc=cr_cc[4] }

            assign
               dr_acct[4] = dftRCPTAcct
               dr_sub[4]  = dftRCPTSubAcct
               dr_cc[4]   = dftRCPTCostCenter
               dr_proj[4] = pod_proj
               cr_proj[4] = pod_proj
               entity[4]  = pod_entity
               gl_amt[4]  = glamt + line_tax.

            {glenacex.i &entity=pod_entity
                        &type='"DR"'
                        &module='"IC"'
                        &acct=dr_acct[6]
                        &sub=dr_sub[6]
                        &cc=dr_cc[6] }

            /*INTERCOMPANY POSTING - PO RECEIPTS ACCT*/
            assign
               dr_proj[6] = pod_proj
               cr_acct[6] = dftRCPTAcct
               cr_sub[6]  = dftRCPTSubAcct
               cr_cc[6]   = dftRCPTCostCenter
               cr_proj[6] = pod_proj
               entity[6]  = pod_po_entity
               gl_amt[6]  = glamt + line_tax.
            {&POPORCB6-P-TAG7}

         end. /* If pod_entity <> pod_po_entity */
      end. /* If (not using_supplier_consignment) or */

      /* IN STANDARD GL COST ENVIRONMENT, FOR NON-BASE CURRENCY THE  */
      /* GL AMOUNT FOR INVENTORY ACCOUNT IS UPDATED CORRECTLY BASED  */
      /* ON THE (TOTAL COST - OVERHEAD COST) & QTY RECEIVED FOR AN   */
      /* ITEM. ALSO, THE ROUNDING DIFFERENCES BETWEEN THE INVENTORY  */
      /* ACCOUNT AND PO RECEIPT ACCOUNT ARE POSTED TO EXCHANGE       */
      /* ROUNDING ACCOUNT.                                           */

      if glx_mthd        =  "STD"
         and po_curr     <> base_curr
         and l_excrv_amt <> 0
      then do:

         for first cu_mstr
            fields (cu_curr cu_ex_rnd_acct cu_ex_rnd_cc cu_ex_rnd_sub)
            where cu_curr = po_curr
         no-lock:
         end. /* FOR FIRST cu_mstr */

         if  available cu_mstr
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
               gl_amt[5]  = l_excrv_amt.

      end. /* IF glx_mthd = "STD" ... */
      /* PO RETURNS AND NEGATIVE PO RECEIPTS UPDATE THE AVERAGE GL   */
      /* COST INCORRECTLY WHEN THE RETURN IS FROM A SITE DIFFERENT   */
      /* FROM THE PO LINE SITE.                                      */
      /* THE QOH AND CURRENT GL COST ARE INCORRECT, IF THE RETURN    */
      /* TRANSACTION IS PRIOR TO THE TRANSFER. TO CORRECT THIS,      */
      /* THE SEQUENCE OF TRANSFER TRANSACTION (ISS-TR & RCT-TR) AND  */
      /* RECEIPT TRANSACTION (RCT-PO/ISS-PRV) ARE NOW EXCHANGED      */

      /* icxfer1.p IS MOVED FROM POPORCC.P TO POPORCB6.P FOR         */
      /* NEGATIVE RECEIPT OF INVENTORY ITEMS                         */
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
              fields (ld_assay ld_expire ld_grade ld_loc ld_lot ld_part
                      ld_qty_all ld_qty_frz ld_qty_oh ld_ref ld_site ld_status)
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
                                  input kbtransnbr,
                                  output l_glcost,
                                  input-output l_assay,
                                  input-output l_grade,
                                  input-output l_expire)" }
/*GUI*/ if global-beam-me-up then undo, leave.



         if glx_mthd = "AVG"
         or cur_mthd = "AVG"
         or cur_mthd = "LAST"
         then do:
            /* ADDED 8th INPUT PARAMETER AS RECEIVING */
            /* SITES CONSIGNMENT INVENTORY USAGE      */
            {gprun.i ""csavg02.p""
                     "(input  pt_part,
                       input  pod_site,
                       input  transtype,
                       input  kbtransnbr,
                       input  recid(pt_mstr),
                       input  po_nbr,
                       input  trqty,
                       input  ip_usage_qty,
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
/*GUI*/ if global-beam-me-up then undo, leave.


         end. /* IF glx_mthd = "AVG".... */

      end. /* IF pod_type = "" AND site <> rct_site  */

      /*RE-CALCULATE AVERAGE COST*/
      if glx_mthd = "AVG" then do:
         if reavg_yn then do:

            /* ADDED 3rd INPUT PARAMETER AS RECEIVING */
            /* SITES CONSIGNMENT INVENTORY USAGE      */

            {gprun.i ""csavg03.p"" "(input recid(sct_det),
                                       input trqty,
                                       input ip_usage_qty,
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
/*GUI*/ if global-beam-me-up then undo, leave.

         end.

         assign
            l_newcst    = newcst
            l_newovh_tl = newovh_tl.

         run p-costconv(input l_newcst, input l_newovh_tl).

         run p-poconv(input-output gl_amt[1]).

         assign gl_amt[2]  = trqty * newovh_tl.
         {&POPORCB6-P-TAG27}
         /* ROUND PER BASE CURR ROUND METHOD */
         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output gl_amt[2],
              input gl_rnd_mthd,
              output mc-error-number)"}

         /* INITIALISE gl_amt[3] TO ZERO SINCE PPV SHOULD NOT BE   */
         /* GENERATED AND POSTED IN AN AVERAGE COSTING ENVIRONMENT */
         assign gl_amt[3]  = 0.
      end.
   end. /*if pod_type = ""*/

   /*SUBCONTRACT RECEIPTS*/
   else if available pt_mstr and pod_type = "S" then do:

      for first pl_mstr
      fields(pl_cop_acct
             pl_cop_sub
             pl_cop_cc
             pl_inv_acct
             pl_inv_sub
             pl_inv_cc
             pl_ovh_acct
             pl_ovh_sub
             pl_ovh_cc
             pl_ppv_acct
             pl_ppv_sub
             pl_ppv_cc
             pl_prod_line
             pl_rcpt_acct
             pl_rcpt_sub
             pl_rcpt_cc )
             where pl_prod_line = pt_prod_line no-lock:
      end. /* FOR FIRST PL_MSTR */
      /* Determine supplier type needed to get default gl account info */
      run getGLDefaults.

      run checkForKanbanWIPSupermarket.

      {&POPORCB6-P-TAG8}
      assign
         dr_proj[1] = pod_proj
         cr_acct[1] = dftRCPTAcct
         cr_sub[1]  = dftRCPTSubAcct
         cr_cc[1]   = dftRCPTCostCenter
         cr_proj[1] = pod_proj
         entity[1]  = pod_entity
         gl_amt[1]  = glamt.

      if useWIPAcct = no then
      assign
         dr_acct[1] = dftCOPAcct
         dr_sub[1]  = dftCOPSubAcct
         dr_cc[1]   = dftCOPCostCenter.
      else
      assign
         dr_acct[1] = dftWIPAcct
         dr_sub[1]  = dftWIPSubAcct
         dr_cc[1]   = dftWIPCostCenter.

      {&POPORCB6-P-TAG9}
      /* GLAMT WAS CALCULATED AND CONVERTED IN THE */
      /* BEGINNING, NO NEED TO RECALCULATE. */

      assign wolot = pod_wo_lot
         woop  = pod_op.

      if can-find(first wr_route
         where wr_lot = wolot and wr_op = woop)
      then do:

         for first wo_mstr
               fields(wo_lot wo_nbr wo_part wo_routing wo_status wo_type)
               where wo_lot = wolot no-lock:
         end. /* FOR FIRST WO_MSTR */

         find wr_route
            where wr_lot = wolot
            and   wr_op = woop exclusive-lock no-error.

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
                  posub_cr_sub  = dr_sub[1]
                  posub_cr_cc   = dr_cc[1]
                  posub_effdate = eff_date
                  posub_site    = site
                  posub_loc     = location
                  posub_lotser  = lotser
                  posub_ref     = lotref
                  posub_move    = move.

               for first ro_det
                     fields (ro_mv_nxt_op ro_op ro_routing ro_sub_cost)
                     where ro_routing = ( if wo_routing <> "" then
                     wo_routing else wo_part )
                     and ro_op = woop no-lock:
               end. /* FOR FIRST RO_DET */

               /* REPLACED ro_sub_cost WITH wr_sub_cost AS THE LATTER BEING FREEZED */
               /* COST WOULD BE USED FOR CALCULATING SUBCONTRACT RATE VARIANCE      */
               stdcst = wr_sub_cost.
               if available ro_det then
                  posub_move = ro_mv_nxt_op.
               else
                  posub_move = wr_mv_nxt_op.
            end.
            else do:
               assign wr_po_nbr = pod_nbr.
               {gprun.i ""porcsub.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.
         end.
      end.
      else do:
         assign l_ro_routing = "".

         for first ptp_det
               fields( ptp_part ptp_routing ptp_site )
               where ptp_part = pod_part
               and   ptp_site = pod_site no-lock:
         end. /* FOR FIRST PTP_DET */

         if available ptp_det then do:
            if ptp_routing <> "" then
               assign l_ro_routing = ptp_routing.
            else
               assign l_ro_routing = pod_part.
         end.
         else do:
            for first pt_mstr
                  fields(pt_part pt_pm_code pt_prod_line pt_routing)
                  where pt_part = pod_part no-lock:
            end. /* FOR FIRST PT_MSTR */
            if available pt_mstr then do:
               if pt_routing <> "" then
                  assign l_ro_routing = pt_routing.
               else
                  assign l_ro_routing = pod_part.
            end.
         end. /* not available ptp_det */

         for first ro_det
               fields(ro_mv_nxt_op ro_op ro_routing ro_sub_cost)
               where ro_routing = l_ro_routing
               and   ro_op = woop no-lock:
         end. /* FOR FIRST RO_DET */
         if available ro_det then
            assign stdcst = ro_sub_cost.
         else
            assign stdcst = 0.
      end. /* IF WORKORDER IS NOT AVAILABLE */

      assign type_tax = 0
         line_tax = 0.
      /* NON-RECOVERABLE TAXES GO INTO PPV */
      for each tx2d_det
            fields (tx2d_cur_recov_amt tx2d_cur_tax_amt tx2d_line tx2d_nbr
                    tx2d_rcpt_tax_point tx2d_ref tx2d_tax_in
                    tx2d_tax_code tx2d_tr_type)
            where tx2d_tr_type = tax_tr_type and
                  tx2d_ref = receivernbr and tx2d_nbr = po_nbr and
                  tx2d_line = pod_line no-lock break by tx2d_line:

         for first tx2_mstr no-lock
            where tx2_tax_code = tx2d_tax_code:
         end.

         if (tx2d_rcpt_tax_point) and              /* ACCRUE @ RECEIPT */
            ((not using_supplier_consignment or
              not ip_consign_flag) or
             (using_supplier_consignment  and       /* CONSIGNMENT OVERRIDES */
              ip_consign_flag             and
              tx2_usage_tax_point = no    and       /* DON'T ACCRUE @ USAGE */
              ip_is_usage = no ))  or               /* MATERIAL USAGE = NO  */
             (using_supplier_consignment  and
              ip_consign_flag             and
              tx2_usage_tax_point         and       /* ACCRUE @ USAGE */
              ip_is_usage)                          /* MATERIAL USAGE = YES */
            then do:
            /* ACCRUE TAX AT RECEIPT */
            if not tx2d_tax_in then
            /* TAX INCLUDED = NO */
            do:
               /* ACCUMULATE TAXES FOR MULTIPLE TAX TYPES */
               if last_sr_wkfl then
               assign type_tax = type_tax +
                     tx2d_cur_tax_amt - tx2d_cur_recov_amt.
               else
               assign type_tax = type_tax *
                     (totl_qty_this_rcpt / trqty) +
                     (tx2d_cur_tax_amt -
                     tx2d_cur_recov_amt).

               /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
               TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS
               NOT BEEN ASSIGNED TO OTHER TRANSACTIONS. */
               if last_sr_wkfl then do:
                  if type_tax <> 0 and last-of(tx2d_line) then
                     assign type_tax = type_tax - accum_type_tax.
               end.
               else
               if totl_qty_this_rcpt <> 0 then do:
                  assign type_tax = type_tax
                        * (trqty / totl_qty_this_rcpt).
                     /* ROUND PER BASE CURRENCY ROUND METHOD */
                  {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output type_tax,
                          input gl_rnd_mthd,
                          output mc-error-number)"}
               end.
            end.
            else
            /* TAX INCLUDED = YES */
            do:
               /* ADDED type_tax = type_tax - tx2d_cur_recov_amt INSTEAD  */
               /* OF type_tax = - tx2d_cur_recov_amt TO PREVENT type_tax  */
               /* TO BE OVER-WRITTEN WHEN TWO TAX CODES ARE USED AND      */
               /* INCLUDED TAX CODE IS AFTER NON-INCLUDED TAX CODE IN THE */
               /* ASCENDING ORDER.                                        */

               type_tax = type_tax - tx2d_cur_recov_amt.

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
                     {gprunp.i "mcpl" "p" "mc-curr-rnd"
                           "(input-output type_tax,
                             input gl_rnd_mthd,
                             output mc-error-number)"}
                  end.
               end.
               else
               if totl_qty_this_rcpt <> 0 then do:
                  assign type_tax = type_tax
                        * (trqty / totl_qty_this_rcpt).
                  /* ROUND PER BASE CURRENCY ROUND METHOD */
                  {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output type_tax,
                          input gl_rnd_mthd,
                          output mc-error-number)"}
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
                  {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output type_tax,
                          input gl_rnd_mthd,
                          output mc-error-number)"}
               end.
            end.
            else
            if totl_qty_this_rcpt <> 0 then do:
               assign type_tax = type_tax
                     * (trqty / totl_qty_this_rcpt).
               /* ROUND PER BASE CURRENCY ROUND METHOD */

               {gprunp.i "mcpl" "p" "mc-curr-rnd"
                     "(input-output type_tax,
                       input gl_rnd_mthd,
                       output mc-error-number)"}
            end.
         end.

         /* FOR MULTIPLE TAX TYPES, POPULATE accum_type_tax */
         /* AT LAST TAX TYPE */
         if last-of(tx2d_line) then
         do:
            assign
               accum_type_tax = accum_type_tax + type_tax.
            if base_curr <> po_curr then
            do:
               /* CONVERT TYPE_TAX TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input po_curr,
                       input base_curr,
                       input exch_rate,
                       input exch_rate2,
                       input type_tax,
                       input true, /* DO ROUND */
                       output type_tax,
                       output mc-error-number)"}.
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.
            end. /* IF BASE_CURR <> PO_CURR  */
            assign line_tax = line_tax + type_tax.
         end. /* IF LAST-OF(TX2D_LINE)  */
      end.

      /*PPV RECEIPT*/
      {&POPORCB6-P-TAG10}
      assign
         dr_acct[3] = dftPPVAcct
         dr_sub[3]  = dftPPVSubAcct
         dr_cc[3]   = dftPPVCostCenter
         dr_proj[3] = pod_proj
         cr_acct[3] = dftRCPTAcct
         cr_sub[3]  = dftRCPTSubAcct
         cr_cc[3]   = dftRCPTCostCenter
         cr_proj[3] = pod_proj
         entity[3]  = pod_entity.
      {&POPORCB6-P-TAG11}

      /* IN AVERAGE COSTING ENVIRONMENT THERE SHOULD NOT BE ANY */
      /* PPV GENERATED AND POSTED. HENCE gl_amt[3] WHICH HOLDS  */
      /* TAX AMOUNT IS INITIALISED TO ZERO.                     */
      if glx_mthd = "AVG" then
         assign gl_amt[3]  = 0.
      else
         assign gl_amt[3]  = line_tax.

      if entity[1] <> pod_po_entity or poddb <> podpodb
      then do:
         /*INTERCOMPANY POSTING - INTERCO ACCT*/
         {&POPORCB6-P-TAG12}
         {glenacex.i &entity=pod_po_entity
                     &type='"CR"'
                     &module='"IC"'
                     &acct=cr_acct[2]
                     &sub=cr_sub[2]
                     &cc=cr_cc[2] }

         assign
            dr_acct[2] = dftRCPTAcct
            dr_sub[2]  = dftRCPTSubAcct
            dr_cc[2]   = dftRCPTCostCenter
            dr_proj[2] = project
            cr_proj[2] = project
            entity[2]  = entity[1]
            gl_amt[2]  = glamt.

         /*INTERCOMPANY POSTING - PO RECEIPTS ACCT*/
         {glenacex.i &entity=entity[1]
                     &type='"DR"'
                     &module='"IC"'
                     &acct=dr_acct[6]
                     &sub=dr_sub[6]
                     &cc=dr_cc[6] }

         assign
            dr_proj[6] = project
            cr_acct[6] = dftRCPTAcct
            cr_sub[6]  = dftRCPTSubAcct
            cr_cc[6]   = dftRCPTCostCenter
            cr_proj[6] = project
            entity[6]  = pod_po_entity
            gl_amt[6]  = glamt.
         {&POPORCB6-P-TAG13}
      end.
   end. /*if pod_type = "S"*/

   /*MEMO ITEM RECEIPTS*/
   else do:
      {&POPORCB6-P-TAG14}
      assign
         dr_acct[1] = pod_acct
         dr_sub[1]  = pod_sub
         dr_cc[1]   = pod_cc
         dr_proj[1] = pod_proj
         cr_acct[1] = gl_rcptx_acct
         cr_sub[1]  = gl_rcptx_sub
         cr_cc[1]   = gl_rcptx_cc
         cr_proj[1] = pod_proj
         entity[1]  = pod_entity
         gl_amt[1]  = glamt.
      {&POPORCB6-P-TAG15}
      /* GLAMT WAS CALCULATED AND CONVERTED IN THE */
      /* BEGINNING, NO NEED TO RECALCULATE. */

      assign type_tax = 0
             line_tax = 0.
         /* NON-RECOVERABLE TAXES GO INTO PPV */
      for each tx2d_det
            fields (tx2d_cur_recov_amt tx2d_cur_tax_amt tx2d_line tx2d_nbr
                    tx2d_rcpt_tax_point tx2d_ref tx2d_tax_in tx2d_tr_type)
            where tx2d_tr_type = tax_tr_type and
                  tx2d_ref = receivernbr and tx2d_nbr = po_nbr and
                  tx2d_line = pod_line no-lock break by tx2d_line:
/*GUI*/ if global-beam-me-up then undo, leave.


         if tx2d_rcpt_tax_point then do:
            /* ACCRUE TAX AT RECEIPT */
            if not tx2d_tax_in then
            /* TAX INCLUDED = NO */
            do:
               /* ACCUMULATE TAXES FOR MULTIPLE TAX TYPES */
               if last_sr_wkfl then
               assign type_tax = type_tax +
                      tx2d_cur_tax_amt - tx2d_cur_recov_amt.
               else
               assign type_tax = type_tax *
                     (totl_qty_this_rcpt / trqty) +
                     (tx2d_cur_tax_amt -
                     tx2d_cur_recov_amt).

               /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
               TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS
               NOT BEEN ASSIGNED TO OTHER TRANSACTIONS. */
               if last_sr_wkfl then do:
                  if type_tax <> 0 and last-of(tx2d_line) then
                     assign type_tax = type_tax - accum_type_tax.
               end.
               else
                  if totl_qty_this_rcpt <> 0 then do:
                  assign type_tax = type_tax
                        * (trqty / totl_qty_this_rcpt).
                  /* ROUND PER BASE CURRENCY ROUND METHOD */
                  {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output type_tax,
                          input gl_rnd_mthd,
                          output mc-error-number)"}
               end.
            end.
            else
            /* TAX INCLUDED = YES */
            do:
               /* ADDED type_tax = type_tax - tx2d_cur_recov_amt INSTEAD  */
               /* OF type_tax = - tx2d_cur_recov_amt TO PREVENT type_tax  */
               /* TO BE OVER-WRITTEN WHEN TWO TAX CODES ARE USED AND      */
               /* INCLUDED TAX CODE IS AFTER NON-INCLUDED TAX CODE IN THE */
               /* ASCENDING ORDER.                                        */

               type_tax = type_tax - tx2d_cur_recov_amt.

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
                     {gprunp.i "mcpl" "p" "mc-curr-rnd"
                           "(input-output type_tax,
                             input gl_rnd_mthd,
                             output mc-error-number)"}
                  end.
               end.
               else
               if totl_qty_this_rcpt <> 0 then do:
                  assign type_tax = type_tax
                        * (trqty / totl_qty_this_rcpt).
                  /* ROUND PER BASE CURRENCY ROUND METHOD */
                  {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output type_tax,
                          input gl_rnd_mthd,
                          output mc-error-number)"}
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
                  {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output type_tax,
                          input gl_rnd_mthd,
                          output mc-error-number)"}
               end.
            end.
            else
            if totl_qty_this_rcpt <> 0 then do:
               assign type_tax = type_tax
                     * (trqty / totl_qty_this_rcpt).
               /* ROUND PER BASE CURRENCY ROUND METHOD */
               {gprunp.i "mcpl" "p" "mc-curr-rnd"
                     "(input-output type_tax,
                       input gl_rnd_mthd,
                       output mc-error-number)"}
            end.
         end.

         /* FOR MULTIPLE TAX TYPES, POPULATE accum_type_tax */
         /* AT LAST TAX TYPE */
         if last-of(tx2d_line) then
         do:
            assign
               accum_type_tax = accum_type_tax + type_tax.
            if base_curr <> po_curr then
            do:
               /* CONVERT TYPE_TAX TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input po_curr,
                       input base_curr,
                       input exch_rate,
                       input exch_rate2,
                       input type_tax,
                       input true, /* DO ROUND */
                       output type_tax,
                       output mc-error-number)"}.
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.
            end. /* IF BASE_CURR <> PO_CURR  */
            assign line_tax = line_tax + type_tax.
         end. /* IF LAST-OF(TX2D_LINE)  */

      end.
/*GUI*/ if global-beam-me-up then undo, leave.


      /* COMPONENTS ALREADY ROUNDED */
      assign gl_amt[1] = gl_amt[1] + line_tax.

      if pod_entity <> pod_po_entity or poddb <> podpodb
      then do:
         /*INTERCOMPANY POSTING - INTERCO ACCT*/
         {&POPORCB6-P-TAG16}
         {glenacex.i &entity=pod_po_entity
                     &type='"CR"'
                     &module='"IC"'
                     &acct=cr_acct[2]
                     &sub=cr_sub[2]
                     &cc=cr_cc[2] }

         assign
            dr_acct[2] = gl_rcptx_acct
            dr_sub[2]  = gl_rcptx_sub
            dr_cc[2]   = gl_rcptx_cc
            dr_proj[2] = pod_proj
            cr_proj[2] = pod_proj
            entity[2]  = pod_entity
            gl_amt[2]  = glamt + line_tax.

         /*INTERCOMPANY POSTING - PO RECEIPTS ACCT*/
         {glenacex.i &entity=pod_entity
                     &type='"DR"'
                     &module='"IC"'
                     &acct=dr_acct[6]
                     &sub=dr_sub[6]
                     &cc=dr_cc[6] }

         assign
            dr_proj[6] = pod_proj
            cr_acct[6] = gl_rcptx_acct
            cr_sub[6]  = gl_rcptx_sub
            cr_cc[6]   = gl_rcptx_cc
            cr_proj[6] = pod_proj
            entity[6]  = pod_po_entity
            gl_amt[6]  = glamt + line_tax.
         {&POPORCB6-P-TAG17}

      end.
   end. /*else do (memo items)*/

   /* CREATE TRAN HISTORY RECORD FOR EACH LOT/SERIAL/PART */
   assign
      pt_recno  = recid(pt_mstr)
      pod_recno = recid(pod_det)
      po_recno  = recid(po_mstr)
      wr_recno  = recid(wr_route).

   {gprun.i ""poporcc.p""
      "(input shipnbr,
        input ship_date,
        input inv_mov,
        input ip_consign_flag,
        input ip_is_usage,
        input ip_usage_qty,
        input ip_woiss_nbr,
        output invntry-trnbr)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   op_rctpo_trnbr = invntry-trnbr.

   if (pod_rma_type = "I"   or
      pod_rma_type = "O")
   then do:
      {gprun.i ""fsrtvtrn.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

      if undo_all then leave .
   end.

   if porec
      and prm-avail
   then do:
      /* PERFORM PRM PROCESSING ON PO LINE RECEIPT.    */
      /* OCCURRANCE OF PRM PROCESSING FOR EACH SR_WKFL */
      /* NEEDED FOR INVENTORY ITEMS                    */
      /* ADDED PARAMETER LINE_TAX */
      {gprunmo.i &module="PRM" &program=""pjporprm.p""
         &param="""(input eff_date,
                    input invntry-trnbr,
                    buffer sr_wkfl,
                    buffer pod_det,
                    input line_tax)"""}
   end.  /* IF POREC AND PRM-ENABLED */

end.  /* for each sr_wkfl */

for each sr_wkfl exclusive-lock where
   ((sr_userid = mfguser and ip_is_usage = no) or
    (sr_userid = mfguser + "cons" and ip_is_usage))
      and sr_lineid = string(pod_line):
   delete sr_wkfl.
end.

if pod_qty_chg <> 0 then do:

   for first rmd_det
         where rmd_nbr    = pod_nbr
         and   rmd_prefix = "V"
         and   rmd_line   = pod_line exclusive-lock:
   end. /* FOR FIRST RMD_DET */
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

/* PROCEDURE TO OBTAIN COST OF COMPONENT ITEMS FOR AN EMT PO */

PROCEDURE p-price-configuration:

   define variable l_qty_req like sob_qty_req no-undo.

   l_glxcst = 0.
   for first sod_det
         fields (sod_line sod_nbr sod_qty_ord)
         where sod_nbr  = po_mstr.po_so_nbr
         and sod_line = pod_det.pod_sod_line no-lock:
   end. /* FOR FIRST SOD_DET */
   if available sod_det then
   do:
      for each sob_det
            fields (sob_line sob_nbr sob_part sob_qty_req
                    sob_serial sob_site)
            where sob_nbr  = sod_nbr
            and sob_line = sod_line no-lock
            break by sob_part:
/*GUI*/ if global-beam-me-up then undo, leave.


         if first-of(sob_part) then
            l_qty_req = 0.

         if substring(sob_serial,15,1) = "o" then
            l_qty_req = l_qty_req + sob_qty_req.

         if last-of(sob_part) and
            l_qty_req <> 0 then
         do:
            {gprun.i ""gpsct05.p""
               "(input sob_part, sob_site, input 1,
                 output glxcst, output curcst)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            assign
               glxcst = glxcst * (sob_qty_req / sod_qty_ord)
               l_glxcst = l_glxcst + glxcst.
         end. /* IF LAST-OF (SOB_PART) ... */

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH SOB_DET */
      l_glxcst = l_glxcst * absolute(trqty).
   end. /* IF AVAILABLE SOD_DET */

end. /* PROCEDURE P-PRICE-CONFIGURATION */

/* PROCEDURE p-poconv TO ROUND AMOUNT ACCORDING TO PO CURRENCY */
/* AND CONVERT IT TO BASE CURRENCY                             */

PROCEDURE p-poconv:

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
END PROCEDURE. /* PROCEDURE p-poconv */

/* PROCEDURE p-costconv TO CONVERT COST TO PO CURRENCY AND   */
/* ASSIGN THE DISPLAYED COST BACK TO MAKE IT IN SYNC         */
/* WITH VOUCHER MAINTENANCE PROGRAM                          */

PROCEDURE p-costconv:

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

   assign
      l_total_cost = l_sct_cst_tot - l_sct_ovh_tl
      l_total_cost = round(l_total_cost,5).

   if glx_mthd = "AVG"
   then
      gl_amt[1]    = trqty * l_total_cost.

END PROCEDURE. /* PROCEDURE p-costconv */
PROCEDURE getGLDefaults:
   for first vd_mstr
      fields(vd_addr vd_type)
      where vd_addr = po_mstr.po_vend no-lock: end.

   {gprun.i ""glactdft.p"" "(input ""PO_RCPT_ACCT"",
                             input pt_mstr.pt_prod_line,
                             input pod_det.pod_site,
                             input if available vd_mstr then
                                   vd_type else """",
                             input """",
                             input no,
                             output dftRCPTAcct,
                             output dftRCPTSubAcct,
                             output dftRCPTCostCenter)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   {gprun.i ""glactdft.p"" "(input ""PO_PPV_ACCT"",
                             input pt_mstr.pt_prod_line,
                             input pod_det.pod_site,
                             input if available vd_mstr then
                                   vd_type else """",
                             input """",
                             input no,
                             output dftPPVAcct,
                             output dftPPVSubAcct,
                             output dftPPVCostCenter)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   {gprun.i ""glactdft.p"" "(input ""PO_OVH_ACCT"",
                             input pt_mstr.pt_prod_line,
                             input pod_det.pod_site,
                             input if available vd_mstr then
                                   vd_type else """",
                             input """",
                             input no,
                             output dftOVHAcct,
                             output dftOVHSubAcct,
                             output dftOVHCostCenter)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   {gprun.i ""glactdft.p"" "(input ""WO_COP_ACCT"",
                             input pt_mstr.pt_prod_line,
                             input pod_det.pod_site,
                             input """",
                             input """",
                             input no,
                             output dftCOPAcct,
                             output dftCOPSubAcct,
                             output dftCOPCostCenter)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   {gprun.i ""glactdft.p"" "(input ""WO_WIP_ACCT"",
                             input pt_mstr.pt_prod_line,
                             input pod_det.pod_site,
                             input """",
                             input """",
                             input no,
                             output dftWIPAcct,
                             output dftWIPSubAcct,
                             output dftWIPCostCenter)"}
/*GUI*/ if global-beam-me-up then undo, leave.


END PROCEDURE.

PROCEDURE p-calc-charge:

define input parameter        ip-cat-list as character     no-undo.
define input-output parameter cost-total  like sct_cst_tot no-undo.
define input-output parameter calc-amt    as decimal       no-undo.

for each lacd_det
   where lacd_det.lacd_internal_ref_type = {&TYPE_PO}
   and lacd_det.lacd_internal_ref = po_mstr.po_nbr
   no-lock:

   for first in_mstr
      where in_part = pod_det.pod_part
      and in_site = pod_det.pod_site
      no-lock:
   end.
   if not available in_mstr then next.

   for first sc_mstr
      where sc_sim = (if in_gl_set <> "" then
         in_gl_set else icc_ctrl.icc_gl_set)
      and sc_element = lacd_element
      and lookup(sc_category, ip-cat-list) > 0
      no-lock:
   end.
   if not available sc_mstr then next.

   for first spt_det
      where spt_site = in_gl_cost_site
      and spt_sim = sc_sim
      and spt_part = pod_part
      and spt_element = lacd_element
      no-lock:
   end.
   if not available spt_det then next.

   cost-total = cost-total - spt_cst_tl.


   if glx_mthd <> "AVG" then
      calc-amt  = calc-amt - (trqty * spt_cst_tl).

end. /* for each lacd_mstr */

END PROCEDURE.


PROCEDURE checkForKanbanWIPSupermarket:
/* CHECK FOR PO RECEIPT GENERATED BY KANBAN TRANSACTION    */
/* AND IF THE KANBAN SUPERMARKET IS A WIP INVENTORY TYPE.   */
   useWIPAcct = no.

   if kbtransnbr <> 0 then do:
      for first kbtr_hist
         fields(kbtr_supermarket_id kbtr_source_type kbtr_supermarket_site
        kbtr_trans_nbr)
         where kbtr_trans_nbr = kbtransnbr
      no-lock,
      first knbsm_mstr
         fields(knbsm_supermarket_id knbsm_site knbsm_inv_loc_type)
         where knbsm_site = kbtr_supermarket_site and
               knbsm_supermarket_id = kbtr_supermarket_id
      no-lock:
         if knbsm_inv_loc_type = {&KB-SUPERMARKETTYPE-RIP}
         or kbtr_source_type = {&KB-SOURCETYPE-PROCESS}
         then useWIPAcct = yes.
      end.  /* for first kbtr_hist */

   end.  /* if kbtransnbr <> 0  */

END PROCEDURE.  /*  checkForKanbanWIPSupermarket */
