/* a6gllim2.p - 明细项目维护                                      */
/* BY: Micho Yang          DATE: 04/23/08  ECO: *SS - 20080423.1* */

/* DISPLAY TITLE */
{mfdtitle.i "b+ "}

define variable del-yn like mfc_logical initial no no-undo.                                                     

define variable l_acc_beg like cr_code_beg no-undo.
define variable l_acc_end like cr_code_end no-undo.
define variable l_acc_all as character format "x(6)" no-undo.
define variable l_count as integer no-undo.
define variable l_error as logical no-undo.
define variable l_exist as logical no-undo.

define variable batchdelete as character format "x(1)" no-undo.

/* DISPLAY SELECTION FORM */
form
    usrw_key2       COLON 35    LABEL "明细项"
    usrw_charfld[1] COLON 35    LABEL "说明" FORMAT "x(24)"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

mainloop:
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   recno = ?.

   /* Prompt for the delete variable in the key frame at the
   * End of the key field/s only when batchrun is set to yes */

   prompt-for usrw_key2
      editing:

      /* FIND NEXT/PREVIOUS RECORD */
      {a6mfnp01.i usrw_wkfl usrw_key2 usrw_key2 usrw_key2 usrw_key2 usrw_index1}

      if recno <> ? then display usrw_key2 usrw_charfld[1] .
   end. /* editing: */

   /* ADD/MOD/DELETE  */
   find usrw_wkfl where usrw_key1 = "glsum" 
       AND usrw_key2 = INPUT usrw_key2 
       AND usrw_key4 = "D" EXCLUSIVE-LOCK no-error.
   if not AVAILABLE usrw_wkfl then do:
      MESSAGE "错误: 此明细项目不存在,请先到类别维护菜单新增" .
      NEXT-PROMPT usrw_key2 WITH FRAME a .
      UNDO,RETRY .
   end. /* if not available sb_mstr then do: */

   /* PROCESS VALID ACCOUNT RANGES */
   /* Changed &glsbmt_p_1 to getFrameTitle */
   {glcrmmt.i
      &code=usrw_key2
      &type=""GLSUM_ACCT""
      &rangelength=8
      &overlap-msg=3142
      &frame=acc
      &column=1
      &width=40
      &title=getFrameTitle(""ACCOUNT_RANGES"",35)
      &count=8}

   /* HIDE DETAIL LINES BEFORE RETURNING TO HEADER FRAME */
   hide frame acc-update.
   hide frame acc-display.

end. /* mainloop */

status input.

/* DELETE CODE RANGE MANAGEMENT */
{gpdelp.i "glcrmpl" "p"}
