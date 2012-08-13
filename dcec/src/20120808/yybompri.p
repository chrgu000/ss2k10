/*yybompri.p, CREATE BY Han Jia   2008-12-04          	*/
/*BOM and item price report    				*/

{mfdtitle.i "d+ "}
define variable par like bom_parent label "物料单代码".
define variable level as integer.
define variable maxlevel as integer format ">>>"  .
define variable eff_date as date .
define variable parent like ps_par  no-undo.
define variable desc1 like pt_desc1.
define variable um like pt_um.
define variable v_vend like pt_vend.

define variable op AS INT  FORMAT ">>>>9" label "标准工序".
define variable op1 AS INT FORMAT ">>>>9". 
define variable wkctr like wc_wkctr label "工作中心".
define variable wkctr1 like wc_wkctr.
define variable endate like pc_start label "成本日期至" initial today.

define variable phantom like mfc_logical format "yes" .


/* define Excel	object handle */
DEFINE VARIABLE chExcelApplication1 AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.
DEFINE VARIABLE iCount AS INTEGER  .
DEFINE VARIABLE iColumn AS INTEGER .
DEFINE VARIABLE cColumn AS CHARACTER.
DEFINE VARIABLE cRange AS CHARACTER.

define variable foutputfile as char format "x(42)" INIT "D:\SO.XLS".

def TEMP-TABLE tt
    field tt_parent like bom_parent
    field tt_comp   like ps_comp
    field tt_desc1  like pt_desc1
    field tt_desc2  like pt_desc2
    field tt_ref    like ps_ref
    field tt_sdate  like ps_start   label "生效日期" 
    field tt_edate  like ps_end     label "截止日期" 
    field tt_qty    like ps_qty_per
    field tt_op     like ps_op      label "工序" 
    field tt_curr   like pc_curr
    field tt_ctr    like opm_wkctr  label "工作中心" 
    field tt_wcdesc like opm_desc
    field tt_vend   like pt_vend    label "供应商" 
    field tt_adname like ad_name    label "供应商名称" 
    field tt_amt    like pc_amt[1]  label "价格" 
    field tt_pm     like pt_pm_code 
    field tt_um     like pt_um .

FORM 
    par      colon 25
    op     colon 25    op1 label {t001.i} colon 49
    wkctr colon 25     wkctr1 label {t001.i} colon 49 skip 
    endate colon 25 skip(1)
    foutputfile colon 25   label	"输出EXCEL文件"  skip(1)    
    with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

