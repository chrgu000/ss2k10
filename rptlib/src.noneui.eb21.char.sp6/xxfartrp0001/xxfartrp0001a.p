/* fartrpa.p PRINT RETIREMENT REPORT SUBROUTINE                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.10.1.15 $                                                   */
/*V8:ConvertMode=FullGUIReport                                              */
/* REVISION: 9.1      LAST MODIFIED: 10/26/99   BY: *N021* Pat Pigatti      */
/* REVISION: 9.1      LAST MODIFIED: 12/01/99   BY: *N066* Pat Pigatti      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/13/00   BY: *N0G1* BalbeerS Rajput  */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L0* Jacolyn Neder    */
/* REVISION: 9.1      LAST MODIFIED: 11/09/00   BY: *M0W4* Shilpa Athalye   */
/* Revision: 1.10.1.10 BY: Mamata Samant         DATE: 01/14/02  ECO: *M1T6*  */
/* Revision: 1.10.1.12 BY: A.R. Jayaram          DATE: 12/24/02  ECO: *N22V*  */
/* Revision: 1.10.1.13  BY: Manish Dani DATE: 03/21/03 ECO: *N2B2* */
/* $Revision: 1.10.1.15 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00C* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 091106.1 By: Bill Jiang */

/* SS - 091106.1 - B */
{xxfartrp0001.i}
/* SS - 091106.1 - E */

{mfdeclre.i}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

/* WEB ENABLEMENT INCLUDE */
{wbrp02.i}

/* DEFINE VARIABLES */
/* INPUT PARAMTERS */
define input parameter fromAsset  like fa_id       no-undo.
define input parameter toAsset    like fa_id       no-undo.
define input parameter FromBook   like fabk_id     no-undo.
define input parameter toBook     like fabk_id     no-undo.
define input parameter fromLoc    like fa_faloc_id no-undo.
define input parameter toLoc      like fa_faloc_id no-undo.
define input parameter fromClass  like fa_facls_id no-undo.
define input parameter toClass    like fa_facls_id no-undo.
define input parameter fromEntity like fa_entity   no-undo.
define input parameter toEntity   like fa_entity   no-undo.
define input parameter fromDisp   like fa_disp_rsn no-undo.
define input parameter toDisp     like fa_disp_rsn no-undo.
define input parameter yrPeriod   like fabd_yrper  no-undo.
/* SS - 091106.1 - B */
define input parameter yrPeriod1   like fabd_yrper  no-undo.
/* SS - 091106.1 - E */
define input parameter nonDepr    like mfc_logical no-undo.

/* CHARACTER */
define variable retDate      like fabd_yrper               no-undo.
define variable disp-totals  as   character format "x(20)" no-undo.
define variable l-cal        as   character                no-undo.
define variable l-per        as   character                no-undo.

/* INTEGER */
define variable assetCnt     as   integer           no-undo.
define variable total-assets as   integer           no-undo.
define variable l-err-no     as   integer initial 0 no-undo.
define variable gainLossTot  like fabd_accamt       no-undo.
define variable costTot      like fabd_accamt       no-undo.
define variable accDeprTot   like fabd_accamt       no-undo.
define variable dispTot      like fabd_accamt       no-undo.

/* DEFINE BOOK/ASSET TEMPTABLE */
define temp-table T_bkAsset no-undo
   field bookId   like fabk_id
   field assetId  like fa_id
   field locat    like fa_faloc_id
   field classId  like fa_facls_id
   field entityId like fa_entity
   field costAmt  like fabd_peramt
   field accDepr  like fabd_accamt
   field dispAmt  like fa_dispamt
   field gainLoss like fabd_accamt
   field dispRsn  like fa_disp_rsn
   field dispDt   like fa_disp_dt.

