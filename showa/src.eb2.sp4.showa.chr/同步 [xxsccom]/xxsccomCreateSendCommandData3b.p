/* SS - 090908.1 By: Bill Jiang */

/* SS - 090908.1 - RNB
[090908.1]

    <table entityName="com.ss.scm.domain.PodDetEn">

[090908.1]

SS - 090908.1 - RNE */

{mfdeclre.i}

DEFINE INPUT PARAMETER tableName AS CHARACTER.

DEFINE VARIABLE indent AS INTEGER INITIAL 2.
DEFINE VARIABLE indent1 AS CHARACTER.

DEFINE VARIABLE entityName AS CHARACTER.
DEFINE VARIABLE i1 AS INTEGER.

indent1 = FILL(' ',indent).

/* 临时文件前缀 */
FIND FIRST mfc_ctrl
   WHERE mfc_field = "SoftspeedSCM_Request_Entity"
   NO-LOCK NO-ERROR.
IF NOT AVAILABLE mfc_ctrl THEN DO:
   CREATE mfc_ctrl.
   ASSIGN
      mfc_field = "SoftspeedSCM_Request_Entity"
      mfc_module = "SoftspeedSCM_Request_Entity"
      mfc_seq = 1
      mfc_char = "com.ss.scm.domain"
      .
   RELEASE mfc_ctrl.
END.

PUT UNFORMATTED indent1 + "<table entityName=~"" + mfc_char + ".".
entityName = "".
DO i1 = 1 TO LENGTH(tableName):
   IF i1 = 1 THEN DO:
      entityName = UPPER(SUBSTRING(tableName,i1,1)).
      NEXT.
   END.
   ELSE IF SUBSTRING(tableName,i1,1) = "_" THEN DO:
      i1 = i1 + 1.
      entityName = entityName + UPPER(SUBSTRING(tableName,i1,1)).
      NEXT.
   END.
   ELSE DO:
      entityName = entityName + SUBSTRING(tableName,i1,1).
   END.
END.
entityName = entityName + "En".
PUT UNFORMATTED entityName + "~">" SKIP.
