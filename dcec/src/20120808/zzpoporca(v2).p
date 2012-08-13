/* GUI CONVERTED from poporca.p (converter v1.69) Fri May 23 00:18:54 1997 
*/
/* poporca.p - PURCHASE ORDER RECEIPT W/ SERIAL NUMBER CONTROL          */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.0     LAST MODIFIED: 11/19/91    BY: pma *F003*          */
/* REVISION: 7.0     LAST MODIFIED: 12/09/91    BY: RAM *F070*          */
/* REVISION: 7.0     LAST MODIFIED: 01/31/92    BY: RAM *F126*          */
/* REVISION: 7.0     LAST MODIFIED: 02/12/92    BY: pma *F190*          */
/* REVISION: 7.0     LAST MODIFIED: 03/03/92    BY: pma *F085*          */
/* REVISION: 7.0     LAST MODIFIED: 03/09/92    BY: RAM *F269*          */
/* REVISION: 7.0     LAST MODIFIED: 03/11/92    BY: pma *F087*          */
/* REVISION: 7.0     LAST MODIFIED: 03/24/92    BY: RAM *F311*          */
/* REVISION: 7.3     LAST MODIFIED: 10/24/92    BY: sas *G240*          */
/* REVISION: 7.3     LAST MODIFIED: 09/27/92    BY: jcd *G247*          */
/* REVISION: 7.3     LAST MODIFIED: 11/10/92    BY: pma *G304*          */
/* REVISION: 7.3     LAST MODIFIED: 12/14/92    BY: tjs *G443*          */
/* REVISION: 7.3     LAST MODIFIED: 01/11/93    BY: bcm *G425*          */
/* REVISION: 7.3     LAST MODIFIED: 01/18/93    BY: WUG *G563*          */
/* REVISION: 7.3     LAST MODIFIED: 02/22/93    BY: tjs *G718*          */
/* REVISION: 7.3     LAST MODIFIED: 04/09/93    BY: WUG *G873*          */
/* REVISION: 7.3     LAST MODIFIED: 04/19/93    BY: tjs *G964*          */
/* REVISION: 7.2     LAST MODIFIED: 05/13/93    BY: kgs *GA90*          */
/* REVISION: 7.2     LAST MODIFIED: 05/26/93    BY: kgs *GB35*          */
/* REVISION: 7.3     LAST MODIFIED: 06/17/93    BY: WUG *GC41*          */
/* REVISION: 7.3     LAST MODIFIED: 06/21/93    BY: WUG *GC57*          */
/* REVISION: 7.3     LAST MODIFIED: 06/30/93    BY: dpm *GC87*          */
/* REVISION: 7.4     LAST MODIFIED: 07/02/93    BY: jjs *H020*          */
/* REVISION: 7.4     LAST MODIFIED: 07/26/93    BY: WUG *H038*          */
/* REVISION: 7.4     LAST MODIFIED: 09/15/93    BY: tjs *H093*          */
/* REVISION: 7.3     LAST MODIFIED: 11/19/93    BY: afs *H236*          */
/* REVISION: 7.3     LAST MODIFIED: 04/19/94    BY: dpm *GJ42*          */
/* REVISION: 7.3     LAST MODIFIED: 07/19/94    BY: dpm *FP45*          */
/* REVISION: 7.3     LAST MODIFIED: 07/28/94    BY: dpm *FP66*          */
/* REVISION: 7.3     LAST MODIFIED: 08/02/94    BY: rmh *FP73*          */
/* REVISION: 7.3     LAST MODIFIED: 09/11/94    BY: rmh *GM16*          */
/* REVISION: 7.3     LAST MODIFIED: 09/20/94    BY: ljm *GM74*          */
/* REVISION: 7.3     LAST MODIFIED: 10/11/94    BY: cdt *FS26*          */
/* REVISION: 7.3     LAST MODIFIED: 10/18/94    BY: cdt *FS54*          */
/* REVISION: 8.5     LAST MODIFIED: 10/24/94    BY: pma *J040*          */
/* REVISION: 7.3     LAST MODIFIED: 10/25/94    BY: cdt *FS78*          */
/* REVISION: 8.5     LAST MODIFIED: 10/27/94    BY: taf *J038*          */
/* REVISION: 7.3     LAST MODIFIED: 10/27/94    BY: ljm *GN62*          */
/* REVISION: 7.3     LAST MODIFIED: 11/10/94    BY: bcm *GO37*          */
/* REVISION: 8.5     LAST MODIFIED: 11/22/94    BY: mwd *J034*          */
/* REVISION: 8.5     LAST MODIFIED: 12/14/94    BY: ktn *J041*          */
/* REVISION: 8.5     LAST MODIFIED: 12/20/94    BY: tjs *J014*          */
/* REVISION: 7.4     LAST MODIFIED: 12/28/94    BY: srk *G0B2*          */
/* REVISION: 7.3     LAST MODIFIED: 03/15/95    BY: pcd *G0HJ*          */
/* REVISION: 7.4     LAST MODIFIED: 03/22/95    BY: dxk *F0NS*          */
/* REVISION: 7.4     LAST MODIFIED: 05/22/95    BY: jym *F0S0*          */
/* REVISION: 8.5     LAST MODIFIED: 06/07/95    BY: sxb *J04D*          */
/* REVISION: 8.5     LAST MODIFIED: 07/31/95    BY: kxn *J069*          */
/* REVISION: 8.5     LAST MODIFIED: 09/26/95    BY: kxn *J07M*          */
/* REVISION: 8.5     LAST MODIFIED: 10/07/95    BY: kxn *J08J*          */
/* REVISION: 7.4     LAST MODIFIED: 07/11/95    BY: jym *G0RY*          */
/* REVISION: 7.4     LAST MODIFIED: 08/07/95    BY: jym *G0TP*          */
/* REVISION  7.4     LAST MODIFIED: 08/15/95    BY: rvw *G0V0*          */
/* REVISION  7.4     LAST MODIFIED: 09/12/95    BY: ais *F0V7*          */
/* REVISION  7.4     LAST MODIFIED: 10/23/95    BY: ais *G19K*          */
/* REVISION  7.4     LAST MODIFIED: 10/31/95    BY: jym *F0TC*          */
/* REVISION: 8.5     LAST MODIFIED: 11/07/95    BY: kxn *J091*          */
/* REVISION: 8.5     LAST MODIFIED: 03/11/96    BY: jpm *J0F5*          */
/* REVISION: 8.5     LAST MODIFIED: 03/28/96    BY: rxm *G1R9*          */
/* REVISION: 8.5     LAST MODIFIED: 05/01/96    BY: *J04C* Sue Poland        
  */
/* REVISION: 8.5     LAST MODIFIED: 05/14/96    BY: *G1SL* Robin McCarthy    
  */
/* REVISION: 8.5     LAST MODIFIED: 06/28/96    BY: *J0WR* Sue Poland        
  */
/* REVISION: 8.5     LAST MODIFIED: 07/03/96    BY: *G1Z8* Ajit Deodhar      
  */
/* REVISION: 8.5     LAST MODIFIED: 07/29/96    BY: *J12S* Kieu Nguyen       
  */
/* REVISION: 8.5     LAST MODIFIED: 09/03/96    BY: *J14K* Sue Poland        
  */
/* REVISION: 8.5     LAST MODIFIED: 01/05/97    BY: *J1DH* Julie Milligan    
  */
/* REVISION  8.5     LAST MODIFIED: 02/27/97    BY: *H0SN* Suresh Nayak      
  */
/* REVISION: 8.5     LAST MODIFIED: 04/30/97    BY: *J1QB* Sanjay Patil      
  */
/* REVISION: 8.5     LAST MODIFIED: 05/13/97    BY: *G2M4* Ajit Deodhar      
  */
/* Revision  8.5     Last Modified: 11/28/03    BY: *LB01* Long Bo      */
/* Revision     8.5         Last Modified:     03/14/2004 By: Kevin*/
/* Note(kevin): change sub-program 'poporca3.p' to 'zzpoporca3.p',
                        change the logic of the default value of field 
'location' to in_user*/

/*!
    poporca.p - ITEM ENTRY FOR PO RECEIPTS
*/

/*!
CHANGES MADE IN THIS PROGRAM MAY ALSO HAVE TO BE MADE TO PORVISA.P
*/

/*GO37*/ {mfdeclre.i}

/*GO37*/ {porcdef.i}

/*GO37*/ /* REORGANIZED VARIABLES */

         /* NEW SHARED VARIABLES, BUFFERS AND FRAMES */
         define new shared variable cline               as character.
/*H093*/ define new shared variable conv_to_pod_um      like pod_um_conv.
         define new shared variable issue_or_receipt    as character
                                                        initial "收货".
/*GC87*/ define new shared variable line                like pod_line
                                                        format ">>>".
         define new shared variable lotserial_control   as character.
         define new shared variable lotserial_qty       like sr_qty no-undo.
         define new shared variable multi_entry         like mfc_logical 
no-undo
                                                        label "多记录".
/*H093*/ define new shared variable podtype             like pod_type.
/*F190*/ define new shared variable rct_site            like pod_site.
         define new shared variable total_lotserial_qty like pod_qty_chg.
/*H093*/ define new shared variable total_received      like pod_qty_rcvd.
         define new shared variable trans_um            like pt_um.
         define new shared variable trans_conv          like sod_um_conv.
/*J014*/ define new shared variable undo_all            like mfc_logical.

/*GC87*  define new shared variable site                like sr_site 
no-undo. */
/*GC87*  define new shared variable location            like sr_loc 
no-undo.*/
/*GC87*  define new shared variable lotref              like sr_ref 
no-undo.*/
/*GC87*  define new shared variable lotserial           like sr_lotser
*                                                      no-undo.*/
/*GC87*  define new shared workfile stat_wkfl           no-undo    */
/*GC87*  define new shared variable msgref              as character
*                                                      format "x(20)". */
/*GC87*  define new shared variable stat_recno          as recid.       */
/*GO37** define new shared variable transtype           as character
**                                                     initial "RCT-PO". **/

         /* SHARED VARIABLES, BUFFERS AND FRAMES */
         define shared variable qopen       like pod_qty_rcvd label 
