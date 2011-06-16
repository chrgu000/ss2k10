/* Revision: eb2sp4      BY: Ching Ye     DATE: 11/26/07  ECO: *SS - 20071126.1* */

{mfdtitle.i "2+ "}
   
    /*
&SCOPED-DEFINE PP_FRAME_NAME A
      */

Define variable Eoutputstatment AS CHARACTER FORMAT "x(200)". 
Define variable Eonetime        AS CHARACTER FORMAT "x(1)" init "N".
Define variable outputstatment AS CHARACTER FORMAT "x(200)".
Define variable woutputstatment AS CHARACTER .
DEF VAR fn_me AS CHAR FORMAT "x(30)" INIT "c:\po_receiver_err.txt" .
def var v9000 as char.

def var site like si_site init "gsa01".
def var site1 like   si_site init "gsa01".
def var vend like  po_vend init "C01A002".
def var vend1 like    po_vend init "C01A002".
def var shipno like xx_ship_no init "1".
def var shipno1 like xx_ship_no init "zzzzzzzz".
def var shipline like xx_ship_line init 0.
def var shipline1 like xx_ship_line init 9999.
def var rcvddate like tr_effdate init today.
def var tmpstr as char.
define variable usection as char format "x(16)".
def var tmpmonth as char.
def var j as integer.
def var i as integer.
def var datestr as char.
def var glbasecurr like gl_base_curr.
DEF VAR v_flag AS LOGICAL.
def buffer poms for po_mstr.
def var tstr as char.
def var tstr1 as char.
def var errstr as char.
def var ciminputfile  as char.
def var cimoutputfile as char.
DEF TEMP-TABLE pott 
    FIELD pott_shipno LIKE xx_ship_no
    /*FIELD pott_shipnbr LIKE xx_ship_nbr */
    FIELD pott_site LIKE xx_inv_site
    FIELD pott_vend LIKE xx_inv_vend
    FIELD pott_case like xx_ship_case
    FIELD pott_part_vend LIKE xx_ship_part
    FIELD pott_pkg LIKE xx_ship_pkg
    FIELD pott_qty_unit like xx_ship_qty_unit
    FIELD pott_qty like xx_ship_qty
    FIELD pott_status like xx_ship_status
    FIELD pott_price like xx_ship_price
    FIELD pott_value like xx_ship_value
    FIELD pott_curr like xx_ship_curr
    /* FIELD pott_duedate like xx_ship_duedate */
    /* FIELD pott_etadate like xx_ship_etadate */
    FIELD pott_line like xx_ship_line
    FIELD pott_part_zh like xx_ship_part
    field pott_loc like pt_loc
    field pott_lot like tr_serial
    field pott_ponbr like po_nbr
    FIELD pott_poline like xx_ship_line
    field pott_fix_rate as char
    field pott_qty_open like pod_qty_ord
    field pott_flag as char
    field pott_CIMQTY like pod_qty_ord
    field pott_add_CIMQTY like pod_qty_ord
    field pott_addpo like pod_nbr
    field pott_order_type like xx_ship_type
    field pott_rate like xx_ship_rate
    field pott_cost like xx_ship_price
    field pott_loadOKqty like pod_qty_ord
    .
 

DEF TEMP-TABLE  tt1
    field   tt1_nbr like po_nbr
    field   tt1_curr like po_curr
    field   tt1_line like pod_line
    field   tt1_vend like po_vend
    field   tt1_fix_rate  as char
    field   tt1_openqty like pod_qty_ord
    field   tt1_part like pod_part
    field   tt1_site like pod_site
    field   tt1_lot like tr_serial
    field   tt1_loc like pt_loc
    field   tt1_flag as char
    field   tt1_shipno like xx_ship_no
    field   tt1_rmks like pt_desc1
    field   tt1_vendpart like pt_part
    field   tt1_shipline like xx_ship_line
     
.
DEF TEMP-TABLE  tt1a
    field   tt1a_nbr like po_nbr
    field   tt1a_curr like po_curr
    field   tt1a_line like pod_line
    field   tt1a_vend like po_vend
    field   tt1a_fix_rate  as char
    field   tt1a_openqty like pod_qty_ord
    field   tt1a_part like pod_part
    field   tt1a_site like pod_site
    field   tt1a_lot like tr_serial
    field   tt1a_loc like pt_loc
    field   tt1a_flag as char
    field   tt1a_shipno like xx_ship_no
    field   tt1a_rmks like pt_desc1
    field   tt1a_vendpart like pt_part
    field   tt1a_shipline like xx_ship_line
     
.
DEF TEMP-TABLE  tt2
    field   tt2_nbr like po_nbr.

DEF TEMP-TABLE tte 
    FIELD tte_type1 AS CHAR
    FIELD tte_type AS CHAR
    FIELD tte_vend LIKE po_vend
    FIELD tte_part LIKE pt_part
    FIELD tte_desc AS CHAR FORMAT "x(120)"
    .

PROCEDURE datain.

/*Define variable outputstatment AS CHARACTER FORMAT "x(200)".*/
input from value ( ciminputfile) .
output to  value ( "pocim.in") APPEND.
put  unformatted skip(1) .
put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " ciminputfile " ".

    Do While True:
          IMPORT UNFORMATTED outputstatment.
            put unformatted outputstatment "@" .
	    Eoutputstatment =  Eoutputstatment + "@"  +  trim ( outputstatment ).

    End.
            put unformatted skip .
