/* so10e02.i - INVOICE PRINT include file                               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.8.1.3 $                                                         */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 7.2      LAST MODIFIED: 11/16/94   BY: rxm *FT54 */
/* REVISION: 8.5      LAST MODIFIED: 01/08/96   BY: *J04C* Sue Poland   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* Note: To translate change what is in quotes and uncomment            */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00L* EvdGevel     */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 06/04/98   BY: *L01M* Jean Miller  */
/* REVISION: 8.6E     LAST MODIFIED: 07/08/98   BY: *J2Q6* Samir Bavkar */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.8.1.3 $       BY: Steve Nugent  DATE: 05/30/01  ECO: *P00G*    */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

 /*Fixes various standards violations, abbreviation, and
   indentation problems, many of these fixes were done without
   patch markers, please use RCS if you want to see prior
version of the file */

   /* ********** Begin Translatable Strings Definitions ********* */


&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

   &SCOPED-DEFINE so10e02_i_1 " Backorder"
   /* MaxLen: Comment: */
/* Chamged Shipped to Invoiced in so10e0d_1_2 */
&SCOPED-DEFINE so10e02_i_2 "   Invoiced"
   /* MaxLen: Comment: */

   &SCOPED-DEFINE so10e02_i_3 " Currency Price"
   /* MaxLen: Comment: */

   /* ********** End Translatable Strings Definitions ********* */

   /*       the translated text should be the same size if possible*/
   /*       this include file is called by sorp1001.p            */

   /* To keep invoice print and invoice reprint matching, changes made     */
   /* here must also be made in soivrp1a.p.                                */

   FORM /*GUI*/
   sod_part
   sod_um
   sod_qty_inv  column-label {&so10e02_i_2} format "->>>>>>9.9<<<<<"
   qty_bo       column-label {&so10e02_i_1}
   sod_taxable
   sod_price

   format "->>>>>>>,>>9.99<<<"
   ext_price
/*roger*/   np_fp   LABEL "类型"
with STREAM-IO /*GUI*/  frame d width 90.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

/* ADDED FOLLOWING SECTION */
FORM /*GUI*/
   sod_part
   sod_um

   sod_qty_inv  column-label {&so10e02_i_2} format "->>>>>>9.9<<<<<"

   qty_bo       column-label {&so10e02_i_1}
   sod_taxable
   sod_price
   ext_price

   et_ext_price column-label {&so10e02_i_3}
/*roger*/   np_fp   LABEL "类型"
with STREAM-IO /*GUI*/  frame deuro width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame deuro:handle).
