/* xkkbtr01.p        看板计划外出库消耗         */

{mfdtitle.i "ao"}
{pxmaint.i}
{kbconst.i}

define variable v_cim_is      as    char.
define variable v_err_is      as    char.
define variable v_kbid        like  knbd_id.
define variable v_effdate     like  tr_effdate.
define variable v_kb_ok       as    logical.
define variable v_errors      as    integer.
define variable v_rid         as    rowid.

/*est*/ DEFINE VARIABLE sucess AS LOGICAL INITIAL FALSE.

{xgcmdef.i "new"}

{xglogdef.i "new"}

FORM 
        
    SKIP(.1)  
    v_effdate        colon 30
    v_kbid           colon 30
    SKIP(.4)  
WITH FRAME a SIDE-LABELS WIDTH 80 ATTR-SPACE THREE-D .
setFrameLabels(frame a:handle).

v_cim_is = mfguser + "un.dat".
v_err_is = mfguser + "un.err".

repeat:
   
   v_effdate = today.
   
   update v_effdate v_kbid  with frame a.
   
   if v_effdate = ? then 
   do:
      message "请输入生效日期" 
      view-as alert-box error buttons ok.
      undo, retry.
   end.

   find knbd_det where knbd_id = v_kbid no-lock no-error.
   if not available knbd_det then
   do :
      {pxmsg.i &MSGNUM=5046
               &ERRORLEVEL={&APP-ERROR-RESULT}}
      /*  KANBAN ID DOES NOT EXIST */
      undo, retry.
   end.


   
   if knbd_status <> {&KB-CARDSTATE-FULL} then do:
      message "看板卡状态必须为满"
      view-as alert-box error.
      undo, retry.
   end.
   
   v_rid = rowid(knbd_det).
   
   updblock:
   do transaction on error undo, leave:
      find knbd_det where rowid(knbd_det) = v_rid exclusive-lock no-error.
      knbd_status = {&KB-CARDSTATE-EMPTYAUTH} .
      knbd_print_dispatch = YES.   
      for first knbl_det
      where knbl_keyid  = knbd_knbl_keyid
      no-lock:  end.

      /* RETRIEVE KANBAN MASTER RECORD */
      for first knb_mstr
      where knb_keyId  = knbl_knb_keyId
      no-lock: end.

      /* RETRIEVE KANBAN Item SuperMarket MASTER RECORD */
      for first knbsm_mstr
      where knbsm_keyId       = knb_knbsm_keyId
      no-lock: end.
      
      for first knbi_mstr
      where knbi_keyId       = knb_knbi_keyId
      no-lock: end.

/*est*/ {gprun.i ""kbiss.p"" "(input knbi_part , 
                                            input  knbd_kanban_quantity,
                                            OUTPUT sucess)"}  
/*est*/ IF sucess EQ FALSE THEN DO:
/*est*/     MESSAGE "条码当前量不等于该看板量,退出操作" VIEW-AS ALERT-BOX.
/*est*/     UNDO updblock, LEAVE updblock.
/*est*/ END.

      output to value(v_cim_is) .
      put unformatted "@@batchload icunis.p" skip .
      export knbi_part .
      put unformatted  knbd_kanban_quantity " - - " knbsm_site " " knbsm_inv_loc skip.
      put unformatted  knbd_id " - - - - " v_effdate skip.
      put    skip(1).
      put    "." skip.
      put    "@@end" skip .
      output close .
   
      {gprun.i ""xgcm001.p"" "(input v_cim_is, output v_errors) " }
      
      if v_errors > 0 then do :
         message "收货不成功:icunis.p" skip
                 v_cim_is skip
                 view-as alert-box error  .
         undo updblock, leave updblock.
      end.
      else do :
         os-delete value(v_cim_is) .


      end.

   end. /* do transaction */
   
   {xgxlogdet.i}
   
end.


