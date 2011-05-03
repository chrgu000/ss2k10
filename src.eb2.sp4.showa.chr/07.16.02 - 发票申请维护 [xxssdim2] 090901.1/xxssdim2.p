/* 以下为版本历史 */                                                             
/* SS - 090819.1 By: Bill Jiang */
/* ss - 090901.1  by: jack */

/*以下为发版说明 */
/* SS - 090819.1 - RNB
【090819.1】

暂估发票申请维护

仅限于未打印且未确认的申请

【090819.1】

SS - 090819.1 - RNE */
/*
{mfdtitle.i "090819.1"}
*/
{mfdtitle.i "090901.1"}

/* 共享 */
{xxssdim2s.i "new"}

/* frame a */
define new shared variable nbr_rqm like rqm_mstr.rqm_nbr.
define new shared variable site_rqm  like rqm_mstr.rqm_site.
define new shared variable vend_rqm  like rqm_mstr.rqm_vend.
define new shared variable rqby_userid_rqm like rqm_mstr.rqm_rqby_userid.
define new shared variable req_date_rqm like rqm_mstr.rqm_req_date.
define new shared variable log01__rqm like rqm_mstr.rqm__log01.
DEFINE VAR auto_select LIKE mfc_logical INIT YES .
DEFINE VAR sel_total      AS DECIMAL FORMAT "->>,>>>,>>9.99".

/* frame sel_auto */
DEFINE VAR ship_date_from AS DATE .
DEFINE VAR ship_date_to   AS DATE .
DEFINE VAR shipper_from   AS CHAR  FORMAT "x(11)".
DEFINE VAR shipper_to     AS CHAR FORMAT "x(11)".
DEFINE VARIABLE po LIKE so_po.
DEFINE VARIABLE po1 LIKE so_po.
DEFINE VAR sel_all LIKE mfc_logical INIT YES.

define variable del-yn like mfc_logical initial no.

define variable first_sw_call as logical initial true.
define variable apwork-recno  as recid.

form
   nbr_rqm	              colon 15
   site_rqm COLON 40
   vend_rqm  	          colon 65
   rqby_userid_rqm       colon 15 
   req_date_rqm          colon 40
   log01__rqm            colon 15 
   auto_select            COLON 40 
   sel_total COLON 65
   with frame a attr-space side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM
   ship_date_from COLON 19
   ship_date_to   COLON 50
   shipper_from   COLON 19
   shipper_to     COLON 50
   po COLON 19
   po1 COLON 19
   SKIP(1)
   sel_all        COLON 19
   WITH FRAME sel_auto TITLE COLOR normal (getFrameTitle("AUTOMATIC_SELECTION",39)) SIDE-LABELS WIDTH 80.
 
/* SET EXTERNAL LABELS */
setFrameLabels(frame sel_auto:handle).

FORM
   tt1_status LABEL "Sel"
   tt1_index
   tt1_tr_part
   tt1_tr_effdate
   tt1_qty_open
   WITH FRAME sel_shipper WIDTH 80 TITLE COLOR normal (getFrameTitle("MANUALLY_SELECT_LINES",42)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame sel_shipper:handle).

form
   tt1_pt_desc1 /* COLON 18 */
   tt1_pt_desc2 NO-LABEL 
   tt1_idh_price
   tt1_ih_inv_nbr /* COLON 18 */
   tt1_ih_nbr
   tt1_idh_line
   with frame sel_item side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame sel_item:handle).

nbr_rqm	       = "".
site_rqm = "".
vend_rqm         = "".       
rqby_userid_rqm     = "".  
req_date_rqm   = today.
log01__rqm  = no.

