/* BY: Micho Yang      DATE: 07/31/06     ECO: *SS - 20060731.1*       */
/* SS - 090806.1 By: Neil Gao */

/* SS 090806.1 - B */
/*
增加删除记录的功能,
同步修改7.1.1 的记录
*/
/* SS 090806.1 - E */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

DEF VAR v_type LIKE xxsod_type.
DEF VAR v_cust LIKE xxsod_cust.
DEF VAR v_cust1 LIKE xxsod_cust.
DEF VAR v_project LIKE xxsod_project .
DEF VAR v_project1 LIKE xxsod_project .
DEF VAR v_vend LIKE xxsod_vend.
DEF VAR v_vend1 LIKE xxsod_vend.
DEF VAR v_addr LIKE xxsod_addr.
DEF VAR v_addr1 LIKE xxsod_addr.
DEF VAR v_part LIKE xxsod_part.
DEF VAR v_part1 LIKE xxsod_part .
DEF VAR v_due_date AS DATE .
DEF VAR v_due_date1 AS DATE .
DEF VAR v_invnbr LIKE xxsod_invnbr .
DEF VAR v_invnbr1 LIKE xxsod_invnbr .
DEF VAR v_week LIKE xxsod_week .
DEF VAR v_week1 LIKE xxsod_week.
/* SS 090806.1 - B */
define var yn_del as logical.
define var tnbr1 as char.
define variable tmonth as char.
define variable tpart like pt_part.
define var v_tax LIKE pt_taxable .
define var v_tax1 LIKE pt_taxable .
define var tqty01 as deci.
define var fn_i as char init "xxinsorpn1".
/* SS 090806.1 - E */

         /* DISPLAY TITLE */
/* SS 090806.1 - B */
/*
         {mfdtitle.i "b+ "} /*L00M*/
*/
         {mfdtitle.i "090806.1"} /*L00M*/
/* SS 090806.1 - E */


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/

    v_type       COLON 15    
    v_cust       COLON 15    v_cust1     label {t001.i} COLON 49 SKIP
    v_project    COLON 15    v_project1  LABEL {t001.i} COLON 49 SKIP
    v_vend       COLON 15    v_vend1     LABEL {t001.i} COLON 49 SKIP
    v_addr       COLON 15    v_addr1     LABEL {t001.i} COLON 49 SKIP
    v_part       COLON 15    v_part1     LABEL {t001.i} COLON 49 SKIP
    v_due_date   COLON 15    v_due_date1 LABEL {t001.i} COLON 49 SKIP
    v_invnbr     COLON 15    v_invnbr1   LABEL {t001.i} COLON 49 SKIP
    v_week       COLON 15    v_week1     LABEL {t001.i} COLON 49 SKIP
/* SS 090806.1 - B */
		yn_del				colon 15 label "确认是否删除"
/* SS 090806.1 - B */
          SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " Selection Criteria "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

 /* SET EXTERNAL LABELS */
 setFrameLabels(frame a:handle).


         /* REPORT BLOCK */

         {wbrp01.i}

/*GUI*/ {mfguirpa.i true "printer" 132 " " " " " "  }

        PROCEDURE p-enable-ui:
            
            IF v_cust1 = hi_char THEN v_cust1 = "".
            IF v_project1 = hi_char THEN v_project1 = "".
            IF v_vend1 = hi_char THEN v_vend1 = "".
            IF v_addr1 = hi_char THEN v_addr1 = "".
            IF v_part1 = hi_char THEN v_part1 = "".
            IF v_due_date = low_date THEN v_due_date = ? .
            IF v_due_date1 = hi_date THEN v_due_date1 = ?.
            IF v_invnbr1 = hi_char THEN v_invnbr1 = "" .

         if c-application-mode <> "WEB" then
         
         run p-action-fields (input "display").
         run p-action-fields (input "enable").
        end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/


        PROCEDURE p-report-quote:
