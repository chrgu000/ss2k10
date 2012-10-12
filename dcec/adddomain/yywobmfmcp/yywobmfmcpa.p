/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 09/19/12  ECO: *SS-20120919.1*   */

{mfdeclre.i}


DEFINE INPUT  PARAMETER inp-part AS CHAR.
DEFINE INPUT  PARAMETER inp-bomcode AS CHAR.
DEFINE INPUT  PARAMETER inp-site AS CHAR.
DEFINE INPUT  PARAMETER inp-date AS DATE.



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

DEFINE NEW SHARED TEMP-TABLE ttx1  RCODE-INFORMATION
    FIELDS ttx1_par  LIKE ps_par     LABEL "父件"
    FIELDS ttx1_desc_p LIKE pt_desc1 LABEL "描述"
    FIELDS ttx1_comp LIKE ps_comp    LABEL "子件"
    FIELDS ttx1_desc_c LIKE pt_desc1 LABEL "描述"
    FIELDS ttx1_fix_qty  AS DECIMAL LABEL "卷集数量"
    FIELDS ttx1_fix_cost LIKE pt_price LABEL "卷集成本"
    FIELDS ttx1_bom_qty  AS DECIMAL LABEL "系统数量"
    FIELDS ttx1_bom_cost LIKE pt_price LABEL "系统成本"
    FIELDS ttx1_diffflag AS CHAR FORMAT "x(10)" LABEL "差异类型".

RUN xxpro-initial.
RUN xxpro-bud-fix (INPUT inp-part, INPUT inp-site, INPUT inp-date).
RUN xxpro-bud-bom (INPUT inp-part, INPUT inp-bomcode, INPUT inp-site, INPUT inp-date).
RUN xxpro-report.



/*-----------------------------------------------------*/
PROCEDURE xxpro-initial:
    FOR EACH ttx1:
        DELETE ttx1.
    END.
END PROCEDURE.
/*-----------------------------------------------------*/
PROCEDURE xxpro-report:
    FOR EACH ttx1 WITH WIDTH 250 DOWN STREAM-IO:
        FIND FIRST pt_mstr WHERE /* *SS-20120919.1*   */ pt_mstr.pt_domain = global_domain and pt_part = ttx1_par NO-LOCK NO-ERROR.
        IF AVAILABLE pt_mstr THEN ASSIGN ttx1_desc_p = pt_desc1 + pt_desc2.
        FIND FIRST pt_mstr WHERE /* *SS-20120919.1*   */ pt_mstr.pt_domain = global_domain and pt_part = ttx1_comp NO-LOCK NO-ERROR.
        IF AVAILABLE pt_mstr THEN ASSIGN ttx1_desc_c = pt_desc1 + pt_desc2.
        RUN xxpro-get-cost-tot (INPUT ttx1_comp, INPUT inp-site, INPUT inp-date, INPUT yes, OUTPUT ttx1_bom_cost).
        IF ttx1_bom_qty <> ttx1_fix_qty THEN ASSIGN
            ttx1_diffflag = ttx1_diffflag + IF ttx1_diffflag = "" THEN "" ELSE "," + "量差".
        IF ttx1_bom_cost <> ttx1_fix_cost THEN ASSIGN
            ttx1_diffflag = ttx1_diffflag + IF ttx1_diffflag = "" THEN "" ELSE "," + "价差".

        /*DISPLAY ttx1.*/
    END.

    {yywobmfmcpbw1.i}
END PROCEDURE.

/*-----------------------------------------------------*/
PROCEDURE xxpro-bud-fix:
    DEFINE INPUT PARAMETER p_part AS CHAR.
    DEFINE INPUT PARAMETER p_site AS CHAR.
    DEFINE INPUT PARAMETER p_date AS DATE.

    FIND LAST xxwobmfm_mstr WHERE /* *SS-20120919.1*   */ xxwobmfm_mstr.xxwobmfm_domain = global_domain and xxwobmfm_part = p_part
        AND xxwobmfm_site = p_site
        AND xxwobmfm_date_eff <= p_date
        USE-INDEX xxwobmfm_idx2
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
            ttx1_fix_qty  = 0
            ttx1_fix_cost = xxwobmfm_cost_tot.
        FOR EACH xxwobmfd_det  NO-LOCK
            WHERE  /* *SS-20120919.1*   */ xxwobmfd_det.xxwobmfd_domain = global_domain 
	    and xxwobmfd_par = p_part
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
                ttx1_fix_qty  = ttx1_fix_qty + xxwobmfd_qty
                ttx1_fix_cost = xxwobmfd_cost_tot
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
        ttx1_bom_qty  = 0
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

/*-----------------------------------------------------*/
{yywobmcomma.i}