input close.
output close.
END PROCEDURE.

PROCEDURE dataout.

/*Define variable woutputstatment AS CHARACTER .*/

input from value ( cimoutputfile) .
    Do While True:
          IMPORT UNFORMATTED woutputstatment.

	  IF index (woutputstatment,"ERROR:")   <> 0 OR    /* for us langx */
	     index (woutputstatment,"WARNING:") <> 0 OR    
	     index (woutputstatment,"错误:")	<> 0 OR    /* for ch langx */
	     index (woutputstatment,"警告:")	<> 0 OR
    	     index (woutputstatment,"牡")	<> 0 OR    /* for tw langx */
	     index (woutputstatment,"岿粇:")	<> 0 OR
      	     index (woutputstatment,"(87)")	<> 0 OR      
	     index (woutputstatment,"(557)")	<> 0 OR      
      	     index (woutputstatment,"(143)")	<> 0       
	     
	     then do:
		  IF index (woutputstatment,"ERROR:")   <> 0 OR    /* for us langx */			     
			     index (woutputstatment,"错误:")	<> 0 OR    /* for ch langx */			    			    
			     index (woutputstatment,"岿粇:")	<> 0 then errstr=woutputstatment.


                  

		  if Eonetime = "N" then do :
		     output to  value ( "pocim.err") APPEND.
		     put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " ciminputfile " " Eoutputstatment  skip.
		     Eonetime = "Y".
                     output close.
		  end.
		  output to  value ( "pocim.in") APPEND.
                  put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " cimoutputfile " " woutputstatment  skip.
	          output close.

		  output to  value ( "pocim.err") APPEND.
                  put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " cimoutputfile " " woutputstatment  skip.
	          output close.

	     end.


    End.
input close.
END PROCEDURE.

FORM
    /*
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    */

    SKIP(1)
    site  COLON 20    LABEL "地点" 
    site1 colon 50 label   {t001.i}      
    vend  COLON 20    LABEL "供应商" 
    vend1 colon 50 label   {t001.i}  
    shipno  COLON 20    LABEL "发票号" 
    shipno1 colon 50 label   {t001.i}  
    shipline  COLON 20    LABEL "项次" 
    shipline1 colon 50 label   {t001.i} 
    rcvddate COLON 20  LABEL "收货日期"
    fn_me   COLON 20    LABEL "导入出错的信息文件"
    SKIP(1)
    with frame a side-labels width 80 ATTR-SPACE
    /* /* gui */ NO-BOX THREE-D /* gui */  */ .

/*
 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = ("导入客户订单的相关资料").
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

 /*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME
 */

/* Main Repeat */
mainloop:
repeat :
    hide all no-pause .
    view frame dtitle .
  view frame a .

  IF site1 = hi_char THEN site1 = "".
  IF vend1 = hi_char THEN vend1 = "".
  IF shipno1 = hi_char THEN shipno1 = "".
  update 
      site
      site1
      vend
      vend1
      shipno
      shipno1
      shipline
      shipline1
      rcvddate
      fn_me
      with frame a.
  
  IF site1 = "" THEN site1 = hi_char.
  IF vend1 = "" THEN vend1 = hi_char.
  IF shipno1 = "" THEN shipno1 = hi_char.
  /* 文件的命名规则:SOyyyymmdd99 */
  /* aa i = 101.
  REPEAT :
      fn_i = "SO" + STRING(YEAR(TODAY))            + 
             SUBSTRING(STRING(100 + MONTH(TODAY)),2,2) + 
             SUBSTRING(STRING(100 + DAY(TODAY)),2,2)   + 
             SUBSTRING(STRING(i),2,2).
      IF SEARCH(fn_i + ".inp") = ? THEN DO:
          LEAVE.
      END.
      i = i + 1.
  END.
  aa */

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
   {mfphead.i}

  FOR EACH pott:
      DELETE pott.
  END.
  FOR EACH tte:
      DELETE tte.
  END.
  FOR EACH tt1:
      DELETE tt1.
  END.
  FOR EACH tt1a:
      DELETE tt1a.
  END.
  j=0.
  /* "1,取符合条件的数据,请等待......" 按供应商，图号汇总. B*/
 
  for each xx_inv_mstr where xx_inv_no>= shipno and xx_inv_no <= shipno1 
                             and xx_inv_vend>= vend and xx_inv_vend <= vend1
			     and xx_inv_site >= site and xx_inv_site <= site1
			     no-lock,
      each xx_ship_det no-lock where xx_inv_no=xx_ship_no 
                            /*and xx_ship_site >= site and xx_ship_site <= site1*/
                            /*and xx_ship_vend >= vend and xx_ship_vend <= vend1*/ 
			    /* and xx_ship_no >= shipno and xx_ship_no <= shipno1   */
			    and xx_ship_line >= shipline and xx_ship_line <= shipline1  
			    and xx_ship_status="" and (xx_ship_qty - xx_ship_rcvd_qty) <> 0 
			    break by xx_inv_site by xx_inv_vend  by xx_ship_part :
			     

			    ACCUMULATE xx_ship_qty ( TOTAL by xx_inv_site by xx_inv_vend by  xx_ship_part ) .

      IF LAST-OF(xx_ship_part) THEN DO:
/*          disp xx_inv_no xx_inv_vend xx_inv_site  xx_ship_line xx_ship_status xx_ship_part "OOO". */
          CREATE pott.
          ASSIGN
             pott_shipno = xx_ship_no
	     /*pott_shipnbr = xx_ship_nbr*/
	     /*pott_site = xx_ship_site */
	     /*pott_vend = xx_ship_vend*/
	     pott_site = xx_inv_site
	     pott_vend = xx_inv_vend
	     pott_case = xx_ship_case
	     pott_part_vend = xx_ship_part
	     pott_pkg = xx_ship_pkg
	     pott_qty_unit = xx_ship_qty_unit
	     pott_qty = (ACCUMULATE TOTAL BY xx_ship_part xx_ship_qty) 
	     pott_status = xx_ship_status
	     pott_price = xx_ship_price
	     pott_value = xx_ship_value
	     pott_curr = xx_ship_curr
	     /* pott_duedate = xx_ship_duedate */
	     /* pott_etadate = xx_ship_etadate */
	     pott_line = xx_ship_line
             pott_order_type = xx_ship_type  /*P量产，R新机种*/
	     pott_rate = xx_ship_rate
              .
	    /* get lot*/
	    if rcvddate<>? then do:
		    if month(rcvddate)>9 then assign datestr=substring(string(year(rcvddate)),3)  + string(month(rcvddate)).
		    else assign datestr=string(year(rcvddate))  + "0" + string(month(rcvddate)).
		    if day(rcvddate)>9 then assign datestr= datestr + string(day(rcvddate)).
		    else assign datestr= datestr + "0" + string(day(rcvddate)).
	    end.

            assign pott_lot = datestr + xx_inv_con .
 


	     find first vd_mstr where vd_addr=xx_inv_vend no-lock no-error.
	     if avail vd_mstr then do:
	         if xx_ship_curr<> vd_curr then assign pott_cost=xx_ship_price * xx_ship_rate.
		 else pott_cost=xx_ship_price .
	     end.
	     else pott_cost=xx_ship_price .
      END.     
  end. /* for each xx_ship_det */
 /* "1,取符合条件的数据,请等待......" 按供应商，图号汇总. E*/
  
/* "2,判断供应商图号与ZH图号对应是否存在" . B */
  v_flag = YES.
  FOR EACH pott  :
      FIND FIRST vp_mstr WHERE pott_vend = vp_vend AND pott_part_vend = vp_vend_part NO-LOCK NO-ERROR.
      IF NOT AVAIL vp_mstr THEN DO:
          CREATE tte.
          ASSIGN
              tte_type1 = "零件图号"
              tte_type = "错误" 
              tte_vend = pott_vend
              tte_part = pott_part_vend
              tte_desc = "供应商零件对应未维护，请到(1.19)菜单进行维护。"
              .
          v_flag = NO.
      END.
      ELSE DO:
          ASSIGN 
              pott_part_zh = vp_part 
              .
      END.
      
  END. /* for each tt no-lock */
/* "2,判断供应商图号与ZH图号对应是否存在" . E */

/* "3,判断供应商是否存在" . 取得default pt_loc    B */
  
  FOR EACH pott   :
 
          FIND FIRST vd_mstr WHERE vd_addr = pott_vend NO-LOCK NO-ERROR.
          IF NOT AVAIL vd_mstr THEN DO:
              CREATE tte.
              ASSIGN
                  tte_type1 = "供应商"
                  tte_type = "错误" 
                  tte_vend = pott_vend
                  tte_part = ""
                  tte_desc = "此供应商代码在系统中不存在，请先到(2.3.1)维护供应商。"
                  .
              v_flag = NO.
           END.
           /* get pt_loc */
	   FIND FIRST pt_mstr WHERE pott_part_zh  = pt_part NO-LOCK NO-ERROR.
           IF NOT AVAIL pt_mstr THEN DO:
              CREATE tte.
              ASSIGN
                  tte_type1 = "默认库位"
                  tte_type = "错误" 
                  tte_vend = pott_vend
                  tte_part = pott_part_vend
                  tte_desc = "此图号没有默认库位，请先到(1.4.1)维护默认库位。"
                  .
              v_flag = NO.
           END.
	   else do:
	      assign pott_loc=pt_loc.
           end.
	 

  end. /* for each pott */
/* "3,判断供应商是否存在" . 取得default pt_loc    E */


/* "4,取所含供应商，图号的所有订单号，项胜（未结的) " . B */           

   FOR EACH pott NO-LOCK   break by pott_site by  pott_vend by pott_part_vend:
         if last-of(pott_part_vend) then do:
		  for each po_mstr where po_vend=pott_vend /*and pott_site=pott_site*/ and po_stat="" no-lock,
			   each pod_det where pod_nbr=po_nbr and pod_part=pott_part_zh and pod_status="" and pod_site=pott_site no-lock:
			    find first pt_mstr where pt_part=pott_part_zh no-lock no-error.
			     
			    create tt1 .
			     assign tt1_nbr=po_nbr /* 订单 */
			            tt1_curr=po_curr
				    tt1_line=pod_line /*   订单项   */
				    tt1_vend=po_vend /* 供应商 */
				    tt1_fix_rate = if po_fix_rate = yes then "Y" else "N"
				    tt1_openqty=pod_qty_ord - pod_qty_rcvd /*   未决量   */
				    tt1_part=pod_part	/* 图号 */			    
				    tt1_site=pod_site /* 地点 */				     
				    tt1_loc=if avail pt_mstr then pt_loc else ""  /* 默认库位 */
				    tt1_shipno = pott_shipno
                                    /* get lot*/
			            tt1_lot =pott_lot
				    tt1_vendpart=pott_part_vend
				    tt1_shipline=pott_line.


				 
		  end. /*  for each po_mstr where po */
	  end. /* if last-of(pott_part_vend) then do: */
	  
   end. /* for each pott */
