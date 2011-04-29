/* xxwooprp01.p - WORK ORDER OPERATION REPORT                             */
/* GUI CONVERTED from wooprp.p (converter v1.69) Sat Mar 30 01:26:44 1996 */
/* wooprp.p - WORK ORDER OPERATION REPORT                               */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      LAST MODIFIED: 04/15/86   BY: PML      */
/* REVISION: 1.0      LAST MODIFIED: 05/06/86   BY: EMB      */
/* REVISION: 1.0      LAST MODIFIED: 09/12/86   BY: EMB *12* */
/* REVISION: 2.1      LAST MODIFIED: 10/19/87   BY: WUG *A94**/
/* REVISION: 4.0      LAST MODIFIED: 02/17/88   BY: RL  *A171**/
/* REVISION: 4.0      LAST MODIFIED: 02/24/88   BY: WUG *A175**/
/* REVISION: 4.0      LAST MODIFIED: 04/05/88   BY: WUG *A194**/
/* REVISION: 5.0      LAST MODIFIED: 04/10/89   BY: MLB *B096**/
/* REVISION: 5.0      LAST MODIFIED: 10/26/89   BY: emb *B357**/
/* REVISION: 6.0      LAST MODIFIED: 10/29/90   BY: WUG *D151**/
/* REVISION: 6.0      LAST MODIFIED: 01/22/91   BY: bjb *D248**/
/* REVISION: 6.0      LAST MODIFIED: 08/21/91   BY: bjb *D811**/
/* REVISION: 7.3      LAST MODIFIED: 04/27/92   BY: pma *G999**/
/* SS - 090715.1 By: Neil Gao */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/* SS 090715.1 - B */
/*
{mfdtitle.i "f "}  /*G999*/ /*GUI moved to top.*/
*/
{mfdtitle.i "090715.1"}
/* SS 090715.1 - E */

define variable nbr like wr_nbr.
define variable nbr1 like wr_nbr.
define variable lot like wr_lot.
define variable lot1 like wr_lot.
define variable vend like wo_vend.
define variable vend1 like wo_vend.
define variable part like wo_part.
define variable part1 like wo_part.
define variable so_job like wo_so_job.
define variable so_job1 like wo_so_job.
define variable open_ref like wo_qty_ord label "短缺量".
define variable open_ref-1 like wo_qty_ord label "短缺量".

define variable desc1 like pt_desc1.


define variable wrstatus as character format "X(8)" label "状态".
define variable wostatus as character format "X(12)" label "状态".
/*D248 obsoletes the following variables:
define variable s_num as character extent 3.
define variable s_ordered as character.
define variable d_num as decimal extent 3 decimals 9.
define variable i as integer.
define variable j as integer.                               */
/*IFP*/ define variable wkctr like wr_wkctr.
/*IFP*/ define variable wkctr1 like wr_wkctr.
/*IFP*/ define variable op like wr_op .
/*IFP*/ define variable op1 like wr_op .
/*IFP*/ define variable mch like wr_mch.
/*IFP*/ define variable mch1 like wr_mch.
/*IFP*/    define variable sort_op as logical label "一序一单".
/*IFP*/    define variable total_time like wr_run column-label "标准工时".
/*IFP*/    define variable start  like wr_star.
/*IFP*/    define variable start1 like wr_star.
/*IFP*/    define variable due    like wr_due.
/*IFP*/    define variable due1   like wr_due.
/*IFP*/  define variable printline as character format "x(90)" extent 26.
/*IFP*/  define variable addprint  as character format "x(90)" extent 26.
/*IFP*/ define buffer wrroute for wr_route.
/*IFP*/ define variable nextctr like wr_wkctr.
/*IFP*/ define variable nextop like wr_op .
/*IFP*/ define variable nextctrdesc like wc_desc.
/*IFP*/ define variable nextopdesc like wr_desc .
/*LW*/  define variable TRAN_DATE like OP_TRAN_DATE .
/*LW*/  define variable OPDATE like OP_DATE .
/*LW*/  define variable OPDATE1 like OP_DATE .
/*LW*/  define variable REL_DATE like WO_REL_DATE .
/*LW*/  define variable REL_DATE1 like WO_REL_DATE .
/*LW*/  define variable DUE_DATE like WO_DUE_DATE LABEl "加工单到期日".
/*LW*/  define variable DUE_DATE1 like WO_DUE_DATE.
/*LW*/  define variable desc2 like pt_desc1.
/*LW*/  define variable desc3 as character format "x(5)".
/*LW*/  define variable desc4 like pt_desc1.

