/* apvomta4.p - AP VOUCHER MAINTENANCE P.O. Receipt History Subprogram      */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* Creates new vod_det records (Split from apvomta.p)                       */
/* Pre-86E commented code removed, view in archive revision 1.14            */
/* Old ECO marker removed, but no ECO header exists *F003*                  */
/* Old ECO marker removed, but no ECO header exists *F085*                  */
/* Old ECO marker removed, but no ECO header exists *F096*                  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Old ECO marker removed, but no ECO header exists *F380*                  */
/* Old ECO marker removed, but no ECO header exists *F387*                  */
/* Old ECO marker removed, but no ECO header exists *F681*                  */
/* Old ECO marker removed, but no ECO header exists *F725*                  */
/* Old ECO marker removed, but no ECO header exists *G031*                  */
/* Old ECO marker removed, but no ECO header exists *G186*                  */
/* Old ECO marker removed, but no ECO header exists *G381*                  */
/* Old ECO marker removed, but no ECO header exists *G418*                  */
/* Old ECO marker removed, but no ECO header exists *G860*                  */
/* Old ECO marker removed, but no ECO header exists *GC14*                  */
/* REVISION  7.3           CREATED:  06/29/93   by: jms *GD32*              */
/* REVISION  7.4     LAST MODIFIED:  11/03/93   by: pcd *H209*              */
/*                                   02/10/93   by: pcd *FM07*              */
/*                                   02/25/94   by: pcd *H199*              */
/*                                   03/09/94   by: jjs *GJ05*              */
/*                                   05/09/94   by: pmf *FO06*              */
/*                                   06/14/94   by: bcm *H384*              */
/*                                   06/15/94   by: pmf *FO88*              */
/*                                   07/19/94   by: pmf *FP44*              */
/*                    LAST MODIFIED: 09/12/94   by: slm *GM17*              */
/*                                   12/08/94   by: str *FU40*              */
/*                                   02/05/95   by: str *G0DW*              */
/*                                   03/31/95   by: wjk *F0PT*              */
/*                                   07/24/95   by: jzw *G0SL*              */
/*                                   07/12/95   by: mys *G1FQ*              */
/*                                   01/15/96   by: mys *G1K6*              */
/* REVISION: 8.5      LAST MODIFIED: 10/06/95   BY: mwd *J053*              */
/* REVISION: 8.6      LAST MODIFIED: 01/23/97   BY: BJL *K01G*              */
/* REVISION: 8.6      LAST MODIFIED: 02/14/97   BY: rxm *K066*              */
/*                                   03/10/97   BY: *K084*  Jeff Wootton    */
/*                                   08/25/97   BY: *H1DK*  Todd Runkle     */
/* REVISION: 8.6      LAST MODIFIED: 12/04/97   BY: *G2QJ* Samir Bavkar     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 04/10/98   BY: *L00K* RVSL             */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 06/12/98   BY: *L01Z* Darius Sidel     */
/* REVISION: 8.6E     LAST MODIFIED: 08/04/98   BY: *L03K* Jeff Wootton     */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari  */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Patrick Rowan    */
/* REVISION: 9.1      LAST MODIFIED: 05/24/00   BY: *K24K* Jose Alex        */
/* REVISION: 9.1      LAST MODIFIED: 08/07/00   BY: *L129* Veena Lad        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn              */
/* REVISION: 9.1      LAST MODIFIED: 09/21/00   BY: *N0W0* Mudit Mehta      */
/* Revision: 1.19.1.11     BY: Rajesh Lokre       DATE: 07/09/01  ECO: *M19Z* */
/* Revision: 1.19.1.13     BY: Niranjan R.        DATE: 07/23/01  ECO: *P00L* */
/* Revision: 1.19.1.14     BY: Geeta Kotian       DATE: 09/20/01  ECO: *M1LP* */
/* Revision: 1.19.1.15     BY: Abbas Hirkani      DATE: 03/20/02  ECO: *M1WT* */
/* Revision: 1.19.1.17     BY: Steve Nugent       DATE: 04/17/02  ECO: *P043* */
/* Revision: 1.19.1.18     BY: Ed van de Gevel    DATE: 05/08/02  ECO: *P069* */
/* Revision: 1.19.1.19     BY: Patrick Rowan      DATE: 05/15/02  ECO: *P06L* */
/* Revision: 1.19.1.20     BY: Jose Alex          DATE: 08/02/02  ECO: *M1XR* */
/* Revision: 1.19.1.21     BY: Gnanasekar         DATE: 08/27/02  ECO: *N1SD* */
/* Revision: 1.19.1.22     BY: Rajaneesh S.       DATE: 10/10/02  ECO: *M1XP* */
/* Revision: 1.19.1.23     BY: Patrick Rowan      DATE: 11/22/02  ECO: *M21B* */
/* Revision: 1.19.1.24     BY: Jyoti Thatte       DATE: 12/03/02  ECO: *P0L6* */
/* Revision: 1.19.1.25     BY: Karan Motwani      DATE: 12/10/02  ECO: *N21F* */
/* Revision: 1.19.1.27     BY: Tiziana Giustozzi  DATE: 02/21/03  ECO: *P0MX* */
/* Revision: 1.19.1.29     BY: Paul Donnelly (SB) DATE: 06/26/03  ECO: *Q00B* */
/* Revision: 1.19.1.30     BY: Jean Miller        DATE: 09/26/03  ECO: *Q03S* */
/* Revision: 1.19.1.31     BY: Shivanand H        DATE: 07/13/04  ECO: *P29R* */
/* Revision: 1.19.1.32     BY: Vandna Rohira      DATE: 09/06/04  ECO: *P2J0* */
/* Revision: 1.19.1.33     BY: Abhishek Jha       DATE: 04/01/05  ECO: *P36L* */
/* Revision: 1.19.1.34     BY: Pankaj Goswami     DATE: 02/15/05  ECO: *P36R* */
/* Revision: 1.19.1.34.1.1 BY: Shivanand H        DATE: 06/15/05  ECO: *P3PH* */
/* Revision: 1.19.1.34.1.2 BY: Steve Nugent       DATE: 08/12/05 ECO: *P2PJ*  */
/* Revision: 1.19.1.34.1.3 BY: Hitendra P V       DATE: 09/19/05 ECO: *P3XW*  */
/* Revision: 1.19.1.34.1.4 BY: Amit Kumar         DATE: 11/18/05  ECO: *P48H* */
/* Revision: 1.19.1.34.1.5 BY: Dilip Manawat      DATE: 07/24/06  ECO: *P4Y5* */
/* $Revision: 1.19.1.34.1.6 $           BY: Sambit Pattnaik    DATE: 09/25/06  ECO: *P57B* */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{cxcustom.i "APVOMTA4.P"}

