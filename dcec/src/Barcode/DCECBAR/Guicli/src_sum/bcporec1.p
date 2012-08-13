{mfdeclre.i }
{bcdeclre.i }
   
    {bcwin01.i }
{bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(20)"  LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_po_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_po_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".

DEF VAR bc_po_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "需求量".
DEF VAR bc_site AS CHAR FORMAT "x(18)" LABEL "地点".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "库位".
DEF VAR bc_po_nbr AS CHAR FORMAT "x(8)"    LABEL "采购单".
DEF VAR bc_po_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_po_line AS CHAR FORMAT "x(8)"  LABEL "行号".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR bc_sub AS LOGICAL LABEL "转包".
DEF VAR bc_woid AS CHAR FORMAT "x(8)" LABEL "标志".
DEF VAR bc_wo AS CHAR FORMAT "x(8)" LABEL "工单".
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".
DEF VAR msite AS CHAR.
DEF FRAME bc
    bc_po_nbr AT ROW 1.2 COL 2.5
    bc_po_line AT ROW 2.4 COL 4
 /* bc_po_part AT ROW 3.6 COL 2.5*/
    bc_po_qty AT ROW 3.6 COL 2.5 
    'EA' AT ROW 3.6 COL 22 
    /*bc_po_part_desc  AT ROW 6 COL 1
    bc_po_part_desc1  NO-LABEL AT ROW 7 COL 8.5*/
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
  
   
    WITH SIZE 30 BY 14 TITLE "PO收货"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_po_nbr 
   /* bc_po_line
  
    bc_id  bc_button */ 
     WITH FRAME bc IN WINDOW c-win.
/*
bc_sub = NO.
DISP bc_sub WITH FRAME bc.*/
/*DISABLE bc_po_part_desc  bc_po_part_desc1 WITH FRAME bc_pick .*/
 /*DISP bc_part 
   bc_po_qty
  /*  bc_po_part_desc  
    bc_po_part_desc1  */
   bc_lot 
    bc_qty 
   
    bc_site 

    bc_loc 
  
    WITH FRAME bc .*/
/*VIEW c-win.*/


ON CURSOR-DOWN OF bc_po_nbr
DO:
    
       ASSIGN bc_po_nbr.
       FIND FIRST po_mstr NO-LOCK WHERE po_nbr > bc_po_nbr NO-ERROR.
       IF AVAILABLE po_mstr THEN DO:
           ASSIGN bc_po_nbr = po_nbr.
           DISPLAY bc_po_nbr WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_po_nbr
DO:
   
       ASSIGN bc_po_nbr.
       FIND LAST po_mstr NO-LOCK WHERE po_nbr < bc_po_nbr NO-ERROR.
       IF AVAILABLE po_mstr THEN DO:
           ASSIGN bc_po_nbr = po_nbr.
           DISPLAY bc_po_nbr WITH FRAME bc.
       END.
   
END.
ON enter OF bc_po_nbr
DO:
    bc_po_nbr = bc_po_nbr:SCREEN-VALUE.
    {bcrun.i ""bcmgcheck.p"" "(input ""po"",
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_po_nbr, 
        input """",
         input """", 
        input """",
         input """",
        output success)"}
    IF  NOT success THEN do:
      /* ASSIGN
          bc_po_nbr = ''.
       DISP bc_po_nbr WITH FRAME bc.*/
       UNDO,RETRY.

    END.
   ELSE DO: 
       DISABLE bc_po_nbr WITH FRAME bc.
       ENABLE bc_id WITH FRAME bc.
 
   END.
  
    END.

/*
   ON enter OF bc_po_line
DO:
        bc_po_line = bc_po_line:SCREEN-VALUE.
        
         {bcrun.i ""bcmgcheck.p"" "(input ""pod"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_po_nbr, 
        input bc_po_line,
         input """", 
        input """",
         input """",
        output success)"}
        IF  NOT success THEN do:
        UNDO,RETRY.
    END.
    ELSE do:
        {bcrun.i ""bcmgordexp.p"" "(INPUT ""pod"" ,
            INPUT bc_po_nbr,
            INPUT bc_po_line,
            OUTPUT part,OUTPUT qty,
            OUTPUT lntyp)"}

        bc_po_part = part.
    bc_po_qty = qty.
  
    DISP /*bc_po_part bc_po_qty*/ WITH FRAME bc.
     DISABLE bc_po_line WITH FRAME bc. 
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
         FIND FIRST b_co_mstr WHERE b_co_code = bc_id  AND b_co_ref = '' EXCLUSIVE-LOCK NO-ERROR.
           IF AVAILABLE b_co_mstr THEN DO:
          
               {bcrun.i ""bcmgcheck.p"" "(input ""po_rct"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input bc_id, 
        input bc_po_nbr, 
        input """",
         input """", 
        input """",
         input """",
        output success)"}

          IF NOT success THEN DO:
          ASSIGN
              bc_id = ''.
          DISP bc_id WITH FRAME bc.
          
        UNDO,RETRY.
          END.
      ELSE DO: 
           bc_po_line = lntyp.
           DISP bc_po_line WITH FRAME bc.
          
           {bcpodlock.i}   
           DISABLE bc_id WITH FRAME bc.
              
              IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                bc_po_qty = qty.
                  bc_qty = b_co_qty_cur.
                  FIND FIRST IN_MSTR WHERE IN_part = b_co_part NO-LOCK NO-ERROR.
                 IF AVAILABLE IN_mstr THEN 
                                          assign
                                             bc_site = IN_site
                                             bc_loc = IN_user1.
                  DISP bc_po_nbr bc_part bc_lot /*bc_pack*/ bc_site bc_loc bc_po_qty bc_qty WITH FRAME bc.
                
                    
                 /*IF bc_site <> '' AND bc_loc <> '' THEN RUN main.
                            ELSE do:*/
                                ENABLE bc_site WITH FRAME bc.
                                APPLY 'entry':u TO bc_site.
                            /*END.*/
      
               END.
        END.
          
           END.
             ELSE do:
                 MESSAGE bc_id ' 为进口件条码,清按货运单入库!' VIEW-AS ALERT-BOX.
                 ASSIGN bc_id = ''.
                 DISP bc_id WITH FRAME bc.
                 UNDO,RETRY.
             END.
         
    END.

     ON enter OF bc_site
DO:  
         IF bc_site = '' OR bc_loc = '' THEN DO:
        
         bc_site = bc_site:SCREEN-VALUE.
         APPLY 'entry':u TO bc_site.
         msite = bc_site.
         bc_site = SUBSTR(msite,1,INDEX(msite,'.') - 1).
         bc_loc = SUBSTR(msite,INDEX(msite,'.') + 1).
         
         END.
             
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
           
           IF NOT success  THEN 
               
               do:
               ASSIGN bc_site = ''
                     bc_loc = ''.
               DISP bc_site bc_loc WITH FRAME bc.
               
               UNDO,RETRY.
           END.

          
           ELSE DO:
         
       DISABLE bc_site WITH FRAME bc.
      DISP bc_site bc_loc WITH FRAME bc.
     
      RUN main.
        
          END.     
       
   
  
     END.

 


PROCEDURE main:
        
        { bcrun.i ""bcmgcheck.p"" "(input ""period"" ,
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
        input ""rct-po"" , 
        input """", 
        input """",
         input """", 
        input """",
         input """",
    INPUT """",
        output success)"}      
IF NOT success THEN LEAVE.
         FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.  
         
        FIND FIRST po_mstr WHERE po_nbr = bc_po_nbr NO-LOCK NO-ERROR.
        FIND FIRST pod_det WHERE pod_nbr = po_nbr NO-LOCK NO-ERROR.
        FIND FIRST pt_mstr WHERE pt_part = b_co_part NO-LOCK NO-ERROR.

          FIND FIRST b_po_wkfl WHERE b_po_due_date  =  (IF issch THEN TODAY ELSE pod_due_date) AND b_po_nbr = bc_po_nbr AND b_po_line = bc_po_line  AND b_po_part = b_co_part   EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE b_po_wkfl THEN
                  ASSIGN
                      b_po_qty_rec = b_po_qty_rec + b_co_qty_cur.
          FIND FIRST b_po_rec WHERE b_po_recdate = (IF issch THEN TODAY ELSE pod_due_date) AND b_po_ponbr = bc_po_nbr AND b_po_poln = bc_po_line AND b_po_popart = bc_part EXCLUSIVE-LOCK NO-ERROR.
                   IF AVAILABLE b_po_rec THEN
                        ASSIGN
                           b_po_recqty = b_po_recqty + b_co_qty_cur.
                     ELSE DO:
                         CREATE b_po_rec.
                         ASSIGN
                             b_po_recdate = IF issch THEN TODAY ELSE pod_due_date
                             b_po_ponbr = bc_po_nbr
                              b_po_poln = bc_po_line
                              b_po_popart = bc_part
                              b_po_recqty = b_co_qty_cur.
                     END.
            /* ELSE DO:
                 CREATE b_po_wkfl.
                 ASSIGN 
                     b_po_nbr = bc_po_nbr
                     b_po_line = bc_po_line
                     b_po_part = b_co_part
                     b_po_qty_req = bc_po_qty
                     b_po_qty_rec = b_co_qty_cur
                     b_pod_due_date = IF issch THEN TODAY ELSE pod_due_date
                         b_po_staff = IF AVAILABLE in_mstr THEN IN__qadc01 ELSE ''
                  b_po_prod = IF AVAILABLE pt_mstr THEN pt_prod_line ELSE '' 
                  b_po_vend = po_vend.
     
             END.*/

             assign
             b_co_status = 'rct'
             b_co_site = bc_site
             b_co_loc = bc_loc
            /* b_co_vend =  po_vend */
            b_co_ord = po_nbr
            b_co_line = bc_po_line
            b_co_due_date = IF issch THEN TODAY ELSE pod_due_date
                b_co_qty_req = bc_po_qty.
           
         {bctrcr.i
         &ord=bc_po_nbr
         &mline=bc_po_line
         &b_code=?
         &b_part=b_co_part
         &b_lot=b_co_lot
         &id=?
         &b_qty_req=b_co_qty_req
         &b_qty_loc=b_co_qty_cur
         &b_qty_chg=b_co_qty_cur
         &b_qty_short="if available b_po_rec then b_co_qty_req - b_po_recqty else 0"
         &b_um=b_co_um
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"rct-po"'
          &mtime=TIME
           &b_loc=bc_loc
           &b_site=bc_site
           &b_usrid=g_user
           &b_addr=b_co_vend}
           

            
            
           


             


           
           
             
             
             
             
             
             
             
           /* MESSAGE '业务操作成功！' VIEW-AS ALERT-BOX INFORMATION. */
             RELEASE b_po_wkfl.
             {bcrelease.i}
                 {bcpodrelease.i}
    ASSIGN
      bc_lot = ''
         bc_qty = 0
     bc_part = ''
     bc_id = ''
     bc_site = ''
     bc_loc = ''.
     DISP bc_id bc_site bc_loc bc_lot bc_qty bc_part WITH FRAME bc.
     ENABLE bc_id WITH FRAME bc.
    APPLY 'entry':u TO bc_id.
     
END.



    {BCTRAIL.I}
