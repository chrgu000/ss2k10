/* GUI CONVERTED from retrform.i (converter v1.71) Tue Oct  6 14:45:33 1998 */
/* retrform.i - REPETITIVE                                                    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.       */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/*K1Q4*/ /*V8:WebEnabled=No                                                   */
/* REVISION: 7.3               LAST MODIFIED: 10/31/94   BY: WUG *GN77*       */
/*                                            02/28/95   by: srk *G0FZ*       */
/* REVISION: 7.3               LAST MODIFIED: 03/07/95   BY: WUG *G0GQ*       */
/* REVISION: 7.3               LAST MODIFIED: 03/08/95   BY: WUG *G0GR*       */
/* REVISION: 7.3               LAST MODIFIED: 03/17/95   BY: pcd *G0HN*       */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE retrform_i_1 "Op"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_2 "换算"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_3 "实际准备时间"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_4 "累计完成量"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_5 "BOM"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_6 "错误: 不是一个有效值"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_7 "加工时间/停止时间"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_8 "转入下道工序"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_9 "Input/Output"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_10 "多记录"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_11 "库存差异帐户"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_12 "修改回冲"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_13 "修改收货"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_14 "自队列"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_15 "开始时间"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_16 "至工序"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_17 "要排队"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_18 "次品转移至工序"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_19 "返工量"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_20 "原因代码"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_21 "废品数量"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_22 "次品量"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_23 "已处理量"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_24 "待转移的量"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_25 "工艺流程"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* TRANSACTIONS INPUT FORM/FRAME DEFINITIONS                                  */

def {1} shared var act_run_hrs like op_act_run.
def {1} shared var act_setup_hrs like op_act_run label {&retrform_i_3}.
def {1} shared var bom_code like wo_bom_code label {&retrform_i_5}.
def {1} shared var earn_code like op_earn.
def {1} shared var conv like um_conv label {&retrform_i_2}.
def {1} shared var cum_comp_qty like wr_qty_comp label {&retrform_i_4}.
def {1} shared var dept like dpt_dept.
def {1} shared var discr_acct like glt_acct label {&retrform_i_11}.   /*G0GQ*/
def {1} shared var discr_cc like glt_acct.              /*G0GQ*/
def {1} shared var down_rsn_code like rsn_code.
def {1} shared var eff_date like tr_effdate.
def {1} shared var emp like op_emp.
def {1} shared var from_que like mfc_logical label {&retrform_i_14}     /*G0GR*/
   format {&retrform_i_9}.                       /*G0GR*/
def {1} shared var inque_rsn_code like rsn_code.
def {1} shared var inque_multi_entry like mfc_logical label {&retrform_i_10}.
def {1} shared var line like ln_line.
def {1} shared var mch like wr_mch.
def {1} shared var mod_issrc like mfc_logical label {&retrform_i_12}.
def {1} shared var move_next_op like mfc_logical label {&retrform_i_8}.
def {1} shared var op like ro_op.
def {1} shared var outque_rsn_code like rsn_code.
def {1} shared var outque_multi_entry like mfc_logical label {&retrform_i_10}.
def {1} shared var part like pt_part.
def {1} shared var qty_proc like op_qty_comp label {&retrform_i_23}.
def {1} shared var qty_move like wr_qty_move label {&retrform_i_24}.
def {1} shared var qty_inque like wr_qty_inque.
def {1} shared var qty_outque like wr_qty_outque.
def {1} shared var qty_rejque like wr_qty_rejque.
def {1} shared var qty_rjct like op_qty_rjct label {&retrform_i_22}.
def {1} shared var qty_rwrk like op_qty_rjct label {&retrform_i_19}.
def {1} shared var qty_scrap like op_qty_rjct label {&retrform_i_21}.
def {1} shared var rejque_rsn_code like rsn_code.
def {1} shared var rejque_multi_entry like mfc_logical label {&retrform_i_10}.
def {1} shared var rwrk_rsn_code like rsn_code.
def {1} shared var rwrk_multi_entry like mfc_logical label {&retrform_i_10}.
def {1} shared var rjct_rsn_code like rsn_code.
def {1} shared var run_ea_desc like ea_desc.
def {1} shared var routing like wo_routing label {&retrform_i_25}.
def {1} shared var scrap_rsn_code like rsn_code.
def {1} shared var setup_ea_desc like ea_desc.
def {1} shared var shift like op_shift.
def {1} shared var site like op_site.
def {1} shared var start_run as char label {&retrform_i_15} format "99:XX:XX".
def {1} shared var stop_run like start_run label {&retrform_i_7}.
def {1} shared var to_op like op_wo_op label {&retrform_i_16}.
def {1} shared var to_que like mfc_logical label {&retrform_i_17}         /*G0GR*/
   format {&retrform_i_9}.                       /*G0GR*/
