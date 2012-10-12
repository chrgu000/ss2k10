/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 09/19/12  ECO: *SS-20120919.1*   */

PROCEDURE xxpro-get-cost-det:
    DEFINE INPUT PARAMETER p_part AS CHAR.
    DEFINE INPUT PARAMETER p_site AS CHAR.
    DEFINE INPUT PARAMETER p_date AS DATE.
    DEFINE OUTPUT PARAMETER p_cost   AS DECIMAL.
    DEFINE OUTPUT PARAMETER p_mtl_tl AS DECIMAL.
    DEFINE OUTPUT PARAMETER p_lbr_tl AS DECIMAL.
    DEFINE OUTPUT PARAMETER p_bdn_tl AS DECIMAL.
    DEFINE OUTPUT PARAMETER p_ovh_tl AS DECIMAL.
    DEFINE OUTPUT PARAMETER p_sub_tl AS DECIMAL.
    DEFINE OUTPUT PARAMETER p_mtl_ll AS DECIMAL.
    DEFINE OUTPUT PARAMETER p_lbr_ll AS DECIMAL.
    DEFINE OUTPUT PARAMETER p_bdn_ll AS DECIMAL.
    DEFINE OUTPUT PARAMETER p_ovh_ll AS DECIMAL.
    DEFINE OUTPUT PARAMETER p_sub_ll AS DECIMAL.


    DEFINE VARIABLE v_costset AS CHARACTER.
    DEFINE VARIABLE cst_date  AS DATE.
    DEFINE VARIABLE trrecno   AS RECID.

    assign
        p_cost    = 0
        p_mtl_tl  = 0
		    p_lbr_tl  = 0
		    p_bdn_tl  = 0
		    p_ovh_tl  = 0
		    p_sub_tl  = 0
		    p_mtl_ll  = 0
		    p_lbr_ll  = 0
		    p_bdn_ll  = 0
		    p_ovh_ll  = 0
		    p_sub_ll  = 0.
		
    v_costset  = "STANDARD".

    FIND FIRST in_mstr WHERE  /* *SS-20120919.1*   */ in_mstr.in_domain = global_domain and in_part = p_part AND in_site = p_site NO-LOCK NO-ERROR.
    IF AVAILABLE IN_mstr AND IN_gl_set <> "" THEN ASSIGN v_costset = IN_gl_set.

    FIND FIRST sct_det 
        WHERE /* *SS-20120919.1*   */ sct_det.sct_domain = global_domain 
	and sct_part = p_part
        AND sct_site = p_site
        AND sct_sim  = v_costset
        NO-LOCK NO-ERROR.
    IF AVAILABLE sct_det THEN DO:
        ASSIGN 
            p_cost    = sct_cst_tot
            p_mtl_tl  = sct_mtl_tl
            p_lbr_tl  = sct_lbr_tl
            p_bdn_tl  = sct_bdn_tl
            p_ovh_tl  = sct_ovh_tl
            p_sub_tl  = sct_sub_tl
            p_mtl_ll  = sct_mtl_ll 
            p_lbr_ll  = sct_lbr_ll 
            p_bdn_ll  = sct_bdn_ll 
            p_ovh_ll  = sct_ovh_ll 
            p_sub_ll  = sct_sub_ll.
    END.
END.

/*********************************************/
PROCEDURE xxpro-get-cost-tot:
    DEFINE INPUT PARAMETER p_part AS CHAR.
    DEFINE INPUT PARAMETER p_site AS CHAR.
    DEFINE INPUT PARAMETER p_date AS DATE.
    DEFINE INPUT PARAMETER p_asofflag AS LOGICAL.
    DEFINE OUTPUT PARAMETER p_cost_tot AS DECIMAL.

    DEFINE VARIABLE v_cost    AS DECIMAL EXTENT 6.
    DEFINE VARIABLE v_costset AS CHARACTER.
    DEFINE VARIABLE cst_date  AS DATE.
    DEFINE VARIABLE trrecno   AS RECID.

    v_cost     = 0.
    p_cost_tot = 0.
    IF p_date = ? THEN p_date = TODAY.
    v_costset  = "STANDARD".

    FIND FIRST in_mstr WHERE /* *SS-20120919.1*   */ in_mstr.in_domain = global_domain and in_part = p_part AND in_site = p_site NO-LOCK NO-ERROR.
    IF AVAILABLE IN_mstr AND IN_gl_set <> "" THEN ASSIGN v_costset = IN_gl_set.

    FIND FIRST sct_det 
        WHERE  /* *SS-20120919.1*   */ sct_det.sct_domain = global_domain 
	and sct_part = p_part
        AND sct_site = p_site
        AND sct_sim  = v_costset
        NO-LOCK NO-ERROR.
    IF AVAILABLE sct_det THEN DO:
        ASSIGN v_cost[1] = sct_cst_tot.
    END.

 
    IF p_asofflag = YES THEN DO:
        for first tr_hist
            fields(tr_part tr_effdate tr_site tr_loc tr_ship_type
                   tr_qty_loc tr_bdn_std tr_lbr_std tr_mtl_std tr_ovh_std
                   tr_price tr_status tr_sub_std tr_trnbr tr_type)
            where  /* *SS-20120919.1*   */ tr_hist.tr_domain = global_domain 
	    and  tr_part    =  p_part
            and   tr_effdate >= p_date + 1
            and   tr_site    =  p_site
            and   tr_type    =  "CST-ADJ"
            no-lock use-index tr_part_eff:
        end. /* FOR FIRST TR_HIST */

        if available tr_hist then do:

            /* GET THE FIRST RECORD ENTERED EVEN IF TR_PART_EFF*/
            /* ISN'T IN TRANSACTION NUMBER SEQUENCE            */

            cst_date = tr_effdate.

            for each tr_hist
                FIELDS(tr_part tr_effdate tr_site tr_loc tr_ship_type
                       tr_qty_loc tr_bdn_std tr_lbr_std tr_mtl_std tr_ovh_std
                       tr_price tr_status tr_sub_std tr_trnbr tr_type)
                where /* *SS-20120919.1*   */ tr_hist.tr_domain = global_domain  
		and tr_part    = p_part
                and   tr_effdate = cst_date
                and   tr_site    = p_site
                and   tr_type    = "CST-ADJ"
                use-index tr_part_eff
                by tr_trnbr.

                trrecno = recid(tr_hist).
                leave.
            end. /* FOR EACH TR_HIST */

            for first tr_hist
                fields(tr_part tr_effdate tr_site tr_loc tr_ship_type
                       tr_qty_loc tr_bdn_std tr_lbr_std tr_mtl_std tr_ovh_std
                       tr_price tr_status tr_sub_std tr_trnbr tr_type)
                where recid(tr_hist) = trrecno no-lock:
            end. /* FOR FIRST TR_HIST */

            ASSIGN v_cost[1] = (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std).


            if tr_price <> v_cost[1] THEN DO:
                /*question: how to know detail cost elements changed, issue.*/
                v_cost[1] = v_cost[1] - tr_price.
            END.
        END.
    END.

    ASSIGN p_cost_tot = v_cost[1].
END PROCEDURE.

