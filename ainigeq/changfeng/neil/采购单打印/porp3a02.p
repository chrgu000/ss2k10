/* porp3a02.p  - PURCHASE ORDER PRINT CONFIGURATION                     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*V8:ConvertMode=Report                                                 */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 8.6      LAST MODIFIED: 11/21/96   BY: *K022* Tejas Modi   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/20/00 BY: *N0GF* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KQ* myb              */
         {mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE porp3a02_p_1 "Qty Open"
/* MaxLen: Comment: */

/*N0GF*
 * &SCOPED-DEFINE porp3a02_p_2 "***Cont***"
 * /* MaxLen: Comment: */
 *N0GF*/

/* ********** End Translatable Strings Definitions ********* */

         define input parameter parent as character.
         define input parameter level as integer.
         define input parameter order as character.
         define input parameter line as integer.

         define variable fillchar as character no-undo.
         define variable parent_id as character no-undo.
         define variable sob-qty like sob_qty_req no-undo.
         define variable sob_desc like pt_desc1 no-undo.
         define variable sob_desc2 like pt_desc2 no-undo.
         define variable sob_um like pt_um no-undo.
         define variable cont_lbl as character format "x(10)"
/*N0GF*     initial {&porp3a02_p_2} no-undo. */
/*N0GF*/    no-undo.
         define variable qty_open like pod_qty_ord
            format "->>>>>>9.9<<<<<<" label {&porp3a02_p_1} no-undo.
         define variable tax_flag as character format "x(1)".
         define variable ext_cost like pod_pur_cost
            format "(z,zzz,zzz,zz9.99)".
         define shared variable pod_recno as recid.
         define shared frame c.

/*N0GF*/ assign cont_lbl = "  " + dynamic-function('getTermLabelFillCentered' in h-label,
/*N0GF*/                   input "CONTINUE", input 10, input '*').
         {po03d01.i}  /* DEFINATION FOR FRAME C */

         find pod_det where recid(pod_det) = pod_recno
         no-lock no-error.

         find sod_det where sod_nbr = order and sod_line = line
         no-lock no-error.

/*!      ***********************************************
         sob_serial subfield positions:
         1-4     operation number (old - now 0's)
         5-10    scr    ap percent
         11-14   id number of this record
         15-15   structure code
         16-16   "y" (indicates "new" format sob_det record)
         17-34   original qty per parent
         35-35   original mandatory indicator (y/n)
         36-36   original default indicator (y/n)
         37-39   leadtime offset
         40-40   price manually updated (y/n)
         41-46   operation number (new - 6 digits)
         *******************************************/

         /* NEW STYLE sob_det RECORDS DO NOT HAVE DATA IN sob_parent THAT
            CORRESPONDS TO A pt_part RECORD.  THEY CONTAIN A SYMBOLIC REFERNCE
            IDENTIFIED BY BYTES 11-14 IN sob_serial.
            NEW STYLE sob_det RECORDS ARE FOR SALES ORDERS CREATED
            SINCE PATCH FP28 AND GK60.
         */
         for each sob_det where sob_nbr = sod_nbr and sob_line = sod_line
         and sob_parent = parent and sob_qty_req <> 0 no-lock:
            if sod_qty_ord = 0 then sob-qty = 0.
            else sob-qty = sob_qty_req / sod_qty_ord.
            find pt_mstr where pt_part = sob_part no-lock no-error.
            if available pt_mstr then do:
               sob_desc = pt_desc1.
               sob_desc2 = pt_desc2.
               sob_um = pt_um.
            end.

            parent_id = substring(sob_serial, 11, 4).

            if page-size - line-counter < 1 then do:
               page.
               display pod_line pod_part cont_lbl @ qty_open with frame c.
               down 1 with frame c.
            end.

            fillchar = fill(".", level).

            put sob_feature format "x(12)" at 5 " "
                fillchar + sob_part format "x(27)"
                sob-qty " " sob_um.

            if sob_desc > "" then do:
               if page-size - line-counter < 1 then do:
                  page.
                  display pod_line pod_part cont_lbl @ qty_open with frame c.
                  down 1 with frame c.
               end.
               put sob_desc at 20 skip.
            end.
            if sob_desc2 > "" then do:
               if page-size - line-counter < 1 then do:
                  page.
                  display pod_line pod_part cont_lbl @ qty_open with frame c.
                  down 1 with frame c.
               end.
               put sob_desc2 at 20 skip.
            end.

            if parent_id <> "" then do:
               {gprun.i ""porp3a02.p"" "(input parent_id, input level + 1,
                                         input order, input line
                                         )"}
            end.
         end.
