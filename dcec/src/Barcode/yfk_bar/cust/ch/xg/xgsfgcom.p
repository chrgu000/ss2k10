/* xgfgcom.p                  产品下线扫描                      */
/* Created by    hou                           2005.12.19       */
/* Last MOdified: hou                          2006.03.21 *H01* */

{mfdtitle.i "ao"}

{pxmaint.i}

{pxphdef.i kbknbdxr}

{kbconst.i}
{kbvars.i}

define variable btn           as widget-handle extent 16.
define variable rid           as recid extent 16.
define variable cnt           as integer extent 16.

define variable ibtn          as integer.
define variable shft          as char format "x(4)" label "班次".
define variable batchno       as char.
define variable yy            as char format "x(1)" extent 40 no-undo.
define variable mm            as char format "x(1)" extent 12 no-undo.
define variable i             as integer.
define variable filetmp       as char format "x(50)".

define variable lnr           like xgpl_lnr.
define variable xpdnbr        like xpd_nbr.
define variable site          like pt_site.
define variable loc           like pt_loc.
define variable part          like pt_part.
define variable ptdesc        like pt_desc1.
define variable cname         like ad_name.
define variable cpart         like pt_part.
define variable subqty        like xpal_sub_qty .
define variable fulqty        like xpal_full_qty  .
define variable defcust       like xpal_cust_def label "客户".
define variable defdloc       like xpal_dloc_def label "发运库位".
define variable nextnbr       like xpal_next_nbr.
define variable tmplot        as   char initial "UNCOMPLETED".
define variable ldesc         as   char.
define variable v_rmks        as   char format "x(34)" label "备注".
define variable v_tip         as   char.
define variable v_cnt         as   integer.
define variable v_close       as   logical label "结束包装" .
define variable v_just_close  as   logical label "不含本次数量".
define variable v_temp_ord    as   logical.

DEFINE VARIABLE btnfont       AS   CHAR INITIAL "宋体, size=20 bold".
DEFINE VARIABLE frmfont       AS   CHAR INITIAL "宋体, size=14 bold".
DEFINE VARIABLE cfont         AS   CHAR.
define variable v_qty_pack    like xwo_qty_lot.
define variable v_qty_short   like xwo_qty_lot label "短缺量".
define variable v_un_lot      as   integer.
define variable v_msg         as   char.
define variable v_qty_xpd     like xpd_qty_ord.
define variable v_print       as   logical.
define variable v_found       as   logical.
define variable v_tmp_rid     as   rowid.

define button btnY  label "确定" font 31 auto-go.
define button btnN  label "取消" font 31 auto-endkey.

define variable chexcelapplication  as com-handle.
define variable chexcelworkbook     as com-handle.
define variable chexcelworksheet    as com-handle.

define buffer   xpc    for xpal_ctrl.
define buffer   bfxwo  for xwo_srt.
define buffer   bfxwod for xwosd_det.

define new shared variable parpart like pt_part.

define temp-table ttfg no-undo
   field ttfg_flag   as    logical  format "*/ "
   field ttfg_part   like  pt_part label "零件号"
   field ttfg_desc   like  pt_desc1 format "x(18)" label "描述"
   field ttfg_line   like  xpal_line
   field ttfg_code   like  xpal_code
   field ttfg_cust   like  defcust
   field ttfg_dloc   like  defdloc
   field ttfg_cnt    as    integer label "已点击"
   field ttfg_note   as    char    format "x(4)" label "备注"
   field ttfg_nbr    as    char    label "生产单"
   field ttfg_recid  as    recid.
   
define new shared workfile pkkdet no-undo
    field pkkpart like ps_comp
    field pkkop as char format "x(20)" 
    field pkkqty like pk_qty.

{xglogdef.i "new"}

GET-KEY-VALUE SECTION "fonts" KEY "font30" VALUE cfont.
IF cfont <> btnfont THEN DO:
   PUT-KEY-VALUE SECTION "fonts" KEY "font30" VALUE btnfont.
   PUT-KEY-VALUE SECTION "fonts" KEY "font31" VALUE frmfont.
   MESSAGE "为了显示正确，需要重新进入MFG/PRO" VIEW-AS ALERT-BOX MESSAGE.
   LEAVE.
END.

GET-KEY-VALUE SECTION "fonts" KEY "font31" VALUE cfont.
IF cfont <> frmfont THEN DO:
   PUT-KEY-VALUE SECTION "fonts" KEY "font31" VALUE frmfont.
   MESSAGE "为了显示正确，需要重新进入MFG/PRO" VIEW-AS ALERT-BOX MESSAGE.
   LEAVE.
