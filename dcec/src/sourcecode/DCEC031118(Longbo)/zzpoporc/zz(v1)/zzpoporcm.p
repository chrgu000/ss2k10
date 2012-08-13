/* GUI CONVERTED from poporcm.p (converter v1.69) Mon Jul 22 19:55:19 1996 */
/* poporcm.p - PURCHASE ORDER RECEIPT W/ SERIAL NUMBER CONTROL          */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.0     LAST MODIFIED: 11/19/91    BY: pma *F003*          */
/* REVISION: 7.0     LAST MODIFIED: 12/09/91    BY: RAM *F033*          */
/* REVISION: 7.0     LAST MODIFIED: 12/09/91    BY: RAM *F070*          */
/* REVISION: 7.0     LAST MODIFIED: 01/31/92    BY: RAM *F126*          */
/* REVISION: 7.0     LAST MODIFIED: 02/04/92    BY: RAM *F163*          */
/* REVISION: 7.0     LAST MODIFIED: 02/06/92    BY: RAM *F177*          */
/* REVISION: 7.0     LAST MODIFIED: 02/14/92    BY: sas *F153*          */
/* REVISION: 7.0     LAST MODIFIED: 02/24/92    BY: sas *F211*          */
/* REVISION: 7.0     LAST MODIFIED: 03/09/92    BY: RAM *F269*          */
/* REVISION: 7.0     LAST MODIFIED: 03/11/92    BY: pma *F087*          */
/* REVISION: 7.0     LAST MODIFIED: 03/24/92    BY: RAM *F311*          */
/* REVISION: 7.3     LAST MODIFIED: 08/12/92    BY: tjs *G028*(rev only)*/
/* REVISION: 7.3     LAST MODIFIED: 10/22/92    BY: afs *G116*(rev only)*/
/* REVISION: 7.3     LAST MODIFIED: 09/23/92    BY: mpp *G481*          */
/* REVISION: 7.3     LAST MODIFIED: 11/03/92    BY: mpp *G263*          */
/* REVISION: 7.3     LAST MODIFIED: 11/10/92    BY: pma *G304*          */
/* REVISION: 7.3     LAST MODIFIED: 12/15/92    BY: tjs *G443*          */
/* REVISION: 7.3     LAST MODIFIED: 12/21/92    BY: tjs *G460*(rev only)*/
/* REVISION: 7.3     LAST MODIFIED: 01/11/93    BY: bcm *G425*(rev only)*/
/* REVISION: 7.3     LAST MODIFIED: 02/16/93    BY: tjs *G675*(rev only)*/
/* REVISION: 7.3     LAST MODIFIED: 02/16/93    BY: tjs *G684*          */
/* REVISION: 7.3     LAST MODIFIED: 02/19/93    BY: sas *G647*(rev only)*/
/* REVISION: 7.3     LAST MODIFIED: 02/22/93    BY: tjs *G718*          */
/* REVISION: 7.3     LAST MODIFIED: 04/19/93    BY: tjs *G964*          */
/* REVISION: 7.3     LAST MODIFIED: 04/26/93    BY: WUG *GA34*          */
/* REVISION: 7.3     LAST MODIFIED: 05/13/93    BY: kgs *GA90*(rev only)*/
/* REVISION: 7.3     LAST MODIFIED: 05/21/93    BY: kgs *GB26*(rev only)*/
/* REVISION: 7.3     LAST MODIFIED: 05/21/93    BY: kgs *GB35*          */
/* REVISION: 7.4     LAST MODIFIED: 06/18/93    BY: jjs *H010*          */
/* REVISION: 7.4     LAST MODIFIED: 07/02/93    BY: dpm *H014*          */
/* REVISION: 7.4     LAST MODIFIED: 07/02/93    BY: jjs *H020*(rev only)*/
/* REVISION: 7.4     LAST MODIFIED: 07/06/93    BY: jjs *H024*(rev only)*/
/* REVISION: 7.4     LAST MODIFIED: 07/22/93    BY: pcd *H039*          */
/* REVISION: 7.4     LAST MODIFIED: 09/10/93    BY: tjs *H093*          */
/* REVISION: 7.4     LAST MODIFIED: 10/06/93    BY: dpm *H075*(rev only)*/
/* REVISION: 7.4     LAST MODIFIED: 10/23/93    BY: cdt *H184*(rev only)*/
/* REVISION: 7.4     LAST MODIFIED: 11/05/93    BY: bcm *H210*(rev only)*/
/* REVISION: 7.4     LAST MODIFIED: 11/12/93    BY: afs *H219*(rev only)*/
/* REVISION: 7.4     LAST MODIFIED: 11/14/93    BY: afs *H220*(rev only)*/
/* REVISION: 7.4     LAST MODIFIED: 11/16/93    BY: afs *H227*(rev only)*/
/* REVISION: 7.4     LAST MODIFIED: 11/19/93    BY: afs *H236*(rev only)*/
/* REVISION: 7.4     LAST MODIFIED: 03/28/94    BY: WUG *GI86*          */
/* REVISION: 7.4     LAST MODIFIED: 03/29/94    BY: dpm *H074*          */
/* REVISION: 7.4     LAST MODIFIED: 04/20/94    BY: tjs *GI57*          */
/* REVISION: 7.3     LAST MODIFIED: 04/21/94    BY: dpm *FN24*          */
/* REVISION: 7.2     LAST MODIFIED: 08/01/94    BY: dpm *FP66*          */
/* REVISION: 7.3     LAST MODIFIED: 08/10/94    BY: ais *FQ01*          */
/* REVISION: 7.4     LAST MODIFIED: 09/11/94    BY: rmh *GM16*          */
/* REVISION: 7.4     LAST MODIFIED: 09/20/94    BY: ljm *GM74*          */
/* REVISION: 7.4     LAST MODIFIED: 10/11/94    BY: cdt *FS26*          */
/* REVISION: 7.4     LAST MODIFIED: 10/18/94    BY: cdt *FS54*          */
/* REVISION: 7.4     LAST MODIFIED: 10/27/94    BY: cdt *FS95*          */
/* REVISION: 7.4     LAST MODIFIED: 11/08/94    BY: bcm *GO37*          */
/* REVISION: 8.5     LAST MODIFIED: 11/22/94    BY: mwd *J034*          */
/* REVISION: 8.5     LAST MODIFIED: 12/09/94    BY: taf *J038*          */
/* REVISION: 8.5     LAST MODIFIED: 01/05/95    BY: pma *J040*          */
/* REVISION: 7.4     LAST MODIFIED: 01/20/95    BY: smp *F0F5*          */
/* REVISION: 8.5     LAST MODIFIED: 01/30/95    BY: ktn *J041*          */
/* REVISION: 7.4     LAST MODIFIED: 03/10/95    BY: jpm *H0BZ*          */
/* REVISION: 7.4     LAST MODIFIED: 03/29/95    BY: aed *G0JV*          */
/* REVISION: 7.4     LAST MODIFIED: 03/31/95    BY: bcm *G0JN*          */
/* REVISION: 8.5     LAST MODIFIED: 09/20/95    BY: kxn *J07M*          */
/* REVISION: 8.5     LAST MODIFIED: 06/16/95    BY: rmh *J04R*          */
/* REVISION: 7.4     LAST MODIFIED: 10/06/95    BY: vrn *G0XW*          */
/* REVISION: 8.5     LAST MODIFIED: 01/09/96    BY: tjs *J0B1*          */
/* REVISION: 8.5     LAST MODIFIED: 10/09/95    BY: taf *J053*          */
/* REVISION: 8.5     LAST MODIFIED: 02/14/96    BY: rxm *H0JJ*          */
/* REVISION: 8.5     LAST MODIFIED: 02/05/96    BY: *J0CV* Robert Wachowicz*/
/* REVISION: 8.5     LAST MODIFIED: 04/09/96    BY: rxm *H0KH*          */
/* REVISION: 8.5     LAST MODIFIED: 07/16/96    BY: rxm *G1SV*          */
/* REVISION: 8.5     LAST MODIFIED: 07/22/96    BY: rxm *H0M3*          */
/* Revision  8.5     Last Modified: 11/28/03    BY: *LB01* Long Bo      */

