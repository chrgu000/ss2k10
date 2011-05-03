   /* 说明：
   ** 2R部分，销售只有月度量，无法精确到哪一天需要多少的量，导致需求是月度的需求量，
   ** 例如2日需求2000，如果设定某供应商是5日到货，则此批量会提前到上月2日到货，导致订货量太大，
   ** 因为需求不精确，因此，预示量算法采用1～31日的算法反而合理些。
   ** 下月预示量、下下月预示量按原始Mage的算法计算。 */

   {ParseParam.i} 

   DEFINE VARIABLE  startdate AS DATE.
   DEFINE VARIABLE  enddate AS DATE.
   DEFINE VARIABLE  nextdate AS DATE.
   DEFINE VARIABLE  next2date AS DATE.
   DEFINE VARIABLE  ponbr AS CHARACTER FORMAT "x(8)".
   DEFINE VARIABLE  vend AS CHARACTER FORMAT "x(18)".
   DEFINE VARIABLE  planer AS CHARACTER FORMAT "x(18)".
   DEF VAR str_due_date AS CHAR.
   DEF VAR buyer as char format "x(8)".
   DEF VAR st as char format "x(8)".
   DEF VAR adddate AS DATE.
   DEF VAR onedate AS DATE.
   DEF VAR mm as int.
   DEF VAR yy as int.
   DEF VAR i AS INTEGER.
   DEF VAR m AS INTEGER.
   DEF VAR c AS integer.
   DEF VAR a AS integer.
   DEF VAR n AS INTEGER format ">>>9" label "整理前".
   DEF VAR n1 AS CHAR.
   def var np as char.         /*采购单变量*/
   DEF VAR ch AS CHAR.     /* 全部预示量*/

   DEFINE TEMP-TABLE npod_det 
         FIELD  npod_vend  LIKE  po_vend
         FIELD  npod_name LIKE ad_name FORMAT "X(56)"
         FIELD  npod_attn LIKE ad_attn
         FIELD  npod_fax  LIKE ad_fax
         FIELD  npod_part LIKE pt_part
         FIELD  npod_desc1 LIKE pt_desc1
         FIELD  npod_desc2 LIKE pt_desc2
         FIELD  npod_qty   LIKE pod_qty_ord
         FIELD  npod_next   LIKE pod_qty_ord
         FIELD  npod_next2   LIKE pod_qty_ord
         FIELD  npod_due_date LIKE pod_due_date
         FIELD  npod_um     LIKE pod_um
	 FIELD  npod_nbr   like pod_nbr
         FIELD  npod_draw  LIKE pt_draw
	 FIELD  npod_buyer LIKE pt_buyer
	 FIELD  npod_line LIKE pod_line
	 FIELD  npod_st LIKE pt_status
	 FIELD  npod_output as int
         INDEX npod is UNIQUE  primary npod_vend npod_part npod_due_date  .
DEF TEMP-TABLE empty1
     field empty1_item  as integer label "序号" 
     field empty1_part like mrp_part LABEL "零件图号"
     field empty1_duedate like mrp_due_date LABEL "采购日期"
     field empty1_qty like mrp_qty       LABEL "采购数量"
     FIELD empty1_t LIKE pt_ord_per     LABEL "订货周期"
     field empty1_remark like vd_rmks FORMAT "x(7)"      LABEL "备注"
     field empty1_addr like vd_addr label  "供应商代码"
     field empty1_sort like vd_sort label "客户排序"
     field empty1_yn as integer                LABEL "送货日期(Y/N)"
     INDEX empty1 is UNIQUE  primary empty1_part  empty1_duedate empty1_qty empty1_item.
DEF TEMP-TABLE empty2
    field empty2_ord_on as char  label "采购单号" 
    field empty2_addr like vd_addr label "供应商代码"
    field empty2_part like mrp_part LABEL "零件图号"
    field empty2_qty like mrp_qty       LABEL "采购数量"
    field empty2_duedate like mrp_due_date LABEL "采购日期"
    field empty2_month as integer label "月份"

    INDEX empty2 is UNIQUE  primary empty2_part empty2_duedate /*empty2_qty */. 

