/* GUI CONVERTED from gppiwk02.p (converter v1.69) Thu Jun 27 09:45:21 1996 */
/* gppiwk02.p - Write pricing workfile to pih_hist                      */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 8.5      LAST MODIFIED: 02/21/95   BY: afs *J042*          */
/* REVISION: 8.5      LAST MODIFIED: 07/07/95   BY: DAH *J05C*          */
/* REVISION: 8.5      LAST MODIFIED: 07/28/95   BY: DAH *J063*          */
/* REVISION: 8.5      LAST MODIFIED: 09/11/95   BY: DAH *J07S*          */
/* REVISION: 8.5      LAST MODIFIED: 06/07/96   BY: DAH *J0RG*          */
/* REVISION: 8.5      LAST MODIFIED: 11/14/03   BY: *LB01* Long Bo         */

/* This routine creates pih_hist records for a sales order line based
   on the current entries in the pricing workfile.

   This routine will delete any existing price list history.


   INPUTS:

   Price List workfile
   doc type (1 = so
             2 = qo
             3 = po
             4 = fsm thingie)
   order number
   line number
   acct, cc, proj info for manual lines
   delete line flag (0 to delete all previous system-generated pih_hists;
                     1 to skip deletes)

   OUTPUT:

   No returned variables.
   pih_hist records are created.
   wkpi_wkfl records are deleted.

   A TYPICAL CALL:

      {gprun.i ""gppiwk02.p"" "(1,
                                so_nbr,
                                so_line,
                                sod_acct,
                                sod_cc,
                                sod_project
                                )" }


*/

         {mfdeclre.i}

         define input        parameter doc_type        like pih_doc_type.
         define input        parameter ord_nbr         like pih_nbr.
         define input        parameter line_nbr        like pih_line.
         define input        parameter acct            like pih_disc_acct.
         define input        parameter cost_ctr        like pih_disc_cc.
         define input        parameter project         like pih_disc_proj.

         define            variable calc_seq        like pih_disc_seq.
         define            variable count_seq       as integer.
         define            variable jk              as integer.
         define            variable list_price      as decimal.
/*       define            variable round_fact      like pic_so_rfact.  */
         define            variable seq_factor      as decimal.
         define            variable seq_disc        like pih_amt.
/*J0RG*/ define            variable tot_accr_yes    as decimal.
/*J0RG*/ define            variable tot_accr_no     as decimal.
/*J0RG*/ define            variable accum_sob_price like sob_price.
/*J0RG*/ define            variable sonbr           like sob_nbr.
/*J0RG*/ define            variable found_accr_no   like mfc_logical.
/*J0RG*/ define            variable confg_disc      like mfc_logical.

         {pppiwkpi.i}  /* Shared workfile for Price Lists used */
         {pppivar.i}   /* Shared variables for pricing logic */

         find first pic_ctrl no-lock.

         /********
         if      doc_type = 1 then assign round_fact = pic_so_rfact.
         else if doc_type = 2 then assign round_fact = pic_qo_rfact.
         else if doc_type = 3 then assign round_fact = pic_po_rfact.
         else if doc_type = 4 then assign round_fact = pic_fs_rfact.
         ************/


         /* Delete existing system-generated history */
         for each pih_hist where pih_doc_type =  doc_type
                             and pih_nbr      =  ord_nbr
                             and pih_line     =  line_nbr
                             and pih_source   <> "1"
                           exclusive-LOCK:
            delete pih_hist.
         end.

/*J0RG*/ /*Select the best set of accruals, deleting the others.*/
/*J0RG*/ /*Process the parent item (if configured) last, thus   */
/*J0RG*/ /*allowing the determination of the net price of the   */
/*J0RG*/ /*parent when the accrual is for the current level only*/
/*J0RG*/ /*(wkpi_confg_disc = no).  This is different from how  */
/*J0RG*/ /*accruals processed before where regardless of level  */
/*J0RG*/ /*they were calculated based on the end item's rolled  */
/*J0RG*/ /*up best net price.                                   */

/*J0RG*/ for each wkpi_wkfl where wkpi_amt_type = "8" no-lock
/*J0RG*/                    by wkpi_option descending:

/*J0RG*/    if wkpi_option <> "" then do:

/*J0RG*/       if doc_type = 1 then
/*J0RG*/          sonbr = ord_nbr.
/*J0RG*/       else
/*J0RG*/          sonbr = "qod_det" + ord_nbr.
/*J0RG*/       find sob_det where sob_nbr     = sonbr
/*J0RG*/                      and sob_line    = line_nbr
/*J0RG*/                      and sob_parent  = wkpi_parent
/*J0RG*/                      and sob_feature = wkpi_feature
/*J0RG*/                      and sob_part    = wkpi_option
/*J0RG*/                    no-lock no-error.
/*J0RG*/       if available sob_det then
/*J0RG*/          accum_sob_price = accum_sob_price + sob_price.

/*J0RG*/       if not wkpi_confg_disc and available sob_det then do:
/*J0RG*/          wkpi_disc_amt = sob_price * (1 - wkpi_factor).
/*J0RG*/          tot_accr_no   = tot_accr_no + wkpi_disc_amt.
/*J0RG*/          found_accr_no = yes.
/*J0RG*/       end.

/*J0RG*/       if wkpi_confg_disc then do:
/*J0RG*/          wkpi_disc_amt = best_net_price * (1 - wkpi_factor).
/*J0RG*/          tot_accr_yes  = tot_accr_yes + wkpi_disc_amt.
/*J0RG*/       end.

/*J0RG*/    end.
/*J0RG*/    else do:

/*J0RG*/       if wkpi_confg_disc then do:
/*J0RG*/          wkpi_disc_amt = best_net_price * (1 - wkpi_factor).
/*J0RG*/          tot_accr_yes  = tot_accr_yes + wkpi_disc_amt.
/*J0RG*/       end.
/*J0RG*/       else do:
/*J0RG*/          wkpi_disc_amt = (best_net_price - accum_sob_price) *
/*J0RG*/                          (1 - wkpi_factor).
/*J0RG*/          tot_accr_no   = tot_accr_no + wkpi_disc_amt.
/*J0RG*/          found_accr_no = yes.
/*J0RG*/       end.

/*J0RG*/    end. /* if wkpi_option <> "" */

/*J0RG*/ end. /* for each wkpi_wkfl */

/*J0RG*/ if found_accr_no then do:

/*J0RG*/    if tot_accr_no > tot_accr_yes then
/*J0RG*/       confg_disc = yes.
/*J0RG*/    else
/*J0RG*/       confg_disc = no.

/*J0RG*/    for each wkpi_wkfl where wkpi_amt_type   = "8"
/*J0RG*/                         and wkpi_confg_disc = confg_disc
/*J0RG*/                       exclusive-lock:
/*J0RG*/       delete wkpi_wkfl.
/*J0RG*/    end.

/*J0RG*/ end.

/*J05C** Determine how to perform the discount amount calculation, if
**J05C** configured item and discount records found and confg_disc = no,
**J05C** calculate discounts for each level of configuration "gppiwk2b.p"
**J05C** else calculate discounts across the entire configuration "gppiwk2a.p"
**J05C** note: if not configured item confg_disc is always yes.  **/

/*J05C*/ find first wkpi_wkfl where lookup(wkpi_amt_type, "2,3,4,9") <> 0
/*J05C*/                        and wkpi_source <> "1"
/*J05C*/                        and not wkpi_confg_disc no-lock no-error.
/*J05C*/ if not available wkpi_wkfl then do:
/*LB01*/     {gprun.i ""zzgppiwk2a.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.
         else do:
            {gprun.i ""gppiwk2b.p"" "(
                                      doc_type,
                                      ord_nbr,
                                      line_nbr
                                     )"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.

         /* Write history from workfile */
         for each wkpi_wkfl exclusive-lock:

            /* If this is a new terms field, delete any existing */
            /* terms set for the order by pricing.               */
            if lookup(wkpi_amt_type, "5,6") <> 0 then do:
               find first pih_hist where pih_doc_type   = doc_type
                                     and pih_nbr        = ord_nbr
                                     and pih_amt_type   = wkpi_amt_type
                                   exclusive-lock no-error.
               if available pih_hist then delete pih_hist.
            end.

            if wkpi_source = "0" then
               find pi_mstr where pi_list_id = wkpi_list_id no-lock.
            else do:
               /* For manual history, find old to see if it has changed */
               find pih_hist where pih_doc_type   = doc_type
                               and pih_nbr        = ord_nbr
                               and pih_line       = line_nbr
                               and pih_parent     = wkpi_parent
                               and pih_feature    = wkpi_feature
                               and pih_option     = wkpi_option
                               and pih_list_id    = wkpi_list_id
                               and pih_amt_type   = wkpi_amt_type
                               and pih_confg_disc = wkpi_confg_disc
                             exclusive-lock no-error.
               if available pih_hist and (pih_amt <> wkpi_amt or
/*J07S*/                                  pih_disc_amt <> wkpi_disc_amt) then
                  delete pih_hist.
            end.

            if wkpi_source = "0" or
               not available pih_hist then do:

               create pih_hist.
               assign
                  pih_amt        = wkpi_amt
                  pih_amt_type   = wkpi_amt_type
                  pih_break_cat  = wkpi_break_cat
                  pih_comb_type  = wkpi_comb_type
                  pih_confg_disc = wkpi_confg_disc
                  pih_disc_amt   = wkpi_disc_amt
                  pih_disc_seq   = wkpi_disc_seq
                  pih_doc_type   = doc_type
                  pih_feature    = wkpi_feature
                  pih_line       = line_nbr
                  pih_list       = wkpi_list
                  pih_list_id    = wkpi_list_id
                  pih_nbr        = ord_nbr
                  pih_option     = wkpi_option
                  pih_parent     = wkpi_parent
                  pih_pid_qty    = wkpi_pid_qty
                  pih_qty        = wkpi_qty
                  pih_source     = wkpi_source
                  pih_um         = wkpi_um
/*J063*/          pih_userid     = global_userid
                  pih_mod_date   = today
                  pih_time       = time
                  .

               /* Assign defaults from Price list if available */
               if available pi_mstr then assign
                  pih_accr_acct = pi_accr_acct
                  pih_accr_cc   = pi_accr_cc
                  pih_accr_proj = pi_accr_proj
                  pih_disc_acct = pi_disc_acct
                  pih_disc_cc   = pi_disc_cc
                  pih_disc_proj = pi_disc_proj
                  pih_min_net   = pi_min_net
                  pih_print     = pi_print
                  pih_qty_type  = pi_qty_type
                  .
               else
                  if pih_source = "1" then pih_print = true.


               /* Assign acctng info if no Price List or List accts not set */
               if pih_disc_acct = "" then pih_disc_acct = acct.
               if pih_disc_cc   = "" then pih_disc_cc   = cost_ctr.
               if pih_disc_proj = "" then pih_disc_proj = project.

            end.

            delete wkpi_wkfl.

         end.
