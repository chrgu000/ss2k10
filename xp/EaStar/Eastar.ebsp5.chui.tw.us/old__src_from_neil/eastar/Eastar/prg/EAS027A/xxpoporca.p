/* poporca.p - PURCHASE ORDER RECEIPT W/ SERIAL NUMBER CONTROL                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.49.1.8 $                                            */
/*                                                                            */
/*                                                                            */
/* REVISION: 7.0     LAST MODIFIED: 11/19/91    BY: pma *F003*                */
/* REVISION: 7.0     LAST MODIFIED: 12/09/91    BY: RAM *F070*                */
/* REVISION: 7.0     LAST MODIFIED: 01/31/92    BY: RAM *F126*                */
/* REVISION: 7.0     LAST MODIFIED: 02/12/92    BY: pma *F190*                */
/* REVISION: 7.0     LAST MODIFIED: 03/03/92    BY: pma *F085*                */
/* REVISION: 7.0     LAST MODIFIED: 03/09/92    BY: RAM *F269*                */
/* REVISION: 7.0     LAST MODIFIED: 03/11/92    BY: pma *F087*                */
/* REVISION: 7.0     LAST MODIFIED: 03/24/92    BY: RAM *F311*                */
/* REVISION: 7.3     LAST MODIFIED: 10/24/92    BY: sas *G240*                */
/* REVISION: 7.3     LAST MODIFIED: 09/27/92    BY: jcd *G247*                */
/* REVISION: 7.3     LAST MODIFIED: 11/10/92    BY: pma *G304*                */
/* REVISION: 7.3     LAST MODIFIED: 12/14/92    BY: tjs *G443*                */
/* REVISION: 7.3     LAST MODIFIED: 01/11/93    BY: bcm *G425*                */
/* REVISION: 7.3     LAST MODIFIED: 01/18/93    BY: WUG *G563*                */
/* REVISION: 7.3     LAST MODIFIED: 02/22/93    BY: tjs *G718*                */
/* REVISION: 7.3     LAST MODIFIED: 04/09/93    BY: WUG *G873*                */
/* REVISION: 7.3     LAST MODIFIED: 04/19/93    BY: tjs *G964*                */
/* REVISION: 7.2     LAST MODIFIED: 05/13/93    BY: kgs *GA90*                */
/* REVISION: 7.2     LAST MODIFIED: 05/26/93    BY: kgs *GB35*                */
/* REVISION: 7.3     LAST MODIFIED: 06/17/93    BY: WUG *GC41*                */
/* REVISION: 7.3     LAST MODIFIED: 06/21/93    BY: WUG *GC57*                */
/* REVISION: 7.3     LAST MODIFIED: 06/30/93    BY: dpm *GC87*                */
/* REVISION: 7.4     LAST MODIFIED: 07/02/93    BY: jjs *H020*                */
/* REVISION: 7.4     LAST MODIFIED: 07/26/93    BY: WUG *H038*                */
/* REVISION: 7.4     LAST MODIFIED: 09/15/93    BY: tjs *H093*                */
/* REVISION: 7.3     LAST MODIFIED: 11/19/93    BY: afs *H236*                */
/* REVISION: 7.3     LAST MODIFIED: 04/19/94    BY: dpm *GJ42*                */
/* REVISION: 7.3     LAST MODIFIED: 07/19/94    BY: dpm *FP45*                */
/* REVISION: 7.3     LAST MODIFIED: 07/28/94    BY: dpm *FP66*                */
/* REVISION: 7.3     LAST MODIFIED: 08/02/94    BY: rmh *FP73*                */
/* REVISION: 7.3     LAST MODIFIED: 09/11/94    BY: rmh *GM16*                */
/* REVISION: 7.3     LAST MODIFIED: 09/20/94    BY: ljm *GM74*                */
/* REVISION: 7.3     LAST MODIFIED: 10/11/94    BY: cdt *FS26*                */
/* REVISION: 7.3     LAST MODIFIED: 10/18/94    BY: cdt *FS54*                */
/* REVISION: 8.5     LAST MODIFIED: 10/24/94    BY: pma *J040*                */
/* REVISION: 7.3     LAST MODIFIED: 10/25/94    BY: cdt *FS78*                */
/* REVISION: 8.5     LAST MODIFIED: 10/27/94    BY: taf *J038*                */
/* REVISION: 7.3     LAST MODIFIED: 10/27/94    BY: ljm *GN62*                */
/* REVISION: 7.3     LAST MODIFIED: 11/10/94    BY: bcm *GO37*                */
/* REVISION: 8.5     LAST MODIFIED: 11/22/94    BY: mwd *J034*                */
/* REVISION: 8.5     LAST MODIFIED: 12/14/94    BY: ktn *J041*                */
/* REVISION: 8.5     LAST MODIFIED: 12/20/94    BY: tjs *J014*                */
/* REVISION: 7.4     LAST MODIFIED: 12/28/94    BY: srk *G0B2*                */
/* REVISION: 7.3     LAST MODIFIED: 03/15/95    BY: pcd *G0HJ*                */
/* REVISION: 7.4     LAST MODIFIED: 03/22/95    BY: dxk *F0NS*                */
/* REVISION: 7.4     LAST MODIFIED: 05/22/95    BY: jym *F0S0*                */
/* REVISION: 8.5     LAST MODIFIED: 06/07/95    BY: sxb *J04D*                */
/* REVISION: 8.5     LAST MODIFIED: 07/31/95    BY: kxn *J069*                */
/* REVISION: 8.5     LAST MODIFIED: 09/26/95    BY: kxn *J07M*                */
/* REVISION: 8.5     LAST MODIFIED: 10/07/95    BY: kxn *J08J*                */
/* REVISION: 7.4     LAST MODIFIED: 07/11/95    BY: jym *G0RY*                */
/* REVISION: 7.4     LAST MODIFIED: 08/07/95    BY: jym *G0TP*                */
/* REVISION  7.4     LAST MODIFIED: 08/15/95    BY: rvw *G0V0*                */
/* REVISION  7.4     LAST MODIFIED: 09/12/95    BY: ais *F0V7*                */
/* REVISION  7.4     LAST MODIFIED: 10/23/95    BY: ais *G19K*                */
/* REVISION  7.4     LAST MODIFIED: 10/31/95    BY: jym *F0TC*                */
/* REVISION: 8.5     LAST MODIFIED: 11/07/95    BY: kxn *J091*                */
/* REVISION: 8.5     LAST MODIFIED: 03/11/96    BY: jpm *J0F5*                */
/* REVISION: 8.5     LAST MODIFIED: 03/28/96    BY: rxm *G1R9*                */
/* REVISION: 8.5     LAST MODIFIED: 05/01/96    BY: *J04C* Sue Poland         */
/* REVISION: 8.5     LAST MODIFIED: 05/14/96    BY: *G1SL* Robin McCarthy     */
/* REVISION: 8.5     LAST MODIFIED: 06/28/96    BY: *J0WR* Sue Poland         */
/* REVISION: 8.5     LAST MODIFIED: 07/03/96    BY: *G1Z8* Ajit Deodhar       */
/* REVISION: 8.5     LAST MODIFIED: 07/29/96    BY: *J12S* Kieu Nguyen        */
/* REVISION: 8.5     LAST MODIFIED: 09/03/96    BY: *J14K* Sue Poland         */
/* REVISION: 8.5     LAST MODIFIED: 01/05/97    BY: *J1DH* Julie Milligan     */
/* REVISION  8.5     LAST MODIFIED: 02/27/97    BY: *H0SN* Suresh Nayak       */
/* REVISION: 8.5     LAST MODIFIED: 04/30/97    BY: *J1QB* Sanjay Patil       */
/* REVISION: 8.5     LAST MODIFIED: 05/13/97    BY: *G2M4* Ajit Deodhar       */
/* REVISION: 8.5     LAST MODIFIED: 10/15/97    BY: *J22T* Niranjan Ranka     */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED: 04/01/98    BY: *J2HH* A. Licha           */
/* REVISION: 8.6E    LAST MODIFIED: 06/26/98    BY: *J2MG* Samir Bavkar       */
/* REVISION: 8.6E    LAST MODIFIED: 06/30/98    BY: *J2P2* Niranjan R.        */
/* REVISION: 8.6E    LAST MODIFIED: 07/29/98    BY: *J2QC* Niranjan R.        */
/* REVISION: 8.6E    LAST MODIFIED: 08/20/98    BY: *J2WJ* Ajit Deodhar       */
/* REVISION: 9.0     LAST MODIFIED: 01/19/99    BY: *J38P* Surekha Joshi      */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0     LAST MODIFIED: 04/16/99    BY: *J2DG* Reetu Kapoor       */
/* REVISION: 9.0     LAST MODIFIED: 05/15/99    BY: *J39K* Sanjeev Assudani   */
/* REVISION: 9.1     LAST MODIFIED: 10/25/99    BY: *N002* Bill Gates         */
/* REVISION: 9.1     LAST MODIFIED: 03/06/00    BY: *N05Q* Thelma Stronge     */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 03/28/00    BY: *N090* David Morris       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* REVISION: 9.1     LAST MODIFIED: 07/28/00    BY: *M0PQ* Falguni Dalal      */
/* REVISION: 9.1     LAST MODIFIED: 05/21/00    BY: Strip/Beautify:  3.0      */
/* REVISION: 9.1     LAST MODIFIED: 06/27/00    BY: *N0DM* Mudit Mehta        */
/* REVISION: 9.1     LAST MODIFIED: 07/14/00    BY: *N0DV* Inna Lyubarsky     */
/* REVISION: 9.1     LAST MODIFIED: 06/15/00    BY: Zheng Huang      *N0DK*   */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KQ* myb                */
/* Revision: 1.48    BY: Markus Barone          DATE: 09/01/00 ECO: *N0R3*    */
/* REVISION: 9.1     LAST MODIFIED: 09/08/00    BY: *M0RJ* Kaustubh K.        */
/* Revision: 1.49    BY: Reetu Kapoor           DATE: 11/28/00 ECO: *M0X2*    */
/* REVISION: 9.1     LAST MODIFIED: 09/30/00    BY: *N0WT* Mudit Mehta        */
/* REVISION: 1.49.1.1 BY: Hareesh V.          DATE: 08/16/01   ECO: *M1GR*    */
/* Revision: 1.49.1.2 BY: Rajiv Ramaiah       DATE: 09/17/01   ECO: *N12L*    */
/* Revision: 1.49.1.6 BY: Manjusha Inglay     DATE: 01/03/02   ECO: *N178* */
/* Revision: 1.49.1.7 BY: Vivek Dsilva        DATE: 02/21/02   ECO: *N19R* */
/* $Revision: 1.49.1.8 $   BY: Reetu Kapoor           DATE: 03/25/02 ECO: *N1FC*    */
/* REVISION: eB(SP5)     LAST MODIFIED: 05/27/03    BY: Kaine      *EAS027A*   */
/*V8:ConvertMode=Maintenance                                                  */

/* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO */
/* WHEREVER MISSING AND REPLACED FIND STATEMENTS WITH FOR FIRST  */
/* STATEMENTS FOR ORACLE PERFORMANCE.                            */

/*!
   poporca.p - ITEM ENTRY FOR PO RECEIPTS
*/

/*!
   CHANGES MADE IN THIS PROGRAM MAY ALSO HAVE TO BE MADE TO PORVISA.P
*/

{mfdeclre.i}
/*N0WT*/ {cxcustom.i "POPORCA.P"}
/* SEVERITY PREPROCESSOR CONSTANT DEFINITION INCLUDE FILE */
{pxmaint.i}
{gplabel.i &ClearReg=yes} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */



&SCOPED-DEFINE poporca_p_2 "Qty Open"
/* MaxLen: Comment: */


&SCOPED-DEFINE poporca_p_4 "Ship Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporca_p_5 "WO Op"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporca_p_6 "Packing Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporca_p_7 "Loc"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporca_p_8 "Order"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporca_p_9 "Multi Entry"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporca_p_10 "Lot/Serial!Supplier Lot"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporca_p_11 "Lot/Ser"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporca_p_12 "Location!Ref"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporca_p_13 "ID"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporca_p_14 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporca_p_15 "Cmmts"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporca_p_16 "Cancel B/O"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporca_p_17 "Chg Attribute"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporca_p_18 "Supplier Lot"
/*MaxLen: 12 Comment: Preprocessor defined for side label "Supplier Lot" */

/* ********** End Translatable Strings Definitions ********* */

/*MAIN-BEGIN*/

{porcdef.i}

/* VARIABLE DEFINITION FOR GL CALENDAR VALIDATION */
{gpglefdf.i}

/*@MODULE PRM BEGIN*/
/* SHARED TEMP-TABLES FOR PRM */
{pjportt.i}
/*@MODULE PRM END*/

/* REORGANIZED VARIABLES */

/* NEW SHARED VARIABLES, BUFFERS AND FRAMES */
define new shared variable conv_to_pod_um      like pod_um_conv.
define new shared variable line                like pod_line   format ">>>".
define new shared variable lotserial_qty       like sr_qty            no-undo.
define new shared variable podtype             like pod_type.
define new shared variable rct_site            like pod_site.
define new shared variable total_lotserial_qty like pod_qty_chg.
define new shared variable total_received      like pod_qty_rcvd.
define new shared variable trans_um            like pt_um.
define new shared variable trans_conv          like sod_um_conv.
define new shared variable undo_all            like mfc_logical.
define new shared variable cline               as   character.
define new shared variable issue_or_receipt    as   character.
define new shared variable lotserial_control   as   character.
define new shared variable multi_entry like mfc_logical
                                               no-undo
                                               label {&poporca_p_9}.

/* SHARED VARIABLES, BUFFERS AND FRAMES */
define shared variable h_wiplottrace_procs as   handle                no-undo.
define shared variable h_wiplottrace_funcs as   handle                no-undo.
define shared variable qopen               like pod_qty_rcvd
                                           label {&poporca_p_2}.
define shared variable vendlot             like tr_vend_lot           no-undo.
define shared variable fill-all            like mfc_logical           no-undo.
define shared variable prm-avail           like mfc_logical           no-undo.
define shared frame b.

/* LOCAL VARIABLES, BUFFERS AND FRAMES */
define variable lotserials_req like mfc_logical                       no-undo.
define variable leave_loop     like mfc_logical initial no            no-undo.
define variable cancel_bo      like mfc_logical                       no-undo.
define variable chg_attr       like mfc_logical label {&poporca_p_17} no-undo.
define variable cmmt_yn        like mfc_logical label {&poporca_p_14} no-undo.
define variable cont           like mfc_logical initial yes           no-undo .
define variable del-yn         like mfc_logical initial no            no-undo .
define variable due            like pod_due                           no-undo .
define variable err_flag       like mfc_logical                       no-undo.
define variable ln_stat        like mfc_logical                       no-undo .
define variable packing_qty    like pod_ps_chg                        no-undo.
define variable qty_left       like tr_qty_chg                        no-undo.
define variable receipt_um     like pod_rum                           no-undo.
define variable reset_um       like mfc_logical initial no            no-undo.
define variable serial_control like mfc_logical initial no            no-undo.
define variable shipqtychg     like pod_qty_chg
                               column-label {&poporca_p_4}            no-undo.
define variable undo-taxes     like mfc_logical                       no-undo.
define variable undotran       like mfc_logical                       no-undo.
define variable yn             like mfc_logical                       no-undo.
define variable ponbr          like pod_nbr                           no-undo.
define variable poline         like pod_line                          no-undo.
define variable lotnext        like pod_lot_next                      no-undo.
define variable lotprcpt       like pod_lot_rcpt                      no-undo.
define variable newlot         like pod_lot_next                      no-undo.
define variable trans-ok       like mfc_logical                       no-undo.
define variable srlot          like sr_lotser                         no-undo.
define variable almr           like alm_pgm                           no-undo.
define variable errsite        like pod_site                          no-undo.
define variable errloc         like pod_loc                           no-undo.
define variable l_getlot       like mfc_logical                       no-undo.
define variable cancel-prm     like mfc_logical                       no-undo.
define variable need-to-validate-defaults like mfc_logical            no-undo.
define variable default-receipts-valid    like mfc_logical            no-undo.
define variable invalid-prm-po-ln-rcpt    like mfc_logical            no-undo.

define variable mess_desc      as   character                         no-undo.
define variable templot        as   character                         no-undo.
define variable csz            as   character format "X(38)"          no-undo.
define variable dwn            as   integer                           no-undo.
define variable first_down     as   integer initial 0                 no-undo.
define variable i              as   integer                           no-undo.
define variable msgnbr         as   integer                           no-undo.
define variable w-int1         as   integer                           no-undo.
define variable w-int2         as   integer                           no-undo.
define variable alm_recno      as   recid                             no-undo.
define variable filename       as   character                         no-undo.
define variable ii             as   integer                           no-undo.
define variable use_pod_um_conv as  logical                           no-undo.
/*N0WT*/ {&POPORCA-P-TAG1}

define variable vQuantityReceived as decimal no-undo.
define variable vSiteId as character no-undo.
define variable vLocation as character no-undo.
/*M0RJ*/ define variable l_remove_srwkfl like mfc_logical no-undo.

/*N178*/ define variable l_flag like mfc_logical no-undo.

/*Kaine*/  DEFINE VARIABLE str_newlot LIKE newlot.

/*WORKFILE FOR POD RECEIPT ATTRIBUTES*/
define shared workfile attr_wkfl no-undo
   field chg_line     like sr_lineid
   field chg_assay    like tr_assay
   field chg_grade    like tr_grade
   field chg_expire   like tr_expire
   field chg_status   like tr_status
   field assay_actv   as   logical
   field grade_actv   as   logical
   field expire_actv  as   logical
   field status_actv  as   logical.

assign issue_or_receipt = getTermLabel("RECEIPT",8).

form with frame c 5 down width 80.

/*@MODULE WIPLOTTRACE BEGIN*/
{wlfnc.i} /*FUNCTION FORWARD DECLARATIONS*/
{wlcon.i}
/*@MODULE WIPLOTTRACE END*/

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

form
   pod_line       /*V8! space(.3) */
   pod_part       /*V8! view-as fill-in size 16 by 1 */
   pt_um          /*V8! space(.3) */
   qopen          /*V8! space(.3) */
   pod_um         /*V8! space(.3) */
   shipqtychg     /*V8! space(.3) */
   pod_rum        /*V8! space(.3) */
   pod_project    /*V8! space(.3) */
   pod_due_date   /*V8! space(.3) */
   pod_type
with frame cship 5 down width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame cship:handle).

form
   po_nbr         colon 12   label {&poporca_p_8}
   po_vend
   po_stat
   ps_nbr         to 78
with frame b side-labels no-attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

form with frame e down no-attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame e:handle).

form
   line           colon 15
   receipt_um     colon 36
   site           colon 54
   location       colon 68 label {&poporca_p_7}
   lotserial_qty  colon 15
   wolot          colon 36 label {&poporca_p_13}
   lotserial      colon 54 label {&poporca_p_11}
   packing_qty    colon 15 label {&poporca_p_6}
   woop           colon 36 label {&poporca_p_5}
   lotref         colon 54
   cancel_bo      colon 15 label {&poporca_p_16}

   pod__qad04[1]  colon 54 label {&poporca_p_18} format "x(22)"
   pod_part       colon 15 /*7.0*/ no-attr-space
   multi_entry    colon 54

   chg_attr       colon 73
   pod_vpart      /*7.0 colon 54 */
   colon 15
   no-attr-space
   cmmt_yn        colon 54 label {&poporca_p_15}
with frame d side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

/*@MODULE WIPLOTTRACE BEGIN*/
if is_wiplottrace_enabled() then
   run init_poline_bkfl_input_output.
/*@MODULE WIPLOTTRACE END*/

for first poc_ctrl
   fields (poc_ln_stat) no-lock:
end. /* FOR FIRST POC_CTRL */
ln_stat = if available poc_ctrl and poc_ln_stat = "x" then yes else no.

/*@TO-DO  copy the following to INIT procedure in porcxu.p*/
for first clc_ctrl
   fields (clc_lotlevel) no-lock:
end. /* FOR FIRST CLC_CTRL */

if not available clc_ctrl then do:
   {gprun.i ""gpclccrt.p""}
