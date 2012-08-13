/* xkwosdmt.p 看板数据调整维护 copy from xwosdmt.p by hou     */
/* xwosdmt.p  异常消耗冲减看板 by Atos Origin :SunnyZhou      */

/* DISPLAY TITLE */
{mfdtitle.i "4+ "}

define variable xwTrID like tr_trnbr label "事务号" no-undo.
define variable xwLnr like xwo_lnr initial "R001A" no-undo.
define variable site  like tr_site no-undo.
define variable sitedesc like si_desc no-undo.
define variable loc   like tr_loc no-undo.
define variable locdesc like loc_desc no-undo.
define variable part  like tr_part no-undo.
define variable ptdesc  like pt_desc1 format "x(48)" no-undo.
define variable xwqty   like tr_qty_chg label "数量" no-undo.
define variable iSeq like xwo_serial no-undo.
define variable xwChkTrID as logic no-undo.
define variable xAnswer as logic no-undo.
define variable xwRmks  as character format "x(60)"label "备注" no-undo.
/*xw0626*/ define variable yn as logic.

find first usrw_wkfl where usrw_key1 = "XW-KBCTRL" no-lock no-error.
IF not available usrw_wkfl THEN
DO:
   message "错误: 没有定义<异常消耗需要校验事务号>控制文件".
   pause 10.
   return.
END.
xwChkTrID = usrw_logfld[1].

FORM  
   skip(1)
   xwLnr colon 15 
   part  colon 15        
   ptdesc colon 15 no-label
   site  colon 15  sitedesc no-label
   loc   colon 15
   locdesc colon 15
   xwqty   colon 15
   xwRmks colon 15
   xwTrID colon 15
   skip(1)
with frame a width 80 side-labels attr-space.

/* Set External Labels */
setFrameLabels(frame a:handle).

/* DISPLAY */
repeat:
   view frame a.
   update xwLnr with frame a.
   FIND first xgpl_ctrl where xgpl_lnr = xwLnr no-lock no-error.
   IF not available xgpl_ctrl THEN
   DO:
      pause 0.
      message "警告:生产线不存在,要继续?" 
      update yn.
      if not yn then do:
         undo,retry.
      end.
   END.

   update part with frame a.
   
   FIND pt_mstr where pt_part = part no-lock no-error.
   IF not available pt_mstr THEN 
   DO:
      pause 0.
      message "错误:零件不存在!" .
      undo,retry.
   END.
   
   display pt_desc1 + pt_desc2 @ ptdesc         
   with frame a.
   
   FIND first knbi_mstr where knbi_part = part no-lock no-error.
   IF not available knbi_mstr THEN
   DO:
      pause 0.
      message "错误:此零件为非看板零件!" .
      undo,retry.
   END.

   update site loc with frame a.
   
   FIND first si_mstr where si_site = site no-lock no-error.
   IF not available si_mstr THEN
   DO:
      pause 0.
      message "错误:地点不存在!" .
      undo,retry.
   END.
   FIND first loc_mstr where loc_site = site 
                       and   loc_loc = loc no-lock no-error.
   IF not available loc_mstr THEN
   DO:
      pause 0.
      message "错误:库位不存在!" .
      undo,retry.
   END.
   
   set xwqty xwRmks with frame a.
   
   if xwChkTrID then do:
      update xwTrID with frame a.
      FIND tr_hist where tr_trnbr = xwTrID no-lock no-error.
      IF not available tr_hist THEN
      DO:
         pause 0.
         message "错误:该事务号不存在!" .
         undo,retry.
      END.
      ELSE DO:
         IF tr__log01 = yes THEN
         DO:
            pause 0.
            message "错误:该事务号的已经被冲减过!" .
            undo,retry.
            
         END.
         ELSE IF tr_part <> part THEN
         DO:
            pause 0.
            message "错误:零件号与事务号的零件不相同!" .
            undo,retry.
            
         END. /*tr_part <> part*/
         ELSE IF tr_site <> site THEN DO:
            pause 0.
            message "错误:地点与事务号的地点不相同!" .
            undo,retry.
            
         END. /* tr_site <> site */
         ELSE IF tr_loc <> loc THEN
         DO:
            pause 0.
            message "错误:库位与事务号的库位不相同!" .
            undo,retry.
            
         END.
         ELSE IF tr_qty_loc <> xwQTY THEN 
         DO:
            pause 0.
            message "错误:数量与事务号的数量不相同!" .
            undo,retry.
            
         END. /*tr_qty_chq <> xwQTY*/
      END. /*available tr_hist*/
      
      iSeq = string(tr_trnbr).

   end. /*xwChkTrID */
   ELSE DO:
      iSeq = "999999".
   END.
   run CrtXwosd ( input iSeq).
end. /*repeat*/

status input.

PROCEDURE CrtXwosd:
define input parameter xSeq like xwosd_fg_lot.
   if not xwChkTrID then do:
      FIND first xwosd_det where xwosd_lnr = xwLnr
         and xwosd_date = today
         and xwosd_fg_lot = xSeq
         and xwosd_part = part
         NO-LOCK NO-ERROR.
      IF available xwosd_det THEN
      DO:
         MESSAGE "警告:该零件已在今天冲扣过一次，还要冲减?  " 
                 VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO              
                 TITLE "重处冲减询问? " UPDATE xAnswer.        
         IF not xAnswer THEN
         DO:
            return.
         END.
         
      END. /*available xwosd_det*/
   END. /* not xwChkTrID  */
   create xwosd_det.
   ASSIGN xwosd_lnr = xwLnr
          xwosd_date = today
          xwosd_fg_lot = xSeq
          xwosd_site = site
          xwosd_loc = loc
          xwosd_part = part
          xwosd_qty  = - xwQTY
          xwosd_bkflh = yes
          xwosd_used = yes
          xwosd_use_dt = today
          xwosd_use_tm = time
          xwosd__chr01 = global_userid
          xwosd__chr02 = xwRmks.
          
   release xwosd_det.
   
   /*{mfmsg.i 1 1}  ADDING NEW RECORD */
   {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1 }

   if xwChkTrID then do:
      FIND tr_hist where string(tr_trnbr) = xSeq exclusive-lock no-error.
      if available tr_hist then do:
         tr__log01 = yes .
      end.
      release tr_hist.
   end.

END PROCEDURE. /* PROCEDURE ASSIGN_DEFAULT_WO_ACCT */
