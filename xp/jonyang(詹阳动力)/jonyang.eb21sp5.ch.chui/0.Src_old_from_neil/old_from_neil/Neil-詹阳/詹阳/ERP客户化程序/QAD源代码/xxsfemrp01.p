/* GUI CONVERTED from sfemrp01.p (converter v1.71) Tue Oct  6 14:48:18 1998 */
/* sfemrp01.p - EMPLOYEE EFFICIENCY REPORT                              */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert sfemrp01.p (converter v1.00) Fri Oct 10 13:57:21 1997 */
/* web tag in sfemrp01.p (converter v1.00) Mon Oct 06 14:17:47 1997 */
/*F0PN*/ /*K0YC*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 7.2    LAST MODIFIED: 12/07/92   BY: emb *G398**/
/* REVISION: 7.2    LAST MODIFIED: 10/19/94   BY: ljm *GN40**/
/* REVISION: 7.3    LAST MODIFIED: 12/29/94   BY: cpp *FT95**/
/* REVISION: 8.6    LAST MODIFIED: 10/14/97   BY: ays *K0YC* */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

     {mfdtitle.i "e+ "}   /*G398*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sfemrp01_p_1 "雇员合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfemrp01_p_2 "实际"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfemrp01_p_3 "标志: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sfemrp01_p_4 " 雇员: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sfemrp01_p_5 "效率"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfemrp01_p_6 "工序: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sfemrp01_p_7 "工作中心/设备合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfemrp01_p_8 "    差异"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfemrp01_p_9 "标准"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfemrp01_p_10 "类型"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfemrp01_p_11 "加工"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfemrp01_p_12 "显示加工时间"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfemrp01_p_13 "准备"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfemrp01_p_14 "显示准备时间"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfemrp01_p_15 "  报表合计:"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


     define variable part   like op_part.
     define variable part1  like op_part.
     define variable wkctr  like op_wkctr.
     define variable wkctr1 like op_wkctr.
     define variable mch    like op_mch.
     define variable mch1   like op_mch.
     define variable nbr  like op_wo_nbr.
     define variable nbr1 like op_wo_nbr.
     define variable op  like op_wo_op format ">>>>>>".
     define variable op1 like op_wo_op format ">>>>>>".
     define variable emp  like op_emp.
     define variable emp1 like op_emp.
     define variable opdate  like op_date.
     define variable opdate1 like op_date.
     define variable lot  like op_wo_lot.
     define variable lot1 like op_wo_lot.

     define variable run_var like wr_act_run.
     define variable setup_var like wr_act_setup.
     define variable run_eff as decimal format "->>>,>>9.9<<%".
     define variable setup_eff as decimal format "->>>,>>9.9<<%".
     define variable std_run like wr_run.
     define variable any_setup like mfc_logical.
     define variable any_run like mfc_logical.
     define variable USR like OP_USERID.
     define variable USR1 like OP_USERID.


     define variable setup_ans like mfc_logical
        label {&sfemrp01_p_14}.
     define variable run_ans like mfc_logical
        label {&sfemrp01_p_12} initial true.
     define variable type as character label {&sfemrp01_p_10} format "x(5)".

     
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
				emp        colon 20 emp1      label {t001.i} colon 49
        opdate     colon 20 opdate1   label {t001.i} colon 49
        wkctr      colon 20 wkctr1    label {t001.i} colon 49
        mch        colon 20 mch1      label {t001.i} colon 49
        part       colon 20 part1     label {t001.i} colon 49
        nbr        colon 20 nbr1      label {t001.i} colon 49
        lot        colon 20 lot1      label {t001.i} colon 49
        op         colon 20 op1       label {t001.i} colon 49
        USR     colon 20 USR1   label {t001.i} colon 49
        setup_ans  colon 20
        run_ans    colon 20
      SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space.

setFrameLabels(frame a:handle).

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME




/*K0YC*/ {wbrp01.i}
        
