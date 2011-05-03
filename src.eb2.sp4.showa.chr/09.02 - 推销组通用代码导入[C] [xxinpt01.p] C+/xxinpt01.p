/* xxinpt01.p - 推销组通用代码导入                      */
/* Revision: eb2sp4	BY: Micho Yang         DATE: 08/05/08  ECO: *SS - 20080805.1* */

/* SS - 20080805.1 - B */
/* 
1. 主要用于导入销售部门定义的推销组代码
2. 每次重新导入时，先删除系统已经存在的记录。
   然后再导入到code_mstr 
   code_fldname = "xxdtbrp1.p"
   code_value = 第1列数据                                                                          
   code_cmmt = 第2列数据
   */
/* SS - 20080805.1 - E */

{mfdtitle.i "C+ "}

define variable file_name  as character format "x(40)" .
DEFINE VARIABLE UPDATE_yn AS LOGICAL INIT NO .

DEF TEMP-TABLE tt
   FIELD tt_cust LIKE CODE_user1 
   FIELD tt_value LIKE CODE_value 
   FIELD tt_cmmt LIKE CODE_cmmt
   
   .

form 
   skip(1)
   file_name colon 30 label "导入文件的路径及名称"
   SKIP(2)
   UPDATE_yn COLON 30 LABEL "是否确认导入数据"
   skip(1)
with frame a side-label width 80 .

setFrameLabels(frame a:handle).
     
main:
repeat :

   update file_name UPDATE_yn with frame a.
   
   if search(file_name) = ? then do:
      message "文件不存在" .
      next.
   end.   
   
   {mfselprt.i "printer" 120}
   
   input from value(file_name).
   
   REPEAT:
      CREATE tt .
      IMPORT DELIMITER "~011" tt .
   end.
   input close.
   
   IF UPDATE_yn = NO THEN DO:
      FOR EACH tt WITH FRAME b:
         DISP 
            tt_cust COLUMN-LABEL "厂别"
            tt_value COLUMN-LABEL "推销组"
            tt_cmmt COLUMN-LABEL "说明"
            .
      END.
   END.
   ELSE DO:
      FOR EACH tt :
         FIND FIRST CODE_mstr WHERE CODE_fldname = "pt_promo"
            AND CODE_value = tt_value NO-LOCK NO-ERROR.
         IF NOT AVAIL CODE_mstr THEN DO:
            CREATE CODE_mstr.
            ASSIGN
               CODE_fldname = 'pt_promo'
               CODE_value = tt_value 
               CODE_cmmt = tt_cmmt
               CODE_user1 = tt_cust
               .
         END.
      END.

      PUT UNFORMATTED "数据已成功导入" .
   END.
      
   {mfreset.i} 
   {mfgrptrm.i}
end.
