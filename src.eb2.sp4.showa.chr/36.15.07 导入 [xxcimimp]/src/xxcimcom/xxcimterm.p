/* SS - 081222.1 By: Bill Jiang */

{mfdeclre.i}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

DEFINE INPUT PARAMETER term_lbl LIKE lbl_long.
DEFINE OUTPUT PARAMETER LONG_lbl LIKE lbl_long.

FOR FIRST lbl_mstr NO-LOCK
   WHERE lbl_lang = GLOBAL_user_lang
   AND lbl_term = TERM_lbl
   :
   ASSIGN
      LONG_lbl = lbl_long
      .
END.