"短缺量".
/*J038*/ define shared variable vendlot     like tr_vend_lot no-undo.
/*GO37*/ define shared frame b.

/*G247** define shared variable mfguser as character. **/

         /* LOCAL VARIABLES, BUFFERS AND FRAMES */
         define variable cancel_bo      like mfc_logical.

/*J040*  define variable chg_stat       like mfc_logical label"Change 
Status".*/
/*J040*/ define variable chg_attr       like mfc_logical label "改变属性".
/*G718*/ define variable cmmt_yn        like mfc_logical
                                        label "说明" no-undo.
         define variable cont           like mfc_logical initial yes.
         define variable csz            as character format "X(38)".
         define variable del-yn         like mfc_logical initial no.
         define variable due            like pod_due.
         define variable dwn            as integer.
/*G1SL /*FP66*/ define variable error_flag     like mfc_logical. */
/*G1SL*/ define variable err_flag       like mfc_logical no-undo.
         define variable first_down     as integer initial 0.
/*J14K* /*FS26*/ define variable fromloc        like pod_loc.   */
/*J14K* /*FS26*/ define variable fromsite       like pod_site.  */
         define variable i              as integer.
         define variable ln_stat        like mfc_logical no-undo.
/*GO37*/ define variable msgnbr         as integer.
         define variable packing_qty    like pod_ps_chg no-undo.
         define variable qty_left       like tr_qty_chg.
         define variable receipt_um     like pod_rum no-undo.
         define variable reset_um       like mfc_logical initial no.
         define variable serial_control like mfc_logical initial no.
/*FS54*/ define variable shipqtychg     like pod_qty_chg
                                        column-label "发货数量".
/*J14K* /*FS26*/ define variable toloc          like pod_loc.   */
/*J14K* /*FS26*/ define variable tosite         like pod_site.  */
/*H020*/ define variable undo-taxes     like mfc_logical no-undo.
/*FS26*/ define variable undotran       like mfc_logical.
         define variable yn             like mfc_logical.
/*G0TP*/ define variable w-int1 as integer no-undo.
/*G0TP*/ define variable w-int2 as integer no-undo.
/*H093*  define variable conv_to_pod_um like pod_um_conv. */
/*GC87*  define variable line           like pod_line format ">>>". */
/*H093*  define variable overage_qty    like pod_qty_rcvd. */
/*H093*  define variable total_received like pod_qty_rcvd. */
/*J04D*/ define variable ponbr          like pod_nbr no-undo.
/*J04D*/ define variable poline         like pod_line no-undo.
/*J04D*/ define variable lotnext        like pod_lot_next no-undo.
/*J04D*/ define variable lotprcpt       like pod_lot_rcpt no-undo.
/*J041*/ define variable newlot         like pod_lot_next.
/*J041*/ define variable trans-ok       like mfc_logical.
/*J041*/ define variable alm_recno      as recid.
/*J041*/ define variable filename       as character.
/*J040*/ define variable srlot          like sr_lotser no-undo.
/*J069*/ define variable almr           like alm_pgm.
/*J069*/ define variable ii             as integer.
/*J14K*/ define variable errsite        like pod_site no-undo.
/*J14K*/ define variable errloc         like pod_loc no-undo.
/*G2M4*/ define variable use_pod_um_conv like mfc_logical no-undo.


/*H093*  define buffer poddet           for pod_det. */

/*LB01*/
			define shared work-table wosub			/* record subcontract work order data */
				field wosubline like pod_line
				field wosublot like wod_lot
				field wosubop  like wod_op
				field wosubqty like pod_qty_chg.
/*LB01*/


/*GO37 ** MOVED THE FOLLOWING VARIABLES TO porcdef.i **
        *define     shared variable base_amt        like pod_pur_cost.
/*G718*/*define new shared variable cmtindx         like cmt_indx.
        *define     shared variable eff_date        like glt_effdate.
        *define     shared variable exch_rate       like exd_rate.
/*GC87*/*define     shared variable location        like sr_loc no-undo.
/*GC87*/*define     shared variable lotref          like sr_ref no-undo.
/*GC87*/*define     shared variable lotserial       like sr_lotser no-undo.
        *define     shared variable move            like mfc_logical.
/*GC87*/*define shared variable msgref              as character format 
"x(20)".
        *define     shared variable po_recno        as recid.
/*G964*/*define     shared variable pod_recno       as recid.
/*G240*/*define shared variable porec           like mfc_logical no-undo.
        *define     shared variable ps_nbr          like prh_ps_nbr.
        *define     shared variable ref             like glt_ref.
        *define     shared variable proceed         like mfc_logical.
/*H093*/*define new shared variable total_received  like pod_qty_rcvd.
        *define     shared variable trlot           like tr_lot.
/*GB35*/*define     shared variable updt_blnkt      like mfc_logical.
/*GC87*/*define     shared variable site            like sr_site no-undo.
/*GC87*/*define     shared variable stat_recno      as recid.
        *define     shared variable wolot           like pod_wo_lot no-undo.
        *define     shared variable woop            like pod_op no-undo.
/*GC87*/*define     shared workfile stat_wkfl no-undo
/*F087*/*                   field podnbr    like pod_nbr
/*F087*/*                   field podline   like pod_line
/*F087*/*                   field assay     like tr_assay initial ?
/*F087*/*                   field grade     like tr_grade initial ""
/*F087*/*                   field expire    like tr_expire initial ?
/*F087*/*                   field rcpt_stat like ld_status initial ?.
*GO37***END MOVED **/

/*J040*/ /*WORKFILE FOR POD RECEIPT ATTRIBUTES*/
/*J040*/ define shared workfile attr_wkfl no-undo
/*J040*/   field chg_line   like sr_lineid
/*J040*/   field chg_assay  like tr_assay
/*J040*/   field chg_grade  like tr_grade
/*J040*/   field chg_expire like tr_expire
/*J040*/   field chg_status like tr_status
/*J040*/   field assay_actv like mfc_logical
/*J040*/   field grade_actv like mfc_logical
/*J040*/   field expire_actv like mfc_logical
/*J040*/   field status_actv like mfc_logical.

/*G425*/ FORM /*GUI*/  with frame c 5 down width 80 THREE-D /*GUI*/.


/*FS54*/ FORM /*GUI*/
/*G0B2*/    pod_line             space(.3)
/*G0B2*/    pod_part             space(.3)
/*G0B2*/    pt_um                space(.3)
/*G0B2*/    qopen                space(.3)
/*G0B2*/    pod_um               space(.3)
/*G0B2*/    shipqtychg           space(.3)
/*G0B2*/    pod_rum              space(.3)
/*G0B2*/    pod_project          space(.3)
/*G0B2*/    pod_due_date         space(.3)
/*G0B2*/    pod_type
         with frame cship 5 down width 80 THREE-D /*GUI*/.


/*FS54*/    FORM /*GUI*/
/*FS54*/
RECT-FRAME       AT ROW 1 COLUMN 1.25
RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
SKIP(.1)  /*GUI*/
po_nbr         colon 12   label "订单"
/*FS54*/       po_vend
/*FS54*/       po_stat
/*FS54*/       ps_nbr         to 78
/*FS54*/     SKIP(.4)  /*GUI*/
with frame b side-labels no-attr-space width 80 NO-BOX THREE-D /*GUI*/.

DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
RECT-FRAME-LABEL:HIDDEN in frame b = yes.
RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/


/*F087*/ /*colon 15 below was colon 13*/
/*F087*/ /*colon 36 below was colon 34*/

/*H0SN*/ FORM /*GUI*/  with frame e down no-attr-space width 80 THREE-D 
/*GUI*/.


         FORM /*GUI*/

RECT-FRAME       AT ROW 1 COLUMN 1.25
RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
SKIP(.1)  /*GUI*/
line           colon 15
            receipt_um     colon 36
            site           colon 54
            location       colon 68 label "库"
            lotserial_qty  colon 15
            wolot          colon 36 label "标志"
            lotserial      colon 54 label "批/序"
            packing_qty    colon 15 label "装箱单数量"
            woop           colon 36 label "工序"
            lotref         colon 54
            cancel_bo      colon 15 label "取消欠交量"
/*J038*     multi_entry    colon 54                                  */
/*J038*/    vendlot        colon 54 /*J04D*/format "x(22)"
            pod_part       colon 15 /*7.0*/ no-attr-space
/*J038*/    multi_entry    colon 54
/*J038*     chg_stat       colon 54                                  */
/*J040*/    chg_attr       colon 73
            pod_vpart      /*7.0 colon 54 */
/*F087*/                   colon 15
            /*7.0*/ no-attr-space
/*G718*/    cmmt_yn        colon 54 label "说明"
          SKIP(.4)  /*GUI*/
with frame d side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

DEFINE VARIABLE F-d-title AS CHARACTER INITIAL "".
RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.
RECT-FRAME-LABEL:HIDDEN in frame d = yes.
RECT-FRAME:HEIGHT-PIXELS in frame d =
  FRAME d:HEIGHT-PIXELS - RECT-FRAME:Y in frame d - 2.
RECT-FRAME:WIDTH-CHARS IN FRAME d = FRAME d:WIDTH-CHARS - .5.  /*GUI*/



         find first poc_ctrl no-lock.