/* "4,取所含供应商，图号的所有订单号，项胜（未结的) " . E */           


/* 5,判断是否存在订单 ，pott_flag="2"不存在订单，需产生订单并收货  ,pott_flag="1" 存在订单  B*/

   FOR EACH pott NO-LOCK   :
       
       find first tt1 where tt1_vend=pott_vend and tt1_part=pott_part_zh no-lock no-error.
       if avail tt1 then assign pott_flag="1" pott_ponbr=tt1_nbr pott_poline=tt1_line pott_curr = tt1_curr. 
       else  assign pott_flag="2"  pott_add_CIMQTY = pott_qty /*pott_curr = tt1_curr */ . 
  end. /* for each pott */
/* 5,判断是否存在订单 ，pott_flag="2"不存在订单，需产生订单并收货  ,pott_flag="1" 存在订单  B*/

/* 6,,当pott_flag="1" 存在订单时, pott_flag="3" ALL 全收，pott_flag="4" 部份收，部分增加订单再收   B*/
 
   FOR EACH pott where pott_flag="1" NO-LOCK  break by pott_site by  pott_vend by pott_part_vend :
      if last-of(pott_part_vend) then do:
                
	       for each  tt1 where tt1_site=pott_site and tt1_vend=pott_vend and tt1_part=pott_part_zh no-lock break by tt1_site by  tt1_vend  by tt1_part.
	         
	            ACCUMULATE tt1_openqty ( TOTAL by tt1_site by tt1_vend by  tt1_part ) .
                   if last-of(tt1_part) then do:
		    
		      if pott_qty<= (ACCUMULATE TOTAL BY tt1_part tt1_openqty)  then assign pott_flag="3" pott_CIMQTY=pott_qty pott_add_CIMQTY=0. 
		      else assign pott_CIMQTY=(ACCUMULATE TOTAL BY tt1_part tt1_openqty)  pott_flag="4" pott_add_CIMQTY=(pott_qty - (ACCUMULATE TOTAL BY tt1_part tt1_openqty)).
		   end.
	       end.
       
      end. 
  end. /* for each pott */

/* 6,,当pott_flag="1" 存在订单时, pott_flag="3" ALL 全收，pott_flag="4" 部份收，部分增加订单再收   E*/


/* 7,,当pott_flag="2" 全增订单, 长率pott_flag="4" 部份收，部分增加订单再收，按规则组成定单号   B*/
  
  FOR EACH pott  where pott_flag="2" or pott_flag="4" break by pott_site by pott_vend by pott_part_vend by pott_flag:
     find first vd_mstr where vd_addr=pott_vend no-lock no-error.
       
     if month(today)>=10 then tmpmonth=string(month(today)).
     else tmpmonth="0" + string(month(today)).
      if avail vd_mstr then do:
       if pott_flag="4" then assign pott_addpo=pott_order_type + substring(string(year(today)),3) +  tmpmonth  + substring(vd_sort,1,2) + "Z".
       if pott_flag="2" then assign pott_addpo=pott_order_type + substring(string(year(today)),3) +   tmpmonth  + substring(vd_sort,1,2) + "R".
     end.
     else do:
       if pott_flag="4" then assign pott_addpo=pott_order_type + substring(string(year(today)),3) +  tmpmonth   + "ERZ".
       if pott_flag="2" then assign pott_addpo=pott_order_type + substring(string(year(today)),3) +   tmpmonth   + "ERR".

     end.
    

  end.
/* 7,,当pott_flag="2" 全增订单, 长率pott_flag="4" 部份收，部分增加订单再收，按规则组成定单号   E */

/* 71 tt1 to tt1a B*/
for each tt1:
   create tt1a.
    
      assign    tt1a_nbr  = tt1_nbr 
		tt1a_curr = tt1_curr  
		tt1a_line = tt1_line  
		tt1a_vend  = tt1_vend
		tt1a_fix_rate  = tt1_fix_rate  
		tt1a_openqty  = tt1_openqty
		tt1a_part = tt1_part 
		tt1a_site  = tt1_site
		tt1a_lot  = tt1_lot 
		tt1a_loc  = tt1_loc 
		tt1a_flag = tt1_flag  
		tt1a_shipno = tt1_shipno   
		tt1a_vendpart=tt1_vendpart
		tt1a_shipline=tt1_shipline
		tt1a_rmks = "已存在的订单". 
end.
/* 71 tt1 to tt1a E*/
/*72, pott表全部，部分记录，产生PO后，取回PO订单，项，数量信息，B */   
/*abc*
FOR EACH pott NO-LOCK where pott_add_CIMQTY<>0  break by pott_addpo:
 
         if last-of(pott_addpo) then do:
		  for each po_mstr where pott_addpo=po_nbr and po_vend=pott_vend /*and pott_site=pott_site*/ and po_stat="" no-lock,
			   each pod_det where pod_nbr=po_nbr  and pod_status=""  no-lock:
			    find first pt_mstr where pt_part=pott_part_zh no-lock no-error.
			    create tt1a .
			     assign tt1a_nbr=po_nbr /* 1 */
			            tt1a_curr=po_curr
				    tt1a_line=pod_line /* 3 */
				    tt1a_vend=po_vend /* 4 */
				    tt1a_fix_rate = if po_fix_rate = yes then "Y" else "N"
				    tt1a_openqty=pod_qty_ord - pod_qty_rcvd /* 6 */
				    tt1a_part=pod_part	/* 5 */			    
				    tt1a_site=pod_site /* 2 */				     
				    tt1a_loc=if avail pt_mstr then pt_loc else ""
				    tt1a_shipno = pott_shipno
                                    tt1a_rmks = "新增加的订单"
                                    /* get lot */
	                            tt1a_lot =pott_lot .

		  end.
	  end.
	  
 end. /* for each pott */
