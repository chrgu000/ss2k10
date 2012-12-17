/* soivpstb.p - SALES ORDER LINE INVOICE POST                                */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.29.3.1 $                                                              */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 1.0      LAST MODIFIED: 06/18/86   BY: PML                      */
/* REVISION: 6.0      LAST MODIFIED: 06/08/90   BY: MLB *D038*               */
/* REVISION: 6.0      LAST MODIFIED: 08/17/90   BY: MLB *D055*               */
/* REVISION: 6.0      LAST MODIFIED: 10/19/90   BY: MLB *D110*               */
/* REVISION: 6.0      LAST MODIFIED: 12/23/90   BY: MLB *D238*               */
/* REVISION: 6.0      LAST MODIFIED: 12/06/90   BY: afs *D279*               */
/* REVISION: 6.0      LAST MODIFIED: 02/15/91   BY: MLB *D352*               */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: afs *D387*               */
/* REVISION: 6.0      LAST MODIFIED: 08/12/91   BY: afs *D824*               */
/* REVISION: 7.0      LAST MODIFIED: 04/17/92   BY: afs *F411*               */
/* REVISION: 7.3      LAST MODIFIED: 05/06/93   BY: WUG *GA71*               */
/* REVISION: 7.3      LAST MODIFIED: 06/16/93   BY: dpm *GC09*               */
/* REVISION: 7.3      LAST MODIFIED: 05/03/94   BY: dpm *FN83*               */
/* REVISION: 7.3      LAST MODIFIED: 09/02/94   by: pmf *FQ75*               */
/* REVISION: 7.3      LAST MODIFIED: 03/13/95   BY: jxz *F0M3*               */
/* REVISION: 8.5      LAST MODIFIED: 03/02/95   BY: tjm *J042*               */
/* REVISION: 8.5      LAST MODIFIED: 07/17/95   BY: DAH *J05M*               */
/* REVISION: 8.5      LAST MODIFIED: 11/21/95   BY: mys *G1DX*               */
/* REVISION: 8.5      LAST MODIFIED: 07/25/95   BY: taf *J053*               */
/* REVISION: 8.5      LAST MODIFIED: 05/23/96   BY: jzw *H0L6*               */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: dxk *G1YS*               */
/* REVISION: 8.5      LAST MODIFIED: 07/31/96   BY: *J177* Sue Poland        */
/* REVISION: 8.6      LAST MODIFIED: 11/25/96   BY: *K01X* jzw               */
/* REVISION: 8.6      LAST MODIFIED: 02/28/97   BY: *K06N* E. Hughart        */
/* REVISION: 8.6      LAST MODIFIED: 06/10/97   BY: *K0D4* Jeff Wootton      */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* REVISION: 8.6E     LAST MODIFIED: 06/24/98   BY: *J2NH* Dana Tunstall     */
/* REVISION: 8.6E     LAST MODIFIED: 07/06/98   BY: *L024* Sami Kureishy     */
/* REVISION: 9.0      LAST MODIFIED: 09/30/98   BY: *J2CZ* Reetu Kapoor      */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari   */
/* REVISION: 9.1      LAST MODIFIED: 10/07/99   BY: *J3L7* Satish Chavan     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.28       BY: Katie Hilbert         DATE: 04/01/01 ECO: *P002* */
/* Revision: 1.29       BY: Deepali Kotavadekar   DATE: 12/18/02 ECO: *N21T* */
/* $Revision: 1.29.3.1 $         BY: Vivek Gogte           DATE: 06/16/03 ECO: *N2H2* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}

{gldydef.i}
{gldynrm.i}
{gprunpdf.i "mcpl" "p"}
DEFINE INPUT PARAMETER xxabsnbr  as character no-undo.
define shared variable rndmthd       like  rnd_rnd_mthd.
define shared variable sod_recno     as    recid.
define shared variable so_recno      as    recid.
define shared variable ext_price     like  sod_price.
define shared variable undo_all      like  mfc_logical no-undo.
define shared variable eff_date      like  ar_date.
define shared variable exch_rate     like  exr_rate.
define shared variable exch_rate2    like  exr_rate2.
define shared variable exch_ratetype like  exr_ratetype.
define shared variable exch_exru_seq like  exru_seq.
define shared variable base_price    like  ext_price.
define shared variable ext_disc      as    decimal.
define shared variable post_entity   like  ar_entity.

define variable sa_year           like  cph_year      no-undo.
define variable sa_bucket         as    integer       no-undo.
define variable pl                like  pt_prod_line  no-undo.
define variable line_entity       like  ar_entity     no-undo.
define variable extdscamt         as    decimal       no-undo.
define variable tmp_cost          as    decimal       no-undo.
define variable taxes_included    like  ar_amt        no-undo.
define variable last_disc_amt     like  pih_disc_amt  no-undo.
define variable mc-error-number   like  msg_nbr       no-undo.
define variable account_code      like  ac_code       no-undo.
/* {sssoivp1.i} */
do transaction on error undo, leave:

   for first gl_ctrl
      fields(gl_rnd_mthd)
      no-lock:
   end. /* FOR FIRST gl_ctrl */

   for first soc_ctrl
      fields(soc_ar soc_fysm soc_sa)
      no-lock:
   end. /* FOR FIRST soc_ctrl */

   for first sod_det 
      fields(sod_acct        sod_cc   sod_dsc_acct sod_dsc_cc
             sod_line        sod_nbr  sod_sub      sod_dsc_sub
             sod_dsc_project sod_part sod_prodline sod_project
             sod_qty_inv     sod_site sod_std_cost sod_taxc
             sod_type        sod_um_conv)
     no-lock where recid(sod_det) = sod_recno 
       :
   end. /* FOR FIRST sod_det */

   for first so_mstr
      fields(so_curr    so_cust so_fsm_type
             so_inv_nbr so_nbr  so_sched
             so_ship    so_site so_slspsn)
      where recid(so_mstr) = so_recno
      no-lock :
   end. /* FOR FIRST so_mstr */

   /* IF FOR ANY REASON THE INVOICE NUMBER IS BLANK THEN LEAVE.              */
   /* THIS CAUSES undo_all TO BE SET TRUE AND THE SO POSTING IS ROLLED BACK. */

   if so_inv_nbr = ""
   then
      undo, leave.

   /* GET THE POSTING ENTITY BASED ON THE SALES ORDER LINE SITE */
   if sod_site <> so_site
   then do:

      for first si_mstr
         fields(si_entity si_site)
         where si_site = sod_site
         no-lock :
      end. /* FOR FIRST si_mstr */

      if available si_mstr
      then
         line_entity = si_entity.
      else
         line_entity = glentity.
   end. /* IF sod_site <> so_site */
   else
      line_entity = post_entity.

   /* ACCUMULATE ANY GTM INCLUDED TAX */
   if (soc_ar   = yes
      or soc_sa = yes)
   then do:
      taxes_included = 0.

      for each tx2d_det
         fields (tx2d_cur_tax_amt tx2d_line    tx2d_nbr
                 tx2d_ref         tx2d_tax_in  tx2d_tr_type)
         where tx2d_ref     = so_inv_nbr
         and   tx2d_nbr     = so_nbr
         and   tx2d_tr_type = "16"
         and   tx2d_line    = sod_line
