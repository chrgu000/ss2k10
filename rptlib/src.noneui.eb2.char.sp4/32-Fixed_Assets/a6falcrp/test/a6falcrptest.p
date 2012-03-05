/* falcrp.p FIXED ASSETS LOCATION REPORT                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/*V8:ConvertMode=FullGUIReport                                           */
/* REVISION: 9.1     LAST MODIFIED: 10/26/99 BY: *N021* Pat Pigatti      */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1     LAST MODIFIED: 08/14/00 BY: *N0L0* Jacolyn Neder    */
/* REVISION: 9.1     LAST MODIFIED: 08/25/00 BY: *N0NV* Rajinder Kamra   */
/* REVISION: 9.1     LAST MODIFIED: 02/12/06 BY: *SS - 20060212* Bill Jiang   */

/* SS - 20060212 - B */
{a6falcrp.i "new"}
/* SS - 20060212 - E */

         {mfdtitle.i "b+ "}

         /* ********** Begin Translatable Strings Definitions ********* */

/*N0NV
 *        &SCOPED-DEFINE falcrp_p_1 "Telephone: "
 *        /* MaxLen: 15 Comment: */
 *
 *          &SCOPED-DEFINE falcrp_p_2 "Fax: "
 *          /* MaxLen: 10 Comment: */
 *N0NV*/

         &SCOPED-DEFINE falcrp_p_3 "Address"
         /* MaxLen: 38 Comment: Fixed Asset Location Address */

         &SCOPED-DEFINE falcrp_p_4 "Print Address"
         /* MaxLen: 24 Comment: Print Address for Location yes/no */

         /* ********** End Translatable Strings Definitions ********* */

         define new shared variable addr as character format "x(38)" extent 6.

         define variable l-loc     like faloc_id     no-undo.
         define variable l-loc1    like faloc_id     no-undo.
         define variable l-entity  like faloc_entity no-undo.
         define variable l-entity1 like faloc_entity no-undo.
         define variable l-sub     like faloc_sub    no-undo.
         define variable l-sub1    like faloc_sub    no-undo.
         define variable l-cc      like faloc_cc     no-undo.
         define variable l-cc1     like faloc_cc     no-undo.
         define variable l-addr    like mfc_logical  no-undo.
         define variable i         as   integer      no-undo.

         form
           l-loc     colon 25
           l-loc1    colon 50 label {t001.i}
           l-entity  colon 25
           l-entity1 colon 50 label {t001.i}
           l-sub     colon 25
           l-sub1    colon 50 label {t001.i}
           l-cc      colon 25
           l-cc1     colon 50 label {t001.i}
           skip(1)
           l-addr    colon 25 label {&falcrp_p_4}
         with frame a side-labels width 80.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         form
            faloc_id
            faloc_desc
            faloc_entity
            faloc_sub
            faloc_cc
            addr[1]      column-label {&falcrp_p_3}
         with frame b no-box width 132 down.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).

         {wbrp01.i}

         mainloop:
         repeat:
            if l-loc1    = hi_char then l-loc1    = "".
            if l-entity1 = hi_char then l-entity1 = "".
            if l-sub1    = hi_char then l-sub1    = "".
            if l-cc1     = hi_char then l-cc1     = "".

            if c-application-mode <> "WEB":U then
               update
                  l-loc
                  l-loc1
                  l-entity
                  l-entity1
                  l-sub
                  l-sub1
                  l-cc
                  l-cc1
                  l-addr
               with frame a.

            {wbrp06.i &command = update
                      &fields = "l-loc    l-loc1
                                 l-entity l-entity1
                                 l-sub
                                 l-sub1
                                 l-cc
                                 l-cc1
                                 l-addr"
                      &frm = "a"}

            if (c-application-mode <> "WEB":U) or
                (c-application-mode = "WEB":U and
                (c-web-request begins "DATA":U))
            then do:

               bcdparm = "".
               {mfquoter.i l-loc    }
               {mfquoter.i l-loc1   }
               {mfquoter.i l-entity }
               {mfquoter.i l-entity1}
               {mfquoter.i l-sub    }
               {mfquoter.i l-sub1   }
               {mfquoter.i l-cc     }
               {mfquoter.i l-cc1    }
               {mfquoter.i l-addr   }

               if l-loc1    = "" then l-loc1    = hi_char.
               if l-entity1 = "" then l-entity1 = hi_char.
               if l-sub1    = "" then l-sub1    = hi_char.
               if l-cc1     = "" then l-cc1     = hi_char.
            end.  /* if (c-application-mode <> "WEB":U ... */

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
            /* SS - 20060212 - B */
            /*
            {mfphead.i}

            for each faloc_mstr
            fields (faloc_id faloc_desc faloc_entity faloc_sub faloc_cc)
            where faloc_id     >= l-loc
            and   faloc_id     <= l-loc1
            and   faloc_entity >= l-entity
            and   faloc_entity <= l-entity1
            and   faloc_sub    >= l-sub
            and   faloc_sub    <= l-sub1
            and   faloc_cc     >= l-cc
            and   faloc_cc     <= l-cc1:

               display
                  faloc_id
                  faloc_desc
                  faloc_entity
                  faloc_sub
                  faloc_cc
               with frame b.

               if l-addr then do:
                  for first ad_mstr
                  fields (ad_addr ad_name ad_line1 ad_line2 ad_line3
                          ad_phone ad_fax ad_city ad_state ad_zip ad_format)
                  where ad_addr = faloc_id no-lock: end.
                  if available ad_mstr then do:
                     assign
/*N0NV*/                addr[5] = getTermLabel("TELEPHONE",20) + ": "
/*N0NV*/                          + string(ad_phone, "x(16)")
/*N0NV*/                addr[6] = getTermLabel("FAX_NUMBER",20) + ": "
/*N0NV*/                          + string(ad_fax, "x(16)")
                        addr[1] = ad_line1
                        addr[2] = ad_line2
                        addr[3] = ad_line3