/*72, pott表全部，部分记录，产生PO后，取回PO订单，项，数量信息，E */ 
*abc*/


FOR EACH pott  where   (pott_flag="2" or pott_flag="4") and pott_add_CIMQTY<>0 break by pott_site by pott_vend by pott_addpo by pott_part_vend  :
                    find first pt_mstr where pt_part=pott_part_zh no-lock no-error.
		    find first vd_mstr where vd_addr=pott_vend no-lock no-error.
                    create tt1a .
			     assign tt1a_nbr=pott_addpo /* 1 */
			            tt1a_curr=if avail vd_mstr then vd_curr else "" 
				   /* tt1a_line=pod_line  3 */
				    tt1a_vend=pott_vend /* 4 */
				    /* tt1a_fix_rate = if po_fix_rate = yes then "Y" else "N" */
				    tt1a_openqty=pott_add_CIMQTY /* 6 */
				    tt1a_part=pott_part_zh	/* 5 */			    
				    tt1a_site=pott_site /* 2 */				     
				      tt1a_loc=if avail pt_mstr then pt_loc else "" 
				    tt1a_shipno = pott_shipno
                                    tt1a_rmks = "新增加的订单"
                                    /* get lot */
	                            tt1a_lot =pott_lot 
				    tt1a_vendpart=pott_part_vend
				    tt1a_shipline=pott_line.
             
  end.
 
/* 单个订单循环增加   E */




for each tte with frame ab1c:
    /* SET EXTERNAL LABELS */
    setFrameLabels(frame ab1c:handle).
	disp tte_type1
	     tte_type
	     tte_vend
	     tte_part
 with frame ab1c width 200 down.
end.
for each tt1a where tt1a_openqty<>0   with frame ab2c:
    /* SET EXTERNAL LABELS */
    setFrameLabels(frame ab2c:handle).
	 disp tt1a_nbr  /* 订单 */
	 tt1a_curr 
	 tt1a_line /*   订单项   */
	 tt1a_vend /* 供应商 */
	 tt1a_openqty /*   未决量   */
	 tt1a_part 	/* 图号 */
	 tt1a_vendpart label "Vend part"
	 tt1a_site /* 地点 */				     
	 tt1a_loc  /* 默认库位 */
	 tt1a_shipno  
	 tt1a_lot 
	 tt1a_shipline
	 tt1a_rmks /* get lot*/
 with frame ab2c width 200 down.
 end.
  




   /* REPORT TRAILER */
   {mfrtrail.i}


def var abcd   AS LOGICAL.
abcd=no.
 message "CIM-LOAD or not?/进行收货? " update abcd.
 if abcd=yes then do:



/* 8,,判断是否要增加定单，tmpstr B要增加,A不增加  B */
   tmpstr="A".
   FOR EACH pott  where (pott_flag="2" or pott_flag="4") and pott_add_CIMQTY<>0 break by pott_site by pott_vend by pott_addpo by pott_part_vend  :
     tmpstr="B".
   end.
/* 8,,判断是否要增加定单，tmpstr B要增加,A不增加  E  */
   if tmpstr="B" then do:
    /*  取得订单清单 B   */
    FOR EACH pott  where (pott_flag="2" or pott_flag="4") and pott_add_CIMQTY<>0 break by pott_site by pott_vend by pott_addpo by pott_part_vend  :
       if last-of(pott_addpo) then do:
          create tt2.
              assign tt2_nbr =pott_addpo.
        end.
    end.
    /*  取得订单清单 E   */
   

   /*  单个订单循环增加   B */
  for each tt2: 
   usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "por3" .
   output to value( trim(usection) + ".i") .
   FOR EACH pott  where tt2_nbr =pott_addpo and (pott_flag="2" or pott_flag="4") and pott_add_CIMQTY<>0 break by pott_site by pott_vend by pott_addpo by pott_part_vend  :
 
        if first-of(pott_addpo) then do: 
	       tstr="N".
	       tstr1="N".
	       find first poms where poms.po_nbr=pott_addpo no-lock no-error.
	       if avail poms and poms.po_stat="C" then assign tstr="Y" tstr1="Y".

	   put pott_addpo skip.
	   find first poms where poms.po_nbr=pott_addpo no-lock no-error.
	   if avail poms then put " -" skip.
	   else put pott_vend  skip.
	   put " -" skip.
	   do i=1 to 11:
	    put "- ".
	   end.
	   put pott_site skip.
	   put "-" skip.
	   /* put "-" skip. */
	end.   /* if first-of(pott_addpo) then do:  */
	if last-of(pott_part_vend) then do:
	   put "-" skip.
 
	    if  tstr="Y" then do:
	      tstr="N".
	      put   "Y" skip.
               
             end.

	   put pott_site skip.
	   put "-" skip.
	   put pott_part_zh skip.
	   put string(pott_add_CIMQTY)  skip.
	   put pott_cost skip.
	   /*  put "-" skip. */
	   put "-" skip.
	   put "n" skip.
	   
         end.  /* if last-of(pott_part_vend) then do: */
	
        if last-of(pott_addpo) then do:
	   put "." skip.
	   put "." skip.
	   put "" skip.
	   put "" skip.

	   	 if  tstr1="Y" then do:
	         tstr1="N".
	         put   "Y" skip.
               
                end.

	   put "." skip.
	end.   
      end.
      output close.

      input from value ( usection + ".i") .
      output to  value ( usection + ".o") .
        batchrun = yes. 
        {gprun.i ""popomt.p""}
	batchrun = no. 
      input close.
      output close.

        errstr="".
	ciminputfile = usection + ".i".
        cimoutputfile = usection + ".o".
        {xserrlg5.i}
	if errstr="" then do:
          unix silent value ( "rm -f "  + Trim(usection) + ".i").
          unix silent value ( "rm -f "  + Trim(usection) + ".o").
        end.


  end.
