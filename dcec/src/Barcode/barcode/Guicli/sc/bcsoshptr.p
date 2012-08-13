{bcdeclre.i }
    {bcwin01.i}
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
DEF VAR bc_site1 AS CHAR FORMAT "x(15)" LABEL "地点".
DEF VAR bc_loc1 AS CHAR FORMAT "x(8)" LABEL "库位". 
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF TEMP-TABLE blddet LIKE b_ld_det.
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".
DEF VAR mid1 LIKE b_tr_id.
DEF VAR mid2 LIKE b_tr_id.
DEF VAR bc_cust AS CHAR FORMAT "x(8)" LABEL "客户".
DEF VAR bc_so_nbr AS CHAR FORMAT "x(8)" LABEL "订单".
DEF VAR bc_so_line AS CHAR FORMAT "x(8)" LABEL "行号".
DEF VAR bc_so_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_so_qty AS DECIMAL LABEL "数量".
DEF VAR id AS CHAR.
DEF FRAME bc
    
    bc_cust AT ROW 1.2 COL 4
    bc_so_nbr AT ROW 2.4 COL 4
    bc_so_line AT ROW 3.6 COL 4
    bc_so_part AT ROW 4.8 COL 2.5
    bc_so_qty AT ROW 6  COL 4 "EA" AT ROW 6  COL 22
    bc_id AT ROW 7.2 COL 4
    bc_part AT ROW 8.4 COL 2.5
   bc_lot AT ROW 9.6 COL 1.6
    bc_ref AT ROW 10.8 COL 2.5
    bc_qty AT ROW 12 COL 4
    "EA" AT ROW 10.8  COL 22
  /* bc_pkqty AT ROW 10 COL 4*/
    bc_site AT ROW 13.2 COL 4

    bc_loc AT ROW 13.2 COL 20 NO-LABEL
  bc_site1 AT ROW 14.4 COL 4
   bc_loc1 AT ROW 14.4 COL 20 NO-LABEL
    bc_button AT ROW 17.5 COL 10
    WITH SIZE 30 BY 18.5 TITLE "销售发货"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.


ENABLE bc_cust WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 DISP bc_part 
   
    
   bc_lot 
    bc_qty 
   
    bc_site 

    bc_loc 
  
    WITH FRAME bc .
VIEW c-win.

 ON enter OF bc_cust
DO:
     bc_cust = bc_cust:SCREEN-VALUE.
     IF bc_cust <> '' THEN DO:
     
     {bcrun.i ""bcmgcheck.p"" "(input ""cust"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input  bc_cust , 
        input """",
         input """",
        output success)"}
        IF NOT success THEN 
        UNDO,RETRY.
        ELSE DO:
            DISABLE bc_cust WITH FRAME bc.
            ENABLE bc_so_nbr WITH FRAME bc.
        END.
     END.
     ELSE ENABLE bc_id WITH FRAME bc.
 END.


 ON enter OF bc_so_nbr
DO:
     bc_so_nbr = bc_so_nbr:SCREEN-VALUE.
     
     
     {bcrun.i ""bcmgcheck.p"" "(input ""so"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_so_nbr, 
        input """",
         input  """" , 
        input """",
         input """",
        output success)"}
        IF NOT success THEN 
        UNDO,RETRY.
        ELSE DO:
            DISABLE bc_so_nbr WITH FRAME bc.
            ENABLE bc_so_line  WITH FRAME bc.
        END.

 END.



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
         input  """" , 
        input """",
         input """",
        output success)"}
        IF NOT success THEN 
        UNDO,RETRY.
        ELSE DO:
             {bcrun.i ""bcmgordexp.p"" "(INPUT ""sod"" ,
            INPUT bc_po_nbr,
            INPUT bc_po_line,
            OUTPUT part,OUTPUT qty,
            OUTPUT """")"}
    bc_so_part = part.
             DISP bc_so_part WITH FRAME bc.
          DISABLE bc_so_line WITH FRAME bc.
          ENABLE bc_id WITH FRAME bc.
        END.

 END.

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
     
