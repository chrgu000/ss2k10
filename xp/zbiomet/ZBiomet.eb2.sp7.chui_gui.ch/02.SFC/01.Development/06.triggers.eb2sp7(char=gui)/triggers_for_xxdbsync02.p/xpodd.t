/* podd.t PURCHASE ORDER LINE DELETE TRIGGER                          */
/*Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                 */
/*All rights reserved worldwide.  This is an unpublished work.        */
/*V8:ConvertMode=NoConvert*/
/*********************************************************************/
/*  Program :podd.t                                                  */
/*  Author  :Ben Holmes                                              */
/*  Date    :01/19/96                                                */
/*  !Description : pod_det DELETE trigger program                    */
/*          : In order to enhance this trigger to support additional */
/*          : interfaces, add a DO-END block similar to the one      */
/*          : used for the Warehousing Interface to (1) check for the*/
/*          : need to continue processing; (2) move the relevant     */
/*          : fields to an appropriate work area; and (3) call       */
/*          : one or more subprograms to continue processing.        */
/*          : This .t program should remain short, relying on        */
/*          : subprograms to perform most of the work.               */
/*          : J26K - Export also Item Number.                        */
/*********************************************************************/
/*                             MODIFY LOG                            */
/*********************************************************************/
/*Revision 8.5          Last Modified:  01/19/96 BY: BHolmes *J0FY*  */
/*Revision 8.5          Last Modified:  06/12/96 BY: fwy     *J0KF*  */
/*Revision 8.5          Last Modified:  06/25/96 BY: BHolmes *J0M9*  */
/*Revision 8.5          Last Modified:  07/27/96 BY: fwy     *J12B*  */
/*Revision 8.5          Last Modified:  01/07/97 BY: jpm      *J1DM* */
/*Revision 8.5          Last Modified:  11/19/97 BY: gym     *J26K*  */
/*Revision 9.1          Last Modified:  08/13/00 BY: *N0KQ* myb       */
/*                                                                   */
/*                                                                   */
/*********************************************************************/

TRIGGER PROCEDURE FOR DELETE OF POD_DET.


/*ss - 20090401.1 - B*/
do:
    find first xpod_det 
	where xpod_nbr  = pod_nbr 
	and   xpod_line = pod_line 
    no-error .
    if avail xpod_det then do:
	delete xpod_det .
    end. 
end.
/*ss - 20090401.1 - E*/



/*J12B  if not can-find(first whl_mstr where whl_mstr.whl_act no-lock) */
/*J12B  then leave. */

    {mfdeclre.i }
    define new shared variable w-recid as recid.
    define new shared work-table wf_old_pod_det like pod_det.
/*J0M9*/define new shared variable w-te_type as character.

    define variable w-file as character format "x(24)".


    /* Warehousing Interface processing */

    WI:
    do:

    /* If there is no active external warehouse that is flagged to
    receive purchase order export transactions, then do not process */
/*J12B*/    if not can-find(first whl_mstr no-lock
/*J12B*/        where whl_mstr.whl_act and whl_mstr.whl_po_exp)
/*J12B*/    then leave WI.

    /* If the quantity ordered has already been received
    and the order closed, then do not process */
    find po_mstr no-lock where po_mstr.po_nbr = pod_det.pod_nbr.
        if not po_mstr.po_sched
        then do:
/*J0KF      if   (pod_det.pod_status = "C" or pod_det.pod_status = "X") */
/*J0KF*/        if (pod_det.pod_status = "C")
              and abs(pod_det.pod_qty_rcvd) ge abs(pod_det.pod_qty_ord)
            then leave WI.
        end.

    /* For customer schedules, check the cum rather than order quantity */
        if po_mstr.po_sched
        then do:
/*J0KF      if   (pod_det.pod_status = "C" or pod_det.pod_status = "X") */
/*J0KF*/        if   (pod_det.pod_status = "C")
              and abs(pod_det.pod_qty_rcvd) ge abs(pod_det.pod_cum_qty[3])
            then leave WI.
        end.

    /* Move key pod_det values to work table for subsequent processing */
        assign w-recid = recid(pod_det).
        create wf_old_pod_det.
        if recid(wf_old_pod_det)= -1 then .
        assign
            wf_old_pod_det.pod_nbr       = pod_det.pod_nbr
            wf_old_pod_det.pod_line      = pod_det.pod_line
            wf_old_pod_det.pod_site      = pod_det.pod_site
            wf_old_pod_det.pod_loc       = pod_det.pod_loc
            wf_old_pod_det.pod_sched     = pod_det.pod_sched
/*J26K*/    wf_old_pod_det.pod_part      = pod_det.pod_part
/*J0M9*/    wf_old_pod_det.pod_qty_ord   = pod_det.pod_qty_ord.

    /* Call subprogram to create export transaction for warehouse */
        w-file = "wipodd.p".
/*J1DM*/ /* {gprun.i ""wipodd.p""} */
/*J1DM*/    {gprunmo.i &module="WI"
                       &program="wipodd.p"}

/*J12B*/end. /* WI */
