/* xxqmrp009.p  进口合同状况报表                                                            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                                      */
/* All rights reserved worldwide.  This is an unpublished work.                             */
/*V8:ConvertMode=NoConvert                                                                  */
/* REVISION: 1.0      LAST MODIFIED: 2008/05/08   BY: Softspeed roger xiao   ECO:*xp001*    */
/*-Revision end------------------------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Definitions ********* */
define var nbr as char.
define var nbr1 as char   .
define var date as date.
define var date1 as date  .
define var cu_part like xxcpt_cu_part .
define var cu_part1 like  xxcpt_cu_part label "至" .
define var cu_ln like xxcpt_ln .
define var cu_ln1 like xxcpt_ln .
define var bk_ln like xxcbkd_bk_ln .
define var bk_ln1 like xxcbkd_bk_ln .
define var v_yn    as logical initial yes label "仅限未结".
define var v_bk_type  as char initial "IMP" .


define var v_cu_desc1  like xxcpt_Desc  .
define var v_price     like xxcpt_price label "海关单价(USD)".
define var v_amt       like tr_qty_loc  .
define var v_qty_oh        like xxcpl_qty .
define var v_qty_oh1       like xxcpl_qty .
define var v_qty_oh2       as decimal format "->>,>>9.9999".
define var v_qty_par       like xxcpl_qty .
define var v_qty_par_all   like xxcpl_qty .
define var v_qty_buy       like xxcpl_qty .
define var v_qty_left      like xxcpl_qty .
define var v_qty_tsf  like xxcbkd_qty_tsf  .
define var v_qty_io   like xxcbkd_qty_io  .
define var v_qty_sl   like xxcbkd_qty_sl  .
define var v_qty_rjct like xxcbkd_qty_rjct  .



define  frame a.

form
    SKIP(.2)
    skip(1)

    date      colon 18 label "报关日期"
    date1     colon 50 label "至"
    nbr       colon 18 label "手册编号" 
    nbr1      colon 50 label "至"
    bk_ln      colon 18 label "手册序"
    bk_ln1     colon 50 label "至"
    cu_ln      colon 18 label "商品序"
    cu_ln1     colon 50 label "至"
    
    cu_part     colon 18 label "商品编码"
    cu_part1    colon 50 label "至" 


    skip(1)
    v_yn      colon 18

    skip (2)
   
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    hide all no-pause . {xxtop.i}
    view frame  a  .

    if nbr1 = hi_char        then nbr1 = "".
    if cu_part1 = hi_char       then cu_part1 = "".
    if date  = low_date then date  = ?.
    if date1 = hi_date  then date1 = ?.
    if cu_ln1 = 99999        then cu_ln1 = 0 .
    if bk_ln1 = 99999        then bk_ln1 = 0 .

    update date date1 nbr nbr1  bk_ln bk_ln1 cu_ln cu_ln1  cu_part cu_part1 v_yn   with frame a.

    if nbr1 = "" then nbr1 = hi_char.
    if cu_part1 = "" then cu_part1 = hi_char.
    if date  = ? then date  = low_date .
    if date1 = ? then date1 = hi_date  .
    if cu_ln1   = 0  then cu_ln1 = 999999.
    if bk_ln1   = 0  then bk_ln1 = 999999.


    /* PRINTER SELECTION */
    /* OUTPUT DESTINATION SELECTION */
    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = " "
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

PUT UNFORMATTED "#def REPORTPATH=$/Citizen/xxqmrp009" SKIP.
PUT UNFORMATTED "#def :end" SKIP.

/*{mfphead.i}*/



