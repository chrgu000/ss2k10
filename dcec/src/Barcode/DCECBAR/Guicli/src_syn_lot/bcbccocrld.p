{mfdeclre.i}
{bcdeclre.i  }
{bcwin00.i 12}
    {bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(18)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part1 AS CHAR FORMAT "x(18)" LABEL "至".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "数量".*/
DEF VAR bc_qty_std AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "标准数量".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEF VAR bc_split_qty AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "拆分数量".

DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".
DEFINE BUTTON bc_button1 LABEL "确认" SIZE 8 BY 1.50.
DEFINE BUTTON bc_button2 LABEL "打印" SIZE 8 BY 1.50.
DEFINE BUTTON bc_button3 LABEL "条码生成" SIZE 8 BY 1.50.
DEF VAR oktocomt AS LOGICAL.
DEF VAR bc_split_id LIKE bc_id.
DEF VAR bc_site AS CHAR LABEL "地点".
DEF VAR bc_site1 AS CHAR LABEL "至".
DEF VAR bc_loc AS CHAR LABEL "库位".
DEF VAR bc_loc1 AS CHAR LABEL "至".
DEF  VAR chExcelApplication   AS COM-HANDLE.
DEF  VAR chWorkbook           AS COM-HANDLE.
DEF  VAR chWorksheet          AS COM-HANDLE.
DEF VAR crange AS CHAR.
DEF VAR rowstart AS INT.
DEF VAR bc_mult AS LOGICAL  LABEL "最小包装".
DEF FRAME bc
   
    bc_site AT ROW 1.2 COL 4
   bc_site1 AT ROW 2.4 COL 5.5 
   /* bc_part_desc  AT ROW 5 COL 1
    bc_part_desc1  NO-LABEL AT ROW 6 COL 8.5*/

   bc_loc AT ROW 3.6 COL 4
    bc_loc1 AT ROW 4.8 COL 5.5
  
    bc_part AT ROW 6 COL 2.5
    bc_part1 AT ROW 7.2 COL 5.5
     bc_mult AT ROW 8.4 COL 1
   bc_button1 AT ROW 9.9 COL 10
    /*bc_button2 AT ROW 11 COL 16*/
    
    WITH SIZE 30 BY 12 TITLE "零件库存标签生成"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
bc_mult = NO.
ENABLE bc_site  bc_site1 bc_loc bc_loc1 bc_part bc_part1 bc_mult bc_button1 /*bc_button2*/ WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 DISP bc_mult WITH FRAME bc.
VIEW c-win.
ON CURSOR-DOWN OF bc_site
DO:
    
       ASSIGN bc_site.
       FIND FIRST si_mstr NO-LOCK WHERE si_site > bc_site NO-ERROR.
       IF AVAILABLE si_mstr THEN DO:
           ASSIGN bc_site = si_site.
           DISPLAY bc_site WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_site
DO:
   
       ASSIGN bc_site.
       FIND LAST si_mstr NO-LOCK WHERE si_site < bc_site NO-ERROR.
       IF AVAILABLE si_mstr THEN DO:
           ASSIGN bc_site = si_site.
           DISPLAY bc_site WITH FRAME bc.
       END.
   
END.
ON VALUE-CHANGED OF bc_site
DO:
    bc_site = bc_site:SCREEN-VALUE.
END.
ON enter OF bc_site
DO:
    bc_site = bc_site:SCREEN-VALUE.
    /*{bcrun.i ""bcmgcheck.p"" "(input ""site"",
        input bc_site,
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        INPUT """",
        output success)"}
        IF NOT success THEN
            UNDO,RETRY.
        ELSE DO:*/
   /*  DISABLE bc_site WITH FRAME bc.*/
        APPLY 'entry':u TO bc_site1.
       /* END.*/
END.
ON CURSOR-DOWN OF bc_site1
DO:
    
       ASSIGN bc_site1.
       FIND FIRST si_mstr NO-LOCK WHERE si_site > bc_site1 NO-ERROR.
       IF AVAILABLE si_mstr THEN DO:
           ASSIGN bc_site1 = si_site.
           DISPLAY bc_site1 WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_site1
DO:
   
       ASSIGN bc_site1.
       FIND LAST si_mstr NO-LOCK WHERE si_site < bc_site1 NO-ERROR.
       IF AVAILABLE si_mstr THEN DO:
           ASSIGN bc_site1 = si_site.
           DISPLAY bc_site1 WITH FRAME bc.
       END.
   
END.
ON VALUE-CHANGED OF bc_site1
DO:
    bc_site1 = bc_site1:SCREEN-VALUE.
END.
ON enter OF bc_site1
DO:
    bc_site1 = bc_site1:SCREEN-VALUE.
   /* {bcrun.i ""bcmgcheck.p"" "(input ""site"",
        input bc_site1,
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        INPUT """",
        output success)"}
        IF NOT success THEN
            UNDO,RETRY.
        ELSE DO:*/
 /*    DISABLE bc_site1 WITH FRAME bc.*/
      APPLY 'entry':u TO bc_loc.
        /*END.*/
END.
ON CURSOR-DOWN OF bc_loc
DO:
    
       ASSIGN bc_loc.
       FIND FIRST loc_mstr NO-LOCK WHERE /*loc_site = bc_site AND*/ loc_loc > bc_loc NO-ERROR.
       IF AVAILABLE loc_mstr THEN DO:
           ASSIGN bc_loc = loc_loc.
           DISPLAY bc_loc WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_loc
DO:
   
       ASSIGN bc_loc.
       FIND LAST loc_mstr NO-LOCK WHERE /*loc_site = bc_site AND*/ loc_loc < bc_loc NO-ERROR.
       IF AVAILABLE loc_mstr THEN DO:
           ASSIGN bc_loc = loc_loc.
           DISPLAY bc_loc WITH FRAME bc.
       END.
   
END.
ON VALUE-CHANGED OF bc_loc
DO:
    bc_loc = bc_loc:SCREEN-VALUE.
END.
ON enter OF bc_loc
DO:
    bc_loc = bc_loc:SCREEN-VALUE.
   /*{bcrun.i ""bcmgcheck.p"" "(input ""loc"",
        input bc_site, 
        input bc_loc, 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """",
         input """",
       INPUT """",
       INPUT """",
        output success)"}
        IF NOT success THEN
            UNDO,RETRY.
        ELSE DO: */
           
               
           /* DISABLE bc_loc WITH FRAME bc.*/
      APPLY 'entry':u TO bc_loc1.
                
       /* END.*/
END.
ON CURSOR-DOWN OF bc_loc1
DO:
    
       ASSIGN bc_loc1.
       FIND FIRST loc_mstr NO-LOCK WHERE /*loc_site = bc_site1 AND*/ loc_loc > bc_loc1 NO-ERROR.
       IF AVAILABLE loc_mstr THEN DO:
           ASSIGN bc_loc1 = loc_loc.
           DISPLAY bc_loc1 WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_loc1
DO:
   
       ASSIGN bc_loc1.
       FIND LAST loc_mstr NO-LOCK WHERE /*loc_site = bc_site1 AND*/ loc_loc < bc_loc1 NO-ERROR.
       IF AVAILABLE loc_mstr THEN DO:
           ASSIGN bc_loc1 = loc_loc.
           DISPLAY bc_loc1 WITH FRAME bc.
       END.
   
END.
ON VALUE-CHANGED OF bc_loc1
DO:
    bc_loc1 = bc_loc1:SCREEN-VALUE.
END.
ON enter OF bc_loc1
DO:
    bc_loc1 = bc_loc1:SCREEN-VALUE.
    APPLY 'entry':u TO bc_part.
   /*{bcrun.i ""bcmgcheck.p"" "(input ""loc"",
        input bc_site1, 
        input bc_loc1, 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """",
         input """",
       INPUT """",
       INPUT """",
        output success)"}
        IF NOT success THEN
            UNDO,RETRY.
        ELSE DO:*/ 
           
               
          /*  DISABLE bc_loc1 WITH FRAME bc.*/
   /* APPLY 'entry':u TO bc_button.*/
     
        /*        
        END.*/
END.
ON CURSOR-DOWN OF bc_part
DO:
    
       ASSIGN bc_part.
       FIND FIRST pt_mstr NO-LOCK WHERE pt_part > bc_part NO-ERROR.
       IF AVAILABLE pt_mstr THEN DO:
           ASSIGN bc_part = pt_part.
           DISPLAY bc_part WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_part
DO:
   
       ASSIGN bc_part.
       FIND LAST pt_mstr NO-LOCK WHERE pt_part < bc_part NO-ERROR.
       IF AVAILABLE pt_mstr THEN DO:
           ASSIGN bc_part = pt_part.
           DISPLAY bc_part WITH FRAME bc.
       END.
   
END.
ON enter OF bc_part
DO:
     ASSIGN bc_part.
    APPLY 'entry':u TO bc_part1.
END.

    ON VALUE-CHANGED OF bc_part
    DO:
        ASSIGN bc_part.
    END.

    ON CURSOR-DOWN OF bc_part1
DO:
    
       ASSIGN bc_part1.
       FIND FIRST pt_mstr NO-LOCK WHERE pt_part > bc_part1 NO-ERROR.
       IF AVAILABLE pt_mstr THEN DO:
           ASSIGN bc_part1 = pt_part.
           DISPLAY bc_part1 WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_part1
DO:
   
       ASSIGN bc_part1.
       FIND LAST pt_mstr NO-LOCK WHERE pt_part < bc_part1 NO-ERROR.
       IF AVAILABLE pt_mstr THEN DO:
           ASSIGN bc_part1 = pt_part.
           DISPLAY bc_part1 WITH FRAME bc.
       END.
   
END.
ON enter OF bc_part1
DO:
     ASSIGN bc_part1.
    APPLY 'entry':u TO bc_mult.
END.

    ON VALUE-CHANGED OF bc_part1
    DO:
        ASSIGN bc_part1.
    END.
    ON CURSOR-DOWN OF bc_mult
DO:
 ASSIGN bc_mult.
 IF bc_mult  THEN bc_mult = NO.
       ELSE bc_mult = YES.
       DISP bc_mult WITH FRAME bc.

 END.

 ON CURSOR-UP OF bc_mult
DO:
 ASSIGN bc_mult.
 IF bc_mult  THEN bc_mult = NO.
       ELSE bc_mult = YES.
       DISP bc_mult WITH FRAME bc.

 END.

 ON VALUE-CHANGED OF bc_mult
 DO:
     ASSIGN bc_mult.
 END.
 ON enter OF bc_mult
 DO:
     ASSIGN  bc_mult.
     APPLY 'entry':u TO bc_button1.
 END.
ON 'choose':U OF bc_button1
DO:
    RUN main.
END.

/*ON 'choose':U OF bc_button2
DO:
    RUN prt.
END.*/





ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.
PROCEDURE main:
      DEF VAR b_id LIKE b_co_code.
      DEF VAR m_fmt LIKE b_co_format.
     DEF VAR bc_qty_mult AS DECIMAL.
      DEF VAR i AS INT.
      DEF VAR j AS INT.
   DEF VAR mqty AS DECIMAL.
   DEF VAR bcprefix AS CHAR.
   DEF VAR bc_rlse_qty AS DECIMAL.
   DEF VAR bc_qty_label AS DECIMAL.
   DEF VAR mdesc AS CHAR FORMAT "x(50)".
    DEF VAR prt AS CHAR FORMAT 'x(22)' LABEL '打印机'.
      DEF VAR isfirst AS CHAR.
          DEF VAR isleave AS LOGICAL.
          isfirst = 'first'.
    IF bc_site1 = '' THEN bc_site1 = hi_char.
   IF bc_loc1 = ''  THEN bc_loc1 = hi_char.
   IF bc_part1 = '' THEN bc_part1 = hi_char.
   
      /*DEF BUFFER absmstr FOR ABS_mstr.*/
    
      /*FOR EACH ABS_mstr WHERE (abs_id BEGINS 's' OR abs_id BEGINS 'c') AND abs_type = 'r' AND substr(ABS_id,2,50) >= bc_poshp AND substr(ABS_id,2,50) <= bc_poshp1 NO-LOCK:
         FIND FIRST b_co_mstr WHERE b_co_ref = SUBSTR(ABS_id,2,50) NO-LOCK NO-ERROR.
         IF NOT AVAILABLE  b_co_mstr THEN DO:*/
 j = 1.
    bcprefix = SUBSTR(string(YEAR(TODAY),'9999'),3,2) + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99') + STRING(TIME,'999999') + SUBstr(STRING(etime),LENGTH(STRING(etime)) - 1,2).
    
     FOR EACH ld_det WHERE ld_site >= bc_site AND ld_site <= bc_site1 AND ld_loc >= bc_loc AND ld_loc <= bc_loc1 AND ld_part >= bc_part AND ld_part <= bc_part1 AND ld_qty_oh > 0 NO-LOCK,
          FIRST loc_mstr WHERE loc_loc = ld_loc and loc_site = ld_site AND loc_status <> "wip" NO-LOCK,
         FIRST pt_mstr WHERE pt_part = ld_part and
                    pt_prod_line <> "1201" AND 
                    pt_prod_line <> "1300" AND 
                    pt_prod_line <> "1400" AND 
                    pt_prod_line <> "2001" AND 
                    pt_prod_line <> "2304" AND 
                    pt_prod_line <> "2a0b" AND 
                    pt_prod_line <> "2a0l" AND 
                    pt_prod_line <> "6lta" AND 
     NOT
                    (pt_prod_line  > "7000" AND 
                    pt_prod_line  < "7zzz") AND 
                    pt_prod_line <> "8888" AND 
                    pt_prod_line <> "9999" AND 
                    pt_prod_line <> "999a" AND 
                    pt_prod_line <> "999b" AND 
                    pt_prod_line <> "nqad" NO-LOCK:
   
       mqty = 0.
      /*  FIND FIRST pod_det WHERE pod_nbr = ABS_order AND string(pod_line) = ABS_line NO-LOCK NO-ERROR.*/
          FOR EACH b_co_mstr USE-INDEX b_co_sort1  WHERE b_co_site = ld_site AND b_co_loc = ld_loc AND (b_co_status = 'rct' OR b_co_status = 'all') AND b_co_part = ld_part /*AND ld_lot = b_co_lot*/ NO-LOCK:

                            mqty = mqty + b_co_qty_cur.
          END.
    
        bc_rlse_qty = ld_qty_oh - mqty.
        IF bc_rlse_qty > 0 THEN DO:
     
        IF bc_mult  THEN DO:
           bc_qty_mult = bc_rlse_qty.
       FIND FIRST ptp_det WHERE ptp_part = ld_part AND ptp_site = ld_site NO-LOCK NO-ERROR.
        IF AVAILABLE ptp_det THEN
            bc_qty_mult = IF ptp_ord_mult <> 0 THEN ptp_ord_mult ELSE bc_rlse_qty.
           ELSE DO:
         
              IF AVAILABLE pt_mstr THEN  bc_qty_mult = IF pt_ord_mult <> 0 THEN pt_ord_mult ELSE bc_rlse_qty.

           END.
        END.
            IF bc_mult THEN     bc_qty_label = IF bc_qty_mult <> 0 AND bc_rlse_qty MOD bc_qty_mult <> 0 THEN truncate(bc_rlse_qty / bc_qty_mult,0) + 1 ELSE
                 bc_rlse_qty / (IF bc_qty_mult <> 0 THEN bc_qty_mult ELSE bc_rlse_qty). 
               ELSE
                   bc_qty_label = 1.
          
                        
             
             DO i = 1 TO bc_qty_label:
             
                   IF j MOD 1000 = 0 THEN do:
                     PAUSE 1.
                      MESSAGE '已生成1000张标签！' VIEW-AS ALERT-BOX.
                     bcprefix = SUBSTR(string(YEAR(TODAY),'9999'),3,2) + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99') + STRING(TIME,'999999') + SUBstr(STRING(etime),LENGTH(STRING(etime)) - 1,2).
                     j = 1.
                     END.
                 b_id = bcprefix + STRING(j,'999').
                   
                       bc_id = b_id.
                  
                  
                   CREATE b_co_mstr.
               ASSIGN 
                   b_co_code = b_id
                   b_co_part = ld_part
                   b_co_lot = b_id
                                   /* b_co_qty_ini = bc_qty*/
                 
                    b_co_qty_cur = 
                                   IF bc_mult THEN ( IF i < bc_qty_label THEN bc_qty_mult ELSE IF bc_rlse_qty MOD bc_qty_mult = 0 THEN bc_qty_mult ELSE bc_rlse_qty MOD bc_qty_mult
                        )
                                       ELSE
                           bc_rlse_qty
                   /*b_co_qty_std = bc_qty_std*/
                   b_co_um = 'ea'
                  /* b_co_status = 'ac'*/
                   /*b_co_format = m_fmt*/
                   b_co_userid = barusr
                  /* b_co_ord = ABS_order
                   b_co_line = ABS_line
                   b_co_vend = ABS_shipfrom
                  b_co_ref = substr(ABS_par_id,2,50)*/
                  /* b_co_qty_req = bc_rlse_qty*/
                   b_co_desc1 = IF AVAILABLE pt_mstr THEN pt_desc1 ELSE ''
                   b_co_desc2 = IF AVAILABLE pt_mstr THEN pt_desc2 ELSE ''
                   b_co_site = ld_site
                    b_co_loc = ld_loc
                       b_co_status = 'rct'.
                     j = j + 1.
                      mdesc = b_co_desc2 + b_co_desc1.
                
                 {bclabel.i ""zpl"" ""part"" "b_co_code" "b_co_part" 
     "b_co_lot" "b_co_ref" "b_co_qty_cur" "b_co_vend" "mdesc"  }
                
                 end.
                       
        END.
           
        END.

      
        /* ELSE DO:
             FOR EACH b_co_mstr WHERE b_co_ref = SUBSTR(ABS_mstr.ABS_id,2,50) NO-LOCK:
{bclabel.i ""zpl"" ""part"" "b_co_code" "b_co_part" 
     "b_co_lot" "b_co_ref" "b_co_qty_cur" "b_co_vend"}
             END.
         END.*/
     
              /* {bcusrhist.i }*/
                   
/*MESSAGE "是否打印？" SKIP(1)
        "继续?"
        VIEW-AS ALERT-BOX
        QUESTION
        BUTTON YES-NO
        UPDATE oktocomt.*/
 /*IF oktocomt THEN DO:*/
/* FIND FIRST b_usr_mstr WHERE b_usr_usrid = g_user NO-LOCK NO-ERROR.*/
    /*IF b_usr_prt_typ <> 'ipl' AND b_usr_prt_typ <> 'zpl' THEN DO:
    MESSAGE '本系统暂不支持除了ipl,zpl类型的条码打印机!' VIEW-AS ALERT-BOX ERROR.

        LEAVE.*/
       /* END.*/
 /*OUTPUT TO VALUE(b_usr_printer).*/

 
     
     
  
   
     
    
              RELEASE b_co_mstr.
   
               RELEASE b_po_wkfl.
               ENABLE bc_site WITH FRAME bc.
               APPLY 'entry':u TO bc_site.
            
               END.


{bctrail.i}
