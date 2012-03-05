/* rcinvchk.p - Inventory Status Check                                        */
/*Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                         */
/*All rights reserved worldwide.  This is an unpublished work.                */
/* $Revision: 1.8.3.4 $                                                */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 9.2       CREATED    : 12/15/01     BY: Ashwini G.   *M1LD*      */
/* Revision: 1.8     BY: Sandeep Parab         DATE: 06/04/02  ECO: *M1XH*  */
/* Revision: 1.8.3.1 BY: Karan Motwani         DATE: 01/05/04  ECO: *P1HP*  */
/* Revision: 1.8.3.2 BY: Binoy John            DATE: 01/27/05  ECO: *P35M*  */
/* $Revision: 1.8.3.4 $ BY: Shivganesh Hegde DATE: 06/21/05 ECO: *P3Q3*  */
/* $Revision: 1.8.3.4 $ BY: Bill Jiang DATE: 06/23/06 ECO: *SS - 20060623.1*  */
/* $Revision: 1.8.3.4 $ BY: Bill Jiang DATE: 06/28/06 ECO: *SS - 20060628.1*  */
/* $Revision: 1.8.3.4 $ BY: Bill Jiang DATE: 06/28/06 ECO: *SS - 20060628.2*  */

/* SS - 20060628.2 - B */
/*
1. 允许负数发货
*/
/* SS - 20060628.2 - E */

/* SS - 20060623.1 - B */
/*
1. 修正了允许过量发放的BUG
*/
/* SS - 20060623.1 - E */

/* SS - 20060623.1 - B */
/*
1. 允许负数发货
*/
/* SS - 20060623.1 - E */

/* SS - 20060623.1 - B */
DEFINE VARIABLE overissue LIKE IS_overissue.
/* SS - 20060623.1 - E */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* INCLUDE FILE SHARED VARIABLES */
{mfdeclre.i}

/* STANDARD MAINTENANCE COMPONENT INCLUDE FILE */
{pxmaint.i}

/* DEFINE THE PERSISTENT HANDLE */
{pxphdef.i socmnrtn}

/* DEFINE INPUT/OUTPUT PARAMETER */
define input  parameter  l_part          like abs_item    no-undo.
define input  parameter  l_site          like abs_site    no-undo.
define input  parameter  l_loc           like abs_loc     no-undo.
define input  parameter  l_lot           like abs_lot     no-undo.
define input  parameter  l_ref           like abs_ref     no-undo.
define input  parameter  l_qty           like abs_qty     no-undo.
define input  parameter  l_lineid        like abs_id      no-undo.
define input  parameter  l_avoid_final   like mfc_logical no-undo.
define output parameter  l_undo          like mfc_logical no-undo.

/* DEFINE SHARED TEMP-TABLE */
define shared temp-table work_ldd                   no-undo
   field work_ldd_id  like abs_id
   index work_ldd_id  work_ldd_id.

/* DEFINENING A SHARED TEMP-TABLE TO COMPUTE THE QUANTITY  */
/* TO CHECK AGAINST THE INVENTORY AVAILABLE FOR THAT ITEM  */

define shared temp-table compute_ldd                no-undo
   field compute_site   like abs_site
   field compute_loc    like abs_loc
   field compute_lot    like abs_lot
   field compute_item   like abs_item
   field compute_ref    like abs_ref
   field compute_qty    like abs_qty
   field compute_lineid like sr_lineid
   index compute_index compute_site compute_item
         compute_loc   compute_lot  compute_ref .

/* DEFINE LOCAL VARIABLES/BUFFER */
define        variable   l_status  like ld_status   no-undo.
define        buffer     ldd_det   for  ld_det.
define        variable   l_final   like  ld_qty_oh  no-undo.

/* RUN PROCEDURE socmnrtn.p PERSISTENTLY AND SET ph_socmnrtn AS */
/* HANDLE TO PERSISTENT PROCEDURE                               */

{pxrun.i
   &PROC    = 'GetInvStatus'
   &PROGRAM = 'socmnrtn.p'
   &HANDLE  = ph_socmnrtn
   &PARAM   = "(input  l_part,
                input  l_site,
                input  l_loc,
                input  l_lot,
                input  l_ref,
                output l_status,
                buffer ldd_det)"}.

/* SS - 20060628.1 - B */
overissue = NO.
/* SS - 20060628.1 - E */
if can-find(first is_mstr
            where is_status    = l_status
            and   is_overissue = yes    )
then  do:
   /* SS - 20060628.1 - B */
   overissue = YES.
   /* SS - 20060628.1 - E */

   if l_qty = 0
   then  do:

      l_undo = yes.

      /* UNABLE TO ISSUE OR RECEIVE FOR ITEM */
      {pxmsg.i
         &MSGNUM=161
         &ERRORLEVEL=3
         &MSGARG1=l_part}

      delete PROCEDURE ph_socmnrtn no-error.
      return .
   end. /* IF l_qty = 0 */

