/* GUI CONVERTED from txaprp.p (converter v1.77) Wed May 12 23:23:05 2004 */
/* txaprp.p - GTM - AP TAX BY TRANSACTION REPORT                              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.17.1.21 $                                                     */
/* REVISION: 8.6            CREATED: 02/26/97   BY: *K06V*  Jeff Wootton      */
/* REVISION: 8.6      LAST MODIFIED: 04/16/97   BY: *K0BR*  Jeff Wootton      */
/* REVISION: 8.6      LAST MODIFIED: 05/09/97   BY: *K0D2*  Jeff Wootton      */
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   BY: *K0WZ*  bvm               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007*  A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 04/15/98   BY: *L00M*  rup               */
/* REVISION: 8.6E     LAST MODIFIED: 06/24/98   BY: *L01G*  Robin McCarthy    */
/* REVISION: 8.6E     LAST MODIFIED: 07/11/98   BY: *L02S*  Jim Josey         */
/* REVISION: 8.6E     LAST MODIFIED: 08/12/98   BY: *L05Q*  Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 08/27/98   BY: *K1W9*  Ababs Hirkani     */
/* REVISION: 8.6E     LAST MODIFIED: 09/21/98   BY: *L08W*  Russ Witt         */
/* REVISION: 9.1      LAST MODIFIED: 07/29/99   BY: *K21V*  Ranjit Jain       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014*  Robin McCarthy    */
/* REVISION: 9.1      LAST MODIFIED: 10/06/99   BY: *L0J3*  Jose Alex         */
/* REVISION: 9.1      LAST MODIFIED: 02/28/00   BY: *K25B*  Atul Dhatrak      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 04/21/00   BY: *L0T9*  Ranjit Jain       */
/* REVISION: 9.1      LAST MODIFIED: 06/30/00   BY: *N0DX*  Rajinder Kamra    */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb                */
/* REVISION: 9.1      LAST MODIFIED: 10/20/00 BY: *N0W4* Mudit Mehta          */
/* Revision: 1.17.1.12    BY: Ed van de Gevel    DATE: 11/09/01  ECO: *N15N*  */
/* Revision: 1.17.1.13    BY: Rajaneesh S.       DATE: 11/26/01  ECO: *M1QV*  */
/* Revision: 1.17.1.14    BY: Chris Green        DATE: 01/06/02  ECO: *N16J*  */
/* Revision: 1.17.1.15    BY: Hareesh V.         DATE: 06/21/02  ECO: *N1HY*  */
/* Revision: 1.17.1.18    BY: Ed van de Gevel    DATE: 09/05/02  ECO: *P0HQ*  */
/* Revision: 1.17.1.20  BY: Vandna Rohira      DATE: 09/05/03  ECO: *P126*  */
/* $Revision: 1.17.1.21 $ BY: Ed van de Gevel DATE: 02/24/04 ECO: *P1QF* */
/*V8:ConvertMode=FullGUIReport                                                */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/******************************************************************************/

