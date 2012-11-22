

/* display  Get_SO_SEQ_NO (INPUT PrintDate,INPUT Part,INPUT SalesOrder). */

FUNCTION Get_SO_SEQ_NO RETURNS CHARACTER (
     INPUT  wPrintDate	     AS character,
     INPUT  wPart	     AS character,
     INPUT  wSalesOrder      AS character).

     DEFINE VARIABLE OOKK AS INTEGER.
     FIND First QAD_WKFL where QAD_KEY1 = "BARCODE_GET_SO_SEQ_NO_BASE_ON_DATE_PART_SO" 
                           and QAD_KEY2 = trim(wPrintDate) + "@" + trim(wPart) + "@" + trim(wSalesOrder) no-error.
     IF  AVAILABLE(QAD_WKFL) Then Do:
         return QAD_CHARFLD[1].
     END.
     ELSE DO:
        OOKK = 1.
        FOR EACH  QAD_WKFL where QAD_KEY1 = "BARCODE_GET_SO_SEQ_NO_BASE_ON_DATE_PART_SO" 
                           and   QAD_KEY2  begins trim(wPrintDate) + "@" + trim(wPart) + "@" no-lock :
	      OOKK = OOKK + 1.      

	    END.

        CREATE QAD_WKFL.
        ASSIGN QAD_KEY1 = "BARCODE_GET_SO_SEQ_NO_BASE_ON_DATE_PART_SO"
               QAD_KEY2 = trim(wPrintDate) + "@" + trim(wPart) + "@" + trim(wSalesOrder)
               QAD_CHARFLD [1] = string ( OOKK ).

	    return string ( OOKK ).
     END.

END FUNCTION.