/*H0M3 reinstates code originally entered in this file by ECO-G1SL.  That code
  was subsequently over-written unintentionally by ECO-G1SV. */

/*!
    poporcm.p - PO Receipts
*/

/*!
ANY CHANGES MADE TO POPORCM.P SHOULD ALSO BE MADE TO PORVISM.P
*/

	 /* DISPLAY TITLE */
/*GO37*/ {mfdeclre.i}

/*GO37 - Reorganized declaration section */
	 /* COMMON VARIABLES, FRAMES & BUFFERS FOR RECEIPTS & RETURNS */
	 {porcdef.i "new"}

/*H039*/ {gpglefdf.i}

	 /* NEW SHARED VARIABLES, BUFFERS AND FRAMES */
/*H0JJ*/ define new shared variable convertmode as character no-undo.
/*J053*/ define new shared variable rndmthd like rnd_rnd_mthd.
/*GO37*/ define new shared frame b.
/*H074*/ define new shared variable fiscal_id       like prh_receiver.
/*H074*/ define new shared variable fiscal_rec like mfc_logical initial no.
	 define new shared variable qopen       like pod_qty_rcvd
						label "短缺量".
	 define new shared variable receivernbr like prh_receiver.
/*H010*/ define new shared variable maint       like mfc_logical no-undo.
/*J053* /*H010*/ define new shared variable undo_trl2   like mfc_logical no-undo.*/

/*H074*/ define new shared workfile tax_wkfl
/*H074*/            field tax_nbr                   like pod_nbr
/*H074*/            field tax_line                  like pod_line
/*H074*/            field tax_env                   like pod_tax_env
/*H074*/            field tax_usage                 like pod_tax_usage
/*H074*/            field tax_taxc                  like pod_taxc
/*H074*/            field tax_in                    like pod_tax_in
/*H074*/            field tax_taxable               like pod_taxable
/*H074*/            field tax_price                 like prh_pur_cost.

/*J040*/ /*WORKFILE FOR POD RECEIPT ATTRIBUTES*/
/*J040*/ define new shared workfile attr_wkfl no-undo
/*J040*/   field chg_line   like sr_lineid
/*J040*/   field chg_assay  like tr_assay
/*J040*/   field chg_grade  like tr_grade
/*J040*/   field chg_expire like tr_expire
/*J040*/   field chg_status like tr_status
/*J040*/   field assay_actv like mfc_logical
/*J040*/   field grade_actv like mfc_logical
/*J040*/   field expire_actv like mfc_logical
/*J040*/   field status_actv like mfc_logical.

	 /* LOCAL VARIABLES, BUFFERS AND FRAMES */
	 define            variable pook        like mfc_logical.
	 define            variable ent_exch    like exd_ent_rate.
	 define            variable cmmt_yn     like mfc_logical
						label "说明".
	 define            variable fill-all    like mfc_logical label
						"全部收货".
	 define            variable rcv_type    like poc_rcv_type.
/*H0M3	 define            variable error_flag  like mfc_logical. */
/*H0M3*/ define            variable err_flag    like mfc_logical.
	 define            variable vndname     like ad_name.
/*FS26*/ define            variable issqty      like pod_qty_ord.
/*FS26*/ define            variable fromsite    like pod_site.
/*FS26*/ define            variable fromloc     like pod_loc.
/*FS26*/ define            variable tosite      like pod_site.
/*FS26*/ define            variable toloc       like pod_loc.
/*FS26*/ define            variable reject1     like mfc_logical.
/*FS26*/ define            variable reject2     like mfc_logical.
/*J0CV*/ define            variable ship_date   like prh_ship_date no-undo.

/*F0F5*  THESE LABELS NO LONGER NEEDED
./*FS54*/ define            variable pslabel     as  character  format "x(13)".
./*FS54*/ define            variable rclabel     as  character  format "x(9)".
./*FS54*/ define            variable movelabel   as  character  format "x(23)".
./*FS54*/ define            variable filllabel   as  character  format "x(12)".
.*F0F5*/
/*F0F5*/ define            variable ordernum    like po_nbr.
/*G0JN*/ define            variable newprice    like pod_pur_cost.
/*G0XW*/ define            variable dummy_disc  like pod_disc_pct no-undo.
/*G0XW*/ define            variable pc_recno    as recid no-undo.
/*J038*/ define new shared variable vendlot like tr_vend_lot no-undo.


/*LB01*/
			define new shared work-table wosub			/* record subcontract work order data */
				field wosubline like pod_line
				field wosublot like wod_lot
				field wosubop  like wod_op
				field wosubqty like pod_qty_chg.
				
			define variable iWosubrec as integer.
/*LB01*/


