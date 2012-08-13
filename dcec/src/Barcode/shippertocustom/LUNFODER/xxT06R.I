/* GUI CONVERTED from t06r.i (converter v1.71) Sat May 23 00:21:13 1998 */
/* t06r.i - INFORMATIONAL TEXT TO DISPLAY FOR utshrel.p                      */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*V8:ConvertMode=Report                                                      */
/*K1Q4*/ /*V8:WebEnabled=No                                                  */
/* REVISION: 8.6            CREATED: 11/04/97   BY: *H1GD* Seema Varma       */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

"This utility reports and optionally deletes stranded qad_wkfl records."   at 2
"Pre-Shipper/Shipper Confirm (7.9.40 - xxrcsotr.p) uses the qad_wkfl to keep" at 2
"track of Sales Orders that are in the process of being confirmed."        at 2
"However, if the confirmation is aborted, then the qad_wkfl records are"   at 2
"stranded. Hence, no shipper associated with any of these orders can be"   at 2 "confirmed until the stranded qad_wkfl records are deleted."               at 2
skip(2)
