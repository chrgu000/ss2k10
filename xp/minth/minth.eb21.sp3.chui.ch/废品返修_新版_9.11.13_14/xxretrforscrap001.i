/* retrform.i - REPETITIVE                                                    */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.16 $                                                         */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3               LAST MODIFIED: 10/31/94   BY: WUG *GN77*       */
/*                                            02/28/95   by: srk *G0FZ*       */
/* REVISION: 7.3               LAST MODIFIED: 03/07/95   BY: WUG *G0GQ*       */
/* REVISION: 7.3               LAST MODIFIED: 03/08/95   BY: WUG *G0GR*       */
/* REVISION: 7.3               LAST MODIFIED: 03/17/95   BY: pcd *G0HN*       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb                */
/* REVISION: 9.1      LAST MODIFIED: 09/11/00   BY: *N0RS* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.10     BY: Kirti Desai    DATE: 11/01/01  ECO: *N151*          */
/* Revision: 1.13     BY: Narathip W.    DATE: 04/19/03  ECO: *P0Q7*          */
/* Revision: 1.15     BY: Max Iles       DATE: 09/09/04  ECO: *N2XQ*          */
/* $Revision: 1.16 $    BY: Matthew Lee  DATE: 01/26/05  ECO: *P356*          */
/* $Revision: 1.16 $    BY: Mage Chen    DATE: 07/09/09  ECO: *minth*          */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
{cxcustom.i "RETRFORM.I"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE retrform_i_1 "Op"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_2 "Conv"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_3 "Act Setup Time"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_4 "Cum Completed Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_5 "BOM"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_7 "Elapsed or Stop Time"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_8 "Move Next Op"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_9 "Input/Output"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_10 "Multi Entry"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_11 "Inv Discrep Acct"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_12 "Modify Backflush"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_13 "Modify Receipt"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_14 "From Queue"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_15 "Start Time"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_16 "To Operation"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_17 "To Queue"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_18 "Reject To Op"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_19 "Qty Reworked"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_20 "Reason Code"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_21 "Qty Scrapped"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_22 "Qty Rejected"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_23 "Qty Processed"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_24 "Qty To Move"
/* MaxLen: Comment: */

&SCOPED-DEFINE retrform_i_25 "Routing"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* TRANSACTIONS INPUT FORM/FRAME DEFINITIONS                                  */

define {1} shared variable act_run_hrs        like op_act_run.
define {1} shared variable act_setup_hrs      like op_act_run
   label {&retrform_i_3}.
define {1} shared variable bom_code           like wo_bom_code
   label {&retrform_i_5}.
define {1} shared variable earn_code          like op_earn.
define {1} shared variable conv              like um_conv label {&retrform_i_2}.
define {1} shared variable cum_comp_qty       like wr_qty_comp
   label {&retrform_i_4}.
define {1} shared variable dept               like dpt_dept.
define {1} shared variable discr_acct         like glt_acct
   label {&retrform_i_11}.
define {1} shared variable discr_sub          like glt_sub.
define {1} shared variable discr_cc           like glt_cc.
define {1} shared variable down_rsn_code      like rsn_code.
define {1} shared variable eff_date           like tr_effdate.
define {1} shared variable emp                like op_emp.
define {1} shared variable from_que           like mfc_logical
   label {&retrform_i_14}
   format {&retrform_i_9}.
define {1} shared variable inque_rsn_code     like rsn_code.
define {1} shared variable inque_multi_entry  like mfc_logical
   label {&retrform_i_10}.
define {1} shared variable line               like ln_line.
define {1} shared variable mch                like wc_mch no-undo.
define {1} shared variable mod_issrc          like mfc_logical
   label {&retrform_i_12}.
define {1} shared variable move_next_op       like mfc_logical
   label {&retrform_i_8}.
define {1} shared variable op                 like ro_op no-undo.
define {1} shared variable outque_rsn_code    like rsn_code.
define {1} shared variable outque_multi_entry like mfc_logical
   label {&retrform_i_10}.
define {1} shared variable part               like pt_part.
define {1} shared variable qty_proc           like op_qty_comp
   label {&retrform_i_23}.
define {1} shared variable qty_move           like wr_qty_move
   label {&retrform_i_24}.
define {1} shared variable qty_inque          like wr_qty_inque.
define {1} shared variable qty_outque         like wr_qty_outque.
define {1} shared variable qty_rejque         like wr_qty_rejque.
define {1} shared variable qty_rjct           like op_qty_rjct
   label {&retrform_i_22}.
define {1} shared variable qty_rwrk           like op_qty_rjct
   label {&retrform_i_19}.
define {1} shared variable qty_scrap          like op_qty_rjct
   label {&retrform_i_21}.
define {1} shared variable rejque_rsn_code    like rsn_code.
define {1} shared variable rejque_multi_entry like mfc_logical
   label {&retrform_i_10}.
define {1} shared variable rwrk_rsn_code      like rsn_code.
define {1} shared variable rwrk_multi_entry   like mfc_logical
   label {&retrform_i_10}.
define {1} shared variable rjct_rsn_code      like rsn_code.
define {1} shared variable run_ea_desc        like ea_desc.
define {1} shared variable routing            like wo_routing
   label {&retrform_i_25}.
define {1} shared variable scrap_rsn_code     like rsn_code.
define {1} shared variable setup_ea_desc      like ea_desc.
define {1} shared variable shift              like op_shift.
define {1} shared variable site               like op_site.
define {1} shared variable start_run as character label {&retrform_i_15}
   format "99:XX:XX".
define {1} shared variable stop_run           like start_run
   label {&retrform_i_7}.
define {1} shared variable to_op          like op_wo_op label {&retrform_i_16}.
define {1} shared variable to_que             like mfc_logical
   label {&retrform_i_17}
   format {&retrform_i_9}.
define {1} shared variable um                 like pt_um.
define {1} shared variable wkctr              like wc_wkctr no-undo.

/***** start tx01****/
define {1} shared variable v_part like pt_part .
define {1} shared variable desc1  like pt_desc1.
define {1} shared variable desc2  like pt_desc2.
define {1} shared variable v_loc like loc_loc label "废品库位".
define {1} shared variable pdln like ln_line label "生产线".
define {1} shared variable v_qty_a   as decimal format ">,>>>,>>9.9" label "不良品数" no-undo .
define {1} shared variable v_qty_s   as decimal format ">,>>>,>>9.9" label "报废品数" no-undo .
define {1} shared variable v_qty_g   as decimal format ">,>>>,>>9.9" label "良品数" no-undo .
define {1} shared variable v_hrs  like op_act_run label "返修工时".
define {1} shared variable v_neediss   as logical initial no.

define {1} shared variable p_bc as char format "x(28)" label "条码".
define {1} shared variable rsn like op_rsn.
define {1} shared variable act_multi_entry like mfc_logical.
define {1} shared variable act_setup_hrs20 like act_setup_hrs.
define {1} shared variable stop_multi_entry like act_multi_entry.
define {1} shared variable non_prod_hrs like act_setup_hrs.
define {1} shared variable prod_multi_entry like act_multi_entry.
define {1} shared variable setup_rsn like rsn.
define {1} shared variable act_rsn_codes as character extent 10.
define {1} shared variable act_hrs like wr_qty_comp extent 10.
define {1} shared variable down_rsn_codes as character extent 10.
define {1} shared variable act_setup_hrs20s like wr_qty_comp extent 10.
define {1} shared variable pd_rsn_codes as character extent 10.
define {1} shared variable pd_non_prod_hrs like wr_qty_comp extent 10.
define {1} shared variable rsn_codes        as character   extent 10.
define {1} shared variable quantities       like wr_qty_comp extent 10.
define {1} shared variable scrap_rsn_codes  as character   extent 10.
define {1} shared variable scrap_quantities like wr_qty_comp extent 10.
define {1} shared variable reject_rsn_codes as character   extent 10.
define {1} shared variable reject_quantities like wr_qty_comp extent 10.
define {1} shared variable l_stat_undo as logical initial no.
define {1} shared variable b_qc as char.
define {1} shared variable pdln_desc as char format "x(18)" label "生产线状态".
define {1} shared variable p_qty as decimal format ">,>>>,>>9.9" label "投入数量" no-undo .
define {1} shared variable f_qty as decimal format ">,>>>,>>9.9" label "完成数量" no-undo.
define {1} shared variable c_qty as decimal format ">>>,>>9.9" label "差异数量" no-undo.
define {1} shared variable tot_qty as decimal format ">>>,>>9.9" label "不良品数量" no-undo.
define {1} shared variable tot_stop as decimal format ">>>,>>9.9" label "汇总停工时间" no-undo.
define {1} shared variable tot_non_prod as decimal format ">>>,>>9.9" label "汇总非生产时间" no-undo.
define {1} shared variable b_time as decimal format "zz9.9" extent 4 no-undo.
define {1} shared variable b_time_lbl as char format "x(6)" extent 4 no-undo.
define {1} shared variable d_qty as integer label "差异数量" .
define {1} shared variable compkb_qty as integer label "完成看板数量" .
define {1} shared variable qc_qty as integer label "品质异常数量" .
/***** end tx01****/


{&RETRFORM-I-TAG1}

define {1} shared frame a.
define variable valmsg as character.

form
	v_part			colon 13 label "零件号" v_loc           colon 50   
	desc1			colon 13 label "品名"   loc_Desc		colon 50  label "库位名"  
	desc2			colon 13 label "规格" 	pdln			colon 50 
	v_qty_a			colon 13				ln_desc 		colon 50  label "产线名"
	v_qty_s			colon 13				eff_date        colon 50  label "生效日期"   
	v_qty_g		    colon 13 				v_hrs           colon 50
	   




/*

   pdln            colon 13   ln_desc no-label 
   p_bc            colon 13   xlnc_desc    no-label
   xkb_kb_raim     colon 13 label "看板下达数量" format ">>>,>>9"
   xkb_status      colon 50 label "看板状态"
   compkb_qty      colon 13 label "完成看板数量" format ">>>,>>9"
   qc_qty          colon 50 label "品质异常数量"  
   skip(1)
   xlns_part       colon 13 label "零件号"
   desc1           at 20  no-label  
   xlns_start_date                         at 13
   xlns_start_time   no-label 
   xlns_rel_qty    at 13   
   xlns_comp_qty   at 50
   xlns_tot_Prod   at 13
   d_qty           at 50  label "差异数量"
   xlns_tot_sp     at 13  label "汇总准备时间"
   xlns_chr[1]     at 42  no-label 
   xlns_dec[1]     at 60  no-label 
   xlns_chr[2]     at 13  no-label 
   xlns_dec[2]     at 20  no-label 
   xlns_chr[3]     at 42  no-label 
   xlns_dec[3]     at 60  no-label 
   xlns_tot_dn     at 13
   xlns_tot_dt     at 50
   xlns_tot_qc     at 13  label "品质不良量"
   xlns_status     at 50  label "生产线状态"
   skip(1)
*/   
   
with frame a side-labels attr-space width 80.

/********************tx01***********************
{pxmsg.i &MSGNUM=4291 &ERRORLEVEL=3 &MSGBUFFER=valmsg}

/* Replaced all occurrences of {reval.i} with validate message */

{&RETRFORM-I-TAG2}
form
   emp          colon 13
   ad_name               no-label no-attr-space
   eff_date     colon 13 validate(eff_date <> ?,valmsg)
   shift                 validate(shift <> ?,valmsg)
   site
   part         colon 13
   pt_desc1     at 36    no-label no-attr-space
   op           colon 13
   wr_desc      at 36    no-label no-attr-space
   line         colon 13
   ln_desc      at 36    no-label no-attr-space
   routing      colon 13
   bom_code     colon 43
   wo_lot
with frame a side-labels width 80 attr-space.
{&RETRFORM-I-TAG3}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   space(1)
   site
   part
   op                    label {&retrform_i_1}
   line
with frame b side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

form
   wkctr              colon 18
   mch                colon 43
   wc_desc                     no-label no-attr-space
   dept               colon 18
   dpt_desc           at 36    no-label no-attr-space
   qty_proc           colon 18 validate(qty_proc <> ?,valmsg)
   um                 colon 45 validate(um <> ?,valmsg)
   conv               colon 61 validate(conv <> ?,valmsg)
   qty_scrap          colon 18 validate(qty_scrap <> ?,valmsg)
   scrap_rsn_code     colon 45 label {&retrform_i_20}
   validate(scrap_rsn_code <> ?,valmsg)
   outque_multi_entry          validate(outque_multi_entry <> ?,valmsg)
   qty_rjct           colon 18 validate(qty_rjct <> ?,valmsg)
   rjct_rsn_code      colon 45 label {&retrform_i_20}
   validate(rjct_rsn_code <> ?,valmsg)
   rejque_multi_entry          validate(rejque_multi_entry <> ?,valmsg)
   to_op              colon 18 label {&retrform_i_18}
   mod_issrc          colon 45 validate(mod_issrc <> ?,valmsg)
   move_next_op       colon 68 validate(move_next_op <> ?,valmsg)
   act_run_hrs        colon 18 validate(act_run_hrs <> ?,valmsg)
   start_run          colon 68 validate(start_run <> ?,valmsg)
   earn_code          colon 18
   ea_desc                     no-label no-attr-space format "x(22)"
   stop_run           colon 68 validate(stop_run <> ?,valmsg)
with frame bkfl1 side-labels width 80 attr-space.

if {gpiswrap.i} then
   assign
   start_run:format = "9XXXXX"
   stop_run:format  = "9XXXXX".

/* SET EXTERNAL LABELS */
setFrameLabels(frame bkfl1:handle).

form
   wkctr              colon 18
   mch                colon 43
   wc_desc                     no-label no-attr-space
   dept               colon 18
   dpt_desc           at 36    no-label no-attr-space
   um                 colon 18 validate(um <> ?,valmsg)
   conv               colon 45 validate(conv <> ?,valmsg)
   from_que           colon 18 validate(from_que <> ?,valmsg)
   qty_rjct           colon 18 validate(qty_rjct <> ?,valmsg)
   rjct_rsn_code      colon 45 label {&retrform_i_20}
   validate(rjct_rsn_code <> ?,valmsg)
   rejque_multi_entry          validate(rejque_multi_entry <> ?,valmsg)
   to_op              colon 18
   wr_desc                     no-label
with frame reject1 side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame reject1:handle).

