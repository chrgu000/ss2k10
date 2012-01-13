OUTPUT TO "gltr.xls".
EXPORT DELIMITER ";"
   "END_dt"
   "eff_dt"
   "ref"
   "LINE"
   "doc_typ"
   "doc"
   "amt"
   "type"
   "program"
   .
FOR EACH gltr_hist NO-LOCK
   WHERE gltr_domain = 'prod'
   AND gltr_eff_dt >= 01/01/09
   ,EACH tr_hist NO-LOCK
   WHERE tr_domain = 'prod'
   AND tr_trnbr = INTEGER(gltr_doc)
   :
   IF gltr_amt - ROUND(gltr_amt,2) <> 0 THEN DO:
      EXPORT DELIMITER ";"
         gltr_ent_dt
         gltr_eff_dt
         gltr_ref
         gltr_line
         gltr_doc_typ
         gltr_doc
         /*
         gltr_amt FORMAT "->>,>>>,>>>.9999"
         */
         gltr_amt
         tr_type
         tr_program
         .
   END.
END.
OUTPUT CLOSE.