END.

&SCOPED-DEFINE PP_FRAME_NAME A

FORM
   RECT-FRAME       AT ROW 1 COLUMN 1.25
   RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
   skip(.1)
   lnr          colon 20
   xgpl_desc    at    36 no-labels format "x(40)"
   shft         colon 20
   skip(.4)
WITH FRAME a WIDTH 80 SIDE-LABELS NO-BOX THREE-D.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM
   RECT-FRAME       AT ROW 1 COLUMN 1.25
   RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
   skip(16)
WITH  FRAME b  WIDTH 80 THREE-D.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

FORM
   ttfg_flag NO-LABELS
   ttfg_part 
   ttfg_desc
   ttfg_cust
   ttfg_dloc
   ttfg_nbr  
/*   ttfg_cnt */
   ttfg_note
WITH centered overlay down FRAM f WIDTH 80 THREE-D.

form   
   skip(.2)  
   part           colon 14 LABEL "零件号" 
   pt_desc1       colon 14 LABEL "描述"
   defcust        colon 14 FORMAT "x(10)"
   cname          no-labels at 32 FORMAT "x(24)" 
   defdloc        colon 14 FORMAT "x(10)"
   ldesc          no-labels at 32 FORMAT "x(24)"
   fulqty         colon 14
   v_qty_short    colon 40
   subqty         colon 14
   v_cnt          colon 40 label "点击次数"
   v_rmks         colon 14
   v_close        at    12 view-as toggle-box 
   skip(1)
   space(16) btnY  
   space(20) btnN
   skip(.2) 
with frame c side-labels size 72 by 21 three-d view-as dialog-box font 31 title "请确认信息正确".

/*******************
filetmp = search("finbox.xls").
if filetmp = ? then do:
     message "打印模板finbox.xls不存在".
     pause.
     leave.
end.          
*******************/

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

HIDE FRAME f NO-PAUSE.

blocka:
do on error undo, retry  with frame a:
   v_temp_ord = no.
   
   update lnr shft.
   
   find first xgpl_ctrl where xgpl_lnr = lnr no-lock no-error.
   if not avail xgpl_ctrl then do:
      {mfmsg.i 8524 3}
      undo blocka, retry blocka.
   end.
   
   disp xgpl_desc.
   
   find first xpal_ctrl where xpal_line = lnr no-lock no-error.
   if not avail xpal_ctrl then do:
      message "托盘控制程序未定义".
      undo blocka , retry blocka.
   end.
   
   find first code_mstr where code_fldname = "shft" and code_value = shft
   no-lock no-error.
   if not avail code_mstr then do:
      message "非法的班次".
      undo blocka, retry blocka.
   end.
   
   run createPartlist(input xgpl_lnr, output v_un_lot).
      
end.

ibtn = 0.
loc = xgpl_loc_lnr.
find first ttfg where ttfg_flag no-lock no-error.
do while avail ttfg:
   find first pt_mstr where pt_part = ttfg_part no-lock no-error.
   if not avail pt_mstr then next.
   ibtn = ibtn + 1.
   rid[ibtn] = recid(ttfg).
   cnt[ibtn] = ttfg_cnt.
   create button btn[ibtn]
/*Jeff*   assign row = (trunc((ibtn - 1) / 3,0) * 4 + 2)
          column = (((ibtn - 1) mod 3) * 26 + 3)
          label = ttfg_part
          font = 30
          WIDTH-CHARS = 24 */
/*Jeff*/  assign row = (trunc((ibtn - 1) / 2,0) * 3 + 2)
          column = (((ibtn - 1) mod 2) * 38 + 3)
          label = ttfg_part
          font = 10
          WIDTH-CHARS = 35 
          frame = frame b:handle
          sensitive = true
          visible = true
          triggers:
             on choose do :
                run xxx .
             end.
          end triggers.
   
   find next ttfg where ttfg_flag no-lock no-error.
end.

do on endkey undo, leave:
   wait-for window-close of current-window.
end.

do i = 1 to ibtn:
   DELETE WIDGET btn[i].
end.

/****************************************************************************/
/****************************************************************************/
procedure createpartlist:
   define input parameter  p_line  as char.
   define output parameter p_num   as integer.
   
   p_num = 0.
   
   v_tip = "回车-选择 M-修改 ESC-退出".
  
   for each ttfg:
      delete ttfg.
   end.
   
