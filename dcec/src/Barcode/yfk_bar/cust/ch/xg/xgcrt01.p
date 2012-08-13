/* xgcrt01.p                  生产线产品插件                  */
/* Created by    hou                         2006.01.04       */
/* Last MOdified: hou                        2006.03.21 *H01* */
/* Last MOdified: xwh                        2006.04.12 *x01* 
  description: 插件批号前加"E"，因为避免安全气囊导入的批号与它重复 */


{mfdtitle.i "ao"}

define new shared variable parpart like pt_part.
define new shared workfile pkkdet no-undo
    field pkkpart like ps_comp
    field pkkop as char format "x(20)" 
    field pkkqty like pk_qty.

DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chExcelWorkbook AS COM-HANDLE.
DEFINE VARIABLE chExcelWorksheet AS COM-HANDLE.

define var filetmp  as   char format "x(50)".
define var partdesc like pt_desc1.
define var custname like ad_name.
define var custpart like pt_part.

define var xln      like xpal_line.
define var shft     as   char format "x(8)" label "班次".
define var part     like pt_part LABEL "零件号".
define var qty      like ld_qty_oh label "数量".

define var batchno  like xwo_lot.
define var nextnbr  like xpal_next_nbr.
define var defcust  like xpal_cust_def.
define var defdloc  like xpal_dloc_def.
define var v_serial as   char.
define var v_lot    like xwo_lot.
define var v_msg    as   char.

define var yy       as   char format "x(1)" extent 40 no-undo.
define var mm       as   char format "x(1)" extent 12 no-undo.
define var i        as   integer.

define var goo      as   logical.

define buffer xws   for xwo_srt.

{xglogdef.i "new"}


FORM /*GUI*/ 
   
   xln     colon 20  xgpl_desc  AT    38 NO-LABELS format "x(32)"
   shft    colon 20  v_lot      colon 45 SKIP(1)
   part    colon 20  
   defcust at    38 no-labels
   ad_name at    50 no-labels
   qty     colon 20
   defdloc at    38 no-labels
   loc_desc  at  50 no-labels
with frame a side-labels width 80 attr-space three-d .


/* generate year & month flag */
do i = 1 to 9:
   yy[i] = string(i).
   mm[i] = string(i).
end.

do i = 10 to 35:
   yy[i] = chr(55 + i).
end.

do i = 10 to 12:
   mm[i] = chr(55 + i).
end.

/* Display */
view frame a.
view frame b.

mainloop:
repeat ON ERROR undo, RETRY ON ENDKEY undo, LEAVE with frame a:
   
   update xln shft v_lot .
     
   find first xgpl_ctrl where xgpl_lnr = xln no-lock no-error.
   if not avail xgpl_ctrl then do:
      {mfmsg.i 8524 3}
      undo , retry.
   end.
   
   disp xgpl_desc.
   
   find first xpal_ctrl where xpal_line = xln no-lock no-error.
   if not avail xpal_ctrl then do:
      message "托盘控制程序未定义".
      pause.
      undo , retry.
   end.
   
   if shft = "" then do:
      message "班次不能为空".
      undo, retry.
   end.
   
   update part qty.
   
   find first pt_mstr where pt_part = input part no-lock no-error.
   if not avail pt_mstr then do:
      {mfmsg.i 16 3}
      undo ,retry.
   end.

   find first xpal_ctrl where xpal_line = xln and xpal_part = part no-lock no-error.
   if not avail xpal_ctrl then do:
      message "托盘控制程序未定义" view-as alert-box error.
      undo , retry.
   end.

   find first xwo_srt where xwo_lnr = xln and 
   xwo_part = part and xwo_lot = v_lot no-lock no-error.
   if not avail xwo_srt then do:
      message "批号不存在" view-as alert-box error.
      undo, retry.
   end.

   find first cm_mstr where cm_addr = xpal_cust_def no-lock no-error.
   find first ad_mstr where ad_addr = cm_addr no-lock no-error.
   find first loc_mstr where loc_loc = xpal_dloc_def no-lock no-error.
   defcust = xpal_cust_def.
   defdloc = xpal_dloc_def.
   
   disp defcust ad_name when avail ad_mstr defdloc loc_desc when avail loc_mstr .

   trblock:
   do transaction on error undo, leave:
      /* 批箱号：生产线识别码2位＋产品识别码(1位)＋生产日期4位 ＋班别号1位 ＋3位顺序号 */
      find first xpal_ctrl where xpal_line = xln and xpal_part = part exclusive-lock no-error.
      if xpal_date1 <> today then do:
         xpal_date1 = today.
         xpal_next_nbr1 = 1.
      end.
      else do:
        xpal_next_nbr1 = xpal_next_nbr1 + 1.
      end.
      nextnbr = xpal_next_nbr1.
   
      repeat:
         /* 批箱号：生产线识别码2位＋产品识别码(1位)＋生产日期4位 ＋班别号1位 ＋3位顺序号 */
