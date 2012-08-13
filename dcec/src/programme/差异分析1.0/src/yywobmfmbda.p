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
    FIND FIRST xxwobmfm_mstr WHERE xxwobmfm_part = p_part 
        AND xxwobmfm_site = p_site
        AND xxwobmfm_version = p_version
        NO-LOCK NO-ERROR.
    IF AVAILABLE xxwobmfm_mstr THEN DO:
        NEXT.
    END.
    
    /* explode part by standard picklist logic */
    {gprun.i ""woworla2.p""}
    
    CREATE xxwobmfm_mstr.
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

    FOR EACH xxwobmfd_det WHERE xxwobmfd_par = xxwobmfm_part
        AND xxwobmfd_site    = xxwobmfm_site
        AND xxwobmfd_version = xxwobmfm_version:
        DELETE xxwobmfd_det.
    END.


    for each pkdet
        where eff_date = ? or (eff_date <> ?
        and (pkstart = ? or pkstart <= eff_date)
        and (pkend = ? or eff_date <= pkend)
        /*and ((op = pkop) or (op = 0))*/
             )
        break by pkpart by pkop:
        
        FIND FIRST xxwobmfd_det 
            WHERE xxwobmfd_par   = xxwobmfm_part
            AND xxwobmfd_site    = xxwobmfm_site
            AND xxwobmfd_version = xxwobmfm_version
            AND xxwobmfd_comp    = pkpart
            AND xxwobmfd_op      = pkop
            NO-ERROR.
        IF NOT AVAILABLE xxwobmfd_det THEN DO:
            CREATE xxwobmfd_det.
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
    END.
    
    FOR EACH xxwobmfd_det WHERE xxwobmfd_par = xxwobmfm_part
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
    FIND LAST xxwobmfm_mstr WHERE xxwobmfm_part = p_part
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
