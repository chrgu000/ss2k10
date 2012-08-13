/*Cai last modified by 05/20/2004*/
/*last modified by SunnyZhou 06/16/2004 *xw0616* */
/*last modified by Tracy 11/17/2004 *zx01* */

{mfdtitle.i "2+ "}

DEFINE VARIABLE xwgroup LIKE xkgp_group .
DEFINE VARIABLE des AS CHARACTER FORMAT "x(48)" LABEL "描述" .
DEFINE VARIABLE pop-tit AS CHARACTER NO-UNDO .
DEFINE VARIABLE yn AS LOGICAL .
DEFINE VARIABLE part LIKE pt_part .

FORM

    SKIP(0.3)
    xwgroup           COLON 12
    xkgp_desc      COLON 42 
    xkgp_wkctr      COLON 12 SKIP
    xkgp_type		COLON 12 LABEL "Yes外部/No内部"
    xkgp_auto       COLON 42 LABEL "Yes自动/No手工" SKIP
    xkgp_lead_time COLON 12 "小时"
    xkgp_urg_time      COLON 42  "小时" SKIP
    SKIP(0.5)

WITH FRAME a WIDTH 80 SIDE-LABELS ATTR-SPACE .

FORM
    xkgpd_line FORMAT "9999"
    xkgpd_site FORMAT "x(8)"
    xkgpd_sup FORMAT "x(8)"
    xkgpd_part FORMAT "x(18)"
    xkgpd_urgcard FORMAT ">>>>9"
    des FORMAT "x(20)" 
/*zx01*/ xkgpd__log01 label "自动"

WITH 10 DOWN FRAME f-errs WIDTH 80 .

FORM

    xkgpd_line FORMAT "9999"
    xkgpd_site FORMAT "x(8)"
    xkgpd_sup FORMAT "x(8)"
    xkgpd_part FORMAT "x(18)"
    xkgpd_urgcard FORMAT ">>>>9"
    des  FORMAT "x(20)"  
/*zx01*/ xkgpd__log01 label "自动"

WITH 10 DOWN FRAME f-pop WIDTH 80 TITLE pop-tit .

mainloop:
REPEAT :
 DO TRANSACTION ON ERROR UNDO, LEAVE :
    
     CLEAR FRAME f-pop ALL .
     CLEAR FRAME f-errs ALL .
     HIDE ALL NO-PAUSE .
     

     PROMPT-FOR xwgroup WITH FRAME a EDITING :
         {mfnp.i xkgp_mstr xwgroup xkgp_group xwgroup xkgp_group xkgp_group}
         IF recno <> ? THEN  DO:
             DISPLAY xkgp_group @ xwgroup xkgp_wkctr xkgp_auto xkgp_type xkgp_lead_time xkgp_urg_time xkgp_desc WITH FRAME a .
 	     clear frame f-pop all.
	     FOR EACH xkgpd_det where xkgpd_group = xkgp_group 
	     no-lock
	     break by xkgpd_group by xkgpd_line
		with frame f-pop down:
		 FOR FIRST pt_mstr where pt_part = xkgpd_part no-lock: end.
	             DISPLAY 
			    xkgpd_line
			    xkgpd_site
			    xkgpd_sup 
			    xkgpd_part
			    xkgpd_urgcard 
			    pt_desc1 when available pt_mstr  @ des
/*zx01*/ xkgpd__log01		    
		     WITH FRAME f-pop down .
		     down 1 with frame f-pop.
	     END.
	 END.
	  
     END.
     STATUS INPUT .

     IF INPUT xwgroup = "" THEN DO :
        MESSAGE "请输入组" .
        NEXT-PROMPT xwgroup WITH FRAME a.
        UNDO mainloop ,RETRY mainloop .
     END.

     FIND xkgp_mstr WHERE xkgp_group = INPUT xwgroup NO-ERROR .
     IF NOT AVAILABLE xkgp_mstr THEN DO:
         CREATE xkgp_mstr .
         xkgp_group = INPUT xwgroup .
     END.
     
     DISPLAY xkgp_group @ xwgroup xkgp_wkctr xkgp_auto xkgp_type xkgp_lead_time xkgp_urg_time xkgp_desc WITH FRAME a .

    second-loop: 
    DO ON ERROR UNDO, RETRY WITH frame a:
        yn = NO .
        SET xkgp_desc
	     xkgp_wkctr xkgp_type xkgp_auto xkgp_lead_time xkgp_urg_time 
            GO-ON("F5" "CTRL-D") EDITING :
            IF FRAME-FIELD = "xkgp_wkctr" THEN DO :
                {mfnp.i wc_mstr xkgp_wkctr wc_wkctr xkgp_wkctr wc_wkctr wc_wkctr}
                IF recno <> ? THEN DO :
                    xkgp_wkctr = wc_wkctr .
                    DISPLAY xkgp_wkctr WITH frame a .
                END.
            END.
            ELSE DO :
		    ststatus = stline[2].      /*display F5 delete message*/
		    status input ststatus.  
                READKEY.
                APPLY LASTKEY .
            END. 
        END.

        FIND FIRST wc_mstr where wc_wkctr = input xkgp_wkctr NO-LOCK NO-ERROR.
        IF NOT AVAILABLE wc_mstr then do :
            MESSAGE "请输入有效工作中心。" .
            NEXT-PROMPT xkgp_wkctr WITH FRAME a.
            UNDO second-loop ,RETRY second-loop .
        END.

        IF INPUT xkgp_lead_time < xkgp_urg_time THEN DO:
            MESSAGE "紧急提前期不能大于正常提前期" .
            NEXT-PROMPT xkgp_urg_time WITH FRAME a.
            UNDO second-loop ,RETRY second-loop .
        END.


        IF INPUT xkgp_lead_time <= 0 THEN DO:
            MESSAGE "提前期必须大于零。" .
            NEXT-PROMPT xkgp_lead_time WITH FRAME a.
            UNDO second-loop ,RETRY second-loop .
        END.


        IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D") THEN DO:
            yn = YES .
            MESSAGE "确认删除这种分组吗？" UPDATE yn .
            IF yn THEN DO :
                FOR EACH xkgpd_det WHERE xkgpd_group = xwgroup :
                    DELETE xkgpd_det .
                END.
                DELETE xkgp_mstr .
		clear frame a.
		NEXT mainloop .
            END.
        END.
    END.

    MainBlock:
    do on error undo,leave on endkey undo,leave:

        { xkut001.i
          &file = "xkgpd_det"
          &where = "where (xkgpd_group = xkgp_group)"
          &frame = "f-errs"
          &fieldlist = "xkgpd_line
                        xkgpd_site
                        xkgpd_sup
                        xkgpd_part
                        xkgpd_urgcard
                        des 
/*zx01*/ xkgpd__log01                        
                        "
          &prompt     = "xkgpd_line"
          &pgupkey    = "ctrl-u"
          &pgdnkey    = "ctrl-n"
          &midchoose  = "color mesages"
          &prechoose  = "~{xkgroua.i~}"
          &postdisplay  = "~{xkgroue.i~}"
          &updkey = "M"
          &updcode = "~{xkgroub.i~}"
          &inskey = "A"
          &inscode = "~{xkgrouc.i~}"
          &delkey = "D"
          &delcode = "~{xkgroud.i~}"
        }         

    END.


 END.
END.