repeat:
    
    if wkctr1 = hi_char then wkctr1 = "".
    if op1 = 0 then op1 = 99999.

    update par op op1 wkctr wkctr1 endate foutputfile with frame a.   

    if wkctr1 = "" then wkctr1 = hi_char.

    if foutputfile = "d:\" OR (substring(foutputfile,length(foutputfile) - 3,4) <> ".xls") then do:
		message "输出文件必须是EXCEL表格，以XLS为文件后缀名，请重新输入！" view-as alert-box.
	    NEXT .
	end.
    if search(foutputfile) <> ? then do:
    	message "输出文件存在，请确认没有打开此文件! 此操作将覆盖已有文件!" 
            view-as alert-box button YES-NO update yn1 as logic.
    	if yn1 <> yes then do:
    		UNDO .
            NEXT .
    	end.
    end.

    FOR EACH tt :
        DELETE tt .
    END.
    
    run process_report (INPUT par ,
                        INPUT 15).

    FIND FIRST tt NO-ERROR.
    IF AVAIL tt THEN DO:
        ASSIGN iColumn = 1 .
        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication1.
        
        /* create a new Workbook */
        chWorkbook = chExcelApplication1:Workbooks:Add().
        
        /* get the active Worksheet */
        chWorkSheet = chExcelApplication1:Sheets:Item(1).
        chWorkSheet:Columns("A"):ColumnWidth = 8.
        chWorkSheet:Columns("B"):ColumnWidth = 12.
        chWorkSheet:Columns("C"):ColumnWidth = 8.
        chWorkSheet:Columns("D"):ColumnWidth = 20.
        chWorkSheet:Columns("E"):ColumnWidth = 12.
        chWorkSheet:Columns("F"):ColumnWidth = 8.
        chWorkSheet:Columns("G"):ColumnWidth = 16.
        chWorkSheet:Columns("H"):ColumnWidth = 18.
        chWorkSheet:Columns("I"):ColumnWidth = 18.
        chWorkSheet:Columns("J"):ColumnWidth = 4.
        chWorkSheet:Columns("K"):ColumnWidth = 10.
        chWorkSheet:Columns("L"):ColumnWidth = 6.
        chWorkSheet:Columns("M"):ColumnWidth = 6.
        chWorkSheet:Columns("N"):ColumnWidth = 6.
        chWorkSheet:Columns("O"):ColumnWidth = 6.
        chWorkSheet:Columns("P"):ColumnWidth = 6.
        chWorkSheet:Columns("Q"):ColumnWidth = 9.
        chWorkSheet:Columns("R"):ColumnWidth = 9.
        chWorkSheet:Range("A1:R1"):Font:Bold = TRUE.
        chWorkSheet:Range("A1"):Value = "机型".
        chWorkSheet:Range("B1"):Value = "父零件".   
        chWorkSheet:Range("C1"):Value = "工作中心". 
        chWorkSheet:Range("D1"):Value = "工作中心描述". 
        chWorkSheet:Range("E1"):Value = "子零件".     
        chWorkSheet:Range("F1"):Value = "供应商" .
        chWorkSheet:Range("G1"):Value = "供应商名称".   
        chWorkSheet:Range("H1"):Value = "子零件英文描述". 
        chWorkSheet:Range("I1"):Value = "子零件中文描述".    
        chWorkSheet:Range("J1"):Value = "P/M".    
        chWorkSheet:Range("K1"):Value = "价格".  
        chWorkSheet:Range("L1"):Value = "币别".          
        chWorkSheet:Range("M1"):Value = "单位".        
        chWorkSheet:Range("N1"):Value = "参考".   
        chWorkSheet:Range("O1"):Value = "用量".  
        chWorkSheet:Range("P1"):Value = "工序".          
        chWorkSheet:Range("Q1"):Value = "生效日期".        
        chWorkSheet:Range("R1"):Value = "截止日期". 

    END.
    FOR EACH tt :
        FOR FIRST ps_mstr fields(ps_par ps_comp ps_start ps_end) 
            NO-LOCK WHERE ps_par = tt_comp 
            AND (ps_start = ? or ps_start <= TODAY)
         and (ps_end = ? or TODAY <= ps_end):
        END.
        IF NOT AVAIL ps_mstr THEN DO:
            find first opm_mstr where opm_std_op = string(tt_op) 
                no-lock no-error.
            if available opm_mstr then do:
                assign tt_ctr = opm_wkctr.
                find wc_mstr where wc_wkctr = opm_wkctr 
                    and wc_mch = opm_mch no-lock no-error.
                if available wc_mstr then
                       ASSIGN tt_wcdesc = wc_desc.
            end. 
            FIND vd_mstr WHERE vd_addr = tt_vend  no-lock no-error.
            if available vd_mstr then
                       ASSIGN tt_adname = vd_sort .
            IF tt_op >= int(op) AND tt_op <= int(op1) 
                AND tt_ctr >= wkctr AND tt_ctr <= wkctr1 THEN DO:
                for LAST pc_mstr where pc_part = tt_comp 
                    and (pc_start <= endate OR pc_start = ?)
                    AND (pc_expire >= endate OR pc_expire = ?) no-lock:
                    ASSIGN tt_amt = pc_amt[1]
                        tt_um = pc_um
                        tt_curr = pc_curr .
               end.  
              /* DISP par LABEL "机型" tt_parent LABEL "父零件" tt_ctr LABEL "工作中心" 
                   tt_wcdesc LABEL "工作中心描述"  tt_comp LABEL "子零件" 
                   tt_vend  tt_adname tt_desc1 LABEL "子零件英文描述" 
                   tt_desc2 LABEL "子零件中文描述" tt_pm tt_amt tt_curr tt_um 
                   tt_ref tt_qty tt_op tt_sdate tt_edate WITH STREAM-IO WIDTH 300 . */
               iColumn = iColumn + 1.
               cColumn = STRING(iColumn).
               cRange = "A" + cColumn.
               chWorkSheet:Range(cRange):Value = par .
               cRange = "B" + cColumn.
               chWorkSheet:Range(cRange):Value = tt_parent .
               cRange = "C" + cColumn.
               chWorkSheet:Range(cRange):Value = tt_ctr .
               cRange = "D" + cColumn.
               chWorkSheet:Range(cRange):Value = tt_wcdesc .
               cRange = "E" + cColumn.
               chWorkSheet:Range(cRange):Value = tt_comp .
               cRange = "F" + cColumn.
               chWorkSheet:Range(cRange):Value = tt_vend .
               cRange = "G" + cColumn.
               chWorkSheet:Range(cRange):Value = tt_adname .
               cRange = "H" + cColumn.
               chWorkSheet:Range(cRange):Value = tt_desc1 .
               cRange = "I" + cColumn.
               chWorkSheet:Range(cRange):Value = tt_desc2 .
               cRange = "J" + cColumn.
               chWorkSheet:Range(cRange):Value = tt_pm .
               cRange = "K" + cColumn.
               chWorkSheet:Range(cRange):Value = tt_amt .
               cRange = "L" + cColumn.
               chWorkSheet:Range(cRange):Value = tt_curr .
               cRange = "M" + cColumn.
               chWorkSheet:Range(cRange):Value = tt_um .
               cRange = "N" + cColumn.
               chWorkSheet:Range(cRange):Value = tt_ref .
               cRange = "O" + cColumn.
               chWorkSheet:Range(cRange):Value = tt_qty .
               cRange = "P" + cColumn.
               chWorkSheet:Range(cRange):Value = tt_op .
               cRange = "Q" + cColumn.
               chWorkSheet:Range(cRange):Value = tt_sdate .
               cRange = "R" + cColumn.
               chWorkSheet:Range(cRange):Value = tt_edate .

            END.    /* IF tt_op >= int(op) AND tt_op <= int(op1) end */
        END.      /* IF NOT AVAIL ps_mstr THEN end */
    END.    /* FOR EACH tt end */
    FIND FIRST tt NO-ERROR.
    IF AVAIL tt THEN DO:
        chWorkbook:saveas(foutputfile , , , , , , 1) . 
        chExcelApplication1:Visible = TRUE.
        
        RELEASE OBJECT chExcelApplication1. 
        RELEASE OBJECT chWorkbook.
        RELEASE OBJECT chWorksheet.
    END.
