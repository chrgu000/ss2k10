/* xs                                                                      */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/* REVISION: 2.0         Last Modified: 2008/12/11   By: SamSong   ECO:      */

/*-Revision end------------------------------------------------------------*/

{mfdeclre.i}    /*mfgpro global vars & functions*/
{gplabel.i}     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */


define var v_date as date . v_date = today.
define var v_time as integer  .
define var v_msgtxt as char format "x(50)" .
define var v_nbrtype as char .  /*for xsgetnbr.i */
{xsgetnbr.i}  /*procedure getnbr define */


define var updatebymanual as logical.
define var effdate        like tr_effdate init today.
Define variable OkToUpdate as logical init no.
define variable UpdateMessage as char.
Define Variable UpdateSuccess as logical init no.


Define buffer xxwrddet for xxwrd_det.
Define buffer xywrddet for xxwrd_det.
Define buffer tmpwrddet for xxwrd_det.

define variable ciminputfile   as char .
define variable cimoutputfile  as char .
define variable usection as char format "x(16)".
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="global_user_lang_dir" no-lock no-error. /*  Update MFG/PRO Directory */
if AVAILABLE(code_mstr) Then global_user_lang_dir = trim ( code_cmmt ).
if substring(global_user_lang_dir, length(global_user_lang_dir), 1)  = "/" then global_user_lang_dir = global_user_lang_dir + "/".
Def temp-table fbtmp 
      field rsn_type as char 
      field rsn_code like xxfb_rsn_code
      field rsn_qty  like xxfb_qty_fb.
define variable  sumsetuptime like xxfb_time_start.
define variable  sumruntime like xxfb_time_start.
define variable  sumqtycomp like xxfb_qty_fb.


form
    skip(1)
    updatebymanual    colon 20  label "确认运行"
    effdate           colon 20  label "生效日期"
    skip(1)
with frame a 
title color normal "手工更新MFG/PRO数据"
side-labels width 50 
row 8 centered overlay .   

view frame a .


Update updatebymanual  effdate with frame a.  

if updatebymanual = no or effdate = ?  then do:
   hide frame a.
   leave.
end.
hide frame a.


/*  ?? NEED Roger
if effdate finaical control = no then do:
   message "会计期间有误".
   leave.
end.
*/


Define variable Eoutputstatment AS CHARACTER FORMAT "x(200)".
Define variable Eonetime        AS CHARACTER FORMAT "x(1)" init "N".
Define Variable CimHaveError    AS logical init no.
PROCEDURE datain.
Eoutputstatment = "".
Define variable outputstatment AS CHARACTER FORMAT "x(200)".
input from value ( ciminputfile) .
output to  value ( "sfc.lg") APPEND.
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
CimHaveError    = no.
Eonetime        = "N".
Define variable woutputstatment AS CHARACTER .
input from value ( cimoutputfile) .
    Do While True:
          IMPORT UNFORMATTED woutputstatment.

	  IF index (woutputstatment,"ERROR:") <>  0 OR    /* for us langx */
	     index (woutputstatment,"错误:")  <>  0 OR    /* for ch langx */
	     index (woutputstatment,"岿粇:")  <>  0 OR
      	     index (woutputstatment,"(87)")   <>  0 OR      
	     index (woutputstatment,"(557)")  <>  0 OR      
      	     index (woutputstatment,"(143)")  <>  0       
	     
	     then do:
		  output to  value ( "sfc.lg") APPEND.
                  put  unformatted skip(1) today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " cimoutputfile " " woutputstatment  skip.
	          output close.
                   
                  CimHaveError = yes.
		  output to  value ( "sfc.err") APPEND.
                  put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " cimoutputfile " " woutputstatment  skip.
	          output close.
		  leave.

	     end.


    End.
input close.
END PROCEDURE.



