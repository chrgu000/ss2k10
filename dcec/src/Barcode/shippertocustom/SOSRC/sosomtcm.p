/* GUI CONVERTED from sosomtcm.p (converter v1.75) Sat May  5 08:31:15 2001 */
/* sosomtcm.p - SALES ORDER MAINTENANCE CUSTOMER ENTRY                  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 7.0      LAST MODIFIED: 06/23/92   BY: afs *F678*          */
/* REVISION: 7.0      LAST MODIFIED: 06/30/92   BY: tjs *F698*          */
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247*          */
/* REVISION: 7.3      LAST MODIFIED: 01/20/93   BY: afs *G573*          */
/* REVISION: 7.3      LAST MODIFIED: 08/31/93   BY: tjs *GE56*          */
/* REVISION: 7.3      LAST MODIFIED: 11/18/93   BY: afs *GH40*          */
/* REVISION: 7.3      LAST MODIFIED: 05/23/94   BY: afs *FM85*          */
/* REVISION: 7.3      LAST MODIFIED: 05/27/94   BY: dpm *FO48*          */
/* REVISION: 7.3      LAST MODIFIED: 09/10/94   BY: bcm *GM05*          */
/* REVISION: 7.3      LAST MODIFIED: 11/01/94   BY: afs *FT20*          */
/* REVISION: 7.3      LAST MODIFIED: 04/10/95   BY: vrn *G0KG*                */
/* REVISION: 8.5      LAST MODIFIED: 08/25/95   BY: *J04C* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 05/13/96   BY: *J0M3* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 07/08/96   BY: *J0YR* Kieu Nguyen  */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Elke Van Maele */
/* REVISION: 8.6      LAST MODIFIED: 11/13/96   BY: *J182* Markus Barone  */
/* REVISION: 8.6      LAST MODIFIED: 03/11/97   BY: *J1KT* Meg Mori       */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K07S* Jean Miller    */
/* REVISION: 8.6      LAST MODIFIED: 07/11/97   BY: *K0DH* Kieu Nguyen    */
/* REVISION: 8.6      LAST MODIFIED: 09/29/97   BY: *K0HB* Kieu Nguyen    */
/* REVISION: 8.6      LAST MODIFIED: 09/18/97   BY: *H1FC* Seema Varma    */
/* REVISION: 8.6      LAST MODIFIED: 11/03/97   BY: *J24Z* Surekha Joshi  */
/* REVISION: 8.7      LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.7      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* Luke Pokic     */
/* REVISION: 9.0      LAST MODIFIED: 12/03/98   BY: *J2ZM* Reetu Kapoor   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan     */
/* REVISION: 9.0      LAST MODIFIED: 04/07/00   BY: *M0LN* Manish K.      */
/* REVISION: 9.0      LAST MODIFIED: 06/14/00   BY: *L0Y4* Santosh Rao    */
/* REVISION: 9.0      LAST MODIFIED: 12/01/00   BY: *M0XC* Ravikumar K    */
/* REVISION: 9.0      LAST MODIFIED: 04/21/01   BY: *M11Z* Jean Miller    */

         {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sosomtcm_p_1 "订单"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomtcm_p_2 " 票据开往 "
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomtcm_p_3 " 销售至 "
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomtcm_p_4 " 货物发往 "
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomtcm_p_5 " 最终用户 "
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


/*J04C*/ define input parameter this-is-rma     as  logical.
/*J1KT**    * WILL BE YES FOR RMA */

/*J04C*/ define input parameter rma-recno       as  recid.
/*J04C*/ define input parameter new-rma         as  logical.
/*J1KT**    * WILL BE YES WHEN FIRST CREATING RMA */

         define     shared variable so_recno as recid.
         define     shared variable undo_cust like mfc_logical.

         define            variable yn              like mfc_logical initial yes.
/*GE56*/ define            variable old_bill        like so_bill.
         define     shared variable new_order       like mfc_logical initial no.
         define     shared variable rebook_lines    as logical initial no no-undo.

         define            buffer bill_cm           for cm_mstr.

/*F698*/ define new shared variable ad_recno        as recid.
/*F698*/ define new shared variable ship2_addr      like so_ship.
/*F698*/ define new shared variable ship2_pst_id    like cm_pst_id.
/*F698*/ define new shared variable ship2_lang      like cm_lang.
/*F698*/ define new shared variable ship2_ref       like cm_addr.
/*J04C*/ define new shared variable eucreated       like ad_addr.

         /* BTB SPECIFIC VARIABLES */
/*L0Y4** /*K004*/ define variable prev-ship-to like so_ship.  */
/*M11Z* /*L0Y4*/ define     shared variable prev-ship-to like so_ship     no-undo. */
/*M11Z* /*L0Y4*/ define new shared variable l_status     like mfc_logical no-undo. */
/*M11Z*/ define variable prev-ship-to like so_ship no-undo.
/*K07S*/ define variable enduser-ok as logical no-undo.

/*K004*/ {sobtbvar.i }    /* BACK TO BACK SHARED WORKFILES AND VARIABLES */

         /* Frames */
         define     shared frame a.
         define     shared frame sold_to.
         define     shared frame ship_to.
/*J2ZM*/ define     shared frame ship_to1.
/*J2ZM*/ define     shared frame ship_to2.

/*J10C* DELETE FOLLOWING ***
 * /*J0YR*/ define     shared frame b.
 * /*J0YR*/ define shared variable socmmts     like soc_hcmmts label "Comments".
 * /*J0YR*/ define shared variable confirm     like mfc_logical
 *             format "Y/N" initial yes label "Confirmed".
 * /*J0YR*/ define shared variable promise_date as date label "Promise Date".
 * /*J0YR*/ define shared variable socrt_int   like sod_crt_int.
 * /*J0YR*/ define shared variable reprice     like mfc_logical label "Reprice".
 * /*J0YR*/ define shared variable line_pricing like pic_so_linpri
 *                                                 label "Line Pricing".
 * /*J0YR*  ADDED frame b */
 *         form
 *            so_ord_date     colon 15
 *          line_pricing    colon 38
 *          confirm         colon 58 so_conf_date no-label
 *
 *            so_req_date     colon 15
 *            so_pr_list      colon 38
 *            so_curr         colon 58 so_lang
 *
 *            promise_date    colon 15
 *            so_site         colon 38
 * /*V8-*/
 *            so_taxable      colon 58 so_taxc no-label so_tax_date to 77 no-label
 * /*V8+*/
 * /*V8!
 *            so_taxable      colon 58
 *            view-as fill-in size 3.5 by 1
 *            so_taxc no-label so_tax_date to 79 no-label */
 *
 *            so_due_date     colon 15
 *            so_channel      colon 38
 *            so_fix_pr       colon 68
 *
 *          so_pricing_dt   colon 15
 *            so_project      colon 38
 *            so_cr_terms     colon 68
 *
 *            so_po           colon 15
 *          socrt_int       colon 68
 *
 *            so_rmks         colon 15
 *          reprice         colon 68
 *         with frame b side-labels width 80 attr-space.
 *J10C* END DELETE ****************************/

/*M11Z* /*F698*/ do transaction on error undo, retry:     */
/*M11Z* /*F698*/    find first adc_ctrl no-lock no-error. */

/*M11Z* /*F698*/    if not available adc_ctrl then create adc_ctrl. */
/*M11Z* /*F698*/ end.                                               */

do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


      
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
       
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
so_nbr label {&sosomtcm_p_1}
               so_cust LABEL "销往"
               so_bill LABEL "票据开往"
               so_ship LABEL "货物发往"
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



         {mfadform.i "sold_to" 1 {&sosomtcm_p_3}}
/*GM05*/ {mfadform.i "ship_to" 41 {&sosomtcm_p_4}}
/*GM05** {mfadform.i "ship_to" "41 row 5" " Ship-To "} **/
         {mfadform.i "bill_to" 41 {&sosomtcm_p_2}}
/*J04C*/ {mfadform.i "enduser" 41 {&sosomtcm_p_5}}

/*J2ZM*/ if session:display-type = "GUI":U then do:
/*J2ZM*/    {mfadform.i "ship_to1" 41 {&sosomtcm_p_4}}
/*J2ZM*/    {mfadform.i "bill_to1" 41 {&sosomtcm_p_2}}
/*J2ZM*/    {mfadform.i "enduser1" 41 {&sosomtcm_p_5}}
/*J2ZM*/    {mfadform.i "ship_to2" 41 {&sosomtcm_p_4}}
/*J2ZM*/    {mfadform.i "bill_to2" 41 {&sosomtcm_p_2}}
/*J2ZM*/    {mfadform.i "enduser2" 41 {&sosomtcm_p_5}}
/*J2ZM*/ end. /* SESSION:DISPLAY-TYPE = "GUI" */

/*J04C*/    FORM /*GUI*/ 
/*J04C*/        rma_enduser
/*J04C*/    with frame end-user overlay row 5 column 26
                width 15 attr-space THREE-D /*GUI*/.


/*K004*/ find first soc_ctrl no-lock.

      find so_mstr where recid(so_mstr) = so_recno.
      display so_nbr so_cust so_bill so_ship with frame a.
/*M017*/ for first soc_ctrl fields(soc_apm) no-lock: end.
/*GUI*/ if global-beam-me-up then undo, leave.

/*M017*/ if available soc_ctrl and soc_apm and not new_order then do:
/*M017*/    display so_cust with frame a.
/*M017*/    pause 0.
/*M017*/    find cm_mstr where cm_addr = so_cust no-lock no-error.
/*M017*/    find ad_mstr where ad_addr = cm_addr no-lock no-error.
/*M017*/    if not available ad_mstr or not available cm_mstr then do:
/*M017*/       {mfmsg.i 3 3}
/*M017*/       undo, retry.
/*M017*/    end.
/*M017*/ end. /* IF SOC_APM AND NOT NEW_ORDER */
/*M017*/ else do:  /* APM NOT ACTIVE OR A NEW ORDER */

      prompt-for so_mstr.so_cust with frame a editing:

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
         find first tr_hist where tr_nbr  = so_nbr
                              and tr_type = "ISS-SO"
                            no-lock no-error.
         if available tr_hist then do:
             {mfmsg.i 3040 3} /*can't modify -- tr_hist exists*/
             next-prompt so_cust.
             clear frame sold_to.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame sold_to = F-sold_to-title.
             undo, retry.
         end.
         else
            rebook_lines = true.
      end.

/*G573** {mfaddisp.i "input so_cust" sold_to"} **/
/*G573*/ {mfaddisp.i "input so_cust" sold_to}

      find cm_mstr where cm_addr = input so_cust no-lock no-error.
      if not available ad_mstr or not available cm_mstr then do:
         {mfmsg.i 3 3}
         next-prompt so_cust with frame a.
         undo, retry.
      end.

      assign
         so_cust = input so_cust.

/*M017*/ end. /* APM NOT ACTIVE OR A NEW ORDER */

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

      /*F039* BILL-TO CUSTOMER */
/*GE56*/ old_bill = so_bill.
      do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


            hide frame ship_to.
/*J2ZM*/    if session:display-type = "GUI" then do:
/*J2ZM*/    hide frame ship_to1.
/*J2ZM*/    hide frame ship_to2.
/*J2ZM*/    if not global-tool-bar then do:
/*J2ZM*/       {mfaddisp.i so_bill bill_to1 "row 2.6"}
/*J2ZM*/    end. /* NOT GLOBAL-TOOL-BAR */
/*J2ZM*/    else do:
/*J2ZM*/       {mfaddisp.i so_bill bill_to2 "row 4"}
/*J2ZM*/    end. /* GLOBAL-TOOL-BAR */
/*J2ZM*/ end. /* SESSION:DISPLAY-TYPE = "GUI" */
/*J2ZM*/ else do:
/*J10C* /*J0YR*/ hide frame b.   */
        {mfaddisp.i so_bill bill_to}
/*J2ZM*/ end. /* SESSION:DISPLAY-TYPE = "CHUI" */

/*J10C* /*J0YR*/ view frame b.   */
         prompt-for so_bill with frame a editing:

            {mfnp.i bill_cm so_bill bill_cm.cm_addr
                            so_bill bill_cm.cm_addr cm_addr}

            if recno <> ? then do:

               so_bill = bill_cm.cm_addr.
               display
                  so_bill
               with frame a.

/*J2ZM*/             if session:display-type = "GUI" then do:
/*J2ZM*/          if not global-tool-bar then do:
/*J2ZM*/             {mfaddisp.i so_bill bill_to1 "row 2.6"}
/*J2ZM*/          end. /* NOT GLOBAL-TOOL-BAR */
/*J2ZM*/          else do:
/*J2ZM*/             {mfaddisp.i so_bill bill_to2 "row 4"}
/*J2ZM*/          end. /* GLOBAL-TOOL-BAR */
/*J2ZM*/       end. /* SESSION:DISPLAY-TYPE = "GUI" */
/*J2ZM*/       else do:
                  {mfaddisp.i so_bill bill_to}
/*J2ZM*/       end. /* SESSION:DISPLAY-TYPE = "CHUI " */
            end.
         end.

         find bill_cm where bill_cm.cm_addr = input so_bill no-lock no-error.
         if not available bill_cm then do:
            {mfmsg.i 3 3}
            undo, retry.
         end.

         /* DON'T CHANGE BILL-TO IF BILL-TO'S DEFAULT CURR <> SO CURR */
         if (not new so_mstr)
/*GE56*   and (so_bill <> input so_bill)                                     */
/*GE56*   and (bill_cm.cm_curr <> base_curr or so_curr <> base_curr) then do:*/
/*GE56*/  and (old_bill <> input so_bill)
/*GE56*/  and (bill_cm.cm_curr <> so_curr) then do:

/*H1FC**  BEGIN DELETE **
 *          {mfmsg.i 82 3} /* Cust currency must be consistent with SO curr */
 *          undo, retry.
 *H1FC**  END DELETE   */

/*H1FC*/    /* CUSTOMER BILL-TO CURRENCY DOES NOT MATCH SALES ORDER CURRENCY  */
/*H1FC*/    {mfmsg.i 2018 2}
/*H1FC*/     if this-is-rma and not batchrun then pause.

         end.  /* do on error... */

         assign
            so_bill = input so_bill.
         hide frame bill_to.

/*J2ZM*/ if session:display-type = "GUI" then do:
/*J2ZM*/     hide frame bill_to1.
/*J2ZM*/     hide frame bill_to2.
/*J2ZM*/  end. /* SESSION:DISPLAY-TYPE = "GUI" */

/*F678** view frame ship_to. */

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* bill-to transaction */

/*J04C*  ADDED THE FOLLOWING FOR RMA END USER */
/*K07S*/ enduser-ok = yes.
         if this-is-rma then
         do on error undo, retry
            on endkey undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


/*K07S*/    enduser-ok = no.
            find rma_mstr where recid(rma_mstr) = rma-recno
                exclusive-lock no-error.

/*J24Z*/    /* rma_cust_ven IS TO BE SET TO so_cust EVERY TIME,       */
/*J24Z*/    /* NOT ONLY FOR NEW RMA'S                                 */
/*J24Z*/    assign rma_cust_ven = so_cust.

            /* FOR NEW RMA'S, THE END USER DEFAULTS FROM THE CUSTOMER */
            if new-rma then do:
/*J24Z**        assign rma_cust_ven = so_cust. */
                       so_ship      = rma_enduser.
                if rma_enduser = " " then
/*K07S*/ /*            rma_enduser  = so_ship.      */
                       rma_enduser  = rma_cust_ven.

            end.

/*J2ZM*/    if session:display-type = "GUI" then do:
/*J2ZM*/       if not global-tool-bar then do:
/*J2ZM*/          {mfaddisp.i rma_enduser enduser1 "row 2.6"}
/*J2ZM*/       end. /* NOT GLOBAL-TOOL-BAR */
/*J2ZM*/       else do:
/*J2ZM*/          {mfaddisp.i rma_enduser enduser2 "row 4"}
/*J2ZM*/       end. /* GLOBAL-TOOL-BAR */
/*J2ZM*/    end. /* SESSION:DISPLAY-TYPE = "GUI" */
/*J2ZM*/    else do:
               {mfaddisp.i rma_enduser enduser}
/*J2ZM*/    end. /* SESSION:DISPLAY-TYPE = "CHUI" */

            pause 0.
            display
               rma_enduser
            with frame end-user.

            eusetloop:
            do on error undo, retry
               on endkey undo,leave:
/*GUI*/ if global-beam-me-up then undo, leave.


               prompt-for
                rma_enduser
               with frame end-user editing:

                  {mfnp.i eu_mstr rma_enduser eu_addr rma_enduser
                       eu_addr eu_addr}

                   if recno <> ? then do:
                      rma_enduser  = eu_addr.

                      display
                          rma_enduser
                      with frame end-user.

/*J2ZM*/              if session:display-type = "GUI" then do:
/*J2ZM*/                 if not global-tool-bar then do:
/*J2ZM*/                    {mfaddisp.i rma_enduser enduser1 "row 2.6"}
/*J2ZM*/                 end. /* NOT GLOBAL-TOOL-BAR */
/*J2ZM*/                 else do:
/*J2ZM*/                    {mfaddisp.i rma_enduser enduser2 "row 4"}
/*J2ZM*/                 end. /* GLOBAL-TOOL-BAR */
/*J2ZM*/              end. /* SESSION:DISPLAY-TYPE = "GUI" */
/*J2ZM*/              else do:
                         {mfaddisp.i rma_enduser enduser}
/*J2ZM*/              end. /* SESSION:DISPLAY-TYPE = "CHUI" */

                   end.

               end.   /* editing */

                  rma_enduser = input rma_enduser.

               find eu_mstr
                      where eu_addr =  rma_enduser
                      no-lock no-error.

               do while not available eu_mstr:
                   yn = yes.
/*J0YR*                   {mfmsg01.i 7208 3 yn}               */
/*J0YR*/           {mfmsg01.i 7208 1 yn}
                   /* END USER DOES NOT EXIST. CREATE? */
                   if yn = no then
                      undo, retry.
/*J182*/           /* ADDED INPUT PARAMS FOR AD_ATTN, AD_ZIP & AD_PHONE */
                   {gprun.i ""fscaeumt.p""
                             "(input        rma_cust_ven,
                               input        """",
                               input        """",
                               input        """",
                               input-output rma_enduser)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                    find eu_mstr
                        where eu_addr =  rma_enduser
                        no-lock no-error.
               end.   /* do while not available eu_mstr */

               /* DO NOT ALLOW AN END USER WHO IS NOT ASSOCIATED WITH THE */
               /* CURRENT CUSTOMER                                        */
               if eu_cm_nbr <> rma_cust_ven then do:
                    {mfmsg.i 7301 3}
                    undo eusetloop, retry.
               end.
/*J1KT**       assign global_addr = rma_enduser. */
/*J1KT*/       if new-rma then do:
                      so_ship     = rma_enduser.
                      display so_ship with frame a.
/*J1KT*/       end.
/*K07S*/       enduser-ok = yes.

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
    /* eusetloop do */

     end.
/*GUI*/ if global-beam-me-up then undo, leave.
   /* if this-is-rma */

     hide frame enduser no-pause.
     hide frame end-user no-pause.
/*J10C* /*J0YR*/ hide frame b.     */

/*J2ZM*/ if session:display-type = "GUI" then do:
/*J2ZM*/    hide frame enduser1.
/*J2ZM*/    hide frame enduser2.
/*J2ZM*/    hide frame ship_to.
/*J2ZM*/    if not global-tool-bar then
/*J2ZM*/       view frame ship_to1.
/*J2ZM*/    else
/*J2ZM*/       view frame ship_to2.
/*J2ZM*/ end. /* SESSION:DISPLAY-TYPE = "GUI" */
/*J2ZM*/ else
           view frame ship_to.

/*J10C* /*J0YR*/  view frame b.    */

/*J04C*  END ADDED CODE */
/*K07S*/ if enduser-ok then
/*FO48*/ if not so_sched then do:

            /* SHIP-TO CUSTOMER */
            do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


/*K004*/       prev-ship-to = so_ship.

/*F698*        hide frame new_ship no-pause. */

/*J2ZM*/             if session:display-type = "GUI" then do:
/*J2ZM*/          if not global-tool-bar then do:
/*J2ZM*/             {mfaddisp.i so_ship ship_to1 "row 2.6"}
/*J2ZM*/          end. /* NOT GLOBAL-TOOL-BAR */
/*J2ZM*/          else do:
/*J2ZM*/             {mfaddisp.i so_ship ship_to2 "row 4"}
/*J2ZM*/          end. /* GLOBAL-TOOL-BAR */
/*J2ZM*/       end. /* SESSION:DISPLAY-TYPE = "GUI" */
/*J2ZM*/       else do:
                  {mfaddisp.i so_ship ship_to}
/*J2ZM*/       end. /* SESSION:DISPLAY-TYPE = "CHUI" */

               prompt-for so_mstr.so_ship with frame a editing:
                  /* FIND NEXT/PREVIOUS  RECORD */
                  {mfnp01.i ad_mstr so_ship ad_addr ad_ref so_cust ad_ref}
                  if recno <> ? then do:
                     so_ship = ad_addr.
                     display so_ship with frame a.

/*J2ZM*/             if session:display-type = "GUI" then do:
/*J2ZM*/                if not global-tool-bar then do:
/*J2ZM*/                   {mfaddisp.i so_ship ship_to1 "row 2.6"}
/*J2ZM*/                end. /* NOT GLOBAL-TOOL-BAR */
/*J2ZM*/                else do:
/*J2ZM*/                   {mfaddisp.i so_ship ship_to2 "row 4"}
/*J2ZM*/                end. /* GLOBAL-TOOL-BAR */
/*J2ZM*/             end. /* SESSION:DISPLAY-TYPE = "GUI" */
/*J2ZM*/             else do:
                        {mfaddisp.i so_ship ship_to}
/*J2ZM*/             end. /* SESSION:DISPLAY-TYPE = "CHUI" */
                  end.
               end. /* prompt-for so_ship */

                     assign
                        so_ship = input so_ship.

/*J2ZM*/       if session:display-type = "GUI" then do:
/*J2ZM*/          if not global-tool-bar then do:
/*J2ZM*/             {mfaddisp.i so_ship ship_to1 "row 2.6"}
/*J2ZM*/          end. /* NOT GLOBAL-TOOL-BAR */
/*J2ZM*/          else do:
/*J2ZM*/             {mfaddisp.i so_ship ship_to2 "row 4"}
/*J2ZM*/          end. /* GLOBAL-TOOL-BAR */
/*J2ZM*/       end. /* SESSION:DISPLAY-TYPE = "GUI" */
/*J2ZM*/       else do:
/*F678*/          {mfaddisp.i so_ship ship_to}
/*J2ZM*/       end.

/*M0LN*/       /* ENTERED SHIP-TO MUST BE A VALID CUSTOMER,SHIP-TO OR DOCK */
/*M0LN*/       if available ad_mstr      and
/*M0LN*/          ad_type <> "customer" then
/*M0LN*/       do:
/*M0LN*/          if ad_ref = so_cust then
/*M0LN*/          do:
/*M0LN*/             for first ls_mstr
/*M0LN*/                fields (ls_addr ls_type)
/*M0LN*/                where ls_addr = input so_ship
/*M0LN*/                and  (ls_type = "customer" or
/*M0LN*/                      ls_type = "ship-to"  or
/*M0LN*/                      ls_type = "dock") no-lock:
/*M0LN*/             end. /* FOR FIRST LS_MSTR */

/*M0LN*/             if not available ls_mstr
/*M0LN*/             then do:

/*M0LN*/                /* SHIP-TO DOES NOT EXIST DO YOU WISH TO ADD */
/*M0LN*/                {mfmsg01.i 301 1 yn }
/*M0LN*/                if yn then do:
/*M0LN*/                   create ls_mstr.
/*M0LN*/                   run p_ls_update .
/*M0LN*/                end. /* IF YN THEN */
/*M0LN*/                else do:
/*M0LN*/                   next-prompt so_ship with frame a.
/*M0LN*/                   undo, retry.
/*M0LN*/                end. /* ELSE DO */

/*M0LN*/             end.  /* IF NOT AVAILABLE LS_MSTR */

/*M0LN*/          end. /* IF AD_REF = SO_CUST */

/*M0LN*/          if ad_ref <> so_cust and
/*M0LN*/             so_cust <> so_ship
/*M0LN*/          then do:
/*M0LN*/             for first ls_mstr
/*M0LN*/                fields (ls_addr ls_type)
/*M0LN*/                where ls_addr = input so_ship
/*M0LN*/                and  (ls_type = "customer" or
/*M0LN*/                      ls_type = "ship-to"  or
/*M0LN*/                      ls_type = "dock" ) no-lock:
/*M0LN*/             end. /* FOR FIRST LS_MSTR */
/*M0LN*/             if not available ls_mstr
/*M0LN*/             then do:
/*M0LN*/                /* END USER DOES NOT BELONG TO THIS CUSTOMER */
/*M0LN*/                {mfmsg.i 7301 3}
/*M0LN*/                undo, retry.
/*M0LN*/             end. /* IF NOT AVAILABLE LS_MSTR */
/*M0LN*/          end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF AD_REF <> SO_CUST */

/*M0LN*/       end. /* IF AVAILABLE AD_MSTR */

               if not available ad_mstr then do:

                  {mfmsg01.i 301 1 yn} /* Ship-To does not exist, add? */

                  if yn then do:
/*F698*/             ship2_addr   = so_ship.
/*F698*/             ship2_lang   = cm_mstr.cm_lang.
/*F698*/             ship2_pst_id = cm_mstr.cm_pst_id.
/*F698*/             ship2_ref    = cm_mstr.cm_addr.
/*F698*/             {gprun.i ""sosost.p""}
/*GUI*/ if global-beam-me-up then undo, leave.
  /* Add Ship To */
/*FM85*/             find ad_mstr where recid(ad_mstr) = ad_recno
/*G0KG*/                  no-lock no-error.
/*G0KG*/             if available ad_mstr then do:
/*GH40*/                if so_ship = "" then so_ship = ad_addr.

/*J2ZM*/                if session:display-type = "GUI":U then do:
/*J2ZM*/                   if not global-tool-bar then
/*J2ZM*/                      hide frame ship_to1.
/*J2ZM*/                   else
/*J2ZM*/                      hide frame ship_to2.
/*J2ZM*/                end. /* SESSION:DISPLAY-TYPE = "GUI" */
/*J2ZM*/                view frame ship_to.

/*F349*/                      display
                                 ad_name
                                 ad_line1
                                 ad_line2
                                 ad_city
                                 ad_state
                                 ad_zip
                                 ad_country
                              with frame ship_to.

/*FM85*                       ad_sort = ad_name. **/

/*G0KG*/                   end. /* if available ad_mstr */

/*G0KG*/             else do:
/*G0KG*/                next-prompt so_ship with frame a.
/*G0KG*/                     undo, retry.
/*G0KG*/             end.

                  end. /* if yn then do */

                  if not available ad_mstr
                  or ad_ref <> cm_mstr.cm_addr
                  then do:
                     {mfmsg.i 3 3}
                     next-prompt so_ship with frame a.
                     undo, retry.
                  end.

               end.

               /* DO NOT ALLOW CHANGE OF SHIP-TO AT THE SBU */
/*K0HB*/       if prev-ship-to <> so_ship and not new_order
/*K0HB*/       and soc_use_btb and so_secondary then do:
/*K0HB*/          {mfmsg.i 2825 3} /* No Change is allowed on
                                    * EMT order */
/*K0HB*/          next-prompt so_ship with frame a.
/*K0HB*/          undo, retry.
/*K0HB*/       end.

/*M11Z*/ /**************************************************
 *                    /* VALIDATE CHANGE OF SHIP-TO RELATED TO
 *                     * DIRECT DELIVERY LINES*/
 *                    if prev-ship-to <> so_ship and not new_order
 * /*K0DH*              and soc_use_btb and so_primary             */
 * /*K0DH*/             and soc_use_btb and not so_secondary
 *                    then do:
 *
 *                       for each sod_det where sod_nbr = so_nbr no-lock:
 *
 *                          /* ONLY PROCEED WITH THIS LINE IF DIRECT DELIVERY */
 *                          if sod_btb_type <> "03" then next.
 *
 *                          s-create-pod-line = no.
 *
 *                          /* TRANSMIT CHANGES ON PRIM. SO TO PO AND SEC. SO */
 * /*K0HB*                       ADD input yes before output return-msg  */
 *                          {gprun.i ""sosobtb1.p""
 *                             "(input recid(sod_det),
 *                               input no,
 *                               input ""?"",
 *                               input so_ship,
 *                               input 0,
 *                               input ?,
 *                               input ?,
 *                               input ""?"",
 *                               input yes,
 *                               output return-msg)" }
 *
 *                          /* DISPLAY ERROR MESSAGE RETURN FROM SOSOBTB1.P */
 *                          if return-msg <> 0 then do:
 *                             {mfmsg.i return-msg 3}
 *                             return-msg = 0.
 *                             next-prompt so_ship with frame a.
 *                             undo, retry.
 *                          end.
 *
 *                       end. /* for each sod_det */
 *
 *                    end.  /* validate change of ship-to on dir.del. lines */
 *****************************/ /*M11Z*/

/*K004*/    /* end added section */

/*FT20*/       if so_ship <> so_cust and ad_ref <> so_cust then do:
/*FT20*/          {mfmsg.i 606 2}  /* Ship-to is not for this customer */
/*FT20*/       end.

            end.  /* ship-to input */

/*FO48*/ end. /* if not so_sched */
/*FO48*/ else do:

/*M0XC*/    if session:display-type = "GUI":U
/*M0XC*/    then do:
/*M0XC*/       if not global-tool-bar
/*M0XC*/       then do:
/*M0XC*/          {mfaddisp.i so_ship ship_to1 "row 2.6"}
/*M0XC*/       end. /* NOT GLOBAL-TOOL-BAR */
/*M0XC*/       else do:
/*M0XC*/          {mfaddisp.i so_ship ship_to2 "row 4"}
/*M0XC*/       end. /* GLOBAL-TOOL-BAR */
/*M0XC*/    end. /* SESSION:DISPLAY-TYPE = "GUI" */
/*M0XC*/    else do:
/*FO48*/      {mfaddisp.i so_ship ship_to}
/*M0XC*/    end. /* SESSION:DISPLAY-TYPE = "CHUI" */

/*FO48*/ end.

/*K07S*/ if enduser-ok then
           undo_cust = false.
/*K07S*/ else
            undo, retry.

/*J2ZM*/    clear frame bill_to1 no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame bill_to1 = F-bill_to1-title.
/*J2ZM*/    clear frame bill_to2 no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame bill_to2 = F-bill_to2-title.
/*J2ZM*/    clear frame enduser1 no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame enduser1 = F-enduser1-title.
/*J2ZM*/    clear frame enduser2 no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame enduser2 = F-enduser2-title.

/*J2ZM*/    hide frame bill_to1.
/*J2ZM*/    hide frame bill_to2.
/*J2ZM*/    hide frame enduser1.
/*J2ZM*/    hide frame enduser2.

      end.  /* do transaction */

/*M0LN*/ procedure p_ls_update:
/*M0LN*/    assign
/*M0LN*/       ls_mstr.ls_addr = ad_mstr.ad_addr
/*M0LN*/       ls_mstr.ls_type = "ship-to".
/*M0LN*/    {mgqqapp.i "ls_app_owner"}
/*M0LN*/    if recid (ls_mstr) = -1 then.
/*M0LN*/ end. /* PROCEDURE LS_UPDATE */
