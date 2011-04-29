/* xxgldabrpax.p - GENERAL LEDGER DETAILED ACCOUNT BALANCES REPORT            */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100810.1  By: Roger Xiao */  /*xxglrp001.p子程式,输出到BI*/
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "GLDABRPA.P"}
{gplabel.i}

{wbrp02.i}

define new shared variable begdtxx as date no-undo.

define shared variable first_acct like mfc_logical no-undo.
define shared variable first_sub  like mfc_logical no-undo.
define shared variable first_cc   like mfc_logical no-undo.
define shared variable glname     like en_name     no-undo.
define shared variable per        as integer       no-undo.
define shared variable per1       as integer       no-undo.
define shared variable yr         as integer       no-undo.
define shared variable begdt      like gltr_eff_dt no-undo.
define shared variable enddt      like gltr_eff_dt no-undo.
define shared variable yr_beg     like gltr_eff_dt no-undo.
define shared variable yr_end     as date          no-undo.
define shared variable acc        like ac_code     no-undo.
define shared variable acc1       like ac_code     no-undo.
define shared variable sub        like sb_sub      no-undo.
define shared variable sub1       like sb_sub      no-undo.
define shared variable ctr        like cc_ctr      no-undo.
define shared variable ctr1       like cc_ctr      no-undo.
define shared variable beg_tot    as decimal
                                  format ">>>>>>,>>>,>>9.99cr" no-undo.
define shared variable per_tot    like beg_tot     no-undo.
define shared variable end_tot    like beg_tot     no-undo.
define shared variable transflag  as logical initial no
                                  label "Transaction Totals Only" no-undo.
define shared variable rpt_curr   like gltr_curr   no-undo.
define shared variable entity     like gltr_entity no-undo.
define shared variable entity1    like gltr_entity no-undo.
define shared variable ret        like ac_code     no-undo.
define shared variable asc_recno  as recid         no-undo.
define shared variable round_cnts as logical label
                                  "Round to Nearest Whole Unit" no-undo.
define shared variable prtfmt     as character format "x(30)" no-undo.
define shared variable doc_detail as logical
                                  label "Print Document Detail" no-undo.
define shared variable code       like dy_dy_code  no-undo.
define shared variable code1      like dy_dy_code  no-undo.
define shared variable et_beg_tot like beg_tot.
define shared variable et_end_tot like end_tot.
define shared variable et_per_tot like per_tot.
define shared variable daybooks-in-use as logical no-undo.
define shared variable l_show_hidden like mfc_logical no-undo.

define variable beg_bal           as decimal
                                  format ">>>>>>,>>>,>>9.99cr" no-undo.
define variable knt               as integer no-undo.
define variable cbal              like beg_bal no-undo.
define variable base_amt          as decimal
                                  format "->>>,>>>,>>>,>>9.99" no-undo.
define variable dt                as date no-undo.
define variable dt1               as date no-undo.
define variable end_bal           as decimal
                                  format ">>>,>>>,>>>,>>9.99cr" no-undo.
{&GLDABRPA-P-TAG28}
{&GLDABRPA-P-TAG29}
define variable act_to_dt         as decimal
                                  format ">>>,>>>,>>>,>>9.99cr" no-undo.
define variable account           as character format "x(22)" no-undo.
define variable trxns_exist       like mfc_logical no-undo.
define variable begdt1            like gltr_eff_dt no-undo.
define variable enddt1            like gltr_eff_dt no-undo.
define variable perknt            as integer       no-undo.
define variable dr-bal            as decimal       no-undo.
define variable cr-bal            as decimal       no-undo.
define variable et_beg_bal        like beg_bal.
define variable et_end_bal        like end_bal.
define variable et_act_to_dt      like act_to_dt.
define variable et_base_amt       like base_amt.
define variable et_dr-bal         as decimal       no-undo.
define variable et_cr-bal         as decimal       no-undo.
define variable et_per-total-dr   like base_amt    no-undo.
define variable et_per-total-cr   like base_amt    no-undo.
define variable et_dy-total-dr    like base_amt    no-undo.
define variable et_dy-total-cr    like base_amt    no-undo.
define variable et_trans-total-cr like base_amt    no-undo.
define variable et_trans-total-dr like base_amt    no-undo.

