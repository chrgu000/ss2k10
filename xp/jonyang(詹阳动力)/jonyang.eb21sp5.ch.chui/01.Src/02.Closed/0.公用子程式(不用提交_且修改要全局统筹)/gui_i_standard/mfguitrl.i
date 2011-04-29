/* mfguitrl.i - Report trailer include file                             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.15 $                                                    */

/******************************** Tokens ********************************/
/*V8:ConvertMode=NoConvert                                              */
/*V8:RunMode=Windows                                                    */
/************************************************************************/
/******************************** History *******************************/
/* Revision: 8.3           Created: 05/02/94     By: gui                */
/* Revision: 8.3     Last modified: 11/06/95     By: rkc      /*G1CC*/  */
/* Revision: 8.3     Last modified: 01/23/96     By: dzn      /*G1KT*/  */
/* Revision: 8.5     Last Modified: 03/04/96     By: jpm      /*J0CF*/  */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98     BY: *L007* A. Rahane   */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98     BY: *J314* Alfred Tan  */
/* REVISION: 8.6F    LAST MODIFIED: 01/12/99     BY: *J372* Raphael T   */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00     BY: *N0KR* myb         */
/* Revision: 1.14    BY: Katie Hilbert  DATE: 03/09/01 ECO: *N0XB*      */
/* $Revision: 1.15 $   BY: A.R. Jayaram  DATE: 01/18/02 ECO: *N183*      */
/************************************************************************/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/********************************* Notes ********************************/
/*!
   Parameters:
     {1} "stream name"    (if necessary)
*/
/************************************************************************/

define variable criteria as character no-undo.
define variable criteria-column as integer no-undo.
define variable c-end-report as character format "x(27)" no-undo.
define variable c-rpt-crit   as character format "x(21)" no-undo.
define variable c-rpt-sub    as character format "x(26)" no-undo.

assign
   c-end-report = dynamic-function ('getTermLabelFillCentered' in h-label,
                         input "END_OF_REPORT",
                         input 27,
                         input "-")
   c-rpt-crit = CAPS(getTermLabel("REPORT_CRITERIA",20)) + ":"
   c-rpt-sub = getTermLabel("REPORT_SUBMITTED_BY",25) + ":".


display {1} skip(1)
   c-end-report no-label at 1
with frame rfoot width 80 stream-io.

if line-counter > 7 then do:
   page {1}.
end.

display
   {1}
   skip(3)
   c-rpt-crit    no-label
   space(19)
   c-rpt-sub     no-label
   report_userid no-label
   skip(1)
with stream-io.

/* Print all report criteria from frame a */
local-handle = frame a:FIRST-CHILD. /* field group */
local-handle = local-handle:FIRST-CHILD. /* first widget */
repeat while local-handle <> ?:

   if local-handle:TYPE = "FILL-IN"
   then do:
      criteria = local-handle:SCREEN-VALUE.
      if local-handle:LABEL <> ? then do:
         criteria = local-handle:LABEL + ": " + criteria.
         criteria-column = max(1, (local-handle:column -
                           length(local-handle:LABEL, "RAW"))).
      end.
      else
         criteria-column = max(1,local-handle:column).

      /* Print widget's current value */
      if criteria <> ? and criteria-column <> ? then
      put unformatted
         criteria
         at criteria-column.
   end.
   local-handle = local-handle:NEXT-SIBLING.

end.  /* repeat */

{mfreset.i}

{pxmsg.i &MSGNUM=9 &ERRORLEVEL=1} /* End of report */
