/* GUI CONVERTED from popomtd2.p (converter v1.78) Fri Oct 29 14:37:34 2004 */
/* popomtd2.p - PURCHASE ORDER MAINTENANCE MULTI LINE MODE VALIDATION         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8.2.8 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.2     LAST MODIFIED: 09/09/94    BY: dpm *FQ93**/
/* REVISION: 7.2     LAST MODIFIED: 11/09/94    BY: ljm *FT51**/
/* REVISION: 7.2     LAST MODIFIED: 04/14/95    BY: dxk *F0PY**/
/* REVISION: 7.3     LAST MODIFIED: 10/20/95    BY: ais *G19L**/
/* REVISION: 8.5     LAST MODIFIED: 10/31/95    BY: taf *J053**/
/* REVISION: 8.5     LAST MODIFIED: 03/25/96    BY: ais *G1QK**/
/* REVISION: 8.5     LAST MODIFIED: 05/22/97    BY: *J1RZ* Molly Balan        */
/* REVISION: 8.5     LAST MODIFIED: 02/11/97    BY: *J1YW* B. Gates           */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 10/01/99    BY: *N014* PATTI GAULTNEY     */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KQ* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.8.2.3    BY: Jean Miller        DATE: 05/13/02  ECO: *P05V*    */
/* Revision: 1.8.2.4    BY: Dan Herman         DATE: 06/17/02  ECO: *P091*    */
/* Revision: 1.8.2.5    BY: Shoma Salgaonkar   DATE: 12/23/02  ECO: *M21N*    */
/* Revision: 1.8.2.7    BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J*     */
/* $Revision: 1.8.2.8 $ BY: Gnanasekar         DATE: 08/05/03 ECO: *P0XW* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i}

define new shared variable err-flag as integer.
define new shared variable workord  like wo_nbr.
define new shared variable worklot  like wo_lot.
define new shared variable routeop  like wr_op.
define new shared variable workpart like wo_part.
define new shared variable workproj like wo_project.
define new shared variable subtype  as   character format "x(12)" no-undo.

define shared variable rndmthd        like rnd_rnd_mthd.
define shared variable desc1          like pt_desc1.
define shared variable desc2          like pt_desc2.
define shared variable line           like sod_line.
define shared variable due_date       like pod_due_date.
define shared variable del-yn         like mfc_logical.
define shared variable so_job         like pod_so_job.
define shared variable disc           like pod_disc_pct.
define shared variable po_recno       as recid.
define shared variable vd_recno       as recid.
define shared variable ext_cost       like pod_pur_cost.
define shared variable old_pod_status like pod_status.
define shared variable old_type       like pod_type.
define shared variable pod_recno      as recid.
define shared variable podcmmts       like mfc_logical label "Comments".
define shared variable cmtindx        as integer.
define shared variable st_qty         like pod_qty_ord.
define shared variable st_um          like pod_um.
define shared variable old_um         like pod_um.
define shared variable base_amt       like pod_pur_cost.
define shared variable clines         as integer.
define shared variable blanket        as logical.
define shared variable sngl_ln        like poc_ln_fmt.
define shared variable continue       as logical.

define variable qty_ord      like pod_qty_ord            no-undo.
define variable old_qty_ord  like pod_qty_ord            no-undo.
define variable old_pur_cost like pod_pur_cost           no-undo.
define variable old_vpart    like pod_vpart              no-undo.
define variable last_date    like pod_due_date           no-undo.
define variable yn           like mfc_logical initial no no-undo.
define variable mfgr         like vp_mfgr                no-undo.
define variable mfgr_part    like vp_mfgr_part           no-undo.
define variable old_um_conv  like pod_um_conv            no-undo.
define variable valid_acct   like mfc_logical            no-undo.
define variable old_db       like si_db                  no-undo.
define variable glvalid      like mfc_logical            no-undo.


{pocnvars.i} /* Variables for coinsignment inventory */
{pocnpo.i}  /* Procedures and frames for consignment inventory */

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_SUPPLIER_CONSIGNMENT,
     input 11,
     input ADG,
     input SUPPLIER_CONSIGN_CTRL_TABLE,
     output using_supplier_consignment)"}
/*GUI*/ if global-beam-me-up then undo, leave.


find first gl_ctrl   where gl_ctrl.gl_domain = global_domain no-lock no-error.
find first poc_ctrl  where poc_ctrl.poc_domain = global_domain no-lock no-error.
find first icc_ctrl  where icc_ctrl.icc_domain = global_domain no-lock no-error.

find po_mstr where recid(po_mstr) = po_recno no-error.
find vd_mstr where recid(vd_mstr) = vd_recno no-lock no-error.
find pod_det where recid(pod_det) = pod_recno no-error.
find si_mstr  where si_mstr.si_domain = global_domain and  si_site        =
pod_site no-lock no-error.

continue = no.

ext_cost = pod_qty_ord * pod_pur_cost * (1 - (pod_disc_pct / 100)).

