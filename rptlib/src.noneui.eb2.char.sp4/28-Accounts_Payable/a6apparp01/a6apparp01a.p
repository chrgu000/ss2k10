/* apparpa.p - AP PAYMENT SELECTION REGISTER (part II)                       */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.19.1.22 $                                                      */
/*V8:ConvertMode=Report                                                      */
/* PROGRAM SPLIT FROM APPARP.P                                               */
/* VERSION: 7.4             CREATED: 04/28/94   by: srk *FN21*               */
/*                    LAST MODIFIED: 06/29/94   by: bcm *H415*               */
/*                                   09/24/94   by: srk *GM81*               */
/*                                   01/11/95   by: str *F0DF*               */
/*                                   02/02/95   by: str *H0B3*               */
/*                                   04/19/95   by: jzw *F0QR*               */
/*                                   05/19/95   by: jzw *H0DN*               */
/* REVISION: 8.5      LAST MODIFIED: 07/11/95   by: cdt *J057*               */
/*                                   10/30/95   by: mys *G1BG*               */
/*                                   12/24/95   by: mwd *J053*               */
/*                                   04/05/96   by: jzw *G1LD*               */
/*                                   05/07/96   by: wjk *G1TW*               */
/*                                   07/22/96   by: *G29N* Sanjay Patil      */
/* REVISION: 8.6      LAST MODIFIED: 11/19/96   by: jpm *K020*               */
/*                                   02/18/97   by: bkm *J1HZ*               */
/*                                   03/24/97   by: rxm *J1LJ*               */
/* REVISION: 8.6      LAST MODIFIED: 10/23/97   BY: ckm *K15P*               */
/* REVISION: 8.6      LAST MODIFIED: 01/30/98   BY: *J2CP* Irine D'mello     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 03/31/98   BY: *J2D8* Kawal Batra       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* Pre-86E commented code removed, view in archive revision 1.10             */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton      */
/* REVISION: 8.6E     LAST MODIFIED: 08/19/98   BY: *L06B* Jeff Wootton      */
/* REVISION: 8.6E     LAST MODIFIED: 09/18/98   BY: *J30B* Santhosh Nair     */
/* REVISION: 8.6E     LAST MODIFIED: 10/09/98   BY: *L0BM* Steve Goeke       */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 06/08/99   BY: *N00G* Jean Miller       */
/* REVISION: 9.1      LAST MODIFIED: 08/25/99   BY: *L0H7* Ranjit Jain       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 05/05/00   BY: *N08H* Veena Lad         */
/* REVISION: 9.1      LAST MODIFIED: 06/07/00   BY: *N0C9* Inna Lyubarsky    */
/* REVISION: 9.1      LAST MODIFIED: 08/02/00   BY: *L11Y* Shilpa Athalye    */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 08/21/00   BY: *N0MH* Arul Victoria     */
/* REVISION: 9.1      LAST MODIFIED: 10/27/00   BY: *N0TF* Katie Hilbert     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.19.1.16     BY: Ed van de Gevel  DATE: 11/05/01  ECO: *N15M* */
/* Revision:               BY: Ashish M.        DATE: 03/11/02  ECO: *N1C8* */
/* Revision: 1.19.1.20     BY: Lena Lim         DATE: 06/12/02  ECO: *P089* */
/* Revision: 1.19.1.21     BY: Hareesh V.       DATE: 06/21/02  ECO: *N1HY* */
/* $Revision: 1.19.1.22 $    BY: Orawan S.               DATE: 04/23/03  ECO: *P0QH* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*****************************************************************************/
/* BY: Micho Yang    DATE: 08/22/06 ECO: *SS - 20060825.1*   */
/* SS - 200600824.1 B */
/*
"1.仅包括以下状态""2 - 选择确认""
2.立即更新状态为""3 - 提交""
3.保存响应代码和消息,并相应的更新状态
4.如果超时,更新状态"
*/
{a6apparp01.i}
/* SS - 200600824.1 E */

