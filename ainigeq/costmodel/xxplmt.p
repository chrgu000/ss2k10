/* ppplmt.p - PRODUCT LINE MAINTENANCE                                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 1.0      LAST MODIFIED: 03/20/86   BY: PML                       */
/* REVISION: 7.0      LAST MODIFIED: 08/21/91   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 09/17/91   BY: MLV *F015*                */
/* REVISION: 7.0      LAST MODIFIED: 11/16/91   BY: pml *F048*                */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: pma *F360*                */
/* REVISION: 7.0      LAST MODIFIED: 04/15/92   BY: pma *F403*                */
/* REVISION: 7.3      LAST MODIFIED: 08/26/92   BY: mpp *G009*                */
/* REVISION: 7.3      LAST MODIFIED: 01/26/93   BY: bcm *G429*                */
/* REVISION: 7.3      LAST MODIFIED: 03/16/93   BY: bcm *G823* (rev only )    */
/* REVISION: 7.3      LAST MODIFIED: 10/28/93   BY: ais *GG71*                */
/* REVISION: 7.5      LAST MODIFIED: 07/23/94   by: dzs *J030*                */
/* REVISION: 7.3      LAST MODIFIED: 03/01/95   BY: srk *G0G4*                */
/* REVISION: 8.5      LAST MODIFIED: 04/12/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 04/12/96   BY: *J04C* Markus Barone      */
/* REVISION: 8.5      LAST MODIFIED: 07/31/96   BY: *G2B8* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 10/07/96   BY: *J15M* Sue Poland         */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/05/99   BY: *N014* Vijaya Pakala      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 05/12/00   BY: *N0B1* David Morris       */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb                */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00   BY: *N0VN* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.7.3.6      BY: Katie Hilbert     DATE: 04/01/01  ECO: *P002*   */
/* Revision: 1.7.3.7      BY: Niranjan R.       DATE: 07/12/01  ECO: *P00L*   */
/* Revision: 1.7.3.8      BY: Anil Sudhakaran   DATE: 11/28/01  ECO: *M1FK*   */
/* Revision: 1.7.3.11     BY: Niranjan R.       DATE: 03/13/02  ECO: *P020*   */
/* Revision: 1.7.3.13     BY: Ellen Borden      DATE: 03/22/01  ECO: *P00G*   */
/* Revision: 1.7.3.14     BY: Jean Miller       DATE: 05/17/02  ECO: *P05V*   */
/* Revision: 1.7.3.15     BY: Ed van de Gevel   DATE: 07/04/02  ECO: *P0B4*  */
/* Revision: 1.7.3.16     BY: Rajaneesh S.      DATE: 01/17/03  ECO: *P0LZ*  */
/* Revision: 1.7.3.17           BY: Narathip W.       DATE: 03/27/03  ECO: *P0P9*  */
/* $Revision: 1.7.3.17.1.1 $  BY: Russ Witt   DATE: 10/11/04 ECO:  *P2P4*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

{mfdtitle.i "100826.1"}
{cxcustom.i "xxPLMT.P"}

define variable del-yn like mfc_logical initial no.

define new shared frame a.
define new shared frame b.
define new shared frame c.
define new shared frame d.
define new shared frame e.
define new shared variable plrecid as recid.
{&PPPLMT-P-TAG6}

{gptxcdec.i}    /* DECLARATIONS FOR gptxcval.i */

/* CHECK IF PRM IS INSTALLED */
/* SETS THE FLAG PRM-ENABLED = YES IF IT IS. */
{pjchkprm.i}

/* Variable added to perform delete during CIM.
 * Record is deleted only when the value of this variable
 * Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

/* CONSIGNMENT VARIABLES. */
{socnvars.i}

define variable ENABLE_SUPPLIER_CONSIGNMENT as character
                  initial "enable_supplier_consignment"     no-undo.
define variable SUPPLIER_CONSIGNMENT        as character
                  initial "supplier_consignment"            no-undo.
define variable SUPPLIER_CONSIGN_CTRL_TABLE as character
                  initial "cns_ctrl"                        no-undo.
define variable using_supplier_consignment like mfc_logical no-undo.

