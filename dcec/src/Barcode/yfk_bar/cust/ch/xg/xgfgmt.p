/* xgfgmt.p      非经常性产品生产维护                    */
/* create by hou               2006/02/22                */


{mfdtitle.i "ao"}
{kbconst.i}

define variable   v_nbr    as    char.
define variable   v_stime  as    char  label "开始时间" format "x(5)".
define variable   v_xpdrid as    rowid.
define variable   v_new    as    logical.
define variable   v_tip    as    char.
define variable   v_msg    as    char.
define variable   v_del    as    logical.
define variable   v_yn     as    logical.
define variable   v_nokb   as    logical.
define variable   v_krnbr  as    char.
define variable   v_desc   like  pt_desc1 .
define variable   v_line   as    integer.
define variable   v_rowid  as    rowid.
define variable   v_kro    as    logical.
define variable   v_ldtm   as    integer label "提前期".
define variable   v_actdt  as    date.
define variable   v_acttm  like  xkro_ord_time.
define variable   v_kbid   as    char format "x(60)" label "看板".

define buffer     xpdm     for   xpd_mstr.

define new shared variable parpart like pt_part.

define new shared workfile pkkdet no-undo
    field pkkpart like ps_comp
    field pkkop as char format "x(20)" 
    field pkkqty like pk_qty.

define temp-table ttkb no-undo
   field ttkb_part   like pt_part  column-label "子零件"
   field ttkb_rq_qty like knbd_kanban_quantity column-label "需求量"
   field ttkb_kbid   like knbd_id  column-label "看板卡"
   field ttkb_active as   logical  column-label "是否使用"
   field ttkb_acd    like knbd_active_code column-label "当前有效代码"
   field ttkb_kb_qty like knbd_kanban_quantity column-label "看板数量"
   field ttkb_msg    as   char  format "x(30)" column-label "备注".
   

{xkutlib.i}

&SCOPED-DEFINE PP_FRAME_NAME A

FORM 
    SKIP(.1)  
    xpd_nbr       colon    10
    xpd__log01    colon    30 label "计划管理"
    xpd_stat      colon    64
    xpd_part      colon    10 label "零件号"
    v_desc        colon    30 no-labels
    xpd_lnr       colon    64
    xpd_ord_date  colon    10 label "开始日期"
    v_stime       colon    30
    "(HH:MM)"     at       40
    xpd_cust      colon    64
    xpd_site      colon    10 label "地点"
    xpd_loc_des   colon    30 label "发运库位"
    xpd_user1     colon    64 label "原材料库位"
    xpd_qty_ord   colon    10 format ">>>>>9"
    xpd_qty_com   colon    30
    v_ldtm        colon    64 
    SKIP(1)  
WITH FRAME a SIDE-LABELS WIDTH 80 ATTR-SPACE THREE-D .

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

setFrameLabels(frame a:handle).

form
   ttkb_part  
   ttkb_rq_qty
   ttkb_kbid  
   ttkb_kb_qty    
   ttkb_acd    
   ttkb_active 
with centered overlay DOWN frame f-kb width 80 three-d.

form
   ttkb_part   
   ttkb_kbid   
   ttkb_active 
   ttkb_msg    
with DOWN frame b width 80 attr-space three-d.

