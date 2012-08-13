/*zzssrp02.p for 零件日程报表打印（也即采购日程单打印），writed by Kevin,2003/11*/

/*LAST MODIFIED BY *LB01*             LONG BO   2004-6-02                            

	ADDED 5 COLUMNS: 
	
	1）安全库存				是指.1.4.17（DCEC零件－地点计划维护）中的安全库存。
	2）"月度需求"			＝本月到报表日期间的所有采购收货量 + 报表日到月底这段时间的MRP计划订货量。
	3）"供应商比例"			是指.5.5.1.17（排程单MRP%维护）中的比例。
	4）"比例采购数量"		是指根据"月度需求"和"供应商比例"自动分配出来的数量。
	5）"当月累计到货数量"	即当月累计采购收货量

-----------------------------------------------------------------------------------*/

         /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*GI32*/ {mfdtitle.i "E"}

def var site like si_site.
def var site1 like si_site.
def var vend like vd_addr.
def var vend1 like vd_addr.
def var buyer like ptp_buyer.
def var buyer1 like ptp_buyer.
def var part like pt_part.
def var part1 like pt_part.
def var start like ps_start label "日程日期".
def var outpath as char format "x(40)" label "输出目录".
def var testdir as char.
def var i as inte.

/*lb01*/
def var mstart as date label "月度范围".		/*月度开始日期 */
def var mend as date.		/*月度结束日期 */
/*lb01*/

/*workfile key index: buyer + vend + part*/
def workfile xxwk
   field zzk like pod_loc label "中转库"
   field buyer like ptp_buyer
   field vend like vd_addr
   field vendname like ad_name
   field part like pt_part
   field desc1 like pt_desc1
   field qty_ord like tr_qty_loc
   field qty_pack like tr_qty_loc
   field loc like loc_loc
   field stime like schd_time
   field site like pod_site
   field ponbr like pod_nbr
   field poline like pod_line
   field keeper as char label "保管员"
   /*lb01*/
   field sftstock like ptp_sfty_stk
   field mqty	like tr_qty_loc
   field supperc like qad_decfld[1]  /*采购比例*/
   field cumrctqty like tr_qty_loc
   /*lb01*/
   .

def var up_yn as logic.

/* define Excel object handle */
DEFINE NEW SHARED VARIABLE chExcelApplication AS COM-HANDLE.
/*DEFINE VARIABLE chExcelWorksheet AS COM-HANDLE.*/
DEFINE NEW SHARED VARIABLE chExcelWorkbook AS COM-HANDLE.
/*Define Sheet Variavble*/
DEFINE VARIABLE iLine AS INTEGER.
DEFINE VARIABLE iTotalLine AS INTEGER.
DEFINE VARIABLE iHeaderLine AS INTEGER.
DEFINE VARIABLE iHeaderStartLine AS INTEGER.
DEFINE VARIABLE iMAXPageLine AS INTEGER.
DEFINE VARIABLE iFooterLine AS INTEGER.
DEFINE VARIABLE iPageNum AS INTEGER.
DEFINE VARIABLE iLoop1 AS INTEGER.


form
   RECT-FRAME       AT ROW 1 COLUMN 1.25
   RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
   SKIP(1)  /*GUI*/
   start colon 22 skip(1)
   mstart colon 22 		mend	colon 45 label {t001.i}	skip(1) /*lb01*/
   site colon 22        site1 colon 45 label {t001.i}
   vend colon 22        vend1 colon 45 label {t001.i}
   buyer colon 22       buyer1 colon 45 label {t001.i}
   part colon 22        part1 colon 45 label {t001.i} skip(1)
   outpath colon 22
   skip (1)
   with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

   DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
   RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
   RECT-FRAME-LABEL:HIDDEN in frame a = yes.
   RECT-FRAME:HEIGHT-PIXELS in frame a =
   FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
   RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

repeat:
    
    outpath = "c:\Purchase daily schedule". 
/*	outpath = "E:\Project\DCEC\Customization(6702C.08)". lb01*/
    if start = ? then start = today.    
    
    if site1 = hi_char then site1 = "".
    if vend1 = hi_char then vend1 = "".
    if buyer1 = hi_char then buyer1 = "".
    if part1 = hi_char then part1 = "".
    
    /*lb01--*/
    update start with frame a.
    if start = ? then do:
      message "日程日期不允许为空" view-as alert-box error.
      undo,retry.
    end.
 	
	if day(start) < 28 then do:
		mstart = start - day(start) - 1. /*上个月最后一天*/
		mend = start.
	end.
	else do:
		mstart = start.
		mend = start + 5.   /*变到下个月*/
	end.
	mstart = mstart + 28 - day(mstart).  /*变到月的28号*/
	
	mend = mend + 27 - day(mend).
	/*--lb01*/
	
	    
    update /*start lb01*/ mstart mend  site site1 vend vend1 buyer buyer1 part part1 outpath with frame a.
    
    if site1 = "" then site1 = hi_char.
    if vend1 = "" then vend1 = hi_char.
    if buyer1 = "" then buyer1 = hi_char.
    if part1 = "" then part1 = hi_char.
    
   
