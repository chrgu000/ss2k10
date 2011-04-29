/* xxfarp012.p 技改设备购置固定资产 */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* REVISION: 1.0      LAST MODIFIED: 2010/04/12   BY: Softspeed Roger Xiao */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100813.1  By: Roger Xiao */  /*不管输入什么账簿,输出的购买原值,都是ACC帐的成本 ,但是如果某资产输入的账簿不存在,则记录不显示*/

/*-Revision end------------------------------------------------------------*/
{mfdtitle.i "100813.1"}

define variable v_rptdate as date.
v_rptdate = date(month(today),01,year(today)) - 1. /*上月最后一天*/
define var v_end_lastyr    as character format "x(6)" no-undo. /*上年末*/
define var v_beg_thisyr    as character format "x(6)" no-undo. /*上年末*/
define var v_end_lastmth   as character format "x(6)" no-undo. /*上月末*/
define var perBeg          as character format "x(6)" no-undo. /*开始期间*/
define var perEnd          as character format "x(6)" no-undo. /*结束期间*/
define var perEnd2          as character format "x(6)" no-undo. /*结束期间*/

define variable l-book       like fabk_id     no-undo.
define variable l-book1      like fabk_id     no-undo.
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
define variable l_error   as   integer      no-undo.
define var v_date      as date .
define var v_date1     as date .
define var v_rsn       as char format "x(10)".
define var v_rsn1      as char format "x(10)".
define var v_all       as logical format "Y)包含已报废 /N)不包含已报废" initial yes.

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

define var  v_amt_cost_acc  like fab_salvamt no-undo.
define var  v_post_bk       like fabk_id no-undo.

define var v_ii as integer .
define var v_amt_bymth     like fab_salvamt extent 12 no-undo.
define var v_tmp_amt       like fab_salvamt no-undo.

define var v_startmth    as char .

form
    SKIP(.2)

   l-book    colon 25
 /*l-book1   colon 42      label {t001.i}*/

   l-entity  colon 25
   l-entity1 colon 42      label {t001.i}
   l-asset   colon 25
   l-asset1  colon 42      label {t001.i}
   l-loc     colon 25
   l-loc1    colon 42      label {t001.i}
   l-class   colon 25
   l-class1  colon 42      label {t001.i}
   v_date    colon 25      label "投入使用日期"
   v_date1   colon 42      label {t001.i}

   l-yrper   colon 25
   v_all     colon 25 label "包含已报废资产Y/N"
   
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
    if v_rsn1    = hi_char then v_rsn1  = "".
    if v_date    = low_date  then v_date   = ? .
    if v_date1   = hi_date   then v_date1  = ? .
    if l-book1   = hi_char then l-book1   = "".

    update  
        l-book  
        l-entity
        l-entity1
        l-asset
        l-asset1
        l-loc
        l-loc1
        l-class
        l-class1
        v_date   
        v_date1 
        l-yrper
        v_all

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
    v_post_bk = fabk_id .

    for first fabk_mstr
        fields( fabk_domain fabk_id fabk_post)
         where fabk_mstr.fabk_domain = global_domain 
         and   fabk_id = l-book 
    no-lock: end.
    if not available fabk_mstr then do:
        message "错误:未设定技改资产账目,请先设定" .
        undo,retry.
    end.

    if l-book1   = ""       then l-book1   = hi_char.
    if l-book1   < l-book   then l-book1   = l-book.
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

    if v_rsn1   = ""        then v_rsn1  = hi_char.
    if v_rsn1   < v_rsn     then v_rsn1  = v_rsn.
    if v_date    = ?        then v_date   = low_date .
    if v_date1   = ?        then v_date1  = hi_date .
    if v_date1   < v_date   then v_date1  = v_date .



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


    PUT UNFORMATTED "#def REPORTPATH=$/FA/xxfarp012" SKIP.
    PUT UNFORMATTED "#def :end" SKIP.


v_end_lastyr  = string(integer(substring(l-yrper,1,4)) - 1) + "12" .
v_beg_thisyr  = substring(l-yrper,1,4) + "01" .
v_end_lastmth = if substring(l-yrper,5,2) = "01" then v_end_lastyr
                else substring(l-yrper,1,4) + string(integer(substring(l-yrper,5,2)) - 1,"99") .

l-asof-date  = "" .

