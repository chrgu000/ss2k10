/* SS - 20090425.1 By: Micho Yang */

/* SS - 20090425.1 - B */
/*
累加规则：类型 +　客户　+ 项目 +　周次　＋ 备注 +　零件　＋ 日期 +　时段
*/
/* SS - 20090425.1 - E */

{mfdtitle.i "090425.1"}
define variable vchr_file-name  as character format "x(30)" .

DEF TEMP-TABLE xx
   FIELD xx_type     LIKE xxsod_type
   FIELD xx_cust     LIKE xxsod_cust
   FIELD xx_project  LIKE xxsod_project
   FIELD xx_item     LIKE xxsod_item
   FIELD xx_vend     LIKE xxsod_vend
   FIELD xx_addr     LIKE xxsod_addr
   FIELD xx_part     LIKE xxsod_part
   FIELD xx_color    LIKE xxsod_color
   FIELD xx_desc     LIKE xxsod_desc
   FIELD xx_plan     LIKE xxsod_plan
   FIELD xx_due_date LIKE xxsod_due_date
   FIELD xx_due_time LIKE xxsod_due_time
   FIELD xx_qty_ord  LIKE xxsod_qty_ord
   FIELD xx_invnbr   LIKE xxsod_invnbr
   FIELD xx_rev      LIKE xxsod_rev
   FIELD xx_week     LIKE xxsod_week
   FIELD xx_category LIKE xxsod_category
   FIELD xx_ship     LIKE xxsod_ship
   FIELD xx_rmks     LIKE xxsod_rmks
   FIELD xx_rmks1    LIKE xxsod_rmks1
   .

form 
   skip(1)
   vchr_file-name colon 30 label "导入文件"
   skip(1)
with frame a side-label width 80 .
setFrameLabels(frame a:handle).
     
main:
repeat :

  update vchr_file-name with frame a.
  
  if search(vchr_file-name) = ? then 
  do:
     message "文件不存在" .
     next.
  end.   
  
  {mfselprt.i "printer" 120}
  
     input from value(vchr_file-name).
     REPEAT:
          CREATE xx .
          IMPORT DELIMITER "~011" xx .
     end.
     input close.

     FOR EACH xx WHERE xx_cust = "" :
        DELETE xx.
     END.

     /* 累加规则：类型 +　客户　+ 项目 +　周次　＋ 备注 +　零件　＋ 日期 +　时段 */
     FOR EACH xx BREAK BY xx_type BY xx_cust
        BY xx_project BY xx_week BY xx_rmks
        BY xx_part BY xx_due_date BY xx_due_time :
        ACCUMULATE xx_qty_ord ( TOTAL BY xx_type BY xx_cust BY xx_project BY xx_week BY xx_rmks BY xx_part BY xx_due_date BY xx_due_time).

        IF LAST-OF(xx_due_time) THEN DO:
           CREATE xxsod_det.
           ASSIGN
               xxsod_type     = xx_type    
               xxsod_cust     = xx_cust    
               xxsod_project  = xx_project 
               xxsod_item     = xx_item    
               xxsod_vend     = xx_vend    
               xxsod_addr     = xx_addr    
               xxsod_part     = xx_part    
               xxsod_color    = xx_color   
               xxsod_desc     = xx_desc    
               xxsod_plan     = xx_plan    
               xxsod_due_date = xx_due_date
               xxsod_due_time = xx_due_time
               xxsod_qty_ord  = (ACCUMU TOTAL BY xx_due_time xx_qty_ord)
               xxsod_invnbr   = xx_invnbr  
               xxsod_rev      = xx_rev     
               xxsod_week     = xx_week    
               xxsod_category = xx_category
               xxsod_ship     = xx_ship    
               xxsod_rmks     = xx_rmks    
               xxsod_rmks1    = xx_rmks1 
               .

            IF LENGTH(xxsod_due_date) <> 10 THEN 
            ASSIGN 
                xxsod_due_date = string(year(date(int(entry(2,xxsod_due_date,"-")), int(entry(3,xxsod_due_date,"-")), int(entry(1,xxsod_due_date,"-")))),"9999") + "-" + STRING(MONTH(date(int(entry(2,xxsod_due_date,"-")), int(entry(3,xxsod_due_date,"-")), int(entry(1,xxsod_due_date,"-")))),"99") + "-" + STRING(DAY(date(int(entry(2,xxsod_due_date,"-")), int(entry(3,xxsod_due_date,"-")), int(entry(1,xxsod_due_date,"-")))),"99").

            ASSIGN
                xxsod_due_date1 = xxsod_due_date
                xxsod_due_time1 = xxsod_due_time
                xxsod__chr02 = string(xxsod_qty_ord)
                .

            ASSIGN
                xxsod_desc = TRIM(xxsod_desc)
                xxsod__chr01 = "NO"
                .
        END. /* IF LAST-OF(xx_due_time) THEN DO: */
     END.
     
     put "导入完成" .
     
     {mfreset.i} 
   {mfgrptrm.i}
end.
