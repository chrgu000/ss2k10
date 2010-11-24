/* sosomtb.p  - SALES ORDER HEADER TAX DATA                                 */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* REVISION: 7.3      LAST MODIFIED: 02/04/93   by: bcm *G415*              */
/* REVISION: 7.4      LAST MODIFIED: 06/24/93   by: pcd *H008*              */
/* REVISION: 7.4      LAST MODIFIED: 12/28/93   by: bcm *H269*              */
/* REVISION: 7.4      LAST MODIFIED: 09/22/94   by: jpm *GM78*              */
/* REVISION: 7.4      LAST MODIFIED: 02/03/95   by: srk *H09T*              */
/* REVISION: 7.4      LAST MODIFIED: 02/23/95   by: jzw *H0BM*              */
/* REVISION: 7.4      LAST MODIFIED: 03/06/95   by: wjk *H0BT*              */
/* REVISION: 7.4      LAST MODIFIED: 04/17/95   by: jpm *H0CJ*              */
/* REVISION: 8.5      LAST MODIFIED: 11/17/97   BY: *J26C* Aruna Patil      */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 03/02/00   BY: *N088* Pat Pigatti      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *N0CG* Santosh Rao      */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KJ* Dave Caveney     */
/* REVISION: 9.1      LAST MODIFIED: 08/23/00   BY: *N0ND* Mark Brown       */
/* Revision: 1.17     BY: Vinod Nair         DATE: 09/12/01 ECO: *M1KK*     */
/* Revision: 1.18     BY: Rajaneesh S.       DATE: 06/19/02 ECO: *N1H7*     */
/* Revision: 1.20     BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L*     */
/* Revision: 1.21     BY: Dorota Hohol       DATE: 09/01/03 ECO: *P0VF*     */
/* Revision: 1.22     BY: Veena Lad          DATE: 10/22/03 ECO: *P160*     */
/* Revision: 1.23     BY: Veena Lad          DATE: 02/03/04 ECO: *P1M6*     */
/* Revision: 1.24     BY: Veena Lad          DATE: 03/03/04 ECO: *Q064*     */
/* Revision: 1.25     BY: Veena Lad          DATE: 04/22/04 ECO: *P1YK*     */
/* Revision: 1.26     BY: Bhavik Rathod      DATE: 01/07/05 ECO: *Q0GD*     */
/* Revision: 1.27     BY: Katie Hilbert      DATE: 01/07/05 ECO: *Q0GH*     */
/* $Revision: 1.28 $       BY: Tejasvi Kulkarni   DATE: 02/21/06 ECO: *Q0R7*     */
/*By: Neil Gao 08/08/04 ECO: *SS 20080804* */

/*-Revision end-------------------------------------------------------------*/

/*V8:ConvertMode=Maintenance                                                */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "SOSOMTB.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}

define shared variable so_recno     as recid.
define shared variable new_order    like mfc_logical.
define shared variable undo_sosomtb like mfc_logical.
define shared variable tax_in       like cm_tax_in.
define shared variable l_edittax    like mfc_logical initial no no-undo.

define variable zone_to             like txz_tax_zone.
define variable zone_from           like txz_tax_zone.
define variable tax_class           like so_taxc no-undo.
define variable tax_usage           like so_tax_usage no-undo.
define variable l_vq_use_sold       like mfc_logical initial no no-undo.

form
   space(2)
   so_tax_usage colon 22
   so_tax_env   colon 22
   space(2)
   so_taxc      colon 22
   so_taxable   colon 22
   tax_in       colon 22
   space(2)
   /*V8-*/
with frame set_tax row 8 centered overlay side-labels.

/* SET EXTERNAL LABELS */

/*V8+*/
/*V8!
with frame set_tax centered overlay side-labels.
frame set_tax:row = 8.
FRAME set_tax:HEIGHT-PIXELS = FRAME set_tax:HEIGHT-PIXELS + 8. */
setFrameLabels(frame set_tax:handle).

find so_mstr where recid(so_mstr) = so_recno
exclusive-lock no-error.

ststatus = stline[1].
status input ststatus.

for first mfc_ctrl
   fields(mfc_domain mfc_field mfc_logical)
   where mfc_ctrl.mfc_domain = global_domain
   and   mfc_field           = "l_vqc_sold_usage"
no-lock:
   l_vq_use_sold = mfc_logical.
end. /* FOR FIRST mfc_ctrl */

