/* SS - 110223.1 By: Kaine Zhang */

/* SS - 110223.1 - RNB
[110223.1]
富余库存分析表

物料分类
原材料 库位代码为"Z302"开头的物料  "RAW MATERIALS"
在制品 未完工工单                  "WORK_IN_PROGRESS"
半成品 库位为"Z1" "Z301"开头的物料 "SEMI-FINISHED-GOODS"
产成品 库位代码为"Z4"开头的物料    "FINISHED-GOODS"

SS - 110223.1 - RNE */

{mfdtitle.i "110223.1"}

define variable sSiteA like si_site no-undo.
define variable sSiteB like si_site no-undo.
define variable sLocA like Loc_loc no-undo.
define variable sLocB like Loc_loc no-undo.
define variable sPartA like pt_part no-undo.
define variable sPartB like pt_part no-undo.
define variable sProdLineA like pt_prod_line no-undo.
define variable sProdLineB like pt_prod_line no-undo.
define variable sDateA as date no-undo.
define variable sDateB as date no-undo.
define variable sDelimiter as character initial ";" no-undo.
define variable dWoOpenQty as decimal no-undo.
define variable dWodRequestQty as decimal no-undo.

define variable dz302 as decimal no-undo.
define variable dz301 as decimal no-undo.
define variable dz4 as decimal no-undo.
define variable donwo as decimal no-undo.
define variable dworct as decimal no-undo.
define variable dporct as decimal no-undo.
define variable dwoiss as decimal no-undo.
define variable dporel as decimal no-undo.

define temp-table t1_tmp no-undo
    field t1_site as character
    field t1_part as character
    field t1_type as character
    field t1_wod_request_qty as decimal
    index t1_site_part
        is primary unique
        t1_site
        t1_part
    .

form
    sSiteA     colon 15
    sSiteB     colon 50
    sLocA      colon 15
    sLocB      colon 50
    sProdLineA colon 15
    sProdLineB colon 50
    sPartA     colon 15
    sPartB     colon 50
    sDateA     colon 15
    sDateB     colon 50
    skip(2)
with frame a side-labels width 80.
setframelabels(frame a:handle).


{wbrp01.i}
repeat on endkey undo, leave:
    if sSiteB = hi_char then sSiteB = "".
    if sPartB = hi_char then sPartB = "".
    if sLocB = hi_char then sLocB = "".
    if sProdLineB = hi_char then sProdLineB = "".
    if sDateA = Low_date then sDatea = ?.
    if sDateB = hi_date then sDateB = ?.

    if c-application-mode <> 'web' then
        update
            sSiteA
            sSiteB
            sLocA
            sLocB
            sProdLineA
            sProdLineB
            sPartA
            sPartB
            sDateA
            sDateB
        with frame a .

    {wbrp06.i
        &command = update
        &fields = "
            sSiteA
            sSiteB
            sLocA
            sLocB
            sProdLineA
            sProdLineB
            sPartA
            sPartB
            sDateA
            sDateB
            "
        &frm = "a"
    }

    if (c-application-mode <> 'web')
        or (c-application-mode = 'web' and (c-web-request begins 'data'))
    then do:
        bcdparm = "".
        {mfquoter.i  sSiteA     }
        {mfquoter.i  sSiteB     }
        {mfquoter.i  sLocA     }
        {mfquoter.i  sLocB     }
        {mfquoter.i  sProdLineA }
        {mfquoter.i  sProdLineB }
        {mfquoter.i  sPartA     }
        {mfquoter.i  sPartB     }
        {mfquoter.i  sDateA     }
        {mfquoter.i  sDateB     }
        if sSiteB = "" then sSiteB = hi_char.
        if sPartB = "" then sPartB = hi_char.
        if sProdLineB = "" then sProdLineB = hi_char.
        if sDateA = ? then sDatea = low_date.
        if sDateB = ? then sDateB = hi_date.
    end.

    /* output destination selection */
    {gpselout.i
        &printtype = "printer"
        &printwidth = 132
        &pagedflag = " "
        &stream = " "
        &appendtofile = " "
        &streamedoutputtoterminal = " "
        &withbatchoption = "yes"
        &displaystatementtype = 1
        &withcancelmessAge = "yes"
        &pagebottommargin = 6
        &withemail = "yes"
        &withwinprint = "yes"
        &definevariables = "yes"
    }


    {xxexcelfilename.i execname execname 1}

    run putHeader.

    empty temp-table t1_tmp.
    
    for each wo_mstr
        no-lock
        where wo_domain = global_domain
            and wo_site >= sSiteA
            and wo_site <= sSiteB
            and wo_status = "R"
        use-index wo_site
        ,
    each wod_det
        no-lock
        where wod_domain = wo_domain
            and wod_lot = wo_lot
            and wod_part >= sPartA
            and wod_part <= sPartB
        use-index wod_det
        ,
    first pt_mstr
        no-lock
        where pt_domain = wod_domain
            and pt_part = wod_part
            and pt_prod_line >= sProdLineA
            and pt_prod_line <= sProdLineB
        use-index pt_part
        break
        by wo_site
        by wod_part
    :
        accumulate (wod_qty_req - wod_qty_iss) (total by wod_part).

        if last-of(wod_part) then do:
            create t1_tmp.
            assign
                t1_site = wo_site
                t1_part = wod_part
                t1_wod_request_qty = accum total by wod_part (wod_qty_req - wod_qty_iss)
                .
        end.
    end.

    for each in_mstr
        no-lock
        where in_domain = global_domain
            and in_site >= sSiteA
            and in_site <= sSiteB
            and in_part >= sPartA
            and in_part <= sPartB
        use-index in_site
        ,
    first pt_mstr
        no-lock
        where pt_domain = in_domain
            and pt_part = in_part
            and pt_prod_line >= sProdLineA
            and pt_prod_line <= sProdLineB
        use-index pt_part
    :
        /* calculate normal PO open quantity */
        for each pod_det
            no-lock
            where pod_domain = in_domain
                and pod_part = in_part
                and pod_site = in_site
                and pod_status = ""
                and pod_type = ""       /* only blank po would change inventory */
            use-index pod_partdue
            ,
        first po_mstr
            no-lock
            where po_domain = pod_domain
                and po_nbr = pod_nbr
                and po_confirm
            use-index po_nbr
        :
            accumulate (pod_qty_ord - pod_qty_rcvd) (total).
        end.

        /* calculate R status WO open quantity */
        for each wo_mstr
            no-lock
            where wo_domain = in_domain
                and wo_part = in_part
                and wo_site = in_site
                and wo_status = "R"
            use-index wo_part
        :
            accumulate (wo_qty_ord - wo_qty_comp - wo_qty_rjct) (total).
        end.
        dWoOpenQty = accum total (wo_qty_ord - wo_qty_comp - wo_qty_rjct).

        find first t1_tmp
            no-lock
            where t1_site = in_site
                and t1_part = in_part
            no-error.
        dWodRequestQty = if available(t1_tmp) then t1_wod_request_qty else 0.


        /* calculate request from SOD */
        for each sod_det
            no-lock
            where sod_domain = in_domain
                and sod_part = in_part
                and sod_site = in_site
                and sod_confirm
            use-index sod_part
        :
            accumulate (sod_qty_ord - sod_qty_ship) (total).
        end.
