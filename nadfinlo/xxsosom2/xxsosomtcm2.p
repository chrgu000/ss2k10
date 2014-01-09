/* sosomtcm.p - SALES ORDER MAINTENANCE CUSTOMER ENTRY                        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.40 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
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
/* $Revision: 1.40 $     BY: Deepak Rao            DATE: 12/19/02  ECO: *N223*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110121.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/


{mfdeclre.i}
{cxcustom.i "SOSOMTCM.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sosomtcm_p_1 "Order"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define input parameter this-is-rma     as  logical.

define input parameter rma-recno       as  recid.
define input parameter new-rma         as  logical.

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

   form
      so_nbr label {&sosomtcm_p_1}
      so_cust
      so_bill
      so_ship
   with frame a side-labels width 80 attr-space.

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

   form
      rma_enduser
   with frame end-user overlay row 5 column 26 width 15 attr-space.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame end-user:handle).

   for first soc_ctrl
   fields(soc_apm soc_use_btb)
   no-lock: end.

   find so_mstr where recid(so_mstr) = so_recno exclusive-lock no-error.

   display
      so_nbr
      so_cust
      so_bill
      so_ship
   with frame a.

   /* APM Specific Logic */
   if available soc_ctrl and soc_apm and not new_order then do:

      display
         so_cust
      with frame a.

      pause 0.

      for first cm_mstr
         fields(cm_addr cm_bill cm_curr cm_lang 
            /* SS - 110121.1 - B */
             cm__chr01
            /* SS - 110121.1 - E */
         
         cm_pst_id)
         where cm_addr = so_cust
      no-lock: end. /* FOR FIRST CM_MSTR */

      for first ad_mstr
         fields(ad_addr ad_city ad_country ad_line1 ad_line2 ad_name
                ad_ref ad_state ad_type ad_zip)
         where ad_addr = cm_addr
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
         {mfnp.i cm_mstr so_cust cm_addr so_cust cm_addr cm_addr}

         if recno <> ? then do:
            so_cust = cm_addr.
            display
               so_cust
            with frame a.
            {mfaddisp.i so_cust sold_to}
         end.
      end.

      /* Check for existing shipments */
      if not new so_mstr and so_cust entered then do:

         {&SOSOMTCM-P-TAG1}

         for first tr_hist
            fields(tr_nbr tr_type)
            where tr_nbr = so_nbr
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
            undo, retry.
         end.
         else
            rebook_lines = true.
      end.

      {mfaddisp.i "input so_cust" sold_to}

      for first cm_mstr
         fields(cm_addr cm_bill cm_curr cm_lang 
            /* SS - 110121.1 - B */
             cm__chr01
            /* SS - 110121.1 - E */
         
         cm_pst_id)
         where cm_addr = input so_cust no-lock:
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

/* SS - 110121.1 - B */
    if cm__chr01 <> "AC" then do:
        message "错误:非AC状态的客户,不允许新增订单.请重新输入" .
        undo,retry.
    end.
/* SS - 110121.1 - E */

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

         {mfnp.i bill_cm so_bill bill_cm.cm_addr
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
         fields(cm_addr cm_bill cm_curr cm_lang cm_pst_id)
         where bill_cm.cm_addr = input so_bill no-lock:
      end. /* FOR FIRST BILL_CM */

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

         prompt-for
            rma_enduser
         with frame end-user editing:

            {mfnp.i eu_mstr rma_enduser eu_addr rma_enduser eu_addr eu_addr}

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
            fields(eu_addr eu_cm_nbr)
            where eu_addr =  rma_enduser
         no-lock: end.

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

            for first eu_mstr
               fields(eu_addr eu_cm_nbr)
               where eu_addr =  rma_enduser no-lock:
            end. /* FOR FIRST EU_MSTR */

         end.   /* do while not available eu_mstr */

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

         prompt-for so_mstr.so_ship with frame a
         editing:
            /* FIND NEXT/PREVIOUS  RECORD */
            {mfnp01.i ad_mstr so_ship ad_addr ad_ref so_cust ad_ref}
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
               fields (ls_addr ls_type)
                  where ls_addr = input so_ship
                  and  (ls_type = "customer" or
                        ls_type = "ship-to"  or
                        ls_type = "dock")
               no-lock: end. /* FOR FIRST LS_MSTR */

               if not available ls_mstr
               then do:

                  /* SHIP-TO DOES NOT EXIST DO YOU WISH TO ADD */
                  {pxmsg.i &MSGNUM=301 &ERRORLEVEL=1 &CONFIRM=yn }
                  if yn then do:
                     create ls_mstr.
                     run p_ls_update.
                  end. /* IF YN THEN */
                  else do:
                     next-prompt so_ship with frame a.
                     undo, retry.
                  end. /* ELSE DO */

               end.  /* IF NOT AVAILABLE LS_MSTR */

            end. /* IF AD_REF = SO_CUST */

            if ad_ref  <> so_cust and
               so_cust <> so_ship
            then do:
               for first ls_mstr
               fields (ls_addr ls_type)
                  where ls_addr = input so_ship
                  and  (ls_type = "customer" or
                        ls_type = "ship-to"  or
                        ls_type = "dock")
               no-lock: end.
               if not available ls_mstr
               then do:
                  /* END USER DOES NOT BELONG TO THIS CUSTOMER */
                  {pxmsg.i &MSGNUM=7301 &ERRORLEVEL=3}
                  undo, retry.
               end. /* IF NOT AVAILABLE LS_MSTR */
            end. /* IF AD_REF <> SO_CUST */

         end. /* IF AVAILABLE AD_MSTR */

         if not available ad_mstr then do:

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

               for first ad_mstr
                  fields(ad_addr ad_city ad_country ad_line1 ad_line2
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

   end.

   if enduser-ok then
      undo_cust = false.
   else
      undo, retry.

   clear frame bill_to1 no-pause.
   clear frame bill_to2 no-pause.
   clear frame enduser1 no-pause.
   clear frame enduser2 no-pause.

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
