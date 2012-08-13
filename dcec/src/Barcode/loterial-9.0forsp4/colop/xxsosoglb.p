/* xxsosoglb.p - SALES ORDER LINE GLTRANS WORKFILE POST                        */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.50.1.1 $                                                         */
/* REVISION: 1.0      LAST MODIFIED: 03/11/86   BY: PML                      */
/* REVISION: 6.0      LAST MODIFIED: 10/05/90   BY: MLB *D075*               */
/* REVISION: 6.0      LAST MODIFIED: 11/14/90   BY: MLB *D209*               */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: afs *D387*               */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: MLB *D360*               */
/* REVISION: 6.0      LAST MODIFIED: 04/04/91   BY: afs *D478*               */
/* REVISION: 6.0      LAST MODIFIED: 04/09/91   BY: afs *D516*               */
/* REVISION: 6.0      LAST MODIFIED: 05/08/91   BY: afs *D628*               */
/* REVISION: 6.0      LAST MODIFIED: 10/09/91   BY: dgh *D892*               */
/* REVISION: 7.0      LAST MODIFIED: 10/14/91   BY: jjs *F016*               */
/* REVISION: 6.0      LAST MODIFIED: 02/11/92   BY: mlv *F199*               */
/* REVISION: 7.0      LAST MODIFIED: 02/19/92   BY: MLV *F200*               */
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: afs *F356*               */
/* REVISION: 7.3      LAST MODIFIED: 09/06/92   BY: afs *G047*               */
/* REVISION: 7.4      LAST MODIFIED: 07/13/93   BY: jjs *H050*               */
/* REVISION: 7.4      LAST MODIFIED: 02/24/94   BY: pcd *FM42*               */
/* REVISION: 7.4      LAST MODIFIED: 04/13/94   BY: bcm *H338*               */
/* REVISION: 8.5      LAST MODIFIED: 02/28/95   BY: tjm *J042*               */
/* REVISION: 7.4      LAST MODIFIED: 03/13/95   BY: jxz *F0M3*               */
/* REVISION: 7.5      LAST MODIFIED: 07/17/95   BY: DAH *J05M*               */
/* REVISION: 8.5      LAST MODIFIED: 07/31/95   BY: taf *J053*               */
/* REVISION: 8.5      LAST MODIFIED: 03/19/96   BY: DAH *J0FS*               */
/* REVISION: 8.6      LAST MODIFIED: 07/18/96   BY: BJL *K001*               */
/*                                    (split sosoglb1.p off)                 */
/* REVISION: 8.5      LAST MODIFIED: 07/26/96   BY: dxk *G1YS*               */
/* REVISION: 8.6      LAST MODIFIED: 11/25/96   BY: jzw *K01X*               */
/*                                   02/17/97   BY: *K01R* E. Hughart        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* Old ECO marker removed, but no ECO header exists *J0KJ*                  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* REVISION: 8.6E     LAST MODIFIED: 06/25/98   BY: *L034* Markus Barone    */
/* REVISION: 8.6E     LAST MODIFIED: 07/15/98   BY: *L024* Steve Goeke      */
/* REVISION: 8.6E     LAST MODIFIED: 09/01/98   BY: *L069* Jeff Wootton     */
/* REVISION: 9.0      LAST MODIFIED: 10/01/98   BY: *J2CZ* Reetu Kapoor     */
/* REVISION: 9.0      LAST MODIFIED: 11/17/98   BY: *J31D* Poonam Bahl      */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 06/06/99   BY: *N00D* Adam Harris      */
/* REVISION: 9.1      LAST MODIFIED: 08/20/99   BY: *J3KS* Anup Pereira     */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari  */
/* REVISION: 9.1      LAST MODIFIED: 10/07/99   BY: *J3L7* Satish Chavan    */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Luke Pokic       */
/* REVISION: 9.1      LAST MODIFIED: 06/12/00   BY: *M0NK* Ashwini Ghaisas  */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *N0RF* Mark Brown       */
/* REVISION: 9.1      LAST MODIFIED: 09/26/00   BY: *K264* Manish K.        */
/* REVISION: 9.1      LAST MODIFIED: 01/02/01   BY: *J3Q3* Ashwini G.       */
/* REVISION: 9.1      LAST MODIFIED: 10/14/00   BY: *N0WB* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 02/13/01   BY: *N0WV* Sandeep P.       */
/* REVISION: 9.1      LAST MODIFIED: 03/07/01   BY: *N0X8* Rajesh Thomas    */
/* Revision: 1.38     BY: Katie Hilbert       DATE: 04/01/01   ECO: *P002*  */
/* Revision: 1.38     BY: Kirti Desai         DATE: 04/05/01   ECO: *M13M*  */
/* Revision: 1.40     BY: Nikita Joshi        DATE: 05/25/01   ECO: *L18Q*  */
/* Revision: 1.41     BY: Ed van de Gevel     DATE: 12/03/01   ECO: *N16R*  */
/* Revision: 1.42     BY: Jeff Wootton        DATE: 03/12/02   ECO: *P020*  */
/* Revision: 1.43     BY: Ed van de Gevel     DATE: 04/16/02   ECO: *N1GP*  */
/* Revision: 1.44     BY: Paul Donnelly       DATE: 12/13/01   ECO: *N16J*  */
/* Revision: 1.45     BY: Manjusha Inglay     DATE: 08/19/02   ECO: *N1QP*  */
/* Revision: 1.46     BY: Katie Hilbert       DATE: 12/31/02   ECO: *P0LM*  */
/* Revision: 1.47     BY: Rafal Krzyminski    DATE: 01/17/03   ECO: *P0LX*  */
/* Revision: 1.48     BY: Subramanian Iyer    DATE: 02/03/03   ECO: *N23Q*  */
/* Revision: 1.49     BY: Shoma Salgaonkar    DATE: 03/26/03   ECO: *N28N*  */
/* Revision: 1.50     BY: Anup Pereira        DATE: 05/06/03   ECO: *P0RB*  */
/* $Revision: 1.50.1.1 $  BY: Gnanasekar         DATE: 08/18/03   ECO: *P0ZW*  */

/*V8:ConvertMode=Maintenance                                                 */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i}
{cxcustom.i "SOSOGLB.P"}

{gldydef.i}
{gldynrm.i}

{gprunpdf.i "nrm" "p"}

define input-output parameter l_so_gl_line    like glt_line    no-undo.
define input-output parameter l_so_gltw_line  like gltw_line   no-undo.
define input-output parameter l_tot_amt       like glt_amt     no-undo.
define input-output parameter l_tot_ramt      like glt_amt     no-undo.
define input        parameter p_last_line     like mfc_logical no-undo.

define new shared variable line_entity     like ar_entity.

