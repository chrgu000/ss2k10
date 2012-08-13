/* GUI CONVERTED from mfworc.i (converter v1.71) Tue Oct  6 14:33:30 1998 */
/* mfworc.i - WORK ORDER RECEIPT FRAME DEFINITION                       */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* REVISION: 7.5     LAST MODIFIED: 10/05/94    BY: taf *J035*          */
/* REVISION: 7.5     LAST MODIFIED: 10/05/94    BY: pma *J040*          */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mfworc_i_1 "L/S"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworc_i_2 "参考"
&SCOPED-DEFINE mfworc_i_3 "加工单"
&SCOPED-DEFINE mfworc_i_4 "批处理"
&SCOPED-DEFINE mfworc_i_5 "备注"
&SCOPED-DEFINE mfworc_i_6 "零件号"
&SCOPED-DEFINE mfworc_i_7 "单位"
&SCOPED-DEFINE mfworc_i_8 "摘要"
&SCOPED-DEFINE mfworc_i_9 "状态"
&SCOPED-DEFINE mfworc_i_10 "自动生成批号"
&SCOPED-DEFINE mfworc_i_11 "数量"
&SCOPED-DEFINE mfworc_i_12 "地点"
&SCOPED-DEFINE mfworc_i_13 "单位"
&SCOPED-DEFINE mfworc_i_14 "库位"
&SCOPED-DEFINE mfworc_i_15 "批/序号"
&SCOPED-DEFINE mfworc_i_16 "单位"
&SCOPED-DEFINE mfworc_i_17 "备注"
&SCOPED-DEFINE mfworc_i_18 "生效日期"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wo_nbr         colon 15 label {&mfworc_i_3}
            wo_lot         colon 40
            wo_batch       colon 56 label {&mfworc_i_4}
            wo_rmks        colon 15 label {&mfworc_i_5}
            wo_part        colon 15 label {&mfworc_i_6}
            pt_lot_ser     label {&mfworc_i_1} colon 56
            pt_um          colon 63 label {&mfworc_i_7}
            pt_desc1       colon 15 label {&mfworc_i_8}
            wo_status      colon 56 label {&mfworc_i_9}
            open_ref       colon 15 
            pt_auto_lot    colon 56 label {&mfworc_i_10}
            skip(1)
            lotserial_qty  colon 15 label {&mfworc_i_11}
            site           colon 54 label {&mfworc_i_12}
            um             colon 15 label {&mfworc_i_13}
            location       colon 54 label {&mfworc_i_14}
            conv           colon 15 
            lotserial      colon 54 label {&mfworc_i_15}
            reject_qty     colon 15
            lotref         colon 54 label {&mfworc_i_2}
            reject_um      colon 15 label {&mfworc_i_16}
            multi_entry    colon 54
            reject_conv    colon 15
            chg_attr       colon 54
            tot_units      colon 54
            skip(1)
            rmks           colon 15 label {&mfworc_i_17}
            eff_date       colon 15 label {&mfworc_i_18}
            close_wo       colon 15
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


