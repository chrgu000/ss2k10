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
/*36 &GLOBAL-DEFINE PP_PGM_RP TRUE                                           */
/*36 &GLOBAL-DEFINE PP_ENV_GUI TRUE                                          */
/*36                                                                         */
/*36                                                                         */
/*36 /*GUI preprocessor directive settings */                                */
/*36 &SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT                               */
/*36                                                                         */
/*36 /* {mfdtitle.i "1+ "} */                                                */
/*36                                                                         */
/*36 /* ********** Begin Translatable Strings Definitions ********* */       */
/*36                                                                         */
/*36 &SCOPED-DEFINE soivrp_p_1 "Consolidated Cr"                             */
/*36 /* MaxLen: Comment: */                                                  */
/*36                                                                         */
/*36 &SCOPED-DEFINE soivrp_p_3 "Include Ready To Post"                       */
/*36 /* MaxLen: Comment: */                                                  */
/*36                                                                         */
/*36 &SCOPED-DEFINE soivrp_p_4 "Consolidated Dr"                             */
/*36 /* MaxLen: Comment: */                                                  */
/*36                                                                         */
/*36 &SCOPED-DEFINE soivrp_p_5 "Debit Amount"                                */
/*36 /* MaxLen: Comment: */                                                  */
/*36                                                                         */
/*36 &SCOPED-DEFINE soivrp_p_6 "Include Ready To Print Invoice"              */
/*36 /* MaxLen: Comment: */                                                  */
/*36                                                                         */
/*36 &SCOPED-DEFINE soivrp_p_7 "Consolidate Invoices"                        */
/*36 /* MaxLen: Comment: */                                                  */
/*36                                                                         */
/*36 &SCOPED-DEFINE soivrp_p_8 "Credit Amount"                               */
/*36 /* MaxLen: Comment: */                                                  */
/*36                                                                         */
/*36 &SCOPED-DEFINE soivrp_p_9 "Print Lot/Serial Numbers Shipped"            */
/*36 /* MaxLen: Comment: */                                                  */
/*36                                                                         */
/*36 &SCOPED-DEFINE soivrp_p_10 "Print Only Lines To Invoice"                */
/*36 /* MaxLen: Comment: */                                                  */

/* ********** End Translatable Strings Definitions ********* */
{mfdeclre.i}

define input parameter inbr like so_nbr.
define input parameter inbr1 like so_nbr.
define input parameter ishipdate like so_ship_date.
define input parameter ishipdate1 like so_ship_date.
define input parameter icust  like so_cust.
define input parameter icust1 like so_cust.
define input parameter ibill  like so_bill.
define input parameter ibill1 like so_bill.
define input parameter iinv_only     as logical.
define input parameter iprint_lotserials as logical.
define input parameter iconso as logical.
define input parameter iprint_ready2inv as logical.
define input parameter iprint_ready2post as logical.

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
define new shared variable print_lotserials like mfc_logical.

define variable dr_amt as decimal format "->>,>>>,>>>,>>9.99".
define variable cr_amt as decimal format "->>,>>>,>>>,>>9.99".
define variable runok_noundo like mfc_logical no-undo initial no.
define new shared variable conso like mfc_logical initial no.
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

