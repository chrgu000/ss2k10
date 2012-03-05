/* gl4inrp.p - GENERAL LEDGER 4-COLUMN INCOME STATEMENT                      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*F0PN*/ /*K0S5*/ /*                                                         */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 4.0      LAST MODIFIED: 06/09/88   BY: JMS  **A275**            */
/*                                   09/23/88   by: jms  **A454** (rev only) */
/*                                   10/10/88   by: jms  **A477** (rev only) */
/*                                   11/08/88   by: jms  **A526**            */
/* REVISION: 5.0      LAST MODIFIED: 04/26/89   BY: JMS  **B066**            */
/*                                   06/19/89   by: jms  **B154** (rev only) */
/*                                   09/19/89   by: jms  **B135**            */
/*                                   10/08/89   by: jms  **A789** (rev only) */
/*                                   11/21/89   by: jms  **B400** (rev only) */
/*                                   02/14/90   by: jms  **B499** (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 10/15/90   by: jms  **D034**            */
/*                                   10/17/90   by: jms  **D103**            */
/*              (this portion of program split into glinrp1.p and glinrp1c.p)*/
/*                                   11/07/90   by: jms  **D189**            */
/*                                   02/07/91   by: jms  **D330**            */
/*                                   04/04/91   by: jms  **D491**            */
/*                                   04/04/91   by: jms  **D493** (rev only) */
/*                                   07/23/91   by: jms  **D791** (rev only) */
/*                                   09/05/91   by: jms  **D849** (rev only) */
/*                                   09/11/91   by: jms  **D857**            */
/* REVISION: 7.0      LAST MODIFIED: 01/24/92   by: jms  **F058**            */
/*                                   02/04/92   by: jms  **F146**            */
/*                                   02/25/92   by: jms  **F231**            */
/*                                   06/24/92   by: jms  **F702**            */
/* REVISION: 7.3      LAST MODIFIED: 08/24/92   by: mpp  **G030** (rev only) */
/*                                   09/15/92   by: jms  **F890** (rev only) */
/*                                   01/07/93   by: mpp  **G479**            */
/*                                   02/25/93   by: skk  **G748**            */
/*                                   10/21/93   by: jms  **GG57**            */
/*                                   12/20/93   by: srk  **GI13**            */
/*                                   09/03/94   by: srk  **FQ80**            */
/*                                   04/19/95   by: srk  **G0L1**            */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   by: ays  **K0S5**            */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 03/12/98   by: *J23W* Sachin Shah       */
/* REVISION: 8.6E     LAST MODIFIED: 04/24/98   BY: *L00M* D. Sidel          */
/* REVISION: 8.6E     LAST MODIFIED: 05/14/98   BY: *L010* AWe               */
/* REVISION: 8.6E     LAST MODIFIED: 06/04/98   BY: *K1RK* Mohan CK          */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01W* Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 08/13/98   BY: *H1MY* Prashanth Narayan */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00 BY: *N0L1* Mark Brown          */
/* REVISION: 9.1      LAST MODIFIED: 08/31/00 BY: *N0QF* Mudit Mehta         */
/* REVISION: 9.1      LAST MODIFIED: 09/13/05 BY: *SS - 20050913* Bill Jiang         */

/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO
 WHEREVER MISSING FOR PERFORMANCE AND SMALLER R-CODE */
 
/* SS - 20050913 - B */
define input parameter i_entity like en_entity.
define input parameter i_entity1 like en_entity.
define input parameter begdt01 as date.
define input parameter begdt02 as date.
define input parameter begdt03 as date.
define input parameter begdt04 as date.
define input parameter enddt01 as date.
define input parameter enddt02 as date.
define input parameter enddt03 as date.
define input parameter enddt04 as date.
define input parameter budget01 like mfc_logical.
define input parameter budget02 like mfc_logical.
define input parameter budget03 like mfc_logical.
define input parameter budget04 like mfc_logical.
define input parameter budgetcode01 like bg_code.
define input parameter budgetcode02 like bg_code.
define input parameter budgetcode03 like bg_code.
define input parameter budgetcode04 like bg_code.
define input parameter i_et_report_curr  like exr_curr1.
/* SS - 20050913 - E */

