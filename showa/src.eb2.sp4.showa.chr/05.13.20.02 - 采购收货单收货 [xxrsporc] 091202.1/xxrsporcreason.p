/* SS - 091202.1 By: Lambert Xiang */

  {mfdeclre.i}
  {gplabel.i} /* EXTERNAL LABEL INCLUDE */
  
  define shared temp-table reasonfile no-undo
        field reason like code_value
        field reasondesc like code_cmmt.
  /* define var total_reason as int. */
  
  form
     reason       /*  column-label {&sfoptrd_p_3} */
     reasondesc
/*     total_reason    */ /*   label {&sfoptrd_p_5} no-attr-space */
  with frame c 8 down scroll 1 overlay row 6
  title color normal ("") centered attr-space .
  /* SET EXTERNAL LABELS */
  setFrameLabels(frame c:handle).

  form
     reason       /* column-label {&sfoptrd_p_3} */
     reasondesc
     /* total_reason    */ /*   label {&sfoptrd_p_5} no-attr-space */
  with frame c1 overlay  row 18 no-underline centered attr-space.
  /* SET EXTERNAL LABELS */
  setFrameLabels(frame c1:handle).
    	
  pause 0.
  reasonhist:
  repeat with frame c1 :
      clear frame c all no-pause.
      view frame c.
      view frame c1.
      /*
      total_reason = 0.
      for each reasonfile with frame c:
        total_reason = total_reason + 1.
      end.
      */
      for each reasonfile break by reason with frame c:
        display  reason reasondesc  .
        if not last (reason) then down 1.
      end.
      prompt-for reason editing :
          {mfnp01.i code_mstr reason code_value ""scmrcrmks"" code_fldname code_fldval}
          if recno <> ? then do:
            display code_value @ reason code_cmmt @ reasondesc  with frame c1.
          end.
      end.
      if input reason = "" then leave reasonhist.
      find first reasonfile where reason = input reason no-error.
      if not available reasonfile then do:
           find code_mstr where code_fldname = "scmrcrmks" and code_value = input reason no-lock no-error.
           if available code_mstr then display code_cmmt @ reasondesc.
           else do:
           	 display " " @ reasondesc.
             {mfmsg.i 655 3}
             next-prompt reason.
             undo, retry.
           end.
           create reasonfile.
           assign reason reasondesc.
      end.
      else do:
      	for each reasonfile where reason = input reason :
      		delete reasonfile.
      	end.
      end.
  end. /* reasonhist repeat  */
  hide frame c.
  pause 0.
  hide frame c1.
  pause 0.