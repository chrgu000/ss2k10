/* ppplrp.p - PRODUCT LINE REPORT                                       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.5.2.12 $                                               */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 6.0      LAST MODIFIED: 04/20/90   BY: PML                 */
/* REVISION: 6.0      LAST MODIFIED: 08/02/91   BY: bjb *D811*          */
/* REVISION: 7.0      LAST MODIFIED: 08/21/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 05/26/92   BY: pma *F529*          */
/* REVISION: 7.0      LAST MODIFIED: 08/27/94   BY: rxm *GL58*          */
/* REVISION: 7.5      LAST MODIFIED: 08/31/94   BY: dzs *J030*          */
/* REVISION: 8.5      LAST MODIFIED: 08/02/95   BY: *J04C*  Sue Poland  */
/* REVISION: 8.6      LAST MODIFIED: 10/08/97   BY: mzv *K0NJ*          */
/* REVISION: 9.1      LAST MODIFIED: 08/18/99   BY: *N014* Patti Gaultney */
/* REVISION: 9.1      LAST MODIFIED: 02/11/00   BY: *N07Z* Vijaya Pakala  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KQ* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                */
/* REVISION: 9.1      LAST MODIFIED: 09/27/00 BY: *N0W9* Mudit Mehta      */
/* Revision: 1.5.2.7   BY: Niranjan R.  DATE: 07/12/01 ECO: *P00L*   */
/* Revision: 1.5.2.10  BY: Niranjan R.  DATE: 03/13/02 ECO: *P020*   */
/* $Revision: 1.5.2.12 $  BY: Ellen Borden   DATE: 03/22/01 ECO: *P00G* */
/* $Revision: 1.5.2.12 $  BY: Bill Jiang   DATE: 12/12/05 ECO: *SS - 20051212* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20051212 - B */
{a6ppplrp.i "new"}
/* SS - 20051212 - E */
                                                                             
{mfdtitle.i "b+ "}
{cxcustom.i "PPPLRP.P"}
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ppplrp_p_1 "Inventory"
/* MaxLen:18 Comment: */

&SCOPED-DEFINE ppplrp_p_2 "Inv Discrep"
/* MaxLen:20 Comment: Inventory Discrepency */

&SCOPED-DEFINE ppplrp_p_3 "Scrap"
/* MaxLen:19 Comment: */

&SCOPED-DEFINE ppplrp_p_4 "Work in Process"
/* MaxLen:18 Comment: */

&SCOPED-DEFINE ppplrp_p_5 "Method Variance"
/* MaxLen:20 Comment: Method Variance */

&SCOPED-DEFINE ppplrp_p_6 "Cost Revalue"
/* MaxLen:19 Comment: */

&SCOPED-DEFINE ppplrp_p_7 "Sales"
/* MaxLen:18 Comment: */

&SCOPED-DEFINE ppplrp_p_8 "Sales Disc"
/* MaxLen:20 Comment: Sales Discount*/

&SCOPED-DEFINE ppplrp_p_9 "Exempt Sales"
/* MaxLen:19 Comment: */

&SCOPED-DEFINE ppplrp_p_10 "COGS Material"
/* MaxLen:18 Comment: Cost of Goods Sold Material */

&SCOPED-DEFINE ppplrp_p_11 "COGS Labor"
/* MaxLen:20 Comment: Cost of Goods Sold Labor */

&SCOPED-DEFINE ppplrp_p_12 "COGS Burden"
/* MaxLen:19 Comment: Cost of Goods Sold Burden */

&SCOPED-DEFINE ppplrp_p_13 "COGS Overhead"
/* MaxLen:18 Comment: Cost of Goods Sold Overhead */

&SCOPED-DEFINE ppplrp_p_14 "COGS Subcontract"
/* MaxLen:20 Comment: Cost of Goods Sold Subcontract */

&SCOPED-DEFINE ppplrp_p_15 "Purchases"
/* MaxLen:18 Comment: */

&SCOPED-DEFINE ppplrp_p_16 "PO Receipts"
/* MaxLen:20 Comment: Purchase Order Receipts */

&SCOPED-DEFINE ppplrp_p_17 "Overhead Appl"
/* MaxLen:19 Comment: Overhead Application */

&SCOPED-DEFINE ppplrp_p_18 "PO Price Var"
/* MaxLen:18 Comment: Purchase Order Price Variance */

&SCOPED-DEFINE ppplrp_p_19 "AP Usage Var"
/* MaxLen:20 Comment: Accounts Payable Usage Variance */

&SCOPED-DEFINE ppplrp_p_20 "AP Rate Var"
/* MaxLen:19 Comment: Accounts Payable Rate Variance */

&SCOPED-DEFINE ppplrp_p_21 "Floor Stock"
/* MaxLen:18 Comment: */