/* COMMON VARIABLES MOVED TO porcdef.i
.
.         /* NEW SHARED VARIABLES, BUFFERS AND FRAMES */
./*H074*/ define new shared variable shipper_rec like mfc_logical init false.
.         define new shared variable trlot       like tr_lot.
.         define new shared variable eff_date    like glt_effdate.
.         define new shared variable ref         like glt_ref.
.         define new shared variable qopen       like pod_qty_rcvd
.                                                label "Qty Open".
.         define new shared variable             po_recno as recid.
./*G964*/ define new shared variable             pod_recno as recid.
.         define new shared variable ps_nbr      like prh_ps_nbr
.                                                label "Pack Slip".
.         define new shared variable proceed     like mfc_logical initial yes.
.         define new shared variable base_amt    like pod_pur_cost.
.         define new shared variable move        like mfc_logical initial yes
.                                                label "Move to Next Operation".
.         define new shared variable receivernbr like prh_receiver.
.         define new shared variable exch_rate   like exd_rate.
./*F003*/ define new shared variable wolot       like pod_wo_lot no-undo.
./*F003*/ define new shared variable woop        like pod_op no-undo.
./*G718*/ define new shared variable cmtindx     like cmt_indx.
./*GB35*/ define new shared variable updt_blnkt  like mfc_logical.
.
.
./*H014*/ define new shared variable site        like sr_site no-undo.
./*H014*/ define new shared variable location    like sr_loc no-undo.
./*H014*/ define new shared variable lotref      like sr_ref no-undo.
./*H014*/ define new shared variable lotserial   like sr_lotser no-undo.
./*H014*/ define new shared variable msgref      as character format "x(20)".
./*H014*/ define new shared variable stat_recno  as recid.
./*H014*/ define new shared workfile stat_wkfl   no-undo
./*H014*/                   field    podnbr      like pod_nbr
./*H014*/                   field    podline     like pod_line
./*H014*/                   field    assay       like tr_assay initial ?
./*H014*/                   field    grade       like tr_grade initial ""
./*H014*/                   field    expire      like tr_expire initial ?
./*H014*/                   field    rcpt_stat   like ld_status initial ?.
.
.         /* SHARED VARIABLES, BUFFERS AND FRAMES */
./*G263*  define     shared variable mfguser     as character.*/
./*F153*/ define     shared variable porec       like mfc_logical no-undo.
./*FS95*/ define     shared variable ports       as character no-undo.
./*GO37*/ define     shared variable is-return   like mfc_logical
.                                                no-undo.
.
.         /* LOCAL VARIABLES, BUFFERS AND FRAMES */
./*F126*/ define            variable pook        like mfc_logical.
.         define            variable ent_exch    like exd_ent_rate.
./*G718*/ define            variable cmmt_yn     like mfc_logical
.                                                label "Comments".
.         define            variable fill-all    like mfc_logical label
.                                                "Receive All".
./*FN24*/ define            variable rcv_type    like poc_rcv_type.
./*FP66*/ define            variable error_flag  like mfc_logical.
*GO37** MOVED TO porcdef.i **/

/*J053      DEFINE & INITIALIZE CURRENCY DEPENDENT ROUNDING FORMAT VARS  */
/*J053*/    {pocurvar.i "NEW"}
/*J053*/    {txcurvar.i "NEW"}
/*J053*/
/*J053*/    /* DEFINE TRAILER VARS AS NEW, SO THAT CORRECT _OLD FORMATS */
/*J053*/    /* CAN BE ASSIGNED BASED ON INITIAL DEFINE                  */
/*J053*/    {potrldef.i "NEW"}
/*J053*/    assign
/*J053*/            nontax_old         = nontaxable_amt:format
/*J053*/            taxable_old        = taxable_amt:format
/*J053*/            lines_tot_old      = lines_total:format
/*J053*/            tax_tot_old        = tax_total:format
/*J053*/            order_amt_old      = order_amt:format
/*J053*/            line_tax_old       = line_tax:format
/*J053*/            line_tot_old       = line_total:format
/*J053*/            tax_old            = tax_2:format
/*J053*/            tax_amt_old        = tax_amt:format
/*J053*/            ord_amt_old        = ord_amt:format
/*J053*/            vtord_amt_old      = vtord_amt:format
/*J053*/            line_pst_old       = line_pst:format
/*J053*/            prepaid_old        = po_prepaid:format
/*J053*/            frt_old            = po_frt:format
/*J053*/            spec_chg_old       = po_spec_chg:format
/*J053*/            serv_chg_old       = po_serv_chg:format.

/*GO37* MOVED TO TOP OF PROGRAM **
 ** /* DISPLAY TITLE */
 ** /*H236*/ {mfdtitle.i "c+ "} **/

/*G0JV** Begin section moved from zzpoporcm.i */
/**         form
	       ent_exch colon 15
	       space(2)
/*H0BZ*/    with frame seta1_sub   */
/*H0BZ*/    /* attr-space overlay side-labels
/*H0BZ*/       centered row frame-row(a) + 4  .  */
/*G0JV** End section moved from zzpoporcm.i */

/*GO37*/    FORM /*GUI*/ 
/*GO37*/       
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
po_nbr         colon 12   label "订单"
/*GO37*/       po_vend
/*GO37*/       po_stat
/*GO37*/       ps_nbr         to 78
/*GO37*/     SKIP(.4)  /*GUI*/
with frame b side-labels no-attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/


/*GO37*/ cmmt-prefix = "RCPT:".
/*GO37*/ transtype = "RCT-PO".

/*H0JJ*/ convertmode = "MAINT".

/*F0F5*   UNIQUE FRAMES CREATED FOR EACH SITUATION...
./*FS54*/ /* Make program labels universal to work with Purchase */
./*FS54*/ /* Orders, RTS Shipments, and RTS Receipts.            */
./*GO37** /*FS54*/ if porec then **/
./*GO37*/ if porec and not is-return then
./*FS54*/    assign
./*FS54*/       pslabel   = "Packing Slip:"
./*FS54*/       rclabel   = "Receiver:"
./*FS54*/       movelabel = "Move to Next Operation:"
./*FS54*/       filllabel = "Receive All:".
./*FS54*/ else
./*GO37*/ if porec and is-return then
./*GO37*/    assign
./*GO37*/       pslabel   = ""
./*GO37*/       rclabel   = " RTS Nbr:"
./*GO37*/       movelabel = "Return for Replacement:"
./*GO37*/       filllabel = " Return All:".
./*GO37*/ else
./*FS54*/    assign
./*FS54*/       pslabel   = ""
./*FS54*/       rclabel   = ""
./*FS54*/       movelabel = ""
./*FS54*/       filllabel = "   Ship All:".
.
.         form
./*FS54*/    /* po_nbr         colon 15 */
./*FS54*/    po_nbr         colon 15       label "Order"
.            po_vend
.            po_stat
.            eff_date       colon 68
./*FS54*/    /* ps_nbr      colon 15 */
./*FS54*/    pslabel        to    15       no-label
./*FS54*/    ps_nbr         at    17       no-label
./*FS54*/    /* move        colon 68 */
./*FS54*/    movelabel      to    68       no-label
./*FS54*/    move           at    70       no-label
./*FS54*/    /* receivernbr colon 15 */
./*FS54*/    rclabel        to    15       no-label
./*FS54*/    receivernbr    at    17       no-label
./*GO37*/    vndname        at 27 no-attr-space no-label
./*FS54*/    /* fill-all    colon 68 */
./*FS54*/    filllabel      to    68       no-label
./*FS54*/    fill-all       at    70       no-label
./*G718*/    cmmt_yn        colon 68
./*FS54*/ /* with frame a attr-space side-labels width 80. */
./*FS54*/ with frame a no-attr-space side-labels width 80.
.*F0F5*/
/*F0F5*  ADDED THE FOLLOWING FRAMES: a1 FOR RECEIPTS, a2 FOR SHIPMENTS */

	 FORM /*GUI*/ 
	    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
ordernum       colon 15       label "订单"
	    po_vend
	    po_stat
	    eff_date       colon 68
	    ps_nbr         colon 15       label "装箱单"
	    move           colon 68       label "转入下道工序"
	    receivernbr    colon 15       label "收货单"
	    vndname        at    27       no-attr-space no-label
	    fill-all       colon 68
	    cmmt_yn        colon 68
