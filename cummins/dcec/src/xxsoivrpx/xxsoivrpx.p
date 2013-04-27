/* GUI CONVERTED from soivrp.p (converter v1.78) Mon Aug 25 03:59:36 2008 */
/* soivrp.p - PENDING INVOICE REGISTER                                       */
/* Copyright 1986-2008 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.13.1.8.3.1 $                                                              */
/* REVISION: 6.0      LAST MODIFIED: 07/11/90   BY: WUG *D051*               */
/* REVISION: 6.0      LAST MODIFIED: 08/17/90   BY: MLB *D055*               */
/* REVISION: 5.0      LAST MODIFIED: 08/18/90   BY: MLB *B755*               */
/* REVISION: 6.0      LAST MODIFIED: 12/27/90   BY: MLB *D238*               */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: afs *D387*               */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: afs *D425*               */
/* REVISION: 6.0      LAST MODIFIED: 04/05/91   BY: bjb *D507*               */
/* REVISION: 6.0      LAST MODIFIED: 08/14/91   BY: MLV *D825*               */
/* REVISION: 6.0      LAST MODIFIED: 10/09/91   BY: dgh *D892*               */
/* REVISION: 7.0      LAST MODIFIED: 02/11/92   BY: tjs *F191*               */
/* REVISION: 7.0      LAST MODIFIED: 02/27/92   BY: tjs *F244*               */
/* REVISION: 7.0      LAST MODIFIED: 03/11/92   BY: tjs *F247*               */
/* REVISION: 7.0      LAST MODIFIED: 03/18/92   BY: TMD *F263*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 03/27/92   BY: tjs *F328*               */
/* REVISION: 7.0      LAST MODIFIED: 03/30/92   BY: tjs *F333*               */
/* REVISION: 7.0      LAST MODIFIED: 04/08/92   BY: tmd *F367*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 06/19/92   BY: tmd *F458*               */
/* REVISION: 7.3      LAST MODIFIED: 09/06/92   BY: afs *G047*               */
/* REVISION: 7.3      LAST MODIFIED: 04/05/93   BY: tjs *G858*               */
/* REVISION: 7.3      LAST MODIFIED: 05/04/93   BY: tjs *GA65*               */
/* REVISION: 7.4      LAST MODIFIED: 06/16/93   BY: skk *H002*               */
/* REVISION: 7.4      LAST MODIFIED: 07/14/93   BY: jjs *H050*               */
/* REVISION: 7.4      LAST MODIFIED: 11/11/94   BY: afs *H593*               */
/* REVISION: 7.4      LAST MODIFIED: 12/28/94   BY: bcm *F0C0*               */
/* REVISION: 7.4      LAST MODIFIED: 03/09/95   BY: kjm *F0LC*               */
/* REVISION: 8.5      LAST MODIFIED: 09/01/95   BY: taf *J053*               */
/* REVISION: 8.6      LAST MODIFIED: 06/26/96   BY: bjl *K001*               */
/* REVISION: 8.6      LAST MODIFIED: 11/12/96   BY: *H0N9* Aruna Patil       */
/*                                   03/19/97   BY: *K082* E. Hughart        */
/* REVISION: 8.6      LAST MODIFIED: 10/04/97   BY: ckm *K0LD*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 07/01/98   BY: *L024* Sami Kureishy     */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0JM* BalbeerS Rajput   */
/* REVISION: 9.1      LAST MODIFIED: 12/22/00   BY: *L16X* Seema Tyagi       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.13.1.5   BY: Paul Donnelly        DATE: 02/08/02  ECO: *N16J*  */
/* Revision: 1.13.1.6  BY: John Corda DATE: 08/09/02 ECO: *N1QP* */
/* Revision: 1.13.1.8  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/* $Revision: 1.13.1.8.3.1 $ BY: Mallika Poojary DATE: 08/14/08 ECO: *P6Z8* */
/*-Revision end---------------------------------------------------------------*/