/*cj* 08/26/05 add invoice nbr*/

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}
{cxcustom.i "TXAPRP.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE txaprp_p_1 "Taxable Amt"
/* MaxLen: Comment: */

&SCOPED-DEFINE txaprp_p_2 "Tax Amount"
/* MaxLen: Comment: */

&SCOPED-DEFINE txaprp_p_5 "Code      Amount"
/* MaxLen: Comment: */

&SCOPED-DEFINE txaprp_p_6 "Base Total:"
/* MaxLen: Comment: */

&SCOPED-DEFINE txaprp_p_7 "Print Unconfirmed"
/* MaxLen: Comment: */

&SCOPED-DEFINE txaprp_p_8 "Print Confirmed"
/* MaxLen: Comment: */

&SCOPED-DEFINE txaprp_p_9 "Payment"
/* MaxLen: Comment: */

&SCOPED-DEFINE txaprp_p_10 "Date!Eff Date"
/* MaxLen: 8 Comment: Stacked column labels for Date/Effective Date */

/* ********** End Translatable Strings Definitions ********* */
{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "mcui" "p"}

define variable taxtype    like tx2d_tax_type  no-undo.
define variable taxtype1   like tx2d_tax_type  no-undo.
define variable taxc       like tx2d_taxc      no-undo.
define variable taxc1      like tx2d_taxc      no-undo.
define variable taxusage   like tx2d_tax_usage no-undo.
define variable taxusage1  like tx2d_tax_usage no-undo.
define variable taxdate    like vo_tax_date    no-undo.
define variable taxdate1   like vo_tax_date    no-undo.
define variable apdate     like ap_date        no-undo.
define variable apdate1    like ap_date        no-undo.
define variable effdate    like ap_effdate     no-undo.
define variable effdate1   like ap_effdate     no-undo.
define variable batch      like ap_batch       no-undo.
define variable batch1     like ap_batch       no-undo.
define variable ref        like ap_ref         no-undo.
define variable ref1       like ap_ref         no-undo.
define variable vend       like ap_vend        no-undo.
define variable vend1      like ap_vend        no-undo.
define variable entity     like ap_entity      no-undo.
define variable entity1    like ap_entity      no-undo.
define variable show_conf  like mfc_logical
   label {&txaprp_p_8}
   initial yes no-undo.
define variable show_unconf like mfc_logical
   label {&txaprp_p_7} no-undo.
define variable l_aparflag as   character      no-undo.

define new shared variable base_rpt      like ap_curr no-undo.
define new shared variable mc_rpt_curr   like gl_base_curr no-undo.
define variable temp_tx2d_tottax like tx2d_tottax no-undo.
define variable temp_rate1 like exr_rate no-undo.
define variable temp_rate2 like exr_rate2 no-undo.

define variable base_amt like ap_amt no-undo.
define variable disp_curr as character format "x(1)" no-undo.
define variable disc_pct like ap_amt decimals 10 no-undo.
define variable base_tot_amt like base_amt
   label {&txaprp_p_1} no-undo.
define variable base_tax like ap_amt label {&txaprp_p_2} no-undo.
{&TXAPRP-P-TAG1}
define variable rndmthd like rnd_rnd_mthd no-undo.
define variable tax_printed as logical initial false no-undo.
define variable l_tx2d_tax_amt like tx2d_tottax no-undo.

{etvar.i   &new = "new"} /* common euro variables */
{etrpvar.i &new = "new"} /* common euro report variables */
{eteuro.i}

define variable et_base_amt      like base_amt no-undo.
define variable et_base_tot_amt  like base_tot_amt no-undo.
define variable et_base_tax      like base_tax no-undo.
define variable et_conv_tot_amt  like base_tot_amt no-undo.
define variable et_conv_tax      like base_tax no-undo.
define variable et_org_tot_amt   like base_tot_amt no-undo.
define variable et_org_tax       like base_tax no-undo.

define variable l_base_rec_nonrec  like tx2d_recov_amt            no-undo.
define variable l_tx2d_rec_nonrec  like tx2d_recov_amt initial 0  no-undo.
define variable l_disp_rec_nonrec  like mfc_logical
   format "Recoverable/Non-Recover" initial yes
   label "Display Recoverable/Non-Recoverable Tax"               no-undo.
define variable l_rec_nonrec_label as  character format "x(30)"  no-undo.
define variable l_rec_nonrec_amt   like tx2d_recov_amt           no-undo.

define new shared workfile txw_wkfl no-undo
   field txw_code  like tx2d_tax_code
   field txw_type  like tx2d_tax_type
   field txw_class like tx2d_taxc
   field txw_usage like tx2d_tax_usage
   field txw_start like tx2_effdate
   field txw_taxable_amt like ap_amt
   field txw_amt   like ap_amt
   field txw_rec_nonrec_amt like tx2d_recov_amt.


{&TXAPRP-P-TAG2}

/* MUST DEFINE INTERNAL PROCEDURES HERE FOR FULL GUI REPORTS */

PROCEDURE p-convert-amt:

   define input parameter  l_eff_date   like ap_effdate no-undo.
   define input parameter  l_amt        like ap_amt     no-undo.
   define input parameter  l_curr       like ap_curr    no-undo.
   define input parameter  l_temp_rate1 like ap_ex_rate no-undo.
   define input parameter  l_temp_rate2 like ap_ex_rate no-undo.
   define output parameter l_ret_amt    like ap_amt     no-undo.

   define variable is_transparent       like mfc_logical no-undo.

   if base_rpt         = ""         and
      {&TXAPRP-P-TAG30}
      ap_mstr.ap_curr <> base_curr
      {&TXAPRP-P-TAG31}
      then
   assign
      disp_curr = getTermLabel("CURRENCY",1).
   {gprunp.i "mcpl" "p" "mc-chk-union-transparency"
      "(input l_curr,
        input et_report_curr,
        input l_eff_date,
        output is_transparent)"}

   if is_transparent
   then do:
      {gprunp.i "mcpl" "p" "mc-get-ex-rate"
         "(input l_curr,
           input et_report_curr,
           input "" "",
           input l_eff_date,
           output l_temp_rate1,
           output l_temp_rate2,
           output mc-error-number)"}

      if mc-error-number = 0
      then do:
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input l_curr,
              input et_report_curr,
              input l_temp_rate1,
              input l_temp_rate2,
              input l_amt,
              input true,  /* ROUND */
              output l_ret_amt,
              output mc-error-number)"}

      end. /* IF mc-error-number = 0 */

      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end. /* IF mc-error-number <> 0  */

   end. /* IF is_transparent */
   else
      do:

      /* CONVERT TO BASE CURRENCY */

      if (base_rpt      <> ""                    and
         mc_rpt_curr  <> et_report_curr        and
         mc_rpt_curr  <> base_curr)            or
         (base_rpt      = ""                    and
         l_curr       <> base_curr             and
         l_curr       <> et_report_curr)
      then do:
         /* CONVERT AMOUNT FROM TRANSACTION CURRENCY TO BASE CURRENCY */
         /* BASED ON TRANSACTION EXCHANGE RATE                        */

         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input l_curr,
              input base_curr,
              input l_temp_rate1,
              input l_temp_rate2,
              input l_amt,
              input true,  /* ROUND */
              output l_ret_amt,
              output mc-error-number)"}

         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end. /* IF mc-error-number <> 0 ... */
      end. /* IF base_rpt <> ... */
      else
         l_ret_amt = l_amt.

      /* CONVERT l_ret_amt TO THE REPORTING CURRENCY */

      if ((base_rpt     <> ""                   and
         mc_rpt_curr  <> et_report_curr)      or
         (base_rpt     =  ""                   and
         l_curr       <> et_report_curr))     and
         base_curr    <> et_report_curr
      then do:

         /* REPORTING CURRENCY DIFFEENT FROM THE TRANSACTON CURRENCY */
         /* EXCHANGE RATES FROM EXCHANGE RATE MASTER                 */
         /* TR CURRENCY = AUD   BASE CURRENCY (base_curr)     = USD  */
         /* CURRENCY (base_rpt) = AUD                                */
         /* REPORTING CURRENCY (et_report_curr) GBP                  */

         {gprunp.i "mcpl" "p" "mc-get-ex-rate"
            "(input  base_curr,
              input  et_report_curr,
              input  "" "",
              input  l_eff_date,
              output temp_rate1,
              output temp_rate2,
              output mc-error-number)"}

         if mc-error-number = 0
         then do:

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input base_curr,
                 input et_report_curr,
                 input temp_rate1,
                 input temp_rate2,
                 input l_ret_amt,
                 input true,  /* ROUND */
                 output l_ret_amt,
                 output mc-error-number)"}

         end. /* IF mc-error-number = 0 */

         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.
      end. /* IF base_rpt <> "" ...  */
   end. /* ELSE DO */
END PROCEDURE. /* PROCEDURE p-convert-amt */