/* REPORT LOGIC */
/* GET THOSE ASSETS THAT ARE WITHIN SELECTED RANGES */
for each fa_mstr
   fields( fa_domain fa_faloc_id fa_facls_id fa_entity
          fa_disp_rsn fa_disp_dt fa_dep fa_dispamt fa_id fa_puramt)
    where fa_mstr.fa_domain = global_domain and  fa_id       >= fromAsset
   and   fa_id       <= toAsset
   and   fa_facls_id >= fromClass
   and   fa_facls_id <= toClass
   and   fa_faloc_id >= fromLoc
   and   fa_faloc_id <= toLoc
   and   fa_entity   >= fromEntity
   and   fa_entity   <= toEntity
   and   fa_disp_dt  <> ?
   and   fa_disp_rsn >= fromDisp
   and   fa_disp_rsn <= toDisp
   no-lock:

   /* IF yrPer <> disp date OR NON DEPR ASSET DON'T RPT */

   if (nonDepr     = yes
   or  fa_dep      = yes)
   then do:

      /* FIND THE BOOK ID FOR EACH VALID ASSET */
      for each fab_det
          fields( fab_domain fab_fa_id fab_fabk_id)
           where fab_det.fab_domain = global_domain and  fab_fa_id    = fa_id
          and   fab_fabk_id >= fromBook
          and   fab_fabk_id <= toBook
          no-lock
          break by fab_fa_id
                by fab_fabk_id:

         if not first-of(fab_fabk_id)
         then
            next.

         /* FIND THE YR/PERIOD OF RETIREMENT BASED ON CALENDAR */

         for first fabk_mstr
            fields( fabk_domain fabk_calendar fabk_id fabk_post)
             where fabk_mstr.fabk_domain = global_domain and  fabk_id =
             fab_fabk_id
         no-lock:
         end. /* FOR FIRST fabk_mstr */

         if available fabk_mstr
         then
            l-cal = if fabk_post
                    then ""
                    else
                       fabk_calendar.

         {gprunp.i "fapl" "p" "fa-get-per"
            "(input  fa_disp_dt,
              input  l-cal,
              output l-per,
              output l-err-no)"}

         /* SS - 091106.1 - B
         if l-per = yrPeriod
         SS - 091106.1 - E */
         /* SS - 091106.1 - B */
         if l-per >= yrPeriod AND l-per <= yrPeriod1
         /* SS - 091106.1 - E */
         then do:

            /* SS - 091106.1 - B
            /* CREATE TEMP TABLE FOR BOOK AND ASSET DATA */
            create T_bkAsset.

            {gprunp.i "fapl" "p" "fa-get-cost"
               "(input  fab_fa_id,
                 input  fab_fabk_id,
                 output costAmt)"}

            {gprunp.i "fapl" "p" "fa-get-accdep"
               "(input  fab_fa_id,
                 input  fab_fabk_id,
                 input  yrPeriod,
                 output accDepr)"}

            assign
               bookId   =  fab_fabk_id
               assetId  =  fab_fa_id
               locat    =  fa_faloc_id
               classId  =  fa_facls_id
               entityId =  fa_entity
               dispAmt  =  fa_dispamt
               gainLoss =  (costAmt - accDepr) - dispAmt
               dispRsn  =  fa_disp_rsn
               dispDt   =  fa_disp_dt.
            SS - 091106.1 - E */
            /* SS - 091106.1 - B */
            /* CREATE TEMP TABLE FOR BOOK AND ASSET DATA */
            CREATE ttxxfartrp0001.

            {gprunp.i "fapl" "p" "fa-get-cost"
               "(input  fab_fa_id,
                 input  fab_fabk_id,
                 output ttxxfartrp0001_fabd_peramt)"}

            {gprunp.i "fapl" "p" "fa-get-accdep"
               "(input  fab_fa_id,
                 input  fab_fabk_id,
                 input  yrPeriod,
                 output ttxxfartrp0001_fabd_accamt)"}

            ASSIGN
               ttxxfartrp0001_fabk_id = fab_fabk_id
               ttxxfartrp0001_fa_id = fab_fa_id
               ttxxfartrp0001_fa_faloc_id = fa_faloc_id
               ttxxfartrp0001_fa_facls_id = fa_facls_id
               ttxxfartrp0001_fa_entity = fa_entity
               ttxxfartrp0001_fa_dispamt = fa_dispamt
               ttxxfartrp0001_fabd_gainamt = (ttxxfartrp0001_fabd_peramt - ttxxfartrp0001_fabd_accamt) - fa_dispamt
               ttxxfartrp0001_fa_disp_rsn = fa_disp_rsn
               ttxxfartrp0001_fa_disp_dt = fa_disp_dt
               .
            /* SS - 091106.1 - E */
         end. /* IF l-per = yrPeriod */
      end. /* FOR EACH fab_det */

      /* CREATING TEMPTABLE T_bkAsset RECORDS FOR */
      /* NON-DEPRECIATING ASSETS.                 */
      if fa_dep = no
      then do:
         /* SS - 091106.1 - B
         create T_bkAsset.
         assign
            assetId  =  fa_id
            locat    =  fa_faloc_id
            classId  =  fa_facls_id
            entityId =  fa_entity
            costAmt  =  fa_puramt
            accDepr  =  0
            dispAmt  =  fa_dispamt
            gainLoss =  (costAmt - accDepr)
                      - dispAmt
            dispRsn  =  fa_disp_rsn
            dispDt   =  fa_disp_dt.
         SS - 091106.1 - E */
         /* SS - 091106.1 - B */
         CREATE ttxxfartrp0001.
         ASSIGN
            ttxxfartrp0001_fa_id = fa_id
            ttxxfartrp0001_fa_faloc_id = fa_faloc_id
            ttxxfartrp0001_fa_facls_id = fa_facls_id
            ttxxfartrp0001_fa_entity = fa_entity
            ttxxfartrp0001_fabd_peramt = fa_puramt
            ttxxfartrp0001_fabd_accamt = 0
            ttxxfartrp0001_fa_dispamt = fa_dispamt
            ttxxfartrp0001_fabd_gainamt = (fa_puramt - 0) - fa_dispamt
            ttxxfartrp0001_fa_disp_rsn = fa_disp_rsn
            ttxxfartrp0001_fa_disp_dt = fa_disp_dt
            .
         /* SS - 091106.1 - E */

      end. /* IF fa_dep = no */
   end. /* IF nonDepr = yes  */
