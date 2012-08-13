/* mfgrptrm.i - Run the report-to-window program                        */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*V8:ConvertMode=NoConvert                                              */
/* REVISION: 8.3      LAST MODIFIED: 02/16/95   BY: gui                 */
/* Revision: 8.5      Last Modified: 10/16/95         By: jpm  *J08V*/
/* Revision: 8.5      Last Modified: 02/26/96         By: rkc  *G1D6*/
/* Revision: 8.5      Last Modified: 02/26/96         By: rkc  *G1GL*/
/* REVISION: 8.5      LAST MODIFIED: 03/11/96         BY: rkc  *G1MR*/
/* REVISION: 9.1      LAST MODIFIED: 08/13/00         BY: *N0KR* myb    */


/*G1MR*/ {gprptdef.i}
/*G1D6*/ {mfguidel.i}
if report-to-window then do:
/*G1GL*/ output close.
/*G1MR*  {gprun.i ""gpwinrun.p"" "(input 'gprptwin.p', input '')"}  */
/*G1MR*/ {gprun.i ""gpwinrun.p"" "(input 'gprptwin.p', input "{&RPT-LEADER}" + CURRENT-WINDOW:TITLE)"}
         report-to-window = no.
end. /* if report-to-window */
