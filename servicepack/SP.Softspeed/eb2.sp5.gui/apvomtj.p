/* GUI CONVERTED from apvomtj.p (converter v1.77) Wed Oct 22 22:38:13 2003 */
/* apvomtj.p - AP VOUCHER MAINTENANCE Auto receiver matching.                 */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* $Revision: 1.36.1.2 $                                                             */
/*!
 * Controls the Range selection criteria for selecting Receivers for
 * vouchering.
 *
 * Input parameters:
 *      ap_recno
 *      ap_total
 *
 */
/*                                                                            *//*                                                                            */
/* REVISION: 7.4      CREATED:       08/06/93            BY: pcd *H199*       */
/*                                   03/08/94            BY: dpm *H075*       */
/*                                   04/04/94            BY: pcd *H317*       */
/*                                   07/22/94            by: pmf *FP44*       */
/*                                   10/10/94            by: bcm *H558*       */
/*                                   04/19/95            by: dpm *H0CT*       */
/*                                   01/05/96            by: mys *H0J2*       */
/* REVISION: 8.5                     03/06/95            BY: dpm *J044*       */
/* REVISION: 8.5      LAST MODIFIED: 03/29/95            by: dzn *F0PN*       */
/* REVISION: 8.5      LAST MODIFIED: 09/30/95            by: mwd *J053*       */
/* REVISION: 8.5      LAST MODIFIED: 12/16/96            by: rxm *J1C6*       */
/* REVISION: 8.5      LAST MODIFIED: 01/13/97            by: bkm *J1F3*       */
/* REVISION: 8.5      LAST MODIFIED: 10/03/97   BY: *J22C* Irine D'mello      */
/* REVISION: 8.5      LAST MODIFIED: 01/15/98   BY: *J2B1* Irine D'mello      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 04/10/98   BY: *L00K* RVSL               */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* Pre-86E commented code removed, view in archive revision 1.11              */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 02/02/99   BY: *J36W* Prashanth Narayan  */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* Jacolyn Neder      */
/* REVISION: 9.1      LAST MODIFIED: 11/20/00   BY: *M0WQ* Rajesh Lokre       */
/* Revision: 1.22        BY: Katie Hilbert        DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.23        BY: Ed van de Gevel      DATE: 06/29/01  ECO: *N0ZX* */
/* Revision: 1.24        BY: Steve Nugent         DATE: 04/17/02  ECO: *P043* */
/* Revision: 1.25        BY: Steve Nugent         DATE: 05/27/02  ECO: *P076* */
/* Revision: 1.28        BY: Samir Bavkar         DATE: 03/12/02  ECO: *P04G* */
/* Revision: 1.30        BY: Samir Bavkar         DATE: 06/20/02  ECO: *P09D* */
/* Revision: 1.31        BY: Luke Pokic           DATE: 07/01/02  ECO: *P09Z* */
/* Revision: 1.32        BY: Samir Bavkar         DATE: 07/16/02  ECO: *P0BK* */
/* Revision: 1.33        BY: Patrick Rowan        DATE: 11/18/02  ECO: *P0K4* */
/* Revision: 1.35        BY: Robin McCarthy       DATE: 02/28/03  ECO: *P0M9* */
/* Revision: 1.36        BY: Jyoti Thatte         DATE: 03/14/03  ECO: *P0MX* */
/* $Revision: 1.36.1.2 $       BY: Deepali Kotavadekar  DATE: 10/22/03  ECO: *P13S* */
/* $Revision: 1.36.1.2 $       BY: Bill Jiang  DATE: 07/30/06  ECO: *SS - 20060730.1* */

/* SS - 20060730.1 - B */
/*
1. 更正了"自动选择"的BUG
*/
/* SS - 20060730.1 - E */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{cxcustom.i "APVOMTJ.P"}
{apconsdf.i}

/* GET AUTHORIZED ENTITIES FOR THE USER */
{glsec.i}

/* DEFINE GPRUNP VARIABLES OUTSIDE OF INTERNAL PROCEDURES */
{gprunpdf.i "mcpl" "p"}

/* IF ip_select_logistics_charge is yes LOGISTICS CHARGES WILL BE */
/* SELECTED, ELSE RECEIVERS WILL BE SELECTED.                      */

define input  parameter ip_select_logistics_charge like mfc_logical no-undo.

/* ip_incl_blank_suppliers IS USED FOR LOGISTICS CHARGES ONLY (NOT RECEIVERS)*/
/* IF YES ALL PVO MASTER RECORDS THAT HAVE SUPPLIER = ap_vend OR HAVE A BLANK */
/* SUPPLIER ARE SELECTED */
/* IF NO ONLY PVO RECORDS THAT HAVE SUPPLIER = ap_vend ARE SELECTED */

define input  parameter ip_incl_blank_suppliers    like mfc_logical no-undo.

define output parameter process_sel like mfc_logical.

define shared variable ap_recno as recid.
define shared variable vo_recno as recid.
define shared variable aptotal  like ap_amt.
define shared variable rndmthd  like rnd_rnd_mthd.
define shared variable ap_amt_fmt as character no-undo.

define variable trdate       as date label "Date" no-undo.
define variable trdate1      as date no-undo.
define variable ext_ref      like pvo_external_ref label "External Ref" no-undo.
define variable ext_ref1     like pvo_external_ref no-undo.
define variable int_ref      like pvo_internal_ref label "Internal Ref" no-undo.
define variable int_ref1     like pvo_internal_ref no-undo.
define variable ship_from    like pvo_shipfrom no-undo.
define variable ship_from1   like pvo_shipfrom no-undo.
define variable ship_to      like pvo_shipto no-undo.
define variable ship_to1     like pvo_shipto no-undo.
define variable order        like pvo_order no-undo.
define variable order1       like pvo_order no-undo.
define variable item         like pvo_part no-undo.
define variable item1        like pvo_part no-undo.
define variable buyer        like prh_buyer no-undo.
define variable approved     like prh_approve no-undo.
define variable vo_open      like mfc_logical label "Voucher Open Qty/Amt"
   initial no.
define variable sel_all      like mfc_logical initial no.
define variable sel_stat     as character.
define variable rndamt       like glt_amt.
define variable open_amt_fmt  as character.
define variable sel_total_fmt as character.

define variable apwork-recno  as recid.
define variable apselected    as logical initial false.
define variable first_sw_call as logical initial true.