/*V8:ConvertMode=FullGUIReport                                               */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* THIS REPORT USES THE gltw_wkfl TO ACCUMULATE GL      */
/* TRANSACTIONS AND THEN DOES AN UNDO TO DELETE THEN    */

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "1+ "}
{xxgetsoivrp.i "new"}
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE soivrp_p_1 "Consolidated Cr"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp_p_3 "Include Ready To Post"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp_p_4 "Consolidated Dr"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp_p_5 "Debit Amount"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp_p_6 "Include Ready To Print Invoice"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp_p_7 "Consolidate Invoices"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp_p_8 "Credit Amount"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp_p_9 "Print Lot/Serial Numbers Shipped"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp_p_10 "Print Only Lines To Invoice"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i new}
{gldynrm.i new}

define new shared variable tot_base_amt like ar_amt.

define new shared variable tot_base_price as decimal
   format "->>>>,>>>,>>9.99".

define new shared variable tot_base_margin as decimal
   format "->>>>,>>>,>>9.99".
define new shared variable nbr like so_nbr.
define new shared variable nbr1 like so_nbr.
define new shared variable shipdate like so_ship_date.
define new shared variable shipdate1 like shipdate.
define new shared variable cust  like so_cust.
define new shared variable cust1 like so_cust.
define new shared variable bill  like so_bill.
define new shared variable bill1 like so_bill.
define new shared variable print_ready2inv like mfc_logical
   initial yes.
define new shared variable print_ready2post like mfc_logical
   initial no.
define new shared variable inv_only like mfc_logical initial yes.
define new shared variable print_lotserials like mfc_logical
   label {&soivrp_p_9}.

define variable dr_amt as decimal format "->>,>>>,>>>,>>9.99"
   label {&soivrp_p_5}.
define variable cr_amt as decimal format "->>,>>>,>>>,>>9.99"
   label {&soivrp_p_8}.
define variable runok_noundo like mfc_logical no-undo initial no.
define new shared variable conso like mfc_logical initial no
   label {&soivrp_p_7}.
define variable tot_price_fmt as character no-undo.
define variable tot_marg_fmt as character no-undo.
define variable tot_amt_fmt as character no-undo.
define variable gltwdr_fmt as character no-undo.
define variable gltwdr as decimal format "->>>>,>>>,>>9.99" no-undo.
define variable gltwcr_fmt as character no-undo.
define variable gltwcr as decimal format "->>>>,>>>,>>9.99" no-undo.
define variable rptstr as character format "x(19)" no-undo.
define variable l_cnt as integer no-undo.
define variable l_ref like so_inv_nbr no-undo.
define new shared variable m_cons_cnt as int init 0 no-undo.
define variable fname as character format "x(120)" initial "c:\invoice.xls" no-undo.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/

 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
nbr                  colon 15
   nbr1                 label {t001.i} colon 50 skip
   shipdate             colon 15
   shipdate1            label {t001.i} colon 50 skip
   cust           colon 15
   cust1          label {t001.i} colon 50 skip
   bill           colon 15
   bill1          label {t001.i} colon 50 skip(1)
   inv_only             colon 40 label {&soivrp_p_10}
/*   print_lotserials     colon 40 */
/*  conso                colon 40  */
   print_ready2inv      colon 40 label {&soivrp_p_6}
   print_ready2post     colon 40 label {&soivrp_p_3}
   skip(2)
    fname colon 20 view-as fill-in size 45 by 1

 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF DEFINED(GPLABEL_I)=0 &THEN
   &IF (DEFINED(SELECTION_CRITERIA) = 0)
   &THEN " Selection Criteria "
   &ELSE {&SELECTION_CRITERIA}
   &ENDIF
&ELSE
   getTermLabel("SELECTION_CRITERIA", 25).
