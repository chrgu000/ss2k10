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
/* SS - 090917.1 By: Neil Gao */

/* SS 090910.1 - B */
/*
增加显示功能
*/
/* SS 090910.1 - E */

/* DISPLAY TITLE */
{mfdtitle.i "090910.1"}

define variable code like code_fldname.
define variable code1 like code_fldname.
define variable ifpass as logical.
define var scmfilename as char format "x(40)".

form
   	code           	colon 25
  	code1 					colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


{wbrp01.i}
repeat:

	if code1 = hi_char then code1 = "".

   if c-application-mode <> 'web' then
      update code code1 with frame a.

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if code1 = "" then code1 = hi_char.
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

   {mfphead.i}


			/*调用bill程序*/
		{gprun.i ""xxsccomCreateSendCommandData_CODE.p"" "(input code,
		                               input code1,
		                               input 'xxsccosi.p',
		                               input-output scmfilename)"}
		                               
		 	if scmfilename <> "" then do:
	  		{gprun.i ""xxpomt1xa2.p"" "(input scmfilename,input '')"}.
	  		for each code_mstr where code_fldname >= code and code_fldname <= code1 no-lock
	  			with frame c width 132 down :
	  				
	  			setframelabels(frame c:handle).
	  			
	  			disp code_fldname code_cmmt code_desc with frame c.
	  			down with frame c.
	  				
	  		end.
	  		
	  	end.
	  	

   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
