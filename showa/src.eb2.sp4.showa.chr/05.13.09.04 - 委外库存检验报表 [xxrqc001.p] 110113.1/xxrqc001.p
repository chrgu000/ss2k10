/* ss - 091102.1 by: jack */
/* ss - 091110.1 by: jack */
/* ss - 091209.1 by: jack */
/* ss - 091216.1 by: jack */  /* 增加采购员显示 */
/* ss - 110106.1 by: jack */ /* 增加3 为空选择 */
/* ss - 110113.1 by: jack */  /* 3 选择*/

/*-Revision end--------------------------------------------------------------------------*/



/* DISPLAY TITLE */
/*
{mfdtitle.i "091110.1"}
*/
/*
{mfdtitle.i "091209.1"}
*/
/*
{mfdtitle.i "091216.1"}
*/
/*
{mfdtitle.i "110106.1"}
*/
{mfdtitle.i "110113.1"}

{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{apconsdf.i}

define var trdate like pc_start .
define var trdate1 like pc_start .
define var line like ln_line .
define var line1 like ln_line .
define var part like pc_part .
define var part1 like pc_part .
DEFINE var v_desc  like ln_desc .
DEFINE VAR v_desc1 LIKE pt_desc1 .
DEFINE VAR v_check AS CHAR FORMAT "x(1)" .  /* 1 为检验合格 0 为不合格 空为全部*/

define temp-table tt
FIELD tt_date LIKE tr_effdate
field tt_line like ln_line
field tt_desc like ln_desc
FIELD tt_part LIKE pt_part
FIELD tt_desc1 LIKE pt_desc1
FIELD tt_qty LIKE tr_qty_chg
FIELD tt_serial LIKE tr_serial
FIELD tt_status LIKE xxmqc_status 
FIELD tt_type AS CHAR  /* 收货或退货*/
.

/* ss - 091209.1 -b */
DEFINE VAR v_draw LIKE pt_draw .
/* ss - 091209.1 -e */
 /* ss - 091216.1 -b */
    DEFINE VAR v_buyer LIKE pt_buyer .
    /* ss - 091216.1 -e */

define buffer trhist for tr_hist .

form

   trdate           colon 16  
   trdate1        label {t001.i}  colon 45  
   
   line       colon 16  
   line1    label {t001.i}  colon 45  
   
   part           colon 16  
   part1         label {t001.i}  colon 45  
   /* ss - 110106.1 -b
     v_check LABEL "检验输出"   COLON 16 "1 查询检验合格 0 不合格 空为全部" 
    ss - 110106.1 -e */
    /* ss - 110106.1 -b */
    v_check LABEL "检验输出"   COLON 16 "1 查询检验合格 0 不合格 3 未检验 空为全部" 
    /* ss - 110106.1 -e */
    "备注：报表包括退货" COLON 16
 
   skip(1)        

skip(1)
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
   
    
    if trdate  = low_date   then trdate = ?.
    if trdate1 = hi_date then trdate1 = ? .
    if line1 = hi_char then line1 = "" .
    if part1   = hi_char   then part1  = "".
    
    
   

    UPDATE  trdate trdate1 line line1 part part1    v_check      with frame a.

    
    if trdate = ?   then trdate = low_date .
    if trdate1 = ? then trdate1 = hi_date .
    if line1 = "" then line1 = hi_char .
    if part1 = ""   then  part1  = hi_char .
    
    

    /* PRINTER SELECTION */
    /* OUTPUT DESTINATION SELECTION */
    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = " "
                &stream = " "
                &appendToFile = " "
                &streamedOutputToTerminal = " "
                &withBatchOption = "yes"
                &displayStatementType = 1
                &withCancelMessage = "yes"
                &pageBottomMargin = 6
                &withEmail = "yes"
                &withWinprint = "yes"
                &defineVariables = "yes"}
mainloop: 
do on error undo, return error on endkey undo, return error:                    

for each tt :
delete tt .
end .



PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname,1,LENGTH(execname) - 2) SKIP.
PUT UNFORMATTED "#def :end" SKIP.

