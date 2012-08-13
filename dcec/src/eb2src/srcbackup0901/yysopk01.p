/* GUI CONVERTED from sopk01.p (converter v1.76) Thu Dec  5 05:03:36 2002 */
/* sopk01.p - PACKING LIST PRINT MAIN SUBROUTINE                        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.30 $                                                         */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 5.0      LAST MODIFIED: 03/28/90   BY: MLB *B615* */
/* REVISION: 5.0      LAST MODIFIED: 03/14/90   BY: FTB*D004**/
/* REVISION: 6.0      LAST MODIFIED: 04/10/90   BY: ftb *D002**/
/* REVISION: 6.0      LAST MODIFIED: 05/01/90   BY: MLB *D021**/
/* REVISION: 5.9      LAST MODIFIED: 09/04/90   BY: MLB *B781**/
/* REVISION: 6.0      LAST MODIFIED: 11/02/90   BY: WUG *D173**/
/* REVISION: 6.0      LAST MODIFIED: 01/30/91   BY: afs *D323**/
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: afs *D425**/
/* REVISION: 7.0      LAST MODIFIED: 02/07/92   BY: afs *F180**/
/* REVISION: 7.0      LAST MODIFIED: 03/26/92   BY: dld *F322**/
/* REVISION: 7.0      LAST MODIFIED: 05/07/92   BY: tjs *F444**/
/* REVISION: 7.0      LAST MODIFIED: 06/17/92   BY: tjs *F504**/
/* REVISION: 7.3      LAST MODIFIED: 12/02/92   BY: WUG *G383**/
/* REVISION: 7.3      LAST MODIFIED: 12/21/93   BY: WUG *GI32**/
/* REVISION: 7.3      LAST MODIFIED: 05/19/94   BY: afs *FO29**/
/* REVISION: 7.3      LAST MODIFIED: 05/09/95   BY: jym *F0RF**/
/* REVISION: 7.3      LAST MODIFIED: 10/10/95   BY: jym *G0YX**/
/* REVISION: 7.3      LAST MODIFIED: 02/07/96   BY: ais *G0NX**/
/* REVISION: 8.5      LAST MODIFIED: 10/01/96   BY: *J15B* Sue Poland         */
/* REVISION: 8.6      LAST MODIFIED: 12/23/96   BY: *K022* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 01/10/97   BY: *K04R* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 04/18/97   BY: *H0YD* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 04/29/97   BY: *K0CH* Taek-Soo Chang     */
/* REVISION: 8.6      LAST MODIFIED: 06/03/97   BY: *H0ZF* Irine D'mello      */
/* REVISION: 8.6      LAST MODIFIED: 07/13/97   BY: *K0DH* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 07/21/97   BY: *J1WT* Markus Barone      */
/* REVISION: 8.6      LAST MODIFIED: 09/29/97   BY: *J220* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 02/11/98   BY: *J2DK* Nirav Parikh       */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 11/16/98   BY: *J347* Satish Chavan      */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 05/11/99   BY: *H1P0* Poonam Bahl        */
/* REVISION: 9.1      LAST MODIFIED: 08/23/99   BY: *N01B* Poonam Bahl        */
/* REVISION: 9.1      LAST MODIFIED: 12/02/99   BY: *N05D* Steve Nugent       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb                */
/* REVISION: 9.1      LAST MODIFIED: 08/17/00   BY: *M0RG* Abhijeet Thakur    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.30 $   BY: Laurene Sheridan  DATE: 11/01/02  ECO: *P09M* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* PARAMETER TO FACILITATE DISPLAY OF SIMULATION STRING */
/* IN THE REPORT HEADER                                 */
define input parameter update_yn like mfc_logical no-undo.

define new shared variable first_line as logical.
define new shared variable sod_recno as recid.
define new shared variable so_recno as recid.
define new shared variable pages as integer.
define new shared variable old_sod_nbr like sod_nbr.

define     shared variable due_date  like sod_due_date.
define     shared variable due_date1 like sod_due_date.
define     shared variable nbr       like so_nbr.
define     shared variable nbr1      like so_nbr.
define     shared variable site      like sod_site.
define     shared variable site1     like sod_site.
define     shared variable all_only as logical initial yes
           label "Print Only Lines to Pick".
define     shared variable print_options as logical initial no
           label "Print Features and Options".
