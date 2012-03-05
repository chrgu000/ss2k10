/* faderpa.p PRINT DEPRECIATION EXPENSE REPORT SUBROUTINE                   */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.10.1.17 $                                                             */
/*V8:ConvertMode=Report                                              */
/* REVISION: 9.1      LAST MODIFIED: 10/26/99   BY: *N021* Pat Pigatti      */
/* REVISION: 9.1      LAST MODIFIED: 11/30/99   BY: *N062* P Pigatti        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/13/00   BY: *N0G1* BalbeerS Rajput  */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L0* Jacolyn Neder    */
/* REVISION: 9.1      LAST MODIFIED: 10/17/00   BY: *M0V2* Veena Lad        */
/* REVISION: 9.1      LAST MODIFIED: 12/28/00   BY: *M0YX* Jose Alex        */
/* Revision:              BY: Vinod Nair        DATE: 12/24/01  ECO: *M1N8* */
/* Revision: 1.10.1.14    BY: Ashish Kapadia    DATE: 07/10/02  ECO: *M1ZW* */
/* Revision: 1.10.1.15    BY: Vivek Gogte       DATE: 11/11/02  ECO: *N1YX* */
/* $Revision: 1.10.1.17 $      BY: Rajesh Lokre      DATE: 05/19/03  ECO: *N240* */
/* $Revision: 1.10.1.17 $      BY: Bill Jiang      DATE: 01/01/06  ECO: *SS - 20060101* */
/* $Revision: 1.10.1.17 $      BY: Bill Jiang      DATE: 03/23/06  ECO: *SS - 20060323* */
/* $Revision: 1.10.1.17 $      BY: Bill Jiang      DATE: 03/27/06  ECO: *SS - 20060327* */


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20060327 - B */
/*
1. 不包括已经报废的资产
*/
/* SS - 20060327 - E */

/* SS - 20060323 - B */
/*
1. 增加了以下字段的输出:FA_PURAMT
2. 增加原值的资产不考虑取代累计折旧,影响以下增加的字段:ACCDEPR_ADJ,EXPAMT_ADJ,ANNDEPR_ADJ
3. 可以输出已经不再提折旧的记录
*/
DEFINE BUFFER bfa1 FOR fa_mstr.
/* SS - 20060323 - E */

/* SS - 20060101 - B */             
{a6faderp02.i}
/* SS - 20060101 - E */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{wbrp02.i}   /* WEB ENABLEMENT INCLUDE */

/* Input Parmameters */
define input parameter fromEntity   like fa_entity   no-undo.
define input parameter toEntity     like fa_entity   no-undo.
define input parameter fromBook     like fabk_id     no-undo.
define input parameter toBook       like fabk_id     no-undo.
define input parameter fromClass    like fa_facls_id no-undo.
define input parameter toClass      like fa_facls_id no-undo.
define input parameter fromAsset    like fa_id       no-undo.
define input parameter toAsset      like fa_id       no-undo.
define input parameter l-yrper      like fabd_yrper  no-undo.
define input parameter l-yrper1     like fabd_yrper  no-undo.
define input parameter printTot     like mfc_logical no-undo.
define input parameter p-ndep       like mfc_logical no-undo.
define input parameter p-printtrans like mfc_logical no-undo.

/* DEFINE VARIABLES */
/* CHARACTER */
define variable perBeg  as character format "x(6)" no-undo.
define variable perEnd  as character format "x(6)" no-undo.
define variable l_fa_id like fa_id                 no-undo.

/* INTEGER */
define variable netBook    like fabd_peramt no-undo.
define variable costAmt    like fabd_peramt no-undo.
define variable accDepr    like fabd_accamt no-undo.
define variable expAmt     like fabd_peramt no-undo.
define variable assetCnt   as   integer     no-undo.
define variable netTot     like fabd_accamt no-undo.
define variable costTot    like fabd_accamt no-undo.
define variable accDeprTot like fabd_accamt no-undo.
define variable expTot     like fabd_accamt no-undo.
define variable annTot     like fabd_accamt no-undo.
define variable annDepr    like fabd_accamt no-undo.
define variable l_expamt   like fabd_peramt no-undo.

