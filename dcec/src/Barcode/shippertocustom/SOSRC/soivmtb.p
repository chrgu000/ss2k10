/* GUI CONVERTED from soivmtb.p (converter v1.71) Tue Feb 22 21:53:06 2000 */
/* soivmtb.p - PENDING INVOICE HEADER TAX DATA                          */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                */
/* REVISION: 7.3      LAST MODIFIED: 02/10/93   BY: bcm *G416*          */
/* REVISION: 7.4      LAST MODIFIED: 12/28/93   BY: bcm *H269*          */
/*                                   02/23/95   BY: jzw *H0BM*          */
/*                                   01/24/96   BY: jzw *H0J6*          */
/* REVISION: 8.5      LAST MODIFIED: 01/13/98   BY: *J29R* Aruna Patil  */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 02/17/00   BY: *J3P9* Manish K.    */

/*H0J6*/    {mfdeclre.i}

        define shared variable so_recno     as recid.
        define shared variable new_order    like mfc_logical.
        define shared variable undo_soivmtb like mfc_logical.
        define variable zone_to             like txz_tax_zone.
        define variable zone_from           like txz_tax_zone.
/*H0J6*     define variable tax_usage           like so_tax_usage no-undo. */
/*H0J6*     define variable tax_env             like so_tax_env no-undo.   */
/*J3P9** /*H0J6*/    define variable tax_in     like ad_tax_in no-undo.    */
/*J3P9*/   define shared variable tax_in    like ad_tax_in .
/*J29R*/   define shared variable l_edittax like mfc_logical initial no no-undo.

/*H0J6*     {mfdeclre.i} */


/*H0J6*     BEGIN DELETE
 *          form
 *              so_tax_usage colon 22
 *              so_tax_env   colon 22
 *          with frame set_tax row 14 centered overlay side-labels.
 *H0J6*     END DELETE */


        find so_mstr where recid(so_mstr) = so_recno exclusive-lock.

/*H269*/    ststatus = stline[1].
/*H269*/    status input ststatus.

/*H0J6*     BEGIN DELETE
 *          /* THIS LOOP EXISTS TO ENSURE A BLANK ENVIRONMENT IS NOT ALLOWED */
 *          get_tax:
 *          do on error undo, retry on endkey undo, leave:
 *
 *              tax_usage = so_tax_usage.
 *              tax_env = so_tax_env.
 *H0J6*     END DELETE */

        /* SET TAX ENVIRONMENT & USAGE */
        set_tax:
        do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


/*H0J6*         BEGIN DELETE
 *              so_tax_usage = tax_usage.
 *              so_tax_env   = tax_env.
 *H0J6*         END DELETE */

        if so_tax_env = "" then do:

            /* LOAD DEFAULTS */
            find ad_mstr where ad_addr = so_ship
            no-lock no-error.
            if available ad_mstr then
/*H0J6*/            do:
            zone_to = ad_tax_zone.
/*H0J6*/                tax_in  = ad_tax_in.
/*H0J6*/            end.
            else do:
            find ad_mstr where ad_addr = so_cust
            no-lock no-error.
            if available(ad_mstr) then
/*H0J6*/                do:
                zone_to = ad_tax_zone.
/*H0J6*/                    tax_in  = ad_tax_in.
/*H0J6*/                end.
            end.

            /* CHECK FOR SITE ADDRESS */
            find ad_mstr where ad_addr = so_site no-lock
            no-error.
            if available(ad_mstr) then
            zone_from = ad_tax_zone.
            else do:
/*H0BM*                 {mfmsg03.i 902 2 """Site Address""" """" """"} */
/*H0BM*/                {mfmsg.i 864 2} /* SITE ADDRESS DOES NOT EXIST */
            zone_from = "".
            end.

            /* SUGGEST A TAX ENVIRONMENT */
            {gprun.i ""txtxeget.p"" "(input  zone_to,
                          input  zone_from,
                          input  so_taxc,
                          output so_tax_env)"}
/*GUI*/ if global-beam-me-up then undo, leave.

        end. /* IF SO_TAX_ENV = "" */

