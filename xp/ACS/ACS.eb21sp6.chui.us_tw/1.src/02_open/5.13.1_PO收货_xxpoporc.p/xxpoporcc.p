/* poporcc.p - PURCHASE ORDER RECEIPT CREATE TR-HIST                          */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 6.0      LAST MODIFIED: 10/27/90   BY: pml *D146*                */
/* REVISION: 6.0      LAST MODIFIED: 03/18/91   BY: WUG *D472*                */
/* REVISION: 6.0      LAST MODIFIED: 04/11/91   BY: RAM *D518*                */
/* REVISION: 6.0      LAST MODIFIED: 05/08/91   BY: MLV *D622*                */
/* REVISION: 6.0      LAST MODIFIED: 07/16/91   BY: RAM *D777*                */
/* REVISION: 6.0      LAST MODIFIED: 11/11/91   BY: WUG *D887*                */
/* REVISION: 7.0      LAST MODIFIED: 11/19/91   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 01/31/92   BY: RAM *F126*                */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*                */
/* REVISION: 7.0      LAST MODIFIED: 03/02/92   BY: pma *F085*                */
/* REVISION: 7.0      LAST MODIFIED: 04/14/92   BY: pma *F392*                */
/* REVISION: 7.0      LAST MODIFIED: 07/09/92   BY: pma *F748*                */
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247*                */
/* REVISION: 7.3      LAST MODIFIED: 12/18/92   BY: tjs *G460*                */
/* REVISION: 7.4      LAST MODIFIED: 09/01/93   BY: dpm *H075*                */
/* REVISION: 7.4      LAST MODIFIED: 11/04/93   BY: bcm *H210*                */
/* REVISION: 7.4      LAST MODIFIED: 09/11/94   BY: rmh *GM16*                */
/* REVISION: 7.4      LAST MODIFIED: 09/26/94   BY: bcm *H539*                */
/* REVISION: 7.4      LAST MODIFIED: 10/10/94   BY: cdt *FS26*                */
/* REVISION: 7.4      LAST MODIFIED: 10/29/94   BY: bcm *GN73*                */
/* REVISION: 7.4      LAST MODIFIED: 10/31/94   BY: ame *GN82*                */
/* REVISION: 8.5      LAST MODIFIED: 11/08/94   BY: taf *J038*                */
/* REVISION: 7.4      LAST MODIFIED: 11/17/94   BY: bcm *GO37*                */
/* REVISION: 8.5      LAST MODIFIED: 12/14/94   BY: ktn *J041*                */
/* REVISION: 8.5      LAST MODIFIED: 01/05/95   BY: pma *J040*                */
/* REVISION: 7.4      LAST MODIFIED: 02/16/95   BY: jxz *F0JC*                */
/* REVISION: 8.5      LAST MODIFIED: 03/06/95   BY: dpm *J044*                */
/* REVISION: 8.5      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 8.5      LAST MODIFIED: 07/05/95   BY: sxb *J04D*                */
/* REVISION: 8.5      LAST MODIFIED: 09/09/95   BY: kxn *J07T*                */
/* REVISION: 7.4      LAST MODIFIED: 09/14/95   BY: jzw *H0FX*                */
/* REVISION: 7.4      LAST MODIFIED: 11/02/95   BY: jym *F0TC*                */
/* REVISION: 8.5      LAST MODIFIED: 10/09/95   BY: taf *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 01/16/96   BY: ame *G1K4*                */
/* REVISION: 8.5      LAST MODIFIED: 05/24/96   BY: pmf *H0L8*                */
/* REVISION: 8.5      LAST MODIFIED: 06/05/96   BY: rxm *G1XG*                */
/* REVISION: 8.6      LAST MODIFIED: 09/03/96   BY: jzw *K008*                */
/* REVISION: 8.6      LAST MODIFIED: 10/01/96   BY: *G2GF* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 10/18/96   BY: *K003* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 11/25/96   BY: *K01X* Jeff Wootton       */
/* REVISION: 8.6      LAST MODIFIED: 03/05/97   BY: *H0SW* Robin McCarthy     */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke        */
/* REVISION: 8.6E     LAST MODIFIED: 03/20/98   BY: *J2F0* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 04/01/98   BY: *J2HH* Alllen Licha       */
/* REVISION: 8.6E     LAST MODIFIED: 06/29/98   BY: *L034* Markus Barone      */
/* REVISION: 8.6E     LAST MODIFIED: 07/02/98   BY: *L020* Charles Yen        */
/* REVISION: 8.6E     LAST MODIFIED: 08/19/98   BY: *L06C* Brenda Milton      */
/* REVISION: 8.6E     LAST MODIFIED: 08/18/98   BY: *J2WM* Aruna Patil        */
/* REVISION: 8.6E     LAST MODIFIED: 08/28/98   BY: *J2XY* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 04/16/99   BY: *J2DG* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 05/15/99   BY: *J39K* Sanjeev Assudani   */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* PATTI GAULTNEY     */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Thelma Stronge     */
/* REVISION: 9.1      LAST MODIFIED: 06/08/00   BY: *M0ND* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/04/00   BY: *M0SQ* Santosh Rao        */
/* Revision: 1.34      BY: Rajesh Kini           DATE: 11/07/00   ECO: *J3QF* */
/* Revision: 1.35      BY: Mudit Mehta           DATE: 09/29/00   ECO: *N0W9* */
/* Revision: 1.39      BY: Katie Hilbert         DATE: 04/01/01   ECO: *P002* */
/* Revision: 1.40      BY: Rajaneesh Sarangi     DATE: 04/06/01   ECO: *M13R* */
/* Revision: 1.41      BY: Irine Fernandes       DATE: 10/22/01   ECO: *M1N4* */
/* Revision: 1.42      BY: Rajaneesh Sarangi     DATE: 11/08/01   ECO: *M1PL* */
/* Revision: 1.45      BY: Jean Miller           DATE: 12/10/01   ECO: *P03H* */
/* Revision: 1.46      BY: Saurabh Chaturvedi    DATE: 01/12/02   ECO: *M1T5* */
/* Revision: 1.47      BY: Ellen Borden          DATE: 11/30/01   ECO: *P00G* */
/* Revision: 1.48      BY: Jeff Wootton          DATE: 05/14/02   ECO: *P03G* */
/* Revision: 1.49      BY: Steve Nugent          DATE: 05/24/02   ECO: *P018* */
/* Revision: 1.53      BY: Luke Pokic            DATE: 05/24/02   ECO: *P03Z* */
/* Revision: 1.54      BY: Steve Nugent          DATE: 06/10/02   ECO: *P07Y* */
/* Revision: 1.55      BY: Luke Pokic            DATE: 06/14/02   ECO: *P08L* */
/* Revision: 1.56      BY: Luke Pokic            DATE: 06/19/02   ECO: *P099* */
/* Revision: 1.57      BY: Robin McCarthy        DATE: 07/15/02   ECO: *P0BJ* */
/* Revision: 1.58      BY: Tiziana Giustozzi     DATE: 07/17/02   ECO: *P0BG* */
/* Revision: 1.63      BY: Patrick Rowan         DATE: 08/01/02   ECO: *P0C8* */
/* Revision: 1.64      BY: Tiziana Giustozzi     DATE: 08/06/02   ECO: *P0CW* */
/* Revision: 1.65      BY: Steve Nugent          DATE: 08/10/02   ECO: *P0DT* */
/* Revision: 1.66      BY: Tiziana Giustozzi     DATE: 09/11/02   ECO: *P0DR* */
/* Revision: 1.70      BY: Tiziana Giustozzi     DATE: 11/26/02   ECO: *P0KV* */
/* Revision: 1.72      BY: Pawel Grzybowski      DATE: 03/27/03   ECO: *P0NT* */
/* Revision: 1.73      BY: Gnanasekar            DATE: 05/08/03   ECO: *N2DL* */
/* Revision: 1.74      BY: Orawan Songmoungsuk   DATE: 05/26/03   ECO: *P0RG* */
/* Revision: 1.76      BY: Paul Donnelly (SB)    DATE: 06/28/03   ECO: *Q00J* */
/* Revision: 1.77      BY: Gnanasekar            DATE: 08/01/03   ECO: *N2HX* */
/* Revision: 1.78      BY: Gnanasekar            DATE: 08/04/03   ECO: *N2JL* */
/* Revision: 1.79      BY: Katie Hilbert         DATE: 08/22/03   ECO: *P10H* */
/* Revision: 1.80      BY: Robin McCarthy        DATE: 04/19/04   ECO: *P15V* */
/* Revision: 1.81      BY: Russ Witt             DATE: 06/21/04   ECO: *P1CZ* */
/* Revision: 1.82      BY: Sushant Pradhan       DATE: 07/26/04   ECO: *P2C9* */
/* Revision: 1.83      BY: Salil Pradhan         DATE: 08/03/04   ECO: *P2D3* */
/* Revision: 1.84      BY: Abhishek Jha          DATE: 08/23/04   ECO: *P2DN* */
/* Revision: 1.85      BY: Shoma Salgaonkar      DATE: 08/25/04   ECO: *Q0CJ* */
/* Revision: 1.86      BY: Swati Sharma          DATE: 09/30/04   ECO: *P2M1* */
/* Revision: 1.86.2.1  BY: Anitha Gopal          DATE: 07/07/05   ECO: *P3RL* */
/* Revision: 1.86.2.2  BY: Steve Nugent          DATE: 08/11/05   ECO: *P2PJ* */
/* Revision: 1.86.2.3  BY: Antony LejoS          DATE: 03/28/07   ECO: *P5RZ* */
/* Revision: 1.86.2.4  BY: Anuradha K.           DATE: 04/23/07   ECO: *P5TX* */
/* $Revision: 1.86.2.5 $  BY: Ruma Bibra            DATE: 07/24/07   ECO: *P62N* */
/* REVISION: eB2.1 SP6   BY: Apple Tam    DATE: 09/04/10 ECO: *SS-20100904.1* */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{cxcustom.i "POPORCC.P"}
{porcdef.i}
{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */
{pxmaint.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define input parameter shipnbr         like tr_ship_id      no-undo.
define input parameter ship_date       like tr_ship_date    no-undo.
define input parameter inv_mov         like tr_ship_inv_mov no-undo.
define input parameter ip_consign_flag like mfc_logical     no-undo.
define input parameter ip_is_usage     like mfc_logical     no-undo.
define input parameter ip_usage_qty    as decimal           no-undo.
define input parameter ip_rmks         like tr_rmks         no-undo.
define output parameter invntry-trnbr  like tr_trnbr        no-undo.

/* NEW SHARED VARIABLES, BUFFERS AND FRAMES */
define new shared variable podnbr      like pod_nbr.
define new shared variable podpart     like pod_part.
define new shared variable podtype     like pod_type.
define new shared variable same-ref    like mfc_logical.
define new shared variable tr_recno    as recid.
define new shared variable podline     like pod_line.
define new shared variable amount      like spt_cst_tl.

/* SHARED VARIABLES, BUFFERS AND FRAMES */
define     shared variable accum_taxamt like tx2d_tottax no-undo.
define     shared variable cr_acct     like trgl_cr_acct extent 6.
define     shared variable cr_sub      like trgl_cr_sub extent 6.
define     shared variable cr_cc       like trgl_cr_cc extent 6.
define     shared variable cr_proj     like trgl_cr_proj extent 6.
define     shared variable dr_acct     like trgl_dr_acct extent 6.
define     shared variable dr_sub      like trgl_dr_sub extent 6.
define     shared variable dr_cc       like trgl_dr_cc extent 6.
define     shared variable dr_proj     like trgl_dr_proj extent 6.
define     shared variable entity      like si_entity extent 6.
define     shared variable gl_amt      like trgl_gl_amt extent 6.
define     shared variable glx_mthd    like cs_method.
define     shared variable last_sr_wkfl as logical no-undo.
define     shared variable lotser      like sod_serial.
define     shared variable srvendlot   like tr_vend_lot no-undo.
define     shared variable msg-num     like tr_msg.
define     shared variable new_db      like si_db.
define     shared variable new_site    like si_site.
define     shared variable old_db      like si_db.
define     shared variable old_site    like si_site.
define     shared variable receivernbr like prh_receiver.
define     shared variable price       like tr_price.
define     shared variable rct_site    like pod_site.
define     shared variable qty_oh      like in_qty_oh.
define     shared variable sct_recno   as recid.
define     shared variable totl_qty_this_rcpt like pod_qty_chg no-undo.
define     shared variable trqty       like tr_qty_chg.
define     shared variable vr_amt      like glt_amt.
define     shared variable vr_acct     like pod_acct.
define     shared variable vr_sub      like pod_sub.
define     shared variable vr_cc       like pod_cc.
define     shared variable vr_proj     like vod_project.
define     shared variable wr_recno    as recid.
/* KANBAN TRANSACTION NUMBER, SHARED FROM poporcm.p AND kbporcm.p */
define     shared variable kbtransnbr      as integer no-undo.
define     shared variable la-trans-nbr    as integer no-undo.
define     shared variable pod_entity      like si_entity.
define     shared variable pod_po_entity   like si_entity.
define     shared variable poddb           like pod_po_db.
define     shared variable podpodb         like pod_po_db.

/* LOCAL VARIABLES, BUFFERS AND FRAMES */
define variable assay          like tr_assay    no-undo.
define variable expire         like tr_expire   no-undo.
define variable glcost         like sct_cst_tot no-undo.
define variable grade          like tr_grade    no-undo.
define variable i              as integer       no-undo.
define variable icx_acct       like wo_acct     no-undo.
define variable icx_sub        like wo_sub      no-undo.
define variable icx_cc         like wo_cc       no-undo.
define variable rct_cr_acct    like wo_acct     no-undo.
define variable rct_cr_sub     like wo_sub      no-undo.
define variable rct_cr_cc      like wo_cc       no-undo.
define variable tax_recov      like tx2d_tottax no-undo.
define variable to_entity      like en_entity   no-undo.
define variable trans-ok       like mfc_logical no-undo.
define variable ponbr          like pod_nbr     no-undo.
define variable poline         like pod_line    no-undo.
define variable gl_tmp_amt     as decimal       no-undo.
define variable mc-error-number like msg_nbr    no-undo.
define variable tmp-price       like tr_price   no-undo.
define variable l_glxcst        like glxcst     no-undo.
define variable iss_trnbr       like tr_trnbr   no-undo.
define variable rct_trnbr       like tr_trnbr   no-undo.

define variable l_inv_acct     like trgl_dr_acct no-undo.
define variable l_inv_sub      like trgl_dr_sub  no-undo.
define variable l_inv_cc       like trgl_dr_cc   no-undo.
define variable l_wip_acct     like trgl_cr_acct no-undo.
define variable l_wip_sub      like trgl_cr_sub  no-undo.
define variable l_wip_cc       like trgl_cr_cc   no-undo.
define variable l_wvar_acct    like trgl_cr_acct no-undo.
define variable l_wvar_sub     like trgl_cr_sub  no-undo.
define variable l_wvar_cc      like trgl_cr_cc   no-undo.
define variable l_proj         like trgl_cr_proj no-undo.
define variable rndmthd        like rnd_rnd_mthd no-undo.
define variable l_gl_amt       like trgl_gl_amt  no-undo.
define variable l_ord_nbr      like tr_nbr       no-undo.
define variable l_offset_acct  like trgl_dr_acct no-undo.
define variable l_offset_sub   like trgl_dr_sub  no-undo.
define variable l_offset_cc    like trgl_dr_cc   no-undo.

/* LOGISTICS ACCOUNTING VARIABLES */
define variable use-log-acctg  as logical       no-undo.
define variable la-acct        as character     no-undo.
define variable la-sub         as character     no-undo.
define variable la-cc          as character     no-undo.
define variable account-type   as character     no-undo.
define variable ico-acct       as character     no-undo.
define variable ico-sub        as character     no-undo.
define variable ico-cc         as character     no-undo.
define variable podsite        like pod_site    no-undo.
define variable charge         like lc_charge   no-undo.
define variable povend         like po_vend     no-undo.
define variable type-po        as character format "x(2)" no-undo.
define variable prod-line      as character     no-undo.
define variable supp-type      as character     no-undo.

/*SS-20100904 add***********/
define shared variable recgp         as character.
/*SS-20100904 end *********/

define variable l_prh_site like pod_site no-undo.

{&POPORCC-P-TAG5}

/* CONSIGNMENT VARIABLES */
define variable io_usage_tax_point like mfc_logical no-undo.
define variable consignment        like mfc_logical no-undo.

{pocnvars.i}

define workfile taxdetail
   field taxacct   like gl_ap_acct
   field taxsub    like gl_ap_sub
   field taxcc     like gl_ap_cc
   field taxamt    like tx2d_tottax.

/*WORKFILE FOR POD RECEIPT ATTRIBUTES*/
define shared workfile attr_wkfl no-undo
   field chg_line   like sr_lineid
   field chg_assay  like tr_assay
   field chg_grade  like tr_grade
   field chg_expire like tr_expire
   field chg_status like tr_status
   field assay_actv as logical
   field grade_actv as logical
   field expire_actv as logical
   field status_actv as logical.

{&POPORCC-P-TAG1}

/* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

/* CHECK TO SEE IF CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}

for first po_mstr
fields (po_domain po_curr po_fsm_type po_is_btb po_nbr po_so_nbr po_vend)
   where recid(po_mstr) = po_recno
no-lock:
end.

for first pod_det
fields (pod_domain pod_bo_chg pod_fsm_type pod_line pod_loc pod_nbr pod_part
        pod_per_date pod_po_db pod_qty_ord pod_qty_rcvd
        pod_qty_rtnd pod_rev pod_sod_line pod_so_job
        pod_type pod_um_conv pod_project pod_site)
   where recid(pod_det) = pod_recno
no-lock:
end.

for first pt_mstr
fields (pt_domain pt_abc pt_avg_int pt_cyc_int pt_loc pt_part pt_prod_line
        pt_rctpo_active pt_rctpo_status pt_rctwo_active
        pt_rctwo_status pt_shelflife pt_um pt_pm_code)
   where recid(pt_mstr) = pt_recno
no-lock:
end.

for first wr_route
   where recid(wr_route) = wr_recno
no-lock:
end.

for first sct_det
fields (sct_domain sct_bdn_ll sct_bdn_tl sct_lbr_ll sct_lbr_tl sct_mtl_ll
        sct_mtl_tl sct_ovh_ll sct_ovh_tl sct_part sct_sim
        sct_site sct_sub_ll sct_sub_tl)
   where recid(sct_det) = sct_recno
no-lock: end.

if kbtransnbr <> 0 then do:
   for first kbtr_hist
      fields(kbtr_id kbtr_trans_nbr)
      where kbtr_domain = global_domain
      and kbtr_trans_nbr = kbtransnbr
   no-lock:
   end.
end.  /* if kbtransnbr <> 0 then do */

for first gl_ctrl
fields (gl_domain gl_rnd_mthd gl_inv_acct gl_inv_cc gl_inv_sub)
   where gl_domain = global_domain
no-lock: end.

for first icc_ctrl
fields (icc_domain icc_cogs icc_gl_set icc_gl_sum icc_gl_tran icc_mirror)
   where icc_domain = global_domain
no-lock: end.

for first clc_ctrl
fields (clc_domain clc_lotlevel)
  where clc_domain = global_domain
no-lock: end.

if not available clc_ctrl then do:
   {gprun.i ""gpclccrt.p""}
   find first clc_ctrl where clc_domain = global_domain no-lock.
end.
if available icc_ctrl then
   same-ref = icc_gl_sum.

/* PONBR AND POLINE NOW ASSIGNED WITH POD_NBR AND POD_LINE        */
/* IRRESPECTIVE OF TYPE OF PURCHASE ORDER                         */
assign
   ponbr  = pod_nbr
   poline = pod_line.

if using_supplier_consignment and ip_consign_flag and
   ip_is_usage = no
then
   assign
      ip_rmks = getTermLabel("CONSIGNED",10)
      consignment = yes
      transtype = "CN-RCT".
else if using_supplier_consignment and ip_is_usage then
   assign
      consignment = no
      transtype = "RCT-PO".
else do:
   assign
      ip_rmks = ""
      consignment = no.
   if available kbtr_hist then ip_rmks = string(kbtr_id).

   /* Need to reset transtype to its default value after a PO consigned */
   /* line has been processed and before a non-consigned PO line is.    */
   /* Otherwise the non-consigned line will have a transtype of CN-RCT. */
   /* Transtype defaults to RCT-PO for a receipt - poporcm.p & rsporc.p */
   /* Transtype defaults to ISS-PRV for returns - porvism.p             */
   if transtype = "CN-RCT" then do:
      i = 1.

      do while program-name(i) <> ?:
         if index(program-name(i),"poporcm.") > 0
            or index(program-name(i),"rsporc.") > 0
         then do:
            transtype = "RCT-PO".
            leave.
         end.
         if index(program-name(i),"porvism.") > 0
         then do:
            transtype = "ISS-PRV".
            leave.
         end.

         i = i + 1.
      end.
   end.
end.

/* Only RTS's that are issuing inventory should create a */
/* PO receipt tr_hist.                                   */
if pod_fsm_type = "RTS-ISS" or
   pod_fsm_type = "RTS-RCT"
then do:

   for first rmd_det
      fields (rmd_domain rmd_iss rmd_line rmd_nbr rmd_prefix)
      where   rmd_domain  = global_domain
      and     rmd_nbr     = pod_nbr
      and     rmd_prefix  = "V"
      and     rmd_line    = pod_line
   no-lock: end.

end.

if available pt_mstr then do:

   for first ld_det
      fields (ld_domain ld_assay ld_expire ld_grade ld_loc ld_lot ld_part
              ld_qty_all ld_qty_frz ld_qty_oh ld_ref ld_site ld_status)
      where   ld_domain = global_domain
      and     ld_site   = site
      and     ld_loc    = location
      and     ld_part   = pt_part
      and     ld_lot    = lotser
      and     ld_ref    = lotref
   no-lock: end.

   if available ld_det then
      assign
         assay  = ld_assay
         grade  = ld_grade
         expire = ld_expire.
end.

{&POPORCC-P-TAG6}
ref = "".

if (clc_lotlevel <> 0) and (lotser <> "") and (pod_type = "") then do:

   {gprun.i ""gpiclt.p""
            "(input pod_part,
              input lotser,
              input ponbr,
              input string(poline),
              output trans-ok )"}

   if not trans-ok then do:
      /* CURRENT TRANSACTION REJECTED- CONTINUE WITH NEXT TRANSACTION */
      {pxmsg.i &MSGNUM=2740 &ERRORLEVEL=4}
      undo, leave.
   end. /* IF NOT TRANS-OK THEN DO: */

end. /* IF CLC_LOTLEV <> 0 ... */

{&POPORCC-P-TAG4}
/*PRESET TMP-PRICE VALUE FOR THE FOLLOWING INCLUDE FILE*/
if po_curr = base_curr  or
   ip_is_usage
then
   tmp-price = price.
else do:
   tmp-price = price.
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input po_curr,
       input base_curr,
       input exch_rate,
       input exch_rate2,
       input tmp-price,
       input false, /* DO NOT ROUND */
       output tmp-price,
       output mc-error-number)"}
end.

/*SS-20100904* {ictrans.i*/
/*SS-20100904*/ {xxictrans.i
   &addrid=po_vend
   &bdnstd=0
   &cracct=cr_acct[1]
   &crsub=cr_sub[1]
   &crcc=cr_cc[1]
   &crproj=cr_proj[1]
   &curr=po_curr
   &dracct=dr_acct[1]
   &drsub=dr_sub[1]
   &drcc=dr_cc[1]
   &drproj=dr_proj[1]
   &effdate=eff_date
   &exrate=exch_rate
   &exrate2=exch_rate2
   &exratetype=exch_ratetype
   &exruseq=exch_exru_seq
   &glamt=0
   &kbtrans=kbtransnbr
   &lbrstd=0
   &line=pod_line
   &location="(if pod_type = ""M"" then pod_loc else
               if rct_site <> site
               then pod_loc else location)"
   &lotnumber=receivernbr
   &lotref=lotref
   &lotserial=lotser
   &mtlstd=0
   &ordernbr=pod_nbr
   &ovhstd=0
   &part=pod_part
   &perfdate=pod_per_date
   &price=tmp-price
   &quantityreq="if is-return then
                 ((pod_qty_rcvd - pod_qty_rtnd) * pod_um_conv) else if
                  (using_supplier_consignment and ip_consign_flag
                                              and ip_is_usage)
                   then (ip_usage_qty)
                   else ((pod_qty_ord - pod_qty_rcvd) * pod_um_conv)"
   &quantityshort="if is-return then 0 else (pod_bo_chg * pod_um_conv)"
   &quantity="if using_supplier_consignment and ip_consign_flag
                                            and ip_is_usage
                   then ip_usage_qty
                   else trqty"
   &revision=pod_rev
   &rmks=ip_rmks
   &shiptype=pod_type
   &shipnbr=shipnbr
   &shipdate=ship_date
   &invmov=inv_mov
   &site=rct_site
   &slspsn1=""""
   &slspsn2=""""
   &sojob=pod_so_job
   &substd=0
   &transtype=transtype
   &msg="if is-return then 0 else msg-num"
   &ref_site=tr_site}

   /* STORING RECID(tr_hist) IN tr_recno BEFORE CALL TO porcat03.p */
   assign
      tr_vend_lot   = srvendlot
      invntry-trnbr = tr_trnbr
      tr_recno      = recid(tr_hist).

   if pod_type = ""
   then do:

      for first attr_wkfl
         where chg_line = string(pod_line)
      no-lock:

         /* UPDATE INVENTORY ATTRIBUTES IN tr_hist AND ld_det FOR RCT-PO */
         {gprun.i ""porcat03.p""
                  "(input        tr_recno,
                    input        tr_recno,
                    input        pod_part,
                    input        eff_date,
                    input-output chg_assay,
                    input-output chg_grade,
                    input-output chg_expire,
                    input-output chg_status,
                    input        assay_actv,
                    input        grade_actv,
                    input        expire_actv,
                    input        status_actv)"}

         if assay_actv
         then
            assay = chg_assay.

         if grade_actv
         then
            grade = chg_grade.

         if expire_actv
         then
            expire = chg_expire.

      end. /* FOR FIRST attr_wkfl */
   end. /* IF pod_type = "" */