define variable total-assets       as integer                  no-undo.
define variable disp-totals        as character format "x(20)" no-undo.
define variable tot-assets-for-Rep as integer                  no-undo.

define variable l-book-totals    as character format "x(20)" no-undo.
define variable l-entity-totals  as character format "x(20)" no-undo.
define variable l-grand-totals   as character format "x(20)" no-undo.

define variable l_oldentity    like fa_entity  no-undo.
define variable l_oldyrper     like fabd_yrper no-undo.
define variable l_curryrper    like fabd_yrper no-undo.
define variable l_begyrper     like fabd_yrper no-undo.
define variable l_disp_trf     as   character format "x(17)" no-undo.
define variable l_disp_ent     as   character format "x(13)" no-undo.
define variable l_disp_fromper as   character format "x(15)" no-undo.
define variable l_disp_toper   as   character format "x(15)" no-undo.


/* TEMPORARY TABLE FOR TRANSFER DETAILS OF THE ASSET */
define temp-table tt_fabddetail no-undo
   field tt_fabd_fa_id       like fa_id
   field tt_fabd_entity      like fa_entity
   field tt_fabd_fabk_id     like fabd_fabk_id
   field tt_fabd_from_yrper  like fabd_yrper
   field tt_fabd_to_yrper    like fabd_yrper
   field tt_fabd_expense     like fabd_accamt
   index tt_detail is primary
         tt_fabd_fa_id tt_fabd_fabk_id tt_fabd_from_yrper.

define buffer fabddet for fabd_det.

/* DEFINE FORM */
form
   disp-totals
   costTot    at 44
   accDeprTot at 64
   expTot
   netTot
   annTot
with frame f-3 no-labels no-box no-attr-space width 132.

/* SET EXTERNAL LABELS */
/* SS - 20060101 - B */
/*
setFrameLabels(frame f-3:handle).
*/
/* SS - 20060101 - E */

form
   disp-totals no-label
   costTot     column-label "Cost" at 44
   accDeprTot  column-label "Prior Accum Dep Amt"
   expTot      column-label "Expense Amt"
   netTot      column-label "Net Book Value"
   annTot      column-label "Annual Depr Amt"
with frame f-4 no-box no-attr-space width 132.

/* SET EXTERNAL LABELS */
/* SS - 20060101 - B */
/*
setFrameLabels(frame f-4:handle).
*/
/* SS - 20060101 - E */

disp-totals = getTermLabel("TOTALS", 20).

/* BEGIN ADD **NEW FORM SECTION**            */

/* FRAME f-3a IS USED TO DISPLAY BOOK TOTALS */
/* WHEN printTot = "No"                      */
form
   l-book-totals
   costTot    at 44
   accDeprTot at 64
   expTot
   netTot
   annTot
with frame f-3a no-labels no-box no-attr-space width 132.

/* SET EXTERNAL LABELS */
/* SS - 20060101 - B */
/*
setFrameLabels(frame f-3a:handle).
*/
/* SS - 20060101 - E */

/* FRAME f-4a IS USED TO DISPLAY BOOK TOTALS */
/* WHEN printTot = "Yes"                     */
form
   l-book-totals no-label
   costTot     column-label "Cost"         at 44
   accDeprTot  column-label "Prior Accum Dep Amt"
   expTot      column-label "Expense Amt"
   netTot      column-label "Net Book Value"
   annTot      column-label "Annual Depr Amt"
with frame f-4a no-box no-attr-space width 132.

/* SET EXTERNAL LABELS */
/* SS - 20060101 - B */
/*
setFrameLabels(frame f-4a:handle).
*/
/* SS - 20060101 - E */

l-book-totals = getTermLabel("BOOK_TOTALS", 20).

/* FRAME f-7 IS USED TO DISPLAY ENTITY TOTALS */
/* WHEN printTot = "No"                       */
form
   l-entity-totals
   costTot    at 44
   accDeprTot at 64
   expTot
   netTot
   annTot
with frame f-7 no-labels no-box no-attr-space width 132.

/* SET EXTERNAL LABELS */
/* SS - 20060101 - B */
/*
setFrameLabels(frame f-7:handle).
*/
/* SS - 20060101 - E */

