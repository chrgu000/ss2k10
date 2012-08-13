/******************comments****************************************
input file layout:
    1. 雇员
     2. 生效日期
     3. 班次
     4. 地点
     5. SO号
     6. 最后道工序
     7. 生产线
     8. 工艺流程
     9. BOM Code
   10. 工作中心
    11. 设备
    12. 部门
    13. 完成数量
    14. 子零件
    15. 子零件工序
    16. 发放数量
    17. 库位
    18. 批/序号
    19. 参考号
    20. So号
    21. 库位
    22. 序列号
    23. 参考号 
******************end comments************************************/

{mfdtitle.i}

def var x_data as char extent 26 format "x(20)".
def workfile xxwk
       field emp like emp_addr
       field effdate like tr_effdate
       field shift as char format "x(2)"
       field site like si_site
       field par like ps_par
       field lastop like ro_op
       field line like ln_line
       field routing like ptp_routing
       field bom_code like ptp_bom_code
       field wkctr like wc_wkctr
       field mch like wc_mch
       field dept like dpt_dept
       field qty_comp like tr_qty_loc
       field comp like ps_comp
       field compop like ro_op
       field qty_iss like tr_qty_loc
       field comploc like ld_loc
       field complot like ld_lot
       field compref like ld_ref
       field par2 like ps_par
       field parloc like ld_loc
       field parlot like ld_lot
       field parref like ld_ref.
          
def stream src.
def stream bkflh.
def var bkflh_file as char.
def var i as inte.
def var j as inte.

bkflh_file = "c:\bkflh_file.in".

for each xxwk:
     delete xxwk.
end.

input stream src from value("c:\bkfltest.txt").

repeat: /*repeat #1*/
   i = i + 1.
   import stream src delimiter "," x_data.
   
   if i > 1 then do:
         create xxwk.
         assign xxwk.emp = x_data[1]
                xxwk.effdate = date(x_data[2])
                xxwk.shift = x_data[3]
                xxwk.site = x_data[4]
                xxwk.par = x_data[5]
                xxwk.lastop = inte(x_data[6])
                xxwk.line = x_data[7]
                xxwk.routing = x_data[8]
                xxwk.bom_code = x_data[9]
                xxwk.wkctr = x_data[10]
                xxwk.mch = x_data[11]
                xxwk.dept = x_data[12]
                xxwk.qty_comp = deci(x_data[13])
                xxwk.comp = x_data[14]
                xxwk.compop = inte(x_data[15])
                xxwk.qty_iss = deci(x_data[16])
                xxwk.comploc = x_data[17]
                xxwk.complot = x_data[18]
                xxwk.compref = x_data[19]
                xxwk.par2 = x_data[20]
                xxwk.parloc = x_data[21]
                xxwk.parlot = x_data[22]
                xxwk.parref = x_data[23].
                
   end.
   
end. /*repeat #1*/

find first xxwk no-lock no-error.
if not available xxwk then do:
   message "No data need to process!".
   leave.
end.

output stream bkflh to value(bkflh_file).

/*create the header format*/
put stream bkflh "~"" at 1 xxwk.emp "~"".
put stream bkflh xxwk.effdate at 1 " ~"" xxwk.shift "~"" " ~"" xxwk.site "~"".
put stream bkflh "~"" at 1 xxwk.par "~" " xxwk.lastop " ~"" xxwk.line "~"".
put stream bkflh "~"" at 1 xxwk.routing "~"" " ~"" xxwk.bom_code "~"".
put stream bkflh "~"" at 1 xxwk.wkctr "~"" " ~"" xxwk.mch "~"".
put stream bkflh "~"" at 1 xxwk.dept "~" " xxwk.qty_comp " - - - - - - - - - Y Y".
put stream bkflh "" at 1.

/*create the detail components issue format*/
put stream bkflh "-" at 1.    
for each xxwk where xxwk.comp <> "" no-lock:
     put stream bkflh "~"" at 1 xxwk.comp "~" " xxwk.compop.
     put stream bkflh xxwk.qty_iss at 1 " N " "~"" xxwk.site "~"" " ~"" xxwk.comploc "~"" 
                      " ~"" xxwk.complot "~"" " ~"" xxwk.compref "~"".   
end.
put stream bkflh "." at 1.
put stream bkflh "Y" at 1.
put stream bkflh "Y" at 1.

/*create the final goods receipts format*/
put stream bkflh 0 at 1 " - - - - - - " "Yes No".
for each xxwk where xxwk.par2 <> "" no-lock:
    put stream bkflh "~"" at 1 xxwk.site "~"" " ~"" xxwk.parloc "~""
                     " ~"" xxwk.parlot "~"" " ~"" xxwk.parref "~"".
    put stream bkflh 1 at 1.                 
end.
put stream bkflh "." at 1.
put stream bkflh "Y" at 1.
put stream bkflh "Y" at 1.
put stream bkflh "Y" at 1.
put stream bkflh "." at 1.
                 
output stream bkflh close.


    
    batchrun = yes.
    input from value(bkflh_file).
    output to value(bkflh_file + ".out") keep-messages.
       
    hide message no-pause.
       
    {gprun.i ""rebkfl.p""}
       
    hide message no-pause.
      
    output close.
    input close.
    batchrun = no.

