{mfdeclre.i}

DEFINE INPUT  PARAMETER inp-part AS CHAR.
DEFINE INPUT  PARAMETER inp-bomcode AS CHAR.
DEFINE INPUT  PARAMETER inp-site AS CHAR.
DEFINE INPUT  PARAMETER inp-date AS DATE.
DEFINE OUTPUT PARAMETER inp-results AS CHAR.

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

DEFINE NEW SHARED TEMP-TABLE ttx1
    FIELDS ttx1_par  LIKE ps_par
    FIELDS ttx1_desc_p LIKE pt_desc1
    FIELDS ttx1_comp LIKE ps_comp
    FIELDS ttx1_desc_c LIKE pt_desc1
    FIELDS ttx1_fix_qty  AS DECIMAL LABEL "Rollup-BOM qty"
    FIELDS ttx1_fix_cost LIKE pt_price LABEL "Cost"
    FIELDS ttx1_fix_mtl_tl LIKE pt_price LABEL "TL MTL"
    FIELDS ttx1_fix_lbr_tl LIKE pt_price LABEL "TL LBR"
    FIELDS ttx1_fix_bdn_tl LIKE pt_price LABEL "TL BDN"
    FIELDS ttx1_fix_ovh_tl LIKE pt_price LABEL "TL OVH"
    FIELDS ttx1_fix_sub_tl LIKE pt_price LABEL "TL SUB"
    FIELDS ttx1_fix_mtl_ll LIKE pt_price LABEL "LL MTL"
    FIELDS ttx1_fix_lbr_ll LIKE pt_price LABEL "LL LBR"
    FIELDS ttx1_fix_bdn_ll LIKE pt_price LABEL "LL BDN"
    FIELDS ttx1_fix_ovh_ll LIKE pt_price LABEL "LL OVH"
    FIELDS ttx1_fix_sub_ll LIKE pt_price LABEL "LL SUB"
    FIELDS ttx1_bom_qty  AS DECIMAL LABEL "Current-BOM qty"
    FIELDS ttx1_bom_cost LIKE pt_price LABEL "Cost"
    FIELDS ttx1_BOM_mtl_tl LIKE pt_price LABEL "TL MTL"
    FIELDS ttx1_BOM_lbr_tl LIKE pt_price LABEL "TL LBR"
    FIELDS ttx1_bom_bdn_tl LIKE pt_price LABEL "TL BDN"
    FIELDS ttx1_bom_ovh_tl LIKE pt_price LABEL "TL OVH"
    FIELDS ttx1_bom_sub_tl LIKE pt_price LABEL "TL SUB"
    FIELDS ttx1_bom_mtl_ll LIKE pt_price LABEL "LL MTL"
    FIELDS ttx1_bom_lbr_ll LIKE pt_price LABEL "LL LBR"
    FIELDS ttx1_bom_bdn_ll LIKE pt_price LABEL "LL BDN"
    FIELDS ttx1_bom_ovh_ll LIKE pt_price LABEL "LL OVH"
    FIELDS ttx1_bom_sub_ll LIKE pt_price LABEL "LL SUB"
    FIELDS ttx1_diffflag AS CHAR FORMAT "x(10)" LABEL "Different".

RUN xxpro-initial.
RUN xxpro-bud-fix (INPUT inp-part, INPUT inp-site, INPUT inp-date).
RUN xxpro-bud-bom (INPUT inp-part, INPUT inp-bomcode, INPUT inp-site, INPUT inp-date).
RUN xxpro-report.


/*-----------------------------------------------------*/
{yywobmcomma.i}
/*-----------------------------------------------------*/
PROCEDURE xxpro-initial:
    FOR EACH ttx1:
        DELETE ttx1.
    END.
    inp-results = "".
END PROCEDURE.
/*-----------------------------------------------------*/
PROCEDURE xxpro-report:
    FOR EACH ttx1 NO-LOCK:
        IF ttx1_fix_qty <> ttx1_bom_qty THEN inp-results = "changed".
        ELSE DO: 
            RUN xxpro-get-cost-det (INPUT ttx1_comp, 
                                    INPUT inp-site, 
                                    INPUT inp-date, 
                                    OUTPUT ttx1_bom_cost,
                                    OUTPUT ttx1_bom_mtl_tl,
                                    OUTPUT ttx1_bom_lbr_tl,
                                    OUTPUT ttx1_bom_bdn_tl,
                                    OUTPUT ttx1_bom_ovh_tl,
                                    OUTPUT ttx1_bom_sub_tl,
                                    OUTPUT ttx1_bom_mtl_ll,
                                    OUTPUT ttx1_bom_lbr_ll,
                                    OUTPUT ttx1_bom_bdn_ll,
                                    OUTPUT ttx1_bom_ovh_ll,
                                    OUTPUT ttx1_bom_sub_ll
                                    ).
            IF (ttx1_fix_cost <> ttx1_bom_cost)
            or (ttx1_fix_mtl_tl <> ttx1_bom_mtl_tl)
            or (ttx1_fix_lbr_tl <> ttx1_bom_lbr_tl)
            or (ttx1_fix_bdn_tl <> ttx1_bom_bdn_tl)
            or (ttx1_fix_ovh_tl <> ttx1_bom_ovh_tl)
            or (ttx1_fix_sub_tl <> ttx1_bom_sub_tl)
            or (ttx1_fix_mtl_ll <> ttx1_bom_mtl_ll)
            or (ttx1_fix_lbr_ll <> ttx1_bom_lbr_ll)
            or (ttx1_fix_bdn_ll <> ttx1_bom_bdn_ll)
            or (ttx1_fix_ovh_ll <> ttx1_bom_ovh_ll)
            or (ttx1_fix_sub_ll <> ttx1_bom_sub_ll)
            THEN inp-results = "changed".
        END.
        IF inp-results <> "" THEN LEAVE.
    END.
