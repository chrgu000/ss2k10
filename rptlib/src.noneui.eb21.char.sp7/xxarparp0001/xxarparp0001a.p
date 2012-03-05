/* arparpa.p - DETAIL PAYMENT AUDIT REPORT SUBROUTINE                        */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */

/* REVISION: 7.3      LAST MODIFIED: 08/17/93   by: JJS *GE34*               */
/*                                              (split from arparp.p)        */
/* REVISION: 7.4      LAST MODIFIED: 09/11/94   by: slm *GM15*               */
/*                                   02/24/95   by: str *F0K9*               */
/*                                   01/15/96   by: mys *H0HN*               */
/* REVISION: 8.5      LAST MODIFIED: 12/04/95   by: taf *J053*               */
/*                                   04/08/96   by: wjk *H0KG*               */
/*                                   04/15/96   by: mzh *J0J3*               */
/*                                   04/16/96   by: jzw *G1T9*               */
/*                                   05/28/96   by: jzw *G1WL*               */
/*                                   07/18/96   by: jwk *F0XJ*               */
/*                                   10/28/96   by: rxm *F0X6*               */
/*                                   01/08/97   by: bkm *J1DQ*               */
/* REVISION: 8.6      LAST MODIFIED: 10/17/97   by: bvm *K0QK*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 04/08/98   by: rup *L00K*               */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* REVISION: 8.6E     LAST MODIFIED: 06/19/98   BY: *J2PJ* Dana Tunstall     */
/* REVISION: 8.6E     LAST MODIFIED: 07/07/98   BY: *L01K* Jaydeep Parikh    */
/* REVISION: 8.6E     LAST MODIFIED: 09/16/98   BY: *L098* G.Latha           */
/* REVISION: 8.6E     LAST MODIFIED: 09/18/98   BY: *J30B* Santhosh Nair     */
/* REVISION: 8.6E     LAST MODIFIED: 09/21/98   BY: *L09F* Jeff Wootton      */
/* REVISION: 8.6E     LAST MODIFIED: 09/25/98   BY: *L09V* Jeff Wootton      */
/* REVISION: 9.1      LAST MODIFIED: 05/27/99   BY: *N00D* Adam Harris       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson      */
/* REVISION: 9.1      LAST MODIFIED: 10/13/99   BY: *L0K5* Hemali Desai      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 06/06/00   BY: *N0CL* Arul Victoria     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 09/07/00   BY: *L136* Veena Lad         */
/* REVISION: 9.1      LAST MODIFIED: 12/28/00   BY: *M0YY* Vihang Talwalkar  */
/* REVISION: 9.1      LAST MODIFIED: 01/23/01   BY: *M10B* Vinod Nair        */
/* REVISION: 9.1      LAST MODIFIED: 09/14/00   BY: *N0WW* Mudit Mehta       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.19.1.15    BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002*       */
/* Revision: 1.19.1.16    BY: Ed van deGevel DATE: 06/29/01 ECO: *N0ZX*       */
/* Revision: 1.19.1.20    BY: Vinod Nair     DATE: 07/23/01 ECO: *M1DY*       */
/* Revision: 1.19.1.20    BY: Seema Tyagi    DATE: 10/30/01 ECO: *N14K*       */
/* Revision: 1.19.1.21    BY: Mercy C        DATE: 03/18/02 ECO: *M1WF*       */
/* Revision: 1.19.1.22    BY: Karel Groos    DATE: 03/26/02 ECO: *N16J*       */
/* Revision: 1.19.1.24    BY: Paul Donnelly  DATE: 05/01/02 ECO: *N1HQ*       */
/* Revision: 1.19.1.25    BY: Karel Groos    DATE: 05/23/02 ECO: *N1B4*       */
/* Revision: 1.19.1.26    BY: Hareesh V.     DATE: 06/21/02 ECO: *N1HY*       */
/* Revision: 1.19.1.27    BY: Nishit V       DATE: 11/20/02 ECO: *N1ZZ*       */
/* Revision: 1.19.1.28    BY: Rafal Krzyminski   DATE: 02/10/03 ECO: *P0MN*  */
/* Revision: 1.19.1.29    BY: Narathip W.        DATE: 05/19/03 ECO: *P0SH*  */
/* Revision: 1.19.1.31    BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B*  */
/* Revision: 1.19.1.32    BY: Milind S.          DATE: 10/06/04 ECO: *P2NJ*  */
/* Revision: 1.19.1.33    BY: Preeti Sattur      DATE: 02/15/05 ECO: *P37L*  */
/* Revision: 1.19.1.34       BY: Priya Idnani       DATE: 05/23/05 ECO: *P3LZ*  */
/* Revision: 1.19.1.34.1.3   BY: Deepak Taneja      DATE: 05/08/07 ECO: *P5TQ*  */
/* $Revision: 1.19.1.34.1.6 $ BY: Shivakumar Patil   DATE: 08/06/07 ECO: *P603*  */
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 100705.1 By: Bill Jiang */

/* SS - 100705.1 - RNB
1. 基于ssarparp01.p,增加了以下输出字段:
   ar_nbr
SS - 100705.1 - RNE */

/* SS - 100705.1 - B */
{xxarparp0001.i}
/* SS - 100705.1 - E */