/*        
原材料 库位代码为"Z302"开头的物料  "RAW MATERIALS"
在制品 未完工工单                  "WORK_IN_PROGRESS"
半成品 库位为"Z1" "Z301"开头的物料 "SEMI-FINISHED-GOODS"
产成品 库位代码为"Z4"开头的物料    "FINISHED-GOODS"				
*/
			  assign dz301 = 0
			  	     dz302 = 0
			  	     dz4 = 0
			  	     dworct = 0
               dporct = 0
               dwoiss = 0
               dporel = 0
               .
				for each ld_det no-lock use-index ld_part_loc 
					 where ld_domain = global_domain and ld_site = in_site
						 and ld_part = in_part:
						 if ld_loc begins("Z302") then do:
						 		assign dz302 = dz302 + ld_qty_oh.
						 end.
						 else if ld_loc begins("Z301") or ld_loc begins("Z1") then do:
						 	 	assign dz301 = dz301 + ld_qty_oh.
						 end.
						 else if ld_loc begins("z4") then do:
						 	   assign dz4 = dz4 + ld_qty_oh.
						 end.
				end.
				
				for each tr_hist no-lock use-index tr_part_eff 
				   where tr_domain = global_domain and tr_part = in_part
						 and tr_effdate >= sDateA and tr_effdate <= sDateB:
					   if tr_type = "RCT-WO" then do:
					   		assign dworct = dworct + tr_qty_loc.
					   end.
					   if tr_type = "ISS-WO" then do:
					   	  assign dwoiss = dwoiss - tr_qty_loc.
					   end.
					   if (tr_type = "RCT-PO" or tr_type = "ISS-PRV") then do:
					   	  assign dporct = dporct + tr_qty_loc.
					   end.
					   if tr_type = "ORD-PO" then do:
					   	  assign dporel = dporel + tr_qty_loc.
					   end.
				end.
				
        put
            unformatted
            in_site at 1 sDelimiter
            in_part sDelimiter
            pt_um sDelimiter
            pt_desc1 + "/" + pt_desc2 sDelimiter
            in_qty_oh sDelimiter
            accum total (pod_qty_ord - pod_qty_rcvd) sDelimiter
            dWoOpenQty sDelimiter dz302 sDelimiter dz301 sDelimiter dz4 sDelimiter
            in_qty_oh + dWoOpenQty + accum total (pod_qty_ord - pod_qty_rcvd) sDelimiter
            dWodRequestQty sDelimiter
            accum total (sod_qty_ord - sod_qty_ship) sDelimiter
            dWodRequestQty + (accum total (sod_qty_ord - sod_qty_ship)) sDelimiter
            in_qty_oh - dWodRequestQty - (accum total (sod_qty_ord - sod_qty_ship)) sDelimiter
            in_qty_oh + dWoOpenQty + (accum total (pod_qty_ord - pod_qty_rcvd))
                - dWodRequestQty
                - (accum total (sod_qty_ord - sod_qty_ship)) sDelimiter
            dworct sDelimiter 
            dporct sDelimiter 
            dworct + dporct sDelimiter
            dwoiss sDelimiter 
            dporel
            .
    end.


    {xxmfreset.i}
  {mfgrptrm.i}
end.
{wbrp04.i &frame-spec = a}



procedure putHeader:
    put unformatted
        "地点;物料编码;单位;物料名称/规格;库存数量;采购数量;在制数量;原材料;半成品;成品;供给合计;工单需求量;销售需求量;需求合计;库存富余;供应总富余;wo入库数量;po入库数量;入库合计;工单下达数量;订单下达数量" at 1
        .
end procedure.