/* DISPLAY TITLE */
/*GUI moved mfdeclre/mfdtitle.*/

sort_op = YES.
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/* SS 090715.1 - B */
/*   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
*/
/* SS 090715.1 - E */
nbr            colon 15
   nbr1           label {t001.i} colon 49
   lot            colon 15
   lot1           label {t001.i} colon 49
   part           colon 15
   part1          label {t001.i} colon 49
   so_job         colon 15
   so_job1        label {t001.i} colon 49
   vend           colon 15
   vend1          label {t001.i} colon 49 
/*IFP*/ wkctr     colon 15 
/*IFP*/ wkctr1    label {t001.i} colon 49
/*IFP*/ mch       colon 15
/*IFP*/ mch1      label {t001.i} colon 49   
/*IFP*/ op        colon 15
/*IFP*/ op1       label {t001.i} colon 49   
/*IFP*/ start     colon 15
/*IFP*/ start1    label {t001.i} colon 49
/*IFP*/ due       colon 15
/*IFP*/ due1      label {t001.i} colon 49
/*LW*/ OPDATE      colon 15
/*LW*/ OPDATE1      label {t001.i} colon 49
/*LW*/ REL_DATE      colon 15
/*LW*/ REL_DATE1      label {t001.i} colon 49
/*LW*/ DUE_DATE      colon 15
/*LW*/ DUE_DATE1      label {t001.i} colon 49


skip(1)
/*IFP*/ sort_op   colon 15
 SKIP(.4)  /*GUI*/
 /* SS 090715.1 - B */
 /*
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.
*/
with frame a side-labels width 80 attr-space.

setframelabels(frame a:handle).

/* SS 090715.1 - B */

/* SS 090715.1 - B */
/*
 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " 选择条件 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/
*/
/* SS 090715.1 - B */

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/* SS 090715.1 - B */
/*
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:
*/
Mainloop:
repeat:
	
/* SS 090715.1 - E */

   if nbr1 = hi_char then nbr1 = "".
   if lot1 = hi_char then lot1 = "".
   if part1 = hi_char then part1 = "".
   if so_job1 = hi_char then so_job1 = "".
   if vend1 = hi_char then vend1 = "".
/*IFP*/ if wkctr1 = hi_char then wkctr1 = "".
/*IFP*/ if mch1 = hi_char then mch1 = "".
/*IFP*/ if op1 = 999999 then op1 = 0.
/*IFP*/ if start = low_date then start = ?.
/*IFP*/ if start1 = hi_date then start1 = ?.   
/*IFP*/ if due = low_date then due = ?.   
/*IFP*/ if due1 = hi_date then due1 = ?.  
/*LW*/ if OPDATE = low_date then OPDATE = ?.   
/*LW*/ if OPDATE1 = hi_date then OPDATE1 = ?.  
/*LW*/ if REL_DATE = low_date then REL_DATE = ?.   
/*LW*/ if REL_DATE1 = hi_date then REL_DATE1 = ?.  
/*LW*/ if DUE_DATE = low_date then DUE_DATE = ?.   
/*LW*/ if DUE_DATE1 = hi_date then DUE_DATE1 = ?.  
 
/* SS 090715.1 - B */
/*
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:
*/
	update 	nbr nbr1 lot lot1 part part1 so_job so_job1 
					vend vend1 wkctr wkctr1 mch mch1 op op1 start start1 
					due due1 OPDATE OPDATE1 rel_date rel_date1 due_date 
					due_date1 sort_op
	with frame a.
