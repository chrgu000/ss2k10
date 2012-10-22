{bcdeclre.i }
    {bcwin02.i}
     {bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "����".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "�����".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "�������".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".*/
DEF VAR bc_site AS CHAR FORMAT "x(18)" LABEL "��ص�".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "���λ".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "��/���".
DEF VAR bc_site1 AS CHAR FORMAT "x(8)" LABEL "�ص�".
DEF VAR bc_so_job AS CHAR FORMAT "x(8)" LABEL "Ԥ���".
DEFINE BUTTON bc_button LABEL "ȷ��" SIZE 8 BY 1.50.
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "�ο���".
DEF VAR bc_cr AS CHAR FORMAT "x(8)" LABEL "������".
DEF VAR msite AS CHAR.
DEF FRAME bc
    bc_id AT ROW 1.5 COL 4
    bc_part AT ROW 2.7 COL 2.5
   
    
   bc_lot AT ROW 3.9 COL 1.6
    /*bc_ref AT ROW 5.1 COL 2.5*/
    bc_qty AT ROW 5.1 COL 4
  /* bc_pkqty AT ROW 10 COL 4*/
    bc_site AT ROW 6.3 COL 2.5

    bc_loc AT ROW 7.5 COL 2.5
  bc_so_job AT ROW 8.7 COL 2.5
bc_cr AT ROW 9.9 COL 2.5
   /*bc_cr AT ROW 10.8 COL 4*/
 
    WITH SIZE 30 BY 12 TITLE "�ƻ������"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.


ENABLE bc_id WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 DISP bc_part 
   
   
   bc_lot 
    bc_qty 
   
    bc_site 

    bc_loc 
  
    WITH FRAME bc .
VIEW c-win.
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
         
        {bccntlock.i "bc_site" "bc_loc"}
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
           
           IF NOT success  THEN do:
              ASSIGN bc_site = ''
                     bc_loc = ''.
               DISP bc_site bc_loc WITH FRAME bc.
               UNDO,RETRY.
           END.
           ELSE DO:
         
       DISABLE bc_site WITH FRAME bc.
      DISP bc_site bc_loc WITH FRAME bc.
     
     ENABLE bc_so_job WITH FRAME bc.
        
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
ON enter OF bc_so_job
DO:
   bc_so_job = bc_so_job:SCREEN-VALUE.
   FIND FIRST CODE_mstr WHERE CODE_fldname = 'so_job' AND CODE_value = bc_so_job NO-LOCK NO-ERROR.
   IF NOT AVAILABLE code_mstr THEN DO:
    MESSAGE '��ЧԤ���!' VIEW-AS ALERT-BOX.
    ASSIGN
        bc_so_job = ''.
    DISP bc_so_job WITH FRAME bc.
    UNDO,RETRY.
   END.
   ELSE DO:
 
   DISABLE bc_so_job WITH FRAME bc.
  ENABLE bc_cr WITH FRAME bc.
   END.
END.
ON enter OF bc_cr
DO:
   bc_cr = bc_cr:SCREEN-VALUE.
   FIND FIRST CODE_mstr WHERE CODE_fldname = 'ordernbr' AND CODE_value = bc_so_job NO-LOCK NO-ERROR.
   IF NOT AVAILABLE code_mstr THEN DO:
    MESSAGE '��Ч������!' VIEW-AS ALERT-BOX.
    ASSIGN
        bc_cr = ''.
    DISP bc_cr WITH FRAME bc.
    UNDO,RETRY.
   END.
   ELSE DO:
 
   DISABLE bc_cr WITH FRAME bc.
  RUN main.
   END.
END.
/*ON enter OF bc_cr
DO:
   bc_cr = bc_cr:SCREEN-VALUE.
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
         input  bc_cr , 
        input """",
         input """",
        output success)"}
        IF NOT success THEN 
        UNDO,RETRY.
        ELSE DO:
       
   DISABLE bc_cr WITH FRAME bc.
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
        input ""rct-unp"" , 
        input """", 
        input """",
         input """", 
        input """",
         input """",
    INPUT """",
        output success)"}      
IF NOT success THEN LEAVE.
FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
OUTPUT TO VALUE(g_sess). 
put  "@@BATCHLOAD icunrc.P" skip.
            PUT UNFORMAT '"' b_co_part '"' SKIP .
            PUT UNFORMAT STRING(b_co_qty_cur) " - - " '"' + bc_site + '" "' + bc_loc + '"' ' "     "'  SKIP.
            PUT "- - - - - " TODAY SKIP.
            PUT      " " skip
                     "." SKIP
                     "@@END" SKIP.
        
          OUTPUT CLOSE.
             {bcrun.i ""bcmgbdpro.p"" "(INPUT g_sess,INPUT ""out.txt"")"}
                 OS-DELETE VALUE(g_sess).
                 FIND LAST tr_hist USE-INDEX tr_date_trn WHERE tr_date = TODAY AND tr_type = 'rct-unp' AND tr_program = 'icunrc.p' AND tr_site = bc_site AND tr_loc = bc_loc AND /*AND tr_nbr = bc_po_nbr AND string(tr_line) = bc_po_line*/ tr_part = b_co_part AND tr_serial = ''  AND tr_qty_loc = b_co_qty_cur  AND tr_userid = g_user /*AND tr_time >= TIME - 20 AND tr_time <= TIME*/  NO-LOCK NO-ERROR.

             IF  AVAILABLE tr_hist THEN do:
             FIND FIRST b_tr_hist USE-INDEX b_tr_qadid WHERE b_tr_trnbr_qad = tr_trnbr NO-LOCK NO-ERROR.
             IF  AVAILABLE b_tr_hist THEN do:
                 success = NO.
                MESSAGE  '����QADʧ��!'  VIEW-AS ALERT-BOX.
                LEAVE.
             END.
              END.
               ELSE DO:
             success = NO.
             MESSAGE  '����QADʧ��!'  VIEW-AS ALERT-BOX.
             LEAVE.
               END.




ASSIGN b_co_status = 'rct'
       b_co_site = bc_site
        b_co_loc = bc_loc.
 
          

     {bctrcr.i
         &ord=bc_so_job
         &mline=?
         &b_code=?
         &b_part=b_co_part
         &b_lot=b_co_lot
         &id=bc_cr
         &b_qty_req=0
         &b_qty_loc=b_co_qty_cur
         &b_qty_chg=b_co_qty_cur
         &b_qty_short=0
         &b_um=b_co_um
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"rct-unp"'
          &mtime=TIME
           &b_loc=bc_loc
           &b_site=bc_site
           &b_usrid=g_user
           &b_addr=?}
          b_tr_trnbr_qad = IF AVAILABLE tr_hist THEN tr_trnbr ELSE 0.
   /* MESSAGE 'ҵ������ɹ���' VIEW-AS ALERT-BOX INFORMATION.*/
    {bcrelease.i}
        ASSIGN
      bc_lot = ''
         bc_qty = 0
     bc_part = ''
     bc_id = ''
     bc_site = ''
     bc_loc = ''
         bc_so_job = ''
         bc_cr = ''.
     DISP bc_id bc_site bc_loc bc_lot bc_qty bc_part bc_so_job bc_cr WITH FRAME bc.
     ENABLE bc_id WITH FRAME bc.
         ENABLE bc_id WITH FRAME bc.
     APPLY 'entry':u TO bc_id.
END.

{bctrail.i}