def {1} shared var um like pt_um.
def {1} shared var wkctr like wr_wkctr.
def {1} shared frame a.
def {1} shared frame b.
def {1} shared frame bkfl1.
def {1} shared frame reject1.
def {1} shared frame scrap1.
def {1} shared frame lbr1.
def {1} shared frame set1.
def {1} shared frame dt1.
def {1} shared frame rework1.
def {1} shared frame move1.
def {1} shared frame adjust1.
def {1} shared frame cumadj1.

def var valmsg as char init {&retrform_i_6}.




/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
emp          colon 13 LABEL "雇员"
   ad_name      no-label no-attr-space
   eff_date     colon 13 {reval.i eff_date} LABEL "生效日期"
   shift        {reval.i shift} LABEL "班次"
   site LABEL "地点"
   part         colon 13 LABEL "零件号"
   pt_desc1     at 36 no-label no-attr-space
   op           colon 13 LABEL "工序"
   wr_desc      at 36 no-label no-attr-space
   line         colon 13 LABEL "序号"
   ln_desc      at 36 no-label no-attr-space
   routing      colon 13 LABEL "工艺流程"
   bom_code     colon 43
   wo_lot
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME




FORM /*GUI*/ 
/*G0FZ*/ 
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
space(1)
   site
   part
   op           label {&retrform_i_1}
   line
 SKIP(.4)  /*GUI*/
with frame b side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/



FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wkctr        colon 18 LABEL "工作中心"
   mch          colon 43 LABEL "设备"
   wc_desc      no-label no-attr-space
   dept         colon 18 LABEL "部门"
   dpt_desc     at 36 no-label no-attr-space
   qty_proc     colon 18 {reval.i qty_proc}
   um           colon 45 {reval.i um}
   conv         colon 61 {reval.i conv}
   qty_scrap        colon 18 {reval.i qty_scrap}
   scrap_rsn_code    colon 45 label {&retrform_i_20} {reval.i scrap_rsn_code}
   outque_multi_entry   {reval.i outque_multi_entry}
   qty_rjct     colon 18 {reval.i qty_rjct}
   rjct_rsn_code        colon 45 label {&retrform_i_20} {reval.i rjct_rsn_code}
   rejque_multi_entry   {reval.i rejque_multi_entry}
   to_op        colon 18 label {&retrform_i_18}
   mod_issrc        colon 45 {reval.i mod_issrc}
   move_next_op     colon 68 {reval.i move_next_op}
   act_run_hrs      colon 18 {reval.i act_run_hrs} LABEL "实际加工时间"
   start_run        colon 68 {reval.i start_run}
   earn_code        colon 18 LABEL "收入代码"
   ea_desc      no-label no-attr-space format "x(22)"
   stop_run         colon 68 {reval.i stop_run}
 SKIP(.4)  /*GUI*/
with frame bkfl1 side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-bkfl1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame bkfl1 = F-bkfl1-title.
 RECT-FRAME-LABEL:HIDDEN in frame bkfl1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame bkfl1 =
  FRAME bkfl1:HEIGHT-PIXELS - RECT-FRAME:Y in frame bkfl1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME bkfl1 = FRAME bkfl1:WIDTH-CHARS - .5.  /*GUI*/



FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wkctr        colon 18
   mch          colon 43
   wc_desc      no-label no-attr-space
   dept         colon 18
   dpt_desc     at 36 no-label no-attr-space
   um           colon 18 {reval.i um}
   conv         colon 45 {reval.i conv}
   from_que         colon 18 {reval.i from_que}         /*G0GR*/
   qty_rjct     colon 18 {reval.i qty_rjct}
   rjct_rsn_code        colon 45 label {&retrform_i_20} {reval.i rjct_rsn_code}
   rejque_multi_entry   {reval.i rejque_multi_entry}
   to_op        colon 18
   wr_desc      no-label
 SKIP(.4)  /*GUI*/
