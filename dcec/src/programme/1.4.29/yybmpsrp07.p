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

def var effdate like tr_effdate LABEL "BOM生效日期".
define variable record as integer extent 100.
define variable comp like ps_comp.
define variable level as integer.
define variable maxlevel as integer format ">>>" label "层次".
def var datecost like pc_start.
def var partcost as   decimal.
DEFINE VAR v_pc_start LIKE pc_start.
DEFINE VAR v_pc_expire LIKE pc_expire.
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
    field wcdesc like opm_desc
    field wvend like pt_vend
    field wadname LIKE ad_name
    FIELD pmcode LIKE ptp_pm_code
    FIELD par LIKE ps_par
    FIELD bomcode LIKE ptp_bom_code
    FIELD site LIKE ptp_site.

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
           parent colon 25     
            op     colon 25    op1 label {t001.i} colon 50
            wkctr colon 25     wkctr1 label {t001.i} colon 50 
            effdate colon 25   
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
   
   update PARENT  op op1 wkctr wkctr1  effdate with frame a.       
   
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

                find pt_mstr where pt_part = ps_comp  no-lock no-error.
                find ptp_det where ptp_site = ps__chr01 and ptp_part = ps_comp no-lock no-error.
                
                if available pt_mstr /*and 
                ((available ptp_det /*and not ptp_phantom*/)
                  or
                  (not available ptp_det /*and not pt_phantom*/ ))*/ then do:
                
                      create xxwk.
                      assign xxwk.parent = parent
                             xxwk.comp = ps_comp
                             xxwk.desc1 = pt_desc1
                             xxwk.desc2 = pt_desc2
                             xxwk.ref = ps_ref
                             xxwk.sdate = ps_start
                             xxwk.edate = ps_end
                             xxwk.op = ps_op
                             xxwk.qty = ps_qty_per
                             /*xxwk.wvend = IF AVAIL ptp_det THEN ptp_vend ELSE ""*/
                             xxwk.pmcode = IF AVAIL ptp_det THEN ptp_pm_code ELSE ""
                             xxwk.par = ps_par
                             xxwk.bomcode = IF AVAIL ptp_det THEN ptp_bom_code ELSE ""
                             xxwk.site = IF AVAIL ptp_det THEN ptp_site ELSE "".
                      
                      find first opm_mstr where opm_std_op = string(ps_op) no-lock no-error.
                      if available opm_mstr then do:
                            assign xxwk.wkctr = opm_wkctr.
                            
                            find wc_mstr where wc_wkctr = opm_wkctr and wc_mch = opm_mch no-lock no-error.
                            if available wc_mstr then
                                   assign xxwk.wcdesc = wc_desc.

                           /* FIND ad_mstr WHERE ad_add = ptp_vend  no-lock no-error.
                            if available ad_mstr then
                                   ASSIGN xxwk.wadname =ad_name.*/
                      end. 

                end.        
                       
		  record[level] = recid(ps_mstr).

		  if level < maxlevel or maxlevel = 0 
		  and ((available ptp_det /*and ptp_phantom*/ ) or (not available ptp_det and available pt_mstr /*and pt_phantom*/ )
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

   FOR EACH xxwk WHERE xxwk.pmcode <> "M" AND (string(xxwk.op) >= op and string(xxwk.op) <= op1)
       and (xxwk.wkctr >= wkctr and xxwk.wkctr <= wkctr1) AND xxwk.bomcode = ""  NO-LOCK.
     FIND ptp_det WHERE (ptp_part = xxwk.par OR ptp_part = SUBSTRING(xxwk.par,1,LENGTH(ptp_part))) AND ptp_pm_code <> "P" NO-LOCK NO-ERROR.
     IF AVAIL ptp_det THEN DO:
       partcost = 0.
       FOR EACH pc_mstr where pc_part = xxwk.comp BREAK BY pc_start.
        IF LAST-OF(pc_start) THEN DO:
           FIND FIRST ad_mstr WHERE ad_addr = pc_list OR ad_addr = SUBSTRING(pc_list,1 ,LENGTH(ad_addr)) AND ad_type = "supplier"  NO-LOCK NO-ERROR.
           IF AVAIL ad_mstr THEN DO:
               xxwk.wvend = ad_addr.
               xxwk.wadname = ad_name.
           END.
           ELSE DO:
               xxwk.wvend = "DCEC".
               xxwk.wadname = "东风康明斯".

           END.
           partcost = pc_amt[1].
           monkind = pc_curr.
           umcost = pc_um.
           v_pc_start = pc_start.
           v_pc_expire = pc_expire.

        END.
        ELSE DO: 
           partcost = 0.
           monkind = "".
           umcost = "".
           v_pc_start = ?.
           v_pc_expire = ?.
        END.
       END.
       

       disp xxwk.parent label "机型" 
            xxwk.par 
            xxwk.wkctr COLUMN-LABEL "工作中心"
            xxwk.wcdesc label "工作中心描述"
            xxwk.comp label "子零件"
            xxwk.wvend label "供应商"
            xxwk.wadname label "供应商名称"
            xxwk.desc1 label "子零件描述" 
            xxwk.desc2 label "子零件描述"
            xxwk.pmcode 
            partcost label "价格"    
            monkind  label "货币"
            umcost   label "单位" 
            xxwk.ref label "参考号" 
            xxwk.qty label "父件数量" 
            xxwk.op label "工序" 
            v_pc_start COLUMN-LABEL "生效日期" 
            v_pc_expire COLUMN-LABEL "截止日期" 
            with width 280 stream-io. 
     
    END. /*END. end if ptp_det*/
   END.

   
   {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
   
         
end. /*repeat*/