IF bc_cust <> '' THEN DO:
     {bcrun.i ""bcmgcheck.p"" "(input ""bd_match"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input bc_id, 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        output success)"}


END.


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
                  DISP bc_part bc_lot bc_ref bc_qty WITH FRAME bc.
                  END.
                  IF AVAILABLE b_ld_det THEN DO:
                  bc_site = b_ld_site.
                  bc_loc = b_ld_loc.
                      
                      
                     DISP bc_site bc_loc WITH FRAME bc. 
                    IF bc_cust <> '' THEN
                          ENABLE bc_site1 WITH FRAME bc.
                      ELSE DO:
                          FIND FIRST xshloc_mstr WHERE xshloc_cust = bc_cust AND xshloc_part = bc_part AND xshloc_order = bc_so_nbr AND xshloc_line = bc_so_line NO-LOCK NO-ERROR.
                          bc_site1 = xshloc_site.
                          bc_loc1 = xshloc_loc.
                              RUN bcshptr.
                      END.
                      END.
                      ELSE DO:
                          MESSAGE '该条码无库存！' VIEW-AS ALERT-BOX.
                          ENABLE bc_id WITH FRAME bc.
                          UNDO,RETRY.
                      END.
                  
     END.
                      END.
          

         
    END.

 ON enter OF bc_site1
DO:
      
     
     bc_site1 = bc_site1:SCREEN-VALUE.
         {bcrun.i ""bcmgcheck.p"" "(input ""bd_loc"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input bc_site1, 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        output success)"}
        IF NOT success THEN UNDO,RETRY.
        
        ELSE DO:
              FIND b_loc_mstr WHERE b_loc_code = bc_site1 NO-LOCK NO-ERROR.
              bc_site1 = b_loc_site.
              bc_loc1 = b_loc_loc.
           
       DISABLE bc_site1 WITH FRAME bc.
      DISP bc_site1 bc_loc1 WITH FRAME bc.
        
      
      
         IF bc_site = bc_site1 AND bc_loc1 = bc_loc THEN DO:
            MESSAGE '零转移，不允许！' VIEW-AS ALERT-BOX ERROR.
            ENABLE bc_id WITH FRAME bc.
            UNDO,RETRY.
        END.
            ELSE
           RUN bcshptr.
        
        END.
   
   
   END.

   /* ON enter OF bc_loc1
DO:
        bc_loc1 = bc_loc1:SCREEN-VALUE.
        IF bc_loc1 = bc_loc THEN DO:
            MESSAGE '零转移，不允许！' VIEW-AS ALERT-BOX ERROR.
            UNDO,RETRY.
        END.
            ELSE
            DO:
        
        {bcrun.i ""bcmgcheck.p"" "(input ""loc"" ,
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
         input """",
        output success)"}
        IF NOT success THEN UNDO,RETRY.
    ELSE DO:
       DISABLE bc_loc1 WITH FRAME bc.
       ENABLE bc_button WITH FRAME bc.
        
        
        
        END.
   
   END.
   END.*/
    ON 'choose':U OF bc_BUTTON
      DO:
        DISABLE bc_button WITH FRAME bc.
        RUN bcshpprt.



        
        END.
        ON WINDOW-CLOSE OF c-win /* <insert window title> */
   DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO c-win.
  RETURN NO-APPLY.

        END.

