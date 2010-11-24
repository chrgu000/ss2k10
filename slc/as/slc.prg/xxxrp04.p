/*  ---- */
/* Copyright 2010 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 100412.1 By: Kaine Zhang */
/* SS - 100625.1 By: Kaine Zhang */

/* *ss_20100625* 
取消库位分级.
挂账类型,取xxgz_sort的类型 .
*/
/* *ss_20100421* 挂账表批量打印 */

{mfdtitle.i "100625.1"}

define variable iYear as integer format ">>>9" label "年份" no-undo.
define variable iMonth as integer format ">9" label "期间" no-undo.
define variable sVendorA as character label "供应商" no-undo.
define variable sVendorB as character label "至" no-undo.

define variable xxqty1 like tr_qty_loc  no-undo.
define variable xxqty2 like tr_qty_loc  no-undo.
define variable tamt like tr_qty_loc no-undo.
define variable dteGZ as date          no-undo.
define variable xxamt01 like xxgzd_amt  no-undo.
define variable xxamt02 like xxgzd_amt  no-undo.
define variable sVendorType as character no-undo.
define variable sDesc1 as character format "x(24)" no-undo.
define variable sDesc2 as character format "x(24)" no-undo.
define variable sPtGroup as character no-undo.

find first usr_mstr where usr_userid = global_userid no-lock no-error.

form
    iYear   colon 15
    iMonth  colon 15
    sVendorA    colon 15
    sVendorB    colon 45
with frame a side-labels width 80.
setframelabels(frame a:handle).

form
    xxgzd_part          column-label "物料编码"
    sDesc1              column-label "车型代码"
    sDesc2              column-label "名称规格"
    xxqty1              column-label "上期未挂"
    xxkc_rct_po         column-label "本月入库"
    xxgzd_end_qty       column-label "挂账数量"
    xxgzd_price         column-label "含税单价"
    xxgzd_tax_pct       column-label "税率"
    xxgzd_amt           column-label "含税金额"
    tamt                column-label "未税金额"
    xxqty2              column-label "未挂账数"
with frame b down width 320.
setframelabels(frame b:handle).