define variable sel_recs      as integer.
define variable sel_total     like ap_amt.
define variable open_amt      like ap_amt.
define variable supplier-part like vp_vend_part.
define variable part-desc1    like pt_desc1.
define variable part-desc2    like pt_desc2.
define variable inv-qty       like vph_inv_qty.
define variable inv-cost      like vph_inv_qty.
define variable inv-curr-amt  like vph_curr_amt.
define variable l_rcpt_rate   like vo_ex_rate  no-undo.
define variable l_rcpt_rate2  like vo_ex_rate2 no-undo.
define variable rcp_to_vo_ex_rate  like vo_ex_rate  no-undo.
define variable rcp_to_vo_ex_rate2 like vo_ex_rate2 no-undo.
define variable l_accr_rate   like vo_ex_rate  no-undo.
define variable l_accr_rate2  like vo_ex_rate2 no-undo.
define variable accr_to_vo_ex_rate  like vo_ex_rate  no-undo.
define variable accr_to_vo_ex_rate2 like vo_ex_rate2 no-undo.

define variable  l_prh_pur_cost like prh_pur_cost no-undo.
define variable  l_prh_um       like prh_um no-undo.
define variable  l_prh_curr     like prh_curr  no-undo.
define variable  l_prh_curr_amt like prh_curr_amt no-undo.
define variable  l_pvo_acct     like pvo_accrual_acct no-undo.
define variable  l_pvo_sub      like pvo_accrual_sub no-undo.
define variable  l_pvo_cc       like pvo_accrual_cc no-undo.
define variable  l_pvo_project  like pvo_project no-undo.
define variable  l_prh_rcp_date like prh_rcp_date  no-undo.
define variable  l_pvo_ex_rate  like pvo_ex_rate  no-undo.
define variable  l_pvo_ex_rate2 like pvo_ex_rate2  no-undo.
define variable  l_prh_recid    as   recid no-undo.

define variable convamt           like glt_amt       no-undo.
define variable logistics_charge  like pvo_lc_charge
   label "Logistics Charge Code" no-undo.
define variable l_entity_ok       like mfc_logical   initial Yes no-undo.

/* VARIABLEs FOR BROWSE */
define variable log_supplier as character no-undo.

{&APVOMTJ-P-TAG1}

define temp-table apautosel
   field sel_idr     as character format "x(1)"
   field order       like pvo_order
   field int_ref     like prh_receiver
   field line        like prh_line
   field part        like pvo_part
   field spart       like pvo_part
   field um          like prh_um
   field rcvd        like pvo_trans_qty
   field open_amt    like vph_amt
   field desc1       like pt_desc1
   field desc2       like pt_desc2
   field ext_ref     like pvo_external_ref
   field trans_date  like pvo_trans_date
   field ship_from   like pvo_shipfrom
   field charge      like pvo_lc_charge
   field amount      like pvo_accrued_amt
   field pvoid       like pvo_id
   field supplier    like pvo_supplier
   field prh_recno   as recid
   index i_int_ref int_ref.

/* DURING RECEIVER SELECTION THERE WOULD BE ONE apautosel WORKFILE */
/* RECORD FOR AN INTERNAL REFERENCE AND LINE COMBINATION, WHICH    */
/* MEANS THAT THERE WOULD BE MORE THAN ONE pvo_mstr CORRESPONDING  */
/* ONE apautosel RECORD, THEREFORE apautosel.pvoid WOULD BE BLANK */
/* AND THE NEW WORKFILE appvo WOULD BE USED TO FIND A pvo_id IN    */
/* THE det_loop BLOCK IN selectReceivers PROCEDURE.                */

/* DURING LOGISTICS CHARGE SELECTION EVERY PVO_MSTR RECORD SELECTED*/
/* WILL HAVE A CORRESPONDING RECORD IN apautosel WORKFILE AND HENCE*/
/* apautosel.pvoid WILL HAVE A VALID ID FROM PVO_MSTR.             */


define workfile appvo
   field appvo_id            like pvo_id
   field appvo_internal_ref  like pvo_internal_ref
   field appvo_line          like pvo_line.

/* DEFINE SELECTION PROCESS FORMS */

/* Selection Criteria */
FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
trdate           colon 19
   trdate1          colon 50        label {t001.i}
   ext_ref          colon 19
   ext_ref1         colon 50        label {t001.i}
   int_ref          colon 19
   int_ref1         colon 50        label {t001.i}
   order            colon 19
   order1           colon 50        label {t001.i}
   ship_from        colon 19
   ship_from1       colon 50        label {t001.i}
   ship_to          colon 19
   ship_to1         colon 50        label {t001.i}
   item             colon 19
   item1            colon 50        label {t001.i}
   skip (1)
   buyer            colon 19
   vo_open          colon 60
   approved         colon 19
   sel_all          colon 60        label "Select All (*)"
   logistics_charge colon 60
 SKIP(.4)  /*GUI*/
with frame sel_auto
   
   side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-sel_auto-title AS CHARACTER.
 F-sel_auto-title = (getFrameTitle("AUTOMATIC_SELECTION",39)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame sel_auto = F-sel_auto-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame sel_auto =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame sel_auto + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame sel_auto =
  FRAME sel_auto:HEIGHT-PIXELS - RECT-FRAME:Y in frame sel_auto - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME sel_auto = FRAME sel_auto:WIDTH-CHARS - .5. /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame sel_auto:handle).

/* Selection summary */
FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
vo_ref         label "Voucher"     colon 10 format "x(8)"
   aptotal                            colon 28
   sel_total      label "Selection"   colon 60
 SKIP(.4)  /*GUI*/
with frame sel_summary side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-sel_summary-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame sel_summary = F-sel_summary-title.
 RECT-FRAME-LABEL:HIDDEN in frame sel_summary = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame sel_summary =
  FRAME sel_summary:HEIGHT-PIXELS - RECT-FRAME:Y in frame sel_summary - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME sel_summary = FRAME sel_summary:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame sel_summary:handle).

/* SELECTION ITEM UNDER THE CURSOR FOR RECEIVERS */
FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
apautosel.desc1        colon 15
   apautosel.desc2        no-label format "x(10)"
   apautosel.open_amt     label "Open Amt"
 SKIP(.4)  /*GUI*/
with frame sel_item side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-sel_item-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame sel_item = F-sel_item-title.
 RECT-FRAME-LABEL:HIDDEN in frame sel_item = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame sel_item =
  FRAME sel_item:HEIGHT-PIXELS - RECT-FRAME:Y in frame sel_item - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME sel_item = FRAME sel_item:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame sel_item:handle).

/* DEFINE SCROLLING WINDOW FRAME TO TOGGLE SELECTED DOCUMENTS */
FORM /*GUI*/ 
   apautosel.sel_idr       label  "Sel"
   apautosel.order         format "X(8)"
   apautosel.int_ref
   apautosel.line
   apautosel.part          label  "Item"           format "x(15)"
   apautosel.spart         label  "Supplier Item"  format "x(15)"
   apautosel.um            label  "UM"
   apautosel.rcvd          label  "Receipt Qty"