/*J0CV*/    ship_date      colon 68       label "发货日期"
/*H0BZ*/     SKIP(.4)  /*GUI*/
with frame a1 attr-space side-labels width 80 /*color normal*/ NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a1 = F-a1-title.
 RECT-FRAME-LABEL:HIDDEN in frame a1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a1 =
  FRAME a1:HEIGHT-PIXELS - RECT-FRAME:Y in frame a1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a1 = FRAME a1:WIDTH-CHARS - .5.  /*GUI*/


	 FORM /*GUI*/ 
	    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
ordernum       colon 15       label "订单"
	    po_vend
	    po_stat
	    eff_date       colon 68
	    ps_nbr         colon 15       no-label
	    move           colon 68       no-label
	    receivernbr    colon 15       no-label
	    vndname        at    27       no-attr-space no-label
	    fill-all       colon 68       label "全部发货"
	    cmmt_yn        colon 68
/*H0BZ*/     SKIP(.4)  /*GUI*/
with frame a2 attr-space side-labels width 80 /*color normal*/ NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a2-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a2 = F-a2-title.
 RECT-FRAME-LABEL:HIDDEN in frame a2 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a2 =
  FRAME a2:HEIGHT-PIXELS - RECT-FRAME:Y in frame a2 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a2 = FRAME a2:WIDTH-CHARS - .5.  /*GUI*/


/*F0F5*   END ADDED FRAMES */

/*H0BZ*/    FORM /*GUI*/ 
/*H0BZ*/      
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
ent_exch colon 15
/*H0BZ*/      space(2)
/*H0BZ*/     SKIP(.4)  /*GUI*/
with frame seta1_sub attr-space overlay side-labels
/*H0BZ*/             centered row frame-row(a) + 4 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-seta1_sub-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame seta1_sub = F-seta1_sub-title.
 RECT-FRAME-LABEL:HIDDEN in frame seta1_sub = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame seta1_sub =
  FRAME seta1_sub:HEIGHT-PIXELS - RECT-FRAME:Y in frame seta1_sub - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME seta1_sub = FRAME seta1_sub:WIDTH-CHARS - .5.  /*GUI*/


/*J053*/ find gl_ctrl no-lock no-error.
/*H010*/ maint = true.
/*H074*/ shipper_rec = false.
/*H074*/ fiscal_rec = false.

	 main-loop:
	 repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


/*F0F5*     ADDED THE FOLLOWING TO USE zzpoporcm.i FOR ALL HEADER FRAME */
/*F0F5*     MANIPULATION.  THE FRAME TO BE USED IS PASSED AS THE ONE  */
/*F0F5*     PARAMETER.                                                */

	    if porec then do:
		{zzpoporcm.i &frame=a1}
	    end.
	    else do:
		{zzpoporcm.i &frame=a2}
	    end.