END PROCEDURE.

/*-----------------------------------------------------*/
PROCEDURE xxpro-bud-fix:
    DEFINE INPUT PARAMETER p_part AS CHAR.
    DEFINE INPUT PARAMETER p_site AS CHAR.
    DEFINE INPUT PARAMETER p_date AS DATE.

    FIND LAST xxwobmfm_mstr WHERE xxwobmfm_domain = global_domain 
    		and xxwobmfm_part = p_part
        AND xxwobmfm_site = p_site
        AND xxwobmfm_date_eff <= p_date
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE xxwobmfm_mstr THEN LEAVE.
    ELSE DO:
        FIND FIRST ttx1 WHERE ttx1_par = xxwobmfm_part AND ttx1_comp = xxwobmfm_part NO-ERROR.
        IF NOT AVAILABLE ttx1 THEN DO:
            CREATE ttx1.
            ASSIGN 
                ttx1_par  = xxwobmfm_part
                ttx1_comp = xxwobmfm_part
                .
        END.
        ASSIGN 
            ttx1_fix_qty  = 1
            ttx1_fix_cost = xxwobmfm_cost_tot
            ttx1_fix_mtl_tl = xxwobmfm_mtl_tl
            ttx1_fix_lbr_tl = xxwobmfm_lbr_tl
            ttx1_fix_bdn_tl = xxwobmfm_bdn_tl
            ttx1_fix_ovh_tl = xxwobmfm_ovh_tl
            ttx1_fix_sub_tl = xxwobmfm_sub_tl
            ttx1_fix_mtl_ll = xxwobmfm_mtl_ll
            ttx1_fix_lbr_ll = xxwobmfm_lbr_ll
            ttx1_fix_bdn_ll = xxwobmfm_bdn_ll
            ttx1_fix_ovh_ll = xxwobmfm_ovh_ll
            ttx1_fix_sub_ll = xxwobmfm_sub_ll
            .
        FOR EACH xxwobmfd_det  NO-LOCK
            WHERE xxwobmfd_domain = global_domain
            AND xxwobmfd_par = p_part
            AND xxwobmfd_site = p_site
            AND xxwobmfd_version = xxwobmfm_version:
            FIND FIRST ttx1 WHERE ttx1_par = xxwobmfd_par AND ttx1_comp = xxwobmfd_comp NO-ERROR.
            IF NOT AVAILABLE ttx1 THEN DO:
                CREATE ttx1.
                ASSIGN 
                    ttx1_par  = xxwobmfd_par
                    ttx1_comp = xxwobmfd_comp
                    .
            END.
            ASSIGN 
                ttx1_fix_qty  = ttx1_fix_qty + xxwobmfd_qty
                ttx1_fix_cost = xxwobmfd_cost_tot
                ttx1_fix_mtl_tl = xxwobmfd_mtl_tl
                ttx1_fix_lbr_tl = xxwobmfd_lbr_tl
                ttx1_fix_bdn_tl = xxwobmfd_bdn_tl
                ttx1_fix_ovh_tl = xxwobmfd_ovh_tl
                ttx1_fix_sub_tl = xxwobmfd_sub_tl
                ttx1_fix_mtl_ll = xxwobmfd_mtl_ll
                ttx1_fix_lbr_ll = xxwobmfd_lbr_ll
                ttx1_fix_bdn_ll = xxwobmfd_bdn_ll
                ttx1_fix_ovh_ll = xxwobmfd_ovh_ll
                ttx1_fix_sub_ll = xxwobmfd_sub_ll
                .
        END.
    END.
END PROCEDURE.


/*-----------------------------------------------------*/
PROCEDURE xxpro-bud-bom:
    DEFINE INPUT PARAMETER p_part AS CHAR.
    DEFINE INPUT PARAMETER p_bomcode AS CHAR.
    DEFINE INPUT PARAMETER p_site AS CHAR.
    DEFINE INPUT PARAMETER p_date AS DATE.
    
    IF p_bomcode = "" THEN p_bomcode = p_part.


    comp = p_bomcode.
    site = p_site.
    eff_date = p_date.

    
    /* explode part by standard picklist logic */
    {gprun.i ""woworla2.p""}


    FIND FIRST ttx1 WHERE ttx1_par = p_part AND ttx1_comp = p_part NO-ERROR.
    IF NOT AVAILABLE ttx1 THEN DO:
        CREATE ttx1.
        ASSIGN 
            ttx1_par  = p_part
            ttx1_comp = p_part
            .
    END.
    ASSIGN 
        ttx1_bom_qty  = 1
        ttx1_bom_cost = 0.

       
    for each pkdet
        where eff_date = ? or (eff_date <> ?
        and (pkstart = ? or pkstart <= eff_date)
        and (pkend = ? or eff_date <= pkend)
        /*and ((op = pkop) or (op = 0))*/
             )
        break by pkpart by pkop:
        
        FIND FIRST ttx1 WHERE ttx1_par = p_part AND ttx1_comp = pkpart NO-ERROR.
        IF NOT AVAILABLE ttx1 THEN DO:
            CREATE ttx1.
            ASSIGN 
                ttx1_par  = p_part
                ttx1_comp = pkpart
                .
        END.
        ASSIGN 
            ttx1_bom_qty  = ttx1_bom_qty + pkqty
            ttx1_bom_cost = 0.
    END.
END PROCEDURE.

