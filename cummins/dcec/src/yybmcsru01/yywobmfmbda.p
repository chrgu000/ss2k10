{mfdeclre.i}


DEFINE INPUT  PARAMETER inp-part AS CHAR.
DEFINE INPUT  PARAMETER inp-bomcode AS CHAR.
DEFINE INPUT  PARAMETER inp-site AS CHAR.
DEFINE INPUT  PARAMETER inp-date AS DATE.
DEFINE OUTPUT PARAMETER inp-version AS INTEGER.



{gpxpld01.i "new shared"}
define new shared workfile pkdet no-undo
    field pkpart like ps_comp
    field pkop as integer format ">>>>>9"
    field pkstart like pk_start
    field pkend like pk_end
    field pkqty like pk_qty
    field pkbombatch like bom_batch
    field pkltoff like ps_lt_off.

define NEW shared variable comp like ps_comp.
define NEW shared variable site like ptp_site no-undo.
define NEW shared variable eff_date as date.

define variable v_costset as character. /* Added by James Duan */

RUN xxpro-get-lastversion (INPUT inp-part, INPUT inp-site, INPUT inp-date, OUTPUT inp-version).
RUN xxpro-bud-bom (INPUT inp-part, INPUT inp-bomcode, INPUT inp-site, INPUT inp-date, INPUT-OUTPUT inp-version).