/*J04D*/ find first clc_ctrl no-lock no-error.
/*J04D*/ if not available clc_ctrl then do:
/*J04D*/    {gprun.i ""gpclccrt.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J04D*/    find first clc_ctrl no-lock.
/*J04D*/ end.

         if available poc_ctrl and poc_ln_stat = "x" then ln_stat = yes.
         else ln_stat = no.

/*F311*/ find po_mstr where recid(po_mstr) = po_recno.
         line = 1.

         proceed = no.

         edit-loop:
/*GO37** repeat: **/
/*GO37*/ repeat on endkey undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.

/*LB01*/
   		for each wosub exclusive-lock:
   			delete wosub.
	    	end.
/*LB01*/

            lineloop:
            repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


/*FS54*/       display po_nbr po_vend po_stat ps_nbr with frame b.

               clear frame c all no-pause.
               clear frame d all no-pause.

/*FS54*/       clear frame cship all no-pause.
/*H0SN*/       clear frame e all no-pause.

/*FS54*/       if porec then
                  view frame c.
/*FS54*/       else
/*FS54*/          view frame cship.

               view frame d.

               for each pod_det no-lock
               where pod_nbr = po_nbr and pod_line >= line
               and pod_status <> "c" and pod_status <> "x"
               use-index pod_nbrln by pod_line:
/*GUI*/ if global-beam-me-up then undo, leave.


/*G240*/          if  porec then do:
/*G240*/              if  pod_rma_type <> "I"  and
/*G240*/                  pod_rma_type <> ""   then
/*G240*/                  next.
/*G240*/          end.
/*G240*/          else do:
/*G240*/              if  pod_rma_type <> "O" then
/*G240*/                  next.
/*G240*/          end.

/*F126*/          find si_mstr where si_site = pod_site no-lock no-error.
/*F126*/          if available si_mstr and si_db = global_db then do:
                     find pt_mstr where pt_part = pod_part no-lock no-error.
/*G240*              qopen = pod_qty_ord - pod_qty_rcvd.  */

/*G240*/             if  porec then
/*G240*/              ASSIGN
/*G240*/                 qopen  =  pod_qty_ord - pod_qty_rcvd.
/*G240*/             else
/*G240*/              ASSIGN
/*G240*/                 qopen  =  - (pod_qty_ord - pod_qty_rcvd).

/*G873*/             if pod_sched then do:
/*G873*/               {gprun.i ""rsoqty.p"" "(input recid(pod_det),
                                               input eff_date,
                                               output qopen)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G873*/             end.
/*FS54*/             /* Display correct label for RTS shipments. */
/*FS54*/             assign shipqtychg = pod_qty_chg.
/*FS54*/             if porec then do:
                        display pod_line
/*GM74*/       view-as fill-in size 5 by 1 space(.2)
                        pod_part
/*GM74*/      space(.2)
                        pt_um when (available pt_mstr)
/*GM74*/      space(.2)
                        qopen
/*GM74*/      space(.2)
                        pod_um
/*GM74*/       view-as fill-in size 3 by 1 space(.2)
                        pod_qty_chg
/*GM74*/      space(.2)
                        pod_rum
/*GM74*/       view-as fill-in size 3 by 1 space(.2)
                        pod_project
/*GM74*/      space(.2)
                        pod_due_date
/*GM74*/      space(.2)
                        pod_type
/*GM74*/       view-as fill-in size 3 by 1
                     with frame c.
/*J08J*/                     if frame-line(c) = frame-down(c) then leave.
/*J04D*/             down 1 with frame c.

/*FS54*/             end.  /* if porec */
/*FS54*/             else do:
/*FS54*/                display
/*FS54*/                   pod_line
/*FS54*/                   pod_part
/*FS54*/                   pt_um when (available pt_mstr)
/*FS54*/                   qopen
/*FS54*/                   pod_um
/*FS54*/                   shipqtychg
/*FS54*/                   pod_rum
/*FS54*/                   pod_project
/*FS54*/                   pod_due_date
/*FS54*/                   pod_type
/*FS54*/                with frame cship.
/*FS54*/                if frame-line(cship) = frame-down(cship) then leave.
/*FS54*/                down 1 with frame cship.
/*FS54*/             end. /* else do */
/*F126*/          end.
               end.
/*GUI*/ if global-beam-me-up then undo, leave.


               line = 0.

/*J041         do on error undo, retry:               */
/*J034*/       setline:
/*J041*/       do TRANSACTION on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                  update line with frame d editing:
/*F126*/             nppoddet: repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

                        /* FIND NEXT/PREVIOUS RECORD */
                        {mfnp01.i
                           pod_det
                           line
                           pod_line
                           pod_nbr
                           po_nbr
                           pod_nbrln}
                        if recno <> ? then do:
                           line = pod_line.
/*F126*/                   find si_mstr
/*F126*/                   where si_site = pod_site no-lock no-error.
/*F126*/                   if not available si_mstr
/*F126*/                   or (available si_mstr and si_db <> global_db) 
then
/*F126*/                      next nppoddet.
                           display line pod_qty_chg @ lotserial_qty
                           pod_ps_chg @ packing_qty
                           ln_stat @ cancel_bo
                           pod_part
                           pod_vpart
                           pod_rum @ receipt_um
                           pod_wo_lot @ wolot
                           pod_op @ woop
                           with frame d.
                        end. /* IF RECNO <> ? */
/*F126*/                leave.
/*F126*/             end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* NPPODDET: REPEAT: */
/*F126*/             if keyfunction(lastkey) = "end-error" then
/*F126*/                undo lineloop, leave.

                  end. /* END UPDATE ... EDITING */

/*J038*/          assign vendlot = ""
/*J041*/                 lotnext = ""
/*J041*/                 newlot  = "".

                  if line = 0 then leave lineloop.

                  find pod_det where pod_nbr = po_nbr
                  and pod_line = line no-error.
/*F126*/          if available pod_det then do:
/*F126*/             find si_mstr where si_site = pod_site no-lock no-error.
/*F126*/             if not available si_mstr
/*F126*/             or (available si_mstr and si_db <> global_db) then do:
/*F126*/                {mfmsg.i 5421 3}
/*F126*/                /* SITE NOT ASSIGNED TO THIS DATABASE */
/*J034* /*F126*/                undo, retry. */
/*J034*/                undo setline, retry.
/*F126*/             end.
/*J041*/             if (pod_blanket <> "") then do:
/*J041*/                ponbr = pod_blanket.
/*J041*/                poline = pod_blnkt_ln.
/*J041*/             end.
/*J041*/             else do:
/*J041*/                ponbr = pod_nbr.
/*J041*/                poline = pod_line.
/*J041*/             end.
/*F126*/          end.

                  if not available pod_det then do:
                     {mfmsg.i 45 3}
/*J034*              undo, retry. */
/*J034*/             undo setline, retry.
                  end.

                  /*GO37 PICK UP CURRENTLY EFFECTIVE CUM ORDER*/
                  {gprun.i ""poporca5.p"" "(input pod_nbr,
                                            input pod_line,
                                            input eff_date)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*G240*/          if (porec                and
/*G240*/              pod_rma_type <> "I"  and
/*G240*/              pod_rma_type <> "")  or
/*G240*/             (not porec            and
/*G240*/              pod_rma_type <> "O")
/*G240*/          then do:
/*G240*/              {mfmsg.i 45 3}
/*J034* /*G240*/              undo, retry. */
/*J034*/              undo setline, retry.
/*G240*/          end.

                  if pod_status = "c" or pod_status = "x" then do:
                     {mfmsg02.i 336 3 pod_status}
/*J034*              undo, retry. */
/*J034*/             undo setline, retry.
                  end.
/*J041*/          cline = string (line).
/*J041*/          find first sr_wkfl where sr_userid = mfguser
/*J041*/                  and sr_lineid = cline no-lock no-error.
/*J041*/          if available sr_wkfl then newlot = sr_lotser.
/*J041*/          pod_recno = recid (pod_det).
/*J041*/          find pt_mstr where pt_part = pod_part no-lock no-error.
/*J041*/             if available pt_mstr then do:
/*J12S* /*J041*/     if (pt_lot_ser = "L" and pt_auto_lot = yes and     */
/*J12S* /*J041*/         pt_lot_grp <> "") then do:                     */
/*J12S*/             if (pt_lot_ser = "L" and pt_auto_lot = yes and
/*J12S*/                 pt_lot_grp <> "" and porec and pod_type = "") then 
do:
/*J041*/                find alm_mstr where alm_lot_grp = pt_lot_grp
/*J041*/                and alm_site = pod_site no-lock no-error.
/*J041*/                if not available alm_mstr then
/*J041*/                   find alm_mstr where alm_lot_grp = pt_lot_grp
/*J041*/                   and alm_site = "" no-lock no-error.
/*J041*/                if not available alm_mstr then do:
/*J041*/                   {mfmsg.i 2737 3}
/*J034*/                   undo setline, retry.
/*J041*/                end.
/*J041*/                else do:
/*J041*/                    if (search(alm_pgm) = ?) then do:

/*J069*/                       ii = index(alm_pgm,".p").
/*J0F5* /*J069*/               almr = substring(alm_pgm, 1, 2) + "/"  */
/*J0F5*/                       almr = global_user_lang_dir + "/"
/*J0F5*/                            + substring(alm_pgm, 1, 2) + "/"
/*J069*/                            + substring(alm_pgm,1,ii - 1) + ".r".
/*J069*/                       if (search(almr)) = ? then do:
/*J041*/                          {mfmsg02.i 2732 4 alm_pgm}
                                  /* AUTO LOT PROGRAM NOT FOUND */
/*J041*/                          undo setline, retry.
/*J069*/                       end.
/*J041*/                    end.
/*J041*/                end.
/*J041*/                if newlot = "" then do:
/*J041*/                   alm_recno = recid (alm_mstr).
/*J041*/                   filename = "pod_det".
/*J041*/                   if false then do:
/*J0F5* *****************************************************************
* /*J041*/                      {gprun0.i gpauto01.p "(input alm_recno,
*                                                     input pod_recno,
*                                                     input "filename",
*                                                     output newlot,
*                                                     output trans-ok)"
*                              }
*************************************************************************/
/*J0F5*/                      {gprun.i ""gpauto01.p"" "(input alm_recno,
                                                          input pod_recno,
                                                         input "filename",
                                                         output newlot,
                                                         output trans-ok)"
                               }
