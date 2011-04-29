/* apckrp.i - AP PAYMENT REGISTER INCLUDE FILE                                */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.42 $                                           */
/* REVISION: 7.0      LAST MODIFIED: 05/21/92   BY: mlv *F461*                */
/* REVISION: 7.3      LAST MODIFIED: 08/03/92   BY: mpp *G024*                */
/*                                   04/12/93   BY: jms *G937*                */
/*                                   04/17/93   BY: jms *G967*                */
/*                                   07/22/93   BY: wep *GD59*                */
/*                                   09/16/93   BY: bcm *GF38*                */
/* REVISION: 7.4      LAST MODIFIED: 09/21/93   BY: bcm *H110*                */
/*                                   11/23/93   BY: wep *H245*                */
/*                                   02/11/94   BY: wep *FM13*                */
/*                                   04/04/94   by: pcd *H321*                */
/*                                   05/17/94   by: srk *FO20*                */
/* REVISION: 7.4      LAST MODIFIED: 09/12/94   by: slm *GM17*                */
/*                                   09/26/94   by: str *FR77*                */
/*                                   12/14/94   by: pmf *F09H*                */
/*                                   01/25/95   by: str *F0FX*                */
/*                                   04/26/95   by: jzw *F0R3*                */
/*                                   10/31/95   by: mys *H0GN*                */
/*                                   11/20/95   by: jzw *H0H8*                */
/* REVISION: 8.5      LAST MODIFIED: 12/24/95   by: mwd *J053*                */
/*                                   04/04/96   by: jzw *G1LD*                */
/*                                   05/24/96   by: pmf *H0L8*                */
/* REVISION: 8.6      LAST MODIFIED: 10/02/96   by: svs *K007*                */
/*                    LAST MODIFIED: 11/19/96   by: jpm *K020*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/14/98   BY: *J2LY* Niranjan R.        */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 09/16/99   BY: *J3LF* Ranjit Jain        */
/* Pre-86E commented code removed, view in archive revision 1.9               */
/* Old ECO marker removed, but no ECO header exists *F509*                    */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/17/00   BY: *N07D* Antony Babu        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 01/10/01   BY: *L178* Jyoti Thatte       */
/* REVISION: 9.1      LAST MODIFIED: 09/21/00   BY: *N0W0* BalbeerS Raput     */
/* REVISION: 9.1      LAST MODIFIED: 02/08/01   BY: *M105* Rajesh Lokre       */
/* REVISION: 9.1      LAST MODIFIED: 10/14/00   BY: *N0WW* Chris Green        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.25    BY: Katie Hilbert      DATE: 04/01/01   ECO: *P002*  */
/* Revision: 1.26    BY: Ed van de Gevel    DATE: 11/09/01   ECO: *N15N*  */
/* Revision: 1.27    BY: Paul Donnelly      DATE: 01/04/02   ECO: *N16J*  */
/* Revision: 1.28    BY: Paul Donnelly      DATE: 05/03/02   ECO: *N1HQ*  */
/* Revision: 1.29    BY: Lena Lim           DATE: 06/12/02   ECO: *P089*  */
/* Revision: 1.30    BY: Paul Donnelly      DATE: 07/26/02   ECO: *N1PX*  */
/* Revision: 1.31    BY: Kedar Deherkar     DATE: 11/15/02   ECO: *N1WS*  */
/* Revision: 1.32    BY: Orawan S.          DATE: 05/03/02   ECO: *P0QW* */
/* Revision: 1.35    BY: Paul Donnelly (SB) DATE: 06/26/03   ECO: *Q00B* */
/* Revision: 1.36    BY: Rajinder Kamra     DATE: 07/11/03   ECO: *Q00Q* */
/* Revision: 1.37    BY: Kirti Desai        DATE: 10/13/03   ECO: *Q049* */
/* Revision: 1.38    BY: Mamata Samant      DATE: 10/27/03   ECO: *P17F* */
/* Revision: 1.40    BY: Shilpa Athalye     DATE: 01/19/04   ECO: *P1CW* */
/* $Revision: 1.42 $   BY: Jignesh Rachh      DATE: 02/01/05   ECO: *P362* */
/* SS - 090526.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/


/*V8:ConvertMode=Report                                                       */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
{cxcustom.i "APCKRP.I"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apckrp_i_1 "AP Amount"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrp_i_3 "Cash Amount"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrp_i_5 "Due Date"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*!      ARGUMENTS:
*         &sort1  major sort field
*
*         If sort-by-vend then &sort1 = ap_vend
*         Else                 &sort1 = ap_batch.
*/

define new shared variable convert-to-base like mfc_logical no-undo.
define variable remit-name like ad_mstr.ad_name no-undo.

/* THE FOLLOWING FIELDS USED FOR CONVERTING AP_DUE_DATE */
/* CAN BE REMOVED WHEN THE DATABASE IS MODIFIED         */

define variable ap_due_date  like ap_date label {&apckrp_i_5}.
define variable rndamt       like ap_amt.

define variable mc-error-number like msg_nbr no-undo.
define variable exch_line_1     as   character format "x(40)" no-undo.
define variable exch_line_2     as   character format "x(40)" no-undo.
define variable l_curr          like ap_curr                  no-undo.

/* DEFINED VARIABLES FOR ROUNDING ERROR DISPLAY */
define variable l_chk_amt  like ckd_amt                no-undo.
define variable l_rnd_amt  as   decimal format "-9.99" no-undo.

/* FOLLOWING REQUIRED FOR INTER-COMPANY */
{pxpgmmgr.i}
define variable ico_acct as character no-undo.
define variable ico_sub as character no-undo.
define variable ico_cc as character no-undo.

{&APCKRP-I-TAG6}
{&APCKRP-I-TAG7}

/* READ APC_CTRL TO GET APC_USE_DRFT VALUE */
find first apc_ctrl  where apc_ctrl.apc_domain = global_domain no-lock no-error.
{&APCKRP-I-TAG8}

/* FOR DRAFT MANAGEMENT, ALLOW SEARCH BY DUE DATE.    */
/* CONVERT AP_DUE_DATE FROM DATE STORED IN AP__QAD01. */
if apc_use_drft then do:
   /* CONVERT AP__QAD01 TO AP_DUE_DATE */
   {gprun.i ""gpchtodt.p"" "(input  ap__qad01,
                             output ap_due_date)"}

   /* CHECK THE DATE TO SEE IF IT IS IN THE RANGE */
   if ap_due_date < duedate
      or ap_due_date > duedate1 then
      next report_loop.
end.

if first-of({&sort1}) then batch_lines = 0.

if vdfound = yes
then do:

   batch_lines = batch_lines + 1.
   find first bk_mstr  where bk_mstr.bk_domain = global_domain and  bk_code =
   string(ck_bank, "X(2)")
      no-lock no-error.
   if available bk_mstr then bank_curr = bk_curr.

   convert-to-base = ((bank_curr <> base_curr  or
      ap_curr   <> base_curr) and
      base_rpt = "").

   /* IF CHECK VOIDED OR EXCHANGE CONVERSION    */
   /* NECESSARY, GO THRU CKD_DET TO FIND CK AMT */
   if ((bank_curr <> base_curr  or
      bank_curr <> ap_curr)
      and base_rpt = "")
      or ck_status = "VOID"
   then do:
      base_amt = 0.
      for each ckd_det  where ckd_det.ckd_domain = global_domain and  ckd_ref =
      ap_ref no-lock:
         base_ckd_amt = ckd_amt.

         if (base_curr <> bank_curr  or
            base_curr <> ap_curr)
            and base_rpt = ""
         then do:

            /* THE BELOW CONDITION WILL BE TRUE ONLY AFTER */
            /* BCC FOR FOREIGN CURRENCY VOUCHERS PAID IN   */
            /* BASE CURRENCY BEFORE BCC.                   */

            if  ckd_voucher <> ""
            and base_curr   <> ck_curr
            and can-find (first ap_mstr
                              where ap_mstr.ap_domain = global_domain and
                              ap_type =  "VO"
                               and ap_ref  =  ckd_voucher
                               and ap_curr <> ck_curr)
            then
               base_ckd_amt = ckd_cur_amt.

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input ck_curr,
                 input base_curr,
                 input ck_ex_rate,
                 input ck_ex_rate2,
                 input base_ckd_amt,
                 input true, /* ROUND */
                 output base_ckd_amt,
                 output mc-error-number)"}.
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.

         end.
         base_amt = base_amt - base_ckd_amt.
      end.
   end.
   else
   if  base_rpt  =  ""
   and base_curr <> ck_curr
   then
      base_amt   = ap_base_amt.
   else base_amt = ap_amt.

   /* IF CK ENTERED AND VOIDED, DISPLAY 0 AT CHECK AMT AND BATCH TOT */
   /* ELSE IF ONLY VOIDED THIS PERIOD, DISPLAY AS NEGATIVE */
   if ck_voideff >= effdate and ck_voideff <= effdate1 and
      ck_voiddate >= apdate and ck_voiddate <= apdate1
      and ck_voiddate <> ? and ck_voideff <> ?
   then do:
      if ap_date >= apdate and ap_date <= apdate1
         and ap_effdate >= effdate and ap_effdate <= effdate1 then
         base_disp_amt = 0.
      else
         base_disp_amt = base_amt. /*NEGATIVE NUMBER*/
   end.
   else
      base_disp_amt = - base_amt. /*POSITIVE NUMBER*/

   {&APCKRP-I-TAG9}
   accumulate base_disp_amt (total by {&sort1}).

   if sort_by_vend and first-of({&sort1}) then do with frame b1:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b1:handle).
      /* DISPLAY REMIT-TO SUPPLIER NAME */
      find first ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr
      = vd_remit
         no-lock no-wait no-error.
      if not available ad_mstr then
      find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
      ap_vend
         no-lock no-wait no-error.

      if available ad_mstr then
         name = ad_name.
      else
         name = "".

      display ap_vend name with frame b1 side-labels.
   end.

   if sort_by_vend  = no and
      l_header_disp = yes
      then do with frame b2:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b2:handle).
      display ap_batch with frame b2 side-labels.
      assign
         l_header_disp = no.
   end. /* IF sort_by_vend = NO AND l_header_disp = YES */

   if sort_by_vend then do:
      find first ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr
      = vd_remit
         no-lock no-wait no-error.
      if not available ad_mstr then
      find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
      ap_vend
         no-lock no-wait no-error.

      name = if available ad_mstr then ad_name else "".
   end.

   if sort_by_vend = no then do:

      /* DISPLAY REMIT-TO SUPPLIER NAME */

      if ap_vend > ""
      then do:
         find first ad_mstr  where ad_mstr.ad_domain = global_domain and
         ad_addr = vd_remit
            no-lock no-wait no-error.
         if not available ad_mstr then
         find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
         ap_vend
            no-lock no-wait no-error.

         if available ad_mstr then
            name = ad_name.
         else
            name = "".
      end. /* IF ap_vend > ""  */
      else
         name = "".

   end. /* IF SORT_BY_VEND = NO */

   /* FIND STATUS IF VOID FOR THIS PERIOD */
   ckstatus = ck_status.
   if ckstatus = "void" and (ck_voideff < effdate
      or ck_voideff > effdate1
      or ck_voiddate < apdate
      or ck_voiddate > apdate1)
      then ckstatus = "".

   remit-name = "".
   {gprun.i ""apmisccr.p"" "(input ck_mstr.ck_ref,
                               output remit-name)"}
   if remit-name <> "" then
      name = remit-name.

   /* BUILD DISPLAY TEXT FOR EXCHANGE RATE */
   {gprunp.i "mcui" "p" "mc-ex-rate-output"
      "(input ap_curr,
        input base_curr,
        input ap_ex_rate,
        input ap_ex_rate2,
        input ap_exru_seq,
        output exch_line_1,
        output exch_line_2)"}
   {&APCKRP-I-TAG1}

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame c:handle).
   {&APCKRP-I-TAG2}

   {&APCKRP-I-TAG10}