/*L00M*  {mfdtitle.i "b+ "}        */
/* SS - 20050913 - B */
/*
/*L00M*/ {mfdtitle.i "b+ "}
    */
    /*L00M*/ {a6mfdtitle.i "b+ "}
    /* SS - 20050913 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE gl4inrp_p_1 "Level"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl4inrp_p_2 "Budget Code"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl4inrp_p_5 "Column 1 -- Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl4inrp_p_7 "Master Comment Reference"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl4inrp_p_8 "Comment Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl4inrp_p_9 "Column 4 -- Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl4inrp_p_10 "Column 3 -- Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl4inrp_p_11 "Column 2 -- Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl4inrp_p_13 "Print Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl4inrp_p_14 "Round to Nearest Thousand"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl4inrp_p_15 "Use Budgets"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl4inrp_p_16 "Summarize CC"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl4inrp_p_17 "Summarize Sub"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl4inrp_p_18 "Suppress Zero Amounts"
/* MaxLen: Comment: */

/*N0QF***********BEGIN COMMENTING*************
 * &SCOPED-DEFINE gl4inrp_p_3 "% of"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE gl4inrp_p_4 "Income"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE gl4inrp_p_6 " Budget"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE gl4inrp_p_12 "Activity"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE gl4inrp_p_19 "(In 1000's "
 * /* MaxLen: Comment: */
 *N0QF***********END COMMENTING************* */

/* ********** End Translatable Strings Definitions ********* */

/*J23W*  no-undo added ** BEGIN */
         define new shared variable glname like en_name no-undo.
         define new shared variable begdt as date extent 4 no-undo.
         define new shared variable enddt as date extent 4 no-undo.
         define new shared variable budget like mfc_logical extent 4 no-undo.
         /* SS - 20050913 - B */
         /*
         define new shared variable zeroflag like mfc_logical
            initial no label {&gl4inrp_p_18} no-undo.
         */
         define new shared variable zeroflag like mfc_logical
            initial YES label {&gl4inrp_p_18} no-undo.
         /* SS - 20050913 - E */
         define new shared variable sub like sb_sub no-undo.
         define new shared variable sub1 like sb_sub no-undo.
         define new shared variable ctr like cc_ctr no-undo.
         define new shared variable ctr1 like cc_ctr no-undo.
         define new shared variable level as integer
            format ">9" initial 99 label {&gl4inrp_p_1} no-undo.
         /* SS - 20050913 - B */
         /*
         define new shared variable ccflag like mfc_logical
            label {&gl4inrp_p_16} no-undo.
         define new shared variable subflag like mfc_logical
            label {&gl4inrp_p_17} no-undo.
         */
         define new shared variable ccflag like mfc_logical
            INITIAL YES label {&gl4inrp_p_16} no-undo.
         define new shared variable subflag like mfc_logical
            INITIAL YES label {&gl4inrp_p_17} no-undo.
         /* SS - 20050913 - E */
         define new shared variable entity like en_entity no-undo.
         define new shared variable entity1 like en_entity no-undo.
         define new shared variable cname like glname no-undo.
         define new shared variable fiscal_yr like glc_year extent 4 no-undo.
         define new shared variable per_beg like glc_per extent 4 no-undo.
         define new shared variable per_end like glc_per extent 4 no-undo.
         define new shared variable ret like ac_code no-undo.
         define new shared variable yr_end as date extent 4 no-undo.
         define new shared variable income as decimal extent 4 no-undo.
         define new shared variable rpt_curr like gltr_curr no-undo.
         define new shared variable budgetcode like bg_code extent 4 no-undo.
         define new shared variable prt1000 like mfc_logical
            label {&gl4inrp_p_14} no-undo.
         define new shared variable prtfmt as character format "x(30)" no-undo.
         define new shared variable labelname as character format "x(8)"
            extent 4 no-undo.

         define variable peryr as character format "x(8)" no-undo.
         define variable msg1000 as character format "x(16)" no-undo.
         define variable balance like gltr_amt no-undo.
         define variable knt as integer no-undo.
         define variable i as integer no-undo.
         define variable dt as date no-undo.
         define variable cmmt-yn like mfc_logical label {&gl4inrp_p_13} no-undo.
         define variable cmmt_ref like cd_ref label {&gl4inrp_p_7} no-undo.
         define variable cmmt_type like cd_type label {&gl4inrp_p_8} no-undo.
         define variable use_cc like co_use_cc no-undo.
         define variable use_sub like co_use_sub no-undo.
