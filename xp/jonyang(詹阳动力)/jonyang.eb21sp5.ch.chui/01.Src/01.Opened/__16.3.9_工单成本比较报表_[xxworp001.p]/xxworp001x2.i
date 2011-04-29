
        
        
        
        for each pkdet : delete pkdet. end.

        v_desc = trim(pt_desc1) + trim(pt_Desc2).

        /*展BOM取得工单物料清单*/
        {gprun.i ""xxwogetbom.p"" 
                 "(input wo_part,
                   input wo_site, 
                   input wo_rel_date)"}

        /* pkdet*avg-cost-now */
        run get-standard-cost   (input wo_site,input wo_part,output v_std_cost) .

        
        /*取工单成本:16.3.4累计成本/数量 */
        {xxwoworp0502.i "new"}
        define variable ssnbr    like wo_nbr.
        define variable ssnbr1   like wo_nbr.
        define variable sslot    like wo_lot.
        define variable sslot1   like wo_lot.
        define variable sssite   like wo_site no-undo.
        define variable sssite1  like wo_site no-undo.
        define variable sspart   like wo_part.
        define variable sspart1  like wo_part.
        define variable ssdue    like wo_due_date.
        define variable ssdue1   like wo_due_date.
        define variable ssvend   like wo_vend.
        define variable ssso_job like wo_so_job.
        define variable ssstat   like wo_status.
                        
        define variable ssskpage like mfc_logical initial yes label "page break on work order".
        define variable ssmtlyn  like mfc_logical initial yes label "material" format "detail/summary".
        define variable sslbryn  like mfc_logical initial yes label "labor" format "detail/summary".
        define variable ssbdnyn  like mfc_logical initial yes label "burden" format "detail/summary".
        define variable sssubyn  like mfc_logical initial yes label "subcontract" format "detail/summary".
        define variable ssacct_close   like wo_acct_close initial no .
        define variable ssclose_date   like wo_close_date.
        define variable ssclose_date1  like wo_close_date.
        define variable ssclose_eff    like wo_close_eff.
        define variable ssclose_eff1   like wo_close_eff.


        empty temp-table ttsswoworp0502.

        v_wo_cost = 0 .
        ssnbr  = wo_nbr .
        ssnbr1 = wo_nbr .
        sslot  = wo_lot.
        sslot1 = wo_lot.

        {gprun.i ""xxwoworp0502.p"" "(
            input ssnbr,
            input ssnbr1,
            input sslot,
            input sslot1,
            input sssite,
            input sssite1,
            input sspart,
            input sspart1,
            input ssdue,
            input ssdue1,
            input ssso_job,
            input ssvend,
            input ssstat,

            input ssmtlyn,
            input sslbryn,
            input ssbdnyn,
            input sssubyn,

            input ssskpage,

            input ssacct_close,
            input ssclose_date,
            input ssclose_date1,
            input ssclose_eff,
            input ssclose_eff1
            )"}

        for each ttsswoworp0502:
        v_wo_cost = ttsswoworp0502_mtl_acccst .
        end.
        v_wo_cost = if wo_qty_comp <> 0 then  v_wo_cost / wo_qty_comp else v_wo_cost / wo_qty_ord .






        /*展开到最底层,累加各城运行时间*/
        run bom_down (input pt_part, input wo_rel_date, output v_time_run , output v_time_set) .
        v_std_time = v_time_run .


        v_qty_wip = max(0,wo_qty_ord - wo_qty_comp ) .

        disp 
            pt_part            column-label "物料号"
            v_desc             column-label "物料说明"
            wo_nbr             column-label "工单编号"
            wo_lot             column-label "工单ID"
            wo_status          column-label "状态"
            v_std_cost         column-label "标准材料成本"
            v_wo_cost          column-label "工单材料成本"
            v_std_time         column-label "标准材料工时"
            wo_qty_ord         column-label "加工单数量"
            wo_qty_comp        column-label "完成数量"
            v_qty_wip          column-label "在制数量"

        with frame x.
