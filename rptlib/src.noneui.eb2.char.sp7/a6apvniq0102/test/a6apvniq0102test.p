/* apckrp01.p - SUPPLIER ACTIVITY (1099) REPORT                         */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.10.1.10.3.1 $                                               */
/* REVISION: 2.0      LAST MODIFIED: 12/04/87   BY: PML                 */
/* REVISION: 7.0      LAST MODIFIED: 01/27/92   BY: MLV *F098*          */
/* REVISION: 7.2      LAST MODIFIED: 08/23/94   BY: CPP *FQ43*          */
/* REVISION: 7.2      LAST MODIFIED: 02/15/95   BY: STR *F0J6*          */
/* REVISION: 7.4      LAST MODIFIED: 09/18/96   BY: jzw *H0MW*          */
/* REVISION: 8.5      LAST MODIFIED: 09/20/96   BY: jzw *G2G4*          */
/* REVISION: 8.5      LAST MODIFIED: 10/21/96   BY: rxm *H0NC*          */
/* REVISION: 8.6      LAST MODIFIED: 10/10/97   BY: ckm *K0QY*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* Pre-86E commented code removed, view in archive revision 1.9         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Vijaya Pakala */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 08/03/00   BY: *N0W0* Mudit Mehta       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.10.1.7      BY: Katie Hilbert       DATE: 04/01/01 ECO: *P002* */
/* Revision: 1.10.1.8      BY: Ed van de Gevel     DATE: 11/09/01 ECO: *N15N* */
/* Revision: 1.10.1.9      BY: Chris Green         DATE: 11/30/01 ECO: *N16J* */
/* Revision: 1.10.1.10     BY: Kedar Deherkar      DATE: 11/15/02 ECO: *N1WS* */
/* $Revision: 1.10.1.10.3.1 $   BY: Mercy Chittilapilly DATE: 11/17/03 ECO: *P19J* */
/* $Revision: 1.10.1.10.3.1 $   BY: Bill Jiang DATE: 11/10/06 ECO: *SS - 20061110.1* */