/*GUI*/ if global-beam-me-up then undo, leave.


/*J041*/                   end.

/*J041*/                   {gprun.i alm_pgm "(input alm_recno,
                                              input pod_recno,
                                              input "filename",
                                              output newlot,
                                              output trans-ok)"
                           }
/*GUI*/ if global-beam-me-up then undo, leave.

/*J041*/                   if not trans-ok then undo lineloop, retry.
/*J041*/                   lotserial = newlot.
/*J041*/                   release alm_mstr.
/*J041*/                end.  /* NEW LOT  */
/*J041*/             end.  /* IF pt_lot_ser = L */
/*J041*/          end.

               end.
/*GUI*/ if global-beam-me-up then undo, leave.
/*  DO ON ERROR UNDO, RETRY */ /* TRANSACTION */

               assign
                  packing_qty = pod_ps_chg
                  cancel_bo = ln_stat
                  wolot = pod_wo_lot
                  woop = pod_op
/*J041*/          lotserial = newlot
/*J04D*/          lotnext = newlot
                  receipt_um = pod_rum.

               display line
                  packing_qty
                  cancel_bo
                  pod_part
                  pod_vpart
                  receipt_um
                  wolot
/*J041*/          lotnext @ lotserial
                  woop
/*J034*/          pod_site @ site
               with frame d.