/* FRAME f-7a IS USED TO DISPLAY ENTITY TOTALS */
/* WHEN printTot = "Yes"                       */
form
   l-entity-totals no-label
   costTot         column-label "Cost"         at 44
   accDeprTot      column-label "Prior Accum Dep Amt"
   expTot          column-label "Expense Amt"
   netTot          column-label "Net Book Value"
   annTot          column-label "Annual Depr Amt"
with frame f-7a no-box no-attr-space width 132.

/* SET EXTERNAL LABELS */
/* SS - 20060101 - B */
/*
setFrameLabels(frame f-7a:handle).
*/
/* SS - 20060101 - E */

l-entity-totals = getTermLabel("ENTITY_TOTALS", 20).

/* FRAME f-8 IS USED TO DISPLAY GRAND TOTALS   */
form
   l-grand-totals no-label
   costTot        column-label "Cost"         at 44
   accDeprTot     column-label "Prior Accum Dep Amt"
   expTot         column-label "Expense Amt"
   netTot         column-label "Net Book Value"
   annTot         column-label "Annual Depr Amt"
with frame f-8 no-box no-attr-space width 132.

/* SET EXTERNAL LABELS */
/* SS - 20060101 - B */
/*
setFrameLabels(frame f-8:handle).
*/
/* SS - 20060101 - E */

l-grand-totals = getTermLabel("GRAND_TOTALS", 20).

/* END ADD **NEW FORM SECTION**                */

/* REPORT LOGIC */

empty temp-table tt_fabddetail.

/* COMBINED for first fa_mstr WITH for each fabd_det TO CORRECT */
/* THE PROBLEM OF TOTALS NOT PRINTED WHEN THE NON-DEPRECIATING  */
/* ASSET IS THE LAST ASSET IN A BREAK GROUP                     */