&ENDIF.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/*    /* DEFINE FRAME FOR DISPLAYING REPORT TOTALS IN BASE CURRENCY */                 */
/*    FORM /*GUI*/                                                                     */
/*       rptstr to 61 format "x(19)"                                                   */
/*       tot_base_amt    to 77                                                         */
/*                                                                                     */
/*       tot_base_price  to 110                                                        */
/*                                                                                     */
/*       tot_base_margin to 130                                                        */
/*       skip(1)                                                                       */
/*    with STREAM-IO /*GUI*/  frame rpttot no-labels width 132 down.                   */
/*                                                                                     */
/*    /*DEFINE FRAME FOR DISPLAYING GL TOTALS */                                       */
/*    FORM /*GUI*/                                                                     */
/*       gltw_entity                                                                   */
/*       gltw_acct                                                                     */
/*       gltw_sub                                                                      */
/*       gltw_cc                                                                       */
/*       gltw_date                                                                     */
/*       gltwdr label {&soivrp_p_4}                                                    */
/*       gltwcr label {&soivrp_p_1}                                                    */
/*    with STREAM-IO /*GUI*/  frame gltwtot width 80 down.                             */
/*                                                                                     */
/*    /* SET EXTERNAL LABELS */                                                        */
/*    setFrameLabels(frame gltwtot:handle).                                            */
/*                                                                                     */
/*    find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.             */
/*    for each gltw_wkfl exclusive-lock  where gltw_wkfl.gltw_domain = global_domain   */
/*    and  gltw_userid = mfguser:                                                      */
/*       {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"                                */
/*          "(input gltw_exru_seq)"}                                                   */
/*       delete gltw_wkfl.                                                             */
/*    end.                                                                             */
/*                                                                                     */
/*    /* SETUP THE FORMATS FOR THE TOTAL DISPLAYS.  BECAUSE THESE ARE IN */            */
/*    /* BASE THEY ONLY NEED TO BE SET UP ONCE.  */                                    */
/*    assign                                                                           */
/*       gltwdr_fmt = gltwdr:format                                                    */
/*       gltwcr_fmt = gltwcr:format                                                    */
/*       tot_amt_fmt = tot_base_amt:format                                             */
/*       tot_price_fmt = tot_base_price:format                                         */
/*       tot_marg_fmt = tot_base_margin:format.                                        */
/*                                                                                     */
/*    /* SET CURRENCY FORMAT FOR TOT_BASE_AMT */                                       */
/*    {gprun.i ""gpcurfmt.p"" "(input-output tot_amt_fmt,                              */
/*         input gl_rnd_mthd)"}                                                        */
/*    /* SET CURRENCY FORMAT FOR TOT_BASE_PRICE */                                     */
/*    {gprun.i ""gpcurfmt.p"" "(input-output tot_price_fmt,                            */
/*         input gl_rnd_mthd)"}                                                        */
/*    /* SET CURRENCY FORMAT FOR TOT_BASE_MARGIN */                                    */
/*    {gprun.i ""gpcurfmt.p"" "(input-output tot_marg_fmt,                             */
/*         input gl_rnd_mthd)"}                                                        */
/*    /* SET CURRENCY FORMAT FOR GLTWDR */                                             */
/*    {gprun.i ""gpcurfmt.p"" "(input-output gltwdr_fmt,                               */
/*         input gl_rnd_mthd)"}                                                        */
/*    /* SET CURRENCY FORMAT FOR GLTWCR */                                             */
/*    {gprun.i ""gpcurfmt.p"" "(input-output gltwcr_fmt,                               */
/*         input gl_rnd_mthd)"}                                                        */
/*    assign                                                                           */
/*       tot_base_amt:format = tot_amt_fmt                                             */
/*       tot_base_price:format = tot_price_fmt                                         */
/*       tot_base_margin:format = tot_marg_fmt                                         */
/*       gltwdr:format = gltwdr_fmt                                                    */
/*       gltwcr:format = gltwcr_fmt.                                                   */

{wbrp01.i}