/*F0F5*     FOLLOWING CODE HAS BEEN MOVED INTO zzpoporcm.i
.
.           do transaction:
.
./*FN24*/       do for poc_ctrl:
.                  find first poc_ctrl no-lock.
./*FN24*/          fill-all = poc_rcv_all.
./*FN24*/          rcv_type  = poc_rcv_type.
./*FN24*/       end.
.
./*GO37**       hide all no-pause.
. **            view frame dtitle. **/
./*GO37*/       view frame a.
.
.               if receivernbr = ? then receivernbr = "".
.               if eff_date = ? then eff_date = today.
.               move = yes.
./*FN24*//*     fill-all = poc_rcv_all. */
./*G718*/       cmmt_yn = no.
./*G718*        display receivernbr eff_date fill-all move with frame a. */
./*G718*/       display
.                  receivernbr
.                  eff_date
./*FS54*/          /* move */
./*FS54*/          move        when porec
.                  fill-all
.                  cmmt_yn
./*FS54*/          pslabel rclabel movelabel filllabel
./*FS54*/       with frame a.
.               receivernbr = "".
.
.               seta:
.               do on error undo, retry:
.                  prompt-for po_nbr
.                  with frame a editing:
.                     if frame-field = "po_nbr" then do:
.                        /* FIND NEXT/PREVIOUS RECORD */
./*FS95*/                /* Do not scroll thru RTS for PO or PO for RTS */
./*FS95*/                /* {mfnp06.i po_mstr po_nbr "po_type <> ""B""" */
./*FS95*/                /* po_nbr  "input po_nbr" yes yes }            */
./*FS95*/                {mfnp06.i
.                            po_mstr
.                            po_nbr
.                            "po_type <> ""B"" and po_fsm_type = ports"
.                            po_nbr
.                            "input po_nbr"
.                            yes
.                            yes }
.
.                        if recno <> ? then do:
./*GO37*/                   find ad_mstr
./*GO37*/                   where ad_addr = po_vend no-lock no-error.
./*GO37*/                   if available ad_mstr then
./*GO37*/                      vndname = ad_name.
./*GO37*/                   else
./*GO37*/                      vndname = "".
.                           display po_nbr receivernbr po_vend po_stat
.                           with frame a.
.                        end.
.                     end.
.                     else do:
.                        status input.
.                        readkey.
.                        apply lastkey.
.                     end.
.                  end.
.                  /* END EDITING PORTION OF FRAME A */
.
./*F311            find po_mstr using po_nbr. */
./*F311*/          find po_mstr using po_nbr exclusive-lock no-error.
.
./*F311*/          if not available po_mstr then do:
./*F311*/             {mfmsg.i 343 3}
./*F311*/             /* PURCHASE ORDER DOES NOT EXIST */
./*F311*/             next-prompt po_nbr with frame a.
./*F311*/             undo seta, retry.
./*F311*/          end.
.
./*GO37**          display receivernbr po_vend po_stat with frame a. **/
.
.                  if available po_mstr and po_stat = "c" then do:
.                     /* PURCHASE ORDER CLOSED */
.                     {mfmsg.i 326 3}
.                     next-prompt po_nbr with frame a.
.                     undo seta, retry.
.                  end.
./*GO37*/          if available po_mstr and po_stat = "x" then do:
./*GO37*/             /* PURCHASE ORDER CANCELLED */
./*GO37*/             {mfmsg.i 395 3}
./*GO37*/             next-prompt po_nbr with frame a.
./*GO37*/             undo seta, retry.
./*GO37*/          end.
.
.                  if available po_mstr and po_type = "B" then do:
.                     /* BLANKET ORDER NOT ALLOWED */
.                     {mfmsg.i 385 3}
.                     next-prompt po_nbr with frame a.
.                     undo seta, retry.
.                  end.
.
./*FS95*/          if available po_mstr and ports = "RTS"
./*FS95*/           and po_fsm_type <> ports then do:
./*FS95*/             /* Can not process PO's with RTS programs. */
./*FS95*/             {mfmsg.i 7363 3}
./*FS95*/             next-prompt po_nbr with frame a.
./*FS95*/             undo seta, retry.
./*FS95*/          end.
.
./*FS95*/          if available po_mstr and ports = ""
./*FS95*/           and po_fsm_type <> ports then do:
./*FS95*/             /* Can not process RTS orders with PO programs. */
./*FS95*/             {mfmsg.i 7364 3}
./*FS95*/             next-prompt po_nbr with frame a.
./*FS95*/             undo seta, retry.
./*FS95*/          end.
.
./*GO37*/          find ad_mstr where ad_addr = po_vend no-lock no-error.
./*GO37*/          if available ad_mstr then
./*GO37*/             vndname = ad_name.
./*GO37*/          else
./*GO37*/             vndname = "".
.
./*GO37*/          display
./*GO37*/             receivernbr
./*GO37*/             po_vend
./*GO37*/             po_stat
./*GO37*/             vndname
./*GO37*/          with frame a.
.
.                  if available po_mstr then do:
./*F126               find first pod_det where pod_nbr = po_nbr */
./*F126               no-lock no-error.                         */
./*F126               if not available pod_det then do:         */
./*F126*/             pook = no.
./*F126*/             chkpodsite:
./*F126*/             for each pod_det where pod_nbr = po_nbr no-lock:
./*F126*/                find si_mstr where si_site = pod_site no-lock no-error.
./*F163*/                if available si_mstr and si_db = global_db then do:
./*F126*/                   pook = yes.
./*F126*/                   leave chkpodsite.
./*F163*/                end.
./*F126*/             end.
./*F126*/             if not pook then do:
.                        {mfmsg.i 352 3}
.                        next-prompt po_nbr with frame a.
.                        undo seta, retry.
.                     end.
./*FQ01*/             /* MAKE SURE THAT CENTRAL DATABASE IS CONNECTED */
.
.                    if available po_mstr then do:
.                       find first pod_det
.                        where pod_nbr = po_nbr no-lock no-error.
.                       if global_db <> "" and not connected(pod_po_db) then do:
.                           /* Database not available */
.                           {mfmsg03.i 2510 3 pod_po_db """" """"}
.                           undo seta, retry.
.                        end.
.                     end.
./*FQ01*/             /* END OF PATCH */
.                  end.
.               end.
.
.               /* seta */
.
.               seta1:
.               do on error undo, retry:
./*GI86*/          global_addr = po_vend.
.
/*G718*           set ps_nbr receivernbr eff_date move fill-all with frame a. */
.
./*G718*/          set
./*FS54*/             /* ps_nbr */
./*FS54*/             ps_nbr   when porec
./*FS54*/             /* receivernbr */
./*FS54*/             receivernbr  when porec
.                     eff_date
./*FS54*/             /* move */
./*FS54*/             move     when porec
.                     fill-all
.                     cmmt_yn
./*G718*/          with frame a.
.
.                  if eff_date = ? then eff_date = today.
.
.                  /* CHECK GL EFFECTIVE DATE */
./*H039*/          {mfglef.i eff_date}
.
.                  /* FIND EXCH RATE IF CURRENCY NOT BASE */
.                  if base_curr <> po_curr then do:
.                     if po_fix_rate then do:
.                        exch_rate = po_ex_rate.
.                        ent_exch  = po_ent_ex.
.                     end.
.                     else do:  /*IF NOT FIXED RATE ALLOW FOR SPOT RATE*/
./*G481*/                {gpgtex5.i &ent_curr = base_curr
.                                   &curr = po_curr
.                                   &date = eff_date
.                                   &exch_from = exd_rate
.                                   &exch_to = exch_rate}
./*G481*/                if exd_rate = exch_rate then
./*G481*/                   ent_exch = exd_ent_rate.
./*G481*/                else
./*G481*/                   ent_exch = 1 / exd_ent_rate.
.
.                        seta1_sub:
.                        do on error undo, retry:
.                           form
.                              ent_exch colon 15
./*GM74*/ space(2)
.                           with frame seta1_sub attr-space overlay side-labels
.                           centered row frame-row(a) + 4.
.
.                           update ent_exch with frame seta1_sub.
.                           if ent_exch = 0  then do:
.                              {mfmsg.i 317 3}
.                              /*ZERO NOT ALLOWED*/
.                              undo seta1_sub, retry.
.                           end.
.                           hide frame seta1_sub.
.                           /* SET THE EX_RATE FROM THE ENTERED EXCHANGE RATE */
.                           if ent_exch entered then do:
./*G481*/                      {gpgtex7.i  &ent_curr=base_curr
.                                          &curr = po_curr
.                                          &exch_from=ent_exch
.                                          &exch_to=exch_rate}
.
./*G481*                       find ex_mstr where ex_curr = po_curr no-lock.
. *G481*                       ex_conv then exch_rate = ent_exch.
. *G481*                       else exch_rate = 1 / ent_exch.
. *G481*/
.                           end.
.                        end. /*seta1_sub*/
.
./*GI57*/               /* TRANSACT'N TO BASE, MAKE (INTERNALLY) BASE TO TRANS*/
./*GI57*/                if ent_exch entered and exd_rate <> exd_ent_rate then
./*GI57*/                exch_rate = 1 / ent_exch.
.
.                     end. /*not fixed rate*/
.                  end.
.                  else exch_rate = 1.0.
.
./*G684*           if receivernbr <> "" and poc_rcv_type <> 1 then do: */
./*FN24*//*        if receivernbr <> "" and poc_rcv_type = 2 then do: */
./*FN24*/          if receivernbr <> "" and rcv_type = 2 then do:
./*G684*              {mfmsg.i 354 3} */
/*G684*/             {mfmsg.i 354 4} /*Rcvr # is system assgnd for rcvr type 2*/
.                     next-prompt receivernbr with frame a.
.                     undo seta1, retry.
.                  end.
.
.                  if can-find(first prh_hist where prh_receiver = receivernbr)
.                  then do:
.                     {mfmsg.i 355 3}
.                     next-prompt receivernbr with frame a.
.                     undo seta1, retry.
.                  end.
.
./*G718*/          if cmmt_yn then do: /* ADD COMMENTS, IF DESIRED */
./*G718*/             hide frame a no-pause.
./*G718*/             cmtindx = po_cmtindx.
./*GO37** /*G718*/             global_ref = "RCPT: " + po_nbr. **/
./*GO37*/             global_ref = cmmt-prefix + " " + po_nbr.
./*G718*/             {gprun.i ""gpcmmt01.p"" "(input ""po_mstr"")"}
./*G718*/             po_cmtindx = cmtindx.
./*G718*/          end.
.
.               end.
.               /* seta1 */
.            end.
.            /* transaction */
.*F0F5*     END OF CODE MOVED TO zzpoporcm.i   */


	    do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

/*J04R*        {mfnctrl.i woc_ctrl woc_lot wo_mstr wo_lot trlot} */
/*J04R*/       {mfnxtsq.i wo_mstr wo_lot woc_sq01 trlot}
	    end.
/*GUI*/ if global-beam-me-up then undo, leave.

	    /* transaction */

/*GM16*     for each sr_wkfl where sr_userid = mfguser: */
/*GM16*/    for each sr_wkfl where sr_userid = mfguser exclusive-lock:
	       delete sr_wkfl.
	    end.

	    /* FRAME B FOR ABBREVIATED HEADER */
/*FS54*/    /* Frame b belongs in poporca.p so framing works properly for */
/*FS54*/    /* line item prompting. Also do not hide frame a until we're  */
/*FS54*/    /* calling poporca.p.                                         */
/*FS54*/    /* form                                                       */
/*FS54*/    /*    po_nbr         colon 15                                 */
/*FS54*/    /*    po_vend                                                 */
/*FS54*/    /*    po_stat                                                 */
/*FS54*/    /*    ps_nbr         to 78                                    */
/*FS54*/    /* with frame b side-labels width 80.                         */
/*FS54*/    /* hide frame a no-pause.                                     */
/*FS54*/    /* display po_nbr po_vend po_stat ps_nbr with frame b.        */

	    /* DETAIL FRAME C AND SINGLE LINE PROCESSING FRAME D */
/*F126*/    preppoddet:
	    for each pod_det where pod_nbr = po_nbr
	    and pod_status <> "c" and pod_status <> "x":
/*GUI*/ if global-beam-me-up then undo, leave.


/*F153*/       /********************************************************/
/*F153*/       /*  if this is an rtv po then we need to check the type */
/*F153*/       /*  for normal receipts, the field will be blank. for an*/
/*F153*/       /*  rtv type it will be I. for an rtv return it will be */
/*F153*/       /*  O. For Return to Supplier transactions, the sign of */
/*F153*/       /*  pod_qty_chg is reversed for display purposes,       */
/*F153*/       /*  because we are on a return screen. Before the       */
/*F153*/       /*  transaction is complete we reverse the signs to     */
/*F153*/       /*  to negative again.                                  */
/*F153*/       /********************************************************/
/*F153*/       if  porec then do:
/*F153*/           if  pod_rma_type <> "I"  and
/*F153*/               pod_rma_type <> ""   then
/*F153*/               next preppoddet.
/*F153*/       end.
/*F153*/       else do:
/*F153*/           if  pod_rma_type <> "O" then
/*F153*/               next preppoddet.
/*F153*/       end.

/*F126*/       find si_mstr where si_site = pod_site no-lock no-error.
/*F126*/       if not available si_mstr
/*F126*/       or (available si_mstr and si_db <> global_db) then
/*F126*/          next preppoddet.

/*J07M*/       find pt_mstr where pt_part = pod_part no-lock no-error.

/*J07M*/       /*INITIALIZE ATTRIBUTE VARIABLES WITH CURRENT SETTINGS*/
/*J07M*/       find first attr_wkfl where chg_line = string(pod_line) no-error.
/*J07M*/       if not available attr_wkfl then do:
/*J07M*/          create attr_wkfl.
/*J07M*/          assign chg_line = string(pod_line).
/*J07M*/       end.
/*J07M*/       assign chg_assay = pod_assay
/*J07M*/              chg_grade = pod_grade
/*J07M*/             chg_expire = pod_expire
/*J07M*/             chg_status = pod_rctstat
/*J07M*/             assay_actv = yes
/*J07M*/             grade_actv = yes
/*J07M*/            expire_actv = yes
/*J07M*/           status_actv  = yes.

/*J07M*/       if pod_rctstat_active = no then do:
/*J07M*/         find in_mstr where in_part = pod_part
/*J07M*/         and in_site = pod_site no-lock no-error.
/*J07M*/         if available in_mstr and in_rctpo_active = yes then
/*J07M*/            chg_status = in_rctpo_status.
/*J07M*/         else if available pt_mstr and pt_rctpo_active = yes then
/*J07M*/            chg_status = pt_rctpo_status.
/*J07M*/         else do:
/*J07M*/            chg_status = "".
/*J07M*/            status_actv = no.
/*J07M*/         end.
/*J07M*/       end.

/*J040*/       /*TEST FOR ATTRIBUTE CONFLICTS*/
/*H0M3*        CHANGED error_flag TO err_flag BELOW */
/*J040*/       {gprun.i ""porcat01.p"" "(input recid(pod_det),
					 input pod_site,
					 input pod_loc,
					 input """",
					 input """",
					 input-output chg_assay,
					 input-output chg_grade,
					 input-output chg_expire,
					 input-output chg_status,
					 input-output assay_actv,
					 input-output grade_actv,
					 input-output expire_actv,
					 input-output status_actv,
					 output err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.


	       if fill-all = yes then do:
		  /* ONLY AUTO-FILL PARTS THAT ARE NOT LOT/SERIAL CONTROLLED */
/*J040*/          /* AND HAVE NO ATTRIBUTE (ERROR-FLAG = NO) CONFLICTS       */
/*J040            find pt_mstr where pt_part = pod_part no-lock no-error.    */
                  if
/*H0M3 /*J040*/   not error_flag and ( */
/*H0M3*/          not err_flag and (
		  not available pt_mstr
		  or (available pt_mstr and pt_lot_ser = ""
		  and pod_type <> "S" )
/*J040*/                               )
		  then do:
		     define variable rejected like mfc_logical.
/*FS26*  /*H093*/             if pod_type = "" then do:                    */
/*FS26*/             if pod_type = "" and pod_fsm_type = "" then do:
/*J038* ADDED INPUTS POD_NBR AND STRING(POD_LINE) TO ICEDIT2.P CALL        */
				
		      {gprun.i ""icedit2.p""
			 "(input ""RCT-PO"",
			   input pod_site,
			   input pod_loc,
			   input pod_part,
			   input """",
			   input """",
			   input (pod_qty_ord - pod_qty_rcvd) * pod_um_conv,
			   input pod_um,
			   input pod_nbr,
			   input string(pod_line),
			   output rejected)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H093*/             end.

/*FS26*/             /* RTS's generated by field service neeed sites, and */
/*FS26*/             /* locations identified. And qty properly expressed. */
/*FS26*/             else if pod_fsm_type <> "" then do:
/*FS26*/                assign
/*FS26*/                   rejected  = no
/*FS26*/                   reject1   = no
/*FS26*/                   reject2   = no
/*FS26*/                   issqty = (pod_qty_ord - pod_qty_rcvd) * pod_um_conv.
/*FS26*/
/*FS26*/                find rmd_det where rmd_nbr = pod_nbr
/*FS26*/                            and rmd_prefix = "V"
/*FS26*/                            and rmd_line   = pod_line
/*FS26*/                 no-lock no-error.
/*FS26*/
/*FS26*/                /* Set up RTS Issues */
/*FS26*/                if pod_rma_type = "O" then
/*FS26*/                   assign
/*FS26*/                      issqty    = issqty * -1
/*FS26*/                      fromsite  = pod_site
/*FS26*/                      fromloc   = pod_loc
/*FS26*/                      tosite    = rmd_site
/*FS26*/                      toloc     = rmd_loc.
/*FS26*/
/*FS26*/                /* Set up RTS Receipts */
/*FS26*/                if pod_rma_type = "I" then
/*FS26*/                    assign
/*FS26*/                       fromsite = rmd_site
/*FS26*/                       fromloc  = rmd_loc
/*FS26*/                       tosite   = pod_site
/*FS26*/                       toloc    = pod_loc.
/*FS26*/
/*FS26*/                /* RTS's receipts that have been previously  */
/*FS26*/                /* issued from inventory do not need to test */
/*FS26*/                /* the from site.                            */
/*FS26*/                if fromsite <> "" then do:
/*J0B1*/                   /* ADDED 2 input """", AFTER pod_um BELOW */

/*FS26*/                   {gprun.i ""icedit2.p""
				    "(input ""ISS-TR"",
				      input fromsite,
				      input fromloc,
				      input pod_part,
				      input """",
				      input """",
				      input issqty,
				      input pod_um,
				      input """",
				      input """",
				      output reject1)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*FS26*/                end.
/*FS26*/
/*FS26*/                /* RTS issues from inventory do not need to */
/*FS26*/                /* test the tosite.                         */
/*FS26*/                if tosite <> "" then do:
/*J0B1*/                   /* ADDED 2 input """", AFTER pod_um BELOW */

/*FS26*/                   {gprun.i ""icedit2.p""
				    "(input ""RCT-TR"",
				      input tosite,
				      input toloc,
				      input pod_part,
				      input """",
				      input """",
				      input issqty,
				      input pod_um,
				      input """",
				      input """",
				      output reject2)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*FS26*/                end.
/*FS26*/
/*FS26*/                if reject1 or reject2 then
/*FS26*/                   assign rejected = yes.
/*FS26*/             end.

		     if rejected then do on endkey undo, retry:
			{mfmsg02.i 161 2 pod_part}
			pod_qty_chg = 0.
			if not pod_sched then do:                       /*GA34*/
			   pod_bo_chg = pod_qty_ord - pod_qty_rcvd.
			end.                                            /*GA34*/
			else do:                                        /*GA34*/
			   {gprun.i ""rsoqty.p"" "(input recid(pod_det),/*GA34*/
			    input eff_date, output qopen)"}
/*GUI*/ if global-beam-me-up then undo, leave.
             /*GA34*/
			   pod_bo_chg = qopen.                          /*GA34*/
			end.                                            /*GA34*/
	     end.
	     else do:
			pod_bo_chg = 0.
			if not pod_sched then do:                       /*GA34*/
			   pod_qty_chg = pod_qty_ord - pod_qty_rcvd.
			end.                                            /*GA34*/
			else do:                                        /*GA34*/
			   {gprun.i ""rsoqty.p"" "(input recid(pod_det),/*GA34*/
			    input eff_date, output qopen)"}
/*GUI*/ if global-beam-me-up then undo, leave.
             /*GA34*/
			   pod_qty_chg = qopen.                         /*GA34*/
			end.                                            /*GA34*/
		     end.
		  end.
		  else do:
		     pod_qty_chg = 0.
		     if not pod_sched then do:                          /*GA34*/
			pod_bo_chg = pod_qty_ord - pod_qty_rcvd.
		     end.                                               /*GA34*/
		     else do:                                           /*GA34*/
			{gprun.i ""rsoqty.p"" "(input recid(pod_det),   /*GA34*/
			 input eff_date, output qopen)"}
/*GUI*/ if global-beam-me-up then undo, leave.
                /*GA34*/
			pod_bo_chg = qopen.                             /*GA34*/
		     end.                                               /*GA34*/
		  end.

/*G0JN*/          /*! CHECK PRICE LIST FOR SCHEDULED ITEMS */
/*G0JN*/          if pod_sched then do:

/*G0XW* /*G0JN*/             {gprun.i ""rspccal.p"" "(input pod_part,
./*G0JN*/                                      input pod_pr_list,
./*G0JN*/                                      input eff_date,
./*G0JN*/                                      input pod_um,
./*G0JN*/                                      input po_curr,
./*G0JN*/                                      input qopen /*price_qty*/,
./*G0JN*/                                      output newprice)"}
.*G0XW*/

/*G0XW*/             {gprun.i ""gppccal.p""
			     "(input        pod_part,
			       input        qopen,
			       input        pod_um,
			       input        pod_um_conv,
			       input        po_curr,
			       input        pod_pr_list,
			       input        eff_date,
			       input        pod_pur_cost,
			       input        no,
			       input        dummy_disc,
			       input-output newprice,
			       output       dummy_disc,
			       input-output newprice,
			       output       pc_recno
			      )" }
/*GUI*/ if global-beam-me-up then undo, leave.


/*G1SV*/             /* IF NO LIST PRICE WAS FOUND LETS TRY TO CHECK FOR   */
		     /* A VP_Q_PRICE FOR THE ITEM.  IF WE CANT FIND ONE,   */
		     /* POD_PRICE WILL REMAIN AS IT WAS ORIGINALLY.        */

/*G1SV*/             if pc_recno = 0 then do:
/*G1SV*/                find first vp_mstr where vp_part = pod_part
/*G1SV*/                and vp_vend = po_vend no-lock no-error.
/*G1SV*/                if available vp_mstr then do:
/*G1SV*/                   if qopen >= vp_q_qty and pod_um = vp_um
/*G1SV*/                   and vp_q_price > 0 and po_curr = vp_curr then
/*G1SV*/                      pod_pur_cost = vp_q_price.
/*G1SV*/                end.  /* IF AVAIL VP_MSTR */
/*G1SV*/             end.
/*G1SV*/             else
/*G1SV*/                pod_pur_cost = newprice.

/*G1SV**
* /*H0KH /*G0JN*/      if newprice <> ? then pod_pur_cost = newprice. */
* /*H0KH*/             if pc_recno <> 0 then pod_pur_cost = newprice.
**G1SV*/

/*G0JN*/          end.

/*F153*/          if  not porec then do:
/*F153*/              assign pod_qty_chg = - pod_qty_chg
/*F153*/                     pod_bo_chg  = - pod_bo_chg.
/*F153*/          end.

		  if pod_qty_chg <> 0 then do:
		     create sr_wkfl.
		     assign
		     sr_userid = mfguser
		     sr_lineid = string(pod_line)
		     sr_site = pod_site
		     sr_loc = pod_loc
		     sr_lotser = ""
		     sr_ref = ""
		     sr_qty = pod_qty_chg.
/*GO37** /*GM16*/    recno = recid(sr_wkfl). **/
/*GO37*/             if recid(sr_wkfl) = -1 then .
		  end.

/*H0M3*/          if porec or is-return then do:
                     /* CHECK FOR SINGLE ITEM / SINGLE LOT/SERIAL LOCATION */
/*H0M3*/             find loc_mstr where loc_site = pod_site
/*H0M3*/             and loc_loc = pod_loc no-lock no-error.

/*H0M3*/             if available loc_mstr and loc_single = yes then do:
/*H0M3*/                {gploc02.i pod_det pod_nbr pod_line pod_part}

/*H0M3*/                if error_flag = 0 and loc__qad01 = yes then do:
                           /* CHECK PRIOR RECEIPT TRANSACTIONS (ld_det's) FOR
                              DIFFERENT ITEMS OR LOT/SERIALS IN SAME LOCATION */
/*H0M3*/                   {gprun.i ""gploc01.p""
                                    "(pod_site,
                                      pod_loc,
                                      pod_part,
                                      pod_serial,
                                      "" "",
                                      loc__qad01,
                                      output error_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*H0M3*/                   if error_flag <> 0
                           /* ADJUSTING QTY ON A PREVIOUS VIOLATION (CREATED
                              BEFORE THIS PATCH) OF SINGLE ITEM/LOT/SERIAL
                              LOCATION ALLOWED; CREATING ANOTHER VIOLATION
                              DISALLOWED.
                           */
/*H0M3*/                   and can-find(ld_det where ld_site = pod_site
/*H0M3*/                   and ld_loc = pod_loc and ld_part = pod_part
/*H0M3*/                   and ld_lot = pod_serial and ld_ref = "") then
/*H0M3*/                      error_flag = 0.
/*H0M3*/                end. /* error_flag = 0 and loc__qad01 = yes */

/*H0M3*/                if error_flag <> 0 then do:
/*H0M3*/                   {mfmsg.i 596 2}
/*H0M3*/                   /* TRANSACTION CONFLICTS WITH SINGLE ITEM/LOT LOC */
/*H0M3*/                   undo preppoddet, next preppoddet.
/*H0M3*/                end.
/*H0M3*/             end.  /* avail loc_mstr and loc_single = yes */
/*H0M3*/          end. /* porec or is-return*/

/*J034*/          {gprun.i ""gpsiver.p""
		   "(input pod_site, input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 1 then do:


/*J040**************************DELETE CHECK STSTUS****************************
. /*H014* ***********Added new check routine to check status*******************/
. /*H093*/          if pod_type = "" then
. /*H014*/          do on error undo:
. /*H014*/             /*CREATE LD_DET RECORD IF ASSAY, ETC HAS BEEN CHANGED*/
. /*H014*/             /*OR THERE IS AN ITEM DEFINED STATUS FOR THIS ITEM   */
. /*H014*/             site = pod_site.
. /*H014*/             location = pod_loc.
. /*H014*/             msgref = " " .
. /*H014*/             lotserial = pod_serial.
. /*H014*/             global_part = pod_part.
. /*H014*/             {gprun.i ""poporca1.p""}
. /*H014*/
. /*H014*/             if msgref <> "" then do:
. /*H014*/                msgref = trim(msgref).
. /*H014*/                {mfmsg03.i 1921 2  pod_line msgref """"}
. /*H014*/                /* # conflicts with existing inventory detail*/
. /*H014*/                undo preppoddet, next preppoddet.
. /*H014*/             end.
. /*H014*/          end.
. /*H014* *******End added section*********************************************/
**J040*************************************************************************/

/*J034*/          end.  /* (IF RETURN_INT = 1) */

/*H0M3
 * /*FP66*/       {gprun.i ""polocrc.p"" "(input recid(pod_det),
 * /*FP66*/                                     output error_flag)"} .
 * /*FP66*/       if error_flag then do:
 * /*FP66*/          {mfmsg.i 245 2}
 * /*FP66*/          undo preppoddet, next preppoddet.
 * /*FP66*/       end.
 *H0M3*/
	       end.
	       else do:
		  pod_qty_chg = 0.
		  pod_bo_chg = pod_qty_ord - pod_qty_rcvd.
	       end.
	       pod_ps_chg = pod_qty_chg.
	       pod_rum = pod_um.
	       pod_rum_conv = 1.
	    end.
/*GUI*/ if global-beam-me-up then undo, leave.


	    /* for each */

/*F0F5*     SWAP OUT THE FOLLOWING CODE TO HIDE THE PROPER FRAME...
./*FS54*/    /* hide frame a before calling poporca which uses frame b. */
./*FS54*/    hide frame a no-pause.
.*F0F5*/
/*F0F5*/    if porec then
/*F0F5*/        hide frame a1 no-pause.
/*F0F5*/    else
/*F0F5*/        hide frame a2 no-pause.

	    /* RUN poporca.p TO SELECT EDIT ITEMS TO BE RECEIVED */
/*FN24*//*  do transaction: */
/*J041*/        lotserial = "".
	       po_recno = recid(po_mstr).
	       proceed = no.
	       {gprun.i ""zzpoporca.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*F153*/       /*********************************************************/
/*F153*/       /* if this is a return to supplier then reverse the sign */
/*F153*/       /*********************************************************/
/*F153*/       if not porec then do:

/*F153*/          for each pod_det
/*F153*/          where pod_nbr =  po_nbr
/*F153*/          and   pod_rma_type  = "O"
/*F153*/          and   pod_status    <> "c"
/*F153*/          and   pod_status    <> "x" :

/*F153*/             if pod_qty_chg <> 0 then do:
/*F153*/                assign
/*F153*/                pod_qty_chg = - pod_qty_chg
/*F153*/                pod_bo_chg  = - pod_bo_chg
/*F153*/                pod_ps_chg  = - pod_ps_chg.
/*F153*/             end.

/*F153*/             for each sr_wkfl
/*F153*/             where  sr_userid = mfguser
/*F153*/             and sr_lineid = string(pod_line):
/*F153*/                sr_qty = - sr_qty.
/*F153*/             end.
/*F153*/          end.
/*F153*/       end.
/*F153*/
	       /* RUN poporcb.p TO CREATE RECEIPTS & UPDATE TRANSACTIONS */
	       if proceed = yes then do:
/*J0CV            {gprun.i ""poporcb.p""} */
/*J0CV*/          {gprun.i ""zzpoporcb.p"" "(input ship_date)"}
/*GUI*/ if global-beam-me-up then undo, leave.



/*H010*/          /* CALCULATE AND EDIT TAXES */
/*H010*/          if {txnew.i} then do:
/*H010*/             undo_trl2 = true.
/*H010*/             {gprun.i ""porctrl2.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H010*/             if undo_trl2 then undo.
/*H010*/          end.

/*F177*/          {gprun.i ""poporcd.p""}
/*GUI*/ if global-beam-me-up then undo, leave.
				
				
/*LB01*/		/*Call work order receive/backflush */				
				
/*				iWosubrec = 0.
				for each wosub:
					iWosubrec = iWosubrec + 1.
				end.
				if iWosubrec > 0 then
					message "采购项中有 " + string(iWosubrec) + "项属 S 类型，需要继续做加工单入库回冲！" view-as alert-box.
*/				
				for each wosub where wosubqty <> 0:	
					find first wo_mstr where wo_lot = wosublot no-lock no-error.
					if not available wo_mstr then next.
					message "   外包零件 “" + wo_part + "” 入库回冲.   " view-as alert-box.
					{gprun.i ""zzwowoisrc.p"" "(input wosublot, input wosubqty)"}
				end.
/*LB01*/		
	       end.
       

/*GO37*/       hide frame b no-pause.

/*FN24*//*  end. /*transaction*/ */

	 end.
/*GUI*/ if global-beam-me-up then undo, leave.


	 status input.
