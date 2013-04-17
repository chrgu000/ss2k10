/* xxptlocf.i xxptlocf.p的子程式,判断库位是否还有容量*/
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110316.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/


/*
for each xxloc_det 
    where **********
    no-lock
    break by xxloc_type by xxloc_site by xxloc_loc :
    {xxptlocf.i}
*/

        v_ii = 0 .

        /*库位是否被其他库存占用*/
        for each ld_det
            use-index ld_loc_p_lot
            where ld_site = xxloc_site
            and ld_loc    = xxloc_loc 
            and ld_qty_oh <> 0 
        no-lock break by ld_part by ld_lot :
            if first-of(ld_lot) then v_ii = v_ii + 1 .
        end.

        if v_ii >= xxloc_qty then next .

        /*库位是否被本发票的其他项次占用*/
        for each tempcase 
            where tc_ship_nbr  = v_nbr
            and   tc_vend      = v_vend
            and   tc_loc       = xxloc_loc
            and   tc_case_nbr  <> v_case_nbr
        no-lock break by tc_loc by tc_case_nbr :
            if first-of(tc_case_nbr) then v_ii = v_ii + 1 .
        end.

        if v_ii >= xxloc_qty then next .


        /*库位是否被其他发票的项次占用*/
        for each xxship_det 
            use-index xxship_status
            where xxship_status = "RCT-PO"
            and (xxship_nbr + xxship_vend ) <> (v_nbr + v_vend)
            and xxship_rcvd_loc = xxloc_loc
        no-lock break by xxship_nbr by xxship_case:
            if first-of(xxship_case) then v_ii = v_ii + 1 .
        end.

        if v_ii >= xxloc_qty then next .
        else do:
            v_loc_to = xxloc_loc .
            leave .
        end.

/*
end. *for each xxloc_det*
*/
