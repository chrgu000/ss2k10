{mfdtitle.i "20100706 "}
DEF VAR i AS integer format ">>>9" label "整理后".                     /* 周期参数*/
DEF VAR c AS integer.
DEF VAR n AS INTEGER format ">>>9" label "整理前".
DEF VAR n1 AS CHAR.
def var np as char.         /*采购单变量*/
DEF VAR n2 as char.
def var n3 as char.
def var vendor as char.
def var vendor0 as char.
def var vend01 as char format "x(1)" initial "C" label "供应商国别".
DEF VAR buyer as char label "采购员".
def var part like pt_part.
def var part1 like pt_part.
DEF VAR D AS DATE.
def var c1 as char format "x(30)".
def var c2 as char format "x(15)".
def var c3 as char.
def var j as integer initial 1.
def var p as integer.
def var ifoutput as logical.
def var str1 as char format "x(30)" .
def var site as char.
def var site1 as char.
DEF VAR m AS INT.
DEF VAR dy AS INT.

FUNCTION ok_date RETURNS INTEGER  (INPUT one_date AS date, vend_str AS CHAR) FORWARD.

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

    INDEX empty2 is UNIQUE  primary empty2_part empty2_duedate /*empty2_qty */. 

&SCOPED-DEFINE PP_FRAME_NAME A
form
RECT-FRAME       AT ROW 1 COLUMN 1.25
RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
        skip(.1)
	site  colon 15
	site1 colon 45
	part  colon 15
	part1 colon 45
        D colon 15  label "订单截止日期"
        vendor  colon 15 label "供应商"
        skip(.1)     /**空行**/   
        vend01 colon 15 label "供应商国别"
        "(国产:C ; 日供:J ; 印尼:I ; 泰供:T)" colon 25
        skip(.1)
        buyer colon 15 label "采购员"
        skip(.1)
        str1 colon 15 label "导出文件目录"
        skip(1)
	skip(.1)
with frame a side-label width 80 attr-space NO-BOX THREE-D.

DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

&UNDEFINE PP_FRAME_NAME
setframelabels(frame a:handle). 

{wbrp01.i}
/* mainloop:
repeat: */
/* 
   if D = low_date then D = ? .
   if  vend = hi_char then vend = "".
   if  part = hi_char then part = "".
   UPDATE D vend part with frame a.

   if D = low_date then D = ? .
   if  vend = hi_char then vend = "".
   if  part = hi_char then part = "".
   update vend01 buyer with frame a.

AA:
REPEAT:
    if buyer = "" then do:
       Message "采购员不能为空,请重新填写!             " view-as alert-box error buttons OK.
       update buyer with frame a.
       end.
    if buyer <> "" then leave AA.
END.
*/

repeat:

site = "gsa01".
site1 = "gsa01".
buyer = "4RSA".
vendor = "".
vendor0 = "".
part = "".
part1 = "".
str1 = "d:\load\".
n = 0.
i = 0.

/* d 默认下月末最后一天 */
m = MONTH(TODAY) + 2.
dy = YEAR(TODAY).
IF m > 12 THEN do:
    m = m - 12.
    dy = dy + 1.
END.
d = DATE(STRING( dy ) +  '/' + STRING( m ) + '/01') - 1.

disp site site1 part part1 d vendor vend01 buyer str1 with frame a.
update
    site site1 part part1 d vendor vend01 buyer str1
with frame a.

if vendor <> "" then vendor0 = vendor. 
  else vendor0 = "".
if site1    = hi_char  then site1    = "".
if part1    = hi_char  then part1    = "".
if buyer    = hi_char  then buyer    = "".
if vendor   = hi_char  then vendor   = "".

if (c-application-mode <> 'web') or
   (c-application-mode = 'web' and
   (c-web-request begins 'data')) then
  do:
      assign bcdparm = "".
         {mfquoter.i part      }
         {mfquoter.i part1     }
         {mfquoter.i site      }
         {mfquoter.i site1     }
         {mfquoter.i buyer     }
	 {mfquoter.i vendor0   }
         {mfquoter.i vendor    }
      if site1    = "" then site1    = hi_char.
      if part1    = "" then part1    = hi_char.
      if buyer    = "" then buyer    = hi_char.
      if vendor   = "" then vendor   = hi_char.
  end.

unix silent value("mkdir " + str1 ). 

str1 = str1 + "po-" + buyer + ".xls".