define variable l_flag_debit        like mfc_logical no-undo.
define variable l_daybook_flag      like mfc_logical no-undo.
define variable l_other_daybook     like mfc_logical no-undo.
define variable l_skip_process      like mfc_logical no-undo.
define variable l_et_oth-total-dr   like base_amt    no-undo.
define variable l_et_oth-total-cr   like base_amt    no-undo.
define variable l_et_trans_oth-total-dr like base_amt    no-undo.
define variable l_et_trans_oth-total-cr like base_amt    no-undo.


/* SS - 100810.1 - B */
define variable v_det_bal         as decimal    format "->>>,>>>,>>>,>>9.99" no-undo.
define variable et_base_amt1      like base_amt.
define variable et_base_amt2      like base_amt.

define var tmp_amt1 like base_amt .
define var tmp_amt2 like base_amt .
define var xacct as char format "x(24)".
define new shared temp-table temp1 
    field t1_line    like gltr_line 
    field t1_acct    as char format "x(24)"
    field t1_addr    like gltr_addr
    field t1_batch   like gltr_batch    
    field t1_doc_typ like gltr_doc_typ  
    field t1_doc     like gltr_doc 
    field t1_amt     like gltr_amt
    field t1_curramt like gltr_curramt
    field t1_flag    as logical 
    .
/* SS - 100810.1 - E */


{&GLDABRPA-P-TAG1}
{etvar.i}   /* common euro variables */
{etrpvar.i} /* common euro report variables */

for first asc_mstr fields( asc_domain asc_acc asc_sub asc_cc)
   where recid(asc_mstr) = asc_recno no-lock:
end.

for first ac_mstr fields( ac_domain ac_active ac_code ac_type ac_curr ac_desc )
    where ac_mstr.ac_domain = global_domain
    and  ac_code = asc_acc no-lock:
end.
assign
   act_to_dt    = 0
   beg_bal      = 0
   end_bal      = 0
   et_act_to_dt = 0
   et_beg_bal   = 0
   et_end_bal   = 0
   trxns_exist  = no.

for each en_mstr
   fields( en_domain en_entity en_curr)
    where en_mstr.en_domain = global_domain
    and  en_entity >= entity
    and  en_entity <= entity1
no-lock:

   if can-find (first acd_det
       where acd_det.acd_domain = global_domain
       and  acd_acc  = asc_acc
       and  acd_sub = asc_sub
       and acd_cc   = asc_cc
       and acd_entity = en_entity
       and acd_year = yr
       and acd_per >= per
       and acd_per <= per1 )
   then do:

      assign trxns_exist = yes.
      leave.
   end.
end.  /* for each en_mstr */

/* CALCULATE AND DISPLAY BEGINNING BALANCE */
assign begdtxx = begdt - 1.
if lookup(ac_type, "A,L") = 0 then do:
   if begdt = yr_beg then assign beg_bal = 0.
   else do:
      {glacbal5.i &acc=asc_acc &sub=asc_sub &cc=asc_cc
         &code=code &code1=code1
         &begdt=yr_beg &enddt=begdtxx &drbal=dr-bal
         &crbal=cr-bal &yrend=yr_end
         &rptcurr=rpt_curr &accurr=ac_curr}
   end.
end.
else do:
   {glacbal5.i &acc=asc_acc &sub=asc_sub &cc=asc_cc
      &code=code &code1=code1
      &begdt=low_date &enddt=begdtxx &drbal=dr-bal
      &crbal=cr-bal &yrend=yr_end
      &rptcurr=rpt_curr &accurr=ac_curr}
end.
assign beg_bal = cr-bal + dr-bal.
{&GLDABRPA-P-TAG16}

if et_report_curr <> rpt_curr then do:
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input rpt_curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input beg_bal,
        input true,    /* ROUND */
        output et_beg_bal,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
end.  /* if et_report_curr <> rpt_curr */
else
   assign et_beg_bal = beg_bal.
{&GLDABRPA-P-TAG17}

{&GLDABRPA-P-TAG15}

if round_cnts then beg_bal = round(beg_bal, 0).
if round_cnts then et_beg_bal = round(et_beg_bal, 0).