define     shared variable addr as character format "x(38)" extent 6.
define     shared variable include_partial as logical
           label "Override Partial OK Flag".
define     shared variable print_loc     as logical label "Print Locations".
define     shared variable company       as character format "x(38)" extent 6.
define     shared variable lang          like so_lang.
define     shared variable lang1         like lang.
define     shared variable print_neg     like mfc_logical.
define     shared variable pack_list_exists as logical no-undo.
define     shared variable picked_site   like sod_site.
define     shared variable ship          like so_ship.
define     shared variable ship1         like so_ship.
define            variable i             as integer.
define            variable billto        as character format "x(38)" extent 6.
define            variable shipto        as character format "x(38)" extent 6.
define            variable termsdesc     like ct_desc.
define            variable partial_ok    as logical.
define            variable oktouse       as logical.
define            variable open_qty      like sod_qty_ord.
define            variable l_so_printpl  like mfc_logical no-undo.
define            variable sched_netting as logical initial yes.

define buffer somstr     for so_mstr.
define buffer rmdreceipt for rmd_det.

assign
   pages = 0
   old_sod_nbr = ?.

if lang1 = " " then
   lang1 = hi_char.

/* FOR UPDATE = YES, LIMITING THE TRANSACTION SCOPE FOR ONE      */
/* SO_MSTR RECORD AT A TIME AND MAINTAIN DATABASE INTEGRITY      */
so_mstr_loop:
for each so_mstr
   where (so_nbr >= nbr and so_nbr <= nbr1)
     and so_ship >= ship and so_ship <= ship1
     and so_stat = ""
     and so_print_pl = yes
     and (so_lang >= lang and so_lang <= lang1)
     and not so_secondary
   no-lock by so_nbr transaction:

   so_recno = recid(so_mstr).

   if can-find(first qad_wkfl
      where qad_wkfl.qad_key2 = "CreditCard"
      and qad_wkfl.qad_key1
      begins string(so_mstr.so_nbr,"x(8)"))
   then do:
      for each sod_det
         where sod_nbr = so_nbr
           and sod_site >= site and sod_site <= site1
           and sod_due_date >= due_date and sod_due_date <= due_date1
           and (sod_qty_ord - sod_qty_pick - sod_qty_ship) > 0
           and (sod_due_date >= due_date or due_date = ?)
           and (sod_due_date <= due_date1 or due_date1 = ?)
           and (sod_site >= site or site = "")
           and (sod_site <= site1 or site1 = "")
      no-lock:

         for first qad_wkfl
            where qad_key1 = string(so_nbr,"x(8)") + string(sod_line,"999")
              and qad_key2 = "CreditCard"
              and qad_logfld[1]
              and qad_datefld[1] < today
         no-lock:

            if available(qad_wkfl)
            then do:
               for first soc_ctrl no-lock:
               if soc_cr_hold then do:

                  find somstr where so_recno = recid(somstr)
                     exclusive-lock no-wait no-error.
                  if locked(somstr) then
                     next so_mstr_loop.
                  else if available(somstr) then
                     assign
                        somstr.so_stat = "HD".
               end.
            end.
            next so_mstr_loop.
         end.  /* for first qad_wkfl*/
      end.  /*for each sod_det*/
   end.