/*J034*/       if available si_mstr then do:
/*J034*/          {gprun.i ""gpsiver.p"" "(input si_site,
                                           input recid(si_mstr),
                                           output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/       end.
/*J034*/       if return_int = 0 then do:
/*J034*/          {mfmsg.i 725 3} /* USER DOES NOT HAVE  */
/*J034*/                          /* ACCESS TO THIS SITE */
/*J034*/          pause.
/*J034*/          undo lineloop, retry.
/*J034*/       end.

               /* Initialize input variables, check for open vouchers. */
/*GC87*/       /* (Subroutine created to reduce r-code size.)          */
/*GC87*/       pod_recno = recid(pod_det).
/*/*GC87*/       {gprun.i ""poporca3.p""}*/                            
/*marked by kevin,03/14/2004*/

                          {gprun.i ""zzpoporca3.p""}                         
           /*added by kevin*/

/*GUI*/ if global-beam-me-up then undo, leave.


/*J041*/       DO TRANSACTION:
/*GUI*/ if global-beam-me-up then undo, leave.

/*F190*/       locloop:
               do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

/*F126*/          ststatus = stline[3].
/*F126*/          status input ststatus.

                  find first sr_wkfl where sr_userid = mfguser
                  and sr_lineid = cline no-lock no-error.

/*J040/*F087*/    find first stat_wkfl where podnbr = pod_nbr     */
/*J040/*F087*/    and podline = pod_line no-error.                */
/*J040/*F087*/    if available stat_wkfl then chg_stat = yes.     */
/*J040/*F087*/    else chg_stat = no.                             */

/*G718*/          cmmt_yn = no.
/*J12S*/          chg_attr = no.
/*GJ42*/          find pt_mstr where pt_part = pod_part no-lock no-error.

/*J041*/          lotprcpt  = pod_lot_rcpt.

/*F0NS** ****************************************************************
*                 update lotserial_qty packing_qty cancel_bo receipt_um
*                 wolot woop site location lotserial lotref multi_entry
* /*F087*/          chg_stat
* /*G718*/          cmmt_yn
*                 with frame d
*                 editing:
*                    global_site = input site.
*                    global_loc = input location.
* /*GO37*/             global_lot = input wolot.
* /*G443*/             if available sr_wkfl and input site <> sr_site then 
do:
* /*G443*/             /* Ea entry must be the same site 4 receipt on a line 
*/
* /*G443*/                {mfmsg.i 687 4}
* /*G443*/                undo, retry.
* /*G443*/             end.
*                    readkey.
*                    apply lastkey.
*                 end.
********************************************************************F0NS*/

/* F0NS below replaces the update/edit block above with a display/set */
/* Only lines that were functionally changed were commented with F0NS */

/*F0NS*/  /* Begin */

/*F0NS*/          i = 0.
/*F0NS*/          multi_entry = no.
/*F0NS*/          for each sr_wkfl no-lock where sr_userid = mfguser
/*F0NS*/          and sr_lineid = cline:
/*F0NS*/             i = i + 1.
/*F0NS*/             if i > 1 then do:
/*F0NS*/                multi_entry = yes.
/*F0NS*/                leave.
/*F0NS*/             end.
/*F0NS*/          end.

/*F0NS*/          display lotserial_qty
                     packing_qty
                     cancel_bo
                     receipt_um
                     wolot
                     woop
                     site
                     location
                     lotserial
                     lotref
/*J038*/             vendlot
                     multi_entry
/*J040*              chg_stat      */
/*J040*/             chg_attr
/*G718*/             cmmt_yn
                  with frame d.

/*F0NS*/          set lotserial_qty
                     packing_qty
                     cancel_bo
                     receipt_um
                     wolot
                     woop
/*F0NS*/             site when (not multi_entry)
/*G1Z8**             location                                            */
/*G1Z8**             lotserial                                           */
/*G1Z8** /*J041*/          when (not (available pt_mstr and              */
/*G1Z8** /*J04D*/                     (pt_lot_ser = "L" and pt_auto_lot  */
/*G1Z8** /*J091*/                       and pt_lot_grp <> "")))          */
/*G1Z8**             lotref                                              */

/*G1Z8*/             location when (not multi_entry)
/*G1Z8*/             lotserial
/*J12S*/                     when (not multi_entry)
/*J12S* /*G1Z8*/             when (not (available pt_mstr and            */
/*J12S* /*G1Z8*/                       (pt_lot_ser = "L" and pt_auto_lot */
/*J12S* /*G1Z8*/                        and pt_lot_grp <> ""))           */
/*J12S* /*G1Z8*/                        and not multi_entry)             */
/*G1Z8*/             lotref   when (not multi_entry)
/*J038*/             vendlot
/*F0NS*/             multi_entry when (not multi_entry)
/*J040/*F087*/       chg_stat      */
/*J12S* /*J040*/             chg_attr                                    */
/*J12S*/             chg_attr  when (porec and pod_type = "")
/*G718*/             cmmt_yn
/*G0V0*           with frame d.   */
/*G0V0*/          with frame d
/*G0V0*/          editing:
                    global_site = input site.
                    global_loc = input location.
/*G0V0*GO37*        global_lot = input wolot.        */
/*G0V0*/            global_lot = input lotserial.
/*G0V0*/            readkey.
/*G0V0*/            apply lastkey.
/*G0V0*/          end.

/*F0NS*/  /* End */

/*J040******************************************************************
* /*F087*/        if chg_stat and pod_type <> "" then do:
* /*F087*/           {mfmsg.i 1915 3} /*non-inventory receipt*/
* /*F087*/           next-prompt chg_stat with frame d.
* /*F087*/           undo locloop, retry.
* /*F087*/        end.
**J040*****************************************************************/

                  conv_to_pod_um = 1.
/*G2M4*/          use_pod_um_conv = no.

/*J041*           if available pt_mstr and receipt_um = pt_um then */
/*J041*/          if available pt_mstr then do:
/*J041*/             if receipt_um = pt_um then
/*G2M4*/               do:
/*G2M4*/                  use_pod_um_conv = yes.
                          conv_to_pod_um = 1 / pod_um_conv.
/*G2M4*/               end. /* DO */
/*J041*/          end.
/*G2M4**          else */
                  if receipt_um <> pod_um then do:
                     /*LOOK FOR RCPT UM TO LINE ITEM UM CONV*/
                     {gprun.i ""gpumcnv.p"" "(input receipt_um,
                                              input pod_um,
                                              input pod_part,
                                              output conv_to_pod_um)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     if conv_to_pod_um = ? then do:
                        /*NOT FOUND, LOOK FOR RCPT UM TO STOCKING UM CONV*/
                        find pt_mstr where pt_part = pod_part no-lock 
no-error.
                        if available pt_mstr then do:
                           {gprun.i ""gpumcnv.p"" "(input receipt_um,
                                                    input pt_um,
                                                    input pod_part,
                                                    output conv_to_pod_um)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                           if conv_to_pod_um <> ? then do:
                           /*CHG RCPT-TO-STKG-UM-CONV TO 
RCPT-TO-LINEITEM-CONV*/
                              conv_to_pod_um =  conv_to_pod_um / 
pod_um_conv.
                           end.
                        end.
                     end. /* IF CONV_TO_POD_UM = ? */
                  end. /* IF RECEIPT_UM <> POD_UM */

                  if conv_to_pod_um = ? then do:
                     {mfmsg.i 33 3} /* No UM conversion exists */
                     next-prompt receipt_um with frame d.
                     undo, retry.
                  end.

/*J034*/          {gprun.i ""gpsiver.p"" "(input (input site),
                                           input ?,
                                           output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3} /* USER DOES NOT HAVE ACCESS */
/*J034*/                             /* TO THIS SITE */
/*J034*/             next-prompt site with frame d.
/*J034*/             undo, retry.
/*J034*/          end.

/*J041*/          if available pt_mstr then do:
/*J1QB** /*J041*/ if (pod_lot_rcpt = yes) and (pt_lot_ser = "L") */
/*J1QB*/          if (pod_lot_rcpt = yes) and (pt_lot_ser <> "")

/*J04D*/          and (clc_lotlevel <> 0) then do:
/*J041*/             find first lot_mstr where lot_serial = lotserial and
/*J041*/                 lot_part = pod_part and lot_nbr = pod_nbr and
/*J041*/                 lot_line = cline no-lock no-error.
/*J041*/             if available lot_mstr
/*J041*/             then do:
/*J041*/                {mfmsg.i 2759 3} /* LOT IS IN USE */
/*J041*/                next-prompt lotserial with frame d.
/*J041*/                undo, retry.
/*J041*/             end.
/*J041*/             find first lotw_wkfl where lotw_lotser = lotserial and
/*J041*/             lotw_mfguser <> mfguser and lotw_part <> pt_part
/*J041*/             no-lock no-error.
/*J041*/             if available lotw_wkfl then do:
/*J041*/                {mfmsg.i 2759 3} /* LOT IS IN USE */
/*J041*/                next-prompt lotserial with frame d.
/*J041*/                undo, retry.
/*J041*/             end.
/*J041*/          end.
/*J041*/          end.


/*F190*/          rct_site = pod_site.
                  if pod_type = "S" then do:
/*J014*/             undo_all = false.
/*G964*/             pod_recno = recid(pod_det).
/*G964*/             /* SUBCONTRACT WORKORDER UPDATE */
/*G964*/             {gprun.i ""poporca2.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J014*/             if undo_all then do:
/*J014*/                next-prompt wolot with frame d.
/*J014*/                undo, retry.
/*J014*/             end.

/*LB01*/					find first wosub where wosubline = line exclusive-lock 
no-error.
							if not available wosub then do:
								create wosub.
								wosubline = line.
							end.
							assign
								wosublot = wolot
								wosubop = woop
								wosubqty = lotserial_qty.
/*LB01*/
                  end. /*if pod_type = "S"*/

/*J07M* DELETE FOLLOWING SECTION *
*                 i = 0.
*                 for each sr_wkfl no-lock where sr_userid = mfguser
*                 and sr_lineid = cline:
*                    i = i + 1.
*                    if i > 1 then do:
*                       multi_entry = yes.
*                       leave.
*                    end.
*                 end.
**J07M* END DELETE */

/*J040***************REPLACED FOLLOWING LOGIC IN ITS 
ENTIRETY******************
* /*F087*/        if not chg_stat and available stat_wkfl then delete 
stat_wkfl.
* /*F087*/        stat_recno = 0.
* /*F087*/        if chg_stat then do on error undo, retry
* /*F087*/        with frame d1 overlay row 15 col 36 1 col 1 down:
* /*F087*/           if not available stat_wkfl then do:
* /*F087*/              create stat_wkfl.
* /*F087*/              assign
* /*F087*/              podnbr = pod_nbr
* /*F087*/              podline = pod_line.
* /*H236*/              find ld_det where ld_site = site
* /*H236*/                            and ld_loc = location
* /*H236*/                            and ld_part = pt_part
* /*H236*/                            and ld_lot = lotserial
* /*H236*/                            and ld_ref = lotref
* /*H236*/                          no-lock no-error.
* /*H236*/              if available ld_det then assign
* /*H236*/                 assay     = ld_assay
* /*H236*/                 grade     = ld_grade
* /*H236*/                 expire    = ld_expire
* /*H236*/                 rcpt_stat = ld_status.
* /*F087*/           end.
* /*GN62*/           form
* /*GN62*/              assay
* /*GN62*/              grade
* /*GN62*/              expire
* /*GN62*/              rcpt_stat  space(2)
* /*GN62*/           with frame d1 side-labels overlay row 15 column 36.
* /*F087*/           display assay when assay <> ?
* /*F087*/           grade expire rcpt_stat.
* /*F087*/           set assay grade expire rcpt_stat.
* /*F087*/           if not can-find(is_mstr where is_status = rcpt_stat)
* /*F087*/           and rcpt_stat <> ? then do:
* /*F087*/              {mfmsg.i 362 3} /*status does not exist*/
* /*F087*/              next-prompt rcpt_stat.
* /*F087*/              undo, retry.
* /*F087*/           end.
* /*F087*/           if assay = 0 then assay = ?.
* /*F087*/           if assay = ? and grade = "" and expire = ?
* /*F087*/           and rcpt_stat = ?  then do:
* /*F087*/              delete stat_wkfl.
* /*F087*/              stat_recno = 0.
* /*F087*/           end.
* /*F087*/           else do:
* /*F087*/              stat_recno = recid(stat_wkfl).
* /*F087*/           end.
* /*F087*/        end. /* IF CHG_STAT */
**J040***************REPLACED PRECEEDING LOGIC IN ITS 
ENTIRETY*****************/

                  total_lotserial_qty = pod_qty_chg.
                  trans_um = receipt_um.

/*F0V7*/          /* IF receipt_um = pt_um, THE CONVERSION FACTOR SHOULD BE 
*/
/*F0V7*/          /* 1.  DUE TO TRUNCATION, conv_to_pod_um * pod_um_conv    
*/
/*F0V7*/          /* DOESN'T ALWAYS EQUAL 1, LEADING TO INVENTORY PROBLEMS  
*/

/*G19K* /*F0V7*/  if receipt_um = pt_um   */
/*G19K*/          if available pt_mstr and receipt_um = pt_um
/*F0V7*/          then trans_conv = 1.
/*F0V7*/          else
                     trans_conv = conv_to_pod_um * pod_um_conv.


                  if multi_entry then do:

/*G1Z8*/          /* THIS PATCH INSURES THAT ATLEAST ONE sr_wkfl ENTRY IS
                     PASSED  TO icsrup2.p ( MULTI ENTRY  MODE HANDLER ) EVEN 
IF
                     RECEIVE ALL IS SET TO NO; SO AS TO BRING CONSISTENCY 
WITH
                     RECEIVE ALL SET TO YES.
                  */

/*G1Z8*/     /* CREATE BEGINS */

                  find pt_mstr where pt_part = pod_part no-lock no-error.
                  if not available pt_mstr         or
                        (available pt_mstr         and
                                   pt_lot_ser = "" and
                                   pod_type <> "s") then do:

                     find first sr_wkfl where sr_userid = mfguser
                     and sr_lineid = cline no-lock no-error.
                     if not available sr_wkfl then do:
                              create sr_wkfl.
                              assign
                              sr_userid = mfguser
                              sr_lineid = cline
                              sr_site = site
                              sr_loc = location
                              sr_lotser = lotserial
                              sr_ref = lotref
                              sr_qty = lotserial_qty.
                     end.

                  end.

/*G1Z8*/     /* CREATE ENDS */


/*J07M* DELETE FOLLOWING SECTION
* /*F0NS*/             find first sr_wkfl where sr_userid = mfguser
* /*F0NS*/             and sr_lineid = cline exclusive-lock no-error.
* /*F0NS*/             if lotserial_qty = 0 then do:
* /*F0NS*/                if available sr_wkfl then do:
* /*F0NS*/                   total_lotserial_qty = total_lotserial_qty - 
sr_qty.
* /*F0NS*/                   delete sr_wkfl.
* /*F0NS*/                end.
* /*F0NS*/             end.
* /*F0NS*/             else do:
* /*F0NS*/                if available sr_wkfl then do:
* /*G0RY*     IF MORE THAN ONE SR_WKFL RECORD EXISTS, THEN THE USER HAS      
  */
* /*G0RY*     ALREADY ENTERED MULTI-LINE INFORMATION, DO NOT DESTROY THAT    
  */
* /*G0RY*/                  find sr_wkfl where sr_userid = mfguser and
* /*G0RY*/                    sr_lineid = cline exclusive-lock no-error.
* /*G0RY*/                  if not ambiguous sr_wkfl then
* /*F0NS*/                   assign
* /*F0NS*/                   sr_site = site
* /*F0NS*/                   sr_loc = location
* /*F0NS*/                   sr_lotser = lotserial
* /*F0NS*/                   sr_ref = lotref
* /*F0NS*/                   sr_qty = lotserial_qty.
* /*F0NS*/                end.
*J07M* END DELETE ****/
/*G1R9               REINSTATES CODE ERRONEOUSLY REMOVED BY J07M ABOVE */
/*G1R9*/             find first sr_wkfl where sr_userid = mfguser
/*G1R9*/             and sr_lineid = cline exclusive-lock no-error.
/*G1R9*/             if lotserial_qty = 0 then do:
/*G1R9*/                if available sr_wkfl then do:
/*G1R9*/                   total_lotserial_qty = total_lotserial_qty - 
sr_qty.
/*G1R9*/                   delete sr_wkfl.
/*G1R9*/                end.
/*G1R9*/             end.
/*G1R9*/             else do:
/*G1R9*/                if available sr_wkfl then do:
/*G1R9*                    IF MORE THAN ONE SR_WKFL RECORD EXISTS, THEN THE 
USER
                           ALREADY ENTERED MULTI-LINE INFORMATION, DO NOT
                           DESTROY THAT */
/*G1R9*/                   find sr_wkfl where sr_userid = mfguser and
/*G1R9*/                   sr_lineid = cline exclusive-lock no-error.
/*G1R9*/                   if not ambiguous sr_wkfl then
/*G1R9*/                      assign
/*G1R9*/                         sr_site = site
/*G1R9*/                         sr_loc = location
/*G1R9*/                         sr_lotser = lotserial
/*G1R9*/                         sr_ref = lotref
/*G1R9*/                         sr_qty = lotserial_qty.
/*G1R9*/                end.    /* avail sr_wkfl */
/*G1R9*/             end.

/*G0RY*  DO NOT CREATE ANY DETAIL LINES, THE USER WILL INPUT THIS INFO
* /*F0NS*/               else do:
* /*F0NS*/                   create sr_wkfl.
* /*F0NS*/                   assign
* /*F0NS*/                   sr_userid = mfguser
* /*F0NS*/                   sr_lineid = cline
* /*F0NS*/                   sr_site = site
* /*F0NS*/                   sr_loc = location
* /*F0NS*/                   sr_lotser = lotserial
* /*F0NS*/                   sr_ref = lotref
* /*F0NS*/                   sr_qty = lotserial_qty.
* /*F0NS*/                   if recid(sr_wkfl) = -1 then .
* /*F0NS*/                end.
*G0RY*/
/*J07M*                end. */

                     if i >= 1 then do:
/*G443*                 site = "". */
                        location = "".
/*J041*                 lotserial = "".           */
                        lotref = "".
/*J038*/                vendlot = "".
                     end.

/*J041*/             if lotprcpt = yes then lotnext = lotserial.
/*F190               {gprun.i ""icsrup.p""}              */
/*G443*              {gprun.i ""icsrup.p"" "(rct_site)"} */
/*H093*/             podtype = pod_type.

/*G1R9*/             total_lotserial_qty = 0.
/*G1R9*/             for each sr_wkfl where sr_userid = mfguser and
/*G1R9*/             sr_lineid = cline no-lock:
/*G1R9*/                total_lotserial_qty = total_lotserial_qty + sr_qty.
/*G1R9*/             end.

/*J04D*              {gprun.i ""icsrup2.p"" "(rct_site)"}*/
/*J04D*/             {gprun.i ""icsrup2.p"" "(input rct_site,
                                              input ponbr,
                                              input poline,
                                              input-output lotnext,
                                              input lotprcpt,
                                              input-output vendlot)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*G1SL*/             /* IF MULTI-ENTRY MODE WAS USED TO PROCESS RECEIPTS FOR 
A
                        SINGLE ITEM/LOT/SERIAL LOCATION, IT IS POSSIBLE THAT
                        THEY ARE RETURNING TO THIS PROGRAM HAVING CREATED 
ONLY 1
                        sr_wkfl RECORD.  IF SO, THIS PROGRAM WILL RESET THE
                        VALUE OF THE multi_entry FIELD TO "NO" (F0S0 BELOW). 
IF
                        THE USER HAS RETURNED FROM THE MULTI-ENTRY FRAME BY
                        PRESSING F4 ON AN ERROR CONDITION FOR SINGLE
                        ITEM/LOT/SERIAL, THE PROGRAM IS RETURNING WITH THE
                        VALUES IN sr_wkfl THAT CAUSED THE ERROR MESSAGE 
(BECAUSE
                        THEY ARE DEFINED no-undo).  THESE ERRONEOUS VALUES 
WERE
                        THEN OVERWRITING THE GOOD ONES.  TO PREVENT THIS 
FROM
                        OCCURRING, WE DO A FIND ON THE FIRST sr_wkfl HERE TO
                        RE-ESTABLISH THE CORRECT VALUES FROM sr_wkfl.
                     */
/*G1SL*/             find first sr_wkfl where sr_userid = mfguser
/*G1SL*/             and sr_lineid = cline no-lock no-error.
/*G1SL*/             if available sr_wkfl then
/*G1SL*/                assign
/*G1SL*/                   site = sr_site
/*G1SL*/                   location = sr_loc
/*G1SL*/                   lotserial = sr_lotser
/*G1SL*/                   lotref = sr_ref
/*G1SL*/                   lotserial_qty = sr_qty.
                  end. /* if multi_entry */
/*F0S0*           else do:              */
/*F0S0*/          if multi_entry = yes then do:
/*F0S0*             VERIFY THAT A MULTI_ENTRY WAS ACTUALY PERFORMED    */
/*F0S0*/            i = 0.
/*F0S0*/            multi_entry = no.
/*F0S0*/            for each sr_wkfl no-lock where sr_userid = mfguser
/*F0S0*/            and sr_lineid = cline:
/*F0S0*/               i = i + 1.
/*F0S0*/               if i > 1 then do:
/*F0S0*/                  multi_entry = yes.
/*F0S0*/                  leave.
/*F0S0*/               end.
/*F0S0*/            end.
/*F0S0*/          end. /* multi_entry = yes */
/*F0S0*/          if multi_entry = no then do:
/*J040**********************************************************************
* /*F087*/           if pod_type = "" then do:
* /*F087*/              /*CREATE LD_DET RECORD IF ASSAY, ETC HAS BEEN 
CHANGED*/
* /*F087*/              /*OR THERE IS AN ITEM DEFINED STATUS FOR THIS ITEM   
*/
* /*F087*/              {gprun.i ""poporca1.p""}
* /*F087*/              if msgref <> "" then do:
* /*F087*/                 msgref = trim(msgref).
* /*F087*/                 {mfmsg03.i 1914 3 msgref """" """"}
* /*F087*/                 /* # conflicts with existing inventory detail*/
* /*F087*/                 undo locloop, retry.
* /*F087*/              end.
* /*F087*/           end.
**J040*********************************************************************/

                     /* PERFORM EDITS HERE FOR PURCHASE ORDERS.  RTS
                          EDITS ARE DONE LATER... */

/*FS26*/             /* if pod_type = "" then do:                      */

/*FS26*/             if (pod_type = "" and pod_fsm_type = "") then do:

/*FS78*/                /* Chg icedit.i to icedit.p to reduce compile size. 
*/
/*FS78*/                /*    {icedit.i                                     
*/
/*FS78*/                /*       &transtype=""RCT-PO""                      
*/
/*FS78*/                /*       &site=site                                 
*/
/*FS78*/                /*       &location=location                         
*/
/*FS78*/                /*       &part=global_part                          
*/
/*FS78*/                /*       &lotserial=lotserial                       
*/
/*FS78*/                /*       &lotref=lotref                             
*/
/*FS78*/                /*       &quantity="lotserial_qty * trans_conv"     
*/
/*FS78*/                /*       &um=trans_um                               
*/
/*FS78*/                /*    }                                             
*/
/*FS78*/
/*GO37**  USE transtype NOW      "(input  ""RCT-PO"", **/
/*J04D*/  /* added input ponbr, and input string(poline), below */
/*FS78*/                {gprun.i ""icedit.p""
                                 "(input  transtype,
                                   input  site,
                                   input  location,
                                   input  global_part,
                                   input  lotserial,
                                   input  lotref,
                                   input  lotserial_qty * trans_conv,
                                   input  trans_um,
                                   input ponbr,
                                   input string(poline),
                                   output undotran)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*FS78*/                if undotran then do:
/*J038*                    undo,retry. */
/*J038*/                   undo locloop, retry.
/*FS78*/                end.
/*H093*/             end. /* IF POD_TYPE = "" */

                     /* PERFORM EDITS FOR RTS SHIPMENT/RECEIPTS WITH 
INVENTORY
                        ISSUE/RECEIPT = YES ( -> POD_TYPE = " " INSTEAD OF 
"R") */


                     /* NOTE: FOR RTS RECEIPTS, IT'S JUST LIKE EDITING A PO 
RECEIPT,
                        HOWEVER, AN RTS RETURN IS EDITED AS IF IT'S A 
RECEIPT FOR A
                        NEGATIVE QUANTITY. */

/*J12S*/  /* for RTS Receipts use blank, not ponbr and poline  */
/*J14K* /*J12S*/     if (pod_type = "" and pod_fsm_type = "RTS-RCT") then 
do:   */

/*J14K*/             if (pod_type = "" and pod_fsm_type <> "") then do:
/*J12S*/                if (pt_lot_ser <> "S") then do:
/*J14K*                    Changed qty parm from "lotserial_qty * 
trans_conv" */
/*J12S*/                   {gprun.i ""icedit.p""
                                    "(input  transtype,
                                      input  site,
                                      input  location,
                                      input  global_part,
                                      input  lotserial,
                                      input  lotref,
                                      input  if pod_fsm_type = ""RTS-RCT"" 
then
                                                lotserial_qty * trans_conv
                                             else
                                                lotserial_qty * trans_conv * 
-1,
                                      input  trans_um,
                                      input  """",
                                      input  """",
                                      output undotran)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J12S*/                end.
/*J12S*/                else if pt_lot_ser = "S" then do:
/*J14K*                    Changed qty parm from "lotserial_qty * 
trans_conv" */
/*J12S*/                   {gprun.i ""icedit5.p""
                                    "(input  transtype,
                                      input  site,
                                      input  location,
                                      input  global_part,
                                      input  lotserial,
                                      input  lotref,
                                      input  if pod_fsm_type = ""RTS-RCT"" 
then
                                                lotserial_qty * trans_conv
                                             else
                                                lotserial_qty * trans_conv * 
-1,
                                      input  trans_um,
                                      input  """",
                                      input  """",
                                      output undotran)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J12S*/                end.
/*J12S*/                if undotran then do:
/*J12S*/                   undo locloop, retry.
/*J12S*/                end.
/*J12S*/             end. /* IF POD_TYPE = "" and pod_fsm_type <> "" */

                     /* PERFORM OTHER RTS EDITS - THESE ARE THE RTS 
SHIPMENTS
                        AND RECEIPTS WHERE INVENTORY ISSUE/RECEIPT = NO,
                        I.E., INSTEAD OF 'RECEIVING' PARTS, THEY ARE ABOUT
                        TO BE TRANSFERRED BETWEEN A SUPPLIER SITE/LOCATION 
AND
                        AN INTERNAL WAREHOUSE SITE/LOCAION. */

/*FS26*/             else if pod_fsm_type <> "" then do:
/*FS26*/
/*J14K*/                {gprun.i ""fsrtved.p""
                                "(input pod_nbr,
                                  input pod_line,
                                  input pod_rma_type,
                                  input site,
                                  input location,
                                  input lotserial,
                                  input lotref,
                                  input lotserial_qty,
                                  input trans_conv,
                                  input trans_um,
                                  output undotran,
                                  output msgnbr,
                                  output errsite,
                                  output errloc
                                  )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J14K*/                if undotran then do:
/*J14K*/                      {mfmsg03.i msgnbr 1 errsite errloc """"}
/*J14K*/                      undo locloop,retry.
/*J14K*/                end.

/*J14K*
./*FS26*/                find rmd_det where rmd_nbr = pod_nbr
./*FS26*/                            and rmd_prefix = "V"
./*FS26*/                            and rmd_line   = pod_line
./*FS26*/                 no-lock no-error.
./*FS26*/
./*FS26*/                /* Set up RTS Issues */
./*FS26*/                if pod_rma_type = "O" then
./*FS26*/                   assign
./*FS78*/                      /* Use user input site and location. */
./*FS78*/                      /* fromsite  = pod_site              */
./*FS78*/                      /* fromloc   = pod_loc               */
./*FS78*/                      fromsite  = site
./*FS78*/                      fromloc   = location
./*FS26*/                      tosite    = rmd_site
./*FS26*/                      toloc     = rmd_loc.
./*FS26*/
./*FS26*/                /* Set up RTS Receipts */
./*FS26*/                if pod_rma_type = "I" then
./*FS26*/                   assign
./*FS26*/                      fromsite = rmd_site
./*FS26*/                      fromloc  = rmd_loc
./*FS78*/                      /* Use user input site and location. */
./*FS78*/                      /* tosite   = pod_site               */
./*FS78*/                      /* toloc    = pod_loc.               */
./*FS78*/                      tosite   = site
./*FS78*/                      toloc    = location.
./*FS26*/
./*FS26*/                /* RTS's receipts that have been previously  */
./*FS26*/                /* issued from inventory do not need to test */
./*FS26*/                /* the from site.                            */
./*FS26*/                if fromsite <> "" then do:
./*F0TC*/                   /* input 0,  was  input lotserial_qty * 
trans_conv,*/
./*J12S*/                   /* Change 0 back to input lotserial_qty * 
trans_conv,*/
./*J04C*/  /* added input ponbr, and input string(poline), below */
./*J12S*/  /* Change input ponbr, and input string(poline) to Blank */
./*FS26*/                   {gprun.i ""icedit.p""
.                                    "(input  ""ISS-TR"",
.                                      input  fromsite,
.                                      input  fromloc,
.                                      input  global_part,
.                                      input  lotserial,
.                                      input  lotref,
.                                      input  lotserial_qty * trans_conv,
.                                      input  trans_um,
.                                      input  """",
.                                      input  """",
.                                      output  undotran)"}
./*FS26*/                   if undotran then do:
./*FS78*/                      {mfmsg03.i 7361 1 fromsite fromloc """"}
./*FS26*/                      undo,retry.
./*FS26*/                   end.
./*FS26*/                end.  /*fromsite <> ""*/
./*FS26*/
./*FS26*/                /* RTS issues from inventory do not need to */
./*FS26*/                /* test the tosite.                         */
./*FS26*/                if tosite <> "" then do:
./*J0WR*                    Added ponbr, string(poline) parms */
./*FS26*/                   {gprun.i ""icedit.p""
.                                    "(input  ""RCT-TR"",
.                                      input  tosite,
.                                      input  toloc,
.                                      input  global_part,
.                                      input  lotserial,
.                                      input  lotref,
.                                      input  lotserial_qty * trans_conv,
.                                      input  trans_um,
.                                      input  """",
.                                      input  """",
.                                      output undotran)"}
./*FS26*/                   if undotran then do:
./*FS78*/                      {mfmsg03.i 7362 1 tosite toloc """"}
./*FS26*/                      undo,retry.
./*FS26*/                   end.
./*FS26*/                end. /* if tosite <> "" */
.*J14K*/
/*FS26*/             end.   /* pod_fsm_type <> ""*/

/*F190*/             if pod_site <> site
/*F087*/             and pod_type = ""
/*F190*/             then do:
/*FP45*/                /*DOES STATUS ALLOW RECEIPT AT POD SITE*/
/*GO37** USE transtype NOW       "(input  ""RCT-PO"", **/

/*F0TC* BEGIN COMMENT OUT *
*
* /*FP45*/                {gprun.i ""icedit3.p"" "(input transtype,
*                                               input rct_site,
*                                               input location,
*                                               input global_part,
*                                               input lotserial,
*                                               input lotref,
*                                               input 0,
*                                               input trans_um,
*                                               output yn)"
*                      }
* /*FP45*/                if yn then undo locloop, retry.
*
*                      /*DOES STATUS ALLOW TRANSFER OUT OF  RECEIPT SITE*/
* /*FP45*/                {gprun.i ""icedit3.p"" "(input ""ISS-TR"",
*                                               input rct_site,
*                                               input location,
*                                               input global_part,
*                                               input lotserial,
*                                               input lotref,
*                                               input 0,
*                                               input trans_um,
*                                               output yn)"
*                      }
* /*F190*/                if yn then undo locloop, retry.
*
*                      /*DOES STATUS ALLOW TRANSFER INTO RECEIPT SITE*/
* /*F190*/                {gprun.i ""icedit3.p"" "(input ""RCT-TR"",
*                                               input site,
*                                               input location,
*                                               input global_part,
*                                               input lotserial,
*                                               input lotref,
*                                               input lotserial_qty
*                                                     * trans_conv,
*                                               input trans_um,
*                                               output yn)"
*                      }
*F0TC* END COMMENT OUT */

/*J038*/ /* Added input ponbr, and input string(poline), input trans_um, 
below*/
/*J1DH*/ /* MOVE trans_um AFTER lotserial_qty */
/*F0TC*/                      {gprun.i ""icedit4.p"" "(input transtype,
                                                       input rct_site,
                                                       input site,
                                                       input pt_loc,
                                                       input location,
                                                       input global_part,
                                                       input lotserial,
                                                       input lotref,
                                                       input lotserial_qty *
                                                         trans_conv,
                                                       input trans_um,
                                                       input ponbr,
                                                       input string(poline),
                                                       output yn)"
                              }
/*GUI*/ if global-beam-me-up then undo, leave.


/*F190*/                if yn then undo locloop, retry.
/*F190*/             end. /* IF POD_SITE <> SITE AND POD_TYPE = "" */

                     find first sr_wkfl where sr_userid = mfguser
/*GM16*              and sr_lineid = cline no-error. */
/*GM16*/             and sr_lineid = cline exclusive-lock no-error.
                     if lotserial_qty = 0 then do:
                        if available sr_wkfl then do:
                           total_lotserial_qty = total_lotserial_qty - 
sr_qty.
                           delete sr_wkfl.
                        end.
                     end.
                     else do:
                        if available sr_wkfl then do:
                           assign
                           total_lotserial_qty = total_lotserial_qty - 
sr_qty
                              + lotserial_qty
                           sr_site = site
                           sr_loc = location
                           sr_lotser = lotserial
                           sr_ref = lotref
/*J038*/                   sr_vend_lot = vendlot
                           sr_qty = lotserial_qty.
                        end.
                        else do:
                           create sr_wkfl.
                           assign
                           sr_userid = mfguser
                           sr_lineid = cline
                           sr_site = site
                           sr_loc = location
                           sr_lotser = lotserial
                           sr_ref = lotref
/*J038*/                   sr_vend_lot = vendlot
                           sr_qty = lotserial_qty.
                           total_lotserial_qty = total_lotserial_qty
                              + lotserial_qty.
/*GO37** /*GM16*/          recno = recid(sr_wkfl). **/
/*GO37*/                   if recid(sr_wkfl) = -1 then .
                        end.
                     end. /* lotserial_qty <> 0 */

/*G1SL*/             if porec or is-return then do:
                        /* CHECK FOR SINGLE ITEM / SINGLE LOT/SERIAL 
LOCATION */
/*G1SL*/                find loc_mstr where loc_site = site
/*G1SL*/                and loc_loc = location no-lock no-error.

/*G1SL*/             if available loc_mstr and loc_single = yes then do:
/*G1SL*/                {gploc02.i pod_det pod_nbr pod_line pod_part}

/*G1SL*/                if error_flag = 0 and loc__qad01 = yes then do:
                           /* CHECK PRIOR RECEIPT TRANSACTIONS (ld_det's) 
FOR
                              DIFFERENT ITEMS OR LOT/SERIALS IN SAME 
LOCATION */
/*G1SL*/                   {gprun.i ""gploc01.p""
                                    "(site,
                                      location,
                                      pod_part,
                                      lotserial,
                                      lotref,
                                      loc__qad01,
                                      output error_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*G1SL*/                      if error_flag <> 0
                              /* ADJUSTING QTY ON A PREVIOUS VIOLATION 
(CREATED
                                 BEFORE THIS PATCH) OF SINGLE 
ITEM/LOT/SERIAL
                                 LOCATION ALLOWED; CREATING ANOTHER 
VIOLATION
                                 DISALLOWED.
                              */
/*G1SL*/                      and can-find(ld_det where ld_site = site
/*G1SL*/                      and ld_loc = location and ld_part = pod_part
/*G1SL*/                      and ld_lot = lotserial and ld_ref = lotref) 
then
/*G1SL*/                         error_flag = 0.
/*G1SL*/                   end. /* error_flag = 0 and loc__qad01 = yes */

/*G1SL*/                   if error_flag <> 0 then do:
/*G1SL*/                      {mfmsg.i 596 3}
/*G1SL*/                      /*TRANSACTION CONFLICTS WITH SINGLE ITEM/LOT 
LOC*/
/*G1SL*/                      undo locloop, retry.
/*G1SL*/                   end.
/*G1SL*/                end. /* avail loc_mstr and loc_single = yes */
/*G1SL*/             end. /* porec or is-return */

/*H020 ADDED FOLLOWING CODE */
                     /* IF SITE CHANGED ALLOW USER TO CHANGE TAX ENVIRONMENT 
*/
                     if site <> pod_site and {txnew.i} and pod_taxable then 
do:
                        undo-taxes = true.
                        {gprun.i ""poporctx.p"" "(input recid(po_mstr),
                                                  input site,
                                                  input pod_site,
                                                  input pod_taxable,
                                                  input pod_taxc,
                                                  input-output 
pod_tax_usage,
                                                  input-output pod_tax_env,
                                                  input-output pod_tax_in,
                                                  input-output undo-taxes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                        if undo-taxes then undo locloop, retry.
                     end.
/*H020 END NEW CODE */
                  end. /* else if not multi_entry */

                  /* CHECK FOR ANY CONFLICTING INVENTORY PRIOR TO UPDATE */
/*G1SL
* /*FP66*/       {gprun.i ""polocrc.p"" "(input pod_recno,
* /*FP66*/                                output error_flag)"}.
* /*FP66*/       if error_flag then do:
* /*FP66*/          {mfmsg.i 245 3}
*                   /* SINGLE ITEM LOCATION HAS EXISTING INVENTORY */
* /*FP66*/          undo locloop, retry.
* /*FP66*/       end.
*G1SL*/

/*J040*/          /*SET AND UPDATE INVENTORY DETAIL ATTRIBUTES*/
/*J040*/          find first attr_wkfl where
/*J040*/             chg_line = string(pod_line) no-error.
/*J040*/          if available attr_wkfl and pod_type = "" then do:
/*J040*/             {gprun.i ""porcat02.p"" "(input  recid(pod_det),
                                               input  chg_attr,
                                               input-output chg_assay,
                                               input-output chg_grade,
                                               input-output chg_expire,
                                               input-output chg_status,
                                               input-output assay_actv,
                                               input-output grade_actv,
                                               input-output expire_actv,
                                               input-output status_actv)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J040*/             /*TEST FOR ATTRIBUTE CONFLICTS*/
/*J040*/             for each sr_wkfl where sr_userid = mfguser
/*J040*/             and sr_lineid = cline no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


/*G1SL                  CHANGED OUTPUT PARAMETER FROM error_flag TO err_flag 
*/
/*J040*/                {gprun.i ""porcat01.p"" "(input recid(pod_det),
                                                  input sr_site,
                                                  input sr_loc,
                                                  input sr_ref,
                                                  input sr_lotser,
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


/*G1SL /*J040*/         if error_flag then do with frame a: */
/*G1SL*/                if err_flag then do with frame a:
/*J040*/                   srlot = sr_lotser.
/*J040*/                   if sr_ref <> "" then srlot = srlot + "/" + 
sr_ref.
/*J040*/                   /*ATTRIBUTES DO NOT MATCH LD_DET*/
/*J040*/                   {mfmsg02.i 2742 4 srlot}
/*J040*/                   next-prompt site.
/*J040*/                   undo locloop, retry.
/*J040*/                end.
/*J040*/             end.
/*GUI*/ if global-beam-me-up then undo, leave.
/* for each sr_wkfl..*/
/*J040*/          end. /* if avail attr_wkfl..*/
               end.
/*GUI*/ if global-beam-me-up then undo, leave.
/* locloop: do on error..*/

               pod_qty_chg = total_lotserial_qty.

               /*GO37 CHECK OPERATION QUEUE QTYS*/
               {gprun.i ""poporca6.p"" "(input ""receipt"",
                                         input pod_nbr,
                                         input wolot,
                                         input woop,
                                         input move)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*G2M4*/       if use_pod_um_conv then
/*G2M4*/          total_received = pod_qty_rcvd
/*G2M4*/                + (total_lotserial_qty / pod_um_conv).
/*G2M4*/       else
               total_received = pod_qty_rcvd
                  + (total_lotserial_qty * conv_to_pod_um).

/*FS26*/       /* If it's an RTS shipment(issue) all pod_det qty fields are 
*/
/*FS26*/       /* expressed in negative numbers.  For correct calculations  
*/
/*FS26*/       /* of pod_bo_chg and ultimately tr_hist back order qty,      
*/
/*FS26*/       /* switch the sign of total_received.                        
*/
/*FS26*/       if pod_rma_type = "O" then
/*FS26*/          total_received = total_received * -1.

               if cancel_bo then pod_bo_chg = 0.
               else pod_bo_chg = pod_qty_ord - total_received.

               if cancel_bo then pod_bo_chg = 0.
               else
/*G873*/       if not pod_sched then
                  pod_bo_chg = pod_qty_ord - total_received.
/*G873*/       else do:
/*G873*/          {gprun.i ""rsoqty.p"" "(input recid(pod_det),
                                          input eff_date,
                                          output qopen)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  pod_bo_chg =
                        max(0,qopen - total_lotserial_qty * conv_to_pod_um).
/*G873*/       end.

               assign
/*F070*/       pod_rum_conv = conv_to_pod_um
               pod_rum = receipt_um
               pod_ps_chg = packing_qty.

/*GB35*/       /* Only update blanket order if user requests update */
/*GB35*/       updt_blnkt = no.

/*G0TP* * * UPDT_BLNKT_LIST IS A COMMA SEPARATED LIST OF ALL POD_LINE       
*
*          NUMBERS WHICH MUST HAVE THE BLANK PO RELEASE QUANTITY UPDATED   *
*                                                                          *
*       IF THE USER IS MODIFYING THE RECORD, IT IS POSSIBLE THAT           *
*       OF UPDT_BLNK_LIST HAS BEEN PRVIOUSLY UPDATED TO SHOW UPDT_BLNK =   *
*       YES, IF SO, REMOVE ANY PREVIOUSLY FLAG SETTINGS BECUASE THE USER   *
*       WILL BE PROMPTED AGAIN.                                            *
*          W-INT1 = THE POSITION THE LINE NUMBER NEEDING REMOVAL STARTS ON *
*          W-INT2 = THE POSITION THE COMMA AFTER THE LINE NUMBER IS ON     *
*G0TP*/

/*G0TP*/       if can-do(updt_blnkt_list,string(pod_line))
/*G0TP*/       then do:
/*G0TP*/          assign
/*G0TP*/             w-int1 = index(updt_blnkt_list,
/*G0TP*/                      string(pod_line))
/*G0TP*/             w-int2 = (index(substring(updt_blnkt_list,w-int1),
/*G0TP*/                      ",")) + w-int1 - 1
/*G0TP*/             updt_blnkt_list =
/*G0TP*/                      substring(updt_blnkt_list,1,w-int1 - 1) +
/*G0TP*/                      substring(updt_blnkt_list,w-int2 + 1).
/*G0TP*/       end. /* remove from list */

/*H093*/       /* OVER-RECEIPT TOLERANCE CHECKS */
               if pod_sched or (not pod_sched and
               (total_received > pod_qty_ord and pod_qty_ord > 0) or
               (total_received < pod_qty_ord and pod_qty_ord < 0)) then do:
                  pod_recno = recid(pod_det).
                  {gprun.i ""poporca4.p"" "(output yn)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  if yn then undo lineloop, retry lineloop.
               end.

/*G718*/       /* ADD COMMENTS, IF DESIRED */
/*G718*/       if cmmt_yn then do:
/*G718*/          hide frame c no-pause.
/*FS54*/          hide frame cship no-pause.
/*G718*/          hide frame d no-pause.
/*G718*/          cmtindx = pod_cmtindx.
/*G718*/          global_ref = "收货: " + pod_nbr + "/" + string(pod_line).
/*G718*/          {gprun.i ""gpcmmt01.p"" "(input ""pod_det"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G718*/          pod_cmtindx = cmtindx.
/*G718*/       end.
/*J041*/       end.
/*GUI*/ if global-beam-me-up then undo, leave.
/* DO TRANSACTION */
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
/* lineloop: repeat: */

/*FP73*/    if not batchrun then do:
               do on endkey undo edit-loop, leave edit-loop:
                  yn = yes.
/*GO37*/          if porec then
/*GO37*/             msgnbr  = 340.
/*GO37*/          else
/*GO37*/             msgnbr  = 636.

/*GO37*           {mfmsg01.i 340 1 yn} */
/*GO37*/          {mfmsg01.i msgnbr 1 yn}
                  /* Display purchase order lines being received ? */
                  if yn then do:
                     hide frame c.
/*FS54*/             hide frame cship.
                     hide frame d.
                     for each pod_det no-lock
                     where pod_nbr = po_nbr and pod_status <> "c" and
                     pod_status <> "x" and pod_qty_chg <> 0
                     use-index pod_nbrln,
                     each sr_wkfl no-lock where sr_userid = mfguser
                     and sr_lineid = string(pod_line) with width 80:
/*J038****************  display pod_line pod_part sr_site sr_loc sr_lotser 
*/
/*J038****************  column-label "Lot/Serial!Ref"                      
*/
/*J038****************  sr_qty pod_rum.                                    
*/

/*J038*/                display
/*J038*/                   pod_line
/*J038*/                   pod_part
/*J038*/                   sr_site
/*J038*/                   sr_loc column-label "    库位!参考"
/*J038*/                   sr_lotser column-label "批/序号!供应商批号"
/*J04D*/                             format "x(22)"
/*H0SN** /*J038*/          sr_qty.                                         
*/
/*H0SN*/                   sr_qty with frame e.
/*J04D*******************  pod_rum. ******/

/*J038*                 if sr_ref <> "" then do:                           
*/
/*J038*/                if sr_ref <> "" or sr_vend_lot <> "" then do:

/*H0SN**                   down 1.                                         
*/
/*J038*                    disp sr_ref @ sr_lotser.                        
*/


/*H0SN*/                   down 1 with frame e.
/*J038*/                   display
/*J038*/                      sr_ref @ sr_loc
/*H0SN** /*J038*/             sr_vend_lot @ sr_lotser.                     
*/
/*H0SN*/                      sr_vend_lot @ sr_lotser with frame e.
                        end.

/*H0SN*/                down 1 with frame e.
                     end. /* for each pod_det..*/
                  end. /* if yn */
               end. /* do on endkey..*/

               do on endkey undo edit-loop, leave edit-loop:
                  proceed = no.
                  yn = yes.
/*GN62*/ /*V8+*/       {mfgmsg10.i 12 1 yn} /*Is all info correct */
                       if yn = ? then
                         undo edit-loop, leave edit-loop.
                  if yn then do:
                     proceed = yes.
                     leave.
                  end.
               end. /* do on endkey..*/
/*FP73*/    end. /* if not batchrun */
/*FP73*/    else do:
/*FP73*/       proceed = yes.
/*FP73*/       leave.
/*FP73*/    end.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
/* edit-loop */

/*GO37*/ hide frame c no-pause.
/*GO37*/ hide frame cship no-pause.
/*GO37*/ hide frame d no-pause.


