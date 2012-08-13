{bcdeclre.i "new"  "global"}

{bcwin.i }
{mfdeclre.i}
{mf1.i}

    
DEF VAR islogin AS LOGICAL.
islogin = NO.

DEFINE NEW SHARED VARIABLE usr AS CHARACTER LABEL "用户" FORMAT "x(16)".
DEFINE NEW SHARED VARIABLE pwd AS CHARACTER  CASE-SENSITIVE  LABEL "密码" FORMAT "x(16)".
DEFINE IMAGE logo
    FILE "04-1a.jpg"
    FROM X 4 Y 0
    SIZE-PIXELS 200 BY 200.
 
/*
DEFINE FRAME a
   
    SKIP(.5) SPACE(22)
     logo SKIP(1) SPACE(1)
    usr COLON 10
    pwd  blank COLON 10 
    SKIP(1)
    WITH WIDTH 30 SIDE-LABEL TITLE "条码系统" THREE-D CENTERED .
  */

DEFINE FRAME a
    
    logo AT ROW 2.2 COL 3.5
    usr AT ROW 14 COL 4.5  
    pwd blank AT ROW 15.5 COL 4.5 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS  NO-UNDERLINE THREE-D 
        /* AT COL 2 ROW 2 */  
         SIZE 30 BY 17.




define variable i as integer no-undo.
define variable token1 as character no-undo.
DEF  variable expdays like usrc_expire_days no-undo.
define   variable expired like mfc_logical initial no no-undo.

define variable new_list        as character no-undo.

DEF VAR mark AS CHAR.
  mark = ''.
/*ENABLE ALL WITH FRAME a.*/

ON 'enter':u OF usr 
DO:

       /*APPLY "TAB":U TO usr. */
   usr = usr:SCREEN-VALUE.
  
    
RETURN.
END.  

ON VALUE-CHANGED OF usr 
DO:

       /*APPLY "TAB":U TO usr. */
   usr = usr:SCREEN-VALUE.
  
    
RETURN.
END.  
ON 'enter':u OF pwd
DO:
    
    pwd = pwd:SCREEN-VALUE.
    
 /*   FIND FIRST j_usr_mstr WHERE j_usr_usrid = usr:SCREEN-VALUE  AND 
         j_usr_pwd = pwd:SCREEN-VALUE NO-LOCK NO-ERROR. */
     FIND FIRST b_usr_mstr  WHERE b_usr_usrbar = USR NO-LOCK /*EXCLUSIVE-LOCK*/ /*AND SUBSTRING(usr_passwd,1,8) = SUBSTRING(ENCODE(PWD),1,8)*/ NO-ERROR.
    
   
    IF AVAILABLE b_usr_mstr   THEN
    DO: 
        
        IF NOT b_usr_qad AND ENCODE(pwd) <> b_usr_pwdbar THEN DO:
           MESSAGE '密码错误!' VIEW-AS ALERT-BOX ERROR.
           ASSIGN pwd = ''
                   pwd:SCREEN-VALUE = ''.
           LEAVE.
           END.
    FIND FIRST usr_mstr WHERE  usr_userid = b_usr_usrid NO-LOCK NO-ERROR.
     
     IF  NOT AVAILABLE usr_mstr THEN DO:
      
           MESSAGE '该用户不在QAD中，或没有对应QAD用户！' VIEW-AS ALERT-BOX ERROR.
            
            END.
        ELSE DO:
          /* b_usr_pwd = usr_passwd.*/
        /* if usr_mstr.usr_passwd = "" then
            usr_mstr.usr_passwd = encode("").*/
   GLOBAL_userid = usr_userid.
   barusr = b_usr_usrbar.

 
  /* MESSAGE GLOBAL_userid VIEW-AS ALERT-BOX.*/
        if IF b_usr_qad THEN encode(pwd) = usr_mstr.usr_passwd ELSE YES then do:

            global_user_name = usr_mstr.usr_name.

            /* Remove blank entries from the group list */
            new_list = "".

            do i = 1 to num-entries( usr_mstr.usr_groups ):
               token1 = trim(entry( i, usr_mstr.usr_groups )).
               if token1 <> "" then do:
                  if length( new_list ) > 0 then
                     new_list = new_list + "," + token1.
                  else
                     new_list = token1.
               end.
            end.

            global_user_groups = new_list.

            /* Check password aging */
            expired = no.

            if expdays > 0 and expdays < (today - usr_last_date)
            then do:
               expired = yes.
               /* PASSWORD HAS EXPIRED */
               {pxmsg.i &MSGNUM=5564 &ERRORLEVEL=2}
             /* UNDO,RETRY.*/
            end.
           ELSE DO:
          
            /* If password is null/expired get new one */
           
             

         /* if encode(passwd) = usr_mstr.usr_passwd */

         release usr_mstr. 
         RELEASE b_usr_mstr.
   
     
        g_user = GLOBAL_userid.
       g_sess = g_user + string(TIME) + string(ETIME) + STRING(SESSION).
          /*
    FIND FIRST b_usr_wkfl where  b_usr_id = usr NO-LOCK NO-ERROR.

     IF NOT AVAILABLE b_usr_wkfl THEN DO:
     
        
      /* mfusr = usr + string(today) + "," + string(time).*/
       CREATE b_usr_wkfl.
       b_usr_id = usr.
       b_usr_date = TODAY.
       b_usr_time = TIME.
       FIND FIRST b_usr_wkfl WHERE b_usr_id = usr EXCLUSIVE-LOCK NO-ERROR.
       