end.

   /* Skip SO if batch shipment is pending */
   if can-find( qad_wkfl where qad_key1 = "sosois.p" + so_nbr
                           and qad_key2 = "BATCH" )
   then
      next so_mstr_loop.

  /*judy 07/07/05*/  /*   {sopka01.i}*/
  /*judy 07/07/05*/   {yysopka01.i}

   if so_sched then do:
      oktouse = no.

      for each sod_det no-lock
         where (sod_nbr = so_nbr)
           and sod_sched
           and sod_site >= site and sod_site <= site1
           and sod_pickdate = ?
           and can-find (sch_mstr where
              sch_type = 3         and
              sch_nbr  = sod_nbr   and
              sch_line = sod_line  and
              sch_rlse_id = sod_curr_rlse_id[3]):

         {gprun.i ""rcoqty.p""
            "(input recid(sod_det),
              input due_date1,
              input sched_netting,
              output open_qty)"}
         if open_qty = 0 then next.

         if sod_qty_ord > 0 and (sod_qty_ord - sod_qty_ship) < 0 then next.
         if sod_qty_ord < 0 and (sod_qty_ord - sod_qty_ship) > 0 then next.

         if oktouse = no and
            (sod_qty_all > 0 or (not all_only and open_qty - sod_qty_pick > 0))
         then oktouse = yes.

         if not so_partial and not include_partial then do:
            if open_qty - sod_qty_pick > sod_qty_all then
               next so_mstr_loop.
         end.

         /* DO LOOP ADDED TO SKIP LOCKED SO_MSTR RECORDS */

         /* TRANSACTION IS ALREADY STARTED AT FOR EACH SO_MSTR LOOP*/
         do for somstr:
            find somstr where so_recno = recid(somstr)
               exclusive-lock no-wait no-error.
            if (available somstr and not locked somstr) then
               l_so_printpl = yes.
            else
               l_so_printpl = no.
         end. /* DO FOR SOMSTR */

         if l_so_printpl = no then
            next so_mstr_loop.

      end.

      if not oktouse then next.

      termsdesc = "".
      find ct_mstr where ct_code = so_cr_terms no-lock no-error.
      if available ct_mstr then termsdesc = ct_desc.

      so_recno = recid(so_mstr).
      update billto = "".
      update shipto = "".

      find ad_mstr where ad_addr = so_cust no-lock no-error.
      if available ad_mstr then do:

         assign
            addr[1] = ad_name
            addr[2] = ad_line1
            addr[3] = ad_line2
            addr[4] = ad_line3
            addr[6] = ad_country.
         {mfcsz.i addr[5] ad_city ad_state ad_zip}.
         {gprun.i ""gpaddr.p"" }
         assign
            billto[1] = addr[1]
            billto[2] = addr[2]
            billto[3] = addr[3]
            billto[4] = addr[4]
            billto[5] = addr[5]
            billto[6] = addr[6].
      end.

      find ad_mstr where ad_addr = so_ship no-lock no-error.
      if available ad_mstr then do:
         assign
            addr[1] = ad_name
            addr[2] = ad_line1
            addr[3] = ad_line2
            addr[4] = ad_line3
            addr[6] = ad_country.
         {mfcsz.i addr[5] ad_city ad_state ad_zip}.
         {gprun.i ""gpaddr.p"" }
         assign
            shipto[1] = addr[1]
            shipto[2] = addr[2]
            shipto[3] = addr[3]
            shipto[4] = addr[4]
            shipto[5] = addr[5]
            shipto[6] = addr[6].
      end.
      view frame phead1.

      pages = page-number - 1.

      display
         so_slspsn[1]
/*judy 07/07/05*/ /*   so_slspsn[2]
/*judy 07/07/05*/         so_slspsn[3] so_slspsn[4]*/
         so_po
         so_cr_terms