with frame reject1 side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-reject1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame reject1 = F-reject1-title.
 RECT-FRAME-LABEL:HIDDEN in frame reject1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame reject1 =
  FRAME reject1:HEIGHT-PIXELS - RECT-FRAME:Y in frame reject1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME reject1 = FRAME reject1:WIDTH-CHARS - .5.  /*GUI*/



FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wkctr        colon 18
   mch          colon 43
   wc_desc      no-label no-attr-space
   dept         colon 18
   dpt_desc     at 36 no-label no-attr-space
   um           colon 18 {reval.i um}
   conv         colon 45 {reval.i conv}
   qty_inque        colon 18 {reval.i qty_inque}
   inque_rsn_code   colon 45 {reval.i inque_rsn_code}
   inque_multi_entry    {reval.i inque_multi_entry}
   qty_outque       colon 18 {reval.i qty_outque}
   outque_rsn_code  colon 45 {reval.i outque_rsn_code}
   outque_multi_entry   {reval.i outque_multi_entry}
   qty_rejque       colon 18 {reval.i qty_rejque}
   rejque_rsn_code  colon 45 {reval.i rejque_rsn_code}
   rejque_multi_entry   {reval.i rejque_multi_entry}
 SKIP(.4)  /*GUI*/
with frame scrap1 side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-scrap1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame scrap1 = F-scrap1-title.
 RECT-FRAME-LABEL:HIDDEN in frame scrap1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame scrap1 =
  FRAME scrap1:HEIGHT-PIXELS - RECT-FRAME:Y in frame scrap1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME scrap1 = FRAME scrap1:WIDTH-CHARS - .5.  /*GUI*/



FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wkctr        colon 16
   mch          colon 43
   wc_desc      no-label no-attr-space
   dept         colon 16
   dpt_desc     at 36 no-label no-attr-space
   skip(1)
   act_run_hrs      colon 16 {reval.i act_run_hrs}
   start_run        colon 68 {reval.i start_run}
   earn_code        colon 16
   ea_desc      no-label no-attr-space
   stop_run         colon 68 {reval.i stop_run}
 SKIP(.4)  /*GUI*/
with frame lbr1 side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-lbr1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame lbr1 = F-lbr1-title.
 RECT-FRAME-LABEL:HIDDEN in frame lbr1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame lbr1 =
  FRAME lbr1:HEIGHT-PIXELS - RECT-FRAME:Y in frame lbr1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME lbr1 = FRAME lbr1:WIDTH-CHARS - .5.  /*GUI*/



FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wkctr        colon 16
   mch          colon 43
   wc_desc      no-label no-attr-space
   dept         colon 16
   dpt_desc     at 36 no-label no-attr-space
   skip(1)
   act_setup_hrs    colon 16 {reval.i act_setup_hrs}
   start_run        colon 68 {reval.i start_run}
   earn_code        colon 16
   ea_desc      no-label no-attr-space
   stop_run         colon 68 {reval.i stop_run}
 SKIP(.4)  /*GUI*/
with frame set1 side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-set1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame set1 = F-set1-title.
 RECT-FRAME-LABEL:HIDDEN in frame set1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame set1 =
  FRAME set1:HEIGHT-PIXELS - RECT-FRAME:Y in frame set1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME set1 = FRAME set1:WIDTH-CHARS - .5.  /*GUI*/



FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wkctr        colon 18
   mch          colon 43
   wc_desc      no-label no-attr-space
   dept         colon 18
   dpt_desc     at 36 no-label no-attr-space
   start_run        colon 68 {reval.i start_run}
   act_run_hrs      colon 18 {reval.i act_run_hrs}
   stop_run         colon 68 {reval.i stop_run}
   down_rsn_code    colon 18 {reval.i down_rsn_code}
   earn_code        colon 18
   ea_desc      no-label no-attr-space
 SKIP(.4)  /*GUI*/