islogin = YES.

 END.
 ELSE MESSAGE '该用户已登录！' VIEW-AS ALERT-BOX ERROR. */
   /*    STATUS INPUT  "current user is:" + glob_user.*/
        islogin = YES.
         
 END.
     /*  RUN re.*/
   
        END.
       /*FIND FIRST bsch_det EXCLUSIVE-LOCK.*/
       /*ASSIGN bsch_nbr = "aaaa".*/
       /*MESSAGE "hello" + glob_user VIEW-AS ALERT-BOX.
       CREATE busrh_hist.
       ASSIGN busrh_usrid = glob_user
                   busrh_date = TODAY
               busrh_time = TIME.                */
     ELSE  DO: 
         MESSAGE '密码错误！' VIEW-AS ALERT-BOX ERROR.  
          pwd = ''.
          pwd:SCREEN-VALUE = ''.
     END.
    END.
    END.
    ELSE DO:
      MESSAGE "用户错误！" VIEW-AS ALERT-BOX ERROR.
          pwd = ''.
          pwd:SCREEN-VALUE = ''.
    END.
        /*pwd:SCREEN-VALUE = "".*/
  
END. 

ON END-ERROR OF current-window /* BARCODE FOR MFG/PRO */
OR ENDKEY OF current-window ANYWHERE DO:
    IF NOT islogin THEN DO:
    
    DEF VAR oktocomt AS LOGICAL.
    MESSAGE '是否退出？' VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO
        UPDATE oktocomt .
    IF oktocomt THEN DO:
   /*  FOR EACH b_sess_wkfl WHERE b_sess_usrid = g_user EXCLUSIVE-LOCK:
        DELETE b_sess_wkfl.
    END.*/
     /* FIND FIRST b_usr_wkfl WHERE b_usr_id = g_user EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE b_usr_wkfl THEN DELETE b_usr_wkfl.*/
    QUIT.
/* APPLY "CLOSE":U TO THIS-PROCEDURE.*/
     
    
     END.  
 RETURN NO-APPLY .
    END.
END.

ON WINDOW-CLOSE OF current-window /* BARCODE FOR MFG/PRO */
DO:  
   DEF VAR oktocomt AS LOGICAL.
  MESSAGE '是否退出？' VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO
        UPDATE  oktocomt .
    IF oktocomt THEN DO:
    /* FOR EACH b_sess_wkfl WHERE b_sess_usrid = g_user EXCLUSIVE-LOCK:
        DELETE b_sess_wkfl.
    END.
     */
        /* FIND FIRST b_usr_wkfl WHERE b_usr_id = g_user EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE b_usr_wkfl THEN DELETE b_usr_wkfl.*/
    QUIT.
 /*APPLY "CLOSE":U TO THIS-PROCEDURE.*/
     
     RETURN NO-APPLY .
     END.

END.


REPEAT:
    islogin = NO.
    DISP usr pwd WITH FRAME a.
ENABLE ALL WITH FRAME a.
WAIT-FOR enter OF pwd  /*OR END-ERROR OF THIS-PROCEDURE OR ENDKEY OF THIS-PROCEDURE OR CLOSE OF THIS-PROCEDURE*/.
IF islogin THEN 
DO:
    HIDE FRAME a.
    CURRENT-WINDOW:HIDDEN = YES.
    RUN bcmfg1.p .
    pwd = ''.
END.
   
   

END.
/*
PROCEDURE re:

       CREATE busrh_hist.
       ASSIGN busrh_usrid = glob_user
                   busrh_date = TODAY
                   busrh_time = TIME.
END.
*/
/*
VIEW current-window.





WAIT-FOR CLOSE OF  THIS-PROCEDURE.*/