{gldydef.i}
{gldynrm.i}

{apvomta.i} /*DEFINE VARIABLES IN .i FOR EDIT BUFFER LIMIT*/

{etvar.i } /* COMMON EURO VARIABLES*/
/* VARIABLE DEFINITIONS AND COMMON PROCEDURE TO GET NEW pvod_det FIELDS FROM  */
/* THE qtbl_ext TABLE USING gpextget.i.                                       */
{pocnpvod.i}

define variable glvalid        like mfc_logical.
define variable open_qty       like vph_inv_qty.
define variable vph_sgn        as integer.
define variable open_sgn       as integer.
define variable vph_abs        like vph_inv_qty.
define variable open_abs       like vph_inv_qty.
define variable rec_qty        like vph_inv_qty.
define variable invcst_sgn     as integer.
define variable purcst_sgn     as integer.
define variable rndamt         like glt_amt.
define variable l_rcpt_rate    like vo_ex_rate   no-undo.
define variable l_rcpt_rate2   like vo_ex_rate2  no-undo.
define variable dftRCPTAcct       like pl_rcpt_acct no-undo.
define variable dftRCPTSubAcct    like pl_rcpt_sub  no-undo.
define variable dftRCPTCostCenter like pl_rcpt_cc   no-undo.
define variable dftAPVRAcct       like pl_apvr_acct no-undo.
define variable dftAPVRSubAcct    like pl_apvr_sub  no-undo.
define variable dftAPVRCostCenter like pl_apvr_cc   no-undo.
define variable dftAPVUAcct       like pl_apvu_acct no-undo.
define variable dftAPVUSubAcct    like pl_apvu_sub  no-undo.
define variable dftAPVUCostCenter like pl_apvu_cc   no-undo.
define variable pvod-trx-cost like pvod_pur_cost     no-undo.

define shared variable rndmthd like rnd_rnd_mthd.
define shared variable close_pvo  like mfc_logical label "Close Line".
{&APVOMTA4-P-TAG1}

define new shared variable l_vod_det_exists like mfc_logical no-undo.

define temp-table voddet_table no-undo
   field voddet_acct     like vod_acct
   field voddet_sub      like vod_sub
   field voddet_cc       like vod_cc
   field voddet_entity   like vod_entity
   field voddet_project  like vod_project
   field voddet_tax_at   like vod_tax_at
   field voddet_exp_acct like vod_exp_acct
   field voddet_exp_sub  like vod_exp_sub
   field voddet_exp_cc   like vod_exp_cc
   field voddet_desc     like vod_desc
index voddet-idx voddet_acct voddet_sub voddet_cc voddet_entity
                 voddet_project voddet_tax_at voddet_exp_acct voddet_exp_sub
                 voddet_exp_cc.

find ap_mstr where recid(ap_mstr) = ap_recno no-lock no-error.
find vo_mstr where recid(vo_mstr) = vo_recno no-lock no-error.
find first apc_ctrl where apc_domain = global_domain no-lock.
find first gl_ctrl where gl_domain = global_domain no-lock.

for first icc_ctrl
   fields( icc_domain icc_gl_tran)
    where icc_domain = global_domain
no-lock: end.

/* BACK OUT EXISTING G/L TRANSACTIONS AND DELETE OLD VOUCHER DETAIL */
find first vod_det where vod_domain = global_domain
                     and vod_ref  = vo_ref
                     and vod_type = "R"
no-lock no-error.

