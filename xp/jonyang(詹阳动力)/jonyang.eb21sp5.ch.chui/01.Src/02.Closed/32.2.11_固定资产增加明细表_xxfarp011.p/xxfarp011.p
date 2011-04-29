/* xxfarp011.p 固定资产增加明细表 */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* REVISION: 1.0      LAST MODIFIED: 2010/04/12   BY: Softspeed Roger Xiao */
/*-Revision end------------------------------------------------------------*/

{mfdtitle.i "100412.1"}

define variable v_rptdate as date.
v_rptdate = date(month(today),01,year(today)) - 1. /*上月最后一天*/

define variable l-facode  like fa_code    no-undo.
define variable l-facode1 like fa_code    no-undo.
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
define variable l-book    like fabk_id     no-undo.
define variable l-book1   like fabk_id     no-undo.
define variable l_error   as   integer      no-undo.

define var v_ii   as integer label "序号" .
define var v_acct like faba_acct.
define var v_sub  like faba_sub .
define var v_cc   like faba_cc  .
define var v_clsdesc like facls_desc .
define var  v_amt_cost      like fab_salvamt no-undo.




form
    SKIP(.2)
   l-class   colon 25
   l-class1  colon 42      label {t001.i}
   l-yrper   colon 25
   l-yrper1  colon 42      label {t001.i}

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

l-yrper1 = l-yrper.

{wbrp01.i}
repeat:
    if l-book1 = hi_char then l-book1 = "".
    if l-class1  = hi_char then l-class1  = "".
    if l-facode1 = hi_char then l-facode1  = "".
    if l-yrper1  = hi_char then l-yrper1  = "".
    if l-loc1    = hi_char then l-loc1    = "".

    update  
        l-class
        l-class1
        l-yrper
        l-yrper1

    with frame a.

    if l-yrper      = ""  
       or length(l-yrper) <> 6 
    then do:
        message "错误:无效年度/期间,请重新输入" .
        undo,retry .
    end.     /* IF l-yrper = "" */
    
    if l-yrper1      = ""  
       or length(l-yrper1) <> 6 
    then do:
        message "错误:无效年度/期间,请重新输入" .
        undo,retry .
    end.     /* IF l-yrper = "" */

    for first fabk_mstr
        fields( fabk_domain fabk_id fabk_post)
         where fabk_mstr.fabk_domain = global_domain and  fabk_post = yes
           and fabk_id > ""
    no-lock: end.
    if not available fabk_mstr then do:
        message "错误:未设定固定资产过账账目,请先设定" .
        undo,retry.
    end.

    if l-book1 = ""         then l-book1 = hi_char.
    if l-book1 < l-book     then l-book1 = l-book.
    if l-class1  = ""       then l-class1  = hi_char.
    if l-class1  < l-class  then l-class1  = l-class.
    if l-facode1 = ""       then l-facode1  = hi_char.
    if l-facode1 < l-facode then l-facode1  = l-facode.
    if l-yrper1  = ""       then l-yrper1  = hi_char.
    if l-yrper1  < l-yrper  then l-yrper1  = l-yrper.
    if l-loc1    = ""       then l-loc1    = hi_char.
    if l-loc1    < l-loc    then l-loc1    = l-loc.



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


    PUT UNFORMATTED "#def REPORTPATH=$/FA/xxfarp011" SKIP.
    PUT UNFORMATTED "#def :end" SKIP.

v_ii = 0 .
for each fa_mstr 
        where fa_domain    = global_domain 
          and fa_facls_id >= l-class  and fa_facls_id <= l-class1
          and string(year(fa_startdt),"9999") + string(month(fa_startdt),"99") >= l-yrper
          and string(year(fa_startdt),"9999") + string(month(fa_startdt),"99") <= l-yrper1
    no-lock
    break by fa_id :

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


   find first facls_mstr
        where facls_domain = global_domain 
        and facls_id  = fa_facls_id
    no-lock no-error .
    v_clsdesc = if avail facls_mstr then facls_desc else "" .

    {gprunp.i "fapl" "p" "fa-get-cost"
         "(input  fa_id,
           input  fabk_id,
           output v_amt_cost)"}

    /*取得固定资产的通用代码说明*/
    {xxfarpcode.i}

    export  delimiter ";"
        fa_startdt
        fa_id
        v_clsdesc
        fa_auth_number
        fa_desc1
        fa_ins_co
        if fa__dte01 = ? then "" else string(year(fa__dte01),"9999") + "/" + string(month(fa__dte01),"99") + "/" + string(day(fa__dte01),"99")
        if fa__dte02 = ? then "" else string(year(fa__dte02),"9999") + "/" + string(month(fa__dte02),"99") + "/" + string(day(fa__dte02),"99")
        v_facode        
        v_cc  
        fa_custodian
        v_amt_cost
        l-yrper       /*报表期间*/
        l-yrper1      /*报表期间*/
        .

end. /*for each fa_mstr*/


end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}



