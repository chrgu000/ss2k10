/* apvomte.p  - AP VOUCHER TAX DATA MAINTENANCE - Edit GTM tax fields       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.5.1.13 $                                                     */
/*V8:ConvertMode=Maintenance                                                */
/*                    CREATED:       12/14/92             BY: bcm *G418*    */
/*              LAST MODIFIED:       07/13/93             BY: wep *H037*    */
/*                                   03/03/94             BY: bcm *H290*    */
/*                                   04/07/94             BY: pcd *H325*    */
/*                                   02/23/95             BY: jzw *H0BM*    */
/*                                   04/10/95             BY: srk *H0CG*    */
/*                                   01/24/96             BY: jzw *H0J6*    */
/* REVISION: 8.6     MODIFIED:       03/10/97   BY: *K084*  Jeff Wootton    */
/* REVISION: 8.6     MODIFIED:       01/07/98   BY: *J29D*  Jim Josey       */
/* REVISION: 8.6     MODIFIED:       05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 9.0     MODIFIED:       03/10/99   BY: *M0B3* Michael Amaladhas*/
/* REVISION: 9.0     MODIFIED:       03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1     MODIFIED:       08/11/00   BY: *N0KK* jyn              */
/* REVISION: 9.1      LAST MODIFIED: 11/22/00   BY: *L15T* Veena Lad        */
/* REVISION: 9.1     LAST MODIFIED:  09/22/00  BY: *N0W0* Mudit Mehta       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.5.1.6  BY: Mamata Samant     DATE: 03/19/02  ECO: *P04F*  */
/* Revision: 1.5.1.7     BY: Dan Herman    DATE: 04/17/02  ECO: *P043*  */
/* Revision: 1.5.1.8     BY: Dan Herman    DATE: 05/23/02  ECO: *P06Q*  */
/* Revision: 1.5.1.9     BY: Jyoti Thatte  DATE: 02/21/03  ECO: *P0MX* */
/* Revision: 1.5.1.10  BY: Orawan S. DATE: 04/21/03 ECO: *P0Q8* */
/* Revision: 1.5.1.12  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* $Revision: 1.5.1.13 $ BY: Sachin Deshmukh   DATE: 10/13/04  ECO: *P2G6* */
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
    apvomte.p   Allow editing of tax fields in vouchers
*/
/* COPIED FROM APVOMT.P */

{mfdeclre.i}
{cxcustom.i "APVOMTE.P"}

define new shared variable zone_to     like txe_zone_to.
define new shared variable zone_from   like txe_zone_from.
define     shared variable ap_recno    as   recid.
define     shared variable vo_recno    as   recid.
define     shared variable vd_recno    as   recid.
define     shared variable ba_recno    as   recid.
define     shared variable tax_class   like ad_taxc      no-undo.
define     shared variable tax_usage   like ad_tax_usage no-undo.
define     shared variable tax_taxable like ad_taxable   no-undo.
define     shared variable tax_in      like ad_tax_in    no-undo.
define     shared variable undo_tframe like mfc_logical.
define     shared variable l_flag      like mfc_logical  no-undo.
define            variable tax_env     like txed_tax_env no-undo.

{&APVOMTE-P-TAG1}
{&APVOMTE-P-TAG10}
/*DEFINE VARIABLES FOR DISPLAY OF VAT REG NUMBER AND COUNTRY CODE*/
{apvtedef.i &var="new shared"}

