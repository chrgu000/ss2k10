{mfdeclre.i}
{bcdeclre.i  }
{bcwin02.i}
    {bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(18)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc AS CHAR FORMAT "x(20)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(20)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/
DEF VAR bc_qty_std AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "标准数量".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEF VAR bc_split_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "拆分数量".
DEF VAR bcprefix AS CHAR.
DEF VAR bc_po_nbr AS CHAR FORMAT "x(8)" LABEL "排程单".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR oktocomt AS LOGICAL.
DEF VAR bc_split_id LIKE bc_id.
DEF VAR bc_site AS CHAR.
DEF VAR bc_loc AS CHAR.
DEF VAR bc_qty_label AS  DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "张数".
DEF VAR ismodi AS LOGICAL.
DEF VAR bc_po_vend AS CHAR FORMAT "x(8)" LABEL '供应商'.
DEF VAR bc_po_vend1 AS CHAR FORMAT "x(8)" LABEL "至".
DEF VAR bc_po_nbr1 AS CHAR FORMAT "x(8)" LABEL "至".
DEF VAR bc_part1 AS CHAR FORMAT 'x(8)' LABEL "至".
DEF VAR bc_rlse_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "需求量".
DEF VAR bc_date AS DATE LABEL '日期'.
DEF VAR bc_date1 AS DATE LABEL '至'.
DEF VAR bc_site1 AS CHAR FORMAT "x(8)" LABEL "至".
DEF TEMP-TABLE b_po_chk
    FIELD b_po_recid AS RECID.
DEF FRAME bc
    bc_date AT ROW 1.5 COL 4
    bc_site  AT ROW 3 COL 4
    bc_site1 AT ROW 4.5 COL 5.5
    bc_part AT ROW 6 COL 2.5
   /* bc_po_nbr AT ROW 6.5 COL 2.5*/
    bc_part1 AT ROW 7.5 COL 5.6
  /* bc_pkqty AT ROW 10 COL 4*/
   /* bc_qty_std AT ROW 8 COL 1*/
  
  
  /* bc_date1 AT ROW 9.6 COL 5.6*/
    bc_button AT ROW 9 COL 10
    
    WITH SIZE 30 BY 12 TITLE "自制料件需求导入"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE  bc_part bc_part1 bc_date bc_site bc_site1  bc_button WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 bc_date = TODAY + 1.

 DISP bc_date WITH FRAME bc.
VIEW c-win.


/*ENABLE bc_part  WITH FRAME bc IN WINDOW c-win.*/
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
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
      APPLY 'entry':u TO bc_part.
        /*END.*/
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
ON VALUE-CHANGED OF bc_part
DO:
 bc_part = bc_part:SCREEN-VALUE.
END.
ON enter OF bc_part
DO:
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    bc_part = bc_part:SCREEN-VALUE.
  /*  DISABLE bc_part WITH FRAME bc.
    ENABLE bc_part1 WITH FRAME bc.*/
    APPLY 'entry':u TO bc_part1.
         
     
      /*bc_lot = bcprefix.
      DISP bc_lot WITH FRAME bc.  
      ENABLE bc_lot WITH FRAME bc.*/
       /* END.*/
   
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
ON VALUE-CHANGED OF bc_part1
DO:
 bc_part1 = bc_part1:SCREEN-VALUE.
END.
ON enter OF bc_part1
DO:
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    bc_part1 = bc_part1:SCREEN-VALUE.
    /*DISABLE bc_part1 WITH FRAME bc.*/
    
  /*  ENABLE bc_date WITH FRAME bc.*/
    APPLY 'entry':u TO bc_button.
         
     
      /*bc_lot = bcprefix.
      DISP bc_lot WITH FRAME bc.  
      ENABLE bc_lot WITH FRAME bc.*/
       /* END.*/
   
END.

ON VALUE-CHANGED OF bc_date
DO:
ASSIGN bc_date.
END.
ON enter OF bc_date
DO:
    ASSIGN bc_date.
       /* DISABLE bc_date WITH FRAME bc.
    ENABLE bc_date1 WITH FRAME bc.*/
    APPLY 'entry':u TO bc_part.
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
      DEF VAR b_id LIKE b_co_code.
      DEF VAR m_fmt LIKE b_co_format.
    
      DEF VAR i AS INT.
      IF bc_po_vend1 = '' THEN bc_po_vend1 = hi_char.
      IF bc_po_nbr1 = '' THEN bc_po_nbr1 = hi_char.
      IF bc_part1 = '' THEN bc_part1 = hi_char.
     /* IF bc_date = ? THEN bc_date = low_date.
      IF bc_date1 = ? THEN bc_date1 = hi_date.*/
    IF bc_site1 = '' THEN bc_site1 = hi_char.
     
      for each rps_mstr no-lock
   where rps_due_date = bc_date AND rps_site >= bc_site AND rps_site <= bc_site1  AND rps_part >= bc_part AND rps_part <= bc_part1:
   
      
        RUN bomexp(rps_part,rps_due_date,rps_site,rps_qty_req).

     END.
      
      RELEASE b_rep_wkfl.
    
               END.

PROCEDURE bomexp:
    DEF INPUT PARAMETER mpart LIKE pt_part.
    DEF INPUT PARAMETER mdate AS DATE.
     DEF INPUT PARAMETER msite LIKE rps_site. 
     DEF INPUT PARAMETER mqty LIKE rps_qty_req.
     DEF VAR noexp AS LOGICAL INITIAL NO.
    FIND pt_mstr WHERE pt_part = mpart NO-LOCK NO-ERROR.
    
    FOR EACH ps_mstr WHERE ps_par =  IF pt_bom_code <> '' THEN pt_bom_code ELSE mpart NO-LOCK:
        
       IF ps_ps_code = 'x' THEN
                RUN bomexp(ps_comp,mdate,msite,mqty * ps_qty_per).
        ELSE DO:
        
            
       IF pt_phantom  THEN  DO:
           
                    FOR EACH ld_det WHERE ld_part = ps_comp AND (ld_qty_oh - ld_qty_all - ld_qty_frz) > 0 NO-LOCK :
                 
                     FIND FIRST loc_mstr WHERE loc_site = ld_site AND loc_loc = ld_loc AND loc_type <> 'wip' NO-LOCK NO-ERROR.
                       IF AVAILABLE loc_mstr THEN DO:
                           FIND FIRST ro_det WHERE ro_op = ps_op NO-LOCK NO-ERROR.
                           CREATE b_rep_wkfl.
                           ASSIGN
                               b_rep_due_date = mdate
                               b_rep_part = ps_comp
                               b_rep_site = msite
                               b_rep_ln_loc = IF AVAILABLE ro_det THEN ro_wkctr ELSE ''
                               b_rep_qty_req = mqty * ps_qty_per.
                           noexp = YES.
                       END.
                     IF noexp THEN LEAVE.
                   END.
          IF NOT noexp THEN   RUN bomexp(ps_comp,mdate,msite,mqty * ps_qty_per).
             END.
            ELSE DO:
              FIND FIRST ro_det WHERE ro_op = ps_op NO-LOCK NO-ERROR.
                           CREATE b_rep_wkfl.
                           ASSIGN
                               b_rep_due_date = mdate
                               b_rep_part = ps_comp
                               b_rep_site = msite
                               b_rep_ln_loc = IF AVAILABLE ro_det THEN ro_wkctr ELSE ''
                                b_rep_qty_req = mqty * ps_qty_per.
            END.
        END.
       END.

          END.
{bctrail.i}
