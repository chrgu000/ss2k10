/* sopk01.p - PACKING LIST PRINT MAIN SUBROUTINE                        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
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
/* REVISION: 9.1      LAST MODIFIED: 03/20/06   BY: *SS - Micho 20060320* Micho Yang    */

         {mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sopk01_p_1 "Override Partial OK Flag"
/* MaxLen: Comment: */

&SCOPED-DEFINE sopk01_p_2 "Print Locations"
/* MaxLen: Comment: */

&SCOPED-DEFINE sopk01_p_3 "Print Features and Options"
/* MaxLen: Comment: */

&SCOPED-DEFINE sopk01_p_4 "Print Only Lines to Pick"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*N01B*/ /* PARAMETER TO FACILITATE DISPLAY OF SIMULATION STRING */
/*N01B*/ /* IN THE REPORT HEADER                                 */
/*N01B*/ define input parameter update_yn like mfc_logical no-undo.

         define     shared variable due_date like sod_due_date.
         define     shared variable due_date1 like sod_due_date.
         define     shared variable nbr like so_nbr.
         define     shared variable nbr1 like so_nbr.
         define     shared variable site like sod_site.
         define     shared variable site1 like sod_site.
         define     shared variable all_only as logical initial yes
                            label {&sopk01_p_4}.
         define     shared variable print_options as logical initial no
                            label {&sopk01_p_3}.
         define     shared variable addr as character format "x(38)" extent 6.
         define     shared variable include_partial as logical
                            label {&sopk01_p_1}.
         define     shared variable print_loc as logical label {&sopk01_p_2}.
         define     shared variable company as character format "x(38)" extent 6.
         define     shared variable lang like so_lang.
         define     shared variable lang1 like lang.
         define            variable i as integer.
         define            variable billto as character format "x(38)" extent 6.
         define            variable shipto as character format "x(38)" extent 6.
         define            variable termsdesc like ct_desc.
         define            variable partial_ok as logical.
         define new shared variable first_line as logical.
         define new shared variable sod_recno as recid.
         define new shared variable so_recno as recid.
         define new shared variable pages as integer.
         define new shared variable old_sod_nbr like sod_nbr.
         define     shared variable print_neg like mfc_logical.
         define            variable oktouse as logical.
/*N01B** /*F444*/ define     shared variable pack_list_exists as logical. */
/*N01B*/ define     shared variable pack_list_exists as logical no-undo.
/*F504*/ define     shared variable picked_site like sod_site.
         define     shared variable ship like so_ship.       /*GI32*/
         define     shared variable ship1   like so_ship.    /*GI32*/
         define            variable open_qty like sod_qty_ord.      /*GI32*/
/*J1WT*J15B* define            variable eng_address like ad_addr no-undo.  */
/*H0YD*/ define variable l_so_printpl like mfc_logical no-undo.
/*K0CH*/ define variable sched_netting as logical init yes.

/*H0YD*/ define buffer somstr     for so_mstr.
/*J347*/ define buffer rmdreceipt for rmd_det.

/****************************** SS - Micho 20060320 add B *************************/
FORM HEADER 
    SKIP
    "________________________________________________________________________________"  SKIP
    "±£¹ÜÔ±:                                                                         " 
    WITH STREAM-IO FRAME v_page PAGE-BOTTOM WIDTH 90.
/****************************** SS - Micho 20060320 E *************************/

      pages = 0.
      old_sod_nbr = ?.

/*F0RF** **BEGIN FIX** SEARCH FOR ALL LANGUAGE CODES IF FROM AND TO **
     PARAMETERS FOR lang & lang1 ARE BLANK BY SETTING lang1 TO hi_char */
      if lang1 = " " then assign
    lang1 = hi_char.
/*F0RF**   **END FIX**/

/*N01B*/ /* FOR UPDATE = YES, LIMITING THE TRANSACTION SCOPE FOR ONE      */
/*N01B*/ /* SO_MSTR RECORD AT A TIME AND MAINTAIN DATABASE INTEGRITY      */
      so_mstr_loop:                                             /*GI32*/
      for each so_mstr where (so_nbr >= nbr and so_nbr <= nbr1)
      and so_ship >= ship and so_ship <= ship1                  /*GI32*/
             and so_stat = ""
             and so_print_pl = yes
/*FO29*/                 and (so_lang >= lang and so_lang <= lang1)
/*F504*/              /* and so_conf_date <> ? */
/*K04R* /*K022*/         and not so_primary    */
/*K0DH* /*K04R*/         and so_primary        */
/*K0DH*/                 and not so_secondary
/*N01B**       no-lock by so_nbr: */
/*N01B*/       no-lock by so_nbr TRANSACTION :
/*H0YD*/    so_recno = recid(so_mstr).

/*H1P0*/    /* MOVED THIS SECTION OF CODE TO SOD_DET LOOP BELOW */
/*H1P0**    BEGIN DELETE **
 * /*H0YD*/    /* DO LOOP ADDED TO SKIP LOCKED SO_MSTR RECORDS */
 *
 * /*H0YD*/    do for somstr transaction:
 * /*H0YD*/       find somstr where so_recno = recid(somstr)
 * /*H0YD*/       exclusive-lock no-wait no-error.
 * /*H0YD*/       if (available somstr and not locked somstr) then
 * /*H0YD*/          l_so_printpl = yes.
 * /*H0YD*/       else
 * /*H0YD*/          l_so_printpl = no.
 * /*H0YD*/    end. /* DO FOR SOMSTR */
 *
 * /*H0YD*/    if l_so_printpl = no then
 * /*H0YD*/        next so_mstr_loop.
 *H1P0**    END DELETE */

/*G0NX*/ /* Skip SO if batch shipment is pending */
/*G0NX*/ if can-find( qad_wkfl where qad_key1 = "sosois.p" + so_nbr
/*G0NX*/                         and qad_key2 = "BATCH" )
/*G0NX*/    then next so_mstr_loop.

/****************************** SS - Micho 20060320 B *************************/
/*
 *    {sopka01.i} */
      {xxsopka01.i} 
/****************************** SS - Micho 20060320 B *************************/

     if so_sched then do:                                   /*GI32*/
        oktouse = no.

        for each sod_det no-lock
        where (sod_nbr = so_nbr)
        and sod_sched
        and sod_site >= site and sod_site <= site1
/*J220** and sod_pickdate = ?, */
/*J220*/ and sod_pickdate = ?

/*J220** ** BEGIN DELETE **
 *      each sch_mstr no-lock
 *       where sch_type = 3
 *       and sch_nbr = sod_nbr
 *       and sch_line = sod_line
 *       and sch_rlse_id = sod_curr_rlse_id[3]:
 *J220** ** END DELETE ** */

/*J220*/ and can-find (sch_mstr where
/*J220*/    sch_type = 3         and
/*J220*/    sch_nbr  = sod_nbr   and
/*J220*/    sch_line = sod_line  and
/*J220*/    sch_rlse_id = sod_curr_rlse_id[3]):

/*K0CH*     {gprun.i ""rcoqty.p""
            "(input recid(sod_det), input due_date1, output open_qty)"}  */
/*K0CH*/    {gprun.i ""rcoqty.p""
             "(input recid(sod_det), input due_date1, input sched_netting,
               output open_qty)"}
           if open_qty = 0 then next.

/*G0YX*/    if sod_qty_ord > 0 and (sod_qty_ord - sod_qty_ship) < 0 then next.
/*G0YX*/    if sod_qty_ord < 0 and (sod_qty_ord - sod_qty_ship) > 0 then next.

           if oktouse = no and (sod_qty_all > 0 or  (not all_only and
           open_qty - sod_qty_pick > 0))
           then oktouse = yes.

           if not so_partial and not include_partial then do:
          if open_qty - sod_qty_pick > sod_qty_all then
             next so_mstr_loop.
           end.

/*H1P0*/   /* DO LOOP ADDED TO SKIP LOCKED SO_MSTR RECORDS */

/*N01B*/  /* TRANSACTION IS ALREADY STARTED AT FOR EACH SO_MSTR LOOP*/
/*N01B** /*H1P0*/   do for somstr transaction: */
/*N01B*/   do for somstr:
/*H1P0*/      find somstr where so_recno = recid(somstr)
/*H1P0*/      exclusive-lock no-wait no-error.
/*H1P0*/      if (available somstr and not locked somstr) then
/*H1P0*/         l_so_printpl = yes.
/*H1P0*/      else
/*H1P0*/         l_so_printpl = no.
/*H1P0*/   end. /* DO FOR SOMSTR */

/*H1P0*/   if l_so_printpl = no then
/*H1P0*/      next so_mstr_loop.

        end.

        if not oktouse then next.
        /*END SECTION*/

        termsdesc = "".
        find ct_mstr where ct_code = so_cr_terms no-lock no-error.
        if available ct_mstr then termsdesc = ct_desc.

        so_recno = recid(so_mstr).
        update billto = "".
        update shipto = "".

        find ad_mstr where ad_addr = so_cust no-lock no-error.
        if available ad_mstr then do:
/****************************** SS - Micho 20060320 B *************************/
/*            addr[1] = ad_name.                         */
/*            addr[2] = ad_line1.                        */
/*            addr[3] = ad_line2.                        */
/*            addr[4] = ad_line3.                        */
/*            addr[6] = ad_country.                      */
/*            {mfcsz.i addr[5] ad_city ad_state ad_zip}. */
/*            {gprun.i ""gpaddr.p"" }                    */
/*            billto[1] = addr[1].                       */
/*            billto[2] = addr[2].                       */
/*            billto[3] = addr[3].                       */
/*            billto[4] = addr[4].                       */
/*            billto[5] = addr[5].                       */
/*            billto[6] = addr[6].                       */
              
              addr[1] = ad_name.
              addr[2] = ad_line1 + " " + ad_Line2 + " " + ad_line3 .
              addr[3] = ad_state.
              addr[4] = ad_city.
              addr[6] = ad_country.

              billto[1] = addr[1].                       
              billto[2] = addr[2].                       
              billto[3] = addr[3].                       
              billto[4] = addr[4].                       
              billto[5] = addr[5].                       
              billto[6] = addr[6].                                              
/****************************** SS - Micho 20060320 E *************************/
        end.

        find ad_mstr where ad_addr = so_ship no-lock no-error.
        if available ad_mstr then do:
/****************************** SS - Micho 20060320 B *************************/
/*            addr[1] = ad_name.                         */
/*            addr[2] = ad_line1.                        */
/*            addr[3] = ad_line2.                        */
/*            addr[4] = ad_line3.                        */
/*            addr[6] = ad_country.                      */
/*            {mfcsz.i addr[5] ad_city ad_state ad_zip}. */
/*            {gprun.i ""gpaddr.p"" }                    */
/*            shipto[1] = addr[1].                       */
/*            shipto[2] = addr[2].                       */
/*            shipto[3] = addr[3].                       */
/*            shipto[4] = addr[4].                       */
/*            shipto[5] = addr[5].                       */
/*            shipto[6] = addr[6].                       */

           addr[1] = ad_name.
           addr[2] = ad_line1 + " " + ad_line2 + " " + ad_line3 .
           addr[3] = ad_state .
           addr[4] = ad_city .
           addr[6] = ad_country.

           shipto[1] = addr[1].
           shipto[2] = addr[2].
           shipto[3] = addr[3].
           shipto[4] = addr[4].
           shipto[5] = addr[5].
           shipto[6] = addr[6].
/****************************** SS - Micho 20060320 E *************************/
        end.
        view frame phead1.

   /*D323*/ pages = page-number - 1.
   /****************************** SS - Micho 20060320 B *************************/
   /*
    * /*D021*/ display so_slspsn[1] so_slspsn[2]
    * /*F322*/  so_slspsn[3] so_slspsn[4]
    *     so_po so_cr_terms so_shipvia so_fob termsdesc so_fob
    * /*D021*/  so_rmks with frame phead2.
    */
   /****************************** SS - Micho 20060320 E *************************/

        first_line = yes.
        {gprun.i ""rcpkb01.p""}

/****************************** SS - Micho 20060320 B *************************/
        VIEW FRAME v_page.
/****************************** SS - Micho 20060320 E *************************/

   /*B781*/ page.
     end.                                                   /*GI32*/

     /*    ELSE, THIS ISN'T A SCHEDULED ORDER, DO */

     else do:                                               /*GI32*/
        oktouse = no.
        partial_ok = yes.
   /*F444*/ pack_list_exists = no.
   /*F504*/ picked_site = "MoreThan8".

/*H0ZF**  REMOVING CHECK ON sod_due_date AND sod_site AND ADDING THESE */
/*H0ZF**  CHECKS WITHIN FOR EACH sod_det TO INCLUDE ALL SALES ORDER LINES */
/*H0ZF**  FOR SETTING THE partial_ok FLAG */

/*H0ZF** BEGIN DELETE **
 *      for each sod_det where (sod_nbr = so_nbr)
 *                 and (sod_due_date >= due_date or due_date = ?)
 *                 and (sod_due_date <= due_date1 or due_date1 = ?)
 *                 and (sod_site >= site or site = "")
 *                 and (sod_site <= site1 or site1 = "")
 * /*K022*/                    and sod_btb_type = "01"
 * /*G383*/                    and not sod_sched
 * /*F504*/                    and sod_confirm no-lock by sod_site
 *                 by sod_qty_pick:
 *H0ZF** END DELETE */
   /*F504*                   no-lock: */

/*M0RG*/    for first sod_det
/*M0RG*/       fields (sod_btb_type sod_confirm sod_curr_rlse_id sod_due_date
/*M0RG*/               sod_line sod_nbr sod_pickdate sod_qty_all sod_qty_ord
/*M0RG*/               sod_qty_pick sod_qty_ship sod_rma_type sod_sched
/*M0RG*/               sod_site)
/*M0RG*/       where  sod_nbr      = so_nbr    and
/*M0RG*/            ((sod_btb_type = "02"      and
/*M0RG*/       not   (so_fsm_type  = "SEO":U)) or
/*M0RG*/              sod_btb_type = "03")  no-lock:
/*M0RG*/    end. /* FOR FIRST SOD_DET */
/*M0RG*/    if available sod_det then
/*M0RG*/       next so_mstr_loop.

/*H0ZF*/    for each sod_det where (sod_nbr = so_nbr)
/*N05D** /*H0ZF*/              and sod_btb_type = "01"  */
/*H0ZF*/                       and not sod_sched
/*H0ZF*/                       and sod_confirm no-lock by sod_site
/*H0ZF*/               by sod_qty_pick:

/*N05D*/    /* WE ONLY WANT TO PRINT A PACKING LIST FOR SALES ORDER LINES */
/*N05D*/    /* THAT HAVE AN EMT TYPE OF NON-EMT ("01") OR MATERIAL ORDER  */
/*N05D*/    /* LINES (so_fsm_type = "SEO") THAT ARE EITHER NON-EMT OR     */
/*N05D*/    /* TRANSHIP ("02"). SALES ORDERS MUST USE PRE-SHIPPERS AND/OR */
/*N05D*/    /* SHIPPERS TO CREATE PACKING LISTS AND SHIPPING DOCUMENTS.   */
/*N05D*/    /* MATERIAL ORDERS CANNOT USE PRE-SHIPPERS OR SHIPPERS, SO    */
/*N05D*/    /* PACKING LISTS MUST BE AVAILABLE TO MATERIAL ORDERS         */
/*N05D*/    /* REGARDLESS IF THE MATERIAL ORDER LINE IS AN EMT LINE.      */
/*N05D*/    /* NOTE: MATERIAL ORDERS DO NOT USE DIRECT SHIPMENTS ("03").  */

/*N05D*/    if sod_btb_type = "01" or
/*N05D*/      (sod_btb_type = "02" and so_fsm_type = "SEO":U) then do:

/*G0YX*/    if sod_qty_ord > 0 and (sod_qty_ord - sod_qty_ship) < 0 then next.
/*G0YX*/    if sod_qty_ord < 0 and (sod_qty_ord - sod_qty_ship) > 0 then next.

/*J347*/    if sod_rma_type = "I" then
/*J347*/       next.
/*F504*/    if sod_qty_pick <> 0 then picked_site = sod_site.

/*H0ZF** BEGIN DELETE **
 *         if oktouse = no and (sod_qty_all > 0 or  (not all_only and
 *         sod_qty_ord - sod_qty_pick - sod_qty_ship > 0))
 *         or (print_neg and (sod_qty_all < 0 or (not all_only and
 *         sod_qty_ord - sod_qty_pick - sod_qty_ship < 0)))
 *         then oktouse = yes.
 *H0ZF** END DELETE */

/*H0ZF*/       if oktouse = no    and
/*H0ZF*/       ((sod_qty_all > 0  or
/*H0ZF*/        (not all_only     and
/*H0ZF*/     sod_qty_ord - sod_qty_pick - sod_qty_ship > 0))   or
/*H0ZF*/    (print_neg        and
/*H0ZF*/    (sod_qty_all < 0  or
/*H0ZF*/    (not all_only     and
/*H0ZF*/         sod_qty_ord - sod_qty_pick - sod_qty_ship < 0)))) and
/*H0ZF*/    (sod_due_date >= due_date  or due_date  = ?)       and
/*H0ZF*/    (sod_due_date <= due_date1 or due_date1 = ?)       and
/*H0ZF*/    (sod_site     >= site      or site      = "")      and
/*H0ZF*/    (sod_site     <= site1     or site1     = "")
/*H0ZF*/        then oktouse = yes.

            if so_partial = yes or include_partial = yes then
               partial_ok = yes.

/*H0ZF** BEGIN DELETE **
 *         if so_partial = no and include_partial = no and
 *         ( (sod_qty_ord > 0 and
 *         sod_qty_all < sod_qty_ord - sod_qty_pick - sod_qty_ship)
 *      or (sod_qty_ord < 0 and
 *         sod_qty_all > sod_qty_ord - sod_qty_pick - sod_qty_ship))
 *         then partial_ok = no.
 *H0ZF** END DELETE */

/*J347*/    /* IF SO ENTRY IS CREATED THROUGH A RMA THEN THE BELOW LOGIC */
/*J347*/    /* CHECKS IF THE PACKING LIST SHOULD  BE PRINTED OR NOT.     */
/*J347*/    /* IT FIRST CHECKS IF RMA LINE BEING SHIPPED IS LINKED. I.E. */
/*J347*/    /* IF THE RECEIPT LINE IS LINKED TO THE ISSUE LINE. IF LINKED*/
/*J347*/    /* THEN THE SHIP BEFORE FLAG IS CHECKED. IF THE FLAG IS  NO  */
/*J347*/    /* THEN IT CHECKS IF THE QTY RECEIVED ON THE RECEIPT LINE IS */
/*J347*/    /* LESS THAN THE QTY ALLOCATED + SHIPPED FOR THE ISSUE LINE  */
/*J347*/    /* IF TRUE THEN THE PICKLIST IS NOT PRINTED                  */

/*J347*/    if so_fsm_type = "RMA" then do:
/*J347*/       for first rmd_det
/*J347*/          fields(rmd_line rmd_link rmd_nbr rmd_prefix rmd_qty_acp)
/*J347*/          where rmd_det.rmd_nbr    = sod_nbr
/*J347*/            and rmd_det.rmd_prefix = "C"
/*J347*/            and rmd_det.rmd_line   = sod_line
/*J347*/          no-lock:
/*J347*/       end. /* END OF FOR FIRST RMD_DET */

/*J347*/       if available rmd_det and rmd_det.rmd_link <> 0 then
/*J347*/          for first rma_mstr
/*J347*/             fields( rma_ctype rma_nbr rma_prefix)
/*J347*/             where rma_nbr    = sod_nbr
/*J347*/               and rma_prefix = "C"
/*J347*/             no-lock:
/*J347*/          end. /* END OF FOR FIRST RMA_MSTR */

/*J347*/       if available rma_mstr then
/*J347*/          for first sv_mstr
/*J347*/             fields(sv_code sv_shp_b4rtn sv_type)
/*J347*/             where sv_code = rma_ctype
/*J347*/               and sv_type = ""
/*J347*/             no-lock:
/*J347*/          end. /* END OF FOR FIRST SV_MSTR */

/*J347*/       if available sv_mstr and not sv_shp_b4rtn then
/*J347*/          for first rmdreceipt
/*J347*/             fields(rmd_line rmd_link rmd_nbr
/*J347*/                    rmd_prefix rmd_qty_acp)
/*J347*/             where rmdreceipt.rmd_nbr    = sod_nbr
/*J347*/               and rmdreceipt.rmd_prefix = "C"
/*J347*/               and rmdreceipt.rmd_line   = rmd_det.rmd_link
/*J347*/             no-lock:
/*J347*/          end. /* END OF FOR FIRST RMDRECEIPT */

/*J347*/       if available rmdreceipt
/*J347*/          and rmdreceipt.rmd_qty_acp <
/*J347*/              (sod_qty_all + sod_qty_ship) then
/*J347*/          partial_ok = no.
/*J347*/    end. /* END OF IF SO_FSM_TYPE = "RMA" */

/*H0ZF*/       if so_partial = no and include_partial = no and
/*H0ZF*/       (((sod_qty_ord  > 0 and
/*H0ZF*/          sod_qty_all  < sod_qty_ord - sod_qty_pick - sod_qty_ship)  or
/*H0ZF*/         (sod_qty_ord  < 0 and
/*H0ZF*/          sod_qty_all  > sod_qty_ord - sod_qty_pick - sod_qty_ship)) or
/*H0ZF*/         (sod_due_date < due_date  or
/*H0ZF*/          sod_due_date > due_date1 or
/*H0ZF*/          sod_site     < site      or
/*H0ZF*/          sod_site     > site1))
/*H0ZF*/        then partial_ok = no.

/*H0ZF*/       if not partial_ok then leave.

   /*F504*     if oktouse and                                                 */
   /*F504*     (so_partial = yes or include_partial = yes or partial_ok = no) */
   /*F504*     then leave.                                                    */

/*J2DK*/       if sod_due_date < due_date  or
/*J2DK*/          sod_due_date > due_date1 or
/*J2DK*/          sod_site     < site      or
/*J2DK*/          sod_site     > site1
/*J2DK*/       then next.


   /*F504*/    if sod_site = picked_site and oktouse then do:
   /*F504*     if sod_qty_pick <> 0 then do: */
   /*F444*/       if nbr = nbr1 then
             pack_list_exists = yes. /* specific S.Order */

   /*F444*/       oktouse = no. leave. /* disallow 2 pack lists at a site. */
   /*F444*/    end.

/*H1P0*/       /* DO LOOP ADDED TO SKIP LOCKED SO_MSTR RECORDS */

/*N01B*/       /* TRANSACTION IS ALREADY STARTED AT FOR EACH SO_MSTR LOOP*/
/*N01B** /*H1P0*/       do for somstr transaction: */
/*N01B*/       do for somstr :
/*H1P0*/          find somstr where so_recno = recid(somstr)
/*H1P0*/          exclusive-lock no-wait no-error.
/*H1P0*/          if (available somstr and not locked somstr) then
/*H1P0*/             l_so_printpl = yes.
/*H1P0*/          else
/*H1P0*/             l_so_printpl = no.
/*H1P0*/       end. /* DO FOR SOMSTR */
/*H1P0*/       if l_so_printpl = no then
/*H1P0*/          next so_mstr_loop.

/*N05D*/   end. /* IF sod_btb_type = "01" or (sod_btb_type = "02" ....) */

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
/****************************** SS - Micho 20060320 B *************************/
/*            addr[1] = ad_name.                         */
/*            addr[2] = ad_line1.                        */
/*            addr[3] = ad_line2.                        */
/*            addr[4] = ad_line3.                        */
/*            addr[6] = ad_country.                      */
/*            {mfcsz.i addr[5] ad_city ad_state ad_zip}. */
/*            {gprun.i ""gpaddr.p"" }                    */
/*            billto[1] = addr[1].                       */
/*            billto[2] = addr[2].                       */
/*            billto[3] = addr[3].                       */
/*            billto[4] = addr[4].                       */
/*            billto[5] = addr[5].                       */
/*            billto[6] = addr[6].                       */
              
              addr[1] = ad_name.
              addr[2] = ad_line1 + " " + ad_Line2 + " " + ad_line3 .
              addr[3] = ad_state.
              addr[4] = ad_city.
              addr[6] = ad_country.

              billto[1] = addr[1].                       
              billto[2] = addr[2].                       
              billto[3] = addr[3].                       
              billto[4] = addr[4].                       
              billto[5] = addr[5].                       
              billto[6] = addr[6].                                              
/****************************** SS - Micho 20060320 E *************************/
        end.

/*J15B*     ADDED THE FOLLOWING */
            /* FOR SEO'S (SERVICE ENGINEER ORDERS) BEING SHIPPED TO THE
                ENGINEER INSTEAD OF TO A SERVICE CALL'S CUSTOMER, PRINT THE
                ENGINEER'S ADDRESS (FROM HIS EMPLOYEE ADDRESS) AS THE SHIP-TO */
            if so_fsm_type = "SEO" and so_eng_code = so_ship then do:
                find eng_mstr where eng_code = so_ship no-lock no-error.
                if available eng_mstr then do:
/*J1WT*             eng_address = eng__qadc01.  */
                    find ad_mstr where ad_addr = eng_address no-lock no-error.
                end.    /* if available eng_mstr */
            end.
            else
/*J15B*     END ADDED CODE */
           find ad_mstr where ad_addr = so_ship no-lock no-error.
        if available ad_mstr then do:
/****************************** SS - Micho 20060320 B *************************/
/*            addr[1] = ad_name.                         */
/*            addr[2] = ad_line1.                        */
/*            addr[3] = ad_line2.                        */
/*            addr[4] = ad_line3.                        */
/*            addr[6] = ad_country.                      */
/*            {mfcsz.i addr[5] ad_city ad_state ad_zip}. */
/*            {gprun.i ""gpaddr.p"" }                    */
/*            shipto[1] = addr[1].                       */
/*            shipto[2] = addr[2].                       */
/*            shipto[3] = addr[3].                       */
/*            shipto[4] = addr[4].                       */
/*            shipto[5] = addr[5].                       */
/*            shipto[6] = addr[6].                       */

           addr[1] = ad_name.
           addr[2] = ad_line1 + " " + ad_line2 + " " + ad_line3 .
           addr[3] = ad_state .
           addr[4] = ad_city .
           addr[6] = ad_country.

           shipto[1] = addr[1].
           shipto[2] = addr[2].
           shipto[3] = addr[3].
           shipto[4] = addr[4].
           shipto[5] = addr[5].
           shipto[6] = addr[6].
/****************************** SS - Micho 20060320 E *************************/
        end.
        view frame phead1.

        pages = page-number - 1.

/****************************** SS - Micho 20060320 B *************************/
/*
 *       display so_slspsn[1] so_slspsn[2]
 *  /*F322*/  so_slspsn[3] so_slspsn[4]
 *        so_po
 *        so_cr_terms so_shipvia so_fob termsdesc so_fob
 *        so_rmks with frame phead2.  */
/****************************** SS - Micho 20060320 E *************************/
 
        first_line = yes.

        {gprun.i ""xxsopkb01.p""}

/****************************** SS - Micho 20060320 add B *************************/
        VIEW FRAME v_page.
/****************************** SS - Micho 20060320 E *************************/
        page.
     end. /* ELSE DO */
      end. /* FOR EACH so_mstr */