/*judy 07/07/05*//*   so_shipvia
/*judy 07/07/05*/         so_fob    
/*judy 07/07/05*/      termsdesc*/
/*judy 07/07/05*/ /*         so_fob       */
         so_rmks
      with frame phead2 STREAM-IO /*GUI*/ .

      first_line = yes.
      {gprun.i ""rcpkb01.p""}
      page.
   end.

   /*    ELSE, THIS ISN'T A SCHEDULED ORDER, DO */

   else do:
      assign
         oktouse          = no
         partial_ok       = yes
         pack_list_exists = no
         picked_site      = "MoreThan8".

      for first sod_det
         fields (sod_btb_type sod_confirm sod_curr_rlse_id sod_due_date
                 sod_line sod_nbr sod_pickdate sod_qty_all sod_qty_ord
                 sod_qty_pick sod_qty_ship sod_rma_type sod_sched
                 sod_site)
         where  sod_nbr      = so_nbr    and
              ((sod_btb_type = "02"      and
                not (so_fsm_type  = "SEO")) or
                sod_btb_type = "03")  no-lock:
      end. /* FOR FIRST SOD_DET */
      if available sod_det then
         next so_mstr_loop.

      for each sod_det
         where (sod_nbr = so_nbr)
           and not sod_sched
           and sod_confirm
         no-lock by sod_site
                 by sod_qty_pick:

         /* WE ONLY WANT TO PRINT A PACKING LIST FOR SALES ORDER LINES */
         /* THAT HAVE AN EMT TYPE OF NON-EMT ("01") OR MATERIAL ORDER  */
         /* LINES (so_fsm_type = "SEO") THAT ARE EITHER NON-EMT OR     */
         /* TRANSHIP ("02"). SALES ORDERS MUST USE PRE-SHIPPERS AND/OR */
         /* SHIPPERS TO CREATE PACKING LISTS AND SHIPPING DOCUMENTS.   */
         /* MATERIAL ORDERS CANNOT USE PRE-SHIPPERS OR SHIPPERS, SO    */
         /* PACKING LISTS MUST BE AVAILABLE TO MATERIAL ORDERS         */
         /* REGARDLESS IF THE MATERIAL ORDER LINE IS AN EMT LINE.      */
         /* NOTE: MATERIAL ORDERS DO NOT USE DIRECT SHIPMENTS ("03").  */

         if sod_btb_type = "01" or
            (sod_btb_type = "02" and so_fsm_type = "SEO")
         then do:

            if sod_qty_ord > 0 and (sod_qty_ord - sod_qty_ship) < 0 then next.
            if sod_qty_ord < 0 and (sod_qty_ord - sod_qty_ship) > 0 then next.

            if sod_rma_type = "I" then
               next.
            if sod_qty_pick <> 0 then picked_site = sod_site.

            if oktouse = no    and
               ((sod_qty_all > 0  or
               (not all_only     and
               sod_qty_ord - sod_qty_pick - sod_qty_ship > 0))    or
               (print_neg        and
               (sod_qty_all < 0  or
               (not all_only     and
               sod_qty_ord - sod_qty_pick - sod_qty_ship < 0))))  and
               (sod_due_date >= due_date  or due_date  = ?)       and
               (sod_due_date <= due_date1 or due_date1 = ?)       and
               (sod_site     >= site      or site      = "")      and
               (sod_site     <= site1     or site1     = "")
            then
               oktouse = yes.

            if so_partial = yes or include_partial = yes then
               partial_ok = yes.

            /* IF SO ENTRY IS CREATED THROUGH A RMA THEN THE BELOW LOGIC */
            /* CHECKS IF THE PACKING LIST SHOULD  BE PRINTED OR NOT.     */
            /* IT FIRST CHECKS IF RMA LINE BEING SHIPPED IS LINKED. I.E. */
            /* IF THE RECEIPT LINE IS LINKED TO THE ISSUE LINE. IF LINKED*/
            /* THEN THE SHIP BEFORE FLAG IS CHECKED. IF THE FLAG IS  NO  */
            /* THEN IT CHECKS IF THE QTY RECEIVED ON THE RECEIPT LINE IS */
            /* LESS THAN THE QTY ALLOCATED + SHIPPED FOR THE ISSUE LINE  */
            /* IF TRUE THEN THE PICKLIST IS NOT PRINTED                  */

            if so_fsm_type = "RMA" then do:
               for first rmd_det
                  fields(rmd_line rmd_link rmd_nbr rmd_prefix rmd_qty_acp)
                  where rmd_det.rmd_nbr    = sod_nbr
                    and rmd_det.rmd_prefix = "C"
                    and rmd_det.rmd_line   = sod_line
               no-lock:
               end. /* END OF FOR FIRST RMD_DET */

               if available rmd_det and rmd_det.rmd_link <> 0 then
                  for first rma_mstr
                     fields( rma_ctype rma_nbr rma_prefix)
                     where rma_nbr    = sod_nbr
                       and rma_prefix = "C"
                  no-lock:
                  end. /* END OF FOR FIRST RMA_MSTR */

               if available rma_mstr then
                  for first sv_mstr
                     fields(sv_code sv_shp_b4rtn sv_type)
                     where sv_code = rma_ctype
                       and sv_type = ""
                  no-lock:
                  end. /* END OF FOR FIRST SV_MSTR */

               if available sv_mstr and not sv_shp_b4rtn then
                  for first rmdreceipt
                     fields(rmd_line rmd_link rmd_nbr
                            rmd_prefix rmd_qty_acp)
                     where rmdreceipt.rmd_nbr    = sod_nbr
                       and rmdreceipt.rmd_prefix = "C"
                       and rmdreceipt.rmd_line   = rmd_det.rmd_link
                  no-lock:
                  end. /* END OF FOR FIRST RMDRECEIPT */

               if available rmdreceipt and
                  rmdreceipt.rmd_qty_acp < (sod_qty_all + sod_qty_ship)
               then
                  partial_ok = no.
            end. /* END OF IF SO_FSM_TYPE = "RMA" */

            if so_partial = no and include_partial = no and
               (((sod_qty_ord  > 0 and
               sod_qty_all  < sod_qty_ord - sod_qty_pick - sod_qty_ship)  or
               (sod_qty_ord  < 0 and
               sod_qty_all  > sod_qty_ord - sod_qty_pick - sod_qty_ship)) or
               (sod_due_date < due_date  or
                sod_due_date > due_date1 or
                sod_site     < site      or
                sod_site     > site1))
            then
               partial_ok = no.

            if not partial_ok then leave.

            if sod_due_date < due_date  or
               sod_due_date > due_date1 or
               sod_site     < site      or
               sod_site     > site1
            then next.

            if sod_site = picked_site and oktouse then do:

               if nbr = nbr1 then
                  pack_list_exists = yes. /* specific S.Order */

               oktouse = no.
               leave. /* disallow 2 pack lists at a site. */
            end.

            /* DO LOOP ADDED TO SKIP LOCKED SO_MSTR RECORDS */

            /* TRANSACTION IS ALREADY STARTED AT FOR EACH SO_MSTR LOOP*/
            do for somstr:
               find somstr where so_recno = recid(somstr)
                  exclusive-lock no-wait no-error.
               if (available somstr and not locked somstr) then
                  l_so_printpl = yes.
               else
                  l_so_printpl = no.
            end. /* DO FOR SOMSTR */
            if l_so_printpl = no then
               next so_mstr_loop.

         end. /* IF sod_btb_type = "01" or (sod_btb_type = "02" ....) */

      end. /* FOR EACH sod_det */

      if partial_ok = no then next.
      if not oktouse then next.

      termsdesc = "".
      find ct_mstr where ct_code = so_cr_terms no-lock no-error.
      if available ct_mstr then termsdesc = ct_desc.

      so_recno = recid(so_mstr).
      update billto = "".
      update shipto = "".

      find ad_mstr where ad_addr = so_cust no-lock no-error.
      if available ad_mstr then do:

         assign
            addr[1] = ad_name
            addr[2] = ad_line1
            addr[3] = ad_line2
            addr[4] = ad_line3
            addr[6] = ad_country.
         {mfcsz.i addr[5] ad_city ad_state ad_zip}.
         {gprun.i ""gpaddr.p"" }
         assign
            billto[1] = addr[1]
            billto[2] = addr[2]
            billto[3] = addr[3]
            billto[4] = addr[4]
            billto[5] = addr[5]
            billto[6] = addr[6].
      end.

      /* FOR SEO'S (SERVICE ENGINEER ORDERS) BEING SHIPPED TO THE
         ENGINEER INSTEAD OF TO A SERVICE CALL'S CUSTOMER, PRINT THE
         ENGINEER'S ADDRESS (FROM HIS EMPLOYEE ADDRESS) AS THE SHIP-TO */
      if so_fsm_type = "SEO" and so_eng_code = so_ship then do:
         find eng_mstr where eng_code = so_ship no-lock no-error.
         if available eng_mstr then
            find ad_mstr where ad_addr = eng_address no-lock no-error.
      end.
      else
         find ad_mstr where ad_addr = so_ship no-lock no-error.

      if available ad_mstr then do:
         assign
            addr[1] = ad_name
            addr[2] = ad_line1
            addr[3] = ad_line2
            addr[4] = ad_line3
            addr[6] = ad_country.
         {mfcsz.i addr[5] ad_city ad_state ad_zip}.
         {gprun.i ""gpaddr.p"" }
         assign
            shipto[1] = addr[1]
            shipto[2] = addr[2]
            shipto[3] = addr[3]
            shipto[4] = addr[4]
            shipto[5] = addr[5]
            shipto[6] = addr[6].
      end.
      view frame phead1.

      pages = page-number - 1.

      display
         so_slspsn[1] 
/*judy 07/07/05*/ /*   so_slspsn[2]
/*judy 07/07/05*/         so_slspsn[3] so_slspsn[4]*/
          so_po
         so_cr_terms
/*judy 07/07/05*/ /*   so_shipvia
/*judy 07/07/05*/          so_fob
/*judy 07/07/05*/          termsdesc
/*judy 07/07/05*/          so_fob*/
         so_rmks
      with frame phead2 STREAM-IO /*GUI*/ .

      first_line = yes.

      {gprun.i ""sopkb01.p""}
      page.
   end. /* ELSE DO */
end. /* FOR EACH so_mstr */
