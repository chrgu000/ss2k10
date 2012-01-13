/* sosogla.p - SALES ORDER HEADER GLTRANS WORKFILE POST                      */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* REVISION: 1.0      LAST MODIFIED: 05/12/86   BY: PML                      */
/* REVISION: 6.0      LAST MODIFIED: 10/03/90   BY: MLB *D075*               */
/* REVISION: 6.0      LAST MODIFIED: 10/19/90   BY: pml *D109*               */
/* REVISION: 6.0      LAST MODIFIED: 11/14/90   BY: MLB *D209*               */
/* REVISION: 6.0      LAST MODIFIED: 12/21/90   BY: MLB *D238*               */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: afs *D387*               */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: MLB *D360*               */
/* REVISION: 6.0      LAST MODIFIED: 10/09/91   BY: dgh *D892*               */
/* REVISION: 7.0      LAST MODIFIED: 10/14/91   BY: jjs *F016*               */
/* REVISION: 7.0      LAST MODIFIED: 02/19/92   BY: MLV *F200*               */
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: afs *F356*               */
/* REVISION: 7.0      LAST MODIFIED: 06/19/92   BY: tmd *F458*               */
/* REVISION: 7.3      LAST MODIFIED: 09/06/92   BY: afs *G047*               */
/* REVISION: 7.4      LAST MODIFIED: 07/12/93   BY: jjs *H050*               */
/*                                    (split sosogla1.p off)                 */
/* REVISION: 7.4      LAST MODIFIED: 09/22/93   BY: bcm *H136*               */
/* REVISION: 7.4      LAST MODIFIED: 10/23/93   BY: cdt *H184*               */
/* REVISION: 7.4      LAST MODIFIED: 12/02/93   BY: bcm *H606*               */
/* REVISION: 7.4      LAST MODIFIED: 12/13/94   BY: jzw *F09B*               */
/* REVISION: 7.4      LAST MODIFIED: 03/13/95   BY: jxz *F0M3*               */
/* REVISION: 7.4      LAST MODIFIED: 06/29/95   BY: jym *H0F5*               */
/* REVISION: 7.4      LAST MODIFIED: 07/10/95   BY: jym *H0F7*               */
/* REVISION: 7.4      LAST MODIFIED: 08/17/95   BY: jym *H0FL*               */
/* REVISION: 7.4      LAST MODIFIED: 10/26/95   BY: mys *H0GL*               */
/* REVISION: 8.5      LAST MODIFIED: 07/31/95   BY: taf *J053*               */
/* REVISION: 8.6      LAST MODIFIED: 06/17/96   BY: bjl *K001*               */
/* REVISION: 8.5      LAST MODIFIED: 07/26/96   BY: dxk *G1YS*               */
/* REVISION: 8.6      LAST MODIFIED: 09/16/96   BY: *H0MR* Aruna P. Patil    */
/*                                   02/17/97   BY: *K01R* E. Hughart        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* REVISION: 8.6E     LAST MODIFIED: 06/25/98   BY: *L034* Russ Witt         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* REVISION: 8.6E     LAST MODIFIED: 07/15/98   BY: *L024* Steve Goeke       */
/* REVISION: 8.6E     LAST MODIFIED: 09/11/98   BY: *L069* Jeff Wootton      */
/* REVISION: 9.0      LAST MODIFIED: 10/01/98   BY: *J2CZ* Reetu Kapoor      */
/* REVISION: 9.0      LAST MODIFIED: 11/17/98   BY: *J31D* Poonam Bahl       */
/* REVISION: 9.0      LAST MODIFIED: 11/30/98   BY: *M00P* Jeff Wootton      */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 04/13/99   BY: *J3DK* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED: 05/28/99   BY: *N00D* Adam Harris       */
/* REVISION: 9.1      LAST MODIFIED: 09/16/99   BY: *N02Y* Adam Harris       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari   */
/* REVISION: 9.1      LAST MODIFIED: 02/28/00   BY: *K25F* Rajesh Kini       */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Luke Pokic        */
/* REVISION: 9.1      LAST MODIFIED: 08/03/00   BY: *L12C* Santosh Rao       */
/* REVISION: 9.0      LAST MODIFIED: 08/09/00   BY: *M0R1* Kaustubh K.       */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *N0RF* Mark Brown        */
/* REVISION: 8.6E     LAST MODIFIED: 09/07/00   BY: *L136* Veena Lad         */
/* REVISION: 9.1      LAST MODIFIED: 09/26/00   BY: *K264* Manish K.         */
/* REVISION: 9.1      LAST MODIFIED: 01/02/01   BY: *J3Q3* Ashwini G.        */
/* REVISION: 9.1      LAST MODIFIED: 10/14/00   BY: *N0WB* Mudit Mehta       */
/* Revision: 1.45     BY: Katie Hilbert      DATE: 04/01/01 ECO: *P002*      */
/* Revision: 1.46     BY: Steve Nugent       DATE: 07/09/01 ECO: *P007*      */
/* Revision: 1.47     BY: Nikita Joshi       DATE: 06/20/01 ECO: *L18Q*      */
/* Revision: 1.48     BY: Seema Tyagi        DATE: 06/20/02 ECO: *N1LZ*      */
/* Revision: 1.50     BY: Rafal Krzyminski   DATE: 01/16/03 ECO: *P0LX*      */
/* Revision: 1.52     BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L*      */
/* Revision: 1.53     BY: Gnanasekar         DATE: 09/15/03 ECO: *P0ZW*      */
/* Revision: 1.55     BY: Hareesh V.         DATE: 10/06/03 ECO: *N2F8*      */
/* Revision: 1.56     BY: Rajaneesh S.       DATE: 12/26/03 ECO: *P1HF*      */
/* Revision: 1.57     BY: Rajaneesh S.       DATE: 01/21/04 ECO: *Q05F*      */
/* Revision: 1.58     BY: Bharath Kumar      DATE: 09/29/04 ECO: *P2MC*      */
/* Revision: 1.59     BY: Ajay Nair          DATE: 12/17/04 ECO: *P30F*      */
/* Revision: 1.59.1.2 BY: Dayanand Jethwa    DATE: 02/24/05 ECO: *P27M*      */
/* Revision: 1.59.1.4 BY: Ed van de Gevel    DATE: 08/28/05 ECO: *Q0L5*      */
/* Revision: 1.59.1.7 BY: Jignesh Rachh      DATE: 11/24/05 ECO: *P493*      */
/* $Revision: 1.59.1.8 $ BY: Sandeep Panchal      DATE: 05/02/06 ECO: *P4Q0*      */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                 */

