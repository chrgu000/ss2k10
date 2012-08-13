{bcdeclre.i}
    {bcwin01.i}
    {bctitle.i}
   
  DEFINE QUERY q_mnu FOR b_usrd_det , b_mnd_det.
      DEF VAR isexec AS LOGICAL.
      DEF VAR isfailed AS LOGICAL.
      isexec = NO.
      isfailed = NO.
DEFINE BROWSE b_mnu QUERY q_mnu 
    DISP 
           
   b_mnd_select + '.' +  b_mnd_nbr + ' ' + b_usrd_program  FORMAT "x(30)"
           
   
WITH   NO-ROW-MARKERS NO-LABEL NO-SEPARATORS SIZE 30 BY 18.5 TITLE "主菜单" 
    EXPANDABLE.
    DEF FRAME a
        b_mnu AT ROW  1 COL  1
         WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 30 BY 18.5.
ENABLE ALL WITH FRAME a.
    OPEN QUERY q_mnu FOR EACH b_usrd_det,EACH b_mnd_det WHERE b_usrd_det.b_usrd_usrid = g_user AND b_usrd_det.b_usrd_sel = YES AND b_usrd_det.b_usrd_exec = b_mnd_det.b_mnd_exec AND b_mnd_det.b_mnd_module <>  '基础设置' AND b_mnd_det.b_mnd_module <> '小界面'  AND b_mnd_det.b_mnd_module <> '清理工具' NO-LOCK BY integer(b_mnd_det.b_mnd_select) BY DECIMAL(b_mnd_det.b_mnd_nbr) .




   ON MOUSE-select-dblclick OF b_mnu OR enter OF b_mnu
   DO: isfailed = NO.
       isexec = NO.
      /* FIND FIRST b_ct_ctrl WHERE b_ct_up_mtd <> '' AND b_ct_nrm <> '' AND b_ct_prod_buffer <> '' NO-LOCK NO-ERROR.
IF AVAILABLE b_ct_ctrl THEN DO: */
       IF b_usrd_det.b_usrd_exec <>  'bcbcmfasy.p'  AND b_usrd_det.b_usrd_exec <> 'bciccnt.p' THEN DO:
                              FIND FIRST b_sess_wkfl WHERE b_sess_exec = 'bcbcmfasy.p'OR b_sess_exec = 'bciccnt.p' NO-LOCK NO-ERROR.
                                 IF NOT AVAILABLE b_sess_wkfl THEN DO:
                                    
                                     CREATE b_sess_wkfl.
                                 b_sess_usrid = g_user.
                                 b_sess_exec = b_usrd_det.b_usrd_exec.
                                   bc_exec = b_usrd_det.b_usrd_exec.
                                   FIND FIRST b_mnd_det WHERE b_mnd_exec = b_usrd_det.b_usrd_exec NO-LOCK NO-ERROR.   
                                   bc_name = b_mnd_select + '.' + b_mnd_nbr + ' ' + b_mnd_name.
                                    FIND FIRST b_sess_wkfl   WHERE b_sess_usrid = g_user AND b_sess_exec = b_usrd_det.b_usrd_exec EXCLUSIVE-LOCK NO-ERROR.

                                isexec = YES.
                                               
                                 
                                  END.
                               ELSE   DO: isfailed = YES.
                                   MESSAGE '条码系统正处于异步更新或盘点状态！' VIEW-AS ALERT-BOX WARNING.
                               END.

                               
                               END.
                               ELSE DO:
                                  IF b_usrd_det.b_usrd_exec = 'bcbcmfasy.p' THEN DO:
                                  
                                   IF NOT CAN-FIND(FIRST b_sess_wkfl NO-LOCK) THEN DO:
                                CREATE b_sess_wkfl.
                                 b_sess_usrid = g_user.
                                 b_sess_exec = b_usrd_det.b_usrd_exec.
                                   bc_exec = b_usrd_det.b_usrd_exec.
                                       FIND FIRST b_mnd_det WHERE b_mnd_exec = b_usrd_det.b_usrd_exec NO-LOCK NO-ERROR.   
                                   bc_name = b_mnd_nbr + ' ' + b_mnd_name.
                                    FIND FIRST b_sess_wkfl WHERE b_sess_usrid = g_user AND b_sess_exec = b_usrd_det.b_usrd_exec EXCLUSIVE-LOCK NO-ERROR.

                                isexec = YES.
                                END.
                                ELSE DO: 
                              
                               ISfailed = YES.
                                    MESSAGE '条码系统中有程序在运行，请退出！' VIEW-AS ALERT-BOX WARNING.
                                END.
                                    END.
                               
                                     IF b_usrd_det.b_usrd_exec = 'bciccnt.p' THEN DO:
                                  
                                   IF NOT CAN-FIND(FIRST b_sess_wkfl WHERE b_sess_exec <> 'bciccnt.p' NO-LOCK) THEN DO:
                                CREATE b_sess_wkfl.
                                 b_sess_usrid = g_user.
                                 b_sess_exec = b_usrd_det.b_usrd_exec.
                                   bc_exec = b_usrd_det.b_usrd_exec.
                                      FIND FIRST b_mnd_det WHERE b_mnd_exec = b_usrd_det.b_usrd_exec NO-LOCK NO-ERROR.   
                                   bc_name = b_mnd_nbr + ' ' + b_mnd_name.
                                    FIND FIRST b_sess_wkfl WHERE b_sess_usrid = g_user AND b_sess_exec = b_usrd_det.b_usrd_exec EXCLUSIVE-LOCK NO-ERROR.

                                isexec = YES.
                                END.
                                ELSE DO: 
                                isfailed = YES.
                                    MESSAGE '条码系统中有非盘点程序在运行，请退出！' VIEW-AS ALERT-BOX WARNING.
                                END.
                                    END.
                                    
                                    
                                    END.

       
/*END.
ELSE MESSAGE '控制文件有误!' VIEW-AS ALERT-BOX ERROR.*/
       
       RETURN.
   END.

ON END-ERROR OF c-win /* BARCODE FOR MFG/PRO */
OR ENDKEY OF c-win ANYWHERE DO:
     DELETE WIDGET c-win.
 APPLY "CLOSE":U TO THIS-PROCEDURE.
     
     RETURN NO-APPLY .
     
END.

ON WINDOW-CLOSE OF c-win /* BARCODE FOR MFG/PRO */
DO:  
    DELETE WIDGET c-win.
 APPLY "CLOSE":U TO THIS-PROCEDURE.
     
     RETURN NO-APPLY .

END.




WAIT-FOR mouse-select-dblclick OF b_mnu OR enter OF b_mnu OR CLOSE OF THIS-PROCEDURE.
IF isexec THEN DO:
    DELETE WIDGET c-win.
    APPLY "close":u TO THIS-PROCEDURE.
    {bcrun.i "bc_exec"}

 
    END.
    ELSE 
        IF ISfailed THEN do: 
         
        DELETE WIDGET c-win.
 APPLY "CLOSE":U TO THIS-PROCEDURE.
        RUN bc_small.p.
    END.
