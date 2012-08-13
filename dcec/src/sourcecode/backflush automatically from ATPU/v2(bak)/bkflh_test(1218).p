/******************comments****************************************
input file layout:
        Field             Format
     1. 雇员                 x(18)
     2. 生效日期            YYYY/MM/DD
     3. 班次                 x(2)
     4. 地点                 x(8)
     5. SO号                 x(18)
     6. 最后道工序          >>>>9
     7. 生产线              x(8)
     8. 工艺流程          x(18)
     9. BOM Code            x(18)
   10. 工作中心           x(8)
    11. 设备              x(8)
    12. 部门                x(8)
    13. 完成数量          >>>>>>>>9
    14. 子零件               x(18)
    15. 子零件工序         >>>>9
    16. 发放数量          >>>>>>>>9
    17. 库位                x(8)
    18. 批/序号            x(16)
    19. 参考号            x(8)
    20. So号                x(18)
    21. 库位                x(8)
    22. 序列号              x(16)
    23. 参考号              x(8)
******************end comments************************************/

{mfdtitle.i}

def var srcdir as char format "x(20)".           /*source file directory*/
def var okdir as char format "x(20)".            /*verified file directory*/
def var listfile as char.
def var logfile as char.
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

def var filename as char.
def workfile list
    field filename as char format "x(40)".

def stream bkfile.         
def stream src.
def stream bkflh.
def var bkflh_file as char.
def var i as inte.
def var j as inte.
def var routing like ro_routing.
def var bom_code like bom_parent.

bkflh_file = "c:\bkflh_file.in".
srcdir = "c:\b1".
okdir = "c:\b_ok".
listfile = "c:\list.txt".
logfile = "c:\bkflh.log".

/*******To get the backflush source file list***********/
Dos silent value("dir /b " + srcdir + " > " + listfile).

input stream bkfile from value(listfile).
repeat:
    import stream bkfile delimiter "," filename.
    create list.
    assign list.filename = filename.
end.
input stream bkfile close.

/*record the log file*/
output close.
output to value(logfile) append.

put skip(1).
put "=======================  Run Date: " today   "   Run Time: " string(time,"HH:MM:SS") "================" skip (1).


find first list no-lock no-error.
if not available list then do:
     put "No source file for backflush!" at 1.
     leave.
end.

/*To backflush based on every source file*/
output stream bkflh close.
output stream bkflh to value(bkflh_file).
for each list where list.filename <> "" no-lock:

      for each xxwk:
            delete xxwk.
       end. 
      
      put "Now process file: " + filename at 1.             /*for log file*/
             
       input stream src from value(srcdir + "\" + list.filename).
       i = 0.
       repeat: /*repeat #1*/
          i = i + 1.
         import stream src delimiter "," x_data.
   
          if i > 1 then do:
                create xxwk.
               assign xxwk.emp = x_data[1]
                       xxwk.effdate = date(int(substr(x_data[2],6,2)),int(substr(x_data[2],9,2)),int(substr(x_data[2],1,4)))
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
                
         end. /*if i > 1*/
   
       end. /*repeat #1*/
      input stream src close.

       find first xxwk no-lock no-error.
       if not available xxwk then do:
            put "No data need to process!" at 1.
           next.
       end.


     /*create the header format*/
     find first xxwk no-lock no-error.
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
                 
/*      output stream bkflh close.*/

/*
    /*call the backflush program*/
    batchrun = yes.
    input from value(bkflh_file).
    output to value(bkflh_file + ".out") keep-messages.
       
    hide message no-pause.
       
    {gprun.i ""rebkfl.p""}
       
    hide message no-pause.
      
    output close.
    input close.
    batchrun = no.
*/
    
    Dos silent value("move " + srcdir + "\" + list.filename + " " + okdir).     

end. /*for each list*/
output stream bkflh close.



    /*call the backflush program*/
    batchrun = yes.
    input from value(bkflh_file).
    output to value(bkflh_file + ".out") keep-messages.
       
    hide message no-pause.
       
    {gprun.i ""rebkfl.p""}
       
    hide message no-pause.
      
    output close.
    input close.
    batchrun = no.