PROCEDURE OkToUpdateMFGPRO:

     DEFINE INPUT  PARAMETER wwolot like xxwrd_wolot.
     DEFINE INPUT  PARAMETER wop    like xxwrd_op.
     DEFINE INPUT  PARAMETER wwrnbr like xxwrd_wrnbr.

     DEFINE OUTPUT PARAMETER OkToUpdate     AS logical init no.
     OkToUpdate = no.

     
    find first xxwrddet where xxwrddet.xxwrd_wolot = wwolot and
                              xxwrddet.xxwrd_op    = wop    and
			      xxwrddet.xxwrd_lastop         and    /* 最后一道工序*/
			      xxwrddet.xxwrd_status = "D"  
			      no-lock no-error .   /* 发料WOID*/
     /* 0. Delete OP */
     If AVAILABLE( xxwrddet ) then do:
        OkToUpdate = yes.

	message "0"  OkToUpdate wwolot wop view-as alert-box .

        leave.
     End.

     Find first xxwrddet where xxwrddet.xxwrd_wolot = wwolot and
                               xxwrddet.xxwrd_op    = wop    and
                               xxwrddet.xxwrd_opfinish       and    /* 发料工序  反馈完成*/
                               xxwrddet.xxwrd_issok          and    /* 发料工序  退料完成*/
                               xxwrddet.xxwrd_close = no     and
			       xxwrddet.xxwrd_lastop         and    /* 最后一道工序*/
	                       xxwrddet.xxwrd_lastwo          
			        no-lock no-error .   /* 发料WOID*/
     /* 1. 发料工序, 所有更新 */
     If AVAILABLE( xxwrddet ) then do:
        OkToUpdate = yes.

	message "1"  OkToUpdate wwolot wop view-as alert-box .

        leave.
     End.

     
     find first xxwrddet where xxwrddet.xxwrd_wolot = wwolot and
                               xxwrddet.xxwrd_op    = wop    and
			       xxwrddet.xxwrd_lastop      no-lock  no-error.      /* 最后一道工序*/
     /* 2.  数量不匹配*/

     If AVAILABLE( xxwrddet ) then do:
       IF xxwrddet.xxwrd_qty_comp + xxwrddet.xxwrd_qty_rejct <> xxwrddet.xxwrd_qty_ord then do:
          OkToUpdate = no.
	  	message "2"  OkToUpdate wwolot wop view-as alert-box .

	  leave.
       End.
     End.

    
     /* 当上一个WO ID没有更新MFG/PRO时,不更新MFG/PRO */
     Find first xxwrddet where xxwrddet.xxwrd_wolot > wwolot  and
                               xxwrddet.xxwrd_status <> "D"   and 
			       xxwrddet.xxwrd_wrnbr = wwrnbr  and
			       xxwrddet.xxwrd_lastop              /* 最后一道工序*/
                               USE-INDEX xxwrd_wolot     no-lock  no-error .
     If AVAILABLE( xxwrddet ) then do:

     /* 3. 上道工序已关闭 */
         If xxwrddet.xxwrd_close  then do:    /* 上一个 WOID 已更新MFG/PRO时 */
            OkToUpdate = yes.
   	    message "3"  OkToUpdate wwolot wop view-as alert-box .
            leave.
	 end.
	 else do:
     /* 4. 上个ID工序开放 */

            OkToUpdate = no.
   	    message "4"  OkToUpdate wwolot wop view-as alert-box .
            leave.
	 end.

     end.
 
END PROCEDURE.


