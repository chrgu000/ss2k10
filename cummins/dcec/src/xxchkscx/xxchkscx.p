
DEFINE VARIABLE pct AS DECIMAL.
DEFINE VARIABLE dte AS DATE    NO-UNDO.
OUTPUT TO c:\scxref_old.txt.
PUT UNFORMAT "scx_po,scx_line,scx_part,scx_shipfrom,scx_shipto,scx_type,pod__chr01,pod_pr_list,pod_pur_cost,pod_ord_mult,dte,percent" SKIP.
FOR EACH scx_ref NO-LOCK WHERE scx_domain = "dcec" and scx_type = 2,
    EACH pod_det NO-LOCK WHERE pod_domain = "dcec" and pod_nbr = scx_po
     AND pod_line = scx_line:
    ASSIGN pct = 0 dte = ?.
    FOR EACH qad_wkfl NO-LOCK WHERE qad_domain = "dcec"
    	   and qad_key1 = "poa_det" AND qad_charfld[3] = scx_shipto
         AND qad_charfld[1] = scx_po AND qad_charfld[2] = scx_part
    BREAK BY qad_charfld[2] BY qad_datefld[1]:
        IF LAST-OF(qad_charfld[2]) THEN DO:
            ASSIGN pct = qad_decfld[1]
                   dte = qad_datefld[1].
        END.
    END.
    EXPORT DELIMITER "," scx_po scx_line scx_part scx_shipfrom scx_shipto scx_type pod__chr01 pod_pr_list pod_pur_cost pod_ord_mult dte pct.
END.