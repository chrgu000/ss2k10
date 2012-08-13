{mfdeclre.i}
{bcdeclre.i  }
{bcwin00.i 15}
    {bctitle.i}
DEF VAR bc_user AS CHAR FORMAT 'x(8)' LABEL '用户'.
DEF VAR bc_user_desc AS CHAR FORMAT 'x(15)' LABEL '用户描述'.
DEF VAR bc_user_pwdold AS CHAR FORMAT 'x(16)' LABEL '原密码'.
DEF VAR bc_user_pwd AS CHAR FORMAT 'x(16)' LABEL '新密码'.
DEF VAR bc_user_prtbar AS CHAR FORMAT 'x(22)' LABEL '条码打印'.
DEF VAR bc_user_prtbar1 AS CHAR FORMAT 'x(22)'.
DEF VAR bc_user_prt AS CHAR FORMAT 'x(22)' LABEL '打印机'.
DEF VAR bc_user_prt1 AS CHAR FORMAT 'x(22)'.
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR bc_pwd AS CHAR.
DEF VAR usrqad AS LOGICAL.
DEF VAR ismodi AS LOGICAL.
DEF TEMP-TABLE prt_listbar
    FIELD prt_listbar_path LIKE b_usr_printer
    FIELD prt_listbar_sess LIKE g_sess
  INDEX prt_listbar_sess IS PRIMARY prt_listbar_sess ASC.
DEF TEMP-TABLE prt_list
    FIELD prt_list_path LIKE b_usr_printer1
    FIELD prt_list_sess LIKE g_sess
  INDEX prt_list_sess IS PRIMARY prt_list_sess ASC.
DEF FRAME bc
   
    bc_user AT ROW 1.5 COL 4
   bc_user_desc AT ROW 3 COL 1 
   /* bc_part_desc  AT ROW 5 COL 1
    bc_part_desc1  NO-LABEL AT ROW 6 COL 8.5*/
  bc_user_pwdold AT ROW 4.5 COL 2.5
   bc_user_pwd AT ROW 6 COL 2.5
    bc_user_prtbar AT ROW 7.5 COL 1
    bc_user_prtbar1 AT ROW 8.7 COL 8.6 NO-LABEL
    bc_user_prt AT ROW 10.2 COL 2.5
   bc_user_prt1 AT ROW 11.4 COL 8.6 NO-LABEL
   bc_button AT ROW 12.9 COL 10
    
    WITH SIZE 30 BY 15 TITLE "用户参数更改"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
CURRENT-WINDOW:NAME = 'w'.
FOR EACH b_usr_mstr BREAK BY b_usr_printer:
    IF FIRST-OF(b_usr_printer) THEN DO:
        CREATE prt_listbar.
        ASSIGN prt_listbar_sess = g_sess
               prt_listbar_path = b_usr_printer.
    END.
END.
FOR EACH b_usr_mstr BREAK BY b_usr_printer1:
    IF FIRST-OF(b_usr_printer1) THEN DO:
        CREATE prt_list.
        ASSIGN prt_list_sess = g_sess
               prt_list_path = b_usr_printer1.
    END.
END.
FIND FIRST b_usr_mstr WHERE b_usr_usrbar = barusr NO-LOCK NO-ERROR.
IF AVAILABLE b_usr_mstr THEN 
    ASSIGN bc_user = barusr
           bc_pwd = b_usr_pwdbar
           usrqad = b_usr_qad
           bc_user_desc = b_usr_name
          bc_user_prtbar = substr(b_usr_printer,1,22)
          bc_user_prtbar1 = substr(b_usr_printer,23)
          bc_user_prt = SUBSTR(b_usr_printer1,1,22)
          bc_user_prt1 = SUBSTR(b_usr_printer1,23).
DISP bc_user bc_user_desc bc_user_prtbar bc_user_prtbar1 bc_user_prt bc_user_prt1 WITH FRAME bc.
ENABLE bc_user_desc bc_user_pwdold WHEN NOT usrqad bc_user_pwd WHEN NOT usrqad bc_user_prtbar bc_user_prtbar1 bc_user_prt bc_user_prt1 bc_button WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 bc_user_pwd:READ-ONLY = YES.
VIEW c-win.
ON CURSOR-DOWN OF bc_user_prtbar
DO:
   ASSIGN bc_user_prtbar.
    FIND FIRST prt_listbar WHERE prt_listbar_sess = g_sess AND prt_listbar_path > bc_user_prtbar NO-LOCK NO-ERROR.
     IF AVAILABLE prt_listbar THEN DO:
         ASSIGN bc_user_prtbar = substr(prt_listbar_path,1,22)
                bc_user_prtbar1 = SUBSTR(prt_listbar_path,23).
         DISP bc_user_prtbar bc_user_prtbar1 WITH FRAME bc.
     END.
