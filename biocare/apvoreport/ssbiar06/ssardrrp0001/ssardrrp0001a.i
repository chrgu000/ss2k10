/* CREATED INTERNAL PROCEDURES p-acct-disp AND p-drcrgltrans     */
/* BEFORE REPEAT BLOCK TO MAKE THE REPORT RUN IN FULLGUI REPORT. */

/* SS - 20080717.1 - B */
/*
PROCEDURE p-acct-disp:

   /* DISPLAYS ACCOUNT DETAILS WHEN DETAIL REPORT IS SELECTED    */
   /* IN REPORT CRITERIA.                                        */

   define input parameter l_entity    like ard_entity  no-undo.
   define input parameter l_acct      like ard_acct    no-undo.
   define input parameter l_sub       like ard_sub     no-undo.
   define input parameter l_cc        like ard_cc      no-undo.
   define input parameter l_project   like ard_project no-undo.
   define input parameter l_desc      like ard_desc    no-undo.
   define input parameter l_amt       like ard_amt     no-undo.
   define input parameter l_base_damt like ard_amt     no-undo.
   define input parameter l_curr      like ar_curr     no-undo.
   */
   /* SS - 20080717.1 - E */

   /* SS - 20080717.1 - B */
   /*
   display
      l_entity  @ ard_entity
      l_acct    @ ard_acct
      l_sub     @ ard_sub
      l_cc      @ ard_cc
      l_project @ ard_project
   with frame d.
   */
   CREATE ttssardrrp0001.
   ASSIGN
      ttssardrrp0001_ar_batch = ar_batch

      ttssardrrp0001_ar_type = ar_type

      ttssardrrp0001_ar_nbr = ar_nbr
      ttssardrrp0001_type = TYPE
      ttssardrrp0001_ar_bill = ar_bill
      ttssardrrp0001_name = NAME
      ttssardrrp0001_ar_date = ar_date
      ttssardrrp0001_ar_contested = ar_contested
      ttssardrrp0001_ar_entity = ar_entity
      ttssardrrp0001_ar_cr_terms = ar_cr_terms
      ttssardrrp0001_ar_curr = ar_curr

      ttssardrrp0001_ar_base_amt = DISP_amt

      ttssardrrp0001_ar_amt = ar_amt

      ttssardrrp0001_ar_ex_rate = ar_ex_rate
      ttssardrrp0001_ar_ex_rate2 = ar_ex_rate2

      ttssardrrp0001_ex_rate_relation1 = ex_rate_relation1
      ttssardrrp0001_ar_effdate = ar_effdate
      ttssardrrp0001_ar_cust = ar_cust
      ttssardrrp0001_ar_tax_date = ar_tax_date
      ttssardrrp0001_ar_acct = ar_acct
      ttssardrrp0001_ar_sub = ar_sub
      ttssardrrp0001_ar_cc = ar_cc
      ttssardrrp0001_ar_dun_level = ar_dun_level
      ttssardrrp0001_disp_curr = DISP_curr
      ttssardrrp0001_disp_applied = DISP_applied

      ttssardrrp0001_ex_rate_relation2 = ex_rate_relation2

      ttssardrrp0001_ar_po = ar_po

      ttssardrrp0001_ar_due_date = ar_due_date

      ttssardrrp0001_ard_entity = ard_entity
      ttssardrrp0001_ard_acct = ard_acct
      ttssardrrp0001_ard_sub = ard_sub
      ttssardrrp0001_ard_cc = ard_cc
      ttssardrrp0001_ard_project = ard_project
      .
   /* SS - 20080717.1 - E */

   if (base_rpt = "" and
       mixed_rpt)
   or base_rpt = ar_curr
   then do:

      base_damt:format in frame d = curr_amt_fmt.

      /* SS - 20080717.1 - B */
      /*
      display
         l_amt  @ base_damt
         l_desc @ ard_desc
         with frame d.
      */
      ASSIGN
         ttssardrrp0001_ard_base_amt = ard_amt
         ttssardrrp0001_ard_desc = ard_desc
         .
      /* SS - 20080717.1 - E */

   end. /* IF base_rpt = " " ... */
   else do:

      base_damt:format in frame d = base_amt_fmt.

      /* SS - 20080717.1 - B */
      /*
      display
         l_base_damt @ base_damt
         l_desc      @ ard_desc
         with frame d.
      */
      ASSIGN
         ttssardrrp0001_ard_base_amt = base_damt
         ttssardrrp0001_ard_desc = ard_desc
         .
      /* SS - 20080717.1 - E */

   end. /* ELSE DO */

   /* SS - 20080717.1 - B */
   /*
   down with frame d.
   */
   ASSIGN
      ttssardrrp0001_ard_amt = ard_amt
      .
   /* SS - 20080717.1 - E */

   if  not l_cnv_rnd_msg
   and base_rpt  =  " "
   and base_curr <> ar_curr
   then
      l_cnv_rnd_msg = true.

   /* SS - 20080717.1 - B */
   /*
END PROCEDURE. /* p-acct-disp */
   */
   /* SS - 20080717.1 - E */
