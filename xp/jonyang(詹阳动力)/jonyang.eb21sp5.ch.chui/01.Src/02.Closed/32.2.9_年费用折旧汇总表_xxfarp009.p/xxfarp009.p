/* xxfarp009.p 年费用折旧汇总表 */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* REVISION: 1.0      LAST MODIFIED: 2010/04/12   BY: Softspeed Roger Xiao */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100810.1  By: Roger Xiao */  /* 优先从xfa_hist,按期间,找定期费用faba_acctype = "3" 账户和成本中心*/

/*-Revision end------------------------------------------------------------*/

/*
各类型的区分标准,如下:
制造费用-折旧:"410515"开头的所有账户
销售费用-折旧:"550110"开头的所有账户
管理费用-折旧:"550209"开头的所有账户
辅助材料-折旧:仅"41030301"账户
租赁主机-折旧:仅"54010501"账户
其他账户的折旧不在报表范围内
*/

{mfdtitle.i "100810.1"}

define variable v_rptdate as date.
v_rptdate = date(month(today),01,year(today)) - 1. /*上月最后一天*/
define var v_end_lastyr    as character format "x(6)" no-undo. /*上年末*/
define var v_beg_thisyr    as character format "x(6)" no-undo. /*上年末*/
define var v_end_lastmth   as character format "x(6)" no-undo. /*上月末*/
define var perBeg          as character format "x(6)" no-undo. /*开始期间*/
define var perEnd          as character format "x(6)" no-undo. /*结束期间*/
define var perEnd2          as character format "x(6)" no-undo. /*结束期间*/


define variable l-entity  like fa_entity  no-undo.
define variable l-entity1 like fa_entity  no-undo.
define variable l-asset   like fa_id      no-undo.
define variable l-asset1  like fa_id      no-undo.
define variable l-yrper   like fabd_yrper no-undo.
define variable l-yrper1  like fabd_yrper no-undo.
define variable l-loc     like fa_faloc_id no-undo.
define variable l-loc1    like fa_faloc_id no-undo.
define variable l-class   like fa_facls_id no-undo.
define variable l-class1  like fa_facls_id no-undo.
define variable sub       like faba_sub     no-undo.
define variable sub1      like faba_sub     no-undo.
define variable l_error   as   integer      no-undo.

define var v_acct like faba_acct.
define var v_sub  like faba_sub .
define var v_cc   like faba_cc  .
define var l-asof-date      as   character  format "9999-99" no-undo.

define var v_life_yr    as decimal format ">>>>9.99" no-undo .
define var v_life_mth   as decimal format ">>>>9.99" no-undo .
define var v_mth_oldyr  as decimal format ">>>>9.99" no-undo .
define var v_mth_thisyr as decimal format ">>>>9.99" no-undo .
define var v_mth_total  as decimal format ">>>>9.99" no-undo .
define var v_mth_left   as decimal format ">>>>9.99" no-undo .
define var  v_amt_yr        like fab_salvamt no-undo.
define var  v_amt_mth2      like fab_salvamt no-undo.
define var  v_amt_mth       like fab_salvamt no-undo.
define var  v_amt_oldyr     like fab_salvamt no-undo.
define var  v_amt_before    like fab_salvamt no-undo.
define var  v_amt_thisyr    like fab_salvamt no-undo.
define var  v_amt_total     like fab_salvamt no-undo.
define var  v_amt_left      like fab_salvamt no-undo.
define var  v_amt_cost      like fab_salvamt no-undo.
define var v_clsdesc like facls_desc .


define temp-table temp1 
    field t1_type as char format "x(18)"
    field t1_desc as char format "x(28)"
    field t1_amt  like fab_salvamt extent 3 .


form
    SKIP(.2)
   sub       colon 25      label "费用明细账户"
   sub1      colon 42      label {t001.i}
   l-yrper   colon 25

   /*l-yrper1  colon 42      label {t001.i}*/

   skip(1)
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

