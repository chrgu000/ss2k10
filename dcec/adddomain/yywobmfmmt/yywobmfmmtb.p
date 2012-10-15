{mfdeclre.i}


DEFINE INPUT  PARAMETER inp-part AS CHAR.
DEFINE INPUT  PARAMETER inp-site AS CHAR.
DEFINE INPUT  PARAMETER inp-versionlist AS CHAR.




DEFINE TEMP-TABLE ttx1 RCODE-INFORMATION
    FIELDS ttx1_par    AS CHAR LABEL "成品" FORMAT "x(18)"
    FIELDS ttx1_desc_p AS CHAR LABEL "成品描述" FORMAT "x(24)"
    FIELDS ttx1_comp   AS CHAR LABEL "零件" FORMAT "x(18)"
    FIELDS ttx1_desc_c AS CHAR LABEL "零件描述" FORMAT "x(24)"
    FIELDS ttx1_v1_qty  AS DECIMAL LABEL "版本一数量"
    FIELDS ttx1_v1_cost LIKE pt_price LABEL "版本一成本"
    FIELDS ttx1_v1_mtl_tl like xxwobmfd_mtl_tl LABEL "本层物料"
    FIELDS ttx1_v1_lbr_tl like xxwobmfd_mtl_tl LABEL "本层人工"  
    FIELDS ttx1_v1_bdn_tl like xxwobmfd_mtl_tl LABEL "本层附加"
    FIELDS ttx1_v1_ovh_tl like xxwobmfd_mtl_tl LABEL "本层间接"
    FIELDS ttx1_v1_sub_tl like xxwobmfd_mtl_tl LABEL "本层外包"
    FIELDS ttx1_v1_mtl_ll like xxwobmfd_mtl_ll LABEL "底层物料"
    FIELDS ttx1_v1_lbr_ll like xxwobmfd_mtl_ll LABEL "底层人工"  
    FIELDS ttx1_v1_bdn_ll like xxwobmfd_mtl_ll LABEL "底层附加"
    FIELDS ttx1_v1_ovh_ll like xxwobmfd_mtl_ll LABEL "底层间接"
    FIELDS ttx1_v1_sub_ll like xxwobmfd_mtl_ll LABEL "底层外包"
    FIELDS ttx1_v2_qty  AS DECIMAL LABEL "版本二数量"
    FIELDS ttx1_v2_cost LIKE pt_price LABEL "版本二成本"
    FIELDS ttx1_v2_mtl_tl like xxwobmfd_mtl_tl LABEL "本层物料"
    FIELDS ttx1_v2_lbr_tl like xxwobmfd_mtl_tl LABEL "本层人工"  
    FIELDS ttx1_v2_bdn_tl like xxwobmfd_mtl_tl LABEL "本层附加"
    FIELDS ttx1_v2_ovh_tl like xxwobmfd_mtl_tl LABEL "本层间接"
    FIELDS ttx1_v2_sub_tl like xxwobmfd_mtl_tl LABEL "本层外包"
    FIELDS ttx1_v2_mtl_ll like xxwobmfd_mtl_ll LABEL "底层物料"
    FIELDS ttx1_v2_lbr_ll like xxwobmfd_mtl_ll LABEL "底层人工"  
    FIELDS ttx1_v2_bdn_ll like xxwobmfd_mtl_ll LABEL "底层附加"
    FIELDS ttx1_v2_ovh_ll like xxwobmfd_mtl_ll LABEL "底层间接"
    FIELDS ttx1_v2_sub_ll like xxwobmfd_mtl_ll LABEL "底层外包"
    FIELDS ttx1_diffflag AS CHAR FORMAT "x(20)" LABEL "差异".

DEFINE VARIABLE v_version1 AS INTEGER.
DEFINE VARIABLE v_version2 AS INTEGER.

IF inp-versionlist = "" THEN LEAVE.
IF NUM-ENTRIES(inp-versionlist) <> 2 THEN LEAVE.
ASSIGN v_version1 = INTEGER(ENTRY(1,inp-versionlist))
       v_version2 = INTEGER(ENTRY(2,inp-versionlist)).