/*V8:ConvertMode=FullGUIReport                                          */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20061110.1 - B */
{a6apvniq0102.i "new"}
/* SS - 20061110.1 - E */

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
{cxcustom.i "APCKRP01.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apckrp01_p_1 "Include 1099 Suppliers Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrp01_p_2 "Minimum 1099 Amount"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrp01_p_3 "Summary/Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrp01_p_4 "Supplier Type"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* DEFINE GPRUNP VARIABLES OUTSIDE OF FULL GUI INTERNAL PROCEDURES */
{gprunpdf.i "mcpl" "p"}

define variable vend like ap_vend.
define variable vend1 like ap_vend.
define variable apdate like ap_date.
define variable apdate1 like ap_date.
define variable name like ad_name.
define variable type like ap_type format "X(4)".
define variable summary like mfc_logical format {&apckrp01_p_3}
   label {&apckrp01_p_3}.
define variable min_1099_amt as decimal label {&apckrp01_p_2}.
define variable pass as integer.
define variable vdtype like vd_type label {&apckrp01_p_4}.
define variable vdtype1 like vdtype.
define variable entity         like en_entity.
define variable entity1        like en_entity.
define variable vd1099_only like mfc_logical
   label {&apckrp01_p_1} initial yes no-undo.
define variable base_ckd_amt like ckd_amt no-undo.
define variable base_ck_amt like ckd_amt no-undo.
define variable curr_ck_amt like ckd_amt no-undo.
define variable base_vend_amt like ckd_amt no-undo.
define variable tax_id like vd_tax_id no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable l_addr as character format "x(38)".
define buffer apmstr for ap_mstr.

/* SS - 20061110.1 - B */
define variable base_rpt like ap_curr.
/* SS - 20061110.1 - B */

form
   /* SS - 20061110.1 - B */
   /*
   vend colon 15
   vend1          label {t001.i} colon 49 skip
   vdtype         colon 15
   vdtype1        label {t001.i} colon 49 skip
   entity         colon 15
   entity1        label {t001.i} colon 49 skip
   apdate         colon 15
   apdate1        label {t001.i} colon 49 skip (1)
   vd1099_only    colon 30
   min_1099_amt   colon 30
   summary        colon 30 skip (1)
   */
   vend colon 15
   vend1          label {t001.i} colon 49 skip
   apdate         colon 15
   apdate1        label {t001.i} colon 49 SKIP
   base_rpt COLON 15
   /* SS - 20061110.1 - E */
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* GET ROUNDING METHOD FOR EXCHANGE CONVERSION */
find first gl_ctrl no-lock.

{wbrp01.i}
repeat:

   if vend1 = hi_char then vend1 = "".
   if entity1 = hi_char then entity1 = "".
   if apdate = low_date then apdate = ?.
   if apdate1 = hi_date then apdate1 = ?.
   if vdtype1 = hi_char then vdtype1 = "".

   if c-application-mode <> 'web' then
   update
      /* SS - 20061110.1 - B */
      /*
      vend vend1
      vdtype vdtype1
      entity entity1
      apdate apdate1
      vd1099_only
      min_1099_amt
      summary
      */
      vend vend1
      apdate apdate1
      base_rpt
      /* SS - 20061110.1 - E */
   with frame a.

   /* SS - 20061110.1 - B */
   /*
   /*ADDED ENTITY ENTITY1 BELOW */
   {wbrp06.i &command = update &fields = "  vend vend1 vdtype vdtype1
    entity entity1
    apdate apdate1  vd1099_only min_1099_amt summary" &frm = "a"}
   */
   {wbrp06.i &command = update &fields = "  vend vend1 
    apdate apdate1  base_rpt" &frm = "a"}
   /* SS - 20061110.1 - E */

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i vend   }
      {mfquoter.i vend1  }
      {mfquoter.i vdtype  }
      {mfquoter.i vdtype1  }
      {mfquoter.i entity         }
      {mfquoter.i entity1        }
      {mfquoter.i apdate }
      {mfquoter.i apdate1}
      {mfquoter.i vd1099_only}
      {mfquoter.i min_1099_amt}
      {mfquoter.i summary}
      /* SS - 20061110.1 - B */
      {mfquoter.i base_rpt}
      /* SS - 20061110.1 - E */

      if vend1 = "" then vend1 = hi_char.
      if entity1 = "" then entity1 = hi_char.
      if apdate = ? then apdate = low_date.
      if apdate1 = ? then apdate1 = hi_date.
      if vdtype1 = "" then vdtype1 = hi_char.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   /* SS - 20061110.1 - B */
   /*
   {mfphead.i}

   vdloop:
   for each vd_mstr where
         (vd_addr >= vend and vd_addr <= vend1) and
         (vd_type >= vdtype and vd_type <= vdtype1)
         no-lock by vd_sort:

      if vd1099_only and vd_1099 = no then next vdloop.
      do pass = 1 to 2:
         if pass = 2 then do:
            if base_vend_amt
               < min_1099_amt then next vdloop.

            find ad_mstr where ad_addr = vd_addr no-lock no-error.
            tax_id = "".
            if available ad_mstr then
               tax_id = ad_gst_id.

            do with frame b:
               /* SET EXTERNAL LABELS */
               setFrameLabels(frame b:handle).
               display
                  vd_addr
                  tax_id
                  vd_ap_cntct
               with frame b.
            end.

            if available ad_mstr
            then do:

               {mfcsz.i l_addr ad_city ad_state ad_zip}

               put ad_name at 10
                  ad_line1 at 10
                  ad_line2 at 10
                  l_addr
                  format "X(38)" at 10
                  ad_country.

            end. /* IF AVAILABLE ad_mstr */

         end.

         base_vend_amt = 0.

         aploop:
         for each ap_mstr where (ap_vend = vd_addr)
               and (ap_date >= apdate)
               and (ap_date <= apdate1)
               and (ap_type = "CK")
               no-lock
               use-index ap_vend_date
               by ap_vend by ap_date
            with frame c width 132 down:

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame c:handle).

            for first ck_mstr
            fields (ck_bank ck_clr_date ck_cmtindx ck_curr
                    ck_exru_seq ck_ex_rate ck_ex_rate2
                    ck_ex_ratetype ck_nbr ck_ref ck_status
                    ck_type ck_voiddate ck_voideff)
            no-lock
            where ck_ref = ap_ref: end.

            if ck_status = "VOID" then next aploop.

            assign
               base_ck_amt = 0
               curr_ck_amt = 0.

            for each ckd_det where ckd_ref = ap_ref no-lock:

                /*only find checks for vouchers
                  with entities within selected range */
                find apmstr where apmstr.ap_type = "VO" and apmstr.ap_ref
                = ckd_voucher no-lock no-error.
                if not available apmstr then next aploop.
                if available apmstr and
                (apmstr.ap_entity < entity or apmstr.ap_entity > entity1)
                then next aploop.

               /* IF NECESSARY, DO EXCHANGE CONVERSION */

               base_ckd_amt = ckd_amt.

               if base_curr        <> ck_curr
                  and base_ckd_amt <> 0
               then do:

                  /* THE BELOW CONDITION WILL BE TRUE ONLY AFTER */
                  /* BCC FOR FOREIGN CURRENCY VOUCHERS PAID IN   */
                  /* BASE CURRENCY BEFORE BCC.                   */

                  if  ckd_voucher <> ""
                  and can-find (first ap_mstr
                                   where ap_type =  "VO"
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

               assign
                  base_ck_amt = base_ck_amt + base_ckd_amt
                  curr_ck_amt = curr_ck_amt + ckd_amt
                  base_vend_amt = base_vend_amt + base_ckd_amt.

               if pass = 1
                  and base_vend_amt
                  >= min_1099_amt then leave aploop.

            end. /* FOR EACH CKD_DET */

            if summary = no and pass = 2 then
            {&APCKRP01-P-TAG1}
            display
               ck_bank
               ck_nbr format "999999"
               /* DRAFTS HAVE A DUE DATE (AP__QAD01) */
               (if ap__qad01 > "" then "DR"
               else ap_type)
               @ ap_type
               ck_status
               ap_vend
               ap_date
               ap_effdate
               ap_acct
               ap_sub
               ap_cc
               base_ck_amt
               curr_ck_amt no-label when (base_ck_amt <> curr_ck_amt)
               ck_curr     no-label when (base_ck_amt <> curr_ck_amt).
            {&APCKRP01-P-TAG2}

            {mfrpchk.i}
         end.
         if pass = 2 then
         put
            {&APCKRP01-P-TAG3}
            "-------------" to 88
            base_vend_amt
            format "->>>>,>>>,>>9.99" to 88.
            {&APCKRP01-P-TAG4}
      end. /* DO PASS .. */
   end. /* VDLOOP: */
   /* REPORT TRAILER */

   {mfrtrail.i}
   */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   EMPTY TEMP-TABLE tta6apvniq0102.

   {gprun.i ""a6apvniq0102.p"" "(
       INPUT vend,
       INPUT vend1,
       INPUT apdate,
       INPUT apdate1,
       INPUT base_rpt
      )"}

   EXPORT DELIMITER ";" "ap_vend" "ap_effdate" "ap_date" "ap_ref" "ap_curr" "ap_amt" "ap_base_amt" "ap_acct" "ap_sub" "ap_cc" "ap_type" "vo_invoice" "vo_due_date".
   FOR EACH tta6apvniq0102:
       EXPORT DELIMITER ";" tta6apvniq0102.
   END.

   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

   {a6mfrtrail.i}
   /* SS - 20061110.1 - E */

end. /* REPEAT: */

{wbrp04.i &frame-spec = a}