/* SS 090703.1 - B */
		find first sb_mstr where sb_domain = global_domain and sb_sub = ap_sub no-lock no-error.
/* SS 090703.1 - B */

   display
      string(ck_bank, "X(2)") @ ck_bank
      ck_nbr format "999999"
      ap_vend
      name
      format "x(22)"
      ap_date
      ap_effdate
      ap_curr
      ap_ex_rate when(ap_ex_rate = 1 and ap_ex_rate2 = 1)
      " " when(ap_ex_rate <> 1 or ap_ex_rate2 <> 1) @ ap_ex_rate
      ap_entity
/* SS 090703.1 - B */
/*
      ap_acct
/* SS 090526.1 - B */
/*
      ap_sub
      ap_cc
      ckstatus
      base_disp_amt label {&apckrp_i_3}
*/
			ap_cc no-label
/* SS 090526.1 - E */
*/
			ap_sub
			sb_desc when avail sb_mstr
			ap_cc
/* SS 090703.1 - E */
   with frame c width 132.

   {&APCKRP-I-TAG11}
   do with frame c:
      down 1.
      if ap_rmk <> "" then display ap_rmk @ name.
/* SS 090526.1 - B */
/*
      if ckstatus = "void" then display ck_voideff @ ckstatus.
      if ap_rmk <> ""
         or ckstatus = "void"
         then down 1.
*/
			if ap_rmk <> "" then down 1.