with frame sel_receiver width 80
   title color normal
   (getFrameTitle("RECEIVER_SELECTION_MAINTENANCE",42)) THREE-D /*GUI*/.


/* SET EXTERNAL LABELS */
setFrameLabels(frame sel_receiver:handle).

/* DEFINE LOGISTICS CHARGE SELECTION MAINTENANCE FRAME */
FORM /*GUI*/ 
   apautosel.sel_idr       label  "Sel"
   apautosel.trans_date    column-label  "Date"
   apautosel.int_ref       label  "Internal Ref"  format "X(20)"
   apautosel.ext_ref       column-label  "External Ref" format "x(20)"
   apautosel.open_amt      label  "Open Amt"
with frame sel_charge width 80
   title color normal
   (getFrameTitle("LOGISTICS_CHARGE_SELECTION_MAINT",52)) THREE-D /*GUI*/.


/* SET EXTERNAL LABELS */
setFrameLabels(frame sel_charge:handle).

/* SET LABELS EXPLICITLY TO DISPLAY SHORT LABEL, OTHERWISE THE SYSTEM   */
/* RETRIEVES LONG LABEL AS THE REAL ESTATE IS AVAILABLE.                */
apautosel.trans_date:label in frame sel_charge =
   getTermLabel("DATE",8).

/* SELECTION ITEM UNDER THE CURSOR FOR LOGISTICS CHARGES  */
FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
apautosel.supplier     colon 13
   apautosel.order        colon 33
   apautosel.charge       colon 68
 SKIP(.4)  /*GUI*/
with frame sel_charge_item
   side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-sel_charge_item-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame sel_charge_item = F-sel_charge_item-title.
 RECT-FRAME-LABEL:HIDDEN in frame sel_charge_item = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame sel_charge_item =
  FRAME sel_charge_item:HEIGHT-PIXELS - RECT-FRAME:Y in frame sel_charge_item - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME sel_charge_item = FRAME sel_charge_item:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame sel_charge_item:handle).

{etvar.i} /* COMMON EURO VARIABLES */

/* FIND CONTROLLING RECORDS */
find first gl_ctrl no-lock.
find first apc_ctrl no-lock.
find ap_mstr where recid (ap_mstr) = ap_recno no-lock no-error.
find vo_mstr where recid (vo_mstr) = vo_recno no-lock no-error.

/* VOUCHER ALL FLAG ==> VOUCHER OPEN QTY */
vo_open = apc_vchr_all.

/* SET UP CURRENCY FORMATS FOR AMT FIELDS */
assign open_amt_fmt = apautosel.open_amt:format in frame sel_item
   sel_total_fmt = sel_total:format in frame sel_summary.