/* CHANGED default_sub, default_cc, override_sub AND override_cc */
/* TO LOCAL VARIABLES FROM NEW SHARED VARIABLES                  */
define variable default_sub as character no-undo initial " "
   label "Default Sub-Account".
define variable default_cc as character format "x(4)" no-undo
   initial " " label "Default Cost Center".
define variable override_sub like mfc_logical no-undo
   initial no label "Override".
define variable override_cc like mfc_logical no-undo
   initial no label "Override".

/* CHECK TO SEE IF CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_CUSTOMER_CONSIGNMENT,
     input 10,
     input ADG,
     input CUST_CONSIGN_CTRL_TABLE,
     output using_cust_consignment)"}

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_SUPPLIER_CONSIGNMENT,
     input 11,
     input ADG,
     input SUPPLIER_CONSIGN_CTRL_TABLE,
     output using_supplier_consignment)"}

/* DISPLAY SELECTION FORM */
form
   pl_prod_line   colon 25
   batchdelete no-label colon 60
   pl_desc        colon 25 skip(1)
   pl_taxable     colon 25
   pl__chr05      colon 50
   pl_taxc        colon 25
   default_sub    colon 25 override_sub  colon 50
   default_cc     colon 25 override_cc   colon 50
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/*INVENTORY FORM */
{&PPPLMT-P-TAG1}
form
   pl_inv_acct    colon 25 pl_inv_sub  no-label pl_inv_cc      no-label
   pl_dscr_acct   colon 25 pl_dscr_sub no-label pl_dscr_cc     no-label
   pl_scrp_acct   colon 25 pl_scrp_sub no-label pl_scrp_cc     no-label
   pl_cchg_acct   colon 25 pl_cchg_sub no-label pl_cchg_cc     no-label