/* CALCULATING MATERIAL COST FOR ATO/KIT ITEMS FOR AN EMT PO */
/* TO REFLECT ENTIRE CONFIGURATION COST                      */
if po_is_btb and
   can-find (first pt_mstr where pt_domain  = global_domain and
                                 pt_part    = pod_part      and
                                 pt_pm_code = "c")
then do:
   run p-price-configuration.
   tr_mtl_std = tr_mtl_std + l_glxcst.
end. /* IF PO_IS_BTB AND ... */

assign
   tr_vend_lot = srvendlot
   invntry-trnbr = tr_trnbr
   tr_recno = recid(tr_hist).

/* IF CONSIGNMENT IS BEING USED THEN CREATE A CONSIGNMENT */
/* CROSS-REFERENCE RECORD FOR THE RECEIPT.                */
l_prh_site = site.
if using_supplier_consignment and consignment then do:
   {gprunmo.i &module = "ACN" &program = ""pocnix01.p""
              &param  = """(input pod_nbr,
                            input pod_line,
                            input eff_date,
                            input receivernbr,
                            input rct_site,
                            input trqty,
                            input trqty,
                            input price,
                            input tr_trnbr,
                            input location,
                            input lotser,
                            input lotref,
                            input is-return,
                            input l_prh_site)"""}