/*@TO-DOEND*/

   for first clc_ctrl
      fields(clc_lotlevel) no-lock:
   end. /* FOR FIRST CLC_CTRL */
end. /* IF NOT AVAILABLE CLC_CTRL */

/*@TO-DO  XUI needs to find po_mstr without recid*/
for first po_mstr
   fields (po_nbr po_stat po_vend)
   where recid(po_mstr) = po_recno no-lock:
end. /* FOR FIRST PO_MSTR */
/*@TO-DOEND*/

assign
   line    = 1
   proceed = no.

/*@MODULE PRM BEGIN*/
run build-prm-temp-table.
/*@MODULE PRM END*/

edit-loop:

repeat on endkey undo, leave:
   lineloop:
   repeat:

      display po_nbr po_vend po_stat ps_nbr with frame b.

      clear frame c all no-pause.
      clear frame d all no-pause.

      clear frame cship all no-pause.
      clear frame e all no-pause.

      if porec then
         view frame c.
      else
         view frame cship.

      view frame d.

      for each pod_det no-lock
         where pod_nbr = po_nbr
           and pod_line >= line
           and pod_status <> "c"
           and pod_status <> "x"
         use-index pod_nbrln by pod_line:

         if porec then do:
            if pod_rma_type <> "I"  and
               pod_rma_type <> ""   then next.
         end. /* IF POREC */
         else do:
            if  pod_rma_type <> "O" then next.
         end. /* ELSE DO: */

         for first si_mstr
            fields (si_db si_entity si_site)
            where si_site = pod_site no-lock:
         end. /* FOR FIRST SI_MSTR */

         if available si_mstr and si_db = global_db then do:

            for first pt_mstr
               fields(pt_auto_lot pt_loc pt_lot_grp
                      pt_lot_ser pt_part pt_status pt_um)
               where pt_part = pod_part no-lock:
            end. /* FOR FIRST PT_MSTR */

            if porec then do:
               {pxrun.i &PROC='getOpenQuantity' &PROGRAM='porcxr1.p'
                        &PARAM="(input pod_qty_ord,
                                 input pod_qty_rcvd,
                                 output qopen)"
                        &NOAPPERROR=True
                        &CATCHERROR=True
               }
            end.
            /*@MODULE RTS BEGIN*/
            else
               assign
                  qopen  =  - (pod_qty_ord - pod_qty_rcvd).
            /*@MODULE RTS END*/

            {pxrun.i &PROC='getScheduleOpenQuantity' &PROGRAM='porcxr1.p'
                     &PARAM="(buffer pod_det,
                              input eff_date,
                              input-output qopen)"
                     &NOAPPERROR=True
                     &CATCHERROR=True
            }

            /* Display correct label for RTS shipments. */
            assign shipqtychg = pod_qty_chg.

            if porec then do:
               display
                  pod_line
                  /*V8!space(.2) */
                  pod_part
                  /*V8! view-as fill-in size 16 by 1 */
                  pt_um when (available pt_mstr)
                  /*V8!space(.2) */
                  qopen
                  /*V8!space(.2) */
                  pod_um
                  /*V8! view-as fill-in size 3 by 1 space(.2) */
                  pod_qty_chg
                  /*V8!space(.2) */
                  pod_rum
                  /*V8! view-as fill-in size 3 by 1 space(.2) */
                  pod_project
                  /*V8!space(.2) */
                  pod_due_date
                  /*V8!space(.2) */
                  pod_type
                  /*V8! view-as fill-in size 3 by 1 */
               with frame c.

               if frame-line(c) = frame-down(c) then leave.
               down 1 with frame c.

            end.  /* IF POREC */
            else do:
               display
                  pod_line
                  pod_part
                  pt_um when (available pt_mstr)
                  qopen
                  pod_um
                  shipqtychg
                  pod_rum
                  pod_project
                  pod_due_date
                  pod_type
               with frame cship.

               if frame-line(cship) = frame-down(cship) then leave.
               down 1 with frame cship.
            end. /* ELSE DO */
         end.  /* IF AVAILABLE SI_MSTR */
      end.  /* FOR EACH POD_DET */

      line = 0.

      setline:
      do transaction on error undo, retry:
         update line with frame d
         editing:
            nppoddet:
            repeat:
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

                  for first si_mstr
                     fields (si_db si_entity si_site)
                     where si_site = pod_site no-lock:
                  end. /* FOR FIRST SI_MSTR */

                  if not available si_mstr
                     or (available si_mstr and si_db <> global_db) then
                     next nppoddet.

                  run display-detail.

               end. /* IF RECNO <> ? */
               leave.
            end.  /* NPPODDET: REPEAT: */

            /*@MODULE PRM BEGIN*/
            if prm-avail then do:

               if keyfunction(lastkey) = "END-ERROR"
                  or keyfunction(lastkey) = "GO" then do:

                  need-to-validate-defaults = no.

                  /* NEED TO VALIDATE ALL PO LINES LINKED TO  */
                  /* PRM PROJECT LINES WHERE DEFAULT PO LINE  */
                  /* RECEIPT QUANTITIES ARE TO BE ACCEPTED    */
                  /* - I.E. EACH TTPRM-DET RECORD             */
                  if fill-all then
                     for first ttprm-det no-lock:
                        need-to-validate-defaults = yes.
                     end. /* FOR FIRST TTPRM-DET */

                  if need-to-validate-defaults then
                     leave. /* LEAVE UPDATE..EDITING BLOCK */

                  if keyfunction(lastkey) = "END-ERROR" then
                     undo lineloop, leave.

               end.  /* IF KEYFUNCTION(LASTKEY)... */
            end.  /* IF PRM-AVAIL */
            /*@MODULE PRM END*/
            else
               if keyfunction(lastkey) = "end-error" then
                  undo lineloop, leave.

         end. /* EDITING */

         if (line = 0) then do:         /* NO PO LINE SELECTED */

            if (prm-avail and not need-to-validate-defaults)
               or (not prm-avail) then
               leave lineloop.
            else
               /*@MODULE PRM BEGIN*/
               if prm-avail and need-to-validate-defaults then do:

                  /* VALIDATE THE DEFAULT VALUES THAT WERE ASSIGNED */
                  /* TO EACH OF THE PO LINES TO BE RECEIVED         */
                  {gprunmo.i
                     &program=""pjporvdl.p""
                     &module ="PRM"
                     &param  ="""(input  fill-all,
                                  output default-receipts-valid,
                                  output pod_recno,
                                  output cancel-prm)"""}

                  if cancel-prm then do:
                     /* LEAVE LINE DETAILS AND RETURN TO HEADER */
                     /* SINCE WE DON'T WANT TO PROCESS THE PRM  */
                     /* RECORDS ASSOCIATED WITH THE PO          */
                     run hide-frames.
                     undo, return.
                  end. /* IF CANCEL-PRM */

                  /* CAN LEAVE THE LINELOOP IF PRM VALIDATIONS OF */
                  /* DEFAULT PO LINE VALUES INDICATES NO PROBLEMS */
                  /* BUT WHERE PROBLEM LINES EXIST THE FIRST ONE  */
                  /* WILL BE IDENTIFIED AND USER WILL BE ALLOWED  */
                  /* MAKE THE NECESSARY MODIFICATIONS (STAYS IN   */
                  /* LINELOOP)                                    */
                  if default-receipts-valid then
                     leave lineloop.
                  else do:
                     /* FIND OUT WHICH LINE IS INVALID AND DISPLAY */
                     for first pod_det no-lock
                        where pod_recno = recid(pod_det):

                        line = pod_line.

                        run display-detail.
                     end.  /* FOR FIRST POD_DET */
               end.   /* ELSE DO */
               /*@MODULE PRM END*/
            end.   /* ELSE IF PRM-AVAIL... */
         end.     /* IF LINE = 0 */

         assign
            vendlot = ""
            lotnext = ""
            newlot  = "".

         {pxrun.i &PROC='processRead' &PROGRAM='popoxr1.p'
                  &PARAM="(input po_nbr,
                           input line,
                           buffer pod_det,
                           input {&LOCK_FLAG},
                           input {&WAIT_FLAG})"
                  &NOAPPERROR=True
                  &CATCHERROR=True
         }

         if return-value = {&SUCCESS-RESULT} then do:

            {pxrun.i &PROC='validateSiteDatabase' &PROGRAM='porcxr1.p'
                     &PARAM="(input pod_site)"
                     &NOAPPERROR=True
                     &CATCHERROR=True
            }

/*M1GR**    if return-value <> {&SUCCESS-RESULT} then */
/*M0X2**    undo setline, retry. */

/*M1GR*/    if return-value <> {&SUCCESS-RESULT}
/*M1GR*/    then do:
/*M1GR*/       if batchrun
/*M1GR*/       then
/*M0X2*/          undo edit-loop, retry edit-loop.
/*M1GR*/       else
/*M1GR*/          undo setline, retry.
/*M1GR*/    end.   /* IF return-value <> {&SUCCESS-RESULT} */

            /* PONBR AND POLINE NOW ASSIGNED WITH POD_NBR AND POD_LINE        */
            /* IRRESPECTIVE OF TYPE OF PURCHASE ORDER                         */

            assign
               ponbr  = pod_nbr
               poline = pod_line.

         end. /* IF AVAILABLE POD_DET */

         if not available pod_det then do:
            /* LINE ITEM DOES NOT EXIST */
            {pxmsg.i
               &MSGNUM=45
               &ERRORLEVEL={&APP-ERROR-RESULT}}
/*M0X2**    undo setline, retry. */

/*M1GR*/    if batchrun
/*M1GR*/    then
/*M0X2*/       undo edit-loop, retry edit-loop.
/*M1GR*/    else
/*M1GR*/       undo setline, retry.

     	 end. /* IF NOT AVAILABLE POD_DET */

         /*@TO-DO call this in xui*/
         /* PICK UP CURRENTLY EFFECTIVE CUM ORDER*/
         {gprun.i ""poporca5.p""
                  "(input pod_nbr,
                    input pod_line,
                    input eff_date)"}
         /*@TO-DOEND*/

         if (porec               and
            pod_rma_type <> "I"  and
            pod_rma_type <> "")  or
            (not porec           and
            pod_rma_type <> "O") then do:
            /* LINE ITEM DOES NOT EXIST */
            {pxmsg.i
               &MSGNUM=45
               &ERRORLEVEL={&APP-ERROR-RESULT}}