/* SS 090526.1 - E */
   end.
   {&APCKRP-I-TAG3}

/* SS 090526.1 - B */
/*
   if ap_ex_rate <> 1 or ap_ex_rate2 <> 1 then do:
      if exch_line_1 <> "" then do:
         put exch_line_1 at 71.
      end.
      if exch_line_2 <> "" then do:
         put exch_line_2 at 71.
      end.
      put skip(1).
   end.
*/
/* SS 090526.1 - E */

   if gltrans then do:
      if ap_effdate >= effdate and ap_effdate <= effdate1
         and ap_date >= apdate and ap_date <= apdate1 then do:
         /* FIND NEXT LINE IN GLTW_WKFL GIVEN REF NUMBER. */
         /* RETURNS >>>RETURN_INT<<< */
         {gpnextln.i &ref=ap_vend &line=return_int}
         create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
         assign
            gltw_entity = ap_entity
            gltw_acct = ap_acct
            gltw_sub = ap_sub
            gltw_cc = ap_cc
            gltw_ref = ap_vend
            gltw_line = return_int        /*set by gpnextln.i*/
            gltw_date = ap_date
            gltw_effdate = ap_effdate
            gltw_userid = mfguser
            gltw_desc = ap_batch + " " + ap_type + " " + ap_ref
            + " " + ap_vend
            {&APCKRP-I-TAG12}
            gltw_amt = base_amt
            {&APCKRP-I-TAG13}
            recno = recid(gltw_wkfl).
         release gltw_wkfl.
      end.
      if ck_voideff >= effdate and ck_voideff <= effdate1
         and ck_voiddate >= apdate and ck_voiddate <= apdate1
         and ck_voiddate <> ? and ck_voideff <> ?
      then do:
         /* FIND NEXT LINE IN GLTW_WKFL GIVEN REF NUMBER. */
         /* RETURNS >>>RETURN_INT<<< */
         {gpnextln.i &ref=ap_vend &line=return_int}
         create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
         assign
            gltw_entity = ap_entity
            gltw_acct = ap_acct
            gltw_sub = ap_sub
            gltw_cc = ap_cc
            gltw_ref = ap_vend
            gltw_line = return_int       /*set by gpnextln.i*/
            gltw_date = ck_voiddate
            gltw_effdate = ck_voideff
            gltw_userid = mfguser
            gltw_desc = ap_batch + " " + ap_type + " " + ap_ref
            + " " + ap_vend
            {&APCKRP-I-TAG14}
            gltw_amt = - base_amt.
            {&APCKRP-I-TAG15}
         recno = recid(gltw_wkfl).
         release gltw_wkfl.
      end.
   end.

   /* GET AP DETAIL  */
   assign
      detail_lines = 0
      tot_gain_amt = 0
      gain_amt     = 0
      l_chk_amt    = 0
      l_rnd_amt    = 0.

   for each ckd_det  where ckd_det.ckd_domain = global_domain and  ckd_ref =
   ap_ref no-lock
         by ckd_voucher with frame d width 132
         no-box:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame d:handle).

      find vo_mstr  where vo_mstr.vo_domain = global_domain and  vo_ref =
      ckd_voucher no-lock no-error.
      assign
         base_disc = ckd_disc
         base_ckd_amt = ckd_amt
         gain_amt = 0.

      /* FIND AP VOUCHER RECORD */
      for first apmstr
            fields( ap_domain ap_acct ap_batch ap_cc
            ap_sub ap_disc_sub
            ap_date ap_curr
            ap_disc_acct
            ap_disc_cc ap_effdate ap_entity
            ap_ex_rate
            ap_ex_rate2
            ap_ref ap_rmk ap_type ap_vend)
             where apmstr.ap_domain = global_domain and  apmstr.ap_type = "VO"
            and apmstr.ap_ref = vo_ref no-lock:
      end.
      if not available apmstr then
          /* MUST BE NON-AP PAYMENT WITHOUT VOUCHER */
          /* SO READ THE CHECK INTO apmstr INSTEAD */
          find apmstr no-lock where recid(apmstr) = recid(ap_mstr) no-error.
      if not available apmstr then
          /* CAN'T FIND THE CHECK RECORD, CAN'T CONTINUE */
          next.

      if (bank_curr <> base_curr  or
         bank_curr <> ap_mstr.ap_curr)
         and base_rpt = ""
      then do:

         /* THE BELOW CONDITION WILL BE TRUE ONLY AFTER */
         /* BCC FOR FOREIGN CURRENCY VOUCHERS PAID IN   */
         /* BASE CURRENCY BEFORE BCC.                   */

         if  ckd_voucher <> ""
         and base_curr   <> ck_curr
         and can-find (first ap_mstr
                           where ap_mstr.ap_domain = global_domain and  ap_type
                           =  "VO"
                            and ap_ref  =  ckd_voucher
                            and ap_curr <> ck_curr)
         then
            assign
               base_ckd_amt = ckd_cur_amt
               base_disc    = ckd_cur_disc.

         l_chk_amt = l_chk_amt + base_ckd_amt.

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ck_curr,
              input base_curr,
              input ck_ex_rate,
              input ck_ex_rate2,
              input base_disc,
              input true, /* ROUND */
              output base_disc,
              output mc-error-number)"}.
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ck_curr,
              input base_curr,
              input ck_ex_rate,
              input ck_ex_rate2,
              input base_ckd_amt,
              input true, /* ROUND */
              output base_ckd_amt,
              output mc-error-number)"}.
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

         if available vo_mstr
            and (vo_ex_rate <> ck_ex_rate
            or vo_ex_rate2 <> ck_ex_rate2) then
         do:

            /* THE BELOW CONDITION WILL BE TRUE ONLY AFTER */
            /* BCC FOR FOREIGN CURRENCY VOUCHERS PAID IN   */
            /* BASE CURRENCY BEFORE BCC.                   */

            if  ckd_voucher <> ""
            and base_curr   <> ck_curr
            and can-find (first ap_mstr
                              where ap_mstr.ap_domain = global_domain and
                              ap_type =  "VO"
                               and ap_ref  =  ckd_voucher
                               and ap_curr <> ck_curr)
            then
               gain_amt = ckd_cur_amt + ckd_cur_disc.
            else
               gain_amt = ckd_amt + ckd_disc.

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input vo_curr,
                 input base_curr,
                 input vo_ex_rate,
                 input vo_ex_rate2,
                 input gain_amt,
                 input true,
                 output gain_amt,
                 output mc-error-number)"}.
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.

            assign
               gain_amt = gain_amt - (base_ckd_amt + base_disc).
         end.
         tot_gain_amt = tot_gain_amt + gain_amt.
      end.
      /* IF BASE PAYMENT OF FOREIGN VOUCHER */
      else if available vo_mstr
      and vo_curr        <> ap_mstr.ap_curr
      and ap_mstr.ap_curr = base_curr
      and base_rpt        = ""
      then do:

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input vo_curr,
              input base_curr,
              input vo_ex_rate,
              input vo_ex_rate2,
              input (ckd_cur_amt + ckd_cur_disc),
              input true, /* ROUND */
              output gain_amt,
              output mc-error-number)"}.
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ck_curr,
              input base_curr,
              input ck_ex_rate,
              input ck_ex_rate2,
              input (ckd_cur_amt + ckd_cur_disc),
              input true, /* ROUND */
              output rndamt,
              output mc-error-number)"}.
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

         assign
            gain_amt = gain_amt - rndamt
            tot_gain_amt = tot_gain_amt + gain_amt.
      end. /* ELSE IF AVAILABLE vo_mstr AND vo_curr ... */

      if gltrans then do:
         if ap_mstr.ap_effdate >= effdate and ap_mstr.ap_effdate <= effdate1
            and ap_mstr.ap_date >= apdate and ap_mstr.ap_date <= apdate1
         then do:
            /* FIND NEXT LINE IN GLTW_WKFL GIVEN REF NUMBER. */
            /* RETURNS >>>RETURN_INT<<< */
            {gpnextln.i &ref=apmstr.ap_vend &line=return_int}
            create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
            assign
               gltw_entity = apmstr.ap_entity
               gltw_acct = ckd_acct
               gltw_sub = ckd_sub
               gltw_cc = ckd_cc
               gltw_project = ckd_project
               gltw_ref = apmstr.ap_vend
               gltw_line= return_int        /*set by gpnextln.i*/
               gltw_date = ap_mstr.ap_date
               gltw_effdate = ap_mstr.ap_effdate
               gltw_userid = mfguser
               gltw_desc = ap_mstr.ap_batch + " " + ckd_type + " " +
               ckd_voucher + " " + ap_vend
               gltw_amt = base_ckd_amt + base_disc + gain_amt
               recno = recid(gltw_wkfl).
            release gltw_wkfl.

            /* FOLLOWING GLTW LINES ARE FOR INTER-COMPANY */
            if (ap_mstr.ap_entity <> apmstr.ap_entity)
            then do:
                {glenacex.i &entity=apmstr.ap_entity
                     &type='"DR"'
                     &module='"AP"'
                     &acct=ico_acct
                     &sub=ico_sub
                     &cc=ico_cc }

                /*DEBIT DETAIL ENTITY*/
                {gpnextln.i &ref=ap_mstr.ap_vend &line=return_int}
                create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
                assign
                    gltw_entity = ap_mstr.ap_entity
                    gltw_acct = ico_acct
                    gltw_sub = ico_sub
                    gltw_cc = ico_cc
                    gltw_ref = ap_mstr.ap_vend
                    gltw_line = return_int
                    gltw_date = ap_mstr.ap_date
                    gltw_effdate = ap_mstr.ap_effdate
                    gltw_userid = mfguser
                    gltw_desc = ap_mstr.ap_batch + " " +
                                ap_mstr.ap_type + " " +
                                ap_mstr.ap_ref + " " +
                                ap_mstr.ap_vend
                    gltw_amt = (base_ckd_amt + base_disc + gain_amt)
                    recno = recid(gltw_wkfl).
                    release gltw_wkfl.
                /*CREDIT HEADER ENTITY*/
                {glenacex.i &entity=ap_mstr.ap_entity
                            &type='"CR"'
                            &module='"AP"'
                            &acct=ico_acct
                            &sub=ico_sub
                            &cc=ico_cc }
                {gpnextln.i &ref=apmstr.ap_vend &line=return_int}
                create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
                assign
                    gltw_entity = apmstr.ap_entity
                    gltw_acct = ico_acct
                    gltw_sub = ico_sub
                    gltw_cc = ico_cc
                    gltw_ref = apmstr.ap_vend
                    gltw_line = return_int
                    gltw_date = ap_mstr.ap_date
                    gltw_effdate = ap_mstr.ap_effdate
                    gltw_userid = mfguser
                    gltw_desc = ap_mstr.ap_batch + " " +
                                apmstr.ap_type + " " +
                                apmstr.ap_ref + " " +
                                apmstr.ap_vend
                    gltw_amt = - (base_ckd_amt + base_disc + gain_amt)
                    recno = recid(gltw_wkfl).
                    release gltw_wkfl.
            end. /* INTER-COMPANY */

         end.
         /* SEE IF THE CHECK WAS VOID */
         if ck_voideff >= effdate and ck_voideff <= effdate1
            and ck_voiddate >= apdate and ck_voiddate <= apdate1
            and ck_voiddate <> ? and ck_voideff <> ?
         then do:
            /* FIND NEXT LINE IN GLTW_WKFL GIVEN REF NUMBER. */
            /* RETURNS >>>RETURN_INT<<< */
            {gpnextln.i &ref=apmstr.ap_vend &line=return_int}
            create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
            assign
               gltw_entity = apmstr.ap_entity
               gltw_acct = ckd_acct
               gltw_sub = ckd_sub
               gltw_cc = ckd_cc
               gltw_project = ckd_project
               gltw_ref = apmstr.ap_vend
               gltw_line= return_int        /*set by gpnextln.i*/
               gltw_date = ck_voiddate
               gltw_effdate = ck_voideff
               gltw_userid = mfguser
               gltw_desc = ap_mstr.ap_batch + " " + ckd_type + " "
                         + ckd_voucher + " " + apmstr.ap_vend
               gltw_amt = - (base_ckd_amt + base_disc + gain_amt)
               recno = recid(gltw_wkfl).
            release gltw_wkfl.

            /* FOLLOWING GLTW LINES ARE FOR INTER-COMPANY */
            {glenacex.i &entity=apmstr.ap_entity
                     &type='"DR"'
                     &module='"AP"'
                     &acct=ico_acct
                     &sub=ico_sub
                     &cc=ico_cc }
            if (ap_mstr.ap_entity <> apmstr.ap_entity) and
               (ico_acct <> "" or
                ico_sub <> "" or
                ico_cc <> "")
            then do:
                /*DEBIT DETAIL ENTITY*/
                {gpnextln.i &ref=ap_mstr.ap_vend &line=return_int}
                create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
                assign
                    gltw_entity = ap_mstr.ap_entity
                    gltw_acct = ico_acct
                    gltw_sub = ico_sub
                    gltw_cc = ico_cc
                    gltw_ref = ap_mstr.ap_vend
                    gltw_line = return_int
                    gltw_date = ap_mstr.ap_date
                    gltw_effdate = ap_mstr.ap_effdate
                    gltw_userid = mfguser
                    gltw_desc = ap_mstr.ap_batch + " " +
                                ap_mstr.ap_type + " " +
                                ap_mstr.ap_ref + " " +
                                ap_mstr.ap_vend
                    gltw_amt = - (base_ckd_amt + base_disc + gain_amt)
                    recno = recid(gltw_wkfl).
                release gltw_wkfl.
                /*CREDIT HEADER ENTITY*/
                {glenacex.i &entity=ap_mstr.ap_entity
                            &type='"CR"'
                            &module='"AP"'
                            &acct=ico_acct
                            &sub=ico_sub
                            &cc=ico_cc }
                {gpnextln.i &ref=apmstr.ap_vend &line=return_int}
                create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
                assign
                    gltw_entity = apmstr.ap_entity
                    gltw_acct = ico_acct
                    gltw_sub = ico_sub
                    gltw_cc = ico_cc
                    gltw_ref = apmstr.ap_vend
                    gltw_line = return_int
                    gltw_date = ap_mstr.ap_date
                    gltw_effdate = ap_mstr.ap_effdate
                    gltw_userid = mfguser
                    gltw_desc = ap_mstr.ap_batch + " " +
                                apmstr.ap_type + " " +
                                apmstr.ap_ref + " " +
                                apmstr.ap_vend
                    gltw_amt = (base_ckd_amt + base_disc + gain_amt)
                    recno = recid(gltw_wkfl).
                    release gltw_wkfl.
            end. /* INTER-COMPANY */

         end.
      end.

      if gltrans and ckd_disc <> 0 then do:
         assign
            tot-vtadj = 0
            tot_vtadj_disc = 0.
            ap_recno = recid(ap_mstr).
         if available vo_mstr
         then
            vo_recno = recid(vo_mstr).

         assign
            ckd_recno = recid(ckd_det)
            ck_recno  = recid(ck_mstr).

         {gprun.i ""apckrptx.p""}
         if available vo_mstr then
         find apmstr  where apmstr.ap_domain = global_domain and  apmstr.ap_ref
         = vo_ref
            and ap_type = "VO" no-lock no-error.
         if ap_mstr.ap_effdate >= effdate and
            ap_mstr.ap_effdate <= effdate1
            and ap_mstr.ap_date >= apdate and ap_mstr.ap_date <= apdate1
         then do:

            if convert-to-base then do:

               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ck_curr,
                    input base_curr,
                    input ck_ex_rate,
                    input ck_ex_rate2,
                    input tot_vtadj_disc,
                    input true, /* ROUND */
                    output tot_vtadj_disc,
                    output mc-error-number)"}.
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.

            end.

            /* FIND NEXT LINE IN GLTW_WKFL GIVEN REF NUMBER. */
            /* RETURNS >>>RETURN_INT<<< */
            {gpnextln.i &ref=apmstr.ap_vend &line=return_int}
            create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
            if available vo_mstr and available apmstr then
               assign
                  gltw_acct = apmstr.ap_disc_acct
                  gltw_sub = apmstr.ap_disc_sub
                  gltw_cc   = apmstr.ap_disc_cc.
            else
               assign
                  gltw_acct = ap_mstr.ap_disc_acct
                  gltw_sub = ap_mstr.ap_disc_sub
                  gltw_cc   = ap_mstr.ap_disc_cc.
            assign
               gltw_entity = apmstr.ap_entity
               gltw_ref = apmstr.ap_vend
               gltw_line=return_int       /*set by gpnextln.i*/
               gltw_date = ap_mstr.ap_date
               gltw_effdate = ap_mstr.ap_effdate
               gltw_userid = mfguser
               gltw_desc = ap_mstr.ap_batch + " " + ckd_type + " " + ckd_voucher
                           + " " + apmstr.ap_vend
               gltw_amt = - base_disc + tot_vtadj_disc
               recno = recid(gltw_wkfl).
            release gltw_wkfl.
         end.
         /* CHECK IF THE CHECK WAS VOIDED */
         if ck_voideff >= effdate and ck_voideff <= effdate1
            and ck_voiddate >= apdate and ck_voiddate <= apdate1
            and ck_voiddate <> ? and ck_voideff <> ?
         then do:
            /* FIND NEXT LINE IN GLTW_WKFL GIVEN REF NUMBER. */
            /* RETURNS >>>RETURN_INT<<< */
            {gpnextln.i &ref=apmstr.ap_vend &line=return_int}
            create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
            if available vo_mstr and available apmstr then
               assign
                  gltw_acct = apmstr.ap_disc_acct
                  gltw_sub  = apmstr.ap_disc_sub
                  gltw_cc   = apmstr.ap_disc_cc.
            else
               assign
                  gltw_acct = ap_mstr.ap_disc_acct
                  gltw_sub  = ap_mstr.ap_disc_sub
                  gltw_cc   = ap_mstr.ap_disc_cc.
            assign
               gltw_entity = apmstr.ap_entity
               gltw_ref = apmstr.ap_vend
               gltw_line=return_int       /*set by gpnextln.i*/
               gltw_date = ck_voiddate
               gltw_effdate = ck_voideff
               gltw_userid = mfguser
               gltw_desc = ap_mstr.ap_batch + " " + ckd_type + " " + ckd_voucher
                           + " " + apmstr.ap_vend
               gltw_amt =  base_disc - tot_vtadj_disc
               recno = recid(gltw_wkfl).
            release gltw_wkfl.
         end.
      end. /*IF GLTRANS AND CKD_DISC <> 0*/

      {&APCKRP-I-TAG16}
      rmks = "".
      if available vo_mstr
      then do:
         for first apmstr
            fields( ap_domain apmstr.ap_ref  apmstr.ap_type
                    apmstr.ap_curr apmstr.ap_rmk apmstr.ap_entity)
             where apmstr.ap_domain = global_domain and    apmstr.ap_ref  =
             vo_ref
            and     apmstr.ap_type = "VO"
            no-lock:
         end. /* FOR FIRST apmstr */

         if available apmstr
         then do:
            if ckstatus <> "void"
            and summary = no
            then
               rmks = apmstr.ap_rmk.

            if gain_amt <> 0
            then
               l_curr = (if ck_curr = base_curr
                        and apmstr.ap_curr <> base_curr
                        then
                           apmstr.ap_curr
                        else
                           ap_mstr.ap_curr).
         end. /* IF AVAILABLE apmstr*/
      end. /* IF AVAILABLE vo_mstr */

      if summary = no
         and ckstatus <> "void"
      then do:
         assign
            base_ckd_amt = base_ckd_amt + gain_amt.
         accumulate base_disc (total).
         accumulate base_ckd_amt (total).
         assign
            invoice = ""
            order = "".
         if available vo_mstr then do:
            invoice = vo_invoice.

            find first vpo_det  where vpo_det.vpo_domain = global_domain and
            vpo_ref = vo_ref no-lock no-error.
            assign
               order = if available vpo_det then vpo_po else "".
         end.

         {&APCKRP-I-TAG4}
         {&APCKRP-I-TAG17}
         display