{mfdeclre.i}
{cxcustom.i "APPARPA.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}
{pxphdef.i appmtxr}


/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apparpa_p_2 "Sort Vouchers by Amount"
/* MaxLen: Comment: */

&SCOPED-DEFINE apparpa_p_7 "Print Remarks"
/* MaxLen: Comment: */

&SCOPED-DEFINE apparpa_p_8 "Check Date"
/* MaxLen: 10 Comment: */

&SCOPED-DEFINE apparpa_p_10 "Nbr of Payments"
/* MaxLen: Comment: */

&SCOPED-DEFINE apparpa_p_11 "Account Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE apparpa_p_13 "Nbr of Vouchers"
/* MaxLen: Comment: */

&SCOPED-DEFINE apparpa_p_21 "Invalid Bank Accts"
/* MaxLen: Comment: */

&SCOPED-DEFINE apparpa_p_22 "Gross Amount"
/* MaxLen: Comment: */

&SCOPED-DEFINE apparpa_p_23 "Hash Total"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* ADDED NO-UNDO, ASSIGN THROUGHOUT */

{wbrp02.i}

define shared variable base_rpt   like ap_curr  no-undo.
define shared variable bank       like ap_bank  no-undo.
define shared variable check_rate like vo_ex_rate  no-undo.
define shared variable check_rate2 like vo_ex_rate2 no-undo.

define shared variable print_rmk  like mfc_logical
   label {&apparpa_p_7}
   initial yes  no-undo.
define shared variable sort_by_amount like mfc_logical
   label {&apparpa_p_2}
   initial yes no-undo.
define shared variable print_date like ap_date
   label {&apparpa_p_8}
   initial today  no-undo.

define shared variable ckfrm      like ap_ckfrm  no-undo.
define shared variable bk_val     like mfc_logical  no-undo.
define shared variable bankacct1  as decimal  no-undo.
define shared variable bk1_ok     as logical  no-undo.
define shared variable bk2_ok     as logical  no-undo.
define shared variable isvalid    like mfc_logical  no-undo.
define shared variable bk_acct1   like ad_bk_acct1  no-undo.
define shared variable bk_acct2   like ad_bk_acct1  no-undo.

define shared variable bk_acct_type      like ad_addr format "x(3)"
   label {&apparpa_p_11}  no-undo.
define shared variable bk_acct_type_code like ad_addr
   initial "2"  no-undo.  /* PRT */
define shared variable bk_acct_type_desc like glt_desc  no-undo.
define new shared variable rndmthd       like rnd_rnd_mthd .
define variable old_curr                 like vo_curr  no-undo.
define variable doc_amt_fmt  as character
   initial "->>>>,>>>,>>9.99"  no-undo.
define variable doc_disc_fmt as character
   initial "->>>,>>>,>>9.99"  no-undo.
define variable tot_amt_fmt  as character
   initial "->>>>>,>>>,>>9.99"  no-undo.
define variable tot_disc_fmt as character
   initial "->>>>,>>>,>>9.99"  no-undo.

define variable remit-label  as character format "x(10)" no-undo.
define variable remit-name   like ad_name no-undo.

define new shared variable fname  like lngd_dataset no-undo
   initial "csbd_det".

define variable name           like ad_name  no-undo.
define variable type           like ap_type format "x(4)"  no-undo.
define variable vend_detail    as integer  no-undo.
define variable vend_amt_chg   like ap_amt  no-undo.
define variable tot_amt_chg    like ap_amt  no-undo.
define variable hold           as character format "x(2)"  no-undo.
define variable base_disc_chg  like vo_disc_chg  no-undo.
define variable base_amt_chg   like vo_amt_chg  no-undo.
define variable disp_curr      as character format "x(1)"
   label "C"  no-undo.
define variable separate       as character format "x(1)"  no-undo.
define variable vend_sep_chg   like vend_amt_chg  no-undo.
define variable gross_amt      like ap_amt
   label {&apparpa_p_22}  no-undo.
define variable tot_nbr_pay    as integer
   label {&apparpa_p_10}  no-undo.
define variable tot_nbr_vch    as integer
   label {&apparpa_p_13}  no-undo.
define variable tot_invalid    as integer
   label {&apparpa_p_21}  no-undo.
define variable tot_nbr_sep    as integer no-undo.
define variable sep_updated    as logical no-undo.
define variable frst_non_sep   as logical no-undo.
define variable hash_total     as decimal
   format "->>>>>>>>>>>>>>>>>>>>>>>>999"
   label {&apparpa_p_23}  no-undo.
define variable checkfield     as character format "x"  no-undo.
define variable bankno         as decimal  no-undo.

define variable disp_bankno    like ad_bk_acct1 no-undo.
define variable i              as integer  no-undo.
define variable i2             as integer  no-undo.
define variable city           like ad_city  no-undo.
define variable controle_ok    as logical  no-undo.
define variable giro_msg       as character format "x(40)"  no-undo.
define variable bank_msg       as character format "x(40)"  no-undo.
define variable invalid_vendor like mfc_logical  no-undo.
define variable vopo           like vpo_po  no-undo.
define variable warn_msg       like msg_desc  no-undo.
define variable mc-error-number like msg_nbr no-undo.

/* VARIABLE TO STORE BANK ACCOUNT SO THAT LEADING ZEROS ARE  */
/* RETAINED FOR CHECK FORM "3" and "4" AND                   */
/* BANK ACCOUNT VALIDATION AS BLANK                          */
define variable l_bankno       like bk_bk_acct1 format "x(24)" no-undo.
define variable l_msgdesc      like msg_desc no-undo.

/* SS - 200600824.1 B */
/*
{&APPARPA-P-TAG1}
remit-label=getTermLabelRtColon("REMIT-TO",10).
*/
/* SS - 200600824.1 E */

define variable c-footer-var1 as character no-undo.

form header
   skip(1)

   space(1) c-footer-var1 format "x(64)"
   skip

   space(1)
   l_msgdesc
with frame pfoot page-bottom
   width 132.

/* S - INDICATES VOUCHERS TO BE PAID WITH SEPARATE CHECK */
{pxmsg.i &MSGNUM=3547 &MSGBUFFER=l_msgdesc}

/* HD - Indicates Vouchers With Amounts On Hold */
{pxmsg.i &MSGNUM=3642 &MSGBUFFER=c-footer-var1}

/* SS - 200600824.1 B */
/* view frame pfoot. */
/* SS - 200600824.1 E */

for first gl_ctrl
   fields (gl_bk_val gl_rnd_mthd) no-lock:
end.

for first bk_mstr
   fields (bk_code bk_curr)
   where bk_code = bank no-lock:
end.

assign
   tot_amt_chg  = 0
   tot_nbr_pay  = 0
   tot_nbr_vch  = 0
   hash_total   = 0
   tot_invalid  = 0
   tot_nbr_sep  = 0
   frst_non_sep = yes.

/*message "vd_mstr bigin" view-as alert-box.*/

vdloop:
for each vd_mstr
      fields (vd_addr vd_hold vd_misc_cr vd_remit vd_sort)
   no-lock use-index vd_sort,
      each ap_mstr
      fields (ap_amt ap_bank ap_ckfrm ap_curr ap_effdate ap_open
      ap_ref ap_remit ap_rmk ap_type ap_vend)
      where ap_open  = yes
      and ap_vend    = vd_addr
      and (ap_type   = "VO" )

      and ( ap_bank  = bank )
      and (ap_ckfrm  = ckfrm )
      and ((ap_curr  = base_rpt)
      or (base_rpt = ""))
   no-lock use-index ap_vend,
      each vo_mstr
      fields (vo_amt_chg vo_curr vo_disc_chg vo_disc_date
      vo_due_date vo_ex_rate
      vo_ex_rate2
      vo_base_amt_chg vo_base_disc_chg
      vo_base_ndisc vo_ex_ratetype
      vo_hold_amt vo_invoice
      {&APPARPA-P-TAG2}
      vo_po vo_ref vo_separate vo__qad02)
      where vo_ref = ap_ref
      and (vo_amt_chg <> 0 or vo_disc_chg <> 0)
   no-lock
      break by vd_sort
      by ap_vend
      by ap_curr
      by vo__qad02
      by (if sort_by_amount then "" else ap_ref)
      by ap_amt descending
      {&APPARPA-P-TAG3}
   with frame c width 132 down:
   {&APPARPA-P-TAG4}

      /* SS - 200600824.1 B */
      /*
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame c:handle).
   */
      /* SS - 200600824.1 E */

   if first-of(ap_vend) then do:
      assign
         vend_detail  = 0
         vend_amt_chg = 0
         vend_sep_chg = 0.
   end. /* FIRST-OF AP_VEND */
   if first-of(vo__qad02) then do:
      /* GET BANK- OR GIRO ACCOUNT */
      /*VALIDATE BANK ACCT WITH 11 CHECK IF FILE AND BKVAL = 11*/
      if ap_ckfrm <> "" and lookup(ap_ckfrm,"1,2,5,6,7") = 0
         and (gl_bk_val = "11" or gl_bk_val = "12") then bk_val = yes.
      else bk_val = no.

      for first ad_mstr
         fields (ad_addr ad_city ad_name)
         where ad_addr = vd_addr no-lock:
      end.

      assign
         bankno      = 0
         disp_bankno = " "
         giro_msg    = " "
         bank_msg    = " ".

      if available ad_mstr then do:
         /* FIND BANKACCT OF THE VENDOR */

         for first csbd_det
            fields (csbd_addr csbd_bank csbd_beg_date
            csbd_bk_acct csbd_end_date csbd_type)
            where csbd_bank = vo__qad02
            and csbd_addr = ap_vend
            and csbd_type = bk_acct_type_code
            and csbd_beg_date <= ap_effdate
            and csbd_end_date >= ap_effdate
         no-lock:
         end.

         if not available csbd_det then do:
            /* PICK UP DEFAULT BANK ACCOUNT */

            for first csbd_det
               fields (csbd_addr csbd_bank csbd_beg_date
               csbd_bk_acct csbd_end_date csbd_type)
               where csbd_bank = vo__qad02
               and csbd_addr = ap_vend and csbd_type = "1"
               and csbd_beg_date <= ap_effdate
               and csbd_end_date >= ap_effdate no-lock:
            end.

            /* CHECK FOR VALID BANK IF INPUT ACCOUNT TYPE "ALL" */
            /* IS NOT THERE FOR THE SUPPLIER.                   */
            if not available csbd_det and
               bk_acct_type_code = "1"
            then do:

               if lookup(ckfrm,"3,4") <> 0
               then do:
                  /* LOOK FOR TYPE EDI = 3 */
                  for first csbd_det
                     fields (csbd_addr    csbd_bank     csbd_beg_date
                     csbd_bk_acct csbd_end_date csbd_type)
                     where csbd_bank      = vo__qad02    and
                     csbd_addr      = ap_vend      and
                     csbd_type      = "3"          and
                     csbd_beg_date <= ap_effdate   and
                     csbd_end_date >= ap_effdate
                  no-lock:
                  end. /* FOR FIRST csbd_det */
               end. /* IF LOOKUP(CKFRM,"3,4") <> 0 */

               if lookup(ckfrm,"1,2") <> 0
               then do:
                  /* LOOK FOR TYPE PRT = 2 */
                  for first csbd_det
                     fields (csbd_addr    csbd_bank     csbd_beg_date
                     csbd_bk_acct csbd_end_date csbd_type)
                     where csbd_bank      = vo__qad02    and
                     csbd_addr      = ap_vend      and
                     csbd_type      = "2"          and
                     csbd_beg_date <= ap_effdate   and
                     csbd_end_date >= ap_effdate
                  no-lock:
                  end. /* FOR FIRST csbd_det */
               end. /* IF LOOKUP(CKFRM,"1,2") <> 0 */

               if not available csbd_det
               then do:
                  /* IF EDI ACCOUNT TYPE FOR CKFRM 3 AND 4  */
                  /* AND PRT ACCOUNT TYPE FOR CKFRM 1 AND 2 */
                  /* ARE NOT PRESENT THEN CONSIDER THE      */
                  /* FIRST csbd_det RECORD.                 */
                  for first csbd_det
                     fields (csbd_addr    csbd_bank     csbd_beg_date
                     csbd_bk_acct csbd_end_date csbd_type)
                     where csbd_bank      = vo__qad02    and
                     csbd_addr      = ap_vend      and
                     csbd_beg_date <= ap_effdate   and
                     csbd_end_date >= ap_effdate
                  no-lock:
                  end. /* FOR FIRST csbd_det */
               end. /* IF NOT AVAILABEL csbd_det */
            end. /* IF NOT AVAILABEL csbd_det AND ... */

         end.

         assign
            bk1_ok = false
            bk2_ok = false.

         if available csbd_det then do:
            /* ACCOUNT IS FOR EDI/GIRO */
            if ckfrm >= "3" and ckfrm <= "4" then do:
               assign
                  bk_acct1 = ""
                  bk_acct2 = csbd_bk_acct.
            end.
            else do:  /* ACCOUNT IS FOR CHECKS OR DRAFTS */
               assign
                  bk_acct1 = csbd_bk_acct
                  bk_acct2 = "".
            end.

            /* ADDED SEVENTH OUTPUT PARAMETER l_bankno */

            {gprun.i ""apbkval.p"" "(input bk_val,
                 input bk_acct1,
                 input bk_acct2,
                 output bk1_ok,
                 output bk2_ok,
                 output bankno,
                 output l_bankno)" }

         end.

         /* IF GOING TO FILE VERIFY ACCOUNT NUMBER */
         if (lookup(ap_ckfrm,"1,2,3,5,6,7") = 0 and
            ap_ckfrm <> "" )
            or (lookup(ckfrm,"1,2,3,5,6,7") = 0 and ckfrm <> "" )
         then do:
            if bankno <> 0 and bk1_ok then
            disp_bankno =
            trim(string(bankno,">>>>>>>>>>>>>>>>>>>>>>>>")).
            else if bankno <> 0 and bk2_ok then do:
               assign
                  controle_ok = yes
                  /* CAPS ( ) VIOLATES TRANSLATION STANDARDS */
                  /* BUT UPPER-CASE IS NEEDED ON EDI FILE    */
                  name = caps(ad_name)
                  city = caps(ad_city).
               {apckprb4.i name}
               {apckprb4.i city}
               if not controle_ok

                  then giro_msg =
                  dynamic-function('getTermLabelFillCentered' in h-label,
                  input "INVALID_NAME_CITY",
                  input 40,
                  input '*').

               if gl_bk_val = "11" then do:
                  if substring(trim(bk_acct2),1,1) = "P" then
                     disp_bankno = "P" +
                     trim(string(bankno,">>>>>>>>>>>>>>999999999")).
                  else
                     disp_bankno =
                     trim(string(bankno,">>>>>>>>>>>>>>9999999999")).
               end. /* IF gl_bk_val = "11" */
               else
                  if gl_bk_val = "12" then
               disp_bankno = "P"
               + trim(string(bankno,">>>>>>>>>>>>>9999999999")).
               else
                  disp_bankno = l_bankno.
            end.

            /*WON'T BE ABLE TO PAY IF INVALID ACCOUNT OR */
            /*INVALID NAME/CITY IF GIRO ACCOUNT*/
            /*THEREFORE, DON'T ADD TO PMT TOT AND HASH TOTAL*/
            if (disp_bankno = " " )
               or (giro_msg <> " ") then do:
               disp_bankno =
               trim(string(bankno,">>>>>>>>>>>>>>>>>>>>>>>>")).

               if gl_bk_val = "11" then do:
                  if available csbd_det then
                     disp_bankno = csbd_bk_acct.
                  else
                     disp_bankno = "0".
               end. /* IF gl_bk_val = "11" */

               assign

                  bank_msg =
                  dynamic-function('getTermLabelFillCentered' in h-label,
                  input "INVALID_BANK_ACCOUNT",
                  input 40,
                  input '*')
                  invalid_vendor = yes.
            end.
            else invalid_vendor = no.

         end.   /* File */
         else do:
            invalid_vendor = no.
            if available csbd_det then
               disp_bankno = csbd_bk_acct.
            else disp_bankno = "0".

            if gl_bk_val = "11" and (ap_ckfrm = "3" or ckfrm = "3")
            then do:
               if bk2_ok then do:
                  if substring(trim(bk_acct2),1,1) = "P" then
                     disp_bankno = "P" + string(bankno).
                  else
                     disp_bankno = string(bankno).
               end.
               else do:
                  assign

                     bank_msg =
                     dynamic-function('getTermLabelFillCentered' in h-label,
                     input "INVALID_BANK_ACCOUNT",
                     input 40,
                     input '*')
                     invalid_vendor = yes.
               end.
            end. /*IF gl_bk_val = "11" and (ap_ckfrm = "3"... */

         end.
      end. /* if available ad_mstr */
   end. /*first of vo__qad02 */

   /* ADD TO TOTAL PMTS FOR VALID VENDORS */

   sep_updated = no.
   if vo_separate then do:
      assign
         tot_nbr_sep = tot_nbr_sep + 1
         sep_updated = yes.
   end.
   if first-of(ap_curr) then do:
      if invalid_vendor then tot_invalid = tot_invalid + 1.
      else if not sep_updated then do:
         assign
            tot_nbr_pay = tot_nbr_pay + 1
            frst_non_sep = no.
      end.
      sep_updated = no.
   end.
   else if not vo_separate and frst_non_sep
   then do:
      assign
         tot_nbr_pay = tot_nbr_pay + 1
         frst_non_sep = no.
   end.

   /* ADDED THE FOLLOWING PERSISTENT PROCEDURE TO MAINTAIN */
   /* CONSISTENCY IN THE SEARCH OF ad_mstr                 */
   {pxrun.i &PROC    = 'findRemitTo'
            &PROGRAM = 'appmtxr.p'
            &HANDLE  = ph_appmtxr
            &PARAM   =  "(input  ap_ref,
                          input  ap_type,
                          buffer ad_mstr)"}.

/* ADD EACH VOUCHER AMOUNT TO HASH TOTAL */

{apbkhash.i &amt=vo_amt_chg}

assign
   base_amt_chg = vo_amt_chg
   base_disc_chg = vo_disc_chg
   disp_curr = "".

if base_rpt = ""
   and vo_curr <> base_curr then do:
   /* GET EXCHANGE RATE IF NOT FOREIGN BANK */
   if bk_curr = base_curr then do:

      /* GET EXCHANGE RATE */
      {gprunp.i "mcpl" "p" "mc-get-ex-rate"
         "(input vo_curr,
           input base_curr,
           input vo_ex_ratetype,
           input print_date,
           output check_rate,
           output check_rate2,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         assign
            check_rate = vo_ex_rate
            check_rate2 = vo_ex_rate2.
      end.
   end.

   /* CONVERT FROM FOREIGN TO BASE CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input vo_curr,
        input base_curr,
        input check_rate,
        input check_rate2,
        input base_amt_chg,
        input true, /* ROUND */
        output base_amt_chg,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   /* CONVERT FROM FOREIGN TO BASE CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input vo_curr,
        input base_curr,
        input check_rate,
        input check_rate2,
        input base_disc_chg,
        input true, /* ROUND */
        output base_disc_chg,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
   disp_curr     = getTermLabel("YES",1).

end.
accumulate base_disc_chg (total by ap_vend).

if first-of(ap_vend) then do:
   /* SS - 200600824.1 B */
   /*
   if first(ap_vend) then display.
     */
   /* SS - 200600824.1 E */

   /* DISPLAY REMIT-TO SUPPLIER NAME */

   for first ad_mstr
      fields (ad_addr ad_city ad_name)
      where ad_addr = vd_remit no-lock:
   end.

   if not available ad_mstr then

      for first ad_mstr
      fields (ad_addr ad_city ad_name)
      where ad_addr = ap_vend no-lock:
end.

if available ad_mstr then name = ad_name.
else name = "".


/* SS - 200600824.1 B */
/*
put skip {gplblfmt.i
   &FUNC=getTermLabel(""SUPPLIER"",16)
   &CONCAT="': '"
   } ap_vend " " name.
if vd_hold = yes then do:
   {pxmsg.i &MSGNUM=162 &ERRORLEVEL=2 &MSGBUFFER=warn_msg}
   /*SUPPLIER ON PAYMENT HOLD*/
   put skip.
   put warn_msg.
end.
*/
/* SS - 200600824.1 E */

assign
   vend_detail  = 0
   vend_amt_chg = 0
   vend_sep_chg = 0.
end.

/* DISPLAY SUPPLIER BANK ACCOUNT */
/* SS - 200600824.1 B */
/*
if first-of(vo__qad02) then do:
   if bk1_ok = no and bk2_ok = yes then do:

      put {gplblfmt.i
         &FUNC=getTermLabel(""BANK"",8)
         &CONCAT="': '"
         } to 47 vo__qad02 to 55

         {gplblfmt.i
         &FUNC=getTermLabel(""BANK_ACCOUNT"",16)
         &CONCAT="': '"
         } at 57 disp_bankno space(2) giro_msg .
   end.
   else do:

      put {gplblfmt.i
         &FUNC=getTermLabel(""BANK"",8)
         &CONCAT="': '"
         } to 47 vo__qad02 to 55

         {gplblfmt.i
         &FUNC=getTermLabel(""BANK_ACCOUNT"",16)
         &CONCAT="': '"
         } at 57 disp_bankno space(2) bank_msg .
   end.
end.
*/
/* SS - 200600824.1 E */

tot_nbr_vch = tot_nbr_vch + 1.

if vo_hold_amt <> 0 then hold = "HD".
else hold = "".
if vo_separate = no then vend_amt_chg = vend_amt_chg + base_amt_chg.
else vend_sep_chg = vend_sep_chg + base_amt_chg.

if vend_amt_chg < 0 and sort_by_amount = yes then do:
   assign
      vend_amt_chg = vend_amt_chg - base_amt_chg
      base_amt_chg = - vend_amt_chg
      vend_amt_chg = vend_amt_chg + base_amt_chg.
   if base_rpt = ""
      and vo_curr <> base_curr then
   do:

      /* CONVERT FROM BASE TO FOREIGN CURRENCY */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input base_curr,
           input vo_curr,
           input check_rate2,
           input check_rate,
           input base_amt_chg,
           input true, /* ROUND */
           output base_amt_chg,
           output mc-error-number)"}.
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

   end.
end.

for first vpo_det
   fields (vpo_po vpo_ref)
   where vpo_ref = vo_ref no-lock:
end.

vopo = if available vpo_det then vpo_po else "".

{&APPARPA-P-TAG5}
   /* SS - 200600824.1 B */
   /*
if page-size - line-counter < 4 then do:
   page.
   display.

   put skip {gplblfmt.i
      &FUNC=getTermLabel(""SUPPLIER"",16)
      &CONCAT="': '"
      } ap_vend " " name skip(1).
end.

{&APPARPA-P-TAG6}
display
   vo_ref
   vo_invoice          format "x(13)"
   vopo @ vo_po
   ap_bank
   ap_effdate
   vo_due_date
   vo_disc_date
   disp_curr
   ap_ckfrm                             format "x(1)"
   (base_disc_chg + base_amt_chg)
   @ gross_amt                       format "->>>>,>>>,>>9.99"
   hold                 no-label
   base_disc_chg                        format "->>>,>>>,>>9.99"
   base_amt_chg                         format "->>>>,>>>,>>9.99"
with frame c.
{&APPARPA-P-TAG7}
*/
   /* SS - 200600824.1 E */

   CREATE tta6apparp01.
   ASSIGN 
      tta6apparp01_ap_vend = ap_vend 
      tta6apparp01_name    = NAME 
      tta6apparp01_vo__qad02 = vo__qad02
      tta6apparp01_disp_bankno = DISP_bankno
      tta6apparp01_vo_ref  = vo_ref
      tta6apparp01_vo_invoice = vo_invoice
      tta6apparp01_vopo       = vopo
      tta6apparp01_ap_bank    = ap_bank
      tta6apparp01_ap_effdate = ap_effdate 
      tta6apparp01_vo_due_date = vo_due_date
      tta6apparp01_vo_disc_date = vo_disc_date
      tta6apparp01_disp_curr = DISP_curr
      tta6apparp01_ap_ckfrm = ap_ckfrm
      tta6apparp01_gross_amt = (base_disc_chg + base_amt_chg )
      tta6apparp01_hold = hold
      tta6apparp01_base_disc_chg = base_disc_chg
      tta6apparp01_base_amt_chg = base_amt_chg
      tta6apparp01_ap_rmk = ap_rmk 
      .

/* Multiple PO section -- Begin */
find next vpo_det where vpo_ref = vo_ref no-lock no-error.
do while available vpo_det:
      ASSIGN 
          tta6apparp01_vopo       = tta6apparp01_vopo + "," + vpo_po
          .

   /*
   down 1 with frame c.
   if page-size - line-counter < 4 then do:
      page.
      display.

      put skip {gplblfmt.i
         &FUNC=getTermLabel(""SUPPLIER"",16)
         &CONCAT="': '"
         } ap_vend " " name skip.
   end.
   display vpo_po @ vo_po with frame c.
   */

   find next vpo_det where vpo_ref = vo_ref no-lock no-error.
end.
/* Multiple PO section -- End */

   /* SS - 200600824.1 B */
/*
if vo_separate then display "S" @ separate no-label.
else display " " @ separate no-label.
vend_detail = vend_detail + 1.
*/
   /* SS - 200600824.1 E */


 /* SS - 200600824.1 B */
/*
if vd_misc_cr and ap_remit <> "" then do:

   for first ad_mstr
      fields (ad_addr ad_city ad_name)
      where ad_addr = ap_remit no-lock:
   end.

   if available ad_mstr then do:
      remit-name = ad_name.
      put remit-label at 10 " " remit-name.
   end.
end.
*/
 /* SS - 200600824.1 E */

 /* SS - 200600824.1 B */
/*
if print_rmk and ap_rmk <> "" then put ap_rmk at 10 skip.
if last-of(ap_vend) then do:
   assign
      frst_non_sep = yes
      tot_amt_chg  = tot_amt_chg + vend_amt_chg + vend_sep_chg.
   if vend_detail > 1 then do:
      down 1 with frame c.
      if page-size - line-counter < 4 then do:
         page.
         display.

         put skip {gplblfmt.i
            &FUNC=getTermLabel(""SUPPLIER"",16)
            &CONCAT="': '"
            } ap_vend " " name skip.
      end.
      underline gross_amt base_disc_chg base_amt_chg.

      {&APPARPA-P-TAG8}
      display
         (if base_rpt = ""

         then getTermLabelRt("BASE_CURRENCY",7)
         else "     " + base_rpt)
         @ ap_effdate

         getTermLabel("SUPPLIER",8) @ vo_due_date
         getTermLabelRtColon("TOTALS",8) @ vo_disc_date
         (accum total by ap_vend (base_disc_chg))
         + (vend_amt_chg + vend_sep_chg)
         format "->>>>>,>>>,>>9.99" @ gross_amt
         accum total by ap_vend (base_disc_chg)
         format "->>>>,>>>,>>9.99" @ base_disc_chg
         (vend_amt_chg + vend_sep_chg)
         format "->>>>>,>>>,>>9.99" @ base_amt_chg.

      {&APPARPA-P-TAG9}
   end.
   down 1 with frame c.
   if last(ap_vend) then do:
      tot_nbr_pay = tot_nbr_pay + tot_nbr_sep.
      if page-size - line-counter < 4 then page.
      underline gross_amt base_disc_chg base_amt_chg.

      {&APPARPA-P-TAG10}
      display
         (if base_rpt = ""

         then getTermLabelRt("BASE_CURRENCY",7)
         else "     " + base_rpt)
         @ ap_effdate

         getTermLabelRt("REPORT",8) @ vo_due_date
         getTermLabelRtColon("TOTALS",8) @ vo_disc_date
         (accum total (base_disc_chg)) + (tot_amt_chg)
         format "->>>>>,>>>,>>9.99" @ gross_amt
         accum total (base_disc_chg) format "->>>>,>>>,>>9.99"
         @ base_disc_chg
         tot_amt_chg format "->>>>>,>>>,>>9.99" @ base_amt_chg.

      {&APPARPA-P-TAG11}
      if page-size - line-counter < 4 then page.
      display    "  " with frame leeg.
      do with frame hash:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame hash:handle).

         display    caps(getTermLabelRt("TOTALS",10)) format "x(10)"
            tot_nbr_vch
            tot_nbr_pay
            tot_invalid
            hash_total
         with frame hash no-box width 100 column 20.
      end. /* do with */
   end.

end. /* If last-of(ap_vend) */
*/

{mfrpchk.i}
end. /* vdloop: for each vd_mstr, each ap_mstr*/

/*message "vd_mstr end" view-as alert-box.*/


page. /* PRINT PAGE FOOTING (FRAME PFOOT) BEFORE LEAVING */
{wbrp04.i}

{gpdelp.i "appmtxr" "p"}
