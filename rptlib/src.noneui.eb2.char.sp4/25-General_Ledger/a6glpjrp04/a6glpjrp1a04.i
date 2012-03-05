/* REVISION: 9.1      LAST MODIFIED: 02/16/06   BY: *SS - 20060216* Bill Jiang       */

FOR EACH gltr_hist NO-LOCK
    WHERE gltr_eff_dt >= begdt
    AND gltr_eff_dt <= enddt
    USE-INDEX gltr_eff_dt
    BREAK 
    BY gltr_entity
    BY gltr_acc
    BY gltr_project
    :
    ACCUMULATE gltr_amt (TOTAL BY gltr_entity BY gltr_acc BY gltr_project).
    IF LAST-OF(gltr_project) THEN DO:
        CREATE tta6glpjrp04.
        ASSIGN
            tta6glpjrp04_entity = gltr_entity
            tta6glpjrp04_acc = gltr_acc
            tta6glpjrp04_project = gltr_project
            tta6glpjrp04_amt = (ACCUMULATE TOTAL BY gltr_project gltr_amt)
            .
    END.
END.