/*J23W*  no-undo added ** END */

/*L00M - BEGIN ADD*/
         /* ***** COMMON REPORT VARIABLES ***** */
         {etrpvar.i &new = "new"}
         {etvar.i   &new = "new"}
         {eteuro.i}
/*L01W*  define variable et_show_curr as character format "x(30)" no-undo. */
/*L00M - END ADD*/

         /* SELECT FORM */
         form
            entity        colon 28 entity1    colon 60 label {t001.i}
            cname         colon 28 skip
            begdt[1]      colon 28 label {&gl4inrp_p_5}
            enddt[1]      colon 60 label {t001.i}
            budget[1]     colon 28 label {&gl4inrp_p_15}
            budgetcode[1] colon 60 label {&gl4inrp_p_2}
            begdt[2]      colon 28 label {&gl4inrp_p_11}
            enddt[2]      colon 60 label {t001.i}
            budget[2]     colon 28 label {&gl4inrp_p_15}
            budgetcode[2] colon 60 label {&gl4inrp_p_2}
            begdt[3]      colon 28 label {&gl4inrp_p_10}
            enddt[3]      colon 60 label {t001.i}
            budget[3]     colon 28 label {&gl4inrp_p_15}
            budgetcode[3] colon 60 label {&gl4inrp_p_2}
            begdt[4]      colon 28 label {&gl4inrp_p_9}
            enddt[4]      colon 60 label {t001.i}
            budget[4]     colon 28 label {&gl4inrp_p_15}
            budgetcode[4] colon 60 label {&gl4inrp_p_2}
            zeroflag      colon 28 level     colon 60
            sub           colon 28 sub1      colon 42 label {t001.i}
            subflag       colon 67
            ctr           colon 28 ctr1      colon 42 label {t001.i}
            ccflag        colon 67
            prt1000       colon 28
            cmmt-yn       colon 28 cmmt_type colon 60
            cmmt_ref      colon 28
/*L01W*/    et_report_curr colon 28
/*L00M*ADD SECTION*/
/*L01W*     et_report_txt to 20 no-label */
/*L01W*     et_report_curr      no-label */
/*L01W*     et_rate_txt to 38   no-label */
/*L01W*     et_report_rate      no-label */
/*L00M*END ADD SECTION*/
         with frame a side-labels
/*L00M*  attr-space */
         width 80.

         /* SET EXTERNAL LABELS */
         /* SS - 20050913 - B */
         /*
         setFrameLabels(frame a:handle).
         */
         /* SS - 20050913 - E */

         /* SS - 20050913 - B */
         entity = i_entity.
         entity1 = i_entity1.
         begdt[1] = begdt01.
         begdt[2] = begdt02.
         begdt[3] = begdt03.
         begdt[4] = begdt04.
         enddt[1] = enddt01.
         enddt[2] = enddt02.
         enddt[3] = enddt03.
         enddt[4] = enddt04.
         budget[1] = budget01.
         budget[2] = budget02.
         budget[3] = budget03.
         budget[4] = budget04.
         budgetcode[1] = budgetcode01.
         budgetcode[2] = budgetcode02.
         budgetcode[3] = budgetcode03.
         budgetcode[4] = budgetcode04.
         et_report_curr = i_et_report_curr.
         /* SS - 20050913 - E */

         /* GET NAME OF CURRENT ENTITY */
/*J23W** find en_mstr where en_entity = current_entity no-lock no-error. **/
/*J23W*/ for first en_mstr fields (en_name en_entity)
/*J23W*/ no-lock where en_entity = current_entity: end.
         if not available en_mstr then do:
            {mfmsg.i 3059 3} /* NO PRIMARY ENTITY DEFINED */
            if c-application-mode <> 'web' then
               pause.
            leave.
         end.
         else do:
            assign glname = en_name.
         end.
         assign
            entity = current_entity
            entity1 = current_entity
            cname = glname
            rpt_curr = base_curr.

         /* GET RETAINED EARNINGS CODE FROM CONTROL FILE */