to_op:label in frame reject1 = getTermLabel("TO_OPERATION",16).

form
   wkctr              colon 18
   mch                colon 43
   wc_desc                     no-label no-attr-space
   dept               colon 18
   dpt_desc           at 36    no-label no-attr-space
   um                 colon 18 validate(um <> ?,valmsg)
   conv               colon 45 validate(conv <> ?,valmsg)
   qty_inque          colon 18 validate(qty_inque <> ?,valmsg)
   inque_rsn_code     colon 45 validate(inque_rsn_code <> ?,valmsg)
   inque_multi_entry           validate(inque_multi_entry <> ?,valmsg)
   qty_outque         colon 18 validate(qty_outque <> ?,valmsg)
   outque_rsn_code    colon 45 validate(outque_rsn_code <> ?,valmsg)
   outque_multi_entry          validate(outque_multi_entry <> ?,valmsg)
   qty_rejque         colon 18 validate(qty_rejque <> ?,valmsg)
   rejque_rsn_code    colon 45 validate(rejque_rsn_code <> ?,valmsg)
   rejque_multi_entry          validate( rejque_multi_entry <> ?,valmsg)
with frame scrap1 side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame scrap1:handle).

form
   wkctr        colon 16
   mch          colon 43
   wc_desc               no-label no-attr-space
   dept         colon 16
   dpt_desc     at 36    no-label no-attr-space
   skip(1)
   act_run_hrs  colon 16 validate(act_run_hrs <> ?,valmsg)
   start_run    colon 68 validate(start_run <> ?,valmsg)
   earn_code    colon 16
   ea_desc      no-label no-attr-space format "x(22)"
   stop_run     colon 68 validate(stop_run <> ?,valmsg)
