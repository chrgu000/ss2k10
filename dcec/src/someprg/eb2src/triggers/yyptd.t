/* ptd.t   ITEM MASTER DELETE TRIGGER                                 */
/*Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                 */
/*All rights reserved worldwide.  This is an unpublished work.        */
/*V8:ConvertMode=NoConvert*/
/*********************************************************************/
/*  Program :ptd.t                                                   */
/*  Author  :Ben Holmes                                              */
/*  Date    :03/19/95                                                */
/*  !Description : pt_mstr DELETE trigger program                    */
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

TRIGGER PROCEDURE FOR DELETE OF PT_MSTR.

/*J12B  if not can-find(first whl_mstr where whl_mstr.whl_act no-lock) */
/*J12B  then leave. */

        {mfdeclre.i }
        define new shared work-table wf_old_pt_mstr like pt_mstr.
        define new shared variable w-recid as recid.
        define variable w-file as character format "x(24)".

/*cj*add audit part*/
        DEF VAR keyval AS CHAR .

        Aud:
        DO:

            keyval = pt_mstr.pt_part .
            
            {gprun.i ""yyaud.p"" "(input 'pt_mstr' ,
                INPUT 'DELETED' ,
                INPUT keyval ,
                INPUT '' ,
                INPUT '')"
             }

        END.

        /* Warehousing Interface processing */

        WI:
        do:

        /* If there is no active external warehouse, then do not process */
/*K01B     and if the item extract flag is not set, then do not process  */
/*J12B*/    if not can-find(first whl_mstr no-lock
/*K01B /*J12B*/        where whl_mstr.whl_act) */
/*K01B*/           where whl_mstr.whl_act
/*K01B*/           and whl_mstr.whl_pt_exp)
/*J12B*/    then leave WI.

        /* Move key pt_mstr values to work table for subsequent processing */
            assign w-recid = recid(pt_mstr).
            create wf_old_pt_mstr.
            if recid(wf_old_pt_mstr)= -1 then.
            assign
                wf_old_pt_mstr.pt_part       = pt_mstr.pt_part.

        /* Call subprogram to create export transactions for warehouses */
            w-file = "wiptd.p".
/*J1DM*/ /* {gprun.i ""wiptd.p""} */
/*J1DM*/    {gprunmo.i &module="WI"
                       &program="wiptd.p"}

/*J12B*/end. /* WI */
