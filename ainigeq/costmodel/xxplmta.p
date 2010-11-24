/* ppplmta.p - PRODUCT LINE MAINTENANCE CONTINUATION                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */

/* REVISION: 7.0      LAST MODIFIED: 04/15/92   BY: pma *F403* */
/* Revision: 7.3      Last Modified: 07/28/92   By: mpp *G009* */
/* REVISION: 7.5      LAST MODIFIED: 07/23/94   by: dzs *J030*/
/* Revision: 7.3      Last Modified: 03/01/95   By: srk *G0G4* */
/* Revision: 7.5      Last Modified: 07/22/95   By: ktn *J05X* */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton     */
/* REVISION: 9.1      LAST MODIFIED: 01/19/00   BY: *N077* Vijaya Pakala    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* REVISION: 9.1      LAST MODIFIED: 10/12/00   BY: *N0W9* BalbeerS Rajput  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.8.3.6     BY: Katie Hilbert    DATE: 04/01/01 ECO: *P002*    */
/* Revision: 1.8.3.7     BY: Niranjan R.      DATE: 07/12/01 ECO: *P00L*    */
/* Revision: 1.8.3.8     BY: Anil Sudhakaran  DATE: 11/28/01 ECO: *M1FK*    */
/* Revision: 1.8.3.10    BY: Rajaneesh S.     DATE: 01/17/03 ECO: *P0LZ*    */
/* Revision: 1.8.3.11    BY: Ed van de Gevel  DATE: 02/12/03 ECO:  *N26J*  */
/* $Revision: 1.8.3.11.3.1 $  BY: Russ Witt   DATE: 10/11/04 ECO:  *P2P4*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                            */

{mfdeclre.i}
{cxcustom.i "PPPLMTA.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ppplmta_p_5 "Default Sub-Account"
/* MaxLen: 24 Comment: */

&SCOPED-DEFINE ppplmta_p_6 "Default Cost Center"
/* MaxLen: 24 Comment: */

&SCOPED-DEFINE ppplmta_p_7 "Override"
/* MaxLen: 14 Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* CHANGED default_sub, default_cc, override_sub AND override_cc  */
/* TO INPUT VARIABLES FROM SHARED VARIABLES                       */
define input parameter default_sub as character no-undo
   label {&ppplmta_p_5}.
define input parameter default_cc as character format "x(4)" no-undo
   label {&ppplmta_p_6}.
define input parameter override_sub like mfc_logical no-undo
   label {&ppplmta_p_7}.
define input parameter override_cc like mfc_logical no-undo
   label {&ppplmta_p_7}.

define shared frame a.
define shared frame b.
define shared frame c.
define shared frame d.
define shared frame e.
define shared variable plrecid as recid.

define variable valid_acct like mfc_logical.

{gprunpdf.i "gpglvpl" "p"}

/* Variable added to perform delete during CIM.
 * Record is deleted only when the value of this variable
 * Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

find pl_mstr where recid(pl_mstr) = plrecid.

/* DISPLAY SELECTION FORM */
form
   pl_prod_line   colon 25
   batchdelete no-label colon 60
   pl_desc        colon 25 skip(1)
   pl_taxable     colon 25 
   pl__chr05      colon 50
   pl_taxc        colon 25 
   default_sub colon 25 override_sub  colon 50
   default_cc  colon 25 override_cc   colon 50
with frame a side-labels width 80
   attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/*INVENTORY FORM */
{&PPPLMTA-P-TAG1}
form
   pl_inv_acct    colon 25 pl_inv_sub  no-label pl_inv_cc      no-label
   pl_dscr_acct   colon 25 pl_dscr_sub no-label pl_dscr_cc     no-label
   pl_scrp_acct   colon 25 pl_scrp_sub no-label pl_scrp_cc     no-label
   pl_cchg_acct   colon 25 pl_cchg_sub no-label pl_cchg_cc     no-label
with frame b side-labels width 80 title color normal
   (getFrameTitle("INVENTORY_ACCOUNTS",26)) attr-space.
{&PPPLMTA-P-TAG2}

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
with frame c side-labels width 80 title color normal
   (getFrameTitle("SALES_ACCOUNTS",21)) attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

/* PURCHASING FORM */
form
   pl_pur_acct    colon 25 pl_pur_sub  no-label pl_pur_cc      no-label
   pl_rcpt_acct   colon 25 pl_rcpt_sub no-label pl_rcpt_cc     no-label
   pl_ovh_acct    colon 25 pl_ovh_sub  no-label pl_ovh_cc      no-label
   pl_ppv_acct    colon 25 pl_ppv_sub  no-label pl_ppv_cc      no-label
   pl_apvu_acct   colon 25 pl_apvu_sub no-label pl_apvu_cc     no-label
   pl_apvr_acct   colon 25 pl_apvr_sub no-label pl_apvr_cc     no-label
with frame d side-labels width 80 title color normal
   (getFrameTitle("PURCHASING_ACCOUNTS",28)) attr-space.

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
with frame e side-labels width 80 title color normal
   (getFrameTitle("WORK_ORDER_ACCOUNTS",28)) attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame e:handle).