/*J034*/       if not batchrun then do:
/*J034*/          {gprun.i ""gpsirvr.p""
                   "(input site, input site1, output return_int)"}
/*J034*/          if return_int = 0 then do:
/*J034*/             next-prompt site with frame a.
/*J034*/             undo, retry.
/*J034*/          end.
/*J034*/       end.

    /*verify whether the output path is existing*/    
    if outpath = "" then do:
          message "目录不允许为空,请重新输入!" view-as alert-box error.
          next-prompt outpath with frame a.
          undo,retry.
    end.
    
    testdir = outpath + "\testdir".
    OS-CREATE-DIR value(testdir).
    if OS-ERROR <> 0 then do:
          message "目录不存在,请重新输入!" view-as alert-box error.
          next-prompt outpath with frame a.
          undo,retry.
    end.
    OS-DELETE value(testdir).
     /*end verify the output path*/
    
    up_yn = yes.
   message "确认更新" view-as alert-box question buttons yes-no update up_yn.
   if not up_yn then undo,retry.
    
   /*search the template file*/   
/* lb01   if search("E:\Project\DCEC\Customization(6702C.08)\supplier schedule template.xlt") = ? then do:*/
  if search("\\dcecssy006\dcec_erp\kevin\template\supplier schedule template.xlt") = ? then do: 
      message "报表模板不存在!" view-as alert-box error.
      undo,retry.
   end.
      
    for each xxwk:
       delete xxwk.
    end. 
    
    for each pod_det where (pod_site >= site and pod_site <= site1)
                       and (pod_part >= part and pod_part <= part1) no-lock,
        each po_mstr where po_nbr = pod_nbr
                       and po_sched
                       and (po_vend >= vend and po_vend <= vend1) no-lock,
        each pt_mstr where pt_part = pod_part no-lock,
        each ptp_det where ptp_site = pod_site
                       and ptp_part = pt_part 
                       and (ptp_buyer >= buyer and ptp_buyer <= buyer1) no-lock,
        each schd_det where schd_type = 4
                     and schd_rlse_id = pod_curr_rlse_id[1] 
                       and schd_nbr = pod_nbr 
                       and schd_line = pod_line 
                       and schd_discr_qty > 0
                       and schd_date = start no-lock:              /*kevin*/
        /*break by ptp_buyer by po_vend:*/
        

        find first xxwk where xxwk.buyer = ptp_buyer
                         and xxwk.zzk = pod__chr01
                         and xxwk.ponbr = po_nbr
                     and xxwk.poline = pod_line    
                         and xxwk.part = pod_part no-error.
        if not available xxwk then do:
              create xxwk.
              assign xxwk.zzk = pod__chr01 
                    xxwk.buyer = ptp_buyer
                     xxwk.vend = po_vend
                     xxwk.part = pod_part
                     xxwk.desc1 = pt_desc2              /*chinese description*/
                     xxwk.qty_pack = pod_ord_mult
                     xxwk.loc = pod_loc
                     xxwk.ponbr = pod_nbr
                     xxwk.poline = pod_line
                     xxwk.site = pod_site                     
                     xxwk.stime = schd_time
                     xxwk.sftstock = ptp_sfty_stk
                     .       
			/* lb01-- 计算月度需求数量 
			本月到报表日期间的所有采购收货量 + 报表日到月底这段时间的MRP计划订货量。*/
			xxwk.mqty = 0.
			for each prh_hist no-lock where
			prh_rcp_date >= mstart and prh_rcp_date <= mend
			and prh_part = pod_part and prh_site = pod_site:
				xxwk.mqty = xxwk.mqty + prh_rcvd.
			end.
			for each mrp_det no-lock where
			mrp_site = pod_site and mrp_part = pod_part 
			and mrp_due_date >= today and mrp_due_date <= mend
			and index(mrp_type,"demand") > 0:
				xxwk.mqty = xxwk.mqty + mrp_qty.
			end.			
			
			/*供应商比例*/
			find last qad_wkfl where qad_key1 = "poa_det" and
      		qad_charfld[3] = pod_site and qad_charfld[2] = pod_part
      		and qad_charfld[1] = pod_nbr 
      		and qad_datefld[1] <= mend 
      		no-lock no-error.
      		xxwk.supperc = if available qad_wkfl then qad_decfld[1] else 0 .
			
			/*当月累计到货数量*/
			xxwk.cumrctqty = 0.
			for each prh_hist no-lock where
			prh_rcp_date >= mstart and prh_rcp_date <= mend
			and prh_part = pod_part and prh_site = pod_site
			and prh_nbr = pod_nbr:
				xxwk.cumrctqty = xxwk.cumrctqty + prh_rcvd.
			end.
			/*--lb01*/
        end.
        
        assign xxwk.qty_ord = xxwk.qty_ord + schd_discr_qty.
        
        
        
        find in_mstr where in_site = xxwk.site and in_part = xxwk.part no-lock no-error.
       if available in_mstr then assign xxwk.keeper = in__qadc01.
       
    end. /*for each pod_det, each ...*/
        

     /*Begin to create the PO　palnning order by vendor*/

     /* Create a New chExcel Application object */
     CREATE "Excel.Application" chExcelApplication.

     for each xxwk no-lock break by xxwk.buyer by xxwk.zzk by xxwk.vend by xxwk.part:
    
        i = i + 1.
        
       if first-of(xxwk.zzk) then do:

         /*Create a new workbook based on the template chExcel file */
