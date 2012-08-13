/* GUI CONVERTED from sosorp05.p (converter v1.76) Fri Mar 14 00:29:56 2003 */
/* sosorp05.p  -  SALES ORDER PRINT                                           */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.32 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 1.0      LAST MODIFIED: 05/13/86   BY: PML                       */
/* REVISION: 1.0      LAST MODIFIED: 08/29/86   BY: EMB *12*                  */
/* REVISION: 4.0     LAST EDIT: 12/30/87        BY: WUG *A137*                */
/*                                   10/06/86       pml *31*                  */
/*           2.0                     12/23/86       pml *A8*                  */
/* REVISION: 2.0      LAST MODIFIED: 07/17/87   BY: EMB *A23*                 */
/* REVISION: 2.1      LAST MODIFIED: 07/30/87   BY: WUG *A78*                 */
/* REVISION: 2.1      LAST MODIFIED: 10/20/87   BY: WUG *A94*                 */
/* REVISION: 4.0      LAST MODIFIED: 12/18/87   BY: pml *A113                 */
/* REVISION: 4.0      LAST MODIFIED: 01/11/88   BY: RL  *A136*                */
/* REVISION: 4.0      LAST MODIFIED: 02/09/88   BY: pml *A119*                */
/* REVISION: 4.0      LAST MODIFIED: 02/19/88   BY: WUG *A177*                */
/* REVISION: 4.0      LAST MODIFIED: 02/29/88   BY: WUG *A175*                */
/* REVISION: 4.0      LAST MODIFIED: 05/24/88   BY: flm *A251*                */
/* REVISION: 4.0      LAST MODIFIED: 12/02/88   BY: MLB *A547*                */
/* REVISION: 4.0      LAST MODIFIED: 01/11/89   BY: emb *A596*                */
/* REVISION: 5.0      LAST MODIFIED: 01/12/89   BY: MLB *A608*                */
/* REVISION: 5.0      LAST MODIFIED: 03/02/89   BY: MLB *B056*                */
/* REVISION: 5.0      LAST MODIFIED: 04/07/89   BY: WUG *B094*                */
/* REVISION: 5.0      LAST MODIFIED: 05/25/89   BY: MLB *B123*                */
/* REVISION: 5.0      LAST MODIFIED: 06/10/89   BY: MLB *B130*                */
/* REVISION: 4.0      LAST MODIFIED: 06/27/89   BY: MLB *A751*                */
/* REVISION: 5.0      LAST MODIFIED: 10/16/89   BY: MLB *B342,B344*           */
/* REVISION: 5.0      LAST MODIFIED: 11/22/89   BY: WUG *B402*                */
/* REVISION: 5.0      LAST MODIFIED: 02/12/90   BY: ftb *B564*                */
/* REVISION: 5.0      LAST MODIFIED: 03/15/90   BY: MLB *B615*                */
/* REVISION: 5.0      LAST MODIFIED: 03/30/90   BY: ftb *B642*                */
/* REVISION: 6.0      LAST MODIFIED: 11/12/90   BY: MLB *D200*                */
/* REVISION: 6.0      LAST MODIFIED: 12/13/90   BY: dld *D257*                */
/* REVISION: 6.0      LAST MODIFIED: 12/27/90   BY: MLB *D238*                */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: afs *D425*                */
/* REVISION: 7.0      LAST MODIFIED: 09/17/91   BY: MLV *F015*                */
/* REVISION: 7.0      LAST MODIFIED: 03/18/92   BY: TMD *F263*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 04/02/92   BY: dld *F322*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 04/08/92   BY: tmd *F367*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: dld *F358*                */
/* REVISION: 7.0      LAST MODIFIED: 04/30/92   BY: tmd *F458*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 11/13/92   BY: tjs *G191*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 02/19/93   by: jms *G712*                */
/* REVISION: 7.3      LAST MODIFIED: 03/17/93   BY: afs *G820*   (rev only)   */
/* REVISION: 7.4      LAST MODIFIED: 07/20/93   BY: bcm *H032*   (rev only)   */
/* REVISION: 7.3      LAST MODIFIED: 10/18/94   BY: jzs *GN91*                */
/* REVISION: 7.4      LAST MODIFIED: 04/12/95   BY: jpm *H0CH*                */
/* REVISION: 8.5      LAST MODIFIED: 03/06/95   BY: nte *J042*                */
/* REVISION: 7.4      LAST MODIFIED: 05/15/95   BY: jym *G0MP*                */
/* REVISION: 7.4      LAST MODIFIED: 10/09/95   BY: jym *G0XY*                */
/* REVISION: 8.5      LAST MODIFIED: 04/26/96   BY: jpm *J0KK*                */
/* REVISION: 7.4      LAST MODIFIED: 02/05/98   BY: *H1JC* Jean Miller        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00L* EvdGevel           */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 7.3      LAST MODIFIED: 07/15/98   BY: *L03Y* Dariusz Sidel      */
/* REVISION: 8.6E     LAST MODIFIED: 07/14/98   BY: *L024* Steve Goeke        */
/* REVISION: 9.0      LAST MODIFIED: 11/23/98   BY: *J358* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 02/06/99   BY: *M06R* Doug Norton        */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 07/30/99   BY: *N01B* John Corda         */
/* REVISION: 9.1      LAST MODIFIED: 09/28/99   BY: *L0J4* Satish Chavan      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/20/00   BY: *M0PQ* Falguni Dalal      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* Revision: 1.27         BY: Katie Hilbert      DATE: 04/01/01  ECO: *P002*  */
/* Revision: 1.28         BY: Dan Herman         DATE: 07/06/01  ECO: *P007*  */
/* Revision: 1.29         BY: Ashwini G.         DATE: 01/10/02  ECO: *L194*  */
/* Revision: 1.30       BY: Jean Miller        DATE: 05/13/02  ECO: *P05V*  */
/* $Revision: 1.32 $     BY: Dorota Hohol     DATE: 02/25/03  ECO: *P0N6* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* LAST MODIFIED: 07/06/05   By: judy liu  */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}
{cxcustom.i "SOSORP05.P"}

