/* mfguidel.i - include file for removing cancel print dialog box    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */


/******************************** Tokens ********************************/
/*V8:ConvertMode=NoConvert                                              */
/************************************************************************/
/******************************** History *******************************/
/* Revision: 8.3           Created: 12/11/95     By: rkc      /*G1D6*/  */
/* Revision: 8.5     Last Modified: 03/04/96     By: jpm      /*J0CF*/  */
/* Revision: 9.1     Last Modified: 08/13/00     By: *N0KR* myb         */
/************************************************************************/

         /* Delete cancel dialog box, if it's still around */
         if valid-handle(frame-report-cancel) then do:
            pause 0 before-hide.
            delete widget frame-report-cancel.
         end.