/* ASSIGN l-yrper TO GL PERIOD FOR v_rptdate'S DATE */
{gprunp.i "fapl" "p" "fa-get-per"
  "(input  v_rptdate,
    input  """",
    output l-yrper,
    output l_error)"}

  /* ASSIGN yrPeriod TO v_rptdate'S DATE */
if l_error <> 0 then  l-yrper = string(year(v_rptdate), "9999") + string(month(v_rptdate), "99").

{wbrp01.i}
repeat:
    if l-entity1 = hi_char then l-entity1 = "".
    if l-asset1  = hi_char then l-asset1  = "".
    if l-yrper1  = hi_char then l-yrper1  = "".
    if l-loc1    = hi_char then l-loc1    = "".
    if l-class1  = hi_char then l-class1  = "".
    if sub1 = hi_char then sub1 = "".


    update  
        sub
        sub1
        l-yrper


    with frame a.

       
    if l-yrper      = ""  
       or length(l-yrper) <> 6 
    then do:
        message "错误:无效年度/期间,请重新输入" .
        undo,retry .
    end. /* IF l-yrper = "" */
    

    for first fabk_mstr
        fields( fabk_domain fabk_id fabk_post)
         where fabk_mstr.fabk_domain = global_domain and  fabk_post = yes
           and fabk_id > ""
    no-lock: end.
    if not available fabk_mstr then do:
        message "错误:未设定固定资产过账账目,请先设定" .
        undo,retry.
    end.


    if l-entity1 = ""       then l-entity1 = hi_char.
    if l-entity1 < l-entity then l-entity1 = l-entity.
    if l-asset1  = ""       then l-asset1  = hi_char.
    if l-asset1  < l-asset  then l-asset1  = l-asset.
    if l-yrper1  = ""       then l-yrper1  = hi_char.
    if l-yrper1  < l-yrper  then l-yrper1  = l-yrper.
    if l-loc1    = ""       then l-loc1    = hi_char.
    if l-loc1    < l-loc    then l-loc1    = l-loc.
    if l-class1  = ""       then l-class1  = hi_char.
    if l-class1  < l-class  then l-class1  = l-class.
    if sub1 = ""            then sub1 = hi_char.
    if sub1 < sub           then sub1 = sub.



    /* PRINTER SELECTION */
    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = "nopage"
                &stream = " "
                &appendToFile = " "
                &streamedOutputToTerminal = " "
                &withBatchOption = "yes"
                &displayStatementType = 1
                &withCancelMessage = "yes"
                &pageBottomMargin = 6
                &withEmail = "yes"
                &withWinprint = "yes"
                &defineVariables = "yes"}
mainloop: 
do on error undo, return error on endkey undo, return error:                    


    PUT UNFORMATTED "#def REPORTPATH=$/FA/xxfarp009" SKIP.
    PUT UNFORMATTED "#def :end" SKIP.

for each temp1: delete temp1 .  end.

v_end_lastyr  = string(integer(substring(l-yrper,1,4)) - 1) + "12" .
v_beg_thisyr  = substring(l-yrper,1,4) + "01" .
v_end_lastmth = if substring(l-yrper,5,2) = "01" then v_end_lastyr
                else substring(l-yrper,1,4) + string(integer(substring(l-yrper,5,2)) - 1,"99") .

for each fa_mstr 
        where fa_domain    = global_domain 
          and fa_entity   >= l-entity and  fa_entity <= l-entity1
          and fa_id       >= l-asset  and  fa_id     <= l-asset1
          and fa_faloc_id >= l-loc    and  fa_faloc_id <= l-loc1 
          and fa_facls_id >= l-class  and fa_facls_id <= l-class1
          and can-find(first  faba_det 
                            where faba_domain  = fa_domain 
                            and   faba_fa_id   = fa_id
                            and   faba_acctype = "3"  
                            and   faba_sub >= sub and faba_sub <= sub1
                        no-lock)  /*只表示曾经用过此sub,不代表现在*/
    no-lock
    break by fa_id :

    v_acct = "" .
    v_sub  = "" .
    v_cc   = "" .
    
    /*找定期费用账户acctype = "3"*/
    for last xfa_hist
        use-index xfa_expire
        where xfa_domain = global_domain 
        and   xfa_id     = fa_id 
        and   xfa_expire >= l-yrper
    no-lock:
    end.
    if avail xfa_hist then do:
        assign  v_acct = xfa_acct 
                v_sub  = xfa_sub 
                v_cc   = xfa_cc .
    end.
    else do:
        define var l-acct-seq like faba_glseq no-undo .
        l-acct-seq = 0 .
        for last faba_det use-index faba_fa_id where faba_domain = global_domain and  faba_fa_id = fa_id no-lock:
            l-acct-seq = faba_glseq.
        end.  
        find first faba_det 
            where faba_domain  = fa_domain 
            and   faba_fa_id   = fa_id
            and   faba_acctype = "3" 
            and   faba_glseq   = l-acct-seq 
        no-lock no-error .
        if not avail faba_det then next .
        if avail faba_det then assign  v_acct = faba_acct v_sub = faba_sub v_cc = faba_cc .
    end.

    if not (v_sub  >= sub  and v_sub  <= sub1 ) then next .


    /*确定存在过账账目对应的资产fab_det*/    
    find last fab_det 
        where fab_domain  = fa_domain 
        and   fab_fa_id   = fa_id
        and   fab_fabk_id = fabk_id
    no-lock no-error .
    if not avail fab_det then next .

    find first famt_mstr where famt_domain = global_domain and famt_id = fab_famt_id no-lock no-error .
    if (not avail famt_mstr ) or (available famt_mstr and not famt_active) then next .

    v_life_yr    = fab_life .
    v_life_mth   = 0 .
    v_mth_oldyr  = 0 .
    v_mth_thisyr = 0 .
    v_mth_total  = 0 .
    v_mth_left   = 0 .
    v_amt_yr     = 0 .
    v_amt_mth    = 0 .
    v_amt_oldyr  = 0 .
    v_amt_before = 0 .
    v_amt_thisyr = 0 .
    v_amt_total  = 0 .
    v_amt_cost   = 0 .
    v_amt_left   = 0 .

    /*查找最后一个期间*/
    {gprunp.i "fapl" "p" "fa-get-lastper"
          "(input  fab_fa_id,
            input  fab_fabk_id,
            output perEnd")} 

    /*服务日期所在期间,可能小于初始折旧期间*/
    {gprunp.i "fapl" "p" "fa-get-per"
          "(input  fab_date,
            input  """",
            output perBeg,
            output l_error)"}
    if l_error <> 0 then  perBeg = string(year(fab_date), "9999") + string(month(fab_date), "99").


    /*总折旧期间数--月数,famt_conv 留空*/
    {gprunp.i "fapl" "p" "fa-get-perinlife"
         "(input  perBeg,
           input  fab_life,
           input  """",
           input  famt_actualdays,
           input  """",
           input  fab_date,
           output v_life_mth)"}

    /*由寿命和起始月份,计算:理论结束期间*/
    {gprunp.i "xxfain02" "p" "get-perend-need"
          "(input  v_life_mth,
            input  famt_conv,
            input  perBeg,
            output perEnd2")}  
    perEnd = min(perEnd2,perEnd) .

    /*去年,今年折旧月数*/
    {gprunp.i "xxfain01" "p" "get-mth-used"
          "(input  v_life_mth,
            input  famt_conv,
            input  perBeg,
            input  perEnd,
            input  l-yrper,
            output v_mth_oldyr,
            output v_mth_thisyr")}  

    v_mth_total  = v_mth_oldyr + v_mth_thisyr .
    v_mth_left   = max(0,v_life_mth - v_mth_total) .

    /*总成本*/
    {gprunp.i "fapl" "p" "fa-get-cost"
         "(input  fa_id,
           input  fabk_id,
           output v_amt_cost)"}

    /*上一年末,所有累计折旧*/
    {gprunp.i "fapl" "p" "fa-get-perdep-range"
          "(input  fa_id,
            input  fabk_id,
            input  perBeg,
            input  v_end_lastyr,
            output v_amt_oldyr)"}
    /*上月末,本年累计折旧*/
    {gprunp.i "fapl" "p" "fa-get-perdep-range"
          "(input  fa_id,
            input  fabk_id,
            input  v_beg_thisyr,
            input  v_end_lastmth,
            output v_amt_before)"}
    /*本月末,本年累计折旧*/
    {gprunp.i "fapl" "p" "fa-get-perdep-range"
          "(input  fa_id,
            input  fabk_id,
            input  v_beg_thisyr,
            input  l-yrper,
            output v_amt_thisyr)"}
    /*本月末,所有累计折旧*/
    {gprunp.i "fapl" "p" "fa-get-perdep-range"
          "(input  fa_id,
            input  fabk_id,
            input  perBeg,
            input  l-yrper,
            output v_amt_total)"}

    /*月折旧(本月)*/
    {gprunp.i "fapl" "p" "fa-get-perdep-range"
          "(input  fa_id,
            input  fabk_id,
            input  l-yrper,
            input  l-yrper,
            output v_amt_mth)"}

    /*平均年折旧,月折旧*/
    v_amt_yr   = if v_life_yr  <> 0 then round(v_amt_cost / v_life_yr,2)  else 0  .
    v_amt_mth2 = if v_life_mth <> 0 then round(v_amt_cost / v_life_mth,2)  else 0 .

    /*净值*/
    v_amt_left   = max(0,v_amt_cost - v_amt_total) .




/*
各类型的区分标准,如下:
制造费用-折旧:"410515"开头的所有账户
销售费用-折旧:"550110"开头的所有账户
管理费用-折旧:"550209"开头的所有账户
辅助材料-折旧:仅"41030301"账户
租赁主机-折旧:仅"54010501"账户
其他账户的折旧不在报表范围内
*/


/*temp1-Begin**********************************/        
    if v_sub begins "410515" or v_sub begins "550110" or v_sub begins "550209" then do:
        /*t1_type = sub账户前6码 */
        find first temp1 where t1_type = substring(v_sub,1,6) no-error .
        if not avail temp1 then do:
            find first sb_mstr 
                where sb_domain = global_domain 
                and sb_sub begins substring(v_sub,1,6) 
            no-lock no-error .

            create temp1 .
            assign t1_type = substring(v_sub,1,6)
                   t1_desc = if avail sb_mstr then sb_desc else substring(v_sub,1,6)
                   .
        end.
        assign 
        t1_amt[1] = t1_amt[1] + v_amt_before /*本年,本月前*/     
        t1_amt[2] = t1_amt[2] + v_amt_mth    /*本年,本月*/       
        t1_amt[3] = t1_amt[3] + v_amt_thisyr  /*本年,本月止*/     
        .     
        if l-yrper begins "2010" then 
            assign t1_amt[1] = t1_amt[1] + v_amt_oldyr 
                   t1_amt[3] = t1_amt[3] + v_amt_oldyr .
    end. /*if v_sub begins*/
    else if v_sub = "41030301" or v_sub = "54010501" then do:
        /*t1_type = sub账户 */        
        find first temp1 where t1_type = v_sub no-error .
        if not avail temp1 then do:
            find first sb_mstr 
                where sb_domain = global_domain 
                and sb_sub = v_sub 
            no-lock no-error .
            
            create temp1 .
            assign t1_type = v_sub
                   t1_desc = if avail sb_mstr then sb_desc else v_sub 
                   .
        end.
        assign 
        t1_amt[1] = t1_amt[1] + v_amt_before /*本年,本月前*/     
        t1_amt[2] = t1_amt[2] + v_amt_mth    /*本年,本月*/       
        t1_amt[3] = t1_amt[3] + v_amt_thisyr  /*本年,本月止*/     
        .     
        if l-yrper begins "2010" then 
            assign t1_amt[1] = t1_amt[1] + v_amt_oldyr 
                   t1_amt[3] = t1_amt[3] + v_amt_oldyr .
    end. /*else if v_sub =*/    
/*temp1-End**********************************/  


end. /*for each fa_mstr*/


for each temp1 break by t1_type :
    export  delimiter ";"
            t1_desc + "(" + t1_type + ")"

            t1_amt[1]  /*本年,本月前*/
            t1_amt[2]  /*本年,本月*/
            t1_amt[3]  /*本年,本月止*/
            ""
            l-yrper
            .    
end. /*for each temp1*/



end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}