for each fa_mstr 
        where fa_domain    = global_domain 
        and fa_entity   >= l-entity and  fa_entity   <= l-entity1
        and fa_id       >= l-asset  and  fa_id       <= l-asset1
        and fa_faloc_id >= l-loc    and  fa_faloc_id <= l-loc1 
        and fa_facls_id >= l-class  and fa_facls_id  <= l-class1
        and fa_startdt  >= v_date   and fa_startdt   <= v_date1
        and fa__chr01   = "C01"  /*是否已技改: C01 技改 C99 非技改*/
        and (v_all = yes 
              or (fa_disp_dt = ? 
                  or (fa_disp_dt <> ? and string(year(fa_disp_dt), "9999") + string(month(fa_disp_dt), "99") > l-yrper )))
    no-lock
    break by date(month(fa_startdt),01,year(fa_startdt)) by fa_id :

    v_acct = "" .
    v_sub  = "" .
    v_cc   = "" .
    
    /*找资产账户acctype = "1"*/
    define var l-acct-seq like faba_glseq no-undo .
    l-acct-seq = 0 .
    for last faba_det use-index faba_fa_id where faba_domain = global_domain and  faba_fa_id = fa_id no-lock:
        l-acct-seq = faba_glseq.
    end.  
    find first faba_det 
        where faba_domain  = fa_domain 
        and   faba_fa_id   = fa_id
        and   faba_acctype = "1" 
        and   faba_glseq   = l-acct-seq 
    no-lock no-error .
    if avail faba_det then assign  v_acct = faba_acct v_sub = faba_sub v_cc = faba_cc .

    /*确定存在对应的资产fab_det*/    
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
    v_amt_bymth  = 0 .

    v_amt_cost_acc  = 0 .

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


    /*总折旧期间数--月数*/
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

    /*总成本*/
    {gprunp.i "fapl" "p" "fa-get-cost"
         "(input  fa_id,
           input  v_post_bk,
           output v_amt_cost_acc)"}

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

    /*各月折旧*/
    v_ii = 0 .
    l-asof-date = "" .
    v_tmp_amt = 0.
    do v_ii = 1 to integer(substring(l-yrper,5,2)) :
        l-asof-date = substring(l-yrper,1,4) + string(v_ii,"99") .
        {gprunp.i "fapl" "p" "fa-get-perdep-range"
              "(input  fa_id,
                input  fabk_id,
                input  l-asof-date,
                input  l-asof-date,
                output v_tmp_amt)"}
        v_amt_bymth[v_ii] = v_tmp_amt .
    end.

    {xxfastart1.i} /*v_startdt折旧初始月份*/
                 .

    export  delimiter ";"
        substring(fa_faloc_id,3)
        fa_id
        fa_desc1
        fa__dec01
        v_amt_cost_acc /**fa__dec01*技改金额*/
        /*购买日期*/ if fa__dte01 = ? then "" else string(year(fa__dte01),"9999") + "/" + string(month(fa__dte01),"99") + "/" + string(day(fa__dte01),"99")
        /*启用日期*/ if fa__dte02 = ? then "" else string(year(fa__dte02),"9999") + "/" + string(month(fa__dte02),"99") + "/" + string(day(fa__dte02),"99")
        v_startdt
        v_life_yr
        v_life_yr * 12 
        v_mth_oldyr
        v_mth_thisyr
        v_mth_total
        v_mth_left
        v_amt_mth2
        v_amt_yr
        v_amt_oldyr
        v_amt_bymth[01]
        v_amt_bymth[02]
        v_amt_bymth[03]
        v_amt_bymth[04]
        v_amt_bymth[05]
        v_amt_bymth[06]
        v_amt_bymth[07]
        v_amt_bymth[08]
        v_amt_bymth[09]
        v_amt_bymth[10]
        v_amt_bymth[11]
        v_amt_bymth[12]
        v_amt_thisyr        /*当年所提折旧*/        
        v_amt_total         /*全部所提折旧额*/      
        v_amt_left          /*净值*/  
        ""
        l-yrper
        .
    accum fa__dec01         (total by date(month(fa_startdt),01,year(fa_startdt))).
    accum v_amt_cost_acc        (total by date(month(fa_startdt),01,year(fa_startdt))).
    accum v_amt_mth2        (total by date(month(fa_startdt),01,year(fa_startdt))).
    accum v_amt_yr          (total by date(month(fa_startdt),01,year(fa_startdt))).
    accum v_amt_oldyr       (total by date(month(fa_startdt),01,year(fa_startdt))).
    accum v_amt_bymth[01]   (total by date(month(fa_startdt),01,year(fa_startdt))).
    accum v_amt_bymth[02]   (total by date(month(fa_startdt),01,year(fa_startdt))).
    accum v_amt_bymth[03]   (total by date(month(fa_startdt),01,year(fa_startdt))).
    accum v_amt_bymth[04]   (total by date(month(fa_startdt),01,year(fa_startdt))).
    accum v_amt_bymth[05]   (total by date(month(fa_startdt),01,year(fa_startdt))).
    accum v_amt_bymth[06]   (total by date(month(fa_startdt),01,year(fa_startdt))).
    accum v_amt_bymth[07]   (total by date(month(fa_startdt),01,year(fa_startdt))).
    accum v_amt_bymth[08]   (total by date(month(fa_startdt),01,year(fa_startdt))).
    accum v_amt_bymth[09]   (total by date(month(fa_startdt),01,year(fa_startdt))).
    accum v_amt_bymth[10]   (total by date(month(fa_startdt),01,year(fa_startdt))).
    accum v_amt_bymth[11]   (total by date(month(fa_startdt),01,year(fa_startdt))).
    accum v_amt_bymth[12]   (total by date(month(fa_startdt),01,year(fa_startdt))).
    accum v_amt_thisyr      (total by date(month(fa_startdt),01,year(fa_startdt))).
    accum v_amt_total       (total by date(month(fa_startdt),01,year(fa_startdt))).
    accum v_amt_left        (total by date(month(fa_startdt),01,year(fa_startdt))).

    accum fa__dec01         (total).
    accum v_amt_cost_acc        (total).
    accum v_amt_mth2        (total).
    accum v_amt_yr          (total).
    accum v_amt_oldyr       (total).
    accum v_amt_bymth[01]   (total).
    accum v_amt_bymth[02]   (total).
    accum v_amt_bymth[03]   (total).
    accum v_amt_bymth[04]   (total).
    accum v_amt_bymth[05]   (total).
    accum v_amt_bymth[06]   (total).
    accum v_amt_bymth[07]   (total).
    accum v_amt_bymth[08]   (total).
    accum v_amt_bymth[09]   (total).
    accum v_amt_bymth[10]   (total).
    accum v_amt_bymth[11]   (total).
    accum v_amt_bymth[12]   (total).
    accum v_amt_thisyr      (total).
    accum v_amt_total       (total).
    accum v_amt_left        (total).


    if last-of(date(month(fa_startdt),01,year(fa_startdt))) then do:
        export  delimiter ";"
            ""
            "小计"
            string(year(fa_startdt),"9999") + "-" + string(month(fa_startdt),"99")
            accum total by date(month(fa_startdt),01,year(fa_startdt)) fa__dec01   
            accum total by date(month(fa_startdt),01,year(fa_startdt)) v_amt_cost_acc   
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            accum total by date(month(fa_startdt),01,year(fa_startdt))  v_amt_mth2       
            accum total by date(month(fa_startdt),01,year(fa_startdt))  v_amt_yr        
            accum total by date(month(fa_startdt),01,year(fa_startdt))  v_amt_oldyr     
            accum total by date(month(fa_startdt),01,year(fa_startdt))  v_amt_bymth[01] 
            accum total by date(month(fa_startdt),01,year(fa_startdt))  v_amt_bymth[02] 
            accum total by date(month(fa_startdt),01,year(fa_startdt))  v_amt_bymth[03] 
            accum total by date(month(fa_startdt),01,year(fa_startdt))  v_amt_bymth[04] 
            accum total by date(month(fa_startdt),01,year(fa_startdt))  v_amt_bymth[05] 
            accum total by date(month(fa_startdt),01,year(fa_startdt))  v_amt_bymth[06] 
            accum total by date(month(fa_startdt),01,year(fa_startdt))  v_amt_bymth[07] 
            accum total by date(month(fa_startdt),01,year(fa_startdt))  v_amt_bymth[08] 
            accum total by date(month(fa_startdt),01,year(fa_startdt))  v_amt_bymth[09] 
            accum total by date(month(fa_startdt),01,year(fa_startdt))  v_amt_bymth[10] 
            accum total by date(month(fa_startdt),01,year(fa_startdt))  v_amt_bymth[11] 
            accum total by date(month(fa_startdt),01,year(fa_startdt))  v_amt_bymth[12] 
            accum total by date(month(fa_startdt),01,year(fa_startdt))  v_amt_thisyr    
            accum total by date(month(fa_startdt),01,year(fa_startdt))  v_amt_total     
            accum total by date(month(fa_startdt),01,year(fa_startdt))  v_amt_left      
            ""
            l-yrper
            .

    end. /*if last-of(date(month*/

    if last(date(month(fa_startdt),01,year(fa_startdt))) then do:

    end. /*if last(date(month*/


end. /*for each fa_mstr*/
        export  delimiter ";"
            ""
            "总计"
            "ALL"
            accum total fa__dec01          
            accum total v_amt_cost_acc          
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            accum total v_amt_mth2         
            accum total v_amt_yr          
            accum total v_amt_oldyr       
            accum total v_amt_bymth[01]   
            accum total v_amt_bymth[02]   
            accum total v_amt_bymth[03]   
            accum total v_amt_bymth[04]   
            accum total v_amt_bymth[05]   
            accum total v_amt_bymth[06]   
            accum total v_amt_bymth[07]   
            accum total v_amt_bymth[08]   
            accum total v_amt_bymth[09]   
            accum total v_amt_bymth[10]   
            accum total v_amt_bymth[11]   
            accum total v_amt_bymth[12]   
            accum total v_amt_thisyr      
            accum total v_amt_total       
            accum total v_amt_left      
            ""
            l-yrper
            .


end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}