/* FOR EACH mrp_det WHERE mrp_due_date <= (D + 30)  AND mrp_detail = "计划单"  and mrp_part >= part and mrp_part <= part1 USE-INDEX mrp_part,                       /*FOR 1*/
    EACH pt_mstr WHERE pt_part = mrp_part and pt_vend >= vendor0 and pt_vend <= vendor and substring(pt_vend,1,1) = vend01 and pt_buyer = buyer and pt_pm_code = 'P' USE-INDEX pt_part,
    EACH vd_mstr WHERE vd_addr = pt_vend BREAK BY mrp_part BY mrp_due_date:
*/
FOR EACH pt_mstr WHERE pt_vend >= vendor0 and pt_vend <= vendor and substring(pt_vend,1,1) = vend01 
         and pt_buyer = buyer and pt_pm_code = 'P' and pt_part >= part and pt_part <= part1 and pt_site >= site and pt_site <= site1 USE-INDEX pt_part,
    EACH mrp_det WHERE mrp_part = pt_part and mrp_due_date <= (D + 30)  AND mrp_detail = "计划单"  USE-INDEX mrp_part,                       /*FOR 1*/
    EACH vd_mstr WHERE vd_addr = pt_vend BREAK BY mrp_part BY mrp_due_date:

    if substring(pt_part,1,1) = "X" or substring(pt_part,1,1) = "x" then next.
    c = ok_date(mrp_due_date, vd_rmks).
    n = n + 1.
    find first empty1 where empty1_part = mrp_part and empty1_duedate = mrp_due_date no-error.
    if not available empty1 then do:
	CREATE empty1.
        ASSIGN
            EMPTY1_ITEM = N
            empty1_part = mrp_part
            empty1_duedate = mrp_due_date
            empty1_qty = mrp_qty
            empty1_t = int(pt_rev)         /*送货周期*/
            empty1_remark = vd_rmks
	    empty1_sort = vd_sort
	    empty1_addr = vd_addr
	    empty1_yn = c.
	end.
     else
        ASSIGN
            EMPTY1_ITEM = N
            empty1_part = mrp_part
            empty1_duedate = mrp_due_date
            empty1_qty = empty1_qty + mrp_qty     /* 如果存在同一天同零件的多条记录，进行累计 */
            empty1_t = int(pt_rev)         /*送货周期*/
            empty1_remark = vd_rmks
	    empty1_sort = vd_sort
	    empty1_addr = vd_addr
	    empty1_yn = c.
END.  /*FOR 1*/

disp "提示信息：已筛选" n no-label "条记录 . . . . . .|| 正在汇总运算请等候 . . . . . . ."  with frame b  . 


/*
for each empty1.
    disp EMPTY1_ITEM empty1_part empty1_duedate empty1_qty empty1_sort.
end.

*/
output to VALUE(str1).
put "订单号" "~t" "供应商" "~t" "图号" "~t" "数量" "~t" "日期" "~n".

