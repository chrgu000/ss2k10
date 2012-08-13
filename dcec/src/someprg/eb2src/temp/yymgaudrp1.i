/* GUI CONVERTED from mgaudrp1.i (converter v1.76) Tue May 28 13:03:12 2002 */
/* mgaudrp1.i - SUBROUTINE FOR AUDIT TRAIL REPORT                       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.7 $                                                     */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 7.3            CREATED: 02/22/93   by: JMS  *G657*         */
/* REVISION: 7.3            CREATED: 04/22/94   by: gjp  *GJ52*         */
/* REVISION: 7.3            CREATED: 04/22/94   by: gjp  *GJ53*         */
/* REVISION: 7.3      LAST MODIFIED: 03/31/95   BY: jwy  *G0JT*         */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.7 $    BY: Katie Hilbert         DATE: 05/25/02  ECO: *P072*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

assign
   array_field = no.

do i = 2 to 15:

   if aud_old_data[i] <> "" or aud_new_data[i] <> "" then
      assign array_field = yes.
end.

display
   aud_dataset format "x(14)" column-label "Table Name"
   aud_date                   column-label "Date!Time"
   aud_userid
   aud_key1 /*cj*/ FORMAT "x(60)"  column-label "Address!Sequence"
   "" @ data WITH STREAM-IO /*GUI*/ .

down 1.
display
   aud_time @ aud_date
   aud_key2 @ aud_key1 WITH STREAM-IO /*GUI*/ .
down 1.

do i = 1 to 15:
   if array_field or i = 1 then do:
      if array_field then
         fldstring = aud_field + "[" + string(i) + "]".
      else
         fldstring = aud_field.
      display
         fldstring format "x(30)"  @ data WITH STREAM-IO /*GUI*/ .
      down 1.

      display
         aud_old_data[i] format "x(30)" @ data WITH STREAM-IO /*GUI*/ .
      down 1.

      display
         aud_new_data[i] format "x(30)" @ data WITH STREAM-IO /*GUI*/ .
      down 1.

   end.
end.