/* SS 090715.1 - E */


   bcdparm = "".
   {mfquoter.i nbr    }
   {mfquoter.i nbr1   }
   {mfquoter.i lot    }
   {mfquoter.i lot1   }
/*IFP*/ {mfquoter.i wkctr }
/*IFP*/ {mfquoter.i wkctr1 }
/*IFP*/ {mfquoter.i mch   }
/*IFP*/ {mfquoter.i mch1  }
/*IFP*/ {mfquoter.i op    }
/*IFP*/ {mfquoter.i op1   }
/*IFP*/ {mfquoter.i start }
/*IFP*/ {mfquoter.i start1}
/*IFP*/ {mfquoter.i due   }
/*IFP*/ {mfquoter.i due1  }
/*LW*/ {mfquoter.i OPDATE   }
/*LW*/ {mfquoter.i OPDATE1  }
/*LW*/ {mfquoter.i REL_DATE   }
/*LW*/ {mfquoter.i REL_DATE1  }
/*LW*/ {mfquoter.i DUE_DATE   }
/*LW*/ {mfquoter.i DUE_DATE1  }

/*IFP*/ {mfquoter.i sort_op}

   if  nbr1 = "" then nbr1 = hi_char.
   if  lot1 = "" then lot1 = hi_char.
   if  part1 = "" then part1 = hi_char.
   if  so_job1 = "" then so_job1 = hi_char.
   if  vend1 = "" then vend1 = hi_char.
/*IFP*/ if wkctr1 = "" then wkctr1 = hi_char.
/*IFP*/ if mch1 = "" then mch1 = hi_char.
/*IFP*/ if op1 = 0 then op1 = 999999.
/*IFP*/ if start = ? then start = low_date .
/*IFP*/ if start1 = ? then start1 = hi_date.   
/*IFP*/ if due = ? then due = low_date.   
/*IFP*/ if due1 = ? then due1 = hi_date.   
/*LW*/ if OPDATE = ? then OPDATE = low_date.   
/*LW*/ if OPDATE1 = ? then OPDATE1 = hi_date.   
/*LW*/ if REL_DATE = ? then REL_DATE = low_date.   
/*LW*/ if REL_DATE1 = ? then REL_DATE1 = hi_date.   
/*LW*/ if DUE_DATE = ? then DUE_DATE = low_date.   
/*LW*/ if DUE_DATE1 = ? then DUE_DATE1 = hi_date.   


/* SS 090715.1 - B */
/*
   /* SELECT PRINTER  */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
*/
				{mfselbpr.i "printer" 132}
/* SS 090715.1 - E */

/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:




if not sort_op then do: /*IFP*/
   {mfphead.i}
      put skip(1).
      put "加工单 / 标 志                                                                     销售定制" at 1.
      put "   工序 / 标准工序        零   件   号       订 货 量 已完成量  短缺量    工作中心  设  备  ST  准  时   单   时  短缺量工时 起始时间 完成时间 汇报日期 工单下达日 工单到期日" at 1.
      put "------------------ ------------------------ --------- --------- --------- -------- -------- -- -------- --------- ---------- -------- -------- -------- ---------- ----------" at 1.
   
   for each wo_mstr where (wo_nbr >= nbr and wo_nbr <= nbr1)
/* SS 090715.1 - B */
		and wo_domain = global_domain
/* SS 090715.1 - B */
   and (wo_lot >= lot and wo_lot <= lot1)
   and (wo_part >= part and wo_part <= part1)
   and (wo_so_job >= so_job and wo_so_job <= so_job1)
   and (wo_vend >= vend and wo_vend <= vend1)
   and (wo_rel_date >= rel_date and wo_rel_date <= rel_date1)
   and (wo_due_date >= due_date and wo_due_date <= due_date1)
   no-lock by wo_nbr by wo_part
   with frame b width 132 no-attr-space:

         if page-size - line-counter < 4 then do:
           page.
           put skip(1).
           put "加工单 / 标 志                                                                     销售定制" at 1.
      put "   工序 / 标准工序        零   件   号       订 货 量 已完成量  短缺量    工作中心  设  备  ST  准  时   单   时  短缺量工时 起始时间 完成时间 汇报日期 工单下达日 工单到期日" at 1.
      put "------------------ ------------------------ --------- --------- --------- -------- -------- -- -------- --------- ---------- -------- -------- -------- ---------- ----------" at 1.
         end.
     
