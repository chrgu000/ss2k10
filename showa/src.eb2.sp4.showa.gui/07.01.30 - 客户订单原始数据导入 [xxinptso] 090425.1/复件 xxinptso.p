{mfdtitle.i "C+ "}
define variable vchr_file-name  as character format "x(30)":U   INIT "d:\管理部\仓库\"  .

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
          CREATE xxsod_det .
          IMPORT DELIMITER "~011" xxsod_det .

          ASSIGN
              xxsod_due_date1 = xxsod_due_date
              xxsod_due_time1 = xxsod_due_time
              xxsod__chr02 = string(xxsod_qty_ord)
              .
          ASSIGN
              xxsod_desc = TRIM(xxsod_desc)
              xxsod__chr01 = "NO"
              .
     end.

     input close.
     
     FOR EACH xxsod_det WHERE xxsod_cust = '' :
        DELETE xxsod_det .
     END.

     put "导入完成" .
     
     {mfreset.i} 
   {mfgrptrm.i}
end.
