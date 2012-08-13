{bcdeclre.i  }
DEFINE VARIABLE w AS HANDLE.

DEFINE BUTTON btn_addnew LABEL "添加".
DEFINE BUTTON btn_save LABEL "保存".
DEFINE BUTTON btn_delete LABEL "删除".
DEFINE BUTTON btn_save2 LABEL "保存".

DEFINE VARIABLE v AS LOGICAL.
DEF VAR ismodi AS LOGICAL.
DEF VAR ori_qad AS CHAR.
DEF VAR ori_usrbar AS CHAR.
DEF VAR ori_usr AS CHAR.
DEF VAR mpwd AS CHAR.
DEF VAR mpre_pwd AS CHAR. 
DEF TEMP-TABLE t_user LIKE b_usr_mstr
           FIELD t_sess LIKE g_sess
         INDEX t_sess IS PRIMARY t_sess ASC.
DEFINE QUERY q_user FOR t_user.
   
DEFINE BROWSE b_user QUERY q_user
    DISP b_usr_qad COLUMN-LABEL "QAD用户"
    b_usr_usrid COLUMN-LABEL "QAD用户ID" 
         b_usr_usrbar COLUMN-LABEL "条码用户ID"   
         b_usr_name COLUMN-LABEL "条码用户名" FORMAT 'x(12)'
          b_usr_pwdbar COLUMN-LABEL "条码密码" FORMAT 'x(10)'
          b_usr_PRINTER COLUMN-LABEL "条码打印机" FORMAT 'x(30)'
          b_usr_printer1 COLUMN-LABEL "打印机"
    ENABLE ALL
    WITH 10 DOWN SEPARATORS SIZE 96 BY 10 TITLE "用户维护" 
    THREE-D EXPANDABLE MULTIPLE.

DEFINE QUERY q_mnu FOR b_usrd_det.
DEFINE BROWSE b_mnu QUERY q_mnu 
    DISP b_usrd_usrid COLUMN-LABEL "用户ID" 
           b_usrd_program COLUMN-LABEL "程序名" FORMAT 'x(20)'
           b_usrd_exec COLUMN-LABEL "程序文件" FORMAT 'x(20)'
           b_usrd_sel COLUMN-LABEL "选取"
    ENABLE b_usrd_sel
WITH 10 DOWN SEPARATORS SIZE 96 BY 10 TITLE "用户维护" 
    THREE-D EXPANDABLE.
           

DEFINE FRAME a
    b_user SKIP

    btn_addnew btn_save btn_delete SKIP

    b_mnu SKIP

    btn_save2
    WITH WIDTH 100 THREE-D .

CREATE WINDOW w
    ASSIGN TITLE = bc_name
                 HEIGHT-CHARS = 25
                 WIDTH-CHARS = 100.

ON 'choose':U OF btn_addnew
DO:
  DISABLE btn_addnew WITH FRAME a.  
  
 /* b_user:sensitive = FALSE.*/
    GET LAST q_user.
    REPOSITION q_user TO ROW NUM-RESULTS("q_user").
   
    b_user:SELECT-FOCUSED-ROW().
     b_user:INSERT-ROW("after").
   
    RETURN.
END.
ON 'entry':U OF INPUT BROWSE b_user t_user.b_usr_usrbar
DO:
    ori_usrbar =  INPUT BROWSE b_user t_user.b_usr_usrbar.
END.

ON VALUE-CHANGED OF INPUT BROWSE b_user t_user.b_usr_usrbar
DO:
    IF NOT b_user:NEW-ROW IN FRAME a THEN DO:
        MESSAGE '条码用户不能更改！' VIEW-AS ALERT-BOX ERROR.
         INPUT BROWSE b_user t_user.b_usr_usrbar:SCREEN-VALUE = ori_usrbar.
        LEAVE.
    END.
END.



ON 'leave':U OF INPUT BROWSE b_user t_user.b_usr_usrbar
DO:
    
    IF STRING(INPUT BROWSE b_user t_user.b_usr_qad) = 'yes' THEN DO:
       INPUT BROWSE b_user t_user.b_usr_usrbar:SCREEN-VALUE = INPUT BROWSE b_user t_user.b_usr_usrid.
   END.
  
       