/*         chExcelWorkbook = chExcelApplication:Workbooks:ADD("E:\Project\DCEC\Customization(6702C.08)\supplier schedule template.xlt").*/
         chExcelWorkbook = chExcelApplication:Workbooks:ADD("\\dcecssy006\dcec_erp\kevin\template\supplier schedule template.xlt").
         /* Set Excel Format Variable.*/
         iHeaderLine = 16.
         iLine = iHeaderLine + 1.
         iHeaderStartLine = 1.
         iTotalLine = iLine.
         iMAXPageLine = 43.
         iFooterLine = 43.
         iPageNum = 1.

         /*chExcelApplication:visible = true.*/
           
           i = 1.
           
           chExcelWorkbook:worksheets(1):cells(5,"AA"):value = start.
           chExcelWorkbook:worksheets(1):cells(7,"D"):value = xxwk.zzk.
           
           find ad_mstr where ad_addr = xxwk.zzk and ad_type = "company" no-lock no-error.
         if available ad_mstr then do:
             chExcelWorkbook:worksheets(1):cells(8,"D"):value = ad_name.
             chExcelWorkbook:worksheets(1):cells(9,"D"):value = ad_line1 + " / " + ad_zip.
             chExcelWorkbook:worksheets(1):cells(11,"D"):value = ad_attn.
             chExcelWorkbook:worksheets(1):cells(12,"D"):value = ad_phone.
             chExcelWorkbook:worksheets(1):cells(13,"D"):value = ad_fax.
             chExcelWorkbook:worksheets(1):cells(14,"D"):value = ad_line3.
         end.
                              
           find code_mstr where code_fldname = "ptp_buyer" and code_value = xxwk.buyer no-lock no-error.
           if available code_mstr then do:
               chExcelWorkbook:worksheets(1):cells(11,"AA"):value = 
                   substr(code_cmmt,index(code_cmmt,",") + 1,length(code_cmmt,"raw") - index(code_cmmt,","),"raw").
               
               find emp_mstr where emp_addr = xxwk.buyer no-lock no-error.
               if available emp_mstr then do:
                     chExcelWorkbook:worksheets(1):cells(12,"AA"):value = emp_bs_phone. /* + ",转: " + emp_ext.*/ /*kevin*/
                     chExcelWorkbook:worksheets(1):cells(14,"AA"):value = emp_line3.     
               end.
           end.                                            
           
           find usr_mstr where usr_userid = global_userid no-lock no-error.
           if available usr_mstr then do:
                 chExcelWorkbook:worksheets(1):cells(15,"J"):value = usr_name.
           end.
                      
       end. /*if first-of(xxwk.vend)*/

         if not first-of(xxwk.zzk) /*and not last-of(xxwk.zzk)*/ then do:
            chExcelWorkbook:worksheets(1):rows(itotalline):insert.
            chExcelWorkbook:worksheets(1):rows(itotalline + 1):copy.
            chExcelWorkbook:worksheets(1):cells(itotalline,1):select.
            chExcelWorkbook:worksheets(1):paste.
         end. 
         /*
         ELSE DO:
            IF LAST(xxwk.zzk) THEN DO:
                IF FIRST(xxwk.vend) THEN DO:
                    chExcelWorkbook:Worksheets(1):Rows(iTotalLine + 1):DELETE.
                END.  
                ELSE DO:
                    chExcelWorkbook:Worksheets(1):Rows(iTotalLine):DELETE.
                END.  
            END.
         END.           
        */

         IF iLine > iMAXPageLine THEN DO:
             DO iLoop1 = 1 TO 6:
                 chExcelWorkbook:Worksheets(1):Rows(iTotalLine):INSERT.
             END.
             chExcelWorkbook:Worksheets(1):Range("A" + string(iTotalLine + 8) + ":AG" +  string(iTotalLine + 13)):COPY.
             chExcelWorkbook:Worksheets(1):Cells(iTotalLine,1):SELECT.
             chExcelWorkbook:Worksheets(1):Paste.
             iTotalLine = iTotalLine + 6.
             iLine = iHeaderLine + 1.
         END.

           find first ad_mstr where (ad_type = "supplier" or ad_type = "vendor")
                              and ad_addr = xxwk.vend no-lock no-error.
           if available ad_mstr then do:
               assign xxwk.vendname = ad_name.
           end.
                          
        chExcelWorkbook:worksheets(1):cells(itotalline,"A"):value = i.
        chExcelWorkbook:worksheets(1):cells(itotalline,"B"):value = xxwk.part.
        chExcelWorkbook:worksheets(1):cells(itotalline,"F"):value = xxwk.desc1.
        chExcelWorkbook:worksheets(1):cells(itotalline,"L"):value = xxwk.vendname.
        chExcelWorkbook:worksheets(1):cells(itotalline,"S"):value = xxwk.vend.
        chExcelWorkbook:worksheets(1):cells(itotalline,"U"):value = xxwk.qty_ord.
        chExcelWorkbook:worksheets(1):cells(itotalline,"W"):value = xxwk.stime.
        chExcelWorkbook:worksheets(1):cells(itotalline,"Y"):value = xxwk.loc.
        chExcelWorkbook:worksheets(1):cells(itotalline,"AA"):value = xxwk.qty_pack.
        chExcelWorkbook:worksheets(1):cells(itotalline,"AC"):value = xxwk.keeper.
