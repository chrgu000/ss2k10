/* xxupdatem.p  按月更新                                                   */
/* REVISION: 1.0         Last Modified: 2008/12/11   By: SamSong  NO ECO:  */
/*-Revision end------------------------------------------------------------*/


/*************************************************************以下为版本历史 */                                                             
/* SS - 090330.1 By: Roger Xiao */

/*************************************************************以下为发版说明 */
/* SS - 090330.1 - RNB
1.原版本为在SFC运行的程式,Roger本次修改为在MFGPRO运行
2.默认的输入输出路径相应要由默认的当前路径改回到SFC的tmp路径
3.加会计期间检查
SS - 090330.1 - RNE */

/* DISPLAY TITLE */
/* SS - 090330.1 - B */
{mfdtitle.i "090330.1"}

define var v_tmp_path as char format "x(30)" . /*默认输入输出路径*/
v_tmp_path = "/mfgeb2/bc_test/tmp_sfc/" .  /*程式中的每个'v_tmp_path +',都是本次直接添加,未作ECO */
    
{gpglefv.i} /*var for xsglefchk001.i (gpglef1.p) */

/* SS - 090330.1 - E */


/*SS - 090330.1 - B 

{mfdeclre.i}    /*mfgpro global vars & functions*/
{gplabel.i}     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */ 

SS - 090330.1 - E */



define var updatebymanual as logical init yes.
define var effdate        like tr_effdate init today.
define var vwolot         like xxwrd_wolot init "*".
define var debugonly      as logical init yes.

Define variable OkToUpdate as logical init no.
Define variable UpdateMessage as char.
Define Variable UpdateSuccess as logical init no.


Define buffer xxwrddet for xxwrd_det.
Define buffer xywrddet for xxwrd_det.
Define buffer tmpwrddet for xxwrd_det.

define variable ciminputfile   as char .
define variable cimoutputfile  as char .
define variable usection as char format "x(16)".

/*SS - 090330.1 - B 
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="global_user_lang_dir" no-lock no-error. /*  Update MFG/PRO Directory */
if AVAILABLE(code_mstr) Then global_user_lang_dir = trim ( code_cmmt ).
if substring(global_user_lang_dir, length(global_user_lang_dir), 1)  = "/" then global_user_lang_dir = global_user_lang_dir + "/".
SS - 090330.1 - E */


Def temp-table fbtmp 
      field rsn_type as char 
      field rsn_code like xxfb_rsn_code
      field rsn_qty  like xxfb_qty_fb.
define variable  sumsetuptime AS DECIMAL DECIMALS 2 .
define variable  sumruntime   AS DECIMAL DECIMALS 2.
define variable  sumqtycomp   AS DECIMAL DECIMALS 2.


form
    skip(1)
    vwolot            colon 20  label "WO ID ( * = ALL)"
    updatebymanual    colon 20  label "确认运行"
    
    effdate           colon 20  label "生效日期" 
    skip(1)
    debugonly    colon 20  label "弹出提示信息"

    skip(1)
with frame a 
title color normal "更新MFG/PRO数据BY(月) => 部分也更新"
side-labels width 50 
row 8 centered overlay .   

view frame a .

repeat :
	Update vwolot updatebymanual  effdate  debugonly with frame a.  
	hide frame a.

	if updatebymanual = no or effdate = ?  then do:
	   hide frame a.
	   leave.
	end.
	if vwolot <> "*" then do: 
		find first xxwrd_det where    xxwrd_det.xxwrd_wolot = vwolot 
					      no-lock no-error .
		If NOT AVAILABLE( xxwrd_det ) then do:
		   hide frame a.
		   leave.
		end.
	end.


	hide frame a.

