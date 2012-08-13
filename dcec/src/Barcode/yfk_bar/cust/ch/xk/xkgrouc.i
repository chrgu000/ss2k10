/*Cai last modified by 05/20/2004*/
/*last modified by Tracy 11/17/2004 *zx01* */
InsBlock:
DO ON ENDKEY UNDO, LEAVE
   ON ERROR UNDO, LEAVE:

    pop-tit = "加入新纪录" .

    CLEAR FRAME f-pop ALL NO-PAUSE.

    REPEAT WITH FRAME f-pop:        
         PROMPT-FOR xkgpd_line xkgpd_site xkgpd_sup xkgpd_part xkgpd_urgcard /*zx01*/ xkgpd__log01 WITH FRAME f-pop EDITING:
            IF FRAME-FIELD = "xkgpd_part" THEN DO:
                {mfnp.i pt_mstr xkgpd_part pt_part xkgpd_part pt_part pt_part}
                    IF recno <> ? THEN DO:
                        xkgpd_part = pt_part .
                        DISPLAY xkgpd_part WITH FRAME f-pop .
                    END.
            END.
/*            ELSE IF FRAME-FIELD = "xxgpd_site" THEN DO :
                {mfnp.i si_mstr xkgpd_site si_site xkgpd_site si_site si_site}
                IF recno <> ? THEN DO :
                    xkgpd_site = si_site .
                    DISPLAY xkgpd_site WITH frame f-pop .
                END.
            END.
*/
            ELSE DO :
                STATUS INPUT .
                READKEY.
                APPLY LASTKEY .
            END.
        END.

        FIND si_mstr WHERE si_site = INPUT xkgpd_site NO-LOCK NO-ERROR .
        IF NOT AVAILABLE si_mstr THEN DO:
            MESSAGE "请输入有效地点" .
            NEXT-PROMPT xkgpd_site WITH FRAME f-pop.
            UNDO InsBlock ,RETRY InsBlock .
        END.
    
        FIND pt_mstr WHERE pt_part = INPUT xkgpd_part NO-LOCK NO-ERROR .
        IF NOT AVAILABLE pt_mstr THEN DO:
            MESSAGE "请输入有效零件。" .
            NEXT-PROMPT xkgpd_part WITH FRAME f-pop.
            UNDO InsBlock ,RETRY InsBlock .
        END.
        ELSE DO:
            des = pt_desc1 + pt_desc2 .
            DISPLAY des WITH FRAME f-pop .
        END.
    
        FIND knbsm_mstr where knbsm_site = input xkgpd_site and knbsm_supermarket_id = input xkgpd_sup no-error .
        IF NOT AVAILABLE knbsm_mstr then do :
            MESSAGE "请输入有效超市代码" .
            NEXT-PROMPT xkgpd_sup WITH FRAME f-pop.
            UNDO InsBlock ,RETRY InsBlock .
        END.
        
        FIND xkgpd_det WHERE xkgpd_site = INPUT xkgpd_site
            AND xkgpd_sup = INPUT xkgpd_sup
            AND xkgpd_part = INPUT xkgpd_part NO-ERROR .
        IF AVAILABLE xkgpd_det THEN DO:
            MESSAGE "地点，超市，零件已存在对应组。" .
            UNDO InsBlock ,RETRY InsBlock .
        END.
        
        CREATE xkgpd_det .
        ASSIGN xkgpd_group = xkgp_group  
               xkgpd_part = INPUT xkgpd_part
               xkgpd_site = INPUT xkgpd_site
               xkgpd_sup = INPUT xkgpd_sup
               xkgpd_urgcard = INPUT xkgpd_urgcard
               xkgpd_line = INPUT xkgpd_line 
      /*zx01*/ xkgpd__log01 = input xkgpd__log01.
         
        w-newrecid = recid(xkgpd_det).  
       
  /*       DOWN 1 WITH FRAME f-pop.  */  
        LEAVE . 
   END.
end. /* InsBlock */

hide frame f-pop no-pause.