define new shared variable cust  like so_cust.
define new shared variable cust1 like so_cust.
define new shared variable nbr  like so_nbr.
define new shared variable nbr1 like so_nbr.
define new shared variable ord  like so_ord_date.
define new shared variable ord1 like so_ord_date.
define new shared variable company as character format "x(38)" extent 6.
define new shared variable print_options like mfc_logical
   initial no label "Print Features and Options".
define new shared variable addr as character format "x(38)" extent 6.
define new shared variable lang like so_lang.
define new shared variable lang1 like so_lang.
define new shared variable print_trlr like mfc_logical initial no
   label "Print Sales Order Trailer".
define new shared variable bump_rev like mfc_logical initial true
   label "Increment Order Revision".
define new shared variable disc_det_key  like lngd_key1 initial "1".
define new shared variable disc_sum_key  like lngd_key1 initial "1".
define new shared variable print_line_charges like mfc_logical
   label "Print Additional Line Charges" initial no no-undo.

define new shared variable l_cr_ord_amt   as   decimal no-undo.

define variable disc_det like lngd_translation label "Discount Detail" no-undo.
define variable disc_sum like disc_det         label "Discount Summary" no-undo.
/*judy 07/06/05*/  /*define variable comp_addr like soc_company no-undo.*/
/*judy 07/06/05*/  define   NEW  shared        variable comp_addr like soc_company. 
define variable update_yn like mfc_logical initial yes label "Update" no-undo.
define variable form_code as character format "x(2)" label "Form Code" no-undo.
define variable run_file as character format "x(12)" no-undo.
define variable c-lngd-dataset like lngd_det.lngd_dataset
   initial "soprint.p" no-undo.
define variable report_width like mfc_integer.


{&SOSORP05-P-TAG1}

{etvar.i &new="new"}

{gpfilev.i} /* VARIABLE DEFINITIONS FOR gpfile.i */

/* DEFINE VARIABLES FOR VAT REG NO & COUNTRY CODE */
{gpvtecdf.i &var="new shared"}