/*jy000** if not can-find (first wr_route where wr_lot = wo_lot ) then next. */
/*jy000*/ if not can-find 
             (first wr_route where wr_lot = wo_lot 
/* SS 090715.1 - B */
							and wr_domain = global_domain
/* SS 090715.1 - E */
              and wr_wkctr >= wkctr and wr_wkctr <= wkctr1 
              and wr_op >= op and wr_op <= op1 
              and wr_mch >= mch and wr_mch <= mch1
              and wr_start >= start and wr_start <= start1
              and wr_due >= due and wr_due <= due1              
          ) then next.

/*D248  {mffloat.i wo_qty_ord " " s_ordered 11}         */
      open_ref-1 = max(wo_qty_ord - wo_qty_comp - wo_qty_rjct ,0).
      if wo_status = "C"  then open_ref-1 = 0.
      
      put wo_nbr at 1 wo_part at 20 wo_qty_ord format ">>>>>9.9<" to 53 wo_qty_comp format ">>>>>9.9<" to 63 open_ref-1 format ">>>>>9.9<" to 73  wo_so_job at 74 wo_status at 93 wo_rel_date at 126 wo_due_date at 135.   

      find pt_mstr where 
/* SS 090715.1 - B */
			pt_domain = global_domain and
/* SS 090715.1 - E */      
      pt_part = wo_part no-lock no-error.
      if available pt_mstr and pt_desc1 <> "" then do:
        put wo_lot at 9 pt_desc1 at 22 pt_desc2 at 48.
        end.
      else do:
        put wo_lot at 9 skip(1).
      end.  

      for each wr_route where wr_lot = wo_lot 
/* SS 090715.1 - B */
					and wr_domain = global_domain
/* SS 090715.1 - E */
/*IFP*/   and wr_wkctr >= wkctr and wr_wkctr <= wkctr1 
/*IFP*/   and wr_op >= op and wr_op <= op1 
/*IFP*/   and wr_mch >= mch and wr_mch <= mch1
/*IFP*/   and wr_start >= start and wr_start <= start1
/*IFP*/   and wr_due >= due and wr_due <= due1
/*          EACH OP_HIST WHERE op_wo_lot = wr_lot and op_wo_op = wr_op
          AND OP_DATE >= OPDATE AND OP_DATE <= OPDATE1*/
           no-lock by wr_op with frame b:

/*G999*/ open_ref = max(wr_qty_ord - (wr_qty_comp + wr_sub_comp) - wr_qty_rjct ,0).

/*B357*/ if wo_status = "C" or wr_status = "C" then open_ref = 0.


/*IFP*/  total_time = open_ref * wr_run.

/*LW*/ find first op_hist  where 
/* SS 090715.1 - B */
					op_domain = global_domain and
/* SS 090715.1 - E */
				op_type = "labor" and (op_wo_lot = wr_lot and op_wo_op = wr_op)  no-lock no-error.
/*LW*/  IF available OP_HIST THEN DO:
/*LW*/     OPDATE = OP_DATE.
/*LW*/     END.
/*LW*/     ELSE DO: 
/*LW*/     OPDATE = ?.
/*LW*/     END.
/*LW*/
/*plj
	 display
/*B096*/ "  工序:" + string(wr_op) @ wo_nbr
/*B096   wo_lot*/
	 wo_part
/*B096*/ @ wo_lot
/*D248*/ wr_desc
/*D248*/ wr_vend @ wo_vend open_ref @ wo_qty_ord wr_setup
/*D248*/ wr_run column-label "标准加工/件"
/*IFP*/  total_time 
	 wr_wkctr @ wo_vend
	 wr_mch @ wo_so_job column-label "销售定制!设备"
	 wr_status @ wo_status
	 wr_start @ wo_rel_date wr_due @ wo_due_date with frame b width 255 STREAM-IO /*GUI*/ .
	 /* END SECTION */