END.



ON 'leave':U OF INPUT BROWSE b_user t_user.b_usr_qad 
DO: 
     INPUT BROWSE b_user t_user.b_usr_qad NO-ERROR. 
    IF ERROR-STATUS:ERROR THEN DO:
         MESSAGE '必须为yes/no！' VIEW-AS ALERT-BOX.
         INPUT BROWSE b_user t_user.b_usr_qad:SCREEN-VALUE = 'yes'.
         
         LEAVE.
     END.
  
END.
ON 'entry':U OF INPUT BROWSE b_user t_user.b_usr_qad
DO:
    ori_qad = INPUT BROWSE b_user t_user.b_usr_qad.
END.
ON VALUE-CHANGED OF INPUT BROWSE b_user t_user.b_usr_qad
DO:
    IF NOT b_user:NEW-ROW IN FRAME a THEN DO:
        MESSAGE '已生成的用户类型不能更改！' VIEW-AS ALERT-BOX ERROR.
        INPUT BROWSE b_user t_user.b_usr_qad:SCREEN-VALUE = ori_qad.
        LEAVE.
    END.
    IF STRING(INPUT BROWSE b_user t_user.b_usr_qad) = 'yes' THEN DO:
       
        INPUT BROWSE b_user t_user.b_usr_usrbar:SCREEN-VALUE = INPUT BROWSE b_user t_user.b_usr_usrid.
        INPUT BROWSE b_user t_user.b_usr_pwdbar:SCREEN-VALUE = ''.
    END.
    ELSE DO:
        INPUT BROWSE b_user t_user.b_usr_usrbar:SCREEN-VALUE = ''.
        
    END.
   
END.
ON 'leave':U OF INPUT BROWSE b_user t_user.b_usr_pwdbar
DO:
   
    IF STRING(INPUT BROWSE b_user t_user.b_usr_qad) = 'yes' THEN DO:
       INPUT BROWSE b_user t_user.b_usr_pwdbar:SCREEN-VALUE = ''.
   END.
   ELSE DO:
       IF ismodi AND mpre_pwd <> INPUT BROWSE b_user t_user.b_usr_pwdbar:SCREEN-VALUE THEN mpwd = INPUT BROWSE b_user t_user.b_usr_pwdbar:SCREEN-VALUE.
   END.
  
END.
ON 'entry':U OF INPUT BROWSE b_user t_user.b_usr_pwdbar
DO:
     
       mpre_pwd =  INPUT BROWSE b_user t_user.b_usr_pwdbar:SCREEN-VALUE.
  
END.
ON 'entry':U OF INPUT BROWSE b_user t_user.b_usr_usrid
DO:
    ori_usr = INPUT BROWSE b_user t_user.b_usr_usrid.
END.
ON VALUE-CHANGED OF INPUT BROWSE b_user t_user.b_usr_usrid
DO:
    IF NOT b_user:NEW-ROW IN FRAME a THEN DO:
        MESSAGE 'QAD用户不能更改！' VIEW-AS ALERT-BOX ERROR.
         INPUT BROWSE b_user t_user.b_usr_usrid:SCREEN-VALUE = ori_usr.
        LEAVE.
    END.
END.
ON 'leave':U OF INPUT BROWSE b_user t_user.b_usr_usrid
DO:
   FIND FIRST usr_mstr WHERE usr_userid = INPUT BROWSE b_user t_user.b_usr_usrid NO-LOCK NO-ERROR.
       IF  NOT AVAILABLE usr_mstr OR INPUT BROWSE b_user t_user.b_usr_usrid = '' THEN DO:
           MESSAGE '无效QAD用户ID！' VIEW-AS ALERT-BOX ERROR.
           INPUT BROWSE b_user t_user.b_usr_usrid:SCREEN-VALUE = ''.
           IF STRING(INPUT BROWSE b_user t_user.b_usr_qad) = 'yes' THEN INPUT BROWSE b_user t_user.b_usr_usrbar:SCREEN-VALUE = ''.
           LEAVE.
       END.
    IF b_user:NEW-ROW IN FRAME a AND STRING(INPUT BROWSE b_user t_user.b_usr_qad) = 'yes' THEN DO:
         
        INPUT BROWSE b_user t_user.b_usr_usrbar:SCREEN-VALUE = INPUT BROWSE b_user t_user.b_usr_usrid.
   END.