{mfdeclre.i}
{gplabel.i}
{cxcustom.i "SOSOGLA.P"}

{gldydef.i}
{gldynrm.i}

define input-output parameter l_ar_gl_line   like glt_line    no-undo.
define input-output parameter l_ar_gltw_line like gltw_line   no-undo.
define input-output parameter l_tot_amt      like glt_amt     no-undo.
define input-output parameter l_tot_ramt     like glt_amt     no-undo.
define input        parameter cont_charges   like absl_lc_amt no-undo.
define input        parameter line_charges   like abs_price   no-undo.
define input        parameter p_last_line    like mfc_logical no-undo.
define input-output parameter l_addtax       like mfc_logical no-undo.

define new shared variable apply2_rndmthd like rnd_rnd_mthd.
define shared variable rndmthd like rnd_rnd_mthd.
define shared variable so_recno as recid.
define shared variable ord_amt like sod_price.
define shared variable disc_amt like sod_price.
define shared variable tax like ord_amt extent 3.
define shared variable undo_all like mfc_logical no-undo.
define shared variable gl_sum like mfc_logical.
define shared variable base_amt like ar_amt.
define shared variable exch_rate like exr_rate.
define shared variable exch_rate2 like exr_rate2.
define shared variable exch_ratetype like exr_ratetype.
define shared variable exch_exru_seq like exru_seq.
define shared variable ref like glt_det.glt_ref.
define shared variable batch like ar_batch.
define shared variable eff_date like ar_effdate.
define shared variable post like mfc_logical.
define shared variable tot_curr_amt like glt_amt.
define shared variable curr_amt like glt_amt.
define shared variable already_posted like glt_amt.
define shared variable should_be_posted like glt_amt.
define shared variable post_entity like ar_entity.
define shared variable tax_date like tax_effdate.
define shared variable tax_recno as recid.
define shared variable crtint_amt      like trgl_gl_amt.

define variable gltline like glt_line.
define variable l_gltline2 like glt_line no-undo.
define variable acctcurr like glt_curr.
define variable exrate like glt_ex_rate.
define variable exrate2 like glt_ex_rate2.
define variable exruseq like glt_exru_seq.
define variable gen_desc like glt_desc. /*for glt_desc instead of ""*/
define variable term-disc like ap_amt.
define variable aracct_amt as decimal extent 2        no-undo.
define variable l_ar_curramt as decimal extent 2      no-undo.
define variable aracct_gltw_line like gltw_line       no-undo.
define variable aracct_glt_line  like glt_line        no-undo.
define variable aracct_ref       like glt_det.glt_ref no-undo.
define variable mc-error-number  like msg_nbr         no-undo.
define variable ord_amt_corr  like ord_amt no-undo.
define variable ord_amt_ptax  like so_prep_tax no-undo.
define variable ord_amt_prep  like so_prepaid  no-undo.
define variable l_so_nbr                 as character  no-undo.