{&APVOMTE-P-TAG6}
set_tax:
do on endkey undo, leave:
   tax_class = "".
   for first ap_mstr
      where recid(ap_mstr) = ap_recno
   no-lock:
   end. /* FOR FIRST ap_mstr */
   for first vo_mstr
      fields( vo_domain vo_ref vo_ship vo_taxable vo_taxc vo_tax_env
      vo_tax_usage)
      where recid(vo_mstr) = vo_recno
   no-lock:
   end. /* FOR FIRST vo_mstr*/
   for first vd_mstr
      fields( vd_domain vd_addr)
      where recid(vd_mstr) = vd_recno
   no-lock:
   end. /* FOR FIRST vd_mstr */
   find ba_mstr
      where recid(ba_mstr) = ba_recno
   exclusive-lock no-error.

   /* GET SHIP-TO FROM VOUCHER */
   if zone_to = ""
   then do:
      for first ad_mstr
         fields( ad_domain ad_addr ad_taxable ad_taxc ad_tax_in ad_tax_usage
         ad_tax_zone)
          where ad_mstr.ad_domain = global_domain and  ad_addr = vo_ship
      no-lock:
      end. /* FOR FIRST ad_mstr */
      if available ad_mstr
      then
         zone_to = ad_tax_zone.
      else do:
         for first ad_mstr
         fields( ad_domain ad_addr ad_taxable ad_taxc ad_tax_in ad_tax_usage
         ad_tax_zone)
             where ad_mstr.ad_domain = global_domain and  ad_addr = "~~taxes"
         no-lock:
         end. /* FOR FIRST ad_mstr */
         if available ad_mstr
         then
            zone_to = ad_tax_zone.
      end. /* IF AVAILABLE ad_mstr ELSE */
   end. /* IF ZONE_TO = "" */

   /* GET VENDOR SHIP-FROM TAX ZONE FROM PO */
   if zone_from = ""
   then do:
      for first vpo_det
         fields( vpo_domain vpo_po vpo_ref)
          where vpo_det.vpo_domain = global_domain and  vpo_ref = vo_ref
      no-lock:
      end. /* FOR FIRST vpo_det */
      if available vpo_det
      then do:
         for first po_mstr
            fields( po_domain po_nbr po_tax_env po_vend)
             where po_mstr.po_domain = global_domain and  po_nbr = vpo_po
         no-lock:
         end. /* FOR FIRST po_mstr */
         if available po_mstr
         then do:
            for first ad_mstr
               fields( ad_domain ad_addr ad_taxable ad_taxc ad_tax_in
                       ad_tax_usage ad_tax_zone)
                where ad_mstr.ad_domain = global_domain and  ad_addr = po_vend
            no-lock:
            end. /* FOR FIRST ad_mstr */
            if available ad_mstr
            then
               assign
                  zone_from   = ad_tax_zone
                  tax_class   = ad_taxc
                  tax_usage   = ad_tax_usage
                  tax_taxable = ad_taxable
                  tax_in      = ad_tax_in.
         end. /* IF AVAILABLE po_mstr */
      end. /* IF AVAILABLE vpo_det */
      /* OTHERWISE, GET SHIP-FROM TAX ZONE FROM VENDOR ADDRESS */
      else if zone_from = ""
      then do:
         for first ad_mstr
            fields( ad_domain ad_addr ad_taxable ad_taxc ad_tax_in
                    ad_tax_usage ad_tax_zone)
             where ad_mstr.ad_domain = global_domain and  ad_addr = vd_addr
         no-lock:
         end. /* FOR FIRST ad_mstr */
         if available ad_mstr
         then
            assign
               zone_from   = ad_tax_zone
               tax_class   = ad_taxc
               tax_usage   = ad_tax_usage
               tax_taxable = ad_taxable
               tax_in      = ad_tax_in.
      end. /* ELSE IF zone_from = "" */
   end. /* IF ZONE_FROM = "" */

   {&APVOMTE-P-TAG7}
   tax_env = vo_tax_env.

   /* SET TAX ENVIRONMENT IF AVAILABLE */
   if tax_env = ""
   then do:
      /* TRY PURCHASE RECEIPTS TAX ENVIRONMENT */
      for first vpo_det
          where vpo_det.vpo_domain = global_domain and  vpo_ref = vo_ref
      no-lock:
      end. /* FOR FIRST vpo_det */
      if  available vpo_det
      and can-find(first pvo_mstr
                      where pvo_mstr.pvo_domain = global_domain and  pvo_order
                      = vpo_po)
      then do:
         for first pvo_mstr
            fields( pvo_domain pvo_order pvo_tax_env)
             where pvo_mstr.pvo_domain = global_domain and  pvo_order = vpo_po
         no-lock:
         end. /* FOR FIRST pvo_mstr */
         tax_env = pvo_tax_env.
      end. /* IF AVAILABLE vpo_det AND ..*/
      /* TRY PURCHASE ORDER TAX ENVIRONMENT */
      else if  available vpo_det
           and can-find(po_mstr
                           where po_mstr.po_domain = global_domain and  po_nbr
                           = vpo_po)
      then do:
         for first po_mstr
            fields( po_domain po_nbr po_tax_env po_vend)
             where po_mstr.po_domain = global_domain and  po_nbr = vpo_po
         no-lock:
         end. /*  FOR FIRST po_mstr */
         tax_env = po_tax_env.
      end. /* ELSE IF AVAILABLE vpo_det */

   end. /* IF TAX_ENV = "" */

   /*RE-STRUCTURED SET_TAX1 LOOP*/
   /*OBTAIN AND EDIT TAX CLASS AND ENVIRONMENT VARS*/

   {&APVOMTE-P-TAG2}
   set_tax1:
   do on error undo, retry:
      {&APVOMTE-P-TAG3}
      {&APVOMTE-P-TAG11}
      if tax_env = ""
      then do:
         {gprun.i ""txtxeget.p""
            "(input  zone_to,
              input  zone_from,
              input  tax_class,
              output tax_env)"}
      end. /* IF tax_env = "" */
      /* REPLACE TAX_CLASS WITH VO_TAXC IN VERSION * tax92 */
      /* TAX MANAGEMENT TRANSACTION POP-UP. */
      /* PARAMETERS ARE 5 FIELDS AND UPDATEABLE FLAGS, STARTING ROW, AND UNDO */
      /* FLAG. CHANGED TAX_TAXABLE TO UPDATEABLE CHANGED TAX_IN TO UPDATEABLE */

      {&APVOMTE-P-TAG8}
      {gprun.i ""xxtxtrnpop.p""
         "(input-output tax_usage,   input true,
           input-output tax_env,     input true,
           input-output tax_class,   input true,
           input-output tax_taxable, input true,
           input-output tax_in,      input true,
           input 6,
           output undo_tframe)"}
      {&APVOMTE-P-TAG9}

      if undo_tframe
      then
         if not batchrun
         then
            undo set_tax, leave.
      else do:
         l_flag = true.
         return.
      end. /* IF undo_frame ELSE */
      {&APVOMTE-P-TAG4}
      assign
         vo_tax_env   = tax_env
         vo_taxable   = tax_taxable
         vo_taxc      = tax_class
         vo_tax_usage = tax_usage.

   end. /* SET-TAX1 */

   undo_tframe = false.

end. /* DO ON ENDKEY UNDO,LEAVE */

{&APVOMTE-P-TAG5}
