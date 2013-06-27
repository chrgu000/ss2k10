/* mgflhiq.p - LOOKUP INQUIRY                                           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.10 $                                                     */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 5.0     LAST MODIFIED: 06/29/90            BY: PML  D039   */
/* Revision: 7.3        Last edit: 11/19/92             By: jcd *G339*  */
/* Revision: 7.3        Last edit: 02/12/93             By: rwl *G678*  */
/*                      Last edit: 07/31/94             By: rmh *FP74*  */
/*                      Last edit: 09/10/94             By: bcm *GM07*  */
/*           7.4        Last edit: 09/19/95             By: bcm *H0FZ*  */
/* Revision: 8.6        Last edit: 12/09/97             By: bvm *K1CN*  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KR* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.10 $    BY: Katie Hilbert         DATE: 11/28/01  ECO: *P02D*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "36YP"}

define variable flhfld   like flh_field.
define variable callpgm  like flh_call_pgm format "x(24)".
define variable exec     like flh_exec.

form
   space(1)
   callpgm colon 24
   flhfld  colon 24
   exec    colon 24
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   flh_field
   flh_call_pgm at 34 column-label "Calling!Procedure" format "x(24)"
   flh_exec     at 62 column-label "Procedure!To!Execute"
   flh_desc           column-label "description"
with frame b down width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

{wbrp01.i}

repeat:

   if c-application-mode <> 'web' then
      update
         callpgm
         flhfld
         exec
      with frame a
      editing:

      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i flh_mstr  flhfld  flh_field
         flhfld  flh_field flh_field}

      if recno <> ? then do:
         flhfld = flh_field.
         display flhfld with frame a.
         recno = ?.
      end.
   end.
   status input.

   {wbrp06.i &command = update &fields = " callpgm flhfld exec" &frm = "a"}

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 134
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   clear frame b all.

   for each flh_mstr
      where (flh_field  >= flhfld or flhfld = "")
       and (flh_call_pgm begins callpgm or callpgm = "")
       and (flh_exec = exec or exec = "")
      no-lock use-index flh_field
      with frame b width 134:
      {mfrpchk.i}
      display
         flh_field
         flh_call_pgm
         flh_exec
         flh_desc .
      down 1 with frame b.
   end.

   {mfreset.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}
end.

{wbrp04.i &frame-spec = a}
