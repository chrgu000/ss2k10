/* SS - 091120.1 By: Bill Jiang */

{mfdeclre.i}

DEFINE INPUT PARAMETER entity_en LIKE en_entity.
DEFINE INPUT-OUTPUT PARAMETER name_en LIKE en_name.

FIND FIRST en_mstr
   WHERE en_entity = entity_en
   NO-LOCK NO-ERROR.
IF AVAILABLE en_mstr THEN DO:
   ASSIGN
      name_en = en_name
      .
END.
