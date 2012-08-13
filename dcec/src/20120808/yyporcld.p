/*zzporcld.p for automatically PO receipts using excel file*/
/*Last modified: 2003/12 By: Kevin*/

{mfdtitle.i "f+"}

def var srcfile as char format "x(60)" initial "".
def var sheet as int initial 1.
def var rowfrom as int format ">>9" initial 9.
def var rowto as int format ">>9" initial 99.
def var chexcel as com-handle.
def var chbook as com-handle.
def var chsheet as com-handle.
def var cpart as char format "x(1)" initial "B".
def var cvend as char format "x(1)" initial "D".
def var cloc as char format "x(1)" initial "G".
def var cponbr as char format "x(1)" initial "J".
def var cpoline as char format "x(1)" initial "K".
def var cqty as char format "x(1)" initial "L".
def var effdate like tr_effdate.
 def var gl_trans_type like gltr_tr_type .
 def var  gl_trans_ent  like gltr_entity .
 def var  gl_effdt_date like gltr_eff_dt .
 def var gpglef as integer .

def var irow as inte.
def var alist as char initial "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB".
define variable ent_exch    like exr_rate2.
define variable exch_rate   like exr_rate.
def var error_yn as logic.

def workfile xxwk
    field irow as inte format ">>>9"
    field part like pt_part
    field vend like po_vend
    field ponbr like po_nbr
    field poline like pod_line
    field qty like pod_qty_rcvd
    field ent_exch like exr_rate2
    field loc like pod_loc
    field msg as char format "x(40)".

def stream porc.
def var porcfile as char initial "porc.in".

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
     effdate colon 16
     srcfile colon 16 label "导入文件"
     sheet colon 16 
     rowfrom colon 16 label "导入行从"
     rowto colon 44 label "至"
     skip (1)
    "-Excel 格式(以下内容的位置)-" colon 10 skip(1)
    cpart colon 16 label "零件号"
    cvend colon 36 label "供应商"
    cloc colon 56 label "库位" skip(.4)
    cponbr colon 16 label "采购单"
    cpoline colon 36 label "采购单序"
    cqty colon 56 label "送货数量"
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " 选择条件 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/
setframelabels(frame a:handle) .
effdate = today.
find gl_ctrl no-lock no-error.
 mainloop :    
