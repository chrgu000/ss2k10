/*Program: xgcrt04b.p   工单CIM LOAD */
/* for YFK Author:Jane Wang date:08/18/2005 Copy Right:  Atos Origin		  */
/*modify by xiangwh 2005-09-27 xwh050927
trim the xwck_part  */

         /* DISPLAY TITLE */
         {mfdeclre.i}
DEFINE INPUT PARAMETER ILOT   LIKE xwck_lot.

DEFINE VARIABLE mesg   like xlog_desc    .
DEFINE VARIABLE isite  like pt_site      .
DEFINE VARIABLE iLoc-p like loc_loc      .
DEFINE VARIABLE inbr   like wo_nbr.
DEFINE VARIABLE iwolot like wo_lot.
/*xwh050927*/
DEFINE VARIABLE wopart LIKE wo_part.
/*lw01*/
define variable Proqty as dec.

DEFINE VAR ista like wo_status.
DEFINE VAR ino  as   logical.
assign ista = "R"
       ino  = NO.

DEFINE BUFFER xk for xwck_mstr.

DEFINE VARIABLE Source_file as character init "wo.txt" .
DEFINE VARIABLE log_file    as character init "wo.log" .

FOR EACH xk WHERE XK.XWCK_LOT = ILOT
              AND NOT XK.XWCK_BLKFLH  
              AND XK.XWCK_TYPE <> "" NO-LOCK break by xk.xwck_pallet : 
   
   for first xgpl_ctrl where xgpl_lnr = xk.xwck_lnr no-lock: end.
   if not available xgpl_ctrl then do:
      mesg = "控制文件中无该生产线记录！" .
      {xglogger.i xk.xwck_lnr xk.xwck_part xk.xwck_lot ""WO"" ""ERROR"" mesg}
      next.
   end. 
   else do:
      assign isite  = xgpl_site
             .    
   end.
   if (xk.xwck_type <> "1" and xk.xwck_type <> "2") then do:
      mesg = "良品字段记录不合法！-" + xk.xwck_type.
      {xglogger.i xk.xwck_lnr xk.xwck_part xk.xwck_lot ""WO"" ""ERROR"" mesg}
      next.
   end. 
   if xk.xwck_type = "1"      then assign iloc-p = xgpl_loc.
   else if xk.xwck_type = "2" then assign iloc-p = xgpl_loc1.
        
   for first pt_mstr where pt_part = xk.xwck_part no-lock: end.
   if not available pt_mstr  then do:
      mesg = "零件号不存在！" .
      {xglogger.i xk.xwck_lnr xk.xwck_part xk.xwck_lot ""WO"" ""ERROR"" mesg}
      next.
   end.
/*xwh050927*/
   xk.xwck_part = TRIM(xk.xwck_part).
   wopart = TRIM(xk.xwck_part).

/*lw01*/ if first-of(xk.xwck_pallet) then proqty = 0.
/*lw01*/ proqty = proqty + xk.xwck_qty_chk.
/*lw01*/ if last-of(xk.xwck_pallet) then do:

           if search(Source_file) <> ? then
              os-delete value(Source_file).
           if search(log_file) <> ? then
              os-delete value(log_file).
           if xk.xwck_wolot = "" then do:
              {mfnctrl.i woc_ctrl woc_nbr wo_mstr wo_nbr inbr}
              {mfnxtsq.i wo_mstr wo_lot woc_sq01 iwolot}

              output to value(Source_file) no-echo no-map append.
              PUT UNFORMATTED
               '"' inbr   '" ' '"' iwolot '"' skip
               '"' xk.xwck_part  '"'  " - " '"' isite '"'   skip
               '"'	/*xk.xwck_qty_chk lw01*/ proqty  '"' " - - - "	'"' ista '"' 	
                 " - - - - - - - " '"' ino '" ' skip.
              if available pt_mstr and pt_lot_ser <> "S" then do:
                 PUT UNFORMATTED skip(2).
              end.     
              PUT UNFORMATTED skip.
              PUT "." SKIP.

              output close.

              batchrun = yes.
              input from value(source_file) . 
              output to value(log_file) keep-messages.
              hide message no-pause.
              {gprun.i ""wowomt.p""}
              hide message no-pause.
              output close.
              input  close. 
              batchrun = no.

              for first wo_mstr where wo_nbr = inbr 
                                  and wo_lot = iwolot no-lock: end.
              if not available wo_mstr then do:
                 mesg = "工单没有成功生成，请检查CIMLOAD 日志！-" + log_file .          
                 {xglogger.i xk.xwck_lnr xk.xwck_part xk.xwck_lot ""WO"" ""ERROR"" mesg}
                 next.                                          
              end.
              else if wo_status <> "R" then do:
                 mesg = "工单非下达状态！-" + wo_status .          
                 {xglogger.i xk.xwck_lnr xk.xwck_part xk.xwck_lot ""WO"" ""ERROR"" mesg}
                 next.                                          
              end.
              else if wo_qty_ord = 0 then do:
                 mesg = "工单数量为零！-" + wo_lot.          
                 {xglogger.i xk.xwck_lnr xk.xwck_part xk.xwck_lot ""WO"" ""ERROR"" mesg}
                 next.                                          
              end.
              for first wod_det where wod_lot = iwolot no-lock: end.
              if not available wod_det then do:
                 mesg = "WOD_DET无记录！-" + iwolot.          
                 {xglogger.i xk.xwck_lnr xk.xwck_part xk.xwck_lot ""WO"" ""ERROR"" mesg}
                 next.                                          
              end.

              /*update the table xwo_srt:xwo_blkflh,xwo_wolot*****/  
              {gprun.i ""xgrwfla1.p"" "(INPUT xk.xwck_lot, INPUT iwolot)"}  
            
              /*update the table xwck_mstr:xwck_blkflh *****/
              {gprun.i ""xgrwflb1.p"" "(INPUT xk.xwck_lot,INPUT iwolot)"}  
           end.
           else do:   
              assign 
                     iwolot = xk.xwck_wolot.
           end.

           /*backflush cimload ***/   
           {gprun.i ""xgflh.p"" "(INPUT iwolot, INPUT today ,INPUT iloc-p)"}

           for first wo_mstr where wo_lot = iwolot 
                               and wo_qty_ord = wo_qty_comp no-lock: end.
           for first wod_det where wod_lot = iwolot 
                               and wod_qty_iss <> 0 no-lock: end.
           if available wo_mstr and available wod_det then do:
              /*update the table xwo_srt:xwo_blkflh,xwo_wolot*****/  
              {gprun.i ""xgrwfla.p"" "(INPUT xk.xwck_lot, INPUT iwolot)"}  
               
              /*update the table xwck_mstr:xwck_blkflh *****/
              {gprun.i ""xgrwflb.p"" "(INPUT xk.xwck_lot,INPUT iwolot)"}  
              mesg = "回冲成功！"  .          
              {xglogger.i xk.xwck_lnr xk.xwck_part xk.xwck_lot ""WO"" ""SUCC"" mesg}
              MESSAGE "回冲成功!".
              pause.
           end.
           else do:
              mesg = "工单没有成功回冲，请检查子件控制！ID-" + iwolot .          
              {xglogger.i xk.xwck_lnr xk.xwck_part xk.xwck_lot ""WO"" ""ERROR"" mesg}    
              message "工单没有成功回冲，请检查子件控制！ID-" + iwolot .
              pause.
              next.       
           end.
/*lw01*/ end.
END.