/*GN40*     do on error undo, retry with frame a: */

           if wkctr1  = hi_char then wkctr1 = "".
           if mch1    = hi_char then mch1 = "".
           if opdate  = low_date then opdate = ?.
           if opdate1 = hi_date then opdate1 = ?.
           if nbr1    = hi_char then nbr1 = "".
           if part1   = hi_char then part1 = "".
           if lot1    = hi_char then lot1 = "".
           if USR1    = hi_char then USR1 = "".

           if emp1    = hi_char then emp1 = "".
           if op1 = 99999999 then op1 = 0.



					update emp emp1 opdate opdate1 wkctr
        wkctr1 mch mch1 part part1 nbr nbr1 lot lot1 op op1 setup_ans run_ans with frame a.

/*K0YC*/ if (c-application-mode <> 'web':u) or
/*K0YC*/ (c-application-mode = 'web':u and
/*K0YC*/ (c-web-request begins 'data':u)) then do:


           bcdparm = "".
           {mfquoter.i emp    }
           {mfquoter.i emp1   }
           {mfquoter.i opdate }
           {mfquoter.i opdate1}
           {mfquoter.i wkctr  }
           {mfquoter.i wkctr1 }
           {mfquoter.i mch    }
           {mfquoter.i mch1   }
           {mfquoter.i part   }
           {mfquoter.i part1  }
           {mfquoter.i nbr    }
           {mfquoter.i nbr1   }
           {mfquoter.i lot    }
           {mfquoter.i lot1   }
           {mfquoter.i op     }
           {mfquoter.i op1    }
           {mfquoter.i setup_ans}
           {mfquoter.i run_ans}
           {mfquoter.i USR    }
           {mfquoter.i USR1   }


           if wkctr1  = "" then wkctr1  = hi_char.
           if mch1    = "" then mch1    = hi_char.
           if opdate  = ?  then opdate  = low_date.
           if opdate1 = ?  then opdate1 = hi_date.
           if part1   = "" then part1   = hi_char.
           if nbr1    = "" then nbr1    = hi_char.
           if lot1    = "" then lot1    = hi_char.
           if USR1    = "" then USR1    = hi_char.
          
           if emp1    = "" then emp1    = hi_char.
           if op1     = 0  then op1     = 99999999.


/*K0YC*/ end.
           /* SELECT PRINTER */

					{mfselbpr.i "printer" 132}
					
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:




/*GN40*     end. */

        {mfphead.i}

        assign any_run = no
        any_setup = no.

        for each op_hist no-lock
        where 
		op_domain = global_domain and /*---Add by davild 20090205.1*/
		(op_wkctr >= wkctr and op_wkctr <= wkctr1)
        and (op_mch >= mch and op_mch <= mch1)
        and (op_date >= opdate and op_date <= opdate1)
        and (op_part >= part and op_part <= part1)
        and (op_wo_nbr >= nbr and op_wo_nbr <= nbr1)
        and (op_wo_lot >= lot and op_wo_lot <= lot1)
        and (op_wo_op >= op and op_wo_op <= op1)
        and (op_emp >= emp and op_emp <= emp1)
        and (op_USERID >= USR and op_USERID <= USR1)

        and ((setup_ans and (op_act_setup <> 0 or op_std_setup <> 0))
         or (run_ans and (op_act_run <> 0 or op_qty_comp <> 0)))
        and op_type <> "DOWN"
        and op_type <> "DOWNTIME"
        and op_type <> "MOVE"
        use-index op_date
        break by op_emp by op_wkctr by op_mch by op_date by op_trnbr
