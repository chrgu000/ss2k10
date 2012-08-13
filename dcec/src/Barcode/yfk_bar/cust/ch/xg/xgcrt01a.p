/*Program: xgcrt01a.p   工单CIM LOAD */
/*Copy From xgcrt04a.p    by   hou   2006.02.27                           */


{mfdtitle.i}

define input  parameter p_rid  as  rowid.
define output parameter p_msg  as  char no-undo. 

define variable mesg   like xlog_desc    .
define variable isite  like pt_site      .
define variable iloc-p like loc_loc      .
define variable wopart like wo_part.
define var ista like wo_status.
define var ino  as   logical.

define new shared stream source_str.
define new shared variable source_file as character init "cim.txt".
define new shared variable inbr as character .
define new shared variable iwolot as character.

define variable errors as integer.

{xglogdef.i " "}

assign ista = "r"
       ino  = no.

errors = -1.
p_msg = "Error".

do on error undo,leave:

   find xwo_srt where rowid(xwo_srt) = p_rid exclusive-lock no-error.
   
   for first xgpl_ctrl where xgpl_lnr = xwo_lnr no-lock: end.
   isite  = xgpl_site.    
   iloc-p = xgpl_loc1.
        
   wopart = trim(xwo_part).

   if search(Source_file) <> ? then os-delete value(Source_file).
   
   {mfnctrl.i woc_ctrl woc_nbr wo_mstr wo_nbr inbr}
   {mfnxtsq.i wo_mstr wo_lot woc_sq01 iwolot}
      
   /*cimload format control for wo maintenance*/
   {gprun.i ""xgwomtcm.p"" "(input wopart,input isite,input xwo_qty_lot)"}

   /*backflush cimload format control ***/   
   {gprun.i ""xgworcflh.p"" "(input iwolot, input today ,input iloc-p,input isite,input xwo_qty_lot)"}

   {gprun.i ""xgsfcim.p"" "(input source_file,input iwolot,input xwo_qty_lot,input xwo_part,input isite)"}

   {xgcmdef.i "new"}
   
   if search(Source_file) = ? then do:
       p_msg = "CimLoad File not existing".
       leave.
   end.

   {gprun.i ""xgcm001.p"" "(INPUT source_file, output errors) " }
   
   if errors > 0 then do:
       p_msg = "工单没有成功生成或回冲，请检查cim文件-！" + SOURCE_file .
       leave.
   end.
   else do:
        os-delete silent value(source_file).
   end.

   xwo_wolot  = iwolot.
   
   p_msg = "".
   
end.  /* do */
