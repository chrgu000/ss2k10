/* GUI CONVERTED from poporca3.p (converter v1.78) Fri Oct 29 14:37:34 2004 */
/* poporca3.p - PO RECEIPT Checking AP Vouchers etc                           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.15 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3     LAST MODIFIED: 04/19/93    BY: tjs *G964*                */
/* REVISION: 7.3     LAST MODIFIED: 06/30/93    BY: dpm *GC87*                */
/* REVISION: 7.3     LAST MODIFIED: 10/25/94    BY: cdt *FS78*                */
/* REVISION: 7.3     LAST MODIFIED: 12/27/94    BY: bcm *F0BT*                */
/* REVISION: 8.5     LAST MODIFIED: 01/04/95    BY: ktn *J041*                */
/* REVISION: 8.5     LAST MODIFIED: 01/20/95    BY: taf *J038*                */
/* REVISION: 8.5     LAST MODIFIED: 07/19/96    BY: kxn *J12S*                */
/* REVISION: 8.6E    LAST MODIFIED: 08/30/98    BY: *J2WJ* Ajit Deodhar       */
/* REVISION: 9.0     LAST MODIFIED: 04/16/99    BY: *J2DG* Reetu Kapoor       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *G443*                    */
/* Old ECO marker removed, but no ECO header exists *GA90*                    */
/* REVISION: 9.1      LAST MODIFIED: 06/28/00   BY: Zheng Huang   *N0DK*      */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb                */
/* Revision: 1.14     BY: Paul Donnelly (SB)    DATE: 06/28/03  ECO: *Q00J*   */
/* $Revision: 1.15 $   BY: Vandna Rohira         DATE: 04/26/04  ECO: *P1Z3*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*-Revision end---------------------------------------------------------------*/

/* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO          */
/* WHEREVER MISSING AND REPLACED FIND STATEMENTS WITH FOR FIRST           */
/* STATEMENTS FOR ORACLE PERFORMANCE                                      */

{mfdeclre.i}

/* SEVERITY PREPROCESSOR CONSTANT DEFINITION INCLUDE FILE */
{pxmaint.i}

/* VARIABLE DEFINITIONS */
define shared variable vendlot             like tr_vend_lot no-undo.
define shared variable site                like sr_site     no-undo.
define shared variable location            like sr_loc      no-undo.
define shared variable lotref              like sr_ref      no-undo.
define shared variable lotserial           like sr_lotser   no-undo.
define shared variable total_lotserial_qty like pod_qty_chg.
define shared variable lotserial_control   as character.
define shared variable cline               as character.
define shared variable line                like pod_line
                                           format ">>>"     no-undo.
define shared variable lotserial_qty       like sr_qty      no-undo.
define shared variable pod_recno           as recid.
define        variable i                   as integer       no-undo.

/*@TO-DO  CONTROLLER NEED TO FIND pod_det*/
find pod_det
   where recid(pod_det) = pod_recno
   exclusive-lock no-error.
/*@TO-DOEND*/

lotserial_control = "".

for first  pt_mstr
   fields( pt_domain pt_lot_ser pt_part)
   where pt_mstr.pt_domain = global_domain
   and   pt_part           = pod_part no-lock:
end. /* FOR FIRST PT_MSTR */
if available pt_mstr
then
   lotserial_control = pt_lot_ser.

assign
   site          = ""
   location      = ""
   lotref        = ""
   vendlot       = ""
   pod__qad04[1] = ""
   lotserial_qty = pod_qty_chg
   cline         = string(line)
   global_part   = pod_part
   i             = 0.

for each sr_wkfl
      fields( sr_domain sr_lineid sr_loc sr_lotser sr_ref
              sr_site sr_userid sr_vend_lot)
      where sr_wkfl.sr_domain = global_domain
      and   sr_userid         = mfguser
      and   sr_lineid         = cline no-lock:
   i = i + 1.
   if i > 1
   then
      leave.
end. /* FOR EACH sr_wkfl */

if i = 0
then do:
   assign
      site     = pod_site
      location = pod_loc.

   /* FOR FIELD SERVICE RTS ORDERS DEFAULT THE SERIAL # */

   /*@MODULE RTS BEGIN*/
   if pod_rma_type <> ""
      and lotserial = ""
   then
      assign
         lotserial = pod_serial.
   /*@MODULE RTS END*/
end. /* IF i = 0 */
else
if i <> 0
then do:

   for first sr_wkfl
      fields( sr_domain sr_lineid sr_loc sr_lotser sr_ref
              sr_site sr_userid sr_vend_lot)
      where sr_wkfl.sr_domain = global_domain
      and   sr_userid         = mfguser
      and   sr_lineid         = cline no-lock:
   end. /* FOR FIRST sr_wkfl */
   assign
      site          = sr_site
      location      = sr_loc
      lotserial     = sr_lotser
      lotref        = sr_ref
      pod__qad04[1] = sr_vend_lot
      vendlot       = sr_vend_lot.
end. /* IF i <> 0 */

{pxrun.i
   &PROC='checkOpenVouchers'
   &PROGRAM='porcxr1.p'
   &PARAM="(input pod_sched,
     input pod_nbr,
     input pod_line)"
   &NOAPPERROR=true
   &CATCHERROR=true
   }