/*-----------------------------------------------------*/
PROCEDURE xxpro-bud-bom:
    DEFINE INPUT PARAMETER p_part AS CHAR.
    DEFINE INPUT PARAMETER p_bomcode AS CHAR.
    DEFINE INPUT PARAMETER p_site AS CHAR.
    DEFINE INPUT PARAMETER p_date AS DATE.
    DEFINE INPUT-OUT PARAMETER p_version AS INTEGER.
    
    IF p_bomcode = "" THEN p_bomcode = p_part.
    comp = p_bomcode.
    site = p_site.
    eff_date = p_date.

    p_version = p_version + 1.
    FIND FIRST xxwobmfm_mstr WHERE xxwobmfm_domain = global_domain 
    		and xxwobmfm_part = p_part 
        AND xxwobmfm_site = p_site
        AND xxwobmfm_version = p_version
        NO-LOCK NO-ERROR.
    IF AVAILABLE xxwobmfm_mstr THEN DO:
        NEXT.
    END.
    
    /* explode part by standard picklist logic */
    {gprun.i ""woworla2.p""}
    
    CREATE xxwobmfm_mstr. xxwobmfm_domain = global_domain.
    ASSIGN xxwobmfm_part = p_part 
           xxwobmfm_site = p_site
           xxwobmfm_version = p_version.
    ASSIGN xxwobmfm_date_eff = p_date
           xxwobmfm_bom      = p_bomcode
           xxwobmfm_userid   = GLOBAL_userid
           xxwobmfm_date_mod = TODAY
           xxwobmfm_time_mod = TIME.
    
    /*RUN xxpro-get-cost-tot (INPUT xxwobmfm_part, INPUT xxwobmfm_site, INPUT p_date, INPUT no, OUTPUT xxwobmfm_cost_tot).*/
    RUN xxpro-get-cost-det (INPUT xxwobmfm_part, 
                            INPUT xxwobmfm_site, 
                            INPUT p_date, 
                            OUTPUT xxwobmfm_cost_tot,
                            OUTPUT xxwobmfm_mtl_tl  ,
                            OUTPUT xxwobmfm_lbr_tl  ,
                            OUTPUT xxwobmfm_bdn_tl  ,
                            OUTPUT xxwobmfm_ovh_tl  ,
                            OUTPUT xxwobmfm_sub_tl  ,
                            OUTPUT xxwobmfm_mtl_ll  ,
                            OUTPUT xxwobmfm_lbr_ll  ,
                            OUTPUT xxwobmfm_bdn_ll  ,
                            OUTPUT xxwobmfm_ovh_ll  ,
                            OUTPUT xxwobmfm_sub_ll
                            ).

    FOR EACH xxwobmfd_det WHERE xxwobmfd_domain = global_domain 
    		and xxwobmfd_par = xxwobmfm_part
        AND xxwobmfd_site    = xxwobmfm_site
        AND xxwobmfd_version = xxwobmfm_version:
        DELETE xxwobmfd_det.
    END.

    /* 镜像明细 Added by James Duan */

        /* get cost set */
	find first in_mstr where in_domain = global_domain and 
						 in_part = p_part and in_site = p_site no-lock no-error.
	v_costset = (if available in_mstr and in_gl_set <> "" then in_gl_set else "STANDARD").

	for each spt_det no-lock where spt_domain = global_domain and spt_site = p_site
		and spt_sim = v_costset
		and spt_part = p_part
		by spt_element:
		/* 生成对应版本镜像BOM成本元素明细 */
		find first yywobmspt_mstr where yywobmspt_domain = global_domain 
			and yywobmspt_site = p_site
			and yywobmspt_part = p_part
			and yywobmspt_version = xxwobmfm_version
			and yywobmspt_elem = spt_element no-error.
		if not available yywobmspt_mstr then do:
			create yywobmspt_mstr. yywobmspt_domain = global_domain.
			assign 
			    yywobmspt_site = p_site
			    yywobmspt_part = p_part
			    yywobmspt_version = xxwobmfm_version
			    yywobmspt_elem = spt_element.
				
		end. /* if not available yywobmspt_mstr */
		assign
		    yywobmspt_elem_cost = spt_cst_tl + spt_cst_ll
		    yywobmspt_elem_tl_cost = spt_cst_tl
		    yywobmspt_elem_ll_cost = spt_cst_ll
		    yywobmspt_userid = global_userid
		    yywobmspt_mod_date = today.
	end. /* for each spt_det */

	for each yywobmsptd_det where yywobmsptd_domain = global_domain 
	  and yywobmsptd_site    = p_site
		and yywobmsptd_part = p_part
		and yywobmsptd_version = xxwobmfm_version:
		delete 	yywobmsptd_det.
	end.
    /* 镜像明细 Added by James Duan END*/

    for each pkdet
        where eff_date = ? or (eff_date <> ?
        and (pkstart = ? or pkstart <= eff_date)
        and (pkend = ? or eff_date <= pkend)
        /*and ((op = pkop) or (op = 0))*/
             )
        break by pkpart by pkop:
        
        FIND FIRST xxwobmfd_det 
            WHERE xxwobmfd_domain = global_domain 
            and xxwobmfd_par   = xxwobmfm_part
            AND xxwobmfd_site    = xxwobmfm_site
            AND xxwobmfd_version = xxwobmfm_version
            AND xxwobmfd_comp    = pkpart
            AND xxwobmfd_op      = pkop
            NO-ERROR.
        IF NOT AVAILABLE xxwobmfd_det THEN DO:
            CREATE xxwobmfd_det. xxwobmfd_domain = global_domain.
            ASSIGN xxwobmfd_par     = xxwobmfm_part
                   xxwobmfd_site    = xxwobmfm_site
                   xxwobmfd_version = xxwobmfm_version
                   xxwobmfd_comp    = pkpart
                   xxwobmfd_op      = pkop
                   xxwobmfd_userid   = GLOBAL_userid
                   xxwobmfd_date_mod = TODAY
                   .
        END.
        ASSIGN xxwobmfd_qty  = xxwobmfd_qty + pkqty.

	/* 加入镜像明细 Added by James Duan */
		for each spt_det no-lock where spt_domain = global_domain 
		  and spt_site = p_site
			and spt_sim = v_costset
			and spt_part = pkpart
			by spt_element:
			find first yywobmsptd_det where yywobmsptd_domain = global_domain 
			  and yywobmsptd_site    = p_site 
				and yywobmsptd_part = p_part 
				and yywobmsptd_comp    = pkpart 
				and yywobmsptd_version = xxwobmfm_version
				and yywobmsptd_elem    = spt_element NO-ERROR.
			if not available yywobmsptd_det then do:
				create yywobmsptd_det. yywobmsptd_domain = global_domain.
				assign
				    yywobmsptd_part = p_part
				    yywobmsptd_site    = p_site
				    yywobmsptd_version = xxwobmfm_version
				    yywobmsptd_comp    = pkpart
				    yywobmsptd_elem    = spt_element. 
			end. /* if not available yywobmsptd_det*/
			assign
			    yywobmsptd_elem_cost = spt_cst_tl + spt_cst_ll
			    yywobmsptd_elem_tl_cost = spt_cst_tl
			    yywobmsptd_elem_ll_cost = spt_cst_ll
			    yywobmsptd_userid = global_userid
			    yywobmsptd_mod_date = today
			    yywobmsptd_unit_qty = yywobmsptd_unit_qty + pkqty.
		end. /* for each spt_det */
	/* 加入镜像明细 Added by James Duan END*/
    END.
    /* 输入镜像明细日志 */
    	
    FOR EACH xxwobmfd_det WHERE xxwobmfd_domain = global_domain 
    		and xxwobmfd_par = xxwobmfm_part
        AND xxwobmfd_site    = xxwobmfm_site
        AND xxwobmfd_version = xxwobmfm_version:
        /*RUN xxpro-get-cost-tot (INPUT xxwobmfd_comp, INPUT xxwobmfd_site, INPUT p_date, INPUT no, OUTPUT xxwobmfd_cost_tot).*/
        RUN xxpro-get-cost-det (INPUT xxwobmfd_comp, 
                                INPUT xxwobmfd_site, 
                                INPUT p_date, 
                                OUTPUT xxwobmfd_cost_tot,
                                OUTPUT xxwobmfd_mtl_tl  ,
                                OUTPUT xxwobmfd_lbr_tl  ,
                                OUTPUT xxwobmfd_bdn_tl  ,
                                OUTPUT xxwobmfd_ovh_tl  ,
                                OUTPUT xxwobmfd_sub_tl  ,
                                OUTPUT xxwobmfd_mtl_ll  ,
                                OUTPUT xxwobmfd_lbr_ll  ,
                                OUTPUT xxwobmfd_bdn_ll  ,
                                OUTPUT xxwobmfd_ovh_ll  ,
                                OUTPUT xxwobmfd_sub_ll
                                ).
    END.
END PROCEDURE.

/*-----------------------------------------------------*/
/***get cost procedure*******************/
{yywobmcomma.i}
/*******************************/
PROCEDURE xxpro-get-lastversion:
    DEFINE INPUT PARAMETER p_part AS CHAR.
    DEFINE INPUT PARAMETER p_site AS CHAR.
    DEFINE INPUT PARAMETER p_date AS DATE.
    DEFINE OUTPUT PARAMETER p_version AS INTEGER.

    DEFINE VARIABLE v_bomdate AS DATE.

    IF p_version = ? THEN p_version = 0.
    FIND LAST xxwobmfm_mstr WHERE xxwobmfm_domain = global_domain and xxwobmfm_part = p_part
        AND xxwobmfm_site = p_site
        USE-INDEX xxwobmfm_idx1
        NO-LOCK NO-ERROR.
    IF AVAILABLE xxwobmfm_mstr THEN DO:
        ASSIGN 
            p_version = xxwobmfm_version
            v_bomdate = xxwobmfm_date_eff.
    END.
    ELSE DO:
        v_bomdate = ?.
    END.
END PROCEDURE.
