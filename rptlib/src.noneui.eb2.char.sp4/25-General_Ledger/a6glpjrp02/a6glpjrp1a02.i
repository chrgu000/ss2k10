/* REVISION: 9.1      LAST MODIFIED: 12/12/05   BY: *SS - 20051212* Bill Jiang       */

/* SS - 20051212 - B */
FOR EACH gltr_hist 
    WHERE gltr_entity >= entity
    AND gltr_entity <= entity1
    AND gltr_acc >= acc
    AND gltr_acc <= acc1
    AND gltr_sub >= sub
    AND gltr_sub <= sub1
    AND gltr_ctr >= ctr
    AND gltr_ctr <= ctr1
    AND gltr_eff_dt >= begdt
    AND gltr_eff_dt <= enddt
    AND gltr_tr_type >= tr_type
    AND gltr_tr_type <= tr_type1
    USE-INDEX gltr_ind1
    NO-LOCK
    BREAK BY gltr_project
    BY gltr_ctr
    :
    ACCUMULATE gltr_amt (TOTAL BY gltr_project BY gltr_ctr).
    IF LAST-OF(gltr_ctr) THEN DO:
        CREATE tta6glpjrp02.
        ASSIGN
            tta6glpjrp02_project = gltr_project
            tta6glpjrp02_ctr = gltr_ctr
            tta6glpjrp02_amt = (ACCUMULATE TOTAL BY gltr_ctr gltr_amt)
            .
        FIND FIRST pj_mstr WHERE pj_project = gltr_project NO-LOCK NO-ERROR.
        IF AVAILABLE pj_mstr THEN DO:
            ASSIGN
                tta6glpjrp02_desc = pj_desc
                tta6glpjrp02_type = pj_type
                .
        END.
    END.
END.
/* SS - 20051212 - E */
