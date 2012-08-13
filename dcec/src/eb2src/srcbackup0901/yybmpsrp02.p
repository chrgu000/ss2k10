/*zzbmpsrp01 for product structure report by op or by work center*/

/*GN61*/ {mfdtitle.i "d+ "}

def var parent like bom_parent label "物料单代码".
def var op like opm_std_op label "标准工序".
def var op1 like opm_std_op. 
def var wkctr like wc_wkctr label "工作中心".
def var wkctr1 like wc_wkctr.
/*Jch---*/
def var stdate like pc_start label "成本日期".
def var endate like pc_start label "成本日期至" initial today.

def var effdate like tr_effdate.
define variable record as integer extent 100.
define variable comp like ps_comp.
define variable level as integer.
define variable maxlevel as integer format ">>>" label "层次".
def var datecost like pc_start.
def var partcost as   decimal.
/*
def var partcost like pc_amt.
*/
def var umcost   like pc_um.
datecost = 01/01/90.

def workfile xxwk
    field parent like bom_parent
    field comp like ps_comp
    field desc1 like pt_desc1
    field desc2 like pt_desc2
    field ref like ps_ref
    field sdate like ps_start label "生效日期" 
    field edate like ps_end label "截止日期" 
    field qty like ps_qty_per
    field op like ps_op
    field monkind like pc_curr
    field wkctr like opm_wkctr label "工作中心" 
    field wcdesc like opm_desc.

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
parent      colon 25
            op     colon 25    op1 label {t001.i} colon 49
            wkctr colon 25     wkctr1 label {t001.i} colon 49 skip 
          
            endate colon 25
         /*   effdate  colon 25*/
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

effdate = today.

repeat:
   
   if op1 = hi_char then op1 = "".
   if wkctr1 = hi_char then wkctr1 = "".
   
   update parent op op1 wkctr wkctr1  endate /* effdate*/ with frame a.       
   
   if op1 = "" then op1 = hi_char.
   if wkctr1 = "" then wkctr1 = hi_char.
   
   find bom_mstr where bom_parent = parent no-lock no-error.
   if not available bom_mstr then do:
        message "该产品结构代码不存在,请重新输入!" view-as alert-box error.
        next-prompt parent with frame a.
        undo,retry.
   end.

   find first ps_mstr use-index ps_parcomp where ps_par = parent
   no-lock no-error.
   if not available ps_mstr then do:
        message "该父零件无产品结构,请重新输入!" view-as alert-box error.
        undo,retry.
   end.
   
   {mfselprt.i "printer" 132}
   
   for each xxwk:
        delete xxwk.
   end.
   
   assign
         level = 1
	  comp = parent
	  maxlevel = min(maxlevel,99).   
   
   repeat: /*for expand the ps*/
	       if not available ps_mstr then do:
		  repeat:
		     level = level - 1.
		     if level < 1 then leave.
		     find ps_mstr where recid(ps_mstr) = record[level]
		     no-lock no-error.
		     comp = ps_par.
		     find next ps_mstr use-index ps_parcomp where ps_par = comp
		     no-lock no-error.
		     if available ps_mstr then leave.
		  end.
	       end.
	       if level < 1 then leave.

	       if effdate = ? or (effdate <> ? and
	       (ps_start = ? or ps_start <= effdate)
	       and (ps_end = ? or effdate <= ps_end)) then do:

                find pt_mstr where pt_part = ps_comp no-lock no-error.
                find ptp_det where ptp_site = ps__chr01 and ptp_part = ps_comp no-lock no-error.
                
                if available pt_mstr and 
                ((available ptp_det and not ptp_phantom)
                  or
                  (not available ptp_det and not pt_phantom)) then do:
                
                      create xxwk.
                      assign xxwk.parent = parent
                             xxwk.comp = ps_comp
                             xxwk.desc1 = pt_desc1
                             xxwk.desc2 = pt_desc2
                             xxwk.ref = ps_ref
                             xxwk.sdate = ps_start
                             xxwk.edate = ps_end
                             xxwk.op = ps_op
                             xxwk.qty = ps_qty_per.
                      
                      find first opm_mstr where opm_std_op = string(ps_op) no-lock no-error.
                      if available opm_mstr then do:
                            assign xxwk.wkctr = opm_wkctr.
                            
                            find wc_mstr where wc_wkctr = opm_wkctr and wc_mch = opm_mch no-lock no-error.
                            if available wc_mstr then
                                   assign xxwk.wcdesc = wc_desc.
                      end. 

                end.        
                       
		  record[level] = recid(ps_mstr).

		  if level < maxlevel or maxlevel = 0 
		  and ((available ptp_det and ptp_phantom) or (not available ptp_det and available pt_mstr and pt_phantom)
		        or not available pt_mstr) 
		  then do:
		     comp = ps_comp.
		     level = level + 1.
		     find first ps_mstr use-index ps_parcomp where ps_par = comp
		     no-lock no-error.
		  end.
		  else do:
		     find next ps_mstr use-index ps_parcomp where ps_par = comp
		     no-lock no-error.
		  end.
	       end.
	       else do:
		     find next ps_mstr use-index ps_parcomp where ps_par = comp
		     no-lock no-error.
	       end.
   
   end. /*expand the ps*/

   for each xxwk no-lock 
       where (string(xxwk.op) >= op and string(xxwk.op) <= op1)
       and (xxwk.wkctr >= wkctr and xxwk.wkctr <= wkctr1)
       break by xxwk.wkctr by xxwk.comp:
       /*--- add the Cost of the part*********************/
       partcost = 0.
       for each pc_mstr where pc_part = xxwk.comp 
                              and pc_start <= endate 
                        no-lock:
        /*   disp xxwk.comp pc_part pc_amt[1].*/
           if datecost < pc_start then do:
              partcost = pc_amt[1].
              datecost = pc_start.
              monkind  = pc_curr.
                umcost = pc_um.
           end.
          
       end.   
       
       datecost = 01/01/90.   
       /**--------------------------**********************/      
       disp xxwk.parent label "机型" 
            xxwk.wkctr COLUMN-LABEL "工作中心"
            xxwk.wcdesc label "工作中心描述"
            xxwk.comp label "子零件"
            xxwk.desc1 label "子零件描述" 
            xxwk.desc2 label "子零件描述"
            partcost label "价格"    
            monkind  label "货币"
            umcost   label "单位" 
            xxwk.ref label "参考号" 
            xxwk.qty label "父件数量" 
            xxwk.op label "工序" 
            xxwk.sdate COLUMN-LABEL "生效日期" 
            xxwk.edate COLUMN-LABEL "截止日期" 
            with width 200 stream-io. 
        
   end. /*for each xxwk*/
   
   {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
   
         
end. /*repeat*/