/*Jeff*   for each xpal_ctrl where xpal_line = p_line no-lock: */
/*Jeff**/   for each xpal_ctrl where xpal_line = p_line 
		   and xpal_cust_def = "m111a" no-lock:  /*semi-product only*/
      find first pt_mstr where pt_part = xpal_part no-lock no-error.
      
      create ttfg.
      assign ttfg_flag = yes
             ttfg_part = xpal_part
             ttfg_line = xpal_line
             ttfg_cust = xpal_cust_def
             ttfg_dloc = xpal_dloc_def
             ttfg_desc = if avail pt_mstr then pt_desc1 else ""
             ttfg_recid = recid(xpal_ctrl).
      
      find first xwo_srt where xwo_lnr = xpal_line and xwo_part = xpal_part 
      and xwo_lot = tmplot and xwo_pdnbr = "" no-lock no-error.
      if avail xwo_srt then do:
         p_num = p_num + 1.
         ttfg_cnt = xwo_qty_lot / xpal_sub_qty.
         ttfg_note = "未结".
      end.
   end.
   
   do on error undo, retry :
      {xgut001.i
       &file = "ttfg"
       &where = "where true"
       &frame = "f"
       &fieldlist = "ttfg_flag
                     ttfg_part  
                     ttfg_desc
                     ttfg_cust
                     ttfg_dloc
                     ttfg_nbr
/*                     ttfg_cnt */
                     ttfg_note
                    "
       &prompt     = "ttfg_part"
       &midchoose  = "color mesages"
       &predisplay = "~hide message no-pause. message v_tip.~ "
       &updkey     = "M"
       &updcode    = "~{xgfgcom1.i~}"
       &key1       = "ENTER"
       &code1      = "~{xgfgcom2.i~}"
       }
   
   end.
end procedure.

/****************************************************************************/
procedure xxx:
   define var ptdesc   like pt_desc1.
   define var num      as   integer.
   
   DO on error undo, leave
      on endkey undo, leave:
            
      num = self:TAB-POSITION + 1 - btn[1]:TAB-POSITION.
      find ttfg where recid(ttfg) = rid[num] no-lock no-error.
      find xpc where recid(xpc) = ttfg_recid no-lock no-error.
      
      v_cnt = cnt[num].
      defcust = ttfg_cust.
      defdloc = ttfg_dloc.
      fulqty = xpc.xpal_full_qty.
      subqty = xpc.xpal_sub_qty.
      part = xpc.xpal_part.

/*est*/ DEFINE VARIABLE sucess AS LOGICAL INITIAL FALSE.
/*est*/   {gprun.i ""kbcom01.p"" "(INPUT part,input subqty,input shft, OUTPUT sucess)"}
/*est*/  IF NOT sucess THEN UNDO, LEAVE.
      
      IF fulqty = 0 OR subqty = 0 THEN DO:
         MESSAGE "控制文件中数量不正确" VIEW-AS ALERT-BOX ERROR.
         UNDO, LEAVE.
      END.
      
      find first ad_mstr where ad_addr = defcust no-lock no-error.
      if avail ad_mstr then cname = ad_name.
      else cname = "".
      
      find first loc_mstr where loc_loc = defdloc no-lock no-error.
      if avail loc_mstr then ldesc = loc_desc.
      else ldesc = "".
      
      find first pt_mstr where pt_part = part no-lock no-error.
      
      v_qty_short = fulqty.
      find first xwo_srt where xwo_lnr = lnr and xwo_part = part 
      and xwo_lot = tmplot and xwo_pdnbr = ttfg_nbr no-lock no-error.
      if avail xwo_srt then 
         v_qty_short = v_qty_short - xwo_qty_lot.
         
      v_rmks = "".
      if ttfg_nbr <> "" then do:
         find first xpd_mstr where xpd_nbr = ttfg_nbr no-lock no-error.
         if avail xpd_mstr then do:
            v_rmks = "生产单" + xpd_nbr + "|" + "短缺量" + string(xpd_qty_ord - xpd_qty_com).
         end.
      end.

      v_close = no.
      v_print = no.
      
/*est*/   /*   disp part pt_desc1 defcust cname defdloc ldesc fulqty 
/*est*/           subqty v_cnt v_qty_short v_rmks v_close
/*est*/      with frame c.*/
      