mainloop:
repeat with frame a:
   clear frame a.
   hide frame b .
   hide message.
   
   prompt-for xpd_nbr with frame a editing:
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i xpd_mstr xpd_nbr xpd_nbr xpd_nbr xpd_nbr xpd_nbr}
      if recno <> ? then do:
         v_stime = string(xpd_ord_time,"hh:mm").
         find first pt_mstr where pt_part = xpd_part no-lock no-error.
         if avail pt_mstr then v_desc = pt_desc1.
         else v_desc = "".
         
         display xpd_nbr xpd_stat xpd_lnr xpd_part xpd_ord_date
                 v_stime xpd_cust xpd_loc_des xpd_qty_ord v_desc
                 xpd__log01 xpd_user1 xpd_site xpd_qty_com
         with frame a.
      end. /* IF RECNO <> ? */
   end. /* EDITING */
   
   v_new = no.
   
   seta:
   do transaction with frame a on error undo, retry:
      find xpd_mstr using xpd_nbr no-error.
      if not avail xpd_mstr then do:
         if input xpd_nbr <> "" then do:
            message "生产单不存在." 
            view-as alert-box error.
            undo mainloop, retry mainloop.
         end.

         find first code_mstr where code_fldname = "xpd_mstr.nbr" no-lock no-error.
         if not available code_mstr then do:
            create code_mstr .
            assign code_fldname = "xpd_mstr.nbr"
            code_value = "XP"
            code_cmmt = "1" .
         end.
         v_rowid = rowid(code_mstr).
         
         repeat:
            find code_mstr where rowid(code_mstr) = v_rowid exclusive-lock no-error.
            
            v_nbr = trim(code_value) + string(integer(code_cmmt),"999999").
            find first xpdm where xpdm.xpd_nbr = v_nbr no-lock no-error.
            if not available xpdm then do:
               release code_mstr.
               leave.
            end.
            else do:
               code_cmmt = string(integer(code_cmmt) + 1).
               release code_mstr.
            end.
         end.
         
         v_new = yes.
         create xpd_mstr.
         assign xpd_nbr = v_nbr
                xpd_stat = ""
                xpd_ord_date = today.

      end. /* if not avail xpd_mstr */
      
      v_nbr = xpd_nbr.
      
      if xpd_stat = "C" then do:
         message "生产单已经关闭" skip
         view-as alert-box error.
         undo mainloop, retry mainloop.
      end.
      
      v_xpdrid = rowid(xpd_mstr).
      
      find first pt_mstr where pt_part = xpd_part no-lock no-error.
      if avail pt_mstr then v_desc = pt_desc1.
      else v_desc = "".
      v_stime = string(xpd_ord_time,"hh:mm").
      display xpd_nbr xpd_stat xpd_lnr xpd_part xpd_ord_date
              v_stime xpd_cust xpd_loc_des xpd_qty_ord v_desc
              xpd__log01 xpd_site xpd_user1 xpd_qty_com
      with frame a.

      setb:
      do on error undo, retry:
         xpd_user1 = "R001A".
         xpd_site = "1000".
         update xpd__log01 when v_new
                xpd_stat
                xpd_part   when v_new
                xpd_lnr    when v_new
                xpd_ord_date
                v_stime     
                xpd_cust    
                xpd_site
                xpd_loc_des 
                xpd_user1 
                xpd_qty_ord
                v_ldtm
         with frame a.
          
         find first xgpl_ctrl where xgpl_lnr = xpd_lnr no-lock no-error.
         if not avail xgpl_ctrl then do:
            {mfmsg.i 8524 3}
            undo setb, retry setb.
         end.
         
         xpd_loc = xgpl_loc_lnr.
         
         find first pt_mstr where pt_part = xpd_part no-lock no-error.
         if not avail pt_mstr then do:
            message "无此零件号" view-as alert-box error.
            undo setb, retry setb.
         end.
         
         if xpd_stat <> "" and xpd_stat <> "C" then do:
            message "状态只能为空-正常/C-关闭" view-as alert-box error.
            undo setb, retry setb.
         end.
         
         if not IsCorrectTime(v_stime) then do:
            message "请输入正确的时间" view-as alert-box error.
            undo setb, retry setb.
         end.
         
         find first loc_mstr where loc_loc = xpd_loc_des no-lock no-error.
         if not avail loc_mstr then do:
            message "发运库位不正确" view-as alert-box error.
            undo setb, retry setb.
         end.
         
         find first loc_mstr where loc_loc = xpd_user1 no-lock no-error.
         if not avail loc_mstr then do:
            message "原材料库位不正确" view-as alert-box error.
            undo setb, retry setb.
         end.
         
         find first si_mstr where si_site = xpd_site no-lock no-error.
         if not avail si_mstr then do:
            message "非法的地点" view-as alert-box error.
            undo setb, retry setb.
         end.
         
         find first cm_mstr where cm_addr = xpd_cust no-lock no-error.
         if not avail cm_mstr then do:
            message "无此客户" view-as alert-box error.
            undo setb, retry setb.
         end.
         
         if xpd_qty_ord < xpd_qty_com then do:
            message "需求量必须大于等于完成量" view-as alert-box error.
            undo setb, retry setb.
         end.
         
         if xpd_qty_ord = xpd_qty_com then do:
            message "需求量等于完成量,生产单将关闭" skip
                    "确认吗?" 
            view-as alert-box question buttons yes-no
            update v_yn.
            if not v_yn then undo setb, retry setb.
         end.
         
         if xpd_stat = "C" and xpd_qty_ord <> xpd_qty_com then do:
            message "生产单未完成，不可关闭" view-as alert-box error.
            undo setb, retry setb.
         end.
         
         xpd_ord_time = integer(substr(v_stime,1,index(v_stime,":") - 1)) * 3600
                      + integer(substr(v_stime,index(v_stime,":") + 1)) * 60.

         if xpd_ord_time < v_ldtm * 3600 then do:
            v_actdt = xpd_ord_date - 1.
            v_acttm = 86400 - (v_ldtm * 3600 - xpd_ord_time).
         end.
         else do:
            v_actdt = xpd_ord_date.
            v_acttm = xpd_ord_time - v_ldtm * 3600.
         end.
            
                      
      end. /* setb */

      if xpd_qty_ord = xpd_qty_com then do:
         xpd_stat = "C".
         next mainloop.
      end.
      
      /* Create xpdsd_det */
      for each pkkdet:
        delete pkkdet.
      end.
 
      parpart = xpd_part.
      
      {gprun.i ""xgbmpkiq.p""}

      if not xpd__log01 then do:
         for each pkkdet where pkkqty <> 0:
            
            find first pt_mstr where pt_part = pkkpart and pt_iss_pol = yes no-lock no-error.
            if not available pt_mstr then next .
   
            if v_new then do:
               create xpdsd_det.
               assign        
                  xpdsd_nbr    = xpd_nbr
                  xpdsd_part   = pkkpart
                  xpdsd_date   = today
                  xpdsd_qty    = pkkqty * xpd_qty_ord.
            end.
            else do:
               find first xpdsd_det where xpdsd_nbr = xpd_nbr and xpdsd_part = pkkpart
               exclusive-lock no-error.
               if avail xpdsd_det then do:
                  xpdsd_qty = pkkqty * xpd_qty_ord.
                  xpdsd_work_buf = 0.
               end.
            end.
         end.
   
         for each ttkb:
            delete ttkb.
         end.
         
         for each xpdsd_det where xpdsd_nbr = xpd_nbr no-lock:
            
            for each knbsm_mstr no-lock where
               knbsm_site = xpd_site and
               knbsm_supermarket_id = xpd_lnr,
            each knb_mstr no-lock where
               knb_knbsm_keyid = knbsm_keyid,
            each knbi_mstr no-lock where
               knbi_keyid = knb_knbi_keyid and
               knbi_part = xpdsd_part ,
            /**********************************
            each knbs_det no-lock where
               knbs_keyid = knb_knbs_keyid and
              ((knbs_source_type = {&KB-SOURCETYPE-SUPPLIER} and
                knbs_ref1 >= kb-source and
                knbs_ref1 <= kb-source1)
                    or
               (knbs_source_type <> {&KB-SOURCETYPE-SUPPLIER} and
                knbs_ref2 >= kb-source and
                knbs_ref2 <= kb-source1))
                  and 
              ((knbs_source_type = {&KB-SOURCETYPE-INVENTORY} and
                knbs_ref1 >= ssite and
                knbs_ref1 <= ssite1)
                    or
               (knbs_source_type <> {&KB-SOURCETYPE-INVENTORY})),
            *********************************/
            each knbl_det no-lock where
               knbl_knb_keyid = knb_keyid,
            each knbd_det no-lock where
               knbd_knbl_keyid = knbl_keyid
            by knbsm_site
            by knbi_part
            by knbi_step
            by knbd_id:
               create ttkb.
               assign ttkb_part   = xpdsd_part
                      ttkb_rq_qty = xpdsd_qty
                      ttkb_kbid   = knbd_id
                      ttkb_kb_qty    = knbd_kanban_quantity
                      ttkb_active = yes.

               for first lngd_det
                  where lngd_dataset = 'kanban'             and
                        lngd_field   = 'knbd_active_code'   and
                        lngd_key2    <> ""                  and
                        lngd_key3    =  ""                  and
                        lngd_key4    =  ""                  and
                        lngd_lang    = global_user_lang
                  no-lock:
               end. /* FOR FIRST LNGD_DET */
               if avail lngd_det then 
                  ttkb_acd = lngd_key2.
               else 
                  ttkb_acd = knbd_active_code.
            end.
         end.
         
         v_nokb = no.
         for each xpdsd_det no-lock where xpdsd_nbr = xpd_nbr and 
            not can-find(first ttkb where ttkb_part = xpdsd_part)
            with frame f-nokb down width 80 three-d:
            disp xpdsd_part xpdsd_qty "无对应看板卡".
            v_nokb = yes.
         end.
         
         if v_nokb then do:
            message "某些零件无对应看板卡" skip
                    "是否继续?"
            view-as alert-box question buttons yes-no
            update v_yn.
            if not v_yn then undo mainloop, retry mainloop.
         end.
         
         hide frame f-nokb no-pause.
         
         v_tip = "[回车]-更改 [方向键]-上/下 [Esc]-退出 ".
   
         listblock:
         do on error undo,leave on endkey undo,leave:
            message v_tip.
            
            {xgut001.i
             &file = "ttkb"
             &where = "where true"
             &frame = "f-kb"
             &fieldlist = "ttkb_part
                           ttkb_rq_qty
                           ttkb_kbid
                           ttkb_kb_qty
                           ttkb_acd
                           ttkb_active
                          "
             &prompt     = "ttkb_part"
             &midchoose  = "color mesages"
             &predisplay = "~hide message no-pause. message v_tip.~ "
             &updkey     = "ENTER,RETURN"
             &updcode    = "~{xgfgmta.i~}"
            }
            
            message "确认操作" view-as alert-box question buttons yes-no-cancel
            update yn as logical.
   
            if yn = ? then do:
               hide frame f-kb no-pause.
               undo mainloop, next mainloop .
            end.
            
            if not yn then undo listblock, retry listblock .
         end. /* detBlock */    
         
         for each xpdkb_det where xpdkb_nbr = xpd_nbr :
            delete xpdkb_det.
         end.
   
         for each ttkb where ttkb_active break by ttkb_part:
            if first-of(ttkb_part) then do:
               find first xpdsd_det where xpdsd_nbr = xpd_nbr and xpdsd_part = ttkb_part
               exclusive-lock no-error.
            end.
   
            v_msg = "".
            find first knbd_det where knbd_id = ttkb_kbid and not knbd_active
            no-lock no-error.
            if avail knbd_det then do:
               /****
               {gprun.i ""xgkbcdmt01.p"" "(input ttkb_kbid,output v_msg)"}
               ****/
               /* 此处与xkacmgr.p相关，见*H01* */
               v_rowid = rowid(knbd_det).
               find knbd_det where rowid(knbd_det) = v_rowid exclusive-lock no-error.
               assign knbd_active_code = {&KB-CARD-ACTIVE-CODE-PERIOD}
                      knbd_active_start_date = v_actdt
                      knbd_pou_ref = string(v_acttm).
            end.
            
            if v_msg = "" then do:
               if avail xpdsd_det then do:
                  xpdsd_work_buf = xpdsd_work_buf + ttkb_kb_qty.
               end.
               
               create xpdkb_det.
               assign xpdkb_id   = ttkb_kbid
                      xpdkb_nbr  = xpd_nbr
                      xpdkb_part = ttkb_part
                      xpdkb_stat = "active".
   
               ttkb_msg = "选中".
            end.
            else do:
               ttkb_active = no.
               ttkb_msg = v_msg.
            end.
         end.
         
         for each ttkb with frame b :
            disp ttkb_part ttkb_kbid ttkb_active ttkb_msg.
            down.
         end.
      end. /* if not xpd__log01 */
      else do:
         xpd_type = "J".
         
         v_kro = yes.
         if not v_new then do:
            message "是否生成新要货单?" 
            view-as alert-box question button yes-no
            update v_kro.
         end.
         
         if v_new or v_kro then do:
            v_yn = false .
            do while not v_yn:
               find first code_mstr where code_fldname = "ronbr" no-error .
               if not available code_mstr then do:
                  create code_mstr .
                  assign code_fldname = "ronbr"
                         code_value = "t"
                         code_cmmt = "1" .
               end.
               v_krnbr = trim(code_value) + string(integer(code_cmmt),"9999999") .
      
               find first xkro_mstr no-lock
               where xkro_nbr = v_krnbr 
               no-error .
      
               if not available(xkro_mstr) then 
                  assign v_yn = true .
               code_cmmt = string(integer(code_cmmt) + 1) .
            end .
      
            create xkro_mstr.
            ASSIGN xkro_nbr = v_krnbr
                   xkro_ord_date = v_actdt
                   xkro_ord_time = v_acttm
                   xkro_user = global_userid
                   xkro_site = xpd_site
                   xkro_loc = xpd_user1
                   xkro_dsite = xpd_site
                   xkro_dloc = xpd_loc
                   xkro_print = yes 
                   xkro_type = xpd_type
                   xkro_due_date = xpd_ord_date
                   xkro_due_time = xpd_ord_time
                   xkro__chr01 = xpd_user1
                   xkro__chr02 = xpd_lnr.
            
            v_line = 1.
            for each pkkdet where pkkqty <> 0:
               find first pt_mstr where pt_part = pkkpart and pt_iss_pol = yes no-lock no-error.
               if not available pt_mstr then next .
               create xkrod_det.
               assign xkrod_nbr = xkro_nbr 
                      xkrod_line = v_line
                      xkrod_part = pkkpart
                      xkrod_qty_ord = pkkqty * xpd_qty_ord
                      xkrod_type = xpd_type.
               v_line = v_line + 1.
            end.
            
            if v_new then do:
               message "生成要货单单号:" + v_krnbr
               view-as alert-box information.
            end.
            else do:
               message "新要货单号:" + v_krnbr skip
                       "旧要货单号:" + xpd_user2 skip
               view-as alert-box information.
            end.
            
            xpd_user2 = v_krnbr.
            
         end. /* if v_new or v_kro */
      end.
   end. /* seta */
   message "是否打印生产单?"
   view-as alert-box question button yes-no
   update yn.
   if yn then do :
      
      {mfselprt.i "printer" 132}
      find first xpd_mstr where xpd_nbr = v_nbr no-lock no-error.
      if avail xpd_mstr then do:
         find first pt_mstr where pt_part = xpd_part no-lock no-error.
         put skip(2).
         put "生产单号:" at  1 xpd_nbr.
         put "生 产 线:" at 30 xpd_lnr.
         put "客    户:" at 66 xpd_cust skip.
         put "零 件 号:" at  1 xpd_part.
         put "零件描述:" at 30 pt_desc1 .
         put "需求数量:" at 66 xpd_qty_ord skip.
         put "开始日期:" at  1 xpd_ord_date.
         put "开始时间:" at 30 string(xpd_ord_time,"HH:MM").
         put "地    点:" at  1 xpd_site.
         put "发运库位:" at 30 xpd_loc_des.
         put "原料库位:" at 66 xpd_user1 skip(1).
         
         if xpd_type = "" then do:
            for each xpdsd_det where xpdsd_nbr = xpd_nbr no-lock:
               v_kbid = "".
               for each xpdkb_det where xpdkb_nbr = xpdsd_nbr 
                  and xpdkb_part = xpdsd_part no-lock:
                  v_kbid = v_kbid + (if v_kbid = "" then "" else ",") + string(xpdkb_id).
               end.
               find first pt_mstr where pt_part = xpdsd_part no-lock no-error.
               disp xpdsd_part pt_desc1 xpdsd_qty v_kbid
               with stream-io width 132.
            end.
         end.
         
      end.
      
      {mfreset.i}
   end.
end.
