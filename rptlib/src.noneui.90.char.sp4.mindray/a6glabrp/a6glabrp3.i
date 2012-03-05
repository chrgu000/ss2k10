/* glabrp3.i - SUBROUTINE FOR GENERAL LEDGER ACCOUNT BALANCE REPORT          */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*F0PN*/ /*V8:ConvertMode=Report                                             */
/*                    CONTAINS DEFINITION STATEMENTS                         */
/* REVISION: 7.0      LAST MODIFIED: 01/29/92   BY: JMS  *F107*              */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/*           7.4                     07/13/93   by: skk  *H026* sub/cc descrp*/
/*           7.4                     02/13/95   by: str  *F0HY*              */
/* REVISION: 8.6E     LAST MODIFIED: 03/19/98   BY: *J240* Kawal Batra       */
/* REVISION: 8.6E     LAST MODIFIED: 24 apr 98  BY: *L00M* D. Sidel          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */

/***************************************************************************/
/*!
This include file contains the definition statements used by the various
   subprograms that print the account balance report when "summarize
   sub-accounts" and/or "summarize cost centers" options are selected.
*/
/***************************************************************************/
/*J240********** ADDED NO-UNDO WHEREVER MISSING  *******J240*/

/*H026*/  /* save the first-of (asc...) status to process latter */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glabrp3_i_1 "汇总分帐户"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabrp3_i_2 "汇总成本中心"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*H026*/  define shared variable first_acct like mfc_logical  no-undo.
/*H026*/  define shared variable first_sub like mfc_logical  no-undo.
/*H026*/  define shared variable first_cc like mfc_logical  no-undo.

      define shared variable begdtxx as date  no-undo.
      define shared variable beg_tot as decimal
         format ">>,>>>,>>>,>>>,>>9.99cr"  no-undo.
      define shared variable per_tot like beg_tot  no-undo.
      define shared variable end_tot like beg_tot  no-undo.
      define shared variable glname like en_name  no-undo.
      define shared variable per as integer  no-undo.
      define shared variable per1 as integer  no-undo.
      define shared variable yr as integer  no-undo.
      /* SS - Bill - B 2005.06.02 */
      /*
      define shared variable begdt like gltr_eff_dt  no-undo.
      define shared variable enddt like gltr_eff_dt  no-undo.
      */
      DEFINE INPUT-OUTPUT PARAMETER output_et_beg_bal AS DECIMAL NO-UNDO.
      DEFINE INPUT-OUTPUT PARAMETER output_et_end_bal AS DECIMAL NO-UNDO.
      DEFINE INPUT PARAMETER begdt LIKE gltr_eff_dt NO-UNDO.
      DEFINE INPUT PARAMETER enddt LIKE gltr_eff_dt NO-UNDO.
      /* SS - Bill - E */
      define shared variable yr_beg as date  no-undo.
      define shared variable yr_end as date  no-undo.
      /* SS - Bill - B 2005.06.02 */
      /*
      define shared variable acc like ac_code  no-undo.
      define shared variable acc1 like ac_code  no-undo.
      define shared variable sub like sb_sub  no-undo.
      define shared variable sub1 like sb_sub  no-undo.
      define shared variable ctr like cc_ctr  no-undo.
      define shared variable ctr1 like cc_ctr  no-undo.
      define shared variable ccflag like mfc_logical
         label {&glabrp3_i_2}  no-undo.
      define shared variable subflag like mfc_logical
         label {&glabrp3_i_1}  no-undo.
      define shared variable entity like gltr_entity  no-undo.
      define shared variable entity1 like gltr_entity  no-undo.
      */
      DEFINE INPUT PARAMETER acc LIKE ac_code NO-UNDO.
      DEFINE INPUT PARAMETER acc1 LIKE ac_code NO-UNDO.
      DEFINE INPUT PARAMETER sub LIKE sb_sub NO-UNDO.
      DEFINE INPUT PARAMETER sub1 LIKE sb_sub NO-UNDO.
      DEFINE INPUT PARAMETER ctr LIKE cc_ctr NO-UNDO.
      DEFINE INPUT PARAMETER ctr1 LIKE cc_ctr NO-UNDO.
      define shared variable ccflag like mfc_logical
         label {&glabrp3_i_2}  INIT YES no-undo.
      define shared variable subflag like mfc_logical
         label {&glabrp3_i_1}  INIT YES no-undo.
      DEFINE INPUT PARAMETER entity LIKE gltr_entity NO-UNDO.
      DEFINE INPUT PARAMETER entity1 LIKE gltr_entity NO-UNDO.
      /* SS - Bill - E */
      define shared variable cname like glname  no-undo.
      define shared variable ret like ac_code  no-undo.
      define shared variable rpt_curr like gltr_curr  no-undo.

      define variable beg_bal like beg_tot  no-undo.
      define variable end_bal like beg_tot  no-undo.
      define variable per_act like beg_tot  no-undo.
      define variable act_to_dt like beg_tot  no-undo.
      define variable begdt1 like gltr_eff_dt  no-undo.
      define variable enddt1 like gltr_eff_dt  no-undo.
      define variable knt as integer  no-undo.
      define variable dt as date  no-undo.
      define variable dt1 as date  no-undo.
      define variable account as character format "x(14)"  no-undo.
      define variable perknt as integer  no-undo.
      define variable amt as decimal  no-undo.
      define variable peramt as decimal extent 100  no-undo.
      define variable xknt as integer extent 100  no-undo.
/*F0HY*/  define variable print_acct as logical no-undo.

      define buffer cal for glc_cal.
      define buffer a1 for asc_mstr.

/*L00M*ADD SECTION*/
            {etvar.i}   /* common euro variables */
            {etrpvar.i} /* common euro report variables */
            define shared variable et_beg_tot   like beg_tot.
            define shared variable et_per_tot   like per_tot.
            define shared variable et_end_tot   like end_tot.
            define        variable et_beg_bal   like beg_bal.
            define        variable et_end_bal   like end_bal.
            define        variable et_act_to_dt like act_to_dt.
            define        variable et_per_act   like per_act.

            if not available gl_ctrl then find first gl_ctrl no-lock.
/*L00M*END ADD SECTION*/
