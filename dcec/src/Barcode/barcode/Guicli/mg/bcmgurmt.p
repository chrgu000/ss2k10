DEFINE VARIABLE w AS HANDLE.
/*
DEFINE BUTTON btn_addnew LABEL "AddNew".
DEFINE BUTTON btn_save LABEL "Save".
DEFINE BUTTON btn_delete LABEL "Delete".*/
DEFINE BUTTON btn_save LABEL "保存" SIZE 8 BY 1.5.
DEFINE BUTTON btn_addnew1 LABEL "AddNew".
DEFINE VARIABLE v AS LOGICAL.


DEFINE QUERY q_user FOR b_usr_mstr.
DEFINE BROWSE b_user QUERY q_user
    DISP b_usr_usrid COLUMN-LABEL "用户ID" 
           b_usr_name COLUMN-LABEL "用户名"
           b_usr_pwd COLUMN-LABEL "密码"
           b_usr_printer COLUMN-LABEL "打印机"
    ENABLE b_usr_printer
    WITH 12 DOWN SEPARATORS SIZE 96 BY 10 TITLE "用户浏览" 
    THREE-D EXPANDABLE .

DEFINE QUERY q_mnu FOR b_usrd_det.
DEFINE BROWSE b_mnu QUERY q_mnu 
    DISP b_usrd_usrid COLUMN-LABEL "用户ID" 
           b_usrd_program COLUMN-LABEL "程序名" 
           b_usrd_exec COLUMN-LABEL "程序文件" FORMAT "x(15)"
           b_usrd_sel COLUMN-LABEL "选取"
    ENABLE  b_usrd_sel
WITH 12 DOWN SEPARATORS SIZE 96 BY 10 TITLE "权限浏览" 
    THREE-D EXPANDABLE.
           

DEFINE FRAME a
    b_user  SKIP

   /* btn_addnew btn_save btn_delete SKIP*/ SKIP(1)

    b_mnu SKIP
SKIP(1)
   btn_save COLON 40
    WITH SIZE 98 BY 25 THREE-D .

CREATE WINDOW w
    ASSIGN TITLE = "用户权限维护"
                 HEIGHT-CHARS = 25
                 WIDTH-CHARS = 100.


/*ON 'choose':U OF btn_addnew
DO:
    b_user:READ-ONLY = FALSE.
    GET LAST q_user.
    REPOSITION q_user TO ROW NUM-RESULTS("q_user").
    b_user:INSERT-ROW("after").
    RETURN.
END.

ON 'choose':U OF btn_addnew1
DO:
    b_mnu:READ-ONLY = FALSE.
    GET LAST q_mnu.
    REPOSITION q_mnu TO ROW NUM-RESULTS("q_mnu").
    b_mnu:INSERT-ROW("after").
    RETURN.
END.


ON 'CHOOSE':U OF btn_save
DO:

    IF b_user:NEW-ROW IN FRAME a THEN DO:
       CREATE b_usr_mstr.
       ASSIGN INPUT BROWSE b_user b_usr_usrid b_usr_name b_usr_pwd.

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

    END.
    ELSE DO:
     DEFINE VARIABLE i AS INTEGER.
        DO i = b_user:NUM-SELECTED-ROWS TO 1 by -1:
        GET CURRENT q_user EXCLUSIVE-LOCK NO-WAIT.
        ASSIGN  INPUT BROWSE b_user b_usr_mstr.b_usr_usrid
                                                b_usr_mstr.b_usr_name
                                                b_usr_mstr.b_usr_pwd.
         b_user:FETCH-SELECTED-ROW(i).
        END.
    END.

END.


ON 'CHOOSE':U OF btn_save
DO:
    DEFINE VARIABLE i AS INTEGER.
    IF b_user:NEW-ROW IN FRAME a THEN DO:
   CREATE b_usrd_det.
   ASSIGN INPUT BROWSE b_mnu b_usrd_det.b_usrd_usrid b_usrd_det.b_usrd_program b_usrd_det.b_usrd_exec b_usrd_det.b_usrd_sel.
    END.
    ELSE DO:
    
    
    
    DO i = b_mnu:NUM-SELECTED-ROWS TO 1 by -1:
            
            GET CURRENT q_mnu EXCLUSIVE-LOCK NO-WAIT.
         ASSIGN  INPUT BROWSE b_mnu b_usrd_det.b_usrd_usrid b_usrd_det.b_usrd_program b_usrd_det.b_usrd_exec b_usrd_det.b_usrd_sel.

         b_mnu:FETCH-SELECTED-ROW(i).
        END.
    END.
        RETURN.
END.

ON 'choose':U OF btn_delete
DO:
    /*b_user:READ-ONLY=FALSE.*/
    DEFINE VARIABLE i AS INTEGER.
    DEFINE VARIABLE usr AS CHARACTER.
        DO i = b_user:NUM-SELECTED-ROWS TO 1 by -1:
            v = b_user:FETCH-SELECTED-ROW(i).
            GET CURRENT q_user EXCLUSIVE-LOCK.
            DELETE b_usr_mstr.
            b_user:DELETE-SELECTED-ROWS().
            usr = b_usrd_det.b_usrd_usrid.
            FOR EACH b_usrd_det WHERE b_usrd_usrid = usr:
                DELETE b_usrd_det.
            END.
        END. 
        /*v = b_user:DELETE-SELECTED-ROWS().*/
    /*b_user:READ-ONLY = TRUE.*/
    RETURN.
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
    usr = b_usr_mstr.b_usr_usrid.
     FOR EACH b_mnd_det NO-LOCK:
    
        FIND FIRST b_usrd_det EXCLUSIVE-LOCK WHERE b_usrd_exec = b_mnd_exec
             AND b_usrd_usrid = usr NO-ERROR.
        IF NOT AVAILABLE b_usrd_det THEN DO:
        CREATE b_usrd_det.
        ASSIGN b_usrd_usrid = usr
                    b_usrd_program = b_mnd_name
                    b_usrd_exec = b_mnd_exec
                    b_usrd_sel = NO.
        END.

     END.
    OPEN QUERY q_mnu FOR EACH b_usrd_det WHERE
         b_usrd_usrid = b_usr_mstr.b_usr_usrid.
    /*b_user:READ-ONLY = TRUE.*/
    RETURN.