FUNCTION ok_date RETURNS INTEGER  (INPUT one_date AS date, vend_str AS CHAR) FORWARD.
/* 
   startdate = ToDate(GetParam("startdate")).
   enddate  = todate(GetParam("enddate")).
   nextdate = ToDate(GetParam("nextdate")).
   next2date  = todate(GetParam("next2date")). 

   planer = GetParam("planer").  

   vend = GetParam("vend").

ponbr = "P0803HD4".
*/

   ponbr = GetParam("ponbr").
   ponbr = upper(ponbr).
   ch = GetParam("choice").
   ch = upper(ch).

/* 从订单号码查找对应日期onedate、计划员buyer、供应商vend */
Find first pod_det WHERE pod_nbr = ponbr NO-error.
IF AVAILABLE pod_det  THEN 
   do:
     onedate = pod_due_date.
     Find first pt_mstr WHERE pt_part = pod_part.
     IF AVAILABLE pt_mstr  THEN buyer = pt_buyer.
     Find first po_mstr WHERE po_nbr = pod_nbr.
     IF AVAILABLE po_mstr  THEN vend = po_vend.
   end.
 
   /* 某月第一天 */
   mm = MONTH(onedate) .
   yy = YEAR(onedate).
   startdate = DATE(STRING( yy ) +  '/' + STRING( mm ) + '/01') .
   /* 某月末最后一天 */
   mm = mm + 1.
   IF mm > 12 THEN do:
       mm = mm - 12.
       yy = yy + 1.
   END.
   enddate = DATE(STRING( yy ) +  '/' + STRING( mm ) + '/01') - 1.
   /* 下月末最后一天 */
   mm = mm + 1.
   IF mm > 12 THEN do:
       mm = mm - 12.
       yy = yy + 1.
   END.
   nextdate = DATE(STRING( yy ) +  '/' + STRING( mm ) + '/01') - 1.
   /* 下下月末最后一天 */
   mm = mm + 1.
   IF mm > 12 THEN do:
       mm = mm - 12.
       yy = yy + 1.
   END.
   next2date = DATE(STRING( yy ) +  '/' + STRING( mm ) + '/01') - 1.
   /* mm为订单号码对应第一批的月份，即“mm”月订单 */
   mm = MONTH(onedate) .

OUTPUT TO "C:\qadguicli\bicallprogress\zhpod-2r.txt".
/* OUTPUT TXT FILE */
       
/* DEFINE FIELD TYPE bi */

PUT  "#define column1 as char[10] "
     "~n#define column2 as char[10] "
     "~n#define column3 as char[40] "
     "~n#define column4 as char[24] "
     "~n#define column5 as char[16] "
     "~n#define column6 as char[18] "
     "~n#define column7 as char[24] "
     "~n#define column8 as char[24] "
     "~n#define column9 as char[10] " 
     "~n#define column10 as number "
     "~n#define column11 as char[2] "
     "~n#define column12 as number "
     "~n#define column13 as number "
     "~n#define column14 as char[18] "
     "~n#define column15 as char[18] "
     "~n#define column16 as char[18] "
     "~n#define column17 as char[10] "
     "~n#define column18 as number "
     
     "~n" .  /* Insert a new line*/

/* DEFINE INQURY FILE  LABEL NAME ~t  IS TAB KEY */
   PUT "pt_status "  "~t"
       "Vend"   "~t"   
       "Name              "   "~t" 
       "Attn"  "~t"
       "Fax"  "~t"
       "PARENT_PART"   "~t"   
       "PARENT_DESC1"   "~t"   
       "PARENT_DESC2"   "~t"   
       "Due_Date"    "~t"  
       "Qty "   "~t"  
       "UM"    "~t"   
       "Next_Qty"    "~t"  
       "Next2_Qty"   "~t"
       "flag"   "~t"
       "PO_NUMber   "  "~t"
       "pt_draw      "  "~t"
       "pt_buyer     "  "~t"
       "po_line " 
       SKIP(0) .  
       
FOR EACH npod_det:
    DELETE npod_det.
END.

