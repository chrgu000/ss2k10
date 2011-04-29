/* xxqmrp016.p   出口报关单打印                                             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 2008/05/15   BY: Softspeed RogerXiao         */
/******************************************************************************/

{mfdtitle.i "1.0"}

define var v_form_type as char . v_form_type = "1" .   /*customs declaration form type*/
define var v_bk_type  like xxcbkd_bk_type initial  "OUT" .

define var eff_date as date label "出口日期" .
define var eff_date1 as date label "至" .
define var nbr  as char format "x(18)" label "报关单号".
define var nbr1 as char format "x(18)" label "至".
define var cu_part  as char format "x(18)" label "商品编号".
define var cu_part1 as char format "x(18)" label "至".
define var cu_ln   like xxcpt_ln format ">>>>>" label "商品序" .
define var cu_ln1  like xxcpt_ln  format ">>>>>" label "至" .
define var v_bk_nbr like xxcbk_bk_nbr  label "手册号" .
define var v_bk_nbr1 like xxcbk_bk_nbr  label "至" .
define var v_yn as logical label "仅限未结" initial yes .
define var jj  as integer format ">>9" label "行".
define var v_type like xxexp_type label "报关单类型".
define var v_company as char format "x(40)" .
define var v_addr    as char format "x(40)" .
define var v_dept    as char format "x(40)" .
define var v_trade   as char format "x(40)" .
define var v_tax     as char format "x(40)" .
define var v_from    as char format "x(40)" .
define var v_port    as char format "x(40)" .
define var v_ctry    as char format "x(40)" .
define var v_to      as char format "x(40)" .


define temp-table temp1
    field t1_nbr           like xxexpd_nbr 
    field t1_line          as integer format ">>9" 
    field t1_type          like xxexp_type
    field t1_date1         like xxexp_iss_date
    field t1_date2         like xxexp_req_date
    field t1_bk_nbr        like xxexp_bk_nbr 
    field t1_bk_ln         like xxcbkd_bk_ln 
    field t1_bk_nbr_true   like xxcbk_contract
    field t1_pre_nbr       like xxexp_pre_nbr      
    field t1_dept          like xxexp_dept         
    field t1_bl_nbr        like xxexp_bl_nbr      
    field t1_cu_nbr        like xxexp_cu_nbr      
    field t1_tax_mtd       like xxexp_tax_mtd     
    field t1_trade_mtd     like xxexp_trade_mtd   
    field t1_tax_rate      like xxexp_tax_rate    
    field t1_ship_via      like xxexp_ship_via    
    field t1_ship_tool     like xxexp_ship_tool   
    field t1_license       like xxexp_license     
    field t1_appr_nbr      like xxexp_appr_nbr    
    field t1_contract      like xxexp_contract    
    field t1_container     like xxexp_container   
    field t1_rmks1         like xxexp_rmks1       
    field t1_rmks2         like xxexp_rmks2       
    field t1_from          like xxexp_from        
    field t1_to            like xxexp_to          
    field t1_fob           like xxexp_fob         
    field t1_use           like xxexp_use         
    field t1_box_num       like xxexp_box_num     
    field t1_box_type      like xxexp_box_type    
    field t1_net           like xxexp_net         
    field t1_gross         like xxexp_gross       
    field t1_port          like xxexp_port    
    field t1_cu_ln         like xxexpd_cu_ln           
    field t1_cu_part       like xxexpd_cu_part         
    field t1_price         like xxexpd_price           
    field t1_amt           like xxexpd_amt             
    field t1_ctry          like xxexpd_ctry            
    field t1_cu_qty        like xxexpd_cu_qty          
    field t1_cu_um         like xxexpd_cu_um    
    field t1_desc          like xxcpt_desc
    field t1_curr          like xxexp_curr
    field t1_taxd          as char 
    . 
 
 
 

define frame a .


form
    skip(1)
    v_type      colon 18 
    nbr         colon 18  
    nbr1        colon 45
    eff_Date    colon 18  
    eff_date1   colon 45 
    v_bk_nbr    colon 18
    v_bk_nbr1   colon 45 /*
    cu_part     colon 18  
    cu_part1    colon 45 
    cu_ln       colon 18  
    cu_ln1      colon 45 */
    v_yn        colon 18