{gprun.i ""gpcurfmt.p"" "(input-output open_amt_fmt,
                                   input rndmthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

{gprun.i ""gpcurfmt.p"" "(input-output sel_total_fmt,
                                   input rndmthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.


assign
   apautosel.open_amt:format in frame sel_item = open_amt_fmt
   sel_total:format in frame sel_summary = sel_total_fmt
   aptotal:format in frame sel_summary = ap_amt_fmt.

/* PASS THE LOGISTICS SUPPLIER AS THE PARAMETER TO THE BROWSES BELOW TO */
/* SELECT ONLY THOSE PVO_MSTR RECORDS THAT HAVE THIS SUPPLIER.          */

log_supplier = if not ip_incl_blank_suppliers then
                  ap_vend
               else
                  "".
{gpbrparm.i &browse=aplu017.p &parm=c-brparm1 &val="ap_vend"}
{gpbrparm.i &browse=aplu017.p &parm=c-brparm2 &val="log_supplier"}
{gpbrparm.i &browse=aplu018.p &parm=c-brparm1 &val="ap_vend"}
{gpbrparm.i &browse=aplu018.p &parm=c-brparm2 &val="log_supplier"}
{gpbrparm.i &browse=aplu019.p &parm=c-brparm1 &val="ap_vend"}
{gpbrparm.i &browse=aplu019.p &parm=c-brparm2 &val="log_supplier"}
{gpbrparm.i &browse=aplu020.p &parm=c-brparm1 &val="ap_vend"}
{gpbrparm.i &browse=aplu020.p &parm=c-brparm2 &val="log_supplier"}
{gpbrparm.i &browse=aplu021.p &parm=c-brparm1 &val="ap_vend"}
{gpbrparm.i &browse=aplu021.p &parm=c-brparm2 &val="log_supplier"}
{gpbrparm.i &browse=aplu022.p &parm=c-brparm1 &val="ap_vend"}
{gpbrparm.i &browse=aplu022.p &parm=c-brparm2 &val="log_supplier"}

/* GET THE AUTOMATIC SELECTION CRITERIA */
criteria-block: /* Traps F4 for set ... */
repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

   display
      vo_open
      sel_all
   with frame sel_auto.

   set
      trdate         trdate1
      ext_ref        ext_ref1
      int_ref        int_ref1
      order                     when (ip_select_logistics_charge)
      order1                    when (ip_select_logistics_charge)
      ship_from                 when (ip_select_logistics_charge)
      ship_from1                when (ip_select_logistics_charge)
      ship_to        ship_to1
      item                      when (not ip_select_logistics_charge)
      item1                     when (not ip_select_logistics_charge)
      buyer                     when (not ip_select_logistics_charge)
      approved                  when (not ip_select_logistics_charge)
   with frame sel_auto.

   set
      vo_open
      sel_all
      logistics_charge when (ip_select_logistics_charge)
   with frame sel_auto.

   leave criteria-block.
end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* criteria-block */

/* Replace empty upper-bounds with hi-value */
if trdate     = ?      then trdate     = low_date.
if trdate1    = ?      then trdate1    = hi_date.
if ext_ref1   = ""     then ext_ref1   = hi_char.
if int_ref1   = ""     then int_ref1   = hi_char.
if order1     = ""     then order1     = hi_char.
if ship_from1 = ""     then ship_from1 = hi_char.
if ship_to1   = ""     then ship_to1   = hi_char.
if item1     = ""     then item1     = hi_char.
if sel_all            then sel_stat  = "*".
hide frame sel_auto no-pause.

/* Initialize selected records counter */
sel_recs = 0.


 /* MOVED THE ENTIRE CODE SECTION TO THE INTERNAL PROCEDURE       */
 /* SelectReceivers and ADDED A NEW INTERNAL PROCEDURE FOR        */
 /* AUTO SELECTION OF PENDING VOUCHERS FOR LOGISTICS CHARGES.     */

 /* IF PURCHASE ORDERS ARE ATTACHED LOAD THE PENDING VOUCHERS FOR */
 /* RECEIVER LINES, ELSE LOAD THE PENDING VOUCHERS FOR LOGISTICS  */
 /* CHARGES.                                                      */

if (not ip_select_logistics_charge) then do:
  run selectReceivers
      (input ap_recno,
       input vo_recno).
end. /* IF NOT ip_select_logistic_charge */
else do:
  run selectLogisticsCharge
      (input ap_recno,
       input vo_recno).
end. /* IF SELECT LOGISTICS CHARGES */

/* SET RETURN VALUE */
process_sel = apselected.


 /* ADDED INTERNAL PROCEDURE TO SELECT PENDING VOUCHERS FOR */
 /* RECEIVERS.                                              */
procedure selectReceivers:

   define input parameter ip_ap_recno as recid.
   define input parameter ip_vo_recno as recid.

   find ap_mstr where recid (ap_mstr) = ap_recno no-lock no-error.
   find vo_mstr where recid (vo_mstr) = vo_recno no-lock no-error.

   for each vpo_det where vpo_ref = vo_ref no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

      for each pvo_mstr where
               pvo_order = vpo_po                          and
               pvo_last_vo = ""                            and
               pvo_lc_charge = ""                          and
               pvo_internal_ref_type = {&TYPE_POReceiver}  and
               pvo_trans_qty - pvo_vouchered_qty <> 0      and
               trdate     <= pvo_trans_date                and
               trdate1    >= pvo_trans_date                and
               ext_ref    <= pvo_external_ref              and
               ext_ref1   >= pvo_external_ref              and
               int_ref    <= pvo_internal_ref              and
               int_ref1   >= pvo_internal_ref              and
               ship_to    <= pvo_shipto                    and
               ship_to1   >= pvo_shipto                    and
               item       <= pvo_part                      and
               item1      >= pvo_part                      and
               (buyer     = pvo_buyer  or buyer = "")      and
               (approved  = pvo_approver  or approved = "")
         no-lock
         break by pvo_order by pvo_internal_ref by pvo_line:

         l_entity_ok = yes.

         /* CHECK IF USER IS AUTHORIZED FOR THE RECEIVER ENTITY  */
         for first prh_hist
            fields (prh_nbr prh_receiver prh_line prh_site)
            where prh_nbr      = pvo_order
            and   prh_receiver = pvo_internal_ref
            and   prh_line     = pvo_line
            no-lock:

            run validateEntity
               (input  prh_site,
                output l_entity_ok).

         end. /* FOR FIRST prh_hist */

         /* THE BREAK BY EVALUATES TO A UNIQUE COMBINATION FOR   */
         /* EACH RECORD FETCHED. HENCE USING NEXT TO EXCLUDE     */
         /* RECEIVERS BELONGING TO ENTITY THE USER IS PROHIBITED */
         /* ACCESS TO                                            */
         if not l_entity_ok
         then
            next.

         accumulate pvo_trans_qty (total by pvo_line).
         accumulate pvo_vouchered_qty (total by pvo_line).

         create appvo.
         assign
            appvo.appvo_id           = pvo_id
            appvo.appvo_internal_ref = pvo_internal_ref
            appvo.appvo_line         = pvo_line.

         {&APVOMTJ-P-TAG2}
         /* Get part description */
         find pt_mstr
            where pt_part = pvo_part
            no-lock no-error.

         if available pt_mstr
         then
            assign
               part-desc1 = pt_desc1
               part-desc2 = pt_desc2.
         else
            assign
               part-desc1 = ""
               part-desc2 = "".

         /* Get the supplier part number */
         find vp_mstr
            where vp_part = pvo_part
            and   vp_vend = pvo_supplier
            no-lock no-error.

         if available vp_mstr
         then
            supplier-part = vp_vend_part.
         else
            supplier-part = "".

         /* GET RECEIVER DATA FROM PRH_HIST */
         run getReceiverData
            (input pvo_internal_ref,
             input pvo_line,
             input ?,
             output l_prh_pur_cost,  /* PRH_PUR_COST * PRH_UM_CONV */
             output l_prh_um,
             output l_prh_curr,
             output l_prh_curr_amt,  /* PRH_CURR_AMT * PRH_UM_CONV */
             output l_pvo_acct,
             output l_pvo_sub,
             output l_pvo_cc,
             output l_pvo_project,
             output l_prh_rcp_date,
             output l_pvo_ex_rate,
             output l_pvo_ex_rate2,
             output l_prh_recid).

         /* Save matching information in the workfile */
         create apautosel.
         assign
            apautosel.sel_idr    = sel_stat
            apautosel.order      = vpo_po
            apautosel.int_ref    = pvo_internal_ref
            apautosel.ext_ref    = pvo_external_ref
            apautosel.line       = pvo_line
            apautosel.part       = pvo_part
            apautosel.spart      = supplier-part
            apautosel.um         = l_prh_um
            apautosel.rcvd       = pvo_trans_qty
            apautosel.desc1      = part-desc1
            apautosel.desc2      = part-desc2
            apautosel.prh_recno  = l_prh_recid.

         assign
            apautosel.open_amt  = (accum total by pvo_line pvo_trans_qty )
                                   * l_prh_curr_amt
            rndamt              = (accum total by pvo_line pvo_vouchered_qty)
                                   * l_prh_curr_amt.

         if recid(apautosel) = ? then .

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output apautosel.open_amt,
              input        rndmthd,
              output       mc-error-number)"}

         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output rndamt,
              input        rndmthd,
              output       mc-error-number)"}

         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

         apautosel.open_amt = apautosel.open_amt - rndamt.

         /* Count selected records */
         sel_recs = sel_recs + 1.

         /* Accumulate total selected if sel_all */
         if sel_all
         then
            sel_total = sel_total + apautosel.open_amt.

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH pvo_mstr */
   end. /* FOR EACH vpo_det */

   sw_block:
   do on endkey undo, leave:

      if sel_recs = 0 then leave.

      if not batchrun then do:

         /*DISPLAY CONTROL TOTALS FRAME*/
         display
            vo_ref
            aptotal
            sel_total
         with frame sel_summary.

         view frame sel_receiver.
         view frame sel_item.

         /* INCLUDE SCROLLING WINDOW TO ALLOW THE USER TO SCROLL      */
         /* THROUGH (AND SELECT FROM) EXISTING PAYMENTS APPLICATIONS  */
         {swselect.i
            &detfile      = apautosel
            &scroll-field = apautosel.order
            &framename    = "sel_receiver"
            &framesize    = 10
            &sel_on       = ""*""
            &sel_off      = """"
            &display1     = apautosel.sel_idr
            &display2     = apautosel.order
            &display3     = apautosel.int_ref
            &display4     = apautosel.line
            &display5     = apautosel.part
            &display6     = apautosel.spart
            &display7     = apautosel.um
            &display8     = apautosel.rcvd
            &exitlabel    = sw_block
            &exit-flag    = first_sw_call
            &record-id    = apwork-recno
            &include1     = "/* ACCUMULATE OPEN AMOUNT INTO SELECTION TOTAL */
                             sel_total = sel_total - apautosel.open_amt.
                             /* DISPLAY SUMMARY & ITEM INFORMATION */
                             display sel_total with frame sel_summary."
            &include2     = "/* ACCUMULATE OPEN AMOUNT INTO SELECTION TOTAL */
                             sel_total = sel_total + apautosel.open_amt.
                             /* DISPLAY SUMMARY & ITEM INFORMATION */
                             display sel_total with frame sel_summary."
            &include3     = "/* DISPLAY SUMMARY & ITEM INFORMATION */
                             display
                                 apautosel.desc1
                                 apautosel.desc2
                                 apautosel.open_amt
                              with frame sel_item."}
      end. /* not batchrun */

      /* ELSE BATCHRUN - WE JUST SKIPPED THE "RECEIVER SELECTION  */
      /* MAINTENANCE" FRAME BUT WE STILL NEED TO CONSUME THE      */
      /* CORRESPONDING LINE IN CIM FILE                           */
      else do:
         readkey.
         if keyfunction(lastkey) <> "RETURN" then import ^.
      end.

      /* TRAP ENDKEY */
      if keyfunction(lastkey) = "end-error"
         or lastkey = keycode("F4")
         or keyfunction(lastkey) = "."
         or lastkey = keycode("CTRL-E") then do:
         undo sw_block, leave.
      end.

      /* CREATE VPH_HIST (ATTACHED RECEIVERS) FROM SELECTION */
      det_loop:
      for each apautosel where sel_idr = "*":
/*GUI*/ if global-beam-me-up then undo, leave.

         apselected = true.

         /* GET THE PENDING VOUCHERS FOR THE SELECTED RECEIVER */
         for each appvo
             where appvo.appvo_internal_ref = apautosel.int_ref
               and appvo.appvo_line         = apautosel.line:

            for first pvo_mstr exclusive-lock
                where pvo_id  = appvo.appvo_id:
            end.

            if available pvo_mstr then do:
               create vph_hist.
               assign
                  vph_ref        = vo_ref
                  vph_pvo_id     = pvo_id
                  vph_pvod_id_line  = 0
                  vph_nbr        = apautosel.order
                  vph_inv_date   = ap_effdate
                  /* STORE TAX USAGE AND TAX CLASS */
                  vph__qadc01    = pvo_tax_usage                       +
                                   fill(" ",8 - length(pvo_tax_usage)) +
                                   pvo_taxc                            +
                                   fill(" ",3 - length(pvo_taxc)).

               run getReceiverData
                   (input "",
                    input 0,
                    input apautosel.prh_recno,
                    output l_prh_pur_cost,  /* PRH_PUR_COST * PRH_UM_CONV */
                    output l_prh_um,
                    output l_prh_curr,
                    output l_prh_curr_amt,  /* PRH_CURR_AMT * PRH_UM_CONV */
                    output l_pvo_acct,
                    output l_pvo_sub,
                    output l_pvo_cc,
                    output l_pvo_project,
                    output l_prh_rcp_date,
                    output l_pvo_ex_rate,
                    output l_pvo_ex_rate2,
                    output l_prh_recid).

               /* Calculate voucher qty and amount */
               if vo_open then
                  assign
                     inv-qty  = pvo_trans_qty - pvo_vouchered_qty
                     inv-cost = l_prh_pur_cost
                     inv-curr-amt = l_prh_curr_amt.
               else
                  assign
                     inv-qty  = 0
                     inv-cost = 0
                     inv-curr-amt = 0.

               vph_inv_qty = inv-qty.

               if l_prh_curr = vo_curr then
                  assign vph_curr_amt = inv-curr-amt.

               else do:

                  run mc_get_vo_ex_rate_at_rcpt_date.
                  run convert_receipt_to_voucher
                     (input-output inv-curr-amt).

                  assign
                     vph_curr_amt = inv-curr-amt.

               end.
               if l_prh_curr <> base_curr or l_prh_curr <> vo_curr then
                  run mc-convert-voucher-to-base
                     (input  vph_curr_amt,
                     output inv-cost).
               vph_inv_cost = inv-cost.

               assign
                  vph_acct       = l_pvo_acct
                  vph_sub        = l_pvo_sub
                  vph_cc         = l_pvo_cc
                  vph_project    = l_pvo_project.

               /* UPDATE PENDING VOUCHER RECORD */
               assign
                  pvo_vouchered_qty = pvo_vouchered_qty + vph_inv_qty
                  pvo_last_voucher  = if vo_open then vo_ref else "".

               /* UPDATE VOUCHER TOTAL */
               rndamt = (vph_inv_qty * vph_curr_amt).

               {gprunp.i "mcpl" "p" "mc-curr-rnd"
                  "(input-output rndamt,
                           input rndmthd,
                           output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.
               ap_amt = ap_amt + rndamt.

               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ap_curr,
                           input base_curr,
                           input ap_ex_rate,
                           input ap_ex_rate2,
                           input rndamt,
                           input true, /* ROUND */
                           output rndamt,
                           output mc-error-number)"}.
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.
               ap_base_amt = ap_base_amt + rndamt.

               find first iec_ctrl no-lock no-error.
               if available(iec_ctrl) and iec_use_instat then do:

                  for first prh_hist
                     fields (prh_nbr prh_line prh_receiver prh_um_conv)
                     where recid(prh_hist) = l_prh_recid
                  no-lock:
                     /* UPDATE RECEIPT IMPORT/EXPORT HISTORY RECORD (ieh_hist)
                      * WHEN INTRASTAT IS USED */
                     {gprun.i ""iehistap.p""
                              "(input pvo_order,
                                input pvo_line,
                                input pvo_internal_ref,
                                input prh_um_conv,
                                input vo_ref,
                                input vo_curr,
                                input vph_inv_qty,
                                input vph_curr_amt,
                                input ap_effdate)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  end.
               end.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF AVAILABLE PVO_MSTR */
         end. /* FOR EACH APPVO */
      end. /* FOR EACH APAUTOSEL */

      /*CHECK TO SEE IF ANY RECORDS WERE PROCESSED*/
      if not apselected then do:
         /* NO RECEIVERS SELECTED FOR PROCESSING */
         {pxmsg.i &MSGNUM=2215 &ERRORLEVEL=2}
         do on endkey undo sw_block, retry sw_block:
            pause.
         end.
         undo sw_block, retry sw_block.
      end.

      leave sw_block.
   end.  /* SW_BLOCK */

   hide frame sel_summary no-pause.
   hide frame sel_receiver no-pause.
   hide frame sel_item no-pause.

end. /*PROCEDURE - SELECTRECEIVERS */

/* ADDED INTERNAL PROCEDURE TO SELECT PENDING VOUCHERS FOR */
/* LOGISTICS CHARGES.                                      */
PROCEDURE selectLogisticsCharge:
   define input parameter ip_ap_recno as recid.
   define input parameter ip_vo_recno as recid.

   find ap_mstr where recid (ap_mstr) = ap_recno no-lock no-error.
   find vo_mstr where recid (vo_mstr) = vo_recno no-lock no-error.

   for each pvo_mstr where
            pvo_supplier = ap_vend                       and
            pvo_last_voucher = ""                        and
            (pvo_lc_charge = logistics_charge
                or logistics_charge = "")                and
            pvo_lc_charge <> ""                          and
            trdate     <= pvo_trans_date                 and
            trdate1    >= pvo_trans_date                 and
            ext_ref    <= pvo_external_ref               and
            ext_ref1   >= pvo_external_ref               and
            int_ref    <= pvo_internal_ref               and
            int_ref1   >= pvo_internal_ref               and
            ship_from  <= pvo_shipfrom                   and
            ship_from1 >= pvo_shipfrom                   and
            ship_to    <= pvo_shipto                     and
            ship_to1   >= pvo_shipto                     and
            order      <= pvo_order                      and
            order1     >= pvo_order                      and
            item       <= pvo_part                       and
            item1      >= pvo_part
      no-lock:

         l_entity_ok = yes.

         /* CHECK IF USER IS AUTHORIZED FOR THE LOGISTICS CHARGE */
         /* ENTITY AT HEADER LEVEL                               */
         run validateEntity
            (input  pvo_shipto,
             output l_entity_ok).

         if not l_entity_ok
         then
            next.

         for each pvod_det
            fields (pvod_id pvod_id_line pvod_shipto)
            where pvod_id = pvo_id
            no-lock:

            /* CHECK IF USER IS AUTHORIZED FOR THE LOGISTICS CHARGE */
            /* ENTITY AT DETAIL LEVEL                               */
            run validateEntity
               (input  pvod_shipto,
                output l_entity_ok).

            /* IF USER IS NOT AUTHORIZED FOR THE ENTITY FOR AN      */
            /* INTERMEDIATE LINE, LEAVE BEFORE THE FLAG l_entity_ok */
            /* IS CHANGED BY THE SEBSEQUENT LINES WITH ENTITIES     */
            /* TO WHICH THE USER IS AUTHORIZED TO                   */
            if not l_entity_ok
            then
               leave.

         end. /* FOR EACH pvod_det */

         if not l_entity_ok
         then
            next.

         run create_autosel (buffer pvo_mstr ,
                         input vo_curr).

   end. /* FOR EACH PVO_MSTR */


   if ip_incl_blank_suppliers then do:

      for each pvo_mstr where
               pvo_supplier = ""                            and
               pvo_last_voucher = ""                        and
               (pvo_lc_charge = logistics_charge
                   or logistics_charge = "")                and
               pvo_lc_charge <> ""                          and
               trdate     <= pvo_trans_date                 and
               trdate1    >= pvo_trans_date                 and
               ext_ref    <= pvo_external_ref               and
               ext_ref1   >= pvo_external_ref               and
               int_ref    <= pvo_internal_ref               and
               int_ref1   >= pvo_internal_ref               and
               ship_from  <= pvo_shipfrom                   and
               ship_from1 >= pvo_shipfrom                   and
               ship_to    <= pvo_shipto                     and
               ship_to1   >= pvo_shipto                     and
               order      <= pvo_order                      and
               order1     >= pvo_order                      and
               item       <= pvo_part                       and
               item1      >= pvo_part
      no-lock:

         l_entity_ok = yes.

         /* CHECK IF USER IS AUTHORIZED FOR THE LOGISTICS CHARGE */
         /* ENTITY AT HEADER LEVEL                               */
         run validateEntity
            (input  pvo_shipto,
             output l_entity_ok).

         if not l_entity_ok
         then
            next.

         for each pvod_det
            fields (pvod_id pvod_id_line pvod_shipto)
            where pvod_id = pvo_id
            no-lock:

            /* CHECK IF USER IS AUTHORIZED FOR THE LOGISTICS CHARGE */
            /* ENTITY AT DETAIL LEVEL                               */
            run validateEntity
               (input  pvod_shipto,
                output l_entity_ok).

            /* IF USER IS NOT AUTHORIZED FOR THE ENTITY FOR AN      */
            /* INTERMEDIATE LINE, LEAVE BEFORE THE FLAG l_entity_ok */
            /* IS CHANGED BY THE SEBSEQUENT LINES WITH ENTITIES     */
            /* TO WHICH THE USER IS AUTHORIZED TO                   */
            if not l_entity_ok
            then
               leave.

         end. /* FOR EACH pvod_det */

         if not l_entity_ok
         then
            next.

         run create_autosel (buffer pvo_mstr ,
                         input vo_curr).

      end. /* FOR EACH PVO_MSTR */
   end. /* if ip_incl_blank_suppliers  */

   sw_block2:
   do on endkey undo, leave:

      if sel_recs = 0 then leave.

      if not batchrun then do:

         /*DISPLAY CONTROL TOTALS FRAME*/
         display
            vo_ref
            aptotal
            sel_total
         with frame sel_summary.

         view frame sel_charge.
         view frame sel_charge_item.

         /* INCLUDE SCROLLING WINDOW TO ALLOW THE USER TO SCROLL      */
         /* THROUGH (AND SELECT FROM) EXISTING PAYMENTS APPLICATIONS  */
         {swselect.i
            &detfile      = apautosel
            &scroll-field = apautosel.int_ref
            &framename    = "sel_charge"
            &framesize    = 10
            &sel_on       = ""*""
            &sel_off      = """"
            &display1     = apautosel.sel_idr
            &display2     = apautosel.trans_date
            &display3     = apautosel.int_ref
            &display4     = apautosel.ext_ref
            &display5     = apautosel.open_amt
            &exitlabel    = sw_block2
            &exit-flag    = first_sw_call
            &record-id    = apwork-recno
            &include1     = "/* ACCUMULATE OPEN AMOUNT INTO SELECTION TOTAL */
                             sel_total = sel_total - apautosel.open_amt.
                             /* DISPLAY SUMMARY AND ITEM INFORMATION */
                             display sel_total with frame sel_summary."
            &include2     = "/* ACCUMULATE OPEN AMOUNT INTO SELECTION TOTAL */
                             sel_total = sel_total + apautosel.open_amt.
                             /* DISPLAY SUMMARY AND ITEM INFORMATION */
                             display sel_total with frame sel_summary."
            &include3     = "/* DISPLAY SUMMARY AND ITEM INFORMATION */
                             display apautosel.supplier
                             apautosel.order apautosel.charge
                             with frame sel_charge_item."}
      end. /* not batchrun */

      else do:
         readkey.
         if keyfunction(lastkey) <> "RETURN" then import ^.
      end.

      /* TRAP ENDKEY */
      if keyfunction(lastkey) = "end-error"
         or lastkey = keycode("F4")
         or keyfunction(lastkey) = "."
         or lastkey = keycode("CTRL-E") then do:
         undo sw_block2, leave.
      end.

      /* CREATE VPH_HIST (ATTACHED PENDING VOUCHERS) FROM SELECTION */
      det_loop2:
      for each apautosel where sel_idr = "*":
         apselected = true.

         for first pvo_mstr exclusive-lock
            where pvo_id  = apautosel.pvoid:
         end.

         if available pvo_mstr then
            for each pvod_det
            where pvod_id = pvo_id exclusive-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

               create vph_hist.
               assign
                  vph_ref          = vo_ref
                  vph_pvo_id       = pvo_id
                  vph_pvod_id_line = pvod_id_line
                  vph_nbr          = apautosel.order
                  vph_inv_date     = ap_effdate
                  vph_acct         = pvod_accrual_acct
                  vph_sub          = pvod_accrual_sub
                  vph_cc           = pvod_accrual_cc
                  vph_project      = pvod_project
                  vph__qadc01      = pvod_tax_usage                       +
                                     fill(" ",8 - length(pvod_tax_usage)) +
                                     pvod_taxc                            +
                                     fill(" ",3 - length(pvod_taxc)).


               /* CALCULATE VOUCHER AMOUNT */
               if vo_open then
                  inv-curr-amt = pvod_accrued_amt - pvod_vouchered_amt.
               else
                  inv-curr-amt = 0.

               /* UPDATE PENDING VOUCHER RECORD */
               assign
                  pvod_vouchered_amt = pvod_vouchered_amt + inv-curr-amt
                  pvo_vouchered_amt = pvo_vouchered_amt + inv-curr-amt
                  pvo_last_voucher  = if vo_open then vo_ref else "".

               if pvo_curr = vo_curr then
                  vph_curr_amt = inv-curr-amt.
               else do:
                  run mc_get_vo_ex_rate_at_accrual_date.
                  run convert_accrual_to_voucher
                     (input-output inv-curr-amt).

                  vph_curr_amt = inv-curr-amt.
               end.


               /* UPDATE VOUCHER TOTAL */
               ap_amt = ap_amt + vph_curr_amt.

               convamt = vph_curr_amt.

               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ap_curr,
                           input base_curr,
                           input ap_ex_rate,
                           input ap_ex_rate2,
                           input convamt,
                           input true, /* ROUND */
                           output convamt,
                           output mc-error-number)"}.
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.
               ap_base_amt = ap_base_amt + convamt.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH PVOD_DET */

      end. /* FOR EACH APAUTOSEL */

      /*CHECK TO SEE IF ANY RECORDS WERE PROCESSED*/
      if not apselected then do:
         /* NO RECEIVERS SELECTED FOR PROCESSING */
         {pxmsg.i &MSGNUM=2215 &ERRORLEVEL=2}
         do on endkey undo sw_block2, retry sw_block2:
            pause.
         end.
         undo sw_block2, retry sw_block2.
      end.

      leave sw_block2.
   end.  /* SW_BLOCK2 */

   hide frame sel_summary no-pause.
   hide frame sel_charge no-pause.
   hide frame sel_charge_item no-pause.