/*36 /*GUI preprocessor Frame A define */                                      */
/*36 &SCOPED-DEFINE PP_FRAME_NAME A                                            */
/*36                                                                           */
/*36 FORM /*GUI*/                                                              */
/*36                                                                           */
/*36  RECT-FRAME       AT ROW 1.4 COLUMN 1.25                                  */
/*36  RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL                            */
/*36  SKIP(.1)  /*GUI*/                                                        */
/*36    nbr                  colon 15                                          */
/*36    nbr1                 label {t001.i} colon 50 skip                      */
/*36    shipdate             colon 15                                          */
/*36    shipdate1            label {t001.i} colon 50 skip                      */
/*36    cust                 colon 15                                         */
/*36    cust1                label {t001.i} colon 50 skip                     */
/*36    bill                 colon 15                                         */
/*36    bill1                label {t001.i} colon 50 skip(1)                  */
/*36    inv_only             colon 40 label {&soivrp_p_10}                     */
/*36    print_lotserials     colon 40                                          */
/*36    conso                colon 40                                          */
/*36    skip(1)                                                                */
/*36    print_ready2inv      colon 40 label {&soivrp_p_6}                      */
/*36    print_ready2post     colon 40 label {&soivrp_p_3}                      */
/*36  SKIP(.4)  /*GUI*/                                                        */
/*36 with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.      */
/*36                                                                           */
/*36  DEFINE VARIABLE F-a-title AS CHARACTER.                                  */
/*36  F-a-title = &IF DEFINED(GPLABEL_I)=0 &THEN                               */
/*36    &IF (DEFINED(SELECTION_CRITERIA) = 0)                                  */
/*36    &THEN " Selection Criteria "                                           */
/*36    &ELSE {&SELECTION_CRITERIA}                                            */
/*36    &ENDIF                                                                 */
/*36 &ELSE                                                                     */
/*36    getTermLabel("SELECTION_CRITERIA", 25).                                */
/*36 &ENDIF.                                                                   */
/*36  RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.                    */
/*36  RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =                               */
/*36   FONT-TABLE:GET-TEXT-WIDTH-PIXELS(                                       */
/*36   RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT). */
/*36  RECT-FRAME:HEIGHT-PIXELS in frame a =                                    */
/*36   FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.                    */
/*36  RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/    */
/*36                                                                           */
/*36 /*GUI preprocessor Frame A undefine */                                    */
/*36 &UNDEFINE PP_FRAME_NAME                                                   */
/*36                                                                           */
/*36                                                                           */
/*36                                                                           */
/*36 /* SET EXTERNAL LABELS */                                                 */
/*36 setFrameLabels(frame a:handle).                                           */
/*36                                                                           */
/*36 /* DEFINE FRAME FOR DISPLAYING REPORT TOTALS IN BASE CURRENCY */          */
/*36 FORM /*GUI*/                                                              */
/*36    rptstr to 61 format "x(19)"                                            */
/*36    tot_base_amt    to 77                                                  */
/*36                                                                           */
/*36    tot_base_price  to 110                                                 */
/*36                                                                           */
/*36    tot_base_margin to 130                                                 */
/*36    skip(1)                                                                */
/*36 with STREAM-IO /*GUI*/  frame rpttot no-labels width 132 down.            */
/*36                                                                           */
/*36 /*DEFINE FRAME FOR DISPLAYING GL TOTALS */                                */
/*36 FORM /*GUI*/                                                              */
/*36    gltw_entity                                                            */
/*36    gltw_acct                                                              */
/*36    gltw_sub                                                               */
/*36    gltw_cc                                                                */
/*36    gltw_date                                                              */
/*36    gltwdr label {&soivrp_p_4}                                             */
/*36    gltwcr label {&soivrp_p_1}                                             */
/*36 with STREAM-IO /*GUI*/  frame gltwtot width 80 down.                      */
/*36                                                                           */
/*36 /* SET EXTERNAL LABELS */                                                 */
/*36 setFrameLabels(frame gltwtot:handle).                                     */

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.
for each gltw_wkfl exclusive-lock  where gltw_wkfl.gltw_domain = global_domain
and  gltw_userid = mfguser:
   {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
      "(input gltw_exru_seq)"}
   delete gltw_wkfl.
end.

/* SETUP THE FORMATS FOR THE TOTAL DISPLAYS.  BECAUSE THESE ARE IN */
/* BASE THEY ONLY NEED TO BE SET UP ONCE.  */
/* assign                                                     */
/*    gltwdr_fmt = gltwdr:format                              */
/*    gltwcr_fmt = gltwcr:format                              */
/*    tot_amt_fmt = tot_base_amt:format                       */
/*    tot_price_fmt = tot_base_price:format                   */
/*    tot_marg_fmt = tot_base_margin:format.                  */

/* SET CURRENCY FORMAT FOR TOT_BASE_AMT */
{gprun.i ""gpcurfmt.p"" "(input-output tot_amt_fmt,
     input gl_rnd_mthd)"}
/* SET CURRENCY FORMAT FOR TOT_BASE_PRICE */
{gprun.i ""gpcurfmt.p"" "(input-output tot_price_fmt,
     input gl_rnd_mthd)"}
/* SET CURRENCY FORMAT FOR TOT_BASE_MARGIN */
{gprun.i ""gpcurfmt.p"" "(input-output tot_marg_fmt,
     input gl_rnd_mthd)"}
/* SET CURRENCY FORMAT FOR GLTWDR */
{gprun.i ""gpcurfmt.p"" "(input-output gltwdr_fmt,
     input gl_rnd_mthd)"}
/* SET CURRENCY FORMAT FOR GLTWCR */
{gprun.i ""gpcurfmt.p"" "(input-output gltwcr_fmt,
     input gl_rnd_mthd)"}