plj*/

         put "GX:" at 1 string(wr_op) format "x(6)" at 4 wr_std_op at 11 wr_desc at 20 wr_qty_ord format ">>>>>9.9<" to 53 wr_qty_comp format ">>>>>9.9<" to 63 open_ref format ">>>>>9.9<" to 73 
            wr_wkctr at 75 wr_mch at 84 wr_status at 93 wr_setup format ">>9.99<<" to 103 wr_run format ">>9.999<<" to 113 total_time format ">>>9.999<<" to 124 wr_start at 126 wr_due at 135 
             OPdate AT 144 WO_REL_DATE AT 153 WO_DUE_DATE AT 164.
         
         if page-size - line-counter < 1 then do:
           put skip(1).
           page.
           put skip(1).
           put "加工单 / 标 志                                                                     销售定制" at 1.
          put "   工序 / 标准工序        零   件   号       订 货 量 已完成量  短缺量    工作中心  设  备  ST  准  时   单   时  短缺量工时 起始时间 完成时间 汇报日期 工单下达日 工单到期日" at 1.
          put "------------------ ------------------------ --------- --------- --------- -------- -------- -- -------- --------- ---------- -------- -------- -------- ---------- ----------" at 1.

         end.
     
/* SS 090715.1 - B */
/*
/*GUI*/ {mfguirex.i  "false"} /*Replace mfrpexit*/
*/
/* SS 090715.1 - E */

   /*D811*/
      end.
      put skip(1).
      
      if page-size - line-counter > 2 then do:
           put "------------------ ------------------------ --------- --------- --------- -------- -------- -- -------- --------- ---------- -------- -------- -------- ---------- ----------" at 1.
      end.
               
/*      down 1.*/
/* SS 090715.1 - B */
/*      
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/
*/
/* SS 090715.1 - E */
   end.
end. /*IFP*/
else do:
                   
                   
      for each wr_route where wr_lot >= lot and wr_lot <= lot1 
/* SS 090715.1 - B */
					and wr_domain = global_domain
/* SS 090715.1 - E */
/*IFP*/   and wr_wkctr >= wkctr and wr_wkctr <= wkctr1 
/*IFP*/   and wr_op >= op and wr_op <= op1 
/*IFP*/   and wr_mch >= mch and wr_mch <= mch1
/*IFP*/   and wr_start >= start and wr_start <= start1
/*IFP*/   and wr_due >= due and wr_due <= due1
/*IFP*/   and wr_nbr >= nbr and wr_nbr <= nbr1,
/*IFP*/   each wo_mstr where (wo_lot = wr_lot)
/* SS 090715.1 - B */
					and wo_domain = global_domain
/* SS 090715.1 - B */
/*IFP*/   and (wo_part >= part and wo_part <= part1)
/*IFP*/   and (wo_so_job >= so_job and wo_so_job <= so_job1)
/*IFP*/   and (wo_vend >= vend and wo_vend <= vend1)
/*lw */   and (wo_rel_Date >= rel_date and wo_rel_date <= rel_date1)
/*lw*/    and (wo_due_date >= due_date and wo_due_date <= due_date1) 
          and (wo_status = "R") 
          no-lock by wr_part by wr_op with frame c STREAM-IO width 132 no-labels no-box:
           
             open_ref = max(wr_route.wr_qty_ord - (wr_route.wr_qty_comp + wr_route.wr_sub_comp) - wr_route.wr_qty_rjct,0).
             total_time = open_ref * wr_route.wr_run.

             find first wrroute where wrroute.wr_nbr = wr_route.wr_nbr 
/* SS 090715.1 - B */
							and wrroute.wr_domain = global_domain
/* SS 090715.1 - E */
             and wrroute.wr_lot = wr_route.wr_lot 
             and wrroute.wr_op > wr_route.wr_op 
             use-index wr_nbrop no-lock no-error.
             
             if available wrroute then assign nextctr = wrroute.wr_wkctr 
                                              nextop = wrroute.wr_op
                                              nextopdesc = wrroute.wr_desc.
             else assign nextctr = "" 
                         nextop = 0 
                         nextopdesc = "".                                             
             find first wc_mstr where 