define shared variable rndmthd             like rnd_rnd_mthd.
define shared variable so_recno            as recid.
define shared variable sod_recno           as recid.
define shared variable ext_price           like sod_price.
define shared variable undo_all            like mfc_logical no-undo.
define shared variable eff_date            as date.
define shared variable gl_sum              like mfc_logical.
define shared variable exch_rate           like exr_rate.
define shared variable exch_rate2          like exr_rate2.
define shared variable exch_ratetype       like exr_ratetype.
define shared variable exch_exru_seq       like exru_seq.
define shared variable ext_list            like sod_list_pr.
define shared variable ext_disc            as decimal.
define shared variable ref                 like glt_det.glt_ref.
define shared variable batch               like ar_batch.
define shared variable post                like mfc_logical.
define shared variable ord_amt             like glt_amt.
define shared variable tot_curr_amt        like glt_amt.
define shared variable curr_amt            like glt_amt.
define shared variable already_posted      like glt_amt.
define shared variable should_be_posted    like glt_amt.
define shared variable post_entity         like ar_entity.
define shared variable auto_balance_amount like glt_amt no-undo.

define variable glamt                    like glt_amt.
define variable gltline                  like glt_line    no-undo.
define variable l_gltline2               like glt_line    no-undo.
define variable glsdscamt                like glamt       no-undo.
define variable taxes_included           like ap_amt      no-undo.
define variable last_disc_amt            as decimal       no-undo.
define variable man_pih_recid            as recid         no-undo.
define variable man_disc_exists          like mfc_logical initial no no-undo.
define variable l_tax_rate               like tx2_tax_pct no-undo.
/* FOR glt_desc INSTEAD OF "" */
define variable gen_desc                 like glt_desc.
define variable gen_desc_posted_invoice  like glt_desc    no-undo.
define variable gen_desc_accrued_revenue like glt_desc    no-undo.
define variable mc-error-number          like msg_nbr     no-undo.
define variable been-posted              like mfc_logical no-undo.
define variable l_ext_disc               like ext_disc    no-undo.
define variable l_glamt                  like glamt       no-undo.
{&SOSOGLB-P-TAG1}

assign
   gen_desc_posted_invoice  = getTermLabel("POSTED_INVOICE",24)
   gen_desc_accrued_revenue = getTermLabel("ACCRUED_REVENUE",24)
   gen_desc                 = gen_desc_posted_invoice.

