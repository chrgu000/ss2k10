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


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "f "}  /*G999*/ /*GUI moved to top.*/
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
/*IFP*/    define variable total_time like wr_run column-label "标准工时".
/*IFP*/    define variable start  like wr_star.
/*IFP*/    define variable start1 like wr_star.
/*IFP*/    define variable due    like wr_due.
/*IFP*/    define variable due1   like wr_due.
/*IFP*/  define variable printline as character format "x(90)" extent 28.
/*IFP*/  define variable addprint  as character format "x(90)" extent 28.
/*IFP*/ define buffer wrroute for wr_route.
/*IFP*/ define variable nextctr like wr_wkctr.
/*IFP*/ define variable nextop like wr_op .
/*IFP*/ define variable nextctrdesc like wc_desc.
/*IFP*/ define variable nextopdesc like wr_desc .

/* DISPLAY TITLE */
/*GUI moved mfdeclre/mfdtitle.*/


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
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
skip(1)

 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " 选择条件 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME




/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

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

run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


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

   /* SELECT PRINTER  */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
             
                   
      for each wr_route where wr_lot >= lot and wr_lot <= lot1 
/*IFP*/   and wr_wkctr >= wkctr and wr_wkctr <= wkctr1 
/*IFP*/   and wr_op >= op and wr_op <= op1 
/*IFP*/   and wr_mch >= mch and wr_mch <= mch1
/*IFP*/   and wr_start >= start and wr_start <= start1
/*IFP*/   and wr_due >= due and wr_due <= due1
/*IFP*/   and wr_nbr >= nbr and wr_nbr <= nbr1,
/*IFP*/   each wo_mstr where (wo_lot = wr_lot)
/*IFP*/   and (wo_part >= part and wo_part <= part1)
/*IFP*/   and (wo_so_job >= so_job and wo_so_job <= so_job1)
/*IFP*/   and (wo_vend >= vend and wo_vend <= vend1)
          and (wo_status = "R") 
          no-lock by wr_part by wr_op with frame c STREAM-IO width 132 no-labels no-box:
           
             open_ref = max(wr_route.wr_qty_ord - (wr_route.wr_qty_comp + wr_route.wr_sub_comp) - wr_route.wr_qty_rjct,0).
             total_time = open_ref * wr_route.wr_run.

             find first wrroute where wrroute.wr_nbr = wr_route.wr_nbr 
             and wrroute.wr_lot = wr_route.wr_lot 
             and wrroute.wr_op > wr_route.wr_op 
             use-index wr_nbrop no-lock no-error.
             
             if available wrroute then assign nextctr = wrroute.wr_wkctr 
                                              nextop = wrroute.wr_op
                                              nextopdesc = wrroute.wr_desc.
             else assign nextctr = "" 
                         nextop = 0 
                         nextopdesc = "".                                             
             find first wc_mstr where wc_wkctr = wrroute.wr_wkctr and wc_mch = wrroute.wr_mch no-lock no-error.
             if available wc_mstr then nextctrdesc = wc_desc.
             else nextctrdesc = "".
                         

             if wo_status = "C" or wr_route.wr_status = "C" then do:
                open_ref = 0.
                next.
             end.
             
             find pt_mstr where pt_part = wo_part no-lock no-error.
             find first wc_mstr where wc_wkctr = wr_route.wr_wkctr and wc_mch = wr_route.wr_mch no-lock no-error.
             
             if page-size - line-counter < 27 then page.
             
                 
                 