/*FT95*     with frame b down width 133: */
/*FT95*/    with frame b down width 150 no-box:

						setFrameLabels(frame b:handle).

           std_run = op_std_run * op_qty_comp.
           run_var = op_act_run - std_run.
           run_eff = (std_run / op_act_run) * 100.

           setup_eff = (op_std_setup / op_act_setup) * 100.
           setup_var = op_act_setup - op_std_setup.

           accumulate op_std_setup (total by op_mch).
           accumulate std_run (total by op_mch).
           accumulate op_act_setup (total by op_mch).
           accumulate op_act_run (total by op_mch).

           accumulate op_std_setup (total by op_emp).
           accumulate std_run (total by op_emp).
           accumulate op_act_setup (total by op_emp).
           accumulate op_act_run (total by op_emp).

           if first-of (op_emp)
           then do:

          if page-size - line-counter < 4 then page.
          down 1.

          find emp_mstr where 
		  emp_domain = global_domain and /*---Add by davild 20090205.1*/
		  (emp_addr = op_emp) no-lock no-error.

          put
          {&sfemrp01_p_4} op_emp.

          if available emp_mstr then put space(1) emp_lname.

          put skip(1).
           end.

           if (setup_ans or run_ans) then do:
          if setup_ans and (op_act_setup <> 0 or op_std_setup <> 0)
          then do:

             if run_ans and page-size - line-counter < 2 then page.

             any_setup = yes.

/*FT95*              display op_trnbr op_date op_wkctr op_mch */
/*FT95*/             display op_trnbr format ">>>>>>>9"
/*FT95*/             op_date op_wkctr op_mch OP_USERID
             op_wo_nbr op_part
             {&sfemrp01_p_13} @ type
             "" @
             op_qty_comp
             op_std_setup @ op_std_run like op_act_run
             column-label {&sfemrp01_p_9}
             op_act_setup @ op_act_run   column-label {&sfemrp01_p_2}
             setup_var @ run_var column-label {&sfemrp01_p_8}
             setup_eff
/*K0YC*          when setup_eff <> ? */
/*K0YC*/         when (setup_eff <> ?)
             @ run_eff column-label {&sfemrp01_p_5} WITH STREAM-IO /*GUI*/ .

             down 1.
             display
            fill(" ",3) + {&sfemrp01_p_3} + op_wo_lot @ op_wo_nbr
            fill(" ",3) + {&sfemrp01_p_6} + string(op_wo_op) @ op_part WITH STREAM-IO /*GUI*/ .

             if ((op_act_run <> 0) or (op_qty_comp <> 0))
             and run_ans then do:
            any_run = yes.
            display
               {&sfemrp01_p_11} @ type op_qty_comp std_run @ op_std_run
               op_act_run run_var
/*K0YC*            run_eff when run_eff <> ?. */
/*K0YC*/           run_eff when (run_eff <> ?) WITH STREAM-IO /*GUI*/ .
             end.
          end.
          else do:
             if ((op_act_run <> 0) or (op_qty_comp <> 0))
             and run_ans then do:

            if page-size - line-counter < 2 then page.

            any_run = yes.

/*FT95*                 display op_trnbr op_date op_wkctr op_mch */
/*FT95*/                display op_trnbr format ">>>>>>>9"
/*FT95*/                op_date op_wkctr op_mch OP_USERID
            op_wo_nbr op_part
            {&sfemrp01_p_11} @ type op_qty_comp std_run @ op_std_run
            op_act_run run_var run_eff