end.

/* ld_det SHOULD NOT BE DELETED WHEN SUPPLIER */
/* CONSIGNMENT FUNCTIONALITY IS ACTIVE AND    */
/* SUPPLIER CONSIGNED QUANTITY IS NOT ZERO    */
for first cns_ctrl
   fields (cns_domain cns_active)
   where cns_domain = global_domain
no-lock:
end. /* FOR FIRST cns_ctrl */
if available cns_ctrl
then do :
   for first loc_mstr
      where loc_mstr.loc_domain = global_domain
      and   loc_site = rct_site
      and   loc_loc = (if      pod_type = "M"
                          then pod_loc
                       else if rct_site <> site
                          then pod_loc
                       else location)
   no-lock:
   end. /*FOR FIRST loc_mstr*/

   if available loc_mstr
      and available ld_det
      and loc_perm             = no
      and cns_active           = yes
      and ld_qty_oh            = 0
      and ld_qty_all           = 0
      and ld_qty_frz           = 0
      and ld_supp_consign_qty  = 0
   then
      delete ld_det.
end. /* IF AVAILABLE cns_ctrl */

/* IF THE INTRASTAT BOLT-ON IS INSTALLED, CREATE AN
 * IMPORT/EXPORT HISTORY RECORD (ieh_hist) FOR THE tr_hist
 * RECORD (IF NECESSARY).
 */

