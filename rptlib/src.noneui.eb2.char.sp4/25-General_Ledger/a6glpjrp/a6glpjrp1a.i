/* REVISION: 9.1      LAST MODIFIED: 09/22/05   BY: *SS - 20050922* Bill Jiang       */

/* SS - 20050922 - B */
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
    USE-INDEX gltr_ind1
    NO-LOCK
    BREAK BY gltr_project
    :
    ACCUMULATE gltr_amt (TOTAL BY gltr_project).
    IF LAST-OF(gltr_project) THEN DO:
        CREATE tta6glpjrp.
        ASSIGN
            tta6glpjrp_project = gltr_project
            tta6glpjrp_amt = (ACCUMULATE TOTAL BY gltr_project gltr_amt)
            .
        FIND FIRST pj_mstr WHERE pj_project = gltr_project NO-LOCK NO-ERROR.
        IF AVAILABLE pj_mstr THEN DO:
            ASSIGN
                tta6glpjrp_desc = pj_desc
                tta6glpjrp_type = pj_type
                .
        END.
    END.
END.
/* SS - 20050922 - E */