&SCOPED-DEFINE ppplrp_p_22 "Sub Usage Var"
/* MaxLen:20 Comment: Subcontract Usage Variance */

&SCOPED-DEFINE ppplrp_p_23 "Sub Rate Var"
/* MaxLen:19 Comment: Subcontract Rate Variance */

/* ********** End Translatable Strings Definitions ********* */

define variable line1 like pl_prod_line.
define variable line2 like pl_prod_line.

/* CONSIGNMENT VARIABLES. */
{socnvars.i}

define variable ENABLE_SUPPLIER_CONSIGNMENT as character
                  initial "enable_supplier_consignment"     no-undo.
define variable SUPPLIER_CONSIGNMENT        as character
                  initial "supplier_consignment"            no-undo.
define variable SUPPLIER_CONSIGN_CTRL_TABLE as character
                  initial "cns_ctrl"                        no-undo.
define variable using_supplier_consignment like mfc_logical no-undo.

/* SELECT FORM */
form
   line1          colon 15
   line2          colon 49 label {t001.i}

with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */

{wbrp01.i}
repeat:

   if line2 = hi_char then line2 = "".

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

   if c-application-mode <> 'web' then
      update line1 line2 with frame a.

   {wbrp06.i &command = update &fields = "  line1 line2" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i line1 }
      {mfquoter.i line2 }

      if line2 = "" then line2 = hi_char.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
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

   /* SS - 20051212 - B */
   /*
   {mfphead.i}

   for each pl_mstr where (pl_prod_line >= line1)
         and (pl_prod_line <= line2)
         no-lock with frame b width 132
         no-attr-space:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
      {&PPPLRP-P-TAG1}
      display

         /* INVENTORY */
         pl_prod_line  pl_desc skip
         pl_inv_acct   colon  19  label    {&ppplrp_p_1}
         pl_inv_sub    at     30  no-label
         pl_inv_cc     at     39  no-label
         pl_dscr_acct  colon  64  label    {&ppplrp_p_2}
         pl_dscr_sub   at     75  no-label
         pl_dscr_cc    at     84  no-label
         pl_scrp_acct  colon 107  label    {&ppplrp_p_3}
         pl_scrp_sub   at    118  no-label
         pl_scrp_cc    at    127  no-label skip
         pl_cchg_acct  colon 19   label    {&ppplrp_p_6}
         pl_cchg_sub   at    30   no-label
         pl_cchg_cc    at    39   no-label skip(1)

         /* SALES */
         pl_sls_acct   colon  19  label    {&ppplrp_p_7}
         pl_sls_sub    at     30  no-label
         pl_sls_cc     at     39  no-label
         pl_dsc_acct   colon  64  label    {&ppplrp_p_8}
         pl_dsc_sub    at     75  no-label
         pl_dsc_cc     at     84  no-label
         pl_esls_acct  colon 107  label    {&ppplrp_p_9}
         pl_esls_cc    at    127  no-label skip
         pl_cmtl_acct  colon  19  label    {&ppplrp_p_10}
         pl_cmtl_sub   at     30  no-label
         pl_cmtl_cc    at     39  no-label
         pl_clbr_acct  colon  64  label    {&ppplrp_p_11}
         pl_clbr_sub   at     75  no-label
         pl_clbr_cc    at     84  no-label
         pl_cbdn_acct  colon 107  label    {&ppplrp_p_12}
         pl_cbdn_sub   at    118  no-label
         pl_cbdn_cc    at    127  no-label skip
         pl_covh_acct  colon  19  label    {&ppplrp_p_13}
         pl_covh_sub   at     30  no-label
         pl_covh_cc    at     39  no-label
         pl_csub_acct  colon  64  label    {&ppplrp_p_14}
         pl_csub_sub   at     75  no-label
         pl_csub_cc    at     84  no-label skip(1)

         /* PURCHASING */
         pl_pur_acct   colon  19  label    {&ppplrp_p_15}
         pl_pur_sub    at     30  no-label
         pl_pur_cc     at     39  no-label
         pl_rcpt_acct  colon  64  label    {&ppplrp_p_16}
         pl_rcpt_sub   at     75  no-label
         pl_rcpt_cc    at     84  no-label
         pl_ovh_acct   colon 107  label    {&ppplrp_p_17}
         pl_ovh_sub    at    118  no-label
         pl_ovh_cc     at    127  no-label skip
         pl_ppv_acct   colon  19  label    {&ppplrp_p_18}
         pl_ppv_sub    at     30  no-label
         pl_ppv_cc     at     39  no-label
         pl_apvu_acct  colon  64  label    {&ppplrp_p_19}
         pl_apvu_sub   at     75  no-label
         pl_apvu_cc    at     84  no-label
         pl_apvr_acct  colon 107  label    {&ppplrp_p_20}
         pl_apvr_sub   at    118  no-label
         pl_apvr_cc    at    127  no-label skip(1)

         /*WORK ORDERS*/
         pl_flr_acct   colon  19  label    {&ppplrp_p_21}
         pl_flr_sub    at     30  no-label
         pl_flr_cc     at     39  no-label
         pl_mvar_acct  colon  64
         pl_mvar_sub   at     75  no-label
         pl_mvar_cc    at     84  no-label
         pl_mvrr_acct  colon 107
         pl_mvrr_sub   at    118  no-label
         pl_mvrr_cc    at    127  no-label skip
         pl_cop_acct   colon  19
         pl_cop_sub    at     30  no-label
         pl_cop_cc     at     39  no-label
         pl_svar_acct  colon  64  label    {&ppplrp_p_22}
         pl_svar_sub   at     75  no-label
         pl_svar_cc    at     84  no-label
         pl_svrr_acct  colon 107  label    {&ppplrp_p_23}
         pl_svrr_sub   at    118  no-label
         pl_svrr_cc    at    127  no-label skip
         pl_xvar_acct  colon  19
         pl_xvar_sub   at     30  no-label
         pl_xvar_cc    at     39  no-label
         pl_wip_acct   colon  64  label    {&ppplrp_p_4}
         pl_wip_sub    at     75  no-label
         pl_wip_cc     at     84  no-label
         pl_wvar_acct  colon  107 label    {&ppplrp_p_5}
         pl_wvar_sub   at     118 no-label
         pl_wvar_cc    at     127 no-label skip(1)

         /* SERVICE ACCOUNTS */
         pl_fslbr_acct colon  19
         pl_fslbr_sub  at     30  no-label
         pl_fslbr_cc   at     39  no-label
         pl_rmar_acct  colon  64
         pl_rmar_sub   at     75  no-label
         pl_rmar_cc    at     84  no-label
         pl_fsbdn_acct colon  19
         pl_fsbdn_sub  at     30  no-label
         pl_fsbdn_cc   at     39  no-label
         pl_fsexd_acct colon  64
         pl_fsexd_sub  at     75  no-label
         pl_fsexd_cc   at     84  no-label
         pl_fsexp_acct colon  19
         pl_fsexp_sub  at     30  no-label
         pl_fsexp_cc   at     39  no-label
         pl_fsdef_acct colon  64
         pl_fsdef_sub  at     75  no-label
         pl_fsdef_cc   at     84  no-label
         pl_fsaccr_acct colon 19
         pl_fsaccr_sub  at    30  no-label
         pl_fsaccr_cc   at    39  no-label skip(1)
      with side-labels.
      {&PPPLRP-P-TAG2}



      if using_cust_consignment or using_supplier_consignment then do:
         {gprunmo.i
             &program = "pppliqa.p"
             &module = "ACN"
             &param = """(input pl_prod_line,
                          input "''",
                          input "''",
                          input 1)"""}
      end.

      for each pld_det where (pld_prodline = pl_prod_line)
            no-lock with frame c width 132 no-attr-space:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame c:handle).
         display
            pld_site     colon  19
            pld_loc      colon  64 skip
            pld_inv_acct colon  19
            pld_inv_sub  at     30 no-label
            pld_inv_cc   at     39 no-label
            pld_dscracct colon  64
            pld_dscr_sub at     75 no-label
            pld_dscr_cc  at     84 no-label
            pld_scrpacct colon 107
            pld_scrp_sub at    118 no-label
            pld_scrp_cc  at    127 no-label
            pld_cchg_acc colon  19
            pld_cchg_sub at     30 no-label
            pld_cchg_cc  at     39 no-label skip(1)
         with side-labels.
         if using_cust_consignment or using_supplier_consignment then do:
             {gprunmo.i
             &program = "pppliqa.p"
             &module = "ACN"
             &param = """(input pld_prodline,
                          input pld_site,
                          input pld_loc,
                          input 2)"""}
/*P00G*/ end.
         {mfrpexit.i "false"}
      end.

      {mfrpchk.i}
   end.

   /* REPORT TRAILER  */
   {mfrtrail.i}
   */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   FOR EACH tta6ppplrp:
       DELETE tta6ppplrp.
   END.

    {gprun.i ""a6ppplrp.p"" "(
        INPUT line1,
        INPUT line2
        )"}

    EXPORT DELIMITER ";" "prod_line" "desc" "_chr01" "_chr02" "_chr03" "_chr04" "_chr05".
    FOR EACH tta6ppplrp:
        EXPORT DELIMITER ";" tta6ppplrp.
    END.

    PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

    {a6mfrtrail.i}
   /* SS - 20051212 - E */

end.

{wbrp04.i &frame-spec = a}