repeat:

     update effdate srcfile sheet rowfrom rowto cpart cvend cponbr cloc cpoline cqty with frame a.
     
    if effdate = ? then do:
       message "生效日期不允许为空" view-as alert-box error.
       undo,retry.
    end.
     
     /* CHECK GL EFFECTIVE DATE */
     /*tfq {gpglef.i effdate}*/
     find first en_mstr where en_primary = yes no-lock .
 /*tfq*/    {gpglef.i ""IC"" en_entity effdate "mainloop"}
     
     if search(srcfile) = ? then do:
           message "导入文件不存在,请重新输入!" view-as alert-box error.
           next-prompt srcfile with frame a.
           undo,retry.
     end.
     if not srcfile matches "*.xls" then do:
           message "导入文件不是Excel文件,请重新输入!" view-as alert-box error.
           next-prompt srcfile with frame a.
           undo,retry.
     end.

    for each xxwk:
        delete xxwk.
    end.
          
     Do on error undo:

          assign srcfile.
          status input "开始检查数据, 请稍等.......".
          assign sheet.
     
          CREATE "Excel.Application" chExcel.
          chExcel:Visible = false.
          chbook = chExcel:Workbooks:open(srcfile).
          chSheet = chExcel:Sheets:Item(sheet).  

          /*status input "Converting.....".*/
          irow = rowfrom - 1.

          repeat:
                irow = irow + 1.
                if irow > rowto then leave.
                
                if (string(trim(chsheet:cells(irow,"A"):value)) = "" 
                  or string(trim(chsheet:cells(irow,"A"):value)) = ?)
             and (string(trim(chsheet:cells(irow,"B"):value)) = ""
                  or string(trim(chsheet:cells(irow,"B"):value)) = ?)   
              then next.
              else do:
                  create xxwk.
                  assign xxwk.irow = irow
                             xxwk.part = trim(chsheet:cells(irow,lookup(cpart,alist)):value)
                             xxwk.vend = trim(chsheet:cells(irow,lookup(cvend,alist)):value)
                             xxwk.loc = trim(chsheet:cells(irow,lookup(cloc,alist)):value)
                             xxwk.ponbr = trim(chsheet:cells(irow,lookup(cponbr,alist)):value)
                             xxwk.poline = inte(chsheet:cells(irow,lookup(cpoline,alist)):value)
                             xxwk.qty = deci(chsheet:cells(irow,lookup(cqty,alist)):value).
                end.
                                
          end. /*sub repeat for every lines*/

          chbook:close(srcfile).
          chexcel:quit.
          release object chsheet.
          release object chbook.  
          release object chexcel.
     
     end. /*do on error undo*/

     for each xxwk:
        find po_mstr where po_nbr = xxwk.ponbr no-lock no-error.
        if not available po_mstr then do:
            assign xxwk.msg = "采购单不存在;".
            next.
        end.
        if po_vend <> xxwk.vend then do:
            assign xxwk.msg = xxwk.msg + "与采购单中供应商不一致;".
            next.
        end.
        if po_stat <> "" then do:
           assign xxwk.msg = xxwk.msg + "采购单序已结或取消;".
           next.
        end.
        
        if po_sched <> yes then do:
           assign xxwk.msg = "采购单不是排程单;".
           next.
        end.
        
        find pod_det where pod_nbr = xxwk.ponbr and pod_line = xxwk.poline no-lock no-error.
        if not available pod_det then do:
            assign xxwk.msg = xxwk.msg + "采购单序不存在;".
            next.
        end.
        
        if pod_part <> xxwk.part then do:
              assign xxwk.msg = xxwk.msg + "与采购单中零件不一致;".                   
            next.
        end.
        
        /*verify whether the part can perform the 'po receipts'*/
        find pt_mstr where pt_part = pod_part no-lock no-error.
        if not available pt_mstr then do:
            assign xxwk.msg = xxwk.msg + "零件号不存在;".
            next.
        end.
         
/*G1ZV*/   if can-find(first isd_det where
/*G1ZV*/              isd_status = string(pt_status,"x(8)") + "#"
/*G1ZV*/              and (isd_tr_type = "rct-po")) then do:
                assign xxwk.msg = xxwk.msg + "零件 " + pt_part + " 不能进行采购收货;".
                next. 
