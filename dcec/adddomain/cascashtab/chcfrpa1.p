/* GUI CONVERTED from chcfrpa1.p (converter v1.71) Sun Oct 21 21:39:25 2007 */
/* chcfrpa.p - CAS CASH FLOW REPORT (PART II)                           */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/* REVISION: 9.1CH   LAST MODIFIED: 09/09/02   BY: XinChao Ma           */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

          {mfdeclre.i}

	  {gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

/* ********** End Translatable Strings Definitions ********* */

          {wbrp02.i}

       define shared variable begdt     like gltr_eff_dt.
       define shared variable enddt     like gltr_eff_dt.
       define shared variable entity    like gltr_entity.
       define shared variable entity1   like gltr_entity.

       define variable line as integer format ">>9".
       define variable pages as integer format ">>9".
       define variable amount like xcftr_amt format "->>,>>>,>>>,>>9.99".
       define variable amount1 like xcftr_amt format "->>,>>>,>>>,>>9.99".
       define variable disamount like xcftr_amt format "->>,>>>,>>>,>>9.99".
       define variable tot_amt like xcftr_amt format "->>,>>>,>>>,>>9.99".   
       define variable io_tot_amt like xcftr_amt format "->>,>>>,>>>,>>9.99".   
       define variable sub_tot_amt like xcftr_amt format "->>,>>>,>>>,>>9.99".   
       define variable reporter as character format "x(24)".
       define variable year as integer format ">>>9".
       define variable month as integer format ">>9".
       define variable month1 as integer format ">9".
       define variable desc1 as character format "x(24)".
       define variable desc2 as character format "x(16)".
       define variable desc11 as character format "x(24)".
       define variable desc21 as character format "x(16)".

       
       define buffer fmb for fm_mstr.
       define buffer fmb1 for fm_mstr.

       FORM /*GUI*/  header getTermLabel("CASH_FLOW_REPORT", 10) format "x(10)" at 45
                   "----------" at 45 skip(1)
                   getTermLabel("CASH_FLOW_REPORT_NO", 8) at 80
                   getTermLabel("REPORTER", 10) format "x(10)" at 5
                   reporter no-label
                   getTermLabel("CASH_FLOW_YEAR", 4) at 45
                   year no-label
                   month
                   getTermLabel("TO", 2) format "x(2)" 
                   month1
                   getTermLabel("CASH_FLOW_CURRENCY", 8) at 80 
                   skip
                   fill("-", 90) format "x(90)"
                   getTermLabel("CASH_FLOW_ENTRY", 4) at 30
                   getTermLabel("CASH_FLOW_LINE", 4) to 72
                   getTermLabel("AMOUNT", 10) to 91
                   skip
                   fill("-", 60) format "x(60)"
                   fill("-", 8) format "x(8)"
                   fill("-", 20) format "x(20)"
                   with STREAM-IO /*GUI*/  frame cf no-box width 300.
  
       for first glc_cal fields (glc_end glc_per glc_start glc_year)
           no-lock where glc_start = begdt : end.
        if available glc_cal then assign month = glc_per
                                         year  = glc_year.

       for first glc_cal fields (glc_end glc_per glc_start glc_year)
           no-lock where glc_end = enddt: end.
        if available glc_cal then month1 = glc_per.
        else month1 = month(enddt).

       find ls_mstr where ls_addr = "~~reports" and ls_type = "company"
            no-lock no-error.

            if available ls_mstr then
            find ad_mstr where ad_addr = ls_addr no-lock no-error.

            if available ad_mstr then
               reporter = ad_name.

       view frame cf.

       for first fm_mstr fields (fm_desc fm_dr_cr fm_fpos fm_header
                                 fm_page_brk fm_skip fm_sums_into
                                 fm_total fm_type fm_underln )
           use-index fm_fpos no-lock where fm_type = "C"
                                       and fm_sums_into = 0: end.

           assign io_tot_amt = 0
                  sub_tot_amt =0
                  tot_amt = 0
                  amount1 = 0
                  line = 0.
/*
               form
                  fmb1.fm_desc format "x(64)"
                  line
                  amount
               with frame cf_b no-label no-box width 152.	    
*/
           for each fmb where fmb.fm_type = "C" 
                          and fmb.fm_sums_into = fm_mstr.fm_fpos
               no-lock use-index fm_sums_into 
/*                     break by fmb.fm_sums_into  */
                       break by fmb.fm_fpos
                       with frame cf_b no-box width 152:

	    
               FORM /*GUI*/ 
                  fmb1.fm_desc format "x(64)"
                  line
                  amount
                  skip(1)
               with STREAM-IO /*GUI*/  frame cf_b no-label no-box width 152.	    
               
/*             if first-of(fmb.fm_sums_into) then do:  */
               find first qad_wkfl where qad_key1 = "fm_desc" and
                          qad_key2 = string(fmb.fm_fpos, "999999") 
                          no-lock no-error.
               if available qad_wkfl then 
               assign desc1 = qad_charfld[1] + qad_charfld[2] + qad_charfld[3]
                      desc2 = qad_charfld[4] + qad_charfld[5].

                  display trim(fmb.fm_desc) + trim(desc1) + trim(desc2)
                          @ fmb1.fm_desc 
                          with frame cf_b STREAM-IO /*GUI*/ .
                  down 1 with frame cf_b.
   
               for each fmb1 where fmb1.fm_type = "C"
                          and fmb1.fm_sums_into = fmb.fm_fpos
                    no-lock break /*by fmb.fm_sums_into*/
                                  by fmb1.fm_sums_into
                                  by fmb1.fm_dr_cr descending
                    with frame cf_b /*down*/ width 152:

               find first ac_mstr where ac_fpos = fmb1.fm_fpos
                                    and ac_active = yes
                                  no-lock no-error.

               if available ac_mstr then do:
/*                  down 1 with frame cf_b.  */
  
               amount = 0.
               find first xcftr_hist where xcftr_ref = "cashflowinitial"
                                       and xcftr_acct = ac_code
                                       no-lock no-error.
               if available xcftr_hist then amount = xcftr_amt.

               for each gltr_hist where gltr_entity >= entity
                                    and gltr_entity <= entity1
                                    and gltr_eff_dt >= begdt
                                    and gltr_eff_dt <= enddt
                                        no-lock,
                   each xcftr_hist where xcftr_entity = gltr_entity
                                     and xcftr_ref = gltr_ref 
                                     and xcftr_glt_line = gltr_line
                                     and xcftr_acct = ac_code
                                     and xcftr_ac_code = gltr_acc
                                     and xcftr_sub     = gltr_sub
                                     and xcftr_cc      = gltr_ctr
                                     and xcftr_pro     = gltr_project
                                         no-lock 
                                     break by xcftr_ref:
                   amount = amount + xcftr_amt.
/*
                   if last-of(xcftr_ref) and gltr_curr <> base_curr then do:
                   for first exr_rate
                       where ((exr_curr1 = gltr_curr and exr_curr2 = base_curr)
                          or (exr_curr2 = gltr_curr and exr_curr1 = base_curr))
                         and exr_start_date <= today
                         and exr_end_date >= today
                             no-lock:
                   end. /* FOR FIRST exrrate */
                   if available exr_rate then do:
                      if exr_curr1 = gltr_curr and exr_curr2 = base_curr then
                         amount1 = amount1 + 
                         (exr_rate2 / exr_rate - gltr_ex_rate2 / gltr_ex_rate)
                         * gltr_curramt.
                      else
                      if exr_curr2 = gltr_curr and exr_curr1 = base_curr then
                         amount1 = amount1 + 
                         (exr_rate / exr_rate2 - gltr_ex_rate2 / gltr_ex_rate)
                         * gltr_curramt.
                   end.

                   end. /* if last-of(xcftr_ref) and gltr_curr <> */
*/
                   if gltr_curr <> base_curr then do:
                   for first exr_rate
                       where exr_curr2 = gltr_curr and exr_curr1 = base_curr
                         and exr_start_date <= today
                         and exr_end_date >= today
                             no-lock:
                   end. /* FOR FIRST exrrate */
                   if available exr_rate then do:
                         amount1 = amount1 + 
                         (exr_rate / exr_rate2 - gltr_ex_rate2 / gltr_ex_rate)
                         * xcftr_curr_amt.
                   end.
                   end. /* if last-of(xcftr_ref) and gltr_curr <> */

               end. /* for each gltr_hist */

               line = line + 1.
               find first qad_wkfl where qad_key1 = "fm_desc" and
                          qad_key2 = string(fmb1.fm_fpos, "999999") 
                          no-lock no-error.
               if available qad_wkfl then 
               assign desc11 = qad_charfld[1] + qad_charfld[2] + qad_charfld[3]
                      desc21 = qad_charfld[4] + qad_charfld[5].
               if amount > 0 then disamount = amount.
               else disamount  = -1 * amount.

               display "    " + trim(fmb1.fm_desc) + trim(desc11) + trim(desc21)
                       @ fmb1.fm_desc
                       line
                       disamount @ amount
                       with frame cf_b STREAM-IO /*GUI*/ .

               if page-size - line-count < 3 then do:
                  down 1 with frame cf_b.
                  page.
                  pages = pages + 1.
                  view frame cf.
               end.
               else do:
                  down 1 with frame cf_b.
               end.

               io_tot_amt = io_tot_amt + amount.

               if last-of(fmb1.fm_dr_cr) then do:
                  line = line + 1.
                  if fmb1.fm_dr_cr = yes then
                  display "    " + getTermLabel("CASH_FLOW_IN_TOT", 12) 
                          @ fmb1.fm_desc with frame cf_b STREAM-IO /*GUI*/ .
                  else
                  display "    " + getTermLabel("CASH_FLOW_OUT_TOT", 12) 
                          @ fmb1.fm_desc with frame cf_b STREAM-IO /*GUI*/ .
            
                  display line
                          abs(io_tot_amt) @ amount with frame cf_b STREAM-IO /*GUI*/ .
                  if page-size - line-count < 3 then do:
                     down 1 with frame cf_b.
                     page.
                     pages = pages + 1.
                     view frame cf.
                  end.
                  else do:
                  down 1 with frame cf_b.
                  end.

                  sub_tot_amt = sub_tot_amt + io_tot_amt.
                  io_tot_amt = 0.
               end.

/*             end. /* if available ac_mstr */  
           end. /* for each fmb1 */  */

               if last-of(fmb1.fm_sums_into) then do: 
                  line = line + 1.
                  display "    " + substring(fmb.fm_desc, 5, 20, "RAW")
                          + trim(desc1) + trim(desc2)
                          + getTermLabel("NET_AMOUNT", 4) 
                          @ fmb1.fm_desc with frame cf_b STREAM-IO /*GUI*/ . 
            
                  display line
                          abs(sub_tot_amt) @ amount with frame cf_b STREAM-IO /*GUI*/ .
/*                  down 1 with frame cf_b.*/
               if page-size - line-count < 3 then do:
                  page.
                  pages = pages + 1.
                  view frame cf.
               end.
               else do:
               end.

                  tot_amt = tot_amt + sub_tot_amt.
                  sub_tot_amt = 0.
               end.  
             end. /* if available ac_mstr */  

           end. /* for each fmb1 */

          /* affect to cash due to exchange rate change */
/*        if last(fmb.fm_sums_into) then do:  */
          if last(fmb.fm_fpos) then do:  
          line = line + 1.
          down 1 with frame cf_b.
          display getTermLabel("EXCHANGERATE_TO_CASH", 64)
                          @ fmb1.fm_desc with frame cf_b STREAM-IO /*GUI*/ . 
          display line
                  amount1 @ amount with frame cf_b STREAM-IO /*GUI*/ .
          down 1 with frame cf_b.
          line = line + 1.
          display fm_mstr.fm_desc
                  @ fmb1.fm_desc with frame cf_b STREAM-IO /*GUI*/ . 
          display line
                  tot_amt @ amount with frame cf_b STREAM-IO /*GUI*/ .
          /*down 1 with frame cf_b.*/
          end.

        end. /* for each fmb */
           

       page.
        
       if c-application-mode <> 'web':u then
          pause before-hide.

/*         hide frame b. */
       {wbrp04.i}