/* 从 pod_det 表提取当月订货量信息                              */
/* 只要有订货量，即使零件状态为“RD”也不影响订货量和预示量的输出 */
/* 取消选择条件，只要求输入订单号po_nbr =========================================
FOR EACH pod_det WHERE pod_due_date >= startdate AND pod_due_date <= enddate AND
    (pod_nbr = ponbr OR ponbr = "")  NO-LOCK,
    EACH po_mstr WHERE po_nbr = pod_nbr AND (po_vend = vend OR vend = "") NO-LOCK,
    EACH pt_mstr WHERE pt_part = pod_part and pt_buyer = buyer NO-LOCK:
================================================================================= */
FOR EACH pod_det WHERE pod_nbr = ponbr NO-LOCK,
    EACH po_mstr WHERE po_nbr = pod_nbr NO-LOCK,
    EACH pt_mstr WHERE pt_part = pod_part and pt_buyer = buyer NO-LOCK:

    FIND FIRST npod_det WHERE npod_part = pod_part AND npod_vend = po_vend 
        AND npod_due_date = pod_due_date NO-ERROR.
     IF AVAILABLE npod_det  THEN npod_qty = npod_qty + pod_qty_ord. 
           
           ELSE DO: 
               CREATE npod_det.
               FIND FIRST ad_mstr WHERE ad_addr = po_vend NO-LOCK NO-ERROR.
               
                   ASSIGN npod_vend = ad_addr 
                          npod_name = ad_name + ad_line3
                          npod_attn = ad_attn
                          npod_fax  = ad_fax
                          npod_part = pt_part
                          npod_desc1 = pt_desc1
                          npod_desc2 = pt_desc2
                          npod_qty = pod_qty_ord
                          npod_due_date = pod_due_date
                          npod_um = pt_um
			  npod_nbr = pod_nbr
                          npod_draw = pt_draw
			  npod_buyer = pt_buyer
			  npod_st = pt_status
			  npod_line = pod_line
			  npod_output = 1.

                   FIND FIRST npod_det WHERE npod_vend = ad_addr 
                       AND npod_part = pt_part AND npod_due_date = 12/12/12  NO-LOCK NO-ERROR.
                   IF NOT AVAILABLE npod_det THEN DO:
                  

                   CREATE npod_det.
                                    ASSIGN  npod_vend = ad_addr 
                                            npod_name = ad_name + ad_line3
                                            npod_attn = ad_attn
                                            npod_fax  = ad_fax
                                            npod_part = pt_part
                                            npod_desc1 = pt_desc1
                                            npod_desc2 = pt_desc2
                                            npod_due_date = 12/12/12
                                            npod_um = pt_um
                                            npod_nbr = ponbr
                                            npod_draw = pt_draw
					    npod_buyer = pt_buyer
					    npod_st = pt_status
					    npod_output = 1.
                            END. 
              
           END.
END.

/* 为防止漏订货，凡是在1.4.3零件状态为“AC”和“SP”的零件，全部显示预示栏 */

 For each pt_mstr where ( pt_status = "AC" or pt_status = "SP") and pt_buyer = buyer and pt_vend = vend no-lock:
    FIND FIRST npod_det WHERE npod_part = pt_part AND npod_due_date = 12/12/12  NO-LOCK NO-ERROR.
    IF NOT AVAILABLE npod_det THEN 
    DO:
       CREATE npod_det.
       FIND FIRST ad_mstr WHERE ad_addr = vend NO-LOCK NO-ERROR.
            ASSIGN  npod_vend = ad_addr 
                    npod_name = ad_name + ad_line3
                    npod_attn = ad_attn
                    npod_fax  = ad_fax
                    npod_part = pt_part
                    npod_desc1 = pt_desc1
                    npod_desc2 = pt_desc2
                    npod_due_date = 12/12/12
                    npod_um = pt_um
                    npod_nbr = ponbr
                    npod_draw = pt_draw
		    npod_buyer = pt_buyer
		    npod_st = pt_status
		    npod_output = 0.
     END. 
 end.


