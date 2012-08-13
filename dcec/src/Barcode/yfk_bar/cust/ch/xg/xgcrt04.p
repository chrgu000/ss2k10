/*Program: xgcrt04.p   工单CIM LOAD */
/* for YFK Author:Jane Wang	 Copy Right:  Atos Origin		  */
/*xwh051101 remark xwck_wolot <> ''*/
/*Last Modified BY: Li Wei  DATE:2005-11-28 ECO *lw01* */
/*last modified by: hou          2006-03-06 ECO *H01*  */
/*last modified by: hou          2006-03-12 ECO *H02*  */
         /* DISPLAY TITLE */
         {mfdtitle.i "+Ja "}
 
DEFINE VARIABLE endTime  like xwo_due_time.
DEFINE VARIABLE lnr      like xwck_lnr .
DEFINE VARIABLE lnr1     like xwck_lnr .
DEFINE VARIABLE lot      like xwck_pallet. /*xwck_lot .lw01*/
DEFINE VARIABLE lot1     like xwck_pallet. /*xwck_lot .lw01*/
DEFINE VARIABLE xToday   as   date        initial today  label "截止日期" .         
DEFINE VARIABLE xTime    as   character   format "x(5)" label "截止时间".    
DEFINE VARIABLE blkflh   like xwck_blkflh initial No.
DEFINE VARIABLE xAnswer  as   logical init No.
DEFINE VARIABLE xqty     like wo_qty_ord.
/*lw01*/ define variable mesg as character.
/*lw01*/ define variable isite    as character.
/*lw01*/ define variable iloc-p   as character.
/*lw01*/ define variable errors as integer.
/*lw01*/ define new shared stream source_str.
/*lw01*/ define new shared variable source_file as character init "cim.txt".
/*lw01*/ define new shared variable inbr as character .
/*lw01*/ define new shared variable iwolot as character .
/*lw01*/ define temp-table xwkfl
                field xwkfl_recid as recid
                field xwkfl_pallet as character
                field xwkfl_wolot  as character.



DEFINE buffer xkmr for xwck_mstr.

DEFINE VARIABLE xkmrid as recid.

/*H01*/
{xglogdef.i "new"}


endTime = time - 1 .


FOR FIRST xwck_mstr where xwck_type <> "" and (xwck_blkflh = No or xwck_tr)
    use-index xwck_lot no-lock: END.
IF not available xwck_mstr THEN FOR last xwck_mstr no-lock: end.
IF not available xwck_mstr THEN 
DO:
   Message "错误:没有排序资料,你不能运行此程序".
   pause 10.
   return.
END.

FOR first xgpl_ctrl no-lock: end.
IF not available xgpl_ctrl THEN
DO:
   Message "错误:没有定义控制文件(xgpl_ctrl)".	
   pause 10.
   return.
END.
/*xwh060713---
ELSE DO:
   ASSIGN lnr  = xgpl_lnr 
          lnr1 = xgpl_lnr.
END.
---xwh060713*/
FOR LAST xwck_mstr where  xwck_type <> "" and xwck_blkflh = No
    use-index  xwck_lot no-lock: END.
IF not available xwck_mstr THEN FOR first xwck_mstr no-lock : end.
IF not available xwck_mstr THEN
DO:
   Message "错误:没有排序资料,你不能运行此程序".
   pause 10.
   return.
END.

FORM
   lnr    colon 22 lnr1 colon 50
   lot    colon 22 lot1 colon 50
   xToday colon 25
   xTime  colon 25  skip(1)
with frame a side-labels width 80.

xTime = string(time,"HH:MM") .

DISPLAY
	 lnr lnr1 
	 lot lot1
	 xToday 
	 xTime  
with frame a.

mainloop:
REPEAT:
/*do on error undo, leave on endkey undo,Leave . */
/*lw01*/ for each xwkfl:
/*lw01*/     delete xwkfl.
/*lw01*/ end.
/*lw01*/ errors = -1.

    update lnr lnr1 lot lot1 xToday xTime  with frame a.
  
	IF xToday <> ? and xToday > today then do:
		message "汇总结束日期不能晚于今天" .
		undo,retry.
	end.
	IF substring(xTime,1,2) > "23" or substring(xTime,4,2) > "59" then do:
		message "汇总结束时间格式不对" .
		undo,retry.
	end.
	endTime = integer(substring(xTime,1,2)) * 3600 + integer(substring(xTime,4,2)) * 60 .
     
     if search(Source_file) <> ? then os-delete value(Source_file).

     FOR EACH xwck_mstr          
	    where   	    
	        ((xwck_lnr >= lnr and lnr <> "") or lnr = "") 
	    and ((xwck_lnr <= lnr1 and lnr1 <> "" ) or lnr1 = "")