END.
ON VALUE-CHANGED OF INPUT BROWSE b_user t_user.b_usr_pwdbar
DO:
    ismodi = YES.
END.


ON 'CHOOSE':U OF btn_save
DO:
  
  
    IF b_user:NEW-ROW IN FRAME a THEN DO:
        FIND FIRST t_user WHERE t_user.b_usr_usrbar = INPUT BROWSE b_user t_user.b_usr_usrbar NO-LOCK NO-ERROR.
    IF NOT AVAILABLE t_user THEN DO:
         IF STRING(INPUT BROWSE b_user t_user.b_usr_usrbar) = '' OR (string(INPUT BROWSE b_user t_user.b_usr_qad) = 'no' AND STRING(INPUT BROWSE b_user t_user.b_usr_usrbar) = string(INPUT BROWSE b_user t_user.b_usr_usrid))  THEN
           do:
             MESSAGE '条码用户不能为空，或不能与QAD用户同名!' VIEW-AS ALERT-BOX ERROR.
             INPUT BROWSE b_user t_user.b_usr_usrbar:SCREEN-VALUE = ''.
             LEAVE.
         END.
    IF string(INPUT BROWSE b_user t_user.b_usr_qad) = 'no' AND 
        (IF b_user:NEW-ROW IN FRAME a THEN (mpwd = '' OR LENGTH(mpwd) < 5)
             ELSE (IF ismodi AND mpre_pwd <> INPUT BROWSE b_user t_user.b_usr_pwdbar THEN (mpwd = '' OR LENGTH(mpwd) <5) ELSE NO))
                 THEN DO:
                 MESSAGE '非QAD用户密码设置不能超过为空，并5位以上！' VIEW-AS ALERT-BOX ERROR.
                LEAVE.
    END.
        CREATE t_user.
        t_sess = g_sess.
       ASSIGN INPUT BROWSE b_user t_user.b_usr_qad t_user.b_usr_usrid t_user.b_usr_name /*b_usr_pwd*/ t_user.b_usr_printer t_user.b_usr_printer1.
     IF NOT t_user.b_usr_qad  THEN  t_user.b_usr_pwdbar =  ENCODE(mpwd).
             ELSE t_user.b_usr_pwdbar = ''.
     
     IF t_user.b_usr_qad THEN t_user.b_usr_usrbar = t_user.b_usr_usrid.
                    ELSE t_user.b_usr_usrbar = INPUT BROWSE b_user t_user.b_usr_usrbar.              
     /* bmnd_nbr = BROWSE b_mnd  bmnd_det.bmnd_nbr.
                     bmnd_select = BROWSE b_mnd  bmnd_det.bmnd_select.
                     bmnd_name = BROWSE b_mnd  bmnd_det.bmnd_name.
                     bmnd_exec = BROWSE b_mnd  bmnd_det.bmnd_exec.
                     bmnd_module = BROWSE b_mnd  bmnd_det.bmnd_module.*/
        /*ASSIGN  bmnd_nbr = BROWSE b_mnd  bmnd_det.bmnd_nbr
                     bmnd_select = BROWSE b_mnd  bmnd_det.bmnd_select
                     bmnd_name = BROWSE b_mnd  bmnd_det.bmnd_name
                     bmnd_exec = BROWSE b_mnd  bmnd_det.bmnd_exec
                     bmnd_module = BROWSE b_mnd  bmnd_det.bmnd_module.*/
               CREATE b_usr_mstr.
               BUFFER-COPY t_user EXCEPT t_sess TO b_usr_mstr.
    END.
    ELSE do:
        MESSAGE '该用户已存在！' VIEW-AS ALERT-BOX ERROR.
        /* INPUT BROWSE b_user t_user.b_usr_usrbar:SCREEN-VALUE = ''.
         INPUT BROWSE b_user t_user.b_usr_usrid:SCREEN-VALUE = ''.
         INPUT BROWSE b_user t_user.b_usr_pwdbar:SCREEN-VALUE = ''.*/
         
    END.
    END.
    ELSE DO:
     DEFINE VARIABLE i AS INTEGER.
      IF STRING(INPUT BROWSE b_user t_user.b_usr_usrbar) = '' OR (string(INPUT BROWSE b_user t_user.b_usr_qad) = 'no' AND STRING(INPUT BROWSE b_user t_user.b_usr_usrbar) = string(INPUT BROWSE b_user t_user.b_usr_usrid))  THEN
           do:
             MESSAGE '条码用户不能为空，或不能与QAD用户同名！' VIEW-AS ALERT-BOX ERROR.
             INPUT BROWSE b_user t_user.b_usr_usrbar:SCREEN-VALUE = ''.
             LEAVE.
         END.
    IF string(INPUT BROWSE b_user t_user.b_usr_qad) = 'no' AND 
        (IF b_user:NEW-ROW IN FRAME a THEN (mpwd = '' OR LENGTH(mpwd) < 5)
             ELSE (IF ismodi AND mpre_pwd <> INPUT BROWSE b_user t_user.b_usr_pwdbar THEN (mpwd = '' OR LENGTH(mpwd) <5) ELSE NO))
                 THEN DO:
                 MESSAGE '非QAD用户密码设置不能超过为空，并5位以上！' VIEW-AS ALERT-BOX ERROR.
                LEAVE.
    END.   
     DO i = b_user:NUM-SELECTED-ROWS TO 1 by -1:
        GET CURRENT q_user EXCLUSIVE-LOCK NO-WAIT.
        ASSIGN  INPUT BROWSE b_user t_user.b_usr_qad t_user.b_usr_usrid
                                                t_user.b_usr_name
                                               /* b_usr_mstr.b_usr_pwd*/
                                                t_user.b_usr_printer
                                                t_user.b_usr_printer1
                                                t_user.b_usr_usrbar.
          IF NOT t_user.b_usr_qad  THEN  t_user.b_usr_pwdbar = IF ismodi AND mpre_pwd <> INPUT BROWSE b_user t_user.b_usr_pwdbar  THEN encode(mpwd) ELSE t_user.b_usr_pwdbar.
               ELSE t_user.b_usr_pwdbar = ''.
         IF t_user.b_usr_qad THEN t_user.b_usr_usrbar = t_user.b_usr_usrid.
                                    ELSE t_user.b_usr_usrbar = INPUT BROWSE b_user t_user.b_usr_usrbar.           
         b_user:FETCH-SELECTED-ROW(i).
         FIND FIRST b_usr_mstr WHERE b_usr_mstr.b_usr_usrbar =  t_user.b_usr_usrbar EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE b_usr_mstr THEN BUFFER-COPY t_user EXCEPT t_sess TO b_usr_mstr.
        END.
    END.
    
   OPEN QUERY q_user FOR EACH t_user WHERE t_sess = g_sess.
       ENABLE btn_addnew WITH FRAME a.
       mpwd = ''.
       mpre_pwd = ''.
           ismodi = NO.
        
