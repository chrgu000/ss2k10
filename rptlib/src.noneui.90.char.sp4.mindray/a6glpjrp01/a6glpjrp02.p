/* SS - Bill - B 2005.07.08 */
{a6glpjrp.i}

DEFINE INPUT PARAMETER begdt LIKE gltr_eff_dt.
DEFINE INPUT PARAMETER enddt LIKE gltr_eff_dt.
DEFINE INPUT PARAMETER acc LIKE ac_code.
DEFINE INPUT PARAMETER acc1 LIKE ac_code.
DEFINE INPUT PARAMETER sub LIKE sb_sub.
DEFINE INPUT PARAMETER sub1 LIKE sb_sub.
DEFINE INPUT PARAMETER entity LIKE en_entity.
DEFINE INPUT PARAMETER entity1 LIKE en_entity.

DEFINE VARIABLE amt LIKE gltr_amt.

amt = 0.
FOR EACH gltr_hist 
    WHERE gltr_entity >= entity
    AND gltr_entity <= entity1
    AND gltr_acc >= acc
    AND gltr_acc <= acc1
    AND gltr_sub >= sub
    AND gltr_sub <= sub1
    AND gltr_eff_dt >= begdt
    AND gltr_eff_dt <= enddt
    USE-INDEX gltr_ind1
    NO-LOCK
    BREAK BY gltr_project
    :
    amt = amt + gltr_amt.
    IF LAST-OF(gltr_project) THEN DO:
        CREATE wfpj.
        ASSIGN
            wfpj_acc = gltr_acc
            wfpj_sub = gltr_sub
            wfpj_project = gltr_project
            wfpj_amt = amt
            .
        amt = 0.
        FIND pj_mstr WHERE pj_project = gltr_project NO-LOCK NO-ERROR.
        IF AVAILABLE pj_mstr THEN DO:
            wfpj_desc = pj_desc.
            wfpj_type = pj_type.
        END.
    END.
END.
/* SS - Bill - E */