/* FIND IMPORT EXPORT CONTROL FILE */
for first iec_ctrl
fields (iec_domain iec_use_instat)
   where iec_domain = global_domain
no-lock: end.

/* CREATE THE INTRASTAT HISTORY RECORD DURING THE NORMAL RECEIPT AND */
/* THE CONSIGNED RECEIPT.  WHEN poporcc.p IS CALLED DURING CONSIGNED */
/* USAGE, THEN SKIP THIS STEP THAT CREATES THE INTRASTAT HISTORY.    */
if ip_is_usage = no then
   if available iec_ctrl and iec_use_instat then do:
      if available tr_hist then do:
         {gprun.i ""iehistpo.p"" "(input tr_recno)"}
      end.
   end.

/* WHEN COSTING METHOD IS AVERAGE, THE TRANSACTION TYPE */
/* OF THE FIRST GL TRANSACTION WILL ALWAYS BE 'RCT-AVG' */
if available trgl_det
then do:
   if pod_type = ""
      and glx_mthd = "AVG"
   then
      trgl_type = (if using_supplier_consignment
                      and ip_consign_flag
                      and ip_is_usage = no
                   then
                      transtype
                   else
                      "RCT-AVG").
end. /* IF AVAILABLE trgl_det */

do i = 1 to 6:
   if gl_amt[i] <> 0 then do:

      if i = 6 and pod_po_db <> global_db then do:
         assign
            podnbr = pod_nbr
            podpart = pod_part
            podtype = pod_type
            old_db = global_db
            new_db = pod_po_db.

         {gprun.i ""gpaliasd.p""}
         {gprun.i ""poporcc1.p""}
         new_db = old_db.
         {gprun.i ""gpaliasd.p""}
      end.

      else do:

         if i <> 1 then do:
            create trgl_det.
            trgl_domain   = global_domain.
            assign
               trgl_trnbr    = tr_trnbr
               trgl_sequence = recid(trgl_det)
               trgl_dr_acct  = dr_acct[i]
               trgl_dr_sub   = dr_sub[i]
               trgl_dr_cc    = dr_cc[i]
               trgl_dr_proj  = dr_proj[i]
               trgl_cr_acct  = cr_acct[i]
               trgl_cr_sub   = cr_sub[i]
               trgl_cr_cc    = cr_cc[i]
               trgl_cr_proj  = cr_proj[i].
            if recid(trgl_det) = -1 then .
         end.

         if available trgl_det then do:
            trgl_gl_amt  = gl_amt[i].
            if     pod_type = ""
               and glx_mthd = "AVG"
               and (   i = 1
                    or i = 2)
            then
               trgl_type = (if using_supplier_consignment and
                            ip_consign_flag and ip_is_usage = no
                             then  transtype
                             else "RCT-AVG").
            else
               trgl_type = transtype.
         end.

         {mficgl02.i
            &gl-amount=gl_amt[i]
            &tran-type=trgl_type
            &order-no=pod_nbr
            &dr-acct=trgl_dr_acct
            &dr-sub=trgl_dr_sub
            &dr-cc=trgl_dr_cc
            &drproj=trgl_dr_proj
            &cr-acct=trgl_cr_acct
            &cr-sub=trgl_cr_sub
            &cr-cc=trgl_cr_cc
            &crproj=trgl_cr_proj
            &entity=entity[i]
            &find="false"
            &same-ref="same-ref"}

      end.

   end.

