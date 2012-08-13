{bcdeclre.i }
    {bcwin02.i}
     {bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/
DEF VAR bc_site AS CHAR FORMAT "x(18)" LABEL "入地点".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "入库位".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEF VAR bc_site1 AS CHAR FORMAT "x(8)" LABEL "地点".
DEF VAR bc_so_job AS CHAR FORMAT "x(8)" LABEL "预算号".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".
DEF VAR bc_cr AS CHAR FORMAT "x(8)" LABEL "定制码".
DEF VAR bc_emp AS CHAR FORMAT "x(8)" LABEL "雇员".
DEF VAR msite AS CHAR.
DEF VAR bc_prod_line AS CHAR FORMAT "x(8)" LABEL "生产线".
DEF TEMP-TABLE bk_tmp
    FIELD bk_sess LIKE g_sess
   FIELD  bk_part LIKE b_rep_part
   FIELD  bk_qty LIKE b_rep_qty_iss
   FIELD  bk_site LIKE b_rep_site
    FIELD bk_ln_loc LIKE b_rep_ln_loc.

DEF FRAME bc
    bc_emp AT ROW 1.2 COL 4
   
    bc_id AT ROW 2.4 COL 4
    bc_part AT ROW 3.6 COL 2.5
   
    
   bc_lot AT ROW 4.8 COL 1.6
    /*bc_ref AT ROW 5.1 COL 2.5*/
    bc_qty AT ROW 6 COL 4
  /* bc_pkqty AT ROW 10 COL 4*/
    bc_site AT ROW 7.2 COL 2.5

    bc_loc AT ROW 8.4 COL 2.5
     bc_prod_line AT ROW 9.6 COL 2.5
  /*bc_so_job AT ROW 8.7 COL 2.5
bc_cr AT ROW 9.9 COL 2.5*/
   /*bc_dr AT ROW 10.8 COL 4*/
 
    WITH SIZE 30 BY 12 TITLE "自制件入库回冲"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.


ENABLE bc_emp WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 
VIEW c-win.
ON CURSOR-DOWN OF bc_emp
DO:
    ASSIGN bc_emp.
    FIND FIRST emp_mstr WHERE emp_addr > bc_emp NO-LOCK NO-ERROR.
    IF AVAILABLE emp_mstr THEN DO:
        bc_emp = emp_addr.
        DISP bc_emp WITH FRAME bc.
    END.
END.

ON CURSOR-UP OF bc_emp
DO:
    ASSIGN bc_emp.
    FIND LAST emp_mstr WHERE emp_addr < bc_emp NO-LOCK NO-ERROR.
    IF AVAILABLE emp_mstr THEN DO:
        bc_emp = emp_addr.
        DISP bc_emp WITH FRAME bc.
    END.
END.
ON enter OF bc_emp
DO:
   ASSIGN bc_emp.
  {bcrun.i ""bcmgcheck.p"" "(input ""emp"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input  bc_emp , 
        input """",
         input """",
        output success)"}
        IF NOT success THEN DO: 
           ASSIGN bc_emp = ''.
           DISP bc_emp WITH FRAME bc.
           UNDO,RETRY.
        END.
        ELSE DO:
            DISABLE bc_emp WITH FRAME bc.
            ENABLE bc_id WITH FRAME bc.
        END.

END.

ON CURSOR-DOWN OF bc_id
DO:
    
       ASSIGN bc_id.
       FIND FIRST b_co_mstr NO-LOCK WHERE b_co_code > bc_id NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_id = b_co_code.
           DISPLAY bc_id WITH FRAME bc.
       END.
    
END.
ON CURSOR-UP OF bc_id
DO:
   
        ASSIGN bc_id.
       FIND LAST b_co_mstr NO-LOCK WHERE b_co_code < bc_id NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_id = b_co_code.
           DISPLAY bc_id WITH FRAME bc.
       END.
   
END.
ON enter OF bc_id
DO:
        bc_id = bc_id:SCREEN-VALUE.
        APPLY 'entry':u TO bc_id.
        FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
         {bcrun.i ""bcmgcheck.p"" "(input ""bd"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input bc_id, 
        input """", 
        input """",
         input  ""in"" , 
        input """",
         input """",
        output success)"}
        IF NOT success THEN DO: 
        bc_id = ''.
        DISP bc_id WITH FRAME bc.
        UNDO,RETRY.
        END.
      ELSE DO:
     

          
          
              DISABLE bc_id WITH FRAME bc.
              
              
              IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                 bc_ref = b_co_ref.
                  bc_qty = b_co_qty_cur.
                  DISP bc_part bc_lot /*bc_ref*/ bc_qty WITH FRAME bc.
                  END.
                  
                  ENABLE bc_site WITH FRAME bc.
      END.
          

         
    END.
 ON enter OF bc_site
DO:
           bc_site = bc_site:SCREEN-VALUE.
          /* APPLY 'entry':u TO bc_site.*/
         msite = bc_site.
         bc_site = SUBSTR(msite,1,INDEX(msite,'.') - 1).
         bc_loc = SUBSTR(msite,INDEX(msite,'.') + 1).
         
       
         /* {bcrun.i ""bcmgcheck.p"" "(input ""loc"" ,
        input bc_site,
        input bc_loc, 
        input bc_part, 
        input """", 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input ""rep"", 
        input """",
         input """",
        output success)"}
           
           IF NOT success  THEN do:
              ASSIGN bc_site = ''
                     bc_loc = ''.
               DISP bc_site bc_loc WITH FRAME bc.
               UNDO,RETRY.
           END.
           ELSE DO:*/
         
       DISABLE bc_site WITH FRAME bc.
      DISP bc_site bc_loc WITH FRAME bc.
     
    ENABLE bc_prod_line WITH FRAME bc.
        
        /*  END.   */  
       
  
   END.
ON CURSOR-DOWN OF bc_prod_line
DO:
    ASSIGN bc_prod_line.
    FIND FIRST b_rep_wkfl WHERE b_rep_site = bc_site AND b_rep_part = bc_part AND b_rep_line > bc_prod_line NO-LOCK NO-ERROR.
    IF AVAILABLE b_rep_wkfl THEN DO:
        bc_prod_line = b_rep_line.
        DISP bc_prod_line WITH FRAME bc.
    END.
END.

ON CURSOR-UP OF bc_prod_line
DO:
     ASSIGN bc_prod_line.
    FIND LAST b_rep_wkfl WHERE b_rep_site = bc_site AND b_rep_part = bc_part AND b_rep_line < bc_prod_line NO-LOCK NO-ERROR.
    IF AVAILABLE b_rep_wkfl THEN DO:
        bc_prod_line = b_rep_line.
        DISP bc_prod_line WITH FRAME bc.
    END.
END.
ON enter OF bc_prod_line
DO:
    ASSIGN bc_prod_line.
    FIND FIRST rps_mstr WHERE rps_site = bc_site AND rps_part = bc_part AND rps_line = bc_prod_line NO-LOCK NO-ERROR.
    IF NOT AVAILABLE rps_mstr THEN DO:
       MESSAGE '无效生产线或不属于该地点该零件!' VIEW-AS ALERT-BOX.
       ASSIGN bc_prod_line = ''.
       DISP bc_prod_line WITH FRAME bc.
       UNDO,RETRY.
    END.
    ELSE DO:
        DISABLE bc_prod_line WITH FRAME bc.
        RUN main.
    END.

END.
   /* ON enter OF bc_loc
DO:
        bc_loc = bc_loc:SCREEN-VALUE.
        
        {bcrun.i ""bcmgcheck.p"" "(input ""loc"" ,
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
         input """",
        output success)"}
        IF NOT success THEN UNDO,RETRY.
    ELSE DO:
       DISABLE bc_loc WITH FRAME bc.
       ENABLE bc_so_job WITH FRAME bc.
        
        
        
        END.
   
   
   END.*/
/*ON enter OF bc_so_job
DO:
   bc_so_job = bc_so_job:SCREEN-VALUE.
   DISABLE bc_so_job WITH FRAME bc.
  ENABLE bc_cr WITH FRAME bc.
END.*/
/*
ON enter OF bc_cr
DO:
   bc_cr = bc_cr:SCREEN-VALUE.
   DISABLE bc_cr WITH FRAME bc.
  RUN main.
END.*/
/*ON enter OF bc_dr
DO:
   bc_dr = bc_dr:SCREEN-VALUE.
   {bcrun.i ""bcmgcheck.p"" "(input ""acct"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input  bc_dr , 
        input """",
         input """",
        output success)"}
        IF NOT success THEN 
        UNDO,RETRY.
        ELSE DO:
       
   DISABLE bc_dr WITH FRAME bc.
   ENABLE bc_button WITH FRAME bc.
    END.
END.*/

        ON WINDOW-CLOSE OF c-win /* <insert window title> */
   DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO c-win.
  RETURN NO-APPLY.

        END.


PROCEDURE main:
    
    {bcrun.i ""bcmgcheck.p"" "(input ""period"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input ""IC"", 
        input """",
         input """",
        output success)"}   
     IF NOT success THEN LEAVE.
     {bcrun.i ""bcmgcheck.p"" "(input ""si_au"" ,
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
         input """",
        output success)"}   
     IF NOT success THEN LEAVE.
{bcrun.i ""bcmgcheck.p"" "(input ""ictr_typ"" ,
        input bc_site, 
        input bc_loc, 
        input bc_part, 
        input """",
         input """", 
        input ""rct-wo"" , 
        input """", 
        input """",
         input """", 
        input """",
         input """",
    INPUT """",
        output success)"}      
IF NOT success THEN LEAVE.
FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
ASSIGN b_co_status = 'rct'
       b_co_site = bc_site
        b_co_loc = bc_loc.
 
          

     {bctrcr.i
         &ord=b_co_part
         &mline=?
         &b_code=?
         &b_part=b_co_part
         &b_lot=b_co_lot
         &id=bc_prod_line
         &b_qty_req=0
         &b_qty_loc=b_co_qty_cur
         &b_qty_chg=b_co_qty_cur
         &b_qty_short=0
         &b_um=b_co_um
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"rct-wo"'
          &mtime=TIME
           &b_loc=bc_loc
           &b_site=bc_site
           &b_usrid=g_user
           &b_addr=bc_emp}
          
   /* MESSAGE '业务操作成功！' VIEW-AS ALERT-BOX INFORMATION.*/
    
         RUN bomexp(b_co_part,TODAY,b_co_site,b_co_qty_cur,b_co_part).
     
     FOR EACH bk_tmp WHERE bk_sess = g_sess NO-LOCK:
      {bctrcr.i
         &ord=b_co_part
         &mline=?
         &b_code=?
         &b_part=bk_part
         &b_lot=?
         &id=bc_prod_line
         &b_qty_req=0
         &b_qty_loc="bk_qty * -1"
         &b_qty_chg="bk_qty * -1"
         &b_qty_short=0
         &b_um='"ea"'
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"iss-wo"'
          &mtime=TIME
           &b_loc=bk_ln_loc
           &b_site=bk_site
           &b_usrid=g_user
           &b_addr=?}
     END.
     {bcrelease.i}
        ASSIGN
      bc_lot = ''
         bc_qty = 0
     bc_part = ''
     bc_id = ''
     bc_site = ''
     bc_loc = ''
         bc_emp = ''
         bc_prod_line = ''.
     DISP bc_emp bc_id bc_site bc_loc bc_lot bc_qty bc_part bc_prod_line WITH FRAME bc.
     ENABLE bc_id WITH FRAME bc.
         ENABLE bc_id WITH FRAME bc.
     APPLY 'entry':u TO bc_id.
END.



PROCEDURE bomexp:
    DEF INPUT PARAMETER mpart LIKE pt_part.
        DEF INPUT PARAMETER mdate AS DATE.
     DEF INPUT PARAMETER msite LIKE bc_site. 
     DEF INPUT PARAMETER mqty AS INT.
     DEF INPUT PARAMETER mord AS CHAR.
     DEF VAR noexp AS LOGICAL INITIAL NO.
     DEF VAR bomcode AS CHAR.
     DEF VAR phantom AS LOGICAL.
    DEF VAR routing AS CHAR.
     routing = mpart.
     bomcode = mpart.
    FIND FIRST ptp_det WHERE ptp_site = msite AND ptp_part = mpart AND ptp_bom_code <> '' NO-LOCK NO-ERROR.
    
    IF AVAILABLE ptp_det THEN assign
        bomcode = ptp_bom_code
        routing = ptp_routing.
    ELSE DO:
       FIND FIRST pt_mstr WHERE pt_part = mpart NO-LOCK NO-ERROR.
       IF AVAILABLE pt_mstr THEN
          assign
           bomcode = IF pt_bom_code <> '' THEN pt_bom_code ELSE pt_part
           routing = IF pt_routing <> '' THEN pt_routing ELSE pt_part.
    END.
    FOR EACH ps_mstr WHERE ps__chr01 = msite AND ps_par =  bomcode AND (IF ps_start <> ? THEN ps_start <= mdate ELSE YES) AND (IF ps_end <> ? THEN ps_end >= mdate ELSE YES) NO-LOCK:
    FIND FIRST ptp_det WHERE ptp_site = msite AND ptp_part = mpart  NO-LOCK NO-ERROR.
         IF AVAILABLE ptp_det THEN  assign
             phantom = ptp_phantom.
             
         
         ELSE DO:
        FIND FIRST pt_mstr WHERE pt_part = ps_comp NO-LOCK NO-ERROR.
         IF AVAILABLE pt_mstr THEN assign
             phantom = pt_phantom.
             
    END.
       IF ps_ps_code = 'x' THEN
                RUN bomexp(ps_comp,mdate,msite,mqty * ps_qty_per,mord).
        ELSE DO:
        
            
       IF phantom  THEN  DO:
           
                        /*  FIND FIRST ro_det WHERE ro_routing = (IF pt_routing <> '' THEN pt_routing ELSE mpart) AND  ro_op = ps_op NO-LOCK NO-ERROR.
                          FIND FIRST b_ld_det WHERE b_ld_part = ps_comp AND b_ld_site = msite AND b_ld_loc = ro_wkctr AND b_ld_qty_oh > 0 NO-LOCK NO-ERROR.
                           IF AVAILABLE b_ld_det THEN DO: 
                              FIND FIRST bk_tmp WHERE bk_sess = g_sess AND bk_site = msite AND bk_ln_loc = ro_wkctr AND bk_part = ps_comp EXCLUSIVE-LOCK NO-ERROR.
                              IF AVAILABLE bk_tmp THEN
                               ASSIGN bk_qty = bk_qty + (mqty * ps_qty_per).
                              ELSE DO:
                                  CREATE bk_tmp.
                                  ASSIGN
                                      bk_sess = g_sess
                                      bk_site = msite
                                      bk_ln_loc = ro_wkctr
                                      bk_part = ps_comp
                                      bk_qty = mqty * ps_qty_per.
                              END.
                               
                               noexp = YES.
                           END.
                     
                   
          IF NOT noexp THEN*/   RUN bomexp(ps_comp,mdate,msite,mqty * ps_qty_per,mord).
             END.
            ELSE DO:
               FIND FIRST ro_det WHERE ro_routing = routing AND  ro_op = ps_op AND (IF ro_start <> ? THEN ro_start <= mdate ELSE YES) AND (IF ro_end <> ? THEN ro_end >= mdate ELSE YES) NO-LOCK NO-ERROR.
                    FIND FIRST bk_tmp WHERE bk_sess = g_sess AND bk_site = msite AND bk_ln_loc = ro_wkctr AND bk_part = ps_comp EXCLUSIVE-LOCK NO-ERROR.
                              IF AVAILABLE bk_tmp THEN
                               ASSIGN bk_qty = bk_qty + (mqty * ps_qty_per).
                              ELSE DO:
                                  CREATE bk_tmp.
                                  ASSIGN
                                      bk_sess = g_sess
                                      bk_site = msite
                                      bk_ln_loc = ro_wkctr
                                      bk_part = ps_comp
                                      bk_qty = mqty * ps_qty_per.
                              END.     
            END.
        END.
       END.

          END.
{bctrail.i}
