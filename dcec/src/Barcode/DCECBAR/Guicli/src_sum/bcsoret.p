{mfdeclre.i }
{bcdeclre.i }
    
    {bcwin01.i }
{bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(20)"  LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_so_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_so_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".

DEF VAR bc_so_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
DEF VAR bc_site AS CHAR FORMAT "x(18)" LABEL "地点".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "库位".
DEF VAR bc_so_nbr AS CHAR FORMAT "x(8)"    LABEL "销售单".
DEF VAR bc_so_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_so_line AS CHAR FORMAT "x(8)"  LABEL "行号".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR bc_sub AS LOGICAL LABEL "转包".
DEF VAR bc_woid AS CHAR FORMAT "x(8)" LABEL "标志".
DEF VAR bc_wo AS CHAR FORMAT "x(8)" LABEL "工单".
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".
DEF VAR msite AS CHAR.
DEF FRAME bc
    bc_so_nbr AT ROW 1.2 COL 2.5
    bc_so_line AT ROW 2.4 COL 4
 /* bc_so_part AT ROW 3.6 COL 2.5*/
    bc_so_qty AT ROW 3.6 COL 4  
    'EA' AT ROW 3.6 COL 22 
    /*bc_so_part_desc  AT ROW 6 COL 1
    bc_so_part_desc1  NO-LABEL AT ROW 7 COL 8.5*/
    /*bc_sub AT ROW 6 COL 4
    bc_wo AT ROW 7.2 COL 4
    bc_woid AT ROW 8.4 COL 4*/
    bc_id AT ROW 4.8 COL 4
    bc_part AT ROW 6 COL 2.5
   
  
   bc_lot AT ROW 7.2 COL 1.6
   /* bc_ref AT ROW 9.6 COL 2.5*/
    bc_qty AT ROW 8.4 COL 4 'EA' AT ROW 8.4 COL 22 
   
    bc_site AT ROW 9.6 COL 4

    bc_loc AT ROW 10.8 COL 4
  
   
    WITH SIZE 30 BY 14 TITLE "销售退货"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_so_nbr 
   /* bc_so_line
  
    bc_id  bc_button */ 
     WITH FRAME bc IN WINDOW c-win.
/*
bc_sub = NO.
DISP bc_sub WITH FRAME bc.*/
/*DISABLE bc_so_part_desc  bc_so_part_desc1 WITH FRAME bc_pick .*/
 /*DISP bc_part 
   bc_so_qty
  /*  bc_so_part_desc  
    bc_so_part_desc1  */
   bc_lot 
    bc_qty 
   
    bc_site 

    bc_loc 
  
    WITH FRAME bc .*/
/*VIEW c-win.*/


ON CURSOR-DOWN OF bc_so_nbr
DO:
    
       ASSIGN bc_so_nbr.
       FIND FIRST so_mstr NO-LOCK WHERE so_nbr > bc_so_nbr NO-ERROR.
       IF AVAILABLE so_mstr THEN DO:
           ASSIGN bc_so_nbr = so_nbr.
           DISPLAY bc_so_nbr WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_so_nbr
DO:
   
       ASSIGN bc_so_nbr.
       FIND LAST so_mstr NO-LOCK WHERE so_nbr < bc_so_nbr NO-ERROR.
       IF AVAILABLE so_mstr THEN DO:
           ASSIGN bc_so_nbr = so_nbr.
           DISPLAY bc_so_nbr WITH FRAME bc.
       END.
   
END.
ON enter OF bc_so_nbr
DO:
    bc_so_nbr = bc_so_nbr:SCREEN-VALUE.
    {bcrun.i ""bcmgcheck.p"" "(input ""so"",
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_so_nbr, 
        input """",
         input """", 
        input """",
         input """",
        output success)"}
    IF  NOT success THEN do:
       
       UNDO,RETRY.

    END.
   ELSE DO: 
       DISABLE bc_so_nbr WITH FRAME bc.
       ENABLE bc_id WITH FRAME bc.
 
   END.
  
    END.

/*
   ON enter OF bc_so_line
DO:
        bc_so_line = bc_so_line:SCREEN-VALUE.
        
         {bcrun.i ""bcmgcheck.p"" "(input ""sod"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_so_nbr, 
        input bc_so_line,
         input """", 
        input """",
         input """",
        output success)"}
        IF  NOT success THEN do:
        UNDO,RETRY.
    END.
    ELSE do:
        {bcrun.i ""bcmgordexp.p"" "(INPUT ""sod"" ,
            INPUT bc_so_nbr,
            INPUT bc_so_line,
            OUTPUT part,OUTPUT qty,
            OUTPUT lntyp)"}

        bc_so_part = part.
    bc_so_qty = qty.
  
    DISP /*bc_so_part bc_so_qty*/ WITH FRAME bc.
     DISABLE bc_so_line WITH FRAME bc. 
    IF lntyp = 's' THEN do:
        bc_sub = YES.
       /* ENABLE bc_wo WITH FRAME bc.*/
    END.
    ELSE do:
        bc_sub = NO.
        bc_wo = ''.
        bc_woid = ''.
        ENABLE bc_id WITH FRAME bc.
        
        END.
    
   
    
    END.
    END.*/

   /* ON enter OF bc_sub
DO:
      
        IF bc_sub:SCREEN-VALUE = 'YES' THEN 
    ENABLE bc_wo  WITH FRAME bc.
        ELSE  ENABLE bc_id WITH FRAME bc.
        DISABLE bc_sub WITH FRAME bc.
        END.*/
    
    
 /*ON enter OF bc_wo
DO:
     bc_wo = bc_wo:SCREEN-VALUE.
    {bcrun.i ""bcmgcheck.p"" "(input ""wo"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_wo, 
        input """",
         input """", 
        input """",
         input """",
        output success)"}.
    IF NOT success THEN do:
      UNDO,RETRY.
      
    END.
    ELSE DO:
    DISABLE bc_wo WITH FRAME bc.
    ENABLE bc_woid WITH FRAME bc.
        
        END.
    END.

    ON enter OF bc_woid
DO:
        bc_woid = bc_woid:SCREEN-VALUE.
          {bcrun.i ""bcmgcheck.p"" "(input ""woid"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_wo, 
        input bc_woid,
         input """", 
        input """",
         input """",
        output success)"}
        IF NOT success THEN 
        UNDO,RETRY.
      ELSE 
          do:
              DISABLE bc_woid WITH FRAME bc.
          ENABLE bc_id WITH FRAME bc.
      END.
    END.*/
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
           {bcrun.i ""bcmgcheck.p"" "(input ""so_ret"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input bc_id, 
        input bc_so_nbr, 
        input """",
         input """", 
        input """",
         input """",
        output success)"}

          IF NOT success THEN 
        UNDO,RETRY.
      ELSE DO: 
           bc_so_line = lntyp.
           DISP bc_so_line WITH FRAME bc.
           {bcsodlock.i}   
           DISABLE bc_id WITH FRAME bc.
              
              IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                bc_so_qty = qty.
                  bc_qty = b_co_qty_cur.
                  DISP bc_part bc_lot /*bc_pack*/ bc_so_qty bc_qty WITH FRAME bc.
                  END.
              ENABLE bc_site WITH FRAME bc.
      END.
          
    
         
    END.

     ON enter OF bc_site
DO:
         
         bc_site = bc_site:SCREEN-VALUE.
         APPLY 'entry':u TO bc_site.
         msite = bc_site.
         bc_site = SUBSTR(msite,1,INDEX(msite,'.') - 1).
         bc_loc = SUBSTR(msite,INDEX(msite,'.') + 1).
         
       
             
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
         input """",
        output success)"}
           
           IF NOT success  THEN UNDO,RETRY.
           ELSE DO:
         
       DISABLE bc_site WITH FRAME bc.
      DISP bc_site bc_loc WITH FRAME bc.
     
      RUN main.
        
          END.     
       
   
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
         input ""SO"", 
        input """",
         input """",
        output success)"}   
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
        input ""iss-so"" , 
        input """", 
        input """",
         input """", 
        input """",
         input """",
    INPUT """",
        output success)"}      
IF NOT success THEN LEAVE.
         FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.  
          assign
              b_co_status = 'rct'
              b_co_site = bc_site
              b_co_loc = bc_loc
               b_co_ord = ""
           b_co_line = ""
          b_co_cust = ''
              b_co_due_date = ?.
          FIND FIRST b_ex_sod WHERE b_ex_so = bc_so_nbr AND b_ex_soln = bc_so_line EXCLUSIVE-LOCK NO-ERROR.
           IF AVAILABLE b_ex_sod THEN
                 ASSIGN
                     b_ex_issqty = b_ex_issqty - b_co_qty_cur.
          
           
         {bctrcr.i
         &ord=bc_so_nbr
         &mline=bc_so_line
         &b_code=?
         &b_part=b_co_part
         &b_lot=b_co_lot
         &id=?
         &b_qty_req=b_co_qty_req
         &b_qty_loc="b_co_qty_cur"
         &b_qty_chg="b_co_qty_cur"
         &b_qty_short="if available b_ex_sod then b_co_qty_req - b_ex_issqty else 0"
         &b_um=b_co_um
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"iss-so"'
          &mtime=TIME
           &b_loc=bc_loc
           &b_site=bc_site
           &b_usrid=g_user
           &b_addr=?}
           
             b_co_qty_req = 0.
             
             
             
             
             
             
           /* MESSAGE '业务操作成功！' VIEW-AS ALERT-BOX INFORMATION. */
             {bcsodrelease.i}
             {bcrelease.i}
    ENABLE bc_id WITH FRAME bc.
  APPLY 'entry':u TO bc_id.
     
END.



    {BCTRAIL.I}
