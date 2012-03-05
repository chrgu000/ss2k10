/* glinrp3.i - SUBROUTINE FOR GENERAL LEDGER INCOME STATEMENT REPORT    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*                    CONTAINS DEFINITION STATEMENTS                    */
/* REVISION: 7.0      LAST MODIFIED: 02/04/92   BY: JMS  *F146*         */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 03/18/98   BY: *J242*   Sachin Shah  */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: *L00S* AWe *        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan     */
/***************************************************************************/
/*!
This include file contains the definition statements used by the various
   subprograms that print the income statement report when "summarize
   sub-accounts" and/or "summarize cost centers" options are selected.
*/
/***************************************************************************/
/*J242* Added no-undo wherever missing for performance */
/* REVISION: 9.0SP4 LAST MODIFIED: 2005/07/10 BY: *SS - 20050710* Bill Jiang */


/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glinrp3_i_1 "使用预算金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp3_i_2 "抑制帐户号码"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp3_i_3 "汇总分帐户"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp3_i_4 "抑制有零余额的帐户"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp3_i_5 "汇总成本中心"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp3_i_6 "圆整至千元"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp3_i_7 "圆整至整数单位"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp3_i_8 "开始日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp3_i_9 "层次"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp3_i_10 "结束日期"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

      define shared variable glname like en_name no-undo.
      /* SS - 20050710 - B */
      /*
      define shared variable begdt like gltr_eff_dt
         label {&glinrp3_i_8} no-undo.
      define shared variable enddt like gltr_eff_dt label {&glinrp3_i_10} no-undo.
      */
      /* SS - 20050710 - E */
      define shared variable fiscal_yr like glc_year no-undo.
      define shared variable balance as decimal no-undo.
/*F058*/  define shared variable sub like sb_sub no-undo.
/*F058*/  define shared variable sub1 like sb_sub no-undo.
/*F058*/  define shared variable ctr like cc_ctr no-undo.
/*F058*/  define shared variable ctr1 like cc_ctr no-undo.
      define shared variable level as integer format ">9" initial 99
         label {&glinrp3_i_9} no-undo.
      define shared variable budgflag like mfc_logical
         label {&glinrp3_i_1} no-undo.
      define shared variable zeroflag like mfc_logical label
         {&glinrp3_i_4} no-undo.
      /* SS - 20050710 - B */
      /*
      define shared variable ccflag like mfc_logical label
         {&glinrp3_i_5} no-undo.
/*F058*/  define shared variable subflag like mfc_logical
/*F058*/     label {&glinrp3_i_3} no-undo.
      */
      /* SS - 20050710 - E */
      define shared variable prtflag like mfc_logical initial yes
         label {&glinrp3_i_2} no-undo.
      /* SS - 20050710 - B */
      /*
      define shared variable entity like en_entity no-undo.
      define shared variable entity1 like en_entity no-undo.
      */
      /* SS - 20050710 - E */
      define shared variable cname like glname no-undo.
      define shared variable yr_end as date no-undo.
      define shared variable ret like ac_code no-undo.
      define shared variable per_end like glc_per no-undo.
      define shared variable per_beg like glc_per no-undo.
      define shared variable rpt_curr like gltr_curr no-undo.
      define shared variable budgetcode like bg_code no-undo.
      define shared variable prt1000 like mfc_logical
         label {&glinrp3_i_6} no-undo.
/*F146*/  define shared variable roundcnts like mfc_logical
         label {&glinrp3_i_7} no-undo.
      define shared variable hdrstring as character format "x(8)" no-undo.
      define shared variable prtfmt as character format "x(30)" no-undo.
      define shared variable income like gltr_amt no-undo.
      define shared variable percent as decimal format "->>>>.9%" no-undo.
/*F058*/  define shared variable xacc like ac_code no-undo.
/*F058*/  define shared variable ac_recno as recid no-undo.
/*F058*/  define shared variable fm_recno as recid no-undo.
/*F058*/  define shared variable cur_level as integer no-undo.
/*F058*/  define shared variable fmbgflag like mfc_logical no-undo.
/*F146*/  define shared variable tot as decimal extent 100 no-undo.
/*F146*/  define shared variable totflag like mfc_logical extent 100
         no-undo.

      define variable balance1 like balance no-undo.
      define variable crtot like balance1 no-undo.
      define variable record as recid extent 100 no-undo.
      define variable fpos like fm_fpos no-undo.
      define variable i as integer no-undo.
      define variable knt as integer no-undo.
      define variable dt as date no-undo.
      define variable dt1 as date no-undo.
/*F058*/  define variable xsub like sb_sub no-undo.
/*F058*/  define variable xcc like cc_ctr no-undo.
/*F058*/  define variable account as character format "x(14)" no-undo.
/*F146*/  define variable amt as decimal no-undo.
          /* SS - 20050710 - B */
          define INPUT PARAMETER entity like en_entity no-undo.
          define INPUT PARAMETER entity1 like en_entity no-undo.
          define INPUT PARAMETER begdt like gltr_eff_dt no-undo.
          define INPUT PARAMETER enddt like gltr_eff_dt no-undo.
          define INPUT PARAMETER subflag like mfc_logical no-undo.
          define INPUT PARAMETER ccflag like mfc_logical no-undo.
          /* SS - 20050710 - E */

/*L00S - BEGIN ADD*/
        /* DEFINE EURO TOOLKIT VARIABLES */
        {etrpvar.i}
        {etvar.i}

        define     shared variable et_balance  like balance    no-undo.
        define            variable et_balance1 like et_balance no-undo.
        define     shared variable et_income   like income     no-undo.
        define     shared variable et_tot      like tot        no-undo.
/*L00S - END ADD*/