/*GUI*/ {mfguirpa.i true "printer" 132 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


   if nbr1 = hi_char then nbr1 = "".
   if shipdate = low_date then shipdate = ?.
   if shipdate1 = hi_date then shipdate1 = ?.
   if cust1 = hi_char then cust1 = "".
   if bill1 = hi_char then bill1 = "".

   if c-application-mode <> 'web' then

run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   {wbrp06.i &command = update &fields = "  nbr nbr1 shipdate shipdate1
        cust cust1 bill bill1 inv_only /* print_lotserials  conso */ print_ready2inv
        print_ready2post" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i nbr    }
      {mfquoter.i nbr1   }
      {mfquoter.i shipdate  }
      {mfquoter.i shipdate1 }
      {mfquoter.i cust   }
      {mfquoter.i cust1  }
      {mfquoter.i bill   }
      {mfquoter.i bill1  }
      {mfquoter.i inv_only}
      {mfquoter.i print_lotserials}
      {mfquoter.i conso}
      {mfquoter.i print_ready2inv}
      {mfquoter.i print_ready2post}
      {mfquoter.i fname}
      if nbr1 = "" then nbr1 = hi_char.
      if shipdate = ? then shipdate = low_date.
      if shipdate1 = ? then shipdate1 = hi_date.
      if cust1 = "" then cust1 = hi_char.
      if bill1 = "" then bill1 = hi_char.

   end.

   /* OUTPUT DESTINATION SELECTION */

/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
/* find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock. */

   {mfphead.i}

   tranloop:
   do transaction on endkey undo, leave:
   empty temp-table tmp-soivdet36 no-error.
     {gprun.i ""xxgetsoivrp.p""
            "(input nbr,
              input nbr1,
              input shipdate,
              input shipdate1,
              input cust,
              input cust1,
              input bill,
              input bill1,
              input inv_only,
              input no,
              input no,
              input print_ready2inv,
              input print_ready2post
                  )"}
       {gprun.i ""xxsoivrpxls.p"" "(input fname)"}
/*                                                                                                                      */
/*        /* Main Report Loop */                                                                                        */
/*        {gprun.i  ""soivrpa.p""}                                                                                      */
/*                                                                                                                      */
/*        if keyfunction(lastkey) <> "end-error" then do:                                                               */
/*           /* Report Totals */                                                                                        */
/*                                                                                                                      */
/*           underline tot_base_amt tot_base_price tot_base_margin                                                      */
/*           with frame rpttot.                                                                                         */
/*           down 1 with frame rpttot.                                                                                  */
/*           display                                                                                                    */
/*                                                                                                                      */
/*              base_curr + " " + getTermLabel("REPORT_TOTALS",14) + ":" @ rptstr                                       */
/*              tot_base_amt                                                                                            */
/*              tot_base_price                                                                                          */
/*              tot_base_margin                                                                                         */
/*           with frame rpttot STREAM-IO /*GUI*/ .                                                                      */
/*                                                                                                                      */
/*           /* Print GL Recap */                                                                                       */
/*           page.                                                                                                      */
/*                                                                                                                      */
/*           for each gltw_wkfl exclusive-lock                                                                          */
/*            where gltw_wkfl.gltw_domain = global_domain and  gltw_userid = mfguser                                    */
/*           break by gltw_userid                                                                                       */
/*           by gltw_entity                                                                                             */
/*           by gltw_acct                                                                                               */
/*           by gltw_sub                                                                                                */
/*           by gltw_cc                                                                                                 */
/*           with frame gltwtot:                                                                                        */
/*                                                                                                                      */
/*              cr_amt = 0.                                                                                             */
/*              dr_amt = 0.                                                                                             */
/*              if gltw_amt < 0 then cr_amt = - gltw_amt.                                                               */
/*              else dr_amt = gltw_amt.                                                                                 */
/*              accumulate (dr_amt) (total by gltw_cc).                                                                 */
/*              accumulate (cr_amt) (total by gltw_cc).                                                                 */
/*                                                                                                                      */
/*                                                                                                                      */
/*  /*GUI*/ {mfguichk.i  &loop="tranloop"} /*Replace mfrpchk*/                                                          */
/*                                                                                                                      */
/*                                                                                                                      */
/*              if last-of(gltw_cc) then do:                                                                            */
/*                                                                                                                      */
/*                 display gltw_entity                                                                                  */
/*                         gltw_acct                                                                                    */
/*                         gltw_sub                                                                                     */
/*                         gltw_cc                                                                                      */
/*                         gltw_date with frame gltwtot STREAM-IO /*GUI*/ .                                             */
/*                                                                                                                      */
/*                 /** ADDED CODE TO INCLUDE THE CONDITION WHERE ACCUMULATED  **/                                       */
/*                 /** DEBIT AND CREDIT AMOUNT IS NOT EQUAL TO ZERO           **/                                       */
/*                                                                                                                      */
/*                 if     ((accum total by gltw_cc dr_amt) <> 0)                                                        */
/*                    and ((accum total by gltw_cc cr_amt) <> 0)                                                        */
/*                 then do:                                                                                             */
/*                    assign                                                                                            */
/*                       gltwdr = accum total by gltw_cc dr_amt                                                         */
/*                       gltwcr = accum total by gltw_cc cr_amt.                                                        */
/*                    display gltwdr gltwcr with frame gltwtot STREAM-IO /*GUI*/ .                                      */
/*                 end. /* IF ((ACCUM TOTAL BY gltw_cc dr_amt) ... */                                                   */
/*                 else                                                                                                 */
/*                    if (accum total by gltw_cc dr_amt) <> 0 then                                                      */
/*              do:                                                                                                     */
/*                    gltwdr = accum total by gltw_cc dr_amt.                                                           */
/*                                                                                                                      */
/*                    display gltwdr "" @ gltwcr with frame gltwtot STREAM-IO /*GUI*/ .                                 */
/*                                                                                                                      */
/*                 end.                                                                                                 */
/*                 else                                                                                                 */
/*                    if (accum total by gltw_cc cr_amt) <> 0 then                                                      */
/*              do:                                                                                                     */
/*                    gltwcr = accum total by gltw_cc cr_amt.                                                           */
/*                                                                                                                      */
/*                    display gltwcr "" @ gltwdr with frame gltwtot STREAM-IO /*GUI*/ .                                 */
/*                                                                                                                      */
/*                 end.                                                                                                 */
/*                 down 1 with frame gltwtot.                                                                           */
/*              end.                                                                                                    */
/*                                                                                                                      */
/*              if last-of(gltw_userid) then do:                                                                        */
/*                 underline gltwdr gltwcr with frame gltwtot.                                                          */
/*                 down 1 with frame gltwtot.                                                                           */
/*                 display                                                                                              */
/*                    accum total (dr_amt) @ gltwdr                                                                     */
/*                    accum total (cr_amt) @ gltwcr with frame gltwtot STREAM-IO /*GUI*/ .                              */
/*                                                                                                                      */
/*              end.                                                                                                    */
/*                                                                                                                      */
/*              {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"                                                          */
/*                 "(input gltw_exru_seq)"}                                                                             */
/*                                                                                                                      */
/*              delete gltw_wkfl.                                                                                       */
/*                                                                                                                      */
/*           end. /* for each gltw_ */                                                                                  */
/*        end. /* if not end-error */                                                                                   */
/*                                                                                                                      */
/*     end.  /* TRANLOOP */                                                                                             */
/*     /* DELETING THE TEMPORARY RECORD CREATED IN TX2D_DET (SOIVRPA.P) FOR CONSOLIDATED RECORDS*/                      */
/*     do transaction:                                                                                                  */
/*        do l_cnt = 1 to m_cons_cnt:                                                                                   */
/*        l_ref  = ('IV' + substring(mfguser,4,4) + STRING(m_cons_cnt)).                                                */
/*           for each tx2d_det                                                                                          */
/*              where  tx2d_domain = global_domain                                                                      */
/*                 and tx2d_ref = l_ref                                                                                 */
/*                 and tx2d_nbr = 'REGISTER'                                                                            */
/*           exclusive-lock:                                                                                            */
/*              delete tx2d_det.                                                                                        */
/*           end.                                                                                                       */
/*           release tx2d_det.                                                                                          */
/*        end.                                                                                                          */
   end.


/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/



end.

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" nbr nbr1 shipdate shipdate1 cust cust1 bill bill1 inv_only /* print_lotserials conso */ print_ready2inv print_ready2post fname "} /*Drive the Report*/
