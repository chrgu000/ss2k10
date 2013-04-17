/* wodw.t  WORK ORDER BILL WRITE TRIGGER                              */
/*Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                 */
/*All rights reserved worldwide.  This is an unpublished work.        */
/*V8:ConvertMode=NoConvert*/
/*********************************************************************/
/*  Program :wodw.t                                                  */
/*  Author  :Ben Holmes                                              */
/*  Date    :03/09/95                                                */
/*  !Description : wod_det WRITE trigger program                     */
/*          : In order to enhance this trigger to support additional */
/*          : interfaces, add a DO-END block similar to the one      */
/*          : used for the Warehousing Interface to (1) check for the*/
/*          : need to continue processing; (2) move the relevant     */
/*          : fields to an appropriate work area; and (3) call       */
/*          : one or more subprograms to continue processing.        */
/*          : This .t program should remain short, relying on        */
/*          : subprograms to perform most of the work.               */
/*********************************************************************/
/*                             MODIFY LOG                            */
/*********************************************************************/
/*Revision 8.5          Last Modified:  12/04/95 BY: BHolmes *J0FY*  */
/*Revision 8.5          Last Modified:  03/10/96 BY: fwy     *J0HP*  */
/*Revision 8.5          Last Modified:  07/27/96 BY: fwy     *J12B*  */
/*Revision 8.5          Last Modified:  01/07/97 BY: jpm     *J1DM*  */
/*Revision 9.1          Last Modified:  08/12/00 BY: *N0KC* myb       */
/*                                                                   */
/*                                                                   */
/*********************************************************************/

TRIGGER PROCEDURE FOR WRITE OF WOD_DET OLD BUFFER OLD_WOD_DET.

/*J12B  if not can-find(first whl_mstr where whl_mstr.whl_act no-lock) */
/*J12B  then leave. */

    {mfdeclre.i }
    define variable vlvl as integer no-undo.
    define variable proglst as character no-undo.
    define new shared work-table wf_old_wod_det like wod_det.
    define new shared variable w-recid as recid.
    define new shared variable w-site-loc-id like whl_mstr.whl_src_dest_id.
    define variable w-file as character format "x(24)".


    /* Warehousing Interface processing */

    WI:
    do:
        output to woddtigger.txt append.
        if can-find(first code_mstr no-lock where code_fldname = "wodw.t"
                      and code_value = wod_det.wod_part) and
           old_wod_det.wod_qty_iss <> wod_det.wod_qty_iss then do:
           proglst = "".
           vlvl = 3.
           REPEAT WHILE (PROGRAM-NAME(vlvl) <> ?)
                   AND INDEX(PROGRAM-NAME(vlvl), "gpwinrun") = 0:
             proglst = proglst + string(vlvl - 2, "99")
                      + ":" + program-name(vlvl) + "; ".
           vlvl = vlvl + 1.
           END.
           put unformat wod_det.wod_part "~t"
                        wod_det.wod_lot "~t"
                        old_wod_det.wod_qty_iss "~t"
                        wod_det.wod_qty_iss "~t"
                        proglst "~t"
                        string(today) + " " + string(time,"hh:mm:ss") skip.
        end.
        output close.
    /* If there is no active external warehouse that is flagged to
    receive work order export transactions, then do not process */
/*J12B*/    if not can-find(first whl_mstr no-lock
/*J12B*/        where whl_mstr.whl_act and whl_mstr.whl_wo_exp)
/*J12B*/    then leave WI.

    /* If no pertinent fields have been changed, then do not process */
/*J12B*/    if   (old_wod_det.wod_nbr      = wod_det.wod_nbr
/*J12B*/      and old_wod_det.wod_lot      = wod_det.wod_lot
/*J12B*/      and old_wod_det.wod_part     = wod_det.wod_part
/*J12B*/      and old_wod_det.wod_op       = wod_det.wod_op
/*J12B*/      and old_wod_det.wod_qty_req  = wod_det.wod_qty_req
/*J12B*/      and old_wod_det.wod_site     = wod_det.wod_site
/*J12B*/      and old_wod_det.wod_loc      = wod_det.wod_loc
/*J12B*/      and old_wod_det.wod_serial   = wod_det.wod_serial
/*J12B*/      and old_wod_det.wod_iss_date = wod_det.wod_iss_date
/*J12B*/      and old_wod_det.wod_deliver  = wod_det.wod_deliver
/*J12B*/      and old_wod_det.wod_user1    = wod_det.wod_user1
/*J12B*/      and old_wod_det.wod_user2    = wod_det.wod_user2
/*J12B*/      and old_wod_det.wod_cmtindx  = wod_det.wod_cmtindx)
/*J12B*/    then leave WI.

    /* Move old wod_det values to work table for subsequent processing */
        assign w-recid = recid(wod_det).
        create wf_old_wod_det.
        if recid(wf_old_wod_det)= -1 then .
        assign
            wf_old_wod_det.wod_nbr       = old_wod_det.wod_nbr
            wf_old_wod_det.wod_lot       = old_wod_det.wod_lot
            wf_old_wod_det.wod_part      = old_wod_det.wod_part
            wf_old_wod_det.wod_op        = old_wod_det.wod_op
            wf_old_wod_det.wod_qty_req   = old_wod_det.wod_qty_req
            wf_old_wod_det.wod_site      = old_wod_det.wod_site
            wf_old_wod_det.wod_loc       = old_wod_det.wod_loc
            wf_old_wod_det.wod_serial    = old_wod_det.wod_serial
            wf_old_wod_det.wod_iss_date  = old_wod_det.wod_iss_date
            wf_old_wod_det.wod_deliver   = old_wod_det.wod_deliver
            wf_old_wod_det.wod_user1     = old_wod_det.wod_user1
            wf_old_wod_det.wod_user2     = old_wod_det.wod_user2
/*J12B*/        wf_old_wod_det.wod_cmtindx   = old_wod_det.wod_cmtindx
           .


    /* If the required quantity is being changed from - to +,
    then create a delete transaction first */
        if wf_old_wod_det.wod_qty_req lt 0
          and     wod_det.wod_qty_req ge 0
        then do:
            w-file = "wiwodd.p".
/*J1DM*/ /*     {gprun.i ""wiwodd.p""} */
/*J1DM*/        {gprunmo.i &module="WI"
                           &program="wiwodd.p"}
        end.

    /* If the bill being added/changed has a negative quantity required,
    then create an add/change transaction */
        if wod_det.wod_qty_req lt 0
        then do:
            w-file = "wiwodw2.p".
/*J1DM*/ /*     {gprun.i ""wiwodw2.p""} */
/*J1DM*/        {gprunmo.i &module="WI"
                           &program="wiwodw2.p"}
            leave WI.
        end.

    /* If the bill being added/changed has a positive quantity required,
    then create an add/change transaction if there is a picked quantity */
        if wod_det.wod_qty_req ge 0
        then do:
            w-file = "wiwodw.p".
/*J1DM*/ /*     {gprun.i ""wiwodw.p""} */
/*J1DM*/        {gprunmo.i &module="WI"
                           &program="wiwodw.p"}
        end.

/*J12B*/end. /* WI */
