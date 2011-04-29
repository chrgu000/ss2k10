/* xxqmrp017.p   进口报关单打印                                             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 2008/05/15   BY: Softspeed RogerXiao         */
/******************************************************************************/

{mfdtitle.i "1.0"}

define var v_form_type as char . v_form_type = "1" .   /*customs declaration form type*/
define var v_bk_type  like xxcbkd_bk_type initial  "IMP" .

define var eff_date as date label "进口日期" .
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
define var v_type like xximp_type label "报关单类型".
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
    field t1_nbr           like xximpd_nbr 
    field t1_line          as integer format ">>9" 
    field t1_type          like xximp_type
    field t1_date1         like xximp_rct_date
    field t1_date2         like xximp_req_date
    field t1_bk_nbr        like xximp_bk_nbr 
    field t1_bk_ln         like xxcbkd_bk_ln 
    field t1_bk_nbr_true   like xxcbk_contract
    field t1_pre_nbr       like xximp_pre_nbr      
    field t1_dept          like xximp_dept         
    field t1_bl_nbr        like xximp_bl_nbr      
    field t1_cu_nbr        like xximp_cu_nbr      
    field t1_tax_mtd       like xximp_tax_mtd     
    field t1_trade_mtd     like xximp_trade_mtd   
    field t1_tax_rate      like xximp_tax_rate    
    field t1_ship_via      like xximp_ship_via    
    field t1_ship_tool     like xximp_ship_tool   
    field t1_license       like xximp_license     
    field t1_appr_nbr      like xximp_appr_nbr    
    field t1_contract      like xximp_contract    
    field t1_container     like xximp_container   
    field t1_rmks1         like xximp_rmks1       
    field t1_rmks2         like xximp_rmks2       
    field t1_from          like xximp_from        
    field t1_to            like xximp_to          
    field t1_fob           like xximp_fob         
    field t1_use           like xximp_use         
    field t1_box_num       like xximp_box_num     
    field t1_box_type      like xximp_box_type    
    field t1_net           like xximp_net         
    field t1_gross         like xximp_gross       
    field t1_port          like xximp_port    
    field t1_cu_ln         like xximpd_cu_ln           
    field t1_cu_part       like xximpd_cu_part         
    field t1_price         like xximpd_price           
    field t1_amt           like xximpd_amt             
    field t1_ctry          like xximpd_ctry            
    field t1_cu_qty        like xximpd_cu_qty          
    field t1_cu_um         like xximpd_cu_um    
    field t1_desc          like xxcpt_desc
    field t1_curr          like xximp_curr
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
"报关单类型注:空-所有,1-集报,2-转厂,3-结转入,4-零星,5-成品返修" colon 5

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
            {mfnp01.i xximp_mstr nbr xximp_nbr global_domain "(xximp_type = input v_type or input v_type = '' ) and  xximp_domain" xximp_type}
            if recno <> ? then do:
                disp xximp_nbr @ nbr  
                with frame a.
            end.
        end.
        else if frame-field="nbr1" then do:
            {mfnp01.i xximp_mstr nbr1 xximp_nbr global_domain "(xximp_type = input v_type or input v_type = '' )  and  xximp_domain" xximp_type}
            if recno <> ? then do:
                disp xximp_nbr @ nbr1  
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


        PUT UNFORMATTED "#def REPORTPATH=$/Citizen/xxqmrp017" SKIP.
        PUT UNFORMATTED "#def :end" SKIP.

        
        for each xximp_mstr 
                where xximp_domain = global_domain 
                and xximp_nbr >= nbr and xximp_nbr <= nbr1 
                and (xximp_type = v_type or v_type = "" )
                and xximp_bk_nbr  >= v_bk_nbr and xximp_bk_nbr <= v_bk_nbr1
                and xximp_req_date >= eff_date and xximp_req_date <= eff_date1
                no-lock ,
            each xximpd_det 
                where xximpd_domain = global_domain 
                and xximpd_nbr = xximp_nbr
                and xximpd_cu_part >= cu_part  and xximpd_cu_part <= cu_part1 
                and xximpd_cu_ln  >= cu_ln   and xximpd_cu_ln <= cu_ln1
                and (xximpd_stat = "" or v_yn = no )
            no-lock break by xximpd_nbr by xximpd_line :

            find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xximpd_cu_ln no-lock no-error.
            find first xxcbkd_det 
                where xxcbkd_domain = global_domain 
                and xxcbkd_bk_type     = v_bk_type 
                and xxcbkd_bk_nbr   = xximp_bk_nbr
                and xxcbkd_cu_ln    = xximpd_cu_ln
            no-lock no-error .

            find first xxcbk_mstr 
                where xxcbk_domain = global_domain 
                and xxcbk_bk_nbr   = xximp_bk_nbr
            no-lock no-error .
            

            find first temp1 
                    where t1_nbr           = xximpd_nbr
                    and   t1_line          = xximpd_line
            no-error .
            if not avail temp1 then do:
                create temp1 .
                assign 
                    t1_nbr           = xximpd_nbr
                    t1_line          = xximpd_line
                    t1_type          = xximp_type
                    t1_date1         = xximp_rct_date
                    t1_date2         = xximp_req_date
                    t1_bk_nbr        = xximp_bk_nbr     
                    t1_bk_nbr_true   = if avail xxcbk_mstr then xxcbk_contract else xximp_bk_nbr   
                    t1_bk_ln         = if avail xxcbkd_det then xxcbkd_bk_ln else 0 
                    t1_cu_ln         = xximpd_cu_ln     
                    t1_cu_part       = xximpd_cu_part   
                    t1_price         = xximpd_price     
                    t1_amt           = xximpd_amt       
                    t1_ctry          = xximpd_ctry      
                    t1_cu_qty        = xximpd_cu_qty    
                    t1_cu_um         = xximpd_cu_um 
                    t1_desc          = if avail xxcpt_mstr then xxcpt_desc else ""
                    t1_curr          = xximp_curr
                    t1_taxd          = "全免"

                    t1_pre_nbr       = xximp_pre_nbr    
                    t1_dept          = xximp_dept       
                    t1_bl_nbr        = xximp_bl_nbr     
                    t1_cu_nbr        = xximp_cu_nbr     
                    t1_tax_mtd       = xximp_tax_mtd    
                    t1_trade_mtd     = xximp_trade_mtd  
                    t1_tax_rate      = xximp_tax_rate   
                    t1_ship_via      = xximp_ship_via   
                    t1_ship_tool     = xximp_ship_tool  
                    t1_license       = xximp_license    
                    t1_appr_nbr      = xximp_appr_nbr   
                    t1_contract      = xximp_contract   
                    t1_container     = xximp_container  
                    t1_rmks1         = xximp_rmks1      
                    t1_rmks2         = xximp_rmks2      
                    t1_from          = xximp_from       
                    t1_to            = xximp_to         
                    t1_fob           = xximp_fob        
                    t1_use           = xximp_use        
                    t1_box_num       = xximp_box_num    
                    t1_box_type      = xximp_box_type   
                    t1_net           = xximp_net        
                    t1_gross         = xximp_gross      
                    t1_port          = xximp_port 
                    .

            end.

        end. /*for each xximp_mstr*/
        
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