/*


工单号             工单标志 项目号               工序 SFC关联号 工序完成 工序类型       订购数       合格数       报废数   返工开始数   返工完成数 设置时间 运行时间 机器       单位用量 lastop 最后工单ID 领退料完成 产品批号           工序已结
------------------ -------- ------------------ ------ --------- -------- -------- ------------ ------------ ------------ ------------ ------------ -------- -------- -------- ---------- -------- ---------- ---------- ------------------ --------
402924             532684   31-1589-48-01-R03       3         1 yes                       50.0         50.0          0.0          0.0          0.0     3900     2040 ZBJ30-01       1.00 yes      yes        yes        08121101           no
402924             532683   31-1589-48-01-R05       5         1 no                        50.0         45.0          5.0          6.0          6.0      900      180 ZBJ14-01       1.00 yes      no         no         08121101           no
402924             532682   31-1589-48-01-R10      10         1 no                        45.0         10.0          0.0          0.0          0.0        0       60 ZBJ29-01       1.00 yes      no         no         08121101           no
402924             532681   31-1589-48-01-R15      15         1 no                        45.0          0.0          0.0          0.0          0.0        0        0 ZBJ18-01       1.00 yes      no         no         08121101           no
402924             532680   31-1589-48-01-R20      20         1 no                        45.0          0.0          0.0          0.0          0.0        0        0 ZBJ14-01       1.00 yes      no         no         08121101           no
402924             532679   31-1589-48-01-R30      30         1 no                        45.0          0.0          0.0          0.0          0.0        0        0 ZBJ13-01       1.00 yes      no         no         08121101           no
402924             532678   31-1589-48-01          37         1 no                        45.0          0.0          0.0          0.0          0.0        0        0 ZBP01-01       1.00 no       no         no         08121101           no
402924             532678   31-1589-48-01          40         1 no                        45.0          0.0          0.0          0.0          0.0        0        0 ZBP03-02       1.00 no       no         no         08121101           no
402924             532678   31-1589-48-01          45         1 no                        45.0          0.0          0.0          0.0          0.0        0        0 ZBJ11-01       1.00 no       no         no         08121101           no
402924             532678   31-1589-48-01          50         1 no                        45.0          0.0          0.0          0.0          0.0        0        0 ZBQ05-01       1.00 no       no         no         08121101           no
402924             532678   31-1589-48-01          55         1 no                        45.0          0.0          0.0          0.0          0.0        0        0 ZBP05-01       1.00 no       no         no         08121101           no
402924             532678   31-1589-48-01          60         1 no                        45.0          0.0          0.0          0.0          0.0        0        0 ZBQ04-01       1.00 yes      no         no         08121101           no



   10 xxwrd_wonbr               char        i     X(18)
   20 xxwrd_wolot               char        i     X(8)
   30 xxwrd_part                char        i     X(18)
   40 xxwrd_op                  inte        i     >>>>>9          0
   50 xxwrd_wrnbr               inte        i     >>>>>9          0
   60 xxwrd_opfinish            logi              yes/no          no
   70 xxwrd_status              char              X(1)
   80 xxwrd_qty_ord             deci-10           ->,>>>,>>9.9,>>>,>>9.9,>>>,>>9.9,>>>,>>9.9,>>>,>>9.9>>>>>>9        0
  140 xxwrd_time_run            inte              >>>>>>>9        0
  160 xxwrd_wc                  char        i     x(8)
  170 xxwrd_qty_bom             deci-10           ->>,>>9.99      1
  180 xxwrd_lastop              logi              yes/no          no
  190 xxwrd_lastwo              logi              yes/no          no
  200 xxwrd_issok               logi              yes/no          no
  210 xxwrd_inv_lot             char              x(18)
  220 xxwrd_close               logi              yes/no          no
*/


/* CLOSE_CURRENT_ID-MOVE_WO_BILL-16_1-16_13_1  */
DEFINE VAR  CloseCurrID-MvBill as logical .
PROCEDURE P_CloseCurrID-MvBill :
   DEFINE INPUT  PARAMETER A-Wolot  like xxwrd_wolot .
   DEFINE OUTPUT PARAMETER CloseCurrID-MvBill as logical .
   CloseCurrID-MvBill = yes.

END PROCEDURE.