/* ========================================================================================================== */
/* 计算下月和下下月预示量 */
FIND FIRST po_mstr WHERE po_nbr = ponbr NO-LOCK NO-ERROR.
  IF AVAILABLE po_mstr THEN DO:
      FOR EACH wo_mstr WHERE wo_status = "P" AND  wo_due_date > enddate 
           AND wo_due_date < next2date NO-LOCK,
           EACH pt_mstr WHERE pt_part = wo_part and pt_buyer = buyer AND pt_pm_code = "p" 
           AND pt_vend =  po_vend NO-LOCK:
           FIND npod_det WHERE npod_vend = pt_vend AND npod_part = wo_part
               AND npod_due_date = 12/12/12  NO-ERROR.
           IF AVAILABLE npod_det  THEN DO:
               IF wo_due_date <= nextdate  THEN npod_next = npod_next + wo_qty_ord.
               ELSE npod_next2 = npod_next2 + wo_qty_ord.
           END.
           ELSE DO: 
               CREATE npod_det.
               FIND FIRST ad_mstr WHERE ad_addr = pt_vend NO-LOCK NO-ERROR.
               IF AVAILABLE ad_mstr THEN
                   ASSIGN npod_vend = ad_addr 
                          npod_name = ad_name + ad_line3
                   npod_attn = ad_attn
                   npod_fax  = ad_fax
                   npod_part = pt_part
                   npod_desc1 = pt_desc1
                   npod_desc2 = pt_desc2
                   npod_due_date = 12/12/12
                   npod_um = pt_um
                   npod_nbr = ponbr
                   npod_draw = pt_draw
		   npod_buyer = pt_buyer.
               ELSE ASSIGN npod_vend = ""
                          npod_name = ""
                   npod_attn = ""
                   npod_fax  = ""
                   npod_part = pt_part
                   npod_desc1 = pt_desc1
                   npod_desc2 = pt_desc2
                   npod_due_date = 12/12/12
                   npod_um = pt_um
                   npod_nbr = ponbr
                   npod_draw = pt_draw
		   npod_buyer = pt_buyer.

                IF wo_due_date <= nextdate  THEN npod_next =   wo_qty_ord.
               ELSE npod_next2 =   wo_qty_ord.

           END.
       END.

       FOR EACH rqd_det WHERE rqd_status = "" AND  rqd_due_date > enddate 
            AND rqd_due_date < next2date AND rqd_vend = po_vend  NO-LOCK ,
            EACH pt_mstr WHERE pt_part = rqd_part and pt_buyer = buyer NO-LOCK :
            FIND npod_det WHERE npod_vend = rqd_vend AND npod_part = rqd_part AND npod_due_date = 12/12/12 NO-ERROR.
            IF AVAILABLE npod_det  THEN DO:
                IF rqd_due_date <= nextdate  THEN npod_next = npod_next + RQD_req_QTY.
                ELSE npod_next2 = npod_next2 + RQD_req_QTY.
            END.
            ELSE DO: 
                CREATE npod_det.
                FIND FIRST ad_mstr WHERE ad_addr = rqd_vend NO-LOCK NO-ERROR.
                IF AVAILABLE ad_mstr THEN
                      IF AVAILABLE ad_mstr THEN
                    ASSIGN npod_vend = ad_addr 
                           npod_name = ad_name + ad_line3
                    npod_attn = ad_attn
                    npod_fax  = ad_fax
                    npod_part = pt_part
                    npod_desc1 = pt_desc1
                    npod_desc2 = pt_desc2
                    npod_due_date = 12/12/12
                    npod_um = pt_um
                    npod_nbr = ponbr
                    npod_draw = pt_draw.
                ELSE ASSIGN npod_vend = ""
                           npod_name = ""
                    npod_attn = ""
                    npod_fax  = ""
                    npod_part = pt_part
                    npod_desc1 = pt_desc1
                    npod_desc2 = pt_desc2
                    npod_due_date = 12/12/12
                    npod_um = pt_um
                    npod_nbr = ponbr
                    npod_draw = pt_draw
		    npod_buyer = pt_buyer.


                 IF rqd_due_date <= nextdate  THEN npod_next =  RQD_req_QTY.
                ELSE npod_next2 =   RQD_req_QTY.

            END.
        END.


          FOR EACH pod_det WHERE pod_status = "" AND  pod_due_date > enddate 
            AND pod_due_date < next2date   NO-LOCK ,
            EACH pt_mstr WHERE pt_part = pod_part and  pt_buyer = buyer NO-LOCK:
              FIND FIRST po_mstr WHERE po_nbr = pod_nbr AND po_vend = vend  NO-LOCK NO-ERROR.
              IF AVAILABLE po_mstr  THEN  DO:

            FIND npod_det WHERE npod_vend = po_vend AND npod_part = pod_part  AND npod_due_date = 12/12/12 NO-ERROR.
            IF AVAILABLE npod_det  THEN DO:
                IF pod_due_date <= nextdate  THEN npod_next = npod_next + pod_qty_ord.
                ELSE npod_next2 = npod_next2 + pod_qty_ord.
            END.
            ELSE DO: 
                CREATE npod_det.
                FIND FIRST ad_mstr WHERE ad_addr = po_vend NO-LOCK NO-ERROR.
                IF AVAILABLE ad_mstr THEN
                      IF AVAILABLE ad_mstr THEN
                    ASSIGN npod_vend = ad_addr 
                           npod_name = ad_name + ad_line3
                    npod_attn = ad_attn
                    npod_fax  = ad_fax
                    npod_part = pt_part
                    npod_desc1 = pt_desc1
                    npod_desc2 = pt_desc2
                    npod_due_date = 12/12/12
                    npod_um = pt_um
                    npod_nbr = ponbr
                    npod_draw = pt_draw
		    npod_buyer = pt_buyer.
                ELSE ASSIGN npod_vend = ""
                           npod_name = ""
                    npod_attn = ""
                    npod_fax  = ""
                    npod_part = pt_part
                    npod_desc1 = pt_desc1
                    npod_desc2 = pt_desc2
                    npod_due_date = 12/12/12
                    npod_um = pt_um
                    npod_nbr = ponbr
                    npod_draw = pt_draw
		    npod_buyer = pt_buyer.


                 IF pod_due_date <= nextdate  THEN npod_next =  pod_qty_ord.
                ELSE npod_next2 =   pod_qty_ord.

             

            END.
              END. /* IF AVAILABLE po_mstr  THEN  DO:*/
        END.



