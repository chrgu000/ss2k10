/* adcsmt02.i - CUSTOMER MAINTENANCE FORMS a, b, and b2                      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.24 $                                                     */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 7.4      LAST MODIFIED: 10/12/93   BY: cdt  *H086*              */
/* REVISION: 7.4      LAST MODIFIED: 06/03/94   BY: dpm  *GK07*              */
/* REVISION: 7.4      LAST MODIFIED: 09/15/94   BY: ljm  *H521*              */
/* REVISION: 8.6      LAST MODIFIED: 10/10/96   BY: svs  *K007*              */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 04/15/98   BY: *L00R* Adam Harris       */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 06/19/98   BY: *L01N* Robin McCarthy    */
/* REVISION: 9.0      LAST MODIFIED: 11/20/98   BY: *M002* David Morris      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 06/30/99   BY: *N00S* Kedar Deherkar    */
/* REVISION: 9.1      LAST MODIFIED: 09/06/99   BY: *K22L* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Robin McCarthy    */
/* REVISION: 9.1      LAST MODIFIED: 05/08/00   BY: *N0B0* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/17/00   BY: *N0LJ* Mark Brown        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.20     BY: Katie Hilbert         DATE: 04/01/01 ECO: *P002*   */
/* Revision: 1.21     BY: Anil Sudhakaran       DATE: 04/09/01 ECO: *M0P4*   */
/* Revision: 1.22     BY: Hualin Zhong          DATE: 10/25/01 ECO: *P010*   */
/* Revision: 1.23     BY: Amit Chaturvedi       DATE: 01/20/03 ECO: *N20Y*   */
/* $Revision: 1.24 $    BY: Narathip W.           DATE: 04/17/03 ECO: *P0Q4*   */
/*111205.1 - add address columns to 66 character length.                      */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
{cxcustom.i "ADCSMT02.I"}
/* VARIABLE ADDED TO PERFORM DELETE DURING CIM.
* RECORD IS DELETED ONLY WHEN THE VALUE OF THIS VARIABLE
* IS SET TO "X" */
define variable batchdelete as character format "x(1)" no-undo.

{&ADCSMT02-I-TAG1}
form
   skip
   cm_addr        colon 10
   batchdelete    no-label colon 60
   ad_name        colon 10 form "x(86)"
   ad_line1       colon 10 form "x(86)"
   ad_line2       colon 10 form "x(86)"
   ad_line3       colon 10 form "x(86)"

   ad_city        colon 10
   ad_state
   ad_zip
   ad_format

   ad_country     colon 10
   ad_ctry                 no-label
   ad_county      colon 56

   ad_attn        colon 10
   ad_attn2       colon 43 label "[2]"

   ad_phone       colon 10
   ad_ext
   ad_phone2      colon 43 label "[2]"
   ad_ext2

   ad_fax         colon 10
   ad_fax2        colon 43 label "[2]"
   ad_date

with frame a title color normal
   (getFrameTitle("CUSTOMER_ADDRESS",24))
   side-labels width 80 attr-space.
{&ADCSMT02-I-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   cm_sort        colon 10
   cm_type        colon 60

   cm_slspsn[1]   colon 10 label "Salespsn1"
   mult_slspsn    colon 33 label "Multiple"
   cm_region      colon 60

   cm_shipvia     colon 10
   cm_curr        colon 60

   cm_ar_acct     colon 10
   cm_ar_sub               no-label
   cm_ar_cc                no-label

   cm_scurr       colon 60 label "Dual Pricing Cur"

   cm_resale      colon 10
   cm_site        colon 60

   cm_rmks        colon 10
   cm_lang        colon 60 label "Lang"

with frame b title color normal (getFrameTitle("CUSTOMER_DATA",20))
   side-labels
   width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

/* NEW FIELD ADDED AS cm__qadl01 */

form
   cm_taxable     colon 15
   /*V8! view-as fill-in size 3.5 by 1 */
   cm_class       colon 55
   cm_pr_list2    colon 15
   cm_sic         colon 55 format "x(8)"
   cm_pr_list     colon 15
   cm_partial     colon 55
   cm_fix_pr      colon 15
   cm__qadl01     colon 55 label "Invoice by Authorization"
with frame b2 title color normal (getFrameTitle("CUSTOMER_DATA",20))
   side-labels
   width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b2:handle).