end . /* IF CAN-FIND(first is_mstr */

if can-find(first is_mstr
            where is_status    = l_status
            and   is_overissue = no)
then do:
   find first ldd_det
   where ldd_det.ld_part = l_part
   and   ldd_det.ld_lot  = l_lot
   and   ldd_det.ld_ref  = l_ref
   and   ldd_det.ld_site = l_site
   and   ldd_det.ld_loc  = l_loc
   exclusive-lock no-error.

   if  available ldd_det
   and ldd_det.ld_qty_oh > 0
   then do:

      l_final = 0.

      if not l_avoid_final
      then do:

         for each compute_ldd
            where compute_site    = l_site
            and compute_item    = l_part
            and compute_lot     = l_lot
            and compute_ref     = l_ref
            and compute_loc     = l_loc
            and compute_lineid <> l_lineid
         no-lock:

            l_final = l_final + compute_qty.

         end. /* FOR EACH compute_ldd */

      end. /* IF NOT l_avoid_final */

      if absolute(l_qty) > ( ldd_det.ld_qty_oh - l_final )
         /* SS - 20060628.2 - B */
         AND l_qty >= 0
         /* SS - 20060628.2 - E */
      then do:
         l_undo = yes.

         /* UNABLE TO ISSUE OR RECEIVE FOR ITEM */
         {pxmsg.i
            &MSGNUM=161
            &ERRORLEVEL=3
            &MSGARG1=l_part}

         delete PROCEDURE ph_socmnrtn no-error.
         return.
      end. /* IF abs(l_qty) .. */
      else do:
         create work_ldd.
         work_ldd_id = l_lineid.
      end. /* ELSE DO */

      if not l_avoid_final
         then do:

         for first compute_ldd
            where compute_lineid  = l_lineid
         no-lock:
         end. /* FOR FIRST compute_ldd */

         if available compute_ldd
         then do:
            assign
               compute_qty  = l_qty
               compute_site = l_site
               compute_loc  = l_loc
               compute_lot  = l_lot
               compute_ref  = l_ref .
         end .  /* IF AVAILABLE compute_ldd */
         else if  not available compute_ldd
         then  do:
            create compute_ldd .
            assign
               compute_site   = l_site
               compute_item   = l_part
               compute_lot    = l_lot
               compute_ref    = l_ref
               compute_loc    = l_loc
               compute_qty    = l_qty
               compute_lineid = l_lineid .

            if recid(compute_ldd) = -1
            then .

         end . /* CREATE compute ldd */

         release  compute_ldd .

      end. /* IF NOT l_avoid_final */

   end. /* IF AVAILABLE ldd_det ... */
   else do:

      for first work_ldd
         fields (work_ld_id)
         where work_ldd_id = l_lineid
         no-lock:
      end. /* FOR FIRST work_ldd */

      if not available work_ldd
      then do:
         /* SS - 20060623.1 - B */
         IF (execname <> "rcsois.p" AND execname <> "rcshwb.p") OR l_qty >= 0 THEN DO:
         /* SS - 20060623.1 - E */
            l_undo = yes.

            /* UNABLE TO ISSUE OR RECEIVE FOR ITEM */
            {pxmsg.i
               &MSGNUM=161
               &ERRORLEVEL=3
               &MSGARG1=l_part}

            delete PROCEDURE ph_socmnrtn no-error.
            return.
         /* SS - 20060623.1 - B */
         END.
         /* SS - 20060623.1 - E */
      end. /* IF NOT AVAILABLE work_ldd  */
   end. /* ELSE DO - IF NOT AVAILABLE ldd_det */
   release ldd_det.
end. /* IF CAN-FIND is_mstr... */
else do:

   if can-find(si_mstr
                  where si_site     = l_site
                  and   si_auto_loc = no)
   then do:

      find first ldd_det
         where ldd_det.ld_part = l_part
         and   ldd_det.ld_lot  = l_lot
         and   ldd_det.ld_ref  = l_ref
         and   ldd_det.ld_site = l_site
         and   ldd_det.ld_loc  = l_loc
      exclusive-lock no-error.

      if not available ldd_det
         /* SS - 20060628.1 - B */
         AND overissue = NO
         /* SS - 20060628.1 - E */
      then do:
         l_undo = yes.

         /* UNABLE TO ISSUE OR RECEIVE FOR ITEM */
         {pxmsg.i
            &MSGNUM=161
            &ERRORLEVEL=3
            &MSGARG1=l_part}

         delete PROCEDURE ph_socmnrtn no-error.
         return.
      end. /* IF NOT AVAILABLE ldd_det */
   end. /* IF CAN-FIND(si_mstr... */
end. /*  ELSE DO: */


delete PROCEDURE ph_socmnrtn no-error.