/* SS 090715.1 - B */
							wc_domain = global_domain and
/* SS 090715.1 - E */             
             wc_wkctr = wrroute.wr_wkctr and wc_mch = wrroute.wr_mch no-lock no-error.
             if available wc_mstr then nextctrdesc = wc_desc.
             else nextctrdesc = "".
/*lw*/             desc2 = "".
/*lw*/             desc3 = "".
/*LW*/             DESC4 = "". 
/*lw*/              if substring(wr_route.wr_wkctr,1,2) = "23" then do :
/*LW*/                 DESC4 = wr_route.wr_DESC. 
/*lw*/                 find FIRST wod_det where 
/* SS 090715.1 - B */
												wod_domain = global_domain and
/* SS 090715.1 - B */
												wod_lot = wo_lot and wod_qty_req <> 0 no-lock no-error.    
/*lw*/                 if available wod_det then find pt_mstr where 
/* SS 090715.1 - B */
												pt_domain = global_domain and
/* SS 090715.1 - E */
												pt_part = wod_part no-lock no-error.
/*lw*/                 if available pt_mstr then desc2 = pt_desc1.
/*lw*/                 desc3 = "材料：".
/*lw*/                 end. /*end for substring(wr_wkctr,1,2) = "23" */

             if wo_status = "C" or wr_route.wr_status = "C" then do:
                open_ref = 0.
                next.
             end.
             
             find pt_mstr where 
/* SS 090715.1 - B */
							pt_domain = global_domain and
/* SS 090715.1 - E */             
             pt_part = wo_part no-lock no-error.
             find first wc_mstr where 
/* SS 090715.1 - B */
							wc_domain = global_domain and 
