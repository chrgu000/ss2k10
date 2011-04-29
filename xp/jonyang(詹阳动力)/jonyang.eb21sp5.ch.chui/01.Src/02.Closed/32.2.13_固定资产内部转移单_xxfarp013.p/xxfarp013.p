/* xxfarp013.p 固定资产内部转移单 */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* REVISION: 1.0      LAST MODIFIED: 2010/04/12   BY: Softspeed Roger Xiao */
/*-Revision end------------------------------------------------------------*/

{mfdtitle.i "100412.1"}

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
define variable l_error   as   integer      no-undo.
define var v_date      as date .
define var v_date1     as date .
define var v_rsn       as char format "x(10)".
define var v_rsn1      as char format "x(10)".

define var v_acct like faba_acct.
define var v_sub  like faba_sub .
define var v_cc   like faba_cc  .
define var v_locname    like faloc_desc no-undo.
define var v_amt_post      like fab_salvamt no-undo.
define var v_amt_cost      like fab_salvamt no-undo.
define var v_amt_left      like fab_salvamt no-undo.
define var v_amt_mth       like fab_salvamt no-undo.
define var v_life_mth   as decimal format ">>>>9.99" no-undo .
define var v_mth_oldyr  as decimal format ">>>>9.99" no-undo .
define var v_mth_thisyr as decimal format ">>>>9.99" no-undo .
define var v_mth_total  as decimal format ">>>>9.99" no-undo .
define var v_mth_left   as decimal format ">>>>9.99" no-undo .


form
    SKIP(.2)

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


    update  
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


    PUT UNFORMATTED "#def REPORTPATH=$/FA/xxfarp013" SKIP.
    PUT UNFORMATTED "#def :end" SKIP.

v_end_lastyr  = string(integer(substring(l-yrper,1,4)) - 1) + "12" .
v_beg_thisyr  = substring(l-yrper,1,4) + "01" .
v_end_lastmth = if substring(l-yrper,5,2) = "01" then v_end_lastyr
                else substring(l-yrper,1,4) + string(integer(substring(l-yrper,5,2)) - 1,"99") .

v_amt_post   = 0. 
v_amt_cost  = 0.
v_amt_left   = 0.

for each fa_mstr 
        where fa_domain    = global_domain 
        and fa_entity   >= l-entity and  fa_entity   <= l-entity1
        and fa_id       >= l-asset  and  fa_id       <= l-asset1
        and fa_faloc_id >= l-loc    and  fa_faloc_id <= l-loc1 
        and fa_facls_id >= l-class  and fa_facls_id  <= l-class1
        and fa_startdt  >= v_date   and fa_startdt   <= v_date1
        and fa_disp_dt = ? 
    no-lock
    break by fa_id :

    find first faloc_mstr where faloc_domain = global_domain and faloc_id = fa_faloc_id no-lock no-error .
    v_locname = if avail faloc_mstr then faloc_desc else fa_faloc_id .

    /*确定存在过账账目对应的资产fab_det*/    
    find last fab_det 
        where fab_domain  = fa_domain 
        and   fab_fa_id   = fa_id
        and   fab_fabk_id = fabk_id
    no-lock no-error .
    if not avail fab_det then next .

    find first famt_mstr where famt_domain = global_domain and famt_id = fab_famt_id no-lock no-error .
    if (not avail famt_mstr ) or (available famt_mstr and not famt_active) then next .

    v_life_mth   = 0 .
    v_mth_oldyr  = 0 .
    v_mth_thisyr = 0 .
    v_mth_total  = 0 .
    v_mth_left   = 0 .
    v_amt_mth    = 0 .
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

    /*本月末,所有累计折旧*/
    {gprunp.i "fapl" "p" "fa-get-perdep-range"
          "(input  fa_id,
            input  fabk_id,
            input  perBeg,
            input  l-yrper,
            output v_amt_post)"}
    /*净值*/
    v_amt_left   = max(0,v_amt_cost - v_amt_post) .

    /*月折旧(本月)*/
    {gprunp.i "fapl" "p" "fa-get-perdep-range"
          "(input  fa_id,
            input  fabk_id,
            input  l-yrper,
            input  l-yrper,
            output v_amt_mth)"}    

    export  delimiter ";"
            fa_id
            fa_desc1
            v_locname 
            substring(fa_faloc_id,2)
            if fa__dte02 = ? then "" else string(year(fa__dte02),"9999") + "/" + string(month(fa__dte02),"99") + "/" + string(day(fa__dte02),"99")
            v_amt_cost
            v_amt_left
            v_amt_mth
            v_mth_left
            .

   
end. /*for each fa_mstr*/


end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}