DEFINE VAR  CHANGE_BOM_UNIT-16_13_1 as logical .
PROCEDURE P_CHANGE_BOM_UNIT-16_13_1 :
   DEFINE INPUT  PARAMETER B-Wolot like xxwrd_wolot.
   DEFINE OUTPUT PARAMETER CHANGE_BOM_UNIT-16_13_1 as logical.
   DEFINE VARIABLE comp_reject like xxwrd_qty_comp.
   CHANGE_BOM_UNIT-16_13_1 = yes.

   find first tmpwrddet where tmpwrddet.xxwrd_wolot = B-Wolot and tmpwrddet.xxwrd_lastop = yes and tmpwrddet.xxwrd_lastwo no-lock no-error. 
   if AVAILABLE(tmpwrddet) then comp_reject = tmpwrddet.xxwrd_qty_comp + tmpwrddet.xxwrd_qty_rejct.
   if comp_reject = 0 then comp_reject = 1.
   
   for each wod_det where wod_lot = B-Wolot  no-lock :

	   usection = B-Wolot + "-CHANGE_BOM_UNIT-16_13_1" + "-" + trim ( wod_part ) + "-" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,10))) .
	   output to value( trim(usection) + ".i") .

          /*  取小数点,,,,,,,,,??*/
	  /*  记录log   OK */
	   display 
	       
	   "- " + B-Wolot  format "x(30)" skip
	   wod_part  format "x(20)"       skip
	   string ( wod_qty_pick ) +  " - - N " + string ( wod_qty_pick / comp_reject ) format "x(45)" skip
	   "." skip
	   "."

	   with fram finput no-box no-labels width 200.

	   output close.
           batchrun = yes.
	   input from value ( usection + ".i") .
	   output to  value ( usection + ".o") .
	  /*	{gprun.i ""wowamt.p""} */
	   input close.
	   output close.
	   ciminputfile = usection + ".i".
	   cimoutputfile = usection + ".o".
	   run datain.
	   run dataout.

           if  CimHaveError then  CHANGE_BOM_UNIT-16_13_1 = no.
  
  end.
END PROCEDURE.

    
DEFINE VAR  WO_BACKFLUSH-16_12 as logical .    
PROCEDURE P_WO_BACKFLUSH-16_12 :
   DEFINE INPUT  PARAMETER C-Wolot like xxwrd_wolot.
   DEFINE OUTPUT PARAMETER WO_BACKFLUSH-16_12 as logical .
   DEFINE VAR qty_ord like wo_qty_ord init 1.
   
   WO_BACKFLUSH-16_12 = yes.

   find first wo_mstr where wo_lot = C-Wolot  no-lock no-error. 
   if AVAILABLE(wo_mstr) then qty_ord = wo_qty_ord.

 
   for each xxwrd_det where xxwrd_det.xxwrd_wolot = C-Wolot and xxwrd_det.xxwrd_lastop = yes no-lock break by xxwrd_det.xxwrd_wolot desc   :
	   usection = C-Wolot + "-WO_BACKFLUSH-16_12" + "-" + trim ( xxwrd_det.xxwrd_part ) + "-" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,10)))  .
	   output to value( trim(usection) + ".i") .

	   display 
       
	   "- " + C-Wolot   format "x(30)"   " " effdate " Y  Y "  skip
	   xxwrd_det.xxwrd_qty_comp     " - - "   xxwrd_det.xxwrd_qty_rejct  " - - - - " 

	    if xxwrd_det.xxwrd_inv_lot = "" then ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)) ) else xxwrd_det.xxwrd_inv_lot 
	    
	    skip  

	   "SFC-Module Y " format "x(30)" skip
           "Y" skip
	   "Y" skip
	   if xxwrd_det.xxwrd_lastwo then qty_ord else xxwrd_det.xxwrd_qty_comp + xxwrd_det.xxwrd_qty_rejct skip  
	   "-" skip
	   "-" skip
	   "." skip
	   "Y" skip
	   "Y" skip
	   "Y" skip
	   "." skip

	   with fram finput2 no-box no-labels width 200.

	   output close.
           batchrun = yes.
	   input from value ( usection + ".i") .
	   output to  value ( usection + ".o") .
	  /* open-coming	 {gprun.i ""wowoisrc.p""}             */
	   input close.
	   output close.
	   ciminputfile = usection + ".i".
	   cimoutputfile = usection + ".o".
	   run datain.
	   run dataout.

           if  CimHaveError then  WO_BACKFLUSH-16_12 = no.

   end.
END PROCEDURE.