with frame lbr1 side-labels width 80 attr-space.
if {gpiswrap.i} then
   assign
   start_run:format = "9XXXXX"
   stop_run:format  = "9XXXXX".

/* SET EXTERNAL LABELS */
setFrameLabels(frame lbr1:handle).

form
   wkctr         colon 16
   mch           colon 43
   wc_desc                no-label no-attr-space
   dept          colon 16
   dpt_desc      at 36    no-label no-attr-space
   skip(1)
   act_setup_hrs colon 16 validate(act_setup_hrs <> ?,valmsg)
   start_run     colon 68 validate(start_run <> ?,valmsg)
   earn_code     colon 16
   ea_desc                no-label no-attr-space format "x(22)"
   stop_run      colon 68 validate(stop_run <> ?,valmsg)
with frame set1 side-labels width 80 attr-space.
if {gpiswrap.i} then
   assign
   start_run:format = "9XXXXX"
   stop_run:format  = "9XXXXX".

/* SET EXTERNAL LABELS */
setFrameLabels(frame set1:handle).

form
   wkctr          colon 18
   mch            colon 43
   wc_desc                 no-label no-attr-space
   dept           colon 18
   dpt_desc       at 36    no-label no-attr-space
   start_run      colon 68 validate(start_run <> ?,valmsg)
   act_run_hrs    colon 18 validate(act_run_hrs <> ?,valmsg)
   stop_run       colon 68 validate(stop_run <> ?,valmsg)
   down_rsn_code  colon 18 validate(down_rsn_code <> ?,valmsg)
   earn_code      colon 18
   ea_desc        no-label no-attr-space format "x(22)"