/*est*/ /*     update subqty v_close btnY btnN with frame c.*/
      
      if avail xpd_mstr then do:
         if subqty > (xpd_qty_ord - xpd_qty_com) then do:
            message "完成量超过生产单需求量" skip
                    "生产单:" + ttfg_nbr  skip
            view-as alert-box error.
            undo, leave.
         end.
      end.
      
      /* Create xwosd_det */
      for each pkkdet:
        delete pkkdet.
      end.
 
      parpart = part.
      
      {gprun.i ""xgbmpkiq.p""}
 
      find first pt_mstr where pt_part = part no-lock no-error.
      ptdesc = pt_desc1.

      trblock:
      do transaction on error undo ,leave:
         if avail xwo_srt then do:
            v_tmp_rid = rowid(xwo_srt).
            find xwo_srt where rowid(xwo_srt) = v_tmp_rid 
            exclusive-lock no-error.

/*H01*/     {xgxwoo.i xwo_serial subqty}
            
            batchno = xwo_serial.
            assign xwo_date    = today
                   xwo_time    = time
                   xwo_due_date  = today
                   xwo_due_time  = time
                   xwo_qty_lot   = xwo_qty_lot + subqty.
            
            if xwo_shift <> shft then xwo_shift   = shft.
            
            for each pkkdet:
               find first xwosd_det where xwosd_lnr = lnr and xwosd_part = pkkpart
               and xwosd_fg_lot = xwo_serial and xwosd_op = pkkop no-lock no-error.
               if avail xwosd_det then do:
/*H01*/           {xgxwosdo.i pkkqty * subqty}
                  
                  v_tmp_rid = rowid(xwosd_det).
                  find xwosd_det where rowid(xwosd_det) = v_tmp_rid
                  exclusive-lock no-error.
                  if avail xwosd_det then do:
                     assign	
                         xwosd_date   = today
                         xwosd_qty    = xwosd_qty + pkkqty * subqty
                         xwosd_use_dt = today
                         xwosd_use_tm = time.
                  end.    
                  release xwosd_det.
               end.
            end.
            if xwo_qty_lot = fulqty then v_close = yes.   
         end.
         else do:
            find xpc where recid(xpc) = ttfg_recid exclusive-lock no-error.
            if xpc.xpal_date1 <> today then do:
               xpc.xpal_date1 = today.
               xpc.xpal_next_nbr1 = 1.
            end.
            else do:
              xpc.xpal_next_nbr1 = xpc.xpal_next_nbr1 + 1.
            end.
            nextnbr = xpc.xpal_next_nbr1.
   
            repeat:
               /* 批箱号：生产线识别码2位＋产品识别码(1位)＋生产日期4位 ＋班别号1位 ＋3位顺序号 */
               batchno = substr(lnr,1,2) 
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
            release  xpal_ctrl.

            /* create xwo_srt */
            create xwo_srt.
            assign xwo_lnr       = lnr
                   xwo_shift     = shft
                   xwo_part      = part
                   xwo_pt_desc   = ptdesc
                   xwo_lot       = tmplot
                   xwo_date      = today
                   xwo_time      = time
                   xwo_due_date  = today
                   xwo_due_time  = time
                   xwo_site      = site
                   xwo_loc_des   = defdloc
                   xwo_blkflh    = no
                   xwo_qty_lot   = subqty
                   xwo_serial    = batchno
                   xwo_loc_lnr   = loc
                   xwo_cust      = defcust
                   xwo_pdnbr     = ttfg_nbr.
            
/*H01*/     {xgxwoo.i xwo_serial subqty}

            for each pkkdet:
               create xwosd_det.
               assign	
                   xwosd_lnr    = lnr
                   xwosd_part   = pkkpart
                   xwosd_date   = today
                   xwosd_fg_lot = batchno
                   xwosd_op     = pkkop
                   xwosd_qty    = pkkqty * subqty
                   xwosd_used   = yes
                   xwosd_use_dt = today
                   xwosd_use_tm = time
                   xwosd_bkflh  = no
                   xwosd_pdnbr  = ttfg_nbr.
               
               find first pt_mstr where pt_part = pkkpart no-lock no-error.
               if available pt_mstr then do:
                  xwosd_site = pt_site.
                  xwosd_loc = pt_loc.  
                  if pt_iss_pol = no then do:
                     xwosd_used = no.
                     xwosd_bkflh = yes.
                  end.
               end.

