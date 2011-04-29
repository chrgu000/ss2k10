/*xxmrprapa03.p*/
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090828.1 By: Roger Xiao */
/* SS - 091019.1  By: Roger Xiao */


{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{pxmaint.i}

{xxmrprapa03v.i } /*shared temp-table temp1*/

define buffer b-temp1 for temp1 .

define input  parameter v_part      like wo_part      no-undo.
define input  parameter v_wolot     like wo_lot       no-undo.
define input  parameter v_qty_ord   like wo_qty_ord   no-undo.
define input  parameter v_due_date  like wo_due_date  no-undo.
define input  parameter v_rel_date  like wo_rel_date  no-undo.
define input  parameter v_wonbr     like wo_nbr       no-undo.
define input  parameter v_yn        like mfc_logical  no-undo.
define input  parameter v_show      like mfc_logical  no-undo.
define output parameter v_ok        like mfc_logical  no-undo.

define var v_i        as integer .
define var v_line     as integer .
define var v_qty_tmp  as decimal .
define var v_pr_list2   like vd_pr_list2 no-undo.

define var exchg_rate        as decimal no-undo.
define var exchg_rate2       as decimal no-undo.
define var error_number      like msg_nbr no-undo.
define var grs_return_code   as   integer           no-undo.
define var grs_req_nbr       like req_nbr no-undo.

form 
    space(3)
    t1_nbr 
    t1_vend 
    t1_qty
    space(3)
with frame a  8 down overlay ROW 6 centered .
setFrameLabels(frame a:handle).


v_ok = no .

mainloop:
repeat:

    /*取消已批准的*/
    if v_yn = no then do:
        for each temp1 where t1_wolot = v_wolot :
            delete temp1 .
        end.
        v_ok = yes .
        leave mainloop.
    end.  /*if v_yn = no*/
    else do:  /*v_yn=yes*/

        /*修改已批准的*/
        find first temp1 where t1_wolot = v_wolot no-error.
        if avail temp1 then do:
            /*nothing*/
        end.
        else do: /*new-add*/
            /*新增刚批准的*/

            find first pt_mstr where pt_domain = global_domain and pt_part = v_part no-lock no-error.
            if not avail pt_mstr then do:
                if global_user_lang = "CH" then message "该零件号不存在:" v_part.
                if global_user_lang = "US" then message "Item number does not exist" v_part.
                undo,leave mainloop.
            end.

            for last xxqt_mstr 
                where xxqt_domain = global_domain 
                and xxqt_part     = v_part 
                and xxqt_start   <= today
                and (xxqt_expire >= today or xxqt_expire = ?)
                use-index xxqt_part 
                no-lock:
            end.
            if not avail xxqt_mstr then do:
                if global_user_lang = "CH" then message "该零件号无有效的供应商分配比例," v_part  .
                if global_user_lang = "US" then message "No effective supplier distribution for Part:"  v_part  .
                undo,leave mainloop.
            end.

            v_qty_tmp = 999999999999999999.
            v_line = 0 . /*符合条件的,最小的区间*/
            v_i    = 0 .
            do v_i = 1 to 10 :
                if xxqt_qty[v_i] >= v_qty_ord then do:
                    if v_qty_tmp > xxqt_qty[v_i] then 
                        assign v_qty_tmp = xxqt_qty[v_i]
                               v_line = v_i .
                end.
            end.

            if v_line = 0 then do:
                if global_user_lang = "CH" then message "该零件号无有效的供应商分配比例." v_part  .
                if global_user_lang = "US" then message "No effective supplier distribution for Part:"  v_part  .
                undo,leave mainloop.
            end.

            find first xxqtd_det 
                where xxqtd_domain = global_domain 
                and   xxqtd_part   = xxqt_part 
                and   xxqtd_start  = xxqt_start
                and   xxqtd_period = v_line 
            no-lock no-error.
            if not avail xxqtd_det then do:
                if global_user_lang = "CH" then message "该零件号无有效的供应商分配比例:" v_part  .
                if global_user_lang = "US" then message "No Effective Supplier Distribution for Part:"  v_part  .
                undo,leave mainloop.
            end.

            v_i    = 0 .
            for each  xxqtd_det 
                where xxqtd_domain = global_domain 
                and   xxqtd_part   = xxqt_part 
                and   xxqtd_start  = xxqt_start
                and   xxqtd_period = v_line 
            no-lock :
                v_i = v_i + xxqtd_pct .
            end. /*for each  xxqtd_det*/

            if v_i <> 100 then do:
                if global_user_lang = "CH" then message "该零件号供应商分配比例总和不等于100%:" v_part .
                if global_user_lang = "US" then message "Supplier Distribution Accumulative Total not equal 100%" v_part .
                undo,leave mainloop.
            end.

            for each  xxqtd_det 
                where xxqtd_domain = global_domain 
                and   xxqtd_part   = xxqt_part 
                and   xxqtd_start  = xxqt_start
                and   xxqtd_period = v_line 
            no-lock :
                find first vd_mstr 
                    where vd_domain = global_domain 
                    and vd_addr = xxqtd_vend 
                no-lock no-error.
                if not avail vd_mstr then do:
                    if global_user_lang = "CH" then message "供应商不存在:" xxqtd_vend /*"比例" xxqtd_pct "%"*/.
                    if global_user_lang = "US" then message "Not a valid supplier:"  xxqtd_vend .
                    undo,leave mainloop.
                end.

                if vd_curr <> base_curr then do:
                        exchg_rate  = ?.
                        exchg_rate2 = ?.

                        {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                              "(input vd_curr,
                                input base_curr,
                                input """",
                                input today ,
                                output exchg_rate,
                                output exchg_rate2,
                                output error_number)"}
                        if error_number <> 0 then do:
                            if global_user_lang = "CH" then message "供应商" vd_addr "币别" vd_curr ",兑换率不存在" .
                            if global_user_lang = "US" then message "Exchange rate does not exist,for Supplier:" vd_addr " Curr:" vd_curr .
                            undo,leave mainloop.
                        end.
                end. /*if vd_curr <> base_curr*/

                v_pr_list2 = if vd_pr_list2 <> "" then vd_pr_list2 else vd_addr .
                find last pc_mstr
                    use-index pc_list
                    where pc_mstr.pc_domain = global_domain     
                    and pc_list       = v_pr_list2                 
                    and pc_curr       = vd_curr  
                    and pc_part       = pt_part                          
                    and pc_um         = pt_um                            
                    and (pc_start     <= v_due_date or pc_start  = ?)      
                    and (pc_expire    >= v_due_date or pc_expire = ?)    
                    and pc_amt_type   = "L"                           
                no-lock no-error.
                if not avail pc_mstr then do:
                    if global_user_lang = "CH" then message "供应商" vd_addr "物料号" v_part ",不存在有效价格表" .
                    if global_user_lang = "US" then message "Price list not found,For Supplier:" vd_addr " Part:" v_part .
                    undo,leave mainloop.
                end.




                find first temp1 
                    where t1_part = xxqtd_part
                    and t1_vend   = xxqtd_vend 
                    and t1_wolot  = v_wolot 
                no-error.
                if not avail temp1 then do:
                    create temp1.
                    assign t1_part       = xxqtd_part 
                           t1_vend       = xxqtd_vend 
                           t1_pct        = xxqtd_pct 
                            /* SS - 091019.1 - B 
                           t1_pctqty     = xxqtd_pct * v_qty_ord / 100
                               SS - 091019.1 - E */
                           /* SS - 091019.1 - B */ 
                           t1_pctqty     = round(xxqtd_pct * v_qty_ord / 100,0)
                           /* SS - 091019.1 - E */ /*四舍五入到个位,避免MOD不支持小数*/
                           t1_wonbr      = v_wonbr             
                           t1_wolot      = v_wolot             
                           t1_due_date   = v_due_date        
                           t1_rel_date   = v_rel_date  
                           .            
                end.

            end. /*for each  xxqtd_det*/


            /*标识主供应商:准备接受其他供应商的调整数量*/
/* SS - 091019.1 - B 
            for each temp1 where t1_wolot = v_wolot break by t1_part by t1_pct :
                if last-of (t1_part) then t1_main_vend = yes .
            end.
   SS - 091019.1 - E */
/* SS - 091019.1 - B */ 
            v_qty_tmp = 0 .
            for each temp1 where t1_wolot = v_wolot break by t1_part by t1_pct :
                v_qty_tmp = v_qty_tmp + t1_pctqty . 
                if last-of (t1_part) then 
                    assign t1_main_vend = yes 
                           t1_pctqty = t1_pctqty + (v_qty_ord - v_qty_tmp) .
            end. /*for each temp1*/
/* SS - 091019.1 - E */

            v_qty_tmp = 0 .
            for each temp1 where t1_wolot = v_wolot and t1_main_vend = no :
                if t1_pctqty < pt_ord_min then do:
                    v_qty_tmp = v_qty_tmp + t1_pctqty .
                    t1_pctqty = 0 .
                end.
                else if (pt_ord_pol = "POQ" or pt_ord_pol = "LFL" ) and pt_ord_mult <> 0 then do:
                    if (t1_pctqty mod pt_ord_mult <> 0 ) then do:
                        v_qty_tmp = v_qty_tmp + (t1_pctqty mod pt_ord_mult).
                        t1_pctqty = t1_pctqty - (t1_pctqty mod pt_ord_mult).
                    end.
                end.
            end.
            for each temp1 where t1_wolot = v_wolot :
                t1_qty = t1_pctqty .
                if t1_main_vend = yes then t1_qty = t1_pctqty + v_qty_tmp .

                if t1_qty = 0 then delete temp1 .
            end.    

            for each temp1 where t1_wolot = v_wolot :

                find first b-temp1 
                        where b-temp1.t1_vend = temp1.t1_vend
                        and   b-temp1.t1_wolot <> temp1.t1_wolot 
                no-error.
                if avail b-temp1 then do:
                    assign temp1.t1_nbr     = b-temp1.t1_nbr 
                           temp1.t1_nbr_new = b-temp1.t1_nbr_new .
                end.
                else do: /*not avail b-temp1*/
                    /*如果要求同一天一个供应商一份PR,用这一段*
                    find first rqd_det 
                        where rqd_domain = global_domain 
                        and rqd_vend     = temp1.t1_vend 
                        and rqd_open     = yes 
                        and rqd_status   = ""
                        and can-find(first rqm_mstr where rqm_domain = global_domain and rqm_nbr = rqd_nbr and rqm_rtdto_purch = no and rqm_open = yes and rqm_status = "" and rqm_req_date = today no-lock)
                    no-lock no-error. 
                    if not avail rqd_det then do:
                        {gprunmo.i
                            &program="mrprapa1.p"
                            &module="GRS"
                            &param="""(output grs_return_code,
                                       output grs_req_nbr)"""
                        }
                        if grs_return_code = 0 then assign temp1.t1_nbr = grs_req_nbr .
                    end.
                    else do:
                        assign temp1.t1_nbr = rqd_nbr .
                    end.
                    */
                    /*此段会造成程式退出到主界面前一直是锁定rqf_ctrl*
                    {gprunmo.i
                        &program="mrprapa1.p"
                        &module="GRS"
                        &param="""(output grs_return_code,
                                   output grs_req_nbr)"""
                    }
                    if grs_return_code = 0 then assign temp1.t1_nbr = grs_req_nbr .
                    */

                    /*用预先取得的变量赋值,避免锁定rqf_ctrl*/
                    assign temp1.t1_nbr = v_tmp_pre + string(v_tmp_nbr,"9999") .

                    /*产生本次审批的临时单号表*/
                    create temp2. assign temp2.t2_nbr = v_tmp_pre + string(v_tmp_nbr,"9999") .



                    assign v_tmp_nbr    = v_tmp_nbr + 1 .
                    if length(v_tmp_pre + string(v_tmp_nbr,"9999") ) > 8 then v_tmp_nbr = 1 .

                end. /*not avail b-temp1*/
            end. /*for each temp1*/
        end.  /*new-add*/

        if v_show then do:
      
            pause 0 .
            view frame a .
            clear frame a all no-pause.

            for each temp1 where t1_wolot = v_wolot 
                break by t1_vend :
                disp t1_nbr t1_vend t1_qty with frame a.
                down 1 with frame a.
            end. /*for each temp1*/
            pause .
        end. /*v_show*/


    end. /*v_yn=yes*/

    v_ok = yes .
    leave .
end . /*mainloop:*/
hide frame a no-pause.



for each temp1 where t1_wolot = v_wolot :
    if t1_qty = 0 then delete temp1 .
end.    