RUN xxpro-initial.
RUN xxpro-bud-version1 (INPUT inp-part, INPUT inp-site, INPUT v_version1).
RUN xxpro-bud-version2 (INPUT inp-part, INPUT inp-site, INPUT v_version2).
RUN xxpro-report.



/*-----------------------------------------------------*/
PROCEDURE xxpro-initial:
    FOR EACH ttx1:
        DELETE ttx1.
    END.
END PROCEDURE.
/*-----------------------------------------------------*/
PROCEDURE xxpro-report:
    FOR EACH ttx1:
        FIND FIRST pt_mstr WHERE 
	/*SS-20120906.1-B*/
         pt_mstr.pt_domain = global_domain
        /*SS-20120906.1-E*/
	AND pt_part = ttx1_par NO-LOCK NO-ERROR.
        IF AVAILABLE pt_mstr THEN ASSIGN ttx1_desc_p = pt_desc1 + pt_desc2.
        FIND FIRST pt_mstr WHERE
	/*SS-20120906.1-B*/
         pt_mstr.pt_domain = global_domain
        /*SS-20120906.1-E*/
	AND pt_part = ttx1_comp NO-LOCK NO-ERROR.
        IF AVAILABLE pt_mstr THEN ASSIGN ttx1_desc_c = pt_desc1 + pt_desc2.
        IF ttx1_v1_qty <> ttx1_v2_qty THEN ASSIGN
            ttx1_diffflag = ttx1_diffflag + (IF ttx1_diffflag = "" THEN "" ELSE ",") + "量差".
        IF ttx1_v1_cost <> ttx1_v2_cost THEN ASSIGN
            ttx1_diffflag = ttx1_diffflag + (IF ttx1_diffflag = "" THEN "" ELSE ",") + "价差".
    END.

    {yywobmfmmtbw1.i}
END PROCEDURE.

/*-----------------------------------------------------*/
PROCEDURE xxpro-bud-version1:
    DEFINE INPUT PARAMETER p_part AS CHAR.
    DEFINE INPUT PARAMETER p_site AS CHAR.
    DEFINE INPUT PARAMETER p_version AS INTEGER.

    FIND FIRST xxwobmfm_mstr WHERE 
        /*SS-20120906.1-B*/
         xxwobmfm_mstr.xxwobmfm_domain = global_domain
        /*SS-20120906.1-E*/
	AND xxwobmfm_part = p_part
        AND xxwobmfm_site = p_site
        AND xxwobmfm_version = p_version
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
            ttx1_v1_qty  = 0
            ttx1_v1_cost = xxwobmfm_cost_tot
            ttx1_v1_mtl_tl = xxwobmfm_mtl_tl 
            ttx1_v1_lbr_tl = xxwobmfm_lbr_tl 
            ttx1_v1_bdn_tl = xxwobmfm_bdn_tl 
            ttx1_v1_ovh_tl = xxwobmfm_ovh_tl 
            ttx1_v1_sub_tl = xxwobmfm_sub_tl 
            ttx1_v1_mtl_ll = xxwobmfm_mtl_ll 
            ttx1_v1_lbr_ll = xxwobmfm_lbr_ll 
            ttx1_v1_bdn_ll = xxwobmfm_bdn_ll 
            ttx1_v1_ovh_ll = xxwobmfm_ovh_ll 
            ttx1_v1_sub_ll = xxwobmfm_sub_ll 
          .
        FOR EACH xxwobmfd_det  NO-LOCK
            WHERE 
	    /*SS-20120906.1-B*/
            xxwobmfd_det.xxwobmfd_domain = global_domain
            /*SS-20120906.1-E*/
	    AND xxwobmfd_par = p_part
            AND   xxwobmfd_site = p_site
            AND   xxwobmfd_version = xxwobmfm_version:
            FIND FIRST ttx1 WHERE ttx1_par = xxwobmfd_par AND ttx1_comp = xxwobmfd_comp NO-ERROR.
            IF NOT AVAILABLE ttx1 THEN DO:
                CREATE ttx1.
                ASSIGN 
                    ttx1_par  = xxwobmfd_par
                    ttx1_comp = xxwobmfd_comp
                    .
            END.
            ASSIGN 
            ttx1_v1_qty    = ttx1_v1_qty + xxwobmfd_qty
            ttx1_v1_cost   = xxwobmfd_cost_tot
            ttx1_v1_mtl_tl = xxwobmfd_mtl_tl 
            ttx1_v1_lbr_tl = xxwobmfd_lbr_tl 
            ttx1_v1_bdn_tl = xxwobmfd_bdn_tl 
            ttx1_v1_ovh_tl = xxwobmfd_ovh_tl 
            ttx1_v1_sub_tl = xxwobmfd_sub_tl 
            ttx1_v1_mtl_ll = xxwobmfd_mtl_ll 
            ttx1_v1_lbr_ll = xxwobmfd_lbr_ll 
            ttx1_v1_bdn_ll = xxwobmfd_bdn_ll 
            ttx1_v1_ovh_ll = xxwobmfd_ovh_ll 
            ttx1_v1_sub_ll = xxwobmfd_sub_ll 
                .
        END.
    END.