/* DISPLAY ACCOUNT CODE AND BEGINNING BALANCE */
if ac_active or beg_bal <> 0 or
   et_beg_bal <> 0 or
   trxns_exist
then do:
   {glacct.i &acc=asc_acc &sub=asc_sub &cc=asc_cc &acct=account}
/* SS - 100810.1 - B 
   if page-size - line-counter <= 1 then
      page. 

   if first_acct then put asc_acc at 2 ac_desc at 26.
   if first_sub and asc_sub <> "" and co_use_sub
   then do:

      for first sb_mstr fields( sb_domain sb_desc sb_sub)
          where sb_mstr.sb_domain = global_domain
          and  sb_sub = asc_sub no-lock:
      end.
      put substring(account,1,(length(trim(asc_acc))+ 1
         + length(asc_sub))) format "x(22)" at 2
         "*" at 26 sb_desc at 27.
   end. 

   if asc_cc <> "" and first_cc then do:

      for first cc_mstr fields( cc_domain cc_desc cc_ctr)
          where cc_mstr.cc_domain = global_domain
          and  cc_ctr = asc_cc no-lock:
      end.
      put account at 2
         "**" at 26 cc_desc at 28.
   end. 

   if ac_curr <> et_report_curr then put ac_curr at 53.

   if ac_type = "M" then
      put {gplblfmt.i
             &FUNC=getTermLabel(""MEMO"",8)
          }  at 53.

   if ac_type = "S" then
      put {gplblfmt.i
             &FUNC=getTermLabel(""STAT"",8)
          }  at 53.

   {&GLDABRPA-P-TAG30}
   put string(et_beg_bal, prtfmt) format "x(19)" to 74 skip.
   {&GLDABRPA-P-TAG31}

   SS - 100810.1 - E */
/* SS - 100810.1 - B */
    v_det_bal = et_beg_bal .

    put unformatted
    /* 报表币别   */  et_report_curr             ";"
    /* 报表账户   */  account                    ";"
    /* 年         */  yr                       "年;"
    /* 月         */  0                          ";"
    /* 日         */  0                          ";"
    /* 凭证编号   */  "期初余额"                 ";"
    /* 摘要       */  ""                         ";"
    /* 供应商     */  ""                         ";"
    /* 客户       */  ""                         ";"
    /* 对方科目   */  ""                         ";"
    /* 批处理号   */  ""                         ";"
    /* "单据类型" */  ""                         ";"
    /* 单据号     */  ""                         ";"
    /* 银行       */  ""                         ";" 
    /* 支票编号   */  ""                         ";" 
    /* 借方发生额 */  0                          ";"
    /* 贷方发生额 */  0                          ";"
    /* 借或贷     */  ""                         ";"
    /* 当前余额   */  v_det_bal 
                      skip  .

/* SS - 100810.1 - E */

   /* LOOK FOR PERIODS */
   assign perknt = 0.
   for each glc_cal
      fields( glc_domain glc_end glc_start glc_per glc_year)
       where glc_cal.glc_domain = global_domain
       and  glc_year = yr
       and  glc_per >= per
       and  glc_per <= per1
   no-lock:

      /* LOOK UP TRANSACTIONS */
      assign begdt1 = begdt.
      if begdt1 < glc_start then assign begdt1 = glc_start.
      assign enddt1 = enddt.
      if enddt1 > glc_end then assign enddt1 = glc_end.
      assign
         knt             = 0
         et_per-total-cr = 0
         et_per-total-dr = 0
         l_et_oth-total-dr       = 0
         l_et_oth-total-cr       = 0
         l_et_trans_oth-total-dr = 0
         l_et_trans_oth-total-dr = 0
         l_other_daybook         = no.

      {&GLDABRPA-P-TAG48}
      for each gltr_hist
         {&GLDABRPA-P-TAG2}
         fields (gltr_acc gltr_addr gltr_amt gltr_batch
                 gltr_correction gltr_ctr gltr_curramt gltr_desc
                 gltr_doc gltr_doc_typ gltr_dy_code gltr_ecur_amt
                 gltr_eff_dt gltr_entity gltr_line gltr_project
                 gltr_ref gltr_sub gltr_tr_type)
         {&GLDABRPA-P-TAG3}
          where gltr_hist.gltr_domain = global_domain and
                             gltr_acc = asc_acc and
                             gltr_sub = asc_sub and
                             gltr_ctr = asc_cc  and
                        gltr_entity  >= entity  and
                        gltr_entity  <= entity1 and
                        gltr_eff_dt  >= begdt1  and
                        gltr_eff_dt  <= enddt1       
         no-lock use-index gltr_acc_ctr
            break by gltr_dy_code
                  by gltr_tr_type
                  by gltr_eff_dt
                  by gltr_ref
                  by gltr_line:
         {&GLDABRPA-P-TAG4}