END PROCEDURE. /* SELECTLOGISTICSCHARGE */

PROCEDURE mc-convert-voucher-to-base:

   define input  parameter source_amount as decimal no-undo.
   define output parameter target_amount as decimal no-undo.

   /* CONVERT FROM VOUCHER TO BASE CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input vo_mstr.vo_curr,
                        input base_curr,
                        input vo_ex_rate,
                        input vo_ex_rate2,
                        input source_amount,
                        input false, /* DO NOT ROUND */
                        output target_amount,
                        output mc-error-number)"}.
   if mc-error-number <> 0 then
         run mc_warning.
END PROCEDURE. /* MC-CONVERT-VOUCHER-TO-BASE */

PROCEDURE mc_get_vo_ex_rate_at_rcpt_date:

   /* GET EXCHANGE RATE BETWEEN VOUCHER AND BASE */
   /* AS OF RECEIPT DATE                         */
   {gprunp.i "mcpl" "p" "mc-get-ex-rate"
      "(input vo_mstr.vo_curr,
                        input base_curr,
                        input vo_ex_ratetype,
                        input l_prh_rcp_date,
                        output l_rcpt_rate,
                        output l_rcpt_rate2,
                        output mc-error-number)"}
   if mc-error-number <> 0 then
         run mc_warning.

   /* COMBINE PRH-TO-BASE EX RATE WITH BASE-TO-VO EX RATE */
   {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
      "(input l_pvo_ex_rate,
              input l_pvo_ex_rate2,
              input l_rcpt_rate2,
              input l_rcpt_rate,
              output rcp_to_vo_ex_rate,
              output rcp_to_vo_ex_rate2)"}