DEFINE VAR  CHG_NEXT_ID_ORDER_QTY-16_1 as logical .    
PROCEDURE P_CHG_NEXT_ID_ORDER_QTY-16_1 :
   DEFINE INPUT  PARAMETER D-Wolot like xxwrd_wolot.
   DEFINE OUTPUT PARAMETER CHG_NEXT_ID_ORDER_QTY-16_1 as logical .
   DEFINE VAR    wrnbr             like xxwrd_wrnbr.  /* 关联号 */
   DEFINE VAR    qty_comp          like xxwrd_qty_comp . 
   wrnbr    = 0 .
   qty_comp = 1  .
   CHG_NEXT_ID_ORDER_QTY-16_1 = yes.

   find first tmpwrddet where tmpwrddet.xxwrd_wolot = D-Wolot and tmpwrddet.xxwrd_lastop = yes  no-lock no-error. 
   if AVAILABLE(tmpwrddet) then  do :
      wrnbr    = tmpwrddet.xxwrd_wrnbr.
      qty_comp = tmpwrddet.xxwrd_qty_comp.
   end.

   for each xxwrd_det where xxwrd_det.xxwrd_wolot <> "D" no-lock break by xxwrd_det.xxwrd_op desc   :
   end.


END PROCEDURE.



DEFINE VAR  LABOR_FEEDBACK-17_1 as logical .    
PROCEDURE P_LABOR_FEEDBACK-17_1 :
   DEFINE INPUT  PARAMETER G-Wolot like xxwrd_wolot.
   DEFINE INPUT  PARAMETER wop     like xxwrd_op.
   DEFINE OUTPUT PARAMETER LABOR_FEEDBACK-17_1 as logical .
   LABOR_FEEDBACK-17_1 = yes.



   for each xxwrd_det where xxwrd_det.xxwrd_wolot = G-Wolot and xxwrd_status <> "D"  no-lock  break by xxwrd_op:


       /* 跨越天数 ???? */


       /**
       
           if xxfb_type = v_line_prev[1] then do:
        if xxfb_date_start = v_date then do:
            v_time_used = xxfb_time_end - xxfb_time_start .
        end.
        else do:
            v_time_used = (xxfb_date_end - xxfb_date_start) * (60 * 60 * 24) - xxfb_time_start + xxfb_time_end .
        end.

        find first xxwrd_det where xxwrd_wolot = xxfb_wolot and xxwrd_op = xxfb_op no-error .
        if avail xxwrd_Det then do:
            xxwrd_time_setup = xxwrd_time_setup + v_time_used .
         end.
       end.

       
       **/


       sumsetuptime = 0.
       sumruntime = 0.
       sumqtycomp = 0.

      
      for each xxfb_hist where xxfb_wolot = xxwrd_det.xxwrd_wolot and xxwrd_det.xxwrd_op = xxfb_op and xxfb_update = no and 
               ( xxfb_type = "11"  or     /* 设置时间 Time */
                 xxfb_type = "12"  or     /* 运行时间 Time */
                 xxfb_type = "13"  or     /* 完工反馈 Qty  */
                 xxfb_type = "14"  or     /* 报废反馈 Qty  */
                 xxfb_type = "15"       /* 返工反馈 Qty  */ )  break by xxfb_user by xxfb_wc by xxfb_type by xxfb_rsn_code :

		 if first-of(xxfb_wc) then do:
                    sumsetuptime = 0.
                    sumruntime = 0.
                    sumqtycomp = 0.
		    for each fbtmp : delete fbtmp. end.
		 end.
                 

                 if xxfb_type = "11" then sumsetuptime = sumsetuptime + xxfb_time_end - xxfb_time_start .
		 if xxfb_type = "12" then sumruntime   = sumruntime   + xxfb_time_end - xxfb_time_start.
		 if xxfb_type = "13" then sumqtycomp   = sumqtycomp   + xxfb_qty_fb.
                 

                 if xxfb_type = "14" then do:
		    find first fbtmp where rsn_type = "J" and rsn_code = xxfb_rsn_code  no-error.
		    if available fbtmp then rsn_qty = rsn_qty + xxfb_qty_fb. 
		    else do:
		    create fbtmp.
		    assign rsn_type = "J" 
		           rsn_code = xxfb_rsn_code
			   rsn_qty  = xxfb_qty_fb.
		    end.
		 end.
                 if xxfb_type = "15" then do:
		    find first fbtmp where rsn_type = "R" and rsn_code = xxfb_rsn_code  no-error.
		    if available fbtmp then rsn_qty = rsn_qty + xxfb_qty_fb. 
		    else do:
		    create fbtmp.
		    assign rsn_type = "R" 
		           rsn_code = xxfb_rsn_code
			   rsn_qty  = xxfb_qty_fb.
		    end.

		 end.
                 if last-of (xxfb_wc) then do:
                    
		    usection = G-Wolot + "-LABOR_FEEDBACK-17_1" + "-" + string ( xxfb_op ) + "-" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,10)))  .
		    output to value( trim(usection) + ".i") .

		    display 
		       
		     "- " + G-wolot + " " + string ( xxfb_op ) format "x(45)" skip
                     if xxfb_user  "" then xxfb_user else " - "
		     " - - " +  trim ( xxfb_wc )   format "x(30)"  skip
                     sumqtycomp  
		     with fram finput4 no-box no-labels width 200.


		     find first fbtmp where rsn_type = "J" no-error.
		     display if available ( fbtmp ) then " Y " else  " N "  with fram finput4 no-box no-labels width 200.

		     find first fbtmp where rsn_type = "R" no-error.
		     display if available ( fbtmp ) then " Y " else  " N "  with fram finput4 no-box no-labels width 200.


                     display effdate " - - - -  "  sumsetuptime " - " sumruntime  " SFC-Module" skip with fram finput4 no-box no-labels width 200.

                     for each fbtmp where rsn_type = "J" :
		         display rsn_code skip
			         rsn_qty  skip
				 with fram finput4 no-box no-labels width 200 .
		     end. 
		     find first fbtmp where rsn_type = "J" no-error.
                     if available ( fbtmp ) then display "." skip with fram finput4 no-box no-labels width 200.                  


                     for each fbtmp where rsn_type = "R" :
		         display rsn_code skip
			         rsn_qty  skip
				 with fram finput4 no-box no-labels width 200 .
		     end. 
		     find first fbtmp where rsn_type = "R" no-error.
                     if available ( fbtmp ) then display "." skip with fram finput4 no-box no-labels width 200.

                      display 
		      
		      "Y" skip
		      "." skip

		   with fram finput4 no-box no-labels width 200.

		   output close.

		   batchrun = yes.
		   input from value ( usection + ".i") .
		   output to  value ( usection + ".o") .
		  /*	{gprun.i ""sfoptr01.p""}   */
		   input close.
		   output close.
		   ciminputfile = usection + ".i".
		   cimoutputfile = usection + ".o".
		   run datain.
		   run dataout.

		   if  CimHaveError then  LABOR_FEEDBACK-17_1 = no.

		 end.
      end.  /* for each fb_hist where xxfb_wolot = xxwrd_det.xxwrd_wolot */
   end.   /* for each xxwrd_det where xxwrd_det.xxwrd_wolot = G-Wolot */