/*N0NV*                 addr[5] = {&falcrp_p_1} + string(ad_phone, "x(16)") */
/*N0NV*                 addr[6] = {&falcrp_p_2} + string(ad_fax, "x(16)")*/ .
                     {mfcsz.i addr[4] ad_city ad_state ad_zip}
                  end.  /* if available ad_mstr */

                  /* MAKE SURE THERE ARE NOT BLANK LINES IN ADDR OUTPUT */
                  {gprun.i ""gpaddr.p""}

                  do i = 1 to 6:
                     if addr[i] <> ""
/*N0NV*              and addr[i] <> {&falcrp_p_1}  /* BLANK TELEPHONE */ */
/*N0NV*              and addr[i] <> {&falcrp_p_2}  /* BLANK FAX NUMBER */ */
/*N0NV*/             and addr[i] <> getTermLabel("TELEPHONE",20) + ": "
/*N0NV*/             and addr[i] <> getTermLabel("FAX_NUMBER",20) + ": "
                     then do:
                        display
                           addr[i] @ addr[1]
                        with frame b.
                        down with frame b.
                     end.
                  end.
               end.  /* if l-addr */

               down 1 with frame b.

               {mfrpchk.i}
            end.  /* for each faloc_mstr */

            {mfrtrail.i}
            */
            PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

            FOR EACH tta6falcrp:
               DELETE tta6falcrp.
            END.

            {gprun.i ""a6falcrp.p"" "(
               INPUT l-loc,
               INPUT l-loc1,
               INPUT l-entity,
               INPUT l-entity1,
               INPUT l-sub,
               INPUT l-sub1,
               INPUT l-cc,
               INPUT l-cc1,
               INPUT l-addr
               )"}

            EXPORT DELIMITER ";" "id" "desc" "entity" "sub" "cc" "_chr01" "ad__chr01".
            FOR EACH tta6falcrp:
                EXPORT DELIMITER ";" tta6falcrp.
            END.

            PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

            {a6mfrtrail.i}
            /* SS - 20060212 - E */
         end. /* MAIN-LOOP */

         {wbrp04.i &frame-spec = a}