/* SS 090806.1 - B */
/*
            {wbrp06.i &command = update &fields = " 
                      v_type v_cust v_cust1 v_project v_project1 
                      v_vend v_vend1 v_addr v_addr1 v_part v_part1
                      v_due_date v_due_date1 v_invnbr v_invnbr1 
                      v_week v_week1 
             " &frm = "a"}
*/
            {wbrp06.i &command = update &fields = " 
                      v_type v_cust v_cust1 v_project v_project1 
                      v_vend v_vend1 v_addr v_addr1 v_part v_part1
                      v_due_date v_due_date1 v_invnbr v_invnbr1 
                      v_week v_week1 yn_del
             " &frm = "a"}
/* SS 090806.1 - E */

            if (c-application-mode <> 'web') or
               (c-application-mode = 'web' and
               (c-web-request begins 'data')) then do:

               bcdparm = "".
               {mfquoter.i v_type  }
               {mfquoter.i v_cust  }
               {mfquoter.i v_cust1  }
               {mfquoter.i v_project  }
               {mfquoter.i v_project1  }
               {mfquoter.i v_vend  }
               {mfquoter.i v_vend1  }
               {mfquoter.i v_addr  }
               {mfquoter.i v_addr1  }
               {mfquoter.i v_part }
               {mfquoter.i v_part1 }
               {mfquoter.i v_due_date }
               {mfquoter.i v_due_date1 }
               {mfquoter.i v_invnbr }
               {mfquoter.i v_invnbr1 }
               {mfquoter.i v_week }
               {mfquoter.i v_week1 }
/* SS 090806.1 - B */
								{mfquoter.i yn_del }
/* SS 090806.1 - E */
            IF v_cust1 = "" THEN v_cust1 = hi_char.
            IF v_project1 = "" THEN v_project1 = hi_char.
            IF v_vend1 = "" THEN v_vend1 = hi_char.
            IF v_addr1 = "" THEN v_addr1 = hi_char.
            IF v_part1 = "" THEN v_part1 = hi_char.
            IF v_due_date = ? THEN v_due_date = low_date.
            IF v_due_date1 = ? THEN v_due_date1 = hi_date .
            IF v_invnbr1 = "" THEN v_invnbr1 = hi_char.

/*L03V*/    end.  /* if (c-application-mode <> 'web') ... */

        END PROCEDURE .

            
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:

        {mfphead.i}

         /* EXPORT DELIMITER ";" "类型" "客户" "项目"	"顺序号"	"供应商号"	"收货地点"	"零件号"	"零件颜色"	"零件名称"	"计划代码"	"传票日期"	"传票时间"	"订货数量"	"传票号码"  
                                 "版本号" 	"周次"	"分类"	"交货规则"	"备注"	"备注1"  "送货日期" "送货时间" .*/
            
            put unformatted "类型   客户     项目    顺序号  供应商号  收货地点        零件号        零件颜色            零件名称       计划代码  送货日期   送货时间      订货数量            传票号码      版本号    周次      分类       交货规则              备注                 备注1       传票日期  传票时间       传票数量   " SKIP.
            put unformatted "---- -------- -------- ------- --------- --------- -------------------- --------- ------------------------ --------- ---------- --------- ---------------- -------------------- ------ ---------- -------- ---------------- -------------------- -------------------- --------- --------- ----------------" SKIP .
            FOR EACH xxsod_det NO-LOCK WHERE xxsod_cust >= v_cust
                                         AND xxsod_cust <= v_cust1
                                         AND xxsod_project >= v_project
                                         AND xxsod_project <= v_project1
                                         AND xxsod_vend >= v_vend
                                         AND xxsod_vend <= v_vend1
                                         AND xxsod_addr >= v_addr
                                         AND xxsod_addr <= v_addr1
                                         AND xxsod_part >= v_part
                                         AND xxsod_part <= v_part1 
                                         AND date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) >= v_due_date
                                         AND date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) <= v_due_date1
                                         AND xxsod_invnbr >= v_invnbr 
                                         AND xxsod_invnbr <= v_invnbr1
                                         AND (xxsod_week >= v_week OR v_week = 0)
                                         AND (xxsod_week <= v_week1 OR v_week1 = 0) BY xxsod_due_date1 BY xxsod_due_time1 BY xxsod_invnbr :
                PUT UNFORMATTED xxsod_type AT 1.
                PUT UNFORMATTED xxsod_cust AT 6.
                PUT UNFORMATTED xxsod_project AT 15.
                PUT UNFORMATTED xxsod_item AT 24 .
                PUT UNFORMATTED xxsod_vend AT 32 .
                PUT UNFORMATTED xxsod_addr AT 42 .
                PUT UNFORMATTED xxsod_part AT 52 .
                PUT UNFORMATTED xxsod_color AT 73 .
                PUT UNFORMATTED xxsod_desc AT 83 .
                PUT UNFORMATTED xxsod_plan AT 108 .
                PUT UNFORMATTED xxsod_due_date1 AT 118.
                PUT UNFORMATTED xxsod_due_time1 AT 129.
                PUT UNFORMATTED xxsod_qty_ord TO 154 .
                PUT UNFORMATTED xxsod_invnbr AT 156 .
                PUT UNFORMATTED xxsod_rev AT 177.
                PUT UNFORMATTED xxsod_week TO 193.
                PUT UNFORMATTED xxsod_category AT 195.
                PUT UNFORMATTED xxsod_ship AT 204.
                PUT UNFORMATTED xxsod_rmks AT 221.
                PUT UNFORMATTED xxsod_rmks1 AT 242.
                PUT UNFORMATTED xxsod_due_date AT 263.
                PUT UNFORMATTED xxsod_due_time  AT 273.
                PUT UNFORMATTED xxsod__chr02 TO 298.
                PUT SKIP.

            END.