/*M0X2**    undo setline, retry. */

/*M1GR*/    if batchrun
/*M1GR*/    then
/*M0X2*/       undo edit-loop, retry edit-loop.
/*M1GR*/    else
/*M1GR*/       undo setline, retry.

         end. /* IF POREC */

         {pxrun.i &PROC='validateStatusId' &PROGRAM='porcxr1.p'
                  &PARAM="(input pod_status)"
                  &NOAPPERROR=True
                  &CATCHERROR=True
         }
/*M1GR**    if return-value <> {&SUCCESS-RESULT} then */
/*M0X2**    undo setline, retry. */

/*M1GR*/ if return-value <> {&SUCCESS-RESULT}
/*M1GR*/ then do:
/*M1GR*/    if batchrun
/*M1GR*/    then
/*M0X2*/       undo edit-loop, retry edit-loop.
/*M1GR*/    else
/*M1GR*/       undo setline, retry.
/*M1GR*/ end. /* IF return-value <> {&SUCCESS-RESULT}*/

         cline = string (line).

         {pxrun.i &PROC='readFirstDetailForLine' &PROGRAM='porcxr2.p'
                  &PARAM="(input integer(cline),
                           buffer sr_wkfl,
                           input {&NO_LOCK_FLAG},
                           input {&NO_WAIT_FLAG})"
                  &NOAPPERROR=True
                  &CATCHERROR=True
         }

         if return-value = {&SUCCESS-RESULT} then newlot = sr_lotser.

/*****************Kaine begin**************************************/
		str_newlot = "".
		IF newlot = "" THEN DO:
			FIND FIRST xseq_ctrl WHERE xseq_date = eff_date NO-ERROR.
			IF NOT AVAILABLE xseq_ctrl THEN DO:
				CREATE xseq_ctrl.
				xseq_date = eff_date.
				xseq_num = 1.
			END.	
			newlot = substring(STRING(YEAR(Xseq_date)),3,2) 
			+ STRING(MONTH(Xseq_date),"99") 
			+ string(DAY(Xseq_date),"99")
			+ STRING(xseq_num,"9999").
			str_newlot = "yes".			
		END.  /*Kaine*  IF newlot = "" THEN DO*/
/*****************Kaine end****************************************/

         pod_recno = recid (pod_det).
         {pxrun.i &PROC='setAutoLotNumber' &PROGRAM='porcxr1.p'
                  &PARAM="(buffer pod_det,
                           input porec,
                           input-output newlot,
                           output trans-ok)"
                  &NOAPPERROR=True
                  &CATCHERROR=True
         }

         if return-value <> {&SUCCESS-RESULT} then do:
/*M1GR** if not trans-ok then */
/*M1GR*/    if not batchrun
/*M1GR*/    then
               undo lineloop, retry.
            else
/*M0X2**       undo setline, retry. */
/*M0X2*/       undo edit-loop, retry edit-loop.
         end. /* IF return-value <> {$SUCCESS-RESULT}*/

         lotserial = newlot.

      end. /*  DO ON ERROR UNDO, RETRY */ /* TRANSACTION */

      assign
         packing_qty = pod_ps_chg
         cancel_bo   = can-find(first poc_ctrl where poc_ln_stat = "x")
         wolot       = pod_wo_lot
         woop        = pod_op
         lotserial   = newlot
         lotnext     = newlot
         receipt_um  = pod_rum.
	
      display
         line
         packing_qty
         cancel_bo
         pod_part
         pod_vpart
         receipt_um
         wolot
         lotnext @ lotserial
         woop
         pod_site @ site
      with frame d.

