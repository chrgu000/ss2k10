/*{mfdtitle.i}*/
{bcdeclre.i}
DEF VAR b_usr LIKE b_usr_id.
FORM 
    SKIP(1)
    b_usr COLON 20  LABEL "�û�"
    WITH FRAME unlock WIDTH 80 TITLE 'b_usr_wkfl���' THREE-D SIDE-LABELS. 
REPEAT :
  UPDATE b_usr WITH FRAME unlock.
  IF b_usr = g_user THEN DO:
      MESSAGE '����ɾ����ǰ�û���' VIEW-AS ALERT-BOX.
      UNDO,RETRY.
  END.
  ELSE DO:
  
 FIND FIRST b_usr_wkfl WHERE b_usr_id = b_usr EXCLUSIVE-LOCK NO-ERROR.
 
 IF AVAILABLE b_usr_wkfl THEN DO:

      DELETE b_usr_wkfl.
     FOR EACH b_sess_wkfl WHERE b_sess_usrid = b_usr EXCLUSIVE-LOCK:
         DELETE b_sess_wkfl.
     END.
       END.
 ELSE MESSAGE '���û�����ϵͳ�У�' VIEW-AS ALERT-BOX WARNING.
   
END.

END.