END. /* IF AVAILABLE po_mstr THEN DO:*/
ELSE DO:
   FOR EACH wo_mstr WHERE wo_status = "P" AND  wo_due_date > enddate 
           AND wo_due_date < next2date NO-LOCK,
           EACH pt_mstr WHERE pt_part = wo_part and  pt_buyer = buyer AND pt_pm_code = "p" 
           AND  pt_vend <> "" AND (pt_vend = vend OR vend = "")  NO-LOCK:
           FIND npod_det WHERE npod_vend = pt_vend AND npod_part = wo_part
               AND npod_due_date = 12/12/12  NO-ERROR.
           IF AVAILABLE npod_det  THEN DO:
               IF wo_due_date <= nextdate  THEN npod_next = npod_next + wo_qty_ord.
               ELSE npod_next2 = npod_next2 + wo_qty_ord.
           END.
           ELSE DO: 
               CREATE npod_det.
               FIND FIRST ad_mstr WHERE ad_addr = pt_vend NO-LOCK NO-ERROR.
               IF AVAILABLE ad_mstr THEN
                   ASSIGN npod_vend = ad_addr 
                          npod_name = ad_name + ad_line3
                   npod_attn = ad_attn
                   npod_fax  = ad_fax
                   npod_part = pt_part
                   npod_desc1 = pt_desc1
                   npod_desc2 = pt_desc2
                   npod_due_date = 12/12/12
                   npod_um = pt_um
                   npod_nbr = ponbr
                   npod_draw = pt_draw
		   npod_buyer = pt_buyer.
               ELSE ASSIGN npod_vend = ""
                          npod_name = ""
                   npod_attn = ""
                   npod_fax  = ""
                   npod_part = pt_part
                   npod_desc1 = pt_desc1
                   npod_desc2 = pt_desc2
                   npod_due_date = 12/12/12
                   npod_um = pt_um
                   npod_nbr = ponbr
                   npod_draw = pt_draw
		   npod_buyer = pt_buyer.

                IF wo_due_date <= nextdate  THEN npod_next =   wo_qty_ord.
               ELSE npod_next2 =   wo_qty_ord.

           END.
       END.


   FOR EACH rqd_det WHERE rqd_status = "" AND  rqd_due_date > enddate 
     AND rqd_due_date < next2date AND rqd_vend <> "" AND ( rqd_vend = vend OR vend = "") NO-LOCK ,
     EACH pt_mstr WHERE pt_part = rqd_part and  pt_buyer = buyer NO-LOCK :
     FIND npod_det WHERE npod_vend = rqd_vend AND npod_part = rqd_part AND npod_due_date = 12/12/12 NO-ERROR.
     IF AVAILABLE npod_det  THEN DO:
         IF rqd_due_date <= nextdate  THEN npod_next = npod_next + RQD_req_QTY.
         ELSE npod_next2 = npod_next2 + RQD_req_QTY.
     END.
     ELSE DO: 
         CREATE npod_det.
         FIND FIRST ad_mstr WHERE ad_addr = rqd_vend NO-LOCK NO-ERROR.
         IF AVAILABLE ad_mstr THEN
               IF AVAILABLE ad_mstr THEN
             ASSIGN 
		npod_vend = ad_addr 
                npod_name = ad_name + ad_line3
		npod_attn = ad_attn
		npod_fax  = ad_fax
		npod_part = pt_part
		npod_desc1 = pt_desc1
		npod_desc2 = pt_desc2
		npod_due_date = 12/12/12
		npod_um = pt_um
		npod_nbr = ponbr
		npod_draw = pt_draw
		npod_buyer = pt_buyer.
         ELSE ASSIGN 
		npod_vend = ""
		npod_name = ""
		npod_attn = ""
		npod_fax  = ""
		npod_part = pt_part
		npod_desc1 = pt_desc1
		npod_desc2 = pt_desc2
		npod_due_date = 12/12/12
		npod_um = pt_um
		npod_nbr = ponbr
		npod_draw = pt_draw
		npod_buyer = pt_buyer.


          IF rqd_due_date <= nextdate  THEN npod_next =  RQD_req_QTY.
         ELSE npod_next2 =   RQD_req_QTY.

     END.
 END.



   FOR EACH pod_det WHERE pod_status = "" AND  pod_due_date > enddate 
     AND pod_due_date < next2date   NO-LOCK ,
     EACH pt_mstr WHERE pt_part = pod_part and  pt_buyer = buyer NO-LOCK:
       FIND FIRST po_mstr WHERE po_nbr = pod_nbr AND (po_vend = vend OR vend = "") NO-LOCK NO-ERROR.
       IF AVAILABLE po_mstr  THEN DO:

     FIND npod_det WHERE npod_vend = po_vend AND npod_part = pod_part  AND npod_due_date = 12/12/12 NO-ERROR.
     IF AVAILABLE npod_det  THEN DO:
         IF pod_due_date <= nextdate  THEN npod_next = npod_next + pod_qty_ord.
         ELSE npod_next2 = npod_next2 + pod_qty_ord.
     END.
     ELSE DO: 
         CREATE npod_det.
         FIND FIRST ad_mstr WHERE ad_addr = po_vend NO-LOCK NO-ERROR.
         IF AVAILABLE ad_mstr THEN
               IF AVAILABLE ad_mstr THEN
             ASSIGN 
		npod_vend = ad_addr 
		npod_name = ad_name + ad_line3
		npod_attn = ad_attn
		npod_fax  = ad_fax
		npod_part = pt_part
		npod_desc1 = pt_desc1
		npod_desc2 = pt_desc2
		npod_due_date = 12/12/12
		npod_um = pt_um
		npod_nbr = ponbr
		npod_draw = pt_draw
		npod_buyer = pt_buyer.
	     ELSE ASSIGN 
		npod_vend = ""
		npod_name = ""
		npod_attn = ""
		npod_fax  = ""
		npod_part = pt_part
		npod_desc1 = pt_desc1
		npod_desc2 = pt_desc2
		npod_due_date = 12/12/12
		npod_um = pt_um
		npod_nbr = ponbr
		npod_draw = pt_draw
		npod_buyer = pt_buyer.


          IF pod_due_date <= nextdate  THEN npod_next =  pod_qty_ord.
         ELSE npod_next2 =   pod_qty_ord.

     END.
             END. /*IF AVAILABLE po_mstr  THEN DO:*/
 END.