{&TXAPRP-P-TAG3}

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
taxtype           colon 15
   taxtype1          label {t001.i} colon 49
   taxc              colon 15
   taxc1             label {t001.i} colon 49
   taxusage          colon 15
   taxusage1         label {t001.i} colon 49
   taxdate           colon 15
   taxdate1          label {t001.i} colon 49
   apdate            colon 15
   apdate1           label {t001.i} colon 49
   effdate           colon 15
   effdate1          label {t001.i} colon 49
   batch             colon 15
   batch1            label {t001.i} colon 49
   ref               colon 15 format "x(8)"
   ref1              label {t001.i} colon 49 format "x(8)"
   vend              colon 15
   vend1             label {t001.i} colon 49
   entity            colon 15
   entity1           label {t001.i} colon 49
   skip (1)
   show_conf         colon 43
   show_unconf       colon 43
   l_disp_rec_nonrec colon 43
   base_rpt          colon 43
   et_report_curr    colon 43

 SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " Selection Criteria "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


{&TXAPRP-P-TAG4}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM /*GUI*/ 
   ap_mstr.ap_batch
   vo_mstr.vo_ref
   ap_mstr.ap_ref label {&txaprp_p_9} format "x(8)"
   ap_mstr.ap_type
   ap_mstr.ap_date
   column-label {&txaprp_p_10}

/*cj*/ vo_mstr.vo_invoice

   ap_mstr.ap_vend

   base_amt label {&txaprp_p_5} /* LABEL FOR 2 COLUMNS */

   tx2d_det.tx2d_taxc
   base_tot_amt
   base_tax
   disp_curr no-label
   l_rec_nonrec_amt
with STREAM-IO /*GUI*/  frame b width 152 down.


/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

/* DEFINE HEADER */
FORM /*GUI*/  header

   mc-curr-label at 60
   et_report_curr
   skip
   mc-exch-label at 60
   mc-exch-line1
   skip
   mc-exch-line2 at 82
   skip
with STREAM-IO /*GUI*/  frame phead1 page-top width 132.

find first gl_ctrl no-lock.

{wbrp01.i}