END.

PROCEDURE process_report:
   define input parameter comp like ps_comp no-undo.
   define input parameter level as integer no-undo.

   define query q_ps_mstr for ps_mstr
      fields(ps_comp ps_end ps_par ps_ps_code ps_qty_per 
             ps_start ps_op ps_ref ps__chr01).

   for first bom_mstr
      fields(bom_batch_um bom_desc bom_fsm_type bom_parent)
      where bom_parent = comp
      no-lock:
   end. /* FOR FIRST bom_mstr */

   for first pt_mstr
      fields (pt_bom_code pt_desc1 pt_desc2
      pt_iss_pol  pt_part  pt_phantom pt_um)
      no-lock
      where pt_part = comp:
   end. /* FOR FIRST pt_mstr */

   if available pt_mstr
   and pt_bom_code <> ""
   then
      comp = pt_bom_code.

   open query q_ps_mstr
      for each ps_mstr
      use-index ps_parcomp
      where ps_par = comp no-lock.

   get first q_ps_mstr no-lock.

   if not available ps_mstr
   then
      return.

   repeat while available ps_mstr :

      if (ps_start = ? or ps_start <= TODAY)
         and (ps_end = ? or TODAY <= ps_end)
      then do:

         assign
            um = ""
            desc1 = ""
            v_vend = ""
            phantom = no.

         for first pt_mstr
            fields(pt_bom_code pt_desc1 pt_desc2 
                   pt_part pt_phantom pt_um pt_vend pt_pm_code)
            where pt_part = ps_comp
            no-lock:
         end. /* FOR FIRST pt_mstr */

         if available pt_mstr
         then do:
            assign
               um = pt_um
               desc1 = pt_desc1
               phantom = pt_phantom
               v_vend = pt_vend .
         end.
         else do:
            for first bom_mstr
               fields(bom_batch_um bom_desc bom_fsm_type bom_parent)
               where bom_parent = ps_comp
               no-lock:
            end. /* FOR FIRST bom_mstr */
            if available bom_mstr
            then
               assign
                  um = bom_batch_um
                  desc1 = bom_desc.
         end.
         FOR FIRST ptp_det 
             FIELDS (ptp_site ptp_part ptp_phantom ptp_vend ptp_pm_code)
             WHERE ptp_site = ps__chr01 AND ptp_part = ps_comp NO-LOCK:
         END.
         IF AVAIL ptp_det THEN ASSIGN phantom = ptp_phantom
             v_vend = ptp_vend .

         IF NOT phantom THEN DO:
             CREATE tt.
             ASSIGN tt_parent = ps_par 
                 tt_comp   = ps_comp 
                 tt_desc1  = desc1
                 tt_desc2  = pt_desc2 WHEN AVAIL pt_mstr
                 tt_pm     = ptp_pm_code WHEN AVAIL ptp_det
                 tt_ref    = ps_ref    
                 tt_sdate  = ps_start  
                 tt_edate  = ps_end    
                 tt_qty    = ps_qty_per
                 tt_op     = ps_op     
                 tt_vend   = v_vend    .
         END.
         if level < maxlevel
         or maxlevel = 0
         then do:

            run process_report (input ps_comp, input level + 1).
            get next q_ps_mstr no-lock.
         end.
         else do:
            get next q_ps_mstr no-lock.
         end.
      end.  /* End of Valid date */
      else do:
         get next q_ps_mstr no-lock.
      end.
   end.  /* End of Repeat loop */
   close query q_ps_mstr.
END PROCEDURE.