/*V8:ConvertMode=Report                                                      */
{mfdeclre.i}
{cxcustom.i "ARPARPA.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{pxpgmmgr.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arparpa_p_1 "Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_4 "Unassigned Amt"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_5 "Summary/Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_7 "Cash Acct!Dsc Acct"
/* MaxLen: Comment: */

/* REPLACED pre-processor label "Curr!Exch Rate"      */
/* TO "Cur!Exch Rate" FOR TRANSLATION PURPOSE         */
&SCOPED-DEFINE arparpa_p_9 "Cur!Exch Rate"
/* MaxLen: 13 Comment: */

&SCOPED-DEFINE arparpa_p_12 "Discount Amt"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_13 "Cash Amt"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_15 "Enty"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_21 "Date!Eff Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_22 "AR Amt"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_23 "Non-AR Amt"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_24 "Print GL Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_28 "Check!Bill-To"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_29 "Remark!Name"
/* MaxLen: Comment: */

{&ARPARPA-P-TAG1}
/* ********** End Translatable Strings Definitions ********* */

{etvar.i}
{etrpvar.i}
{wbrp02.i}

/* DEFINE SHARED WORKFILE AP_WKFL FOR CURRENCY SUMMARY */
{gpacctp.i}

define shared variable rndmthd like rnd_rnd_mthd.
define new shared variable base_amt like ar_amt.

define new shared variable base_damt like ard_amt.
define new shared variable base_disc like ard_disc.
define new shared variable tot-vtadj like ar_amt.
define new shared variable tot-vtcurradj like tot-vtadj.
define new shared variable apply2_rndmthd like rnd_rnd_mthd.

define shared variable batch like ar_batch.
define shared variable batch1 like ar_batch.
define shared variable check_nbr like ar_check.
define shared variable check1 like ar_check.
define shared variable cust like ar_bill.
define shared variable cust1 like ar_bill.
define shared variable entity like ar_entity.
define shared variable entity1 like ar_entity.
define shared variable ardate like ar_date.
define shared variable ardate1 like ar_date.
define shared variable effdate like ar_effdate.
define shared variable effdate1 like ar_effdate.
define shared variable bank  like   ar_bank    no-undo.
define shared variable bank1 like   bank       no-undo.
define shared variable base_rpt like ar_curr no-undo.
define shared variable mixed_rpt like mfc_logical.
define shared variable summary like mfc_logical format {&arparpa_p_5}
   initial no label {&arparpa_p_5}.
define shared variable gltrans like mfc_logical initial no
   label {&arparpa_p_24}.
{&ARPARPA-P-TAG13}
define shared variable ptype like ar_type initial " " no-undo.
define shared variable l_unassign like mfc_logical
                                  format "Historical/Current"
                                  initial no
                                  label "Unassigned Unapplied Amount".

define variable detlines as integer.
define variable disp_curr as character format "x(1)" label "C".
define variable type like ar_type format "X(6)".
define variable aramt like ard_amt label {&arparpa_p_22}.
define variable unamt like ard_amt label {&arparpa_p_4}.
define variable c_unamt like unamt.
define variable nonamt like ard_amt label {&arparpa_p_23}.
define variable c_nonamt like nonamt.
define variable base_det_amt like glt_amt.
define variable base_gl_disc like glt_amt.
define variable gain_amt like glt_amt.
define variable name like ad_name.
define variable basepayforeign as logical no-undo.
define variable oldcurr like ar_curr.
define variable oldsession as character.
define variable c_session as character.
define variable base_amt_fmt as character.
define variable curr_amt_old as character.
define variable curr_amt_fmt as character.
define variable curr_to_pass like ar_curr.
define variable save_line like gltw_line no-undo.
define variable base_glar_amt like glt_amt no-undo.
define variable ex_rate_relation1 as character format "x(40)" no-undo.
define variable ex_rate_relation2 as character format "x(40)" no-undo.
define variable foreignpayforeign like mfc_logical no-undo.
define variable c-base-rpt-lbl1 as character no-undo.
define variable c-base-rpt-lbl2 as character no-undo.
define variable b_appl_amt like ar_amt no-undo.
define variable c_appl_amt like ar_amt no-undo.
define buffer appl    for ar_mstr.
define buffer appldet for ard_det.

/* FOLLOWING NEEDED TO CALL ROUTINE TXTOTAL.P ***/
define variable tax_tr_type like tx2d_tr_type initial "19".
define variable tax_lines like tx2d_line initial 0.
/* ABOVE FOR TXTOTAL.P                        ***/

/* FOLLOWING NEEDED TO CALL ROUTINE TXGLPOST.P ***/
define variable gen_desc like glt_desc.
/* ABOVE FOR TXGLPOST.P                         ***/

define variable ico_acct as character no-undo.
define variable ico_sub as character no-undo.
define variable ico_cc as character no-undo.

define variable l_base_damt1 like ard_amt.
define variable l_base_disc1 like ard_disc.
define variable l_aramt1     like ard_amt.
define variable l_unamt1     like ard_amt.
define variable l_nonamt1    like ard_amt.
define variable l_yn         like mfc_logical.

{&ARPARPA-P-TAG14}
define buffer armstr for ar_mstr.

{&ARPARPA-P-TAG64}
{&ARPARPA-P-TAG65}

{&ARPARPA-P-TAG2}
{&ARPARPA-P-TAG15}
form
   ar_check
   column-label {&arparpa_p_28}
   ar_po format "x(28)" column-label {&arparpa_p_29}
   ar_type
   ar_bank column-label "Bk"
   ar_curr column-label {&arparpa_p_9}
   format "x(32)"  /* TO DISPLAY EX RATES IN CURRENCY COLUMN */
   base_amt
   ar_date column-label {&arparpa_p_21}
   ar_entity
   ar_acct column-label {&arparpa_p_7}
   ar_sub
   ar_cc
with frame c width 132 down.
{&ARPARPA-P-TAG16}
{&ARPARPA-P-TAG3}

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

{&ARPARPA-P-TAG17}
form
   ard_ref
   type column-label {&arparpa_p_1}
   ard_entity format "X(4)" label {&arparpa_p_15}
   ard_acct
   ard_sub
   ard_cc
   disp_curr
   base_damt label {&arparpa_p_13}
   base_disc label {&arparpa_p_12}
   aramt label {&arparpa_p_22}
   unamt label {&arparpa_p_4}
   nonamt label {&arparpa_p_23}
with frame e width 132 down.
{&ARPARPA-P-TAG18}

/* SET EXTERNAL LABELS */
setFrameLabels(frame e:handle).

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock no-error.
{&ARPARPA-P-TAG19}
for first arc_ctrl
   fields( arc_domain arc_sum_lvl)
 where arc_ctrl.arc_domain = global_domain no-lock:
end. /* FOR FIRST arc_ctrl */
base_amt_fmt = base_amt:format.
{gprun.i ""gpcurfmt.p"" "(input-output base_amt_fmt,
     input gl_rnd_mthd)"}
assign
   curr_amt_old = base_amt:format
   oldsession = SESSION:numeric-format
   oldcurr = "".
{&ARPARPA-P-TAG20}

do with frame e width 132 no-box down:
{&ARPARPA-P-TAG21}
   {&ARPARPA-P-TAG4}
   for each ar_mstr  where ar_mstr.ar_domain = global_domain and (  (ar_batch
   >= batch) and (ar_batch <= batch1)
         and (ar_check >= check_nbr) and (ar_check <= check1)
         and (ar_bill >= cust) and (ar_bill <= cust1)
         and (ar_entity >= entity) and (ar_entity <= entity1)
         and (ar_date >= ardate) and (ar_date <= ardate1)
         and (ar_effdate >= effdate) and (ar_effdate <= effdate1)
         and (ar_bank >= bank and ar_bank <= bank1)
         and (ar_type = "P")
         and ((ar_curr = base_rpt)
         or (base_rpt = "")) ) no-lock break by ar_batch by ar_nbr
         {&ARPARPA-P-TAG5}
         {&ARPARPA-P-TAG22}
      with frame c width 132 down:
      {&ARPARPA-P-TAG23}
      /* CHECK FOR UNAPPLIED OR NON-AR PAYMENTS */
      for first ard_det  where ard_det.ard_domain = global_domain and (
      ard_nbr = ar_nbr
                          and (ptype = "" or ard_type = ptype)
                        ) no-lock:
      end.
      if available ard_det then do:

         /* CHECK WHETHER THE UNAPPLIED PAYMENT HAS BEEN FULLY MATCHED */
         if ard_type = "U" then do for appl:
            assign b_appl_amt = 0
                   c_appl_amt = 0.
            for each appl
               fields( ar_domain ar_check ar_xslspsn1 ar_type ar_base_amt ar_amt)
                where appl.ar_domain = global_domain and  appl.ar_check     =
                ar_mstr.ar_check
               and   appl.ar_xslspsn1  = ard_det.ard_tax
               and   appl.ar_type      = "A"
               no-lock:
               assign b_appl_amt = b_appl_amt + appl.ar_base_amt
                      c_appl_amt = c_appl_amt + appl.ar_amt.
            end.
         end.

         if not (not l_unassign
            and (ptype = "U"
               and ard_amt = c_appl_amt))
         then do:
               l_yn = yes.
            if (oldcurr <> ar_curr) then do:
               /* DETERMINE ROUNDING METHOD FROM DOCUMENT CURRENCY OR BASE    */
               if (gl_base_curr <> ar_curr) then do:

                  /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                  {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                     "(input ar_curr,
                       output rndmthd,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
                     next.
                  end.
               end.
               else rndmthd = gl_rnd_mthd.

               apply2_rndmthd = rndmthd.

               /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN       */
               find rnd_mstr  where rnd_mstr.rnd_domain = global_domain and
               rnd_rnd_mthd = rndmthd no-lock no-error.
               if not available rnd_mstr then do:
                  /* ROUND METHOD RECORD NOT FOUND */
                  {pxmsg.i &MSGNUM=863 &ERRORLEVEL=4}
                  next.
               end.
               /* IT IS ASSUMED THAT THE STARTUP SESSION IS FOR THE BASE */
               /* CURRENCY, THEREFORE DO NOT CHANGE SESSION IF BASE_RPT */
               /* IS BASE */
               if not (base_rpt = "" and not mixed_rpt)
               then do:
                  /* IF RND_DEC_PT = COMMA FOR DECIMAL POINT */
                  /* THIS IS A EUROPEAN STYLE CURRENCY */
                  if (rnd_dec_pt = "," ) then
                  assign
                     c_session = "European"
                     SESSION:numeric-format = "European".
                  else
                  assign
                     c_session = "American"
                     SESSION:numeric-format = "American".
               end.

               assign
                  oldcurr = ar_curr
                  curr_amt_fmt = curr_amt_old.
               {gprun.i ""gpcurfmt.p"" "(input-output curr_amt_fmt,
                    input rndmthd)"}
            end.

            if ar_curr = base_curr then
            assign
               base_amt:format = curr_amt_fmt
               base_amt = ar_amt.
            else
            /*INSTEAD OF CONVERTING ar_amt, USE NEW FIELD ar_base_amt */
            assign
               base_amt = ar_base_amt
               base_amt:format = base_amt_fmt .

            /* SS - 100705.1 - B
            if first-of(ar_batch) then do with frame b:
               /* SET EXTERNAL LABELS */
               setFrameLabels(frame b:handle).
               display ar_batch with frame b side-labels.
            end. /* if first-of(ar_batch) */
            SS - 100705.1 - E */

            if first-of(ar_nbr) then
            do with frame c:
               find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
               ar_bill no-lock no-wait no-error.
               if available ad_mstr then name = ad_name.
               else name = "".

               /* SS - 100705.1 - B
               /* Changed format of batch header to make room for currency */
               /* and Exchange rate.                                       */
               {&ARPARPA-P-TAG6}
               display
                  ar_check
                  ar_bank
                  ar_po
                  ar_type.
               {&ARPARPA-P-TAG7}
               if not (base_rpt = "" and not mixed_rpt)
                  then display ar_curr with frame c.
               else
                  display base_curr @ ar_curr with frame c.
               if base_rpt = "" and not mixed_rpt then
               do:
                  base_amt:format = base_amt_fmt.
                  display (- base_amt) @ base_amt
                  with frame c.
               end.
               else
                  do:
                  base_amt:format = curr_amt_fmt.
                  display (- ar_amt) @ base_amt
                  with frame c.
               end.
               {&ARPARPA-P-TAG24}
               display
                  ar_date
                  ar_entity
                  ar_acct
                  ar_sub
                  ar_cc
                  {&ARPARPA-P-TAG25}
               with frame c.
               down 1 with frame c.
               {&ARPARPA-P-TAG26}
               SS - 100705.1 - E */
               
               /*       USE mc-ex-rate-output ROUTINE TO GET THE RATES FOR DISPLAY */
               {gprunp.i "mcui" "p" "mc-ex-rate-output"
                  "(input ar_curr,
                    input base_curr,
                    input ar_ex_rate,
                    input ar_ex_rate2,
                    input ar_exru_seq,
                    output ex_rate_relation1,
                    output ex_rate_relation2)"}

               /* SS - 100705.1 - B
               {&ARPARPA-P-TAG27}
               {&ARPARPA-P-TAG8}
               display
                  ar_bill @ ar_check
                  name @ ar_po
                  {&ARPARPA-P-TAG28}
                  ex_rate_relation1 @ ar_curr
                  ar_effdate @ ar_date
                  ar_disc_acct @ ar_acct
                  ar_disc_sub @ ar_sub
                  ar_disc_cc @ ar_cc
                  {&ARPARPA-P-TAG29}
                  skip
               with frame c.
               down 1 with frame c.
               SS - 100705.1 - E */

               if ex_rate_relation2 <> "" then
               do:
                  {&ARPARPA-P-TAG30}
                  display ex_rate_relation2 @ ar_curr with frame c.
                  {&ARPARPA-P-TAG31}
                  down 1 with frame c.
               end.

               /* SS - 100705.1 - B
               if gltrans then do:
                  {&ARPARPA-P-TAG32}
                  {gpnextln.i &ref=ar_bill &line=return_int}
                  {&ARPARPA-P-TAG33}
                  create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.

                  assign
                     {&ARPARPA-P-TAG34}
                     gltw_entity = ar_entity
                     gltw_acct = ar_acct
                     gltw_sub = ar_sub
                     gltw_cc = ar_cc
                     gltw_ref = ar_bill
                     gltw_line = return_int
                     gltw_date = ar_date
                     gltw_effdate = ar_effdate
                     gltw_userid = mfguser
                     gltw_desc = ar_batch + " " + ar_type + " " + ar_nbr
                     {&ARPARPA-P-TAG35}
                     recno = recid(gltw_wkfl)
                     save_line = gltw_line.

                  /* RELEASE THE RECORD SO arparpvt.p FINDS IT */
                  release gltw_wkfl.
               end.
               SS - 100705.1 - E */
            end.  /* first ar_nbr/gltrans file */

            /*  STORE TOTALS, BY CURRENCY, IN WORK FILE.                */
            if base_rpt = "" and mixed_rpt
            then do:
               {&ARPARPA-P-TAG36}
               find first ap_wkfl where ar_curr = apwk_curr no-error.
               {&ARPARPA-P-TAG37}

               /* If a record for this currency doesn't exist, create one. */
               if not available ap_wkfl then do:
                  create ap_wkfl.
                  {&ARPARPA-P-TAG38}
                  apwk_curr = ar_curr.
                  {&ARPARPA-P-TAG39}
               end.

               /* Accumulate individual currency totals in work file.*/
               {&ARPARPA-P-TAG40}
               apwk_for = apwk_for + (- ar_amt).
               if base_curr <> ar_curr then
                  {&ARPARPA-P-TAG41}
                  apwk_base = apwk_base + (- base_amt).
               else apwk_base = apwk_for.
            end.
            {&ARPARPA-P-TAG42}

            /* GET AR DETAIL  */
            detlines = 0.
            {&ARPARPA-P-TAG43}
            for each ard_det  where ard_det.ard_domain = global_domain and  ard_nbr =
            ar_nbr no-lock
                  break by ard_nbr by ard_acct by ard_sub with frame e:
               {&ARPARPA-P-TAG44}

               basepayforeign = no.
               /* GET MEMO OR INVOICE ASSOCIATED WITH THIS PMT */
               if ard_ref <> "" then do:
                  find armstr  where armstr.ar_domain = global_domain and
                  armstr.ar_nbr = ard_ref no-lock
                     no-error.
                  if available armstr and armstr.ar_curr <> base_curr
                     and ar_mstr.ar_curr = base_curr then
                  /* BASE PMT ON A FOREIGN CURR MEMO/INVOICE */
                  basepayforeign = yes.
               end.
               /*       WITH EURO TRANSPARENCY AN EMU CURRENCY PAYMENT CAN SETTLE */
               /*       THE INVOICE/MEMO THAT IS IN ANOTHER EMU CURRENCY AND BOTH */
               /*       THE CURRENCIES MAY NOT BE BASE.                           */
               foreignpayforeign = no.
               if available armstr then
               if armstr.ar_curr <> base_curr and
                  ar_mstr.ar_curr <> base_curr and
                  ar_mstr.ar_curr <> armstr.ar_curr and
                  base_rpt = "" then foreignpayforeign = yes.

               /* IF PMT CURR = BASE OR REPT CURR = PMT CURR */
               if ar_mstr.ar_curr = base_curr or
                  base_rpt = ar_mstr.ar_curr then do:
                  assign
                     base_damt = ard_amt
                     base_disc = ard_disc
                     base_det_amt = ard_amt + ard_disc
                     disp_curr = " ".

                  if basepayforeign or foreignpayforeign then
               do:
                     /*  NO NEED TO DO (ard_amt + ard_disc)*ar_mstr.ar_ex_rate */
                     /*  PART OF THE CONVERSION TO DERIVE THE INVOICE/MEMO AMT */
                     /*  AS OF DATE OF PAYMENT.                                */
                     /*  INSTEAD USE THE ard_cur_amt + ard_cur_disc WHICH      */
                     /*  ALREADY HAS THOSE VALUES.                             */
                     /*  CONVERT FROM BASE TO FOREIGN CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input armstr.ar_curr,
                          input base_curr,
                          input armstr.ar_ex_rate,
                          input armstr.ar_ex_rate2,
                          input (ard_cur_amt + ard_cur_disc),
                          input true, /* ROUND */
                          output base_glar_amt,
                          output mc-error-number)"}.
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}.
                     end.
                  end.
                  else
                     base_glar_amt = ard_amt + ard_disc.

               end.
               else do:

                  if ard_ref <> ""
                     /* INVOICE/MEMO ATTACHED */
                     and ard_cur_amt + ard_cur_disc <> 0
                     /* PAYMENT DETAIL HAS A FOREIGN AMOUNT */
                     and ard_cur_amt + ard_cur_disc = armstr.ar_applied
                     /* PAYMENT FOREIGN CURRENCY AMOUNT EQUALS */
                     /*  INVOICE/MEMO APPLIED AMOUNT */
                  then do:
                     base_damt = armstr.ar_base_applied.
                     /* USE INVOICE/MEMO BASE APPLIED AMOUNT */
                     base_disc = armstr.ar_base_applied
                     /* USE INVOICE/MEMO BASE APPLIED AMOUNT */
                     * ard_disc
                     / (ard_amt + ard_disc).
                     /* IN SAME PROPORTION AS DISCOUNT */
                     /* ROUND TO BASE METHOD */
                     {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output base_disc,
                          input gl_ctrl.gl_rnd_mthd,
                          output mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
                     end.
                     /* MAKE PAYMENT + DISCOUNT BALANCE TO INVOICE/MEMO */
                     base_damt = base_damt - base_disc.
                  end.
                  else do:
                     /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                     /* CHANGED ROUNDING FROM FALSE TO TRUE BELOW */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input ar_mstr.ar_curr,
                          input base_curr,
                          input ar_mstr.ar_ex_rate,
                          input ar_mstr.ar_ex_rate2,
                          input ard_amt,
                          input true, /* ROUND */
                          output base_damt,
                          output mc-error-number)"}.
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}.
                     end.

                     /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input ar_mstr.ar_curr,
                          input base_curr,
                          input ar_mstr.ar_ex_rate,
                          input ar_mstr.ar_ex_rate2,                       input ard_disc,
                          input true, /* ROUND */
                          output base_disc,
                          output mc-error-number)"}.
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}.
                     end.

                  end.

                  base_det_amt = base_damt + base_disc.

                  if basepayforeign or foreignpayforeign then
                  do:
                     /* CONVERT FROM BASE TO FOREIGN CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input armstr.ar_curr,
                          input base_curr,
                          input armstr.ar_ex_rate,
                          input armstr.ar_ex_rate2,
                          input (ard_cur_amt + ard_cur_disc),
                          input true, /* ROUND */
                          output base_glar_amt,
                          output mc-error-number)"}.
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}.
                     end.
                  end.
                  else
                     do:

                     if available armstr and
                        ar_mstr.ar_curr = armstr.ar_curr then
                     do:
                        /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                        {gprunp.i "mcpl" "p" "mc-curr-conv"
                           "(input armstr.ar_curr,
                             input base_curr,
                             input armstr.ar_ex_rate,
                             input armstr.ar_ex_rate2,
                             input (ard_amt + ard_disc),
                             input true, /* ROUND */
                             output base_glar_amt,
                             output mc-error-number)"}.
                        if mc-error-number <> 0 then do:
                           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}.
                        end.
                     end.
                     else
                        do:
                        /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                        {gprunp.i "mcpl" "p" "mc-curr-conv"
                           "(input ar_mstr.ar_curr,
                             input base_curr,
                             input ar_mstr.ar_ex_rate,
                             input ar_mstr.ar_ex_rate2,
                             input (ard_amt + ard_disc),
                             input true, /* ROUND */
                             output base_glar_amt,
                             output mc-error-number)"}.
                        if mc-error-number <> 0 then do:
                           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}.
                        end.
                     end.
                  end.
                  /* ROUND PER BASE CURRENCY ROUND METHOD */

                  disp_curr = getTermLabel("YES",1).
               end.

               assign
                  detlines = detlines + 1
                  type = "".

               if ard_type = "M" then
                  type = getTermLabel("MEMO",6).
               else
                  if ard_type = "F" then
                  type = getTermLabel("FINANCE_CHARGE",6).
               else
                  if ard_type = "I" then
                  type = getTermLabel("INVOICE",6).
               else
                  if ard_type = "D" then
                  type = getTermLabel("DRAFT",6).
               else
                  if ard_type = "U" then
                  type = getTermLabel("UNAPPLIED",6).
               else
                  if ard_type = "N" then
                  type = getTermLabel("NON-AR",6).

               accumulate base_damt (total).
               accumulate base_disc (total).
               accumulate ard_amt (total).
               accumulate ard_disc (total).
               if not summary then do with frame e:
                  /* SS - 100705.1 - B */
                  CREATE ttxxarparp0001.
                  ASSIGN
                     /* SS - 100705.1 - B */
                     ttxxarparp0001_ar_nbr = ar_mstr.ar_nbr
                     /* SS - 100705.1 - E */
                     ttxxarparp0001_ar_batch = ar_mstr.ar_batch
      
                     ttxxarparp0001_ar_check = ar_mstr.ar_check
                     ttxxarparp0001_ar_bank = ar_mstr.ar_bank
                     ttxxarparp0001_ar_po = ar_mstr.ar_po
                     ttxxarparp0001_ar_type = ar_mstr.ar_type
      
                     ttxxarparp0001_ar_date = ar_mstr.ar_date
                     ttxxarparp0001_ar_entity = ar_mstr.ar_entity
                     ttxxarparp0001_ar_acct = ar_mstr.ar_acct
                     ttxxarparp0001_ar_sub = ar_mstr.ar_sub
                     ttxxarparp0001_ar_cc = ar_mstr.ar_cc
      
                     ttxxarparp0001_ar_bill = ar_mstr.ar_bill
                     ttxxarparp0001_ad_name = NAME
                     ttxxarparp0001_ex_rate_relation1 = ex_rate_relation1
                     ttxxarparp0001_ar_ex_rate = ar_mstr.ar_ex_rate
                     ttxxarparp0001_ar_ex_rate2 = ar_mstr.ar_ex_rate2
                     ttxxarparp0001_ar_effdate = ar_mstr.ar_effdate
                     ttxxarparp0001_ar_disc_acct = ar_mstr.ar_disc_acct
                     ttxxarparp0001_ar_disc_sub = ar_mstr.ar_disc_sub
                     ttxxarparp0001_ar_disc_cc = ar_mstr.ar_disc_cc
                     ttxxarparp0001_ex_rate_relation2 = ex_rate_relation2
                     .
                  /*
                  if not (base_rpt = "" and not mixed_rpt) then 
                     ASSIGN
                     ttxxarparp0001_ar_curr = ar_mstr.ar_curr
                     .
                  else
                     ASSIGN 
                        ttxxarparp0001_ar_curr = base_curr
                        .
                  */
                  ASSIGN
                     ttxxarparp0001_ar_curr = ar_mstr.ar_curr
                     .
                  /*
                  if base_rpt = "" and not mixed_rpt THEN do:
                     ASSIGN
                        ttxxarparp0001_ar_amt = (- base_amt)
                        .
                  end.
                  ELSE do:
                      ASSIGN
                          ttxxarparp0001_ar_amt = (- ar_mstr.ar_amt)
                          .
                  end.
                  */
                  ASSIGN
                     ttxxarparp0001_ar_base_amt = (- base_amt)
                     ttxxarparp0001_ar_amt = (- ar_mstr.ar_amt)
                     .
                  /* SS - 100705.1 - E */

                  /* SS - 100705.1 - B
                  {&ARPARPA-P-TAG45}
                  display
                     (if ard_type = "N"
                     or ard_type = "U"
                     then ard_tax /* N/U REFERENCE */
                     else ard_ref)
                     @ ard_ref
                     type
                     ard_entity
                     ard_acct
                     ard_sub
                     ard_cc
                  with frame e.

                  if (base_rpt = ""
                      and mixed_rpt
                      and disp_curr = getTermLabel("YES",1))
                     or base_rpt = ar_mstr.ar_curr
                  then do:
                     assign
                        base_damt:format = curr_amt_fmt
                        base_disc:format = curr_amt_fmt
                        disp_curr = "".
                     display disp_curr
                        ard_amt @ base_damt
                        ard_disc @ base_disc.
                  end.
                  else
                     do:
                     assign
                        base_damt:format = base_amt_fmt
                        base_disc:format = base_amt_fmt.
                     display disp_curr
                        base_damt
                        base_disc.
                  end.

                  /* DETERMINE FORMATTING TO BE BASE OR CURR */

                  if (base_rpt = "" and mixed_rpt) or
                     base_rpt = ar_mstr.ar_curr
                     then
                  assign
                     aramt:format  = curr_amt_fmt
                     unamt:format  = curr_amt_fmt
                     nonamt:format = curr_amt_fmt.
                  else
                  assign
                     aramt:format  = base_amt_fmt
                     unamt:format  = base_amt_fmt
                     nonamt:format = base_amt_fmt.
                  SS - 100705.1 - E */
                  /* SS - 100705.1 - B */
                  IF ard_type = "N" OR ard_type = "U" THEN
                      ASSIGN
                      ttxxarparp0001_ard_ref = ard_tax
                      .
                  ELSE
                      ASSIGN
                      ttxxarparp0001_ard_ref = ard_ref
                      .
      
                  ASSIGN
                      ttxxarparp0001_ard_type = ard_type
                      ttxxarparp0001_ard_type_desc = TYPE
                      ttxxarparp0001_ard_entity = ard_entity
                      ttxxarparp0001_ard_acct = ard_acct
                      ttxxarparp0001_ard_sub = ard_sub
                      ttxxarparp0001_ard_cc = ard_cc
                      .
                  if (base_rpt = ""
                      and mixed_rpt
                      and disp_curr = getTermLabel("YES",1))
                     or base_rpt = ar_mstr.ar_curr
                  then do:
                      ASSIGN
                          DISP_curr = ""
                          .
                  end.
                  ASSIGN
                     ttxxarparp0001_disp_curr = DISP_curr
                     ttxxarparp0001_ard_amt = ard_amt
                     ttxxarparp0001_ard_disc = ard_disc
                     ttxxarparp0001_ard_base_amt = base_damt
                     ttxxarparp0001_ard_base_disc = base_disc
                     .
                  /* SS - 100705.1 - E */

                  if ard_type <> "N" then do:
                     aramt = base_glar_amt.

                     /* SS - 100705.1 - B
                     if  base_rpt       = ""
                     and mixed_rpt
                     and basepayforeign = false
                     then
                        display (ard_amt + ard_disc) @ aramt.
                     else
                        display aramt.
                        accumulate (ard_amt + ard_disc) (total).
                        accumulate aramt (total).
                     SS - 100705.1 - E */
                     /* SS - 100705.1 - B */
                     ASSIGN 
                        ttxxarparp0001_aramt = (ard_amt + ard_disc)
                        ttxxarparp0001_base_aramt = aramt
                        .
                     /* SS - 100705.1 - E */
                  end.
                  /* SS - 100705.1 - B
                  else display 0 @ aramt.
                  SS - 100705.1 - E */
                  /* SS - 100705.1 - B */
                  ELSE ASSIGN ttxxarparp0001_aramt = 0.
                  /* SS - 100705.1 - E */

                  if ard_type = "U"
                  then do:
                     unamt = base_damt.

                     if not l_unassign
                     then do:

                        do for appl:
                           assign b_appl_amt = 0
                                  c_appl_amt = 0.
                           for each appl
                              fields( ar_domain ar_check ar_bill ar_xslspsn1 ar_type                                  ar_base_amt ar_amt)
                              where appl.ar_domain   = global_domain
                              and   appl.ar_check    = ar_mstr.ar_check
                              and   appl.ar_bill     = ar_mstr.ar_bill
                              and   appl.ar_xslspsn1 = ard_det.ard_tax
                              and   appl.ar_type     = "A"
                           no-lock:
                              assign b_appl_amt = b_appl_amt + appl.ar_base_amt
                                     c_appl_amt = c_appl_amt + appl.ar_amt.
                           end. /* FOR EACH appl */
                        end. /* DO FOR appl */

                        if     ar_mstr.ar_curr <> gl_base_curr
                           and base_rpt        <> ""
                        then
                           unamt = base_damt - c_appl_amt.
                        else
                           unamt = base_damt - b_appl_amt.

                        /* SS - 100705.1 - B
                        if     base_rpt = ""
                           and mixed_rpt
                        then
                           display (ard_amt - c_appl_amt) @ unamt.
                        else
                           display unamt.

                        accumulate c_unamt (total).
                        accumulate unamt (total).
                        SS - 100705.1 - E */
                        /* SS - 100705.1 - B */
                        ASSIGN 
                           ttxxarparp0001_unamt = (ard_amt - c_appl_amt)
                           ttxxarparp0001_base_unamt = unamt
                           .
                        /* SS - 100705.1 - E */
                     end. /* IF NOT l_unassign */
                     else do:
                        /* SS - 100705.1 - B
                        if     base_rpt = ""
                           and mixed_rpt
                        then
                           display ard_amt @ unamt.
                        else
                           display unamt.

                        accumulate unamt(total).
                        SS - 100705.1 - E */
                        /* SS - 100705.1 - B */
                        ASSIGN 
                           ttxxarparp0001_unamt = ard_amt
                           ttxxarparp0001_base_unamt = unamt
                           .
                        /* SS - 100705.1 - E */
                     end. /* IF l_unassign */
                  end. /* IF ard_type = "U" */
                  else
                     /* SS - 100705.1 - B
                     display 0 @ unamt.
                     SS - 100705.1 - E */
                     /* SS - 100705.1 - B */
                     ASSIGN ttxxarparp0001_unamt = 0.
                     /* SS - 100705.1 - E */

                  if ard_type = "N" then do:
                     nonamt = base_damt.
                     /* SS - 100705.1 - B
                     if base_rpt = ""
                        and mixed_rpt
                        then display ard_amt @ nonamt.
                     else display nonamt.
                     accumulate c_nonamt (total).
                     accumulate nonamt (total).
                     SS - 100705.1 - E */
                     /* SS - 100705.1 - B */
                     ASSIGN 
                        ttxxarparp0001_nonamt = ard_amt
                        ttxxarparp0001_base_nonamt = nonamt
                        .
                     /* SS - 100705.1 - E */
                  end.
                  /* SS - 100705.1 - B
                  else display 0 @ nonamt.

                  down 1.
                  SS - 100705.1 - E */
                  /* SS - 100705.1 - B */
                  else ASSIGN ttxxarparp0001_nonamt = 0.
                  /* SS - 100705.1 - E */
               end.

               /* SS - 100705.1 - B
               if gltrans then do:
                  assign
                     tot-vtadj = 0
                     tot-vtcurradj = 0.
                  /* GET TAX TOTALS */
                  {gprun.i ""txtotal.p"" "(input  tax_tr_type,
                       input  ard_det.ard_nbr,
                       input  ard_det.ard_ref,
                       input  tax_lines,
                       output tot-vtcurradj)"}
                  /* TAX MANAGEMENT ADJUSTMENTS ARE NEGATIVE VALUES */
                  assign
                     tot-vtcurradj = - tot-vtcurradj
                     tot-vtadj = tot-vtcurradj.
                  if available armstr then do:
                     if base_curr <> armstr.ar_curr then
                  do:
                        /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                        {gprunp.i "mcpl" "p" "mc-curr-conv"
                           "(input armstr.ar_curr,
                             input base_curr,
                             input ar_mstr.ar_ex_rate,
                             input ar_mstr.ar_ex_rate2,
                             input tot-vtadj,
                             input false, /* DO NOT ROUND */
                             output tot-vtadj,
                             output mc-error-number)"}.
                        if mc-error-number <> 0 then do:
                           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}.
                        end.

                     end.
                  end.

                  find first gltw_wkfl  where gltw_wkfl.gltw_domain = global_domain
                  and  gltw_ref = ar_mstr.ar_bill
                     and gltw_line = save_line
                  exclusive-lock no-error.
                  if available gltw_wkfl then do:
                     gltw_amt = gltw_amt + base_glar_amt.
                     release gltw_wkfl.
                  end.

                  {gpnextln.i &ref=ar_mstr.ar_bill &line=return_int}
                  create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
                  assign
                     gltw_entity = ard_entity
                     gltw_acct = ard_acct
                     gltw_sub = ard_sub
                     gltw_cc = ard_cc
                     {&ARPARPA-P-TAG46}
                     gltw_ref = ar_mstr.ar_bill
                     gltw_line = return_int
                     gltw_date = ar_mstr.ar_date
                     gltw_effdate = ar_mstr.ar_effdate
                     gltw_userid = mfguser
                     gltw_desc = ar_mstr.ar_batch + " " +
                     ar_mstr.ar_type + " " + ar_mstr.ar_nbr
                     gltw_amt = - base_glar_amt
                     recno = recid(gltw_wkfl).

                  if (base_rpt = "" or base_rpt = base_curr) then
                     base_gl_disc = base_disc - tot-vtadj.
                  else base_gl_disc = base_disc - tot-vtcurradj.

                  if base_gl_disc <> 0 then do:

                     find first gltw_wkfl  where gltw_wkfl.gltw_domain =
                     global_domain and  gltw_ref = ar_mstr.ar_bill
                        and gltw_line = save_line
                     exclusive-lock no-error.
                     if available gltw_wkfl then do:
                        gltw_amt = gltw_amt - base_disc.
                        release gltw_wkfl.
                     end.

                     {&ARPARPA-P-TAG9}
                     {gpnextln.i &ref=ar_mstr.ar_bill &line=return_int}
                     create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
                     assign
                        gltw_entity = ard_entity
                        gltw_acct = ar_mstr.ar_disc_acct
                        gltw_sub = ar_mstr.ar_disc_sub
                        gltw_cc = ar_mstr.ar_disc_cc
                        gltw_ref = ar_mstr.ar_bill
                        gltw_line = return_int
                        gltw_date = ar_mstr.ar_date
                        gltw_effdate = ar_mstr.ar_effdate
                        gltw_userid = mfguser
                        gltw_desc = ar_mstr.ar_batch + " "
                        + ar_mstr.ar_type + " "
                        + ar_mstr.ar_nbr
                        gltw_amt = base_gl_disc
                        recno = recid(gltw_wkfl).
                     {&ARPARPA-P-TAG10}
                  end.

                  if base_curr <> ar_mstr.ar_curr
                     or basepayforeign = yes or foreignpayforeign then do:
                     if (base_rpt = "" or  base_rpt = base_curr) then
                     gain_amt = base_glar_amt - base_damt - base_gl_disc
                     - tot-vtadj.
                     else
                     gain_amt = base_glar_amt - base_damt - base_gl_disc
                     - tot-vtcurradj.

                     if basepayforeign = no and foreignpayforeign = no and
                        base_rpt = ar_mstr.ar_curr then
                        gain_amt = 0.

                     if gain_amt <> 0 then do:

                        find first gltw_wkfl  where gltw_wkfl.gltw_domain =
                        global_domain and  gltw_ref = ar_mstr.ar_bill
                           and gltw_line = save_line
                        exclusive-lock no-error.
                        if available gltw_wkfl then do:
                           gltw_amt = gltw_amt - gain_amt.
                           release gltw_wkfl.
                        end.

                        {gpnextln.i &ref=ar_mstr.ar_bill &line=return_int}
                        create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
                        assign
                           gltw_entity  = ar_mstr.ar_entity
                           gltw_acct    = ar_mstr.ar_var_acct
                           gltw_sub     = ar_mstr.ar_var_sub
                           gltw_cc      = ar_mstr.ar_var_cc
                           gltw_ref     = ar_mstr.ar_bill
                           gltw_line    = return_int
                           gltw_date    = ar_mstr.ar_date
                           gltw_effdate = ar_mstr.ar_effdate
                           gltw_userid  = mfguser
                           gltw_desc    = ar_mstr.ar_batch + " "
                           + ar_mstr.ar_type + " "
                           + ar_mstr.ar_nbr
                           gltw_amt    = gain_amt
                           recno       = recid(gltw_wkfl).
                     end.
                  end.

                  if tot-vtcurradj <> 0 then do:
                     gen_desc = ar_mstr.ar_batch + " " + ar_mstr.ar_type.
                     {gpnextln.i &ref=ar_mstr.ar_bill &line=return_int}
                     if (base_rpt = "" or
                        base_rpt = base_curr) then
                        curr_to_pass = base_curr.
                     else curr_to_pass = base_rpt.

                     /* CHANGED "not arc_gl_sum" TO "arc_sum_lvl" */
                     /* ADDED SECOND EXCHANGE RATE, TYPE, SEQUENCE */
                     {&ARPARPA-P-TAG11}
                     {gprun.i ""txglpost.p"" "(
                          input tax_tr_type         /* TRANSACTION TYPE */,
                          {&ARPARPA-P-TAG67}        /* SALES ORDER NUMBER */
                          input ard_det.ard_nbr     /* REFERENCE */,
                          input ard_det.ard_ref     /* NUMBER */,
                          input curr_to_pass        /* REPORT CURRENCY */,
                          input ar_mstr.ar_bill     /* GL REFERENCE NUMBER */,
                          input ar_mstr.ar_effdate  /* EFFECTIVE DATE */,
                          input ar_mstr.ar_ex_rate  /* EXCHANGE RATE */,
                          input ar_mstr.ar_ex_rate2,
                          input ar_mstr.ar_ex_ratetype,
                          input ar_mstr.ar_exru_seq,
                          input ar_mstr.ar_batch    /* BATCH */,
                          input 'AR'                /* MODULE */,
                          input gen_desc            /* TRANS. DESCRIPTION */,
                          input false               /* POST */,
                          input arc_sum_lvl         /* SUMM LEVEL */,
                          input true                /* AUDIT TRAIL */,
                          input false               /* REPORT IN DETAIL */,
                          input ''                  /* PROJECT*/,
                          input ar_mstr.ar_type     /* TYPE OF DOCUMENT */,
                          input ar_mstr.ar_ship     /* ADDRESS */,
                          input gen_desc            /* GLTW_WKFL TYPE */,
                          input -1                  /* POSTING SIGN */
                          )" }
                     {&ARPARPA-P-TAG12}
                     find last gltw_wkfl  where gltw_wkfl.gltw_domain = global_domain
                     and  gltw_ref = ar_mstr.ar_bill
                        and gltw_line = return_int
                        and gltw_userid = mfguser no-error.
                     if available gltw_wkfl then
                     assign
                        gltw_date = ar_mstr.ar_date
                        gltw_effdate = ar_mstr.ar_effdate
                        recno = recid(gltw_wkfl).
                  end. /* IF tot-vtcurradj <> 0 */

                  {&ARPARPA-P-TAG66}

                  /* FOR INTERCOMPANY TRANSACTIONS */
                  /* CHECK FOR MEMO/INVOICE & PAYMENT ENTITIES                  */
                  /* FOR UNAPPLIED & NON-AR, CHECK FOR HEADER & DETAIL ENTITIES */
                  if ((available armstr
                     and armstr.ar_entity  <> ar_mstr.ar_entity)
                     or   ar_mstr.ar_entity <> ard_entity)
                  then do:
                     {glenacex.i &entity=ard_entity
                        &type='"CR"'
                        &module='"AR"'
                        &acct=ico_acct
                        &sub=ico_sub
                        &cc=ico_cc }

                     /* CREDIT HEADER ENTRY - PAYMENT ENTITY */
                     {gpnextln.i &ref=ar_mstr.ar_bill &line=return_int}
                     create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
                     assign
                        gltw_entity  = ar_mstr.ar_entity
                        gltw_acct    = ico_acct
                        gltw_sub     = ico_sub
                        gltw_cc      = ico_cc
                        gltw_ref     = ar_mstr.ar_bill
                        gltw_line    = return_int
                        gltw_date    = ar_mstr.ar_date
                        gltw_effdate = ar_mstr.ar_effdate
                        gltw_userid  = mfguser
                        gltw_desc    = ar_mstr.ar_batch  + " "
                        + ar_mstr.ar_type + " "
                        + ar_mstr.ar_nbr
                        gltw_amt     = - base_damt
                        recno        = recid(gltw_wkfl).

                     /* DEBIT DETAIL ENTRY - INVOICE/MEMO ENTITY */
                     {glenacex.i &entity=ar_mstr.ar_entity
                        &type='"DR"'
                        &module='"AR"'
                        &acct=ico_acct
                        &sub=ico_sub
                        &cc=ico_cc }
                     {gpnextln.i &ref=ar_mstr.ar_bill &line=return_int}
                     create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
                     assign
                        gltw_entity  = if available armstr
                        then
                        armstr.ar_entity
                        else
                        ard_entity
                        gltw_acct    = ico_acct
                        gltw_sub     = ico_sub
                        gltw_cc      = ico_cc
                        gltw_ref     = ar_mstr.ar_bill
                        gltw_line    = return_int
                        gltw_date    = ar_mstr.ar_date
                        gltw_effdate = ar_mstr.ar_effdate
                        gltw_userid  = mfguser
                        gltw_desc    = ar_mstr.ar_batch  + " "
                        + ar_mstr.ar_type + " "
                        + ar_mstr.ar_nbr
                        gltw_amt     = base_damt
                        recno        = recid(gltw_wkfl).
                  end. /* IF armstr.ar_entity AND... */
               end.  /* gltrans */
               SS - 100705.1 - E */
            end.  /* ard_det loop */

            /* SS - 100705.1 - B
            accumulate (accum total  (nonamt)) (total by ar_mstr.ar_batch).
            accumulate (accum total  (unamt)) (total by ar_mstr.ar_batch).
            accumulate (accum total  (aramt)) (total by ar_mstr.ar_batch).
            accumulate (accum total  (base_disc)) (total by ar_mstr.ar_batch).
            accumulate (accum total  (base_damt)) (total by ar_mstr.ar_batch).

            {&ARPARPA-P-TAG47}
            {&ARPARPA-P-TAG48}
            if detlines > 1 and not summary then do with frame e:
               {&ARPARPA-P-TAG49}
               if page-size - line-counter < 4 then page.
               {&ARPARPA-P-TAG50}
               underline base_damt base_disc aramt unamt nonamt.
               {&ARPARPA-P-TAG51}

               if base_rpt = "" and mixed_rpt
                  then
                  {&ARPARPA-P-TAG52}
               display skip
                  ar_mstr.ar_curr @ ard_ref
                  getTermLabel("PAYMENT",7) @ type
                  getTermLabelRtColon("TOTALS",7) @  ard_acct
                  accum total (ard_amt) @ base_damt
                  accum total (ard_disc) @ base_disc
                  accum total (ard_amt + ard_disc) @ aramt
                  accum total (c_unamt) @ unamt
                  accum total (c_nonamt) @ nonamt
                  skip.
               {&ARPARPA-P-TAG53}

               else
               {&ARPARPA-P-TAG54}
               display
                  skip(0)
                  base_rpt @ ard_ref
                  getTermLabel("PAYMENT",7) @ type
                  getTermLabelRtColon("TOTALS",7) @  ard_acct
                  accum total (base_damt) @ base_damt
                  accum total (base_disc) @ base_disc
                  accum total (aramt) @ aramt
                  accum total (unamt) @ unamt
                  accum total (nonamt) @ nonamt
                  skip.
               {&ARPARPA-P-TAG55}

            end.
            if last-of(ar_mstr.ar_batch) then do:
               if page-size - line-counter < 4 then page.
               /* RESET SESSION FOR BASE CURR */
               SESSION:numeric-format = oldsession.
               if summary then do with frame c:
                  down 2.
                  underline base_amt.

                  if base_rpt = "" then
                     base_amt:format = base_amt_fmt.
                  else
                     base_amt:format = curr_amt_fmt.

                  assign
                     c-base-rpt-lbl1 =
                     getTermLabelRtColon("BASE_BATCH_TOTAL",28)
                     c-base-rpt-lbl2 =
                     getTermLabelRtColon("BATCH_TOTAL",24).

                  display
                     (if base_rpt = ""
                     then c-base-rpt-lbl1
                     else
                     base_rpt + " " + c-base-rpt-lbl2 )
                     @ ar_po
                     accum total by ar_mstr.ar_batch
                     (accum total base_damt) @ base_amt
                     skip.

               end.
               {&ARPARPA-P-TAG56}
               else do with frame e:
                  down 2.
                  underline base_damt base_disc aramt unamt nonamt.
                  {&ARPARPA-P-TAG57}

                  if base_rpt = "" then
                  assign
                     base_damt:format = base_amt_fmt
                     base_disc:format = base_amt_fmt
                     aramt:format     = base_amt_fmt
                     unamt:format     = base_amt_fmt
                     nonamt:format    = base_amt_fmt.
                  else
                  assign
                     base_damt:format = curr_amt_fmt
                     base_disc:format = curr_amt_fmt
                     aramt:format     = curr_amt_fmt
                     unamt:format     = curr_amt_fmt
                     nonamt:format    = curr_amt_fmt.

                  assign
                     c-base-rpt-lbl1 = getTermLabel("BASE",8).

                  {&ARPARPA-P-TAG58}
                  display
                     (if base_rpt = ""
                     then c-base-rpt-lbl1
                     else base_rpt)
                     @ ard_ref
                     getTermLabel("BATCH",7) @ type
                     getTermLabelRtColon("TOTALS",7) @  ard_acct
                     accum total by ar_mstr.ar_batch
                     (accum total base_damt) @ base_damt
                     accum total by ar_mstr.ar_batch
                     (accum total base_disc) @ base_disc
                     accum total by ar_mstr.ar_batch
                     (accum total aramt) @ aramt
                     accum total by ar_mstr.ar_batch
                     (accum total unamt) @ unamt
                     accum total by ar_mstr.ar_batch
                     (accum total nonamt) @ nonamt
                     skip.
                  {&ARPARPA-P-TAG59}

                     l_base_damt1 = accum total (accum total base_damt).
                     l_base_disc1 = accum total (accum total base_disc).
                     l_aramt1     = accum total (accum total aramt).
                     l_unamt1     = accum total (accum total unamt).
                     l_nonamt1    = accum total (accum total nonamt).

               end.
            end.  /* batch totals */
            SS - 100705.1 - E */
         end. /* IF NOT (NOT l_unassign) */
      end. /* IF AVAILABLE ard_det */

      /* RESET SESSION IF BASE_RPT <> BASE */
      if not (base_rpt = "" and not mixed_rpt)
         then SESSION:numeric-format = c_session.
      {mfrpchk.i}
   end. /* for each ar_mstr */

   /* SS - 100705.1 - B
   if l_yn then do:   /* REPORT TOTALS */
      /* RESET SESSION FOR BASE CURR */
      SESSION:numeric-format = oldsession.
      if page-size - line-counter < 4 then page.
      if summary then do with frame c:
         down 2.
         underline base_amt.

         display
            (if base_rpt = ""
            then getTermLabelRtColon("BASE_REPORT_TOTAL",28)
            else base_rpt +  " " +
            getTermLabelRtColon("REPORT_TOTAL",14))
            @ ar_po
            l_base_damt1 @ base_amt.

      end. /* IF SUMMARY */
      {&ARPARPA-P-TAG60}
      else do with frame e:
         down 2.
         underline base_damt base_disc aramt unamt nonamt.

         display
            (if base_rpt = ""
            then getTermLabel("BASE",8)
            else base_rpt)
            @ ard_ref
            getTermLabel("REPORT",7) @ type
            getTermLabelRtColon("TOTALS",8) @  ard_acct
            l_base_damt1 @ base_damt
            l_base_disc1 @ base_disc
            l_aramt1     @ aramt
            l_unamt1     @ unamt
            l_nonamt1    @ nonamt.
         {&ARPARPA-P-TAG61}

      end. /* ELSE DO */
   end. /* IF l_yn */ /* REPORT TOTALS */
   SS - 100705.1 - E */
   
   {&ARPARPA-P-TAG62}
end.  /* do with frame e */
{&ARPARPA-P-TAG63}
SESSION:numeric-format = oldsession.
{wbrp04.i}