/*J23W** find first co_ctrl no-lock no-error. **/
/*J23W*/ for first co_ctrl fields (co_ret co_use_cc co_use_sub)
/*J23W*/ no-lock: end.
         if not available co_ctrl then do:
            {mfmsg.i 3032 3} /* CONTROL FILE MUST BE DEFINED BEFORE RUNNING
                                REPORT*/
            if c-application-mode <> 'web' then
               pause.
            leave.
         end.
         assign
            ret = co_ret
            use_sub = co_use_sub
            use_cc = co_use_cc.

         /* DEFINE HEADERS */
         /* SS - 20050913 - B */
         /*
         form header
            cname at 1 space(2) msg1000
/*L01W* /*L00M*/ et_show_curr */
/*L01W*/    mc-curr-label et_report_curr skip
/*L01W*/    mc-exch-label at 44 mc-exch-line1 at 66 skip
/*L01W*/    mc-exch-line2 at 66 skip(1)
            skip
            labelname[1] to 50  labelname[2] to 75  labelname[3] to 100
            labelname[4] to 125
/*N0QF*
 *          begdt[1] to 47  {t001.i} {&gl4inrp_p_3} to 57
 *          begdt[2] to 72  {t001.i} {&gl4inrp_p_3} to 82
 *          begdt[3] to 97  {t001.i} {&gl4inrp_p_3} to 107
 *          begdt[4] to 122 {t001.i} {&gl4inrp_p_3} to 132
 *          enddt[1] to 50           {&gl4inrp_p_4} to 57
 *          enddt[2] to 75           {&gl4inrp_p_4} to 82
 *          enddt[3] to 100          {&gl4inrp_p_4} to 107
 *          enddt[4] to 125          {&gl4inrp_p_4} to 132
 *N0QF*/
/*N0QF*/    begdt[1] to 47  {t001.i} getTermLabelRt("%_OF",6) to 57    format "x(6)"
/*N0QF*/    begdt[2] to 72  {t001.i} getTermLabelRt("%_OF",6) to 82    format "x(6)"
/*N0QF*/    begdt[3] to 97  {t001.i} getTermLabelRt("%_OF",6) to 107   format "x(6)"
/*N0QF*/    begdt[4] to 122 {t001.i} getTermLabelRt("%_OF",6) to 132   format "x(6)"
/*N0QF*/    enddt[1] to 50           getTermLabelRt("INCOME",6) to 57  format "x(6)"
/*N0QF*/    enddt[2] to 75           getTermLabelRt("INCOME",6) to 82  format "x(6)"
/*N0QF*/    enddt[3] to 100          getTermLabelRt("INCOME",6) to 107 format "x(6)"
/*N0QF*/    enddt[4] to 125          getTermLabelRt("INCOME",6) to 132 format "x(6)"
            "-----------------" to 50  "------" to 57
            "-----------------" to 75  "------" to 82
            "-----------------" to 100 "------" to 107
            "-----------------" to 125 "------" to 132
         skip(1) with frame phead1 page-top no-box width 132.

         form header  /* USED IF REPORT DOESN'T START AT PAGE TOP */
            labelname[1] to 50  labelname[2] to 75  labelname[3] to 100
            labelname[4] to 125
/*N0QF*
 *          begdt[1] to 47  {t001.i} {&gl4inrp_p_3} to 57
 *          begdt[2] to 72  {t001.i} {&gl4inrp_p_3} to 82
 *          begdt[3] to 97  {t001.i} {&gl4inrp_p_3} to 107
 *          begdt[4] to 122 {t001.i} {&gl4inrp_p_3} to 132
 *          enddt[1] to 50           {&gl4inrp_p_4} to 57
 *          enddt[2] to 75           {&gl4inrp_p_4} to 82
 *          enddt[3] to 100          {&gl4inrp_p_4} to 107
 *          enddt[4] to 125          {&gl4inrp_p_4} to 132
 *N0QF*/