export delimiter ";" "生产线" "生产线描述"  "入库日期"  "零件"  "零件说明"  "图纸图号" "数量" "批号" "检验状态" "类型" /* ss - 091216.1 -b */ "采购员" /* ss - 091216.1 -e */ . 

        
          for each tr_hist USE-INDEX   tr_eff_trnbr  no-lock where (tr_effdate >= trdate and tr_effdate <= trdate1) 
              and ( tr_type = "rct-wo"  )  
               and (tr_part >= part and tr_part <= part1)  :
           
              FOR FIRST wo_mstr WHERE wo_lot = tr_lot AND (wo_line >= LINE AND wo_line <= line1) NO-LOCK:
              
               
               /* ss - 091110.1 -b */
                  IF v_check <> "" THEN DO:
                      /* ss - 110106.1 -b */
                      IF v_check <> "3"  THEN DO:
                     
                      /* ss - 110106.1 -e */
                          FIND FIRST xxmqc_det WHERE xxmqc_rcp_date = tr_effdate AND xxmqc_vend = wo_line AND xxmqc_part = tr_part AND xxmqc_serial  = tr_serial  AND xxmqc_char[1] = "consignd"
                       AND  xxmqc_status = v_check  NO-LOCK NO-ERROR .
                      IF AVAILABLE xxmqc_det  THEN DO:
                                    create tt .
                		      assign
                                     tt_date = tr_effdate
                		             tt_line = wo_line
                                     tt_part = tr_part
                    			     tt_qty = tr_qty_chg
                                     tt_status = xxmqc_status
                                     tt_serial = tr_serial
                                    .
                                   IF tr_qty_chg > 0 THEN
                                       tt_type = "收货"    .
                                   ELSE 
                                       tt_type = "退货" .
                         END.
                     /* ss - 110106.1 -b */
                      END.
                      ELSE DO:
                        FIND FIRST xxmqc_det WHERE xxmqc_rcp_date = tr_effdate AND xxmqc_vend = wo_line AND xxmqc_part = tr_part AND xxmqc_serial  = tr_serial  AND xxmqc_char[1] = "consignd"
                       /* ss - 110113.1 -b AND xxmqc_status = "" ss - 110113.1 -e */  NO-LOCK NO-ERROR .
                        IF AVAILABLE xxmqc_det /* ss - 110113.1 -b */ AND xxmqc_status = "" /* ss - 110113.1 -e */  THEN DO:
                                    create tt .
                		      assign
                                     tt_date = tr_effdate
                		             tt_line = wo_line
                                     tt_part = tr_part
                    			     tt_qty = tr_qty_chg
                                     tt_status = xxmqc_status
                                     tt_serial = tr_serial
                                    .
                                   IF tr_qty_chg > 0 THEN
                                       tt_type = "收货"    .
                                   ELSE 
                                       tt_type = "退货" .
                         END.
                         ELSE /* ss - 110113.1 -b */ IF NOT AVAILABLE xxmqc_det THEN /* ss - 110113.1 -e */ DO:
                             create tt .
            		      assign
            		             tt_date = tr_effdate
            		             tt_line = wo_line
                                 tt_part = tr_part
                			     tt_qty = tr_qty_chg
                                 tt_status = ""
                                tt_serial = tr_serial
                                .
                               IF tr_qty_chg > 0 THEN
                                   tt_type = "收货"    .
                               ELSE 
                                   tt_type = "退货" .
            
                           END.

                      END.
                     /* ss - 110106.1 -e */
                  
                 END.
                  
                 ELSE DO:
               /* ss - 091110.1 -e */
               FIND FIRST xxmqc_det WHERE xxmqc_rcp_date = tr_effdate AND xxmqc_vend = wo_line AND xxmqc_part = tr_part AND xxmqc_serial  = tr_serial  AND xxmqc_char[1] = "consignd"
                    NO-LOCK NO-ERROR .
                  IF AVAILABLE xxmqc_det  THEN DO:
                            create tt .
        		      assign
                             tt_date = tr_effdate
        		             tt_line = wo_line
                             tt_part = tr_part
            			     tt_qty = tr_qty_chg
                             tt_status = xxmqc_status
                             tt_serial = tr_serial
                            .
                           IF tr_qty_chg > 0 THEN
                               tt_type = "收货"    .
                           ELSE 
                               tt_type = "退货" .
               END.
               /* ss - 091019.1 -b */
              ELSE DO:
                 create tt .
		      assign
		            tt_date = tr_effdate
		             tt_line = wo_line
                     tt_part = tr_part
    			     tt_qty = tr_qty_chg
                     tt_status = ""
                    tt_serial = tr_serial
                    .
                   IF tr_qty_chg > 0 THEN
                       tt_type = "收货"    .
                   ELSE 
                       tt_type = "退货" .

               END.
              /* ss - 091110.1 -b */
              END.  /* v_check = "" */
              /* ss - 091110.1 -e */
              END.  /* wo_mstr */
          
              END.  /* tr_hist */
		  
    

       for each tt no-lock where tt_line <> "" break by  tt_line by tt_part by tt_date :
	     accumulate tt_qty (total by tt_part) .
	

        FIND FIRST ln_mstr WHERE ln_line = tt_line NO-LOCK NO-ERROR .
                 IF AVAILABLE ln_mstr THEN 
                     v_desc = ln_desc .
                 ELSE 
                     v_desc = "" .
        FIND FIRST pt_mstr WHERE pt_part = tt_part NO-LOCK NO-ERROR .
        IF AVAILABLE pt_mstr THEN DO:
     
                  v_desc1 = pt_desc1 .
               /* ss - 091209.1 -b */
               v_draw = pt_draw .
                /* ss - 091216.1 -b */
               v_buyer = pt_buyer
               /* ss - 091216.1 -e */.
        END.
               /* ss - 091209.1 -e */
        ELSE DO:
              v_desc1 = "" .
               /* ss - 091209.1 -b */
               v_draw = "" .
                /* ss - 091216.1 -b */
               v_buyer = ""
               /* ss - 091216.1 -e */ .
        END.
               /* ss - 091209.1 -e */
	
	   export delimiter ";" tt_line v_desc   tt_date  tt_part v_desc1 v_draw   tt_qty  tt_serial  tt_status  tt_type /* ss - 091216.1 -b */ v_buyer /* ss - 091216.1 -e */ .
	  
	  if last-of(tt_part) then do:
	   export delimiter ";"  "小计 "  "" ""  "" ""  ""  (accumulate total by tt_part tt_qty ) "" "" "" /* ss - 091216.1 -b */ "" /* ss - 091216.1 -e */.
	  
	  end .
	  
	   {mfrpchk.i}
	  
	end .


end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}


    