/*N12L*/ for first si_mstr
/*N12L*/    fields (si_db si_entity si_site)
/*N12L*/    where si_site = pod_site
/*N12L*/    no-lock:
/*N12L*/ end. /* FOR FIRST si_mstr */

      if available si_mstr then do:

         {pxrun.i &PROC='validateSiteSecurity' &PROGRAM='icsixr.p'
                  &PARAM="(input si_site,
                           input """")"
                  &NOAPPERROR=True
                  &CATCHERROR=True
         }
         if return-value <> {&SUCCESS-RESULT} then do:
            pause.
            undo lineloop, retry.
         end.
      end.

      /* Initialize input variables, check for open vouchers. */

      pod_recno = recid(pod_det).

      /*mxb - moved call to checkOpenVouchers into poporca3.p*/
      {gprun.i ""poporca3.p""}
      lotserial = NEWlot.

      DO TRANSACTION:
      locloop:
      do on error undo, retry:
         ststatus = stline[3].
         status input ststatus.

         {pxrun.i &PROC='readFirstDetailForLine' &PROGRAM='porcxr2.p'
                  &PARAM="(input integer(cline),
                           buffer sr_wkfl,
                           input {&NO_LOCK_FLAG},
                           input {&NO_WAIT_FLAG})"
                  &NOAPPERROR=True
                  &CATCHERROR=True
         }

         assign
            cmmt_yn = no
            chg_attr = no.

         {pxrun.i &PROC='processRead' &PROGRAM='ppitxr.p'
                  &PARAM="(input pod_part,
                           buffer pt_mstr,
                           input {&NO_LOCK_FLAG},
                           input {&NO_WAIT_FLAG})"
                  &NOAPPERROR=True
                  &CATCHERROR=True
         }

         lotprcpt  = pod_lot_rcpt.

         /*mxb - multi-entry is only used to support chui*/
         assign
            i           = 0
            multi_entry = no.
         for each sr_wkfl
            fields(sr_lineid sr_loc sr_lotser sr_qty
                   sr_ref sr_site sr_userid sr_vend_lot)
            where sr_userid = mfguser
              and sr_lineid = cline no-lock:
            i = i + 1.
            if i > 1 then do:
               multi_entry = yes.
               leave.
            end. /* IF I > 1  */
         end. /*  FOR FIRST SR_WKFL */

         /*mxb - pod__qad04 is only used to support chui*/
         if pod__qad04[1] = ? then
            assign pod__qad04[1] = "".

         display
            lotserial_qty
            packing_qty
            cancel_bo
            receipt_um
            wolot
            woop
            site
            location
            lotserial
            lotref
            pod__qad04[1]
            multi_entry
            chg_attr
            cmmt_yn
         with frame d.

         l_getlot = yes.
         if available pt_mstr
            and (porec = yes) and
            (is-return = no) then  do:

            if ({pxfunct.i &FUNCTION='isAutoLotEnabled' &PROGRAM='clalxr.p'
                           &PARAM="input pt_lot_ser,
                                   input pt_auto_lot,
                                   input pt_lot_grp,
                                   input pod_type,
                                   input yes"
                })
            then l_getlot = no.

         end. /* IF AVAILABLE PT_MSTR */

         set lotserial_qty
             packing_qty
             cancel_bo
             receipt_um
             wolot
             woop
             /*@MODULE WIPLOTTRACE - enablement*/
             site      when (not multi_entry
                        and not (is_wiplottrace_enabled() and pod_type = "s"))
             location  when (not multi_entry
                        and not (is_wiplottrace_enabled() and pod_type = "s"))
/*Kaine             lotserial when ((not multi_entry) and l_getlot
*                        and not (is_wiplottrace_enabled() and pod_type = "s"))
* Kaine*/
             lotref    when (not multi_entry
                        and not (is_wiplottrace_enabled() and pod_type = "s"))
             pod__qad04[1]
                       when (not (is_wiplottrace_enabled() and pod_type = "s"))
             multi_entry
                       when (not multi_entry
                        and not (is_wiplottrace_enabled() and pod_type = "s"))
             /*@TO-DO - enablement*/
             chg_attr  when (porec and pod_type = "")
             cmmt_yn
             /*@TO-DOEND*/
         with frame d
         editing:
            assign
               /*@TO-DO - setCharacterValue for global_site, ...*/
               global_site = input site
               global_loc  = input location
               global_lot  = input lotserial.
               /*@TO-DOEND*/

            readkey.
            apply lastkey.
         end. /* EDITING: */

/*****************Kaine begin**************************************/
			IF str_newlot = "yes" AND lotserial_qty <> 0 THEN DO:
					Xseq_num = xseq_num + 1 .
			END.
/*****************Kaine end****************************************/

         /*@MODULE PRM BEGIN*/
         /* STORE THE RECEIPT QUANTITY IN THE PRM TEMP TABLE */
         run save-receipt-qty.
         /*@MODULE PRM END*/

         {pxrun.i &PROC='getUMConversionToPOLine' &PROGRAM='porcxr1.p'
                  &PARAM="(input receipt_um,
                           buffer pod_det,
                           output conv_to_pod_um,
                           output use_pod_um_conv)"
                  &NOAPPERROR=True
                  &CATCHERROR=True
         }
         if return-value <> {&SUCCESS-RESULT} then do:
            next-prompt receipt_um with frame d.
            undo, retry.
         end. /* IF CONV_TO_POD_UM = ? */

         {pxrun.i &PROC='validateSiteSecurity' &PROGRAM='icsixr.p'
                  &PARAM="(input (input site),
                           input ? )"
                  &NOAPPERROR=True
                  &CATCHERROR=True
         }
         if return-value <> {&SUCCESS-RESULT} then do:
            next-prompt site with frame d.
            undo, retry.
         end.

         {pxrun.i &PROC='processRead' &PROGRAM='icsixr.p'
                  &PARAM="(input  site,
                           buffer si_mstr,
                           input  {&NO_LOCK_FLAG},
                           input  {&NO_WAIT_FLAG})"
                  &NOAPPERROR=True
                  &CATCHERROR=True}

         /* VERIFY OPEN GL PERIOD FOR LINE ITEM SITE/ENTITY */
         if avail si_mstr then do:
            {pxrun.i &PROC='validateDateInGLPeriod' &PROGRAM='glglxr.p'
                     &PARAM="(input site,
                              input ""IC"",
                              input eff_date)"
                     &NOAPPERROR=True
                     &CATCHERROR=True
               }
/*N178*/ end. /* IF AVAILABLE si_mstr */

         if return-value <> {&SUCCESS-RESULT} then do:
/*N178*/    if not available si_mstr
/*N178*/    then do:
/*N178*/       /* SITE DOES NOT EXIST */
/*N178*/       {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
/*N178*/    end. /* IF NOT AVAILABLE si_mstr */
            next-prompt site with frame d.
            undo locloop, retry.
         end.

/*N178** end.  */

         if available pt_mstr then do:

/*N178*/    /* BEGIN ADD */

            /* IN CASE OF RTS RECEIPTS FOR SERIALIZED ITEMS, SKIP THE     */
            /* VALIDATION FOR SERIAL NUMBER USING THE PROCEDURE           */
            /* validateLotSerialUsage WHEN THE SHIPMENT AND RECEIPT FOR   */
            /* THE SERIALIZED ITEM ARE PERFORMED ON THE SAME RTS WITH THE */
            /* SAME SERIAL NUMBER.                                        */

            l_flag = no.

            if pod_fsm_type = "RTS-RCT"
            then do:
               for first rmd_det
                  fields (rmd_nbr     rmd_part rmd_prefix
                          rmd_qty_acp rmd_ser  rmd_type )
                  where  rmd_nbr     = pod_nbr
                  and    rmd_part    = pod_part
                  and    rmd_prefix  = "V"
                  and    rmd_type    = "O"
                  and    rmd_qty_acp > 0
               no-lock:
                  if rmd_ser <> lotserial
                  then do:
                     for first tr_hist
                        fields (tr_nbr     tr_part
                                tr_program tr_serial)
                        where  tr_serial  = lotserial
                        and    tr_nbr     = pod_nbr
                        and    tr_part    = pod_part
                        and    tr_program = "fsrtvis.p"
                     no-lock:
                     end. /* FOR FIRST tr_hist */

                     if not available tr_hist
                     then
                        l_flag = yes.

                  end. /* IF rmd_ser <> lotserial */

               end. /* FOR FIRST rmd_det */

               if not available rmd_det
               then
                  l_flag = yes.

            end. /* IF pod_fsm_type = "RTS-RCT" */

            else

               /* FOR ALL OTHER TRANSACTIONS, EXCEPT RTS RECEIPTS */
               /* FOR SERIALIZED ITEMS.                           */

               l_flag = yes.

            if     l_flag       = yes
               and pod_fsm_type <> "RTS-RCT"
            then do:

/*N178*/       /* END ADD */

               {pxrun.i &PROC='validateLotSerialUsage' &PROGRAM='cllotxr.p'
                        &PARAM="(input pt_part,
                                 input pt_lot_ser,
                                 input pod_lot_rcpt,
                                 input yes,
                                 input lotserial)"
                        &NOAPPERROR=True
                        &CATCHERROR=True
               }

/*N178*/    end. /* IF l_flag = YES AND ... */

            if return-value <> {&SUCCESS-RESULT} then do:
               next-prompt lotserial with frame d.
               undo, retry.
            end.

         end. /* IF AVAILABLE pt_mstr */

         {pxrun.i &PROC='validateRestrictedTrans' &PROGRAM='porcxr1.p'
                  &PARAM="(buffer pt_mstr,
                          input pod_type,
                          input transtype)"
                  &NOAPPERROR=True
                  &CATCHERROR=True
         }
         if return-value <> {&SUCCESS-RESULT} then
            undo, retry.

         {pxrun.i &PROC='setReceiptSite' &PROGRAM='porcxr1.p'
                  &PARAM="(buffer pod_det,
                           buffer wo_mstr,
                           output rct_site)"
                  &NOAPPERROR=True
                  &CATCHERROR=True
         }

         /*@TO-DO - check on pod_type needs to be in XUI controller*/
         if pod_type = "S" then do:
            assign
               undo_all  = false
               pod_recno = recid(pod_det).

            /* SUBCONTRACT WORKORDER UPDATE */
            {gprun.i ""poporca2.p""}
            if undo_all then do:
               next-prompt wolot with frame d.
               undo, retry.
            end. /* IF UNDO_ALL */
         end. /* IF POD_TYPE = "S" */
         /*@TO-DOEND*/

         assign
            total_lotserial_qty = pod_qty_chg
            trans_um            = receipt_um.

         /* IF receipt_um = pt_um, THE CONVERSION FACTOR SHOULD BE */
         /* DOESN'T ALWAYS EQUAL 1, LEADING TO INVENTORY PROBLEMS  */

         {pxrun.i &PROC='getReceiptUMConversion' &PROGRAM='porcxr1.p'
                  &PARAM="(input receipt_um,
                           input conv_to_pod_um,
                           buffer pt_mstr,
                           buffer pod_det,
                           output trans_conv)"
                  &NOAPPERROR=True
                  &CATCHERROR=True
         }

         if multi_entry then do:

            /* THIS PATCH INSURES THAT AT LEAST ONE sr_wkfl ENTRY IS
               PASSED  TO icsrup2.p ( MULTI ENTRY  MODE HANDLER ) EVEN IF
               RECEIVE ALL IS SET TO NO; SO AS TO BRING CONSISTENCY WITH
               RECEIVE ALL SET TO YES.
            */

            /* CREATE BEGINS */

            {pxrun.i &PROC='processRead' &PROGRAM='ppitxr.p'
                     &PARAM="(input pod_part,
                              buffer pt_mstr,
                              input {&NO_LOCK_FLAG},
                              input {&NO_WAIT_FLAG})"
                     &NOAPPERROR=True
                     &CATCHERROR=True
            }

            if return-value <> {&SUCCESS-RESULT} or
               (return-value = {&SUCCESS-RESULT} and
                pt_lot_ser = ""   and
                pod_type <> "s")  then do:

               {pxrun.i &PROC='readFirstDetailForLine' &PROGRAM='porcxr2.p'
                        &PARAM="(input integer(cline),
                                 buffer sr_wkfl,
                                 input {&NO_LOCK_FLAG},
                                 input {&NO_WAIT_FLAG})"
                        &NOAPPERROR=True
                        &CATCHERROR=True
               }

               if return-value <> {&SUCCESS-RESULT} then do:
                  {pxrun.i &PROC='createPOReceiptDetail' &PROGRAM='porcxr2.p'
                           &PARAM="(buffer sr_wkfl,
                                    input mfguser,
                                    input integer(cline),
                                    input site,
                                    input location,
                                    input lotserial,
                                    input lotref,
                                    input """",
                                    input lotserial_qty)"
                           &NOAPPERROR=True
                           &CATCHERROR=True
                  }
                  {pxrun.i &PROC='processRead' &PROGRAM='porcxr2.p'
                           &PARAM="(input mfguser,
                                    input integer(cline),
                                    input site,
                                    input location,
                                    input lotserial,
                                    input lotref,
                                    buffer sr_wkfl,
                                    input {&LOCK_FLAG},
                                    input {&WAIT_FLAG})"
                           &NOAPPERROR=True
                           &CATCHERROR=True
                  }
/*N1FC**          assign                                */
/*N1FC**             sr_vend_lot = pod__qad04[1].       */
               end. /* IF NOT AVAILABLE SR_WKFL */
/*N1FC*/       if available sr_wkfl
/*N1FC*/       then
/*N1FC*/          sr_vend_lot = pod__qad04[1].
            end. /* IF NOT AVAILABLE PT_MSTR */

            /* CREATE ENDS */

            {pxrun.i &PROC='readFirstDetailForLine' &PROGRAM='porcxr2.p'
                     &PARAM="(input integer(cline),
                              buffer sr_wkfl,
                              input {&LOCK_FLAG},
                              input {&WAIT_FLAG})"
                     &NOAPPERROR=True
                     &CATCHERROR=True
            }
            if lotserial_qty = 0 then do:
               if available sr_wkfl then do:
                  total_lotserial_qty = total_lotserial_qty - sr_qty.
                  delete sr_wkfl.
               end. /* IF AVAILABLE SR_WKFL */
            end. /* IF LOTSERIAL_QTY = 0 */
            else do:
               if available sr_wkfl then do:
                  /* IF MORE THAN ONE SR_WKFL RECORD EXISTS, THEN THE USER
                     ALREADY ENTERED MULTI-LINE INFORMATION, DO NOT DESTROY
                     THAT */

                  find sr_wkfl where sr_userid = mfguser and
                     sr_lineid = cline exclusive-lock no-error.
                  if not ambiguous sr_wkfl then
                     assign
                        sr_site   = site
                        sr_loc    = location
                        sr_lotser = lotserial
                        sr_ref    = lotref
                        sr_qty    = lotserial_qty.
               end. /* IF AVAIL SR_WKFL */
            end. /* ELSE DO: */

            if i >= 1 then
               assign
                  location = ""
                  lotref   = ""
                  vendlot  = "".

            /*@TO-DO  it seems to be a dead code. i will not be 0 when
                      multi_entry is true*/
            if i = 0 then
               assign vendlot = pod__qad04[1].
            /*@TO_DOEND*/

            if lotprcpt = yes then lotnext = lotserial.

            podtype = pod_type.
            total_lotserial_qty = 0.

            {pxrun.i &PROC='getTotalLotSerialQuantity' &PROGRAM='porcxr2.p'
                     &PARAM="(input integer(cline),
                              output total_lotserial_qty)"
                     &NOAPPERROR=True
                     &CATCHERROR=True
            }

            {gprun.i ""icsrup2.p""
                     "(input rct_site,
                       input ponbr,
                       input poline,
                       input-output lotnext,
                       input lotprcpt,
                       input-output vendlot)"}

            /* IF MULTI-ENTRY MODE WAS USED TO PROCESS RECEIPTS FOR A
               SINGLE ITEM/LOT/SERIAL LOCATION, IT IS POSSIBLE THAT
               THEY ARE RETURNING TO THIS PROGRAM HAVING CREATED ONLY 1
               sr_wkfl RECORD.  IF SO, THIS PROGRAM WILL RESET THE
               VALUE OF THE multi_entry FIELD TO "NO" (F0S0 BELOW). IF
               THE USER HAS RETURNED FROM THE MULTI-ENTRY FRAME BY
               PRESSING F4 ON AN ERROR CONDITION FOR SINGLE
               ITEM/LOT/SERIAL, THE PROGRAM IS RETURNING WITH THE
               VALUES IN sr_wkfl THAT CAUSED THE ERROR MESSAGE (BECAUSE
               THEY ARE DEFINED no-undo).  THESE ERRONEOUS VALUES WERE
               THEN OVERWRITING THE GOOD ONES.  TO PREVENT THIS FROM
               OCCURRING, WE DO A FIND ON THE FIRST sr_wkfl HERE TO
               RE-ESTABLISH THE CORRECT VALUES FROM sr_wkfl.
            */

            {pxrun.i &PROC='readFirstDetailForLine' &PROGRAM='porcxr2.p'
                     &PARAM="(input integer(cline),
                              buffer sr_wkfl,
                              input {&NO_LOCK_FLAG},
                              input {&NO_WAIT_FLAG})"
                     &NOAPPERROR=True
                     &CATCHERROR=True
            }
            if return-value = {&SUCCESS-RESULT} then
               assign
                  site      = sr_site
                  location  = sr_loc
                  lotserial = sr_lotser
                  lotref    = sr_ref
                  lotserial_qty = sr_qty.

         end. /* IF MULTI_ENTRY */

            if multi_entry = yes then do:
               /* VERIFY THAT A MULTI_ENTRY WAS ACTUALLY PERFORMED */
               assign
                  i           = 0
                  multi_entry = no.

               for each sr_wkfl
                  fields(sr_lineid sr_loc sr_lotser sr_qty
                         sr_ref sr_site sr_userid sr_vend_lot)
                  where sr_userid = mfguser
                    and sr_lineid = cline no-lock:
                  i = i + 1.
                  if i = 1 then
                     assign pod__qad04[1] = sr_vend_lot.

                  if i > 1 then do:
                     multi_entry = yes.
                     leave.
                  end. /* IF I > 1 */
               end. /* FOR EACH SR_WKFL */
            end. /* IF MULTI_ENTRY = YES */