/* ROUND EXT_COST BASE ON DOCUMENT CURRENCY ROUND METHOD */
{gprun.i ""gpcurrnd.p""
   "(input-output ext_cost,
     input rndmthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.


assign
   old_um_conv = pod_um_conv
   mfgr        = ""
   mfgr_part   = "".

if pod_vpart <> ""
then do:
   find first vp_mstr
        where vp_mstr.vp_domain = global_domain and  vp_part      = pod_part
       and   vp_vend_part = pod_vpart
       and   vp_vend      = po_vend
   no-lock no-error.

   if available vp_mstr
   then do:
      mfgr      = vp_mfgr.
      mfgr_part = vp_mfgr_part.
   end. /* IF AVAILABLE vp_mstr */

end. /* IF pod_vpart <> "" */

global_site = pod_site.
global_addr = po_vend.

if pod_per_date = ?
then
   pod_per_date = pod_due_date.
if pod_need     = ?
then
   pod_need     = pod_due_date.

if pod_status         = "c"
   and old_pod_status = "x"
then do:
   /* Cancelled line changed to closed */
   {pxmsg.i &MSGNUM=329 &ERRORLEVEL=2}
end. /* IF pod_status = "c" and ... */

if (pod_qty_ord = 0 or
   not can-find(pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
   pod_part))
   and pod_type = "S"
then do:
   /* TYPE (S)UBCONTRACT NOT ALLOWED FOR MEMO ITEMS */
   /* OR ZERO QUANTITIES */
   {pxmsg.i &MSGNUM=342 &ERRORLEVEL=3}
   continue = no.
   leave.
end. /* IF (pod_qty_ord = 0 or...*/

if blanket
   and pod_qty_chg > (pod_qty_ord - pod_rel_qty)
then do:
   /* Quantity to release is more than quantity open */
   {pxmsg.i &MSGNUM=384 &ERRORLEVEL=3}
   continue = no.
   leave.
end. /* IF blanket and...*/

if pod_type = "B"
   and not blanket
then do:
   /* Type "B" is reserved for blanket orders */
   {pxmsg.i &MSGNUM=683 &ERRORLEVEL=3}
   continue = no.
   leave.
end. /* IF pod_type = "B" and...*/

if pod_type <> "B"
   and blanket
then do:
   /* Blanker order type must be 'B' */
   {pxmsg.i &MSGNUM=382  &ERRORLEVEL=3}
   continue = no.
   leave.
end. /* IF pod_type <> "B" and... */

if pod_req_nbr <> ""
   and can-find(last req_det  where req_det.req_domain = global_domain and (
   req_nbr = pod_req_nbr))
   and can-find(pt_mstr  where pt_mstr.pt_domain = global_domain and (  pt_part
        = pod_part))
   and blanket                             = false
   and ((new pod_det and pod_type         <> "")
   or (not new pod_det and pod_type       <> old_type))
then do:
   /* PO type not allowed when using requisition */
   {pxmsg.i &MSGNUM=348 &ERRORLEVEL=3}
   continue = no.
   leave.
end. /* IF pod_req_nbr <> "" and ... */

/* INITIALIZE SETTINGS */
{gprunp.i "gpglvpl" "p" "initialize"}

/* ACCT/SUB/CC/PROJ VALIDATION */
{gprunp.i "gpglvpl" "p" "validate_fullcode"
   "(input  pod_acct,
     input  pod_sub,
     input  pod_cc,
     input  pod_project,
     output glvalid)"}

if glvalid  = no
then do:
   continue = no.
   leave.
end. /* If glvalid = no */

find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = pod_part
no-lock no-error no-wait.
if available pt_mstr
   and desc1 = pt_desc1
then do:
   pod_desc = "".
end. /* IF AVAILABLE pt_mstr and...*/

else pod_desc = desc1.

if pod_loc = ""
   and pod_insp_rqd
then do:
   pod_loc = poc_insp_loc.
   /* Inspection required, location set to # */
   {pxmsg.i &MSGNUM=351 &ERRORLEVEL=1 &MSGARG1=pod_loc}
end. /* If pod_loc = "" and ...*/

/* Work Order Update/Validation moved to subroutine to */
/* pick up work orders in remote databases.            */
if pod_type        = "S"
   and pod_req_nbr = ""
then do:
   old_db   = global_db.

   if si_db <> global_db
   then do:
      {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

   end. /* IF si_db <> global_db */

   assign
      worklot  = pod_wo_lot
      routeop  = pod_op
      workpart = pod_part
      workproj = pod_project.

   {gprun.i ""popomtd1.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


   assign
      pod_wo_lot = worklot
      pod_op     = routeop.

   if old_db    <> global_db
   then do:
      {gprun.i ""gpalias3.p"" "(old_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

   end. /* IF old_db <> global_db */

end. /* IF pod_type = "S" and...*/

if using_supplier_consignment and
   can-find(pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
   pod_part)
then do:

   if new pod_det
   then
      run 'initializeSuppConsignDetailFields'
          (input po_vend,
           input pod_part,
           input po_consignment,
           input po_max_aging_days,
           output pod_consignment,
           output pod_max_aging_days).

   /* SET CONSIGNMENT TO 'NO' IF QUANTITY ORDERED IS NEGATIVE */

   if     pod_qty_ord < 0
      and pod_consignment
   then do:
      pod_consignment = no.
      /* WARNING: CONSIGNMENT SET TO NO FOR NEGATIVE QTY ORDERED */
      {pxmsg.i
         &MSGNUM=6302
         &ERRORLEVEL=2
         &PAUSEAFTER=TRUE
      }
   end. /* IF pod_qty_ord < 0 */

end.  /* If using_supplier_consignment */

continue = yes. /* set the flag to yes for successful completion */