/*        chExcelWorkbook:worksheets(1):cells(itotalline,"AG"):value = xxwk.site.*/              /*kevin,12/2*/
        chExcelWorkbook:worksheets(1):cells(itotalline,"AE"):value = xxwk.ponbr.
        chExcelWorkbook:worksheets(1):cells(itotalline,"AG"):value = xxwk.poline.
        
        /*lb01--*/
        chExcelWorkbook:worksheets(1):cells(itotalline,"AH"):value = xxwk.sftstock.
        chExcelWorkbook:worksheets(1):cells(itotalline,"AI"):value = xxwk.mqty.
        chExcelWorkbook:worksheets(1):cells(itotalline,"AJ"):value = xxwk.supperc.
        chExcelWorkbook:worksheets(1):cells(itotalline,"AK"):value = xxwk.mqty * xxwk.supperc / 100.
        chExcelWorkbook:worksheets(1):cells(itotalline,"AL"):value = xxwk.cumrctqty.
        /*--lb01*/

        iline = iline + 1.
        itotalline = itotalline + 1.

        if last-of(xxwk.zzk) then do:

            DO iLoop1 = 1 TO iMAXPageLine - iLine + 1:
                chExcelWorkbook:Worksheets(1):Rows(iTotalLine):INSERT.
                chExcelWorkbook:Worksheets(1):Rows(iTotalLine + 1):COPY.
                chExcelWorkbook:Worksheets(1):Rows(iTotalLine):SELECT.
                chExcelWorkbook:Worksheets(1):Paste.
                iTotalLine = iTotalLine + 1.
            END.
        
            chExcelWorkbook:Worksheets(1):Rows(iTotalLine):DELETE.

           /* save the new chExcel data workbook file */ 
             chExcelWorkbook:SaveAs(outpath + "\" + string(year(start),"9999") 
                                   + string(month(start),"99") + string(day(start),"99") + "-"
                                   + xxwk.buyer + "-" + xxwk.zzk + ".xls",,,,,,1).
             chExcelWorkbook:CLOSE.
             RELEASE OBJECT chExcelWorkbook.
        end.
         
     end. /*for each xxwk*/ 

     /* close the Excel file */
     chExcelApplication:QUIT.
     /* release com - handles */
     RELEASE OBJECT chExcelApplication.
     /*End of creation*/                  
        
end. /*repeat*/