/* SS 090715.1 - E */
             wc_wkctr = wr_route.wr_wkctr and wc_mch = wr_route.wr_mch no-lock no-error.
             
             if page-size - line-counter < 29 then page.
  /**************************           
                              
/*IFP*/     addprint[1]   = "  员工号码：_____________ 工作者：________________    产品：_________     单位：件        ".
/*IFP*/     printline[1]  = "┌───┬────┬────┬─────┬──┬────┬──┬────────────┐".
/*IFP*/     printline[2]  = "│部 门 │        │工作中心│          │设备│        │描述│                        │".
/*IFP*/     printline[3]  = "├───┼────┴─┬──┼─────┼──┴─┬──┴──┴┬───┬───────┤".
/*IFP*/     printline[4]  = "│加工单│            │标志│          │下达日期│            │到期日│              │".
/*IFP*/     printline[5]  = "├───┼──────┴──┼──┬──┴────┴──────┴───┴───────┤".
/*IFP*/     printline[6]  = "│零 件 │                  │描述│                                                    │".
/*IFP*/     printline[7]  = "├───┼───┬──┬──┴──┴──────┬───┬─────┬───┬─────┤".
/*IFP*/     printline[8]  = "│工 序 │      │描述│                        │需求量│          │短缺量│          │".
/*IFP*/     printline[9]  = "├───┼───┼──┴┬───────────┴┬──┴─┬───┴───┴─────┤".
/*IFP*/     printline[10] = "│加工量│      │下工序│                        │工作中心│                          │".
/*IFP*/     printline[11] = "├───┴──┬┴───┴───┬──────┬─┴────┴┬────┬───────┤".
/*IFP*/     printline[12] = "│标准准备时间│                │标准工时/件 │              │合计工时│              │".
/*IFP*/     printline[13] = "├──────┼────────┼──────┼───────┼────┴─┬─────┤".
/*IFP*/     printline[14] = "│实际准备时间│                │实际加工工时│              │ 首检(日/月)│          │". 
/*IFP*/     printline[15] = "├──────┼───┬──┬─┴─┬──┬─┴─┬──┬──┴┬──┬──┴┬────┤".
/*IFP*/     printline[16] = "│分厂验收合格│      │可用│      │废品│      │签字│      │日期│      │完成工时│".
/*IFP*/     printline[17] = "├──────┼───┼──┼───┼──┼───┼──┼───┼──┼───┼────┤".
/*IFP*/     printline[18] = "│总厂验收合格│      │可用│      │废品│      │签字│      │日期│      │        │".
/*IFP*/     printline[19] = "├──────┴───┴──┴───┴──┴───┴──┴───┴──┴───┴────┤".
/*IFP*/     printline[20] = "│  转出人：___________  签收人：___________  实收量：____________ 日期:____________    │".
/*IFP*/     printline[21] = "├───────────────────────────────────────────┤".
/*IFP*/     printline[22] = "│                                                                                      │".
/*IFP*/     printline[23] = "│                                                                                      │".
/*IFP*/     printline[24] = "│                                                                                      │".
/*IFP*/     printline[25] = "└───────────────────────────────────────────┘".
   
             display "工   艺   流   程   单" at 37 skip(1).
             display "员工号码：____________     工作者：______________     班组：___________ "  at 6 "   单位：" pt_um.
             display printline[1] at 5.
             display "│部 门 │" at 5  wc_dept at 15 "│工作中心│" at 23 wr_route.wr_wkctr at 35 "│设备│" at 45 wr_route.wr_mch at 53 "│描述│" at 61 wc_desc at 69 "│" at 93.
             display printline[3] at 5.
             display "│加工单│" at 5 wo_nbr format "X(12)" at 15 "│标志│" at 27 wo_lot at 35 "│下达日期│" at 45 wo_mstr.wo_rel_date format "99/99/9999" at 58 "│到期日│" at 69 wo_mstr.wo_due_date format "99/99/9999" at 80 "│" at 93.
             display printline[5] at 5.
             display "│零 件 │" at 5 wo_part at 15 "│描述│" at 33 pt_desc1 format "x(24)" at 41 pt_desc2 format "x(24)" to 92 "│" at 93 .
             display printline[7] at 5.
             display "│工 序 │" at 5 wr_route.wr_op at 15 "│描述│" at 21 TRIM(wr_route.wr_desc) format "x(24)" at 29 "│需求量│" at 53 wr_route.wr_qty_ord format ">>>>>9.99" to 72 "│短缺量│" at 73 open_ref format ">>>>>9.99" at 83  "│" at 93.          
             display printline[9] at 5.
             display "│加工量│      │下工序│" at 5 string(nextop) + ' ' + nextopdesc format "x(24)" at 31   "│工作中心│" at 55 nextctr + " " + nextctrdesc format "x(26)" at 67 "│" at 93.
             display printline[11] at 5.
             display "│标准准备时间│" at 5 wr_route.wr_setup to 36 "│标准工时/件 │" at 37 wr_route.wr_run to 66  "│合计工时│" at 67 total_time to 92 "│" at 93. 
             display printline[13] at 5.
             display printline[14] at 5.
             display printline[15] at 5.
             display printline[16] at 5.
             display printline[17] at 5.
             display printline[18] at 5.
             display printline[19] at 5.
             display printline[20] at 5.
             display printline[21] at 5.
             display "│" at 5 desc3 at 7 desc2 at 15 DESC4 AT 42 "│" at 93.
             
             display printline[23] at 5.
             display printline[24] at 5.
             display printline[25] at 5 skip(1).
             display "--------------------------------------------------------------------------------------------------" at 2 skip(2).

             down.
***********************/
addprint[1]   = "  员工号码：____________     工作者：______________     产品：___________   单位： 件".
printline[1]  = "+---------------------------------------------------------------------------------------+".
printline[2]  = "|工作中心|          |描述|                              |加工单|         |标志|         |".
                /* 1223456789012345678901234567890123456789012345678901234567890*/
printline[3]  = "+---------------------------------------------------------------------------------------+".
printline[4]  = "|零件|                  |描述|                                |需求量|     |短缺量|     |".
                /* 122345678901234567890123456789012345678901234567890123456789012345678901234567890123456789*/
