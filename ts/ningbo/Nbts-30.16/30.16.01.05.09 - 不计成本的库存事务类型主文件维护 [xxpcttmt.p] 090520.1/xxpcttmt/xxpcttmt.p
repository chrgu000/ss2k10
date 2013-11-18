/* SS - 090520.1 By: Bill Jiang */

/* SS - 090520.1 - RNB
[090520.1]

不计成本的库存事务类型维护

空表示所有,适用于以下字段:
  - 地点 [xxpctt_site]
  - 产品线 [xxpctt_prod_line]
  - 类型 [xxpctt_type]

非空优先

字段之间的优先级如下:
  - 地点 [xxpctt_site]
  - 产品线 [xxpctt_prod_line]
  - 类型 [xxpctt_type]

关键字段说明:
  - 是否计算成本 [xxpctt_cost]:0(计算),1(不计)
  
[090520.1]

SS - 090520.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "090520.1"}

define variable del-yn        like mfc_logical initial no.

/* Variable added to perform delete during CIM. Record is deleted
 * Only when the value of this variable is set to "X" */
define variable batchdelete as   character format "x(1)" no-undo.
define variable l_yn        like mfc_logical             no-undo.

DEFINE variable addr_global LIKE GLOBAL_addr.

/* DISPLAY SELECTION FORM */
form
   xxpctt_site        colon 20   si_desc at 40 no-label
   xxpctt_prod_line   colon 20   pl_desc at 40 no-label
   xxpctt_type        colon 20   code_cmmt at 40 no-label
   xxpctt_start       colon 20   batchdelete at 40 no-label
   xxpctt_expire      colon 20
   xxpctt_cost    colon 20 FORMAT "9"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