/*K0YC*         when run_eff <> ?. */
/*K0YC*/        when (run_eff <> ?) WITH STREAM-IO /*GUI*/ .
            down 1.
            display
               fill(" ",3) + {&sfemrp01_p_3} + op_wo_lot @ op_wo_nbr
               fill(" ",3) + {&sfemrp01_p_6} + string(op_wo_op) @ op_part WITH STREAM-IO /*GUI*/ .
             end.
          end.
           end.

           if last-of (op_mch)
           and not first-of(op_mch)
           and (any_setup or any_run)
           then do:

          if page-size - line-counter < 2 then page.
          else
          underline op_std_run op_act_run run_var.
          down 1.
          display fill(" ",18 - length({&sfemrp01_p_7}))
             + {&sfemrp01_p_7} @ op_part WITH STREAM-IO /*GUI*/ .

          if any_setup then do:

             display {&sfemrp01_p_13} @ type
             (accum total by op_mch op_std_setup) @ op_std_run
             (accum total by op_mch op_act_setup) @ op_act_run
             ((accum total by op_mch op_act_setup) -
             (accum total by op_mch op_std_setup)) @ run_var WITH STREAM-IO /*GUI*/ .

             if (accum total by op_mch op_act_setup) <> 0
            then display ((accum total by op_mch op_std_setup)
            / (accum total by op_mch op_act_setup)) * 100
            @ run_eff WITH STREAM-IO /*GUI*/ .
          end.

          if run_ans and any_run then do:

             if any_setup then down 1.

             display {&sfemrp01_p_11} @ type
             (accum total by op_mch std_run) @ op_std_run
             (accum total by op_mch op_act_run) @ op_act_run
             ((accum total by op_mch op_act_run) -
               (accum total by op_mch std_run)) @ run_var WITH STREAM-IO /*GUI*/ .

             if (accum total by op_mch op_act_run) <> 0
            then display ((accum total by op_mch std_run)
            / (accum total by op_mch op_act_run)) * 100
            @ run_eff WITH STREAM-IO /*GUI*/ .
          end.

          if not last-of (op_emp) then down 1.

          assign any_run = no
               any_setup = no.
           end.

           if last-of(op_emp)
           then do:

          if page-size - line-counter < 2 then page.
          else
          underline op_std_run op_act_run run_var.
          down 1.

          display fill(" ",18 - length({&sfemrp01_p_1}))
            + {&sfemrp01_p_1} @ op_part WITH STREAM-IO /*GUI*/ .

          if setup_ans then do:

             display {&sfemrp01_p_13} @ type
             (accum total by op_emp op_std_setup) @ op_std_run
             (accum total by op_emp op_act_setup) @ op_act_run
             ((accum total by op_emp op_act_setup) -
             (accum total by op_emp op_std_setup)) @ run_var WITH STREAM-IO /*GUI*/ .

             if (accum total by op_mch op_act_setup) <> 0
            then display ((accum total by op_emp op_std_setup)
            / (accum total by op_emp op_act_setup)) * 100
            @ run_eff WITH STREAM-IO /*GUI*/ .

             if run_ans then down 1.

          end.
          if run_ans then do:

             display {&sfemrp01_p_11} @ type
             (accum total by op_emp std_run) @ op_std_run
             (accum total by op_emp op_act_run) @ op_act_run
             ((accum total by op_emp op_act_run) -
             (accum total by op_emp std_run)) @ run_var WITH STREAM-IO /*GUI*/ .

             if (accum total by op_emp op_act_run) <> 0
            then display ((accum total by op_emp std_run)
            / (accum total by op_emp op_act_run)) * 100
               @ run_eff WITH STREAM-IO /*GUI*/ .
          end.

          assign any_run = no
               any_setup = no.
           end.

           if last (op_emp) then do:

          if page-size - line-counter < 2 then page.
          else
          underline op_std_run op_act_run run_var.
          down 1.

          display fill(" ",18 - length({&sfemrp01_p_15})) +
             {&sfemrp01_p_15} @ op_part WITH STREAM-IO /*GUI*/ .

          if setup_ans then do:
             display {&sfemrp01_p_13} @ type
             (accum total op_std_setup) @ op_std_run
             (accum total op_act_setup) @ op_act_run
             ((accum total op_act_setup) -
             (accum total op_std_setup)) @ run_var WITH STREAM-IO /*GUI*/ .

             if (accum total op_act_setup) <> 0
            then display ((accum total (op_std_setup))
            / (accum total op_act_setup)) * 100
            @ run_eff WITH STREAM-IO /*GUI*/ .
             if run_ans then down 1.
          end.

          if run_ans then do:
             display {&sfemrp01_p_11} @ type
             (accum total std_run) @ op_std_run
             (accum total op_act_run) @ op_act_run
           ((accum total op_act_run) - (accum total std_run)) @ run_var WITH STREAM-IO /*GUI*/ .

             if (accum total op_act_run) <> 0 then
            display ((accum total std_run)
            / (accum total op_act_run)) * 100
            @ run_eff WITH STREAM-IO /*GUI*/ .
          end.

          put skip(1).
           end.

           
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

        end.

        /* REPORT TRAILER */
        
 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .


	
     end.

/*K0YC*/ {wbrp04.i &frame-spec = a}