/* FACILITATE UPDATE FLAG AS REPORT INPUT CRITERIA, TO */
/* ELIMINATE USER INTERACTION AT THE END OF REPORT     */


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
nbr                colon 20
   nbr1               label "To" colon 49 skip
   cust               colon 20
   cust1              label "To" colon 49 skip
   ord                colon 20
   ord1               label "To" colon 49 skip
   lang               colon 20
   lang1              label "To" colon 49 skip(1)
   {&SOSORP05-P-TAG2}
   print_options      colon 30 skip
   comp_addr          colon 30 skip
   form_code          colon 30 deblank skip
   print_trlr         colon 30
   disc_det           colon 30
   disc_sum           colon 30
   bump_rev           colon 30
   print_line_charges colon 30
   update_yn          colon 30 skip
with frame a width 80 side-labels NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{cclc.i} /* DETERMINE IF CONTAINER AND LINE CHARGES ARE ENABLED */

find first soc_ctrl no-lock no-error.
comp_addr = soc_company.

{&SOSORP05-P-TAG3}

find first lngd_det where lngd_dataset = c-lngd-dataset
   and lngd_field   = "det_disc_prnt"
   and lngd_lang    = global_user_lang
   and lngd_key1    = disc_det_key
no-lock no-error.
if available lngd_det then
   disc_det = lngd_translation.
else
   disc_det = "".

find first lngd_det where lngd_dataset = c-lngd-dataset
   and lngd_field   = "det_disc_prnt"
   and lngd_lang    = global_user_lang
   and lngd_key1    = disc_sum_key
no-lock no-error.
if available lngd_det then
   disc_sum = lngd_translation.
else
   disc_sum = "".