END PROCEDURE.

/*


工单类型   交易号 指令代码 执行日期 开始日期 结束日期 执行时间 开始时间 结束时间         数量 原因代码 备注               已更新 用户名   机器     工单号             工单标志 项目号               工序 指令描述 程式         单号
-------- -------- -------- -------- -------- -------- -------- -------- -------- ------------ -------- ------------------ ------ -------- -------- ------------------ -------- ------------------ ------ -------- ------------ --------
                1 11       08/12/11 08/12/11 08/12/11    33780    33780    37500          0.0                             no     zbc2     ZBJ30-01 402924             532684   31-1589-48-01-R03       3 设置时间 xstimesetup.
                2 12       08/12/11 08/12/11 08/12/11    37500    37500    37740          0.0                             no     zbc2     ZBJ30-01 402924             532684   31-1589-48-01-R03       3 运行时间 xstimerun.p
                8 13       08/12/11 08/12/11 08/12/11    39720    39720    39720         50.0                             no     zbc2     zbj30-01 402924             532684   31-1589-48-01-R03       3 完工反馈 xsfbfinish.p


		9 13       08/12/11 08/12/11 08/12/11    40080    40080    40080         40.0                             no     zbc2     zbj14-01 402924             532683   31-1589-48-01-R05       5 完工反馈 xsfbfinish.p
               10 14       08/12/11 08/12/11 08/12/11    40680    40680    40680          4.0 10       Reject/工艺        no     zbc2     zbj14-01 402924             532683   31-1589-48-01-R05       5 报废反馈 xsfbscrap.p
               11 14       08/12/11 08/12/11 08/12/11    40740    40740    40740          4.0 10       Reject/工艺        no     zbc2     zbj14-01 402924             532683   31-1589-48-01-R05       5 报废反馈 xsfbscrap.p
               12 14       08/12/11 08/12/11 08/12/11    40740    40740    40740         -4.0 10       Reject/工艺        no     zbc2     zbj14-01 402924             532683   31-1589-48-01-R05       5 报废反馈 xsfbscrap.p
               13 15       08/12/11 08/12/11 08/12/11    41100    41100    41100          2.0 10       Rework/工艺        no     zbc2     zbj14-01 402924             532683   31-1589-48-01-R05       5 返工反馈 xsfbrework.p
               14 15       08/12/11 08/12/11 08/12/11    41460    41460    41460          4.0 12       Rework/量具        no     zbc2     zbj14-01 402924             532683   31-1589-48-01-R05       5 返工反馈 xsfbrework.p

   10 xxfb_wotype               char              X(1)
   20 xxfb_trnbr                inte        i     >>>>>>>>        0
   30 xxfb_type                 char        i     X(3)
   40 xxfb_date                 date        i     99/99/99        ?
   50 xxfb_date_start           date              99/99/99        ?
   60 xxfb_date_end             date              99/99/99        ?
   70 xxfb_time                 inte              >>>>>>>9        0
   80 xxfb_time_start           inte              >>>>>>>9        0
   90 xxfb_time_end             inte              >>>>>>>9        0
  100 xxfb_qty_fb               deci-10           ->,>>>,>>9.9>>>>9          0
  200 xxfb_type2                char              x(8)
  210 xxfb_program              char              x(12)
  220 xxfb_nbr                  char              x(8)

*/