{gpfilev.i}  /* VARIABLE DEFINITIONS FOR gpfile.i */
{cclc.i} /* DETERMINE IF CONTAINER AND LINE CHARGES IS ENABLED */

{&SOSOGLA-P-TAG1}
gen_desc  = getTermLabel("POSTED_INVOICE",24).

do transaction on error undo, leave:

   assign
      exrate  = exch_rate
      exrate2 = exch_rate2.

   for first soc_ctrl
         fields( soc_domain soc_crtacc_acct soc_crtacc_sub soc_crtacc_cc
                soc_crtapp_acct soc_crtapp_sub soc_crtapp_cc)
          where soc_ctrl.soc_domain = global_domain no-lock:
   end.

   for first so_mstr
         fields( so_domain so_ar_acct so_ar_cc so_ar_sub so_cr_terms so_curr
         so_cust
                so_exru_seq so_ex_rate so_ex_rate2 so_ex_ratetype so_inv_nbr
                so_nbr so_quote so_ship so_ship_date so_taxc so_tax_date
                {&SOSOGLA-P-TAG3}
                so_trl1_amt so_trl1_cd so_trl2_amt so_trl2_cd so_trl3_amt so_trl3_cd)
         where recid(so_mstr) = so_recno no-lock:
   end.

{&SOSOGLA-P-TAG4}
   /* If for any reason the invoice number is blank then LEAVE.
   This causes UNDO_ALL to be set TRUE and the SO posting
   is rolled back. */

   if post and so_inv_nbr = "" then undo, leave.

   for first gl_ctrl
         fields( gl_domain gl_disc_acct gl_disc_sub gl_disc_cc gl_rnd_mthd)
          where gl_ctrl.gl_domain = global_domain no-lock:
   end.
   /* Order Total */
   if ord_amt <> 0 then do:

      ord_amt_corr = ord_amt.
      if so_fsm_type = "PRM" then do:
         /* REVERSE PREPAYMENT BOOKINGS */
         /* ADDED 12TH INPUT PARAMETER p_last_line TO ACCOMODATE THE    */
         /* LOGIC INTRODUCED IN gpcurcnv.i FOR HANDLING ROUNDING ISSUES */

         {gprunmo.i
            &module="PRM"
            &program="pjsogla.p"
            &param="""(input        recid(so_mstr),
                       input        gen_desc,
                       input-output ord_amt_corr,
                       input-output ord_amt_ptax,
                       input-output ord_amt_prep,
                       input-output acctcurr,
                       input-output exrate,
                       input-output exrate2,
                       input-output exruseq,
                       input-output gltline,
                       input-output l_gltline2,
                       input        p_last_line)"""}

      end.


      curr_amt = ord_amt_corr.
      if ord_amt_corr <> 0 then do:
         {gpcurcnv.i &glamt=base_amt}

         /*IF BASE TRANS AND FOREIGN ACCT, FIND CURR_AMT*/
         assign
            acctcurr = so_curr
            exruseq  = exch_exru_seq.

         {gprunp.i "gpglpl" "p" "gpgl-convert-to-account-currency"
            "(input so_curr,
              input so_ar_acct,
              input-output acctcurr,
              input eff_date,
              input-output curr_amt,
              input 0, /* forcurramt */
              input base_curr, /* forcurr */
              input so_ex_ratetype,
              input-output exrate,
              input-output exrate2,
              input-output exruseq
             )"}.

         {&SOSOGLA-P-TAG5}
         /* CREATE DETAIL RECORDS */
         if post then do:
            /* ADDED SECOND EXCHANGE RATE, TYPE, SEQUENCE */
            /* CHANGED SO_EXRU_SEQ TO EXCH_EXRU_SEQ BELOW */
            /* ADDED ACCT-EXRUSEQ BELOW */
            /* CHANGED &CURR FROM SO_CURR TO ACCTCURR */
            /* ADDED 2nd Parameter SUB */
            {&SOSOGLA-P-TAG6}
            {mfgltd.i &acct=so_ar_acct
               &sub=so_ar_sub
               &cc=so_ar_cc
               &amt=base_amt
               &date=eff_date
               &curr=acctcurr
               &curramt=curr_amt
               &entity=post_entity
               &exrate=exrate
               &exrate2=exrate2
               &exratetype=so_ex_ratetype
               &exruseq=exch_exru_seq
               &acct-exruseq=exruseq
               &project=""""}
            {&SOSOGLA-P-TAG7}

            /* IF A ROUNDING ERROR HAS OCCURED TO THE AR, THEN THE GLT_DET WILL */
            /* ALSO NEED TO BE ADJUSTED; THEREFORE, SAVE THE LINE NUMBER FOR THIS */
            /* AR ACCOUNT IN THE VARIABLE AR_ACCT_GLT_LINE. */
            assign
               aracct_ref      = ref
               l_ar_gl_line    = l_gltline2
               aracct_glt_line = l_gltline2.

         end.

         run proc-mfgltw ( input so_ar_acct, input so_ar_sub, input so_ar_cc,
                           input so_inv_nbr ).

         /* IF A ROUNDING ERROR HAS OCCURED TO THE AR, THEN THE GLTW_WKFL WILL */
         /* ALSO NEED TO BE ADJUSTED; THEREFORE, SAVE THE LINE NUMBER FOR THIS */
         /* AR ACCOUNT IN THE VARIABLE AR_ACCT_GLTW_LINE. */
         assign
            l_ar_gltw_line   = return_int
            aracct_gltw_line = return_int.
      end.  /* IF ORD_AMT_CORR <> 0 */
   end.  /* ord_amt <> 0 */

   /* Order Discount */
   if disc_amt <> 0 then do:
      curr_amt = - disc_amt.
      {gpcurcnv.i &glamt=base_amt}

      assign
         l_tot_amt  = l_tot_amt  + curr_amt
         l_tot_ramt = l_tot_ramt + base_amt.

      {&SOSOGLA-P-TAG8}
      if post then do:
         /* ADDED SECOND EXCHANGE RATE, TYPE, SEQUENCE */
         /* ADDED ACCT-EXRUSEQ BELOW */
         /* ADDED 2nd Parameter SUB */
         {&SOSOGLA-P-TAG9}
         {mfgltd.i &acct=gl_disc_acct
            &sub=gl_disc_sub
            &cc=gl_disc_cc
            &amt=base_amt
            &date=eff_date
            &curr=so_curr
            &curramt=curr_amt
            &entity=post_entity
            &exrate=exch_rate
            &exrate2=exch_rate2
            &exratetype=exch_ratetype
            &exruseq=exch_exru_seq
            &acct-exruseq=exch_exru_seq
            &project=""""}
         {&SOSOGLA-P-TAG10}
      end.   /* if post */

      run proc-mfgltw ( input gl_disc_acct, input gl_disc_sub,
                        input gl_disc_cc, input so_inv_nbr ).

   end.    /* disc_amt <> 0 */

   /* Trailer amt 1 */
   if so_trl1_amt <> 0 then do:
      /* ADDED FOURTH AND FIFTH INPUT-OUTPUT PARAMETERS              */
      /* L_TOT_AMT AND L_TOT_RAMT                                    */
      /* ADDED SIXTH INPUT PARAMETER p_last_line TO ACCOMODATE THE   */
      /* LOGIC INTRODUCED IN gpcurcnv.i FOR HANDLING ROUNDING ISSUES */
      /* ADDED THIRD INPUT PARAMETER AS A BLANK VALUE BECAUSE OF     */
      /* ADDITION OF AN EXTRA PARAMETER IN sosogla1.p TO INCLUDE TAX */
      /* FOR LINE  CHARGES IN PROGRAM SOSOGLLC.P                     */


      {gprun.i ""sosogla1.p"" "(input so_trl1_cd,
                                input so_trl1_amt,
                                input """",
                                input-output l_tot_amt,
                                input-output l_tot_ramt,
                                input        p_last_line)"}

   end.

   /* Trailer amt 2 */
   if so_trl2_amt <> 0 then do:
      /* ADDED FOURTH AND FIFTH INPUT-OUTPUT PARAMETERS              */
      /* L_TOT_AMT AND L_TOT_RAMT                                    */
      /* ADDED SIXTH INPUT PARAMETER p_last_line TO ACCOMODATE THE   */
      /* LOGIC INTRODUCED IN gpcurcnv.i FOR HANDLING ROUNDING ISSUES */
      /* ADDED THIRD INPUT PARAMETER AS A BLANK VALUE BECAUSE OF     */
      /* ADDITION OF AN EXTRA PARAMETER IN sosogla1.p TO INCLUDE TAX */
      /* FOR LINE  CHARGES IN PROGRAM SOSOGLLC.P                     */

      {gprun.i ""sosogla1.p"" "(input so_trl2_cd,
                                input so_trl2_amt,
                                input """",
                                input-output l_tot_amt,
                                input-output l_tot_ramt,
                                input        p_last_line)"}

   end.

   /* Trailer amt 3 */
   if so_trl3_amt <> 0 then do:

      /* ADDED FOURTH AND FIFTH INPUT-OUTPUT PARAMETERS              */
      /* L_TOT_AMT AND L_TOT_RAMT                                    */
      /* ADDED SIXTH INPUT PARAMETER p_last_line TO ACCOMODATE THE   */
      /* LOGIC INTRODUCED IN gpcurcnv.i FOR HANDLING ROUNDING ISSUES */
      /* ADDED THIRD INPUT PARAMETER AS A BLANK VALUE BECAUSE OF     */
      /* ADDITION OF AN EXTRA PARAMETER IN sosogla1.p TO INCLUDE TAX */
      /* FOR LINE  CHARGES IN PROGRAM SOSOGLLC.P                     */


      {gprun.i ""sosogla1.p"" "(input so_trl3_cd,
                                input so_trl3_amt,
                                input """",
                                input-output l_tot_amt,
                                input-output l_tot_ramt,
                                input        p_last_line)"}

   end.

   /* LINE CHARGES ARE CREATED USING TRAILER CODES. USING      */
   /* sosogla1.p TO CREATE PROPER GL ENTRIES FOR LINE CHARGES. */

   if using_line_charges then do:

      /* ADDED FOURTH INPUT PARAMETER p_last_line TO ACCOMODATE THE  */
      /* LOGIC INTRODUCED IN gpcurcnv.i FOR HANDLING ROUNDING ISSUES */

      {gprunmo.i
         &program = "sosogllc.p"
         &module = "ACL"
         &param = """(input so_recno,
                      input-output l_tot_amt,
                      input-output l_tot_ramt,
                      input        p_last_line)"""}

   end. /* IF using_line_charges */

   /* POST CONTAINER CHARGES */
   if using_container_charges then do:

      /* ADDED 27TH INPUT PARAMETER p_last_line TO ACCOMODATE THE    */
      /* LOGIC INTRODUCED IN gpcurcnv.i FOR HANDLING ROUNDING ISSUES */

      {gprunmo.i
         &program = "sosoglcc.p"
         &module = "ACL"
         &param = """(input so_inv_nbr,
                      input rndmthd,
                      input so_recno,
                      input ord_amt,
                      input disc_amt,
                      input tax[1],
                      input tax[2],
                      input tax[3],
                      input undo_all,
                      input gl_sum,
                      input base_amt,
                      input exch_rate,
                      input exch_rate2,
                      input exch_ratetype,
                      input exch_exru_seq,
                      input ref,
                      input batch,
                      input eff_date,
                      input post,
                      input tot_curr_amt,
                      input curr_amt,
                      input already_posted,
                      input should_be_posted,
                      input post_entity,
                      input tax_date,
                      input tax_recno,
                      input p_last_line)"""}

   end. /* IF using_container_charges */

   /* TAXES */
   /* POST tx2d_det; CREATE GLTW_WKFL FOR AUDIT TRAIL */
   /* NOTE: arc_gl_sum IS TRUE IF POSTING IS TO BE    */
   /*       SUMMARIZED.  gpgltdet.i EXPECTS THE FLAG  */
   /*       TO BE FALSE IF POSTING IS TO BE SUMMARIZED*/

   for first arc_ctrl
         fields( arc_domain arc_sum_lvl)
          where arc_ctrl.arc_domain = global_domain no-lock:
   end.

   /* ENSURE THAT THE EXCHANGE RATE REFLECTS THE GL EFFECTIVE DATE */

   if post and not so_fix_rate then
   do:
      /* ADDED SECOND EXCHANGE RATE BELOW */
      /* ADDED EXCHANGE RATE TYPE BELOW   */
      {gprun.i ""txcurup.p"" "(input so_inv_nbr,
                               input so_nbr,
                               input '16',
                               input exrate,
                               input exrate2,
                               input so_ex_ratetype,
                               input post_entity,
                               input eff_date)"}
   end. /* assign correct exchange rate */

   if post and can-find(first tx2d_det
               where tx2d_domain  = global_domain
               and   tx2d_ref     = so_inv_nbr
               and   tx2d_nbr     = "CONSOL"
               and   tx2d_tr_type = '16')
   then do:
      l_so_nbr = 'CONSOL'.
      if l_addtax
      then
         run tx2dloop .
   end. /* IF post AND CAN-FIND(FIRST tx2d_det */
   else do:
      l_so_nbr       = so_nbr.
      run tx2dloop .
   end. /* IF NOT post AND NOT CAN-FIND( .... */

   {&SOSOGLA-P-TAG11}

   if post and can-find(first tx2d_det
               where tx2d_domain  = global_domain
               and   tx2d_ref     = so_inv_nbr
               and   tx2d_nbr     = "CONSOL"
               and   tx2d_tr_type = '16')
   then do:
      l_so_nbr = 'CONSOL'.

      if l_addtax
      then
         run txglpostproc .

      l_addtax = false .
   end. /* IF post AND (NOT CAN-FIND ..*/
   else do:
      l_so_nbr = so_nbr.
      run txglpostproc.
   end. /* IF post AND CAN-FIND(FIRST tx2d_det ... */

   {&SOSOGLA-P-TAG12}
   /* CREDIT TERMS INTEREST */
   /* POST THE CREDIT TERMS INTEREST COMPONENT OF THE ITEM PRICE */
   /* TO A STATISCAL ACCCOUNT FOR THE INVOICE.                   */
   {&SOSOGLA-P-TAG13}
   if crtint_amt <> 0 and soc_crtacc_acct <> "" and
      soc_crtapp_acct <> "" then do:

      {&SOSOGLA-P-TAG14}
      /* DEBIT ACCRUED TERMS INTEREST ACCOUNT */
      curr_amt = crtint_amt.
      {gpcurcnv.i &glamt=base_amt}
      run credit-terms-interest
         (input soc_crtacc_acct,
         input soc_crtacc_sub,
         input soc_crtacc_cc).

      /* CREDIT APPLIED TERMS INTEREST ACCOUNT */
      curr_amt = - crtint_amt.
      {gpcurcnv.i &glamt=base_amt}
      run credit-terms-interest
         (input soc_crtapp_acct,
         input soc_crtapp_sub,
         input soc_crtapp_cc).

   {&SOSOGLA-P-TAG15}
   end. /* IF CRTINT_AMT <> 0 ..... */

   /* IN THE CASE OF CURRENCY CONVERSIONS, ROUNDING ERRORS MUST          */
   /* BE CHECKED FOR.  WHEN THE GLT_DET RECORD IS CREATED FOR THE        */
   /* SO AR ACCT, THE CONVERTSION IS DONE AGAINST THE SUM OF ALL         */
   /* THE VALUES WHICH MAKE UP THE SO AR ACCT AMOUNT.  HOWEVER,          */
   /* WHEN THE OTHER GLT_DET RECORDS ARE CREATED, THE CONVERSION         */
   /* IS PERFORMED AGAINST EACH INDIVIUAL GLT_DET RECORD.  (ONE ITEM     */
   /* ITEM CONVERTED AT A TIME IS THE CORRECT FORMULA.  A ROUNDING ERROR */
   /* CAN BE DETECTED BY COMPARING THE SO AR ACCTOUNT VALUE TO THE SUM   */
   /* OF ALL THE OTHER GLT_DET RECORDS FOR THIS GL REFERENCE.  IF A      */
   /* DISCREPENCY IS FOUND, THEN THE AR-ACCT GLT_DET & GLTW_WKFL RECORDS */
   /* ARE ADJUSTED BY THE ROUNDING ERROR.                                */
   assign aracct_amt = 0
          l_ar_curramt = 0.

   if not post
   then do:
      for each gltw_wkfl
          where gltw_wkfl.gltw_domain = global_domain and  gltw_userid = mfguser
      no-lock:
         if gltw_acct = so_ar_acct
         then
            assign
               aracct_amt[1]   = aracct_amt[1]   + gltw_amt
               l_ar_curramt[1] = l_ar_curramt[1] + gltw_curramt.
         else do:
            for first ac_mstr
               fields( ac_domain ac_code ac_curr ac_stat_acc ac_type)
                where ac_mstr.ac_domain = global_domain and  ac_code = gltw_acct
            no-lock:
            end.

            if available ac_mstr
               and ac_type <> "S"
               and ac_type <> "M"
            then
               assign
                  aracct_amt[2]   = aracct_amt[2]   + gltw_amt
                  l_ar_curramt[2] = l_ar_curramt[2] + gltw_curramt.
            else
               if not available ac_mstr
               then
                  assign
                     aracct_amt[2]   = aracct_amt[2]   + gltw_amt
                     l_ar_curramt[2] = l_ar_curramt[2] + gltw_curramt.
         end. /* ELSE DO */
      end.  /* FOR EACH gltw_wkfl */
   end. /* IF NOT post */

   for each glt_det
         fields( glt_domain glt_acct glt_addr glt_amt glt_batch glt_cc glt_sub
                glt_correction glt_curr glt_curr_amt glt_date glt_desc glt_doc
                glt_doc_type glt_dy_code glt_dy_num glt_effdate glt_entity
                glt_exru_seq glt_ex_rate glt_ex_rate2 glt_ex_ratetype glt_line
                glt_project glt_ref glt_rflag glt_sub glt_tr_type glt_userid)
          where glt_det.glt_domain = global_domain and   glt_ref = aracct_ref
          no-lock:
      if glt_acct = so_ar_acct then
         assign
            aracct_amt[1]   = aracct_amt[1]   + glt_amt
            l_ar_curramt[1] = l_ar_curramt[1] + glt_curr_amt.
      else do:

         for first ac_mstr
               fields( ac_domain ac_code ac_curr ac_stat_acc ac_type)
                where ac_mstr.ac_domain = global_domain and  ac_code = glt_acct
                no-lock:
         end.

         if available ac_mstr and ac_type <> "S" and ac_type <> "M"
         then
            assign
               aracct_amt[2]   = aracct_amt[2]   + glt_amt
               l_ar_curramt[2] = l_ar_curramt[2] + glt_curr_amt.
         else
         if not available ac_mstr then
            assign
               aracct_amt[2]   = aracct_amt[2]   + glt_amt
               l_ar_curramt[2] = l_ar_curramt[2] + glt_curr_amt.
      end.
   end.  /* for each glt_det */
   if aracct_amt[1] <> (aracct_amt[2] * -1) then do:
      {&SOSOGLA-P-TAG16}
      find glt_det exclusive-lock  where glt_det.glt_domain = global_domain and
         glt_ref = aracct_ref and
         glt_line = aracct_glt_line and
         glt_rflag = false no-error.
      if available glt_det then
         assign
            glt_amt      = glt_amt      - (aracct_amt[1]   + aracct_amt[2])
            glt_curr_amt = glt_curr_amt - (l_ar_curramt[1] + l_ar_curramt[2]).
      find gltw_wkfl exclusive-lock  where gltw_wkfl.gltw_domain =
      global_domain and
         gltw_line = aracct_gltw_line and
         gltw_rflag = no and
         gltw_ref = mfguser no-error.
      if available gltw_wkfl then
         assign
            gltw_amt      = gltw_amt    - (aracct_amt[1]   + aracct_amt[2])
            gltw_curramt = gltw_curramt - (l_ar_curramt[1] + l_ar_curramt[2]).
      {&SOSOGLA-P-TAG17}
   end. /* end */

   {&SOSOGLA-P-TAG2}
   return.
end.

undo_all = yes. /*ERROR */

/*------------------------------------------------------------------*/

PROCEDURE credit-terms-interest:

   define input parameter p-acct as character.
   define input parameter p-sub as character.
   define input parameter p-cc as character.

   /*IF BASE TRANS AND FOREIGN ACCT, FIND CURR_AMT*/
   assign
      acctcurr = so_mstr.so_curr
      exrate  = exch_rate
      exrate2 = exch_rate2
      exruseq = exch_exru_seq.

   {gprunp.i "gpglpl" "p" "gpgl-convert-to-account-currency"
              "(input so_curr,
                input p-acct,
                input-output acctcurr,
                input eff_date,
                input-output curr_amt,
                input 0, /* forcurramt */
                input base_curr, /* forcurr */
                input so_ex_ratetype,
                input-output exrate,
                input-output exrate2,
                input-output exruseq
                )"}.

   /* CREATE DETAIL RECORDS */
   if post then do:
      /* ADDED SECOND EXCHANGE RATE, TYPE, SEQUENCE */
      /* CHANGED SO_EXRU_SEQ TO EXCH_EXRU_SEQ BELOW */
      /* ADDED ACCT-EXRUSEQ BELOW */
      /* CHANGED &CURR FROM SO_CURR TO ACCTCURR */
      /* ADDED 2nd Parameter SUB BELOW */
      /* CHANGED &project TO so_project (WAS """") */
      {&SOSOGLA-P-TAG18}
      {mfgltd.i &acct=p-acct
         &sub=p-sub
         &cc=p-cc
         &amt=base_amt
         &date=eff_date
         &curr=acctcurr
         &curramt=curr_amt
         &entity=post_entity
         &exrate=exrate
         &exrate2=exrate2
         &exratetype=so_ex_ratetype
         &exruseq=exch_exru_seq
         &acct-exruseq=exruseq
         &project=so_project}
      {&SOSOGLA-P-TAG19}
   end.

   run proc-mfgltw ( input p-acct,
                     input p-sub,
                     input p-cc,
                     input so_inv_nbr ).

END PROCEDURE.

PROCEDURE proc-mfgltw:

   define input parameter inpar_so_ar_acct like so_ar_acct no-undo.
   define input parameter inpar_so_ar_sub like so_ar_sub no-undo.
   define input parameter inpar_so_ar_cc  like so_ar_cc no-undo.
   define input parameter inpar_so_inv_nbr like so_inv_nbr no-undo.

   /* ADDED 2nd parameter SUB BELOW */
   /* CHANGED ref FROM UNKNOWN VALUE (?) TO mfguser IN mfgltw.i */
   {&SOSOGLA-P-TAG20}
   {mfgltw.i &acct=inpar_so_ar_acct
      &sub=inpar_so_ar_sub
      &cc=inpar_so_ar_cc
      &entity=post_entity
      &project=""""
      &ref=mfguser
      &date=eff_date
      &type=""INVOICE""
      &docnbr=inpar_so_inv_nbr
      &amt=base_amt
      &curramt=curr_amt
      &daybook=""""}
   {&SOSOGLA-P-TAG21}

END PROCEDURE.

PROCEDURE tx2dloop :

   if available so_mstr
   then .

   for each tx2d_det
      where tx2d_domain   = global_domain
        and (tx2d_ref     = if post
                            then
                               so_inv_nbr
                            else
                               so_nbr)
        and (tx2d_nbr     = if post
                            then
                               l_so_nbr
                            else if so_fsm_type = "FSM-RO"
                            then
                               so_quote
                            else
                               " ")
        and (tx2d_tr_type = if post
                            then
                               "16"
                            else if so_fsm_type = "FSM-RO"
                            then
                               "38"
                            else
                               "13")
      use-index tx2d_ref_nbr:

         if tx2d_trans_ent <> post_entity
         then
            tx2d_trans_ent = post_entity.

   end. /* FOR EACH tx2d_det */

END PROCEDURE. /* tx2dloop */

PROCEDURE txglpostproc :

   {&SOSOGLA-P-TAG22}
   /* ADDED SECOND EXCHANGE RATE, TYPE, SEQUENCE */
   /* CHANGED THE ELSE CLAUSE FROM SO_QUOTE TO "" IN THE   */
   /* THIRD INPUT PARAMETER                                */

   /* CHANGED "not arc_gl_sum" TO "arc_sum_lvl" */
   /* REVERSED PARAMETER FOR SUMM-LVL */

   /* MODIFIED THE FIRST AND THIRD INPUT PARAMETER TO ACCOUNT FOR */
   /* CALL INVOICES                                               */
   /* REPLACED NINETEENTH INPUT PARAMETER FROM 'IV' TO 'I'        */

   if available so_mstr
   then .

   if available arc_ctrl
   then .

   {&SOSOGLA-P-TAG23}
   {gprun.i ""txglpost.p"" "(input if post then '16'
                                   else
                                   if so_fsm_type = 'fsm-ro'
                                   then '38'
                                   else '13',
                             input if post then so_inv_nbr
                                   else so_nbr,
                             input if post then l_so_nbr
                                   else
                                   if so_fsm_type = 'fsm-ro'
                                   then so_quote
                                   else """",
                             input so_curr,
                             input ref    /* GL REFERENCE NUMBER */,
                             input eff_date,
                             input exrate,
                             input exrate2,
                             input so_ex_ratetype,
                             input so_exru_seq,
                             input batch,
                             input 'SO'   /* MODULE SENDING TRXN */,
                             input gen_desc /* TRAN. DESCRIPTION */,
                             input post   /* CREATE GLT_DET */,
                             input arc_sum_lvl /* SUMM-LVL */,
                             input true      /* CREAT GLTW_WKFL */,
                             input gl_sum    /* REPORT IN DETAIL */,
                             input ''        /* PROJECT */,
                             input 'I'       /* TYPE OF DOCUMENT */,
                             input so_ship   /* DOC ADDRESS */,
                             input 'INVOICE' /* GLTW_WKFL TYPE */,
                             input -1    /* CREDIT TAX AMOUNTS */)"}
    {&SOSOGLA-P-TAG24}
END PROCEDURE. /* txglpostproc */
