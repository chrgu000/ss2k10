/* podw.t PURCHASE ORDER LINE WRITE TRIGGER                                   */
/*Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                         */
/*All rights reserved worldwide.  This is an unpublished work.                */
/* $Revision: 1.12 $                                                           */
/*V8:ConvertMode=NoConvert                                                    */
/******************************************************************************/
/*  !Description : This program is a database trigger running                 */
/*          : everytime a record is changed.  It will create a                */
/*          : worktable and then call another program                         */
/*          :                                                                 */
/******************************************************************************/
/*                             MODIFY LOG                                     */
/******************************************************************************/
/* REVISION 8.5      LAST MODIFIED: 01/19/96   BY: *J0FY* BHolmes             */
/* REVISION 8.5      LAST MODIFIED: 06/25/96   BY: *J0M9* BHolmes             */
/* REVISION 8.5      LAST MODIFIED: 01/07/97   BY: *J1DM* jpm                 */
/* REVISION 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb                 */
/* Old ECO marker removed, but no ECO header exists *J12B*                    */
/* Revision: 1.4       BY: Mark Christian        DATE: 09/09/01  ECO: *M1KG*  */
/* Revision: 1.5       BY: Jean Miller           DATE: 06/13/02  ECO: *P082*  */
/* Revision: 1.8       BY: Jean Miller           DATE: 08/01/02  ECO: *P0CL*  */
/* Revision: 1.9       BY: Jean Miller           DATE: 08/17/02  ECO: *P0FN* */
/* Revision: 1.11      BY: Paul Donnelly (SB)    DATE: 06/28/03  ECO: *Q00J* */
/* $Revision: 1.12 $    BY: Jean Miller           DATE: 01/10/06  ECO: *Q0PD*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

TRIGGER PROCEDURE FOR WRITE OF POD_DET OLD BUFFER OLD_POD_DET.

{mfdeclre.i }

define variable l-qualifier as character format "x(8)".
define variable vflag as character.
define variable vlvl as integer.

/* Track Capacity Units */
if new pod_det and
  (old_pod_det.pod_nbr  <> pod_det.pod_nbr  or
   old_pod_det.pod_line <> pod_det.pod_line)
then do:

   l-qualifier = "".

   /* See if this is a Blanket PO */
   if can-find(first po_mstr  where po_mstr.po_domain = global_domain
                               and po_mstr.po_nbr = pod_det.pod_nbr
                               and po_mstr.po_blanket <> "")
   then
      l-qualifier = "BLANKET".
   else
      l-qualifier = "".

   /* If not a Blanket PO, is this a scheduled Line */
   if l-qualifier = "" and pod_det.pod_sched then
      l-qualifier = "SCHED".

   {lvucap.i &TABLE="pod_det" &QUALIFIER="l-qualifier"}

end.
/** {xxtrace.i} **/
xxtrig:
do transaction:
   if OLD_POD_DET.pod__chr01 <> pod_det.pod__chr01 then do:
   assign vflag = pod_det.pod_nbr + string(pod_det.pod_line)
                + string(today) + string(time).
   find first usrw_wkfl exclusive-lock where usrw_domain = global_domain
          and usrw_key1 = "Trace_pod__chr01"
          and usrw_key2 = vflag no-error.
   if not available usrw_wkfl then do:
      create usrw_wkfl. usrw_domain = global_domain.
      assign usrw_key1 = "Trace_pod__chr01"
             usrw_key2 = vflag.
   end.
      assign usrw_key3 = pod_det.pod_nbr
             usrw_key4 = string(pod_det.pod_line)
             usrw_key5 = pod_det.pod_part
             usrw_key6 = pod_det.pod_site
             usrw_charfld[1] = pod_det.pod__chr01
             usrw_charfld[2] = old_pod_det.pod__chr01
             usrw_charfld[3] = execname
             usrw_charfld[4] = mfguser
             usrw_charfld[6]  = global_userid
             usrw_datefld[1]  = today
             usrw_intfld[1]   = time.
    FOR EACH mon_mstr NO-LOCK WHERE mon_sid = mfguser,
        EACH qaddb._connect NO-LOCK WHERE mon__qadi01 = _Connect-Usr:
      assign usrw_charfld[5]  = _connect-name
             usrw_charfld[7]  = _connect-device
             usrw_charfld[8]  = mon_interface
             usrw_datefld[4]  = mon_date_start
             usrw_charfld[10] = mon_program
             usrw_datefld[2]  = mon_login_date
             usrw_intfld[2]   = mon_login_time.
    END.
      vlvl = 2.
      REPEAT WHILE (PROGRAM-NAME(vlvl) <> ?):
        usrw_charfld[15] = usrw_charfld[15] + string(vlvl - 1, "99")
                  + ":" + program-name(vlvl) + "; ".
        vlvl = vlvl + 1.
        if index(PROGRAM-NAME(vlvl),"mfnewa3.p") > 0 then leave.
      END.
   end.
end.
