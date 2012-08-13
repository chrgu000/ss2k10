/*Program: xgcrt04a.p   工单CIM LOAD */
/* for YFK Author:Jane Wang date:08/18/2005 Copy Right:  Atos Origin		  */
/*Modify by Xiangwh 2005-09-25   xwh050925
add the pallet parameter to backflush subprogram*/
/*modify by xiangwh 2005-09-27 xwh050927
trim the xwck_part  */

/*Last Modified BY: Li Wei , Date:2005-11-28 ECO *lw01* */
/*Modified by:xwh, date:2005-12-6 xwh051206*/
/*Modified by: hou       2006-03-06 *H01* */

{mfdtitle.i}

DEFINE VARIABLE mesg   like xlog_desc    .
DEFINE VARIABLE isite  like pt_site      .
DEFINE VARIABLE iLoc-p like loc_loc      .
/*xwh050925*/
DEFINE INPUT PARAMETER palnbr LIKE xwck_pallet. 
/*xwh050927*/
DEFINE VARIABLE wopart LIKE wo_part.
DEFINE VAR ista like wo_status.
DEFINE VAR ino  as   logical.
/*lw01*/
define new shared stream source_str.
define new shared variable source_file as character init "cim.txt".
define new shared variable inbr as character .
define new shared variable iwolot as character.

define variable errors as integer.


define variable ProQty as dec.
define temp-table xwkfl
    field xwkfl_recid as recid.

/*H01*/
{xglogdef.i "new"}

assign ista = "R"
       ino  = NO.

DEFINE BUFFER xk for xwck_mstr.


/*lw01*/
for each xwkfl:
    delete xwkfl.
end.
errors = -1.
do /*transaction*/ on error undo,leave:

FOR EACH xk /*NO-LOCK lw01*/ WHERE xk.xwck_pallet = palnbr 
              AND NOT XK.XWCK_BLKFLH  
              AND XK.XWCK_TYPE <> "" 
              USE-INDEX xwck_paldt
              break by xwck_pallet:
   
   for first xgpl_ctrl where xgpl_lnr = xk.xwck_lnr no-lock: end.
   if not available xgpl_ctrl then do:
      mesg = "控制文件中无该生产线记录！" .
      {xglogger.i xk.xwck_lnr xk.xwck_part xk.xwck_lot ""WO"" ""ERROR"" mesg}
      next.
   end. 
   else do:
      assign isite  = xgpl_site.    
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
   xwck_part = TRIM(xwck_part).
   wopart = TRIM(xwck_part).

/*lw01*/
   if first-of(xk.xwck_pallet) then ProQty = 0.
   ProQty = ProQty + xk.xwck_qty_chk.
   
   /**** Added by lw01, To save every recode ID of current Backflush *****/
   find first xwkfl where xwkfl_recid = recid(xk) no-error.
   if not avail xwkfl then do:
       create xwkfl.
       xwkfl_recid = recid(xk).
   end.

   if last-of(xk.xwck_pallet) then do:

       if search(Source_file) <> ? then os-delete value(Source_file).
/*lw01       if search(log_file) <> ?    then os-delete value(log_file).*/
       
       if xk.xwck_wolot = "" then do:

            {mfnctrl.i woc_ctrl woc_nbr wo_mstr wo_nbr inbr}
            {mfnxtsq.i wo_mstr wo_lot woc_sq01 iwolot}
          
           /*cimload format control for wo maintenance*/
           {gprun.i ""xgwomtcm.p"" "(input wopart,input isite,input proqty)"}

       end.
       else do:   
          assign 
             iwolot = xk.xwck_wolot.
       end.
        
       /*backflush cimload format control ***/   
       {gprun.i ""xgworcflh.p"" "(INPUT iwolot, INPUT today ,INPUT iloc-p,input isite,input proqty)"}

       {gprun.i ""xgsfcim.p"" "(input source_file,input iwolot,input proqty,xk.xwck_part,input isite)"}


       {xgcmdef.i "new"}
       
           if search(Source_file) = ? then do:
               message "ERR:CimLoad File not existing".
               undo,leave.
           end.
          
          {gprun.i ""xgcm001.p""
          "(INPUT source_file,
          output errors)"}
/*xwh060422*/
           OUTPUT TO backflhlog.prn APPEND.
           for each cim_mstr break by cim_group:
               PUT UNFORMATTED cim_desc SKIP.
           end.
           OUTPUT CLOSE.
           
           if errors > 0 then do:
/*xwh051206----*/
               mesg = "工单没有成功生成或回冲，请检查cim文件-！" + SOURCE_file .
               {xglogger.i xk.xwck_lnr xk.xwck_part xk.xwck_pallet ""WO"" ""ERROR"" mesg}
/*----xwh051206*/

/*xwh060422  OUTPUT TO backflhlog.prn APPEND.
               for each cim_mstr break by cim_group:
                   PUT UNFORMATTED cim_desc SKIP.
               end.
               OUTPUT CLOSE.
*/
               {mfselprt.i "printer" 132}
               for each cim_mstr break by cim_group:
                   disp cim_desc with width 200 stream-io.
               end.
               {mfreset.i}
               undo , leave.
           end.
           else do:
                message "INF:成功回冲!".
                os-delete silent value(source_file).
           end.
        
   end. /*if last-of()*/
END. /*for each*/

if errors = 0  then do:
    for each xwkfl:
        for each xk where recid(xk) = xwkfl_recid :
            /*update the table xwo_srt*/
            {gprun.i ""xgrwfla.p"" "(INPUT xk.xwck_lot, INPUT iwolot)"}
            xk.xwck_blkflh = yes.
            xk.xwck_wolot  = iwolot. /*lw01*/
        end.
    end.
end.
end.  /*do transaction*/

/*H01*/
{xgxlogdet.i}