/* SS - 100810.1 - B */
{gprun.i ""xxglrp001a.p"" "(input gltr_ref , input gltr_line, output xacct )"}
/* SS - 100810.1 - E */

         /* THE FLAG l_skip_process IS USED TO EXECUTE THE  */
         /*          FIRST-OF AND LAST-OF                   */

         /* THE FLAG l_daybook_flag IS USED TO CHECK WHETHER */
         /*     THE DAYBOOK IS IN THE INPUT CRITERIA         */

         assign
            l_skip_process = (gltr_acc = ret
                              and gltr_eff_dt = yr_end
                              and (gltr_tr_type = "YR"
                              or gltr_tr_type = "RA"))

            l_daybook_flag = (gltr_dy_code >= code
                              and gltr_dy_code <= code1).

         if not l_daybook_flag
         then
            l_other_daybook = yes.

         if not l_skip_process
         then do:

            {&GLDABRPA-P-TAG5}
            assign
               base_amt = gltr_amt.
            {&GLDABRPA-P-TAG18}
            if rpt_curr <> base_curr
            then
               assign
                  base_amt = gltr_curramt.
            {&GLDABRPA-P-TAG19}
            {&GLDABRPA-P-TAG20}

            if et_report_curr <> rpt_curr
            then do:
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input rpt_curr,
                    input et_report_curr,
                    input et_rate1,
                    input et_rate2,
                    input base_amt,
                    input true,     /* ROUND */
                    output et_base_amt,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.
            end.  /* if et_report_curr <> rpt_curr */
            {&GLDABRPA-P-TAG21}
            else
               assign
                  et_base_amt = base_amt.

            if round_cnts then base_amt = round(base_amt, 0).
            if round_cnts then et_base_amt = round(et_base_amt, 0).

            /*The following code block calculates separate Dr and Cr amounts
            and takes into consideration correction of accounting amounts*/

            l_flag_debit = ((base_amt >= 0
                             and gltr_correction = no)
                             or (base_amt        < 0
                             and gltr_correction = yes)).

            if l_flag_debit
            then do:
               if l_daybook_flag
               then
                  assign
                     et_per-total-dr   = et_per-total-dr   + et_base_amt
                     et_dy-total-dr    = et_dy-total-dr    + et_base_amt
                     et_trans-total-dr = et_trans-total-dr + et_base_amt.
               else
                  if l_show_hidden
                  then
                     assign
                        et_per-total-dr         = et_per-total-dr      +
                                                  et_base_amt
                        l_et_oth-total-dr       = l_et_oth-total-dr    +
                                                  et_base_amt
                        l_et_trans_oth-total-dr = l_et_trans_oth-total-dr
                                                  + et_base_amt.
               {&GLDABRPA-P-TAG22}
               {&GLDABRPA-P-TAG23}
            end. /* IF l_flag_debit */
            else do:
               if l_daybook_flag
               then
                  assign
                     et_per-total-cr   = et_per-total-cr   + (et_base_amt * -1)
                     et_dy-total-cr    = et_dy-total-cr    + (et_base_amt * -1)
                     et_trans-total-cr = et_trans-total-cr + (et_base_amt * -1).
               else
                  if l_show_hidden
                  then
                     assign
                        et_per-total-cr         = et_per-total-cr          +
                                                   (et_base_amt * -1)
                         l_et_oth-total-cr       = l_et_oth-total-cr       +
                                                   (et_base_amt * -1)
                         l_et_trans_oth-total-cr = l_et_trans_oth-total-cr +
                                                   (et_base_amt * - 1).

               {&GLDABRPA-P-TAG24}
               {&GLDABRPA-P-TAG25}
            end. /* ELSE DO */
         end. /* IF NOT l_skip_process */

         if (page-size - line-counter <= 1  and transflag = no) or
            (page-size - line-counter <= 1 and transflag = yes
            and  first-of(gltr_tr_type))
         then do:
/* SS - 100810.1 - B 
            page.

            if first_acct then
               put asc_acc at 2 ac_desc + " (" + getTermLabel("CONT",4) + ".)"
                   format "x(32)" at 26 skip.

            if first_sub and asc_sub <> "" and co_use_sub
            then
               put substring(account,1,(length(trim(asc_acc))+ 1
                  + length(asc_sub))) format "x(22)" at 2
               "*" at 26 sb_desc + " (" + getTermLabel("CONT",4) + ".)"
               format "x(32)" at 27 skip.

            if asc_cc <> "" and first_cc then
               put account at 2 "**" at 26
               cc_desc + " (" + getTermLabel("CONT",4) + ".)"
               format "x(32)" at 28 skip.

            put getTermLabel("PERIOD",6) + " " + string(glc_per) + "/" +
               string(glc_year) format "x(15)" at 3 skip.
   SS - 100810.1 - E */
         end. /* new page processed */
/* SS - 100810.1 - B 
         else if first(gltr_tr_type) then  
            put getTermLabel("PERIOD",6) + " " + string(glc_per) + "/" +
               string(glc_year) format "x(15)" at 3 skip.  /* ignore if new page */
   SS - 100810.1 - E */

         if transflag = no
         then do:
            if not l_skip_process
            then do:
               if page-size - line-counter <= 1
               then do:
/* SS - 100810.1 - B 
                  page.
                  if first_acct
                  then
                     put asc_acc at 2 ac_desc +
                       " (" + getTermLabel("CONT",4) + ".)"
                      format "x(32)" at 26 skip.

                  if first_sub and asc_sub <> "" and co_use_sub
                  then
                     put substring(account,1,(length(trim(asc_acc))+ 1
                        + length(asc_sub))) format "x(22)" at 2
                     "*" at 26 sb_desc + " (" + getTermLabel("CONT",4) + ".)"
                     format "x(32)" at 27 skip.

                  if asc_cc <> "" and first_cc
                  then
                     put
                        account at 2 "**" at 26
                        cc_desc + " (" + getTermLabel("CONT",4) + ".)"
                        format "x(32)" at 28 skip.

                  put
                     getTermLabel("PERIOD",6) + " " + string(glc_per) + "/" +
                     string(glc_year) format "x(15)" at 3 skip.
   SS - 100810.1 - E */
               end. /* new page processed */
               {&GLDABRPA-P-TAG6}
            end. /* IF NOT l_skip_process */

            if l_daybook_flag
            then do:
               if not l_skip_process
               then do:
/* SS - 100810.1 - B */
                et_base_amt1 = if l_flag_debit then et_base_amt else 0 .
                et_base_amt2 = if l_flag_debit then 0 else (et_base_amt * -1) .
                v_det_bal    = v_det_bal + et_base_amt1 - et_base_amt2 .

                if index("AP,AR,JL",gltr_tr_type) > 0 and gltr_doc <> "" then          
                put unformatted
                    /* 报表币别   */  et_report_curr             ";"
                    /* 报表账户   */  account                    ";"
                    /* 年         */  year(gltr_eff_dt)          "年;"
                    /* 月         */  month(gltr_eff_dt)         ";"
                    /* 日         */  day(gltr_eff_dt)           ";"
                    /* 凭证编号   */  gltr_ref                   ";"
                    /* 摘要       */  gltr_desc                  ";"
                    /* 供应商     */  if gltr_ref begins "AP" then gltr_addr   else ""  ";"
                    /* 客户       */  if gltr_ref begins "AR" then gltr_addr   else ""  ";"
                    /* 对方科目   */  xacct                      ";"
                    /* 批处理号   */  gltr_batch                 ";"
                    /* "单据类型" */  gltr_doc_typ               ";"
                    /* 单据号     */  gltr_doc                   ";"
                    /* 银行       */  if gltr_doc_typ = "CK" and length(gltr_doc) > 2 then substring(gltr_doc,1,2) else "" ";" 
                    /* 支票编号   */  if gltr_doc_typ = "CK" and length(gltr_doc) > 2 then substring(gltr_doc,3)   else "" ";" 
                    /* 借方发生额 */  if gltr_doc = "" then 0 else et_base_amt1  ";"
                    /* 贷方发生额 */  if gltr_doc = "" then 0 else et_base_amt2  ";"
                    /* 借或贷     */  if l_flag_debit then "借" else  "贷" ";"
                    /* 当前余额   */  v_det_bal 
                                      skip  .
                if index(xacct,",") > 0 and gltr_doc = "" then do:
                    /*还原余额,重新扣减明细*/
                    v_det_bal    = v_det_bal - et_base_amt1 + et_base_amt2 .

                    for each temp1 
                        break by t1_line :              
                        assign tmp_amt1 = t1_amt.
                        if rpt_curr <> base_curr then assign tmp_amt1 = t1_curramt.
                        if et_report_curr <> rpt_curr
                        then do:
                           {gprunp.i "mcpl" "p" "mc-curr-conv"
                              "(input rpt_curr,
                                input et_report_curr,
                                input et_rate1,
                                input et_rate2,
                                input tmp_amt1,
                                input true,     /* ROUND */
                                output tmp_amt2,
                                output mc-error-number)"}
                           if mc-error-number <> 0
                           then do:
                              {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                           end.
                        end.  /* if et_report_curr <> rpt_curr */
                        else assign tmp_amt2 = tmp_amt1.
                        if round_cnts then tmp_amt2 = round(tmp_amt2, 0).
                        
                        /*借贷方调整一下*/
                        et_base_amt1 = if t1_flag then 0 else (tmp_amt2 * -1)  .
                        et_base_amt2 = if t1_flag then tmp_amt2   else 0 .
                        v_det_bal    = v_det_bal + et_base_amt1 - et_base_amt2 .


                        put unformatted
                            /* 报表币别   */  et_report_curr             ";"
                            /* 报表账户   */  account                    ";"
                            /* 年         */  year(gltr_eff_dt)        "年;"
                            /* 月         */  month(gltr_eff_dt)         ";"
                            /* 日         */  day(gltr_eff_dt)           ";"
                            /* 凭证编号   */  gltr_ref                   ";"
                            /* 摘要       */  gltr_desc                  ";"
                            /* 供应商     */  if gltr_ref begins "AP" then t1_addr   else ""  ";"
                            /* 客户       */  if gltr_ref begins "AR" then t1_addr   else ""  ";"
                            /* 对方科目   */  t1_acct                    ";"
                            /* 批处理号   */  t1_batch                   ";"
                            /* "单据类型" */  t1_doc_typ                 ";"
                            /* 单据号     */  t1_doc                     ";"
                            /* 银行       */  if t1_doc_typ = "CK" and length(t1_doc) > 2 then substring(t1_doc,1,2) else "" ";" 
                            /* 支票编号   */  if t1_doc_typ = "CK" and length(t1_doc) > 2 then substring(t1_doc,3)   else "" ";" 
                            /* 借方发生额 */  et_base_amt1  ";"
                            /* 贷方发生额 */  et_base_amt2  ";"
                            /* 借或贷     */  if t1_flag then "贷" else "借"  ";"
                            /* 当前余额   */  v_det_bal   
                                              skip  .
                    end. /*for each temp1*/
                end. /*if index(xacct,",")*/

/* SS - 100810.1 - E */
               end. /* IF NOT l_skip_process */

               if last-of(gltr_dy_code) and
                  daybooks-in-use = yes
               then do:
                  {&GLDABRPA-P-TAG40}
/* SS - 100810.1 - B 
                  put "-------------------" to 102
                      "-------------------" to 124
                      skip
                      {gplblfmt.i
                         &FUNC=getTermLabel(""TOTAL_DAYBOOK"",35)
                         &CONCAT = "':  '"
                      }  to 74
                      gltr_dy_code
                      et_dy-total-dr to 102
                      et_dy-total-cr to 124
                      {&GLDABRPA-P-TAG9}
                      skip(1).
   SS - 100810.1 - E */

                  {&GLDABRPA-P-TAG41}
                  assign
                     et_dy-total-dr = 0
                     et_dy-total-cr = 0.
               end. /*last of (gltr_dy_code)*/
            end. /* IF l_daybook_flag */
         end. /* do added to detail period printing */
/* SS - 100810.1 - B 
         else do:
            if l_daybook_flag
            then do:
               if first-of(gltr_tr_type)
               then
                  put
                     gltr_tr_type at 16
                     gltr_dy_code at 75.

               if last-of(gltr_tr_type)
               then do:

                  {&GLDABRPA-P-TAG10}
                  {&GLDABRPA-P-TAG42}
                  put
                     et_trans-total-dr to 102
                     et_trans-total-cr to 124 skip.
                  {&GLDABRPA-P-TAG43}
                  {&GLDABRPA-P-TAG11}
                  assign
                     et_trans-total-cr = 0
                     et_trans-total-dr = 0.

               end. /*if last-of(gltr_tr_type)*/
            end. /* IF l_daybook_flag */
         end.  /* else do */
   SS - 100810.1 - E */

         if not l_skip_process
         then
         assign knt = knt + 1.
      end.  /* for each gltr_hist */

      {&GLDABRPA-P-TAG49}
      if (l_show_hidden
      and knt > 0
      and l_other_daybook)
      then do:
/* SS - 100810.1 - B 
         put "-------------------" to 102
             "-------------------" to 124
             skip
             {gplblfmt.i
              &FUNC=getTermLabel(""OTHER_DAYBOOKS"",35)
              &CONCAT = "':  '"
             }  to 74
              l_et_oth-total-dr to 102
              l_et_oth-total-cr to 124
              skip(1).
   SS - 100810.1 - E */
      end. /* IF l_show_hidden */

      {&GLDABRPA-P-TAG50}
      /* DISPLAY PERIOD TOTAL */
      {&GLDABRPA-P-TAG51}
      if knt > 0 then do:
         {&GLDABRPA-P-TAG52}
         {&GLDABRPA-P-TAG12}
         {&GLDABRPA-P-TAG44}
/* SS - 100810.1 - B 
         put "-------------------" to 102
             "-------------------" to 124
             skip
             et_per-total-dr to 102
             et_per-total-cr to 124 skip.
   SS - 100810.1 - E */
         {&GLDABRPA-P-TAG45}
         {&GLDABRPA-P-TAG13}
            act_to_dt = act_to_dt + et_per-total-dr - et_per-total-cr.

         {&GLDABRPA-P-TAG26}

         {&GLDABRPA-P-TAG27}
         assign
            et_act_to_dt = act_to_dt.

      end. /*if knt > 0 then do*/
      {&GLDABRPA-P-TAG53}
   end. /* FOR EACH glc_cal... */

   /* DISPLAY ENDING BALANCE */
   assign
      end_bal = beg_bal + act_to_dt
      et_end_bal = et_beg_bal + et_act_to_dt.

   {&GLDABRPA-P-TAG46}
/* SS - 100810.1 - B 
   put
      skip
      {gplblfmt.i
         &FUNC=getTermLabel(""ACTIVITY_TO_DATE"",35)
         &CONCAT = "': '"
      } at 2 begdt " - " enddt1

      et_act_to_dt to 74 skip

      {gplblfmt.i
         &FUNC=getTermLabel(""ENDING_BALANCE"",35)
         &CONCAT = "':   '"
      } at 2 enddt1

      et_end_bal to 74 skip(3).
   SS - 100810.1 - E */
   {&GLDABRPA-P-TAG47}

   if lookup(ac_type, "M,S") = 0 then do:
      assign
         beg_tot = beg_tot + beg_bal
         per_tot = per_tot + act_to_dt
         end_tot = end_tot + end_bal

         et_beg_tot = et_beg_tot + et_beg_bal
         et_per_tot = et_per_tot + et_act_to_dt
         et_end_tot = et_end_tot + et_end_bal.

   end.

end. /* IF ac_active or beg_bal <> 0 or ... */
{wbrp04.i}
{&GLDABRPA-P-TAG14}
