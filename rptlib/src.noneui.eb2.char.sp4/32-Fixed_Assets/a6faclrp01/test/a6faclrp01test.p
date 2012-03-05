/* faclrp.p FIXED ASSETS CLASS REPORT                                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 9.1     LAST MODIFIED: 10/26/99     BY: *N021* Pat Pigatti */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00 BY: *N0KW* Jacolyn Neder    */
/* REVISION: 9.1      LAST MODIFIED: 12/29/05 BY: *SS - 20051229* Bill Jiang    */

/* SS - 20051229 - B */
{a6faclrp01.i "new"}
/* SS - 20051229 - E */



         {mfdtitle.i "b+ "}


         /* ********** Begin Translatable Strings Definition ********* */

         &SCOPED-DEFINE faclrp_p_1 "Print Accounts"
         /* MaxLen: 24  Comment: Print Account Defaults */

         &SCOPED-DEFINE faclrp_p_2 "Account Type"
         /* MaxLen: 24 Comment: Asset Account Type */

         &SCOPED-DEFINE faclrp_p_3 "Description"
         /* MaxLen: 24  Comment: Description */

         /* ********** End Translatable Strings Definition ********* */

         define variable l-class     like facls_id     no-undo.
         define variable l-class1    like facls_id     no-undo.
         define variable l-book      like fadf_fabk_id no-undo.
         define variable l-book1     like fadf_fabk_id no-undo.
         define variable l-mthd      like fadf_famt_id no-undo.
         define variable l-mthd1     like fadf_famt_id no-undo.
         define variable l-accts     like mfc_logical initial yes no-undo.
         define variable transmnc    like lngd_key1 no-undo.
         define variable translbl    like lngd_translation no-undo.
         define variable l-fabk-desc like lngd_translation no-undo.
         define variable l-famt-desc like lngd_translation no-undo.
         define variable l-posting   like fabk_post no-undo.

         form
           l-class  colon 25
           l-class1 colon 50 label {t001.i}
           l-book   colon 25
           l-book1  colon 50 label {t001.i}
           l-mthd   colon 25
           l-mthd1  colon 50 label {t001.i}
           skip
           l-accts  colon 25 label {&faclrp_p_1}
         with frame a side-labels width 80.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         /* SS - 20051229 - B */
         /*
         form
            facls_id
            facls_desc
            facls_dep
            facd_acct
            translbl  column-label {&faclrp_p_2}
         with frame b no-box width 132 down.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).

         form
            fadf_fabk_id at 10
            l-fabk-desc        column-label {&faclrp_p_3}
            fadf_famt_id
            l-famt-desc        column-label {&faclrp_p_3}
            fadf_famt_elife
            l-posting
         with frame c no-box width 132 down.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame c:handle).
         */
         /* SS - 20051229 - E */

         {wbrp01.i}

         mainloop:
         repeat:
            if l-class1 = hi_char then l-class1 = "".
            if l-book1  = hi_char then l-book1  = "".
            if l-mthd1  = hi_char then l-mthd1  = "".

            if c-application-mode <> "WEB":U then
               update
                  l-class
                  l-class1
                  l-book
                  l-book1
                  l-mthd
                  l-mthd1
                  l-accts
               with frame a.

            {wbrp06.i &command = update
                      &fields = "l-class l-class1
                                 l-book  l-book1
                                 l-mthd  l-mthd1
                                 l-accts"
                      &frm = "a"}

            if (c-application-mode <> "WEB":U) or
                (c-application-mode = "WEB":U and
                (c-web-request begins "DATA":U))
            then do:

               bcdparm = "".
               {mfquoter.i l-class }
               {mfquoter.i l-class1}
               {mfquoter.i l-book  }
               {mfquoter.i l-book1 }
               {mfquoter.i l-mthd  }
               {mfquoter.i l-mthd1 }
               {mfquoter.i l-accts}

               if l-class1 = "" then l-class1 = hi_char.
               if l-book1  = "" then l-book1  = hi_char.
               if l-mthd1  = "" then l-mthd1  = hi_char.
            end.  /* if (c-application-mode <> "WEB":U ... */

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
            /* SS - 20051229 - B */
            /*
            {mfphead.i}
            */
            /* SS - 20051229 - E */

            /* SS - 20051229 - B */
            /*
            for each facls_mstr
            fields (facls_id facls_desc facls_dep)
            where facls_id >= l-class
            and   facls_id <= l-class1 no-lock:

               display
                  facls_id
                  facls_desc
                  facls_dep
               with frame b.

               if l-accts = yes then
               do:
                  for each facd_det no-lock
                  where facd_facls_id = facls_id
                  break by facd_acctype:

                     {gplngn2a.i
                        &file     = ""facd_det""
                        &field    = ""facd_acctype""
                        &code     = facd_det.facd_acctype
                        &mnemonic = transmnc
                        &label    = translbl}

                     display
                        facd_acct
                        translbl
                     with frame b.

                     down with frame b.
                     if last(facd_acctype)
                     then down 1 with frame b.

                  end.  /* for each facd_det */
               end.  /* if l-accts */

               if facls_dep then do:

                  for each fadf_mstr
                  fields (fadf_facls_id fadf_fabk_id fadf_famt_id
                          fadf_famt_elife)
                  where fadf_facls_id  = facls_id
                  and   fadf_fabk_id >= l-book
                  and   fadf_fabk_id <= l-book1
                  and   fadf_famt_id >= l-mthd
                  and   fadf_famt_id <= l-mthd1
                  no-lock break by fadf_facls_id by fadf_fabk_id:

                     if first-of(fadf_fabk_id) then do:
                        /* DISPLAY BOOKS */
                        for first fabk_mstr
                        fields (fabk_id fabk_desc fabk_post)
                        where fabk_id = fadf_fabk_id
                        no-lock: end.
                        if available fabk_mstr
                        then
                           assign
                              l-fabk-desc = fabk_desc
                              l-posting = fabk_post.
                        else
                           assign
                              l-fabk-desc = ""
                              l-posting = no.
                     end. /* first-of ... */

                     for first famt_mstr
                     fields (famt_id famt_type famt_desc)
                     where famt_id = fadf_famt_id
                     no-lock: end.
                     if available famt_mstr then do:
                        if famt_id begins "0" then do:
                           {gplngn2a.i
                              &file     = ""famt_mstr""
                              &field    = ""famt_desc""
                              &code     = famt_mstr.famt_type
                              &mnemonic = transmnc
                              &label    = l-famt-desc}
                        end.
                        else
                           l-famt-desc = famt_desc.
                     end.
                     else
                        l-famt-desc = "".

                     display
                        fadf_fabk_id
                        l-fabk-desc
                        fadf_famt_id
                        l-famt-desc
                        fadf_famt_elife
                        l-posting
                     with frame c.
                     down with frame c.

                     if last-of(fadf_facls_id)
                     then down 1 with frame c.
                     {mfrpchk.i}
                  end.  /* for each fadf_mstr */
               end. /* if facls_dep ... */
            end. /* for each facls_mstr */
            {mfrtrail.i}
            */
            PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

            FOR EACH tta6faclrp01:
               DELETE tta6faclrp01.
            END.

            {gprun.i ""a6faclrp01.p"" "(
               INPUT l-class,
               INPUT l-class1,
               INPUT l-book,
               INPUT l-book1,
               INPUT l-mthd,
               INPUT l-mthd1,
               INPUT l-accts
               )"}

            EXPORT DELIMITER ";" "facls_id" "facls_desc" "facls_dep" "facd_acct1" "facd_acct2" "facd_acct3" "facd_acct4" "facd_acct5" "facd_acct6" "facd_acct7" "fadf_fabk_id" "fabk_desc" "fadf_famt_id" "famt_desc" "fadf_famt_elife" "posting" "facls__int01".
            FOR EACH tta6faclrp01:
                EXPORT DELIMITER ";" tta6faclrp01.
            END.

            PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

            {a6mfrtrail.i}
            /* SS - 20051229 - E */
         end. /* MAIN-LOOP */

         {wbrp04.i &frame-spec = a}