for each xxcbkd_det 
        where xxcbkd_domain = global_domain
        and xxcbkd_bk_type  = v_bk_type 
        and xxcbkd_bk_nbr >= nbr and xxcbkd_bk_nbr <= nbr1
        and xxcbkd_bk_ln   >= bk_ln1      and xxcbkd_bk_ln <= bk_ln1
        and xxcbkd_cu_ln   >= cu_ln1      and xxcbkd_cu_ln <= cu_ln1
        and xxcbkd_cu_part >= cu_part      and xxcbkd_cu_part <= cu_part1 
        and (v_yn = no or xxcbkd_stat = "" )
        no-lock break by xxcbkd_bk_nbr by xxcbkd_bk_ln with frame x width 300 :

        find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxcbkd_cu_ln no-lock no-error .
        v_cu_desc1 = if avail xxcpt_mstr then xxcpt_desc else  "" .
        v_price    = if avail xxcpt_mstr then xxcpt_price else  0 .
        v_amt       = v_price *  xxcbkd_qty_ord .

        v_qty_rjct = 0 .
        for each xxexp_mstr 
                where  xxexp_domain = global_domain
                and ( xxexp_type = "6") 
                and (xxexp_req_date >= date and xxexp_req_date <= date1 )
                no-lock,
            each xxexpd_det 
                where xxexpd_domain = global_domain
                and xxexpd_nbr = xxexp_nbr
                and xxexpd_cu_ln = xxcbkd_cu_ln
                no-lock :
                v_qty_rjct = v_qty_rjct + xxexpd_cu_qty .
        end.

        v_qty_sl = 0 .
        for each xximp_mstr 
                where  xximp_domain = global_domain
                and ( xximp_type = "2") 
                and (xximp_req_date >= date and xximp_req_date <= date1 )
                no-lock ,
            each xximpd_det 
                where xximpd_domain = global_domain
                and xximpd_nbr = xximp_nbr
                and xximpd_cu_ln = xxcbkd_cu_ln
                no-lock :
                v_qty_sl = v_qty_sl + xximpd_cu_qty .
        end.

        v_qty_tsf = 0 .
        for each xximp_mstr 
                where  xximp_domain = global_domain
                and ( xximp_type = "3") 
                and (xximp_req_date >= date and xximp_req_date <= date1 )
                no-lock ,
            each xximpd_det 
                where xximpd_domain = global_domain
                and xximpd_nbr = xximp_nbr
                and xximpd_cu_ln = xxcbkd_cu_ln
                no-lock :
                v_qty_tsf = v_qty_tsf + xximpd_cu_qty .
        end.
        
        v_qty_io = 0 .
        for each xximp_mstr 
                where  xximp_domain = global_domain
                and ( xximp_type = "4") 
                and (xximp_req_date >= date and xximp_req_date <= date1 )
                no-lock ,
            each xximpd_det 
                where xximpd_domain = global_domain
                and xximpd_nbr = xximp_nbr
                and xximpd_cu_ln = xxcbkd_cu_ln
                no-lock :
                v_qty_io  = v_qty_io + xximpd_cu_qty .
        end.
        for each xxipr_mstr 
                where xxipr_domain = global_domain 
                and (xxipr_req_date >= date and xxipr_req_date <= date1 )
                no-lock ,
            each xxiprd_det 
                where xxiprd_domain = global_domain
                and xxiprd_nbr  = xxipr_nbr
                and xxiprd_cu_ln = xxcbkd_cu_ln 
                no-lock :
                v_qty_io  = v_qty_io + xxiprd_cu_qty .
        end.

        v_qty_oh  = ( v_qty_tsf + v_qty_sl + v_qty_io  ) . /*累计出口数*/
        v_qty_oh1 = ( xxcbkd_qty_ord - v_qty_oh ) . /*合同余数*/
        v_qty_oh2 = round(v_qty_oh1 / xxcbkd_qty_ord * 100,2) . /*余额%比*/

        v_qty_par = 0 . 
        v_qty_par_all = 0 . /*成品耗量*/
        for each xxcbkps_mstr 
            where xxcbkps_domain = global_domain 
            and xxcbkps_bk_nbr   = xxcbkd_bk_nbr
            and xxcbkps_ln_comp  = xxcbkd_bk_ln
            use-index xxcbkps_bk_nbr2 
            no-lock :
            v_qty_par = 0 .
            for each xxexp_mstr
                    where  xxexp_domain = global_domain
                    and ( xxexp_type = "4" or xxexp_type = "2" ) 
                    and (xxexp_req_date >= date and xxexp_req_date <= date1 )
                    no-lock ,
                each xxexpd_det 
                    where xxexpd_domain = global_domain
                    and xxexpd_nbr = xxexp_nbr
                    and xxexpd_cu_ln = xxcbkps_cu_ln_par
                    no-lock :
                    v_qty_par = v_qty_par + xxexpd_cu_qty .
            end.
            for each xxepr_mstr 
                    where xxepr_domain = global_domain 
                    and xxepr_req_date >= date and xxepr_req_date <= date1
                    no-lock,
                each xxeprd_Det 
                    where xxeprd_domain = global_domain
                    and xxeprd_nbr   = xxepr_nbr 
                    and xxeprd_cu_ln = xxcbkps_cu_ln_par 
                    no-lock :
                v_qty_par = v_qty_par + xxeprd_cu_qty .
            end. 
            v_qty_par = v_qty_par * xxcbkps_qty_per .
            v_qty_par_all = v_qty_par_all + v_qty_par .
        end.

        v_qty_left = v_qty_oh - v_qty_par_all .
        v_qty_buy  = if v_qty_left >= 0 then 0 else ( - v_qty_left) .

        put  unformatted  
             today            ";" /* "制表日" */
             date             ";" /* "起" */
             date1            ";" /* "止" */
             xxcbkd_bk_nbr    ";" /* "手册编号" */
             xxcbkd_bk_ln     ";" /* "手册序" */
             xxcbkd_cu_part   ";" /* "商品编码"  */
             v_cu_desc1       ";" /* "海关品名" */
             xxcbkd_um        ";" /* "海关单位" */
             xxcbkd_qty_ord   ";" /* "备案数量" */
             v_qty_tsf        ";" /* "结转数量" */
             v_qty_io         ";" /* "进口数量" */
             v_qty_sl         ";" /* "转厂数量" */
             v_qty_rjct       ";" /* "退港数量" */
             v_qty_oh         ";" /* "累计出口" */
             v_qty_oh1        ";" /* "合同余数" */
             v_qty_oh2        ";" /* "余额比率%" */
             v_qty_par_all    ";" /* "成品耗量" */
             v_qty_buy        ";" 
             v_qty_left       skip .

end. /*for each xxcps_mstr*/
      



end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