/* SS 090526.1 - B */
/*
            apmstr.ap_entity
*/
/* SS 090526.1 - E */
            ckd_voucher
            ckd_type
            order
/* SS 090923.1 - B */
/*
            rmks     format "x(10)"
*/
            rmks     format "x(24)"
/* SS 090923.1 - E */
            invoice  format "x(20)"
            ckd_acct
/* SS 090526.1 - B */
/*
            ckd_sub
            ckd_cc
            base_ckd_amt label {&apckrp_i_1}
            base_disc format "->>>>>>>>>>9.99".
*/
						ckd_sub
						ckd_cc
						base_ckd_amt label {&apckrp_i_1}.
/* SS 090526.1 - E */
         {&APCKRP-I-TAG18}
         down 1.
         {&APCKRP-I-TAG5}

         /* Multiple PO section -- Begin */
         if available vo_mstr then do:
            find next vpo_det  where vpo_det.vpo_domain = global_domain and
            vpo_ref = vo_ref no-lock no-error.
            do while available vpo_det:
               display vpo_po @ order with frame d.
               down 1 with frame d.
               find next vpo_det  where vpo_det.vpo_domain = global_domain and
               vpo_ref = vo_ref
                  no-lock no-error.
            end.
         end. /*IF AVAIL VO_MSTR*/
         /* Multiple PO section -- End */

         detail_lines = detail_lines + 1.
      end. /* IF SUMMARY = NO */
   end. /* FOR EACH CKD_DET */

   accumulate (accum total (base_disc)) (total by {&sort1}).
   accumulate (accum total (base_ckd_amt)) (total by {&sort1}).

   /* CALCULATE GAIN/LOSS AMOUNT */
   if gltrans and tot_gain_amt <> 0 then do:
      if ap_mstr.ap_effdate >= effdate
         and ap_mstr.ap_effdate <= effdate1
         and ap_mstr.ap_date >= apdate and ap_mstr.ap_date <= apdate1
      then do:

         /* FIND NEXT LINE IN GLTW_WKFL GIVEN REF NUMBER. */
         /* RETURNS >>>RETURN_INT<<< */
         {gpnextln.i &ref=ap_mstr.ap_vend &line=return_int}
         create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
         assign
            gltw_entity = ap_mstr.ap_entity

            /* IF TWO VOUCHERS ARE ATTCHED FIRST IN FOREIGN CURRENCY  */
            /* WITH GAIN/LOSS AND SECOND IN BASE CURRENCY, gain_amt   */
            /* WILL HAVE ZERO VALUE SO IT IS REPLACED BY tot_gain_amt */

            gltw_ref = ap_mstr.ap_vend
            gltw_line = return_int       /*set by gpnextln.i*/
            gltw_date = ap_mstr.ap_date
            gltw_effdate = ap_mstr.ap_effdate
            gltw_userid = mfguser
            gltw_desc = ap_mstr.ap_batch + " " +
                        ap_mstr.ap_type + " " +
                        ap_mstr.ap_ref + " " + ap_mstr.ap_vend
            gltw_amt = - tot_gain_amt
            recno = recid(gltw_wkfl).
         /* GET REALIZED GAIN/LOSS ACCOUNTS */
         /* FROM ACCOUNT DEFAULT MASTER    */
         {gprunp.i "mcpl" "p" "get-gain-loss-accounts"
               " (input true,
                  input l_curr,
                  input tot_gain_amt > 0,
                  input false,
                  output gltw_acct,
                  output gltw_sub,
                  output gltw_cc)"}
         release gltw_wkfl.
      end.
      /* CHECK IF THE CHECK WAS VOIDED */
      if ck_voideff >= effdate and ck_voideff <= effdate1
         and ck_voiddate >= apdate and ck_voiddate <= apdate1
         and ck_voiddate <> ? and ck_voideff <> ?
      then do:

         /* FIND NEXT LINE IN GLTW_WKFL GIVEN REF NUMBER. */
         /* RETURNS >>>RETURN_INT<<< */
         {gpnextln.i &ref=ap_mstr.ap_vend &line=return_int}
         create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
         assign
            gltw_entity = apmstr.ap_entity

            /* IF TWO VOUCHERS ARE ATTCHED FIRST IN FOREIGN CURRENCY  */
            /* WITH GAIN/LOSS AND SECOND IN BASE CURRENCY, gain_amt   */
            /* WILL HAVE ZERO VALUE SO IT IS REPLACED BY tot_gain_amt */

            gltw_ref = ap_mstr.ap_vend
            gltw_line= return_int        /*set by gpnextln.i*/
            gltw_date = ck_voiddate
            gltw_effdate = ck_voideff
            gltw_userid = mfguser
            gltw_desc = ap_mstr.ap_batch + " " +
                        ap_mstr.ap_type + " " +
                        ap_mstr.ap_ref + " " + ap_mstr.ap_vend
            gltw_amt =  tot_gain_amt
            recno = recid(gltw_wkfl).
         /* GET REALIZED GAIN/LOSS ACCOUNTS */
         /* FROM ACCOUNT DEFAULT MASTER    */
         {gprunp.i "mcpl" "p" "get-gain-loss-accounts"
            " (input true,
               input ap_mstr.ap_curr,
               input tot_gain_amt > 0,
               input false,
               output gltw_acct,
               output gltw_sub,
               output gltw_cc)"}
         release gltw_wkfl.
      end.
   end. /* IF GLTRANS */

   if detail_lines > 1 then do:
      {&APCKRP-I-TAG19}

      /* LOGIC TO CONVERT THE TOTAL CHECK AMOUNT IN l_chk_amt TO */
      /* BASE CURRENCY AND CALCULATE THE CORRESPONDING ROUNDING  */
      /* AMOUNT IN ORDER TO DISPLAY IT.                          */

      if (bank_curr    <> base_curr
         or  bank_curr <> ap_mstr.ap_curr)
         and base_rpt  = ""
      then do:

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ck_curr,
              input base_curr,
              input ck_ex_rate,
              input ck_ex_rate2,
              input l_chk_amt,
              input true, /* ROUND */
              output l_chk_amt,
              output mc-error-number)"}.

         if mc-error-number <> 0
         then
            {pxmsg.i &MSGNUM=mc-error-number
                     &ERRORLEVEL=2}

         /* CALCULATE ROUNDING ERROR AFTER TAKING INTO CONSIDERATION */
         /* EXCHANGE GAIN/LOSS, IF ANY.                              */
         l_rnd_amt = l_chk_amt
                     - (accum total (base_ckd_amt))
                     + tot_gain_amt.

         if l_rnd_amt <> 0
         then do:

            display
               getTermLabel("ROUNDING_ERROR",14) @ invoice format "x(14)"
               l_rnd_amt                         @ ckd_acct
            with frame d.

         end. /* IF l_rnd_amt <> ... */

      end. /* IF (bank_curr <> ... */