END PROCEDURE. /* MC_GET_VO_EX_RATE_AT_RCPT_DATE */

PROCEDURE convert_receipt_to_voucher:

   define input-output parameter amt as decimal no-undo.

   /* CONVERT FROM RECEIPT TO VOUCHER CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input l_prh_curr,
               input vo_mstr.vo_curr,
               input rcp_to_vo_ex_rate,
               input rcp_to_vo_ex_rate2,
               input amt,
               input false, /* DO NOT ROUND */
               output amt,
               output mc-error-number)"}
   if mc-error-number <> 0 then
         run mc_warning.

END PROCEDURE. /* CONVERT_RECEIPT_TO_VOUCHER */

PROCEDURE mc_warning:
   {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
END PROCEDURE.

PROCEDURE mc_get_vo_ex_rate_at_accrual_date:

   /* GET EXCHANGE RATE BETWEEN VOUCHER AND BASE */
   /* AS OF ACCRUAL TRANSACTION DATE             */
   {gprunp.i "mcpl" "p" "mc-get-ex-rate"
      "(input vo_mstr.vo_curr,
        input base_curr,
        input vo_ex_ratetype,
        input pvo_mstr.pvo_trans_date,
        output l_accr_rate,
        output l_accr_rate2,
        output mc-error-number)"}
   if mc-error-number <> 0 then
         run mc_warning.

   /* COMBINE PRH-TO-BASE EX RATE WITH BASE-TO-VO EX RATE */
   {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
       "(input pvo_ex_rate,
         input pvo_ex_rate2,
         input l_accr_rate2,
         input l_accr_rate,
         output accr_to_vo_ex_rate,
         output accr_to_vo_ex_rate2)"}

END PROCEDURE. /* MC_GET_VO_EX_RATE_AT_ACCRUAL_DATE */

PROCEDURE convert_accrual_to_voucher:

   define input-output parameter amt as decimal no-undo.

   /* CONVERT FROM ACCRUAL TO VOUCHER CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input pvo_mstr.pvo_curr,
           input vo_mstr.vo_curr,
           input accr_to_vo_ex_rate,
           input accr_to_vo_ex_rate2,
           input amt,
           input false, /* DO NOT ROUND */
           output amt,
           output mc-error-number)"}
   if mc-error-number <> 0 then
         run mc_warning.

