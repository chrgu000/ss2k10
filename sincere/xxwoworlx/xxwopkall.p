/* wopkall.p - WORK ORDER PICK LIST HARD ALLOCATIONS                          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.11 $                                                  */

/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED: 05/03/90   BY: MLB **D024*               */
/* REVISION: 6.0      LAST MODIFIED: 05/30/90   BY: emb                       */
/* REVISION: 6.0      LAST MODIFIED: 10/07/91   BY: alb *D887*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 02/08/93   BY: emb *G656*                */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.6    BY: Katie Hilbert  DATE: 04/01/01 ECO: *P008*             */
/* Revision: 1.7    BY: Russ Witt      DATE: 06/04/01 ECO: *P00J*             */
/* Revision: 1.9  BY: Niranjan R. DATE: 06/25/02 ECO: *P09L* */
/* $Revision: 1.11 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N* */
/* 100716.1  $  BY: mage chen  DATE: 07/16/10    ECO: *P45S*  */
/* 100727.1  $  BY: mage chen  DATE: 07/16/10    ECO: *P45S*  */

/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}

define shared variable wod_recno as recid.
define shared variable qty_to_all like wod_qty_all.
define variable all_this_loc like wod_qty_all.
define variable this_lot like ld_lot.
define variable flowOrder as logical no-undo.

define buffer lddet for ld_det.

find first icc_ctrl  where icc_ctrl.icc_domain = global_domain no-lock.
find wod_det where recid(wod_det) = wod_recno.

define temp-table tt_poul
   field tt_poul_wkctr      like poul_wkctr
   field tt_poul_site       like poul_site
   field tt_poul_mch        like poul_mch
   field tt_poul_preference like pould_preference
   field tt_poul_loc        like pould_loc
   field tt_index           as   integer
   index tt_index
      tt_index.

/* THIS IS FOR FLOW TYPE WORK ORDER OR REGULAR WORK ORDER ATTACHED TO FLOW */
if execname = "flschrc.p" then
   flowOrder = yes.

this_lot = ?.

if qty_to_all > 0 then do:

   /* THIS IS FOR FLOW TYPE WORK ORDER OR REGULAR WORK ORDER ATTACHED TO FLOW */
   if flowOrder then do:

      /* USE THE POINT OF USE LOGIC */
      run getPointOfUseLocation (input wod_nbr,
                                 input wod_lot,
                                 input wod_site,
                                 input wod_op,
                                 input wod_part
                                ).
   end.

   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
   wod_part no-lock no-error.
   if pt_sngl_lot then do:
      find first lad_det no-lock  where lad_det.lad_domain = global_domain and
      (  lad_dataset = "wod_det"
             and lad_nbr = wod_lot and lad_line = string(wod_op)
             and lad_part = wod_part
             and (lad_qty_all > 0 or lad_qty_pick > 0) ) no-error.
      if available lad_det then this_lot = lad_lot.
   end.

   if icc_ascend then do:
      if icc_pk_ord <= 2 then do:
      /*ss - 10070727.1 - b*
  {wopkall.i
            &sort1 = "(if icc_pk_ord = 1 then ld_loc else ld_lot)" }
*ss - 10070727.1 - e*/
/*ss - 10070727.1 - b*/
          {xxwopkall.i
            &sort1 = "(if icc_pk_ord = 1 then ld_loc else ld_lot)" }
/*ss - 10070727.1 - e*/


      end.
      else do:
       /*ss - 10070727.1 - b*
     {wopkall.i
            &sort1 = "(if icc_pk_ord = 3 then ld_date else ld_expire)" }
*ss - 10070727.1 - e*/
/*ss - 10070727.1 - b*/
          {wopkall.i
            &sort1 = "(if icc_pk_ord = 3 then ld_date else ld_expire)" }
/*ss - 10070727.1 - e*/


      end.
   end.
   else do:
      if icc_pk_ord <= 2 then do:
           /*ss - 10070727.1 - b*
             {wopkall.i
            &sort1 = "(if icc_pk_ord = 1 then ld_loc else ld_lot)"
            &sort2 = "descending"}
*ss - 10070727.1 - e*/
/*ss - 10070727.1 - b*/
                {wopkall.i
            &sort1 = "(if icc_pk_ord = 1 then ld_loc else ld_lot)"
            &sort2 = "descending"}
/*ss - 10070727.1 - e*/



      end.
      else do:

  /*ss - 10070727.1 - b*
     {wopkall.i
            &sort1 = "(if icc_pk_ord = 3 then ld_date else ld_expire)"
            &sort2 = "descending"}
*ss - 10070727.1 - e*/
/*ss - 10070727.1 - b*/
         {wopkall.i
            &sort1 = "(if icc_pk_ord = 3 then ld_date else ld_expire)"
            &sort2 = "descending"}
/*ss - 10070727.1 - e*/

      end.
   end.