/* SS 090526.1 - B */
/*
      underline base_ckd_amt base_disc.
      display
         getTermLabelRtColon("CHECK_TOTALS",10) @ rmks format "x(10)"
         accum total (base_ckd_amt) format "->>>>>,>>>,>>9.99"
         @ base_ckd_amt
         accum total (base_disc) format "->>>>>>>>>>9.99"
         @ base_disc with frame d.
*/
      underline base_ckd_amt.
      display
         getTermLabelRtColon("CHECK_TOTALS",10) @ rmks format "x(24)"
         accum total (base_ckd_amt) format "->>>>>,>>>,>>9.99"
         @ base_ckd_amt
         with frame d.
/* SS 090526.1 - E */
      {&APCKRP-I-TAG20}
   end.
   {&APCKRP-I-TAG21}

/* SS 090923.1 - B */
		if last-of(ck_nbr) and not summary then do:
			l_header_disp = yes.
			put skip(2).
			put "制单：______________ 审批：______________ 批准：_______________ 收票人：____________" skip.
			if not last(ck_nbr) then page.
		end.
/* SS 090923.1 - E */
   
end. /* IF vdfound = YES */

/* Can't use display @ from here on because of two frames */
if last-of({&sort1}) then do:
   if batch_lines > 0 then do:
      {&APCKRP-I-TAG22}