main-loop:
repeat with frame a:

   /* Initialize batchdelete variable */
   batchdelete = "".

   prompt-for
      xxpctt_site
      xxpctt_prod_line
      xxpctt_type
      xxpctt_start
      /* Prompt for batchdelete variable only during CIM */
      batchdelete no-label when (batchrun)
      editing:

      if frame-field = 'xxpctt_site' then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i xxpctt_mstr xxpctt_site " xxpctt_domain = global_domain and xxpctt_site" xxpctt_prod_line xxpctt_prod_line xxpctt_spts}
         run disp_proc.
      end.
      else if frame-field = "xxpctt_prod_line" then do:
         {mfnp05.i xxpctt_mstr xxpctt_spts "xxpctt_domain = global_domain and xxpctt_site = input xxpctt_site" xxpctt_prod_line "input xxpctt_prod_line"}
         run disp_proc.
      end.  /* if frame-field = xxpctt_prod_line */
      else if frame-field = "xxpctt_type" then do:
         addr_global = GLOBAL_addr.
         GLOBAL_addr = "tr_type".

         {mfnp05.i xxpctt_mstr xxpctt_spts "xxpctt_domain = global_domain and xxpctt_site = input xxpctt_site and xxpctt_prod_line = input xxpctt_prod_line" xxpctt_type "input xxpctt_type"}
         run disp_proc.

         GLOBAL_addr = addr_global.
      end. /* if frame-field = "xxpctt_type"  */
      else if frame-field = "xxpctt_start" then do:
         {mfnp05.i xxpctt_mstr xxpctt_spts "xxpctt_domain = global_domain and xxpctt_site = input xxpctt_site and xxpctt_prod_line = input xxpctt_prod_line and xxpctt_type = input xxpctt_type" xxpctt_start "input xxpctt_start"}
         run disp_proc.
      end.
      else do:
         readkey.
         apply lastkey.
      end.
   end. /* editing: */

   if input xxpctt_site <> "" and (NOT can-find(si_mstr WHERE si_domain = global_domain AND si_site = input xxpctt_site)) then do:
      /* Site does not exist */
      {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
      next-prompt xxpctt_site.
      undo.
   end.

   if input xxpctt_prod_line <> "" and (NOT can-find(pl_mstr WHERE pl_domain = global_domain AND pl_prod_line = input xxpctt_prod_line)) then do:
      /* Product line does not exist */
      {pxmsg.i &MSGNUM=59 &ERRORLEVEL=3}
      next-prompt xxpctt_prod_line.
      undo.
   end.

   if input xxpctt_type <> "" and (NOT can-find(code_mstr WHERE code_domain = global_domain AND code_fldname = "tr_type" AND CODE_value = input xxpctt_type)) then do:
      /* Invalid type code */
      {pxmsg.i &MSGNUM=4211 &ERRORLEVEL=3}
      next-prompt xxpctt_type.
      undo.
   end.

   /* ADD/MOD/DELETE  */
   find first xxpctt_mstr 
      using xxpctt_site 
      and xxpctt_prod_line 
      and xxpctt_type
      and xxpctt_start
      where xxpctt_domain = global_domain 
      no-error.
   if not available xxpctt_mstr then do:
      if input xxpctt_prod_line = "" 
         and input xxpctt_type      = "" 
         and not batchrun 
         then do:

         /* Do you want to continue? */
         {pxmsg.i &MSGNUM=6398 &ERRORLEVEL=2 &CONFIRM=l_yn}

         if not l_yn then do:
            next-prompt xxpctt_prod_line.
            undo, retry.
         end. /* IF NOT l_yn */
      end. /* IF  INPUT xxpctt_prod_line = "" ... */

      /* ADDING NEW RECORD */
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create xxpctt_mstr.
      assign
         xxpctt_domain = global_domain
         xxpctt_site
         xxpctt_prod_line
         xxpctt_type
         xxpctt_start
         .

      /*
      if not can-find(pl_mstr where pl_domain = global_domain and pl_prod_line = xxpctt_prod_line) and xxpctt_prod_line <> "" then do:
         /* Product Line does not exist */
         {pxmsg.i &MSGNUM=59 &ERRORLEVEL=2}
      end.
      */
   end. /* if not available xxpctt_mstr then do: */

   /* STORE MODIFY DATE AND USERID */
   xxpctt_last_date = today.
   xxpctt_last_time = TIME.
   xxpctt_last_userid = global_userid.
   xxpctt_last_program = execname.

   /*
   if (xxpctt_curr <> input xxpctt_curr) and
      (xxpctt_curr <> "" and input xxpctt_curr <> "" )
   then do:
      /* Currency cannot be changed */
      {pxmsg.i &MSGNUM=84 &ERRORLEVEL=3}
      undo, retry.
   end. /* then do: */
   */

   recno = recid(xxpctt_mstr).

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   do on error undo, retry with frame a no-validate:
      update
         xxpctt_expire
         xxpctt_cost
      go-on ("F5" "CTRL-D").

      if xxpctt_expire <> ? and xxpctt_start <> ? and xxpctt_expire < xxpctt_start then do:
         /* Expiration date precedes start date */
         {pxmsg.i &MSGNUM=6221 &ERRORLEVEL=2}
      end. /* and xxpctt_expire < xxpctt_start then do: */

      /* DELETE */
      if lastkey = keycode("F5") 
         or lastkey = keycode("CTRL-D")
         /* Delete record if batchdelete is set to "x" */
         or input batchdelete = "x"
         then do:
         del-yn = yes.
         /* Please confirm delete */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn = no then undo, retry.
      end. /* then do: */

      /* MANUALLY VALIDATE PRICE LIST TYPE*/
      if index("01", STRING(xxpctt_cost)) = 0 then do:
         /* Invalid entry */
         {pxmsg.i &MSGNUM=4509 &ERRORLEVEL=3}
         next-prompt xxpctt_cost with frame a.
         undo, retry.
      end.
   end. /* do on error undo, retry with frame a no-validate: */

   if del-yn then do:
      delete xxpctt_mstr.

      clear frame a.

      del-yn = no.
      next main-loop.
   end. /* if del-yn then do: */
end. /* repeat with frame a: */

procedure disp_proc:
   if recno <> ? then do:
      find si_mstr 
         where si_mstr.si_domain = global_domain
         and si_mstr.si_site = xxpctt_mstr.xxpctt_site
         no-lock no-error.
      IF AVAILABLE si_mstr THEN DO:
         display si_desc with frame a.
      END.
      ELSE DO:
         display "" @ si_desc with frame a.
      END.

      find pl_mstr 
         where pl_mstr.pl_domain = global_domain
         and pl_mstr.pl_prod_line = xxpctt_mstr.xxpctt_prod_line
         no-lock no-error.
      IF AVAILABLE pl_mstr THEN DO:
         display pl_desc with frame a.
      END.
      ELSE DO:
         display "" @ pl_desc with frame a.
      END.

      find code_mstr 
         where code_mstr.code_domain = global_domain
         and code_mstr.code_fldname = "tr_type"
         and code_mstr.code_value = xxpctt_mstr.xxpctt_type
         no-lock no-error.
      IF AVAILABLE code_mstr THEN DO:
         display code_cmmt with frame a.
      END.
      ELSE DO:
         display "" @ code_cmmt with frame a.
      END.

      display
         xxpctt_site
         xxpctt_prod_line
         xxpctt_type
         xxpctt_start
         xxpctt_expire
         xxpctt_cost
      with frame a.
   end.  /* if recno <> ? */
end.

status input.