/* DISPLAY */

if override_sub then
display
   default_sub @ pl_inv_sub
   default_sub @ pl_dscr_sub
   default_sub @ pl_scrp_sub
   default_sub @ pl_cchg_sub
   {&PPPLMTA-P-TAG6}
with frame b.
else
display
   pl_inv_sub
   pl_dscr_sub
   pl_scrp_sub
   pl_cchg_sub
with frame b.
if override_cc then
display
   default_cc @ pl_inv_cc
   default_cc @ pl_dscr_cc
   default_cc @ pl_scrp_cc
   default_cc @ pl_cchg_cc
   {&PPPLMTA-P-TAG7}
with frame b.
else
display
   pl_inv_cc
   pl_dscr_cc
   pl_scrp_cc
   pl_cchg_cc
with frame b.

setb:
do transaction with frame b on error undo, retry:
   {&PPPLMTA-P-TAG3}
   set
      pl_inv_acct
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
      pl_cchg_cc.
   {&PPPLMTA-P-TAG4}

   /* ACCT/SUB/CC VALIDATION */
   run ip-validate
      (input pl_inv_acct, input pl_inv_sub, input pl_inv_cc).

   if valid_acct = no then do:
      next-prompt pl_inv_acct with frame b.
      undo, retry.
   end.

   run ip-validate
      (input pl_dscr_acct, input pl_dscr_sub, input pl_dscr_cc).

   if valid_acct = no then do:
      next-prompt pl_dscr_acct with frame b.
      undo, retry.
   end.

   run ip-validate
      (input pl_scrp_acct, input pl_scrp_sub, input pl_scrp_cc).

   if valid_acct = no then do:
      next-prompt pl_scrp_acct with frame b.
      undo, retry.
   end.

   run ip-validate
      (input pl_cchg_acct, input pl_cchg_sub, input pl_cchg_cc).

   if valid_acct = no then do:
      next-prompt pl_cchg_acct with frame b.
      undo, retry.
   end.
   {&PPPLMTA-P-TAG5}

end.

hide frame b.
view frame c.

display
   pl_sls_acct
   pl_dsc_acct
   pl_cmtl_acct
   pl_clbr_acct
   pl_cbdn_acct
   pl_covh_acct
   pl_csub_acct
with frame c.
if override_sub then
display
   default_sub @ pl_sls_sub
   default_sub @ pl_dsc_sub
   default_sub @ pl_cmtl_sub
   default_sub @ pl_clbr_sub
   default_sub @ pl_cbdn_sub
   default_sub @ pl_covh_sub
   default_sub @ pl_csub_sub
with frame c.
else
display
   pl_sls_sub
   pl_dsc_sub
   pl_cmtl_sub
   pl_clbr_sub
   pl_cbdn_sub
   pl_covh_sub
   pl_csub_sub
with frame c.
if override_cc then
display
   default_cc @ pl_sls_cc
   default_cc @ pl_dsc_cc
   default_cc @ pl_cmtl_cc
   default_cc @ pl_clbr_cc
   default_cc @ pl_cbdn_cc
   default_cc @ pl_covh_cc
   default_cc @ pl_csub_cc
with frame c.
else
display
   pl_sls_cc
   pl_dsc_cc
   pl_cmtl_cc
   pl_clbr_cc
   pl_cbdn_cc
   pl_covh_cc
   pl_csub_cc
with frame c.

setc:

do transaction with frame c on error undo, retry
      on endkey undo, return:
   set
      pl_sls_acct
      pl_sls_sub
      pl_sls_cc
      pl_dsc_acct
      pl_dsc_sub
      pl_dsc_cc
      pl_cmtl_acct
      pl_cmtl_sub
      pl_cmtl_cc
      pl_clbr_acct
      pl_clbr_sub
      pl_clbr_cc
      pl_cbdn_acct
      pl_cbdn_sub
      pl_cbdn_cc
      pl_covh_acct
      pl_covh_sub
      pl_covh_cc
      pl_csub_acct
      pl_csub_sub
      pl_csub_cc.

   /* ACCT/SUB/CC VALIDATION */
   run ip-validate
      (input pl_sls_acct, input pl_sls_sub, input pl_sls_cc).

   if valid_acct = no then do:
      next-prompt pl_sls_acct with frame c.
      undo, retry.
   end.

   run ip-validate
      (input pl_dsc_acct, input pl_dsc_sub, input pl_dsc_cc).

   if valid_acct = no then do:
      next-prompt pl_dsc_acct with frame c.
      undo, retry.
   end.

   run ip-validate
      (input pl_cmtl_acct, input pl_cmtl_sub, input pl_cmtl_cc).

   if valid_acct = no then do:
      next-prompt pl_cmtl_acct with frame c.
      undo, retry.
   end.

   run ip-validate
      (input pl_clbr_acct, input pl_clbr_sub, input pl_clbr_cc).

   if valid_acct = no then do:
      next-prompt pl_clbr_acct with frame c.
      undo, retry.
   end.

   run ip-validate
      (input pl_cbdn_acct, input pl_cbdn_sub, input pl_cbdn_cc).

   if valid_acct = no then do:
      next-prompt pl_cbdn_acct with frame c.
      undo, retry.
   end.

   run ip-validate
      (input pl_covh_acct, input pl_covh_sub, input pl_covh_cc).

   if valid_acct = no then do:
      next-prompt pl_covh_acct with frame c.
      undo, retry.
   end.

   run ip-validate
      (input pl_csub_acct, input pl_csub_sub, input pl_csub_cc).

   if valid_acct = no then do:
      next-prompt pl_csub_acct with frame c.
      undo, retry.
   end.

