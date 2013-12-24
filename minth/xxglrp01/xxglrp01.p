/* REVISION: eb21sp3      LAST MODIFIED: 11/07/06   BY: *SS - Micho - 20061107* Micho Yang     */

/****************************** Add by SS - Micho - 20061107 B ******************************/
/*
{ssglacstrp.i "new"}
*/
/****************************** Add by SS - Micho - 20061107 B ******************************/

/* DISPLAY TITLE */
{mfdtitle.i "090917.1"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glcctrrp_p_1 "Suppress Zero Accounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcctrrp_p_2 "Use Budgets"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcctrrp_p_4 "Round to Nearest Whole Unit"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcctrrp_p_6 "Budget Code"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcctrrp_p_7 "Column 2 - Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcctrrp_p_9 "Column 1 - Date"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

          define new shared variable glname like en_name no-undo.
          define new shared variable begdt as date extent 2 no-undo.
          define new shared variable enddt as date extent 2 no-undo.
          define new shared variable acc like ac_code NO-UNDO  .
          define new shared variable acc1 like ac_code NO-UNDO .
          define new shared variable sub like sb_sub no-undo.
          define new shared variable sub1 like sb_sub no-undo.
          define new shared variable ctr like cc_ctr no-undo.
          define new shared variable ctr1 like cc_ctr no-undo.
          define new shared variable yr_beg as date no-undo.
          define new shared variable yr as integer no-undo.
          define new shared variable budget like mfc_logical extent 2 no-undo.
          define new shared variable peryr as character format "x(8)" no-undo.
          define new shared variable fiscal_yr as integer extent 2 no-undo.
          define new shared variable fiscal_yr1 as integer extent 2 no-undo.
          define new shared variable per_end like glc_per extent 2 no-undo.
          define new shared variable per_beg like glc_per extent 2 no-undo.
          define new shared variable entity like en_entity no-undo.
          define new shared variable entity1 like en_entity no-undo.
          define new shared variable cname like glname no-undo.
          define new shared variable hdrstring as character
             format "x(8)" no-undo.
          define new shared variable hdrstring1 like hdrstring no-undo.
          define new shared variable yr_end as date extent 2 no-undo.
          define new shared variable ret like ac_code no-undo.
          define new shared variable proj like gltr_project no-undo.
          define new shared variable proj1 like gltr_project no-undo.
          define new shared variable budgetcode like bg_code extent 2 no-undo.
          define new shared variable rpt_curr like ac_curr no-undo.
          define new shared variable prtcents like mfc_logical
             label {&glcctrrp_p_4} no-undo.
          define new shared variable prtfmt as character format "x(30)" no-undo.
          define new shared variable prtfmt1 as character
             format "x(30)" no-undo.
          define new shared variable zeroflag like mfc_logical
            label {&glcctrrp_p_1} no-undo.

          define variable use_sub like co_use_sub no-undo.
          define variable i as integer no-undo.
          DEF VAR effdate AS DATE .
          DEF VAR effdate1 AS DATE .

          /****************************** Add by SS - Micho - 20061107 B ******************************/
          define variable ccflag   AS LOGICAL INIT NO label "汇总成本中心" NO-UNDO .
          DEF VAR subflag AS logical INIT NO LABEL "汇总分帐户" NO-UNDO .
          DEF VAR v_curr  AS CHAR .
          DEF VAR v_curr1 AS CHAR .
          DEF VAR v_post  AS logical INIT NO .
          DEF VAR v_ln    AS INTEGER FORMAT "9".
	  def var v_inc_flag as logical init no .
          /****************************** Add by SS - Micho - 20061107 B ******************************/

/*L00M * BEGIN ADD*/
          /* DEFINE EURO VARIABLES */
          {etrpvar.i &new = "new"}
          {etvar.i   &new = "new"}
/*L01W*   define new shared variable et_show_curr as character */
/*L01W*                                 format "x(30)"no-undo. */
          /* GET EURO INFORMATION  */
          {eteuro.i}
/*L00M * END ADD*/

          /* SELECT FORM */
          form
              entity        colon 30 entity1   colon 50 label {t001.i}
              effdate       COLON 30 effdate1  COLON 50 LABEL {t001.i}
              acc           colon 30 acc1      colon 50 label {t001.i}
              sub           colon 30 sub1      colon 50 label {t001.i}
              ctr           colon 30 ctr1      colon 50 label {t001.i}
              v_curr        COLON 30 v_curr1   COLON 50 LABEL {t001.i}

              subflag       COLON 30
              ccflag        COLON 30
              v_post        COLON 30
	           v_inc_flag    colon 30 label "是否包括无发生额的科目"
              v_ln          COLON 30
              SKIP(1)
           with frame a side-labels attr-space width 80.

           /* SET EXTERNAL LABELS */
           setFrameLabels(frame a:handle).

          /* GET NAME OF CURRENT ENTITY */
/*J241**  find en_mstr where en_entity = current_entity no-lock no-error. **/
/*J241*/  for first en_mstr fields (en_name en_entity)
/*J241*/      no-lock where en_entity = current_entity: end.
          if not available en_mstr then do:
             {mfmsg.i 3059 3} /* NO PRIMARY ENTITY DEFINED */
             if c-application-mode <> 'web' then
                pause.
             leave.
          end.
          else do:
             assign glname = en_name.
             release en_mstr.
          end.
          assign
             entity = current_entity
             entity1 = current_entity
             cname = glname
             rpt_curr = base_curr
             proj = ""
             proj1 = hi_char.
          /* GET RETAINED EARNINGS CODE FROM CONTROL FILE */
/*J241**  find first co_ctrl no-lock no-error. **/
/*J241*/  for first co_ctrl fields (co_ret co_use_sub) no-lock: end.
          if not available co_ctrl then do:
             {mfmsg.i 3032 3} /* CONTROL FILE MUST BE DEFINED BEFORE
                                 RUNNING REPORT */
             if c-application-mode <> 'web' then
                pause.
             leave.
          end.
          ret = co_ret.
          use_sub = co_use_sub.

          /* SS - 20060210 - B */
          IF MONTH(TODAY) = 1 THEN DO:
             effdate = DATE(12,1,YEAR(TODAY) - 1).
          END.
          ELSE DO:
             effdate = DATE(MONTH(TODAY) - 1,1,YEAR(TODAY)).
          END.
          effdate1 = DATE(MONTH(TODAY),1,YEAR(TODAY)) - 1.

          {wbrp01.i}

          /* REPORT BLOCK */
          mainloop:
          repeat:

            /* INPUT OPTIONS */
            if entity1 = hi_char then assign entity1 = "".
            if acc1 = hi_char then assign acc1 = "".
            if sub1 = hi_char then assign sub1 = "".
            if ctr1 = hi_char then assign ctr1 = "".
            if v_curr1 = hi_char then assign v_curr1 = "".

            if c-application-mode <> 'web' then
               update entity entity1 effdate effdate1
                      acc acc1
                      sub  when (use_sub)
                      sub1 when (use_sub)
                      ctr ctr1
                      v_curr v_curr1
                      subflag
                      ccflag
                      v_post
		      v_inc_flag
                      v_ln
                   with frame a.

            {wbrp06.i &command = update &fields = " entity entity1 
                effdate effdate1 acc acc1 sub sub1 ctr ctr1 v_curr 
                subflag ccflag v_post v_inc_flag v_ln 
             " &frm = "a"}
               /* SS - 20060210 - E */

            if (c-application-mode <> 'web') or
            (c-application-mode = 'web' and
            (c-web-request begins 'data')) then do:

/*K1S9*/       run quote-vars.

               if entity1  = "" then assign entity1 = hi_char.
               if acc1     = ""    then assign acc1 = hi_char.
               if sub1     = ""    then assign sub1 = hi_char.
               if ctr1     = ""    then assign ctr1 = hi_char.
               IF v_curr1  = "" THEN ASSIGN v_curr1 = hi_char .
               IF effdate1 = ? THEN ASSIGN effdate1 = TODAY .
            end.  /* if (c-application-mode <> 'web') ... */

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}

            /* main programmer */
            {xxglrp01.i}

         end.

         {wbrp04.i &frame-spec = a}

/*K1S9* Add section */
    PROCEDURE quote-vars:
         /* CREATE BATCH INPUT STRING */
         assign bcdparm = "".
         {mfquoter.i entity       }
         {mfquoter.i entity1      }
         {mfquoter.i effdate      }
         {mfquoter.i effdate1     }
         {mfquoter.i acc          }
         {mfquoter.i acc1         }
         if use_sub then do:
            {mfquoter.i sub       }
            {mfquoter.i sub1      }
         end.
         {mfquoter.i v_curr       }
         {mfquoter.i v_curr1      }
         {mfquoter.i ctr          }
         {mfquoter.i ctr1         }
         {mfquoter.i subflag      } 
         {mfquoter.i ccflag       } 
         {mfquoter.i v_post       } 
         {mfquoter.i v_inc_flag   } 
         {mfquoter.i v_ln         } 
     END PROCEDURE.
/*K1S9* end of add */