/*H0J6*         BEGIN DELETE
 *              update
 *                 so_tax_usage
 *                 so_tax_env
 *              with frame set_tax.
 *
 *              tax_usage = so_tax_usage.
 *
 *              /* VALIDATE TAX ENVIRONMENT */
 *              if so_tax_env = "" then do:
 *H0BM**            {mfmsg03.i 906 3 *
 *H0BM**              """Tax Environment""" """" """"}. *
 *H0BM*             {mfmsg.i 944 3}.
 *H0BM*               /* BLANK TAX ENVIRONMENT NOT ALLOWED */
 *                  tax_env = "".
 *                  next-prompt so_tax_env with frame set_tax.
 *                  undo, retry set_tax.
 *              end.
 *
 *              if not {gptxe.v so_tax_env ""no""} then do:
 *H0BM**           {mfmsg03.i 902 3 *
 *H0BM**              """Tax Environment""" """" """"}. *
 *H0BM*            {mfmsg.i 869 3}.
 *H0BM*            /* TAX ENVIRONMENT DOES NOT EXIST */
 *                 next-prompt so_tax_env with frame set_tax.
 *                 undo, retry set_tax.
 *              end.
 *H0J6*         END DELETE */

/*H0J6*/        /* TAX MANAGEMENT TRANSACTION POP-UP. */
/*H0J6*/        /* PARAMETERS ARE 5 FIELDS AND UPDATEABLE FLAGS, */
/*H0J6*/        /* STARTING ROW, AND UNDO FLAG. */
/*J3P9*/        /* CHANGED SIXTH,EIGHT AND TENTH INPUT PARAMETER */
/*J3P9*/        /* TO TRUE FROM FALSE */
/*H0J6*/        {gprun.i ""txtrnpop.p""
            "(input-output so_tax_usage, input true,
              input-output so_tax_env,   input true,
              input-output so_taxc,      input true,
              input-output so_taxable,   input true,
              input-output tax_in,       input true,
              input 14,
              output undo_soivmtb)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*H0J6*/        if undo_soivmtb then undo set_tax, return.

/*J29R*/    /* WHEN SHIP-TO IS CHANGED, GTM IS USED AND USER RESPONDS YES    */
/*J29R*/    /* TO PROMPT MESSAGE "SHIP-TO CHANGED; UPDATE TAX DATA? (Y/N)".  */
/*J29R*/    /* THEN UPDATE LINE ITEM TAX ENVIRONMENT WITH THE HEADER TAX     */
/*J29R*/    /* ENVIRONMENT OR RE-EVALUATE IF THE LINE SITE IS DIFFERENT FROM */
/*J29R*/    /* THE HEADER SITE.                                              */

/*J29R*/    if l_edittax then
/*J29R*/       for each sod_det where sod_nbr = so_nbr exclusive-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

/*J29R*/           assign sod_tax_usage = so_tax_usage
/*J29R*/                  sod_tax_env   = if (sod_site = so_site) then
/*J29R*/                                  so_tax_env else ""
/*J29R*/                  sod_tax_in    = tax_in.
/*J29R*/           if sod_tax_env = "" and sod_taxable then do:

/*J29R*/              /* CHECK FOR SITE ADDRESS */
/*J29R*/              find ad_mstr where ad_addr = sod_site no-lock
/*J29R*/              no-error.
/*J29R*/              if available(ad_mstr) then
/*J29R*/                  zone_from = ad_tax_zone.
/*J29R*/              else do:
/*J29R*/                  /* SITE ADDRESS # DOES NOT EXIST FOR LINE # */
/*J29R*/                  {mfmsg03.i 2355 2 sod_site sod_line """"}
/*J29R*/                  zone_from = "".
/*J29R*/              end.

/*J29R*/              {gprun.i ""txtxget2.p"" "(input  zone_to,
                                                input  zone_from,
                                                input  so_taxc,
                                                input  sod_site,
                                                input  sod_line,
                                                output sod_tax_env)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J29R*/           end. /* SOD_TAX_ENV = "" AND SOD_TAXABLE */
/*J29R*/       end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH SOD_DET */

        end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* SET_TAX */
        undo_soivmtb = false.

/*H0J6*     end.    /* get_tax */ */

/*H0J6*     hide frame set_tax. */
