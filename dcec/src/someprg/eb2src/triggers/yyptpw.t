/* ptpw.t  ITEM PLANNING DETAIL WRITE TRIGGER                         */
/*Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                 */
/*All rights reserved worldwide.  This is an unpublished work.        */
/*V8:ConvertMode=NoConvert*/
/*********************************************************************/
/*  Program :ptpw.t                                                  */
/*  Author  :Ben Holmes                                              */
/*  Date    :03/19/95                                                */
/*  !Description : ptp_det WRITE trigger program                     */
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
/*Revision 8.5          Last Modified:  03/19/95 BY: BHolmes *J0FY*  */
/*Revision 8.5          Last Modified:  07/27/96 BY: fwy     *J12B*  */
/*Revision 8.6          Last Modified:  11/20/96 BY: cjv     *K01B*  */
/*Revision 8.6          Last Modified:  01/07/97 BY: jpm     *J1DM*  */
/*Revision 9.1          Last Modified:  08/13/00 BY: *N0KQ* myb       */
/*                                                                   */
/*                                                                   */
/*********************************************************************/

TRIGGER PROCEDURE FOR WRITE OF PTP_DET OLD BUFFER OLD_PTP_DET.

/*J12B  if not can-find(first whl_mstr where whl_mstr.whl_act no-lock) */
/*J12B  then leave. */

        {mfdeclre.i }
        define new shared work-table wf_old_ptp_det like ptp_det.
        define new shared variable w-recid as recid.
        define variable w-file as character format "x(24)".

/*cj*add audit part*/
        DEF VAR keyval AS CHAR .

        Aud:
        DO:

            keyval = ptp_det.ptp_part + "." + ptp_det.ptp_site .
            
            IF old_ptp_det.ptp_phantom <> ptp_det.ptp_phantom THEN DO :
                {gprun.i ""yyaud.p"" "(input 'ptp_det' ,
                    INPUT 'ptp_phantom' ,
                    INPUT keyval ,
                    INPUT old_ptp_det.ptp_phantom ,
                    INPUT ptp_det.ptp_phantom)"
                 }
            END.
            
            IF old_ptp_det.ptp_routing <> ptp_det.ptp_routing THEN DO :
                {gprun.i ""yyaud.p"" "(input 'ptp_det' ,
                    INPUT 'ptp_routing' ,
                    INPUT keyval ,
                    INPUT old_ptp_det.ptp_routing ,
                    INPUT ptp_det.ptp_routing)"
                 }
            END.
            
            IF old_ptp_det.ptp_bom_code <> ptp_det.ptp_bom_code THEN DO :
                {gprun.i ""yyaud.p"" "(input 'ptp_det' ,
                    INPUT 'ptp_bom_code' ,
                    INPUT keyval ,
                    INPUT old_ptp_det.ptp_bom_code ,
                    INPUT ptp_det.ptp_bom_code)"
                 }
            END.

        END.


        /* Warehousing Interface processing */

        WI:
        do:

        /* If there is no active external warehouse, then do not process */
/*K01B     If the item export flag is not set, then do not process */
/*J12B*/    if not can-find(first whl_mstr no-lock
/*K01B  /*J12B*/        where whl_mstr.whl_act) */
/*K01B*/           where whl_mstr.whl_act
/*K01B*/           and whl_mstr.whl_pt_exp)
/*J12B*/    then leave WI.

        /* If no pertinent fields have been changed, then do not process */
/*J12B*/    if   (old_ptp_det.ptp_part     = ptp_det.ptp_part
/*J12B*/      and old_ptp_det.ptp_ins_rqd  = ptp_det.ptp_ins_rqd
/*J12B*/      and old_ptp_det.ptp_rev      = ptp_det.ptp_rev
/*J12B*/      and old_ptp_det.ptp_rop      = ptp_det.ptp_rop
/*J12B*/      and old_ptp_det.ptp_sfty_stk = ptp_det.ptp_sfty_stk
/*J12B*/      and old_ptp_det.ptp_user1    = ptp_det.ptp_user1
/*J12B*/      and old_ptp_det.ptp_user2    = ptp_det.ptp_user2)
/*J12B*/    then leave WI.

        /* Move old ptp_det values to work table for subsequent processing */
            assign w-recid = recid(ptp_det).
            create wf_old_ptp_det.
            if recid(wf_old_ptp_det)= -1 then .
            assign
                wf_old_ptp_det.ptp_part     = old_ptp_det.ptp_part
                wf_old_ptp_det.ptp_ins_rqd  = old_ptp_det.ptp_ins_rqd
                wf_old_ptp_det.ptp_rev      = old_ptp_det.ptp_rev
                wf_old_ptp_det.ptp_rop      = old_ptp_det.ptp_rop
                wf_old_ptp_det.ptp_sfty_stk = old_ptp_det.ptp_sfty_stk
                wf_old_ptp_det.ptp_user1    = old_ptp_det.ptp_user1
                wf_old_ptp_det.ptp_user2    = old_ptp_det.ptp_user2
            .

        /* Call subprogram to create export transactions for warehouses */
            w-file = "wiptpw.p".
/*J1DM*/ /* {gprun.i ""wiptpw.p""} */
/*J1DM*/    {gprunmo.i &module="WI"
                       &program="wiptpw.p"}

/*J12B*/end. /* WI */