END PROCEDURE. /* CONVERT_ACCRUAL_TO_VOUCHER */

PROCEDURE getReceiverData:
   define input  parameter iReceiver       as  character no-undo.
   define input  parameter iLine           as  integer no-undo.
   define input  parameter iPrhRecid       as  recid no-undo.
   define output parameter oPurchaseCost   as  decimal  no-undo.
   define output parameter oUm             as  character  no-undo.
   define output parameter oCurr           as  character  no-undo.
   define output parameter oCurrAmt        as  decimal  no-undo.
   define output parameter oAcct           as  character  no-undo.
   define output parameter oSubAcct        as  character  no-undo.
   define output parameter oCostCenter     as  character  no-undo.
   define output parameter oProject        as  character  no-undo.
   define output parameter oRcpDate        as  date  no-undo.
   define output parameter oExRate         as  decimal  no-undo.
   define output parameter oExRate2        as  decimal  no-undo.
   define output parameter oPrhRecid       as  recid  no-undo.

   define buffer pvomstr for pvo_mstr.

   if iPrhRecid = ? then
      for first prh_hist
         fields(prh_pur_cost prh_um prh_um_conv prh_curr prh_curr_amt
                prh_rcp_date prh_receiver prh_line)
         where prh_receiver = iReceiver
           and prh_line     = iLine
         no-lock :
      end. /* FOR FIRST PRH_HIST */
   else
      for first prh_hist
         fields(prh_pur_cost prh_um prh_um_conv prh_curr prh_curr_amt
                prh_rcp_date prh_receiver prh_line)
         where recid(prh_hist) = iPrhRecid
         no-lock :
      end. /* FOR FIRST PRH_HIST */

   if available prh_hist then do:

      assign
         oPurchaseCost = prh_pur_cost * prh_um_conv
         oUm           = prh_um
         oCurr         = prh_curr
         oCurrAmt      = prh_curr_amt * prh_um_conv
         oRcpDate      = prh_rcp_date
         oPrhRecid     = recid(prh_hist).

      for first pvomstr
         where pvomstr.pvo_internal_ref_type = {&TYPE_POReceiver}
         and pvomstr.pvo_lc_charge    = ""
         and pvomstr.pvo_internal_ref = prh_receiver
         and pvomstr.pvo_line = prh_line
         no-lock:
      end.

      if available pvomstr then
         assign
            oAcct         = pvomstr.pvo_accrual_acct
            oSubAcct      = pvomstr.pvo_accrual_sub
            oCostCenter   = pvomstr.pvo_accrual_cc
            oProject      = pvomstr.pvo_project
            oExRate       = pvomstr.pvo_ex_rate
            oExRate2      = pvomstr.pvo_ex_rate2.
   end. /* If available prh_hist */
