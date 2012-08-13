{bcdeclre.i "new"  "global"}

{bcwin.i }
{mfdeclre.i}
{mf1.i}
    {bclogindef.i}
define variable i as integer no-undo.
define variable token1 as character no-undo.
DEF  variable expdays like usrc_expire_days no-undo.
define   variable expired like mfc_logical initial no no-undo.

define variable new_list        as character no-undo.

DEF VAR mark AS CHAR.
  mark = ''.
ENABLE ALL WITH FRAME a.

ON 'enter':u OF usr 
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
     FIND FIRST b_usr_mstr  WHERE b_usr_usrid = USR EXCLUSIVE-LOCK /*AND SUBSTRING(usr_passwd,1,8) = SUBSTRING(ENCODE(PWD),1,8)*/ NO-ERROR.
    
   
    IF AVAILABLE b_usr_mstr   THEN
    DO: 
       
    FIND FIRST usr_mstr WHERE  usr_userid = usr NO-LOCK NO-ERROR.
     
     IF  NOT AVAILABLE usr_mstr THEN DO:
      
           MESSAGE '该用户不在QAD中！' VIEW-AS ALERT-BOX ERROR.
            
            END.
        ELSE DO:
           b_usr_pwd = usr_pass.
        /* if usr_mstr.usr_passwd = "" then
            usr_mstr.usr_passwd = encode("").*/
   GLOBAL_userid = usr.
   
  
  /* MESSAGE GLOBAL_userid VIEW-AS ALERT-BOX.*/
        if encode(pwd) = usr_mstr.usr_passwd then do:

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

         release usr_mstr. RELEASE b_usr_mstr.
   
     
        g_user = usr.
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
 ELSE MESSAGE '该用户已登录！' VIEW-AS ALERT-BOX ERROR. 
   /*    STATUS INPUT  "current user is:" + glob_user.*/
           
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
     ELSE   MESSAGE '密码错误！' VIEW-AS ALERT-BOX ERROR.  
    END.
    END.
    ELSE 
        MESSAGE "用户错误！" VIEW-AS ALERT-BOX.
        pwd:SCREEN-VALUE = "".
  
END. 

ON END-ERROR OF c-win /* BARCODE FOR MFG/PRO */
OR ENDKEY OF c-win ANYWHERE DO:
    DEF VAR oktocomt AS LOGICAL.
    MESSAGE '是否退出？' VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO
        UPDATE oktocomt .
    IF oktocomt THEN DO:
   /*  FOR EACH b_sess_wkfl WHERE b_sess_usrid = g_user EXCLUSIVE-LOCK:
        DELETE b_sess_wkfl.
    END.*/
      FIND FIRST b_usr_wkfl WHERE b_usr_id = g_user EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE b_usr_wkfl THEN DELETE b_usr_wkfl.
    QUIT.
 APPLY "CLOSE":U TO THIS-PROCEDURE.
     
     RETURN NO-APPLY .
     END.  

END.

ON WINDOW-CLOSE OF c-win /* BARCODE FOR MFG/PRO */
DO:  
   DEF VAR oktocomt AS LOGICAL.
  MESSAGE '是否退出？' VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO
        UPDATE  oktocomt .
    IF oktocomt THEN DO:
    /* FOR EACH b_sess_wkfl WHERE b_sess_usrid = g_user EXCLUSIVE-LOCK:
        DELETE b_sess_wkfl.
    END.
     */
         FIND FIRST b_usr_wkfl WHERE b_usr_id = g_user EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE b_usr_wkfl THEN DELETE b_usr_wkfl.
    QUIT.
 APPLY "CLOSE":U TO THIS-PROCEDURE.
     
     RETURN NO-APPLY .
     END.

END.


REPEAT:

WAIT-FOR enter OF pwd  /*OR END-ERROR OF THIS-PROCEDURE OR ENDKEY OF THIS-PROCEDURE OR CLOSE OF THIS-PROCEDURE*/.
IF islogin THEN 
DO:
   DELETE WIDGET c-win.
    RUN bcmfg1.p .
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

VIEW c-win.





WAIT-FOR CLOSE OF  THIS-PROCEDURE.
