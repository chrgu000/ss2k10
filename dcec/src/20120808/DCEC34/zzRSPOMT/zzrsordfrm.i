/* GUI CONVERTED from rsordfrm.i (converter v1.69) Fri Mar 21 08:49:07 1997 */
/* rsordfrm.i - Release Management Supplier Schedules                   */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*G0YF* /*F0PN*/ /*V8:ConvertMode=Maintenance                        */ */
/*G0YF*/ /*V8:ConvertMode=ReportAndMaintenance                          */
/* REVISION: 7.3    LAST MODIFIED: 09/30/92           BY: WUG *G462*    */
/* REVISION: 7.3    LAST MODIFIED: 05/24/93           BY: WUG *GB29*    */
/* REVISION: 7.3    LAST MODIFIED: 06/16/93           BY: WUG *GB74*    */
/* REVISION: 7.3    LAST MODIFIED: 06/24/93           BY: WUG *GC68*    */
/* REVISION: 7.3    LAST MODIFIED: 07/13/93           BY: WUG *GD42*    */
/* REVISION: 7.3    LAST MODIFIED: 07/13/93           BY: WUG *GD43*    */
/* REVISION: 7.3    LAST MODIFIED: 07/26/93           BY: WUG *GA72*    */
/* REVISION: 7.3    LAST MODIFIED: 07/28/93           BY: WUG *GD81*    */
/* REVISION: 7.4    LAST MODIFIED: 00/06/93           BY: bcm *H057*    */
/* REVISION: 7.4    LAST MODIFIED: 11/01/93           BY: WUG *H204*    */
/* REVISION: 7.4    LAST MODIFIED: 10/19/94           BY: ljm *GN40*    */
/* REVISION: 7.3    LAST MODIFIED: 10/31/94           BY: WUG *GN76*    */
/* REVISION: 7.4    LAST MODIFIED: 03/16/95           BY: dpm *J044*    */
/* REVISION: 7.4    LAST MODIFIED: 03/23/95           BY: bcm *G0J1*    */
/* REVISION: 7.4    LAST MODIFIED: 10/06/95           BY: dxk *G0YH*    */
/* REVISION: 7.4    LAST MODIFIED: 10/18/95           BY: vrn *G0ZX*    */
/* REVISION: 7.4    LAST MODIFIED: 10/22/95           BY: vrn *G0YF*    */
/* REVISION: 8.5    LAST MODIFIED: 06/06/96           BY: rxm *G1XN*    */
/* REVISION: 8.5    LAST MODIFIED: 03/20/97           BY: vrn *J1LT*    */

/* SCHEDULED ORDER MAINT INCLUDE */

	 define variable pocmmts like poc_hcmmts label "说明".
	 define variable podcmmts like poc_lcmmts label "说明".
/*GB74*/ define variable print_sch like mfc_logical label "打印日程".
/*GB74*/ define variable edi_sch like mfc_logical label "EDI 日程".
/*H204*/ define variable fax_sch like mfc_logical label "固定日程".

/*GA72*/ if no then find first scx_ref.

	 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/*G0YF*/    

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
{rsprmfrm.i}
/*G0YF*
.	    scx_po               colon 16 format "x(08)"
.	    scx_line             colon 68
.	    scx_part             colon 16 label "Item"
.	    pod_vpart            no-label format "x(26)"
./*GD42*/   pod_um               colon 68
.	    scx_shipfrom         colon 16 label "Supplier"
.	    ad_name              no-label
.	    scx_shipto           colon 16 label "Ship-To"
.*G0YF*/
	 

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame a width 80 attr-space side-labels
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
&ENDIF /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*G0YF*/ FORM /*GUI*/ 
/*G0YF*/  

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
{rsprmfrm.i}
/*G0YF*/       skip(.4)   
/*G0YF*/ 

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame prm width 80 attr-space side-labels
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-prm-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame prm = F-prm-title.
 RECT-FRAME-LABEL:HIDDEN in frame prm = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame prm =
  FRAME prm:HEIGHT-PIXELS - RECT-FRAME:Y in frame prm - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME prm = FRAME prm:WIDTH-CHARS - .5.  /*GUI*/
&ENDIF /*GUI*/


	 FORM /*GUI*/ 
	    

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
space(1)
	    po_nbr
            po_vend
            ad_name              no-label
	 

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame po width 80 attr-space side-labels
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-po-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame po = F-po-title.
 RECT-FRAME-LABEL:HIDDEN in frame po = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame po =
  FRAME po:HEIGHT-PIXELS - RECT-FRAME:Y in frame po - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME po = FRAME po:WIDTH-CHARS - .5.  /*GUI*/
&ENDIF /*GUI*/


/*GN40*  CHANGED COLON 16 TO COLON 17 */
	 FORM /*GUI*/ 
/*GN40*/    

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
po_ap_acct           colon 17
	    po_ap_cc             no-label
	    po_shipvia           colon 50
/*GN40*/    po_taxable           colon 17 po_taxc no-label
	    po_fob               colon 50
/*GN40*/    po_cr_terms          colon 17
            po_buyer             colon 50
/*GN40*/    po_bill              colon 17 label "票据开往地址"  /*GD81*/
	    po_contact           colon 50
