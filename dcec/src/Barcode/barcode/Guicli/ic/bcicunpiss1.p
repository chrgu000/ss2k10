{bcdeclre.i NEW}
    {bcwin02.i}
    {bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/
DEF VAR bc_site AS CHAR FORMAT "x(8)" LABEL "地点".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "库位".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEF VAR bc_site1 AS CHAR FORMAT "x(8)" LABEL "地点".
DEF VAR bc_so_job AS CHAR FORMAT "x(8)" LABEL "订单".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".
DEF VAR bc_dr AS CHAR FORMAT "x(8)" LABEL "借记".
DEF VAR qty_chg AS DECIMAL.
DEF FRAME bc
    bc_id AT ROW 1.5 COL 4
    bc_part AT ROW 2.7 COL 2.5
   
    
   bc_lot AT ROW 3.9 COL 1.6
   /* bc_ref AT ROW 5.1 COL 2.5*/
    bc_qty AT ROW 5.1 COL 4
  /* bc_pkqty AT ROW 10 COL 4*/
    bc_site AT ROW 6.3 COL 4

    bc_loc AT ROW 7.5 COL 4
  bc_so_job AT ROW 8.7 COL 4

   /*bc_dr AT ROW 10.8 COL 4*/
    bc_button AT ROW 11 COL 10
    WITH SIZE 30 BY 14 TITLE "计划外出库"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.


ENABLE bc_id WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 DISP bc_part 
   
   
   bc_lot 
    bc_qty 
   
    bc_site 

    bc_loc 
  
    WITH FRAME bc .
VIEW c-win.

ON enter OF bc_id
DO:
        bc_id = bc_id:SCREEN-VALUE.
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
         input  ""out"" , 
        input """",
         input """",
        output success)"}
        IF NOT success THEN 
        UNDO,RETRY.
      ELSE DO:
     

          
          
              DISABLE bc_id WITH FRAME bc.
              FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
              FIND FIRST b_ld_det WHERE b_ld_code = b_co_code AND b_ld_qty_oh <> 0 NO-LOCK NO-ERROR.
              IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                 bc_ref = b_co_ref.
                  bc_qty = b_co_qty_cur.
                  DISP bc_part bc_lot /*bc_ref*/ bc_qty WITH FRAME bc.
                  END.
                  IF AVAILABLE b_ld_det THEN DO:
                  bc_site = b_ld_site.
                  bc_loc = b_ld_loc.
                      
                      
                     DISP bc_site bc_loc WITH FRAME bc. 
                      ENABLE bc_site WITH FRAME bc.
                      
                      END.
                      ELSE DO:
                          MESSAGE '该条码无库存！' VIEW-AS ALERT-BOX.
                          ENABLE bc_id WITH FRAME bc.
                          UNDO,RETRY.
                      END.
                  
      END.
          

         
    END.

ON enter OF bc_so_job
DO:
   bc_so_job = bc_so_job:SCREEN-VALUE.
   DISABLE bc_so_job WITH FRAME bc.
   ENABLE bc_button WITH FRAME bc.
END.
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
ON 'choose':U OF bc_BUTTON
      DO:
    DISABLE bc_button WITH FRAME bc.
    RUN main.



        
        END.
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
         input """", 
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
        input bc_lot,
         input bc_ref, 
        input ""iss-unp"" , 
        input """", 
        input """",
         input """", 
        input """",
         input """",
    INPUT """",
        output success)"}      
IF NOT success THEN LEAVE.
FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
b_co_status = 'issued'.

FIND FIRST b_ld_det WHERE b_ld_code = b_co_code AND b_ld_qty_oh <> 0 EXCLUSIVE-LOCK NO-ERROR.
 
b_ld_qty_oh = 0.

     {bctrcr.i
         &ord=""""
         &mline=?
         &b_code=b_co_code
         &b_part=b_co_part
         &b_lot=b_co_lot
         &b_ser=b_co_ser
         &b_qty_ord=0
         &b_qty_loc="b_co_qty_cur * -1"
         &b_qty_chg="b_co_qty_cur * -1"
         &b_um=b_co_um
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"iss-unp"'
          &mtime=TIME
           &b_loc=bc_loc
           &b_site=bc_site
           &b_usrid=g_user}
           {bcusrhist.i }
          FIND FIRST b_ct_ctrl NO-LOCK NO-ERROR.
         IF b_ct_up_mtd = 'online' THEN DO:

             {bcrun.i ""bcmgwrbf.p"" 
          "(INPUT """",
          INPUT 0,
          INPUT b_co_code,
          INPUT b_co_part,
          INPUT b_co_lot,
          INPUT b_co_ser,
           INPUT b_co_ref,
    INPUT b_co_qty_cur ,
          INPUT b_co_um,
    INPUT TODAY,
    INPUT ?,
    INPUT ?,
    INPUT """",
    INPUT 0,
    INPUT bc_loc,
    INPUT bc_site,
    INPUT ""icunis.p"",
    INPUT """",
    INPUT """",
    INPUT """",
    INPUT """",
    INPUT bc_so_job,
    INPUT """",
    INPUT """",
    INPUT """",
    INPUT """",
    INPUT mcount,
    INPUT ?,
    OUTPUT bid)"}
        
        
             
             
             
             
            {bcrun.i ""bcmgwrfl.p"" "(INPUT ""icunis"",input bid )"
               }
             
             
             
             
             
             
             
             
             
             END.
    MESSAGE '业务操作成功！' VIEW-AS ALERT-BOX INFORMATION.
   {bcrelease.i}
    ENABLE bc_id WITH FRAME bc.
END.
{bctrail.i}