/***********************************************************************************************************/
/*===========    对于尾数的处理:周期小于14的就退后到上一个可送货日;周期大于等于14的就直接输出   ===========*/
/***********************************************************************************************************/
FOR EACH empty1 break by empty1_part:                   /*FOR 2*/
    FIND LAST empty2 WHERE empty2_part = empty1_part NO-ERROR .
         
    IF NOT AVAILABLE empty2 THEN 
        do:   /*do a*/
            if empty1_t >= 14 then
               do: /*do b*/
                   n1 = 'P' + substring(string(empty1_duedate),1,2) + substring(string(empty1_duedate),4,2) + substring(empty1_sort,1,2) + '1'.
                   find po_mstr where po_nbr = n1  NO-ERROR.
                   if not available po_mstr then
                      np = n1.
                   else
                      do:
	              j = int(substring(po_nbr,8,1)) + 1.
	              np = substring(n1,1,7) + string(j).
	              end.  
                   CREATE empty2.
                       ASSIGN
                       empty2_ord_on = np
	               empty2_addr = empty1_addr
	               empty2_part = empty1_part
	               empty2_qty = empty1_qty
                       empty2_duedate = empty1_duedate.
	       end.
	    else
	        do:  /*do c*/
                   XX:
		   repeat:
		    empty1_duedate = empty1_duedate - 1.
		    if ok_date(empty1_duedate,vd_rmks) = 1 then 
		    leave XX.
		   end.
                   n1 = 'P' + substring(string(empty1_duedate),1,2) + substring(string(empty1_duedate),4,2) + substring(empty1_sort,1,2) + '1'.
                   find po_mstr where po_nbr = n1  NO-ERROR.
                   if not available po_mstr then
                      np = n1.
                   else
                      do:
	              j = int(substring(po_nbr,8,1)) + 1.
	              np = substring(n1,1,7) + string(j).
	              end.  
                   CREATE empty2.
                       ASSIGN
                       empty2_ord_on = np
	               empty2_addr = empty1_addr
	               empty2_part = empty1_part
	               empty2_qty = empty1_qty
                       empty2_duedate = empty1_duedate.
		end. /*end do c*/
	  end.  /*end do a*/
     ELSE
     DO: /*do d*/

         IF empty1_yn = 0 THEN   /****对于不是可送货日的记录,如果和empty2中的最后一条记录时间差小于送货周期的话就将数据直接相加,如果大于周期的话就将推到最近一个可送货日添加一条新记录****/
	 do:
	    if abs(empty1_duedate - empty2_duedate) < empty1_t then
	       empty2_qty = empty2_qty + empty1_qty. 
            if abs(empty1_duedate - empty2_duedate) >= empty1_t then
	       do:
	          XX:
		   repeat:
		    empty1_duedate = empty1_duedate - 1.
		    if ok_date(empty1_duedate,vd_rmks) = 1 then 
		    leave XX.
		   end.
		   find empty2 where empty2_part = empty1_part and empty2_duedate = empty1_duedate no-error.                                              
		        if not available empty2 then do:                                                                                                 
                           n1 = 'P' + substring(string(empty1_duedate),1,2) + substring(string(empty1_duedate),4,2) + substring(empty1_sort,1,2) + '1'.   
                           find po_mstr where po_nbr = n1  NO-ERROR.                                                                                     
                                if not available po_mstr then                                                                                          
                                   np = n1.                                                    /*=====================================*/
                                else                                                           /* 这段程序用来判断空表一中数据的时间  */
                                   do:                                                         /* 经过运算调整后是否与空表2中已有数据 */
	                             j = int(substring(po_nbr,8,1)) + 1.                       /* 如果已存在零件号和日期都相等的记录  */
	                             np = substring(n1,1,7) + string(j).                       /* 就将表1中该零件的数量加到表2相应的  */
	                           end.                                                        /* 记录中;如果不存在,就在表2中创建一条 */ 
                           CREATE empty2.                                                      /* 新的记录.                           */
                                  ASSIGN                                                       /* 修改日期:   2007/12/10              */
                                  empty2_ord_on = np                                           /*=====================================*/
	                          empty2_addr = empty1_addr
	                          empty2_part = empty1_part
	                          empty2_qty = empty1_qty
                                  empty2_duedate = empty1_duedate.
		          end.
		      else 
		           empty2_qty = empty2_qty + empty1_qty.
		           
	       end.
            end.
         IF empty1_yn = 1 THEN
            DO:
                n1 = 'P' + substring(string(empty1_duedate),1,2) + substring(string(empty1_duedate),4,2) + substring(empty1_sort,1,2) + '1'.
                find po_mstr where po_nbr = n1  NO-ERROR.
                if not available po_mstr then
                   np = n1.
                else
                   do:
	           j = int(substring(po_nbr,8,1)) + 1.
	           np = substring(n1,1,7) + string(j).
	           end.
		 /*np = empty2_ord_on. */
	        CREATE empty2.
                ASSIGN
                empty2_ord_on = np
	        empty2_addr = empty1_addr
	        empty2_part = empty1_part
	        empty2_qty = empty1_qty
                empty2_duedate = empty1_duedate.
	    END.
		
     END. /*end do d*/
         
END.  /*FOR 2*/

/*for each empty2 where year(empty2_duedate) <= MONTH(empty2_duedate) <= month(D) : */
for each empty2 where empty2_duedate <= D :
 
       i = i + 1.
       put empty2_ord_on "~t"
           empty2_addr "~t"
	   empty2_part "~t"
	   empty2_qty "~t"
	   empty2_duedate
	   skip(0).
END.
OUTPUT CLOSE.

MESSAGE "检测到 " + string(n) " 条记录,汇总后输出 " + string(i) + " 条记录,请检查生成的信息是否完整正确!" VIEW-AS ALERT-BOX INFORMATION.
hide frame b.
/* 清除上次运行结果 */
for each empty1.
    delete empty1.
end.
for each empty2.
    delete empty2.
end.
hide frame b.

end. /* repeat */



/* 返回是否为可送货日 */
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


