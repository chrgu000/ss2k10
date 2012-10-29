/* GUI CONVERTED from chcfrpa.p (converter v1.71) Sun Oct 21 21:39:25 2007 */
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

       FORM /*GUI*/  header SUBSTRING ("©°©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©´" , 1, 30,  "RAW") 
                   format "x(30)" at 35 
                   SUBSTRING ("©¦" , 1, 2,  "RAW") format "x(2)" at 35
                   getTermLabel("CASH_FLOW_REPORT", 10) format "x(10)" at 45
                   SUBSTRING ("©¦" , 1, 2,  "RAW") at 63
                   SUBSTRING ("©¸©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¼" , 1, 30,  "RAW")
                   format "x(30)" at 35
                /*   "----------" at 45 */ skip(1)
                   getTermLabel("CASH_FLOW_REPORT_NO", 8) at 80
                   getTermLabel("REPORTER", 10) format "x(10)" at 5
                   reporter no-label
                   getTermLabel("CASH_FLOW_YEAR", 4) at 45
                   year no-label
                   month "kkk"
                   getTermLabel("TO", 2) format "x(2)" 
                   month1
                   getTermLabel("CASH_FLOW_CURRENCY", 8) at 80 
                   skip
SUBSTRING ("
©°©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©Ð©¤©¤©¤©¤©¤©Ð©¤©¤©¤©¤©¤©¤©¤©¤©¤©´" , 1, 96,  "RAW") format "x(96)" at 1 
               /*    fill("-", 90) format "x(90)"*/
                   SUBSTRING ("©¦" , 1, 2,  "RAW") format "x(2)" at 1
                   getTermLabel("CASH_FLOW_ENTRY", 4) at 30
                   SUBSTRING ("©¦" , 1, 2,  "RAW") format "x(2)" at 59 
                   getTermLabel("CASH_FLOW_LINE", 4) to 70
                   SUBSTRING ("©¦" , 1, 2,  "RAW") format "x(2)" at 71 
                   getTermLabel("AMOUNT", 10) to 90
                   SUBSTRING ("©¦" , 1, 2,  "RAW") format "x(2)" at 91 
                    SUBSTRING ("
©À©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©à©¤©¤©¤©¤©¤©à©¤©¤©¤©¤
©¤©¤©¤©¤©¤©È" , 1, 97,  "RAW") format "x(96)" at 1
                   skip
/*
                   fill("-", 60) format "x(60)"
                   fill("-", 8) format "x(8)"
                   fill("-", 20) format "x(20)"
*/
                   with STREAM-IO /*GUI*/  frame cf no-box width 300.
  
       for first glc_cal fields (glc_end glc_per glc_start glc_year glc_domain)
           no-lock where glc_domain = global_domain and glc_start = begdt : end.
        if available glc_cal then assign month = glc_per
                                         year  = glc_year.

       for first glc_cal fields (glc_end glc_per glc_start glc_year glc_domain )
           no-lock where glc_domain = global_domain and glc_end = enddt: end.
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
                                 fm_total fm_type fm_underln fm_domain)
           use-index fm_fpos no-lock where fm_type = "C"
                                       and fm_sums_into = 0
                                       and fm_domain = global_domain: end.

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
                          and fmb.fm_domain = global_domain
               no-lock use-index fm_sums_into 
                       break by fmb.fm_sums_into
                       with frame cf_b no-box width 152:

	   define variable x1 as char.
	   define variable x2 as char.
	   define variable x3 as char.
	   define variable x4 as char.
	   define variable x5 as char.
	   define variable x6 as char.

           x1 = SUBSTRING("©¦" , 1, 2,  "RAW"). 
           x2 = SUBSTRING ("©¦" , 1, 2,  "RAW").
           x3 = SUBSTRING ("©¦" , 1, 2,  "RAW").
           x4 = SUBSTRING ("©¦" , 1, 2,  "RAW").
           x5 =  SUBSTRING ("
©À©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©à©¤©¤©¤©¤©¤©à©¤©¤©¤©¤
©¤©¤©¤©¤©¤©È" , 1, 97,  "RAW").
           x6 = SUBSTRING ("
©¸©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©Ø©¤©¤©¤©¤©¤©Ø©¤©¤©¤©¤
©¤©¤©¤©¤©¤©¼" , 1, 97,  "RAW"). 

             FORM /*GUI*/  x1  format "x(2)" at 1 
                  fmb1.fm_desc format "x(54)"
                  x2  format "x(2)" at 59 
                  line
                  x3  format "x(2)" at 71
                  amount to 90
                  x4 format "x(2)" at 91 skip
                  x5 format "x(96)" at 1 
               with STREAM-IO /*GUI*/  frame cf_b no-label no-box width 152.	    
               
/*             if first-of(fmb.fm_sums_into) then do:  */
               find first qad_wkfl where qad_key1 = "fm_desc" and
                          qad_key2 = string(fmb.fm_fpos, "999999") 
                          and qad_domain = global_domain
                          no-lock no-error.
               if available qad_wkfl then 
               assign desc1 = qad_charfld[1] + qad_charfld[2] + qad_charfld[3]
                      desc2 = qad_charfld[4] + qad_charfld[5].

                  display x1
                          fmb.fm_desc + desc1 + desc2 @ fmb1.fm_desc 
                          x2
                          x3
                          x4
                          x5
                          with frame cf_b STREAM-IO /*GUI*/ .
                  down 1 with frame cf_b.
/*                  next.
               end. */
   
               for each fmb1 where fmb1.fm_type = "C"
                          and fmb1.fm_sums_into = fmb.fm_fpos
                          and fmb1.fm_domain = global_domain
                    no-lock break /*by fmb.fm_sums_into*/
                                  by fmb1.fm_sums_into
                                  by fmb1.fm_dr_cr descending
                    with frame cf_b /*down*/ width 152:

               find first ac_mstr where ac_fpos = fmb1.fm_fpos
                                    and ac_active = yes
                                    and ac_domain = global_domain
                                  no-lock no-error.

               if available ac_mstr then do:
/*                  down 1 with frame cf_b.  */
  
               amount = 0.

  /*      find first xcftr_hist where xcftr_ref = "cashflowinitial"    */
/*XXLY*/      for each xcftr_hist where xcftr_ref = "cashflowinitial" 
                                       and xcftr_acct = ac_code
                                       and xcftr_domain = global_domain
/*XXLY*/                               and integer(xcftr__qadc04) >= month and integer(xcftr__qadc04) <= month1 
                                       no-lock:
                            amount = amount + xcftr_amt.
                   end.
               for each gltr_hist where gltr_entity >= entity
                                    and gltr_entity <= entity1
                                    and gltr_eff_dt >= begdt
                                    and gltr_eff_dt <= enddt
                                    and gltr_domain = global_domain
                                        no-lock,
                   each xcftr_hist where xcftr_entity = gltr_entity
                                     and xcftr_ref = gltr_ref 
                                     and xcftr_acct = ac_code
                                     and xcftr_ac_code = gltr_acc
                                     and xcftr_sub     = gltr_sub
                                     and xcftr_cc      = gltr_ctr
                                     and xcftr_pro     = gltr_project
                                     and xcftr_domain = global_domain
                                         no-lock 
                                     break by xcftr_ref:
                   amount = amount + xcftr_amt.

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
                          and qad_domain = global_domain
                          no-lock no-error.
               if available qad_wkfl then 
               assign desc11 = qad_charfld[1] + qad_charfld[2] + qad_charfld[3]
                      desc21 = qad_charfld[4] + qad_charfld[5].
               if amount > 0 then disamount = amount.
               else disamount  = -1 * amount.
               display x1
                       "    " + fmb1.fm_desc + desc11 + desc21 @ fmb1.fm_desc
                       x2
                       line
                       x3
                       disamount @ amount
                       x4
                       /*x5*/ 
                       with frame cf_b STREAM-IO /*GUI*/ .
           /*    down 1 with frame cf_b.*/

 if page-size - line-count < 3 then do:
               display x6 @ x5 with frame cf_b STREAM-IO /*GUI*/ .
               down 1 with frame cf_b.
 page.
 pages = pages + 1.
 view frame cf.
 end.
 else do:
               display x5 with frame cf_b STREAM-IO /*GUI*/ .
               down 1 with frame cf_b.
end.
               io_tot_amt = io_tot_amt + amount.

               if last-of(fmb1.fm_dr_cr) then do:
                  line = line + 1.
                  if fmb1.fm_dr_cr = yes then
                  display x1
                          "    " + getTermLabel("CASH_FLOW_IN_TOT", 12) 
                          @ fmb1.fm_desc 
                          x2
                          x3
                          x4
                      /*    x5*/
                  with frame cf_b STREAM-IO /*GUI*/ .
                  else
                  display x1
                          "    " + getTermLabel("CASH_FLOW_OUT_TOT", 12) 
                          @ fmb1.fm_desc with frame cf_b STREAM-IO /*GUI*/ .
            
                  display x2
                          line
                          x3
                          abs(io_tot_amt) @ amount 
                          x4
                       /*   x5*/
                  with frame cf_b STREAM-IO /*GUI*/ .
            /*      down 1 with frame cf_b.*/
 if page-size - line-count < 3 then do:
               display x6 @ x5 with frame cf_b STREAM-IO /*GUI*/ .
               down 1 with frame cf_b.
 page.
 pages = pages + 1.
 view frame cf.
 end.
 else do:
               display x5 with frame cf_b STREAM-IO /*GUI*/ .
               down 1 with frame cf_b.
end.

                  sub_tot_amt = sub_tot_amt + io_tot_amt.
                  io_tot_amt = 0.
               end.

/*             end. /* if available ac_mstr */  
           end. /* for each fmb1 */  */

               if last-of(fmb1.fm_sums_into) then do: 
                  line = line + 1.
                  display x1
                          "    " + substring(fmb.fm_desc, 5, 20, "RAW")
                          + desc1 + desc2
                          + getTermLabel("NET_AMOUNT", 4) 
                          @ fmb1.fm_desc with frame cf_b STREAM-IO /*GUI*/ . 
            
                  display x2
                          line
                          x3
                          abs(sub_tot_amt) @ amount 
                          x4
                       /*   x5*/
                  with frame cf_b STREAM-IO /*GUI*/ .
/*                  down 1 with frame cf_b.*/
 if page-size - line-count < 3 then do:
               display x6 @ x5 with frame cf_b STREAM-IO /*GUI*/ .
               /*down 1 with frame cf_b.*/
 page.
 pages = pages + 1.
 view frame cf.
 end.
 else do:
               display x5 with frame cf_b STREAM-IO /*GUI*/ .
          /*     down 1 with frame cf_b.*/
end.

                  tot_amt = tot_amt + sub_tot_amt.
                  sub_tot_amt = 0.
               end.  
             end. /* if available ac_mstr */  

           end. /* for each fmb1 */

          /* affect to cash due to exchange rate change */
          if last(fmb.fm_sums_into) then do:  
          line = line + 1.
        /*  down 1 with frame cf_b.  */
          display x1
                  getTermLabel("EXCHANGERATE_TO_CASH", 64)
                          @ fmb1.fm_desc with frame cf_b STREAM-IO /*GUI*/ . 
          display x2
                  line
                  x3
                  amount1 @ amount 
                  x4
                  x5
          with frame cf_b STREAM-IO /*GUI*/ .
          down 1 with frame cf_b.
          line = line + 1.
          display x1
                  fm_mstr.fm_desc
                  @ fmb1.fm_desc with frame cf_b STREAM-IO /*GUI*/ . 
          display x2
                  line
                  x3
                  tot_amt @ amount 
                  x4
 SUBSTRING ("
©¸©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©Ø©¤©¤©¤©¤©¤©Ø©¤©¤©¤©¤
©¤©¤©¤©¤©¤©¼" , 1, 97,  "RAW") @ x5
          with frame cf_b STREAM-IO /*GUI*/ .
          /*down 1 with frame cf_b.*/
          end.

        end. /* for each fmb */
           

       page.
        
       if c-application-mode <> 'web':u then
          pause before-hide.

       {wbrp04.i}