with frame dt1 side-labels width 80 attr-space.
if {gpiswrap.i} then
   assign
   start_run:format = "9XXXXX"
   stop_run:format  = "9XXXXX".

/* SET EXTERNAL LABELS */
setFrameLabels(frame dt1:handle).

form
   wkctr            colon 18
   mch              colon 43
   wc_desc                   no-label no-attr-space
   dept             colon 18
   dpt_desc         at 36    no-label no-attr-space
   um               colon 18 validate(um <> ?,valmsg)
   conv             colon 45 validate(conv <> ?,valmsg)
   qty_rwrk         colon 18 validate(qty_rwrk <> ?,valmsg)
   rwrk_rsn_code    colon 45 label {&retrform_i_20}
   validate(rwrk_rsn_code <> ?,valmsg)
   rwrk_multi_entry          validate(rwrk_multi_entry <> ?,valmsg)
   mod_issrc        colon 18 validate(mod_issrc <> ?,valmsg)
   act_run_hrs      colon 18 validate(act_run_hrs <> ?,valmsg)
   start_run        colon 68 validate(start_run <> ?,valmsg)
   earn_code        colon 18
   ea_desc                   no-label no-attr-space format "x(22)"
   stop_run         colon 68 validate(stop_run <> ?,valmsg)
   to_op            colon 18
   wr_desc                   no-label
   to_que           colon 68
