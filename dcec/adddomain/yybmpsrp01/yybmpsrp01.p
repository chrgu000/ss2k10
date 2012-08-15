/*zzbmpsrp01 for product structure report by op or by work center*/

/*GN61*/ {mfdtitle.i "d+ "}

def var parent like bom_parent.
def var op like opm_std_op.
def var op1 like opm_std_op.
def var wkctr like wc_wkctr.
def var wkctr1 like wc_wkctr.
def var effdate like tr_effdate.
define variable record as integer extent 100.
define variable comp like ps_comp.
define variable level as integer.
define variable maxlevel as integer format ">>>" label "层次".
/*cj*/ DEF VAR xqty AS DECIMAL EXTENT 100 .

def workfile xxwk
    field parent like bom_parent
    field comp like ps_comp
    field desc2 like pt_desc2
    field ref like ps_ref
    field sdate like ps_start
    field edate like ps_end
    field qty like ps_qty_per
    field op like ps_op
    field wkctr like opm_wkctr
    field wcdesc like opm_desc.

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
parent      colon 25
            op     colon 25    op1 label {t001.i} colon 49
            wkctr colon 25     wkctr1 label {t001.i} colon 49 skip(1)  
            effdate  colon 25
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
   
   update parent op op1 wkctr wkctr1 effdate with frame a.       
   
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
   
   {mfselprt.i "printer" 255}
   
   for each xxwk:
        delete xxwk.
   end.
   
   assign
         level = 1
	  comp = parent
	  maxlevel = min(maxlevel,99).   

/*cj*/ xqty[level] = 1 .
   
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
                             xxwk.desc2 = pt_desc2
                             xxwk.ref = ps_ref
                             xxwk.sdate = ps_start
                             xxwk.edate = ps_end
                             xxwk.op = ps_op
                             xxwk.qty = ps_qty_per /*cj*/ * xqty[level] .
                      
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
/*cj*/       xqty[level] = ps_qty_per * xqty[level - 1] .
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
       find first pt_mstr where pt_part = xxwk.comp no-lock no-error .
        disp xxwk.parent label "机型" xxwk.wkctr xxwk.wcdesc label "工作中心描述"
               xxwk.comp xxwk.desc2 label "子零件描述"              
             xxwk.ref label "参考" xxwk.qty label "用量"  xxwk.op label "工序" xxwk.sdate xxwk.edate pt_status 
             with width 255 stream-io. 
   end. /*for each xxwk*/
   
   {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
   
         
end. /*repeat*/