/*H01*/        {xgxwosdo.i pkkqty * subqty}
               
            end.
            if xwo_qty_lot = fulqty then v_close = yes.
         end. /* not avail xwo_srt */
         
         /* 更新临时生产单及明细，若发现子零件工作缓冲高于需求   */
         /* 则对该子零件的看板进行失效或关闭处理，以降低工作缓冲 */
         /* 若生产单完成，则关闭该单，并对子零件做善后处理       */
         if ttfg_nbr <> "" then do:
            find first xpd_mstr where xpd_nbr = ttfg_nbr and xpd_part = ttfg_part
            and xpd_lnr = ttfg_line exclusive-lock no-error.
            if avail xpd_mstr then do:
               xpd_qty_com = xpd_qty_com + subqty.
            end.
            
            if xpd_type = "" then do:
               for each pkkdet:
                  if ttfg_nbr <> "" then do:
                     find first xpdsd_det where xpdsd_nbr = ttfg_nbr and xpdsd_part = pkkpart
                     exclusive-lock no-error.
                     if avail xpdsd_det then do:
                        xpdsd_qty_cum = xpdsd_qty_cum + pkkqty * subqty.
                        v_qty_xpd = xpdsd_qty - xpdsd_qty_cum.
                        if v_qty_xpd <= xpdsd_work_buf then do:
               
                           {gprun.i ""xgkbpd01.p"" "(input ttfg_nbr, 
                                                     input xpdsd_part,
                                                     input v_qty_xpd,
                                                     input-output xpdsd_work_buf)"}
                        end.
                     end.
                  end.
               end.
            end.
            
            if xpd_qty_com = xpd_qty_ord then do:
               xpd_stat = "C".
               v_close = yes.
            end.
         end.
         
         if v_close then do:
            if ttfg_nbr <> "" and xpd_stat = "C" and xpd_type = "" then do:
               for each xwosd_det where xwosd_det.xwosd_lnr = lnr and xwosd_det.xwosd_fg_lot = xwo_serial
                  and xwosd_det.xwosd_pdnbr = ttfg_nbr no-lock:
                  if xwosd_det.xwosd_qty = xwosd_det.xwosd_qty_consumed then next.
                  
                  find bfxwod where rowid(bfxwod) = rowid(xwosd_det)
                  exclusive-lock no-error.
                  
                  bfxwod.xwosd_qty_consumed = bfxwod.xwosd_qty.
                  
                  for each xpdkb_det where xpdkb_nbr = ttfg_nbr and 
                  
                     xpdkb_part = bfxwod.xwosd_part:
                  
                     find first knbd_det where knbd_id = xpdkb_id and knbd_active
                     no-lock no-error.
                     if avail knbd_det then do:
                        v_tmp_rid =rowid(knbd_det).
                        find knbd_det where rowid(knbd_det) = v_tmp_rid
                        exclusive-lock no-error.
                        if avail knbd_det then do:
                           if knbd_active_code = {&KB-CARD-ACTIVE-CODE-PERIOD} then
                              assign knbd_pou_ref = ""
                                     knbd_active_start_date = ?.

                           if knbd_status = {&KB-CARDSTATE-EMPTYACC} then 
                              {gprun.i ""xgkbcdmt02.p"" "(input knbd_id,output v_msg)"}
                           else do:
                              /************************************
                              assign
                                 knbd_status = {&KB-CARDSTATE-EMPTYACC}
                                 knbd_print_dispatch = no
                                 knbd_authorize_date = ?
                                 knbd_authorize_time = 0
                                 knbd_dispatch_id = ""
                                 knbd_disp_list_date = ?
                                 knbd_disp_list_time = 0
                                 knbd_due_date = ?
                                 knbd_due_time = 0
                                 knbd_status_chg_date = today
                                 knbd_status_chg_time = time.

                              {pxrun.i &PROC  = 'setKanbanCardDetailExtendFields'
                                 &PROGRAM = 'kbknbdxr.p'
                                 &HANDLE = ph_kbknbdxr
                                 &PARAM = "(buffer knbd_det,
                                            input knbd_cmtindx,
                                            input knbd_disp_list_date,
                                            input knbd_disp_list_time,
                                            input knbd_status_chg_date,
                                            input knbd_status_chg_time,
                                            input knbd_auto_print_req,
                                            input knbd_dispatch_id,
                                            input knbd_second_card_ID,
                                            input knbd_due_date,
                                            input knbd_due_time,
                                            input knbd_del_status_code,
                                            input knbd_del_loc)"
                                 &NOAPPERROR = true
                                 &CATCHERROR = true}
                              
                              {pxrun.i &PROC  = 'setModificationInfo' &PROGRAM = 'kbknbdxr.p'
                                 &PARAM = "(buffer knbd_det)"
                                 &NOAPPERROR = true
                                 &CATCHERROR = true
                                 }
                              *************************************/
                              {gprun.i ""xgkbcdmt03.p"" "(input knbd_id,output v_msg)"}
                           end.
                        end.   
                        release knbd_det.
                     end.
                  end.
                  release bfxwod.
               end.
            end.
            
            xwo_lot = xwo_serial.
            
            for each pkkdet:
               find first xwosd_det where xwosd_det.xwosd_lnr = lnr and xwosd_det.xwosd_part = pkkpart
               and xwosd_det.xwosd_fg_lot = xwo_lot and xwosd_det.xwosd_op = pkkop no-lock no-error.
               if avail xwosd_det then do:
                  find bfxwod where rowid(bfxwod) = rowid(xwosd_det) 
                  exclusive-lock no-error.
                  if avail bfxwod then do:
                     assign	
                         bfxwod.xwosd_date   = today
                         bfxwod.xwosd_use_dt = today
                         bfxwod.xwosd_use_tm = time.
                  end.
                  release bfxwod.    
               end.
            end.
            
            {gprun.i ""xgcrt01s.p"" "(input rowid(xwo_srt), output v_msg) " }

            if v_msg <> "" then do:
               message "加工单回冲cim失败" skip
                       v_msg skip
               view-as alert-box error.
               undo trblock, leave trblock.
            end.

            cnt[num] = 0.
            /*************************
            v_print = yes.
            message "包装已完成,是否打印包装条码?" skip(1)
                    "批号：" + string(batchno) 
                    VIEW-AS ALERT-BOX 
                    QUESTION BUTTONS YES-NO 
                    UPDATE v_print.
   
            if v_print then v_qty_pack = xwo_qty_lot.
            ****************************/
         end.
         else do:
            cnt[num] = cnt[num] + 1.
         end.
         
         release bfxwod.
         release xpd_mstr.
         release xpdsd_det.
         release xpdkb_det.
         release xwo_srt.
         release xpc.
      end. /* do transaction */
      
      /***********************
      /* print barcode */
      if v_print then do:
         find first pt_mstr where pt_part = part no-lock no-error.
         if avail pt_mstr then ptdesc = pt_desc1.
         else ptdesc = "".
      
         find first ad_mstr where ad_addr = defcust no-lock no-error.
         if avail ad_mstr then cname = ad_name.
         else cname = "".
      
         find first cp_mstr where cp_cust = defcust and cp_part = part no-lock no-error.
         if not avail cp_mstr then do:
            find first cp_mstr where cp_part = part no-lock no-error.        
         end.
         if avail cp_mstr then cpart = cp_cust_part.
         else cpart = "".

        FIND FIRST xgpl_ctrl WHERE xgpl_lnr = lnr NO-LOCK NO-ERROR.

         /* Create a New chExcel Application object */
         CREATE "Excel.Application" chExcelApplication.          
         chExcelWorkbook = chExcelApplication:Workbooks:Open(filetmp).                         
         chExcelWorksheet = chExcelWorkbook:ActiveSheet(). 
      
         chExcelWorksheet:Cells(1, 2) = "*" + trim(part) +  "*".
         chExcelWorksheet:Cells(1, 4) = ptdesc.
         chExcelWorksheet:Cells(3, 2) = "*" + string(v_qty_pack) +  "*".
         chExcelWorksheet:Cells(3, 4) = "*" + trim(batchno) + "*".
         chExcelWorksheet:Cells(5, 2) = cname.
         chExcelWorksheet:Cells(5, 4) = "*" + trim(cpart) + "*".
      
         chExcelApplication:Visible = false.
         chExcelWorksheet:printout(,,,,xgpl_chr2,,).
         
         chExcelWorkbook:CLOSE(FALSE).
         chExcelApplication:QUIT.
      
      
          /* Release com - handles */
         RELEASE OBJECT chExcelWorksheet. 
         RELEASE OBJECT chExcelWorkbook.
         RELEASE OBJECT chExcelApplication.
      end.
      ************************************************/
      
      message "操作完成".
            
   END.
end procedure.

procedure checkbatchno:
   define input-output parameter bno as char.
   
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
