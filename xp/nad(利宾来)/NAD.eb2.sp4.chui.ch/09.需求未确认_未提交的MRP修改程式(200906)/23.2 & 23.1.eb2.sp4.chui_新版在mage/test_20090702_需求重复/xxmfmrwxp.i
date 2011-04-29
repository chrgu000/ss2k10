/* mfmrw.i - -- INCLUDE FILE FOR MRP WORKFILE UPDATE                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.10 $                                                     */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 1.0      LAST MODIFIED: 07/17/86   BY: EMB */
/* REVISION: 5.0      LAST MODIFIED: 01/04/91   BY: emb *B866*/
/* REVISION: 6.0      LAST MODIFIED: 07/05/90   BY: emb *D040*/
/* REVISION: 6.0      LAST MODIFIED: 11/05/90   BY: emb *D177*/
/* REVISION: 7.0      LAST MODIFIED: 10/25/91   BY: emb      */
/* REVISION: 7.3      LAST MODIFIED: 03/21/94   BY: pxd *FM90*/
/* REVISION: 7.5      LAST MODIFIED: 09/29/94   BY: tjs *J027*/
/* REVISION: 7.2      LAST MODIFIED: 05/25/95   BY: emb *F0S6*/
/* REVISION: 8.6      LAST MODIFIED: 03/05/98   BY: *J23R* Sandesh Mahagaokar */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 11/06/00   BY: *N0TN* Jean Miller        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.9      BY: Katie Hilbert         DATE: 03/23/01  ECO: *P008*   */
/* $Revision: 1.10 $     BY: Inna Fox              DATE: 05/02/02  ECO: *P05B*   */

/* $Revision: ss - 090616.1  $    BY: mage chen : 05/14/09 ECO: *090616.1*    */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/******************************************************************************/
/*!
{1} data set      {2} part number   {3} order number
{4} line number   {5} additionally indexed item (wod_op, ...)
{6} start date    {7} due date
{8} quantity      {9} order type    {10} detail (as a literal)
{11} site                           {12} detail (as a variable)
*/
/******************************************************************************/

/* SS - 090616.1 - B */
{inmrp1.i}
/* SS - 090616.1 - E */

if can-find (pt_mstr where pt_part = {2}) then do:

   for first mrp_det
         fields(mrp_dataset mrp_detail mrp_due_date mrp_line mrp_line2
                mrp_nbr mrp_part mrp_qty mrp_rel_date mrp_site mrp_type)
         where mrp_det.mrp_dataset = "{1}"
         and mrp_det.mrp_part = {2}
         and mrp_det.mrp_nbr = {3}
         and mrp_det.mrp_line = {4}
         and mrp_det.mrp_line2 = {5}
         no-lock /*no-error*/:
   end.

   if not available mrp_det
      and {7} <> ?
      and {8} <> 0 and {8} <> ?
   then do:

      create mrp_det.
      assign
         mrp_det.mrp_dataset = "{1}"
         mrp_det.mrp_part = {2}
         mrp_det.mrp_site = {11}
         mrp_det.mrp_nbr  = {3}
         mrp_det.mrp_line = {4}
         mrp_det.mrp_line2 = {5}.

         {mfmrkey.i}
         mrp_det.mrp_keyid = next_seq.

   end. /* if not available mrp_det */

   do while available mrp_det:

      if (mrp_det.mrp_site <> {11} and mrp_det.mrp_qty <> 0)
         or {8} = 0
         or {8} = ?
         or {7} = ?
         or (mrp_det.mrp_rel_date = {6}
         and mrp_det.mrp_due_date = {7}
         and mrp_det.mrp_qty  = {8}
         and mrp_det.mrp_type = "{9}"
         and mrp_det.mrp_site = {11})
      then do:

         run inmrp (input mrp_det.mrp_part, input mrp_det.mrp_site).
      end.

      mrp_recno = recid(mrp_det).

      find mrp_det
         exclusive-lock
         where recid(mrp_det) = mrp_recno.

      if {8} = 0
         or {8} = ?
         or {7} = ?
      then
         delete mrp_det.

      else do:

         if mrp_det.mrp_rel_date = {6}
            and mrp_det.mrp_due_date = {7}
            and mrp_det.mrp_qty  = {8}
            and mrp_det.mrp_type = "{9}"
            and mrp_det.mrp_site = {11}
         then
            leave.

         assign
            mrp_det.mrp_rel_date = {6}
            mrp_det.mrp_due_date = {7}
            mrp_det.mrp_qty  = {8}
            mrp_det.mrp_type = "{9}"
            mrp_det.mrp_site = {11}.

         if "{10}" > " " then
            mrp_det.mrp_detail = getTermLabel("{10}",24).

         if "{12}" > " " then
            mrp_det.mrp_detail = "" {12}.

      end. /* else do */

   end. /* do while available mrp_det */

end. /* if can-find(pt_mstr... */