do transaction on error undo, leave:

   if post then
      find sod_det where recid(sod_det) = sod_recno
      exclusive-lock no-error.
   else
      for first sod_det
         fields(sod_acct sod_cc sod_dsc_acct sod_dsc_cc
                sod_dsc_project sod_dsc_sub sod_fsm_type
                sod_line sod_nbr sod_project sod_qty_inv
                sod_site sod_sub sod_taxc)
         where recid(sod_det) = sod_recno no-lock:
      end. /* FOR FIRST SOD_DET */

   for first so_mstr
      fields(so_cr_terms so_curr so_cust so_exru_seq so_ex_rate
             so_ex_rate2 so_ex_ratetype so_inv_nbr so_nbr so_sched
             so_fsaccr_acct so_fsaccr_sub so_fsaccr_cc
             so_fsdef_acct so_fsdef_sub so_fsdef_cc
             so_revenue so_site)
      where recid(so_mstr) = so_recno no-lock:
   end.
   {&SOSOGLB-P-TAG10}

   for first svc_ctrl
      fields(svc_per_bill svc_prorate)
   no-lock:
   end.
   for first sac_ctrl
      fields(sac_sa_pre)
   no-lock:
   end.

   /* If for any reason the invoice number is blank then LEAVE.
      This causes UNDO_ALL to be set TRUE and the SO posting
      is rolled back. */

   if post and so_inv_nbr = "" then undo, leave.

   for first gl_ctrl
      fields(gl_rnd_mthd gl_sls_acct gl_sls_sub gl_sls_cc)
   no-lock: end.

   if not can-find(first arc_ctrl) then do:
      create arc_ctrl.
      if recid(arc_ctrl) = ? then .
   end. /* if not can-find(first acrc_ctrl) */

   if not available arc_ctrl then
      for first arc_ctrl
         fields(arc_sum_lvl) no-lock:
      end.

   if so_sched then
      assign
         ext_disc = if ext_list = 0 then 0 else ext_disc
         ext_list = if ext_list = 0 then ext_price else ext_list.

   if ext_list <> 0 then do:

      assign
         l_tax_rate     = 0
         taxes_included = 0.

      /* ACCUMULATE ANY INCLUDED TAXES */
      for each tx2d_det
         fields(tx2d_cur_tax_amt tx2d_line tx2d_nbr tx2d_ref
                tx2d_tax_code tx2d_tax_amt tx2d_tax_in tx2d_tr_type)
         where tx2d_ref = (if post then so_inv_nbr else so_nbr) and
               tx2d_nbr = (if post then so_nbr else '')         and
               tx2d_tr_type = (if post then '16' else '13')     and
               tx2d_line = sod_line
      no-lock:
         if tx2d_tax_in then
            taxes_included = taxes_included + tx2d_cur_tax_amt.

         if taxes_included <> 0
         then do:
            for first tx2_mstr
               fields( tx2_tax_code tx2_tax_pct )
               where tx2_tax_code = tx2d_tax_code
            no-lock:
               l_tax_rate = tx2_tax_pct.
            end. /* FOR FIRST tx2_mstr */
         end. /* IF taxes_included <> 0 */

         if  taxes_included <> 0
            and l_tax_rate <> 0
         then
            assign
               glamt    = - ext_list * 100 / (100 + l_tax_rate)
               curr_amt = glamt.

      end.

      if taxes_included = 0
      then do:

         /*CREDIT SALES BY THE LIST PRICE*/
         assign
            glamt    = - ext_list + taxes_included
            curr_amt = - ext_list + taxes_included.

      end. /* IF taxes_included = 0 */

      l_glamt = glamt.

      run roundAmount
         (input-output l_glamt,
          input rndmthd).
      run roundAmount
         (input-output curr_amt,
          input rndmthd).

      {gpcurcnv.i &glamt=glamt}

      assign
         l_tot_amt  = l_tot_amt  + curr_amt
         l_tot_ramt = l_tot_ramt + glamt.

      if post
      then do:
         if sod_acct = "" and sod_sub = "" and sod_cc = ""  then
            assign
               sod_acct = gl_sls_acct
               sod_sub  = gl_sls_sub
               sod_cc   = gl_sls_cc.
      end. /* IF POST THEN DO */

      been-posted = no.
      if so_fsm_type = "PRM" then do:
         /* POSTING ROUTINE */

         /* ADDED SIXTH INPUT PARAMETER p_last_line TO ACCOMODATE THE   */
         /* LOGIC INTRODUCED IN gpcurcnv.i FOR HANDLING ROUNDING ISSUES */

         {gprunmo.i
            &module="PRM"
            &program="pjsoglb.p"
            &param="""(input gen_desc_posted_invoice,
                       input-output glamt,
                       input-output glsdscamt,
                       input-output gltline,
                       input-output l_gltline2,
                       input        p_last_line)"""}
         been-posted = yes.
      end. /* IF SO_FSM_TYPE = "PRM" */

      /* GET THE POSTING ENTITY BASED ON THE SALES ORDER LINE SITE */
      if sod_site <> so_site then do:

         for first si_mstr
            fields(si_entity si_site)
            where si_site = sod_site no-lock:
         end.
         if available si_mstr then
            line_entity = si_entity.
         else
            line_entity = glentity.
      end.
      else
         line_entity = post_entity.
      {&SOSOGLB-P-TAG9}

      if not been-posted then do:
         /* IF POST AND NOT JUST REPORT CREATE GLT_DET RECORDS */
         if post then do:

            /* IF CONTRACT IS DEFERRED AND BILLING PERRIOD IS NOT       */
            /* MONTHLY AND IT IS NOT ADDITIONAL CHARGES LINE ON CONTRACT*/
            if so_revenue   = "2"
               and sod_fsm_type = "SC"
            then
               run deferContract.
            else
            if so_revenue    = "3"
               and sod_fsm_type = "SC"
            then
               run accruedContract.
            else do:
               run postGLAmount
                  (input sod_acct,
                   input sod_sub,
                   input sod_cc,
                   input sod_project,
                   input glamt,
                   input curr_amt).
               /* SAVE LINE NUMBER OF LAST SOD_ACCT GLT_DET POSTING */
               l_so_gl_line = l_gltline2.
            end. /* if so_revenue not 2 and 3 */

         end. /* if post */

         /* IF CONTRACT IS DEFERRED AND BILLING PERRIOD IS NOT MONTHLY */
         /* AND IT IS NOT ADDITIONAL CHARGES LINE ON CONTRACT          */
         if so_revenue   = "2"
            and sod_fsm_type = "SC"
         then do:
            if not post
            then
               run deferContract.
         end.
         else
         /* IF CONTRACT IS ACCRUED, AND NOT RUNNING AS "POST",  */
         /* RUN BALANCE ROUTINE TO CREATE GL WORK RECORDS ONLY. */
         if so_revenue    = "3"
            and sod_fsm_type = "SC"
         then do:
            if not post
            then
               run accruedContract.
         end.
         else do:
            run createGLWorkAmount
               (input sod_acct,
                input sod_sub,
                input sod_cc,
                input sod_project,
                input glamt,
                input curr_amt).
            /* SAVE LINE NUMBER OF LAST SOD_ACCT GLTW_WKFL POSTING */
            l_so_gltw_line = return_int.
         end.

         /* IF THE LINE ENTITY IS NOT THE SAME AS THE HEADER ENTITY,*/
         /* THEN WE HAVE TO MAKE POSTINGS TO THE INTERCOMPANY ACCT  */
         /* IN EACH DATABASE TO KEEP THE ENTITIES IN BALANCE.       */
         if line_entity <> post_entity then do:

            {&SOSOGLB-P-TAG11}
            {gprun.i ""sosoglb1.p""
               "(input sod_project,
                 input glamt,
                 input gen_desc_posted_invoice)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            {&SOSOGLB-P-TAG12}
         end.  /* Intercompany postings for order total */
      end.  /* IF NOT BEEN-POSTED */
   end.  /* if ext_list <> 0 */

   /* POST THE DISCOUNT AMOUNT */

   /* CONSIDERING PRICE LIST RECORDS (PIH_HIST) INDIVIDUALLY */
   /* FOR CREATION OF GL RECORDS INSTEAD OF OVERALL DISCOUNT */
   /* (EXT_DISC)                                             */

   l_ext_disc = ext_disc.

   if not so_sched and (sod_fsm_type = "" or sod_fsm_type = "RMA-ISS")
   then do:
      /* Discount source is from pih_hist */

      if  taxes_included <> 0
         and l_tax_rate <> 0
      then do:
         ext_disc = ext_disc * 100 / (100 + l_tax_rate).

         run roundAmount
            (input-output ext_disc,
             input rndmthd).

      end. /* IF taxes_included <> 0 and ... */

      assign
         last_disc_amt   = ext_disc
         man_disc_exists = no.

      /* FIND MANUAL DISCOUNT RECORD AT THE PARENT LEVEL */
      /* IF AVAILABLE, SET RECID FOR FURTHER PROCESSING. */

      for first pih_hist
         fields(pih_amt_type pih_comb_type pih_disc_acct
                pih_disc_sub pih_disc_cc pih_disc_amt
                pih_disc_proj pih_disc_seq pih_doc_type pih_feature
                pih_line pih_nbr pih_option pih_parent pih_source)
         where  pih_doc_type = 1    and pih_nbr      = sod_nbr
           and  pih_line = sod_line and pih_parent   = ""
           and  pih_feature  = ""   and pih_option   = ""
           and  pih_source   = "1"  and pih_amt_type = "2" no-lock:
      end.

      if available pih_hist then
         assign
            man_pih_recid   = recid(pih_hist)
            man_disc_exists = yes.

      /* GET DISCOUNT AMOUNT ONLY IF THE EXTENDED LIST PRICE IS NON ZERO */
      if ext_list <> 0
      then do:

         /* POST MULTIPLE DISCOUNTS */
         for each pih_hist
            fields(pih_amt_type pih_comb_type pih_disc_acct pih_disc_amt
                   pih_disc_sub pih_disc_cc pih_disc_proj pih_disc_seq
                   pih_doc_type pih_feature pih_line pih_nbr pih_option
                   pih_parent pih_source)
               where  pih_doc_type = 1
                 and  pih_nbr      = sod_nbr
                 and  pih_line     = sod_line
                 and  lookup(pih_amt_type, "2,3,4,9") <> 0
                 and  pih_disc_amt <> 0
                 and  ((pih_source = "0") or
                       (pih_source <> "0" and
                        pih_option <> ""))
            no-lock
            break by pih_parent
                  by pih_feature
                  by pih_option
                  by pih_comb_type
                  by pih_disc_seq:
/*GUI*/ if global-beam-me-up then undo, leave.


            /*DEBIT SALES DISC */

            if not last(pih_disc_seq) then do:

               /* INTERNAL PROCEDURE p-config-disc-amt CALCULATES DISCOUNT  */
               /* AMOUNT CONSIDERING CONFIGURATION BILL QUANTITY            */

               /* CALCULATE DISCOUNT AMOUNT */
               run p-config-disc-amt.

            end.
            else do:
               /* LAST RECORD WILL RESOLVE ANY VARIANCE DUE */
               /* ROUNDING, BY USING THE REMAINING DISCOUNT */
               /* TO POST (last_disc_amt).                  */
               /* IF A PARENT LEVEL MANUAL DISCOUNT EXISTS  */
               /* THEN APPLY REMAINING DISCOUNT BY USING THE*/
               /* SAVED RECID (man_pih_recid) IN LOCATING   */
               /* THE CORRECT pih_hist RECORD.              */
               if not man_disc_exists then
                  glsdscamt = last_disc_amt.
               else
                  /* CALCULATE DISCOUNT AMOUNT */
                  run p-config-disc-amt.

            end.

            /* CREATING GL RECORD ONLY IF GLSDSCAMT <> 0 */
            if glsdscamt <> 0
            then do:

               curr_amt  = glsdscamt.
               {gpcurcnv.i &glamt=glsdscamt}

               assign
                  l_tot_amt  = l_tot_amt  + curr_amt
                  l_tot_ramt = l_tot_ramt + glsdscamt.
               {&SOSOGLB-P-TAG2}
               if post
               then do:
                  if sod_dsc_acct = "" then
                     assign
                        sod_dsc_acct = sod_acct
                        sod_dsc_sub = if sod_dsc_sub = ""
                                      then sod_sub else sod_dsc_sub
                        sod_dsc_cc  = if sod_dsc_cc = ""
                                      then sod_cc else sod_dsc_cc.
               end. /* IF POST THEN DO */
               {&SOSOGLB-P-TAG3}

               /* CREATE DETAIL RECORDS */
               if post then
                  run postGLAmount
                     (input pih_disc_acct,
                      input pih_disc_sub,
                      input pih_disc_cc,
                      input pih_disc_proj,
                      input glsdscamt,
                      input curr_amt).

               run createGLWorkAmount
                  (input pih_disc_acct,
                   input pih_disc_sub,
                   input pih_disc_cc,
                   input pih_disc_proj,
                   input glsdscamt,
                   input curr_amt).

               /* IF THE LINE ENTITY IS NOT THE SAME AS THE HEADER ENTITY,  */
               /* THEN WE HAVE TO MAKE POSTINGS TO THE INTERCOMPANY ACCOUNT */
               /* IN EACH DATABASE TO KEEP THE ENTITIES IN BALANCE.         */
               if line_entity <> post_entity then do:

                  {&SOSOGLB-P-TAG13}
                  {gprun.i ""sosoglb1.p""
                     "(input pih_disc_proj,
                       input glsdscamt,
                       input gen_desc_posted_invoice)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  {&SOSOGLB-P-TAG14}

               end.  /* Intercompany postings for discount amount*/
            end. /* IF GLSDSCAMT <> 0 */
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH pih_hist */
      end. /* IF ext_list <> 0 */

      if man_disc_exists then do:
         /*USE THE MANUAL DISCOUNT RECORD AT THE PARENT LEVEL*/
         /*TO ABSORB ANY VARIANCE DUE TO ROUNDING BY USING   */
         /*THE REMAINING DISCOUNT TO POST (last_disc_amt).   */

         for first pih_hist
            fields(pih_amt_type pih_comb_type pih_disc_acct pih_disc_amt
                   pih_disc_sub pih_disc_cc pih_disc_proj pih_disc_seq
                   pih_doc_type pih_feature pih_line pih_nbr pih_option
                   pih_parent pih_source)
            where recid(pih_hist) = man_pih_recid no-lock:
         end.
         if available pih_hist then do:
            assign
               glsdscamt = last_disc_amt
               curr_amt  = glsdscamt.
            {gpcurcnv.i &glamt=glsdscamt}

            assign
               l_tot_amt  = l_tot_amt  + curr_amt
               l_tot_ramt = l_tot_ramt + glsdscamt.

            /* CREATING GL RECORD ONLY IF GLSDSCAMT <> 0 */
            if glsdscamt <> 0
            then do:
               {&SOSOGLB-P-TAG4}
               if post
               then do:
                  if sod_dsc_acct = "" then
                     assign
                        sod_dsc_sub  = if sod_dsc_sub = "" then sod_sub
                                       else sod_dsc_sub
                        sod_dsc_acct = sod_acct
                        sod_dsc_cc   = if sod_dsc_cc = "" then sod_cc
                                       else sod_dsc_cc.

               end. /* IF POST THEN DO */

               {&SOSOGLB-P-TAG5}
               /* CREATE DETAIL RECORDS */
               if post then
                  run postGLAmount
                     (input pih_disc_acct,
                      input pih_disc_sub,
                      input pih_disc_cc,
                      input pih_disc_proj,
                      input glsdscamt,
                      input curr_amt).

               run createGLWorkAmount
                  (input pih_disc_acct,
                   input pih_disc_sub,
                   input pih_disc_cc,
                   input pih_disc_proj,
                   input glsdscamt,
                   input curr_amt).

               /* IF THE LINE ENTITY IS NOT THE SAME AS THE HEADER ENTITY,  */
               /* THEN WE HAVE TO MAKE POSTINGS TO THE INTERCOMPANY ACCOUNT */
               /* IN EACH DATABASE TO KEEP THE ENTITIES IN BALANCE.         */
               if line_entity <> post_entity then do:

                  {&SOSOGLB-P-TAG15}
                  {gprun.i ""sosoglb1.p""
                     "(input pih_disc_proj,
                       input glsdscamt,
                       input gen_desc_posted_invoice)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  {&SOSOGLB-P-TAG16}

               end.  /* Intercompany postings for discount amount*/
            end. /* IF GLSDSCAMT <> 0 */
         end. /* if available pih_hist */
      end. /* if man_disc_exists */

   end. /* if not so_sched and so_fsm_type = "" */

   else do:      /* Discount is from sod_det */

      if  taxes_included <> 0
         and l_tax_rate <> 0
      then do:
         ext_disc = ext_disc * 100 / (100 + l_tax_rate).

         run roundAmount
            (input-output ext_disc,
             input rndmthd).

      end. /* IF taxes_included <> 0 and ... */

      assign
         glsdscamt = ext_disc
         curr_amt  = ext_disc.
      {gpcurcnv.i &glamt=glsdscamt}

      assign
         l_tot_amt  = l_tot_amt  + curr_amt
         l_tot_ramt = l_tot_ramt + glsdscamt.

      /* CREATING GL RECORD ONLY IF GLSDSCAMT <> 0 */
      if glsdscamt <> 0
      then do:
         {&SOSOGLB-P-TAG6}
         if post
         then do:
            if sod_dsc_acct = "" then
               assign
                  sod_dsc_sub = if sod_dsc_sub = ""
                                then sod_sub else sod_dsc_sub
                  sod_dsc_acct = sod_acct
                  sod_dsc_cc   = if sod_dsc_cc = ""
                                 then sod_cc else sod_dsc_cc.
         end. /* IF POST THEN DO */
         {&SOSOGLB-P-TAG7}

         /* CREATE DETAIL RECORDS */
         if post then
            run postGLAmount
               (input sod_dsc_acct,
                input sod_dsc_sub,
                input sod_dsc_cc,
                input sod_dsc_project,
                input glsdscamt,
                input curr_amt).

         run createGLWorkAmount
            (input sod_dsc_acct,
             input sod_dsc_sub,
             input sod_dsc_cc,
             input sod_dsc_project,
             input glsdscamt,
             input curr_amt).

         /* IF THE LINE ENTITY IS NOT THE SAME AS THE HEADER ENTITY,  */
         /* THEN WE HAVE TO MAKE POSTINGS TO THE INTERCOMPANY ACCOUNT */
         /* IN EACH DATABASE TO KEEP THE ENTITIES IN BALANCE.         */
         if line_entity <> post_entity then do:

            {&SOSOGLB-P-TAG17}
            {gprun.i ""sosoglb1.p""
               "(input sod_project,
                 input glsdscamt,
                 input gen_desc_posted_invoice)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            {&SOSOGLB-P-TAG18}

         end.  /* Intercompany postings for discount amount*/
      end. /* IF GLSDSCAMT <> 0 */
   end. /* Discount is from sod_det */

   if ( ext_disc + l_glamt)
      <> ( - ext_list + taxes_included + l_ext_disc)
   then do:
      if ( - ext_list + taxes_included + l_ext_disc)
         >  ( ext_disc + l_glamt)
      then
         l_tot_amt = l_tot_amt +
                     (( - ext_list + taxes_included + l_ext_disc ) -
                      ( ext_disc + l_glamt)).
      else
         l_tot_amt = l_tot_amt -
                     (( ext_disc + l_glamt ) -
                      ( - ext_list + taxes_included + l_ext_disc)).
   end. /* IF (ext_disc + l_glamt) <> (- ext_list .... */

   if ext_disc <> 0 then
      if post then do:
         assign
            glsdscamt = ext_disc
            curr_amt  = ext_disc.

         {gpcurcnv.i &glamt = glsdscamt}

      end. /* if post */

   /* POST MULTIPLE ACCRUALS */

   if not so_sched and (sod_fsm_type = "" or
      sod_fsm_type = "RMA-ISS")
   then do:
      {&SOSOGLB-P-TAG19}

      /* ADDED THE INPUT PARAMETER p_last_line TO ACCOMODATE THE     */
      /* LOGIC INTRODUCED IN gpcurcnv.i FOR HANDLING ROUNDING ISSUES */

      {gprun.i ""soglaccr.p""
         "(input p_last_line)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      {&SOSOGLB-P-TAG20}
   end.

   return.

end.
undo_all = yes. /* ERROR */

PROCEDURE p-config-disc-amt:
   /* TO CALCULATE DISCOUNT AMOUNT CONSIDERING  */
   /* CONFIGURATION BILL QUANTITY               */

   glsdscamt = sod_det.sod_qty_inv * pih_hist.pih_disc_amt.

   for first sob_det
      fields(sob_nbr sob_line sob_parent sob_feature
             sob_part sob_qty_req)
      where
      sob_nbr     = sod_det.sod_nbr      and
      sob_line    = sod_det.sod_line     and
      sob_parent  = pih_hist.pih_parent  and
      sob_feature = pih_hist.pih_feature and
      sob_part    = pih_hist.pih_option
   no-lock:
      glsdscamt = glsdscamt * sob_qty_req.
   end. /* FOR FIRST sob_det */

   run roundAmount
      (input-output glsdscamt,
       input rndmthd).

   last_disc_amt = last_disc_amt - glsdscamt.
END PROCEDURE. /* p-config-disc-amt */

PROCEDURE deferContract:

   /* VARIABLES TO ALLOCATE AMOUNTS TO CONTRACT LINES */
   define variable total_ext_price as decimal no-undo.
   define variable line_amt        as decimal no-undo.
   define variable line_curr_amt   as decimal no-undo.
   define variable posted_amt      as decimal no-undo.
   define variable posted_curr_amt as decimal no-undo.

   if can-find(first sab_det
      where sab_so_nbr = sod_det.sod_nbr
      and   sab_sod_line = sod_det.sod_line)
   then do:
      /* SALES ORDER LINE WAS SUMMARY OF CONTRACT DETAIL LINES. */
      /* USE BILLING DETAILS TO DETERMINE EACH BILLED AMOUNT.   */

      /* ACCUMULATE TOTAL OF BILLING DETAILS */
      total_ext_price = 0.
      for each sab_det
         where sab_so_nbr = sod_det.sod_nbr
         and   sab_sod_line = sod_det.sod_line
      no-lock:
         total_ext_price = total_ext_price + sab_ext_price.
      end.

      /* PROCESS ALL BILLING DETAILS */
      for each sab_det
         where sab_so_nbr = sod_det.sod_nbr
         and   sab_sod_line = sod_det.sod_line
      no-lock
         break by sab_so_nbr
               by sab_sod_line:
         /* NEED TO CALCULATE AMOUNT FOR EACH BILLING DETAIL, */
         /* BECAUSE SALES ORDER LINE MAY HAVE INCLUDED TAX.   */
         if last-of(sab_sod_line)
         then
            /* TAKE REMAINING TOTAL OF BILLING DETAILS */
            assign
               line_amt = glamt - posted_amt
               line_curr_amt = curr_amt - posted_curr_amt.
         else do:
            /* TAKE PORTION RELATED TO THIS BILLING DETAIL */
            assign
               line_amt = glamt * sab_ext_price / total_ext_price
               line_curr_amt = curr_amt * sab_ext_price / total_ext_price.
            run roundAmount
               (input-output line_amt,
                input gl_ctrl.gl_rnd_mthd).
            run roundAmount
               (input-output line_curr_amt,
                input rndmthd).
            assign
               posted_amt = posted_amt + line_amt
               posted_curr_amt = posted_curr_amt + line_curr_amt.
         end.

         if sab_qty_per > 1
         then do:
            /* MULTIPLE MONTHS INVOLVED, DEFER INCOME */
            for first sad_det
               fields(sad_nbr sad_prefix sad_line sad_eu_nbr sad_cycle
                      sad_accrued sad_st_date sad_end_date sad_for
                      sad_qty_lst)
               where sad_nbr    = sab_nbr
               and   sad_prefix = sab_prefix
               and   sad_line   = sab_line
            no-lock:
               run deferContractDetail
                  (input line_amt,
                   input line_curr_amt).
            end.
         end.
         else do:
            /* NO MORE THAN ONE MONTH INVOLVED, POST TO GL */
            if post
            then do:
               run postGLAmount
                  (input sod_det.sod_acct,
                   input sod_det.sod_sub,
                   input sod_det.sod_cc,
                   input sod_det.sod_project,
                   input line_amt,
                   input line_curr_amt).
               /* SAVE LINE NUMBER OF LAST SOD_ACCT GLT_DET POSTING */
               l_so_gl_line = l_gltline2.
            end.
            run createGLWorkAmount
               (input sod_det.sod_acct,
                input sod_det.sod_sub,
                input sod_det.sod_cc,
                input sod_det.sod_project,
                input line_amt,
                input line_curr_amt).
            /* SAVE LINE NUMBER OF LAST SOD_ACCT GLTW_WKFL POSTING */
            l_so_gltw_line = return_int.
         end.
      end. /* for each sab_det */
   end. /* if can-find first sab_det */
   else do:
      /* SALES ORDER LINE RELATES TO ONE CONTRACT DETAIL LINE */
      for first sad_det
         fields(sad_nbr sad_prefix sad_line sad_eu_nbr sad_cycle
                sad_accrued sad_st_date sad_end_date sad_for sad_qty_lst)
         where sad_nbr    = sod_det.sod_sa_nbr
         and   sad_prefix = sac_ctrl.sac_sa_pre
         and   sad_line   = sod_det.sod_sad_line
      no-lock:
      end.
      if available sad_det
         and sad_qty_lst> 1
      then
         /* MULTIPLE MONTHS INVOLVED, DEFER INCOME */
         run deferContractDetail
            (input glamt,
            input curr_amt).
      else do:
         /* NO MORE THAN ONE MONTH INVOLVED, POST TO GL */
         if post
         then do:
            run postGLAmount
               (input sod_det.sod_acct,
               input sod_det.sod_sub,
               input sod_det.sod_cc,
               input sod_det.sod_project,
               input glamt,
               input curr_amt).
            /* SAVE LINE NUMBER OF LAST SOD_ACCT GLT_DET POSTING */
            l_so_gl_line = l_gltline2.
         end.
         run createGLWorkAmount
            (input sod_det.sod_acct,
            input sod_det.sod_sub,
            input sod_det.sod_cc,
            input sod_det.sod_project,
            input glamt,
            input curr_amt).
         /* SAVE LINE NUMBER OF LAST SOD_ACCT GLTW_WKFL POSTING */
         l_so_gltw_line = return_int.
      end.
   end. /* if not can-find first sab_det */

END PROCEDURE.

PROCEDURE deferContractDetail:

   define input parameter p_amt         as decimal no-undo.
   define input parameter p_curr_amt    as decimal no-undo.

   define variable smonth               as integer    no-undo.
   define variable syear                as integer    no-undo.
   define variable sdate                as date       no-undo.
   define variable numOfDays            as integer    no-undo.
   define variable periodSkip           as logical    no-undo.
   define variable periodToBeSkip       like sod_qty_per no-undo.
   define variable periodsToBeBilled    like sod_qty_per no-undo.
   define variable perPeriodGLAmount    like glt_amt  no-undo.
   define variable perPeriodCurrAmount  like glt_amt  no-undo.
   define variable recognizedGLAmount   like glt_amt  no-undo.
   define variable recognizedCurrAmount like glt_amt  no-undo.
   define variable deferredGLAmount     like glt_amt  no-undo.
   define variable deferredCurrAmount   like glt_amt  no-undo.

   periodToBeSkip = 0.
   for last defr_det
      fields(defr_eff_date defr_period_remain)
      where defr_nbr    = sad_det.sad_nbr
      and   defr_prefix = sad_det.sad_prefix
      and   defr_line   = sad_det.sad_line
   no-lock:
   end.
   if available defr_det then
      periodsToBeBilled = ((month(eff_date) -
                           (month(defr_eff_date) + defr_period_remain))
                        + ((year (eff_date) - year (defr_eff_date))
                        * 12)).
   else do:
      for first sa_mstr
         fields(sa_st_date sa_per_bill sa_prorate)
         where sa_nbr    = sad_det.sad_nbr
         and   sa_prefix = sad_det.sad_prefix
      no-lock:
      end.
      if available sa_mstr
      then do:
         if (not sa_per_bill or not sa_prorate)
            and sa_st_date <> sad_det.sad_st_date
         then do:
            numOfDays = sad_det.sad_st_date - sa_st_date .
            if numOfDays <= 31 then
               periodToBeSkip = 1.
            else do:
               periodToBeSkip = numOfDays modulo 31.
               if periodToBeSkip <= 31 then
                  periodToBeSkip = 1.
               periodToBeSkip = truncate( numOfDays / 31 , 0)
                              + periodToBeSkip.
            end.
            periodSkip = yes.
         end.
      end.
      periodsToBeBilled = ((month(eff_date) - month(today))
                        + ((year(eff_date) - year(today)) * 12)) + 1.
   end.

   if periodsToBeBilled <= 0 then
      periodsToBeBilled = 1.

   periodsToBeBilled = periodsToBeBilled - periodToBeSkip.

   if periodsToBeBilled < 0 then
      periodsToBeBilled = 0.

   if periodsToBeBilled > sad_det.sad_qty_lst then
      periodsToBeBilled = sad_det.sad_qty_lst.

   sdate = eff_date.

   if periodsToBeBilled > 1 then do:
      if available defr_det then
         assign
            smonth = month(defr_eff_date) + defr_period_remain
                   + periodsTobeBilled
            syear = year(defr_eff_date).
      else do:
         if periodSkip then
            assign
               smonth = month(today) + periodsTobeBilled
               syear = year(today).
         else
            assign
               smonth = month(today) + periodsTobeBilled - 1
               syear = year(today).
      end.
      if smonth > 12 then
         assign
            syear  = syear + integer(smonth / 12)
            smonth = smonth modulo 12.

      sdate = date(smonth,1,syear).
   end.

   /* If it is end of line then recognize every thing */
   if available sad_det then
      if (month(eff_date) >= month(sad_det.sad_end_date)) and
         (year (eff_date) >= year (sad_det.sad_end_date))
      then
         periodsToBeBilled = sad_det.sad_qty_lst.

   assign
      perPeriodGLAmount   = p_amt / sad_det.sad_qty_lst
      perPeriodCurrAmount = p_curr_amt / sad_det.sad_qty_lst.
   run roundAmount
      (input-output perPeriodGLAmount,
       input gl_ctrl.gl_rnd_mthd).
   run roundAmount
      (input-output perPeriodCurrAmount,
       input rndmthd).

   assign
      recognizedGLAmount    = perPeriodGLAmount * periodsToBeBilled
      recognizedCurrAmount  = perPeriodCurrAmount * periodsToBeBilled.
   run roundAmount
      (input-output recognizedGLAmount,
       input gl_rnd_mthd).
   run roundAmount
      (input-output recognizedCurrAmount,
       input rndmthd).

   assign
      deferredGLAmount    = p_amt - recognizedGLAmount
      deferredCurrAmount  = p_curr_amt - recognizedCurrAmount.

   if periodsToBeBilled <> 0 then do:
      if post
      then do:
         run postGLAmount
            (input sod_det.sod_acct,
            input sod_det.sod_sub,
            input sod_det.sod_cc,
            input sod_det.sod_project,
            input recognizedGLAmount,
            input recognizedCurrAmount).
         /* SAVE LINE NUMBER OF LAST SOD_ACCT GLT_DET POSTING */
         l_so_gl_line = l_gltline2.
      end.
      run createGLWorkAmount
         (input sod_det.sod_acct,
         input sod_det.sod_sub,
         input sod_det.sod_cc,
         input sod_det.sod_project,
         input recognizedGLAmount,
         input recognizedCurrAmount).
      /* SAVE LINE NUMBER OF LAST SOD_ACCT GLTW_WKFL POSTING */
      l_so_gltw_line = return_int.
   end.
   /* IF DEFERRED AMOUNT IS 0 THEN DON'T CREATE THE GL */
   /* TRANSACTION FOR DEFERRED ACCOUNT                 */

   if deferredGLAmount <> 0 then do:
      if post then
         run postGLAmount
            (input so_mstr.so_fsdef_acct,
             input so_mstr.so_fsdef_sub,
             input so_mstr.so_fsdef_cc,
             input "",
             input deferredGLAmount,
             input deferredCurrAmount).
      run createGLWorkAmount
         (input so_mstr.so_fsdef_acct,
          input so_mstr.so_fsdef_sub,
          input so_mstr.so_fsdef_cc,
          input "",
          input deferredGLAmount,
          input deferredCurrAmount).
   end.

   if post
   then do:
      create defr_det.
      assign
         defr_nbr             = sad_nbr
         defr_line            = sad_line
         defr_prefix          = sad_prefix
         defr_for             = sad_for
         defr_eu_nbr          = sad_eu_nbr
         defr_inv_nbr         = so_inv_nbr
         defr_sls_acct        = sod_acct
         defr_sls_sub         = sod_sub
         defr_sls_cc          = sod_cc
         defr_project         = sod_project
         defr_acct            = so_fsdef_acct
         defr_sub             = so_fsdef_sub
         defr_cc              = so_fsdef_cc
         defr_eff_date        = sdate
         defr_cust            = so_cust
         defr_ex_rate         = exch_rate
         defr_ex_rate2        = exch_rate2
         defr_exru_seq        = exch_exru_seq
         defr_ex_ratetype     = exch_ratetype
         defr_curr            = so_curr
         defr_entity          = line_entity
         defr_period_remain   = sad_qty_lst - periodsToBeBilled
         defr_period_curr_amt = - perPeriodCurrAmount
         defr_inv_amt         = - p_amt
         defr_rev_amt         = - deferredGLAmount
         defr_rec_amt         = - recognizedGLAmount
         defr_per_period_amt  = - perPeriodGLAmount
         defr_mod_date        = today
         defr_mod_userid      = global_userid
         .

      if recid(defr_det)  = -1 then .

   end.

END PROCEDURE.

PROCEDURE accruedContract:

   /* VARIABLES TO ALLOCATE AMOUNTS TO CONTRACT LINES */
   define variable total_ext_price as decimal no-undo.
   define variable line_amt        as decimal no-undo.
   define variable line_curr_amt   as decimal no-undo.
   define variable posted_amt      as decimal no-undo.
   define variable posted_curr_amt as decimal no-undo.

   if can-find(first sab_det
      where sab_so_nbr = sod_det.sod_nbr
      and   sab_sod_line = sod_det.sod_line)
   then do:
      /* SALES ORDER LINE WAS SUMMARY OF CONTRACT DETAIL LINES. */
      /* USE BILLING DETAILS TO DETERMINE EACH BILLED AMOUNT.   */

      /* ACCUMULATE TOTAL OF BILLING DETAILS */
      total_ext_price = 0.
      for each sab_det
         where sab_so_nbr = sod_det.sod_nbr
         and   sab_sod_line = sod_det.sod_line
      no-lock:
         total_ext_price = total_ext_price + sab_ext_price.
      end.

      /* PROCESS ALL BILLING DETAILS */
      for each sab_det
         where sab_so_nbr = sod_det.sod_nbr
         and   sab_sod_line = sod_det.sod_line
      no-lock
         break by sab_so_nbr
               by sab_sod_line:
         /* NEED TO CALCULATE AMOUNT FOR EACH BILLING DETAIL, */
         /* BECAUSE SALES ORDER LINE MAY HAVE INCLUDED TAX.   */
         if last-of(sab_sod_line)
         then
            /* TAKE REMAINING TOTAL OF BILLING DETAILS */
            assign
               line_amt = glamt - posted_amt
               line_curr_amt = curr_amt - posted_curr_amt.
         else do:
            /* TAKE PORTION RELATED TO THIS BILLING DETAIL */
            assign
               line_amt = glamt * sab_ext_price / total_ext_price
               line_curr_amt = curr_amt * sab_ext_price / total_ext_price.
            run roundAmount
               (input-output line_amt,
                input gl_ctrl.gl_rnd_mthd).
            run roundAmount
               (input-output line_curr_amt,
                input rndmthd).
            assign
               posted_amt = posted_amt + line_amt
               posted_curr_amt = posted_curr_amt + line_curr_amt.
         end.

         for first sad_det
            fields(sad_nbr sad_prefix sad_line sad_accrued)
            where sad_nbr    = sab_nbr
            and   sad_prefix = sab_prefix
            and   sad_line   = sab_line
         no-lock:
         end.

         if available sad_det
            and sad_accrued
         then
            /* CONTRACT DETAIL HAS BEEN ACCRUED, CLOSE OUT ACCRUAL */
            run accruedContractDetail
               (input line_amt,
                input line_curr_amt).
         else do:
            /* CONTRACT DETAIL HAS NOT BEEN ACCRUED, POST TO SALES */
            if post
            then do:
               run postGLAmount
                  (input sod_det.sod_acct,
                   input sod_det.sod_sub,
                   input sod_det.sod_cc,
                   input sod_det.sod_project,
                   input line_amt,
                   input line_curr_amt).
               /* SAVE LINE NUMBER OF LAST SOD_ACCT GLT_DET POSTING */
               l_so_gl_line = l_gltline2.
            end.
            run createGLWorkAmount
               (input sod_det.sod_acct,
               input sod_det.sod_sub,
               input sod_det.sod_cc,
               input sod_det.sod_project,
               input line_amt,
               input line_curr_amt).
            /* SAVE LINE NUMBER OF LAST SOD_ACCT GLTW_WKFL POSTING */
            l_so_gltw_line = return_int.
         end.
      end. /* for each sab_det */
   end. /* if can-find first sab_det */
   else do:
      /* SALES ORDER LINE RELATES TO ONE CONTRACT DETAIL LINE */
      for first sad_det
         fields(sad_nbr sad_prefix sad_line sad_accrued)
         where sad_nbr    = sod_det.sod_sa_nbr
         and   sad_prefix = sac_ctrl.sac_sa_pre
         and   sad_line   = sod_det.sod_sad_line
      no-lock:
      end.
      if available sad_det
         and sad_accrued
      then
         /* CONTRACT DETAIL HAS BEEN ACCRUED, CLOSE OUT ACCRUAL */
         run accruedContractDetail
            (input glamt,
             input curr_amt).
      else do:
         /* CONTRACT DETAIL HAS NOT BEEN ACCRUED, POST TO SALES */
         if post
         then do:
            run postGLAmount
               (input sod_det.sod_acct,
               input sod_det.sod_sub,
               input sod_det.sod_cc,
               input sod_det.sod_project,
               input glamt,
               input curr_amt).
            /* SAVE LINE NUMBER OF LAST SOD_ACCT GLT_DET POSTING */
            l_so_gl_line = l_gltline2.
         end.
         run createGLWorkAmount
            (input sod_det.sod_acct,
            input sod_det.sod_sub,
            input sod_det.sod_cc,
            input sod_det.sod_project,
            input glamt,
            input curr_amt).
         /* SAVE LINE NUMBER OF LAST SOD_ACCT GLTW_WKFL POSTING */
         l_so_gltw_line = return_int.
      end.
   end. /* if not can-find first sab_det */

END PROCEDURE.

PROCEDURE accruedContractDetail:

   define input parameter p_amt         as decimal no-undo.
   define input parameter p_curr_amt    as decimal no-undo.

   define variable adjustGLAmount   like glt_amt no-undo.
   define variable adjustCurrAmount like glt_amt no-undo.

   for first defr_det
      where defr_nbr    = sad_det.sad_nbr
      and   defr_prefix = sad_det.sad_prefix
      and   defr_line   = sad_det.sad_line
   exclusive-lock:
   end.

   if available defr_det then do:
      if defr_rev_amt <> 0 then do:
         assign
            adjustGLAmount = ( - p_amt - defr_accr_amt + defr_rev_amt)
            gen_desc = gen_desc_accrued_revenue.
         if so_mstr.so_curr = base_curr then
            adjustCurrAmount = adjustGLAmount.
         else do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input  base_curr,
                 input  so_mstr.so_curr,
                 input  exch_rate2,
                 input  exch_rate,
                 input  adjustGLAmount,
                 input  false,
                 output adjustCurrAmount,
                 output mc-error-number)" }
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end.
         auto_balance_amount = auto_balance_amount + adjustGLAmount.
         if post
         then do:
            {mfgltd.i
               &acct        = defr_sls_acct
               &sub         = defr_sls_sub
               &cc          = defr_sls_cc
               &amt         = "- adjustGLAmount"
               &date        = eff_date
               &curr        = so_mstr.so_curr
               &curramt     = "- adjustCurrAmount"
               &entity      = defr_entity
               &exrate      = defr_ex_rate
               &exrate2     = defr_ex_rate2
               &exratetype  = defr_ex_ratetype
               &exruseq     = defr_exru_seq
               &acct-exruseq= defr_exru_seq
               &project     = defr_project
               {&SOSOGLB-P-TAG21}
               }
         end.

         {mfgltw.i
            &acct        = defr_sls_acct
            &sub         = defr_sls_sub
            &cc          = defr_sls_cc
            &entity      = defr_entity
            &project     = defr_project
            &ref         = ?
            &date        = eff_date
            &type        = ""INVOICE""
            &docnbr      = so_inv_nbr
            &amt         = "- adjustGLAmount"
            &curramt     = "- adjustCurrAmount"
            &daybook     = """"
            {&SOSOGLB-P-TAG22}
            }

         if post
         then do:
            {mfgltd.i
               &acct        = defr_acct
               &sub         = defr_sub
               &cc          = defr_cc
               &amt         = adjustGLAmount
               &date        = eff_date
               &curr        = so_mstr.so_curr
               &curramt     = adjustCurrAmount
               &entity      = defr_entity
               &exrate      = defr_ex_rate
               &exrate2     = defr_ex_rate2
               &exratetype  = defr_ex_ratetype
               &exruseq     = defr_exru_seq
               &acct-exruseq= defr_exru_seq
               &project     = defr_project
               {&SOSOGLB-P-TAG23}
               }
         end.

         {mfgltw.i
            &acct        = defr_acct
            &sub         = defr_sub
            &cc          = defr_cc
            &entity      = defr_entity
            &project     = defr_project
            &ref         = ?
            &date        = eff_date
            &type        = ""INVOICE""
            &docnbr      = so_inv_nbr
            &amt         = adjustGLAmount
            &curramt     = adjustCurrAmount
            &daybook     = """"
            {&SOSOGLB-P-TAG24}
            }

         assign
            defr_eff_date      = eff_date
            defr_period_remain = 0
            defr_rec_amt       = defr_rec_amt + defr_rev_amt
            defr_rev_amt       = 0
            defr_accr_amt      = 0
            gen_desc           = gen_desc_posted_invoice.
      end. /* if defr_rev_amt <> 0 then */

      /* CLEAR AMOUNT FROM ACCRUED ACCOUNT */
      if post then
         run postGLAmount
            (input defr_acct,
             input defr_sub,
             input defr_cc,
             input defr_project,
             input p_amt,
             input p_curr_amt).
      run createGLWorkAmount
         (input defr_acct,
         input defr_sub,
         input defr_cc,
         input defr_project,
         input p_amt,
         input p_curr_amt).

      for first sad_det
         where sad_nbr     = defr_nbr
         and   sad_prefix  = defr_prefix
         and   sad_line    = defr_line
         and   sad_for     = defr_for
         and   sad_accrued = yes
      exclusive-lock:
         sad_accrued = no.
      end.
   end. /* if available defr_det */