with frame b side-labels width 80
title color normal (getFrameTitle("INVENTORY_ACCOUNTS",26)) attr-space.
{&PPPLMT-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

/* SALES FORM */
form
   pl_sls_acct    colon 25 pl_sls_sub  no-label pl_sls_cc      no-label
   pl_dsc_acct    colon 25 pl_dsc_sub  no-label pl_dsc_cc      no-label
   pl_cmtl_acct   colon 25 pl_cmtl_sub no-label pl_cmtl_cc     no-label
   pl_clbr_acct   colon 25 pl_clbr_sub no-label pl_clbr_cc     no-label
   pl_cbdn_acct   colon 25 pl_cbdn_sub no-label pl_cbdn_cc     no-label
   pl_covh_acct   colon 25 pl_covh_sub no-label pl_covh_cc     no-label
   pl_csub_acct   colon 25 pl_csub_sub no-label pl_csub_cc     no-label
with frame c side-labels width 80
title color normal (getFrameTitle("SALES_ACCOUNTS",21)) attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

/* PURCHASING FORM */
form
   pl_pur_acct    colon 25 pl_pur_sub  no-label pl_pur_cc     no-label
   pl_rcpt_acct   colon 25 pl_rcpt_sub no-label pl_rcpt_cc    no-label
   pl_ovh_acct    colon 25 pl_ovh_sub  no-label pl_ovh_cc     no-label
   pl_ppv_acct    colon 25 pl_ppv_sub  no-label pl_ppv_cc     no-label
   pl_apvu_acct   colon 25 pl_apvu_sub no-label pl_apvu_cc    no-label
   pl_apvr_acct   colon 25 pl_apvr_sub no-label pl_apvr_cc    no-label
with frame d side-labels width 80
title color normal (getFrameTitle("PURCHASING_ACCOUNTS",28)) attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

/* WORK ORDER FORM */
form
   pl_flr_acct    colon 25
   pl_flr_sub     no-label
   pl_flr_cc      no-label
   pl_mvar_acct   colon 25
   pl_mvar_sub    no-label
   pl_mvar_cc     no-label
   pl_mvrr_acct   colon 25
   pl_mvrr_sub    no-label
   pl_mvrr_cc     no-label
   pl_xvar_acct   colon 25
   pl_xvar_sub    no-label
   pl_xvar_cc     no-label
   pl_cop_acct    colon 25
   pl_cop_sub     no-label
   pl_cop_cc      no-label
   pl_svar_acct   colon 25
   pl_svar_sub    no-label
   pl_svar_cc     no-label
   pl_svrr_acct   colon 25
   pl_svrr_sub    no-label
   pl_svrr_cc     no-label
   pl_wip_acct    colon 25
   pl_wip_sub     no-label
   pl_wip_cc      no-label
   pl_wvar_acct   colon 25
   pl_wvar_sub    no-label
   pl_wvar_cc     no-label
with frame e side-labels width 80
title color normal (getFrameTitle("WORK_ORDER_ACCOUNTS",28)) attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame e:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:

   assign
      override_sub = no
      override_cc  = no.

   view frame b.
   {&PPPLMT-P-TAG7}

   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   prompt-for
      pl_mstr.pl_prod_line
      /* Prompt for the delete variable in the key frame at the
       * End of the key field/s only when batchrun is set to yes */
      batchdelete no-label when (batchrun)
   editing:

      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i pl_mstr pl_prod_line pl_prod_line pl_prod_line
         pl_prod_line pl_prod_line}

      if recno <> ? then do:

         display
            pl_prod_line
            pl_desc
            pl_taxable
            pl__chr05
            pl_taxc
            default_sub
            override_sub
            default_cc
            override_cc
         with frame a.

         display pl_inv_acct
            pl_inv_sub
            pl_inv_cc
            pl_dscr_acct
            pl_dscr_sub
            pl_dscr_cc
            pl_scrp_acct
            pl_scrp_sub
            pl_scrp_cc
            pl_cchg_acct
            pl_cchg_sub
            pl_cchg_cc
         with frame b.
         {&PPPLMT-P-TAG3}

      end.
   end.

   /* ADD/MOD/DELETE  */
   seta:
   do transaction with frame a on error undo, retry:

      find pl_mstr using pl_prod_line no-error.

      if not available pl_mstr then do:

         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}

         create pl_mstr.
         assign pl_prod_line.

         find first gl_ctrl no-lock no-error.
         if available gl_ctrl then
            assign
               pl_sls_acct        = gl_sls_acct
               pl_sls_sub         = gl_sls_sub
               pl_sls_cc          = gl_sls_cc
               pl_dsc_acct        = gl_disc_acct
               pl_dsc_sub         = gl_disc_sub
               pl_dsc_cc          = gl_disc_cc
               pl_inv_acct        = gl_inv_acct
               pl_inv_sub         = gl_inv_sub
               pl_inv_cc          = gl_inv_cc
               pl_rcpt_acct       = gl_rcpt_acct
               pl_rcpt_sub        = gl_rcpt_sub
               pl_rcpt_cc         = gl_rcpt_cc
               pl_wip_acct        = gl_wip_acct
               pl_wip_sub         = gl_wip_sub
               pl_wip_cc          = gl_wip_cc
               pl_pur_acct        = gl_pur_acct
               pl_pur_sub         = gl_pur_sub
               pl_pur_cc          = gl_pur_cc
               pl_ppv_acct        = gl_ppv_acct
               pl_ppv_sub         = gl_ppv_sub
               pl_ppv_cc          = gl_ppv_cc
               pl_scrp_acct       = gl_scrp_acct
               pl_scrp_sub        = gl_scrp_sub
               pl_scrp_cc         = gl_scrp_cc
               pl_wvar_acct       = gl_wvar_acct
               pl_wvar_sub        = gl_wvar_sub
               pl_wvar_cc         = gl_wvar_cc
               pl_dscr_acct       = gl_dscr_acct
               pl_dscr_sub        = gl_dscr_sub
               pl_dscr_cc         = gl_dscr_cc
               pl_cchg_acct       = gl_cchg_acct
               pl_cchg_sub        = gl_cchg_sub
               pl_cchg_cc         = gl_cchg_cc
               pl_apvu_acct       = gl_apvu_acct
               pl_apvu_sub        = gl_apvu_sub
               pl_apvu_cc         = gl_apvu_cc
               pl_apvr_acct       = gl_apvr_acct
               pl_apvr_sub        = gl_apvr_sub
               pl_apvr_cc         = gl_apvr_cc
               pl_ovh_acct        = gl_ovh_acct
               pl_ovh_sub         = gl_ovh_sub
               pl_ovh_cc          = gl_ovh_cc
               pl_cmtl_acct       = gl_cmtl_acct
               pl_cmtl_sub        = gl_cmtl_sub
               pl_cmtl_cc         = gl_cmtl_cc
               pl_clbr_acct       = gl_clbr_acct
               pl_clbr_sub        = gl_clbr_sub
               pl_clbr_cc         = gl_clbr_cc
               pl_cbdn_acct       = gl_cbdn_acct
               pl_cbdn_sub        = gl_cbdn_sub
               pl_cbdn_cc         = gl_cbdn_cc
               pl_covh_acct       = gl_covh_acct
               pl_covh_sub        = gl_covh_sub
               pl_covh_cc         = gl_covh_cc
               pl_csub_acct       = gl_csub_acct
               pl_csub_sub        = gl_csub_sub
               pl_csub_cc         = gl_csub_cc
               pl_cop_acct        = gl_cop_acct
               pl_cop_sub         = gl_cop_sub
               pl_cop_cc          = gl_cop_cc
               pl_mvar_acct       = gl_mvar_acct
               pl_mvar_sub        = gl_mvar_sub
               pl_mvar_cc         = gl_mvar_cc
               pl_mvrr_acct       = gl_mvrr_acct
               pl_mvrr_sub        = gl_mvrr_sub
               pl_mvrr_cc         = gl_mvrr_cc
               pl_svar_acct       = gl_svar_acct
               pl_svar_sub        = gl_svar_sub
               pl_svar_cc         = gl_svar_cc
               pl_svrr_acct       = gl_svrr_acct
               pl_svrr_sub        = gl_svrr_sub
               pl_svrr_cc         = gl_svrr_cc
               pl_flr_acct        = gl_flr_acct
               pl_flr_sub         = gl_flr_sub
               pl_flr_cc          = gl_flr_cc
               pl_xvar_acct       = gl_xvar_acct
               pl_xvar_sub        = gl_xvar_sub
               pl_xvar_cc         = gl_xvar_cc
               pl_fslbr_acct      = gl_fslbr_acct
               pl_fslbr_sub       = gl_fslbr_sub
               pl_fslbr_cc        = gl_fslbr_cc
               pl_fsbdn_acct      = gl_fsbdn_acct
               pl_fsbdn_sub       = gl_fsbdn_sub
               pl_fsbdn_cc        = gl_fsbdn_cc
               pl_fsexp_acct      = gl_fsexp_acct
               pl_fsexp_sub       = gl_fsexp_sub
               pl_fsexp_cc        = gl_fsexp_cc
               pl_fsexd_acct      = gl_fsexd_acct
               pl_fsexd_sub       = gl_fsexd_sub
               pl_fsexd_cc        = gl_fsexd_cc
               pl_rmar_acct       = gl_rmar_acct
               pl_rmar_sub        = gl_rmar_sub
               pl_rmar_cc         = gl_rmar_cc
               pl_fsdef_acct      = gl_fsdef_acct
               pl_fsdef_sub       = gl_fsdef_sub
               pl_fsdef_cc        = gl_fsdef_cc
               pl_fsaccr_acct     = gl_fsaccr_acct
               pl_fsaccr_sub      = gl_fsaccr_sub
               pl_fsaccr_cc       = gl_fsaccr_cc
               pl_fsrc_inv_acct   = gl_fsrc_inv_acct
               pl_fsrc_inv_cc     = gl_fsrc_inv_cc
               pl_fscm_inv_acct   = gl_fscm_inv_acct
               pl_fscm_inv_cc     = gl_fscm_inv_cc
               {&PPPLMT-P-TAG5}.

         if using_cust_consignment or using_supplier_consignment then do:
         /*Create the consignment accts for the product line*/
         /* ADDED INPUT PARAMETERS default_sub, default_cc, */
         /* override_sub AND override_cc AS 3RD, 4TH, 5TH   */
         /* AND 6TH INPUT PARAMETERS RESPECTIVELY           */
            {gprunmo.i
               &program = "ppplmtc.p"
               &module = "ACN"
               &param = """(input pl_prod_line,
                            input 1,
                            input default_sub,
                            input default_cc,
                            input override_sub,
                            input override_cc)"""}

         end. /* If using_cust_consignment*/
         {&PPPLMT-P-TAG8}

      end.

      /* STORE MODIFY DATE AND USERID */
      pl_mod_date = today.
      pl_userid = global_userid.

      recno = recid(pl_mstr).

      display
         pl_prod_line
         pl_desc
         pl_taxable
         pl__chr05
         pl_taxc
         default_sub
         override_sub
         default_cc
         override_cc
      with frame a.

      display
         pl_inv_acct pl_inv_sub pl_inv_cc
         pl_dscr_acct pl_dscr_sub pl_dscr_cc
         pl_scrp_acct pl_scrp_sub pl_scrp_cc
         pl_cchg_acct pl_cchg_sub pl_cchg_cc
      with frame b.
      {&PPPLMT-P-TAG4}

      ststatus = stline[2].
      status input ststatus.
      del-yn = no.

      set1:
      do on error undo, retry:
         set
            pl_desc pl_taxable pl__chr05 pl_taxc
            default_sub override_sub default_cc override_cc
         go-on (F5 CTRL-D) with frame a.

         /* VALIDATION OF NON TAX CODE*/
         {gptxcval.i &code=pl_taxc  &frame="a"}

         if override_sub then do:
            if not ({gpglsub.v default_sub}) then do:
               next-prompt default_sub with frame a.
               {pxmsg.i &MSGNUM=3131 &ERRORLEVEL=3}
               undo, retry.
            end.
         end.
         if override_cc then do:
            if not ({gpglcc.v default_cc}) then do:
               next-prompt default_cc with frame a.
               {pxmsg.i &MSGNUM=3057 &ERRORLEVEL=3}
               undo, retry.
            end.
         end.

         /* DELETE */
         if lastkey = keycode("F5") or
            lastkey = keycode("CTRL-D") or
            /* Delete to be executed if batchdelete is set to "x" */
            input batchdelete = "x":U
         then do:

            del-yn = yes.
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
            if del-yn = no then undo set1.

            /*CHECK FOR PARTS USING PRODUCT LINE */
            if can-find(first pt_mstr
                        where pt_prod_line = pl_prod_line)
            then do:
               find first pt_mstr where pt_prod_line = pl_prod_line no-lock.
               /* Items exist for this product line */
               {pxmsg.i &MSGNUM=203 &ERRORLEVEL=4}
               /* Existing item ...                 */
               {pxmsg.i &MSGNUM=204 &ERRORLEVEL=4 &MSGARG1=pt_part}
               undo set1, retry.
            end.

            /*CHECK FOR SALES ACCOUNTS USING PRODUCT LINE */
            else
            if can-find(first plsd_det
                        where plsd_prodline = pl_prod_line)
            then do:
               /* Delete not allowed, outstanding ...*/
               /* SALES ACCOUNT DETAIL */
               {pxmsg.i &MSGNUM=745 &ERRORLEVEL=4}
               undo set1, retry.
            end.

            /*CHECK FOR PRODUCT LINE DETAIL USING PRODUCT LINE */
            else
            if can-find(first pld_det
                        where pld_prodline = pl_prod_line)
            then do:
               /* Delete not allowed, outstanding ...*/
               /* INVENTORY ACCOUNT DETAIL */
               {pxmsg.i &MSGNUM=746 &ERRORLEVEL=4}
               undo set1, retry.
            end.

            /* CHECK FOR CHARGE/REVENUE PRODUCT LINE USE */
            find first fcc_mstr where fcc_prod_line = pl_prod_line
            no-lock no-error.
            if available fcc_mstr then do:
               if fcc_type = "C" then do:
                  {pxmsg.i &MSGNUM=1402 &ERRORLEVEL=3}
                  /* THIS CHARGE PRODUCT LINE MAY NOT BE DELETED */
                  undo set1, retry.
               end.
               else do:
                  {pxmsg.i &MSGNUM=1399 &ERRORLEVEL=3}
                  /* THIS REVENUE PRODUCT LINE MAY NOT BE DELETED */
                  undo set1, retry.
               end.
            end.  /* if available fcc_mstr */

            /* CHECK FOR PRODUCT LINES REFERRED TO BY SERVICE TYPES */
            find first sv_mstr where sv_prod_line = pl_prod_line
               no-lock no-error.
            if available sv_mstr then do:
               /* DELETE NOT ALLOWED */
               {pxmsg.i &MSGNUM=1021 &ERRORLEVEL=3}
               /* SERVICE TYPE # REFERS TO THIS PRODUCT LINE */
               {pxmsg.i &MSGNUM=1398 &ERRORLEVEL=1 &MSGARG1=sv_code}
               undo set1, retry.
            end.

            if prm-enabled then do:
               /* CHECK IF PRODUCT LINE REFERENCED ON A PROJECT */
               for first pjd_det fields(pjd_sub_nbr pjd_nbr) no-lock
                     where pjd_prod_line = pl_prod_line:
               end.
               if available pjd_det then do:
                  /* CANNOT DELETE. REFERENCED ON SUBPROJECT */
                  /* # OF PROJECT #                          */
                  {pxmsg.i &MSGNUM=3898 &ERRORLEVEL=3
                           &MSGARG1=pjd_sub_nbr
                           &MSGARG2=pjd_nbr}
                  undo set1, retry set1.
               end.
               for first pjs_mstr fields(pjs_line_disp pjs_nbr)
                     no-lock
                     where pjs_prod_line = pl_prod_line:
               end.
               if available pjs_mstr then do:
                  /* CANNOT DELETE. REFERENCED ON PROJECT */
                  /* LINE # OF PROJECT #                  */
                  {pxmsg.i &MSGNUM=3897 &ERRORLEVEL=3
                           &MSGARG1=pjs_line_disp
                           &MSGARG2=pjs_nbr}
                  undo set1, retry set1.
               end.
            end.

         end.   /* if lastkey... */
      end.  /* set1 */

      if del-yn then do:

         if using_cust_consignment or using_supplier_consignment then do:
            /*Delete the consignment accts for the product line*/
            /* ADDED INPUT PARAMETERS default_sub, default_cc, */
            /* override_sub AND override_cc AS 3RD, 4TH, 5TH   */
            /* AND 6TH INPUT PARAMETERS RESPECTIVELY           */
            {gprunmo.i
               &program = "ppplmtc.p"
               &module = "ACN"
               &param = """(input pl_prod_line,
                            input 4,
                            input default_sub,
                            input default_cc,
                            input override_sub,
                            input override_cc)"""}
         end. /* If using_cust_consignment*/

         if del-yn then delete pl_mstr.
         if del-yn then clear frame a.
         clear frame b.

         del-yn = no.
         next mainloop.

      end.

   end.  /*transaction - seta*/

   status input.

   plrecid = recid(pl_mstr).

   {&PPPLMT-P-TAG9}
   /* ADDED INPUT PARAMETERS default_sub, default_cc, */
   /* override_sub AND override_cc                    */
   {gprun.i ""xxplmta.p""
       "(input default_sub,
         input default_cc,
         input override_sub,
         input override_cc)"}

   hide frame c no-pause.
   hide frame d no-pause.
   hide frame e no-pause.

   if keyfunction(lastkey) <> "END-ERROR"  and
      keyfunction(lastkey) <> "."
   then do:

      /* ADDED INPUT PARAMETERS default_sub, default_cc, */
      /* override_sub AND override_cc AS 2ND, 3RD, 4TH   */
      /* AND 5TH PARAMETER RESPECTIVELY                  */
      {gprun.i ""ppplmtb.p""
         "(input plrecid,
           input default_sub,
           input default_cc,
           input override_sub,
           input override_cc)"}

      if using_cust_consignment or using_supplier_consignment then
         /*Update the consignment accts for the product line*/
         /* ADDED INPUT PARAMETERS default_sub, default_cc, */
         /* override_sub AND override_cc AS 3RD, 4TH, 5TH   */
         /* AND 6TH INPUT PARAMETERS RESPECTIVELY           */
         {gprunmo.i
            &program = "ppplmtc.p"
            &module = "ACN"
            &param = """(input pl_prod_line,
                         input 3,
                         input default_sub,
                         input default_cc,
                         input override_sub,
                         input override_cc)"""}
   end.

end.

status input.
