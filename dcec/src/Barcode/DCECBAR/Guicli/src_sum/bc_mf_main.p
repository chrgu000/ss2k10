
SESSION:DATE-FORMAT = 'mdy'.
{bcdeclre.i}
    
/*DEFINE  VARIABLE w AS WIDGET-HANDLE.*/
{bcwin.i }

DEFINE VARIABLE item_list AS CHARACTER.
DEFINE VARIABLE item_value AS CHARACTER.
DEF VAR isexec AS LOGICAL.
DEF VAR isover AS LOGICAL.
DEF VAR isctrl AS LOGICAL.
DEF VAR isok AS LOGICAL.
isok = NO.

DEFINE VARIABLE mnu_nbr AS CHARACTER.

DEF VAR PRE_MOD AS CHAR.
DEFINE VARIABLE st AS CHARACTER FORMAT "x(20)".

DEFINE VARIABLE mdu_list AS CHARACTER
    VIEW-AS SELECTION-LIST SINGLE NO-DRAG
    SIZE 27.2 BY 12.

DEFINE VARIABLE mnu_list AS CHARACTER
     VIEW-AS SELECTION-LIST SINGLE NO-DRAG
    SIZE 17 BY 12.

DEFINE VARIABLE exec_pro AS CHARACTER LABEL "执行程序".
DEFINE VARIABLE i_tab AS INTEGER.
/*
DEFINE FRAME a
    SKIP(1)
    SPACE(5) "系统模块功能" /*SPACE(29) "系统管理功能"*/
    SKIP(0)
    SPACE(1) mdu_list /*SPACE(2) mnu_list */
    SKIP(.5)
    SPACE(1) "执行程序" SPACE(1) exec_pro
    SKIP (.5)
WITH WIDTH 30  NO-LABEL CENTER THREE-D.
  */

DEFINE FRAME a
    "系统模块功能" AT ROW 1.5 COL 10
     mdu_list AT ROW 2.5 COL 2 NO-LABEL 
     exec_pro AT ROW 15.5 COL 2 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
        /* AT COL 2 ROW 2 */  
         SIZE 30 BY 17.




/*CREATE WINDOW w
    ASSIGN TITLE = "条码系统"
                 HIDDEN             = YES
        
         HEIGHT-CHARS             = 18
         WIDTH-CHARS            =  30
         /*MAX-HEIGHT         = 25
         MAX-WIDTH          = 100
         VIRTUAL-HEIGHT     = 26
         VIRTUAL-WIDTH      = 90
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = NO
         THREE-D            = yes
         MESSAGE-AREA       = no*/
         SENSITIVE          = YES.
ASSIGN CURRENT-WINDOW                = w
       THIS-PROCEDURE:CURRENT-WINDOW = w.
w:HIDDEN = no.*/



   /* st = ','.*/

 FOR EACH b_mnd_det NO-LOCK    BREAK BY b_mnd_select  :
    
    IF FIRST-OF (b_mnd_select) AND (PRE_MOD <> B_MND_MODULE) THEN 
        st = st + b_mnd_module + ",".
        PRE_MOD = B_MND_MODULE.
END.

mnu_nbr = "0".
RUN mnu_display (INPUT "0").

mdu_list:LIST-ITEMS = st.
st = "".

/*VIEW w.*/
/*
isexec = NO.
issmall = NO.
isover = NO.
ISCTRL = NO.*/
ENABLE ALL WITH FRAME a.

/*internal procedure*/

PROCEDURE mnu_display:
    DEFINE INPUT PARAMETER nbr AS CHARACTER.
    st = "".
    st = st + "." + ",".
    st = st + ".."  + ",".
    FOR EACH b_mnd_det WHERE b_mnd_nbr = nbr:
            st = st + b_mnd_select + ";" + b_mnd_name + ",".
    END.
    mnu_nbr = nbr.
END PROCEDURE.


/*events*/