END. /*else do:***/
/*==================================================================================================*/
/*
for each npod_det where npod_due_date = 12/12/12,
    each empty2 where empty2_part = npod_part:
    if empty2_month = mm + 1 then npod_next = npod_next + empty2_qty.
    else if empty2_month = mm + 2 then npod_next2 = npod_next2 + empty2_qty.
end.
*/
/* 输出当月订货量和预示量文本 */
if ch = "Y" then
  do:
    FOR EACH npod_det :
           IF npod_due_date = 12/12/12 THEN DO:
		str_due_date = "预示栏".
	   END.
           ELSE IF npod_due_date <> ? THEN DO:
		str_due_date = STRING(npod_due_date).
	   END.
           ELSE str_due_date  = " ".
            
           PUT   npod_st   "~t"        
	         npod_vend      "~t"   
                 npod_name     "~t"  
                 npod_attn     "~t"
                 npod_fax       "~t"
                 npod_part    "~t"
                 npod_desc1     "~t"
                 npod_desc2  "~t" 
                 npod_due_date  "~t"
                 npod_qty   "~t"
                 npod_um     "~t"
                 npod_next  "~t"
                 npod_next2   "~t" 
                 str_due_date   "~t" 
		 npod_nbr   "~t" 
		 npod_draw "~t"
		 npod_buyer "~t"
		 npod_line
                 SKIP(0).
           
          
     END.
   end.