PROCEDURE UpdateMFGPRO :
    DEFINE INPUT  PARAMETER uWolot   like xxwrd_wolot.
    DEFINE INPUT  PARAMETER uStatus  like xxwrd_status.    /* D 表示 DELET */
    DEFINE INPUT  PARAMETER uLastwo  like xxwrd_lastwo.    /* = yes  发料WO ID*/
    DEFINE OUTPUT PARAMETER UpdateMessage   AS char.
    DEFINE OUTPUT PARAMETER UpdateSuccess   AS logical init no.
    
    UpdateSuccess = no.
    UpdateMessage = "".

    IF uLastwo = no and uStatus = "D" then do:
       /* 1. CLOSE Current WO123    CIM 16.1 */
       /* 2. CLOSE MOVE WO123'WO BILL TO WO124  CIM 16.13.1  */
       RUN P_CloseCurrID-MvBill ( INPUT uWolot , OUTPUT CloseCurrID-MvBill ) .
       IF CloseCurrID-MvBill then do:
          UpdateSuccess = yes.
	  leave.
       end.
       else do:
          UpdateMessage = "关闭删除WOID,移动WOBILL出错!".
          UpdateSuccess = no.
	  leave.
       end.
    end.

    IF uLastwo = no and uStatus  "D" then do:
       /* 不是最大ID,不被删除,正常处理 */
    end.

    IF uLastwo = Yes and uStatus = "D" then do:   
          UpdateMessage = "第大的WO ID 不能删除!".
          UpdateSuccess = no.
	  leave.
    end.

    IF uLastwo = Yes and uStatus  "D" then do:   
       RUN P_CHANGE_BOM_UNIT-16_13_1 (INPUT uWolot , OUTPUT CHANGE_BOM_UNIT-16_13_1 ). 
       IF CHANGE_BOM_UNIT-16_13_1 then UpdateSuccess = yes.
       else do :
          UpdateMessage = "更新单位用量出错,请查询sfc.err!".
          UpdateSuccess = no.
	  leave.
       end.
    End.
     
    

    If UpdateSuccess = yes then do:
       RUN P_CHG_NEXT_ID_ORDER_QTY-16_1 (INPUT uWolot , OUTPUT CHG_NEXT_ID_ORDER_QTY-16_1).
       IF CHG_NEXT_ID_ORDER_QTY-16_1 THEN UpdateSuccess = yes .
       else do:
          UpdateMessage = "修改WO ORDER QTY 有误,请查看sfc.err!".
	  UpdateSuccess = no.
	  leave.
       end.
    end.

    RUN P_WO_BACKFLUSH-16_12(INPUT uWolot , OUTPUT WO_BACKFLUSH-16_12 ).
    IF WO_BACKFLUSH-16_12 then UpdateSuccess = yes.
    else do:
       UpdateMessage = "工单反馈出错!".
       UpdateSuccess = no.
       leave.
    end.

	
    If UpdateSuccess = no then leave.

    /* Labor Feedback */
    For each xxwrd_det where xxwrd_det.xxwrd_wolot = uWolot use-index xxwrd_wolot  :

        If xxwrd_det.xxwrd_status  = "N" then do:
  	   RUN P_ADD_ID_ROUTING-16_13_13 (INPUT uWolot , INPUT xxwrd_det.xxwrd_op , OUTPUT ADD_ID_ROUTING-16_13_13 ).
           IF ADD_ID_ROUTING-16_13_13 THEN UpdateSuccess = yes .
           else do:
              UpdateMessage = "新增工序 " + string ( xxwrd_det.xxwrd_op ).
	      UpdateSuccess = no.
           end.
           
        end.


       If xxwrd_det.xxwrd_status  = "D" then do:
  	   RUN P_CLOSE_ID_ROUTING-16_13_13 (INPUT uWolot , INPUT xxwrd_det.xxwrd_op , OUTPUT CLOSE_ID_ROUTING-16_13_13 ).
           IF CLOSE_ID_ROUTING-16_13_13 THEN UpdateSuccess = yes .
           else do:
              UpdateMessage = "删除工序 " + string ( xxwrd_det.xxwrd_op ).
	      UpdateSuccess = no.
           end.
       end.

       If xxwrd_det.xxwrd_status   "D" then do:
  	   RUN P_LABOR_FEEDBACK-17_1 (INPUT uWolot , INPUT xxwrd_det.xxwrd_op , OUTPUT LABOR_FEEDBACK-17_1 ).
           IF LABOR_FEEDBACK-17_1 THEN do:
	      UpdateSuccess = yes .
           END.
           else do:
              UpdateMessage = "工时反馈 " + string  ( xxwrd_det.xxwrd_op ).
	      UpdateSuccess = no.
           end.
       end.
    End.