END.


ON 'CHOOSE':U OF btn_save2
DO:
    DEFINE VARIABLE i AS INTEGER.
        DO i = b_mnu:NUM-SELECTED-ROWS TO 1 by -1:
             GET CURRENT q_mnu EXCLUSIVE-LOCK NO-WAIT.
         ASSIGN  INPUT BROWSE b_mnu b_usrd_det.b_usrd_sel.

         b_mnu:FETCH-SELECTED-ROW(i).
        END.
    RETURN.
END.

ON 'choose':U OF btn_delete
DO:
    /*b_user:sensitive=FALSE.*/
    DEFINE VARIABLE i AS INTEGER.
    DEFINE VARIABLE usr AS CHARACTER.
        DO i = b_user:NUM-SELECTED-ROWS TO 1 by -1:
            v = b_user:FETCH-SELECTED-ROW(i).
            GET CURRENT q_user EXCLUSIVE-LOCK.
           usr = t_user.b_usr_usrbar. 
           FIND FIRST b_usr_mstr WHERE b_usr_mstr.b_usr_usrbar = usr EXCLUSIVE-LOCK NO-ERROR.
           IF AVAILABLE b_usr_mstr THEN DELETE b_usr_mstr.
            b_user:DELETE-SELECTED-ROWS().
            DELETE t_user.
            FOR EACH b_usrd_det WHERE b_usrd_usrid = usr:
                DELETE b_usrd_det.
            END.
        END. 
        /*v = b_user:DELETE-SELECTED-ROWS().*/
    /*b_user:sensitive = TRUE.*/
    RETURN.