/*N178*/    if     l_flag       = yes
/*N178*/       and pod_fsm_type = "RTS-RCT"
/*N178*/    then do:

/*N178*/       {pxrun.i &PROC='validateLotSerialUsage' &PROGRAM='cllotxr.p'
                        &PARAM="(input pt_part,
                                 input pt_lot_ser,
                                 input pod_lot_rcpt,
                                 input yes,
                                 input lotserial)"
                        &NOAPPERROR=True
                        &CATCHERROR=True
               }

/*N178*/       if return-value <> {&SUCCESS-RESULT}
/*N178*/       then do:
/*N178*/          next-prompt lotserial
/*N178*/          with frame d.
/*N178*/          undo, retry.
/*N178*/       end. /* IF return-value <> {&SUCCESS-RESULT} */

/*N178*/    end. /* IF l_flag = yes AND ... */

            if multi_entry = no then do:

               /* PERFORM EDITS HERE FOR PURCHASE ORDERS.  RTS
                  EDITS ARE DONE LATER... */

               if (pod_type = "" and pod_fsm_type = "") then do:

                  {pxrun.i &PROC='validateInventory' &PROGRAM='porcxr2.p'
                           &PARAM="(input transtype,
                                    input site,
                                    input location,
                                    input global_part,
                                    input lotserial,
                                    input lotref,
                                    input (lotserial_qty * trans_conv),
                                    input trans_um,
                                    input ponbr,
                                    input (if lotserial_qty >=0
                                           then poline else 0),
                                    input yes
                                   )"
                           &NOAPPERROR=True
                           &CATCHERROR=True
                  }

                  if return-value <> {&SUCCESS-RESULT} then
                     undo locloop, retry.

               end. /* IF (POD_TYPE = "" AND POD_FSM_TYPE = "") */

               /* PERFORM EDITS FOR RTS SHIPMENT/RECEIPTS WITH INVENTORY
                  ISSUE/RECEIPT = YES ( -> POD_TYPE = " " INSTEAD OF "R") */

               /* NOTE: FOR RTS RECEIPTS, IT'S JUST LIKE EDITING A PO RECEIPT,
                  HOWEVER, AN RTS RETURN IS EDITED AS IF IT'S A RECEIPT FOR A
                  NEGATIVE QUANTITY. */

               /*@MODULE RTS BEGIN*/
               if (pod_type = "" and pod_fsm_type <> "") then do:
                  if (pt_lot_ser <> "S") then do:
                     {gprun.i ""icedit.p""
                              "(input  transtype,
                                input  site,
                                input  location,
                                input  global_part,
                                input  lotserial,
                                input  lotref,
                                input  if pod_fsm_type = ""RTS-RCT"" then
                                          lotserial_qty * trans_conv
                                       else
                                          lotserial_qty * trans_conv * -1,
                                input  trans_um,
                                input  """",
                                input  """",
                                output undotran)"}
                  end. /* IF (PT_LOT_SER <> "S") */
                  else if pt_lot_ser = "S" then do:
                     {gprun.i ""icedit5.p""
                              "(input  transtype,
                                input  site,
                                input  location,
                                input  global_part,
                                input  lotserial,
                                input  lotref,
                                input  if pod_fsm_type = ""RTS-RCT"" then
                                          lotserial_qty * trans_conv
                                       else
                                          lotserial_qty * trans_conv * -1,
                                input  trans_um,
                                input  """",
                                input  """",
                                output undotran)"}
                  end. /* ELSE IF PT_LOT_SER = "S" */
                  if undotran then do:
                     undo locloop, retry.
                  end. /* IF UNDOTRAN */
               end. /* IF POD_TYPE = "" AND POD_FSM_TYPE <> "" */

               /* PERFORM OTHER RTS EDITS - THESE ARE THE RTS SHIPMENTS
                  AND RECEIPTS WHERE INVENTORY ISSUE/RECEIPT = NO,
                  I.E., INSTEAD OF 'RECEIVING' PARTS, THEY ARE ABOUT
                  TO BE TRANSFERRED BETWEEN A SUPPLIER SITE/LOCATION AND
                  AN INTERNAL WAREHOUSE SITE/LOCAION. */

               else if pod_fsm_type <> ""
                    and    pod_type <> "M"
                    then do:
                       {gprun.i ""fsrtved.p""
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
                                   output errloc)"}
                       if undotran then do:
                          {pxmsg.i
                           &MSGNUM=msgnbr
                           &ERRORLEVEL={&INFORMATION-RESULT}
                           &MSGARG1=errsite
                           &MSGARG2=errloc
                           &MSGARG3=""""}
                       undo locloop,retry.
                       end. /* IF UNDOTRAN */
               end. /* ELSE IF POD_FSM_TYPE <> "" */
               /*@MODULE RTS END*/

               if pod_type = "" then do:
                  {pxrun.i &PROC='validateReceiptToPOSiteTransfer'
                           &PROGRAM='porcxr2.p'
                           &PARAM="(input rct_site,
                                    input site,
                                    input transtype,
                                    input pt_loc,
                                    input location,
                                    input global_part,
                                    input lotserial,
                                    input lotref,
                                    input (lotserial_qty * trans_conv),
                                    input trans_um,
                                    input ponbr,
                                    input poline)"
                           &NOAPPERROR=True
                           &CATCHERROR=True
                  }
                  if return-value <> {&SUCCESS-RESULT} then undo locloop, retry.
               end.  /* if pod_type = "" */

               {pxrun.i &PROC='readFirstDetailForLine' &PROGRAM='porcxr2.p'
                        &PARAM="(input integer(cline),
                                 buffer sr_wkfl,
                                 input {&LOCK_FLAG},
                                 input {&WAIT_FLAG})"
                        &NOAPPERROR=True
                        &CATCHERROR=True
               }

               if lotserial_qty = 0 then do:
                  if available sr_wkfl then do:
                     total_lotserial_qty = total_lotserial_qty - sr_qty.
                     delete sr_wkfl.
                  end. /* IF AVAILABLE SR_WKFL */
               end. /* IF LOTSERIAL_QTY = 0 */
               else do:
                  if available sr_wkfl then
                     assign
                        total_lotserial_qty = total_lotserial_qty - sr_qty
                                            + lotserial_qty
                        sr_site = site
                        sr_loc = location
                        sr_lotser = lotserial
                        sr_ref = lotref
                        sr_vend_lot = pod__qad04[1]
                        sr_qty = lotserial_qty.
                  else do:
                     {pxrun.i &PROC='createPOReceiptDetail' &PROGRAM='porcxr2.p'
                              &PARAM="(buffer sr_wkfl,
                                       input mfguser,
                                       input integer(cline),
                                       input site,
                                       input location,
                                       input lotserial,
                                       input lotref,
                                       input """",
                                       input lotserial_qty)"
                              &NOAPPERROR=True
                              &CATCHERROR=True
                     }
                     {pxrun.i &PROC='processRead' &PROGRAM='porcxr2.p'
                              &PARAM="(input mfguser,
                                       input integer(cline),
                                       input site,
                                       input location,
                                       input lotserial,
                                       input lotref,
                                       buffer sr_wkfl,
                                       input {&LOCK_FLAG},
                                       input {&WAIT_FLAG})"
                              &NOAPPERROR=True
                              &CATCHERROR=True
                     }
                     assign
                        sr_vend_lot = pod__qad04[1].

                     total_lotserial_qty = total_lotserial_qty
                                         + lotserial_qty.

                     if recid(sr_wkfl) = -1 then .
                  end. /* ELSE DO: */
               end. /* IF LOTSERIAL_QTY <> 0 */

               if porec or is-return then do:

                  {pxrun.i &PROC='validateSingleItemOrLotSerialLocation'
                           &PROGRAM='porcxr2.p'
                           &PARAM="(input site,
                                    input location,
                                    input lotserial,
                                    input lotref,
                                    input pod_nbr,
                                    input pod_line,
                                    input yes)"
                           &NOAPPERROR=True
                           &CATCHERROR=True
                  }
                  if return-value <> {&SUCCESS-RESULT} then
                     undo locloop, retry.
               end. /* IF POREC OR IS-RETURN */

               /*@MODULE TAXES BEGIN*/
               /* IF SITE CHANGED ALLOW USER TO CHANGE TAX ENVIRONMENT */
               if site <> pod_site and {txnew.i} and pod_taxable then do:
                  undo-taxes = true.
                  {gprun.i ""poporctx.p""
                           "(input recid(po_mstr),
                             input site,
                             input pod_site,
                             input pod_taxable,
                             input pod_taxc,
                             input-output pod_tax_usage,
                             input-output pod_tax_env,
                             input-output pod_tax_in,
                             input-output undo-taxes)"}
                  if undo-taxes then undo locloop, retry.
               end. /* IF SITE <> POD_SITE AND {TXNEW.I} AND POD_TAXABLE */
               /*@MODULE TAXES END*/
            end. /* ELSE IF NOT MULTI_ENTRY */

            /*mxb - this can stay in chui because porcat02.p will be
            restructured to expose logic to XUI*/
            /*SET AND UPDATE INVENTORY DETAIL ATTRIBUTES*/
            find first attr_wkfl
               where chg_line = string(pod_line) exclusive-lock no-error.
            if available attr_wkfl and pod_type = "" then do:
               {gprun.i ""porcat02.p""
                        "(input  recid(pod_det),
                          input  chg_attr,
                          input  eff_date,
                          input-output chg_assay,
                          input-output chg_grade,
                          input-output chg_expire,
                          input-output chg_status,
                          input-output assay_actv,
                          input-output grade_actv,
                          input-output expire_actv,
                          input-output status_actv)"}

               /*TEST FOR ATTRIBUTE CONFLICTS*/
               {pxrun.i &PROC='validateAttributes' &PROGRAM='porcxr1.p'
                        &PARAM="(buffer pod_det,
                                 input  eff_date,
                                 input  chg_assay,
                                 input  chg_grade,
                                 input  chg_expire,
                                 input  chg_status,
                                 input  assay_actv,
                                 input  grade_actv,
                                 input  expire_actv,
                                 input  status_actv)"
                        &NOAPPERROR=True
                        &CATCHERROR=True
               }
               if return-value <> {&SUCCESS-RESULT} then do:
                  next-prompt site.
                  undo locloop, retry.
               end.

            end. /* IF AVAIL ATTR_WKFL..*/

            /*@MODULE PRM BEGIN*/
            if porec and prm-avail then do:
               run validate-prm-records.

               if invalid-prm-po-ln-rcpt then
                  undo locloop, retry.

            end.  /* IF POREC AND PRM-AVAIL */
            /*@MODULE PRM END*/
         end. /* LOCLOOP: DO ON ERROR..*/

         pod_qty_chg = total_lotserial_qty.

         /*@TO-DO  need to call this in xui.*/
         /* CHECK OPERATION QUEUE QTY'S */
         {gprun.i ""poporca6.p""
                  "(input ""receipt"",
                    input pod_nbr,
                    input wolot,
                    input woop,
                    input move)"}
         /*@TO-DOEND*/

         {pxrun.i &PROC='setTotalReceived' &PROGRAM='porcxr1.p'
                  &PARAM="(input use_pod_um_conv,
                          input total_lotserial_qty,
                          input conv_to_pod_um,
                          input pod_qty_rcvd,
                          input pod_um_conv,
                          output total_received)"
                  &NOAPPERROR=True
                  &CATCHERROR=True
         }

         /* If it's an RTS shipment(issue) all pod_det qty fields are */
         /* expressed in negative numbers.  For correct calculations  */
         /* of pod_bo_chg and ultimately tr_hist back order qty,      */
         /* switch the sign of total_received.                        */

         /*@MODULE RTS BEGIN*/
         if pod_rma_type = "O" then
            total_received = total_received * -1.
         /*@MODULE RTS END*/

         {pxrun.i &PROC='setBackOrder' &PROGRAM='porcxr1.p'
                  &PARAM="(input cancel_bo,
                           input total_received,
                           input eff_date,
                           input conv_to_pod_um,
                           buffer pod_det,
                           input total_lotserial_qty,
                           input-output qopen)"
                  &NOAPPERROR=True
                  &CATCHERROR=True
         }

         assign
            pod_rum_conv = conv_to_pod_um
            pod_rum = receipt_um
            pod_ps_chg = packing_qty.

         /* Only update blanket order if user requests update */
         updt_blnkt = no.

         /*@MODULE wiplottrace BEGIN*/
         if pod_type = 's' then do:
            run check_and_get_wip_lots
              (input recid(pod_det),
               input wolot, input woop,
               input move,
               output undo_all).

            if undo_all then undo lineloop, retry lineloop.
         end. /* IF POD_TYPE = 'S' */
         /*@MODULE wiplottrace END*/

         /* UPDT_BLNKT_LIST IS A COMMA SEPARATED LIST OF ALL POD_LINE
            NUMBERS WHICH MUST HAVE THE BLANK PO RELEASE QUANTITY UPDATED

            IF THE USER IS MODIFYING THE RECORD, IT IS POSSIBLE THAT
            OF UPDT_BLNK_LIST HAS BEEN PRVIOUSLY UPDATED TO SHOW UPDT_BLNK =
            YES, IF SO, REMOVE ANY PREVIOUSLY FLAG SETTINGS BECUASE THE USER
            WILL BE PROMPTED AGAIN.
            W-INT1 = THE POSITION THE LINE NUMBER NEEDING REMOVAL STARTS ON
            W-INT2 = THE POSITION THE COMMA AFTER THE LINE NUMBER IS ON
         */

         /*@TO-DO need call poporca4.p in xui*/
         if can-do(updt_blnkt_list,string(pod_line)) then
            assign
               w-int1 = index(updt_blnkt_list, string(pod_line))
               w-int2 = (index(substring(updt_blnkt_list,w-int1),
                         ",")) + w-int1 - 1
               updt_blnkt_list =
                        substring(updt_blnkt_list,1,w-int1 - 1) +
                        substring(updt_blnkt_list,w-int2 + 1).

            /* OVER-RECEIPT TOLERANCE CHECKS */
            if pod_sched or (not pod_sched and
               (total_received > pod_qty_ord and pod_qty_ord > 0) or
               (total_received < pod_qty_ord and pod_qty_ord < 0)) then do:

               pod_recno = recid(pod_det).
               {gprun.i ""poporca4.p"" "(output yn)"}
               if yn then undo lineloop, retry lineloop.
            end. /* IF POD_SCHED OR (NOT POD_SCHED AND */
         /*@TO-DOEND*/

            if cmmt_yn then do:
               run hide-frames.

               assign
                  cmtindx = pod_cmtindx
                  /*@TO-DO - master comments defaults*/ /*mxb*/
                  global_ref
                          = caps(getTermLabel("RCPT",8)) + ": ":U + pod_nbr + "/" + string(pod_line).
                  /*@TO-DOEND*/

               {gprun.i ""gpcmmt01.p"" "(input ""pod_det"")"}
               pod_cmtindx = cmtindx.
            end. /* IF CMMT_YN */

            /*@MODULE PRM BEGIN*/
            if porec and prm-avail then
               run display-pao-lines.
            /*@MODULE PRM END*/

         end. /* DO TRANSACTION */
      end. /* lineloop: repeat: */

      if not batchrun then do:
         do on endkey undo edit-loop, leave edit-loop:
/*M0RJ*/    assign
/*M0RJ*/       l_remove_srwkfl = yes
               yn              = yes.
            if porec then
               /* DISPLAY PURCHASE ORDER LINES BEING RECEIVED? */
               msgnbr  = 340.
            else
               /* DISPLAY ITEMS BEING ISSUED? */
               msgnbr  = 636.

            {pxmsg.i
               &MSGNUM=msgnbr
               &ERRORLEVEL={&INFORMATION-RESULT}
               &CONFIRM=yn}
            /* Display purchase order lines being received ? */

            if yn then do:
               run hide-frames.

               for each pod_det
                  fields (pod_bo_chg pod_cmtindx pod_due_date
                          pod_fsm_type pod_line pod_lot_rcpt
                          pod_nbr pod_op pod_part pod_project
                          pod_ps_chg pod_qty_chg pod_qty_ord
                          pod_qty_rcvd pod_rma_type pod_rum
                          pod_rum_conv pod_sched pod_site
                          pod_status pod_taxable pod_taxc
                          pod_tax_env pod_tax_in pod_tax_usage
                          pod_type pod_um pod_um_conv pod_vpart
                          pod_wo_lot)
                  where pod_nbr = po_nbr and pod_status <> "c"
                    and pod_status <> "x" and pod_qty_chg <> 0 no-lock
                  use-index pod_nbrln ,
                  each sr_wkfl
                  fields(sr_lineid sr_loc sr_lotser sr_qty sr_ref
                         sr_site sr_userid sr_vend_lot) no-lock
                  where sr_userid = mfguser
                    and sr_lineid = string(pod_line) with width 80:

                  display
                     pod_line
                     pod_part
                     sr_site
                     sr_loc column-label {&poporca_p_12}
                     sr_lotser column-label {&poporca_p_10} format "x(22)"
                     sr_qty with frame e.

                  if sr_ref <> "" or sr_vend_lot <> "" then do:
                     down 1 with frame e.
                     display
                        sr_ref @ sr_loc
                        sr_vend_lot @ sr_lotser with frame e.
                  end. /* IF SR_REF <> "" OR SR_VEND_LOT <> "" */

                  down 1 with frame e.
               end. /* FOR EACH POD_DET..*/
            end. /* IF YN */
         end. /* DO ON ENDKEY..*/

         do on endkey undo edit-loop, leave edit-loop:
            assign
               proceed = no
               yn      = yes.
            /* IS ALL INFORMATION CORRECT */
         /*V8-*/
                  {mfmsg01.i 12 1 yn} /* Is all information correct */
         /*V8+*/ /*V8! {mfgmsg10.i 12 1 yn} /*Is all info correct */
                       if yn = ? then
                         undo edit-loop, leave edit-loop. */
/*M0RJ*/    l_remove_srwkfl = no.

            if yn then do:
               /* CHECK FOR RECEIPTS OF DIFFERENT ITEMS ON A   */
               /* SINGLE ITEM LOCATION                         */

               for each sr_wkfl
                  fields (sr_lineid sr_loc sr_lotser sr_qty
                          sr_ref sr_site sr_userid sr_vend_lot)
                  where sr_userid = mfguser no-lock:

                  {pxrun.i &PROC='validateSingleItemOrLotSerialLocation'
                           &PROGRAM='porcxr2.p'
                           &PARAM="(input sr_site,
                                    input sr_loc,
                                    input sr_lotser,
                                    input sr_ref,
                                    input po_nbr,
                                    input integer(sr_lineid),
                                    input no)"
                           &NOAPPERROR=True
                           &CATCHERROR=True
                  }
                  if return-value <> {&SUCCESS-RESULT} then
                     undo edit-loop, retry edit-loop.

               end.  /* FOR EACH SR_WKFL */