/*36 assign                                                                  */
/*36    tot_base_amt:format = tot_amt_fmt                                    */
/*36    tot_base_price:format = tot_price_fmt                                */
/*36    tot_base_margin:format = tot_marg_fmt                                */
/*36    gltwdr:format = gltwdr_fmt                                           */
/*36    gltwcr:format = gltwcr_fmt.                                          */
/*36                                                                         */
/*36  {wbrp01.i}                                                             */
/*36                                                                         */
/*36                                                                         */
/*36  /*GUI*/ {mfguirpa.i true "printer" 132 " " " " " "  }                  */
/*36                                                                         */
/*36 /*GUI repeat : */                                                       */
/*36    /*GUI*/ procedure p-enable-ui:                                       */
/*36                                                                         */
/*36                                                                         */
/*36       if nbr1 = hi_char then nbr1 = "".                                 */
/*36       if shipdate = low_date then shipdate = ?.                         */
/*36       if shipdate1 = hi_date then shipdate1 = ?.                        */
/*36       if cust1 = hi_char then cust1 = "".                               */
/*36       if bill1 = hi_char then bill1 = "".                               */
/*36                                                                         */
/*36       if c-application-mode <> 'web' then                               */
/*36                                                                         */
/*36    run p-action-fields (input "display").                               */
/*36    run p-action-fields (input "enable").                                */
/*36    end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/       */
/*36 /*GUI*/ procedure p-report-quote:                                                       */
/*36                                                                                         */
/*36                                                                                         */
/*36    {wbrp06.i &command = update &fields = "  nbr nbr1 shipdate shipdate1                 */
/*36         cust cust1 bill bill1 inv_only print_lotserials  conso  print_ready2inv         */
/*36         print_ready2post" &frm = "a"}                                                   */
/*36                                                                                         */
/*36    if (c-application-mode <> 'web') or                                                  */
/*36       (c-application-mode = 'web' and                                                   */
/*36       (c-web-request begins 'data')) then do:                                           */
/*36                                                                                         */
/*36       bcdparm = "".                                                                     */
/*36       {mfquoter.i nbr    }                                                              */
/*36       {mfquoter.i nbr1   }                                                              */
/*36       {mfquoter.i shipdate  }                                                           */
/*36       {mfquoter.i shipdate1 }                                                           */
/*36       {mfquoter.i cust   }                                                              */
/*36       {mfquoter.i cust1  }                                                              */
/*36       {mfquoter.i bill   }                                                              */
/*36       {mfquoter.i bill1  }                                                              */
/*36       {mfquoter.i inv_only}                                                             */
/*36       {mfquoter.i print_lotserials}                                                     */
/*36       {mfquoter.i conso}                                                                */
/*36       {mfquoter.i print_ready2inv}                                                      */
/*36       {mfquoter.i print_ready2post}                                                     */
/*36                                                                                         */
/*36       if nbr1 = "" then nbr1 = hi_char.                                                 */
/*36       if shipdate = ? then shipdate = low_date.                                         */
/*36       if shipdate1 = ? then shipdate1 = hi_date.                                        */
/*36       if cust1 = "" then cust1 = hi_char.                                               */
/*36       if bill1 = "" then bill1 = hi_char.                                               */
/*36                                                                                         */
/*36    end.                                                                                 */
/*36                                                                                         */
/*36    /* OUTPUT DESTINATION SELECTION */                                                   */
/*36                                                                                         */
/*36 /*GUI*/ end procedure. /* p-report-quote */                                             */
/*36 /*GUI - Field Trigger Section */                                                        */
/*36                                                                                         */
/*36 /*GUI MFSELxxx removed*/                                                                */
/*36 /*GUI*/ procedure p-report:                                                             */
/*36 /*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }                                   */
/*36 /*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:        */
/*36 find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.                    */
/*36    {mfphead.i}                                                                          */

nbr               = inbr.
nbr1              = inbr1.
shipdate          = ishipdate.
shipdate1         = ishipdate1.
cust              = icust.
cust1             = icust1.
bill              = ibill.
bill1             = ibill1.
inv_only          = iinv_only.
print_lotserials  = iprint_lotserials.
conso             = iconso.
print_ready2inv   = iprint_ready2inv.
print_ready2post  = iprint_ready2post.

   tranloop:
   do transaction on endkey undo, leave:

      /* Main Report Loop */
      {gprun.i  ""xxgetsoivrpa.p""}

      if keyfunction(lastkey) <> "end-error" then do:
         /* Report Totals */
