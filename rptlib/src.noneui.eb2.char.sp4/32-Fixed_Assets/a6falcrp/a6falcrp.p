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
define input parameter i_l-loc     like faloc_id     no-undo.
define input parameter i_l-loc1    like faloc_id     no-undo.
define input parameter i_l-entity  like faloc_entity no-undo.
define input parameter i_l-entity1 like faloc_entity no-undo.
define input parameter i_l-sub     like faloc_sub    no-undo.
define input parameter i_l-sub1    like faloc_sub    no-undo.
define input parameter i_l-cc      like faloc_cc     no-undo.
define input parameter i_l-cc1     like faloc_cc     no-undo.
define input parameter i_l-addr    like mfc_logical  no-undo.

{a6falcrp.i}

/*
{mfdtitle.i "b+ "}
*/
{a6mfdtitle.i "b+ "}
/* SS - 20060212 - E */

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

         /* SS - 20060212 - B */
         /*
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).
         */
         /* SS - 20060212 - E */

         form
            faloc_id
            faloc_desc
            faloc_entity
            faloc_sub
            faloc_cc
            addr[1]      column-label {&falcrp_p_3}
         with frame b no-box width 132 down.

         /* SS - 20060212 - B */
         /*
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).
         */
         l-loc = i_l-loc.
         l-loc1 = i_l-loc1.
         l-entity = i_l-entity.
         l-entity1 = i_l-entity1.
         l-sub = i_l-sub.
         l-sub1 = i_l-sub1.
         l-cc = i_l-cc.
         l-cc1 = i_l-cc1.
         l-addr = i_l-addr.
         /* SS - 20060212 - E */

         {wbrp01.i}

         /* SS - 20060212 - B */
         /*
         mainloop:
         repeat:
         */
         /* SS - 20060212 - E */
            if l-loc1    = hi_char then l-loc1    = "".
            if l-entity1 = hi_char then l-entity1 = "".
            if l-sub1    = hi_char then l-sub1    = "".
            if l-cc1     = hi_char then l-cc1     = "".

            /* SS - 20060212 - B */
            /*
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
            */
            /* SS - 20060212 - E */

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

            /* SS - 20060212 - B */
            /*
            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
            {mfphead.i}
            */
            /* SS - 20060212 - E */

            for each faloc_mstr
            /* SS - 20060212 - B */
            /*
            fields (faloc_id faloc_desc faloc_entity faloc_sub faloc_cc)
            */
            /* SS - 20060212 - E */
            where faloc_id     >= l-loc
            and   faloc_id     <= l-loc1
            and   faloc_entity >= l-entity
            and   faloc_entity <= l-entity1
            and   faloc_sub    >= l-sub
            and   faloc_sub    <= l-sub1
            and   faloc_cc     >= l-cc
            and   faloc_cc     <= l-cc1:

               /* SS - 20060212 - B */
               /*
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
               */
               CREATE tta6falcrp.
               ASSIGN
                  tta6falcrp_id = faloc_id
                  tta6falcrp_desc = faloc_desc
                  tta6falcrp_entity = faloc_entity
                  tta6falcrp_sub = faloc_sub
                  tta6falcrp_cc = faloc_cc
                  tta6falcrp__chr01 = faloc__chr01
                  .
               for first ad_mstr
               /* SS - 20060212 - B */
               /*
               fields (ad_addr ad_name ad_line1 ad_line2 ad_line3
                       ad_phone ad_fax ad_city ad_state ad_zip ad_format)
               */
               /* SS - 20060212 - E */
               where ad_addr = faloc_id no-lock: end.
               if available ad_mstr then do:
                  ASSIGN
                     tta6falcrp_ad__chr01 = ad__chr01
                     .
               end.  /* if available ad_mstr */
               /* SS - 20060212 - E */

               {mfrpchk.i}
            end.  /* for each faloc_mstr */

            /* SS - 20060212 - B */
            /*
            {mfrtrail.i}
         end. /* MAIN-LOOP */
         */
         /* SS - 20060212 - E */

         {wbrp04.i &frame-spec = a}
