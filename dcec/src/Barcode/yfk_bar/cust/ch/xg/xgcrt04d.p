/*Program: xgcrt04c.p   移库CIM LOAD */
/* for YFK Author:Jane Wang date:08/18/2005 Copy Right:  Atos Origin		  */

         /* DISPLAY TITLE */
         {mfdeclre.i}
DEFINE INPUT PARAMETER ILOT   LIKE xwck_LOT.

DEFINE VARIABLE mesg   like xlog_desc    .
DEFINE VARIABLE isite  like pt_site      .

DEFINE VARIABLE iLoc-y like loc_loc      .
DEFINE VARIABLE iLoc-n like loc_loc      .

DEFINE BUFFER xk   for xwck_mstr.
DEFINE BUFFER xkmr for xwck_mstr.

DEFINE VARIABLE xsrtid as recid.

DEFINE VARIABLE Source_file as character init "tr.txt" .
DEFINE VARIABLE log_file    as character init "tr.log" .

FOR FIRST xk WHERE XK.XWCK_LOT = ILOT 
              AND  XK.XWCK_TYPE = "1"
              AND  XK.XWCK_TR NO-LOCK: 
   
   for first xgpl_ctrl where xgpl_lnr = xk.xwck_lnr no-lock: end.
   if not available xgpl_ctrl then do:
      mesg = "控制文件中无该生产线记录！" .
      {xglogger.i xk.xwck_lnr xk.xwck_part xk.xwck_lot ""TR"" ""ERROR"" mesg}
      next.
   end. 
   else do:
      if xgpl_loc = xgpl_loc1 then do:
         mesg = "仓库库位与隔离库位相同！" .
         {xglogger.i xk.xwck_lnr xk.xwck_part xk.xwck_lot ""TR"" ""ERROR"" mesg}
         next.
      end.
      else do:
         assign isite  = xgpl_site
                iloc-y = xgpl_loc
	        iloc-n = xgpl_loc1
	        .
     end.		
   end.
   for first pt_mstr where pt_part = xk.xwck_part no-lock: end.
   if not available pt_mstr  then do:
      mesg = "零件号不存在！" .
      {xglogger.i xk.xwck_lnr xk.xwck_part xk.xwck_lot ""TR"" ""ERROR"" mesg}
      next.
   end.

   if search(Source_file) <> ? then
      os-delete value(Source_file).
   if search(log_file) <> ? then
      os-delete value(log_file).

   output to value(Source_file) no-echo no-map append.
   PUT UNFORMATTED  
     "~"" xk.xwck_part "~"" SKIP
     "~"" xk.xwck_qty_chk  "~"" SKIP(1)
     "~"" isite "~" ~"" iloc-n "~"" SKIP
     "~"" isite "~" ~"" iloc-y "~"" SKIP
     "." SKIP
     "." SKIP.
   OUTPUT CLOSE .

   batchrun = yes.
   input from value(source_file) . 
   output to value(log_file) keep-messages.
   hide message no-pause.
   {gprun.i ""iclotr04.p""}
   hide message no-pause.
   output close.
   input  close. 
   batchrun = no.

     mesg = "移库处理完成,请检查结果！" .          
     {xglogger.i xk.xwck_lnr xk.xwck_part xk.xwck_lot ""TR"" ""SUCC"" mesg}
     message  "移库处理完成，请检查结果！" .
     PAUSE.

   /*update the table xwck_mstr:xwck_tr *****/
    xsrtid = recid(xk).

    for first xkmr where recid(xkmr) = xsrtid exclusive-lock: end.
    IF available xkmr THEN DO:
       xkmr.xwck_tr = No.
       release xkmr.    	
    END.   
   /***
   {gprun.i ""xgrwflc.p"" "(INPUT xk.xwck_lot)"} *****/
   
 END.