ON mouse-select-dblclick OF mdu_list OR enter OF mdu_list
DO:
    DEFINE VARIABLE sel AS CHARACTER.
    sel = SUBSTRING(mdu_list:SCREEN-VALUE,1,1).

    CASE sel:
        WHEN "." THEN RUN mnu_display(INPUT "0").
        WHEN ".." THEN RUN mnu_display(INPUT "0").
        otherwise DO:
            
            FOR FIRST b_mnd_det NO-LOCK WHERE b_mnd_nbr = mnu_nbr AND b_mnd_select  = sel:
            END.
            IF  b_mnd_exec <> "" THEN DO:
                FIND FIRST b_usrd_det NO-LOCK WHERE b_usrd_usrid = g_user 
                     AND b_usrd_exec = b_mnd_exec AND b_usrd_sel = YES NO-ERROR.
                IF AVAILABLE b_usrd_det THEN DO:
                     bc_name = right-trim(SUBSTR(b_mnd_nbr,3,2)) + '.' + b_mnd_select + ' ' + b_mnd_name .
                    {bcrun.i " b_mnd_exec "}
                       
                    
                END.
                ELSE DO:
                    MESSAGE "用户" + g_user + "无此权限" VIEW-AS ALERT-BOX.
                    RETURN.
                END.
                     
            END.
            ELSE DO:
                     mnu_nbr = mnu_nbr + "." + b_mnd_select.
                     RUN mnu_display( INPUT mnu_nbr).
            END.
       END.
    END CASE.

    mdu_list:LIST-ITEMS = st.
    /*
    isexec = NO.
    issmall = NO.
    isctrl = NO.
    DEFINE VARIABLE st AS CHARACTER.
    FOR EACH b_usrd_det , EACH b_mnd_det NO-LOCK WHERE b_usrd_det.b_usrd_usrid = g_user AND b_usrd_det.b_usrd_exec = b_mnd_det.b_mnd_exec AND b_usrd_det.b_usrd_sel = YES AND b_mnd_det.b_mnd_module = mdu_list:SCREEN-VALUE  BY DECIMAL(B_MND_DET.B_MND_SELECT) BY DECIMAL(b_mnd_det.b_mnd_nbr) :
       
            
             st = st + b_mnd_det.b_mnd_select + '.' + b_mnd_det.b_mnd_nbr + ' ' + b_mnd_name + ",".
    END.
    
 IF mdu_list:SCREEN-VALUE = '小界面' THEN 
     issmall = YES.
 ELSE mnu_list:LIST-ITEMS = st.     
 bc_name = mdu_list:SCREEN-VALUE.*/
    RETURN.
END.

/*
ON mouse-select-dblclick OF mnu_list OR enter OF mnu_list
DO:
/*isexec = NO.
issmall = NO.
isctrl = NO.
isok = NO.*/



IF mnu_list:SCREEN-VALUE <> '36.8 控制文件' THEN DO:

FIND FIRST b_ct_ctrl WHERE b_ct_up_mtd <> '' AND b_ct_nrm <> '' /*AND b_ct_prod_buffer <> ''*/ NO-LOCK NO-ERROR.
IF AVAILABLE b_ct_ctrl THEN isok = YES.
 ELSE MESSAGE '控制文件有误!' VIEW-AS ALERT-BOX.
END.
ELSE isok = YES.

     IF isok THEN DO:
     