END.
/*ON 'leave':U OF INPUT BROWSE b_mnu b_usrd_sel
DO:
   IF string(INPUT BROWSE b_user t_user.b_usr_qad) <> 'yes' AND substr(INPUT BROWSE b_mnu b_usrd_exec,3,2) <> 'bc'
       AND STRING(INPUT BROWSE b_mnu b_usrd_sel) = 'yes' AND NOT STRING(INPUT BROWSE b_mnu b_usrd_program) BEGINS '条码管理'  THEN DO:
       
       b_usrd_det.b_usrd_sel:SCREEN-VALUE = 'NO'.
       MESSAGE '该用户没有权限使用此程序!' VIEW-AS ALERT-BOX ERROR.
   END.
   
END.*/
/*ON 'mouse-select-dblclick':U OF b_mnu
DO:
    b_usrd_det.b_usrd_sel = YES.
    RETURN.
END.*/

ON 'mouse-select-click':U OF b_user
DO:
    /*MESSAGE b_usr_mstr.b_usr_usrid VIEW-AS ALERT-BOX.*/
    DEFINE VARIABLE usr AS CHARACTER.
    ASSIGN usr = t_user.b_usr_usrbar NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE '该用户还未保存！' VIEW-AS ALERT-BOX ERROR.
        LEAVE.
    END.
   
    FOR EACH b_mnd_det WHERE b_mnd_exec <> '':
        FIND FIRST b_usrd_det EXCLUSIVE-LOCK WHERE b_usrd_usrid = usr AND b_usrd_exec = b_mnd_exec 
               NO-ERROR.
        IF NOT AVAILABLE b_usrd_det THEN DO:
        CREATE b_usrd_det.
        ASSIGN b_usrd_usrid = usr
                    b_usrd_program = b_mnd_name
                    b_usrd_exec = b_mnd_exec
                    b_usrd_sel = NO.
        END.
      ELSE DO:
         ASSIGN  b_usrd_program = b_mnd_name
                    /*b_usrd_exec = b_mnd_exec*/.
        END.
    END.
    FOR EACH b_usrd_det WHERE b_usrd_usrid = usr:
        FIND FIRST b_mnd_det NO-LOCK WHERE b_mnd_exec = b_usrd_exec NO-ERROR.
        IF NOT AVAILABLE b_mnd_det THEN
             DELETE b_usrd_det.
    END.
    OPEN QUERY q_mnu FOR EACH b_usrd_det WHERE
         b_usrd_usrid = usr.
    /*b_user:sensitive = TRUE.*/
    RETURN.
END.

/*REPEAT:*/
FOR EACH t_user WHERE t_sess = g_sess:
    DELETE t_user.
END.
FOR EACH b_usr_mstr NO-LOCK:
    CREATE t_user.
    BUFFER-COPY b_usr_mstr TO t_user
        ASSIGN t_sess = g_sess.

END.
 OPEN QUERY q_user FOR EACH t_user WHERE t_sess = g_sess.
 
   FOR EACH b_usrd_det:
        FIND FIRST b_mnd_det NO-LOCK WHERE b_mnd_exec = b_usrd_exec NO-ERROR.
        IF NOT AVAILABLE b_mnd_det THEN
             DELETE b_usrd_det.
    END.

    CURRENT-WINDOW = w.
    CURRENT-WINDOW:NAME = 'w'.
    ENABLE b_user b_mnu  btn_save btn_save2 btn_delete btn_addnew WITH FRAME a.
/*END.*/
{bctrail.i}