END.

REPEAT:
FOR EACH usr_mstr NO-LOCK WHERE usr_userid <> '':
    FIND FIRST b_usr_mstr WHERE b_usr_usrid = usr_mstr.usr_userid EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE b_usr_mstr THEN b_usr_pwd = usr_passwd.
    ELSE DO:
        CREATE b_usr_mstr.
        b_usr_usrid = usr_userid.
        b_usr_pwd = usr_passwd.
        b_usr_name = usr_name.

    END.
END.

    FOR EACH b_mnd_det NO-LOCK:
   
    FIND FIRST b_usrd_det WHERE b_usrd_usrid = 'admin' AND b_usrd_exec = b_mnd_exec NO-LOCK NO-ERROR.
     IF NOT AVAILABLE b_usrd_det THEN DO:
          CREATE b_usrd_det.
        ASSIGN b_usrd_usrid = 'admin'
                    b_usrd_program = b_mnd_name
                    b_usrd_exec = b_mnd_exec
                    b_usrd_sel = YES.
         
         END.
 FIND FIRST b_usrd_det WHERE b_usrd_usrid = 'mfg' AND b_usrd_exec = b_mnd_exec NO-LOCK NO-ERROR.
     IF NOT AVAILABLE b_usrd_det THEN DO:
          CREATE b_usrd_det.
        ASSIGN b_usrd_usrid = 'mfg'
                    b_usrd_program = b_mnd_name
                    b_usrd_exec = b_mnd_exec
                    b_usrd_sel = YES.
         
         END.
    END.

 
    FOR EACH b_usrd_det:
        FIND FIRST b_mnd_det NO-LOCK WHERE b_mnd_exec = b_usrd_exec NO-ERROR.
        IF NOT AVAILABLE b_mnd_det THEN
             DELETE b_usrd_det.
    END.
    OPEN QUERY q_user FOR EACH b_usr_mstr WHERE b_usr_usrid <> 'admin' AND b_usr_usrid <> 'mfg'.
     FIND FIRST b_usr_mstr WHERE b_usr_usrid <> 'admin' AND b_usr_usrid <> 'mfg' NO-LOCK NO-ERROR.

OPEN QUERY q_mnu FOR EACH b_usrd_det WHERE b_usrd_usrid = b_usr_usrid.
    CURRENT-WINDOW = w.
    UPDATE b_user b_mnu   btn_save WITH FRAME a.
END.

DELETE WIDGET w.
