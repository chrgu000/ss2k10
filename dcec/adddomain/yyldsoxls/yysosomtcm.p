/* GUI CONVERTED from sosomtcm.p (converter v1.78) Thu Nov 12 20:06:17 2009 */
/* sosomtcm.p - SALES ORDER MAINTENANCE CUSTOMER ENTRY                        */
/* Copyright 1986-2009 QAD Inc., Santa Barbara, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 7.0      LAST MODIFIED: 06/23/92   BY: afs *F678*                */
/* REVISION: 7.0      LAST MODIFIED: 06/30/92   BY: tjs *F698*                */
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247*                */
/* REVISION: 7.3      LAST MODIFIED: 01/20/93   BY: afs *G573*                */
/* REVISION: 7.3      LAST MODIFIED: 08/31/93   BY: tjs *GE56*                */
/* REVISION: 7.3      LAST MODIFIED: 11/18/93   BY: afs *GH40*                */
/* REVISION: 7.3      LAST MODIFIED: 05/23/94   BY: afs *FM85*                */
/* REVISION: 7.3      LAST MODIFIED: 05/27/94   BY: dpm *FO48*                */
/* REVISION: 7.3      LAST MODIFIED: 09/10/94   BY: bcm *GM05*                */
/* REVISION: 7.3      LAST MODIFIED: 11/01/94   BY: afs *FT20*                */
/* REVISION: 7.3      LAST MODIFIED: 04/10/95   BY: vrn *G0KG*                */
/* REVISION: 8.5      LAST MODIFIED: 08/25/95   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 05/13/96   BY: *J0M3* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 07/08/96   BY: *J0YR* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Elke Van Maele     */
/* REVISION: 8.6      LAST MODIFIED: 11/13/96   BY: *J182* Markus Barone      */
/* REVISION: 8.6      LAST MODIFIED: 03/11/97   BY: *J1KT* Meg Mori           */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K07S* Jean Miller        */
/* REVISION: 8.6      LAST MODIFIED: 07/11/97   BY: *K0DH* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 09/29/97   BY: *K0HB* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 09/18/97   BY: *H1FC* Seema Varma        */
/* REVISION: 8.6      LAST MODIFIED: 11/03/97   BY: *J24Z* Surekha Joshi      */
/* REVISION: 8.7      LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.7      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* Luke Pokic         */
/* REVISION: 9.0      LAST MODIFIED: 12/03/98   BY: *J2ZM* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/13/00   BY: *M0LN* Manish K.          */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *N0CG* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 06/14/00   BY: *L0Y4* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 07/03/00   BY: *N0DX* Rajinder Kamra     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 12/01/00   BY: *M0XC* Ravikumar K        */
/* REVISION: 9.1      LAST MODIFIED: 10/14/00   BY: *N0WB* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F039*                    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *F349*                    */
/* Old ECO marker removed, but no ECO header exists *J10C*                    */
/* Revision: 1.36      BY: Jean Miller           DATE: 08/13/01  ECO: *M11Z*  */
/* Revision: 1.37      By: Jean Miller           DATE: 10/29/01  ECO: *P02K*  */
/* Revision: 1.38      BY: Niranjan R.           DATE: 03/12/02  ECO: *P020*  */
/* Revision: 1.39      BY: Duane Burdette        DATE: 07/02/02  ECO: *N1LX*  */
/* Revision: 1.40      BY: Deepak Rao            DATE: 12/19/02  ECO: *N223*  */
/* Revision: 1.42      BY: Paul Donnelly (SB)    DATE: 06/28/03  ECO: *Q00L*  */
/* Revision: 1.43      BY: Veena Lad             DATE: 02/03/04  ECO: *P1M6*  */
/* Revision: 1.44      BY: Veena Lad             DATE: 03/03/04  ECO: *Q064*  */
/* Revision: 1.45      BY: Gaurav Kerkar         DATE: 07/09/04  ECO: *P28X*  */
/* Revision: 1.46      BY: Bhavik Rathod         DATE: 01/07/05  ECO: *Q0GD*  */
/* Revision: 1.47      BY: Katie Hilbert         DATE: 01/07/05  ECO: *Q0GH*  */
/* Revision: 1.48      BY: SurenderSingh N.      DATE: 01/12/05  ECO: *P322*  */
/* Revision: 1.48.1.1  BY: Alok Gupta            DATE: 08/04/05  ECO: *P3WS*  */
/* Revision: 1.48.1.2  BY: Shivaraman V.         DATE: 04/11/06  ECO: *P4P5*  */
/* Revision: 1.48.1.5     BY: Mochesh Chandran   DATE: 07/09/07  ECO: *P61L*  */
/* $Revision: 1.48.1.6 $    BY: Gerard Menezes   DATE: 11/13/09  ECO: *Q3M1*  */
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 09/27/12  ECO: *SS-20120927.1*   */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{cxcustom.i "SOSOMTCM.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define input parameter this-is-rma     as  logical.

define input parameter rma-recno       as  recid.
define input parameter new-rma         as  logical.
define output parameter l_edittax      like mfc_logical initial no no-undo.

define new shared variable ad_recno        as recid.
define new shared variable ship2_addr      like so_ship.
define new shared variable ship2_pst_id    like cm_pst_id.
define new shared variable ship2_lang      like cm_lang.
define new shared variable ship2_ref       like cm_addr.

define shared variable so_recno as recid.
define shared variable undo_cust    like mfc_logical.
define shared variable new_order    like mfc_logical initial no.
define shared variable rebook_lines as   logical initial no no-undo.

define variable yn              like mfc_logical initial yes.
define variable old_bill        like so_bill.
define variable l_old_soldto    like so_cust     no-undo.
define variable l_shiptocheck   like mfc_logical no-undo.

define buffer bill_cm           for cm_mstr.

/* EMT SPECIFIC VARIABLES */
define variable prev-ship-to like so_ship no-undo.
define variable enduser-ok as logical no-undo.

{sobtbvar.i }    /* EMT SHARED WORKFILES AND VARIABLES */

/* Frames */
define shared frame a.
define shared frame sold_to.
define shared frame ship_to.
define shared frame ship_to1.
define shared frame ship_to2.

do transaction:

   for first mnd_det
      fields (mnd_exec mnd_nbr mnd_select)
      where  (mnd_exec = "adstmt.p")
   no-lock:
   end. /* FOR FIRST mnd_det */
   if available mnd_det
   then do:
      {gprun1.i ""mfsec.p"" "(input mnd_det.mnd_nbr,
                              input mnd_det.mnd_select,
                              input false,
                              output l_shiptocheck )" }
   end. /* IF AVAILABLE mnd_det */

   
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
      
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
so_nbr label "Order"
      so_cust
      so_bill
      so_ship
    SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

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

   {mfadform.i "sold_to" 1 SOLD-TO}
   {mfadform.i "ship_to" 41 SHIP-TO}
   {mfadform.i "bill_to" 41 BILL-TO}
   {mfadform.i "enduser" 41 END_USER}

   if session:display-type = "GUI" then do:
      {mfadform.i "ship_to1" 41 SHIP-TO}
      {mfadform.i "bill_to1" 41 BILL-TO}
      {mfadform.i "enduser1" 41 END_USER}
      {mfadform.i "ship_to2" 41 SHIP-TO}
      {mfadform.i "bill_to2" 41 BILL-TO}
      {mfadform.i "enduser2" 41 END_USER}
   end. /* SESSION:DISPLAY-TYPE = "GUI" */

   FORM /*GUI*/ 
      rma_enduser
   with frame end-user overlay row 5 column 26 width 15 attr-space THREE-D /*GUI*/.


   /* SET EXTERNAL LABELS */
   setFrameLabels(frame end-user:handle).

   for first soc_ctrl
   fields( soc_domain soc_apm soc_use_btb)
    where soc_ctrl.soc_domain = global_domain no-lock: end.

   find so_mstr where recid(so_mstr) = so_recno exclusive-lock no-error.

   display
      so_nbr
      so_cust
      so_bill
      so_ship
   with frame a.

   assign
      l_edittax    = no
      l_old_soldto = so_cust.

   /* APM Specific Logic */
   if available soc_ctrl and soc_apm and not new_order then do:

      display
         so_cust
      with frame a.

      pause 0.

      for first cm_mstr
         fields( cm_domain cm_addr cm_bill cm_curr cm_lang cm_pst_id)
          where cm_mstr.cm_domain = global_domain and  cm_addr = so_cust
      no-lock: end. /* FOR FIRST CM_MSTR */

      for first ad_mstr
         fields( ad_domain ad_addr ad_city ad_country ad_line1 ad_line2 ad_name
                ad_ref ad_state ad_type ad_zip)
          where ad_mstr.ad_domain = global_domain and  ad_addr = cm_addr
      no-lock: end. /* FOR FIRST AD_MSTR */

      if not available ad_mstr or not available cm_mstr then do:
         /* Not a valid Customer */
         {pxmsg.i &MSGNUM=3 &ERRORLEVEL=3}
         undo, retry.
      end.

   end. /* IF SOC_APM AND NOT NEW_ORDER */

   else do:  /* APM NOT ACTIVE OR A NEW ORDER */

      prompt-for
         so_mstr.so_cust
      with frame a editing:

         /* FIND NEXT/PREVIOUS  RECORD */
         {mfnp.i cm_mstr so_cust  " cm_mstr.cm_domain = global_domain and
         cm_addr "  so_cust cm_addr cm_addr}

         if recno <> ? then do:
            so_cust = cm_addr.
            display
               so_cust
            with frame a.
            {mfaddisp.i so_cust sold_to}
         end.
      end.

      /* added condition for soldto to prevent Qxtend errors */
      if not new so_mstr
         and so_cust entered and (l_old_soldto <> input so_cust)
      then do:

        /* CHECK FOR EXISTING PRE-SHIPPER OR SHIPPER */

         for first abs_mstr
            fields (abs_order abs_domain)
            where abs_order           = so_nbr
            and   abs_mstr.abs_domain = global_domain
         no-lock:
         end. /* FOR FIRST abs_mstr */

         if available abs_mstr
         then do:
            /* CANNOT MODIFY CUSTOMER. PRE-SHIPPER/SHIPPER EXISTS */
            {pxmsg.i &MSGNUM=6867 &ERRORLEVEL=3}
            next-prompt so_cust.
            clear frame sold_to.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame sold_to = F-sold_to-title.
            undo, retry.
         end. /* IF AVAILABLE abs_mstr */

         /* CHECK FOR EXISTING SHIPMENTS */

         {&SOSOMTCM-P-TAG1}

         for first tr_hist
            fields( tr_domain tr_nbr tr_type)
             where tr_hist.tr_domain = global_domain and  tr_nbr = so_nbr
              and tr_type = "ISS-SO"
          /* HINT FOR ORACLE TO USE THE CORRECT INDEX */
         no-lock query-tuning(HINT "INDEX(TR_HIST##TR_NBR_EFF)"):
         end.

         {&SOSOMTCM-P-TAG2}

         if available tr_hist then do:
            /* Can't modify customer, transaction history exists */
            {pxmsg.i &MSGNUM=3040 &ERRORLEVEL=3}
            next-prompt so_cust.
            clear frame sold_to.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame sold_to = F-sold_to-title.
            undo, retry.
         end.
         else
            rebook_lines = true.

         if l_old_soldto     <> ""
            and l_old_soldto <> input so_cust
            and can-find(first mfc_ctrl
                         where mfc_domain = global_domain
                         and   mfc_field  = "l_vqc_sold_usage"
                         and   mfc_logical)
         then do:

            /* SOLD-TO CHANGED. UPDATE TAX DATA */
            {pxmsg.i &MSGNUM=6463 &ERRORLEVEL=1 &CONFIRM=l_edittax}

            /* LOAD DEFAULT TAX CLASS & USAGE */
            if l_edittax
            then do:

              for first ad_mstr
                  fields(ad_domain ad_addr ad_city ad_country ad_edi_ctrl
                         ad_inv_mthd ad_lang ad_line1 ad_line2 ad_name
                         ad_pst_id ad_ctry ad_state ad_taxable ad_taxc
                         ad_tax_in ad_tax_usage ad_zip)
                  where ad_mstr.ad_domain = global_domain
                  and   ad_addr           = input so_cust no-lock:
                     so_tax_usage = ad_tax_usage.
              end. /* FOR FIRST ad_mstr */

            end. /* IF l_edittax */

         end. /* IF l_old_soldto <> "" AND ... */

      end.

      {mfaddisp.i "input so_cust" sold_to}

      for first cm_mstr
         fields( cm_domain cm_addr cm_bill cm_curr cm_lang cm_pst_id)
          where cm_mstr.cm_domain = global_domain and  cm_addr = input so_cust
          no-lock:
      end. /* FOR FIRST CM_MSTR */

      if not available ad_mstr or not available cm_mstr then do:
         /* Not a valid Customer */
         {pxmsg.i &MSGNUM=3 &ERRORLEVEL=3}
         next-prompt so_cust with frame a.
         undo, retry.
      end.

      assign
         so_cust = input so_cust.

   end. /* APM NOT ACTIVE OR A NEW ORDER */

   global_addr = so_cust.

   /* Display default bill-to and ship-to */
   if new_order then do:

      if cm_bill <> "" then
         so_bill = cm_bill.
      else
         so_bill = so_cust.

      so_ship = so_cust.

      display
         so_bill
         so_ship
      with frame a.

   end.

   old_bill = so_bill.

   do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


      hide frame ship_to.

      if session:display-type = "GUI" then do:

         hide frame ship_to1.
         hide frame ship_to2.

         if not global-tool-bar then do:
            {mfaddisp.i so_bill bill_to1 "row 2.6"}
         end. /* NOT GLOBAL-TOOL-BAR */
         else do:
            {mfaddisp.i so_bill bill_to2 "row 4"}
         end. /* GLOBAL-TOOL-BAR */

      end. /* SESSION:DISPLAY-TYPE = "GUI" */

      else do:
         {mfaddisp.i so_bill bill_to}
      end. /* SESSION:DISPLAY-TYPE = "CHUI" */

      prompt-for
         so_bill
      with frame a editing:

         {mfnp.i bill_cm so_bill  " bill_cm.cm_domain = global_domain and
         bill_cm.cm_addr "
            so_bill bill_cm.cm_addr cm_addr}

         if recno <> ? then do:

            so_bill = bill_cm.cm_addr.
            display
               so_bill
            with frame a.

            if session:display-type = "GUI" then do:
               if not global-tool-bar then do:
                  {mfaddisp.i so_bill bill_to1 "row 2.6"}
               end. /* NOT GLOBAL-TOOL-BAR */
               else do:
                  {mfaddisp.i so_bill bill_to2 "row 4"}
               end. /* GLOBAL-TOOL-BAR */
            end. /* SESSION:DISPLAY-TYPE = "GUI" */
            else do:
               {mfaddisp.i so_bill bill_to}
            end. /* SESSION:DISPLAY-TYPE = "CHUI " */
         end.
      end.

      for first bill_cm
         fields( cm_domain cm_addr cm_bill cm_curr cm_lang cm_pst_id)
          where bill_cm.cm_domain = global_domain and  bill_cm.cm_addr = input
          so_bill no-lock:
      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR FIRST BILL_CM */

      if not available bill_cm then do:
         /* Not a valid customer */
         {pxmsg.i &MSGNUM=3 &ERRORLEVEL=3}
         undo, retry.
      end.

      /* DON'T CHANGE BILL-TO IF BILL-TO'S DEFAULT CURR <> SO CURR */
      if (not new so_mstr)
         and (old_bill <> input so_bill)
         and (bill_cm.cm_curr <> so_curr)
      then do:
         /* CUSTOMER BILL-TO CURRENCY DOES NOT MATCH SALES ORDER CURRENCY  */
         {pxmsg.i &MSGNUM=2018 &ERRORLEVEL=2}
         if this-is-rma and not batchrun then pause.
      end.  /* do on error... */

      assign
         so_bill = input so_bill.

      hide frame bill_to.

      if session:display-type = "GUI" then do:
         hide frame bill_to1.
         hide frame bill_to2.
      end. /* SESSION:DISPLAY-TYPE = "GUI" */

   end.  /* bill-to transaction */

   enduser-ok = yes.

   if this-is-rma then
   do on error undo, retry
      on endkey undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


      enduser-ok = no.

      find rma_mstr where recid(rma_mstr) = rma-recno
      exclusive-lock no-error.

      /* rma_cust_ven IS TO BE SET TO so_cust EVERY TIME,       */
      /* NOT ONLY FOR NEW RMA'S                                 */
      assign
         rma_cust_ven = so_cust.

      /* FOR NEW RMA'S, THE END USER DEFAULTS FROM THE CUSTOMER */
      if new-rma then do:
         so_ship      = rma_enduser.
         if rma_enduser = " " then
            rma_enduser  = rma_cust_ven.
      end.

      if session:display-type = "GUI" then do:
         if not global-tool-bar then do:
            {mfaddisp.i rma_enduser enduser1 "row 2.6"}
         end. /* NOT GLOBAL-TOOL-BAR */
         else do:
            {mfaddisp.i rma_enduser enduser2 "row 4"}
         end. /* GLOBAL-TOOL-BAR */
      end. /* SESSION:DISPLAY-TYPE = "GUI" */
      else do:
         {mfaddisp.i rma_enduser enduser}
      end. /* SESSION:DISPLAY-TYPE = "CHUI" */

      pause 0.

      display
         rma_enduser
      with frame end-user.

      eusetloop:
      do on error undo, retry
         on endkey undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


         prompt-for
            rma_enduser
         with frame end-user editing:

            {mfnp.i eu_mstr rma_enduser  " eu_mstr.eu_domain = global_domain
            and eu_addr "  rma_enduser eu_addr eu_addr}

            if recno <> ? then do:

               rma_enduser  = eu_addr.

               display
                  rma_enduser
               with frame end-user.

               if session:display-type = "GUI" then do:
                  if not global-tool-bar then do:
                     {mfaddisp.i rma_enduser enduser1 "row 2.6"}
                  end. /* NOT GLOBAL-TOOL-BAR */
                  else do:
                     {mfaddisp.i rma_enduser enduser2 "row 4"}
                  end. /* GLOBAL-TOOL-BAR */
               end. /* SESSION:DISPLAY-TYPE = "GUI" */
               else do:
                  {mfaddisp.i rma_enduser enduser}
               end. /* SESSION:DISPLAY-TYPE = "CHUI" */

            end.

         end.   /* editing */

         rma_enduser = input rma_enduser.

         for first eu_mstr
            fields( eu_domain eu_addr eu_cm_nbr)
             where eu_mstr.eu_domain = global_domain and  eu_addr =  rma_enduser
         no-lock: end.
/*GUI*/ if global-beam-me-up then undo, leave.


         do while not available eu_mstr:

            yn = yes.

            /* END USER DOES NOT EXIST. CREATE? */
            {pxmsg.i &MSGNUM=7208 &ERRORLEVEL=1 &CONFIRM=yn}

            if yn = no then
               undo, retry.

            /* CREATE END USER */
            /* REMOVED OUTPUT PARAMETER eucreated */
            {gprun.i ""fscaeumt.p""
               "(input        rma_cust_ven,
                 input        """",
                 input        """",
                 input        """",
                 input-output rma_enduser
                )"}
/*GUI*/ if global-beam-me-up then undo, leave.


            for first eu_mstr
               fields( eu_domain eu_addr eu_cm_nbr)
                where eu_mstr.eu_domain = global_domain and  eu_addr =
                rma_enduser no-lock:
            end. /* FOR FIRST EU_MSTR */

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
   /* do while not available eu_mstr */

         /* DO NOT ALLOW AN END USER WHO IS NOT ASSOCIATED WITH THE */
         /* CURRENT CUSTOMER                                        */
         if eu_cm_nbr <> rma_cust_ven then do:
            /* End user does not belong to this customer */
            {pxmsg.i &MSGNUM=7301 &ERRORLEVEL=3}
            undo eusetloop, retry.
         end.

         if new-rma then do:
            so_ship     = rma_enduser.
            display so_ship with frame a.
         end.
         enduser-ok = yes.

      end.    /* eusetloop do */

   end.   /* if this-is-rma */

   hide frame enduser no-pause.
   hide frame end-user no-pause.

   if session:display-type = "GUI" then do:
      hide frame enduser1.
      hide frame enduser2.
      hide frame ship_to.
      if not global-tool-bar then
         view frame ship_to1.
      else
         view frame ship_to2.
   end. /* SESSION:DISPLAY-TYPE = "GUI" */
   else
      view frame ship_to.

   if enduser-ok then
      if not so_sched then do:

      /* SHIP-TO CUSTOMER */
      do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


         prev-ship-to = so_ship.

         if session:display-type = "GUI" then do:
            if not global-tool-bar then do:
               {mfaddisp.i so_ship ship_to1 "row 2.6"}
            end. /* NOT GLOBAL-TOOL-BAR */
            else do:
               {mfaddisp.i so_ship ship_to2 "row 4"}
            end. /* GLOBAL-TOOL-BAR */
         end. /* SESSION:DISPLAY-TYPE = "GUI" */
         else do:
            {mfaddisp.i so_ship ship_to}
         end. /* SESSION:DISPLAY-TYPE = "CHUI" */

         so_mstr.so_ship:screen-value = so_mstr.so_ship.

         prompt-for so_mstr.so_ship with frame a
         editing:
            /* FIND NEXT/PREVIOUS  RECORD */
            {mfnp01.i ad_mstr so_ship ad_addr ad_ref  " ad_mstr.ad_domain =
            global_domain and so_cust "  ad_ref}
            if recno <> ? then do:
               so_ship = ad_addr.
               display so_ship with frame a.

               if session:display-type = "GUI" then do:
                  if not global-tool-bar then do:
                     {mfaddisp.i so_ship ship_to1 "row 2.6"}
                  end. /* NOT GLOBAL-TOOL-BAR */
                  else do:
                     {mfaddisp.i so_ship ship_to2 "row 4"}
                  end. /* GLOBAL-TOOL-BAR */
               end. /* SESSION:DISPLAY-TYPE = "GUI" */
               else do:
                  {mfaddisp.i so_ship ship_to}
               end. /* SESSION:DISPLAY-TYPE = "CHUI" */
            end.
         end. /* prompt-for so_ship */

         /* CHECK FOR EXISTING PRE-SHIPPER OR SHIPPER */
         if not new so_mstr
            and so_ship entered
         then do:

            for first abs_mstr
               fields (abs_order abs_domain)
               where abs_order           = so_nbr
               and   abs_mstr.abs_domain = global_domain
            no-lock:
            end. /* FOR FIRST abs_mstr */

            if available abs_mstr
            then do:
               /* CANNOT MODIFY CUSTOMER. PRE-SHIPPER/SHIPPER EXISTS */
               {pxmsg.i &MSGNUM=6867 &ERRORLEVEL=3}
               next-prompt so_ship.
               clear frame ship_to.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame ship_to = F-ship_to-title.
               undo, retry.
            end. /* IF AVAILABLE abs_mstr */

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF NOT NEW so_mstr AND so_ship ENTERED */

         assign
            so_ship = input so_ship.

         if session:display-type = "GUI" then do:
            if not global-tool-bar then do:
               {mfaddisp.i so_ship ship_to1 "row 2.6"}
            end. /* NOT GLOBAL-TOOL-BAR */
            else do:
               {mfaddisp.i so_ship ship_to2 "row 4"}
            end. /* GLOBAL-TOOL-BAR */
         end. /* SESSION:DISPLAY-TYPE = "GUI" */
         else do:
            {mfaddisp.i so_ship ship_to}
         end.

         /* ENTERED SHIP-TO MUST BE A VALID CUSTOMER,SHIP-TO OR DOCK */
         if available ad_mstr      and
            ad_type <>  "customer"
         then do:

            if ad_ref = so_cust then do:

               for first ls_mstr
               fields( ls_domain ls_addr ls_type)
                   where ls_mstr.ls_domain = global_domain and (  ls_addr =
                   input so_ship
                  and  (ls_type = "customer" or
                        ls_type = "ship-to"  or
                        ls_type = "dock")
               ) no-lock: end.

               if not available ls_mstr
               then do:
                  if l_shiptocheck
                  then do:
                     /* SHIP-TO DOES NOT EXIST DO YOU WISH TO ADD */
                     {pxmsg.i &MSGNUM=301 &ERRORLEVEL=1 &CONFIRM=yn }
                     if yn then do:
                        create ls_mstr. ls_mstr.ls_domain = global_domain.
                        run p_ls_update.
                     end. /* IF YN THEN */
                     else do:
                        next-prompt so_ship with frame a.
                        undo, retry.
                     end. /* ELSE DO */
                  end.  /* IF l_shiptocheck */
                  else do:
                     /* USER DOES NOT HAVE PERMISSION TO CREATE NEW SHIP-TO */
                     {pxmsg.i &MSGNUM=1623 &ERRORLEVEL=3}
                     next-prompt so_ship with frame a.
                     undo, retry.
                  end. /* ELSE DO : */
               end.  /* IF NOT AVAILABLE LS_MSTR */

            end. /* IF AD_REF = SO_CUST */

            if ad_ref  <> so_cust and
               so_cust <> so_ship
            then do:
               for first ls_mstr
               fields( ls_domain ls_addr ls_type)
                   where ls_mstr.ls_domain = global_domain and (  ls_addr =
                   input so_ship
                  and  (ls_type = "customer" or
                        ls_type = "ship-to"  or
                        ls_type = "dock")
               ) no-lock: end.
               if not available ls_mstr
               then do:
                  /* END USER DOES NOT BELONG TO THIS CUSTOMER */
                  {pxmsg.i &MSGNUM=7301 &ERRORLEVEL=3}
                  undo, retry.
               end. /* IF NOT AVAILABLE LS_MSTR */
            end. /* IF AD_REF <> SO_CUST */

         end. /* IF AVAILABLE AD_MSTR */

         if not available ad_mstr
         then do:
            if l_shiptocheck
            then do:
               /* Ship-To does not exist, add? */
               {pxmsg.i &MSGNUM=301 &ERRORLEVEL=1 &CONFIRM=yn}

               if yn then do:

                  assign
                     ship2_addr   = so_ship
                     ship2_lang   = cm_mstr.cm_lang
                     ship2_pst_id = cm_mstr.cm_pst_id
                     ship2_ref    = cm_mstr.cm_addr.

                  /* Add Ship To */
                  {gprun.i ""sosost.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


                  for first ad_mstr
                     fields( ad_domain ad_addr ad_city ad_country ad_line1 ad_line2
                     ad_name ad_ref ad_state ad_type ad_zip)
                     where recid(ad_mstr) = ad_recno no-lock:
                  end. /* FOR FIRST AD_MSTR */

                  if available ad_mstr then do:

                     if so_ship = "" then
                        so_ship = ad_addr.

                     if session:display-type = "GUI" then do:
                        if not global-tool-bar then
                           hide frame ship_to1.
                        else
                           hide frame ship_to2.
                    end. /* SESSION:DISPLAY-TYPE = "GUI" */

                    view frame ship_to.

                    display
                       ad_name
                       ad_line1
                       ad_line2
                       ad_city
                       ad_state
                       ad_zip
                       ad_country
                    with frame ship_to.

                  end. /* if available ad_mstr */

                  else do:
                     next-prompt so_ship with frame a.
                     undo, retry.
                  end.

               end. /* if yn then do */
            end. /* IF l_shiptocheck */
            else do:
               /* USER DOES NOT HAVE PERMISSION TO CREATE NEW SHIP-TO */
               {pxmsg.i &MSGNUM=1623 &ERRORLEVEL=3}
               next-prompt so_ship with frame a.
               undo, retry.
            end.  /* ELSE DO: */

            if not available ad_mstr
               or ad_ref <> cm_mstr.cm_addr
            then do:
               {pxmsg.i &MSGNUM=3 &ERRORLEVEL=3}
               next-prompt so_ship with frame a.
               undo, retry.
            end.

         end.

         /* DO NOT ALLOW CHANGE OF SHIP-TO AT THE SBU */
         if prev-ship-to <> so_ship and
            not new_order and
            soc_use_btb and
            so_secondary
         then do:
            /* No change is allowed on EMT Order */
            {pxmsg.i &MSGNUM=2825 &ERRORLEVEL=3}
            next-prompt so_ship with frame a.
            undo, retry.
         end.


         if so_ship <> so_cust and ad_ref <> so_cust then do:
            /* Ship-to is not for this customer */
            {pxmsg.i &MSGNUM=606 &ERRORLEVEL=2}
         end.

      end.  /* ship-to input */

   end. /* if not so_sched */

   else do:

      if session:display-type = "GUI"
      then do:
         if not global-tool-bar
         then do:
            {mfaddisp.i so_ship ship_to1 "row 2.6"}
         end. /* NOT GLOBAL-TOOL-BAR */
         else do:
            {mfaddisp.i so_ship ship_to2 "row 4"}
         end. /* GLOBAL-TOOL-BAR */
      end. /* SESSION:DISPLAY-TYPE = "GUI" */
      else do:
         {mfaddisp.i so_ship ship_to}
      end. /* SESSION:DISPLAY-TYPE = "CHUI" */

      if so_ship    <> so_cust
         and ad_ref <> so_cust
      then do:
         /* SHIP-TO IS NOT FOR THIS CUSTOMER */
         {pxmsg.i &MSGNUM=606 &ERRORLEVEL=2}
      end. /* IF so_ship <> so_cust */

   end. /* IF so_sched */

   if enduser-ok then
      undo_cust = false.
   else
      undo, retry.

   clear frame bill_to1 no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame bill_to1 = F-bill_to1-title.
   clear frame bill_to2 no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame bill_to2 = F-bill_to2-title.
   clear frame enduser1 no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame enduser1 = F-enduser1-title.
   clear frame enduser2 no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame enduser2 = F-enduser2-title.

   hide frame bill_to1.
   hide frame bill_to2.
   hide frame enduser1.
   hide frame enduser2.

end.  /* do transaction */

PROCEDURE p_ls_update:
/* ------------------------------------------------------------------
   Purpose:
   Parameters:  <None>
   Notes:
   ------------------------------------------------------------------*/

   assign
      ls_mstr.ls_addr = ad_mstr.ad_addr
      ls_mstr.ls_type = "ship-to".

   {mgqqapp.i "ls_app_owner"}

   if recid (ls_mstr) = -1 then.

END PROCEDURE.