END PROCEDURE.
/*-----------------------------------------------------*/
PROCEDURE xxpro-bud-version2:
    DEFINE INPUT PARAMETER p_part AS CHAR.
    DEFINE INPUT PARAMETER p_site AS CHAR.
    DEFINE INPUT PARAMETER p_version AS INTEGER.

    FIND FIRST xxwobmfm_mstr WHERE 
        /*SS-20120906.1-B*/
        xxwobmfm_mstr.xxwobmfm_domain = global_domain
        /*SS-20120906.1-E*/
	AND xxwobmfm_part = p_part
        AND xxwobmfm_site = p_site
        AND xxwobmfm_version = p_version
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
            ttx1_v2_qty  = 0
            ttx1_v2_cost = xxwobmfm_cost_tot
            ttx1_v2_mtl_tl = xxwobmfm_mtl_tl 
            ttx1_v2_lbr_tl = xxwobmfm_lbr_tl 
            ttx1_v2_bdn_tl = xxwobmfm_bdn_tl 
            ttx1_v2_ovh_tl = xxwobmfm_ovh_tl 
            ttx1_v2_sub_tl = xxwobmfm_sub_tl 
            ttx1_v2_mtl_ll = xxwobmfm_mtl_ll 
            ttx1_v2_lbr_ll = xxwobmfm_lbr_ll 
            ttx1_v2_bdn_ll = xxwobmfm_bdn_ll 
            ttx1_v2_ovh_ll = xxwobmfm_ovh_ll 
            ttx1_v2_sub_ll = xxwobmfm_sub_ll 
            .
        FOR EACH xxwobmfd_det  NO-LOCK
            WHERE 
	    /*SS-20120906.1-B*/
            xxwobmfd_det.xxwobmfd_domain = global_domain
            /*SS-20120906.1-E*/
	    AND   xxwobmfd_par = p_part
            AND   xxwobmfd_site = p_site
            AND   xxwobmfd_version = xxwobmfm_version:
            FIND FIRST ttx1 WHERE ttx1_par = xxwobmfd_par AND ttx1_comp = xxwobmfd_comp NO-ERROR.
            IF NOT AVAILABLE ttx1 THEN DO:
                CREATE ttx1.
                ASSIGN 
                    ttx1_par  = xxwobmfd_par
                    ttx1_comp = xxwobmfd_comp
                    .
            END.
            ASSIGN 
                ttx1_v2_qty  = ttx1_v2_qty + xxwobmfd_qty
                ttx1_v2_cost = xxwobmfd_cost_tot
            ttx1_v2_mtl_tl = xxwobmfd_mtl_tl 
            ttx1_v2_lbr_tl = xxwobmfd_lbr_tl 
            ttx1_v2_bdn_tl = xxwobmfd_bdn_tl 
            ttx1_v2_ovh_tl = xxwobmfd_ovh_tl 
            ttx1_v2_sub_tl = xxwobmfd_sub_tl 
            ttx1_v2_mtl_ll = xxwobmfd_mtl_ll 
            ttx1_v2_lbr_ll = xxwobmfd_lbr_ll 
            ttx1_v2_bdn_ll = xxwobmfd_bdn_ll 
            ttx1_v2_ovh_ll = xxwobmfd_ovh_ll 
            ttx1_v2_sub_ll = xxwobmfd_sub_ll 
                .
        END.
    END.
END PROCEDURE.