/*N0QF*/    begdt[1] to 47  {t001.i} getTermLabelRt("%_OF",6) to 57    format "x(6)"
/*N0QF*/    begdt[2] to 72  {t001.i} getTermLabelRt("%_OF",6) to 82    format "x(6)"
/*N0QF*/    begdt[3] to 97  {t001.i} getTermLabelRt("%_OF",6) to 107   format "x(6)"
/*N0QF*/    begdt[4] to 122 {t001.i} getTermLabelRt("%_OF",6) to 132   format "x(6)"
/*N0QF*/    enddt[1] to 50           getTermLabelRt("INCOME",6) to 57  format "x(6)"
/*N0QF*/    enddt[2] to 75           getTermLabelRt("INCOME",6) to 82  format "x(6)"
/*N0QF*/    enddt[3] to 100          getTermLabelRt("INCOME",6) to 107 format "x(6)"
/*N0QF*/    enddt[4] to 125          getTermLabelRt("INCOME",6) to 132 format "x(6)"
            "-----------------" to 50  "------" to 57
            "-----------------" to 75  "------" to 82
            "-----------------" to 100 "------" to 107
            "-----------------" to 125 "------" to 132
         skip(1) with frame phead2 no-box width 132.
         */
         /* SS - 20050913 - E */

         {wbrp01.i}

         /* REPORT BLOCK */
             /* SS - 20050913 - B */
             /*
         mainloop:
         repeat:
             */
             /* SS - 20050913 - E */

            /* INPUT OPTIONS */
            if ctr1 = hi_char then assign ctr1 = "".
            if sub1 = hi_char then assign sub1 = "".
            if entity1 = hi_char then assign entity1 = "".