/* SS - 090330.1 - B */
    {xsglefchk001.i &module =""IC""  &entity =""""  &date =effdate }   /*会计期间检查*/
/* SS - 090330.1 - E */    


	Define variable Eoutputstatment AS CHARACTER FORMAT "x(200)".
	Define variable Eonetime        AS CHARACTER FORMAT "x(1)" init "N".
	Define Variable CimHaveError    AS logical init no.
	PROCEDURE datain.
		Eoutputstatment = "".
		Define variable outputstatment AS CHARACTER FORMAT "x(200)".
		input from value (v_tmp_path +  ciminputfile) .
		output to  value (v_tmp_path + "sfc.lg") APPEND.
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
		input from value (v_tmp_path +  cimoutputfile) .
		    Do While True:
			  IMPORT UNFORMATTED woutputstatment.

			  IF index (woutputstatment,"ERROR:") <>  0 OR    /* for us langx */
			     index (woutputstatment,"错误:")  <>  0 OR    /* for ch langx */
			     index (woutputstatment,"岿粇:")  <>  0 OR
			     index (woutputstatment,"(87)")   <>  0 OR      
			     index (woutputstatment,"(557)")  <>  0 OR      
			     index (woutputstatment,"(1896)") <>  0 OR      
			     index (woutputstatment,"(143)")  <>  0       
			     
			     then do:
				  output to  value (v_tmp_path +  "sfc.lg") APPEND.
				  put  unformatted skip(1) today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " cimoutputfile " " woutputstatment  skip.
				  output close.
				   
				  CimHaveError = yes.
				  output to  value (v_tmp_path +  "sfc.err") APPEND.
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

             /* SAMSONG 20081229 */
	     find first xxfb_hist where xxfb_wolot = wwolot and xxfb_update = no and 
		        ( xxfb_type = "11" or xxfb_type = "12"  ) and ( xxfb_date_start = ? or  xxfb_date_end = ? )   no-lock no-error .

	     /* 6. Start Or End Time = ? */
	     If AVAILABLE( xxfb_hist ) then do:
		OkToUpdate = no.
		if debugonly = yes then message "0.工序时间有误,工序/OP:" + wwolot + "/" + string(xxfb_op) + ",可以更新="  OkToUpdate  view-as alert-box .
		leave.
	     End.
             /* SAMSONG 20081229 */


	     Find first xxwrddet where xxwrddet.xxwrd_wolot = wwolot and
				       xxwrddet.xxwrd_op    = wop    and
				       xxwrddet.xxwrd_close = no     and
				       xxwrddet.xxwrd_lastop         and    /* 最后一道工序*/
				       xxwrddet.xxwrd_lastwo          
					no-lock no-error .   /* 发料WOID*/
	     /* 1. 发料工序, 所有更新 */
	     If AVAILABLE( xxwrddet ) then do:
                /*20081226    判断第一道工序是否  1.已完成,2.退料已完成 */
		if  xxwrddet.xxwrd_opfinish       and    /* 发料工序  反馈完成*/
		    xxwrddet.xxwrd_issok          and 
		    xxwrddet.xxwrd_qty_comp + xxwrddet.xxwrd_qty_rejct = xxwrddet.xxwrd_qty_ord
		    
		    then do :    /* 发料工序  退料完成*/

		    OkToUpdate = yes.
		    if debugonly = yes then message "1.发料工序,工序/OP:" + wwolot + "/" + string(wop) + ",可以更新="  OkToUpdate  view-as alert-box .
		end.
		else do:
                   
	           Find first xxwrddet where xxwrddet.xxwrd_wolot = wwolot and
				       xxwrddet.xxwrd_op    <> wop   and
				       xxwrddet.xxwrd_close = no     and
				       xxwrddet.xxwrd_status <> "D"   no-lock no-error.          

                    If AVAILABLE( xxwrddet ) then do:  /* 多道工序 */
   		       OkToUpdate = no.
		       if debugonly = yes then message "1.5 工序OR退料未完成OR数量不匹配,工序/OP:" + wwolot + "/" + string(wop) + ",可以更新="  OkToUpdate  view-as alert-box .
		    end.
		    else do:
        		OkToUpdate = yes.             /*  发料工序 只有一道工序*/
          	        if debugonly = yes then message "1.发料工序,工序/OP:" + wwolot + "/" + string(wop) + ",可以更新="  OkToUpdate  view-as alert-box .

		    end.
		end.



		leave.
	     End.

	     
	     find first xxwrddet where xxwrddet.xxwrd_wolot = wwolot and
				       xxwrddet.xxwrd_op    = wop    and
				       xxwrddet.xxwrd_status <> "D"  and
				       xxwrddet.xxwrd_lastop     
				       no-lock  no-error.      /* 最后一道工序*/
	     /* 2.  数量不匹配*/

	     If AVAILABLE( xxwrddet ) then do:
	       IF xxwrddet.xxwrd_qty_comp + xxwrddet.xxwrd_qty_rejct <> xxwrddet.xxwrd_qty_ord then do:
		  OkToUpdate = no.

		  if debugonly = yes then message "2.数量不匹配,工序/OP:" + wwolot + "/" + string(wop) + ",可以更新="  OkToUpdate  view-as alert-box .

		  leave.
	       End.
	     End.

	    
	     /* 当上一个WO ID没有更新MFG/PRO时,不更新MFG/PRO */
	     Find first xxwrddet where xxwrddet.xxwrd_wolot > wwolot  and
				       xxwrddet.xxwrd_wrnbr = wwrnbr  and
				       xxwrddet.xxwrd_lastop              /* 最后一道工序*/
				       USE-INDEX xxwrd_wolot     no-lock  no-error .
	     If AVAILABLE( xxwrddet ) then do:

	     /* 3.上道工序已关闭 */
		 If xxwrddet.xxwrd_close  then do:    /* 上一个 WOID 已更新MFG/PRO时 */
		    OkToUpdate = yes.
		    if debugonly = yes then message "3.上道工序已关闭,工序/OP:" + wwolot + "/" + string(wop) + ",可以更新="  OkToUpdate  view-as alert-box .
		    leave.
		 end.
		 else do:
	     /* 4. 上个ID工序开放 */

		    OkToUpdate = no.
		    if debugonly = yes then message "4.上道工序未关闭,工序/OP:" + wwolot + "/" + string(wop) + ",可以更新="  OkToUpdate  view-as alert-box .

		    leave.
		 end.

	     end.
	 
	    find first xxwrddet where xxwrddet.xxwrd_wolot = wwolot and
				      xxwrddet.xxwrd_op    = wop    and
				      xxwrddet.xxwrd_lastop         and    /* 最后一道工序*/
				      xxwrddet.xxwrd_status = "D"  
				      no-lock no-error .   /* 发料WOID*/
	     /* 5. Delete OP */
	     If AVAILABLE( xxwrddet ) then do:
		OkToUpdate = yes.
		if debugonly = yes then message "5.工序被删除,工序/OP:" + wwolot + "/" + string(wop) + ",可以更新="  OkToUpdate  view-as alert-box .
		leave.
	     End.

             



	END PROCEDURE.




	DEFINE VAR  Close_ID-Clear_Bill-Add_Bill as logical .
	PROCEDURE P_Close_ID-Clear_Bill-Add_Bill :
	   DEFINE INPUT  PARAMETER A-Wolot  like xxwrd_wolot .
	   DEFINE INPUT  PARAMETER A-Wrnbr  like xxwrd_wrnbr.
	   DEFINE OUTPUT PARAMETER Close_ID-Clear_Bill-Add_Bill as logical .
	   DEFINE VAR    NextID             like xxwrd_wolot init "".      /*Current ID = 532706 , NEXT ID = 532705*/
	   DEFINE VAR    PreID              like xxwrd_wolot init "".      /*Current ID = 532706 , PreID   = 532707*/
	   DEFINE VAR    NextQty             like xxwrd_qty_comp init 0 .      /*Current ID = 532706 , PreID   = 532707*/

	   Close_ID-Clear_Bill-Add_Bill = yes.


	   usection = A-Wolot + "<" + "Close_ID-16_1" + "<" + trim ( A-Wolot )  + "<" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,10))) . 

	   output to value(v_tmp_path +  trim(usection) + ".i") .

	   display 
	    "- " + A-Wolot   format "x(30)"  skip
	    "-  ? ? ? C "    format "x(20)" skip
	    "-" skip
	    "-" skip
	    "-" skip
	    "." skip
	  
	   with fram finputA no-box no-labels width 200.

	   output close.
	   batchrun = yes.
	   input from value (v_tmp_path +  usection + ".i") .
	   output to  value (v_tmp_path +  usection + ".o") .
	   {gprun.i ""wowomt.p""} 
	   input close.
	   output close.
	   ciminputfile = usection + ".i".
	   cimoutputfile = usection + ".o".
	   run datain.
	   run dataout.

	   if  CimHaveError then  do :
	       Close_ID-Clear_Bill-Add_Bill = no.
	       leave.
	   end.

	   PreID  = "".
	   NextID = "".
	   NextQty = 0.
	   for  each tmpwrddet where tmpwrddet.xxwrd_wolot < A-Wolot and tmpwrddet.xxwrd_wrnbr =  A-Wrnbr and tmpwrddet.xxwrd_lastop = yes  /* and tmpwrddet.xxwrd_status <> "D"  */
			    no-lock break by  xxwrd_wolot desc  :
		If first-of(xxwrd_wolot) then do:
		   NextID  = tmpwrddet.xxwrd_wolot .     /* IF Current ID = 532706 , THEN NEXT ID = 532705*/
		   NextQty = tmpwrddet.xxwrd_qty_ord.
		   leave.
		end.
	   end.


	   for each  tmpwrddet where tmpwrddet.xxwrd_wolot > A-Wolot and tmpwrddet.xxwrd_wrnbr =  A-Wrnbr and tmpwrddet.xxwrd_lastop = yes /* and tmpwrddet.xxwrd_status <> "D"   */
			       no-lock break by  xxwrd_wolot : 

		If first-of (xxwrd_wolot)then do :
		   PreID   = tmpwrddet.xxwrd_wolot .     /* IF Current ID = 532706 , THEN Pre ID = 532707*/

		   /* PreQty  = tmpwrddet.xxwrd_qty_comp . /*  ?????  上道工序的完成数量 ,上道工序没有完成不要删除......... ?  ? */ */
		   
		end.
	 
	   end.

	   if PreID = "" then do:   /* 第一道工序被删除 , 在输入画面控制 */
	      Close_ID-Clear_Bill-Add_Bill = no.
	      leave.
	   end.
	   if NextID = "" then do:  /* 删除成品WO ID , 不用修改WO BILL */
	      Close_ID-Clear_Bill-Add_Bill = yes.
	      leave.
	   end.
	       
	   /**************Clear BOM FOR NEXT ID  *******/
	   for each wod_det where wod_lot = NextID  no-lock :
		   usection = A-Wolot + "<" + "Clear_BOM-16_13_1" + "<" + trim (NextID) + "<" + trim ( wod_part ) + "<" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,10))) .
		   output to value(v_tmp_path +  trim(usection) + ".i") .

		   put 		       
		   "- " + NextID  format "x(30)" skip
		   wod_part  format "x(20)"       skip
		   " 0 0 0 N 0 0"  format "x(30)" skip
		   "." skip
		   ".".

		   output close.
		   batchrun = yes.
		   input from value (v_tmp_path +  usection + ".i") .
		   output to  value (v_tmp_path +  usection + ".o") .
		   {gprun.i ""wowamt.p""} 
		   input close.
		   output close.
		   ciminputfile = usection + ".i".
		   cimoutputfile = usection + ".o".
		   run datain.
		   run dataout.
		   if  CimHaveError then do :
		       Close_ID-Clear_Bill-Add_Bill = no.
		       leave.
		   end.
	  
	  end.

	  /**************ADD BOM FOR NEXT ID  *******/
	  if Close_ID-Clear_Bill-Add_Bill = yes then do:
		   for each wod_det where wod_lot = A-Wolot and wod_bom_amt <> 0   no-lock :
			   usection = A-Wolot + "<" + "ADD_BOM-16_13_1" + "<" + trim (NextID) + "<" + trim ( wod_part ) + "<" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,10))) .
			   output to value(v_tmp_path +  trim(usection) + ".i") .

			   put 		       
			   "- " + NextID  format "x(30)" skip
			   wod_part  format "x(20)"       skip
			   NextQty " 0 0 N  1 " wod_bom_amt  skip
			   "." skip
			   ".".

			   output close.
			   batchrun = yes.
			   input from value (v_tmp_path +  usection + ".i") .
			   output to  value (v_tmp_path +  usection + ".o") .
			   {gprun.i ""wowamt.p""} 
			   input close.
			   output close.
			   ciminputfile = usection + ".i".
			   cimoutputfile = usection + ".o".
			   run datain.
			   run dataout.
			   if  CimHaveError then do :
			       Close_ID-Clear_Bill-Add_Bill = no.
			       leave.
			   end.
		  
		  end.  /*  for each wod_det where wod_lot = A-Wolot */

	  end.



	END PROCEDURE.

	DEFINE VAR  ADD_ID_ROUTING-16_13_13 as logical .
	PROCEDURE P_ADD_ID_ROUTING-16_13_13 :
	   DEFINE INPUT  PARAMETER Y-Wolot  like xxwrd_wolot .
	   Define INPUT  PARAMETER wop      like xxwrd_op.
	   Define INPUT  PARAMETER wwc      like xxwrd_wc.
	   Define INPUT  PARAMETER wopname  like xxwrd_opname.
	   DEFINE OUTPUT PARAMETER ADD_ID_ROUTING-16_13_13 as logical .
	   ADD_ID_ROUTING-16_13_13 = yes.
	   


	   find first wr_route where wr_lot = Y-wolot and wr_op = wop no-lock no-error . /* Release Routing Status */
	   if NOT AVAILABLE(wr_route) then do:
		   usection = Y-Wolot + "<" + "ADD_ID_ROUTING-16_13_13" + "<" + string ( wop ) + "<" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,10))) .
		   output to value(v_tmp_path +  trim(usection) + ".i") .

		   display 
		       
		   "- " + Y-Wolot  format "x(30)" skip
		   wop    skip
		   " "    skip
		   """" + wopname + """" format "x(26)"  " "     wwc     skip
		   "." skip
		   "." skip
		   with fram finputY no-box no-labels width 200.

		   output close.
		   batchrun = yes.
		   input from value (v_tmp_path +  usection + ".i") .
		   output to  value (v_tmp_path +  usection + ".o") .
		   {gprun.i ""woopmt.p""}
		   input close.
		   output close.
		   ciminputfile = usection + ".i".
		   cimoutputfile = usection + ".o".
		   run datain.
		   run dataout.

		   if  CimHaveError then  ADD_ID_ROUTING-16_13_13 = no.
	  end.   
	END PROCEDURE.

	DEFINE VAR  CLOSE_ID_ROUTING-16_13_13 as logical .
	PROCEDURE P_CLOSE_ID_ROUTING-16_13_13 :
	   DEFINE INPUT  PARAMETER K-Wolot  like xxwrd_wolot .
	   Define INPUT  PARAMETER wop      like xxwrd_op.
	   Define INPUT  PARAMETER wwc      like xxwrd_wc.

	   DEFINE OUTPUT PARAMETER CLOSE_ID_ROUTING-16_13_13 as logical .
	   CLOSE_ID_ROUTING-16_13_13 = yes.

	   usection = K-Wolot + "<" + "CLOSE_ID_ROUTING-16_13_13" + "<" + string ( wop ) + "<" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,10))) .

	   for each wr_route where wr_lot = K-Wolot and wr_op = wop : /* Close Routing Status */
	       wr_route.wr_status  = "C".
	   end.

	   output to value(v_tmp_path +  trim(usection) + ".i") .

	   display 
	       
	   "- " + K-Wolot  format "x(30)" skip
	   wop    skip
	   "SFC_CLOSE"    wwc   fill(" -" , 20) format "x(60)"  " C " skip
	   "." skip
	   "." skip
	   with fram finputK no-box no-labels width 200.

	   output close.
	   batchrun = yes.
	   input from value (v_tmp_path +  usection + ".i") .
	   output to  value (v_tmp_path +  usection + ".o") .
	  /*  {gprun.i ""woopmt.p""} */
	   input close.
	   output close.

	   ciminputfile = usection + ".i".
	   cimoutputfile = usection + ".o".
	   run datain.
	   run dataout.

	   if  CimHaveError then  CLOSE_ID_ROUTING-16_13_13 = no.


	END PROCEDURE.



	DEFINE VAR  CHANGE_BOM_UNIT-16_13_1 as logical .
	PROCEDURE P_CHANGE_BOM_UNIT-16_13_1 :
	   DEFINE INPUT  PARAMETER B-Wolot like xxwrd_wolot.
	   DEFINE OUTPUT PARAMETER CHANGE_BOM_UNIT-16_13_1 as logical.
	   DEFINE VARIABLE comp_reject like xxwrd_qty_comp.
	   Define var bom_unit AS DECIMAL DECIMALS 2 .
	   bom_unit = 0.

	   CHANGE_BOM_UNIT-16_13_1 = yes.

	   find first tmpwrddet where tmpwrddet.xxwrd_wolot = B-Wolot and tmpwrddet.xxwrd_lastop = yes and tmpwrddet.xxwrd_lastwo no-lock no-error. 
	   if AVAILABLE(tmpwrddet) then do :
	      comp_reject = tmpwrddet.xxwrd_qty_comp + tmpwrddet.xxwrd_qty_rejct.
	   end.
	   if comp_reject = 0 then comp_reject = 1.
	   for each wod_det where wod_lot = B-Wolot  no-lock :

		   bom_unit = wod_qty_pick / comp_reject .
		   usection = B-Wolot + "<" + "CHANGE_BOM_UNIT-16_13_1" + "<" + trim ( wod_part ) + "<" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,10))) .
		   output to value(v_tmp_path +  trim(usection) + ".i") .

		   put 		       
		   "- " + B-Wolot  format "x(30)" skip
		   wod_part  format "x(20)"       skip
		   string ( wod_qty_pick ) +  " - - N " + string ( bom_unit ) format "x(45)" skip
		   "." skip
		   ".".

		   output close.
		   batchrun = yes.
		   input from value (v_tmp_path +  usection + ".i") .
		   output to  value (v_tmp_path +  usection + ".o") .
		   {gprun.i ""wowamt.p""} 
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
	   DEFINE VAR Sum_Reject_Qty like xxwrd_qty_rejct init 0.
	   DEFINE VAR Ord_Qty         like xxwrd_qty_rejct init 0.
	   
	   WO_BACKFLUSH-16_12 = yes.


	   for each tmpwrddet where tmpwrddet.xxwrd_wolot = C-Wolot :
	       Sum_Reject_Qty  = Sum_Reject_Qty  + tmpwrddet.xxwrd_qty_rejct.
	   end.
	   for each wo_mstr where wo_lot = C-Wolot :
	       Ord_Qty = wo_qty_ord.
	   end.
	 
	   for each xxwrd_det where xxwrd_det.xxwrd_wolot = C-Wolot and xxwrd_det.xxwrd_lastop = yes and xxwrd_det.xxwrd_status <> "D" no-lock break by xxwrd_det.xxwrd_wolot desc   :
		   usection = C-Wolot + "<" + "WO_BACKFLUSH-16_12" + "<" + trim ( xxwrd_det.xxwrd_part ) + "<" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,10)))  .
		   output to value(v_tmp_path +  trim(usection) + ".i") .

		   put  
	       
		   "- " + C-Wolot   format "x(30)"   " " effdate " Y  Y "  skip  .

		   if xxwrd_det.xxwrd_lastwo = yes then put  xxwrd_det.xxwrd_qty_comp     " - - "   0  " - - - - " .
		   if xxwrd_det.xxwrd_lastwo = no  then put  xxwrd_det.xxwrd_qty_comp     " - - "   Sum_Reject_Qty  " - - - - " .

		    put 
		    if xxwrd_det.xxwrd_inv_lot = "" then ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)) ) else xxwrd_det.xxwrd_inv_lot  format "x(18)"
		    
		    skip  

		   "SFC-Module Y " format "x(30)" skip
		   "Y" skip
		   "Y" skip 
		    if xxwrd_det.xxwrd_lastwo = yes then  string( Ord_Qty  ) else "-"  
		    skip  
		   
		   "-" skip
		   "-" skip .


		   if xxwrd_det.xxwrd_lastwo = no then do:   /* 不是发料工序 */
		      for each wod_det where wod_lot = xxwrd_det.xxwrd_wolot no-lock :
			   put 
			   wod_part format "x(18)"   if  wod_op  = 0 then " - " else " " + string ( wod_op ) skip

			   " - - - - - " 
			   if xxwrd_det.xxwrd_inv_lot = "" then ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)) ) else xxwrd_det.xxwrd_inv_lot  format "x(18)"  skip .
		      end.

		   end.


		   put 
		   "." skip
		   "Y" skip
		   "Y" skip
		   "Y" skip
		   "." skip .
		   
		   output close.
		   batchrun = yes.
		   input from value (v_tmp_path +  usection + ".i") .
		   output to  value (v_tmp_path +  usection + ".o") .
		   {gprun.i ""wowoisrc.p""} 
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

	   for each xxwrd_det where xxwrd_det.xxwrd_wolot < D-Wolot  and 
				    xxwrd_det.xxwrd_status <> "D"    and 
				    xxwrd_det.xxwrd_wrnbr = wrnbr    and 
				    xxwrd_det.xxwrd_lastop no-lock break by xxwrd_det.xxwrd_wolot desc   :

		   usection = D-Wolot + "<" + "CHG_NEXT_ID_ORDER_QTY-16_1" + "<" + trim ( xxwrd_det.xxwrd_wolot ) + "<" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,10)))  .
		   output to value(v_tmp_path +  trim(usection) + ".i") .

		   display 
		    "- " + xxwrd_det.xxwrd_wolot   format "x(30)"  skip
		    qty_comp  " ? ? ? " format "x(10)" skip
		    "-" skip
		    "-" skip
		    "-" skip
		    "." skip
		  
		   with fram finputD no-box no-labels width 200.

		   output close.
		   batchrun = yes.
		   input from value (v_tmp_path +  usection + ".i") .
		   output to  value (v_tmp_path +  usection + ".o") .
		   {gprun.i ""wowomt.p""}      
		   input close.
		   output close.
		   ciminputfile = usection + ".i".
		   cimoutputfile = usection + ".o".
		   run datain.
		   run dataout.

		   if  CimHaveError then  CHG_NEXT_ID_ORDER_QTY-16_1 = no.

	   end.


	END PROCEDURE.


	DEFINE VAR  LABOR_FEEDBACK-17_1 as logical .    
	PROCEDURE P_LABOR_FEEDBACK-17_1 :
	   DEFINE INPUT  PARAMETER G-Wolot like xxwrd_wolot.
	   DEFINE INPUT  PARAMETER wop     like xxwrd_op.
	   DEFINE OUTPUT PARAMETER LABOR_FEEDBACK-17_1 as logical .
	   LABOR_FEEDBACK-17_1 = yes.


	       sumsetuptime = 0.
	       sumruntime = 0.
	       sumqtycomp = 0.

	      
	      for each xxfb_hist where xxfb_wolot = G-Wolot and  xxfb_op = wop  and xxfb_update = no and 
		       ( ( xxfb_type = "11" and xxfb_nbr <> "D" and xxfb_date_start <> ? and  xxfb_date_end <> ? ) or     /* 设置时间 Time SAMSONG20081229*/
			 ( xxfb_type = "12" and xxfb_nbr <> "D" and xxfb_date_start <> ? and  xxfb_date_end <> ? ) or     /* 运行时间 Time */
			 xxfb_type = "13"  or     /* 完工反馈 Qty  */
			 xxfb_type = "14"  or     /* 报废反馈 Qty  */
			 xxfb_type = "15"         /* 返工反馈 Qty  */ )  break by xxfb_user by xxfb_wc by xxfb_type by xxfb_rsn_code :

			 if first-of(xxfb_wc) then do:
			    sumsetuptime = 0.
			    sumruntime = 0.
			    sumqtycomp = 0.
			    for each fbtmp : delete fbtmp. end.
			 end.
			 if xxfb_type = "11" then do:
				 if xxfb_date_end = xxfb_date_start then 
				 sumsetuptime = sumsetuptime + xxfb_time_end - xxfb_time_start .
				 else
				 sumsetuptime = sumsetuptime + (xxfb_date_end - xxfb_date_start) * (60 * 60 * 24) - xxfb_time_start + xxfb_time_end .
			 end.
			 if xxfb_type = "12" then do:
				 if xxfb_date_end = xxfb_date_start then 
				 sumruntime = sumruntime + xxfb_time_end - xxfb_time_start .
				 else
				 sumruntime = sumruntime + (xxfb_date_end - xxfb_date_start) * (60 * 60 * 24) - xxfb_time_start + xxfb_time_end .
			 end.
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
			    
			    usection = G-Wolot + "<" + "LABOR_FEEDBACK-17_1" + "<" + string ( xxfb_op ) + "<" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,10)))  .
			    output to value(v_tmp_path +  trim(usection) + ".i") .

			    put  
			       
			     "- " + G-wolot + " " + string ( xxfb_op ) format "x(45)" skip
			     if xxfb_user  <> "" then xxfb_user else " - "
			     " - - " +  trim ( xxfb_wc )   format "x(30)"  skip
			     sumqtycomp  .



			     find first fbtmp where rsn_type = "J" no-error.
			     put  if available ( fbtmp ) then " Y " else  " N "  .

			     find first fbtmp where rsn_type = "R" no-error.
			     put  if available ( fbtmp ) then " Y " else  " N "  .


			     put effdate " - - - -  "  sumsetuptime / 3600  " - " sumruntime / 3600  " SFC-Module" skip .

			     for each fbtmp where rsn_type = "J" :
				 put rsn_code skip 
				     rsn_qty  skip .
			     end. 
			     find first fbtmp where rsn_type = "J" no-error.
			     if available ( fbtmp ) then put "." skip .


			     for each fbtmp where rsn_type = "R" :
				 put rsn_code skip 
				     rsn_qty  skip .
			     end. 
			     find first fbtmp where rsn_type = "R" no-error.
			     if available ( fbtmp ) then put "." skip .

			      put  
			      "Y" skip
			      "." skip.

			   output close.

			   for each wr_route where wr_lot = xxfb_wolot and wr_op = xxfb_hist.xxfb_op : /* Release Routing Status */
			       wr_route.wr_status  = "".
			   end.

			   batchrun = yes.
			   input from value (v_tmp_path +  usection + ".i") .
			   output to  value (v_tmp_path +  usection + ".o") .
				{gprun.i ""sfoptr01.p""}   
			   input close.
			   output close.
			   ciminputfile = usection + ".i".
			   cimoutputfile = usection + ".o".
			   run datain.
			   run dataout.

			   for each wr_route where wr_lot = xxfb_wolot and wr_op = xxfb_hist.xxfb_op : /* Release Routing Status */
			       wr_route.wr_status  = "".
			   end.

			   if  CimHaveError then  LABOR_FEEDBACK-17_1 = no.

			 end.

	      end.  /* for each fb_hist where xxfb_wolot = xxwrd_det.xxwrd_wolot */

	END PROCEDURE.


	PROCEDURE UpdateMFGPRO :
	    DEFINE INPUT  PARAMETER uWolot   like xxwrd_wolot.
	    DEFINE INPUT  PARAMETER uStatus  like xxwrd_status.    /* D 表示 DELET */
	    DEFINE INPUT  PARAMETER uLastwo  like xxwrd_lastwo.    /* = yes  发料WO ID*/
	    DEFINE INPUT  PARAMETER uWrnbr   like xxwrd_wrnbr .
	    DEFINE OUTPUT PARAMETER UpdateMessage   AS char.
	    DEFINE OUTPUT PARAMETER UpdateSuccess   AS logical init no.
	    
	    UpdateSuccess = no.
	    UpdateMessage = "".

	    IF uLastwo = no and uStatus = "D" then do:

	       RUN P_Close_ID-Clear_Bill-Add_Bill ( INPUT uWolot , INPUT uWrnbr , OUTPUT Close_ID-Clear_Bill-Add_Bill ) .
	       IF Close_ID-Clear_Bill-Add_Bill then do:
		  UpdateSuccess = yes.
		  leave.
	       end.
	       else do:
		  UpdateMessage = "关闭删除WOID,移动WOBILL出错!".
		  UpdateSuccess = no.
		  leave.
	       end.
	    end.

	    IF uLastwo = no and uStatus <> "D" then do:
	       UpdateSuccess = yes.
	       /* 不是最大ID,不被删除,正常处理 */
	    end.

	    IF uLastwo = Yes and uStatus = "D" then do:   
		  UpdateMessage = "第大的WO ID ,不能删除!".
		  UpdateSuccess = no.
		  leave.
	    end.

	    IF uLastwo = Yes and uStatus <> "D" then do:   
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

	    
	    If UpdateSuccess = no then leave.

	    /* Labor Feedback */
	    For each xxwrd_det where xxwrd_det.xxwrd_wolot = uWolot break by xxwrd_op :

		If xxwrd_det.xxwrd_status  = "N" then do:
		   RUN P_ADD_ID_ROUTING-16_13_13 (INPUT uWolot , INPUT xxwrd_det.xxwrd_op , INPUT xxwrd_det.xxwrd_wc , INPUT xxwrd_det.xxwrd_opname , OUTPUT ADD_ID_ROUTING-16_13_13 ).
		   IF ADD_ID_ROUTING-16_13_13 THEN UpdateSuccess = yes .
		   else do:
		      UpdateMessage = "新增工序 " + string ( xxwrd_det.xxwrd_op ).
		      UpdateSuccess = no.
		   end.
		   
		end.


	       If xxwrd_det.xxwrd_status  = "D" then do:
		   RUN P_CLOSE_ID_ROUTING-16_13_13 (INPUT uWolot , INPUT xxwrd_det.xxwrd_op , INPUT xxwrd_det.xxwrd_wc , OUTPUT CLOSE_ID_ROUTING-16_13_13 ).
		   IF CLOSE_ID_ROUTING-16_13_13 THEN UpdateSuccess = yes .
		   else do:
		      UpdateMessage = "删除工序 " + string ( xxwrd_det.xxwrd_op ).
		      UpdateSuccess = no.
		   end.
	       end.

	       If xxwrd_det.xxwrd_status <>  "D" then do:
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

	    If UpdateSuccess = no then leave.

	    RUN P_WO_BACKFLUSH-16_12(INPUT uWolot , OUTPUT WO_BACKFLUSH-16_12 ). 
	    IF WO_BACKFLUSH-16_12 then UpdateSuccess = yes.
	    else do:
	       UpdateMessage = "工单反馈出错!".
	       UpdateSuccess = no.
	       leave.
	    end.

	END PROCEDURE.


	For each xywrddet where xywrddet.xxwrd_close = no and xywrddet.xxwrd_lastop = yes  and 
				( ( xywrddet.xxwrd_wolot = vwolot and vwolot <> "*" ) or vwolot = "*"  ) 
				break by xywrddet.xxwrd_wrnbr by xywrddet.xxwrd_wolot desc   :
		 
		 RUN OkToUpdateMFGPRO (INPUT xywrddet.xxwrd_wolot , INPUT xywrddet.xxwrd_op ,INPUT xywrddet.xxwrd_wrnbr, OUTPUT OkToUpdate).

		 IF OkToUpdate = yes then do:
		    UpdateSuccess = no .
		    do transaction on error  undo,leave 
					on endkey undo , leave :
		       
			    RUN UpdateMFGPRO (INPUT xywrddet.xxwrd_wolot , INPUT xywrddet.xxwrd_status , 
					      INPUT xywrddet.xxwrd_lastwo ,INPUT xywrddet.xxwrd_wrnbr  , OUTPUT UpdateMessage , OUTPUT UpdateSuccess).

			     
			If UpdateSuccess = no then undo , leave. 
		       
		    end.
		    
		    If UpdateSuccess = yes then do:
		       for each xxfb_hist where xxfb_wolot = xywrddet.xxwrd_wolot :
			   xxfb_update = yes.   
		       end.
		       for each xxwrd_det where xxwrd_det.xxwrd_wolot = xywrddet.xxwrd_wolot  :
			   xxwrd_det.xxwrd_close = yes.
		       end.
		       if debugonly = yes then message xywrddet.xxwrd_wolot + "  Success to Update MFG/PRO "  view-as alert-box  .

		    end.

		 End.

	End.

	hide frame a.

leave.
end.
hide frame a no-pause.