end.  /* if tmpstr="B" then do: */
/* 单个订单循环增加   E */
 
/*  9 ,做标记tt1_flag="3"  要CIM-LOAD 系统中 B */
  for each tt1:
      find first pott where  tt1_vend=pott_vend and tt1_part=pott_part_zh and (pott_flag="3" or pott_flag="4") no-lock no-error.
      if avail pott then assign tt1_flag="3".
  end.
/*  9 ,做标记tt1_flag="3"  要CIM-LOAD 系统中 E */


/*10, tt1表全部，部分记录，处理CIM-LOAD的，B */           
/*************************************************************************************************************/
    /* 判断采购币与本位币是否相同，是否固定汇率*/
   find first gl_ctrl no-lock no-error.
   If AVAILABLE (gl_ctrl) then assign glbasecurr=gl_base_curr.    

      FOR EACH  tt1 where tt1_flag="3"  and tt1_openqty<>0 NO-LOCK   :

      j=j + 1. 
      usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "por3" .
      output to value( trim(usection) + ".i") .
      
	      PUT  UNFORMATTED   trim ( tt1_nbr )  format "x(50)"  skip .

	      PUT  UNFORMATTED   tt1_shipno + " - " + string(rcvddate) +  " N N N " format "x(50)" skip .
              /* 判断采购币与本位币是否相同，是否固定汇率*/
 	      If tt1_curr <> glbasecurr and  tt1_fix_rate  = "N"  then put UNFORMATTED skip(1) .  

	      PUT  UNFORMATTED trim ( string(tt1_line) )  format "x(50)" skip .
	      PUT  UNFORMATTED trim ( string(tt1_openqty) ) + " - N - - - " + trim (tt1_site) + " " +  trim( tt1_loc ) + " " + """" + trim(tt1_lot) + """" + " - - N N N "   format "X(50)"   skip.
/*	      PUT  UNFORMATTED """" + trim(pott_lot) + """" + " - - N N N "  format "X(50)" skip . */
	      PUT  UNFORMATTED "." skip .
	      PUT  UNFORMATTED "Y" skip .
	      PUT  UNFORMATTED "Y" skip .
	      PUT  UNFORMATTED "." .
      output close.

       input from value ( usection + ".i") .
      output to  value ( usection + ".o") .
        batchrun = yes. 
        {gprun.i ""poporc.p""}
	batchrun = no. 
      input close.
      output close.     

	/*abcd B*/
	V9000="0".
	find last tr_hist where tr_trnbr >= 0 no-lock no-error.
	If AVAILABLE ( tr_hist ) then  V9000 = string(tr_trnbr).

	 find last tr_hist where 
	tr_date = today     and 
	tr_trnbr >= integer ( V9000 ) and 
	tr_nbr  = trim(tt1_nbr)     and  tr_type = "RCT-PO"  and tr_site = trim(tt1_site)    and  tr_part =trim(tt1_part)     and tr_serial = trim(tt1_lot)   and 
	tr_time  + 15 >= TIME  and tr_qty_chg=tt1_openqty and tr_line =tt1_line
	use-index tr_date_trn no-lock no-error.
	If AVAILABLE ( tr_hist ) then do:
	 
		 find first xx_inv_mstr where xx_inv_no= tt1_shipno 
					     and xx_inv_vend= tt1_vend
					     and xx_inv_site =trim(tt1_site)
					     no-lock no-error.
                 if avail xx_inv_mstr then do:
		      output to "afg1"   .
		       put tt1_shipno ";" tt1_vendpart ";" tt1_openqty  ";" tt1_shipline.
		      output close.
		      find first xx_ship_det   where xx_inv_no=xx_ship_no 
					    /*and xx_ship_site >= site and xx_ship_site <= site1*/
					    /*and xx_ship_vend >= vend and xx_ship_vend <= vend1*/ 
					    /* and xx_ship_no >= shipno and xx_ship_no <= shipno1   */
					    and xx_ship_part=tt1_vendpart
					    and xx_ship_line  = tt1_shipline
					    and xx_ship_status="" and (xx_ship_qty - xx_ship_rcvd_qty) <> 0
					     no-error.
					     if avail xx_ship_det then  assign xx_ship_rcvd_qty=xx_ship_rcvd_qty + tt1_openqty xx_ship_rcvd_date=rcvddate.
                end.
					      
					       
	       
	end.
	/*abcd E*/
 
        errstr="".
	ciminputfile = usection + ".i".
        cimoutputfile = usection + ".o".
        {xserrlg5.i}
	if errstr="" then do:
          unix silent value ( "rm -f "  + Trim(usection) + ".i").
          unix silent value ( "rm -f "  + Trim(usection) + ".o").
	  find first  pott where tt1_vend=pott_vend and pott_part_zh= tt1_part no-lock no-error.
	  if avail pott then assign pott_loadOKqty=  pott_loadOKqty + tt1_openqty.
        end.	

  END. /* for each pott */

