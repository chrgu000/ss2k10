DEFINE TEMP-TABLE t1
   FIELD t1_ref LIKE gltr_ref
   INDEX t1_ref t1_ref
   .
for each gltr_hist NO-LOCK 
   where gltr_eff_dt >= 07/01/06 
   and gltr_eff_dt < 08/01/06 
   AND gltr_tr_type = "AP"
   break by gltr_ref
   by gltr_batch
   :
   if last-of(gltr_batch) and (not last-of(gltr_ref)) THEN DO:
      CREATE t1.
      ASSIGN
         t1_ref = gltr_ref
         .
   END.
end.

OUTPUT TO "gltr_ap.xls".
EXPORT DELIMITER "~011" 
  "gltr_ref" "gltr_eff_dt" "gltr_ent_dt" "gltr_user"
  "gltr_line" "gltr_acc" "gltr_sub" "gltr_ctr" "gltr_project" "gltr_entity"
  "gltr_desc" "gltr_amt" "gltr_batch" "gltr_doc_typ" "gltr_doc"
   .
FOR EACH t1 NO-LOCK
   ,EACH gltr_hist NO-LOCK
   WHERE gltr_ref = t1_ref
   :
   EXPORT DELIMITER "~011" 
      gltr_ref gltr_eff_dt gltr_ent_dt gltr_user 
      gltr_line gltr_acc gltr_sub gltr_ctr gltr_project gltr_entity 
      gltr_desc gltr_amt gltr_batch gltr_doc_typ gltr_doc
      .
END.
OUTPUT CLOSE.
