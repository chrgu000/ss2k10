    DEFINE VARIABLE codecount AS INTEGER.
    DEFINE VARIABLE idv AS INTEGER.
    DEFINE VARIABLE codeqty AS DECIMAL.
    DEFINE VARIABLE idvqty AS DECIMAL.
    DEFINE VARIABLE varqty AS DECIMAL.

    DEFINE VARIABLE hExcel      AS COM-HANDLE       NO-UNDO.

    ASSIGN idv = 1.


    OUTPUT TO value("d:\var.csv") NO-CONVERT.
    EXPORT DELIMITER ","
        "条码" "零件" "标准数" "实际数" "标准量" "实际量" "差异量".
    FOR EACH b_wis_wkfl NO-LOCK WHERE b_wis_date <= 04/29/08 BREAK BY b_wis_code :
    ACCUMULATE b_wis_code (COUNT BY b_wis_code).
    IF LAST-OF(b_wis_code) THEN DO:
        codecount = ACCUMU COUNT BY b_wis_code b_wis_code.
        codeqty =  codecount * b_wis_qty.
        idvqty = b_wis_qty.
        varqty = codeqty - idvqty.
        EXPORT DELIMITER ","
          b_wis_code b_wis_part idv codecount idvqty  codeqty varqty .
     END.
   END.

  OUTPUT CLOSE.
  CREATE "Excel.Application" hExcel.
  hExcel:VISIBLE = TRUE.                         
  hExcel:WorkBooks:OPEN( "d:\var.csv"). 
  RELEASE OBJECT hExcel. 