/*N0WT*/       {&POPORCA-P-TAG2}
               proceed = yes.
               leave.
            end.  /* IF YN */
         end. /* do on endkey..*/
      end. /* if not batchrun */
      else do:
         proceed = yes.
         leave.
      end. /* else do: */
   end. /* edit-loop */

   run hide-frames.

/*M0RJ*/ if l_remove_srwkfl
/*M0RJ*/ then do:
/*M0RJ*/    for each sr_wkfl exclusive-lock where sr_userid = mfguser:
/*M0RJ*/       delete sr_wkfl.
/*M0RJ*/    end. /* FOR EACH sr_wkfl */
/*M0RJ*/ end. /* IF l_remove_srwkfl */

/*MAIN-END*/

/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */

/*============================================================================*/
PROCEDURE build-prm-temp-table :

/*------------------------------------------------------------------
PURPOSE :   Build the temp table required for PRM records.
PARAMETERS:
NOTES:      Added for ECO N05Q to help reduce action segment size.
Last change:  SMC  25 May 2000    4:03 pm
-----------------------------------------------------------------*/

   /* CREATE TEMP-TABLE RECORD FOR PO LINE WHEN */
   /* PRM MODULE IS ENABLED AND PO LINE IS      */
   /* LINKED TO A PRM PROJECT LINE              */

   if prm-avail and porec then
      for each pod_det no-lock
         where pod_nbr = po_mstr.po_nbr:

         if pod_status = "c"
            or pod_status = "x" then next.

         if pod_rma_type <> "I"
            and pod_rma_type <> "" then next.

         if prm-avail
            and pod_det.pod_project  <> ""
            and pod_det.pod_pjs_line <> 0 then do:

            {gprunmo.i
               &program=""pjporca1.p""
               &module="PRM"
               &param="""(buffer pod_det)"""}
         end.  /*  IF PRM-AVAIL */
      end. /* FOR EACH POD_DET */

END PROCEDURE.

/*============================================================================*/
PROCEDURE check_and_get_wip_lots :
/*------------------------------------------------------------------------------
<Comment1>
poporca.tag.p
check_and_get_wip_lots (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   define input parameter ip_pod_recid as recid no-undo.
   define input parameter ip_wo_id as character no-undo.
   define input parameter ip_wo_op as integer no-undo.
   define input parameter ip_move as logical no-undo.
   define output parameter op_undo_all as logical no-undo.

   define variable rejected as logical no-undo.

   find pod_det where recid(pod_det) = ip_pod_recid exclusive-lock.

   for first po_mstr where po_nbr = pod_nbr no-lock:
   end. /* for first po_mstr where po_nbr = pod_nbr no-lock: */

   for first wo_mstr
      where wo_lot = ip_wo_id
        and wo_nbr = "" no-lock:
   end. /* FOR FIRST WO_MSTR */

   if not available wo_mstr then leave.

   for first wr_route
      where wr_lot = ip_wo_id and wr_op = ip_wo_op
      no-lock:
   end. /* FOR FIRST WR_ROUTE */

   if not available wr_route then leave.

   if not wr_milestone then do:
      /* MESSAGE #560 - OPERATION NOT A MILESTONE */
      {pxmsg.i
         &MSGNUM=560
         &ERRORLEVEL={&WARNING-RESULT}}

      if is_wiplottrace_enabled() then do:
         if prev_milestone_operation(ip_wo_id, ip_wo_op) <> ?
            and is_operation_queue_lot_controlled(ip_wo_id,
                prev_milestone_operation(ip_wo_id, ip_wo_op),OUTPUT_QUEUE)
         then do:
            /* WIP LOT TRACE IS ENABLED AND OPERATION IS A NON-MILESTONE*/
            {pxmsg.i
               &MSGNUM=8465
               &ERRORLEVEL={&APP-ERROR-RESULT}}
            op_undo_all = true.
            leave.
         end. /* IF PREV_MILESTONE_OPERATION(IP_WO_ID, IP_WO_OP) <> ? */
      end. /* IF IS_WIPLOTTRACE_ENABLED() */
   end. /* IF NOT WR_MILESTONE */

   {gprun.i ""recrtcl.p""
            "(input wo_lot,
              input ip_wo_op,
              input yes,
              input pod_qty_chg * pod_um_conv * pod_rum_conv,
              input eff_date,
              input yes, input wr_wkctr,
              output rejected,
              output lotserials_req)"}

   if rejected then do:
      assign
         mess_desc =
          getTermLabel("FOR_PO_LINE",13) + ": ":U + STRING(pod_line)
          + " ":U + getTermLabel("CUMULATIVE_ID",7) + ": ":U + ip_wo_id
          + " ":U + getTermLabel("OP",4) + ": ":U + STRING(ip_wo_op).

      if lotserials_req then do:
         /* LOT/SERIAL NUMBER REQUIRED */
         {pxmsg.i
            &MSGNUM=1119
            &ERRORLEVEL={&APP-ERROR-RESULT}
            &MSGARG1=mess_desc}
      end. /* IF LOTSERIALS_REQ */
      else do:
         /* INVALID INVENTORY FOR BACKFLUSH */
         {pxmsg.i
            &MSGNUM=1989
            &ERRORLEVEL={&APP-ERROR-NO-REENTER-RESULT}
            &MSGARG1=mess_desc}
      end. /* ELSE DO: */

      /* PLEASE BACKFLUSH COMPONENTS MANUALLY */
      {pxmsg.i
         &MSGNUM=1988
         &ERRORLEVEL={&APP-ERROR-RESULT}}
   end. /* IF REJECTED */
   else do:
      if is_wiplottrace_enabled()
         and is_operation_queue_lot_controlled(ip_wo_id,
             ip_wo_op,OUTPUT_QUEUE) then do:

         run get_poline_porcv_wip_lots_from_user in h_wiplottrace_procs
            (input pod_nbr,
             input pod_line,
             input ip_wo_id,
             input ip_wo_op,
             input pod_qty_chg,
             input pod_um_conv * pod_rum_conv,
             input pod_rum,
             input ip_move,
             input wo_site,
             input po_vend,
             input '',
             output op_undo_all) .
      end. /* IF IS_WIPLOTTRACE_ENABLED */
   end. /* ELSE DO: */

END PROCEDURE.

/*============================================================================*/
PROCEDURE display-detail :

/*------------------------------------------------------------------
PURPOSE :   Display details in frame d.
PARAMETERS:
NOTES:      Added for ECO N05Q to help reduce action segment size
------------------------------------------------------------------*/

   display
      line
      pod_det.pod_qty_chg @ lotserial_qty
      pod_det.pod_ps_chg  @ packing_qty
      ln_stat             @ cancel_bo
      pod_det.pod_part
      pod_det.pod_vpart
      pod_det.pod_rum     @ receipt_um
      pod_det.pod_wo_lot  @ wolot
      pod_det.pod_op      @ woop
   with frame d.

END PROCEDURE.

/*============================================================================*/
PROCEDURE display-pao-lines :

/*------------------------------------------------------------------
PURPOSE :   Display the PRM Project Activity Order Lines attached that
can be linked to the project line..
PARAMETERS:
NOTES:      Added for ECO N05Q to help reduce action segment size.
------------------------------------------------------------------*/

   for first ttpao-det fields() no-lock
      where ttpao-recno = recid(pod_det):

      hide frame c no-pause.
      hide frame d no-pause.

      /* SELECT PAO LINES LINKED TO PROJECT LINE */
      /* ON WHICH PAR IS TO BE PERFORMED         */
      {gprunmo.i
         &program=""pjporpas.p""
         &module="PRM"
         &param="""(input lotserial_qty,
                    buffer pod_det)"""}

      view frame c.
      view frame d.
   end. /* FOR FIRST TTPAO-DET */

END PROCEDURE.

/*============================================================================*/
PROCEDURE hide-frames :

/*------------------------------------------------------------------
PURPOSE :   Hides the frames c, d and cship.
PARAMETERS:
NOTES:      Added for ECO N05Q to help reduce action segment size
------------------------------------------------------------------*/
   hide frame c     no-pause.
   hide frame cship no-pause.
   hide frame d     no-pause.

END PROCEDURE.

/*============================================================================*/
PROCEDURE init_poline_bkfl_input_output :
/*------------------------------------------------------------------------------
/* TO INITIALIZE WIP LOT TRACE TEMP TABLES*/
poporca.tag.p
init_poline_bkfl_input_output (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   run init_poline_bkfl_input_wip_lot in h_wiplottrace_procs.

   run init_poline_bkfl_output_wip_lot in h_wiplottrace_procs.

END PROCEDURE.

/*============================================================================*/
PROCEDURE save-receipt-qty :

/*------------------------------------------------------------------
PURPOSE :   Stores the receipt quantity entered into the PRM
temp-table ttprm-det for later reference.
PARAMETERS:
NOTES:
------------------------------------------------------------------*/
   for first ttprm-det exclusive-lock
      where ttprm-nbr  = pod_det.pod_nbr
        and ttprm-line = pod_det.pod_line:

      ttprm-qty = lotserial_qty.
   end. /* FOR FIRST TTPRM-DET */

END PROCEDURE.

/*============================================================================*/
PROCEDURE validate-prm-records :

/*------------------------------------------------------------------
PURPOSE :   Validates the PRM records associated with the purchase
order lines.
PARAMETERS:
NOTES:      Added for ECO N05Q to help reduce action segment size
------------------------------------------------------------------*/

   /* PERFORM PRM VALIDATIONS ON PO LINE RECEIPT */
   {gprunmo.i
      &program=""pjporvil.p""
      &module="PRM"
      &param="""(input site,
                 input location,
                 output invalid-prm-po-ln-rcpt,
                 buffer pod_det)"""}

END PROCEDURE.