repeat:

   if nbr1 = hi_char then nbr1 = "".
   if cust1 = hi_char then cust1 = "".
   if lang1 = hi_char then lang1 = "".
   if form_code = "" then form_code = "1".

   display print_line_charges with frame a.

   assign company = "".

   update
      nbr nbr1
      cust cust1
      ord ord1
      lang lang1
      print_options
      comp_addr
      form_code
      {&SOSORP05-P-TAG4}
      print_trlr
      disc_det
      disc_sum
      bump_rev
      print_line_charges when (using_line_charges)
      update_yn
   with frame a
   editing:

      if frame-field = "disc_det" then do:
         {mfnp05.i lngd_det lngd_trans
            "lngd_dataset   = c-lngd-dataset
                  and lngd_field  = 'det_disc_prnt'
                  and lngd_lang   = global_user_lang"
            lngd_translation "disc_det" }
         if recno <> ? then
         display lngd_translation @ disc_det
         with frame a.
      end.

      else if frame-field = "disc_sum" then do:
         {mfnp05.i lngd_det lngd_trans
            "lngd_dataset   = c-lngd-dataset
                  and lngd_field  = 'det_disc_prnt'
                  and lngd_lang   = global_user_lang"
            lngd_translation "disc_sum" }
         if recno <> ? then display lngd_translation @ disc_sum
         with frame a.
      end.

      else do:
         status input.
         readkey.
         apply lastkey.
      end.

   end.
   {&SOSORP05-P-TAG5}

   bcdparm = "".
   {mfquoter.i nbr    }
   {mfquoter.i nbr1   }
   {mfquoter.i cust   }
   {mfquoter.i cust1  }
   {mfquoter.i ord    }
   {mfquoter.i ord1   }
   {mfquoter.i lang   }
   {mfquoter.i lang1}
   {mfquoter.i print_options}
   {mfquoter.i comp_addr}
   {mfquoter.i form_code}
   {&SOSORP05-P-TAG6}
   {mfquoter.i print_trlr}
   {mfquoter.i disc_det  }
   {mfquoter.i disc_sum  }
   {mfquoter.i bump_rev  }
   {mfquoter.i print_line_charges}
   {mfquoter.i update_yn }

   if nbr1 = "" then nbr1 = hi_char.
   if cust1 = "" then cust1 = hi_char.
   if lang1 = "" then lang1 = hi_char.

   /* Add this do loop so the converter wont create an 'on leave' */
   do:

      /* Validate discount print options */
      find first lngd_det where
             lngd_dataset     = c-lngd-dataset
         and lngd_field       = "det_disc_prnt"
         and lngd_lang        = global_user_lang
         and lngd_translation = disc_det
      no-lock no-error.
      if not available lngd_det then do:
         /* INVALID OPTION */
         {pxmsg.i &MSGNUM=712 &ERRORLEVEL=3 &MSGARG1=disc_det}
         {gprun.i ""gpmsgls1.p""
            "(6928, c-lngd-dataset, 'det_disc_prnt', global_user_lang )"}
         next-prompt disc_det with frame a.
         undo, retry.
      end.
      disc_det_key = lngd_key1.

      find first lngd_det where
             lngd_dataset     = c-lngd-dataset
         and lngd_field       = "det_disc_prnt"
         and lngd_lang        = global_user_lang
         and lngd_translation = disc_sum
         no-lock no-error.
      if not available lngd_det then do:
         /* INVALID OPTION */
         {pxmsg.i &MSGNUM=712 &ERRORLEVEL=3 &MSGARG1=disc_det}
         {gprun.i ""gpmsgls1.p""
            "(6928, c-lngd-dataset, 'det_disc_prnt', global_user_lang )"}
         next-prompt disc_sum with frame a.
         undo, retry.
      end.
      disc_sum_key = lngd_key1.

      {&SOSORP05-P-TAG7}

      /* TO TRANSLATE, ADD THE LANGUAGE CODE IN THE LOOKUP BELOW*/
      if lookup(form_code,"1") = 0 then do:
         {pxmsg.i &MSGNUM=129 &ERRORLEVEL=3} /* FORM CODE NOT INSTALLED */
         next-prompt form_code with frame a.
         undo, retry.
      end.

      if comp_addr <> "" then do:

         find ad_mstr where ad_addr = comp_addr no-lock no-error.

         if available ad_mstr then do:

            find ls_mstr where ls_addr = ad_addr and ls_type = "company"
            no-lock no-error.

            if not available ls_mstr then do:
               {pxmsg.i &MSGNUM=28 &ERRORLEVEL=3} /* NOT A VALID COMPANY */
               next-prompt comp_addr with frame a.
               undo , retry.
            end.

            assign
               addr[1] = ad_name
               addr[2] = ad_line1
               addr[3] = ad_line2
               addr[4] = ad_line3
               addr[6] = ad_country.

            {mfcsz.i addr[5] ad_city ad_state ad_zip}.
            {gprun.i ""gpaddr.p"" }

            assign
               company[1] = addr[1]
               company[2] = addr[2]
               company[3] = addr[3]
               company[4] = addr[4]
               company[5] = addr[5]
               company[6] = addr[6].

            /* FIND VAT REG NO & COUNTRY CODE */
            {gpvtecrg.i}

         end. /* if available ad_mstr */
         else do:
            {pxmsg.i &MSGNUM=28 &ERRORLEVEL=3} /* NOT A VALID COMPANY */
            next-prompt comp_addr with frame a.
            undo , retry.
         end.
      end. /* if comp_addr <> "" */

   end.

   {&SOSORP05-P-TAG8}

   assign report_width = (if et_ctrl.et_print_dc then 132 else 80).

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer" &printWidth = report_width
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
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


   mainloop:
   do transaction:

      if false then do:
          
  /*judy 07/06/05*/     /* {gprun.i ""sorp0501.p""*/
  /*judy 07/06/05*/       /*    "(input update_yn,*/
  /*judy 07/06/05*/        /*     input print_line_charges)"}*/
  /*judy 07/06/05*/      {gprun.i ""yysorp0501.p""
                                       "(input update_yn,
                                          input print_line_charges)"}  
 
      end.

      {&SOSORP05-P-TAG9}

      /*RUN SELECTED FORMAT */
      {gprfile.i}
 
 
   /*judy 07/06/05*/      /*{gprun.i " ""sorp05"" + run_file + "".p"""
    /*judy 07/06/05*/        "(input update_yn,
    /*judy 07/06/05*/          input print_line_charges)"}*/
   /*judy 07/06/05*/      {gprun.i " ""yysorp05"" + run_file + "".p"""
                                        "(input update_yn,
                                       input print_line_charges)"}  
      {&SOSORP05-P-TAG10}

      {mfreset.i}       
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


      /* MOVED USER INTERACTION TO REPORT INPUT CRITERIA. */
      if not update_yn then
         undo mainloop, leave mainloop.

   end. /* mainloop: do transaction */

end. /* repeat */