mainloop:
repeat on error undo, retry:
   
   HIDE FRAME w.
   HIDE FRAME match_maintenance.
   view frame a.

   update 
      nbr_rqm 
      with frame a editing:
      {mfnp.i rqm_mstr nbr_rqm rqm_nbr nbr_rqm rqm_nbr rqm_nbr}
      if recno <> ? then do:
         {xxssdim2d1.i}
      end. /* if recno<>? */
   end.  /*with frame a eiting:*/
            
   /* 前缀 */
   FIND FIRST mfc_ctrl WHERE mfc_field = "SoftspeedDI_rqm_nbr" NO-LOCK NO-ERROR.
   IF NOT AVAILABLE mfc_ctr THEN DO:
      /* Control table error.  Check applicable control tables */
      {pxmsg.i &MSGNUM=594 &ERRORLEVEL=3}
      undo, retry.
   END.
   IF INPUT nbr_rqm <> "" THEN DO:
      IF NOT (INPUT nbr_rqm BEGINS mfc_char) THEN DO:
         /* Prefix not defined in control table */
         {pxmsg.i &MSGNUM=5640 &ERRORLEVEL=3}
         undo, retry.
      END.
   END.

   /* 不允许编辑已经过账的行 */
   find first rqm_mstr where rqm_nbr = INPUT nbr_rqm no-error.
   if available rqm_mstr then do:
      /* 全部已确认 */
      if rqm_open = YES 
         /* 已打印 */
         OR rqm_status <> "" then do:
         /* Cannot modify. Amount has been posted */
         {pxmsg.i &MSGNUM=6658 &ERRORLEVEL=3}
         undo, retry.
      end.
      else do:
         /*
         FIND FIRST rqd_det
            WHERE rqd_det.rqd_nbr = INPUT nbr_rqm
            AND rqd_det.rqd_open = YES
            NO-LOCK NO-ERROR.
         /* 部分已确认 */
         IF AVAILABLE rqd_det THEN DO:
            /* Cannot modify. Amount has been posted */
            {pxmsg.i &MSGNUM=6658 &ERRORLEVEL=3}
            undo, retry.
         END.
         ELSE DO:
            {xxssdim2d1.i}
         END.
         */
         {xxssdim2d1.i}
      end. /*else do*/
   end. /*if available rqm_mst*/
            
   /* 创建新行 */
   if not available rqm_mstr then do:	       
      if INPUT nbr_rqm = "" then do :
         FIND FIRST mfc_ctrl 
            WHERE mfc_field = "SoftspeedDI_rqm_nbr" 
            EXCLUSIVE-LOCK NO-ERROR.
         nbr_rqm = STRING(INTEGER("1" + fill("0",8)) + mfc_integer).
         nbr_rqm = mfc_char + SUBSTRING(nbr_rqm, 2 + LENGTH(mfc_char)).
         DO WHILE CAN-FIND(
            FIRST rqm_mstr
            WHERE rqm_mstr.rqm_nbr = nbr_rqm
            ):
            mfc_integer = mfc_integer + 1.
            nbr_rqm = STRING(INTEGER("1" + fill("0",8)) + mfc_integer).
            nbr_rqm = mfc_char + SUBSTRING(nbr_rqm, 2 + LENGTH(mfc_char)).
         END.
         mfc_integer = mfc_integer + 1.
      end.

      create rqm_mstr.
      assign
         rqm_nbr = nbr_rqm
         rqm_rqby_userid = GLOBAL_userid
         rqm_req_date = TODAY
         .
                        
      if recid(rqm_mstr) = ? THEN DO:
         release rqm_mstr.
      END.
   end. /*if not available rqm_mstr*/

   {xxssdim2d1.i}

   ststatus = stline[3].
   status input ststatus.

   vend_rqmloop:
   repeat on endkey undo mainloop, retry:
      /* 地点和客户 - B */
      update 
         site_rqm
         vend_rqm 
         with frame a editing:
         readkey.
         apply lastkey.
		end.

      FIND FIRST si_mstr WHERE si_site = site_rqm NO-LOCK NO-ERROR.
      if not available si_mstr
      then do:
         {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
         next-prompt site_rqm with frame a.
         undo, retry.
      end.

      find first cm_mstr where cm_addr = vend_rqm no-lock no-error.
      if not available cm_mstr then do:
         {pxmsg.i &MSGNUM=3 &ERRORLEVEL=3}
         next-prompt vend_rqm with frame a.
         undo,retry.
      end.

      FIND first rqm_mstr where rqm_nbr = nbr_rqm AND rqm_site <> "" AND rqm_vend <> "" no-lock NO-ERROR.
		IF available rqm_mstr and (rqm_site <> site_rqm OR rqm_vend <> vend_rqm) THEN DO:
         /* Update not allowed */
         {pxmsg.i &MSGNUM=171 &ERRORLEVEL=3}
			next-prompt site_rqm with frame a.
			undo,retry.
		END.
      /* 地点和客户 - E */

      /* 删除或编辑 - B */
      ststatus = stline[2].
      status input ststatus.

      update 
         rqby_userid_rqm 
         req_date_rqm 
         log01__rqm
         go-on(F5 CTRL-D) with frame a editing:
         readkey.
         apply lastkey.
      end.

      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
         del-yn = no.
         {mfmsg01.i 11 1 del-yn}
         if del-yn then do:
            /* 只要是未过账的申请,就允许删除 */
            {gprun.i ""xxssdim2dm.p"" "(
               INPUT nbr_rqm
               )"}

            clear frame a.
            ASSIGN
               nbr_rqm	       = ""
               site_rqm = ""
               vend_rqm         = ""
               rqby_userid_rqm     = ""
               req_date_rqm   = TODAY
               log01__rqm  = no
               .
            display 
               nbr_rqm	     
               site_rqm
               vend_rqm        
               rqby_userid_rqm    
               req_date_rqm  
               log01__rqm 
               auto_select
               with frame a.
         end.
         if del-yn then next mainloop.
      end. /*f5*/
      else do: /*f5*/
         find first rqm_mstr where rqm_nbr = nbr_rqm exclusive-lock NO-ERROR.
         if available rqm_mstr then do:
            assign
               rqm_nbr          = nbr_rqm
               rqm_site = site_rqm
               rqm_vend         = vend_rqm
               rqm_rqby_userid     = rqby_userid_rqm
               rqm_req_date     = req_date_rqm
               rqm__log01      = log01__rqm
               .
         end.
         release rqm_mstr.
      end. /*f5*/
      /* 删除或编辑 - E */

      /* 是否自动选择 - B */
      ststatus = stline[3].
      status input ststatus.
      /* 是否自动选择 - E */

      leave.
   end. /*repeat*/


   loopf1:
   do on error undo, leave:
       
      /* 执行自动选择 - E */
      IF auto_select = YES THEN DO:
         ship_date_from = ?.
         ship_date_to   = ?.
         shipper_from   = "".
         shipper_to     = "".
         po = "".
         po1 = "".
   
         sel_all = YES.
   
         auto-select-block:
         repeat on endkey undo mainloop, retry:
            SET 
               ship_date_from 
               ship_date_to 
               shipper_from 
               shipper_to 
               po
               po1
               WITH FRAME sel_auto .
   
            DISPLAY
               sel_all
               WITH FRAME sel_auto.

            SET
               sel_all
               WITH FRAME sel_auto. 
   
            LEAVE auto-select-block .
         END.
           
         IF ship_date_from = ?  THEN ship_date_from = low_date.
         IF ship_date_to   = ?  THEN ship_date_to   = hi_date .
         IF shipper_to     = "" THEN shipper_to     = hi_char .
         IF po1 = "" THEN po1 = hi_char.

         HIDE FRAME sel_auto NO-PAUSE .

         /* 创建临时表 - 更新 */
         {gprun.i ""xxssdim2m.p"" "(
            INPUT nbr_rqm
            )"}
         FOR EACH tt1:
            ASSIGN
               tt1_status = '*'
               .
         END.

         FIND FIRST tt1 NO-LOCK NO-ERROR.
         IF NOT AVAILABLE tt1 THEN DO:
            /* 创建临时表 - 增加 */
            {gprun.i ""xxssdim2a.p"" "(
               INPUT site_rqm,
               INPUT vend_rqm,
               INPUT ship_date_from,
               INPUT ship_date_to,
               INPUT shipper_from,
               INPUT shipper_to,
               INPUT po,
               INPUT po1
               )"}
            IF sel_all THEN DO:
               FOR EACH tt1:
                  ASSIGN
                     tt1_status = '*'
                     .
               END.
            END.
         END.

         sel_total = 0.
         FOR EACH tt1:
            IF tt1_status = "*" THEN DO:
               sel_total = sel_total + tt1_idh_qty_inv * tt1_idh_price.
            END.
         END.
         DISPLAY
            sel_total
            WITH FRAME a.
         
         sw_block:
         do on endkey undo, leave:
            FIND FIRST tt1 NO-LOCK NO-ERROR.
            IF NOT AVAILABLE tt1 THEN DO:
               /* Record not found */
               {pxmsg.i &MSGNUM=1310 &ERRORLEVEL=3}
               LEAVE loopf1.
            END.
   
            display 
               nbr_rqm	
               site_rqm
               vend_rqm        
               rqby_userid_rqm    
               req_date_rqm  
               log01__rqm 
               auto_select
               sel_total
               with frame a.
   
            VIEW FRAME sel_shipper.
            VIEW FRAME sel_item .
	   
              
            /* INCLUDE SCROLLING WINDOW TO ALLOW THE USER TO SCROLL      */
            /* THROUGH (AND SELECT FROM) EXISTING PAYMENTS APPLICATIONS  */
            {swselect.i
               &detfile      = tt1
               &scroll-field = tt1_index
               &framename    = "sel_shipper"
               &framesize    = 7
               &sel_on       = ""*""
               &sel_off      = """"
               &display1     = tt1_status
               &display2     = tt1_index
               &display3     = tt1_tr_part
               &display4     = tt1_tr_effdate
               &display5     = tt1_qty_open
               &exitlabel    = sw_block
               &exit-flag    = first_sw_call
               &record-id    = apwork-recno
               &include1     = "
                  /* ACCUMULATE OPEN AMOUNT INTO SELECTION TOTAL */
                  sel_total = sel_total - tt1_qty_open * tt1_idh_price.
                  /* DISPLAY SUMMARY & tt1_tr_part INFORMATION */
                  display sel_total with frame a.
                  "
               &include2     = "
                  /* ACCUMULATE OPEN AMOUNT INTO SELECTION TOTAL */
                  sel_total = sel_total + tt1_qty_open * tt1_idh_price.
                  /* DISPLAY SUMMARY & tt1_tr_part INFORMATION */
                  display sel_total with frame a.
                  "
               &include3     = "
                  /* DISPLAY SUMMARY & tt1_tr_part INFORMATION */
                  find FIRST pt_mstr where pt_part = tt1_tr_part no-lock no-error.
                  if available pt_mstr THEN DO:
                     display
                        pt_desc1 @ tt1_pt_desc1
                        pt_desc2 @ tt1_pt_desc2
                        tt1_idh_price
                        tt1_ih_inv_nbr
                        tt1_ih_nbr
                        tt1_idh_line
                        with frame sel_item.
                  END.
                  ELSE DO:
                     display
                        '' @ tt1_pt_desc1
                        '' @ tt1_pt_desc2
                        tt1_idh_price
                        tt1_ih_inv_nbr
                        tt1_ih_nbr
                        tt1_idh_line
                        with frame sel_item.
                  END.
                  "
               }
   
            HIDE FRAME sel_shipper.
            HIDE FRAME sel_item.

            LEAVE sw_block.
         END. /* do on endkey undo, leave: */

         /* 删除没有选择的记录 */
         FOR EACH tt1 NO-LOCK 
            WHERE tt1_status <> "*" 
            :
            {gprun.i ""xxssdim2dd.p"" "(
               INPUT nbr_rqm,
               INPUT STRING(tt1_SoftspeedDI_VAT),
               INPUT tt1_tr_trnbr
               )"}
            DELETE tt1.
         END.
   
         /* 同步已经选择的记录 */
         {gprun.i ""xxssdim2sdb.p"" "(
            INPUT nbr_rqm
            )"}

         if keyfunction(lastkey) = "end-error" or keyfunction(lastkey) = "." then do:
            LEAVE loopf1.
            HIDE FRAME sel_shipper.
            HIDE FRAME sel_item.
         end. /* IF keyfunction(lastkey) = "end-error" ... */
      END.  /*  IF auto_select = YES THEN DO: */
      /* 执行自动选择 - E */
           
      HIDE FRAME sel_shipper.
      HIDE FRAME sel_item.
      {gprun.i ""xxssdim2b.p""}
          
      ststatus = stline[2].
      status input ststatus.
   
      loopf2:
      REPEAT WITH FRAME match_maintenance:
         PROMPT-FOR
            INDEX_tt1
            editing:
            if frame-field = "index_tt1" then do:
               /* NEXT-PREV ON ATTACHED RECEIVERS ONLY */
               {mfnp.i tt1 index_tt1 tt1_index index_tt1 tt1_index tt1_index}
   
               if recno <> ? then do: 
                  /* 显示 */
                  {xxssdim2d.i}
               END.    
            END. /* if frame-field = "receiver" then do: */
            ELSE DO:
               STATUS INPUT.
               readkey.
               apply lastkey.
            END.
         END. /* with frame match_maintenance editing: */

         FIND FIRST tt1 WHERE tt1_index = INPUT index_tt1  EXCLUSIVE-LOCK NO-ERROR.
         IF NOT AVAILABLE tt1 THEN DO:
            /* Record not found */
            {pxmsg.i &MSGNUM=1310 &ERRORLEVEL=3}
            NEXT-PROMPT index_tt1.
            UNDO,RETRY.
         END.

         /* 显示 */
         {xxssdim2d.i}

         ststatus = stline[2].
         status input ststatus.

         sel_total = sel_total - tt1_idh_qty_inv * tt1_idh_price.

         SET 
            idh_qty_inv_tt1 
            go-on ("F5" "CTRL-D") WITH FRAME match_maintenance .

         IF ABSOLUTE(INPUT idh_qty_inv_tt1) > ABSOLUTE(tt1_qty_open) THEN DO:
            /* Quantity exceeds available remaining */
            {pxmsg.i &MSGNUM=125 &ERRORLEVEL=3}
            NEXT-PROMPT idh_qty_inv_tt1.
            UNDO,RETRY.
         END.

         ASSIGN
            tt1_idh_qty_inv = INPUT idh_qty_inv_tt1
            .

         sel_total = sel_total + tt1_idh_qty_inv * tt1_idh_price.
         DISP
            sel_total
            WITH FRAME a.
   
         if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
            del-yn = yes.
            {mfmsg01.i 11 1 del-yn}
            if not del-yn then undo loopf2.
         end. /* then do: */
           
         /* 删除 */
         if del-yn then do:
            {gprun.i ""xxssdim2dd.p"" "(
               INPUT nbr_rqm,
               INPUT STRING(tt1_SoftspeedDI_VAT),
               INPUT tt1_tr_trnbr
               )"}
            
            sel_total = sel_total - tt1_idh_qty_inv * tt1_idh_price.
            DISP 
               sel_total 
               WITH FRAME a.

            DELETE tt1.

            clear frame match_maintenance.
            del-yn = no.
            next loopf2.
         end. /* if del-yn then do: */
   
         /* 更新 */
         {gprun.i ""xxssdim2sds.p"" "(
            INPUT nbr_rqm,
            INPUT RECID(tt1)
            )"}
   
         if keyfunction(lastkey) = "end-error" or keyfunction(lastkey) = "." then do:
            leave loopf1.
            HIDE FRAME w.
            HIDE FRAME match_maintenance .
         end. /* IF keyfunction(lastkey) = "end-error" ... */
      END. /* loopf2: */
   END. /* loopf1 : do on error undo, leave: */
end. /*mainloop*/

STATUS input.