END PROCEDURE.

PROCEDURE roundAmount:

   define input-output parameter p_amt as decimal no-undo.
   define input        parameter p_rndmthd like gl_rnd_mthd no-undo.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output p_amt,
        input        p_rndmthd,
        output       mc-error-number)" }

   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

END PROCEDURE.

PROCEDURE postGLAmount:

   define input parameter p_acct like sod_acct no-undo.
   define input parameter p_sub like sod_sub no-undo.
   define input parameter p_cc like sod_cc no-undo.
   define input parameter p_project like sod_project no-undo.
   define input parameter p_amt as decimal no-undo.
   define input parameter p_curr_amt as decimal no-undo.

   /* MFGLTD.I REFERENCES UNQUALIFIED SO_INV_NBR */
   define variable so_inv_nbr like so_mstr.so_inv_nbr.
   so_inv_nbr = so_mstr.so_inv_nbr.

   {mfgltd.i
      &acct=p_acct
      &sub=p_sub
      &cc=p_cc
      &amt=p_amt
      &date=eff_date
      &curr=so_mstr.so_curr
      &curramt=p_curr_amt
      &entity=line_entity
      &exrate=exch_rate
      &exrate2=exch_rate2
      &exratetype=exch_ratetype
      &exruseq=exch_exru_seq
      &acct-exruseq=exch_exru_seq
      &project=p_project
      {&SOSOGLB-P-TAG25}
      }

END PROCEDURE.

PROCEDURE createGLWorkAmount:

   define input parameter p_acct like sod_acct no-undo.
   define input parameter p_sub like sod_sub no-undo.
   define input parameter p_cc like sod_cc no-undo.
   define input parameter p_project like sod_project no-undo.
   define input parameter p_amt as decimal no-undo.
   define input parameter p_curr_amt as decimal no-undo.

   /* REPLACED VALUE OF ref FROM ? TO mfguser */
   {&SOSOGLB-P-TAG26}
   {mfgltw.i
      &acct=p_acct
      &sub=p_sub
      &cc=p_cc
      &entity=line_entity
      &project=p_project
      &ref=mfguser
      &date=eff_date
      &type=""INVOICE""
      &docnbr=so_mstr.so_inv_nbr
      &amt=p_amt
      &curramt=p_curr_amt
      &daybook=""""}
   {&SOSOGLB-P-TAG27}
END PROCEDURE.

{&SOSOGLB-P-TAG8}
