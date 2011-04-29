/* rqpoblda.p - Requisition To Purchase Order Build Sub-Program             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.3.1.5 $                                                         */
/*V8:ConvertMode=ReportAndMaintenance                                       */
/*V8:RunMode=Character,Windows                                              */
/* REVISION 8.5       LAST MODIFIED: 04/15/97  BY: *J1Q2* Patrick Rowan     */
/* REVISION 8.6       LAST MODIFIED: 05/20/98  BY: *K1Q4* Alfred Tan        */
/* REVISION 8.5       LAST MODIFIED: 09/02/98  BY: *J2YD* Patrick Rowan     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KP* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.3.1.5 $    BY: Vinay Soman          DATE: 10/18/04 ECO: *P2PN* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 101208.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/






/*!
 ----------------------------------------------------------------------------
 DESCRIPTION: Display scrolling window of requisition lines to select.
              Supports the multi-line Purchase Requisition Module of MFG/PRO.

 Notes:
 1) A temp-table is used to hold the requisition lines.  Once a line has been
    selected, the copy_to_po flag will be set.  A seperate process will
gather the selected lines and create a new purchase order.
============================================================================
!*/
{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* SHARED VARIABLES*/
{rqpovars.i}
/* SS - 101208.1 - B */
define var v_Desc1 as char label "หตร๗" format "x(60)" no-undo.
/* SS - 101208.1 - E */

form
   rqpo_nbr
   rqpo_line
   rqpo_item
   rqpo_net_qty
   rqpo_need_date
   rqpo_supplier
   rqpo_buyer_id
   rqpo_copy_to_po
   skip 
   v_desc1 at 15 
with frame y down scroll 1 width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame y:handle).

/* FOR BOOLEAN VALUE IN DOWN FRAME,    */
/* ENSURE TRANSLATION TO USER LANGUAGE */
{gpfrmdis.i &fname = "y"}

repeat for rqpo_wrk on endkey undo, leave
   with frame y width 80 no-attr-space down:
   {xxswindowd5218.i rqpo_wrk "y"
      rqpo_nbr
      rqpo_line
      rqpo_nbr
      rqpo_copy_to_po
      rqpo_nbr
      rqpo_line
      rqpo_item
      rqpo_net_qty
      rqpo_need_date
      rqpo_supplier
      rqpo_buyer_id
      rqpo_copy_to_po
      v_desc1 } /* SS - 101208.1 */

   /* {1}=file name  {2}=frame name {3}=key1 field    */
   /* {4}=key2 field {5}=scrolling field name         */
   /* {6}=field to update  {7}...{14}=display fields  */

   if keyfunction(lastkey) = "go"
   then do:

      {mfmsg01.i 12 1 info_correct}  /* IS ALL INFO CORRECT? */
      if info_correct
      then
         leave.
   end. /* IF KEYFUNCTION(LASTKEY) = "GO" */

   if keyfunction(lastkey) = "return"
   or keyfunction(lastkey) = "end-error"
   then
      leave.

end.  /* REPEAT */