if available vod_det
then do:

   /*FIND THE ENTITY FOR THE CREDIT ACCOUNT*/
   for each vod_det where vod_domain = global_domain
                      and vod_ref  = vo_ref
                      and vod_type = "R"
   exclusive-lock:
      {&APVOMTA4-P-TAG2}

      /* SET l_vod_det_exists TO YES WHICH IS USED IN   */
      /* APVOMTA3.P TO RE-CALCULATE OLD GL COST TO POST */
      /* CORRECT AMOUNT IN INVENTORY AND INVENTORY      */
      /* DISCREPANCY ACCOUNT FOR EXISTING VOUCHER       */

      l_vod_det_exists = yes.

      create voddet_table.
      assign
         voddet_acct     = vod_acct
         voddet_sub      = vod_sub
         voddet_cc       = vod_cc
         voddet_entity   = vod_entity
         voddet_project  = vod_project
         voddet_tax_at   = vod_tax_at
         voddet_exp_acct = vod_exp_acct
         voddet_exp_sub  = vod_exp_sub
         voddet_exp_cc   = vod_exp_cc
         voddet_desc     = vod_desc.

      delete vod_det.
   end. /* FOR EACH vod_det */
end. /* IF AVAILABLE vod_det */

for each vod_det
   fields(vod_ref vod_amt vod_base_amt)
   where vod_domain =  global_domain
   and   vod_ref    =  vo_ref
   and   vod_type   <> "R"
   and   vod_type   <> "T"
   exclusive-lock:

   {gprunp.i   "mcpl" "p" "mc-curr-conv"
      "(input  vo_curr,
        input  base_curr,
        input  vo_ex_rate,
        input  vo_ex_rate2,
        input  vod_amt,
        input  true, /* ROUND */
        output vod_base_amt,
        output mc-error-number)"}.

   if mc-error-number <> 0
   then do:
   		if not batchrun then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.
   end.  /* IF mc-error-number <> 0 */
end. /* FOR EACH vod_det */

/* CREATE NEW AUTOMATIC VOUCHER RECORDS BASED ON */
/* UPDATED P.O. RECEIPTS */
/***************************************************/
/*     VODAMT[1] & VODACCT[1] ===> RECEIPTS        */
/*     VODAMT[2] & VODACCT[2] ===> RATE VARIANCE   */
/*     VODAMT[3] & VODACCT[3] ===> USAGE VARIANCE  */
/*     VODAMT[4] & VODACCT[4] ===> EXCHANGE GAIN   */
/*     VODAMT[5] & VODACCT[5] ===> EXCHANGE LOSS   */
/*     VODAMT[6] & VODACCT[6] ===> DISCREPANCY     */
/*     VODAMT[7] & VODACCT[7] ===> OLD EXP ACCT    */
/*     VODAMT[8] & VODACCT[8] ===> NEW EXP ACCT    */
/***************************************************/

vchr_ln = 0.

for each vph_hist
   where vph_domain = global_domain
   and   vph_ref    = vo_ref
   and   vph_pvo_id <> 0
exclusive-lock:

   if vph_pvod_id_line > 0
   then do:

      for first pvo_mstr no-lock where pvo_domain = global_domain and
                                       pvo_id = vph_pvo_id,
          first pvod_det no-lock where
                pvod_domain = global_domain
            and pvod_id = pvo_id
            and pvod_id_line = vph_pvod_id_line,
          first prh_hist no-lock where prh_domain = global_domain and
                                       prh_receiver = pvo_internal_ref  and
                                       prh_line = pvo_line:
      end. /* FOR FIRST pvo_mstr */

      run getExtTableRecord
          (input "10074a",
           input global_domain,
           input pvod_id,
           input pvod_id_line,
           output pvod_trans_qty,
           output pvod_vouchered_qty,
           output pvod_pur_cost,
           output pvod_pur_std,
           output pvod-dummy-dec1,
           output pvod_trans_date,
           output pvod-dummy-char).

      run getExtTableRecord
          (input "10074b",
           input global_domain,
           input pvod_id,
           input pvod_id_line,
           output pvod_ex_rate,
           output pvod_ex_rate2,
           output pvod-dummy-dec1,
           output pvod-dummy-dec2,
           output pvod-dummy-dec3,
           output pvod-dummy-date,
           output pvod_ex_ratetype).

      find first gl_ctrl where gl_domain = global_domain no-lock.

      find pt_mstr where pt_domain = global_domain and pt_part = pvo_part
      no-lock no-error.

      if available pt_mstr then
         find pl_mstr where pl_domain = global_domain and
                            pl_prod_line = pt_prod_line
         no-lock no-error.

      /* Determine supplier type needed to get default gl account info */
      run get-gl-defaults.

      if prh_po_site <> "" then
         find si_mstr where si_domain = global_domain and si_site = prh_po_site
         no-lock no-error.
      else
         find si_mstr where si_domain = global_domain and si_site = pvo_shipto
         no-lock no-error.

      if available si_mstr then
         vodentity = si_entity.
      else
         vodentity = ap_entity.

      do i = 1 to 8:
         assign
            vodamt[i]     = 0
            vodacct[i]    = ""
            vodsub[i]     = ""
            vodcc[i]      = ""
            vodproject[i] = "".
      end. /* DO i = 1 to 8 */

      /* GET EXCHANGE RATE BETWEEN VOUCHER AND BASE AS OF RECEIPT DATE */
      /* (THIS IS EQUIVALENT TO ETK ECO G2SZ IN 86C) */
      {gprunp.i "mcpl" "p" "mc-get-ex-rate"
         "(input vo_curr,
           input base_curr,
           input vo_ex_ratetype,
           input pvo_trans_date,
           output l_rcpt_rate,
           output l_rcpt_rate2,
           output mc-error-number)"}
      if mc-error-number <> 0
      then do:
      	 if not batchrun then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.
      end. /* IF mc-error-number <> 0 */

      /* SET TOTINVDIFF FOR WARNING MSG #5 AND HOLD_AMT UPDATE IN APVOMT.P */
      invcst = vph_inv_qty * vph_curr_amt.

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output invcst,
           input rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0
      then do:
      		if not batchrun then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.
      end. /* IF mc-error-number <> 0 */

      /* CONVERT pvod_pur_cost TO TRANSACTION CURR */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
                "(input  base_curr,
                  input  pvo_mstr.pvo_curr,
                  input  pvod_ex_rate2,
                  input  pvod_ex_rate,
                  input  pvod_pur_cost,
                  input  false,
                  output pvod-trx-cost,
                  output mc-error-number)"}

      if mc-error-number <> 0 then do:
      		if not batchrun then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
       	   end.
      end.
      assign
         rcvd_open = pvod_trans_qty - pvod_vouchered_qty + vph_inv_qty
         purcst    = rcvd_open
                   * pvod-trx-cost
                   * prh_um_conv.

      if vo_curr  <> pvo_curr
      then
            run determine_vo_exchange_rate_calc_amts
               (input pvod_id,
                input pvod_id_line,
                input-output purcst).