/*                                                                             */
/*       underline tot_base_amt tot_base_price tot_base_margin                 */
/*       with frame rpttot.                                                    */
/*       down 1 with frame rpttot.                                             */
/*       display                                                               */
/*                                                                             */
/*          base_curr + " " + getTermLabel("REPORT_TOTALS",14) + ":" @ rptstr  */
/*          tot_base_amt                                                       */
/*          tot_base_price                                                     */
/*          tot_base_margin                                                    */
/*       with frame rpttot STREAM-IO /*GUI*/ .                                 */
/*                                                                             */
/*       /* Print GL Recap */                                                  */
/*       page.                                                                 */

         for each gltw_wkfl exclusive-lock
          where gltw_wkfl.gltw_domain = global_domain and  gltw_userid = mfguser
         break by gltw_userid
         by gltw_entity
         by gltw_acct
         by gltw_sub
         by gltw_cc
         with frame gltwtot:

            cr_amt = 0.
            dr_amt = 0.
            if gltw_amt < 0 then cr_amt = - gltw_amt.
            else dr_amt = gltw_amt.
            accumulate (dr_amt) (total by gltw_cc).
            accumulate (cr_amt) (total by gltw_cc).


/*GUI {mfguichk.i  &loop="tranloop"} /*Replace mfrpchk*/   */


/*    if last-of(gltw_cc) then do:                                                  */
/*                                                                                  */
/*       display gltw_entity                                                        */
/*               gltw_acct                                                          */
/*               gltw_sub                                                           */
/*               gltw_cc                                                            */
/*               gltw_date with frame gltwtot STREAM-IO /*GUI*/ .                   */
/*                                                                                  */
/*       /** ADDED CODE TO INCLUDE THE CONDITION WHERE ACCUMULATED  **/             */
/*       /** DEBIT AND CREDIT AMOUNT IS NOT EQUAL TO ZERO           **/             */
/*                                                                                  */
/*       if     ((accum total by gltw_cc dr_amt) <> 0)                              */
/*          and ((accum total by gltw_cc cr_amt) <> 0)                              */
/*       then do:                                                                   */
/*          assign                                                                  */
/*             gltwdr = accum total by gltw_cc dr_amt                               */
/*             gltwcr = accum total by gltw_cc cr_amt.                              */
/*          display gltwdr gltwcr with frame gltwtot STREAM-IO /*GUI*/ .            */
/*       end. /* IF ((ACCUM TOTAL BY gltw_cc dr_amt) ... */                         */
/*       else                                                                       */
/*          if (accum total by gltw_cc dr_amt) <> 0 then                            */
/*    do:                                                                           */
/*          gltwdr = accum total by gltw_cc dr_amt.                                 */
/*                                                                                  */
/*          display gltwdr "" @ gltwcr with frame gltwtot STREAM-IO /*GUI*/ .       */
/*                                                                                  */
/*       end.                                                                       */
/*       else                                                                       */
/*          if (accum total by gltw_cc cr_amt) <> 0 then                            */
/*    do:                                                                           */
/*          gltwcr = accum total by gltw_cc cr_amt.                                 */
/*                                                                                  */
/*          display gltwcr "" @ gltwdr with frame gltwtot STREAM-IO /*GUI*/ .       */
/*                                                                                  */
/*       end.                                                                       */
/*       down 1 with frame gltwtot.                                                 */
/*    end.                                                                          */
/*                                                                                  */
/*    if last-of(gltw_userid) then do:                                              */
/*       underline gltwdr gltwcr with frame gltwtot.                                */
/*       down 1 with frame gltwtot.                                                 */
/*       display                                                                    */
/*          accum total (dr_amt) @ gltwdr                                           */
/*          accum total (cr_amt) @ gltwcr with frame gltwtot STREAM-IO /*GUI*/ .    */
/*                                                                                  */
/*    end.                                                                          */

            {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
               "(input gltw_exru_seq)"}

            delete gltw_wkfl.

         end. /* for each gltw_ */
      end. /* if not end-error */

   end.  /* TRANLOOP */
   /* DELETING THE TEMPORARY RECORD CREATED IN TX2D_DET (SOIVRPA.P) FOR CONSOLIDATED RECORDS*/
   do transaction:
      do l_cnt = 1 to m_cons_cnt:
      l_ref  = ('IV' + substring(mfguser,4,4) + STRING(m_cons_cnt)).
         for each tx2d_det
            where  tx2d_domain = global_domain
               and tx2d_ref = l_ref
               and tx2d_nbr = 'REGISTER'
         exclusive-lock:
            delete tx2d_det.
         end.
         release tx2d_det.
      end.
   end.

/*36                                                         */
/*36 /*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/               */
/*36                                                         */
/*36 /*GUI*/ {mfgrptrm.i} /*Report-to-Window*/               */
/*36                                                         */


/* end.                                                                      */
/*                                                                           */
/* {wbrp04.i &frame-spec = a}                                                */
/*                                                                           */
/* /*GUI*/ end procedure. /*p-report*/                                       */
/* /*GUI*/ {mfguirpb.i &flds=" nbr nbr1 shipdate shipdate1 cust cust1 bill bill1 inv_only print_lotserials conso print_ready2inv print_ready2post "} /*Drive the Report*/ */