/*GN40*/    po_ship          colon 17 label "货物发往地址" /*GD43*//*GD81*/
	    po_contract          colon 50
/*GN40*/    print_sch            colon 17              /*GB74*/
/*G0J1*/    po_curr              colon 50
/*G0J1**    pocmmts              colon 50 **/
/*GN40*/    edi_sch              colon 17               /*GB74*/
/*G0J1*/    pocmmts              colon 50
/*GN40*/    fax_sch              colon 17                          /*H204*/
/*J1LT* /*J044*/ impexp               to 50 label  "Imp/Exp" */
/*J1LT*/    impexp               colon 50 label  "输入/输出"
/*GN40*/    po_site              colon 17 label "应收款地点"    /*GC68*//*GD81*/
/*G0YH*/       skip(.4)   
	 

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame po1 width 80 attr-space side-labels
/*H057*/ 
&IF (("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" <> "A")) &THEN
title color normal " 订单数据 "
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-po1-title AS CHARACTER.
 F-po1-title = " 订单数据 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame po1 = F-po1-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame po1 =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame po1 + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame po1 =
  FRAME po1:HEIGHT-PIXELS - RECT-FRAME:Y in frame po1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME po1 = FRAME po1:WIDTH-CHARS - .5. /*GUI*/
&ENDIF /*GUI*/

/*H057** title "Order Data". **/

/*GD42 REMOVE PT_UM FROM FOLLOWING FRAME*/
	 FORM /*GUI*/ 
/*G0ZX*     scx_part             colon 11 label "Item"
.	    pod_vpart            at 37 no-label format "x(28)"
.     	    scx_shipto           colon 11 label "Ship-To"
.*G0ZX*/

/*G0ZX*/    

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
scx_part             colon 16 label "零件"
/*G0ZX*/    pod_vpart            at 42 no-label format "x(28)"
/*G0ZX*/    scx_shipto           colon 16 label "货物发往地点"

	    si_desc              no-label
	    scx_line             colon 68
	 

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame pod width 80 attr-space side-labels
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-pod-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame pod = F-pod-title.
 RECT-FRAME-LABEL:HIDDEN in frame pod = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame pod =
  FRAME pod:HEIGHT-PIXELS - RECT-FRAME:Y in frame pod - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME pod = FRAME pod:WIDTH-CHARS - .5.  /*GUI*/
&ENDIF /*GUI*/


	 FORM /*GUI*/ 
	    

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
pod_pr_list          colon 15
	    pod_cst_up           colon 55
            pod_pur_cost         colon 15
            pod_loc              colon 55
            pod_acct             colon 15
            pod_cc               no-label
            pod_um               colon 55
            pod_taxable          colon 15 pod_taxc no-label
            pod_um_conv          colon 55
/*GN76*/    pod_type             colon 15
/*GN76*/    pod_wo_lot           colon 55
				pod__chr01				colon 15 label "中转站"
/*GN76*/    pod_op               colon 55
/*G0YH*/       skip(.4)   
	 

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame pod1 width 80 attr-space side-labels
/*H057*/ 
&IF (("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" <> "A")) &THEN
title color normal " 订单项数据 "
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-pod1-title AS CHARACTER.
 F-pod1-title = " 订单项数据 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame pod1 = F-pod1-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame pod1 =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame pod1 + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame pod1 =
  FRAME pod1:HEIGHT-PIXELS - RECT-FRAME:Y in frame pod1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME pod1 = FRAME pod1:WIDTH-CHARS - .5. /*GUI*/
&ENDIF /*GUI*/

/*H057** title "Order Line Item Data". **/

	 FORM /*GUI*/ 
	    

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
pod_firm_days        colon 20
	    pod_sd_pat           colon 60
            pod_plan_days        colon 20 label "日程天数"
            pod_cum_qty[3]       colon 60 label "最大订货量"
	    pod_plan_weeks       colon 20 label "日程周数"
	    pod_ord_mult         colon 60
	    pod_plan_mths        colon 20 label "日程月份数"
            pod_cum_date[1]      colon 60 label "累计起始日" no-attr-space
	    pod_fab_days         colon 20
	    pod_raw_days         colon 20
	    podcmmts             colon 60
            pod_translt_days     colon 20
/*G1XN*/    pod_start_eff[1]     colon 60 label "生效日期"
	    pod_sftylt_days      colon 20
/*G1XN*/    pod_end_eff[1]       colon 60 label "截止日期"
            pod_vpart            colon 20
	 

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame pod2 width 80 side-labels attr-space
/*H057*/ 
&IF (("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" <> "A")) &THEN
title color normal " 订单项数据 "
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-pod2-title AS CHARACTER.
 F-pod2-title = " 订单项数据 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame pod2 = F-pod2-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame pod2 =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame pod2 + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame pod2 =
  FRAME pod2:HEIGHT-PIXELS - RECT-FRAME:Y in frame pod2 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME pod2 = FRAME pod2:WIDTH-CHARS - .5. /*GUI*/
&ENDIF /*GUI*/

/*H057** title "Order Line Item Data". **/
