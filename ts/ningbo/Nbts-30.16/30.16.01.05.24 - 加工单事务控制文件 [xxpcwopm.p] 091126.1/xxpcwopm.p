/* SS - 091126.1 By: Bill Jiang */

/* SS - 091126.1 - RNB
[091126.1]

加工单期间增加数量计算方法[SoftspeedPC_xxpcwo_qty_ord]:
1. F - 第一个工序的完成数量之和
2. L - 最后一个工序的完成数量之和
3. 其他值均无效

[091126.1]

SS - 091126.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "091126.1"}

define variable SoftspeedPC_xxpcwo_qty_ord like mfc_char FORMAT "x(1)".

form
   SoftspeedPC_xxpcwo_qty_ord          colon 38
   with frame appm-a width 80 side-labels attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame appm-a:handle).

/* DISPLAY */
ststatus = stline[3].
status input ststatus.
view frame appm-a.

repeat with frame appm-a:

   /* ADD MFC_CTRL FIELD SoftspeedPC_xxpcwo_qty_ord */
   for first mfc_ctrl where mfc_domain = global_domain and mfc_field = "SoftspeedPC_xxpcwo_qty_ord"
   exclusive-lock: end.
   if not available mfc_ctrl then do:
      create mfc_ctrl.
      assign
         mfc_domain = GLOBAL_domain
         mfc_field   = "SoftspeedPC_xxpcwo_qty_ord"
         mfc_type    = "C"
         mfc_module  = mfc_field
         mfc_seq     = 10
         mfc_char = "F"
         .
   end.
   assign
      SoftspeedPC_xxpcwo_qty_ord = mfc_char.

   display
      SoftspeedPC_xxpcwo_qty_ord
   with frame appm-a.

   seta:
   do on error undo, retry:
      set
         SoftspeedPC_xxpcwo_qty_ord
      with frame appm-a.

      if INDEX("FL",SoftspeedPC_xxpcwo_qty_ord) = 0 then do:
         /* Invalid entry */
         {pxmsg.i &MSGNUM=4509 &ERRORLEVEL=3}
         next-prompt SoftspeedPC_xxpcwo_qty_ord.
         undo seta, retry.
      end.
   end.

   find first mfc_ctrl where mfc_domain = global_domain and mfc_field = "SoftspeedPC_xxpcwo_qty_ord" no-error.
   if available mfc_ctrl then mfc_char = SoftspeedPC_xxpcwo_qty_ord.
end.

status input.