/* (THIS WAS NOT AFFECTED BY ETK ECO G2SZ IN 86C) */
      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output purcst,
           input rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0
      then do:
      		if not batchrun then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
          end.
      end. /* IF mc-error-number <> 0 */

      assign
         invcst_sgn = if invcst >= 0 then 1 else -1
         purcst_sgn = if purcst >= 0 then 1 else -1.

      if (invcst_sgn * invcst) - (purcst_sgn * purcst) > 0
      then
         totinvdiff = totinvdiff + (invcst - purcst).

      /* DEFINE AMOUNTS FOR P.O. RECEIPTS, VARIANCES, ETC */
      assign
         open_amt = pvod_trans_qty
                  * pvod-trx-cost
                  * prh_um_conv
         rndamt   = pvod_vouchered_qty
                  * pvod-trx-cost
                  * prh_um_conv.


      if vo_curr <> pvo_curr
      then do:
          run determine_vo_exchange_rate_calc_amts
              (input pvod_id,
               input pvod_id_line,
               input-output open_amt).

          run determine_vo_exchange_rate_calc_amts
              (input pvod_id,
               input pvod_id_line,
               input-output rndamt).
      end.
      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output open_amt,
           input rndmthd,
           output mc-error-number)"}

      if mc-error-number <> 0
      then do:
      		if not batchrun then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
        	end.
      end. /* IF mc-error-number <> 0 */

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output rndamt,
           input rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0
      then do:
      		if not batchrun then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
       	 	end.
      end.

      assign
         open_amt = open_amt - rndamt
         rndamt   = (vph_inv_qty * -1)
                  * pvod-trx-cost
                  * prh_um_conv.

      if vo_curr  <> pvo_curr
      then
          run determine_vo_exchange_rate_calc_amts
            (input pvod_id,
             input pvod_id_line,
             input-output rndamt).

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output rndamt,
           input rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0
      then do:
      		if not batchrun then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
          end.
      end.

      assign
         open_amt = open_amt - rndamt

         /* Receipt amount --> vodamt[1] */
         vodamt[1] = vph_inv_qty
                   * pvod-trx-cost
                   * prh_um_conv.

      if vo_curr  <> pvo_curr
      then
            run determine_vo_exchange_rate_calc_amts
                (input pvod_id,
                 input pvod_id_line,
                 input-output vodamt[1]).

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output vodamt[1],
           input rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0
      then do:
      		if not batchrun then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
        end.
      end.

      /* Rate variance --> vodamt[2] */
      assign
         vodamt[2] = (vph_curr_amt * vph_inv_qty)
         rndamt = pvod-trx-cost
                * (prh_um_conv * vph_inv_qty).

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output vodamt[2],
           input rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0
      then do:
      	 if not batchrun then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.
      end.

      if vo_curr <> pvo_curr
      then
         run determine_rcpt_exchange_rate_calc_amts
             (input pvod_id,
              input pvod_id_line,
              input-output rndamt).

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output rndamt, input rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0
      then do:
      	if not batchrun then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
       end.
      end.

      vodamt[2] = vodamt[2] - rndamt.

      /* ONLY SET USAGE VARIANCE IF RECEIVER LINE IS CLOSED */

      /* Usage variance --> vodamt[3]*/
      if (pvo_last_voucher <> "")
      then
         /* CALCULATE USAGE VARIANCE WITH ABSOLUTE VALUES */
         assign
            vph_sgn   = if vodamt[1] >= 0 then 1 else -1
            open_sgn  = if open_amt >= 0 then 1 else -1
            vodamt[3] = (vph_sgn * vodamt[1]) - (open_sgn * open_amt).

      else
      if (open_amt  >= 0 and
          vodamt[1] <  0 )
      or (open_amt  <  0 and
          vodamt[1] >= 0 )
      then
         vodamt[3] = vodamt[1].

      /* USAGE VARIANCE CALCULATION */
      /* ABSOLUTE VALUES ARE USED FOR MAX, MIN TO WORK */

      /* THE FOLLOWING ONLY NEEDS TO BE DONE WHEN THE  */
      /* RECEIVER LINE IS CLOSED                       */
      if pvo_last_voucher <> ""
      then do:
         assign
            open_qty = pvod_trans_qty - (pvod_vouchered_qty - vph_inv_qty)
            vph_sgn  = if (vph_inv_qty >= 0)
                    then 1
                       else -1
            open_sgn = if (open_qty >= 0)
                       then 1
                       else -1.

         if (vph_inv_qty      = 0
             and vph_curr_amt = 0
             and close_pvo    = yes)
         then
            vph_sgn = open_qty / absolute(open_qty).

         assign
            vph_abs  = vph_inv_qty * vph_sgn
            open_abs = open_qty    * open_sgn.

         if vodamt[3] < 0
         then
            rec_qty = max (vph_abs, open_abs).
         else
            rec_qty = min (vph_abs, open_abs).

         vodamt[3]  = vodamt[1] - open_amt.
         /* NEEDED FOR VODAMT[5] */

         if vo_curr = pvo_curr
            and vo_ex_rate = pvod_ex_rate
            and vo_ex_rate2 = pvod_ex_rate2
         then
            vodamt[1] = rec_qty * vph_sgn *
                        pvod-trx-cost
                      * prh_um_conv.

         else do:

            /* CONVERT FROM BASE TO FOREIGN CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input base_curr,
                 input vo_curr,
                 input vo_ex_rate2,
                 input vo_ex_rate,
                 input rec_qty * vph_sgn * pvod_pur_cost * prh_um_conv,
                 input false, /* DO NOT ROUND */
                 output vodamt[1],
                 output mc-error-number)"}.

         end. /* ELSE DO */

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
             "(input-output vodamt[1],
               input rndmthd,
               output mc-error-number)"}
         if mc-error-number <> 0
         then do:
         		if not batchrun then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end. /* IF mc-error-number <> 0 */

      end. /* pvo_last_voucher <> "" */

      /* WHEN THE RECEIVER LINE IS NOT CLOSED THE PO RECEIPTS   */
      /* AMOUNT(vodamt[1]) AND THE PURCHASE GAIN/LOSS           */
      /* CALCULATED WERE INCORRECT.                             */

      /* THE PO RECEIPTS AMOUNT IN NON-BASE WAS BASED ON RECEIPT */
      /* COST(pvod_pur_cost) i.e. IT WAS BASED ON THE PO RECEIPTS */
      /* EXCHANGE RATE.IT SHOULD HAVE USED VOUCHER EXCHANGE RATE */
      /* THIS IS BECAUSE THE  POR AMOUNT IN NON-BASE             */
      /* IS SUBSEQUENTLY DIVIDED BY THE VOUCHER EXCHANGE RATE    */
      /* TO GET THE BASE AMOUNT WHEN CREATING GL TRANSACTIONS.   */

      /* PUR G/L WAS CALCULATED AS IT WOULD HAVE BEEN CALCULATED */
      /* WHEN THE LINE WAS CLOSED. THIS IS INCORRECT. WHEN THE   */
      /* LINE IS NOT CLOSED IT SHOULD BE BASED ON INVOICE QTY.   */

      /* PO RECEIPTS AMOUNT(vodamt[1]) IS NOW BASED ON THE       */
      /* INVOICE QUANTITY AT THE VOUCHER EXCHANGE RATE. THIS     */
      /* CORRECTS THE PO RECEIPTS AMOUNT AND HENCE THE PUR. G/L  */
      /* ENTRY.                                                  */

      else
      if vo_ex_rate  <> pvod_ex_rate   or
         vo_ex_rate2 <> pvod_ex_rate2
      then do:

         /* CONVERT FROM BASE TO FOREIGN CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input base_curr,
              input vo_curr,
              input vo_ex_rate2,
              input vo_ex_rate,
              input vph_inv_qty * pvod_pur_cost *  prh_um_conv,
              input false, /* DO NOT ROUND */
              output vodamt[1],
              output mc-error-number)"}.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
             "(input-output vodamt[1],
               input rndmthd,
               output mc-error-number)"}
         if mc-error-number <> 0
         then do:
         		if not batchrun then do:
        	    {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end. /* IF mc-error-number <> 0 */

      end. /* IF vo_ex_rate <> prh_ex_rate */

      rndamt = (vph_curr_amt * vph_inv_qty).

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
          "(input-output rndamt,
            input rndmthd,
            output mc-error-number)"}
      if mc-error-number <> 0
      then do:
      		if not batchrun then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
          end.
      end. /* IF mc-error-number <> 0 */

      vodamt[4] = rndamt     /* VOUCHERED AMOUNT */
                - vodamt[1]  /* RECEIPT AMT */
                - vodamt[2]  /* RATE VARIANCE */
                - vodamt[3]. /* USAGE VARIANCE */

      if vodamt[4] > 0 then
         /* VOUCHERED MORE THAN THE RECEIPT, DUE TO EXCHANGE LOSS, */
         /* SO MOVE FROM GAIN AMOUNT [4] TO LOSS AMOUNT [5] */
         assign
            vodamt[5] = vodamt[4]
            vodamt[4] = 0.

      if prh_type     <> ""  and
         prh_type <> "s"
      then do:

         if vph_acct    <> pvo_accrual_acct
         or vph_sub     <> pvo_accrual_sub
         or vph_cc      <> pvo_accrual_cc
         or vph_project <> pvo_project
         then do:

            assign
               /* SET PROJECT FOR ITEM RATE VARIANCE ACCOUNT */
               vodproject[2] = vph_project
               /* SET PROJECT FOR ITEM USAGE VARIANCE ACCOUNT */
               vodproject[3] = vph_project.

            if icc_gl_tran then
               assign
                  /* BACK OUT OLD ACCT */
                  vodamt[7]     = - vodamt[1]
                  vodacct[7]    = pvo_accrual_acct
                  vodsub[7]     = pvo_accrual_sub
                  vodcc[7]      = pvo_accrual_cc
                  vodproject[7] = pvo_project

                  /* ENTER NEW ACCT */
                  vodamt[8]     = vodamt[1]
                  vodacct[8]    = vph_acct
                  vodsub[8]     = vph_sub
                  vodcc[8]      = vph_cc
                  vodproject[8] = vph_project.

         end. /* IF vph_acct <> pvo_accrual_acct ... */

      end. /* IF prh_type <> "" ... */

      /* DEFINE ACCOUNTS FOR P.O. RECEIPTS, VARIANCES, ETC */
      {&APVOMTA4-P-TAG3}
      if prh_type    = ""
         or prh_type = "S"
      then do:
         assign
            expacct = ""
            expsub  = ""
            expcc   = "".
         {&APVOMTA4-P-TAG4}
         {&APVOMTA4-P-TAG5}
         assign
            vodacct[1] = dftRCPTAcct  /* RECEIPTS */
            vodsub[1]  = dftRCPTSubAcct
            vodcc[1]   = dftRCPTCostCenter
            vodacct[2] = dftAPVRAcct  /* RATE VARIANCE */
            vodsub[2]  = dftAPVRSubAcct
            vodcc[2]   = dftAPVRCostCenter
            vodacct[3] = dftAPVUAcct  /* USAGE VARIANCE */
            vodsub[3]  = dftAPVUSubAcct
            vodcc[3]   = dftAPVUCostCenter.

         {&APVOMTA4-P-TAG6}

         if not icc_gl_tran then
         for first pod_det
         fields( pod_domain pod_acct pod_cc pod_line pod_nbr pod_sub)
             where pod_domain = global_domain
               and pod_nbr    = pvo_order
               and pod_line  = pvo_line
         no-lock:

            assign
               vodacct[1] = pod_acct
               vodsub[1]  = pod_sub
               vodcc[1]   = pod_cc.
         end. /* FOR FIRST pod_det */

      end. /* IF prh_type = "" OR prh_type = "S" */

      else do:  /*memo items*/
         {&APVOMTA4-P-TAG9}

            /* ASSIGN ACCOUNT ENTERED IN VOUCHER FOR MEMO ITEMS */
            /* WHEN CREATE GL TRANS FLAG IS SET TO "NO"         */

         assign
            vodacct[1] = if icc_gl_tran
                         then gl_rcptx_acct
                         else vph_acct
            vodsub[1]  = if icc_gl_tran
                         then gl_rcptx_sub
                         else vph_sub
            vodcc[1]   = if icc_gl_tran
                         then gl_rcptx_cc
                         else vph_cc.

         for first pod_det
            fields( pod_domain pod_acct pod_cc pod_line pod_nbr pod_sub)
            where pod_domain = global_domain
              and pod_nbr    = pvo_order
              and pod_line  = pvo_line
         no-lock:
            assign
               expacct = pod_acct
               expsub  = pod_sub
               expcc   = pod_cc.
         end. /* FOR FIRST pod_det */

         {&APVOMTA4-P-TAG10}
         if apc_expvar then
            assign
               vodacct[2] = gl_apvrx_acct  /* RATE VARIANCE */
               vodsub[2]  = gl_apvrx_sub
               vodcc[2]   = gl_apvrx_cc
               vodacct[3] = gl_apvux_acct  /* USAGE VARIANCE */
               vodsub[3]  = gl_apvux_sub
               vodcc[3]   = gl_apvux_cc.
         else   /* USE EXPENSE ACCOUNT FOR BOTH VARIANCES */
            assign
               vodacct[2] = vph_acct
               vodsub[2]  = vph_sub
               vodcc[2]   = vph_cc
               vodacct[3] = vph_acct
               vodsub[3]  = vph_sub
               vodcc[3]   = vph_cc.
      end. /* ELSE DO */

      {&APVOMTA4-P-TAG11}

      {gprunp.i "mcpl" "p" "get-gain-loss-accounts"
         " (input false,
            input ap_curr,
            input true,
            input false,
            output vodacct[4],
            output vodsub[4],
            output vodcc[4] )"}

      {gprunp.i "mcpl" "p" "get-gain-loss-accounts"
         " (input false,
            input ap_curr,
            input false,
            input false,
            output vodacct[5],
            output vodsub[5],
            output vodcc[5] )"}

      {&APVOMTA4-P-TAG12}

      {gprun.i ""xxapvomta3.p""
         "(input recid(vo_mstr),
           input recid(vph_hist),
           input recid(prh_hist),
           input-output vodamt[2],
           input-output vodamt[6],
           input-output vodacct[2],
           input-output vodacct[6],
           input-output vodsub[2],
           input-output vodsub[6],
           input-output vodcc[2],
           input-output vodcc[6]
                         )"}

      do i = 1 to 8:

         find first vod_det
            where vod_domain   = global_domain
            and   vod_ref      = vo_ref
            and   vod_type     = "R"
            and   vod_acct     = vodacct[i]
            and   vod_sub      = vodsub[i]
            and   vod_cc       = vodcc[i]
            and   vod_project  = pvo_project
            and   vod_taxable  = pvo_taxable
            and   vod_exp_acct = expacct
            and   vod_exp_sub  = expsub
            and   vod_exp_cc   = expcc
            and   vod_entity   = vodentity
         exclusive-lock no-error.

         if i = 7 or i = 8
         then do:
            find first vod_det
               where vod_domain   = global_domain
               and   vod_ref      = vo_ref
               and   vod_type     = "R"
               and   vod_acct     = vodacct[i]
               and   vod_sub      = vodsub[i]
               and   vod_cc       = vodcc[i]
               and   vod_project  = vodproject[i]
               and   vod_taxable  = pvo_taxable
               and   vod_exp_acct = expacct
               and   vod_exp_sub  = expsub
               and   vod_exp_cc   = expcc
               and   vod_entity   = vodentity
            exclusive-lock no-error.
         end. /* IF i = 7 OR i = 8 */

         if available vod_det
            and vodamt[i] <> 0
         then do:
            vod_amt = vod_amt + vodamt[i].

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input vo_curr,
                 input base_curr,
                 input vo_ex_rate,
                 input vo_ex_rate2,
                 input vod_amt,
                 input true, /* ROUND */
                 output vod_base_amt,
                 output mc-error-number)"}.
            if mc-error-number <> 0
            then do:
            		if not batchrun then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                 end.
            end.

         end. /* IF AVAILABLE vod_det */

         if not available vod_det
            and vodamt[i] <> 0
         then do:

            vchr_ln = vchr_ln + 1.

            do while can-find(vod_det where vod_domain = global_domain
                                        and vod_ref = vo_ref
                                        and vod_ln  = vchr_ln):
               vchr_ln = vchr_ln + 1.
            end. /* DO WHILE CAN-FIND(vod_det ... */

            create vod_det.
            assign
               vod_domain = global_domain
               vod_ref    = vo_ref
               vod_acct   = vodacct[i]
               vod_sub    = vodsub[i]
               vod_cc     = vodcc[i]
               vod_entity = vodentity

               /* ASSIGN PROJECT CODE ENTERED IN VOUCHER FOR MEMO ITEMS */
               /* WHEN CREATE GL TRANS FLAG IS SET TO "NO"              */
               vod_project   = if prh_type     <> "s"
                                  and prh_type <> ""
                                  and not icc_gl_tran
                               then vph_project
                               else pvo_project
               vod_desc      = ""
               vod_amt       = vodamt[i]
               vod_ln        = vchr_ln
               vod_tax_at    = if pvo_taxable then "yes"
                                              else "no"
               vod_taxable   = pvo_taxable
               vod_tax_in    = pvo_tax_in
               vod_tax_env   = pvo_tax_env
               vod_taxc      = right-trim(substring(vph__qadc01,9,3,"RAW"))
               vod_tax_usage = right-trim(substring(vph__qadc01,1,8,"RAW"))
               vod_exp_acct  = expacct
               vod_exp_sub   = expsub
               vod_exp_cc    = expcc
               vod_dy_code   = dft-daybook
               vod_type      = "R"
               recno         = recid(vod_det).

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input vo_curr,
                 input base_curr,
                 input vo_ex_rate,
                 input vo_ex_rate2,
                 input vod_amt,
                 input true, /* ROUND */
                 output vod_base_amt,
                 output mc-error-number)"}.
            if mc-error-number <> 0
            then do:
            	if not batchrun then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
             end.
            end.

            if (i = 2 or i = 3 or i = 7 or i = 8)
               and (prh_type     <> "" and
                    prh_type <> "s")
            then

               if (vph_project <> pvo_project)
               then
                  vod_project = vodproject[i].

            /* NOTE: FIELD LIST IS NOT BEING INCLUDED AS ALL THE FIELDS */
            /* IN THE TEMP TABLE ARE ACCESSED                           */

            for first voddet_table use-index voddet-idx no-lock
                where voddet_acct     = vod_acct
                and   voddet_sub      = vod_sub
                and   voddet_cc       = vod_cc
                and   voddet_entity   = vod_entity
                and   voddet_project  = vod_project
                and   voddet_tax_at   = vod_tax_at
                and   voddet_exp_acct = vod_exp_acct
                and   voddet_exp_sub  = vod_exp_sub
                and   voddet_exp_cc   = vod_exp_cc:
            end. /* FOR FIRST */

            if available voddet_table
            then
               vod_desc = voddet_desc.

            else do:

               find ac_mstr where ac_domain = global_domain and
                                  ac_code = vod_acct
               no-lock no-error.
               if available ac_mstr then
                  vod_desc = ac_desc.

            end. /* ELSE DO: */

            release vod_det.

         end. /* IF NOT AVAILABLE vod_det */

      end. /* DO i = 1 to 8 */

      /* UPDATE PRM PROJECT BUDGET, SUBLEDGER & VOUCHER DETAIL */
      for first pod_det
         fields(pod_domain pod_project pod_pjs_line)
          where pod_domain = global_domain
            and pod_nbr  = vph_nbr
            and pod_line = pvo_line
      no-lock:

         if pod_project      <> "" and
            pod_pjs_line <> 0
         then do:
            {gprunmo.i
               &program="pjapvod.p"
               &module="PRM"
               &param="""(input recid(vph_hist),
                          input recid(pod_det))"}
         end. /* if pod_project <> "" and pod_pjs_line <> 0 */

      end. /* for first pod_det */

      vph_inv_date = ap_effdate.
   end. /* IF vph_pvod_id_line > 0 */

   if vph_inv_qty      = 0
      and vph_inv_cost = 0
      and close_pvo <> yes
   then
      delete vph_hist.

end.  /* FOR EACH VPH_HIST */

/* DELETE VOUCHER DETAIL RECORDS IF AMOUNT = ZERO */
{&APVOMTA4-P-TAG14}
for each vod_det
    where vod_domain = global_domain
      and vod_ref = vo_ref
      {&APVOMTA4-P-TAG13}
      and vod_amt   = 0
exclusive-lock:
      delete vod_det.
end. /* FOR EACH vod_det */
{&APVOMTA4-P-TAG15}
{&APVOMTA4-P-TAG16}

PROCEDURE get-gl-defaults:

   for first vd_mstr
      fields(vd_domain vd_addr vd_type)
       where vd_domain = global_domain and
             vd_addr = ap_mstr.ap_vend
   no-lock: end.

      {gprun.i ""glactdft.p"" "(input ""PO_RCPT_ACCT"",
                                input if available pt_mstr then
                                      pt_mstr.pt_prod_line else """",
                                input pvo_mstr.pvo_shipto,
                                input if available vd_mstr then
                                      vd_type else """",
                                input """",
                                input yes,
                                output dftRCPTAcct,
                                output dftRCPTSubAcct,
                                output dftRCPTCostCenter)"}

      {gprun.i ""glactdft.p"" "(input ""PO_APVU_ACCT"",
                                input if available pt_mstr then
                                      pt_mstr.pt_prod_line else """",
                                input pvo_mstr.pvo_shipto,
                                input if available vd_mstr then
                                      vd_type else """",
                                input """",
                                input yes,
                                output dftAPVUAcct,
                                output dftAPVUSubAcct,
                                output dftAPVUCostCenter)"}

      {gprun.i ""glactdft.p"" "(input ""PO_APVR_ACCT"",
                                input if available pt_mstr then
                                      pt_mstr.pt_prod_line else """",
                                input pvo_mstr.pvo_shipto,
                                input if available vd_mstr then
                                      vd_type else """",
                                input """",
                                input yes,
                                output dftAPVRAcct,
                                output dftAPVRSubAcct,
                                output dftAPVRCostCenter)"}