printline[5]  = "+---------------------------------------------------------------------------------------+".
printline[6]  = "|投入数|      |工序|      |描述|                          |下工序|                      |".
                /* 122345678901234567890123456789012345678901234567890123456789012345678901234567890123456789    */                   
printline[7]  = "+---------------------------------------------------------------------------------------+".
printline[8]  = "|标准准备|          |标准工时|            |实际准备|           |实际加工|               |".
printline[9]  = "+---------------------------------------------------------------------------------------+".
printline[10]  = "|  自检  |  互检  |首检项目|实测结果|  判定  | 首检人 | 日期 |       巡   检            |".
printline[11]  = "+---------------------------------------------------------------------------------------+".
printline[12]  = "|        |        |        |        |        |        |      |                          |".
printline[13]  = "+------------------------------------------------------------|                          |".
printline[14]  = "|        |        |        |        |        |        |      |                          |".
printline[15]  = "+------------------------------------------------------------|                          |".
printline[16]  = "|        |        |        |        |        |        |      |                          |".
printline[17]  = "+---------------------------------------------------------------------------------------+".
printline[18]  = "|        |        |        |        |        |        |      |借图                      |".
printline[19]  = "+---------------------------------------------------------------------------------------+".
printline[20]  = "|        |        |        |        |        |        |      |还图                      |".
printline[21]  = "+---------------------------------------------------------------------------------------+".
printline[22]  = "|终检合格|        |让步|        |料废|       |工废|       |终检人|        |日期|        |".
printline[23]  = "+---------------------------------------------------------------------------------------+".
printline[24]  = " 转出人：___________  签收人：___________  实收量：____________ 日期:____________     ".

             display "工   艺   流   程   单" at 37 skip(1).
             display " 员工号码：____________     工作者：______________     产品：___________  "  at 6 "   单位：" pt_um.
             display printline[1] at 5.
             display "|工作中心|" at 5 wr_route.wr_wkctr at 15 "|描述|" at 24 wc_desc format "x(18)" at 30 "│加工单│" at 54 wo_nbr format "x(12)" at 64 "│标志│" at 77 wo_lot  format "x(8)" at 85 "│" at 93.
             display printline[3] at 5.
             display "|零件|" at 5 wo_part at 12 "|描述|" at 30 pt_desc1 format "x(18)" at 36 "|需求量|" at 61 wr_route.wr_qty_ord format ">>>9.99" at 69 
               "|短缺量|" at 77 open_ref format ">>>9.99" at 85 "|" at 93.
             display printline[5] at 5.
             display "|投入数|      |工序|" at 5 wr_route.wr_op at 26 "|描述|" at 32 TRIM(wr_route.wr_desc) format "x(18)" at 38 "|下工序|" 
             at 63  string(nextop) + ' ' + nextopdesc format "x(18)" at 74 "|" at 93.
             display printline[7] at 5.
             display "|标准准备|" at 5 wr_route.wr_setup at 15 "|标准工时|" at 25   wr_route.wr_run at 35
              "|实际准备|            |实际加工|           |" at 50.
             display printline[9] at 5.
             display printline[10] at 5.
             display printline[11] at 5.
             display printline[12] at 5.
             display printline[13] at 5.
             display printline[14] at 5.
             display printline[15] at 5.
             display printline[16] at 5.
             display printline[17] at 5.
             display printline[18] at 5.
             display printline[19] at 5.
             display printline[20] at 5.
             display printline[21] at 5.
             display printline[22] at 5.
             display printline[23] at 5.
             display printline[24] at 5.
                down.
             
             
      end. /*IFP*/
end. /*IFP*/
   /* REPORT TRAILER */
/* SS 090715.1 - B */
/*
/*plj   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/
plj*/
*/
				{mfreset.i}
/* SS 090715.1 - E */
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end.

/* SS 090715.1 - B */
/*
/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" nbr nbr1 lot lot1 part part1 so_job so_job1 
vend vend1 wkctr wkctr1 mch mch1 op op1 start start1 due due1 OPDATE OPDATE1 rel_date rel_date1 due_date due_date1 sort_op"} /*Drive the Report*/
*/
end.
/* SS 090715.1 - E */