/* THIS LOOP EXISTS TO ENSURE A BLANK ENVIRONMENT IS NOT ALLOWED */
get_tax:
do on error undo, retry on endkey undo, leave:

   assign
      tax_usage = so_tax_usage
      tax_class = so_taxc.

   /* SET TAX CLASS (USED FOR FINDING TAX ENVIRONMENT) & USAGE */
   set_tax:
   do on error undo, retry:

      assign
         so_tax_usage = tax_usage
         so_taxc      = tax_class.

      if so_tax_env = ""
      then do:

         /* LOAD DEFAULTS */
         for first ad_mstr
            fields(ad_domain ad_addr ad_taxc ad_tax_usage
                   ad_tax_zone ad_type)
            where ad_mstr.ad_domain = global_domain
            and   ad_addr           = so_ship
            and   ad_type          <> "dock"
            no-lock:
         end. /* FOR FIRST AD_MSTR */

         if available ad_mstr
         then do:
            zone_to = ad_tax_zone.

            if new_order
            then
               so_tax_usage = ad_tax_usage.

         end.

         else do:
            for first ad_mstr
               fields(ad_domain ad_addr ad_taxc ad_tax_usage ad_tax_zone
                      ad_type)
               where ad_mstr.ad_domain = global_domain
               and   ad_addr           = so_cust
               no-lock:
            end. /* FOR FIRST AD_MSTR */

            if available(ad_mstr)
            then do:
               zone_to = ad_tax_zone.

               if new_order
               then
                  so_tax_usage = ad_tax_usage.

            end.
         end.

         if new_order
         and l_vq_use_sold
         then do:

            for first ad_mstr
               fields(ad_domain ad_addr ad_taxc ad_tax_usage ad_tax_zone
                      ad_type)
               where ad_mstr.ad_domain = global_domain
               and   ad_addr           = so_cust
               no-lock:
            end. /* FOR FIRST AD_MSTR */

            if available(ad_mstr)
            then
               so_tax_usage = ad_tax_usage.

         end. /* IF new_order AND l_vq_use_sold */

         /* CHECK FOR SITE ADDRESS */
         for first ad_mstr
            fields(ad_domain ad_addr ad_taxc ad_tax_usage ad_tax_zone ad_type)
            where ad_mstr.ad_domain = global_domain and  ad_addr = so_site
            no-lock:
         end. /* FOR FIRST AD_MSTR */

         if available(ad_mstr)
         then
            zone_from = ad_tax_zone.
         else do:
            /* SITE ADDRESS DOES NOT EXIST */
            {pxmsg.i &MSGNUM=864 &ERRORLEVEL=2}
            zone_from = "".
         end.

         /* SUGGEST A TAX ENVIRONMENT */
         {gprun.i ""txtxeget.p""
            "(input  zone_to,
              input  zone_from,
              input  so_taxc,
              output so_tax_env)"}
      end.
      {&SOSOMTB-P-TAG1}

/*SS 20080804 - B*/
      update
         so_tax_usage
         so_tax_env
         so_taxc
         so_taxable
         tax_in
      with frame set_tax.
/*SS 20080804 - E*/

      /* VALIDATE TAX USAGE  */
      {pxrun.i &PROC       = 'validateTaxUsage'
               &PROGRAM    = 'txenvxr.p'
               &PARAM      = "(input so_tax_usage)"
               &NOAPPERROR = true
               &CATCHERROR = true }

      if return-value <> {&SUCCESS-RESULT}
      then do:
         next-prompt
            so_tax_usage
         with frame set_tax.
         undo, retry set_tax.
      end. /* IF return-value <> {&SUCCESS-RESULT}  */

      tax_usage = so_tax_usage.

      /* VALIDATE TAX ENVIRONMENT */
      if so_tax_env = ""
      then do:
         /* BLANK TAX ENVIRONMENT NOT ALLOWED */
         {pxmsg.i &MSGNUM=944 &ERRORLEVEL=3}.
         next-prompt so_tax_env with frame set_tax.
         undo, retry set_tax.
      end.

      if not {gptxe.v so_tax_env ""no""}
      then do:
         /* TAX ENVIRONMENT DOES NOT EXIST */
         {pxmsg.i &MSGNUM=869 &ERRORLEVEL=3}.
         next-prompt so_tax_env with frame set_tax.
         undo, retry set_tax.
      end.

      /* WHEN SHIP-TO IS CHANGED, GTM IS USED AND USER RESPONDS YES    */
      /* TO PROMPT MESSAGE "SHIP-TO CHANGED; UPDATE TAX DATA? (Y/N)".  */
      /* THEN UPDATE LINE ITEM TAX ENVIRONMENT WITH THE HEADER TAX     */
      /* ENVIRONMENT OR RE-EVALUATE IF THE LINE SITE IS DIFFERENT FROM */
      /* THE HEADER SITE.                                              */

      if l_edittax
      then
         for each sod_det  where sod_det.sod_domain = global_domain and
         sod_nbr = so_nbr exclusive-lock:
            assign
               sod_tax_usage = so_tax_usage
               sod_tax_env   = if (sod_site = so_site)
                               then
                                  so_tax_env
                               else ""
               sod_tax_in    = tax_in.

         if sod_tax_env = ""
            and sod_taxable
         then do:
            /* CHECK FOR SITE ADDRESS */
            for first ad_mstr
               fields( ad_domain ad_addr ad_taxc ad_tax_usage ad_tax_zone
               ad_type)
                where ad_mstr.ad_domain = global_domain and  ad_addr = sod_site
               no-lock:
            end. /* FOR FIRST AD_MSTR */

            if available(ad_mstr)
            then
               zone_from = ad_tax_zone.
            else do:
               /* SITE ADDRESS # DOES NOT EXIST FOR LINE # */
               {pxmsg.i &MSGNUM=2355 &ERRORLEVEL=2
                        &MSGARG1=sod_site
                        &MSGARG2=sod_line}
               zone_from = "".
            end.

            /* CHECK FOR SHIP-TO ADDRESS */
            for first ad_mstr
               fields(ad_domain ad_addr ad_taxc ad_tax_usage ad_tax_zone
                      ad_type)
               where ad_mstr.ad_domain = global_domain
               and   ad_addr           = so_ship
               no-lock:
            end. /* FOR FIRST AD_MSTR */
            if available ad_mstr
            then
               zone_to = ad_tax_zone.
            else
               zone_to = "".

            {gprun.i ""txtxget2.p""
               "(input  zone_to,
                 input  zone_from,
                 input  so_taxc,
                 input  sod_site,
                 input  sod_line,
                 output sod_tax_env)"}

         end. /* SOD_TAX_ENV = "" AND SOD_TAXABLE */
      end. /* FOR EACH SOD_DET */

   end.
   undo_sosomtb = false.

end.    /* get_tax */
hide frame set_tax.
