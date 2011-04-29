/* xxfarp010.p 固定资产新增汇总表 */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* REVISION: 1.0      LAST MODIFIED: 2010/04/12   BY: Softspeed Roger Xiao */
/*-Revision end------------------------------------------------------------*/

{mfdtitle.i "100412.1"}

define variable v_rptdate as date.
v_rptdate = date(month(today),01,year(today)) - 1. /*上月最后一天*/


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

define var v_acct like faba_acct.
define var v_sub  like faba_sub .
define var v_cc   like faba_cc  .
define var l-asof-date      as   character  format "9999-99" no-undo.

define var v_clsdesc like facls_desc .
define var  v_ii as integer .
define var  v_amt_cost      like fab_salvamt no-undo.
define var  v_amt_thisyr    like fab_salvamt no-undo.
define var  v_amt_totalyr   like fab_salvamt no-undo.
define var  v_amt_bymth     like fab_salvamt extent 12 no-undo.
define var  v_amt_totalmth  like fab_salvamt extent 12 no-undo.


form
    SKIP(.2)

   l-class   colon 25
   l-class1  colon 42      label {t001.i}
   l-yrper   colon 25

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

    update  
        l-class
        l-class1
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


PUT UNFORMATTED "#def REPORTPATH=$/FA/xxfarp010" SKIP.
PUT UNFORMATTED "#def :end" SKIP.

v_amt_totalyr  = 0 .
v_amt_totalmth = 0 .
for each fa_mstr 
        where fa_domain    = global_domain 
          and fa_facls_id >= l-class  and fa_facls_id <= l-class1
          and string(year(fa_startdt),"9999")   = substring(l-yrper,1,4) /*仅限本年*/
          and string(month(fa_startdt),"99")   <= substring(l-yrper,5,2) /*仅限本期间之前*/
    no-lock,
    each facls_mstr 
        where facls_domain    = global_domain 
          and facls_id        = fa_facls_id 
    no-lock
    break by facls_id by fa_id :

    if first-of(facls_id) then do:
        v_amt_bymth  = 0.
        v_amt_thisyr = 0.

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

        v_clsdesc = facls_desc + "-" + v_acct . /*同类别的acct相同,取第一个资产的即可 ? */        

    end. /*if first-of(facls_id)*/

    /*取得成本值*/
    {gprunp.i "fapl" "p" "fa-get-cost"
         "(input  fa_id,
           input  fabk_id,
           output v_amt_cost)"}
    
    v_ii = 0 .
    do v_ii = 1 to integer(substring(l-yrper,5,2)):
        if month(fa_startdt) = v_ii then v_amt_bymth[v_ii] = v_amt_bymth[v_ii] + v_amt_cost .
    end. /*do v_ii =*/



    if last-of(facls_id) then do:
        
        v_ii = 0 .
        do v_ii = 1 to integer(substring(l-yrper,5,2)):
            v_amt_thisyr = v_amt_thisyr + v_amt_bymth[v_ii] .
            v_amt_totalmth[v_ii] = v_amt_totalmth[v_ii] + v_amt_bymth[v_ii] .
        end. /*do v_ii =*/

        v_amt_totalyr = v_amt_totalyr + v_amt_thisyr .

        export  delimiter ";"
            v_clsdesc
            v_sub
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
            v_amt_thisyr 
            ""
            ""
            l-yrper
            .

    end. /*if last-of(facls_id)*/


    if last(facls_id) then do:
        
        export  delimiter ";"
            "总计"
            ""
            v_amt_totalmth[01]
            v_amt_totalmth[02]
            v_amt_totalmth[03]
            v_amt_totalmth[04]
            v_amt_totalmth[05]
            v_amt_totalmth[06]
            v_amt_totalmth[07]
            v_amt_totalmth[08]
            v_amt_totalmth[09]
            v_amt_totalmth[10]
            v_amt_totalmth[11]
            v_amt_totalmth[12]
            v_amt_totalyr   
            ""
            ""
            l-yrper
            .

    end. /*if last(facls_id)*/
    
end. /*for each fa_mstr*/


end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}