/*121213.1 */ and can-find(first xxabs_mstr NO-LOCK where tx2d_ref = xxabsnbr and tx2d_nbr = xxabs_order AND tx2d_line = integer(xxabs_line))
         no-lock:

            /* TAX INCLUDED = YES */
            if tx2d_tax_in
            then
               taxes_included = taxes_included + tx2d_cur_tax_amt.

      end. /* FOR EACH tx2d_det */
   end. /* IF (soc_ar = yes OR soc_sa = yes) */

   /* CREATE AR RECORDS */
   if soc_ar = yes
   then do:
      if (ext_price + ext_disc) <> 0
      then do:
         find first ard_det
            where ard_acct   = sod_acct
            and   ard_sub    = sod_sub
            and   ard_cc     = sod_cc
            and   ard_nbr    = so_inv_nbr
            and   ard_entity = line_entity
            and   ard_tax_at = (if sod_taxable
                               then
                                  "yes"
                               else
                                  "no")
            exclusive-lock
            no-error.

         if not available ard_det
         then do:
            create ard_det.
            assign
               ard_nbr      = so_inv_nbr
               ard_entity   = line_entity
               ard_acct     = sod_acct
               ard_sub      = sod_sub
               ard_cc       = sod_cc
               ard_project  = sod_project
               account_code = ard_acct.

            for first ac_mstr
               fields(ac_code ac_desc)
               where ac_code = account_code
               no-lock:
            end. /* FOR FIRST ac_mstr */

            if available ac_mstr
            then
               ard_desc = ac_desc.
               assign
                  account_code = ""
                  ard_tax_at   = if sod_taxable
                                 then
                                    "yes"
                                 else
                                    "no"
                  ard_taxc     = sod_taxc.

            if recid(ard_det) = -1 then .

         end. /* IF NOT AVAILABLE ard_det */

         assign
            ard_amt     = ard_amt + ext_price + ext_disc
            ard_dy_code = dft-daybook
            ard_dy_num  = nrm-seq-num.
      end. /* IF (ext_price + ext_disc) <> 0 */

      /* CREATE TAX ADJUSTMENT RECORDS */
      if taxes_included <> 0
      then do:

         find first ard_det
            where ard_nbr       = so_inv_nbr
            and   ard_acct      = sod_acct
            and   ard_sub       = sod_sub
            and   ard_cc        = sod_cc
            and   ard_entity    = line_entity
            and   ard_tax_at    = "no"
            and   ard_tax       = "ti"
            exclusive-lock
            no-error.

         if not available ard_det
         then do:
            create ard_det.
            assign
               ard_nbr     = so_inv_nbr
               ard_entity  = line_entity
               ard_acct    = sod_acct
               ard_sub     = sod_sub
               ard_cc      = sod_cc
               ard_project = sod_project
               ard_tax_at  = "no"
               ard_tax     = "ti"
               ard_taxc    = sod_taxc.


            for first ac_mstr
               fields (ac_code ac_desc)
               where ac_code = ard_acct
               no-lock:
               ard_desc = ac_desc.
            end. /* FOR FIRST ac_mstr */

            if recid(ard_det) = -1 then .

         end. /* IF NOT AVAILABLE ard_det */

         assign
            ard_dy_code = dft-daybook
            ard_dy_num  = nrm-seq-num
            ard_amt     = ard_amt - taxes_included.
      end. /* IF taxes_included <> 0 */

      /* CREATE ard_det FOR THE DISCOUNTED AMOUNT */

      /* CONSIDERING PRICE LIST RECORDS (pih_hist) INDIVIDUALLY */
      /* FOR CREATION OF AR RECORDS INSTEAD OF OVERALL DISCOUNT */
      /* ext_disc                                               */
      if not so_sched
         and so_fsm_type = ""
      then do:

         /* DISCOUNT SOURCE IS FROM pih_hist */
         last_disc_amt   = ext_disc.

         /* POST MULTIPLE DISCOUNTS */
         for each pih_hist
            fields (pih_amt_type  pih_disc_acct pih_disc_amt
                    pih_disc_sub  pih_disc_cc   pih_disc_proj
                    pih_doc_type  pih_line      pih_nbr)
            where pih_doc_type = 1
            and   pih_nbr      = sod_nbr
            and   pih_line     = sod_line
            and   pih_disc_amt <> 0
            and   lookup(pih_amt_type, "2,3,4,9") <> 0
            no-lock
            break by pih_disc_acct by pih_disc_sub
                  by pih_disc_cc   by pih_disc_proj:

            accumulate pih_disc_amt (total by pih_disc_proj).

            if last-of(pih_disc_proj)
            then do:
               if not last(pih_disc_proj)
               then do:
                     extdscamt = sod_qty_inv * accum total by
                                 pih_disc_proj
                                 (pih_disc_amt).

                     /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
                     {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output extdscamt,
                          input        rndmthd,
                          output       mc-error-number)"}

                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end. /* IF mc-error-number <> 0 */

                     last_disc_amt = last_disc_amt - extdscamt.

               end. /* IF NOT LAST(pih_disc_proj) */
               else do:

                  /* LAST RECORD WILL RESOLVE ANY VARIANCE DUE TO */
                  /* ROUNDING, BY USING THE REMAINING DISCOUNT */
                  /* TO POST (last_disc_amt).                  */
                  extdscamt = last_disc_amt.

               end. /* ELSE OF IF NOT LAST(pih_disc_proj) */

               /* CREATING AR RECORD ONLY IF extdscamt <> 0 */
               if extdscamt <> 0
               then do:

                  find first ard_det
                     where ard_acct    = pih_disc_acct
                     and   ard_sub     = pih_disc_sub
                     and   ard_cc      = pih_disc_cc
                     and   ard_nbr     = so_inv_nbr
                     and   ard_entity  = line_entity
                     and   ard_tax_at  = if sod_taxable
                                         then
                                            "yes"
                                         else
                                            "no"
                     exclusive-lock
                     no-error.

                  if not available ard_det
                  then do:
                     create ard_det.
                     assign
                        ard_nbr      = so_inv_nbr
                        ard_entity   = line_entity
                        ard_acct     = pih_disc_acct
                        ard_sub      = pih_disc_sub
                        ard_cc       = pih_disc_cc
                        ard_project  = pih_disc_proj
                        account_code = ard_acct.

                     for first ac_mstr
                        fields(ac_code ac_desc)
                        where ac_code = account_code
                        no-lock:
                     end. /* FOR FIRST ac_mstr */

                     if available ac_mstr
                     then
                        ard_desc = ac_desc.
                     assign
                        account_code = ""
                        ard_tax_at   = if sod_taxable
                                       then
                                          "yes"
                                       else
                                          "no"
                        ard_taxc     = sod_taxc.

                     if recid(ard_det) = -1 then .

                  end. /* IF NOT AVAILABLE ard_det */

                  assign
                     ard_amt     = ard_amt - extdscamt
                     ard_dy_code = dft-daybook
                     ard_dy_num  = nrm-seq-num.

               end. /* IF extdscamt <> 0 */
            end. /* LAST-OF(pih_disc_proj) */
         end. /* FOR EACH pih_hist */
      end. /* IF NOT so_sched AND so_fsm_type = "" */

      /* DISCOUNT IS FROM sod_det */
      else do:

         /* CREATING AR RECORD ONLY IF ext_disc <> 0 */
         if ext_disc <> 0
         then do:

            find first ard_det
               where ard_acct  = sod_dsc_acct
               and ard_sub     = sod_dsc_sub
               and ard_cc      = sod_dsc_cc
               and ard_nbr     = so_inv_nbr
               and ard_entity  = line_entity
               and ard_tax_at  = (if sod_taxable
                                 then
                                    "yes"
                                 else
                                    "no")
               exclusive-lock
               no-error.

            if not available ard_det
            then do:
               create ard_det.
               assign
                  ard_nbr      = so_inv_nbr
                  ard_entity   = line_entity
                  ard_acct     = sod_dsc_acct
                  ard_sub      = sod_dsc_sub
                  ard_cc       = sod_dsc_cc
                  ard_project  = sod_dsc_project
                  account_code = ard_acct.

               for first ac_mstr
                  fields(ac_code ac_desc)
                  where ac_code = account_code
                  no-lock :
               end. /* FOR FIRST ac_mstr */

               if available ac_mstr
               then
                  ard_desc = ac_desc.

               assign
                  account_code = ""
                  ard_tax_at   = if sod_taxable
                                 then
                                    "yes"
                                 else
                                    "no"
                  ard_taxc     = sod_taxc.

               if recid(ard_det) = -1 then .

            end. /* IF NOT AVAILABLE ard_det */

            assign
               ard_amt     = ard_amt - ext_disc
               ard_dy_code = dft-daybook
               ard_dy_num  = nrm-seq-num.

         end. /* IF ext_disc <> 0 */
      end. /* DISCOUNT FROM sod_det */

   end. /* soc_ar = yes */

   /* CREATE SALES ANALYSIS RECORDS */

   if soc_sa = yes
   then do:

      base_price = ext_price - taxes_included.

      if so_curr <> base_curr
      then do:

         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input  so_curr,
              input  base_curr,
              input  exch_rate,
              input  exch_rate2,
              input  base_price,
              input  true,
              output base_price,
              output mc-error-number)"}

         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end. /* IF mc-error-number <> 0 */
      end. /* IF so_curr <> base_curr */

      /* FIND THE YEAR AND BUCKET TO POST TO FOR THE FISCAL YEAR */
      if month(eff_date) >= soc_fysm
     and soc_fysm    >  1
      then
         sa_year = year(eff_date) + 1.
      else
         sa_year = year(eff_date).

      if soc_fysm = 1
      then
         sa_bucket = month(eff_date).
      else
         if soc_fysm > month(eff_date)
         then
            sa_bucket = 13 - soc_fysm + month(eff_date).
         else
            sa_bucket = month(eff_date) - soc_fysm + 1.

      /* POST TO CUSTOMER HISTORY */
      find cmh_hist
         where cmh_year = sa_year
         and   cmh_cust = so_cust
         exclusive-lock
         no-error.

      if not available cmh_hist
      then do:
         create cmh_hist.
         assign
            cmh_year = sa_year
            cmh_cust = so_cust.

         if recid(cmh_hist) = -1 then .
      end. /* IF NOT AVAILABLE cmh_hist */

      assign
         cmh_tot_sale = cmh_tot_sale + base_price
         tmp_cost     = sod_qty_inv  * sod_std_cost.

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output tmp_cost,
           input        gl_rnd_mthd,
           output       mc-error-number)"}

      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end. /* IF mc-error-number <> 0 */

      cmh_tot_cost = cmh_tot_cost + tmp_cost.

      /* POST TO PART HISTORY */
      find pth_hist
         where pth_year = sa_year
         and   pth_part = sod_part
         exclusive-lock
         no-error.

      if not available pth_hist
      then do:
         create pth_hist.
         assign
            pth_year = sa_year
            pth_part = sod_part.
         if recid(pth_hist) = -1 then .
      end. /* IF NOT AVAILABLE pth_hist */

      assign
         pth_tot_sale = pth_tot_sale + base_price
         pth_tot_cost = pth_tot_cost + tmp_cost
         pth_tot_qty  = pth_tot_qty  + (sod_qty_inv * sod_um_conv).

      /* POST TO CUSTOMER-PARTS HISTORY */

      /* FOR ORDERS NOT RELATED TO SERVICE (CONTRACTS, RMA'S, CALL
      INVOICES), THE PRODUCT LINE RECORDED IN THE CPH_HIST RECORD
      SHOULD BE THAT OF THE ITEM SOLD.  FOR SERVICE ORDERS, HOWEVER,
      CPH_HIST SHOULD BE CREATED USING THE PRODUCT LINE ON THE ORDER
      LINE. */
      if so_fsm_type = " "
      then do:
         pl = "".

         for first pt_mstr
            fields(pt_part pt_prod_line)
            where pt_part = sod_part
            no-lock :
         end. /* FOR FIRST pt_mstr */

         if available pt_mstr
         then
            pl = pt_prod_line.
      end. /* IF so_fsm_type = " " */
      else
         pl = sod_prodline.

      find cph_hist
         where cph_year   = sa_year
         and   cph_cust   = so_cust
         and   cph_ship   = so_ship
         and   cph_part   = sod_part
         and   cph_type   = sod_type
         and   cph_pl     = pl
         and   cph_site   = sod_site
         and   cph_smonth = soc_fysm
         exclusive-lock
         no-error.

      if not available cph_hist
      then do:
         create cph_hist.
         assign
            cph_year   = sa_year
            cph_cust   = so_cust
            cph_ship   = so_ship
            cph_part   = sod_part
            cph_type   = sod_type
            cph_pl     = pl
            cph_site   = sod_site
            cph_smonth = soc_fysm.
         if recid(cph_hist) = -1 then .
      end. /* IF NOT AVAILABLE cph_hist */

      assign
         cph_tot_sale         = cph_tot_sale         + base_price
         cph_tot_cost         = cph_tot_cost         + tmp_cost
         cph_tot_qty          = cph_tot_qty          +
                                (sod_qty_inv * sod_um_conv)
         cph_qty[sa_bucket]   = cph_qty[sa_bucket]   +
                                (sod_qty_inv * sod_um_conv)
         cph_sales[sa_bucket] = cph_sales[sa_bucket] + base_price
         cph_cost[sa_bucket]  = cph_cost[sa_bucket]  + tmp_cost.

      /* POST TO SALSESPERSON HISTORY */
      find sph_hist
         where sph_year    = sa_year
         and   sph_slspsn1 = so_slspsn[1]
         exclusive-lock
         no-error.

      if not available sph_hist
      then do:

         create sph_hist.
         assign
            sph_year    = sa_year
            sph_slspsn1 = so_slspsn[1]
            sph_smonth  = soc_fysm.
         if recid(sph_hist) = -1 then .

      end. /* IF NOT AVAILABLE sph_hist */

      assign
         sph_tot_sale         = sph_tot_sale         + base_price
         sph_tot_cost         = sph_tot_cost         + tmp_cost
         sph_sales[sa_bucket] = sph_sales[sa_bucket] + base_price
         sph_cost[sa_bucket]  = sph_cost[sa_bucket]  + tmp_cost.

   end.  /* SALES ANALYSIS */

   return.

end. /* DO TRANSACTION ON ERROR UNDO, LEAVE */

/* ERROR */
undo_all = yes.