{wbrp01.i}
repeat on endkey undo, leave:
    {xxxxrpinput.i}

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



    /* SS - 100625.1 - B
    {xxgettmpvd.i
        iYear
        iMonth
    }
    SS - 100625.1 - E */

    for each vd_mstr
        no-lock
        where vd_domain = global_domain
            and vd_addr >= sVendorA
            and vd_addr <= sVendorB
        break
        by vd_addr
    :
        if first-of(vd_addr) and not(first(vd_addr)) then page.

        dteGZ = today.
        xxamt01 = 0.
        xxamt02 = 0.
		find first ad_mstr no-lock where ad_domain = global_domain and ad_addr = vd_addr no-error.

		form header
			 iMonth colon 50 "月挂账表" skip
			 "会计单位: " colon 2 "隆鑫工业有限公司四轮车本部"
			 "挂账日期: " colon 80 dteGZ skip
			 "  供应商: " colon 2 vd_addr ad_name colon 22
		with frame fh1 page-top stream-io no-box no-label width 100.
		view frame fh1.

		/* SS - 100625.1 - B
		sVendorType = "".
        find first tmpvd_tmp
            no-lock
            where tmpvd_addr = vd_addr
            no-error.
        if available(tmpvd_tmp) then do:
            sVendorType = tmpvd_type.
        end.
        SS - 100625.1 - E */
        
        /* SS - 100625.1 - B */
        for first xxgz_mstr
            no-lock
            where xxgz_domain = global_domain
                and xxgz_year = iYear
                and xxgz_per = iMonth
                and xxgz_vend = vd_addr
        :
        end.
        if available(xxgz_mstr) then do:
            sVendorType = xxgz_sort.
        end.
        else do:
            sVendorType = "".
        end.
        /* SS - 100625.1 - E */

        for each xxgzd_det
            no-lock
            where xxgzd_domain = global_domain
                and xxgzd_year = iYear
                and xxgzd_per = iMonth
                and xxgzd_vend = vd_addr
                and (xxgzd_qty + xxgzd_end_qty) <> 0
            ,
        each xxgz_mstr
            no-lock
            where xxgz_domain = global_domain
                and xxgz_year = iYear
                and xxgz_per = iMonth
    			and xxgz_vend = xxgzd_vend
    		break
    		by xxgzd_part
        :
            if xxgz_date = ? then dteGZ = today.
    		else dteGZ = xxgz_date.
    		
    		if first-of(xxgzd_part) then do:
    		    assign
    		        sDesc1 = ""
    		        sDesc2 = ""
    		        sPtGroup = ""
    		        .
    		    find first pt_mstr where pt_domain = global_domain and pt_part = xxgzd_part no-lock no-error.
    		    if available(pt_mstr) then do:
    		        sDesc1 = pt_desc1.
    		        sPtGroup = pt_group.
    		    end.
    		    find first pt_mstr
		            no-lock
		            where pt_domain = global_domain
		                and pt_part = sPtGroup
		            no-error.
		        if available(pt_mstr) then sDesc2 = pt_desc2.
    		end.

    		find first xxkc_det
    		    where xxkc_domain = global_domain
    		        and xxkc_year = iYear
    		        and xxkc_per = iMonth
    			    and xxkc_part = xxgzd_part
    			    and xxkc_vend = xxgzd_vend
    			    /* SS - 100625.1 - B
    			    and xxkc_loc = xxgzd_loc
    			    SS - 100625.1 - E */
    			no-lock no-error.

            assign
                xxqty1 = 0
    		    xxqty2 = 0
    		    .

    	    for each xxld_det
                where xxld_year * 100 + xxld_per < iYear * 100 + iMonth
                    and xxld_vend = xxgzd_vend
                    and xxld_part = xxgzd_part
    			    /* SS - 100625.1 - B
    			    and xxld_loc = xxgzd_loc
    			    SS - 100625.1 - E */
    		    no-lock:
    			if xxld_zg_qty > 0 then xxqty1 = xxqty1 + xxld_zg_qty.
    		end.

    	    /* SS - 100625.1 - B
    	    if sVendorType = "B" then do:
    	    SS - 100625.1 - E */
    	    /* SS - 100625.1 - B */
    	    if sVendorType = "耗用" then do:
    	    /* SS - 100625.1 - E */
    	    	if available(xxkc_det) then do:
    				xxqty1 = xxqty1 + xxkc_beg_qty.
    				xxqty2 = xxkc_end_qty.
    			end.
    	    end.

    	    tamt = xxgzd_amt / (1 + xxgzd_tax_pct / 100 ).
    		disp
    		    xxgzd_part
                sDesc1
                sDesc2
                xxqty1
                xxkc_rct_po when available(xxkc_det)
                xxgzd_qty + xxgzd_end_qty @ xxgzd_end_qty
                xxgzd_price
                xxgzd_tax_pct
                xxgzd_amt
                tamt
                xxqty2
    		with frame b .
    		down with frame b.

    		if page-size - line-counter <= 3 then do:
    			put "供应商确认: " at 10.
    			put "制表人:"      at 70.
    			if avail usr_mstr then put usr_name .
    			page.
    		end.

    		xxamt01 = xxamt01 + xxgzd_amt.
    		xxamt02 = xxamt02 + tamt.
        end.

        for each xxkc_det
            where xxkc_domain = global_domain
                and xxkc_year = iYear
                and xxkc_per = iMonth
    			and xxkc_vend = vd_addr
            no-lock
            break
            by xxkc_part:
            
            if first-of(xxkc_part) then do:
                assign
    		        sDesc1 = ""
    		        sDesc2 = ""
    		        sPtGroup = ""
    		        .
    		    find first pt_mstr where pt_domain = global_domain and pt_part = xxkc_part no-lock no-error.
    		    if available(pt_mstr) then do:
    		        sDesc1 = pt_desc1.
    		        sPtGroup = pt_group.
    		    end.
    		    find first pt_mstr
		            no-lock
		            where pt_domain = global_domain
		                and pt_part = sPtGroup
		            no-error.
		        if available(pt_mstr) then sDesc2 = pt_desc2.
		    end.
		        
    		find first xxgzd_det
    		    where xxgzd_domain = global_domain
    		        and xxgzd_year = iYear
    		        and xxgzd_per = iMonth
    			    and xxgzd_vend = vd_addr
    			    and xxgzd_part = xxkc_part
        			/* SS - 100625.1 - B
        			and xxgzd_loc = xxkc_loc
        			SS - 100625.1 - E */
    			no-lock no-error.
    		if available(xxgzd_det) then next.

    		xxqty1 = 0.
    		xxqty2 = 0.

    		for each xxld_det
    		    where xxld_year * 100 + xxld_per < iYear * 100 + iMonth
			        and xxld_vend = xxkc_vend 
			        and xxld_part = xxkc_part
			        /* SS - 100625.1 - B
			        and xxld_loc = xxkc_loc
			        SS - 100625.1 - E */
			    no-lock:
				if xxld_zg_qty > 0 then xxqty1 = xxqty1 + xxld_zg_qty.
			end.

    		/* SS - 100625.1 - B
    		if sVendorType = "B" then do:
    		SS - 100625.1 - E */
    		/* SS - 100625.1 - B */
    		if sVendorType = "耗用" then do:
    		/* SS - 100625.1 - E */
				xxqty1 = xxqty1 + xxkc_beg_qty.
   				xxqty2 = xxkc_end_qty.
    	    end.
    		xxqty2 = xxqty1 + xxkc_rct_po.

    		disp
    		    xxkc_part @ xxgzd_part
    			sDesc1
    			sDesc2
    			xxqty1
    			xxkc_rct_po
    			xxqty2
    		with frame b .
    		down with frame b.

    		if page-size - line-counter <= 3 then do:
    			put "供应商确认: " at 10.
    			put "制表人:"      at 70.
    			if avail usr_mstr then put usr_name .
    			page.
    		end.

    	end.

    	xxqty1 = 0.
    	for each xxld_det
    	    where xxld_domain = global_domain
    	        and xxld_zg_qty > 0
    	        and xxld_vend = vd_addr
    	    no-lock
    		break
    		by xxld_part
    		/* SS - 100625.1 - B
    		by xxld_loc
    		SS - 100625.1 - E */
    		:
    		
    		if first-of(xxld_part) then do:
                assign
    		        sDesc1 = ""
    		        sDesc2 = ""
    		        sPtGroup = ""
    		        .
    		    find first pt_mstr where pt_domain = global_domain and pt_part = xxld_part no-lock no-error.
    		    if available(pt_mstr) then do:
    		        sDesc1 = pt_desc1.
    		        sPtGroup = pt_group.
    		    end.
    		    find first pt_mstr
		            no-lock
		            where pt_domain = global_domain
		                and pt_part = sPtGroup
		            no-error.
		        if available(pt_mstr) then sDesc2 = pt_desc2.
		    end.
		    
    		find first xxgzd_det where xxgzd_domain = global_domain and xxgzd_year = iYear and xxgzd_per = iMonth
    			and xxgzd_vend = xxld_vend and xxgzd_part = xxld_part
    			/* SS - 100625.1 - B
    			and xxgzd_loc = xxld_loc
    			SS - 100625.1 - E */
    			no-lock no-error.
    		if avail xxgzd_det then next.
    		find first xxkc_det where xxkc_domain = global_domain and xxkc_year = iYear and xxkc_per = iMonth
    			and xxkc_vend = xxld_vend and xxkc_part = xxld_part
    			/* SS - 100625.1 - B
    			and xxkc_loc = xxld_loc
    			SS - 100625.1 - E */
    			no-lock no-error.
    		if avail xxkc_det then next.
            
            
		    
    		xxqty1 = xxqty1 + xxld_zg_qty.

    		/* SS - 100625.1 - B
    		if last-of(xxld_loc) then do:
    		SS - 100625.1 - E */
    		/* SS - 100625.1 - B */
    		if last-of(xxld_part) then do:
    		/* SS - 100625.1 - E */
    			xxqty2 = xxqty1.
    			disp
    			    xxld_part @ xxgzd_part
    				sDesc1
    				sDesc2
    				xxqty1
    				0 @ xxkc_rct_po
    				xxqty2
    			with frame b .
    			down with frame b.

    			xxqty1 = 0.

    			if page-size - line-counter <= 3 then do:
    				put "供应商确认: " at 10.
    				put "制表人:"      at 70.
    				if avail usr_mstr then put usr_name .
    				page.
    			end.
    		end.
    	end.

    	underline xxgzd_amt tamt with frame b.
    	down with frame b.
    	disp
    	    "合计:" @ xxgzd_part
    		xxamt01  @ xxgzd_amt
    		xxamt02  @ tamt
    	with frame b.
    	down with frame b.

    	put skip(2).
    	put "供应商确认: " at 10.
    	put "制表人:"      at 70.
    	if avail usr_mstr then put usr_name .
    end.

    {mfreset.i}
	{mfgrptrm.i}
end.
{wbrp04.i &frame-spec = a}










