{mfdtitle.i}
    DEFINE VAR ac_num  AS CHAR FORMAT "X(32)".
DEFINE VAR ac_desc AS CHAR FORMAT " X(62)".
DEFINE VAR ac_deg AS INT FORMAT ">9".
DEFINE VAR ac_sign1 AS CHAR FORMAT "X(3)".
DEFINE VAR ac_sign1_item AS CHAR FORMAT "X(62)".
DEFINE VAR ac_type AS CHAR FORMAT "X(22)".
DEFINE VAR ac_um AS CHAR FORMAT "X(12)".
DEFINE VAR ac_cr_dr AS LOGICAL FORMAT "DR/CR". /*AS CHAR FORMAT "x(6)" .*/
DEFINE VAR ac  AS CHAR FORMAT "x(300)".
define var direction as char.

DEFINE VAR entity LIKE acd_entity.

define var mactype as char.
DEFINE VAR path AS CHAR.
FORM
    SKIP(0.5)
    entity COLON 12 
  
    
    SKIP(1)
    path COLON 65 LABEL "Output Path"
    WITH FRAME a  WIDTH 80 THREE-D SIDE-LABELS.


 FIND FIRST gl_ctrl NO-LOCK NO-ERROR.  
 entity = gl_entity.
REPEAT:

UPDATE entity path WITH FRAME a.
/* IF FRAME-FIELD = "entity" THEN DO:*/
      IF entity = '' THEN do:
          entity = gl_entity.
        DISPLAY entity WITH FRAME a.
      END.
       /* END.*/






path = path + "KJKM.TXT".
OUTPUT TO value(path)  .
FOR EACH qad_wkfl WHERE qad_key1 = 'cas' NO-LOCK:
    
     FIND FIRST ac_mstr WHERE ac_mstr.ac_code = qad_wkfl.qad_charfld[2] NO-LOCK NO-ERROR.
   /* FIND FIRST ASC_mstr WHERE asc_mstr.ASC_cc = ac_mstr.ac_code NO-LOCK NO-ERROR.*/
    FIND FIRST fm_mstr WHERE fm_mstr.fm_fpos = AC_mstr.ac_fpos NO-LOCK  NO-ERROR.
    IF fm_mstr.fm_dr_cr  THEN direction = "借".
        ELSE direction = "贷".
             IF SUBSTRING(qad_key2,1,1) = "1" THEN mactype = "资产".
             IF SUBSTRING(qad_key2,1,1) = "2" THEN mactype = "负债".
             IF SUBSTRING(qad_key2,1,1) = "3" THEN mactype = "所有者权益".
             IF SUBSTRING(qad_key2,1,1) = "4"   THEN mactype = "成本".
            IF  SUBSTRING(qad_key2,1,1) = "5" THEN mactype = "损益".
    ac = '"' + qad_key2 + '"' + CHR(09) + '"' + qad_charfld[1] +  '"' + CHR(09) + '"' + string(qad_decfld[1]) + '"' + 
        CHR(09) + '"' + "0" + '"' + CHR(09) + '"' + '"' + CHR(09) + '"' + '"' + chr(09) + '"' 
        + mactype + '"' + chr(09) + '""' + CHR(09) + '"' + direction + '"'.
    
   PUT SKIP. 
   PUT UNFORMAT ac.
    
END.
 

OUTPUT CLOSE.
MESSAGE "KJKM has built!" VIEW-AS ALERT-BOX BUTTON OK. 
END.
