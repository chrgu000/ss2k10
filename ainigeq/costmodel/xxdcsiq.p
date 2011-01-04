/* xxdcsiq.p - dcs query                                                     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.12 $                                                         */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 6.0          LAST EDIT: 02/07/90   MODIFIED BY: EMB             */
/* REVISION: 6.0          LAST EDIT: 09/03/91   BY: afs *D847*               */
/* Revision: 7.3          Last edit: 11/19/92   By: jcd *G339*               */
/*           7.3                     09/10/94   BY: bcm *GM02*               */
/*           7.3                     03/15/95   by: str *F0N1*               */
/* REVISION: 8.6          LAST EDIT: 03/09/98   BY: *K1KX* Beena Mol         */
/* REVISION: 8.6          LAST EDIT: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6          LAST EDIT: 06/02/98   BY: *K1RQ* A.Shobha          */
/* REVISION: 9.0          LAST EDIT: 03/10/99   BY: *M0B8* Hemanth Ebenezer  */
/* REVISION: 9.0          LAST EDIT: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* $Revision: 1.12 $    BY: Jean Miller          DATE: 04/06/02  ECO: *P056* */
/*****************************************************************************/
/* All patch markers and commented out code have been removed from the source*/
/* code below. For all future modifications to this file, any code which is  */
/* no longer required should be deleted and no in-line patch markers should  */
/* be added.  The ECO marker should only be included in the Revision History.*/
/*****************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "100826.1"}
DEFINE VARIABLE eledesc AS CHARACTER NO-UNDO.
DEFINE VARIABLE dptdesc AS CHARACTER NO-UNDO.
form
   space(1)
   xxdcs_period label "期间"
   xxdcs_element label "因素" eledesc NO-LABEL
   xxdcs_dept label "部门" dptdesc NO-LABEL
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:

   if c-application-mode <> 'web' then
      prompt-for xxdcs_period xxdcs_element xxdcs_dept with frame a
   editing:

      if frame-field = "xxdcs_element" then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp01.i code_mstr xxdcs_element code_value 'xxdcs_element'
          code_fldname code_fldval}

         if recno <> ? then
            display code_value @ xxdcs_element
                    code_cmmt @ eledesc with frame a.
         recno = ?.
      end.
      else if frame-field = "xxdcs_dept" then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i dpt_mstr xxdcs_dept dpt_dept xxdcs_dept dpt_dept dpt_dept}

         if recno <> ? then
            DISPLAY dpt_dept @ xxdcs_dept
                    dpt_desc @ dptdesc with frame a.
         recno = ?.
      end.
      else do:
         status input.
         readkey.
         apply lastkey.
      end.
   end.
   status input.

   {wbrp06.i &command = prompt-for
             &fields = " xxdcs_period xxdcs_element xxdcs_dept "
             &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      find dpt_mstr where dpt_dept = input xxdcs_dept no-lock no-error.
      if available dpt_mstr then display dpt_desc @ dptdesc with frame a.
      else display "" @ dptdesc with frame a.

      find code_mstr no-lock where code_fldname = "xxdcs_element" and
           code_value = input xxdcs_element no-error.
      if available code_mstr then display code_cmmt @ eledesc with frame a.
      else display "" @ eledesc with frame a.

      hide frame b.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 80
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

   FOR EACH xxdcs_mstr WHERE xxdcs_period >= INPUT xxdcs_period
        AND xxdcs_element >= INPUT xxdcs_element
        AND xxdcs_dept >= INPUT xxdcs_dept
        no-lock with frame b width 80 no-attr-space down:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
      assign eledesc = ""
             dptdesc = "".

      find dpt_mstr where dpt_dept = xxdcs_dept no-lock no-error.
      if available dpt_mstr then assign dptdesc = dpt_desc.

      find code_mstr no-lock where code_fldname = "xxdcs_element" and
           code_value = xxdcs_element no-error.
      if available code_mstr then assign eledesc = code_cmmt.
      {mfrpchk.i}

        display xxdcs_period  column-label "分配期间"
              xxdcs_element column-label "因素"
              eledesc       column-label "因素说明"
              xxdcs_dept    column-label "部门"
              dptdesc       column-label "部门描述"
              xxdcs_amt     column-label "分配金额"
              with stream-io.
   end.
   {mfreset.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}
end.

{wbrp04.i &frame-spec = a}
