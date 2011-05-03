/* icsirp.p - SITE MASTER REPORT                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.13 $                                                          */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 6.0     LAST MODIFIED: 02/07/90   BY: EMB *                      */
/* REVISION: 6.0     LAST MODIFIED: 09/03/91   BY: afs *D847*                 */
/* Revision: 7.3     Last edit:     11/19/92   By: jcd *G348*                 */
/* REVISION: 7.3     LAST MODIFIED: 01/06/93   BY: pma *G510*                 */
/* REVISION: 7.3     LAST MODIFIED: 12/19/95   BY: bcm *G1H2*                 */
/* REVISION: 8.5     LAST MODIFIED: 03/19/96   BY: *J0CV* Robert Wachowicz    */
/* REVISION: 8.6     LAST MODIFIED: 03/11/97   BY: *K07B* Arul Victoria       */
/* REVISION: 8.6     LAST MODIFIED: 10/07/97   BY: mzv *K0M9*                 */
/* REVISION: 9.0     LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer    */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan          */
/* REVISION: 9.1     LAST MODIFIED: 10/01/99   BY: *N014* Brian Compton       */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.12    BY: Jean Miller          DATE: 04/06/02  ECO: *P056*     */
/* $Revision: 1.13 $ BY: Patrick Rowan DATE: 05/24/02  ECO: *P018* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 090907.1 By: Neil Gao */
/* SS - 090910.1 By: Neil Gao */
/* SS - 091103.1 By: Neil Gao */

/* DISPLAY TITLE */
{mfdtitle.i "091214.1"}

define variable vend like po_vend.
define variable vend1 like po_vend.
define variable shnbr like abs_id.
define variable shnbr1 like abs_id.
define variable ifpass as logical.
define var scmfilename as char format "x(40)".

form
   	vend           	colon 20
  	vend1 					colon 45
  	shnbr 					colon 20 label "货运单"
  	shnbr1 					colon 45 label "至"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


{wbrp01.i}
repeat:

	if vend1 = hi_char then vend1 = "".
	if shnbr1 = hi_char then shnbr1 = "".

   if c-application-mode <> 'web' then
      update vend vend1 shnbr shnbr1 with frame a.

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if vend1 = "" then vend1 = hi_char.
      if shnbr1 = "" then shnbr1 = hi_char.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
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

		/* 产生XML文件 */
		scmfilename = "".
		{gprun.i ""xxsccomCreateSendCommandData_ABS.p"" "(input vend,
		                               input vend1,
		                               input shnbr,
		                               input shnbr1,
		                               input-output scmfilename)"}
		 	if scmfilename <> "" then do:
		 		/* 加入上传排除 */
	  		{gprun.i ""xxpomt1xa2.p"" "(input scmfilename,input '')"}.
				


	  	end.
		  
   {mfphead.i}

				/*显示报表*/
				{gprun.i ""xxscshsirp01.p"" "(input vend,
		                               input  vend1,
		                               input shnbr,
		                               input shnbr1
		                               )"}

   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