/*GUI*/ {mfguirpa.i true "printer" 132 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


   if taxtype1  = hi_char  then taxtype1  = "".
   if taxc1     = hi_char  then taxc1     = "".
   if taxusage1 = hi_char  then taxusage1 = "".
   if taxdate   = low_date then taxdate   = ?.
   if taxdate1  = hi_date  then taxdate1  = ?.
   if apdate    = low_date then apdate    = ?.
   if apdate1   = hi_date  then apdate1   = ?.
   if effdate   = low_date then effdate   = ?.
   if effdate1  = hi_date  then effdate1  = ?.
   if batch1    = hi_char  then batch1    = "".
   if ref1      = hi_char  then ref1      = "".
   if vend1     = hi_char  then vend1     = "".
   if entity1   = hi_char  then entity1   = "".

   if c-application-mode <> 'web' then
   {&TXAPRP-P-TAG5}
   
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:

   {&TXAPRP-P-TAG29}

   {wbrp06.i &command = update
      &fields = "
        taxtype
        taxtype1
        taxc
        taxc1
        taxusage
        taxusage1
        taxdate
        taxdate1
        apdate
        apdate1
        effdate
        effdate1
        batch
        batch1
        ref
        ref1
        vend
        vend1
        entity
        entity1
        show_conf
        show_unconf
        l_disp_rec_nonrec
        base_rpt
        et_report_curr /* when (et_tk_active) */

        "
      &frm = "a"}
   {&TXAPRP-P-TAG6}

   assign
      l_rec_nonrec_label = if l_disp_rec_nonrec
                           then
                              getTermLabelRt("RECOVERABLE_TAX",16)
                           else
                              getTermLabelRt("NON-RECOVER_TAX",16).
      l_rec_nonrec_amt:label in frame b = l_rec_nonrec_label.

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".

      {gprun.i ""gpquote.p""
         "(input-output bcdparm, 20,
           input taxtype,
           input taxtype1,
           input taxc,
           input taxc1,
           input taxusage,
           input taxusage1,
           input taxdate,
           input taxdate1,
           input apdate,
           input apdate1,
           input effdate,
           input effdate1,
           input batch,
           input batch1,
           input ref,
           input ref1,
           input vend,
           input vend1,
           input entity,
           input entity1)"}

      {gprun.i ""gpquote.p""
         "(input-output bcdparm, 4,
           input show_conf,
           input show_unconf,
           input base_rpt,
           input et_report_curr,
           input null_char,
           input null_char,
           input null_char,
           input null_char,
           input null_char,
           input null_char,
           input null_char,
           input null_char,
           input null_char,
           input null_char,
           input null_char,
           input null_char,
           input null_char,
           input null_char,
           input null_char,
           input null_char)"}

      {&TXAPRP-P-TAG7}

      if taxtype1  = "" then taxtype1  = hi_char.
      if taxc1     = "" then taxc1     = hi_char.
      if taxusage1 = "" then taxusage1 = hi_char.
      if taxdate   = ?  then taxdate   = low_date.
      if taxdate1  = ?  then taxdate1  = hi_date.
      if apdate    = ?  then apdate    = low_date.
      if apdate1   = ?  then apdate1   = hi_date.
      if effdate   = ?  then effdate   = low_date.
      if effdate1  = ?  then effdate1  = hi_date.
      if batch1    = "" then batch1    = hi_char.
      if ref1      = "" then ref1      = hi_char.
      if vend1     = "" then vend1     = hi_char.
      if entity1   = "" then entity1   = hi_char.

      if base_rpt = "" then
         mc_rpt_curr = base_curr.
      else
         mc_rpt_curr = base_rpt.

      /* BEGIN DELETE */

      /* END DELETE */

      if et_report_curr <> "" then do:
         {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
            "(input et_report_curr,
              output mc-error-number)"}
         if mc-error-number = 0
            and et_report_curr <> mc_rpt_curr then do:

            {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
               "(input et_report_curr,
                 input mc_rpt_curr,
                 input "" "",
                 input et_eff_date,
                 output et_rate2,
                 output et_rate1,
                 output mc-seq,
                 output mc-error-number)"}
         end.  /* if mc-error-number = 0 */

         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
            if c-application-mode = 'web' then return.
            else /*GUI NEXT-PROMPT removed */
            /*GUI UNDO removed */ RETURN ERROR.
         end.  /* if mc-error-number <> 0 */
         else do:

            {gprunp.i "mcui" "p" "mc-ex-rate-output"
               "(input et_report_curr,
                 input mc_rpt_curr,
                 input et_rate2,
                 input et_rate1,
                 input mc-seq,
                 output mc-exch-line1,
                 output mc-exch-line2)"}
            {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
               "(input mc-seq)"}
         end.
      end.  /* if et_report_curr <> "" */
      if et_report_curr = ""
         or et_report_curr = mc_rpt_curr then
      assign
         mc-exch-line1 = ""
         mc-exch-line2 = ""
         et_report_curr = mc_rpt_curr.

   end. /* C-APPLICATION-MODE <> WEB */

   /* OUTPUT DESTINATION SELECTION */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
find first gl_ctrl no-lock.

define buffer apmstr for ap_mstr.


   {&TXAPRP-P-TAG8}
   {mfphead.i}

   view frame phead1.

   for each ap_mstr
         where (ap_batch >= batch)
         and (ap_batch <= batch1)
         and (ap_ref >= ref)
         and (ap_ref <= ref1)
         and (ap_vend >= vend)
         and (ap_vend <= vend1)

         /*     AP_MSTR IS NOT RELEVANT. THE ENTITY
                OF THE VOUCHER BEING PAID IS THE */
         /*     ONE THAT WE NEED TO CHECK        */

         and (ap_date >= apdate)
         and (ap_date <= apdate1)
         and (ap_effdate >= effdate)
         and (ap_effdate <= effdate1)
         and ((ap_curr = base_rpt)
         or (base_rpt = ""))
      no-lock
         break by ap_batch
         by ap_ref:

      
/*GUI*/ {mfguichk.i  } /*Replace mfrpchk*/


      /* ASSIGN RNDMTHD */

      /* GET ROUNDING METHOD FROM CURRENCY MASTER */
      {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
         "(input ap_curr,
           output rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         if c-application-mode <> "WEB" then
            pause.
         next.
      end.

      /*------------------------------------------------------------*/

      if ap_type = "VO"
      then do:

         if (ap_entity < entity or ap_entity > entity1)
            then next.

         find vo_mstr where vo_ref = ap_ref no-lock.
         if ((show_conf and vo_confirmed)
            or (show_unconf and not vo_confirmed))
            and (vo_tax_date >= taxdate)
            and (vo_tax_date <= taxdate1)
         then do:

            /* TX2D_DET TABLE IS USED INSTEAD OF VOD_DET TO DISPLAY  */
            /* ALL TAX CLASSES WHEN VOUCHER IS CREATED WITH MULTIPLE */
            /* TAX CLASSES AND SAME PO RECEIPT ACCOUNT               */

            for each tx2d_det
                  where tx2d_ref        =  ap_ref    and
                  tx2d_taxc      >=  taxc      and
                  tx2d_taxc      <=  taxc1     and
                  tx2d_tax_usage >=  taxusage  and
                  tx2d_tax_usage <=  taxusage1 and
                  tx2d_tax_type  >=  taxtype   and
                  tx2d_tax_type  <=  taxtype1  and
                  tx2d_tr_type    =  "22" /* VOUCHER */
               no-lock
                  break by tx2d_taxc
                  by tx2d_tax_code
                  by tx2d_line:

               /* SHOW ALL AMOUNTS AS DEBITS */
               assign

                  base_amt = tx2d_totamt

                  disp_curr = " ".

               {&TXAPRP-P-TAG9}
               /* PROCEDURE p-convert-amt USED TO CONVERT AMOUNT FROM FOREIGN */
               /* TO BASE AND THEN TO REPORTING CURRENCY                      */

               /* CONVERT AMOUNT TO REPORTING CURRENCY */
               run p-convert-amt
                  (input  ap_mstr.ap_effdate,
                  input  base_amt,
                  input  ap_mstr.ap_curr,
                  input  ap_mstr.ap_ex_rate,
                  input  ap_mstr.ap_ex_rate2,
                  output et_base_amt).
               {&TXAPRP-P-TAG10}

               display
                  ap_mstr.ap_batch
                  vo_mstr.vo_ref
                  " " @ ap_mstr.ap_ref
                  ap_mstr.ap_type
                  ap_mstr.ap_date

/*cj*/            vo_mstr.vo_invoice

                  ap_mstr.ap_vend

                  et_base_amt @
                  base_amt

                  tx2d_taxc
                  " " @ base_tot_amt
                  " " @ base_tax
                  disp_curr no-label
                  " " @ l_rec_nonrec_amt
               with frame b STREAM-IO /*GUI*/ .
               down 1 with frame b.

               display
                  " " @ ap_mstr.ap_batch
                  " " @ vo_mstr.vo_ref
                  " " @ ap_mstr.ap_ref
                  " " @ ap_mstr.ap_type
                  " " @ ap_mstr.ap_date
                  ap_mstr.ap_effdate @ ap_mstr.ap_date

/*cj*/            " " @ vo_mstr.vo_invoice

                  " " @ ap_mstr.ap_vend

                  " " @ base_amt

                  " " @ tx2d_det.tx2d_taxc
                  " " @ base_tot_amt
                  " " @ base_tax
                  " " @ disp_curr no-label
                  " " @ l_rec_nonrec_amt
               with frame b STREAM-IO /*GUI*/ .
               down 1 with frame b.

               if vo_tax_date <> ap_mstr.ap_effdate
                  then
               put space(10)

                  {gplblfmt.i
                  &FUNC=getTermLabel(""TAX_DATE"",15)
                  &CONCAT = "':  '"
                  }
                  vo_mstr.vo_tax_date skip.
               {&TXAPRP-P-TAG11}

               if last-of(tx2d_taxc)
                  then
               assign
                  tax_printed = false.

               find first tx2_mstr
                  where tx2_tax_code = tx2d_tax_code
               no-lock.

               /* CONVERT AMOUNT TO REPORTING CURRENCY */

               run p-convert-amt
                  (input  ap_mstr.ap_effdate,
                  input  tx2d_det.tx2d_tottax,
                  input  tx2d_det.tx2d_curr,
                  input  ap_mstr.ap_ex_rate,
                  input  ap_mstr.ap_ex_rate2,
                  output temp_tx2d_tottax).

               run p-convert-amt
                  (input  ap_mstr.ap_effdate,
                  input  tx2d_det.tx2d_cur_tax_amt,
                  input  tx2d_det.tx2d_curr,
                  input  ap_mstr.ap_ex_rate,
                  input  ap_mstr.ap_ex_rate2,
                  output l_tx2d_tax_amt).

               /* CALCULATE THE RECOVERABLE/NON-RECOVABLE TAX AMOUNT */
               l_rec_nonrec_amt = (if l_disp_rec_nonrec
                                   then
                                      tx2d_cur_recov_amt
                                   else
                                      (tx2d_cur_tax_amt - tx2d_cur_recov_amt)).

               /* CONVERT THE RECOVERABLE/NON-RECOVABLE TAX AMOUNT */
               /* TO REPORTING CURRENCY                            */
               run p-convert-amt
                  (input  ap_mstr.ap_effdate,
                  input  l_rec_nonrec_amt,
                  input  tx2d_det.tx2d_curr,
                  input  ap_mstr.ap_ex_rate,
                  input  ap_mstr.ap_ex_rate2,
                  output l_tx2d_rec_nonrec).

               assign
                  base_tot_amt      = base_tot_amt      + temp_tx2d_tottax
                  base_tax          = base_tax          + l_tx2d_tax_amt.
                  l_base_rec_nonrec = l_base_rec_nonrec + l_tx2d_rec_nonrec.

               /* ADD TO WORKFILE FOR TAX SUMMARY */
               find first txw_wkfl
                  where txw_code = tx2d_tax_code
                  no-error.
               if available txw_wkfl then
               do:
                  assign
                     txw_taxable_amt     = txw_taxable_amt
                                           + temp_tx2d_tottax
                     txw_amt             = txw_amt + l_tx2d_tax_amt
                     txw_rec_nonrec_amt  = txw_rec_nonrec_amt
                                           + l_tx2d_rec_nonrec.

               end. /* IF AVAILABLE TXW_WKFL */

               else do:
                  create txw_wkfl.
                  assign
                     txw_code            = tx2d_tax_code
                     txw_type            = tx2d_tax_type
                     txw_class           = tx2d_taxc
                     txw_usage           = tx2d_tax_usage
                     txw_start           = tx2_effdate
                     txw_taxable_amt     = temp_tx2d_tottax
                     txw_amt             = l_tx2d_tax_amt
                     txw_rec_nonrec_amt  = l_tx2d_rec_nonrec.

               end.

               if last-of(tx2d_tax_code)
               then do:
                  disp_curr = " ".

                  /* VARIABLE base_tax AND base_tot_amt
                  ARE IN REPORTING CURRENCY */

                  assign
                     et_base_tot_amt = base_tot_amt
                     et_base_tax     = base_tax.

                  {&TXAPRP-P-TAG12}
                  if et_base_tax <> 0 or et_base_tot_amt <> 0
                  then do:
                     {&TXAPRP-P-TAG13}

                     display
                        " " @ ap_mstr.ap_batch
                        " " @ vo_mstr.vo_ref
                        " " @ ap_mstr.ap_ref
                        " " @ ap_mstr.ap_type
                        " " @ ap_mstr.ap_date

/*cj*/                  " " @ vo_mstr.vo_invoice

                        " " @ ap_mstr.ap_vend

                        tx2d_tax_code @ base_amt

                        " " @ tx2d_det.tx2d_taxc
                        et_base_tot_amt @
                        base_tot_amt
                        et_base_tax @
                        base_tax
                        disp_curr no-label
                        l_base_rec_nonrec when (l_base_rec_nonrec <> 0)
                        @ l_rec_nonrec_amt
                     with frame b STREAM-IO /*GUI*/ .
                     down 1 with frame b.
                     tax_printed = true.

                  end. /* IF BASE_TAX <> 0 */

                  accumulate base_tot_amt(total).
                  accumulate base_tax(total).
                  accumulate et_base_tot_amt (total).
                  accumulate et_base_tax (total).
                  accumulate l_base_rec_nonrec (total).

                  assign
                     base_tot_amt      = 0
                     base_tax          = 0
                     et_base_tot_amt   = 0
                     et_base_tax       = 0
                     l_base_rec_nonrec = 0.

               end. /* IF LAST-OF TX2D_TAX_CODE */

               {&TXAPRP-P-TAG14}
               if not tax_printed and
                  last-of(tx2d_taxc)
               then do:
                  {&TXAPRP-P-TAG15}
                  display
                     " " @ ap_mstr.ap_batch
                     " " @ vo_mstr.vo_ref
                     " " @ ap_mstr.ap_ref
                     " " @ ap_mstr.ap_type
                     " " @ ap_mstr.ap_date

/*cj*/               " " @ vo_mstr.vo_invoice

                     " " @ ap_mstr.ap_vend

                     " " @ base_amt

                     " " @ tx2d_det.tx2d_taxc
                     et_base_tot_amt @
                     base_tot_amt
                     et_base_tax @
                     base_tax
                     " " @ disp_curr no-label
                     l_base_rec_nonrec when (l_base_rec_nonrec <> 0)
                     @ l_rec_nonrec_amt
                  with frame b STREAM-IO /*GUI*/ .
                  down 1 with frame b.
               end. /* IF NOT TAX_PRINTED */

            end. /* FOR EACH TX2D_DET (CHANGED FROM VOD_DET) */
         end. /* IF VO_CONFIRMED .. */
      end. /* IF AP_TYPE = "VO" */
      /*------------------------------------------------------------*/
      else

      if ap_type = "CK"
      then do:

         find ck_mstr where ck_ref = ap_ref no-lock.
         if ck_status <> "VOID" then
         for each ckd_det where ckd_ref = ck_ref no-lock:
            /* EACH CKD_DET IS FOR THE PAYMENT OF ONE VOUCHER */

            find vo_mstr where vo_ref = ckd_voucher
            no-lock no-error.
            if available vo_mstr
               and (vo_tax_date >= taxdate)
               and (vo_tax_date <= taxdate1)
            then do:
               find apmstr
                  where apmstr.ap_ref = vo_ref
                  and apmstr.ap_type = "VO"
               no-lock.
               if available apmstr then do:

                  if (apmstr.ap_entity < entity or
                     apmstr.ap_entity > entity1) then next.

                  for each tx2d_det
                        where tx2d_ref        =  ap_mstr.ap_ref and
                        tx2d_nbr        =  vo_ref         and
                        tx2d_taxc      >=  taxc           and
                        tx2d_taxc      <=  taxc1          and
                        tx2d_tax_usage >=  taxusage       and
                        tx2d_tax_usage <=  taxusage1      and
                        tx2d_tax_type  >=  taxtype        and
                        tx2d_tax_type  <=  taxtype1       and
                        tx2d_tr_type    =  "29" /* DISCOUNT */
                     no-lock
                        break by tx2d_taxc
                        by tx2d_tax_code
                        by tx2d_line:

                     /* DETAIL LINE, NOT A TAX LINE */

                     assign
                        base_amt = tx2d_totamt.

                     /* ROUND PER DOC CURRENCY */

                     {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output base_amt,
                          input        rndmthd,
                          output       mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.

                     disp_curr = " ".

                     /* CONVERT AMOUNT TO REPORTING CURRENCY */
                     run p-convert-amt
                        (input  ap_mstr.ap_effdate,
                        input  base_amt,
                        input  ap_mstr.ap_curr,
                        input  ap_mstr.ap_ex_rate,
                        input  ap_mstr.ap_ex_rate2,
                        output et_base_amt).

                     {&TXAPRP-P-TAG16}
                     display
                        ap_mstr.ap_batch
                        vo_mstr.vo_ref
                        ap_mstr.ap_ref
                        ap_mstr.ap_type
                        ap_mstr.ap_date

/*cj*/                  " " @ vo_mstr.vo_invoice

                        ap_mstr.ap_vend

                        et_base_amt @
                        base_amt

                        tx2d_taxc
                        " " @ base_tot_amt
                        " " @ base_tax
                        disp_curr no-label
                        " " @ l_rec_nonrec_amt
                     with frame b STREAM-IO /*GUI*/ .
                     down 1 with frame b.

                     display
                        " " @ ap_mstr.ap_batch
                        " " @ vo_mstr.vo_ref
                        " " @ ap_mstr.ap_ref
                        " " @ ap_mstr.ap_type
                        " " @ ap_mstr.ap_date
                        ap_mstr.ap_effdate @ ap_mstr.ap_date

/*cj*/                  " " @ vo_mstr.vo_invoice

                        " " @ ap_mstr.ap_vend

                        " " @ base_amt

                        " " @ tx2d_det.tx2d_taxc
                        " " @ base_tot_amt
                        " " @ base_tax
                        " " @ disp_curr no-label
                        " " l_rec_nonrec_amt
                     with frame b STREAM-IO /*GUI*/ .
                     down 1 with frame b.

                     if vo_tax_date <> ap_mstr.ap_effdate
                        then
                     put space(10)

                        {gplblfmt.i
                        &FUNC=getTermLabel(""TAX_DATE"",15)
                        &CONCAT = "':  '"
                        }
                        vo_mstr.vo_tax_date skip.

                     {&TXAPRP-P-TAG17}

                     if last-of(tx2d_taxc)
                        then
                     assign
                        tax_printed = false.

                     /* TX2D_REF HAS BANK AND CHECK NUMBER */
                     /* TX2D_NBR HAS VOUCHER NUMBER.       */

                     find first tx2_mstr
                        where tx2_tax_code = tx2d_tax_code
                     no-lock.

                     /* WHEN PAYMENT IS IN BASE CURRENCY
                        AND INVOICE IS IN     */
                     /* FOREIGN CURRENCY EXCHANGE RATE in ap_mstr
                     ARE SET TO   */
                     /* EXCHANGE RATE MASTER       */

                     if ap_mstr.ap_curr = base_curr and
                        ap_mstr.ap_curr <> apmstr.ap_curr
                     then do:
                        if tx2d_det.tx2d_curr <> et_report_curr
                        then do:

                           {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                              "(input  tx2d_det.tx2d_curr,
                                input  base_curr,
                                input  "" "",
                                input  ap_mstr.ap_effdate,
                                output temp_rate1,
                                output temp_rate2,
                                output mc-error-number)"}

                           if mc-error-number = 0 then
                          do:

                              {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input tx2d_det.tx2d_curr,
                                   input base_curr,
                                   input temp_rate1,
                                   input temp_rate2,
                                   input tx2d_det.tx2d_tottax,
                                   input true,  /* ROUND */
                                   output temp_tx2d_tottax,
                                   output mc-error-number)"}

                              assign
                                 l_tx2d_tax_amt = tx2d_tax_amt.

                           end. /* IF mc-error-number = 0  */

                           if mc-error-number <> 0
                           then do:
                              {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                           end. /* IF mc-error-number <> 0 */

                           if base_curr <> et_report_curr
                           then do:

                              {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                                 "(input  base_curr,
                                   input  et_report_curr,
                                   input  "" "",
                                   input  ap_mstr.ap_effdate,
                                   output temp_rate1,
                                   output temp_rate2,
                                   output mc-error-number)"}

                              if mc-error-number = 0 then
                              do:

                                 {gprunp.i "mcpl" "p" "mc-curr-conv"
                                    "(input base_curr,
                                      input et_report_curr,
                                      input temp_rate1,
                                      input temp_rate2,
                                      input temp_tx2d_tottax,
                                      input true,  /* ROUND */
                                      output temp_tx2d_tottax,
                                      output mc-error-number)"}

                                 if mc-error-number <> 0
                                 then do:
                                    {pxmsg.i &MSGNUM=mc-error-number
                                       &ERRORLEVEL=2}
                                 end. /* IF mc-error... */

                                 {gprunp.i "mcpl" "p" "mc-curr-conv"
                                    "(input base_curr,
                                      input et_report_curr,
                                      input temp_rate1,
                                      input temp_rate2,
                                      input l_tx2d_tax_amt,
                                      input true,  /* ROUND */
                                      output l_tx2d_tax_amt,
                                      output mc-error-number)"}

                                 if mc-error-number <> 0
                                 then do:
                                    {pxmsg.i &MSGNUM=mc-error-number
                                       &ERRORLEVEL=2}
                                 end. /* IF mc-error ... */

                                 {gprunp.i "mcpl" "p" "mc-curr-conv"
                                    "(input base_curr,
                                      input et_report_curr,
                                      input temp_rate1,
                                      input temp_rate2,
                                      input l_tx2d_rec_nonrec,
                                      input true,  /* ROUND */
                                      output l_tx2d_rec_nonrec,
                                      output mc-error-number)"}
                                 if mc-error-number <> 0
                                 then do:
                                    {pxmsg.i &MSGNUM=mc-error-number
                                       &ERRORLEVEL=2}
                                 end. /* IF mc-error ... */

                              end. /* IF mc-error-number = 0 */
                           end. /* IF base_curr <> ... */
                        end. /* IF tx2d_det.tx2d_curr <> ... */
                        else
                           assign
                              temp_tx2d_tottax  = tx2d_det.tx2d_tottax
                              l_tx2d_tax_amt    = tx2d_cur_tax_amt
                              l_tx2d_rec_nonrec = if l_disp_rec_nonrec
                                                  then
                                                     tx2d_cur_recov_amt
                                                  else
                                                     (tx2d_cur_tax_amt
                                                      - tx2d_cur_recov_amt).

                     end. /* IF ap_mstr.ap_curr = base_curr ... */
                     else do:
                        /* WHEN PAYMENT CURRENCY IS EQUAL TO */
                        /* INVOICE CURRENCY                  */

                        /* CONVERT AMOUNT TO REPORTING CURRENCY */

                        run p-convert-amt
                           (input ap_mstr.ap_effdate,
                           input  tx2d_det.tx2d_tottax,
                           input  tx2d_det.tx2d_curr,
                           input  ap_mstr.ap_ex_rate,
                           input  ap_mstr.ap_ex_rate2,
                           output temp_tx2d_tottax).

                        run p-convert-amt
                           (input  ap_mstr.ap_effdate,
                           input  tx2d_det.tx2d_cur_tax_amt,
                           input  tx2d_det.tx2d_curr,
                           input  ap_mstr.ap_ex_rate,
                           input  ap_mstr.ap_ex_rate2,
                           output l_tx2d_tax_amt).

                        /* CALCULATE THE RECOVERABLE/NON-RECOVABLE TAX AMOUNT */
                        l_rec_nonrec_amt = if l_disp_rec_nonrec
                                           then
                                              tx2d_cur_recov_amt
                                           else
                                              (tx2d_cur_tax_amt
                                               - tx2d_cur_recov_amt).

                        /* CONVERT THE RECOVERABLE/NON-RECOVABLE TAX AMOUNT */
                        /* TO REPORTING CURRENCY                            */
                        run p-convert-amt
                           (input  ap_mstr.ap_effdate,
                           input  l_rec_nonrec_amt,
                           input  tx2d_det.tx2d_curr,
                           input  ap_mstr.ap_ex_rate,
                           input  ap_mstr.ap_ex_rate2,
                           output l_tx2d_rec_nonrec).

                     end. /* ELSE DO */

                     assign
                        base_tot_amt      = base_tot_amt
                                            + temp_tx2d_tottax
                        base_tax          = base_tax
                                            + l_tx2d_tax_amt
                        l_base_rec_nonrec = l_base_rec_nonrec
                                            + l_tx2d_rec_nonrec.

                     /* ADD TO WORKFILE FOR TAX SUMMARY */
                     find first txw_wkfl
                        where txw_code = tx2d_tax_code
                        no-error.
                     if available txw_wkfl then
                     do:
                        assign
                           txw_taxable_amt     = txw_taxable_amt
                                                 + temp_tx2d_tottax
                           txw_amt             = txw_amt + l_tx2d_tax_amt
                           txw_rec_nonrec_amt  = txw_rec_nonrec_amt
                                                 + l_tx2d_rec_nonrec.

                     end. /* IF AVAILABLE TXW_WKFL */

                     else do:
                        create txw_wkfl.
                        assign
                           txw_code            = tx2d_tax_code
                           txw_type            = tx2d_tax_type
                           txw_class           = tx2d_taxc
                           txw_usage           = tx2d_tax_usage
                           txw_start           = tx2_effdate

                           txw_taxable_amt     = temp_tx2d_tottax
                           txw_amt             = l_tx2d_tax_amt
                           txw_rec_nonrec_amt  = l_tx2d_rec_nonrec.

                     end.

                     if last-of(tx2d_tax_code)
                     then do:
                        disp_curr = " ".

                        /* VARIABLES base_tax AND base_tot_amt
                           ARE IN REPORTING CURRENCY */

                        assign
                           et_base_tot_amt = base_tot_amt
                           et_base_tax     = base_tax.

                        {&TXAPRP-P-TAG18}
                        if et_base_tax <> 0 or
                           et_base_tot_amt <> 0
                        then do:
                           {&TXAPRP-P-TAG19}

                           display
                              " " @ ap_mstr.ap_batch
                              " " @ vo_mstr.vo_ref
                              " " @ ap_mstr.ap_ref
                              " " @ ap_mstr.ap_type
                              " " @ ap_mstr.ap_date

/*cj*/                        " " @ vo_mstr.vo_invoice

                              " " @ ap_mstr.ap_vend

                              tx2d_tax_code @ base_amt

                              " " @ tx2d_det.tx2d_taxc
                              et_base_tot_amt @
                              base_tot_amt
                              et_base_tax @
                              base_tax
                              disp_curr no-label
                              l_base_rec_nonrec when (l_base_rec_nonrec <> 0)
                              @ l_rec_nonrec_amt
                           with frame b STREAM-IO /*GUI*/ .
                           down 1 with frame b.
                           tax_printed = true.

                        end. /* IF BASE_TAX <> 0 */

                        accumulate base_tot_amt(total).
                        accumulate base_tax(total).
                        accumulate et_base_tot_amt (total).
                        accumulate et_base_tax (total).
                        accumulate l_base_rec_nonrec (total).

                        assign
                           et_base_tot_amt   = 0
                           et_base_tax       = 0
                           base_tot_amt      = 0
                           base_tax          = 0
                           l_base_rec_nonrec = 0.

                     end. /* IF LAST-OF TX2D_TAX_CODE */

                     {&TXAPRP-P-TAG20}
                     if not tax_printed and
                        last-of(tx2d_taxc)
                     then do:
                        {&TXAPRP-P-TAG21}
                        display
                           " " @ ap_mstr.ap_batch
                           " " @ vo_mstr.vo_ref
                           " " @ ap_mstr.ap_ref
                           " " @ ap_mstr.ap_type
                           " " @ ap_mstr.ap_date

/*cj*/                     " " @ vo_mstr.vo_invoice

                           " " @ ap_mstr.ap_vend

                           " " @ base_amt

                           " " @ tx2d_det.tx2d_taxc
                           et_base_tot_amt @
                           base_tot_amt
                           et_base_tax @
                           base_tax
                           " " @ disp_curr no-label
                           l_base_rec_nonrec when (l_base_rec_nonrec <> 0)
                           @ l_rec_nonrec_amt
                        with frame b STREAM-IO /*GUI*/ .
                        down 1 with frame b.
                     end. /* IF NOT TAX_PRINTED */

                  end. /* FOR EACH TX2D_DET (CHANGED FROM VOD_DET) */
               end. /* IF AVAILABLE AP_MSTR */
            end. /* IF AVAILABLE vo_mstr */
         end. /* FOR EACH CKD_DET */
      end. /* IF AP_TYPE = "CK" */
      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

   end. /* FOR EACH AP_MSTR */
   /*---------------------------------------------------------------*/

   {&TXAPRP-P-TAG22}
   /* DISPLAY REPORT TOTALS */
   underline base_tot_amt base_tax l_rec_nonrec_amt with frame b.
   display

      "     " +

      et_report_curr

      + " " + getTermLabelRtColon("TOTAL",6)
      format "x(15)" @ base_amt
      /*L00M
      *             accum total base_tot_amt format "->>>,>>>,>>9.99" @ base_tot_amt
      *             accum total base_tax format "->>>,>>>,>>9.99" @ base_tax
      *L00M*/

      accum total et_base_tot_amt format "->>>,>>>,>>9.99"
      @ base_tot_amt
      accum total et_base_tax format "->>>,>>>,>>9.99"
      @ base_tax
      accum total l_base_rec_nonrec format "->>>,>>>,>>9.99"
      @ l_rec_nonrec_amt

   with frame b STREAM-IO /*GUI*/ .
   {&TXAPRP-P-TAG23}

   if et_ctrl.et_show_diff then do:
      assign
         et_org_tot_amt  = accum total base_tot_amt
         et_org_tax      = accum total base_tax
         et_conv_tot_amt = accum total et_base_tot_amt
         et_conv_tax     = accum total et_base_tax.

      /* VARIABLES  et_org_tot_amt,et_org_tax,et_conv_tot_amt */
      /* AND et_conv_tax ARE IN REPORTING CURRENCY            */
      /* HENCE COMMENTED SECTION BELOW                        */

      {&TXAPRP-P-TAG24}
      if (et_org_tot_amt <> et_conv_tot_amt or
         et_org_tax     <> et_conv_tax  )
      then do:
         {&TXAPRP-P-TAG25}
         down with frame b.
         display et_diff_txt format "x(15)" @ base_amt
            et_conv_tot_amt - et_org_tot_amt
            format "->>>,>>>,>>9.99" @ base_tot_amt
            et_conv_tax - et_org_tax
            format "->>>,>>>,>>9.99" @ base_tax
         with frame b STREAM-IO /*GUI*/ .
      end.
   end.

   {&TXAPRP-P-TAG26}
   down 1 with frame b.

   assign
      l_aparflag = "AP".
   {&TXAPRP-P-TAG27}

   /* DISPLAY SUMMARY BY TAX RATE */

   /* ADDED VARIABLE l_aparflag TO DISPLAY SALES TAX ACCOUNT AND */
   /* COST-CENTER ONLY FOR AR TAX RATE AND TRANSACTION REPORTS.  */

   {gprun.i ""txarapa.p""
      "(input l_aparflag,
        input l_disp_rec_nonrec)"}

   hide frame phead1.
   /* REPORT TRAILER */
   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end. /* REPEAT */

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" taxtype taxtype1 taxc taxc1 taxusage taxusage1 taxdate taxdate1 apdate apdate1 effdate effdate1 batch batch1 ref ref1 vend vend1 entity entity1 show_conf show_unconf l_disp_rec_nonrec base_rpt et_report_curr  {&TXAPRP-P-TAG28} "} /*Drive the Report*/
