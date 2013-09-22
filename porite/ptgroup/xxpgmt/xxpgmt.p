/* xxgpmt.p - ADD / MODIFY Item group MASTER RECORDS                         */
/*V8:ConvertMode=Maintenance                                                  */
/*-Revision end---------------------------------------------------------------*/

{mfdtitle.i "130903.1"}
&SCOPED-DEFINE xxgpmt_p_1 "Comments"
define variable v_number as character format "x(12)".
define variable errorst as logical.
define variable errornum as integer.
define variable xx as character initial "xxwa_det".
define variable pgdesc like xpg_desc.
define variable del-yn like mfc_logical.
define variable lines as integer.
define variable batchdelete as character format "x(1)" no-undo.

/**程序需在号码范围维护里设置序号ID：xxpggroup *********************************
nrsqmt.p                      36.2.21.1 号码范围维护                  13/09/05
+--------------------------------- 排序主记录 ---------------------------------+
|            序号 ID: xpggroup                                                 |
|               描述: 相似组序号自动产生                                       |
|         目标数据集:                                                          |
|               内部: Yes                                                      |
|           允许放弃: Yes                           生效日期: 13/09/05         |
|           允许作废: Yes                           到期日期:                  |
+------------------------------------------------------------------------------+
+----------------------------------- 区段表 -----------------------------------+
|  号 类型     设置                                         控制               |
| --- -------- -------------------------------------------- --------           |
|   1 FIXED    gp                                                              |
|   2 INT      000001,999999,000001,000001                                     |
+------------------------------------------------------------------------------+
*******************************************************************************/

/* DISPLAY SELECTION FORM */
form
   xpg_group colon 27  batchdelete
   xpg_desc  colon 27  label {&xxgpmt_p_1}
with frame a side-labels width 80 attr-space.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   prompt-for xpg_group
   /* Prompt for the delete variable in the key frame at the
    * End of the key field/s only when batchrun is set to yes */
   batchdelete no-label when (batchrun)
   editing:

      /* FIND NEXT/PREVIOUS RECORD - NON-SERVICE BOMS ONLY */
      {mfnp05.i xpg_mstr
         xpg_group
         " xpg_mstr.xpg_domain = global_domain  "
         xpg_group
         "input xpg_group"}

      if recno <> ? then do:
         display xpg_group xpg_desc with frame a .
      end.    /* if recno <> ? */
      hide frame b.
   end.    /* editing on xpg_group */

   hide frame b.

   if input xpg_group = "" then do:
     assign v_number = "".
     {gprun.i ""gpnrmgv.p"" "('xpggroup',input-output v_number, output errorst
                              ,output errornum)" }
      display v_number @ xpg_group.
   end.

   find xpg_mstr exclusive-lock using  xpg_group where xpg_mstr.xpg_domain =
          global_domain and xpg_group = input xpg_group no-error.
   if not available xpg_mstr then do:
      /* ADDING NEW RECORD */
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create xpg_mstr. xpg_mstr.xpg_domain = global_domain.
      assign xpg_group = caps(input xpg_group).
   end.    /* if not available xpg_mstr */

   display xpg_group xpg_desc.

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   do on error undo, retry:

      set xpg_desc go-on ("F5" "CTRL-D").

      assign
         xpg_mod_usr = global_userid
         xpg_mod_date = today.

      /* DELETE */
      if lastkey = keycode("F5")
         or lastkey = keycode("CTRL-D")
         /* Delete to be executed if batchdelete is set to "x" */
         or input batchdelete = "x":U
      then do:

         if can-find (first xpgt_det where xpgt_det.xpgt_domain = global_domain
           and (xpgt_group = xpg_group))
            or (can-find (first xpgt_det where xpgt_det.xpgt_domain =
                global_domain and ( xpgt_group = xpg_group))
            and not can-find(pt_mstr where pt_mstr.pt_domain = global_domain
            and pt_part = xpg_group))
         then do:
            /*Delete not allowed, product structure exists*/
            {pxmsg.i &MSGNUM=226 &ERRORLEVEL=3}
            undo mainloop, retry.
         end.

         del-yn = yes.
         /* PLEASE CONFIRM DELETE */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn = no then undo, retry.
         lines = 0.
         for each xpgt_det exclusive-lock where xpgt_det.xpgt_domain =
         global_domain and  xpgt_group = xpg_group
            with frame b width 80 no-attr-space down:
            pause 0.
            /* SET EXTERNAL LABELS */
            setFrameLabels(frame b:handle).
            display xpgt_part xpgt_start xpgt_end.
            delete xpgt_det.
            lines = lines + 1.
         end.
         pause before-hide.

         delete xpg_mstr.
         clear frame a.
         del-yn = no.
         if lines > 0 then do:
            /* LINE ITEM RECORD(S) DELETED */
            {pxmsg.i &MSGNUM=24 &ERRORLEVEL=1 &MSGARG1=lines}
         end.
         else do:
            /* RECORD DELETED */
            {pxmsg.i &MSGNUM=22 &ERRORLEVEL=1}
         end.
      end.    /* if lastkey ... */
   end.   /* do on error undo, retry */
end.    /* mainloop repeat */
status input.
