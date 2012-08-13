{mfdeclre.i}
{bcdeclre.i }
{bcwin03.i}
     {bctitle.i}
   
DEF VAR bc_id AS CHAR FORMAT "x(18)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/
DEF VAR bc_qty_std AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "标准数量".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEF VAR bc_split_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "拆分数量".

DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR oktocomt AS LOGICAL.
DEF VAR bc_split_id LIKE bc_id.
DEF VAR bc_site AS CHAR LABEL "地点".
DEF VAR bc_loc AS CHAR LABEL "库位".
DEF FRAME bc
    bc_id AT ROW 2 COL 4
    bc_site AT ROW 3.5 COL 4
   
   /* bc_part_desc  AT ROW 5 COL 1
    bc_part_desc1  NO-LABEL AT ROW 6 COL 8.5*/

   bc_loc AT ROW 5 COL 4
    
  
   
    bc_button AT ROW 7 COL 10
    WITH SIZE 30 BY 10 TITLE "条码修改"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_id  WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/

VIEW c-win.
ON enter OF bc_id
DO:
      bc_id = bc_id:SCREEN-VALUE.
    {bcrun.i ""bcmgcheck.p"" "(input ""bd_loc"",
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         INPUT """", 
        input bc_id, 
        input """",
         input """", 
        input """",
         input """",
         INPUT """",
        output success)"}
        IF NOT success THEN 
        UNDO,RETRY.
       ELSE DO:
            FIND FIRST b_loc_mstr WHERE b_loc_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
             IF AVAILABLE b_loc_mstr THEN DO:
          
                bc_site = b_loc_site.
                bc_loc = b_loc_loc.
             END.
           DISABLE bc_id WITH FRAME bc.
           ENABLE bc_site WITH FRAME bc.
       END.
END.
ON enter OF bc_site
DO:
    bc_site = bc_site:SCREEN-VALUE.
    {bcrun.i ""bcmgcheck.p"" "(input ""site"",
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
        ELSE DO: DISABLE bc_site WITH FRAME bc.
        ENABLE bc_loc WITH FRAME bc.
        END.
END.



ON enter OF bc_loc
DO:
    bc_loc = bc_loc:SCREEN-VALUE.
   {bcrun.i ""bcmgcheck.p"" "(input ""loc"",
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
        ELSE DO: 
            DISABLE bc_loc WITH FRAME bc.
        ENABLE bc_button WITH FRAME bc.
        END.
END.





ON 'choose':u OF bc_button
DO:
    DISABLE bc_button WITH FRAME bc.
    RUN main.
END.

ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

PROCEDURE main:
      
               FIND FIRST b_loc_mstr WHERE b_loc_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
                  
               ASSIGN 
                  b_loc_site = bc_site
                   b_loc_loc = bc_loc.
               
               {bcusrhist.i }
                    MESSAGE '条码已生成！' VIEW-AS ALERT-BOX INFORMATION.
MESSAGE "是否打印？" SKIP(1)
        "继续?"
        VIEW-AS ALERT-BOX
        QUESTION
        BUTTON YES-NO
        UPDATE oktocomt.
 IF oktocomt THEN DO:
 
     FIND FIRST b_usr_mstr WHERE b_usr_usrid = g_user NO-LOCK NO-ERROR.
     IF b_usr_prt_typ <> 'ipl' AND b_usr_prt_typ <> 'zpl' THEN DO:
     MESSAGE '本系统暂不支持除了ipl,zpl类型的条码打印机!' VIEW-AS ALERT-BOX ERROR.

         LEAVE.
         END.
  OUTPUT TO VALUE(b_usr_printer).
  {bclabel.i "b_usr_prt_typ" ""loc"" "b_loc_code" "b_loc_site" 
       "b_loc_loc" """" """" }

     
     
     
     
     MESSAGE '打印完毕！' VIEW-AS ALERT-BOX INFORMATION.
     
     
     
     
     END.
      {bcrelease.i}             
     ENABLE bc_id  WITH FRAME bc.    
               END.

{bctrail.i}