FIND FIRST b_mnd_det WHERE mnu_list:SCREEN-VALUE  = b_mnd_select + '.' + b_mnd_nbr + ' ' + b_mnd_name   NO-LOCK NO-ERROR.
   IF AVAILABLE b_mnd_det THEN DO:
      /*RUN VALUE( b_mnd_exec)*/.
                       
                           IF b_mnd_exec <>  'bcbcmfasy.p'  AND b_mnd_exec <> 'bciccnt.p' THEN DO:
                              
                               
                               
                               FIND FIRST b_sess_wkfl WHERE b_sess_exec = 'bcbcmfasy.p'OR b_sess_exec = 'bciccnt.p' NO-LOCK NO-ERROR.
                                 IF NOT AVAILABLE b_sess_wkfl THEN DO:
                                    
                                     CREATE b_sess_wkfl.
                                 b_sess_usrid = g_user.
                                 b_sess_exec = b_mnd_exec.
                                   bc_exec = b_mnd_exec.
                                   bc_name = mnu_list:SCREEN-VALUE.
                                    FIND FIRST b_sess_wkfl   WHERE b_sess_usrid = g_user AND b_sess_exec = b_mnd_exec EXCLUSIVE-LOCK NO-ERROR.
                                 IF b_mnd_exec = 'bcbcctmaint.p' OR b_mnd_exec = 'bcbcctmaint1.p' OR b_mnd_exec = 'bcbcusrcl.p' OR b_mnd_exec = 'bcbcsesscl.p'THEN
                                     isctrl = YES.
                                 ELSE
                               
                                isexec = YES.
                                  /*  CURRENT-WINDOW:SENSITIVE = FALSE.*/           
                                 MDU_LIST:SENSITIVE = FALSE.
                                 MNU_LIST:SENSITIVE = FALSE.
                                  END.
                               ELSE    MESSAGE '条码系统正处于异步更新或盘点状态！' VIEW-AS ALERT-BOX WARNING.

                               
                               END.
                               ELSE DO:
                                  
                                   
                                   IF b_mnd_exec = 'bcbcmfasy.p' THEN DO:
                                  
                                   IF NOT CAN-FIND(FIRST b_sess_wkfl NO-LOCK) THEN DO:
                                CREATE b_sess_wkfl.
                                 b_sess_usrid = g_user.
                                 b_sess_exec = b_mnd_exec.
                                   bc_exec = b_mnd_exec.
                                      bc_name = mnu_list:SCREEN-VALUE.
                                    FIND FIRST b_sess_wkfl WHERE b_sess_usrid = g_user AND b_sess_exec = b_mnd_exec EXCLUSIVE-LOCK NO-ERROR.

                                isexec = YES.
                                /* CURRENT-WINDOW:SENSITIVE = FALSE.*/ MDU_LIST:SENSITIVE = FALSE.
                                 MNU_LIST:SENSITIVE = FALSE.
                                END.
                                ELSE MESSAGE '条码系统中有程序在运行，请退出！' VIEW-AS ALERT-BOX WARNING.
                                    END.
                               
                                     IF b_mnd_exec = 'bciccnt.p' THEN DO:
                                  
                                   IF NOT CAN-FIND(FIRST b_sess_wkfl WHERE b_sess_exec <> 'bciccnt.p' NO-LOCK) THEN DO:
                                CREATE b_sess_wkfl.
                                 b_sess_usrid = g_user.
                                 b_sess_exec = b_mnd_exec.
                                   bc_exec = b_mnd_exec.
                                      bc_name = mnu_list:SCREEN-VALUE.
                                    FIND FIRST b_sess_wkfl WHERE b_sess_usrid = g_user AND b_sess_exec = b_mnd_exec EXCLUSIVE-LOCK NO-ERROR.

                                isexec = YES.
                               /*  CURRENT-WINDOW:SENSITIVE = FALSE.*/ MDU_LIST:SENSITIVE = FALSE.
                                 MNU_LIST:SENSITIVE = FALSE.
                                END.
                                ELSE MESSAGE '条码系统中有非盘点程序在运行，请退出！' VIEW-AS ALERT-BOX WARNING.
                                    END.
                                    
                                    
                                    END.

                                   
                                    
                                  
                                   

               
                                  
                   
                                
   END.
     END.
END.

*/

ON END-ERROR OF c-win /* BARCODE FOR MFG/PRO */
OR ENDKEY OF c-win ANYWHERE DO:
   
 /*  FOR EACH b_sess_wkfl WHERE b_sess_usrid = g_user EXCLUSIVE-LOCK:
        DELETE b_sess_wkfl.
    END.
   FIND FIRST b_usr_wkfl WHERE b_usr_id = g_user EXCLUSIVE-LOCK  NO-ERROR.
     IF AVAILABLE b_usr_wkfl THEN DELETE b_usr_wkfl.
    
    issmall = NO.
    isexec = NO.
    isover = YES.*/