else do:
    /* 删除部分无效预示量(下月预示和下下月预示都为0,且本月没有订货量） */
    FOR EACH npod_det :
           IF npod_due_date = 12/12/12 THEN 
		str_due_date = "预示栏".
	   ELSE IF npod_due_date <> ? THEN 
		    str_due_date = STRING(npod_due_date).
	        ELSE str_due_date  = " ".
           if npod_due_date = 12/12/12 and npod_next = 0 and npod_next2 = 0 and npod_output = 0 then next. 
	   else
	   PUT   npod_st   "~t"        
	         npod_vend      "~t"   
                 npod_name     "~t"  
                 npod_attn     "~t"
                 npod_fax       "~t"
                 npod_part    "~t"
                 npod_desc1     "~t"
                 npod_desc2  "~t" 
                 npod_due_date  "~t"
                 npod_qty   "~t"
                 npod_um     "~t"
                 npod_next  "~t"
                 npod_next2   "~t" 
                 str_due_date   "~t" 
		 npod_nbr   "~t" 
		 npod_draw "~t"
		 npod_buyer "~t"
		 npod_line
                 SKIP(0).
    END.
end.

OUTPUT CLOSE.



/*--------------------------------*/
/* 自定义函数：返回是否为可送货日 */
/*--------------------------------*/
FUNCTION ok_date RETURNS INTEGER (INPUT one_date AS date, vend_str AS CHAR).
DEF VAR str1 AS CHAR.
DEF VAR str2 AS CHAR.
DEF VAR str3 AS CHAR.
DEF VAR date1 AS DATE.
DEF VAR date2 AS DATE.
DEF VAR date3 AS DATE.


