/* xxfarp006.p 固定资产当月计提折旧 */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* REVISION: 1.0      LAST MODIFIED: 2010/04/12   BY: Softspeed Roger Xiao */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100810.1  By: Roger Xiao */  /* 优先从xfa_hist,按期间,找定期费用faba_acctype = "3" 账户和成本中心*/

/*-Revision end------------------------------------------------------------*/

/*
1.程式已写成固定格式
    1.列是固定的,如需修改一定要修改程式的:"各列赋值" !!!!
    2.行不固定,调整BI格式即可,增加行,复制公式,不需修改程式!
2.报表分为三大段落:
    管理费用,销售费用+租赁,制造费用.

3.各段落的区分标准,同xxfarp009.p,如下:
    制造费用-折旧:"410515"开头的所有账户   
    销售费用-折旧:"550110"开头的所有账户   
    管理费用-折旧:"550209"开头的所有账户   
    辅助材料-折旧:仅"41030301"账户      (006.p不含此类折旧,见007.p) 
    租赁主机-折旧:仅"54010501"账户         
    其他账户的折旧不在报表范围内
*/




{mfdtitle.i "100810.1"}

define variable v_rptdate as date.
v_rptdate = date(month(today),01,year(today)) - 1. /*上月最后一天*/

define variable l-entity  like fa_entity  no-undo.
define variable l-entity1 like fa_entity  no-undo.
define variable l-yrper   like fabd_yrper no-undo.
define variable l-yrper1  like fabd_yrper no-undo.
define variable acc       like ac_code  no-undo.
define variable acc1      like ac_code  no-undo.
define variable sub       like sb_sub  no-undo.
define variable sub1      like sb_sub  no-undo.
define variable ctr       like cc_ctr  no-undo.
define variable ctr1      like cc_ctr  no-undo.
define variable l_error   as   integer      no-undo.

define var v_acct like faba_acct.
define var v_sub  like faba_sub .
define var v_cc   like faba_cc  .
define var v_name like pt_desc1    no-undo .

define var  v_amt_mth       like fab_salvamt no-undo.

define var v_amt      like gltr_curramt  .
define var v_put      like gltr_curramt extent 15 .
define var i-sub      like faba_sub     extent 15 .


define temp-table temp1 
    field t1_ctr  like gltr_ctr
    field t1_sub  like gltr_sub
    field t1_amt  like gltr_amt.


form
    SKIP(.2)
   l-entity  colon 25
   l-entity1 colon 42      label {t001.i}
   acc       colon 25
   acc1      colon 42      label {t001.i}
   sub       colon 25
   sub1      colon 42      label {t001.i}
   ctr       colon 25
   ctr1      colon 42      label {t001.i}
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
    if acc1 = hi_char      then assign acc1 = "".
    if sub1 = hi_char      then assign sub1 = "".
    if ctr1 = hi_char      then assign ctr1 = "".
    if l-entity1 = hi_char then l-entity1 = "".

    update  
        l-entity  
        l-entity1 
        acc       
        acc1      
        sub       
        sub1      
        ctr       
        ctr1      
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


    if acc1 = "" then assign acc1 = hi_char.
    if sub1 = "" then assign sub1 = hi_char.
    if ctr1 = "" then assign ctr1 = hi_char.
    if l-entity1 = ""       then l-entity1 = hi_char.
    if l-entity1 < l-entity then l-entity1 = l-entity.


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


PUT UNFORMATTED "#def REPORTPATH=$/FA/xxfarp006" SKIP.
PUT UNFORMATTED "#def :end" SKIP.

for each temp1: delete temp1. end.