END PROCEDURE.


For each xywrddet where xywrddet.xxwrd_close = no and xywrddet.xxwrd_lastop = yes  break by xywrddet.xxwrd_wolot desc by xywrddet.xxwrd_op desc  :
         
         RUN OkToUpdateMFGPRO (INPUT xywrddet.xxwrd_wolot , INPUT xywrddet.xxwrd_op ,INPUT xywrddet.xxwrd_wrnbr, OUTPUT OkToUpdate).

         IF OkToUpdate = yes then do:
	    RUN UpdateMFGPRO (INPUT xywrddet.xxwrd_wolot , INPUT xywrddet.xxwrd_status , 
	                      INPUT xywrddet.xxwrd_lastwo ,OUTPUT UpdateMessage , OUTPUT UpdateSuccess).
            If UpdateSuccess = no then do:
	       message "Failure to Update MFG/PRO "  view-as alert-box  .
	    end.
	    else do:
	      /* open-coming 
	      for each fb_hist where fb_wolot = uWolot :
	          fb_close = yes.   
	      end.
	      for each xywrd_det where xywrd_det.xxwrd_wolot = uWolot  :
	          xywrd_close = yes.
	      end.
              */
    	       message "Success to Update MFG/PRO "  view-as alert-box  .


	    end.


	 End.

End.

hide frame a.