/*************************************************************************************************************/
/*10, tt1表全部，部分记录，处理CIM-LOAD的，E */    

/*11, pott表全部，部分记录，产生PO后，取回PO订单，项，数量信息，B */  
for each tt1:
  delete tt1.
end.

FOR EACH pott NO-LOCK where pott_add_CIMQTY<>0  break by pott_addpo:
         if last-of(pott_addpo) then do:
		  for each po_mstr where pott_addpo=po_nbr and po_vend=pott_vend /*and pott_site=pott_site*/ and po_stat="" no-lock,
			   each pod_det where pod_nbr=po_nbr  and pod_status=""  no-lock:
			    find first  pt_mstr where pt_part=pott_part_zh no-lock no-error.
			    create tt1 .
			     assign tt1_nbr=po_nbr /* 1 */
			            tt1_curr=po_curr
				    tt1_line=pod_line /* 3 */
				    tt1_vend=po_vend /* 4 */
				    tt1_fix_rate = if po_fix_rate = yes then "Y" else "N"
				    tt1_openqty=pod_qty_ord - pod_qty_rcvd /* 6 */
				    tt1_part=pod_part	/* 5 */			    
				    tt1_site=pod_site /* 2 */				     
				    tt1_loc=if avail pt_mstr then pt_loc else ""
				    tt1_shipno = pott_shipno
                                    /* get lot*/
	                            tt1_lot=pott_lot
				    tt1_vendpart=pott_part_vend
				    tt1_shipline=pott_line.

		  end.
	  end.
	  
 end. /* for each pott */
/*11, pott表全部，部分记录，产生PO后，取回PO订单，项，数量信息，E */  

/*12, pott表全部，部分记录，产生PO后，与TT1表对应，tt1_flag='1'有对应，要处理CIM，tt1_flag='5'，没对应，不处理 B */ 
 for each tt1:
      find first pott where pott_addpo=tt1_nbr and pott_vend=tt1_vend and pott_part_zh=tt1_part no-lock no-error.
      if avail pott then assign tt1_flag='1'.
      else assign tt1_flag='5'.
 end.
/*12, pott表全部，部分记录，产生PO后，与TT1表对应，tt1_flag='1'有对应，要处理CIM，tt1_flag='5'，没对应，不处理 E */ 

/*13, pott表全部，部分记录，处理CIM-LOAD B */ 
/*************************************************************************************************************/
    /* 判断采购币与本位币是否相同，是否固定汇率*/
   find first gl_ctrl no-lock no-error.
   If AVAILABLE (gl_ctrl) then assign glbasecurr=gl_base_curr.    

      FOR EACH  tt1 where tt1_flag="1" and tt1_openqty<>0 NO-LOCK   :

      j=j + 1. 
      usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "por3" .
      output to value( trim(usection) + ".i") .
      
	      PUT  UNFORMATTED   trim ( tt1_nbr )  format "x(50)"  skip .

	      PUT  UNFORMATTED   tt1_shipno + " - " + string(rcvddate) +  " N N N " format "x(50)" skip .
              /* 判断采购币与本位币是否相同，是否固定汇率*/
 	      If tt1_curr <> glbasecurr and  tt1_fix_rate  = "N"  then put UNFORMATTED skip(1) .  

	      PUT  UNFORMATTED trim ( string(tt1_line) )  format "x(50)" skip .
	      PUT  UNFORMATTED trim ( string(tt1_openqty) ) + " - N - - - " + trim (tt1_site) + " " +  trim( tt1_loc ) + " " + """" + trim(tt1_lot) + """" + " - - N N N "   format "X(50)"   skip.
/*	      PUT  UNFORMATTED """" + trim(pott_lot) + """" + " - - N N N "  format "X(50)" skip . */
	      PUT  UNFORMATTED "." skip .
	      PUT  UNFORMATTED "Y" skip .
	      PUT  UNFORMATTED "Y" skip .
	      PUT  UNFORMATTED "." .
      output close.

      input from value ( usection + ".i") .
      output to  value ( usection + ".o") .
      	batchrun = yes.
        {gprun.i ""poporc.p""}
	 batchrun = NO.
 
      input close.
      output close.  
	
   /*abcd B*/
V9000="0".
find last tr_hist where tr_trnbr >= 0 no-lock no-error.
If AVAILABLE ( tr_hist ) then  V9000 = string(tr_trnbr).
/* output to "afg1".
put  "B0;" V9000 ";" tt1_shipno ";"  tt1_site  ";"  tt1_part  ";"  tt1_lot ";" today  ";" tt1_vendpart ";" tt1_vend  ";" tt1_shipline ";" tt1_openqty ";" tt1_nbr skip.
output  close.*/
/*B0;1926363 ;VT22-2312         ;gsa01   ;M07402-471-0A     ;VT22/ABC20071208  ;07/12/08;M07402-471-0B     ;C01A002 ;      2;       195.0*/
/*B0;1926366 ;VT22-2312         ;gsa01   ;M07402-471-0A     ;VT22/ABC20071208  ;07/12/08;M07402-471-0B     ;C01A002 ;      2;       194.0*/
 find last tr_hist where 