end.

hide frame c.
view frame d.

display
   pl_pur_acct
   pl_rcpt_acct
   pl_ovh_acct
   pl_ppv_acct
   pl_apvu_acct
   pl_apvr_acct
with frame d.
if override_sub then
display
   default_sub @ pl_pur_sub
   default_sub @ pl_rcpt_sub
   default_sub @ pl_ovh_sub
   default_sub @ pl_ppv_sub
   default_sub @ pl_apvu_sub
   default_sub @ pl_apvr_sub
with frame d.
else
display
   pl_pur_sub
   pl_rcpt_sub
   pl_ovh_sub
   pl_ppv_sub
   pl_apvu_sub
   pl_apvr_sub
with frame d.
if override_cc then
display
   default_cc @ pl_pur_cc
   default_cc @ pl_rcpt_cc
   default_cc @ pl_ovh_cc
   default_cc @ pl_ppv_cc
   default_cc @ pl_apvu_cc
   default_cc @ pl_apvr_cc
with frame d.
else
display
   pl_pur_cc
   pl_rcpt_cc
   pl_ovh_cc
   pl_ppv_cc
   pl_apvu_cc
   pl_apvr_cc
with frame d.

setd:

do transaction with frame d on error undo, retry
      on endkey undo, return:
   set
      pl_pur_acct
      pl_pur_sub
      pl_pur_cc
      pl_rcpt_acct
      pl_rcpt_sub
      pl_rcpt_cc
      pl_ovh_acct
      pl_ovh_sub
      pl_ovh_cc
      pl_ppv_acct
      pl_ppv_sub
      pl_ppv_cc
      pl_apvu_acct
      pl_apvu_sub
      pl_apvu_cc
      pl_apvr_acct
      pl_apvr_sub
      pl_apvr_cc.

   /* ACCT/SUB/CC VALIDATION */
   run ip-validate
      (input pl_pur_acct, input pl_pur_sub, input pl_pur_cc).

   if valid_acct = no then do:
      next-prompt pl_pur_acct with frame d.
      undo, retry.
   end.

   run ip-validate
      (input pl_rcpt_acct, input pl_rcpt_sub, input pl_rcpt_cc).

   if valid_acct = no then do:
      next-prompt pl_rcpt_acct with frame d.
      undo, retry.
   end.

   run ip-validate
      (input pl_ovh_acct, input pl_ovh_sub, input pl_ovh_cc).

   if valid_acct = no then do:
      next-prompt pl_ovh_acct with frame d.
      undo, retry.
   end.

   run ip-validate
      (input pl_ppv_acct, input pl_ppv_sub, input pl_ppv_cc).

   if valid_acct = no then do:
      next-prompt pl_ppv_acct with frame d.
      undo, retry.
   end.

   run ip-validate
      (input pl_apvu_acct, input pl_apvu_sub, input pl_apvu_cc).

   if valid_acct = no then do:
      next-prompt pl_apvu_acct with frame d.
      undo, retry.
   end.

   run ip-validate
      (input pl_apvr_acct, input pl_apvr_sub, input pl_apvr_cc).

   if valid_acct = no then do:
      next-prompt pl_apvr_acct with frame d.
      undo, retry.
   end.

end.

hide frame d.

/* ADDED INPUT PARAMETERS default_sub, default_cc, */
/* override_sub AND override_cc                    */
{gprun.i ""ppplmte.p""
    "(input default_sub,
      input default_cc,
      input override_sub,
      input override_cc)"}

PROCEDURE ip-validate:
   define input parameter ip-acct as character no-undo.
   define input parameter ip-sub  as character no-undo.
   define input parameter ip-cc   as character no-undo.

   /* INITIALIZE SETTINGS */
   {gprunp.i "gpglvpl" "p" "initialize"}
   /* SET PROJECT VERIFICATION TO NO */
   {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}
   /* ACCT/SUB/CC VALIDATION */
   {gprunp.i "gpglvpl" "p" "validate_fullcode"
      "(input ip-acct,
        input ip-sub,
        input ip-cc,
        input """",
        output valid_acct)"}

END PROCEDURE.  /* ip-validate */