with frame dt1 side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-dt1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame dt1 = F-dt1-title.
 RECT-FRAME-LABEL:HIDDEN in frame dt1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame dt1 =
  FRAME dt1:HEIGHT-PIXELS - RECT-FRAME:Y in frame dt1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME dt1 = FRAME dt1:WIDTH-CHARS - .5.  /*GUI*/



FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wkctr        colon 18
   mch          colon 43
   wc_desc      no-label no-attr-space
   dept         colon 18
   dpt_desc     at 36 no-label no-attr-space
   um           colon 18 {reval.i um}
   conv         colon 45 {reval.i conv}
   qty_rwrk     colon 18 {reval.i qty_rwrk}
   rwrk_rsn_code        colon 45 label {&retrform_i_20} {reval.i rwrk_rsn_code}
   rwrk_multi_entry {reval.i rwrk_multi_entry}
   mod_issrc        colon 18 {reval.i mod_issrc}
   act_run_hrs      colon 18 {reval.i act_run_hrs}
   start_run        colon 68 {reval.i start_run}
   earn_code        colon 18
   ea_desc      no-label no-attr-space format "x(22)"
   stop_run         colon 68 {reval.i stop_run}
   to_op        colon 18
   wr_desc      no-label
   to_que       colon 68                    /*G0GR*/
 SKIP(.4)  /*GUI*/
with frame rework1 side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-rework1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame rework1 = F-rework1-title.
 RECT-FRAME-LABEL:HIDDEN in frame rework1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame rework1 =
  FRAME rework1:HEIGHT-PIXELS - RECT-FRAME:Y in frame rework1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME rework1 = FRAME rework1:WIDTH-CHARS - .5.  /*GUI*/



FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wkctr        colon 18
   mch          colon 43
   wc_desc      no-label no-attr-space
   dept         colon 18
   dpt_desc     at 36 no-label no-attr-space
   um           colon 18 {reval.i um}
   conv         colon 45 {reval.i conv}
   qty_move     colon 18 {reval.i qty_move}
   mod_issrc        colon 18 label {&retrform_i_13} /*G0HN*/
            {reval.i mod_issrc}
 SKIP(.4)  /*GUI*/
with frame move1 side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-move1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame move1 = F-move1-title.
 RECT-FRAME-LABEL:HIDDEN in frame move1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame move1 =
  FRAME move1:HEIGHT-PIXELS - RECT-FRAME:Y in frame move1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME move1 = FRAME move1:WIDTH-CHARS - .5.  /*GUI*/



FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wkctr        colon 18
   mch          colon 43
   wc_desc      no-label no-attr-space
   dept         colon 18
   dpt_desc     at 36 no-label no-attr-space
   um           colon 18 {reval.i um}
   qty_inque        colon 18 {reval.i qty_inque}
   inque_rsn_code   colon 45 {reval.i inque_rsn_code}
   qty_outque       colon 18 {reval.i qty_outque}
   outque_rsn_code  colon 45 {reval.i outque_rsn_code}
   qty_rejque       colon 18 {reval.i qty_rejque}
   rejque_rsn_code  colon 45 {reval.i rejque_rsn_code}
   skip(1)                              /*G0GQ*/
   discr_acct       colon 18                    /*G0GQ*/
   discr_cc     no-label                    /*G0GQ*/
 SKIP(.4)  /*GUI*/
with frame adjust1 side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-adjust1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame adjust1 = F-adjust1-title.
 RECT-FRAME-LABEL:HIDDEN in frame adjust1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame adjust1 =
  FRAME adjust1:HEIGHT-PIXELS - RECT-FRAME:Y in frame adjust1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME adjust1 = FRAME adjust1:WIDTH-CHARS - .5.  /*GUI*/



FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
cum_comp_qty     colon 20 {reval.i cum_comp_qty}
 SKIP(.4)  /*GUI*/
with frame cumadj1 side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-cumadj1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame cumadj1 = F-cumadj1-title.
 RECT-FRAME-LABEL:HIDDEN in frame cumadj1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame cumadj1 =
  FRAME cumadj1:HEIGHT-PIXELS - RECT-FRAME:Y in frame cumadj1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME cumadj1 = FRAME cumadj1:WIDTH-CHARS - .5.  /*GUI*/