/*L01W* /*L00M*/ display et_report_txt et_rate_txt */
/*L01W* /*L00M*/    with frame a.                  */

            /* SS - 20050913 - B */
            /*
            if c-application-mode <> 'web' then
               update entity
                      entity1
                      cname
                      begdt[1]
                      enddt[1]
                      budget[1]
                      budgetcode[1]
                      begdt[2]
                      enddt[2]
                      budget[2]
                      budgetcode[2]
                      begdt[3]
                      enddt[3]
                      budget[3]
                      budgetcode[3]
                      begdt[4]
                      enddt[4]
                      budget[4]
                      budgetcode[4]
                      zeroflag level
                      sub when ( use_sub ) sub1 when ( use_sub )
                      subflag when ( use_sub )
                      ctr when ( use_cc ) ctr1 when ( use_cc )
                      ccflag when ( use_cc )
                      prt1000
                      cmmt-yn cmmt_type cmmt_ref
/*L00M*/              et_report_curr
/*L01W* /*L00M*/      et_report_rate */
               with frame a.

            {wbrp06.i &command = update &fields = "  entity entity1 cname
             begdt [1] enddt [1] budget [1] budgetcode [1] begdt [2]
             enddt [2] budget [2] budgetcode [2] begdt [3]
             enddt [3] budget [3] budgetcode [3] begdt [4]
             enddt [4] budget [4] budgetcode [4]  zeroflag
             level  sub when use_sub sub1 when use_sub
             subflag when use_sub  ctr when use_cc ctr1 when use_cc
             ccflag when use_cc
             prt1000  cmmt-yn cmmt_type cmmt_ref
/*L01W*/     et_report_curr
             " &frm = "a"}
                */
                /* SS - 20050913 - E */

             if (c-application-mode <> 'web') or
             (c-application-mode = 'web' and
             (c-web-request begins 'data')) then do:

                /* CREATE BATCH INPUT STRING */
                assign bcdparm = "".
/*K1RK*/        run quote-vars.
/*K1RK* Moved block to an internal procedure
 *              {gprun.i ""gpquote.p""
 *                "(input-output bcdparm,
 *                               20,
 *                               entity,
 *                               entity1,
 *                               cname,
 *                               string(begdt[1]),
 *                               string(enddt[1]),
 *                               string(budget[1]),
 *                               string(budgetcode[1]),
 *                               string(begdt[2]),
 *                               string(enddt[2]),
 *                               string(budget[2]),
 *                               string(budgetcode[2]),
 *                               string(begdt[3]),
 *                               string(enddt[3]),
 *                               string(budget[3]),
 *                               string(budgetcode[3]),
 *                               string(begdt[4]),
 *                               string(enddt[4]),
 *                               string(budget[4]),
 *                               string(budgetcode[4]),
 *                               string(zeroflag))"
 *              }
 *              {mfquoter.i level        }
 *              if use_sub then do:
 *                 {mfquoter.i sub       }
 *                 {mfquoter.i sub1      }
 *                 {mfquoter.i subflag   }
 *              end.
 *              if use_cc then do:
 *                 {mfquoter.i ctr       }
 *                 {mfquoter.i ctr1      }
 *                 {mfquoter.i ccflag    }
 *              end.
 *              {mfquoter.i prt1000      }
 *              {mfquoter.i cmmt-yn      }
 *              {mfquoter.i cmmt_type    }
 *              {mfquoter.i cmmt_ref     }
 * /*L00M*/     {mfquoter.i cmmt_ref     }
 * /*L00M*/     {mfquoter.i cmmt_ref     }
 *K1RK* end of move block */

                if entity1 = "" then assign entity1 = hi_char.
                if sub1 = "" then assign sub1 = hi_char.
                if ctr1 = "" then assign ctr1 = hi_char.

                /* CHECK FOR VALID REPORT DATES--COLUMN 1 */
                do i = 1 to 4:

                   if enddt[i] = ? then assign enddt[i] = today.
                   /* SS - 20050913 - B */
                   /*
                   display enddt[i] with frame a.
                   */
                   /* SS - 20050913 - E */
                   {glper1.i enddt[i] peryr}  /*GET PERIOD/YEAR*/
                   if peryr = "" then do:
                      {mfmsg.i 3018 3}    /* DATE NOT WITHIN A VALID PERIOD */
                      if c-application-mode = 'web' then return.
                      else next-prompt enddt[i] with frame a.
                      /* SS - 20050913 - B */
                      /*
                      undo mainloop.
                      */
                      /* SS - 20050913 - E */
                   end.

                   assign
                      fiscal_yr[i] = glc_year
                      per_end[i] = glc_per.
/*J23W**           find glc_cal where glc_year = fiscal_yr[i] and glc_per = 1 */
/*J23W**           no-lock no-error. **/

/*J23W*/           for first glc_cal fields (glc_end glc_per glc_start glc_year)
/*J23W*/           no-lock where glc_year = fiscal_yr[i] and glc_per = 1: end.
                   if not available glc_cal then do:
                      {mfmsg.i 3033 3}  /* NO FIRST PERIOD DEFINED FOR THIS
                                           FISCAL YEAR. */
                      if c-application-mode = 'web' then return.
                      else next-prompt begdt[i] with frame a.
                      /* SS - 20050913 - B */
                      /*
                      undo mainloop.
                      */
                      /* SS - 20050913 - E */
                   end.

                   if begdt[i] = ? then assign begdt[i] = glc_start.
                   /* SS - 20050913 - B */
                   /*
                   display begdt[i] with frame a.
                   */
                   /* SS - 20050913 - E */
                   if begdt[i] < glc_start then do:
                      {mfmsg.i 3031 3} /*REPORT CANNOT SPAN FISCAL YEARS*/
                      if c-application-mode = 'web' then return.
                      else next-prompt begdt[i] with frame a.
                      /* SS - 20050913 - B */
                      /*
                      undo mainloop.
                      */
                      /* SS - 20050913 - E */
                   end.

                   if begdt[i] > enddt[i] then do:
                      {mfmsg.i 27 3} /* INVALID DATE */
                      if c-application-mode = 'web' then return.
                      else next-prompt begdt[i] with frame a.
                      /* SS - 20050913 - B */
                      /*
                      undo mainloop.
                      */
                      /* SS - 20050913 - E */
                   end.

                   {glper1.i begdt[i] peryr} /* GET PERIOD/YEAR */
                   if peryr = "" then do:
                      {mfmsg.i 3018 3}    /* DATE NOT WITHIN A VALID PERIOD */
                      if c-application-mode = 'web' then return.
                      else next-prompt begdt[i] with frame a.
                      /* SS - 20050913 - B */
                      /*
                      undo mainloop.
                      */
                      /* SS - 20050913 - E */
                   end.
                   assign per_beg[i] = glc_per.

                   find last glc_cal where glc_year = fiscal_yr[i]
                   no-lock no-error.
                   assign yr_end[i] = glc_end.
                end.

                /*  CHECK FOR VALID LEVEL */
                if level < 1 or level > 99 then do:
                   {mfmsg.i 3015 3}   /*INVALID LEVEL*/
                   if c-application-mode = 'web' then return.
                   else next-prompt level with frame a.
                   /* SS - 20050913 - B */
                   /*
                   undo mainloop.
                   */
                   /* SS - 20050913 - E */
                end.

/*L00M*ADDED SECTION*/
/*L01W*         {etcurval.i &curr     = "et_report_curr" */
/*L01W*              &errlevel = 4 */
/*L01W*              &prompt   = "next-prompt et_report_curr with frame a" */
/*L01W*              &action   = "undo, retry"} */
/*L01W*         et_disp_curr = rpt_curr. /* used when euro toolkit */ */
/*L01W*                                  /* not active */ */
/*L01W*         {gprun.i ""etrate.p"" "("""")"} */
/*L010          et_disp_curr = rpt_curr. */
/*L00M*END ADDED SECTION*/

/*L01W*/        if et_report_curr <> "" then do:
/*L01W*/           {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                     "(input et_report_curr,
                       output mc-error-number)"}
/*L01W*/           if mc-error-number = 0
/*L01W*/           and et_report_curr <> rpt_curr then do:
/*L08W*               CURRENCIES AND RATES REVERSED BELOW...             */
/*L01W*/              {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                        "(input et_report_curr,
                          input rpt_curr,
                          input "" "",
                          input et_eff_date,
                          output et_rate2,
                          output et_rate1,
                          output mc-seq,
                          output mc-error-number)"}
/*L01W*/           end.  /* if mc-error-number = 0 */

/*L01W*/           if mc-error-number <> 0 then do:
/*L01W*/              {mfmsg.i mc-error-number 3}
/*L01W*/              if c-application-mode = 'web' then return.
/*L01W*/              else next-prompt et_report_curr with frame a.
/*L01W*/              undo, retry.
/*L01W*/           end.  /* if mc-error-number <> 0 */
/*L01W*/           else if et_report_curr <> rpt_curr then do:
/*L08W*               CURRENCIES AND RATES REVERSED BELOW...             */
/*L01W*/              {gprunp.i "mcui" "p" "mc-ex-rate-output"
                        "(input et_report_curr,
                          input rpt_curr,
                          input et_rate2,
                          input et_rate1,
                          input mc-seq,
                          output mc-exch-line1,
                          output mc-exch-line2)"}
/*L01W*/              {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                        "(input mc-seq)"}
/*L01W*/           end.
/*L01W*/        end.  /* if et_report_curr <> "" */
/*L01W*/        if et_report_curr = "" or et_report_curr = rpt_curr then assign
/*L01W*/           mc-exch-line1 = ""
/*L01W*/           mc-exch-line2 = ""
/*L01W*/           et_report_curr = rpt_curr.

             end.  /* if (c-application-mode <> 'web') ... */

             /* SELECT PRINTER */
             /* SS - 20050913 - B */
             /*
             {mfselbpr.i "printer" 132}
             {mfphead.i}

             /* PRINT COMMENTS */
             if cmmt-yn then do:
                put cname at 1 skip.
                for each cd_det
/*J23W*/            fields (cd_cmmt cd_ref cd_type)
                    where cd_ref = cmmt_ref and cd_type = cmmt_type
                    no-lock:
                    do i = 1 to 15:
                       if cd_cmmt[i] <> "" then do:
                          if line-counter > page-size then page.
                          put cd_cmmt[i] at 14 skip.
                       end.
                    end.
                    put skip.
                 end.
              end.
              */
              /* SS - 20050913 - E */

              /* SET UP HEADERS */
              do i = 1 to 4:
/*N0QF*          assign labelname[i] = {&gl4inrp_p_12}. */
/*N0QF*/         assign labelname[i] = getTermLabel("ACTIVITY",8).
/*N0QF*          if budget[i] = yes then assign labelname[i] = {&gl4inrp_p_6}. */
/*N0QF*/         if budget[i] = yes then assign labelname[i] = " " + getTermLabel("BUDGET",7).
              end.
              assign msg1000 = "".

/*L00M*ADD SECTION*/
/*L01W*       et_show_curr = "". */
/*L01W*       if et_tk_active then do: */
/*L01W*          assign */
/*L01W*             et_show_curr = et_report_txt + " " + et_disp_curr. */
              if prt1000 then
/*H1MY** /*L01W*/  assign msg1000 = "(in 1000's " + et_report_curr + ")". */
/*N0QF* /*H1MY*/ assign msg1000 = {&gl4inrp_p_19} + et_report_curr + ")". */
/*N0QF*/         assign msg1000 = "(" + getTermLabel("IN_1000'S",10) + " " + et_report_curr + ")".
/*L01W*          assign msg1000 = "(in 1000's " + et_disp_curr + ")". */
/*L01W*       end. */
/*L01W*       else */
/*L00M*END ADD SECTION*/

/*L01W*          if prt1000 then assign msg1000 = "(in 1000's " + */
/*L01W*             base_curr + ")".*/
              /* SS - 20050913 - B */
              /*
                 if cmmt-yn and line-counter > 4 then do:
                    view frame phead2.
                    display "".
                 end.
                 view frame phead1.
                 */
                 /* SS - 20050913 - E */

                 do i = 1 to 4:

/*J23W*********** RESTRUCTURE FOR PERFORMANCE *** BEGIN DELETE ************
*                   if not budget[i] then do:
*                      find first glt_det where glt_entity >= entity and
*                                               glt_entity <= entity1 and
*                                               glt_sub >= sub and
*                                               glt_sub <= sub1 and
*                                               glt_cc >= ctr and glt_cc <= ctr1 and
*                                               glt_effdate >= begdt[i] and
*                                               glt_effdate <= enddt[i] no-lock
*                                               no-error.
*                      if available glt_det then do:
*J23W************************* END DELETE *********************************/

/*J23W* BEGIN ADD */
                   if not budget[i] and
                      can-find (first glt_det where glt_entity >= entity and
                                           glt_entity <= entity1 and
                                           glt_sub >= sub and
                                           glt_sub <= sub1 and
                                           glt_cc >= ctr and glt_cc <= ctr1 and
                                           glt_effdate >= begdt[i] and
                                           glt_effdate <= enddt[i] )
                   then do:
/*J23W* END ADD */

                       /* SS - 20050913 - B */
                       /*
                      {mfmsg.i 3151 2} /* UNPOSTED TRANSACTIONS EXIST FOR RANGES
                                          ON THIS REPORT */
                          */
                          /* SS - 20050913 - E */
                      leave.
/*J23W**           end. **/
                   end.
                end.  /* do i = 1 to 4 */

                /* CALCULATE TOTAL AMOUNT OF INCOME FOR COLUMNS */
                /* SS - 20050913 - B */
                /*
                {gprun.i ""gl4inrpa.p""}
                    */
                    {gprun.i ""a6gl4inrpa.p""}
                    /* SS - 20050913 - E */

                /* CALL SUBPROGRAM TO CALCULATE AND PRINT REPORT */
                    /* SS - 20050913 - B */
                    /*
                {gprun.i ""gl4inrpb.p""}

                /* REPORT TRAILER */
                {mfrtrail.i}

             end.
                */
                    {gprun.i ""a6gl4inrpb.p""}
                /* SS - 20050913 - E */

            {wbrp04.i &frame-spec = a}

/*K1RK* start of add section */
     PROCEDURE quote-vars:
         {gprun.i ""gpquote.p""
                  "(input-output bcdparm,
                   20,
                   entity,
                   entity1,
                   cname,
                   string(begdt[1]),
                   string(enddt[1]),
                   string(budget[1]),
                   string(budgetcode[1]),
                   string(begdt[2]),
                   string(enddt[2]),
                   string(budget[2]),
                   string(budgetcode[2]),
                   string(begdt[3]),
                   string(enddt[3]),
                   string(budget[3]),
                   string(budgetcode[3]),
                   string(begdt[4]),
                   string(enddt[4]),
                   string(budget[4]),
                   string(budgetcode[4]),
                   string(zeroflag))"
             }
        {mfquoter.i level        }
        if use_sub then do:
           {mfquoter.i sub       }
           {mfquoter.i sub1      }
           {mfquoter.i subflag   }
        end.
        if use_cc then do:
           {mfquoter.i ctr       }
           {mfquoter.i ctr1      }
           {mfquoter.i ccflag    }
        end.
        {mfquoter.i prt1000      }
        {mfquoter.i cmmt-yn      }
        {mfquoter.i cmmt_type    }
        {mfquoter.i cmmt_ref     }
/*L01W*/ {mfquoter.i et_report_curr}
/*L01W* {mfquoter.i cmmt_ref     } */
/*L01W* {mfquoter.i cmmt_ref     } */
     END PROCEDURE.
/*K1RK* end of section */