END PROCEDURE.
PROCEDURE determine_vo_exchange_rate_calc_amts:
define input parameter ip_id like vph_pvo_id no-undo.
define input parameter ip_line_id like vph_pvod_id_line no-undo.
define input-output parameter amt_to_calc as decimal no-undo.

run getExtTableRecord
    (input "10074b",
     input global_domain,
     input ip_id,
     input ip_line_id,
     output pvod_ex_rate,
     output pvod_ex_rate2,
     output pvod-dummy-dec1,
     output pvod-dummy-dec2,
     output pvod-dummy-dec3,
     output pvod-dummy-date,
     output pvod_ex_ratetype).

amt_to_calc = amt_to_calc * vo_mstr.vo_ex_rate
                          / vo_mstr.vo_ex_rate2
                          * pvod_ex_rate2
                          / pvod_ex_rate.

END PROCEDURE.

PROCEDURE determine_rcpt_exchange_rate_calc_amts:
define input parameter ip_id like vph_pvo_id no-undo.
define input parameter ip_line_id like vph_pvod_id_line no-undo.
define input-output parameter amt_to_calc as decimal no-undo.

run getExtTableRecord
    (input "10074b",
     input global_domain,
     input ip_id,
     input ip_line_id,
     output pvod_ex_rate,
     output pvod_ex_rate2,
     output pvod-dummy-dec1,
     output pvod-dummy-dec2,
     output pvod-dummy-dec3,
     output pvod-dummy-date,
     output pvod_ex_ratetype).

amt_to_calc = amt_to_calc * l_rcpt_rate
                          / l_rcpt_rate2
                          * pvod_ex_rate2
                          / pvod_ex_rate.

END PROCEDURE.
