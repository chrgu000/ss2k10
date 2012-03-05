/* fadarp.p ASSET DEPRECIATION ARRAY                                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 9.1     LAST MODIFIED: 10/26/99     BY: *N021* Pat Pigatti */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00 BY: *N0L0* Jacolyn Neder    */
/* REVISION: 9.1      LAST MODIFIED: 05/08/06 BY: *SS - 20060508.1* Bill Jiang    */

/* SS - 20060508.1 - B */
{a6fadarp01.i "new"}
/* SS - 20060508.1 - E */

         {mfdtitle.i "b+ "}


         /* ********** Begin Translatable Strings Definition ********* */


         &SCOPED-DEFINE fadarp_p_1 "Summary"
         /* MaxLen: 24 Comment: Determines whether to print summary */

         /* ********** End Translatable Strings Definition ********* */

         /* Define Local Variables */
         define variable l-asset like fa_id no-undo.
         define variable l-asset1 like fa_id no-undo.
         define variable l-book like fabk_id no-undo.
         define variable l-book1 like fabk_id no-undo.
         define variable l-summary like mfc_logical
                           label {&fadarp_p_1} no-undo.

     /* Define Asset Depreciation Array form */
         form
           l-asset colon 25
           l-asset1 colon 42
             label {t001.i}
           l-book colon 25
           l-book1 colon 42
             label {t001.i}
           l-summary colon 25
         with frame a side-labels width 80 attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         {wbrp01.i &io-frame = "a"}

     /* Begin Mainloop for Asset Depreciation Array */
         mainloop:
         repeat:

       /* Allow asset ID and book to be updated. */
           if l-asset1 = hi_char then l-asset1 = "".
           if l-book1 = hi_char then l-book1 = "".

           if c-application-mode <> "WEB":U then
           update
             l-asset
             l-asset1
             l-book
             l-book1
             l-summary
           with frame a.

           {wbrp06.i
            &command = update
            &fields = "l-asset l-asset1 l-book l-book1 l-summary"}

           if (c-application-mode <> "WEB":U) or
              (c-application-mode = "WEB":U and
              (c-web-request begins "DATA":U))
           then do:

             bcdparm = "".
             {mfquoter.i l-asset}
             {mfquoter.i l-asset1}
             {mfquoter.i l-book}
             {mfquoter.i l-book1}
             {mfquoter.i l-summary}

             /* Set the upper limits to max values if blank. */
             if l-asset1 = "" then l-asset1 = hi_char.
             if l-asset1 < l-asset then l-asset1 = l-asset.
             if l-book1 = "" then l-book1 = hi_char.
             if l-book1 < l-book then l-book1 = l-book.

           end. /* if c-application-mode ... */

           /* Adds printer for output with batch option */
           {mfselbpr.i "printer" 132}

              /* SS - 20060508.1 - B */
              /*
           /* Prints page heading for report */
           {mfphead.i}

           /* Calls the Asset Depreciation Array report program */
           {gprun.i ""fadarpa.p"" "(input l-asset,
                                    input l-asset1,
                                    input l-book,
                                    input l-book1,
                                    input l-summary)"}

           /* Adds report trailer */
           {mfrtrail.i}
           */

           PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

           FOR EACH tta6fadarp01:
              DELETE tta6fadarp01.
           END.

           /* Calls the Asset Depreciation Array report program */
           {gprun.i ""a6fadarp01.p"" "(input l-asset,
              input l-asset1,
              input l-book,
              input l-book1,
              input l-summary)"}

           EXPORT DELIMITER ";" "fa_id" "fa_desc1" "fab_fabk_id" "basisAmt" "fab_famt_id" "fab_life" "fabd_retired" "period" "perDate" "fabd_peramt" "accDepr" "fabd_resrv" "resType".
           FOR EACH tta6fadarp01:
              EXPORT DELIMITER ";" tta6fadarp01.
           END.

           PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

           /* Adds report trailer */
           {a6mfrtrail.i}
           /* SS - 20060508.1 - E */

         end. /*MAIN-LOOP*/