END PROCEDURE. /* getReceiverData */


PROCEDURE CREATE_AUTOSEL:

define parameter buffer pvo_mstr for pvo_mstr.
define input parameter vo_curr like vo_curr no-undo.
      /* SAVE MATCHING INFORMATION IN THE WORKFILE */
      create apautosel.
      assign
         apautosel.sel_idr    = sel_stat
         apautosel.charge     = pvo_mstr.pvo_lc_charge
         apautosel.trans_date = pvo_mstr.pvo_trans_date
         apautosel.order      = pvo_mstr.pvo_order
         apautosel.int_ref    = pvo_mstr.pvo_internal_ref
         apautosel.ext_ref    = pvo_mstr.pvo_external_ref
         apautosel.line       = pvo_mstr.pvo_line
         apautosel.part       = pvo_mstr.pvo_part
         apautosel.amount     = pvo_mstr.pvo_accrued_amt
         apautosel.desc1      = pvo_mstr.pvo_lc_charge
         apautosel.pvoid      = pvo_mstr.pvo_id
         apautosel.supplier   = pvo_mstr.pvo_supplier
         apautosel.open_amt   = (pvo_mstr.pvo_accrued_amt -
                                 pvo_mstr.pvo_vouchered_amt).

      if vo_curr <> pvo_mstr.pvo_curr then do:
         run mc_get_vo_ex_rate_at_accrual_date.
         run convert_accrual_to_voucher
            (input-output apautosel.amount).
         run convert_accrual_to_voucher
            (input-output apautosel.open_amt).
      end.

      /* CHARGE NAME IS STORED IN desc1 and CHARGE DESC IS STORED IN */
      /* desc2.                                                      */
      for first lc_mstr where lc_charge = pvo_mstr.pvo_lc_charge no-lock:
      end.
      if available lc_mstr then
         apautosel.desc2 = lc_desc.

      if recid(apautosel) = ? then .

      /* Count selected records */
      sel_recs = sel_recs + 1.

      /* Accumulate total selected if sel_all */
      if sel_all then
         sel_total = sel_total + apautosel.open_amt.
END PROCEDURE.

PROCEDURE validateEntity:

define input  parameter p_site     like prh_site                no-undo.
define output parameter p_entityok like mfc_logical initial Yes no-undo.
define buffer b_simstr for si_mstr.

   for first b_simstr
      fields (si_site si_entity)
      where b_simstr.si_site = p_site
      no-lock:

      /* SS - 20060730.1 - B */
      /*
      for first security
         where security_entity = "*"
         or    security_entity = b_simstr.si_entity
         no-lock:
      end. /* FOR FIRST security */

      if not available security
      then
         p_entityok = no.
      */
      FOR FIRST CODE_mstr
         WHERE CODE_fldname = "gluserid"
         NO-LOCK:
      END.
      IF AVAILABLE CODE_mstr THEN DO:
         for first security
            where security_entity = "*"
            or    security_entity = b_simstr.si_entity
            no-lock:
         end. /* FOR FIRST security */

         if not available security
         then
            p_entityok = no.
      END.
      /* SS - 20060730.1 - E */

   end. /* FOR EACH b_simstr */
END PROCEDURE. /* validateEntity */