/*IFP*/     addprint[1]   = "  员工号码：_____________    姓名：________________    班组：_________     单位：         ".
/*IFP*/     printline[1]  = "┌───┬────┬────┬─────┬──┬────┬──┬────────────┐".
/*IFP*/     printline[2]  = "│部 门 │        │工作中心│          │设备│        │描述│                        │".
/*IFP*/     printline[3]  = "├───┼────┴─┬──┼─────┼──┴─┬──┴──┴┬───┬───────┤".
/*IFP*/     printline[4]  = "│加工单│            │标志│          │开始日期│            │到期日│              │".
/*IFP*/     printline[5]  = "├───┼──────┴──┼──┬──┴────┴──────┴───┴───────┤".
/*IFP*/     printline[6]  = "│零 件 │                  │描述│                                                    │".
/*IFP*/     printline[7]  = "├───┼───┬──┬──┴──┴────┬───┬──────┬───┬──────┤".
/*IFP*/     printline[8]  = "│工 序 │      │描述│                    │需求量│            │短缺量│            │".
/*IFP*/     printline[9]  = "├───┼───┼──┴┬─────────┴──┬┴───┬──┴───┴──────┤".
/*IFP*/     printline[10] = "│加工量│      │下工序│                        │工作中心│                          │".
/*IFP*/     printline[11] = "├──┬┴──┬┴─┬─┴───┬──┬─────┼────┼──┬──────┬───┤".
/*IFP*/     printline[12] = "│准时│      │单时│          │合计│          │实际准时│    │实际加工工时│      │".
/*IFP*/     printline[13] = "├──┼───┼──┴─┬───┴─┬┴───┬─┴───┬┴─┬┴──┬──┬┴───┤".
/*IFP*/     printline[14] = "│材质│      │来料规格│          │代用规格│          │件重│      │总重│        │". 
/*IFP*/     printline[15] = "├──┴─┬─┴┬───┴──┬──┴─┬──┼───┬─┴┬─┴─┬─┴─┬┴────┤".
/*IFP*/     printline[16] = "│来料日期│    │来料验收合格│        │可用│      │废品│      │检查员│          │".
/*IFP*/     printline[17] = "├────┼──┴┬──┬──┴┬──┬┴──┼──┬┴──┼──┬┴───┴┬────┤".
/*IFP*/     printline[18] = "│成品件重│      │总重│      │技术│      │计调│      │首检│1         │2       │".
/*IFP*/     printline[19] = "├────┴─┬─┴─┬┴─┬─┴┬─┴┬──┼──┼──┬┴──┼─────┼────┤".
/*IFP*/     printline[20] = "│分厂验收合格│      │可用│    │工废│    │料废│    │检查员│          │完成工时│".
/*IFP*/     printline[21] = "├──────┼───┼──┼──┼──┼──┼──┼──┼───┼─────┼────┤".
/*IFP*/     printline[22] = "│总厂验收合格│      │可用│    │工废│    │料废│    │检查员│          │        │".
/*IFP*/     printline[23] = "├──────┴───┴──┴──┴──┴──┴──┴──┴───┴─────┴────┤".
/*IFP*/     printline[24] = "│  转出人：___________  签收人：___________  实收量：____________ 日期:____________    │".
/*IFP*/     printline[25] = "├───────────────────────────────────────────┤".
/*IFP*/     printline[26] = "│ 施工说明：                                                                           │".
/*IFP*/     printline[27] = "└───────────────────────────────────────────┘".
             display "工   艺   流   程   单" at 37 .
             display "员工号码：____________     工作者：______________     班组：___________ "  at 6 "   单位：" pt_um.
             display printline[1] at 5.
             display "│部 门 │" at 5  wc_dept at 15 "│工作中心│" at 23 wr_route.wr_wkctr at 35 "│设备│" at 45 wr_route.wr_mch at 53 "│描述│" at 61 wc_desc at 69 "│" at 93.
             display printline[3] at 5.
             display "│加工单│" at 5 wo_nbr format "X(12)" at 15 "│标志│" at 27 wo_lot at 35 "│开始日期│" at 45 wr_route.wr_start format "99/99/9999" at 58 "│到期日│" at 69 wr_route.wr_due format "99/99/9999" at 80 "│" at 93.
             display printline[5] at 5.
             display "│零 件 │" at 5 wo_part at 15 "│描述│" at 33 pt_desc1 format "x(24)" at 41 pt_desc2 format "x(24)" to 92 "│" at 93 .
             display printline[7] at 5.
             display "│工 序 │" at 5 wr_route.wr_op at 15 "│描述│" at 21 wr_route.wr_desc format "x(20)" at 29 "│需求量│" at 49 wr_route.wr_qty_ord format ">>>>>>>9.99" to 70 "│短缺量│" at 71 open_ref format ">>>>>>>9.99" at 81  "│" at 93.          
             display printline[9] at 5.
             display "│加工量│      │下工序│" at 5 string(nextop) + ' ' + nextopdesc format "x(24)" at 31   "│工作中心│" at 55 nextctr + " " + nextctrdesc format "x(26)" at 67 "│" at 93.
             display printline[11] at 5.
             display "│准时│" at 5 wr_route.wr_setup format ">9.99<" to 18 "│单时│" at 19 wr_route.wr_run format ">>>9.99<<<" to 36  "│合计│" at 37 total_time format ">>>>9.99<<" to 54 "│实际准时│    │实际加工工时│      │" at 55. 
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
             display printline[25] at 5.
             display printline[26] at 5.
             display printline[27] at 5 skip(1).
             display "--------------------------------------------------------------------------------------------------" at 2 skip(1).

             down.

      end. /*IFP*/

   /* REPORT TRAILER */
   
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end.

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" nbr nbr1 lot lot1 part part1 so_job so_job1 
vend vend1 wkctr wkctr1 mch mch1 op op1 start start1 due due1"} /*Drive the Report*/