tr_date = today     and 
tr_trnbr >= integer ( V9000 ) and 
tr_nbr  = trim(tt1_nbr)     and  tr_type = "RCT-PO"  and tr_site = trim(tt1_site)    and  tr_part =trim(tt1_part)     and tr_serial = trim(tt1_lot)   and 
tr_time  + 15 >= TIME  and tr_qty_chg=tt1_openqty and tr_line =tt1_line
use-index tr_date_trn no-lock no-error.

If AVAILABLE ( tr_hist ) then do:
/*output to "afg2".
put  "B1;" V9000 ";" tt1_shipno ";"  tt1_site  ";"  tt1_part  ";"  tt1_lot ";" today  ";" tt1_vendpart ";" tt1_vend  ";" tt1_shipline ";" tt1_openqty ";" tt1_nbr skip.
output  close.   */  

		 find first xx_inv_mstr where xx_inv_no= trim(tt1_shipno) 
					     and xx_inv_vend= trim(tt1_vend)
					     and xx_inv_site =trim(tt1_site)
					     no-lock no-error.
                  if avail xx_inv_mstr then do:
		  		      output to value( "afg2" + string(j))  .
		       put tt1_shipno ";" tt1_vendpart ";" tt1_openqty  ";" tt1_shipline.
		      output close.
		      find first xx_ship_det   where xx_inv_no=xx_ship_no 
   
				    /*and xx_ship_site >= site and xx_ship_site <= site1*/
				    /*and xx_ship_vend >= vend and xx_ship_vend <= vend1*/ 
				    /* and xx_ship_no >= shipno and xx_ship_no <= shipno1   */
				    and xx_ship_part=tt1_vendpart
				    and xx_ship_line  = tt1_shipline
				    and xx_ship_status="" and (xx_ship_qty - xx_ship_rcvd_qty)<> 0
				      no-error.
				    if avail xx_ship_det then  assign xx_ship_rcvd_qty=xx_ship_rcvd_qty + tt1_openqty  xx_ship_rcvd_date=rcvddate.
				  	 
		 	 
				      
	     end.
end.
/*abcd E*/


        errstr="".
	ciminputfile = usection + ".i".
        cimoutputfile = usection + ".o".
        {xserrlg5.i}
	if errstr="" then do:
          unix silent value ( "rm -f "  + Trim(usection) + ".i").
          unix silent value ( "rm -f "  + Trim(usection) + ".o").

	  find first  pott where tt1_vend=pott_vend and pott_part_zh= tt1_part no-lock no-error.
	  if avail pott then assign pott_loadOKqty=  pott_loadOKqty + tt1_openqty.
        end.


/*      unix silent value("del " + Trim(usection) + ".*"). */
      
      



  END. /* for each pott */

/*************************************************************************************************************/
/*13, pott表全部，部分记录，处理CIM-LOAD E*/ 
 
      usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "poreceiver" .
      OUTPUT TO VALUE (fn_me) .
      /*OUTPUT TO VALUE (usection) .*/
      EXPORT DELIMITER ";" "类型" "错误类型" "客户代码" "订单/零件号" 
                           "错误描述" .
      FOR EACH tte :
          EXPORT DELIMITER ";" tte .
      END.
      OUTPUT CLOSE .
       

      MESSAGE "本次共导入" + string(j) + "条数据,请检查导出的信息文件以确认数据是否完整正确的导入到系统!" VIEW-AS ALERT-BOX.
      /*HIDE MESSAGE NO-PAUSE .*/
   
      for each pott where pott_qty=pott_loadOKqty:

        for each xx_inv_mstr where pott_vend=xx_inv_vend and pott_part_vend = xx_ship_part
	                     and xx_inv_no>= shipno and xx_inv_no <= shipno1 
                             and xx_inv_vend>= vend and xx_inv_vend <= vend1
			     and xx_inv_site >= site and xx_inv_site <= site1
			     no-lock,
                each xx_ship_det   where xx_inv_no=xx_ship_no 
                            /*and xx_ship_site >= site and xx_ship_site <= site1*/
                            /*and xx_ship_vend >= vend and xx_ship_vend <= vend1*/ 
			    /* and xx_ship_no >= shipno and xx_ship_no <= shipno1   */
			    and xx_ship_line >= shipline and xx_ship_line <= shipline1  
			    and xx_ship_status="":

 
			    assign xx_ship_status="close" xx_ship_rcvd_date=rcvddate.

            end.  /* for each xx_ship_det   where xx_ship_site >= */
      end.
      j=0.
end. /* if abcd=yes */
      UNDO mainloop, RETRY mainloop. 
end. /* Main Repeat */

/*
CREATE xx_ship_det.
ASSIGN    xx_ship_no="1234"
	      xx_ship_nbr=2
	      xx_ship_site ='gsa01'
	      xx_ship_vend='C01A002'
	      xx_ship_case =1
	      xx_ship_part='M07402-471-0B'
	      xx_ship_pkg=3
	      xx_ship_qty_unit=200
	      xx_ship_qty=100 
	      xx_ship_status='open'
	      xx_ship_price=20
	      xx_ship_value=20
	      xx_ship_curr='cny'
	      /* xx_ship_duedate=today */
	      /* xx_ship_etadate=today */
	      xx_ship_line=1
	      xx_ship_rate=1.


	      */