/*APPLY "CLOSE":U TO THIS-PROCEDURE.  
  DELETE WIDGET c-win.

   
     RUN bcmflogin.p.*/
   /* RETURN NO-APPLY .*/
   DEF VAR oktocomt AS LOGICAL.
    MESSAGE '是否退出？' VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO
        UPDATE  oktocomt .
    IF oktocomt THEN DO:
/*    FOR EACH b_sess_wkfl WHERE b_sess_usrid = g_user EXCLUSIVE-LOCK:
        DELETE b_sess_wkfl.
    END.
     FIND FIRST b_usr_wkfl WHERE b_usr_id = g_user EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE b_usr_wkfl THEN DELETE b_usr_wkfl.*/
   QUIT.
 APPLY "CLOSE":U TO THIS-PROCEDURE.
     
    
     END.
     RETURN NO-APPLY .
    
END.

ON WINDOW-CLOSE OF c-win /* BARCODE FOR MFG/PRO */
DO:  
    DEF VAR oktocomt AS LOGICAL.
    MESSAGE '是否退出？' VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO
        UPDATE  oktocomt .
    IF oktocomt THEN DO:
/*    FOR EACH b_sess_wkfl WHERE b_sess_usrid = g_user EXCLUSIVE-LOCK:
        DELETE b_sess_wkfl.
    END.
     FIND FIRST b_usr_wkfl WHERE b_usr_id = g_user EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE b_usr_wkfl THEN DELETE b_usr_wkfl.*/
   QUIT.
 APPLY "CLOSE":U TO THIS-PROCEDURE.
     
     RETURN NO-APPLY .
     END.

END.

ON 'return':U OF exec_pro
DO:
    IF g_user <> "mfg" THEN DO:
        MESSAGE "只有mfg能够操作" VIEW-AS ALERT-BOX.
        RETURN.
    END.
    ASSIGN exec_pro.
    IF exec_pro = "P" THEN DO:
        run value("adeedit\_proedit.r")("", "").
    END.
    RETURN.
END.


REPEAT:

 /*MESSAGE 'ok' VIEW-AS ALERT-BOX.*/

 /*MESSAGE 'ok' VIEW-AS ALERT-BOX.*/
 /*  readkey.
 if lastkey = keycode("alt-g") then
 run value("adeedit\_proedit.r")("", "").
        */

        
WAIT-FOR /*mouse-select-dblclick OF mnu_list OR enter OF mnu_list OR*/ mouse-select-dblclick OF mdu_list 
    OR enter OF mdu_list OR enter OF exec_pro OR ENDKEY OF THIS-PROCEDURE OR END-ERROR OF THIS-PROCEDURE OR CLOSE OF THIS-PROCEDURE.
/*     
IF isexec THEN DO:

    {bcrun.i "bc_exec"}
END.
IF issmall THEN DO: 
    FIND FIRST b_ct_ctrl WHERE b_ct_up_mtd <> '' AND b_ct_nrm <> '' /*AND b_ct_prod_buffer <> ''*/ NO-LOCK NO-ERROR.
IF AVAILABLE b_ct_ctrl THEN DO:
MDU_LIST:SENSITIVE = FALSE.
   MNU_LIST:SENSITIVE = FALSE.  
    RUN bc_small.p.
  END.
ELSE MESSAGE '控制文件有误!' VIEW-AS ALERT-BOX.
END.
IF isover THEN RUN bcmflogin.p.

IF isctrl THEN DO:
    {BCDECLRE.I}
     DEF  VAR win AS WIDGET-HANDLE.
     {bcwinset.i "bc_name"}
    
    {bcrun.i "bc_exec"}
        
        DELETE WIDGET c-win.
    {bcsess.i}
   
    /*CURRENT-WINDOW = w.
    APPLY "entry":u TO w_focus.*/
END.*/
/*CURRENT-WINDOW = w.
 CURRENT-WINDOW:SENSITIVE = TRUE.*/
                                 MDU_LIST:SENSITIVE = TRUE.
                                /* MNU_LIST:SENSITIVE = TRUE.*/
/*
WAIT-FOR CLOSE OF THIS-PROCEDURE .*/

END.

/*DELETE WIDGET w.*/

/* WIDGET w.*/






