/* GET EACH ASSET ID WITHIN USER SELECTED RANGES */
for each fabd_det
   fields(fabd_fa_id fabd_fabk_id fabd_facls_id fabd_entity fabd_yrper)
   where fabd_entity   >= fromEntity
   and   fabd_entity   <= toEntity
   and   fabd_fa_id    >= fromAsset
   and   fabd_fa_id    <= toAsset
   and   fabd_fabk_id  >= fromBook
   and   fabd_fabk_id  <= toBook
   /* SS - 20060323 - B */
   /* 3. 可以输出已经不再提折旧的记录
   and   fabd_yrper    >= l-yrper
   */
   /* SS - 20060323 - E */
   and   fabd_yrper    <= l-yrper1
   and   fabd_facls_id >= fromClass
   and   fabd_facls_id <= toClass
   no-lock,
   first fa_mstr
   /* SS - 20060327 - B */
   /*
      fields(fa_id fa_desc1 fa_dep fa_puramt fa_auth_number fa_startdt)
   */
   /* SS - 20060327 - E */
      where fa_id = fabd_fa_id
      and   (p-ndep or fa_dep)
      no-lock
      break by fabd_entity
            by fabd_fabk_id
            by fabd_facls_id
            by fabd_fa_id:

   /* SS - 20060327 - B */
   /* 1. 不包括已经报废的资产 */
   IF fa_disp_dt <> ? THEN DO:
      IF STRING(YEAR(fa_disp_dt)) + SUBSTRING(STRING(100 + MONTH(fa_disp_dt)), 2) >= l-yrper AND STRING(YEAR(fa_disp_dt)) + SUBSTRING(STRING(100 + MONTH(fa_disp_dt)), 2) <= l-yrper1 THEN DO:
         NEXT.
      END.
   END.
   /* SS - 20060327 - E */

   /* ONLY FIND COST AMOUNT IF NEW ASSETid OR BOOK */
   /* ACCUMULATE DEPR AND NET BOOK AMOUNTS */

   /* FIRST-OF(fabd_fa_id) HERE GIVES UNIQUE RECORD FOR */
   /* ASSET, BOOK AND ENTITY COMBINATION                */
   if first-of(fabd_fa_id)
   then do:

      /* GET CORRECT STARTING YEAR PERIOD FOR USE IN OBTAINING */
      /* TRANSFER DETAILS IN CASE ASSET HAS BEEN TRANSFERRED   */
      if l-yrper <> ""
      then
         l_begyrper = l-yrper.
      else do:
         for first fabddet
            fields (fabd_fa_id fabd_fabk_id fabd_yrper)
            where fabddet.fabd_fa_id   = fabd_det.fabd_fa_id
            and   fabddet.fabd_fabk_id = fabd_det.fabd_fabk_id
            no-lock:
            l_begyrper = fabddet.fabd_yrper.
         end. /*  FOR FIRST fabddet */
      end.  /* ELSE */

      /* GET THE ASSET COST AS OF TO YEAR/PERIOD */
      {gprunp.i "fapl" "p" "fa-get-cost-asof-date"
         "(input  fa_id,
           input  fabd_fabk_id,
           input  l-yrper1,
           input  no,
           output costAmt)"}

      /* GET THE TOTAL PERIOD DEPRECIATION FOR    */
      /* GIVEN YEAR/PERIOD RANGE.                 */

      {gprunp.i "fapl" "p" "fa-get-perdep-range"
         "(input fa_id,
          input  fabd_fabk_id,
          input  l_begyrper,
          input  l-yrper1,
          output expAmt)"}

      {gprunp.i "fapl" "p" "fa-get-perdep"
         "(input  fa_id,
           input  fabd_fabk_id,
           input  l_begyrper,
           output l_expamt)"}

         /* SS - 20060323 - B */
      {gprunp.i "fapla" "p" "fa-get-accdep-a"
         "(input  fa_id,
           input  fabd_fabk_id,
           input  l_begyrper,
           output accDepr)"}
         /* SS - 20060323 - E */

      /* GET COST FROM fa_mstr FOR NON-DEPRECIATING ASSETS */
      if not fa_dep
      then
         costAmt = fa_puramt.

      assign
         accDepr = accDepr  - l_expamt
         netBook = (costAmt - accDepr) - expAmt
         perBeg  = string(integer(substring(l_begyrper,1,4))
                   - 1) + "12"
         perEnd  = string(substring(l_begyrper,1,4)) + "12".

      /* CREATE DETAIL RECORDS FOR THE TRANSFERRED ASSETS */
      if can-find(first fabddet
                  where fabddet.fabd_fa_id    =  fabd_det.fabd_fa_id
                  and   fabddet.fabd_fabk_id  =  fabd_det.fabd_fabk_id
                  and   fabddet.fabd_yrper    >= l_begyrper
                  and   fabddet.fabd_yrper    <= l-yrper1
                  and   fabddet.fabd_entity   <> fabd_det.fabd_entity)
      then do:

         /* CREATE TEMP-TABLE RECORDS FOR ASSET AND BOOK COMBINATION*/
         if not can-find(first tt_fabddetail
                         where tt_fabd_fa_id   = fabd_det.fabd_fa_id
                         and   tt_fabd_fabk_id = fabd_det.fabd_fabk_id)
         then do:

            /* CREATE DETAIL RECORDS */
            for each fabddet
               fields (fabd_fa_id fabd_fabk_id fabd_yrper fabd_entity)
               where fabddet.fabd_fa_id   =  fabd_det.fabd_fa_id
               and   fabddet.fabd_fabk_id =  fabd_det.fabd_fabk_id
               and   fabddet.fabd_yrper   >= l_begyrper
               and   fabddet.fabd_yrper   <= l-yrper1
               no-lock
               break by fabddet.fabd_yrper:

                  /* KEEP TRACK OF ENTITY AND YEAR PERIOD CHANGES */
                  if first(fabddet.fabd_yrper)
                  then
                     assign
                        l_oldentity  =  ""
                        l_oldyrper   = fabddet.fabd_yrper
                        l_curryrper  = fabddet.fabd_yrper.

                  if last-of(fabddet.fabd_yrper)
                  then do:
                     assign
                        l_oldyrper  = l_curryrper
                        l_curryrper = fabddet.fabd_yrper.

                  if l_oldentity <> fabddet.fabd_entity
                  then do:
                     if l_oldentity <> ""
                     then do:
                        find last tt_fabddetail
                           where tt_fabd_fa_id   = fabddet.fabd_fa_id
                           and   tt_fabd_fabk_id = fabddet.fabd_fabk_id
                        exclusive-lock no-error.

                        if available tt_fabddetail
                        then do:
                           /* GET THE TOTAL PERIOD DEPRECIATION FOR */
                           /* GIVEN YEAR/PERIOD RANGE.              */
                           {gprunp.i "fapl" "p" "fa-get-perdep-range"
                              "(input  tt_fabd_fa_id,
                                input  tt_fabd_fabk_id,
                                input  tt_fabd_from_yrper,
                                input  l_oldyrper,
                                output expAmt)"}

                           assign
                              tt_fabd_to_yrper = l_oldyrper.
                              tt_fabd_expense  = expAmt.

                        end. /* IF AVAILABLE tt_fabddetail */
                     end. /* IF l_oldentity <> "" */

                     create tt_fabddetail.
                     assign
                        tt_fabd_fa_id      = fabddet.fabd_fa_id
                        tt_fabd_entity     = fabddet.fabd_entity
                        tt_fabd_fabk_id    = fabddet.fabd_fabk_id
                        tt_fabd_from_yrper = fabddet.fabd_yrper
                        tt_fabd_to_yrper   = fabddet.fabd_yrper
                        l_oldentity        = fabddet.fabd_entity.

                  end. /* if l_oldentity <> fabd_entity */

                  /* UPDATE tt_fabd_to_yrper FOR LAST RECORD */
                  if last (fabddet.fabd_yrper)
                  then do :
                     find last tt_fabddetail
                        where tt_fabd_fa_id   = fabddet.fabd_fa_id
                        and   tt_fabd_fabk_id = fabddet.fabd_fabk_id
                     exclusive-lock no-error.

                     if available tt_fabddetail
                     then do:

                        /* GET THE TOTAL PERIOD DEPRECIATION FOR */
                        /* GIVEN YEAR/PERIOD RANGE.              */
                        {gprunp.i "fapl" "p" "fa-get-perdep-range"
                           "(input  tt_fabd_fa_id,
                             input  tt_fabd_fabk_id,
                             input  tt_fabd_from_yrper,
                             input  fabddet.fabd_yrper,
                             output expAmt)"}

                        assign
                           tt_fabd_to_yrper = fabddet.fabd_yrper
                           tt_fabd_expense  = expAmt.

                     end. /* IF AVAILABLE tt_fabddetail */
                  end. /* IF LAST(fabddet.fabd_yrper) */
               end. /* IF LAST-OF(fabddet.fabd_yrper)  */
            end. /* FOR EACH fabddet */
         end. /*if not can-find(tt_fabddetail */
      end. /* IF CAN-FIND(fabddet) */

      /* GET THE ANNUAL DEPRECIATION FOR YEAR OF l_begyrper */
      {gprunp.i "fapl" "p" "fa-get-anndep"
         "(input fa_id,
           input fabd_fabk_id,
           input perBeg,
           input perEnd,
           output annDepr)"}

   end. /* ASSET AND BOOK COMPARISON */

   /* SS - 20060101 - B */
   /*
   /* PRINT HEADERS OF REPORT */
   if last-of(fabd_fa_id)
      and line-counter = 1
      or  first-of(fabd_facls_id)
   then do with frame f-1:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame f-1:handle).

      display
         skip(1)
         fabd_entity
         skip
         fabd_fabk_id
         skip
         fabd_facls_id
         skip
      with frame f-1 down
      side-labels no-box no-attr-space width 132.
   end. /* IF last-of */
   */
   /* SS - 20060101 - E */

   /* PROCESS FOR EACH ASSET */
   if last-of(fabd_fa_id)
   then do:
      /* CHECK IF TRANSFER ENTRIES ARE AVAILABLE */
      if can-find(first tt_fabddetail
         where tt_fabd_fa_id   = fabd_det.fabd_fa_id
         and   tt_fabd_fabk_id = fabd_det.fabd_fabk_id
         and   tt_fabd_entity  = fabd_det.fabd_entity)
      then do:

         expAmt = 0.
         /* IF ASSET IS TRANSFERRED TO SAME ENTITY MULTIPLE */
         /* TIMES TOTAL THE EXPENSE AMT                     */
         for each tt_fabddetail
            where tt_fabd_fa_id   = fabd_det.fabd_fa_id
            and   tt_fabd_fabk_id = fabd_det.fabd_fabk_id
            and   tt_fabd_entity  = fabd_det.fabd_entity
            no-lock:
            expAmt = expAmt + tt_fabd_expense.
         end. /* for each tt_fabddetail */
      end. /* if can-find(first tt_fabddetail */

      /* ACCUMULATE TOTALS BY CLASS */
      accumulate costAmt (total by fabd_facls_id).
      accumulate accDepr (total by fabd_facls_id).
      accumulate expAmt (total by fabd_facls_id).
      accumulate netBook (total by fabd_facls_id).
      accumulate annDepr (total by fabd_facls_id).

      /* ACCUMULATE TOTALS BY BOOK */
      accumulate costAmt (total by fabd_fabk_id).
      accumulate accDepr (total by fabd_fabk_id).
      accumulate expAmt (total by fabd_fabk_id).
      accumulate netBook (total by fabd_fabk_id).
      accumulate annDepr (total by fabd_fabk_id).

      /* ACCUMULATE TOTALS BY ENTITY */
      accumulate costAmt (total by fabd_entity).
      accumulate accDepr (total by fabd_entity).
      accumulate expAmt  (total by fabd_entity).
      accumulate netBook (total by fabd_entity).
      accumulate annDepr (total by fabd_entity).

      /* ACCUMULATE FOR GRAND TOTALS */
      accumulate costAmt.
      accumulate accDepr.
      accumulate expAmt.
      accumulate netBook.
      accumulate annDepr.

      if printTot = no
      then do with frame f-2:
         /* SS - 20060101 - B */
         /*
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame f-2:handle).

         /* DISPLAY DETAIL REPORT */
         display
            fabd_det.fabd_fa_id @ l_fa_id column-label "Asset"
            fa_mstr.fa_desc1 format "x(29)"
            costAmt column-label "Cost"
            accDepr column-label "Prior Accum Dep Amt"
            expAmt  column-label "Expense Amt"
            netBook column-label "Net Book Value"
            annDepr column-label "Annual Depr Amt"
         with frame f-2 down no-box no-attr-space width 132.
         */
         CREATE tta6faderp02.
         ASSIGN
            tta6faderp02_fabd_entity = fabd_entity
            tta6faderp02_fabd_fabk_id = fabd_fabk_id
            tta6faderp02_fabd_facls_id = fabd_facls_id
            tta6faderp02_fabd_fa_id = fabd_det.fabd_fa_id
            tta6faderp02_fa_desc1 = fa_mstr.fa_desc1
            tta6faderp02_costAmt = costAmt
            tta6faderp02_accDepr = accDepr
            tta6faderp02_expAmt = expAmt
            tta6faderp02_netBook = netBook
            tta6faderp02_annDepr = annDepr
            .
         /* SS - 20060323 - B */
         /* 1. 增加了以下字段的输出:FA_PURAMT */
         IF STRING(YEAR(fa_mstr.fa_startdt)) + SUBSTRING(STRING(100 + MONTH(fa_mstr.fa_startdt)),2,2) <= l-yrper1 THEN DO:
            ASSIGN
               tta6faderp02_fa_puramt = fa_mstr.fa_puramt
               .
         END.

         /* 2. 增加原值的资产不考虑取代累计折旧,影响以下增加的字段:ACCDEPR_ADJ,EXPAMT_ADJ,ANNDEPR_ADJ */
         FIND FIRST bfa1 WHERE bfa1.fa_id = fa_mstr.fa_auth_number NO-LOCK NO-ERROR.
         IF AVAILABLE bfa1 THEN DO:
            FOR EACH fab_det NO-LOCK
               WHERE fab_fa_id = fabd_det.fabd_fa_id 
               AND fab_fabk_id = fabd_fabk_id
               AND STRING(YEAR(fab_ovrdt)) + SUBSTRING(STRING(100 + MONTH(fab_ovrdt)),2,2) < l-yrper
               USE-INDEX fab_resrv
               :
               ASSIGN
                  tta6faderp02_accDepr_adj = tta6faderp02_accDepr_adj + fab_ovramt
                  .
            END.
            FOR EACH fab_det NO-LOCK
               WHERE fab_fa_id = fabd_det.fabd_fa_id 
               AND fab_fabk_id = fabd_fabk_id
               AND STRING(YEAR(fab_ovrdt)) + SUBSTRING(STRING(100 + MONTH(fab_ovrdt)),2,2) >= l-yrper
               AND STRING(YEAR(fab_ovrdt)) + SUBSTRING(STRING(100 + MONTH(fab_ovrdt)),2,2) <= l-yrper1
               USE-INDEX fab_resrv
               :
               ASSIGN
                  tta6faderp02_expAmt_adj = tta6faderp02_expAmt_adj + fab_ovramt
                  .
            END.
            FOR EACH fab_det NO-LOCK
               WHERE fab_fa_id = fabd_det.fabd_fa_id 
               AND fab_fabk_id = fabd_fabk_id
               AND STRING(YEAR(fab_ovrdt)) + SUBSTRING(STRING(100 + MONTH(fab_ovrdt)),2,2) > perBeg
               AND STRING(YEAR(fab_ovrdt)) + SUBSTRING(STRING(100 + MONTH(fab_ovrdt)),2,2) <= perEnd
               USE-INDEX fab_resrv
               :
               ASSIGN
                  tta6faderp02_annDepr_adj = tta6faderp02_annDepr_adj + fab_ovramt
                  .
            END.
         END.
         /* SS - 20060323 - E */
         /* SS - 20060101 - E */

         /* SS - 20060101 - B */
         /*
         /* PRINT TRANSFER DETAILS */
         if p-printtrans
         then  do :
            if can-find(first tt_fabddetail
                        where tt_fabd_fa_id    = fabd_det.fabd_fa_id
                        and   tt_fabd_fabk_id  = fabd_det.fabd_fabk_id)
            then do:

               down 1 with frame f-2.

               l_disp_trf = getTermLabelRtColon("TRANSFER_DETAILS",17).

               display
                  l_disp_trf  @  accDepr
               with frame f-2 no-box no-attr-space width 132.

               down 1 with frame f-2.
            end. /* IF CAN-FIND(FIRST tt_fabddetail  */

            /* DISPLAY TRANSFER DETAILS */
            for each tt_fabddetail
               where tt_fabd_fa_id   = fabd_det.fabd_fa_id
               and   tt_fabd_fabk_id = fabd_det.fabd_fabk_id
            no-lock:
               assign
                  l_disp_ent     = (getTermLabelRtColon("ENTITY", 8) +
                                    " " + tt_fabd_entity)
                  l_disp_fromper = getTermLabelRtColon("FROM", 8) +
                                   " " + tt_fabd_from_yrper
                  l_disp_toper   = getTermLabelRtColon("TO", 8) +
                                   " " + tt_fabd_to_yrper.


               display
                  l_disp_ent      @ accDepr
                  l_disp_fromper  @ expAmt
                  l_disp_toper    @ netBook
               with frame f-2 down no-box no-attr-space width 132.

               down 1  with frame f-2.

               display
                  tt_fabd_expense @ expAmt
               with frame f-2 down no-box no-attr-space width 132.

               down 1  with frame f-2.
            end. /* FOR EACH tt_fabddetail */
         end. /* IF p-printtrans */
         */
         /* SS - 20060101 - E */
      end. /* IF printTot = no */

      /* SS - 20060101 - B */
      /*
      /* ACCUMULATE ASSET COUNT ONLY FOR DETAIL RPT */
      accumulate fabd_fa_id (count by fabd_facls_id).
      accumulate fabd_fa_id (count).

      /* FOR EACH CLASS DISPLAY TOTALS/ASSET COUNT */
      if last-of(fabd_facls_id)
      then do with frame f-5:
         /* ADD A BLANK LINE */
         put skip(1).

         /* DISPLAY TOTALS */
         if printTot = no
         then
            display
               disp-totals
               accum total by fabd_facls_id costAmt @ costTot
               accum total by fabd_facls_id accDepr @ accDeprTot
               accum total by fabd_facls_id expAmt  @ expTot
               accum total by fabd_facls_id netBook @ netTot
               accum total by fabd_facls_id annDepr @ annTot
            with frame f-3.
         else
            display
               disp-totals
               accum total by fabd_facls_id costAmt @ costTot
               accum total by fabd_facls_id accDepr @ accDeprTot
               accum total by fabd_facls_id expAmt  @ expTot
               accum total by fabd_facls_id netBook @ netTot
               accum total by fabd_facls_id annDepr @ annTot
            with frame f-4.

         total-assets = accum count by fabd_facls_id fabd_fa_id.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame f-5:handle).
         display
            skip(1)
            total-assets label "Total Assets"
            skip(1)
         with frame f-5 down side-labels
         no-box no-attr-space width 132.
      end. /* IF LAST-OF fabd_fac_id */

      /* PAGE BREAKING */
      if page-size - line-counter < 3
      then
         page.
      */
      /* SS - 20060101 - E */
      {mfrpchk.i}
   end. /* IF LAST-OF fabd_fa_id */

   /* SS - 20060101 - B */
   /*
   /* DISPLAY TOTALS FOR EACH BOOK AND PAGE BRK */
   if last-of(fabd_fabk_id)
   then do:
      /* DISPLAY TOTALS BY BOOK*/
      if printTot = no
      then
         display
            l-book-totals
            accum total by fabd_fabk_id costAmt @ costTot
            accum total by fabd_fabk_id accDepr @ accDeprTot
            accum total by fabd_fabk_id expAmt @ expTot
            accum total by fabd_fabk_id netBook @ netTot
            accum total by fabd_fabk_id annDepr @ annTot
         with frame f-3a.
      else
         display
            l-book-totals
            accum total by fabd_fabk_id costAmt @ costTot
            accum total by fabd_fabk_id accDepr @ accDeprTot
            accum total by fabd_fabk_id expAmt @ expTot
            accum total by fabd_fabk_id netBook @ netTot
            accum total by fabd_fabk_id annDepr @ annTot
         with frame f-4a.

      if not last(fabd_entity)
         or ((page-size - line-counter) < 3)
      then
         page.
   end. /* IF LAST-OF fabd_fabk_id */

   /* DISPLAY TOTALS FOR EACH ENTITY AND PAGE BREAK */
   if last-of(fabd_entity)
   then do:

      /* DISPLAY TOTALS BY ENTITY                   */
      if printTot = no
      then
         display
            l-entity-totals
            accum total by fabd_entity costAmt @ costTot
            accum total by fabd_entity accDepr @ accDeprTot
            accum total by fabd_entity expAmt  @ expTot
            accum total by fabd_entity netBook @ netTot
            accum total by fabd_entity annDepr @ annTot
         with frame f-7.
      else
         display
            l-entity-totals
            accum total by fabd_entity costAmt @ costTot
            accum total by fabd_entity accDepr @ accDeprTot
            accum total by fabd_entity expAmt  @ expTot
            accum total by fabd_entity netBook @ netTot
            accum total by fabd_entity annDepr @ annTot
         with frame f-7a.

      if not last(fabd_entity)
         or ((page-size - line-counter) < 3)
      then
         page.

      /* PRINT ASSET COUNT AT END */
      if last(fabd_entity)
      then do with frame f-6:

         tot-assets-for-Rep = accum count fabd_fa_id.

         /* SET EXTERNAL LABELS   */
         setFrameLabels(frame f-6:handle).

         display
            skip(1)
            tot-assets-for-Rep label "Total Assets for Report"
            skip(1)
         with frame f-6 down side-labels
         no-box no-attr-space width 132.
      end. /* IF LAST(fabd_entity) */

      /* PRINT GRAND TOTAL AT END */
      if last(fabd_entity)
      then
         display
            skip(1)
            l-grand-totals
            accum total costAmt  @ costTot
            accum total accDepr  @ accDeprTot
            accum total expAmt   @ expTot
            accum total netBook  @ netTot
            accum total annDepr  @ annTot
         with frame f-8.

      if not last(fabd_entity)
         or ((page-size - line-counter) < 3)
      then
         page.

   end. /* IF LAST-OF fabd_entity */
   */
   /* SS - 20060101 - E */

end. /* FOR EACH fabd_det */

/* WEB ENABLEMENT INCLUDE */
{wbrp04.i}