/*lw01*/ and ((xwck_pallet >= lot  and lot <> "") or lot = "" )
/*lw01*/ and ((xwck_pallet <= lot1 and lot1 <> "") or lot1 = "") 

        and (xwck_type <> "" and (not xwck_blkflh or xwck_tr) )
	    and ( xwck_prd_date < xtoday
	         or ( xwck_prd_date = xtoday and  xwck_prd_time <= endTime))
    	and  xwck_prd_date <> ? and  xwck_prd_time <> 0
    	and xwck_part <> ""
	    use-index /*xwck_lot lw01*/ xwck_paldt break by xwck_pallet :
        
/*lw01*/ if first-of(xwck_pallet) then xqty = 0 .
/*lw01*/ xqty = xqty + xwck_qty_chk.
/*lw01*/ if last-of(xwck_pallet) then do:
            {mfnctrl.i woc_ctrl woc_nbr wo_mstr wo_nbr inbr}
            {mfnxtsq.i wo_mstr wo_lot woc_sq01 iwolot}

/*lw01*/     find first xwkfl where xwkfl_pallet = xwck_pallet no-error.
/*lw01*/     if not avail xwkfl then do:
/*lw01*/         create xwkfl.
                 assign
/*lw01*/         xwkfl_recid = recid(xwck_mstr)
                 xwkfl_pallet = xwck_pallet
                 xwkfl_wolot = iwolot.
/*lw01*/     end.


/*lw01*/    for first xgpl_ctrl where xgpl_lnr = xwck_lnr no-lock: end.
/*lw01*/    if not available xgpl_ctrl then do:
/*lw01*/        mesg = "控制文件中无该生产线记录！" .
/*lw01*/        {xglogger.i xwck_lnr xwck_part xwck_lot ""WO"" ""ERROR"" mesg}
/*lw01*/        next.
/*lw01*/    end. 
/*lw01*/    else
/*lw01*/        assign isite  = xgpl_site.

/*lw01*/     if xwck_type = "1"      then assign iloc-p = xgpl_loc.
/*lw01*/     else if xwck_type = "2" then assign iloc-p = xgpl_loc1.

             if not xwck_blkflh then do:
               /*wo mt cim file*/
/*lw01*/       {gprun.i ""xgwomtcm.p"" "(input xwck_part, input isite , input xqty)"}

               /*wo backflush cim file*/
/*lw01*/       {gprun.i ""xgworcflh.p"" 
                "(input iWoLot,
                input today,
                input iloc-p,
                input isite,
                input xqty)"}

               /*cim file for 17.1*/
/*lw01*/       {gprun.i ""xgsfcim.p"" 
                "(input source_file,
                input iWolot,
                input xqty,
                input xwck_part,
                input isite)"}
             END. /*if not xwck_blkflh*/   
         end. /*if last-of*/ 
         
         if xwck_tr then do:
             for first xgpl_ctrl where xgpl_lnr = xwck_lnr no-lock: end.

             {gprun.i ""xgcrt04d.p"" "(INPUT xwck_lot)"}
     	 end.
     end. /*for each xwck_mstr *******/

     
/*lw01*/       {xgcmdef.i "new"}
/*H02** /*lw01*/       do on error undo,leave: */
/*H02*/        do transaction on error undo,leave: 
                   if search(Source_file) = ? then do:
                       message "ERR:CimLoad File not existing".
                       undo,leave.
                   end.
                   {gprun.i ""xgcm001.p""
                   "(INPUT source_file,
                     output errors)"}
           
                  if errors > 0 then do:
        
                       {mfselprt.i "printer" 132}
                       for each cim_mstr break by cim_group:
                           disp cim_desc with width 200 stream-io.
                       end.
                       {mfreset.i}
                       undo , leave.
                  end.
                  else if errors = 0 then do:
                        message "INF:回冲成功".
                        
                        os-delete silent value(source_file).
                        
                        /*update the table xwck_mstr and xwo_srt field status*/
                        for each xwkfl:
                            for each xkmr where xkmr.xwck_pallet = xwkfl_pallet: 
                                /*update the table xwo_srt*/
                                {gprun.i ""xgrwfla.p"" "(INPUT xkmr.xwck_lot, INPUT xwkfl_wolot)"}
                                xkmr.xwck_blkflh = yes.
                                xkmr.xwck_wolot  = iwolot.
                            end.
                        end.
                  end.
/*lw01*/       end.  /* do */
               
               /*H01*/
               {xgxlogdet.i}
               
END. /*mainloop*/
