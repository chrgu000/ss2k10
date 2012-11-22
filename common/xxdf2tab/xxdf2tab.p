
DEFINE VARIABLE vdata AS CHARACTER FORMAT "x(18)"  NO-UNDO.
DEFINE VARIABLE vtype AS CHARACTER FORMAT "x(18)" NO-UNDO.
DEFINE VARIABLE vidxtype AS CHARACTER FORMAT "x(18)" NO-UNDO.
DEFINE VARIABLE vtable AS CHARACTER FORMAT "x(18)" NO-UNDO.
DEFINE VARIABLE vfield AS CHARACTER FORMAT "x(18)" NO-UNDO.
DEFINE VARIABLE vindex AS CHARACTER FORMAT "x(18)" NO-UNDO.
DEFINE VARIABLE varea AS CHARACTER FORMAT "x(18)" NO-UNDO.
DEFINE VARIABLE vdump-name AS CHARACTER FORMAT "x(18)" NO-UNDO.
DEFINE VARIABLE vDesc AS CHARACTER FORMAT "x(18)" NO-UNDO.
DEFINE VARIABLE vcpstream AS CHARACTER FORMAT "x(18)"  NO-UNDO.
DEFINE VARIABLE vformat AS CHARACTER FORMAT "x(18)"  NO-UNDO.
DEFINE VARIABLE vinitial AS CHARACTER FORMAT "x(18)"  NO-UNDO. 
DEFINE VARIABLE vsql-width AS INTEGER   NO-UNDO.
DEFINE VARIABLE vorder AS INTEGER   NO-UNDO.
DEFINE VARIABLE vposition AS INTEGER     NO-UNDO.
DEFINE VARIABLE vprimary AS CHARACTER FORMAT "x(8)"  NO-UNDO.
DEFINE VARIABLE vunique AS CHARACTER  FORMAT "x(3)" NO-UNDO.
DEFINE VARIABLE vINDEX-FIELD AS CHARACTER FORMAT "x(18)" NO-UNDO.
DEFINE VARIABLE vSort AS CHARACTER FORMAT "x(18)" NO-UNDO.
INPUT FROM D:\ss\trunk\cummins\dcec\src\ADD.df.
REPEAT :
    ASSIGN vdata = "". 
    IMPORT UNFORMAT vdata.
    ASSIGN vdata = TRIM(vdata).

    IF trim(ENTRY(1,vdata," ")) <> "" THEN DO:
        IF ENTRY(1,vdata," ") BEGINS "cpstream" THEN
           ASSIGN vcpstream = ENTRY(2,vdata,"=").
        ELSE DO: 
        CASE ENTRY(1,vdata," "):
             WHEN "ADD" THEN
                IF ENTRY(2,vdata," ") = "TABLE" THEN DO:
                    ASSIGN vtype = "TABLE".
                    ASSIGN vtable = ENTRY(3,vdata," ").
                END.
                ELSE IF ENTRY(2,vdata," ") = "FIELD" THEN DO:
                    ASSIGN vfield = ENTRY(3,vdata," ").
                    ASSIGN vtype = "FIELD".
                    ASSIGN vtable = ENTRY(5,vdata," ").
                END.
                ELSE IF ENTRY(2,vdata," ") = "INDEX" THEN DO:
                    ASSIGN vindex = ENTRY(3,vdata," ").
                    ASSIGN vtype = "INDEX".
                    ASSIGN vtable = ENTRY(5,vdata," ").
                END.
             WHEN "AREA" THEN ASSIGN varea = ENTRY(2,vdata, " ") + " " + ENTRY(3,vdata, " ").
             WHEN "DUMP-NAME" THEN ASSIGN vdump-name = ENTRY(2,vdata, " ").
             WHEN "DESCRIPTION" THEN ASSIGN vdesc = ENTRY(2,vdata, " ").
             WHEN "FORMAT" THEN ASSIGN vformat = ENTRY(2,vdata, " ").
             WHEN "INITIAL" THEN ASSIGN vinitial = ENTRY(2,vdata, " ").
             WHEN "POSITION" THEN ASSIGN vposition = INTEGER(ENTRY(2,vdata, " ")).
             WHEN "SQL-WIDTH" THEN ASSIGN vsql-width = INTEGER(ENTRY(2,vdata, " ")).
             WHEN "ORDER" THEN ASSIGN vorder = INTEGER(ENTRY(2,vdata, " ")).
             WHEN "UNIQUE" THEN ASSIGN vunique = "YES".
             WHEN "PRIMARY" THEN ASSIGN vprimary = "PRIMARY".
             WHEN "INDEX-FIELD" THEN
                 ASSIGN vidxtype = "INDEX-FIELD"
                        vindex-field = ENTRY(2,vdata, " ")
                        vsort = ENTRY(3,vdata, " ").
        END CASE.
        END.
    END.
    ELSE DO: 
         /* 
         IF vtype = "TABLE" THEN DO:
             DISPLAY vtype vtable vdesc vAREA  vDUMP-NAME  .
         END.
         ELSE IF vtype = "FIELD" THEN DO:
             DISPLAY vtype vtable vfield vdesc vformat vinitial vPosition vSQL-WIDTH vORDER.
         END.
         ELSE */
          IF vtype = "INDEX" AND vidxtype = "INDEX-FIELD" THEN DO: 
              DISPLAY vtype vindex-field vprimary vunique varea vtable vindex vsort.
              ASSIGN vprimary = "" vunique = ""  vidxtype = "".
         END.
         ASSIGN vtype = "". 
    END. 
END.
INPUT CLOSE.
