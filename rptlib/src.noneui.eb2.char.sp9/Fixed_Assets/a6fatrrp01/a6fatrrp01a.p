/* fatrrpa.p PRINT TRANSFER REPORT SUBROUTINE                                 */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.10.1.10 $                                                      */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 9.1     LAST MODIFIED: 10/26/99     BY: *N021* Pat Pigatti       */
/* REVISION: 9.1     LAST MODIFIED: 12/01/99     BY: *N066* Pat Pigatti       */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00     BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1     LAST MODIFIED: 07/14/00     BY: *N0G1* Rajinder Kamra    */
/* REVISION: 9.1     LAST MODIFIED: 08/14/00     BY: *N0L0* Jacolyn Neder     */
/* Revision: 1.10.1.9    BY: Jean Miller       DATE: 04/06/02  ECO: *P055*  */
/* $Revision: 1.10.1.10 $          BY: Nishit V          DATE: 01/14/03  ECO: *N242*  */
/* $Revision: 1.10.1.10 $          BY: Bill Jiang          DATE: 05/05/06  ECO: *SS - 20060505.1*  */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20060505.1 - B */
/*
1. 标准输入输出
2. 执行列表:
   a6fatrrp01.p
   a6fatrrp01a.p
*/
/* SS - 20060505.1 - E */

/* SS - 20060505.1 - B */
 {a6fatrrp01.i}
/* SS - 20060505.1 - E */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{wbrp02.i}   /* Web enablement include */

/* DEFINE VARIABLES */
/* INPUT PARAMTERS */
define input parameter fromAsset like fa_id no-undo.
define input parameter toAsset like fa_id no-undo.
define input parameter fromLoc like fa_faloc_id no-undo.
define input parameter toLoc like fa_faloc_id no-undo.
define input parameter fromClass like fa_facls_id no-undo.
define input parameter toClass like fa_facls_id no-undo.
define input parameter fromEntity like fa_entity no-undo.
define input parameter toEntity like fa_entity no-undo.
define input parameter yrPeriod like fabd_yrper no-undo.
define input parameter nonDepr like mfc_logical no-undo.
define input parameter fullDepr like mfc_logical no-undo.

/* CHARACTER */
define variable perDate like fabd_yrper format "x(7)" no-undo.

/* INTEGER */
define variable costAmt like fabd_peramt no-undo.
define variable netBook like fabd_peramt no-undo.
define variable accDepr like fabd_accamt no-undo.
define variable costTot like fabd_accamt no-undo.
define variable assetCnt as integer no-undo.
define variable total-assets as integer no-undo.

/* REPORT LOGIC */

for first fabk_mstr
fields(fabk_id fabk_post)
where fabk_post = yes
   and fabk_id > ""
no-lock: end.

if not available fabk_mstr then return.

/* Determine if asset has been transfered */
for each fabd_det
fields(fabd_fa_id fabd_faloc_id
       fabd_facls_id fabd_entity fabd_transfer fabd_yrper
       fabd_fabk_id fabd_trn_loc)
where fabd_entity >= fromEntity and
      fabd_entity <= toEntity and
      fabd_fa_id >= fromAsset and
      fabd_fa_id <= toAsset and
      fabd_faloc_id >= fromLoc and
      fabd_faloc_id <= toLoc and
      fabd_facls_id >= fromClass and
      fabd_facls_id <= toClass and
      fabd_transfer = yes and
      fabd_yrper = yrPeriod
no-lock break by fabd_faloc_id by fabd_fa_id:

   for first fa_mstr
   fields(fa_id fa_dep fa_desc1)
   where fa_id = fabd_fa_id
   no-lock: end.

   if not available (fa_mstr) then next.

   if nonDepr = yes or fa_dep = yes then do:

      /* Only accumulate and display results if new asset */
      if last-of(fabd_fa_id) then do:

         /* find cost,depr,net amounts and format date */
         {gprunp.i "fapl" "p" "fa-get-cost"
            "(input  fabd_fa_id,
              input  fabk_id,
              output costAmt)"}

         {gprunp.i "fapl" "p" "fa-get-accdep"
            "(input  fabd_fa_id,
              input  fabd_fabk_id,
              input  fabd_yrper,
              output accDepr)"}
         assign
            netBook = costAmt - accDepr
            perDate = substring(fabd_yrper,1,4) + "/" +
                      substring(fabd_yrper,5,2).

         /* Full Depreciation Check */
         if fullDepr = yes or netBook > 0 then do:

            /* Count all the assets to be displayed at bottom */
            accumulate fabd_fa_id (count by fabd_faloc_id).

            /* Total cost Amount */
            accumulate costAmt (total by fabd_faloc_id).

            /* SS - 20060505.1 - B */
            /*
            /* Display a blank line and location */
            if line-counter = 1 then do with frame f-1:

               /* SET EXTERNAL LABELS */
               setFrameLabels(frame f-1:handle).

               display
                  skip(1)
                  fabd_faloc_id
                  skip
                  perDate
                  skip(1)
               with frame f-1 down
               side-labels no-box no-attr-space width 132.

            end. /* if line-counter = 1 then */

            /* Display detail report */
            do with frame f-2:

               /* SET EXTERNAL LABELS */
               setFrameLabels(frame f-2:handle).

               display
                  fabd_det.fabd_fa_id
                  fa_mstr.fa_desc1
                  fabd_det.fabd_facls_id
                  fabd_det.fabd_entity
                  costAmt                column-label "Cost"
                  fabd_det.fabd_trn_loc  column-label "From"
                  fabd_det.fabd_faloc_id column-label "To"
               with frame f-2 down no-box no-attr-space width 132.

            end. /* do with */
            */
            CREATE tta6fatrrp01.
            ASSIGN
               tta6fatrrp01_fabd_faloc_id = fabd_faloc_id 
               tta6fatrrp01_perdate       = perdate
               tta6fatrrp01_fabd_fa_id    = fabd_det.fabd_fa_id
               tta6fatrrp01_fa_desc1      = fa_mstr.fa_desc1
               tta6fatrrp01_fabd_facls_id = fabd_det.fabd_facls_id
               tta6fatrrp01_fabd_entity   = fabd_det.fabd_entity
               tta6fatrrp01_costamt       = costamt
               tta6fatrrp01_fabd_trn_loc  = fabd_det.fabd_trn_loc
               .
            /* SS - 20060505.1 - E */

         end. /* if fullDep ... */

      end. /* last-of fabd_fa_id */

   end. /* if nonDepr ... */

   /* SS - 20060505.1 - B */
   /*
   /* Display total cost */
   if last-of(fabd_faloc_id) then do:

      display
         skip(1)
         getTermLabel("TOTAL_COST",14) format "x(14)"
         accum total by fabd_faloc_id costAmt
            format "->>,>>>>,>>>,>>9.99" at 76
      with frame f-3 no-labels no-box no-attr-space width 132.

      /* Display asset count */
      do with frame f-5:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame f-5:handle).

         total-assets = accum count by fabd_faloc_id fabd_fa_id.

         display
            skip(1)
            total-assets label "Total Assets"
         with frame f-5 down side-labels
         no-box no-attr-space width 132.

      end. /* do with */

      page.

   end. /* last-of faloc_id */

   /* Page breaking */
   if page-size - line-counter < 3 then
      page.
   */
   /* SS - 20060505.1 - E */

   {mfrpchk.i}

end. /* do for each fabd_det */

/* Web Enablement include */
{wbrp04.i}