/*F089*/   end.

        if pt_lot_ser <> "" then do:
              assign xxwk.msg = xxwk.msg + "零件 " + pt_part + " 为'批/序号'控制;".
              next.
        end.  
        
        if pod_status <> "" then do:
           assign xxwk.msg = xxwk.msg + "采购单序已结或取消;".
           next.
        end.
        
        /*verify the site security of po detail*/           
        find si_mstr where si_site = pod_site no-lock no-error.
        {gprun.i ""gpsiver.p""
        "(input si_site, input recid(si_mstr), output return_int)"}

        if return_int = 0 then do:
             assign xxwk.msg = xxwk.msg + "用户没有访问地点" + si_site + "的权限".
             next.
        end.                  

        /*verify the default location*/
        find loc_mstr where loc_site = pod_site and loc_loc = xxwk.loc no-error.
        if not available loc_mstr then do:
            assign xxwk.msg = xxwk.msg + "接收库位不存在;".
            next.
        end.

       find isd_det no-lock
             where isd_tr_type = "rct-po"
                   and isd_status =
                   (if available loc_mstr and loc_status <> "" then loc_status
                   else si_status) no-error.
       if available isd_det then do:
           assign xxwk.msg = xxwk.msg + "接收库位 " + xxwk.loc + " 不能进行采购收货;".
           next.
       end.
        
        
        /*verify the exchange rate*/
        /* FIND EXCH RATE IF CURRENCY NOT BASE */
        if base_curr <> po_curr then do:
             if po_fix_rate then do:
                 ent_exch  = po_ent_ex.
             end.
             else do:  /*IF NOT FIXED RATE ALLOW FOR SPOT RATE*/
	     /***********tfq need detail review***********************/
	         find last exr_rate where ((exr_curr1 = base_curr
			                   and  exr_curr2 = po_curr)
			                   or ( exr_curr1 = po_curr 
			                   and  exr_curr2 = base_curr ))
			                   and exr_start_date <= effdate
			                   and exr_end_date >= effdate
			                   no-lock no-error.
	         if available exr_rate then do:
		            if exr_curr2 = po_curr then 
		                assign exch_rate =  exr_rate 
		                       ent_exch = exr_rate2 / exr_rate. 
		            else
		           assign     exch_rate = exr_rate2
                                ent_exch = exr_rate / exr_rate2. 
                        /*  if exr_rate = exch_rate then
                              ent_exch = exr_rate2.
                          else
                              ent_exch = 1 / exr_rate2.  */     
                     /***********tfq need detail review***********************/                              
	        end.
               else do: /*not available exr_det*/
                         assign xxwk.msg = xxwk.msg + ";".
                         next.
        	 end.
	   
             end.

             assign xxwk.ent_exch = ent_exch.                /*kevin*/
        end. /*if base_curr <> po_curr*/
                  
    end. /*for each xxwk*/

    status input "数据检查完毕!".
    
    error_yn = no.
    find first xxwk where xxwk.msg <> "" no-lock no-error.
    if available xxwk then do:
          if not batchrun then
                 message "导入文件中有错误出现,系统将不进行导入,请检查原导入文件!" view-as alert-box error.
        
          error_yn = yes.
    end.


  Do on error undo:     /*#2*/  
    /*Create the upload input file and call the 'poporc.p' to upload*/
    if not error_yn then do:

       status input "开始导入数据, 请稍等......".
    
       output stream porc close.
       output stream porc to value(porcfile).
       
       for each xxwk no-lock break by xxwk.ponbr by xxwk.poline:
            if first-of(xxwk.ponbr) then do:
                put stream porc "~"" at 1 xxwk.ponbr "~"".
                put stream porc "- - " at 1 effdate " Y N N".
            end.
            
            put stream porc "~"" at 1 xxwk.poline "~"".
            put stream porc xxwk.qty at 1 " - N - - - - " "~"" xxwk.loc "~"" " - - - N N N".
            
            if last-of(xxwk.ponbr) then do:
                put stream porc "" at 1.
                /*put stream porc "Y" at 1.*/
                /*put stream porc "Y" at 1.*/
            end.
       end.
       
       output stream porc close.   

       /*Call the program - poporc.p to finish the upload*/
       batchrun = yes.
                                         
       input from value(porcfile).
       output to value(porcfile + ".out") keep-messages.
                                         
       hide message no-pause.                
                                         
       {gprun.i ""poporc.p""}
                                             
       hide message no-pause.
                                         
       output close.
       input close.
       batchrun = no.    
       
    end.
  end. /*#2*/


   {mfselprt.i "printer" 132}
          
    for each xxwk:
       if not error_yn then do:
            find first tr_hist 
                 use-index tr_part_eff where tr_part = xxwk.part 
                                         and tr_effdate = effdate
                                         and tr_type = "rct-po"
                                         and tr_nbr = xxwk.ponbr
                                         and tr_line = xxwk.poline
                                         and tr_loc = xxwk.loc
                                         and tr_qty_loc = xxwk.qty
                               no-lock no-error.
            if available tr_hist then assign xxwk.msg = xxwk.msg + "导入成功;".
            else assign xxwk.msg = xxwk.msg + "导入失败;".                             
                                                       
      end.
      
       disp xxwk.irow label "文件行号" xxwk.part xxwk.vend xxwk.loc 
          xxwk.ponbr xxwk.poline xxwk.qty xxwk.msg label "提示信息"
           with width 132 stream-io.
    end.
        
    {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
     
end. /*repeat*/