end. /* FOR EACH fa_mstr */

/* SS - 091106.1 - B
disp-totals = getTermLabel("TOTALS", 20).

/* CHECK TEMP TABLE TO FORMAT REPORT */
for each T_bkAsset
no-lock
break by bookId
      by assetId:

   /* DETERMINE ASSET COUNT BY BOOK */
   accumulate assetId  (count by bookId).

   /* ACCUMULATE TOTALS */
   accumulate costAmt  (total by bookId).
   accumulate accDepr  (total by bookId).
   accumulate dispAmt  (total by bookId).
   accumulate gainLoss (total by bookId).

   /* PRINT HEADERS OF REPORT */
   if line-counter = 1
   then do with frame f-1:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame f-1:handle).
      display
         skip(1)
         bookId
         skip(1)
      with frame f-1 down
         side-labels no-box no-attr-space width 132.
   end. /* IF line-counter = 1 */

   /* PRINT COLUMN HEADERS AND DETAILS */
   do with frame f-2:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame f-2:handle).
      display
         assetId
         locat
         classId
         entityId column-label "Ent"
         costAmt  column-label "Cost"
         accDepr  column-label "Acc Depr Amt"
         dispAmt  column-label "Disposal Amt"
         gainLoss column-label "Gain/Loss"
         dispRsn  column-label "Reason"
         dispDt
      with frame f-2 down no-box no-attr-space width 132.
   end. /* DO WITH FRAME f-2 */

   /* PRINT OUT ASSET COUNT AFTER EVERY BOOK */
   if last-of(bookId)
   then do:

      /* ADD A BLANK LINE */
      put skip(1).

      /* DISPLAY TOTALS */
      display
         disp-totals
         accum total by bookId costAmt  format "->>>>,>>>,>>9.99" at 37
         accum total by bookId accDepr  format "->>>>,>>>,>>9.99" at 54
         accum total by bookId dispAmt  format "->>>>,>>>,>>9.99" at 71
         accum total by bookId gainLoss format "->>>>,>>>,>>9.99" at 88
      with frame f-3 no-labels no-box no-attr-space width 132.

      /* DISPLAY ASSET COUNT */
      do with frame f-5:

         total-assets = accum count by bookId assetId.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame f-5:handle).
         display
            skip(1)
            total-assets label "Total Assets"
         with frame f-5 down side-labels
            no-box no-attr-space width 132.
      end. /* DO WITH FRAME f-5 */

      assetCnt = 0.
      page.
   end. /* IF LAST-OF(bookId) */

   /* PAGE BREAKING */
   if page-size - line-counter < 3
   then
      page.
   {mfrpchk.i}

end. /* FOR EACH T_bkAsset */
SS - 091106.1 - E */

/* WEB ENABLEMENT INCLUDE */
{wbrp04.i}
