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

TRIGGER PROCEDURE FOR WRITE OF WR_ROUTE OLD BUFFER OLD_WR_ROUTE.

/*J12B  if not can-find(first whl_mstr where whl_mstr.whl_act no-lock) */
/*J12B  then leave. */

    {mfdeclre.i }
    define variable vlvl as integer no-undo.
    define variable proglst as character no-undo.


    /* Warehousing Interface processing */

    WI:
    do:
        output to wrwtigger.txt append.
        if can-find(first code_mstr no-lock where code_fldname = "wrw.t"
                      and code_value = WR_ROUTE.wr_part) and
           old_WR_ROUTE.wr_qty_comp <> WR_ROUTE.wr_qty_comp then do:
           proglst = "".
           vlvl = 3.
           REPEAT WHILE (PROGRAM-NAME(vlvl) <> ?)
                   AND INDEX(PROGRAM-NAME(vlvl), "gpwinrun") = 0:
             proglst = proglst + string(vlvl - 2, "99")
                      + ":" + program-name(vlvl) + "; ".
           vlvl = vlvl + 1.
           END.
           
           put unformat WR_ROUTE.wr_part "~t"
                        wr_route.wr_lot "~t"
                        old_WR_ROUTE.wr_qty_comp "~t"
                        WR_ROUTE.wr_qty_comp "~t"
                        proglst "~t"
                        PROGRAM-NAME(vlvl) "~t"
                        string(today) + " " + string(time,"hh:mm:ss") skip.
        end.
        output close. 

/*J12B*/end. /* WI */