/* SS 090923.1 - B */
/*
      if summary = no then
         put
            fill("-",17) format "x(17)" to 78
         skip.
*/
/* SS 090923.1 - E */

/* SS 090923.1 - B */
/*
      if sort_by_vend = no then
      put  {gplblfmt.i
         &FUNC=getTermLabel(""BATCH_TOTALS"",25)
         &CONCAT=':'
         } to 57.
      else
      put  {gplblfmt.i
         &FUNC=getTermLabel(""SUPPLIER_TOTALS"",25)
         &CONCAT=':'
         } to 77.

      if summary = no then
         put
            accum total by {&sort1} (accum total (base_ckd_amt))
            format "->>>>>,>>>,>>9.99"
            to 78.
*/
/* SS 090923.1 - E */
      {&APCKRP-I-TAG23}
      assign
         l_rep_total = yes.
   end.
   assign
      l_header_disp = yes.

end. /* Last-of ap_batch or ap_vend */

if last ({&sort1})   and
   l_rep_total = yes
then do:
   {&APCKRP-I-TAG24}

/* SS 090923.1 - B */
/*
   if summary = no then
      put
         fill("-",17) format "x(17)" to 78
   skip.
   if base_rpt = "" then
      put base_curr at 53.
   else put base_rpt at 53.

   put  {gplblfmt.i
      &FUNC=getTermLabel(""REPORT_TOTALS"",25)
      &CONCAT=':'
      } at 58.
   if summary = no then
			put
         accum total (accum total (base_ckd_amt))
         format "->>>>>,>>>,>>9.99"
         to 78
      skip.
*/
/* SS 090923.1 - E */


   {&APCKRP-I-TAG25}
   /* WITHOUT SKIP, A PUT FOR THE LAST LINE OF A PAGE */
   /* CAUSES THE FIRST HEADING LINE OF THE NEXT PAGE  */
   /* TO BE SHIFTED RIGHT BY THE LENGTH OF THE PUT.   */
   assign
      l_rep_total = no.

end. /* If last ap_batch or ap_vend */
{mfrpchk.i}
