/* uxptsts.p - VALIDATE/UPDATE PT_STATUS VALIDATION FILE                      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6.1.5 $                                                       */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.3      LAST MODIFIED: 06/26/96    *F0XC  BY: Russ Witt         */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 08/16/00   BY: *N0LL* Dave Caveney       */
/* REVISION: 9.1      LAST MODIFIED: 08/30/00   BY: *N0QM* Jean Miller        */
/* $Revision: 1.6.1.5 $  BY: Jean Miller         DATE: 12/14/01  ECO: *P03Q*  */
/* $Revision: 1.6.1.5 $  BY: Bill Jiang         DATE: 08/29/06  ECO: *SS - 20060829.1*  */

/* SS - 20060829.1 - B */
/*
1. 字段帮助装入
*/
/* SS - 20060829.1 - E */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mgbdpro_p_14 "Input File Name"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable file_name as character format "x(20)"
   label {&mgbdpro_p_14}.

form
   file_name COLON 30
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

PAUSE 0.

repeat:

   /* Display Utility Information */
   {gpcdget.i "UT"}

   update
      file_name
   with frame a.

   IF search(file_name) = ? THEN DO:
      /* 找不到文件:# */
      {pxmsg.i &MSGNUM=391 &ERRORLEVEL=3 &MSGARG1=file_name}
      UNDO,RETRY.
   END.

   {mfquoter.i file_name }

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   {mfphead.i}

   REPEAT:
      {gprun.i ""xxmgflh0a.p"" "(
         INPUT FILE_name
         ")}

      LEAVE.
   END.

   {mfrtrail.i}

end.              /* END REPEAT   */