end. /* end - if qty_to_all > 0*/

/*============================================================================*/
PROCEDURE getPointOfUseLocation:
/* ---------------------------------------------------------------------------
Purpose:      For work center, machine and site read the work center location.
              Depending on the preference of location create temp table,
              which will be used while allocating the quantities.
Exceptions:
Conditions:
Pre:
Post:
Notes:
History:

Inputs:
   pWodNbr   - Work Order Number
   pWodLot   - Work Order Lot
   pWodSite  - Work Order Site
   pWodOp    - Work Order Operation
   pWodPart  - Work Order Item

Outputs:
   none

----------------------------------------------------------------------------*/

   define input parameter pWodNbr  like wod_nbr  no-undo.
   define input parameter pWodLot  like wod_lot  no-undo.
   define input parameter pWodSite like wod_site no-undo.
   define input parameter pWodOp   like wod_op   no-undo.
   define input parameter pWodPart like wod_part no-undo.

   define variable i as integer no-undo.

   for each tt_poul exclusive-lock:
      delete tt_poul.
   end.

   i = 1.

   for first wr_route
       where wr_route.wr_domain = global_domain and  wr_nbr = pWodNbr
      and   wr_lot = pWodLot
      and   wr_op  = pWodOp
   no-lock: end.
   if available wr_route then do:

      for first poul_mstr
          where poul_mstr.poul_domain = global_domain and  poul_wkctr = wr_wkctr
         and   poul_site  = pWodSite
         and   poul_mch   = wr_mch
      no-lock: end.
      if available poul_mstr then do:

         for each pould_det
             where pould_det.pould_domain = global_domain and
             pould_poul_ref_key = poul_ref_key
         use-index pould_preference
         no-lock:
            create tt_poul.
            assign
               tt_poul_wkctr      = poul_wkctr
               tt_poul_site       = poul_site
               tt_poul_mch        = poul_mch
               tt_poul_preference = pould_preference
               tt_poul_loc        = pould_loc
               tt_index           = i.
            .
            i = i + 1.
         end. /* for each pould_det */
      end. /* for first poul_mstr */

      /* MACHINE IS BLANK */
      for first poul_mstr
          where poul_mstr.poul_domain = global_domain and  poul_wkctr = wr_wkctr
         and   poul_site  = pWodSite
         and   poul_mch   = ""
      no-lock: end.
      if available poul_mstr then do:

         for each pould_det
             where pould_det.pould_domain = global_domain and
             pould_poul_ref_key = poul_ref_key
         use-index pould_preference
         no-lock:
            create tt_poul.
            assign
               tt_poul_wkctr      = poul_wkctr
               tt_poul_site       = poul_site
               tt_poul_mch        = poul_mch
               tt_poul_preference = pould_preference
               tt_poul_loc        = pould_loc
               tt_index           = i.
            .
            i = i + 1.
         end. /* for each pould_det */
      end. /* for first poul_mstr */

      /* SITE IS BLANK */
      for first poul_mstr
          where poul_mstr.poul_domain = global_domain and  poul_wkctr = wr_wkctr
         and   poul_mch   = wr_mch
         and   poul_site  = ""
      no-lock: end.
      if available poul_mstr then do:

         for each pould_det
             where pould_det.pould_domain = global_domain and
             pould_poul_ref_key = poul_ref_key
         use-index pould_preference
         no-lock:
            create tt_poul.
            assign
               tt_poul_wkctr      = poul_wkctr
               tt_poul_site       = poul_site
               tt_poul_mch        = poul_mch
               tt_poul_preference = pould_preference
               tt_poul_loc        = pould_loc
               tt_index           = i.
            .
            i = i + 1.
         end. /* for each pould_det */
      end. /* for first poul_mstr */

      /* BOTH SITE AND MACHINE IS BLANK */
      for first poul_mstr
          where poul_mstr.poul_domain = global_domain and  poul_wkctr = wr_wkctr
         and   poul_site  = ""
         and   poul_mch   = ""
      no-lock: end.
      if available poul_mstr then do:

         for each pould_det
             where pould_det.pould_domain = global_domain and
             pould_poul_ref_key = poul_ref_key
         use-index pould_preference
         no-lock:
            create tt_poul.
            assign
               tt_poul_wkctr      = poul_wkctr
               tt_poul_site       = poul_site
               tt_poul_mch        = poul_mch
               tt_poul_preference = pould_preference
               tt_poul_loc        = pould_loc
               tt_index           = i.
            .
            i = i + 1.
         end. /* for each pould_det */
      end. /* for first poul_mstr */

   end. /* if available wr_route */

   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = pWodPart
   no-lock no-error.
   if available pt_mstr then do:
      create tt_poul.
      assign
         tt_poul_site       = pt_site
         tt_poul_loc        = pt_loc
         tt_index           = i.
      .
      i = i + 1.
   end.

END PROCEDURE.