end.

/* CREATE RCT-CNFG AND RCT-WOVAR TRANSACTIONS */
/* ONLY FOR AN EMT PO CREATED WITH A KIT ITEM */
if po_is_btb
   and can-find (first pt_mstr
                 where pt_domain  = global_domain
                 and   pt_part    = pod_part
                 and   pt_pm_code = "c")
   and can-find (first sod_det
                 where sod_domain = global_domain
                 and sod_nbr      = po_so_nbr
                 and sod_line     = pod_sod_line
                 and sod_cfg_type = "2"
                 and sod_part     = pod_part
                 and sod_fa_nbr   = "")
then do:

   {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
             "(input  po_curr,
               output rndmthd,
               output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
   end. /* IF mc-error-number <> 0 */

   for first si_mstr
      fields (si_domain  si_cur_set si_entity si_gl_set
              si_site    si_status)
      where   si_domain = global_domain
      and      si_site = pod_site
   no-lock: end.

   if available si_mstr then
      pod_entity = si_entity.

   for first pl_mstr
      fields (pl_domain pl_cop_acct  pl_cop_cc  pl_cop_sub
              pl_inv_acct  pl_inv_cc  pl_inv_sub
              pl_ovh_acct  pl_ovh_cc  pl_ovh_sub
              pl_wip_acct  pl_wip_cc  pl_wip_sub
              pl_wvar_acct pl_wvar_cc pl_wvar_sub
              pl_prod_line)
      where   pl_domain = global_domain
      and     pl_prod_line = pt_prod_line
   no-lock: end.

   if available pl_mstr then
      for first pld_det
         fields (pld_domain   pld_inv_acct pld_inv_cc   pld_inv_sub
                 pld_loc      pld_prodline pld_site)
         where   pld_domain    = global_domain
         and     pld_prodline  = pl_prod_line
         and     pld_site      = pod_site
         and     pld_loc       = location
      no-lock: end.

   if not available pld_det then do:
      for first pld_det
         fields (pld_domain   pld_inv_acct pld_inv_cc   pld_inv_sub
                 pld_loc      pld_prodline pld_site)
         where   pld_domain    = global_domain
         and     pld_prodline  = pl_prod_line
         and     pld_site      = pod_site
         and     trim(pld_loc) = ""
      no-lock: end.
   end. /* IF NOT AVAILABLE pld_det */

   if available pld_det then
      assign
         l_inv_acct = pld_inv_acct
         l_inv_sub  = pld_inv_sub
         l_inv_cc   = pld_inv_cc.
   else if available pl_mstr then
      assign
         l_inv_acct = pl_inv_acct
         l_inv_sub  = pl_inv_sub
         l_inv_cc   = pl_inv_cc.
   else
      assign
         l_inv_acct = gl_inv_acct
         l_inv_sub  = gl_inv_sub
         l_inv_cc   = gl_inv_cc.

   /* DETERMINE DEFAULT WIP ACCOUNT */
   {gprun.i ""glactdft.p""
            "(input  ""WO_WIP_ACCT"",
              input  pt_prod_line,
              input  pod_site,
              input  """",
              input  """",
              input  yes,
              output l_wip_acct,
              output l_wip_sub,
              output l_wip_cc)"}

   assign
      l_proj    = pod_project
      l_ord_nbr = pod_nbr + "." + string(pod_line).

   /* l_glxcst GIVES THE ENTIRE CONFIGURATION COST WHICH IS */
   /* CALCULATED IN THE PROCEDURE p-price-configuration     */
   l_gl_amt = l_glxcst * trqty.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
             "(input-output l_gl_amt,
               input        rndmthd,
               output       mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end. /* IF mc-error-number */

   /* CREATE INVENTORY TRANSACTION GENERL LEDGER CROSS-REFERENCE RECORD */
   /* OF TYPE RCT-CNFG BY DEBITING THE WIP ACCOUNT AND CREDITING THE    */
   /* INVENTORY ACCOUNT                                                 */
   create trgl_det.
   trgl_domain   = global_domain.
   assign
      trgl_trnbr    = tr_trnbr
      trgl_type     = "RCT-CNFG"
      trgl_sequence = recid(trgl_det)
      trgl_dr_acct  = l_wip_acct
      trgl_dr_sub   = l_wip_sub
      trgl_dr_cc    = l_wip_cc
      trgl_dr_proj  = l_proj
      trgl_cr_acct  = l_inv_acct
      trgl_cr_sub   = l_inv_sub
      trgl_cr_cc    = l_inv_cc
      trgl_cr_proj  = l_proj
      trgl_gl_amt   = l_gl_amt.

   if recid(trgl_det) = -1 then .

   /* CREATE glt_det RECORD ASSOCIATED WITH THE RCT-CNFG */
   /* RECORD CREATED ABOVE                               */
   {mficgl02.i
      &gl-amount=l_gl_amt
      &tran-type=trgl_type
      &order-no=l_ord_nbr
      &dr-acct=l_wip_acct
      &dr-sub=l_wip_sub
      &dr-cc=l_wip_cc
      &drproj=l_proj
      &cr-acct=l_inv_acct
      &cr-sub=l_inv_sub
      &cr-cc=l_inv_cc
      &crproj=l_proj
      &entity=pod_entity
      &find="false"
      &same-ref="same-ref"}

   /* MATERIAL, LABOR, BURDEN, OVERHEAD AND SUBCONTRACT  */
   /* COSTS ASSOCIATED TO THE KIT PARENT ARE ACCUMULATED */
   /* AND POSTED TO RCT-WOVAR TRANSACTION                */
   if (sct_lbr_tl <> 0
       or sct_bdn_tl <> 0
       or sct_ovh_tl <> 0
       or sct_sub_tl <> 0
       or sct_mtl_tl <> 0)
   then do:
      l_gl_amt = trqty *
                 (sct_lbr_tl
                  + sct_bdn_tl
                  + sct_ovh_tl
                  + sct_sub_tl
                  + sct_mtl_tl).

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
                "(input-output l_gl_amt,
                  input        rndmthd,
                  output       mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end. /* IF mc-error-number <> 0 */

      /* DETERMINE DEFAULT METHOD VARIANCE ACCOUNT */
      {gprun.i ""glactdft.p""
               "(input ""WO_WVAR_ACCT"",
                 input pt_prod_line,
                 input pod_site,
                 input """",
                 input """",
                 input no,
                 output l_wvar_acct,
                 output l_wvar_sub,
                 output l_wvar_cc)"}

      /* CREATE INVENTORY TRANSACTION GENERAL LEDGER CROSS-REFERENCE */
      /* RECORD OF TYPE RCT-WOVAR BY DEBITING THE METHOD VARIANCE    */
      /* ACCOUNT AND CREDITING THE WIP ACCOUNT                       */
      create trgl_det.
      trgl_domain   = global_domain.
      assign
         trgl_trnbr    = tr_trnbr
         trgl_type     = "RCT-WOVAR"
         trgl_sequence = recid(trgl_det)
         trgl_dr_acct  = l_wvar_acct
         trgl_dr_sub   = l_wvar_sub
         trgl_dr_cc    = l_wvar_cc
         trgl_dr_proj  = l_proj
         trgl_cr_acct  = l_wip_acct
         trgl_cr_sub   = l_wip_sub
         trgl_cr_cc    = l_wip_cc
         trgl_cr_proj  = l_proj
         trgl_gl_amt   = l_gl_amt.

      if recid(trgl_det) = -1 then .

      /* CREATE glt_det RECORD ASSOCIATED WITH THE RCT-WOVAR */
      /* RECORD CREATED ABOVE                                */
      {mficgl02.i
         &gl-amount=l_gl_amt
         &tran-type=""WIP-ADJ""
         &order-no=l_ord_nbr
         &dr-acct=l_wvar_acct
         &dr-sub=l_wvar_sub
         &dr-cc=l_wvar_cc
         &drproj=l_proj
         &cr-acct=l_wip_acct
         &cr-sub=l_wip_sub
         &cr-cc=l_wip_cc
         &crproj=l_proj
         &entity=pod_entity
         &find="false"
         &same-ref="same-ref"}
   end. /* IF sct_lbr_tl <> 0 */

end. /* IF po_is_btb */

{&POPORCC-P-TAG7}

/* CREATED A NEW ROUTINE, poporcc2.p, TO BE  */
/* CALLED FROM HERE & VOUCHER MAINTENANCE.   */
/* THIS IS TO SUPPORT SUPPLIER CONSIGNMENT.  */
if using_supplier_consignment
   and ip_consign_flag
   and ip_is_usage
then
   totl_qty_this_rcpt = ip_usage_qty.

{gprun.i ""poporcc2.p""
         "(input receivernbr,
           input po_nbr,
           input pod_line,
           input last_sr_wkfl,
           input accum_taxamt,
           input totl_qty_this_rcpt,
           input dr_proj[1],
           input cr_acct[1],
           input cr_sub[1],
           input cr_cc[1],
           input cr_proj[1],
           input tr_trnbr,
           input trqty,
           input po_curr,
           input entity[1],
           input same-ref,
           input using_supplier_consignment,
           input ip_consign_flag,
           input ip_is_usage)"}

/* CREATE LOGISTICS ACCOUNTING CHARGES */
if use-log-acctg
   and po_tot_terms_code <> ""
   and pod_type = " "
then do:

   if available pt_mstr
   then
      prod-line = pt_prod_line.
   else
      prod-line = "".

   type-po = {&TYPE_PO}.

   for first vd_mstr
      fields (vd_domain vd_type)
      where   vd_domain = global_domain
      and     vd_addr   = po_vend
   no-lock:
      supp-type = vd_type.
   end.

   for each lacd_det
      where lacd_det.lacd_domain = global_domain
      and   lacd_det.lacd_internal_ref_type = {&TYPE_PO}
      and   lacd_det.lacd_internal_ref = po_nbr
   no-lock:

      if is-return then
         account-type = "EXPENSE".
      else
         account-type = "ACCRUAL".

      if using_supplier_consignment
         and ip_consign_flag
         and ip_is_usage
      then do:
         {gprunmo.i &module  = "ACN" &program = ""pocnacct.p""
                    &param   = """(input pod_part,
                                  input pod_site,
                                  input po_vend,
                                  output la-acct,
                                  output la-sub,
                                  output la-cc,
                                  output l_offset_acct,
                                  output l_offset_sub,
                                  output l_offset_cc)"""}
      end. /* IF using_supplier_consignment ... */
      else do:

         /* RETRIEVE ACCRUAL OR EXPENSE ACCOUNT */
         {gprunmo.i &module = "LA" &program = ""laglacct.p""
                    &param  = """(input type-po,
                                   input account-type,
                                   input lacd_lc_charge,
                                   input prod-line,
                                   input pod_site,
                                   input supp-type,
                                   input '',
                                   output la-acct,
                                   output la-sub,
                                   output la-cc)"""}
      end. /* ELSE DO */

      for first in_mstr
         fields (in_domain in_part in_site in_gl_set in_gl_cost_site)
         where   in_domain = global_domain
         and     in_part = pod_part
         and     in_site = pod_site
      no-lock: end.

      if not available in_mstr then
         next.

      for first sc_mstr
         where sc_domain = global_domain
         and  (sc_sim = (if in_gl_set <> "" then in_gl_set else icc_gl_set)
         and   sc_element = lacd_element
         and  (sc_category = "1" or sc_category = "4") )
      no-lock: end.

      if not available sc_mstr then
         next.

      for first spt_det
         fields (spt_domain spt_cst_tl)
         where   spt_domain = global_domain
         and     spt_site   = in_gl_cost_site
         and     spt_sim    = sc_sim
         and     spt_part   = pod_part
         and     spt_element = lacd_element
         no-lock: end.

      if not available spt_det then
         next.

      if trqty * spt_cst_tl <> 0 then do:

         create trgl_det.
         trgl_domain   = global_domain.
         assign
            trgl_trnbr    = tr_trnbr
            trgl_sequence = recid(trgl_det)
            trgl_dr_acct  = dr_acct[1]
            trgl_dr_sub   = dr_sub[1]
            trgl_dr_cc    = dr_cc[1]
            trgl_dr_proj  = dr_proj[1]
            trgl_cr_acct  = la-acct
            trgl_cr_sub   = la-sub
            trgl_cr_cc    = la-cc.
            trgl_cr_proj  = pod_project.

         if available spt_det then do:
            trgl_gl_amt = trqty * spt_cst_tl.

            /* ROUND PER BASE CURRENCY ROUND METHOD */
            {gprunp.i "mcpl" "p" "mc-curr-rnd"
                      "(input-output trgl_gl_amt,
                        input gl_rnd_mthd,
                        output mc-error-number)"}
         end.

         trgl_type = transtype.
         recno = recid(trgl_det).

         {mficgl02.i
            &gl-amount=trgl_gl_amt
            &tran-type=trgl_type
            &order-no=pod_nbr
            &dr-acct=dr_acct[1]
            &dr-sub=dr_sub[1]
            &dr-cc=dr_cc[1]
            &drproj=trgl_dr_proj
            &cr-acct=la-acct
            &cr-sub=la-sub
            &cr-cc=la-cc
            &crproj=trgl_cr_proj
            &entity=entity[1]
            &find="false"
            &same-ref="same-ref"}

         la-trans-nbr = tr_trnbr.

         if pod_entity <> pod_po_entity
            or poddb <> podpodb
         then do:

            /* RETRIEVE INTER-COMPANY ACCOUNT IN INVENTORY DATABASE*/
            {gprunmo.i &module  = "LA" &program = ""laglacct.p""
                       &param = """(input type-po,
                                    input 'ICO-CR',
                                    input pod_po_entity,
                                    input '',
                                    input '',
                                    input '',
                                    input '',
                                    output ico-acct,
                                    output ico-sub,
                                    output ico-cc)"""}

            create trgl_det.
            trgl_domain   = global_domain.
            assign
               trgl_trnbr    = tr_trnbr
               trgl_sequence = recid(trgl_det)
               trgl_dr_acct  = la-acct
               trgl_dr_sub   = la-sub
               trgl_dr_cc    = la-cc
               trgl_dr_proj  = dr_proj[6]
               trgl_cr_acct  = ico-acct
               trgl_cr_sub   = ico-sub
               trgl_cr_cc    = ico-cc.
               trgl_cr_proj  = pod_project.

            if available spt_det then do:
               trgl_gl_amt = trqty * spt_cst_tl.

               /* ROUND PER BASE CURRENCY ROUND METHOD */
               {gprunp.i "mcpl" "p" "mc-curr-rnd"
                         "(input-output trgl_gl_amt,
                           input gl_rnd_mthd,
                           output mc-error-number)"}
            end.

            assign
               trgl_type = transtype
               recno = recid(trgl_det).

            /* CREATE trgl_det AND glt_det IN INVENTORY DB FOR */
            /* INTERCOMPANY TRANSACTION */
            {mficgl02.i
               &gl-amount=trgl_gl_amt
               &tran-type=transtype
               &order-no=podnbr
               &dr-acct=la-acct
               &dr-sub=la-sub
               &dr-cc=la-cc
               &drproj=trgl_dr_proj
               &cr-acct=ico-acct
               &cr-sub=ico-sub
               &cr-cc=ico-cc
               &crproj=trgl_cr_proj
               &entity=pod_po_entity
               &find="false"
               &same-ref="same-ref"}

            assign
               amount  = trgl_gl_amt
               old_db  = global_db
               new_db  = pod_po_db
               charge  = lacd_lc_charge
               podsite = pod_site.

            if poddb <> podpodb then do:

               /* SWITCH TO THE ORDER DATABASE */
               {gprun.i ""gpaliasd.p""}

               /* RETRIEVE INTER-COMPANY ACCOUNT IN ORDER DATABASE*/
               {gprunmo.i &module = "LA" &program = ""laglacct.p""
                          &param  = """(input type-po,
                                        input 'ICO-DR',
                                        input pod_entity,
                                        input '',
                                        input '',
                                        input '',
                                        input '',
                                        output ico-acct,
                                        output ico-sub,
                                        output ico-cc)"""}

               /* RETRIEVE ACCRUAL OR EXPENSE ACCOUNT IN ORDER DATABASE*/
               {gprunmo.i &module = "LA" &program = ""laglacct.p""
                          &param  = """(input type-po,
                                        input account-type,
                                        input charge,
                                        input prod-line,
                                        input podsite,
                                        input supp-type,
                                        input '',
                                        output la-acct,
                                        output la-sub,
                                        output la-cc)"""}

               /* CREATE glt_det RECORDS IN ORDER DB FOR INTERCOMPANY */
               /* TRANSACTION */
               {gprunmo.i &module = "LA" &program =  ""laporcc.p""
                          &param  = """(input la-acct,
                                        input la-sub,
                                        input la-cc,
                                        input ico-acct,
                                        input ico-sub,
                                        input ico-cc,
                                        input transtype)"""}

               new_db = old_db.
               {gprun.i ""gpaliasd.p""}

            end. /* if pod_po_db <> global_db */

         end. /* if pod_po_db <> global_db */

      end. /* if trqty * spt_cst_tl <> 0 */

   end. /* for each lacd_det */

end. /* if use-log-acctg */

/*TRANSFER INVENTORY ITEMS FROM THE POD SITE TO THE INPUT SITE*/
/*NOTE: AS OF 7.4 I DON'T THINK THAT HIS CAN HAPPEN - PMA     */
if pod_type = ""
   and site <> rct_site
then do:

   assign
      global_part = pod_part
      global_addr = po_vend.

   /* SINCE THE PROGRAM ICXFER.P DOES NOT ACCEPT THE PO LINE      */
   /* NUMBER AS A PARAMETER, THE TR_HIST FOR THE ISS-TR AND       */
   /* RCT-TR TRANSACTIONS GET CREATED WITH TR_LINE AS 0. THIS     */
   /* CAUSES PROBLEMS WHILE PRINTING PO RECEIVER SINCE THE        */
   /* LOT-SERIAL/LOCATION DETAILS ARE OBTAINED FROM THE TR_HIST   */
   /* HENCE ICXFER1.P HAS BEEN CREATED WHICH IS A CLONE OF        */
   /* ICXFER.P ACCEPTING THE POD_LINE ALSO AS INPUT. THE PO       */
   /* RECEIPT FUNCTIONS WILL USE ICXFER1.P INSTEAD OF ICXFER.P TO */
   /* CREATE ISS-TR AND RCT-TR TRANSACTIONS. OTHER PROGRAMS       */
   /* WILL CONTINUE TO USE ICXFER.P                               */
   if trqty >= 0
      and right-trim(po_fsm_type) = ""
   then do:

      {&POPORCC-P-TAG2}

      {gprun.i ""icxfer1.p""
               "(input receivernbr,
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
                 input pod_loc,
                 input site,
                 input location,
                 input no,
                 input """",
                 input ?,
                 input """",
                 input kbtransnbr,
                 output glcost,
                 input-output assay,
                 input-output grade,
                 input-output expire)"}

      {&POPORCC-P-TAG3}
   end. /* IF trqty >= 0 AND RIGHT-TRIM(po_fsm_type) = ""  */
   else
   if right-trim(po_fsm_type) <> ""
   then do:
      {gprun.i ""icxfer.p""
               "(input receivernbr,
                 input lotser,
                 input lotref,
                 input lotref,
                 input trqty,
                 input pod_nbr,
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
                 input srvendlot,
                 output glcost,
                 output iss_trnbr,
                 output rct_trnbr,
                 input-output assay,
                 input-output grade,
                 input-output expire)"}
   end. /* IF RIGHT-TRIM(po_fsm_type> <>  ""  */

   for first tr_hist
      fields (tr_domain tr_addr tr_assay tr_bdn_std tr_begin_qoh tr_curr tr_date
              tr_effdate tr_expire tr_exru_seq tr_ex_rate tr_ex_rate2
              tr_effdate tr_expire tr_exru_seq tr_ex_rate tr_ex_rate2
              tr_ex_ratetype tr_gl_amt tr_grade tr_last_date
              tr_lbr_std tr_line tr_loc tr_loc_begin tr_lot
              tr_msg tr_mtl_std tr_nbr tr_ovh_std tr_part tr_per_date
              tr_price tr_prod_line tr_program tr_qty_chg tr_qty_loc
              tr_qty_req tr_qty_short tr_ref tr_ref_site tr_rev
              tr_rmks tr_serial tr_ship_date tr_ship_id
              tr_ship_inv_mov tr_ship_type tr_site tr_slspsn tr_so_job
              tr_status tr_sub_std tr_time tr_trnbr tr_type tr_um
              tr_userid tr_vend_lot)
      where   tr_domain = global_domain
      and     tr_trnbr  = trmsg
   no-lock: end.

end. /* IF POD_TYPE = "" AND SITE <> RCT_SITE */

/*CHANGE ATTRIBUTES*/
if available tr_hist then do:

   find first attr_wkfl where chg_line = string(pod_line) no-error.

   if available attr_wkfl
      and pod_type = ""
   then do:
      {gprun.i ""porcat03.p""
               "(input recid(tr_hist),
                 input tr_recno,
                 input pod_part,
                 input eff_date,
                 input-output chg_assay,
                 input-output chg_grade,
                 input-output chg_expire,
                 input-output chg_status,
                 input assay_actv,
                 input grade_actv,
                 input expire_actv,
                 input status_actv)"}
   end.

end.

PROCEDURE p-price-configuration:
/* OBTAIN COST OF COMPONENT ITEMS FOR AN EMT PO */
   define variable l_qty_req like sob_qty_req no-undo.

   l_glxcst = 0.

   for first sod_det
      fields (sod_domain sod_line sod_nbr sod_qty_ord)
      where   sod_domain = global_domain
      and     sod_nbr    = po_mstr.po_so_nbr
      and     sod_line   = pod_det.pod_sod_line
   no-lock:

      for each sob_det
         fields (sob_domain sob_line sob_nbr sob_part sob_qty_req sob_serial
                 sob_site)
         where   sob_domain = global_domain
         and     sob_nbr    = sod_nbr
         and     sob_line   = sod_line
      no-lock break by sob_part:

         if first-of(sob_part) then
            l_qty_req = 0.

         if substring(sob_serial,15,1) = "o" then
            l_qty_req = l_qty_req + sob_qty_req.

         if last-of(sob_part) and
            l_qty_req <> 0
         then do:
            {gprun.i ""gpsct05.p""
                     "(input sob_part,
                       input sob_site,
                       input 1,
                       output glxcst,
                       output curcst)"}

            assign
               glxcst = glxcst * (sob_qty_req / sod_qty_ord)
               l_glxcst = l_glxcst + glxcst.
         end. /* IF LAST-OF (SOB_PART) ... */

      end. /* FOR EACH SOB_DET */

   end. /* FOR FIRST SOD_DET */

END PROCEDURE.