PROCEDURE bcshpprt:
    
    FOR EACH b_shp_wkfl NO-LOCK:
   IF substr(b_shp_shipper,1,1) = 's' THEN DO:
       
       {bcrun.i ""bcmgwrbf.p"" 
         "(INPUT b_shp_so,
         INPUT INTEGER(b_shp_line),
         INPUT """",
         INPUT b_shp_part,
         INPUT """",
         INPUT 0,
          INPUT """",
   INPUT b_shp_qty,
         INPUT """",
   INPUT TODAY,
   INPUT ?,
   INPUT ?,
   INPUT """",
   INPUT 0,
   INPUT b_shp_site,
   INPUT b_shp_loc,
   INPUT ""rcshmt.p"",
   INPUT b_shp_site1,
   INPUT b_shp_loc1,
   INPUT """",
   INPUT """",
   INPUT b_shp_shipper + string(today) + STRING(TIME),
   INPUT b_shp_cust,
   INPUT """",
   INPUT """",
   INPUT """",
   INPUT """",
   INPUT """",
   OUTPUT bid)"}





           {bcrun.i ""bcmgwrfl.p"" "(INPUT ""rcshmt"",input bid )"
              }
  FIND FIRST b_bf_det WHERE b_bf_id = bid NO-LOCK NO-ERROR.
       
       FIND FIRST ABS_mstr WHERE substring(abs__qad01,61,20) = b_bf_bc01 NO-LOCK NO-ERROR.
       IF AVAILABLE ABS_mstr THEN
       {gprun.i ""xgicshprt2.p"" "(input recid(abs_mstr))"}
          IF b_shp_abs_id <> '' THEN  DELETE b_shp_wkfl.
       END.
ELSE DO:  

FIND FIRST xgtr_det WHERE xgtr_shipper = b_shp_shipper NO-LOCK NO-ERROR.
IF NOT AVAILABLE xgtr_det THEN DO:
   CREATE xgtr_det.
   xgtr_shipper = b_shp_shipper.

    xgtr_part = b_shp_part.
    xgtr_site = b_shp_site.
    xgtr_f_loc = b_shp_loc.
    xgtr_t_loc = b_shp_loc1.
    xgtr_qty = b_shp_qty.
    
    END.
{gprun.i ""xgtrprt2.p"" "(input xgtr_shipper)"}
  
    FIND FIRST xgtr_det WHERE xgtr_shipper = b_shp_shipper EXCLUSIVE-LOCK NO-ERROR.
DELETE xgtr_det.
DELETE b_shp_wkfl.
       END.










    END.
    
    
    
    
    
    
    END.
PROCEDURE bcshptr:
    
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
     {bcrun.i ""bcmgcheck.p"" "(input ""si_au"" ,
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
         input """",
        output success)"}   
     IF NOT success THEN LEAVE.
 
IF NOT success THEN LEAVE.
    {bcrun.i ""bcmgcheck.p"" "(input ""ictr_typ"" ,
        input bc_site, 
        input bc_loc, 
        input bc_part, 
        input bc_lot,
         input bc_ref, 
        input ""iss-tr"" , 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        INPUT """",
       output success)"}      
IF NOT success THEN LEAVE.
    
     {bcrun.i ""bcmgcheck.p"" "(input ""ictr_typ"" ,
        input bc_site1, 
        input bc_loc1, 
        input bc_part, 
        input bc_lot,
         input bc_ref, 
        input ""rct-tr"" , 
        input """", 
        input """",
         input """", 
        input """",
         input """",
          INPUT """",
       output success)"}      
IF NOT success THEN LEAVE.
    
    
FIND FIRST b_ld_det WHERE b_ld_code = bc_id AND b_ld_site = bc_site AND b_ld_loc = bc_loc AND b_ld_part = bc_part AND b_ld_lot = bc_lot AND b_ld_ref = bc_ref  EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE b_ld_det THEN DO:
  CREATE blddet.
    BUFFER-COPY
        b_ld_det
        TO blddet.
   
    b_ld_det.b_ld_qty_oh = 0.
    /*RELEASE b_ld_det.*/
   FIND FIRST b_ld_det WHERE b_ld_det.b_ld_code = bc_id AND b_ld_det.b_ld_site = bc_site1 AND b_ld_det.b_ld_loc = bc_loc1 AND b_ld_det.b_ld_part = bc_part AND b_ld_det.b_ld_lot = bc_lot AND b_ld_det.b_ld_ref = bc_ref  EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE b_ld_det THEN DO:
   ASSIGN  b_ld_det.b_ld_qty_oh = blddet.b_ld_qty_oh.