/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
				
/* SS 090806.1 - B */
				yn_del = no.
				message "是否删除记录" update yn_del.
				if yn_del then do on error undo,retry:
					FOR EACH xxsod_det NO-LOCK WHERE xxsod_cust >= v_cust
                                         AND xxsod_cust <= v_cust1
                                         AND xxsod_project >= v_project
                                         AND xxsod_project <= v_project1
                                         AND xxsod_vend >= v_vend
                                         AND xxsod_vend <= v_vend1
                                         AND xxsod_addr >= v_addr
                                         AND xxsod_addr <= v_addr1
                                         AND xxsod_part >= v_part
                                         AND xxsod_part <= v_part1 
                                         AND date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) >= v_due_date
                                         AND date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) <= v_due_date1
                                         AND xxsod_invnbr >= v_invnbr 
                                         AND xxsod_invnbr <= v_invnbr1
                                         AND (xxsod_week >= v_week OR v_week = 0)
                                         AND (xxsod_week <= v_week1 OR v_week1 = 0) :
           
           
           		find first cm_mstr where cm_addr = xxsod_cust no-lock no-error.
							if not avail cm_mstr then next.
           		find first cp_mstr where cp_cust = xxsod_cust and cp_cust_part = xxsod_part no-lock no-error.
							if not avail cp_mstr then do:
								message "错误: 客户零件不存在".
								leave.
							end.
							else tpart = cp_part.
							FIND FIRST pt_mstr WHERE pt_part = tpart no-lock no-error.
  						IF AVAIL pt_mstr THEN v_tax = pt_taxable .
  						find first ad_mstr where ad_addr = xxsod_cust no-lock no-error.
  						if avail ad_mstr then v_tax1 = ad_taxable.
							IF SUBSTRING(xxsod_due_date1,6,2) = "10" THEN tmonth = "A".
							else if SUBSTRING(xxsod_due_date1,6,2) = "11" then tmonth = "B".
							else if SUBSTRING(xxsod_due_date1,6,2) = "12" then tmonth = "C".
							else tmonth = SUBSTRING(xxsod_due_date1,7,1).
							tnbr1  = SUBSTRING(cm_sort,1,2) + substring(xxsod_type,1,1) + substring(xxsod_due_date1,4,1)
									+ tmonth + SUBSTRING(xxsod_project,1,1) + string(int(substring(xxsod_due_date1,9,2))).
							find first sod_det where sod_nbr = tnbr1 and sod_part = tpart no-error.
							if not avail sod_det then do:
								message "错误: 订单号不存在" tnbr1. 
								undo,retry.
							end.
           		tqty01 = sod_qty_ord.
           		if sod_qty_ord = xxsod_qty_ord then do:
           			if sod_qty_inv = 0 and sod_qty_ship = 0 then do:
           				for each cmt_det where cmt_indx = sod_det.sod_cmtindx exclusive-lock:
      				  	 delete cmt_det.
   								end.
   								for each lad_det where lad_dataset = "sod_det" and lad_nbr = sod_nbr and lad_line = string(sod_det.sod_line) exclusive-lock:
     								 find ld_det where ld_site = lad_site and ld_loc  = lad_loc and ld_lot  = lad_lot and ld_ref  = lad_ref
                    	and ld_part = lad_part exclusive-lock no-error.
      							if available ld_det then ld_qty_all = ld_qty_all - (lad_qty_all + lad_qty_pick).
      								delete lad_det.
   								end.
   								for each tx2d_det where tx2d_tr_type = "41" and tx2d_ref = sod_nbr and tx2d_line = sod_line exclusive-lock:
      							delete tx2d_det.
   								end.
   								for each sodr_det exclusive-lock   where sodr_nbr  = sod_nbr and sodr_line = sod_line:
   									delete sodr_det.
									end.
									delete sod_det.
           			end.
           			else do:
           				message "错误: 不能删除订单" tnbr1.
           			end.
           		end. /* if sod_qty_ord = xxsod_qty_ord */
           		else do:
           			OUTPUT TO VALUE(fn_i + ".inp").
								put unformat """" + trim(tnbr1) + """" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip.
								put unformat string(sod_line) skip.
								put "-" skip.
								put unformat string(sod_qty_ord - xxsod_qty_ord) skip.
								put "-" skip.
								put "-" skip.
								IF v_tax = YES AND v_tax1 = YES THEN DO:
        					put "-" skip.
        				END.
								put "." skip.
								put "." skip.
								put "-" skip.
								put "-" skip.
								put "." skip.
								OUTPUT CLOSE .
								
								INPUT FROM VALUE(fn_i + ".inp") .
        				OUTPUT TO VALUE(fn_i + ".cim") .
        				batchrun = YES.
        				{gprun.i ""sosomt.p""}
       					batchrun = NO.
        				INPUT CLOSE .
        				OUTPUT CLOSE .
              	
								find first sod_det where sod_nbr = tnbr1 and sod_part = tpart no-lock no-error.
								if not avail sod_det or sod_qty_ord <> tqty01 - xxsod_qty_ord then do:
									message "错误:更新失败".
									undo ,leave.
								end.
								unix silent value("del " + trim(fn_i)  + ".inp").
								unix silent value("del " + trim(fn_i)  + ".cim").

           		end.
           end. /* for each */
				end. /* if yn_del */
/* SS 090806.1 - E */				
				
END.
                 {wbrp04.i &frame-spec = a}

END PROCEDURE.

/* SS 090806.1 - B */
/*
/*GUI*/ {mfguirpb.i &flds=" v_type v_cust v_cust1 v_project v_project1 
                      v_vend v_vend1 v_addr v_addr1 v_part v_part1
                      v_due_date v_due_date1 v_invnbr v_invnbr1 
                      v_week v_week1 " } 

*/
/*GUI*/ {mfguirpb.i &flds=" v_type v_cust v_cust1 v_project v_project1 
                      v_vend v_vend1 v_addr v_addr1 v_part v_part1
                      v_due_date v_due_date1 v_invnbr v_invnbr1 
                      v_week v_week1 yn_del " } 

/* SS 090806.1 - E */
    
    /* Drive the Report */