/*x01*/         
          batchno = "E" + substr(xln,1,2) 
                 + substr(xpal_code,1,1)
                 + yy[(YEAR(TODAY) - 2000) MOD 35] 
                 + mm[month(today)] 
                 + string(day(today),"99")   
                 + caps(substr(shft,1,1))
                 + string(nextnbr,"999").
   
         RUN checkbatchno ( input-output batchno) .
   
         if batchno <> "" then leave.
         nextnbr = nextnbr + 1.
      end.
      
      xpal_next_nbr1 = nextnbr.
      
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      
      v_serial = xln + string(today,"999999") + string(time,"99999").
      
      /* create xwo_srt */
      create xwo_srt.
      assign xwo_lnr       = xln
             xwo_shift     = shft
             xwo_part      = part
             xwo_lot       = batchno
             xwo_date      = today
             xwo_time      = time
             xwo_due_date  = today
             xwo_due_time  = time
             xwo_site      = pt_site
             xwo_loc_des   = defdloc
             xwo_blkflh    = yes
             xwo_qty_lot   = qty
             xwo_serial    = v_serial
             xwo_loc_lnr   = xgpl_loc_lnr
             xwo_cust      = defcust
             xwo_type      = "E"
             xwo__chr01    = v_lot.
      
/*H01*/ {xgxwoo.i xwo_lot qty}

      /* Create xwosd_det */
      for each pkkdet:
        delete pkkdet.
      end.
     
      parpart = part.
      
      {gprun.i ""xgbmpkiq.p""}
   
      for each pkkdet:
        create xwosd_det.
        assign        
            xwosd_lnr    = xln
            xwosd_part   = pkkpart
            xwosd_date   = today
            xwosd_fg_lot = batchno
            xwosd_op     = pkkop
            xwosd_qty    = pkkqty * qty
            xwosd_used   = yes
            xwosd_bkflh  = yes
            xwosd_use_dt = today
            xwosd_use_tm = time.
        
        find first pt_mstr where pt_part = pkkpart no-lock no-error.
        if available pt_mstr then do:
           xwosd_site = pt_site.
           xwosd_loc = pt_loc.  
           if pt_iss_pol = no then do:
              xwosd_used = no.
              xwosd_bkflh = yes.
           end.
        end.
/*H01*/ {xgxwosdo.i pkkqty * qty}
        
      end.
      
      {gprun.i ""xgcrt01a.p"" "(input rowid(xwo_srt), output v_msg) " }
      
      if v_msg <> "" then do:
         message "加工单回冲cim失败" skip
                 v_msg skip
         view-as alert-box error.
         undo trblock, leave trblock.
      end.
      
      release xpal_ctrl.
   end. /* do transaction */ 
   
   {xgxlogdet.i}
   
end. /*  */

/***********************************************************/
/***********************************************************/
procedure checkbatchno:
   define input-output parameter bno as char.
   
   define buffer   bfxwo  for xwo_srt.
   define buffer   bfxwod for xwosd_det.
   
   find first bfxwo where bfxwo.xwo_lot = bno no-lock no-error.
   if avail bfxwo then do:
      bno = "".
      return.
   end.
   
   find first bfxwod where bfxwod.xwosd_fg_lot = bno no-lock no-error.
   if avail bfxwod then do:
      bno = "".
      return.
   end.

end.