CASE substring(vend_str,1,1):
    WHEN "a" or WHEN "A" THEN
      do:
         date1 = date(string(year(one_date)) + "/" +  string(month(one_date)) + "/" + substring(vend_str,2,2)).
         if weekday(date1) =1 then
	    date1 = date1 + 1.
	 else if weekday(date1) = 7 then
	    date1 = date1 + 2.
         AA:
	 Repeat:
	 FIND LAST hd_mstr WHERE hd_date = date1 NO-ERROR .
         IF NOT AVAILABLE hd_mstr THEN 
	      do:
	          if one_date = date1 then 
		     RETURN (1).
                  ELSE
                      IF weekday(date1) <> 1  THEN
                          IF WEEKDAY(date1) <> 7 THEN
		                        RETURN (0).
                          ELSE date1 = date1 + 2.
                      ELSE date1 = date1 + 1.
	      end.
	 ELSE
	        date1 = date1 + 1.
	 END.
      end.
    WHEN "b" or WHEN "B" THEN
      do:

	 date1 = date(string(year(one_date)) + "/" +  string(month(one_date)) + "/" + substring(vend_str,2,2)).
         if weekday(date1) =1 then
	    date1 = date1 + 1.
	 else if weekday(date1) = 7 then
	    date1 = date1 + 2.
	 date2 = date(string(year(one_date)) + "/" +  string(month(one_date)) + "/" + substring(vend_str,4,2)).
         if weekday(date2) = 1 then
	    date2 = date2 + 1.
	 else if weekday(date2) = 7 then
	    date2 = date2 + 2.

	 BB:
	 Repeat:	 
	 FIND LAST hd_mstr WHERE hd_date = date1 NO-ERROR .
         IF NOT AVAILABLE hd_mstr THEN 
	      do:
	          if one_date = date1 then 
		     RETURN (1).
                  ELSE 
                      IF weekday(date1) <> 1  THEN
                          IF WEEKDAY(date1) <> 7 THEN
		                        leave BB.
                          ELSE date1 = date1 + 2.
                      ELSE date1 = date1 + 1.
	      end.
	 ELSE

	        date1 = date1 + 1.
	 END.

	 CC:
	 Repeat:
	 FIND LAST hd_mstr WHERE hd_date = date2 NO-ERROR .
         IF NOT AVAILABLE hd_mstr THEN 
	      do:
	          if one_date = date2 then 
		     RETURN (1).
                  ELSE
                      IF weekday(date2) <> 1  THEN
                          IF WEEKDAY(date2) <> 7 THEN
		               RETURN (0).
                          ELSE date2 = date2 + 2.
                      ELSE date2 = date2 + 1.
	      end.
	 ELSE
	        date2 = date2 + 1.
	 END.
 
      end.
    WHEN "c" or WHEN "C" THEN
      do:
         date1 = date(string(year(one_date)) + "/" +  string(month(one_date)) + "/" + substring(vend_str,2,2)).
         if weekday(date1) =1 then
	    date1 = date1 + 1.
	 else if weekday(date1) = 7 then
	    date1 = date1 + 2.
	 date2 = date(string(year(one_date)) + "/" +  string(month(one_date)) + "/" + substring(vend_str,4,2)).
         if weekday(date2) =1 then
	    date2 = date2 + 1.
	 else if weekday(date2) = 7 then
	    date2 = date2 + 2.
	 date3 = date(string(year(one_date)) + "/" +  string(month(one_date)) + "/" + substring(vend_str,6,2)).
         if weekday(date3) =1 then
	    date3 = date3 + 1.
	 else if weekday(date3) = 7 then
	    date3 = date3 + 2.
	 dd:
	 Repeat:
	 FIND LAST hd_mstr WHERE hd_date = date1 NO-ERROR .
         IF NOT AVAILABLE hd_mstr THEN 
	      do:
	          if one_date = date1 then 
		     RETURN (1).
                  ELSE 
                      IF weekday(date1) <> 1  THEN
                          IF WEEKDAY(date1) <> 7 THEN
		                        leave dd.
                          ELSE date1 = date1 + 2.
                      ELSE date1 = date1 + 1.
	      end.
	 ELSE
	        date1 = date1 + 1.
	 END.

	 ee:
	 Repeat:
	 FIND LAST hd_mstr WHERE hd_date = date2 NO-ERROR .
         IF NOT AVAILABLE hd_mstr THEN 
	      do:
	          if one_date = date2 then 
		     RETURN (1).
                  ELSE 
                      IF weekday(date2) <> 1  THEN
                          IF WEEKDAY(date2) <> 7 THEN
		                        leave ee.
                          ELSE date2 = date2 + 2.
                      ELSE date2 = date2 + 1.
	      end.
	 ELSE
	        date2 = date2 + 1.
	 END.

	 ff:
	 Repeat:
	 FIND LAST hd_mstr WHERE hd_date = date3 NO-ERROR .
         IF NOT AVAILABLE hd_mstr THEN 
	      do:
	          if one_date = date3 then 
		     RETURN (1).
                  ELSE
                      IF weekday(date3) <> 1  THEN
                          IF WEEKDAY(date3) <> 7 THEN
		                        RETURN (0).
                          ELSE date3 = date3 + 2.
                      ELSE date3 = date3 + 1.
	      end.
	 ELSE
	        date3 = date3 + 1.
	 END.

      end.
    
    OTHERWISE
      do:
        IF SUBSTRING( vend_str, weekday(one_date),1) = "1" then
            DO:
               FIND LAST hd_mstr WHERE hd_date = one_date NO-ERROR .
               IF NOT AVAILABLE hd_mstr THEN
                    RETURN (1).
               ELSE RETURN (0).
            END.
           
        ELSE RETURN (0).
      end.
END CASE.      

END FUNCTION.