skip(2)
"报关单类型注:空-所有;1-集报;2-转厂,3-结转出,4-零星,5-成品返修,6-材料退港" colon 4

    skip(1)
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).


{wbrp01.i}                                                                                   
mainloop:
repeat:
    
    for each temp1: delete temp1. end.
    
    hide all no-pause . {xxtop.i}
    view frame  a  .
    clear frame a no-pause .
    if eff_date = low_date  then eff_date = ? .
    if eff_date1 = hi_date  then eff_date1 = ? .
    if cu_part1 = hi_char   then cu_part1 = "" .
    if cu_ln1 = 99999      then cu_ln1 = 0 .
    if nbr1 = hi_char       then nbr1 = "" .
    if v_bk_nbr1 = hi_char       then v_bk_nbr1 = "" .

    update v_type nbr nbr1 eff_date eff_date1 v_bk_nbr v_bk_nbr1 /* cu_part cu_part1 cu_ln cu_ln1*/ v_yn with frame a editing:
        if frame-field="nbr" then do:
            {mfnp01.i xxexp_mstr nbr xxexp_nbr global_domain  "(xxexp_type = input v_type or input v_type = '' ) and  xxexp_domain" xxexp_type}
            if recno <> ? then do:
                disp xxexp_nbr @ nbr  
                with frame a.
            end.
        end.
        else if frame-field="nbr1" then do:
            {mfnp01.i xxexp_mstr nbr1 xxexp_nbr global_domain "(xxexp_type = input v_type or input v_type = '' ) and  xxexp_domain" xxexp_type}
            if recno <> ? then do:
                disp xxexp_nbr @ nbr1  
                with frame a.
            end.
        end.        
        else if frame-field="v_bk_nbr" then do:
            {mfnp01.i xxcbk_mstr v_bk_nbr xxcbk_bk_nbr global_domain xxcbk_domain xxcbk_bk_nbr}
            if recno <> ? then do:
                disp xxcbk_bk_nbr @ v_bk_nbr  
                with frame a.
            end.
        end.
        else if frame-field="v_bk_nbr1" then do:
            {mfnp01.i xxcbk_mstr v_bk_nbr1 xxcbk_bk_nbr global_domain xxcbk_domain xxcbk_bk_nbr}
            if recno <> ? then do:
                disp xxcbk_bk_nbr @ v_bk_nbr1  
                with frame a.
            end.
        end. /*
        else if frame-field="cu_part" then do:
            {mfnp01.i xxcpt_mstr cu_part xxcpt_cu_part global_domain xxcpt_domain xxcpt_cu_part}
            if recno <> ? then do:
                disp xxcpt_cu_part @ cu_part  
                with frame a.
            end.
        end.
        else if frame-field="cu_part1" then do:
            {mfnp01.i xxcpt_mstr cu_part1 xxcpt_cu_part global_domain xxcpt_domain xxcpt_cu_part}
            if recno <> ? then do:
                disp xxcpt_cu_part @ cu_part1  
                with frame a.
            end.
        end.
        else if frame-field="cu_ln" then do:
            {mfnp01.i xxcpt_mstr cu_ln xxcpt_ln global_domain xxcpt_domain xxcpt_ln}
            if recno <> ? then do:
                disp xxcpt_ln @ cu_ln  
                with frame a.
            end.
        end.
        else if frame-field="cu_ln1" then do:
            {mfnp01.i xxcpt_mstr cu_ln1 xxcpt_ln global_domain xxcpt_domain xxcpt_ln}
            if recno <> ? then do:
                disp xxcpt_ln @ cu_ln1  
                with frame a.
            end.
        end. */
        else do:
            status input ststatus.
            readkey.
            apply lastkey.
        end.
    end. /*update */
    assign v_type nbr nbr1 eff_date eff_date1 v_bk_nbr v_bk_nbr1 /* cu_part cu_part1 cu_ln cu_ln1*/ v_yn  .


    if cu_ln1 = 0    then cu_ln1 = 99999 .
    if cu_part1 = ""  then cu_part1 = hi_char .
    if eff_date = ?   then eff_date = low_date .
    if eff_date1 = ?  then eff_date1 = hi_date .
    if nbr1 = ""      then nbr1 = hi_char .
    if v_bk_nbr1 = ""      then v_bk_nbr1 = hi_char .



    printloop:
    do on error undo, retry:

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


        PUT UNFORMATTED "#def REPORTPATH=$/Citizen/xxqmrp016" SKIP.
        PUT UNFORMATTED "#def :end" SKIP.

        
        for each xxexp_mstr 
                where xxexp_domain = global_domain 
                and xxexp_nbr >= nbr and xxexp_nbr <= nbr1
                and (xxexp_type = v_type or v_type = "" )
                and xxexp_bk_nbr  >= v_bk_nbr and xxexp_bk_nbr <= v_bk_nbr1
                and xxexp_req_date >= eff_date and xxexp_req_date <= eff_date1
                no-lock ,
            each xxexpd_det 
                where xxexpd_domain = global_domain 
                and xxexpd_nbr = xxexp_nbr
                and xxexpd_cu_part >= cu_part  and xxexpd_cu_part <= cu_part1 
                and xxexpd_cu_ln  >= cu_ln   and xxexpd_cu_ln <= cu_ln1
                and (xxexpd_stat = "" or v_yn = no )
            no-lock break by xxexpd_nbr by xxexpd_line :

            find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxexpd_cu_ln no-lock no-error.
            find first xxcbkd_det 
                where xxcbkd_domain = global_domain 
                and xxcbkd_bk_type     = v_bk_type 
                and xxcbkd_bk_nbr   = xxexp_bk_nbr
                and xxcbkd_cu_ln    = xxexpd_cu_ln
            no-lock no-error .

            find first xxcbk_mstr 
                where xxcbk_domain = global_domain 
                and xxcbk_bk_nbr   = xxexp_bk_nbr
            no-lock no-error .
            

            find first temp1 
                    where t1_nbr           = xxexpd_nbr
                    and   t1_line          = xxexpd_line
            no-error .
            if not avail temp1 then do:
                create temp1 .
                assign 
                    t1_nbr           = xxexpd_nbr
                    t1_line          = xxexpd_line
                    t1_type          = xxexp_type
                    t1_date1         = xxexp_iss_date
                    t1_date2         = xxexp_req_date
                    t1_bk_nbr        = xxexp_bk_nbr     
                    t1_bk_nbr_true   = if avail xxcbk_mstr then xxcbk_contract else xxexp_bk_nbr   
                    t1_bk_ln         = if avail xxcbkd_det then xxcbkd_bk_ln else 0 
                    t1_cu_ln         = xxexpd_cu_ln     
                    t1_cu_part       = xxexpd_cu_part   
                    t1_price         = xxexpd_price     
                    t1_amt           = xxexpd_amt       
                    t1_ctry          = xxexpd_ctry      
                    t1_cu_qty        = xxexpd_cu_qty    
                    t1_cu_um         = xxexpd_cu_um 
                    t1_desc          = if avail xxcpt_mstr then xxcpt_desc else ""
                    t1_curr          = xxexp_curr
                    t1_taxd          = "全免"

                    t1_pre_nbr       = xxexp_pre_nbr    
                    t1_dept          = xxexp_dept       
                    t1_bl_nbr        = xxexp_bl_nbr     
                    t1_cu_nbr        = xxexp_cu_nbr     
                    t1_tax_mtd       = xxexp_tax_mtd    
                    t1_trade_mtd     = xxexp_trade_mtd  
                    t1_tax_rate      = xxexp_tax_rate   
                    t1_ship_via      = xxexp_ship_via   
                    t1_ship_tool     = xxexp_ship_tool  
                    t1_license       = xxexp_license    
                    t1_appr_nbr      = xxexp_appr_nbr   
                    t1_contract      = xxexp_contract   
                    t1_container     = xxexp_container  
                    t1_rmks1         = xxexp_rmks1      
                    t1_rmks2         = xxexp_rmks2      
                    t1_from          = xxexp_from       
                    t1_to            = xxexp_to         
                    t1_fob           = xxexp_fob        
                    t1_use           = xxexp_use        
                    t1_box_num       = xxexp_box_num    
                    t1_box_type      = xxexp_box_type   
                    t1_net           = xxexp_net        
                    t1_gross         = xxexp_gross      
                    t1_port          = xxexp_port 
                    .

            end.

        end. /*for each xxexp_mstr*/
        
        jj = 0 .
        for each temp1 
            break by t1_nbr by t1_cu_part by t1_bk_ln :

            jj = jj + 1 .
            if first-of(t1_nbr) then do:
                find first xxcbkc_ctrl where xxcbkc_domain = global_domain no-lock no-error .
                v_company = if avail xxcbkc_ctrl then xxcbkc_name + "(" + xxcbkc_comp + ")" else "" .
                v_addr    = if avail xxcbkc_ctrl then xxcbkc_addr_name + "(" + xxcbkc_addr + ")" else "" .
                find first xxdept_mstr where xxdept_domain = global_domain and xxdept_code = t1_dept no-lock no-error .
                v_dept = if avail xxdept_mstr then xxdept_desc + "(" + xxdept_code + ")" else "" .
                find first xxctra_mstr where xxctra_domain = global_domain and xxctra_code = t1_trade_mtd no-lock no-error.
                v_trade = if avail xxctra_mstr then xxctra_desc1 + "(" + xxctra_code + ")" else "".
                find first xxctax_mstr where xxctax_domain = global_domain and xxctax_code = t1_tax_mtd no-lock no-error.
                v_tax = if avail xxctax_mstr then xxctax_desc1 + "(" + xxctax_code + ")"  else "".
                find first xxloc_mstr where xxloc_domain = global_domain   and xxloc_code = t1_to no-lock no-error.
                v_to  = if avail xxloc_mstr then xxloc_desc + "(" + xxloc_code + ")" else "". 
                find first xxctry_mstr where xxctry_domain = global_domain and xxctry_code = t1_from no-lock no-error.
                v_from = if avail xxctry_mstr then xxctry_name + "(" + xxctry_code + ")" else "" .
                find first xxctry_mstr where xxctry_domain = global_domain and xxctry_code = t1_port no-lock no-error.
                v_port = if avail xxctry_mstr then xxctry_name + "(" + xxctry_code + ")" else "" .
            end.

            find first xxctry_mstr where xxctry_domain = global_domain and xxctry_code = t1_ctry no-lock no-error.
            v_ctry = if avail xxctry_mstr then xxctry_name + "(" + xxctry_code + ")" else "" .

            put unformatted 
                t1_nbr                 ";"  
                jj                     ";"  
                t1_type                ";"  
                t1_pre_nbr             ";"  
                t1_cu_nbr              ";"  
                v_dept                 ";"  
                t1_bk_nbr              ";"  
                t1_bk_nbr_true         ";"  
                t1_date1               ";"  
                t1_date2               ";"  
                v_company              ";"  
                t1_ship_via            ";"  
                t1_ship_tool           ";"  
                t1_bl_nbr              ";"  
                v_addr                 ";"  
                v_trade                ";"  
                v_tax                  ";"  
                t1_tax_rate            ";"  
                t1_license             ";"  
                v_from                 ";"  
                v_port                 ";"  
                v_to                   ";"  
                t1_appr_nbr            ";"  
                t1_fob                 ";"  
                t1_contract            ";"  
                t1_box_num             ";"  
                t1_box_type            ";"  
                t1_gross               ";"  
                t1_net                 ";"  
                t1_container           ";"  
                t1_use                 ";"  
                t1_rmks1               ";"  
                t1_rmks2               ";"  
                /*t1_yunfei*/          ";"  
                /*t1_baofei*/          ";"  
                /*t1_zafei*/           ";"  
                /*t1_danju*/           ";"  
                                       ";"  
                                       ";" 
                                       ";"  
                                       ";"
                                       ";"  
                                       ";"  
                                       ";"
                                       ";"  
                                       ";"
                                       ";"  
                t1_bk_ln               ";"  
                t1_cu_ln               ";"  
                t1_cu_part             ";"  
                t1_desc                ";"
                t1_cu_qty              
                t1_cu_um               ";;"
                v_ctry                 ";"
                t1_price               ";"
                t1_amt                 ";"
                t1_curr                ";"
                t1_taxd                      
                skip .

        end. /*for each temp1*/



        {mfreset.i}  /*{mfrtrail.i}   REPORT TRAILER  */
        {wbrp04.i &frame-spec = a}
    end. /*printloop:*/
end. /*mainloop*/


