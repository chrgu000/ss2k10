/*{mfdtitle.i}*/
DEF VAR b_usr LIKE b_sess_usrid.
DEF VAR isclear AS LOGICAL.
FORM 
    SKIP(1)
    b_usr COLON 20 LABEL "�û�"
    WITH FRAME unlock WIDTH 80  TITLE 'b_sess_wkfl���' THREE-D SIDE-LABELS. 
REPEAT :
    isclear = NO.
    UPDATE b_usr WITH FRAME unlock.
 FOR EACH b_sess_wkfl WHERE b_sess_usrid = b_usr EXCLUSIVE-LOCK :
 
 
      DELETE b_sess_wkfl.
      ISclear = YES.
 
 END.
IF NOT isclear THEN MESSAGE '���û��޳��������У�' VIEW-AS ALERT-BOX WARNING.

END.