END.
    ELSE DO:
   
    CREATE b_ld_det.
    BUFFER-COPY
        blddet
        EXCEPT blddet.b_ld_site blddet.b_ld_loc 
        TO b_ld_det
        ASSIGN
           b_ld_det.b_ld_site = bc_site1
          b_ld_det.b_ld_loc = bc_loc1.
    END.
    
   /* RELEASE b_ld_det.*/
    END.
    FIND FIRST b_co_mstr WHERE b_co_code = bc_id NO-LOCK NO-ERROR.
    FIND FIRST b_shp_wkfl WHERE b_shp_so = bc_so_nbr AND b_shp_line = bc_so_line AND b_shp_part = bc_so_part  AND b_shp_site = bc_site AND b_shp_loc = bc_loc AND b_shp_site1 = bc_site1 AND b_shp_loc1 = bc_loc1 EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE b_shp_wkfl THEN
        b_shp_qty = b_shp_qty + bc_qty.
    ELSE DO:
    FIND LAST b_shp_wkfl WHERE IF bc_cust <> '' THEN b_shp_cust <> ''  ELSE b_shp_cust = '' NO-LOCK NO-ERROR.
   id = IF bc_cust <> '' THEN  's' ELSE 't' + string(integer(SUBSTR(b_shp_shipper, 2, LENGTH(b_shp_shipper) - 1)) + 1,'9999999').
     CREATE b_shp_wkfl.
     b_shp_shipper = id.
    b_shp_so = bc_so_nbr.
    b_shp_line = bc_so_line.
    b_shp_part = bc_so_part.
    b_shp_qty = bc_qty.
    b_shp_site = bc_site.
    b_shp_loc = bc_loc.
    b_shp_site1 = bc_site1.
    b_shp_loc1 = bc_loc1.
    END.
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
           &b_typ='"iss-tr"'
          &mtime=TIME
           &b_loc=bc_loc
           &b_site=bc_site
           &b_usrid=g_user}
           mid1 = mcount.
          {bctrcr.i
         &ord=""""
         &mline=?
         &b_code=b_co_code
         &b_part=b_co_part
         &b_lot=b_co_lot
         &b_ser=b_co_ser
         &b_qty_ord=0
         &b_qty_loc=b_co_qty_cur
         &b_qty_chg=b_co_qty_cur
         &b_um=b_co_um
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"rct-tr"'
          &mtime=TIME
           &b_loc=bc_loc1
           &b_site=bc_site1
           &b_usrid=g_user}
           mid2 = mcount.
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
    INPUT b_co_qty_cur,
          INPUT b_co_um,
    INPUT TODAY,
    INPUT ?,
    INPUT ?,
    INPUT """",
    INPUT 0,
    INPUT bc_loc,
    INPUT bc_site,
    INPUT ""iclotr02.p"",
    INPUT bc_site1,
    INPUT bc_loc1,
    INPUT """",
    INPUT """",
    INPUT """",
    INPUT """",
    INPUT """",
    INPUT """",
    INPUT """",
    INPUT mid1,
    INPUT mid2,
    OUTPUT bid)"}
        
             
             
             
             
            {bcrun.i ""bcmgwrfl.p"" "(INPUT ""iclotr02"",input bid )"
               }
             
             
             
             
             
             
             
             
             
             END.
    MESSAGE '业务操作成功！' VIEW-AS ALERT-BOX INFORMATION.
    {bcrelease.i}
    ENABLE bc_id bc_button WITH FRAME bc.
    END.



    {bctrail.i}
