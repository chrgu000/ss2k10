/* fadarpa.p PRINT DEPRECIATION ARRAY REPORT SUBROUTINE                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 9.1     LAST MODIFIED: 10/26/99     BY: *N021* Pat Pigatti */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane*/
/* REVISION: 9.1     LAST MODIFIED: 08/14/00 BY: *N0L0* Jacolyn Neder   */
/* REVISION: 9.1     LAST MODIFIED: 08/28/00 BY: *N0NV* BalbeerS Rajput */
/* REVISION: 9.1     LAST MODIFIED: 05/08/06 BY: *SS - 20060508.1* Bill Jiang */

/* SS - 20060508.1 - B */
/*
1. 标准输入输出
2. 执行列表:
   a6fadarp01.p
   a6fadarp01a.p
*/
/* SS - 20060508.1 - E */

/* SS - 20060508.1 - B */
{a6fadarp01.i}
/* SS - 20060508.1 - E */


         {mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


         /* ********** Begin Translatable Strings Definition ********* */

         &SCOPED-DEFINE fadarpa_p_1 "Period#"
         /* MaxLen: 8 Comment: Asset depreciation period (ie 1, 2, 3) */

         &SCOPED-DEFINE fadarpa_p_2 "Period Amt"
         /* MaxLen: 16 Comment:  Asset depreciation for related period */

         &SCOPED-DEFINE fadarpa_p_3 "Accum Dep Amt"
         /* MaxLen: 16 Comment:  accumulated depreciation for period */

         &SCOPED-DEFINE fadarpa_p_4 "Basis Amt"
         /* MaxLen: 14 Comment:  Basis Amount */

         &SCOPED-DEFINE fadarpa_p_5 "Adjustment"
         /* MaxLen: 13 Comment:  Adjustment type */

         &SCOPED-DEFINE fadarpa_p_6 "Period"
         /* MaxLen: 10 Comment:  Year Period */

/*N0NV*
 *       &SCOPED-DEFINE fadarpa_p_7 "Original"
 *       /* MaxLen: 10 Comment:  The Orignal Reserve Type */
 *
 *       &SCOPED-DEFINE fadarpa_p_8 "Forecast"
 *       /* MaxLen: 10 Comment:  Used to identify the amount is a forecast */
 *N0NV*/

         /* ********** End Translatable Strings Definition ********* */

         {wbrp02.i}   /* Web enablement include */

         /* DEFINE VARIABLES */
         /* Input Parmameters */
         define input parameter fromAsset like fa_id no-undo.
         define input parameter toAsset like fa_id no-undo.
         define input parameter FromBook like fabk_id no-undo.
         define input parameter toBook like fabk_id no-undo.
         define input parameter printTot like mfc_logical no-undo.

         /* CHARACTER */
         define variable perDate like fabd_yrper format "x(7)" no-undo.
         define variable yrPeriod like fabd_yrper no-undo.
         define variable resType as character format "x(10)" no-undo.
         define variable assetID like fa_id no-undo.
         define variable book like fabk_id no-undo.
         define variable totUnits like fabd_accup no-undo.
         define variable translbl as character no-undo.

         /* INTEGER */
         define variable period as integer format ">>>>>>9" no-undo.
         define variable resNum as integer no-undo.
         define variable basisAmt like fabd_peramt no-undo.
         define variable perDepr like fabd_peramt no-undo.
         define variable accDepr like fabd_accamt no-undo.
         define variable accumAmt like fabd_accamt no-undo.
         define variable accDiff like fabd_accamt no-undo.
         define variable mc-error-number  as integer format "9999" no-undo.

         /* Define Frame */

         define frame f-2
           period column-label {&fadarpa_p_1}
           perDate column-label {&fadarpa_p_6}
           perDepr column-label {&fadarpa_p_2}
           accumAmt column-label {&fadarpa_p_3}
           fabd_det.fabd_resrv
           resType column-label {&fadarpa_p_5}
           with down no-box no-attr-space width 132.

         /* SS - 20060508.1 - B */
         /*
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame f-2:handle).
         */
         /* SS - 20060508.1 - E */

         define frame f-4
           period column-label {&fadarpa_p_1}
           perDate column-label {&fadarpa_p_6}
           perDepr column-label {&fadarpa_p_2}
           accumAmt column-label {&fadarpa_p_3}
           fabd_resrv
           resType column-label {&fadarpa_p_5}
           with down no-box no-attr-space width 132.

         /* SS - 20060508.1 - B */
         /*
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame f-4:handle).
         */
         /* SS - 20060508.1 - E */

         define frame f-5
           period
           perDate
           perDepr
           accumAmt
           fabd_resrv
           resType
           with down no-labels no-box no-attr-space width 132.

         /* SET EXTERNAL LABELS */
/*N0NV*  setFrameLabels(frame f-5:handle). */

         /* SET CURRENCY DEPENDENT ROUNDING FORMATS */
         for first gl_ctrl fields (gl_rnd_mthd) no-lock: end.

         /* REPORT LOGIC */
         /* Get each asset ID to report on */
         for each fa_mstr fields(fa_id fa_desc1) where
           fa_id >= fromAsset and
           fa_id <= toAsset no-lock:

           /* Report an asset ID for each book */
           for each fab_det
             fields(
                    fab_fa_id
                    fab_fabk_id
                    fab_life
                    fab_famt_id
                    fab_uplife
                   )  no-lock where
             fab_fa_id = fa_id and
             (fab_fabk_id >= fromBook and
              fab_fabk_id <= toBook) break by fab_fabk_id:

             if first-of(fab_fabk_id) then do:

               /* Get all depreciation dtls for the asset and book */
               for each fabd_det
                   fields(
                          fabd_fa_id
                          fabd_fabk_id
                          fabd_yrper
                          fabd_accup
                          fabd_resrv
                          fabd_retired
                          fabd_peramt
                         ) no-lock where
                   fabd_fa_id = fa_id and
                   fabd_fabk_id = fab_fabk_id
                   break by fabd_yrper:

                   /* increment period if yr per exists & not 1st time */
                   /* Only find basis amount if new assetID or book */
                   /* Save asset/book for setting basis amt later */
                   /* accumulated depreciation per period */
                   /* Format depr date, set year period */
                   /* Reset first pass flag & set reserve 0 type */
                   /* set resNum to curr reserve */

                   if assetID <> fabd_fa_id or
                      book <> fabd_fabk_id then do:
                     {gprunp.i "fapl" "p" "fa-get-basis"
                               "(input  fabd_fa_id,
                                 input  fabd_fabk_id,
                                 output basisAmt)"}
                   end.

                   {gprunp.i "fapl" "p" "fa-get-perdep"
                             "(input  fa_id,
                               input  fab_fabk_id,
                               input  fabd_yrper,
                               output perDepr)"}

                   {gprunp.i "fapl" "p" "fa-get-accdep"
                             "(input  fa_id,
                               input  fab_fabk_id,
                               input  fabd_yrper,
                               output accDepr)"}

                   assign
                     period = if first-of(fabd_yrper) then
                                period + 1
                              else
                                period
                     assetID = fabd_fa_id
                     book = fabd_fabk_id
                     totUnits = fabd_accup
                     perDate = substring(fabd_yrper,1,4)
                             + "/"
                             + substring(fabd_yrper,5,2)
                     yrPeriod = fabd_yrper
                     resType = if fabd_resrv = 0 then
/*N0NV*                          {&fadarpa_p_7}*/
/*N0NV*/                         getTermLabel("ORIGINAL",10)
                               else
                                 resType
                     resNum = fabd_resrv.

                   /* check the Adj table to pull reserve value */
                   for first faadj_mstr
                       fields(
                              faadj_fa_id
                              faadj_fabk_id
                              faadj_resrv
                              faadj_type
                             ) no-lock where
                       faadj_fa_id = fabd_fa_id and
                       faadj_fabk_id = fabd_fabk_id and
                       faadj_resrv = fabd_resrv:

                       /* check the lang dtl for adjustment types */
                       {gplngn2a.i
                        &file       = ""faadj_mstr""
                        &field      = ""faadj_type""
                        &code       = faadj_type
                        &mnemonic   = resType
                        &label      = translbl}
                   end. /* faadj_mstr */

                       /* SS - 20060508.1 - B */
                       /*
                   /* Print headers of report */
                   if line-counter = 1 then do with frame f-1:
                       /* SET EXTERNAL LABELS */
                       setFrameLabels(frame f-1:handle).
                       display
                         skip(1)
                         fa_id
                         fa_desc1 at 30
                         skip
                         fab_fabk_id
                         basisAmt label {&fadarpa_p_4} at 30
                         skip
                         fab_famt_id
                         fab_life at 30
                         skip
                         fabd_retired
                         skip(1)
                       with frame f-1 down side-labels no-box no-attr-space
                         width 132.
                   end. /* if line-counter = 1 */

                   /* Print column headers and details */
                   if printTot = no then do:
                    Display
                       period
                       perDate
                       fabd_det.fabd_peramt @ perDepr
                       fabd_det.fabd_resrv
                       resType
                     with frame f-2.

                     /* Print Basis Amount only at last-of period */
                     if last-of(fabd_yrper) then
                       display
                         accDepr @ accumAmt
                       with frame f-2.

                   end. /* if printTot = no ... */
                   else
                     do:

                        /* if printTot = yes print only at last-of period */
                        if last-of(fabd_yrper) then
                          display
                            period
                            perDate
                            perDepr
                            accDepr @ accumAmt
                            fabd_det.fabd_resrv
                            resType
                          with frame f-2.
                     end.  /* else do ... */

                    /* Page breaking */
                    if page-size - line-counter < 3 then
                      page.
                    */
                       CREATE tta6fadarp01.
                       ASSIGN
                          tta6fadarp01_fa_id = fa_id
                          tta6fadarp01_fa_desc1 = fa_desc1
                          tta6fadarp01_fab_fabk_id = fab_fabk_id
                          tta6fadarp01_basisAmt = basisAmt
                          tta6fadarp01_fab_famt_id = fab_famt_id
                          tta6fadarp01_fab_life = fab_life
                          tta6fadarp01_fabd_retired = fabd_retired
                          tta6fadarp01_period = period
                          tta6fadarp01_perDate = perDate
                          tta6fadarp01_fabd_peramt = fabd_det.fabd_peramt
                          tta6fadarp01_fabd_resrv = fabd_det.fabd_resrv
                          tta6fadarp01_resType = resType
                          .
                       if last-of(fabd_yrper) THEN DO:
                          ASSIGN
                             tta6fadarp01_accDepr = accDepr
                             .
                       END.
                    /* SS - 20060508.1 - E */
                    {mfrpchk.i}
               end.   /* for each fabd_det */

               /* Check to see if the asset is UOP */
               if can-find(first famt_mstr no-lock where
                                 famt_id = fab_famt_id and
                                 famt_type = "2") then
               do:
                  /* Used to indicate the period amount is forecasted */
/*N0NV*           resType = {&fadarpa_p_8}. */
/*N0NV*/          resType = getTermLabel("FORECAST",10).

                  /* If there are no fabd_det records for UOP asset, initialize
                     the yrPeriod and accumulated depreciation amount */
                  if period = 0 then
                     assign yrPeriod = ""
                            accDepr = 0.

                  /* Use the forecasted amount when the requested date
                     is greater than the year/period in fabd_det or if
                     no fabd_det records are available for the asset */
                  for each fauop_det fields(fauop_fa_id fauop_fabk_id
                    fauop_yrper fauop_accup) where
                    fauop_fa_id = fa_id and
                    fauop_fabk_id = fab_fabk_id and
                    fauop_yrper > yrPeriod no-lock break by fauop_yrper:

                   if assetID <> fauop_fa_id or
                      book <> fauop_fabk_id then do:
                      {gprunp.i "fapl" "p" "fa-get-basis"
                                "(input  fauop_fa_id,
                                  input  fauop_fabk_id,
                                  output basisAmt)"}
                   end.

                   {gprunp.i "fapl" "p" "fa-get-forecast-perdep"
                             "(input  fa_id,
                               input  fab_fabk_id,
                               input  fauop_yrper,
                               output perDepr)"}

                   {gprunp.i "mcpl" "p" "mc-curr-rnd"
                     "(input-output perDepr,
                       input gl_rnd_mthd,
                       output mc-error-number)"}
                   if mc-error-number <> 0 then
                     do:
                       {mfmsg.i mc-error-number 3}
                     end.

                   assign
                     period = if first-of(fauop_yrper) then
                                period + 1
                              else
                                period
                     assetID = fauop_fa_id
                     book = fauop_fabk_id
                     totUnits = totUnits + fauop_upper
                     perDate = substring(fauop_yrper,1,4)
                             + "/"
                             + substring(fauop_yrper,5,2).

                                /* SS - 20060508.1 - B */
                                /*
                   /* Print headers of report */
                   if line-counter = 1 then do with frame f-3:
                  /* SET EXTERNAL LABELS */
                      setFrameLabels(frame f-3:handle).
                       display
                         skip(1)
                         fa_id
                         fa_desc1 at 30
                         skip
                         fab_fabk_id
                         basisAmt label {&fadarpa_p_4} at 30
                         skip
                         fab_famt_id
                         fab_life at 30
                         skip(1)
                       with frame f-3 down side-labels no-box no-attr-space
                         width 132.
                   end. /* if line-counter = 1 */
                   */
                   /* SS - 20060508.1 - E */

                    /* ONLY ACCUMULATE FORECAST IF THE ADDITION DOES NOT
                       GO OVER BASIS AMT AND THE TOTAL UNITS ADDITION
                       DOESN'T GO OVER THE PRODUCTION UNITS */
                    if (accDepr + perDepr) >
                       basisAmt or totUnits > fab_uplife then do:
                       assign
                          accDiff = (accDepr + perDepr) - basisAmt
                          perDepr = perDepr - accDiff
                          accDepr = basisAmt.
                    end.
                    else
                       assign
                          accDepr = accDepr + perDepr.

                       /* SS - 20060508.1 - B */
                       /*
                   /* Only Print column headers when beginning a new page.
                      This is due to the concatenation of the UOP records */
                    if line-counter = 8 then do with frame f-4:
                       display
                          period column-label {&fadarpa_p_1}
                          perDate column-label {&fadarpa_p_6}
                          perDepr column-label {&fadarpa_p_2}
                          accDepr @ accumAmt column-label {&fadarpa_p_3}
                          resType
                       with frame f-4.
                    end. /* if line-counter = 8 */
                    else do with frame f-5:
                       Display
                          period
                          perDate
                          perDepr
                          accDepr @ accumAmt
                          resType
                       with frame f-5.
                    end. /* else */

                    /* Page breaking */
                    if page-size - line-counter < 3 then
                      page.
                    */
                       CREATE tta6fadarp01.
                       ASSIGN
                          tta6fadarp01_fa_id = fa_id
                          tta6fadarp01_fa_desc1 = fa_desc1
                          tta6fadarp01_fab_fabk_id = fab_fabk_id
                          tta6fadarp01_basisAmt = basisAmt
                          tta6fadarp01_fab_famt_id = fab_famt_id
                          tta6fadarp01_fab_life = fab_life
                          tta6fadarp01_fabd_retired = fabd_retired
                          tta6fadarp01_period = period
                          tta6fadarp01_perDate = perDate
                          tta6fadarp01_fabd_peramt = perDepr
                          tta6fadarp01_accDepr = accDepr
                          tta6fadarp01_resType = resType
                          .
                    /* SS - 20060508.1 - E */
                    {mfrpchk.i}

                    /* IF ACCUM DEPR ALREADY = BASIS THEN LEAVE.  THIS COULD
                       OCCUR IF FORECAST DATA IS BEING USED */
                    if accDepr = basisAmt or
                       totUnits = fab_uplife then leave.

                  end. /* for each fauop_det */
               end. /* for first famt_mstr */
               /* SS - 20060508.1 - B */
               /*
               page.
               */
               /* SS - 20060508.1 - E */
               assign
                  totUnits = 0
                  period = 0.
             end. /* if first-of fab_fabk_id */
           end. /* for each fab_det */
         end. /* do for each fa_mstr */

         /* Web Enablement include */
         {wbrp04.i}
