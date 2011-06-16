/* SS - 081104.1 By: Bill Jiang */

/* SS - 081104.1 - B */
/*
1. 第一版
2. "36.4.13 - 字段帮助维护"的CIM数据装入的替代
*/
/* SS - 081104.1 - E */

/* DISPLAY TITLE */
{mfdtitle.i "b+ "}

DEFINE INPUT PARAMETER FILE_name AS CHARACTER.

DEFINE TEMP-TABLE tt1
   FIELD tt1_lang LIKE flhd_lang
   FIELD tt1_field LIKE flhd_field
   FIELD tt1_call_pg LIKE flhd_call_pg
   FIELD tt1_line LIKE flhd_line
   FIELD tt1_text LIKE flhd_text
   INDEX i1 IS UNIQUE tt1_lang tt1_field tt1_call_pg tt1_line
   .

EMPTY TEMP-TABLE tt1.

INPUT FROM VALUE(FILE_name).
REPEAT :
   CREATE tt1.
   IMPORT DELIMITER "~011" tt1.
END.
INPUT CLOSE.

FOR EACH tt1 NO-LOCK
   BREAK BY tt1_lang
   BY tt1_field
   BY tt1_call_pg
   BY tt1_line
   :
   IF FIRST-OF(tt1_call_pg) THEN DO:
      FIND FIRST flhm_mst WHERE flhm_lang = tt1_lang AND flhm_field = tt1_field AND flhm_call_pg = tt1_call_pg NO-LOCK NO-ERROR.
      IF NOT AVAILABLE flhm_mst THEN DO:
         CREATE flhm_mst.
         ASSIGN
            flhm_lang = tt1_lang
            flhm_field = tt1_field
            flhm_call_pg = tt1_call_pg
            .
      END.

      FOR EACH flhd_det 
         WHERE flhd_lang = tt1_lang
         AND flhd_field = tt1_field
         AND flhd_call_pg = tt1_call_pg
         AND flhd_type = "user"
         :
         DELETE flhd_det.
      END.
   END. /* IF FIRST-OF(tt1_call_pg) THEN DO: */

   CREATE flhd_det.
   ASSIGN
      flhd_lang = tt1_lang
      flhd_field = tt1_field
      flhd_call_pg = tt1_call_pg
      flhd_type = "user"
      flhd_line = tt1_line
      flhd_text = tt1_text
      .
END.