END.
ON CURSOR-UP OF bc_user_prtbar
DO:
   ASSIGN bc_user_prtbar.
    FIND LAST prt_listbar WHERE prt_listbar_sess = g_sess AND prt_listbar_path < bc_user_prtbar NO-LOCK NO-ERROR.
     IF AVAILABLE prt_listbar THEN DO:
         ASSIGN bc_user_prtbar = substr(prt_listbar_path,1,22)
                bc_user_prtbar1 = SUBSTR(prt_listbar_path,23).
         DISP bc_user_prtbar bc_user_prtbar1 WITH FRAME bc.
     END.
END.
ON CURSOR-DOWN OF bc_user_prt
DO:
   ASSIGN bc_user_prt.
    FIND FIRST prt_list WHERE prt_list_sess = g_sess AND prt_list_path > bc_user_prt NO-LOCK NO-ERROR.
     IF AVAILABLE prt_list THEN DO:
         ASSIGN bc_user_prt = substr(prt_list_path,1,22)
                bc_user_prt1 = SUBSTR(prt_list_path,23).
         DISP bc_user_prt bc_user_prt1 WITH FRAME bc.
     END.
END.
ON CURSOR-UP OF bc_user_prt
DO:
   ASSIGN bc_user_prt.
    FIND LAST prt_list WHERE prt_list_sess = g_sess AND prt_list_path < bc_user_prt NO-LOCK NO-ERROR.
     IF AVAILABLE prt_list THEN DO:
         ASSIGN bc_user_prt = substr(prt_list_path,1,22)
                bc_user_prt1 = SUBSTR(prt_list_path,23).
         DISP bc_user_prt bc_user_prt1 WITH FRAME bc.
     END.
END.
ON VALUE-CHANGED OF bc_user_desc 
DO:
   ASSIGN bc_user_desc.
END.
ON enter OF bc_user_desc
DO:
   APPLY 'entry':u TO bc_user_pwd.
END.
ON VALUE-CHANGED OF bc_user_pwdold
DO:
   ASSIGN bc_user_pwdold.
END.
ON enter OF bc_user_pwdold 
DO:
    
    APPLY 'entry':u TO bc_user_pwd. 
    
   /* ELSE
       APPLY 'entry':u TO bc_user_prtbar.*/
END.
ON 'leave':U OF bc_user_pwdold
DO:
   IF ENCODE(bc_user_pwdold) = bc_pwd THEN bc_user_pwd:READ-ONLY = NO.
     ELSE  bc_user_pwd:READ-ONLY = YES.
END.

ON VALUE-CHANGED OF bc_user_pwd
DO:
  ASSIGN bc_user_pwd.
END.
ON enter OF bc_user_pwd 
DO:
    
       APPLY 'entry':u TO bc_user_prtbar.
END.
ON VALUE-CHANGED OF bc_user_prtbar 
DO:
   ASSIGN bc_user_prtbar.
END.
ON enter OF bc_user_prtbar
DO:
   APPLY 'entry':u TO bc_user_prtbar1.
END.

ON VALUE-CHANGED OF bc_user_prtbar1 
DO:
   ASSIGN bc_user_prtbar1.
END.
ON enter OF bc_user_prtbar1
DO:
   APPLY 'entry':u TO bc_user_prt.
END.
ON VALUE-CHANGED OF bc_user_prt 
DO:
   ASSIGN bc_user_prt.
END.
ON enter OF bc_user_prt
DO:
   APPLY 'entry':u TO bc_user_prt1.
END.
ON VALUE-CHANGED OF bc_user_prt1
DO:
   ASSIGN bc_user_prt1.
END.
ON enter OF bc_user_prt1
DO:
   APPLY 'entry':u TO bc_button.
END.
ON 'choose':U OF bc_button
DO:
    RUN main.
END.

ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

PROCEDURE main:
   IF ENCODE(bc_user_pwdold) = bc_pwd AND LENGTH(bc_user_pwd) < 5 THEN do:
        MESSAGE '密码必须5位以上！' VIEW-AS ALERT-BOX ERROR.
        bc_user_pwd = ''.
        DISP bc_user_pwd  WITH FRAME bc.
        END.
    FIND FIRST b_usr_mstr WHERE b_usr_usrbar = barusr EXCLUSIVE-LOCK NO-ERROR.
   IF AVAILABLE b_usr_mstr THEN 
         ASSIGN
           b_usr_name = bc_user_desc
          b_usr_pwdbar = IF NOT b_usr_qad AND ENCODE(bc_user_pwdold) = bc_pwd and LENGTH(bc_user_pwd) >= 5 THEN encode(bc_user_pwd) ELSE b_usr_pwdbar
          b_usr_printer = TRIM(bc_user_prtbar) + TRIM(bc_user_prtbar1)
          b_usr_printer1 = TRIM(bc_user_prt) + TRIM(bc_user_prt1).
           bc_user_pwd:READ-ONLY = YES.
            END.                                                                       

{bctrail.i}