with frame rework1 side-labels width 80 attr-space.
if {gpiswrap.i} then
   assign
   start_run:format = "9XXXXX"
   stop_run:format  = "9XXXXX".

/* SET EXTERNAL LABELS */
setFrameLabels(frame rework1:handle).

to_op:label in frame rework1 = getTermLabel("TO_OPERATION",16).

form
   wkctr        colon 18
   mch          colon 43
   wc_desc               no-label no-attr-space
   dept         colon 18
   dpt_desc     at 36    no-label no-attr-space
   um           colon 18 validate(um <> ?,valmsg)
   conv         colon 45 validate(conv <> ?,valmsg)
   qty_move     colon 18 validate(qty_move <> ?,valmsg)
   mod_issrc    colon 18 label {&retrform_i_13}
   validate(mod_issrc <> ?,valmsg)
with frame move1 side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame move1:handle).

mod_issrc:label in frame move1 = getTermLabel("MODIFY_RECEIPT",16).

form
   wkctr            colon 18
   mch              colon 43
   wc_desc                   no-label no-attr-space
   dept             colon 18
   dpt_desc         at 36    no-label no-attr-space
   um               colon 18 validate(um <> ?,valmsg)
   qty_inque        colon 18 validate(qty_inque <> ?,valmsg)
   inque_rsn_code   colon 45 validate(inque_rsn_code <> ?,valmsg)
   qty_outque       colon 18 validate(qty_outque <> ?,valmsg)
   outque_rsn_code  colon 45 validate(outque_rsn_code <> ?,valmsg)
   qty_rejque       colon 18 validate(qty_rejque <> ?,valmsg)
   rejque_rsn_code  colon 45 validate(rejque_rsn_code <> ?,valmsg)
   skip(1)
   discr_acct       colon 18
   discr_sub                 no-label
   discr_cc                  no-label
with frame adjust1 side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame adjust1:handle).

form
   cum_comp_qty     colon 20 validate(cum_comp_qty <> ?,valmsg)
with frame cumadj1 side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame cumadj1:handle).


form
   qty_proc           colon 13 label "已处理数量"      /* 18.22.13 */
   act_run_hrs        colon 40 label "实际运行时间"    
   earn_code          colon 60 label "收益代码" space(0) "(18.22.13)" at 70
   qty_scrap          colon 13 label "废品数量"        /* 18.22.13 */
   scrap_rsn_code     colon 40 label "原因代码"        
   outque_multi_entry colon 60 label "多记录"  "(18.22.13)" at 70
   qty_rjct           colon 13 label "次品数量"        /* 18.22.13 */
   rjct_rsn_code      colon 40 label "原因代码"        
   rejque_multi_entry colon 60 label "多记录"  "(18.22.13)" at 70
   to_op              colon 13 label "次品转移至工序"
   mod_issrc          colon 40 label "修改回冲"        /* 18.22.13 */
   move_next_op       colon 60 label "转入下道工序" "(18.22.13)" at 70
   act_setup_hrs      colon 13 label "准备时间"      /* 18.22.15 */
   setup_rsn          colon 40 label "原因代码"   
   act_multi_entry    colon 60 label "多记录"   "(18.22.15)" at 70  
   act_setup_hrs20    colon 13 label "停工时间"        /* 18.22.20 */
   down_rsn_code      colon 40 label "原因代码"        
   stop_multi_entry   colon 60 label "多记录"  "(18.22.20)" at 70
   non_prod_hrs       colon 13 label "非生产时间"    /* 18.22.22 */
   rsn                colon 40 label "原因代码"  
   prod_multi_entry   colon 60 label "多记录" "(18.22.22)" at 70
with frame d side-labels width 80 attr-space.
********************tx01***********************/