for each fa_mstr 
    where fa_domain = global_domain 
    and fa_entity >= l-entity and fa_entity <= l-entity1
    and fa_disp_dt = ? or (fa_disp_dt <> ? and string(year(fa_disp_dt), "9999") + string(month(fa_disp_dt), "99") >= l-yrper )
    no-lock :

    v_acct = "" .
    v_sub  = "" .
    v_cc   = "" .
    
    /*找费用账户acctype = "3"*/
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

    if not (v_acct >= acc  and v_acct <= acc1 ) then next .
    if not (v_sub  >= sub  and v_sub  <= sub1 ) then next .
    if not (v_cc   >= ctr  and v_cc   <= ctr1 ) then next .

    /*确定存在过账账目对应的资产fab_det*/    
    find last fab_det 
        where fab_domain  = fa_domain 
        and   fab_fa_id   = fa_id
        and   fab_fabk_id = fabk_id
    no-lock no-error .
    if not avail fab_det then next .

    v_amt_mth    = 0 .
    /*月折旧(本月)*/
    {gprunp.i "fapl" "p" "fa-get-perdep-range"
          "(input  fa_id,
            input  fabk_id,
            input  l-yrper,
            input  l-yrper,
            output v_amt_mth)"}

        find first temp1 where t1_ctr = v_cc and t1_sub = v_sub no-error .
        if not avail temp1 then do:
            create temp1 .
            assign t1_ctr = v_cc
                   t1_sub = v_sub
                   t1_amt = v_amt_mth 
                   .
        end.
        else t1_amt = t1_amt + v_amt_mth .
end. /*for each fa_mstr*/


/*part_1:管理费用-折旧***************************************************/
assign
    i-sub[01] = "xxxxxxxx"
    i-sub[02] = "55020901"
    i-sub[03] = "55020907"
    i-sub[04] = "55020902"
    i-sub[05] = "55020903"
    i-sub[06] = "55020904"
    i-sub[07] = "55020905"
    i-sub[08] = "55020906"
    i-sub[09] = "55020908"
    i-sub[10] = "55020910"
    i-sub[11] = "55020909"
    i-sub[12] = "55020911"
    i-sub[13] = "xxxxxxxx"
.

{xxfarp006p.i 
    &where="(t1_sub begins ""550209"")"
    &sub01=i-sub[01] &sub02=i-sub[02] &sub03=i-sub[03] &sub04=i-sub[04] &sub05=i-sub[05] 
    &sub06=i-sub[06] &sub07=i-sub[07] &sub08=i-sub[08] &sub09=i-sub[09] &sub10=i-sub[10]
    &sub11=i-sub[11] &sub12=i-sub[12] &sub13=i-sub[13]
}
/*part_2:销售费用-折旧,+ 租赁主机-折旧**********************************/
assign
    i-sub[01] = "xxxxxxxx"
    i-sub[02] = "55011001"
    i-sub[03] = "55011007"
    i-sub[04] = "55011002"
    i-sub[05] = "55011003"
    i-sub[06] = "55011004"
    i-sub[07] = "55011005"
    i-sub[08] = "55011006"
    i-sub[09] = "55011008"
    i-sub[10] = "55011009"
    i-sub[11] = "xxxxxxxx"
    i-sub[12] = "xxxxxxxx"
    i-sub[13] = "54010501"
.
{xxfarp006p.i 
    &where="t1_sub begins ""550110"" or t1_sub = ""54010501"""
    &sub01=i-sub[01] &sub02=i-sub[02] &sub03=i-sub[03] &sub04=i-sub[04] &sub05=i-sub[05] 
    &sub06=i-sub[06] &sub07=i-sub[07] &sub08=i-sub[08] &sub09=i-sub[09] &sub10=i-sub[10]
    &sub11=i-sub[11] &sub12=i-sub[12] &sub13=i-sub[13]
}

/*part_3:制造费用-折旧***************************************************/
assign
    i-sub[01] = "41051501"
    i-sub[02] = "xxxxxxxx"
    i-sub[03] = "41051502"
    i-sub[04] = "41051503"
    i-sub[05] = "41051504"
    i-sub[06] = "41051505"
    i-sub[07] = "41051506"
    i-sub[08] = "41051507"
    i-sub[09] = "xxxxxxxx"
    i-sub[10] = "41051510"
    i-sub[11] = "41051508"
    i-sub[12] = "41051509"
    i-sub[13] = "xxxxxxxx"
.
{xxfarp006p.i 
    &where="t1_sub begins ""410515"""
    &sub01=i-sub[01] &sub02=i-sub[02] &sub03=i-sub[03] &sub04=i-sub[04] &sub05=i-sub[05] 
    &sub06=i-sub[06] &sub07=i-sub[07] &sub08=i-sub[08] &sub09=i-sub[09] &sub10=i-sub[10]
    &sub11=i-sub[11] &sub12=i-sub[12] &sub13=i-sub[13]
}




end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
