/* mfselbpr.i - INCLUDE FILE TO SELECT PRINTER FOR OUTPUT WITH BATCH OPTION  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*F0PN*/ /*V8:ConvertMode=Report                                             */
/* REVISION: 4.0          LAST EDIT: 02/12/88       MODIFIED BY: WUG *A175**/
/* REVISION: 4.0          LAST EDIT: 01/11/89       MODIFIED BY: emb *A596**/
/* REVISION: 4.0          LAST EDIT: 03/10/89       MODIFIED BY: WUG *A667**/
/* REVISION: 5.0          LAST EDIT: 04/12/89       MODIFIED BY: WUG *B098**/
/* REVISION: 5.0          LAST EDIT: 04/13/89       MODIFIED BY: WUG *B080**/
/* REVISION: 5.0          LAST EDIT: 06/16/89       MODIFIED BY: RL  *B150**/
/* REVISION: 5.0          LAST EDIT: 06/29/89       MODIFIED BY: emb *B164**/
/* REVISION: 5.0          LAST EDIT: 08/24/89       MODIFIED BY: pml *B241**/
/* REVISION: 5.0          LAST EDIT: 09/12/89       MODIFIED BY: tjt *B270**/
/* REVISION: 5.0          LAST EDIT: 09/26/89       MODIFIED BY: MLB *B316**/
/* REVISION: 5.0          LAST EDIT: 12/13/89       MODIFIED BY: WUG *B445**/
/* REVISION: 5.0          LAST EDIT: 02/21/90       MODIFIED BY: MLB *B576**/
/* REVISION: 5.0          LAST EDIT: 05/22/90       MODIFIED BY: emb *B695**/
/* REVISION: 6.0          LAST EDIT: 05/30/90       MODIFIED BY: WUG *B%%%**/
/* REVISION: 7.0          LAST EDIT: 05/21/92       MODIFIED BY: rwl *F556**/
/* Revision: 7.3          Last edit: 09/16/92       Modified by: jcd *G058**/
/* Revision: 7.3          Last edit: 11/25/92       Modified by: jcd *G361**/
/* Revision: 7.3          Last edit: 03/23/95       Modified by: jzs *G0FB**/
/* Revision: 7.3          Last edit: 11/03/95       Modified by: str *G1C6**/
/* Revision: 7.3          Last edit: 12/15/95       Modified by: rwl *G1GW**/
/* Revision: 7.3          Last edit: 02/13/96       Modified by: rkc *G1MR**/
/* Revision: 8.5          Last edit: 10/01/97       Modified by: vrp *J225**/

/* SS - 090707.1 By: Roger Xiao */



/* Parameters:                                                               */
/*    {1} Name of file to output to, e.g. "terminal", "printer"              */
/*    {2} Width of page, e.g. 80 or 132                                      */
/*    {3} (optional) "nopage" for programs printing checks or labels         */
/*    {4} (optional) stream name (must also include in mfrtrail.i)       B164*/
/*    {5} (optional) "append" (if to a file)                             B%%%*/
/*    {6} (optional) "yes" to allow a streamed report terminal => nopage G0FB*/
/*        this fits fsescmgr's need, eliminates fsselbpr.i                   */
/*****************************************************************************/
/* NOTE: CHANGES MADE TO THIS PROGRAM MAY NEED TO BE MADE TO mfselprt.i ALSO */
/*****************************************************************************/


/*----rev description---------------------------------------------------------------------------------*/

/* SS - 090707.1 - RNB
为BI打印到多个文件而修改: 取消输入和显示,直接传入参数dev
SS - 090707.1 - RNE */



/* SS - 090701.1 - B 
         define new shared variable dev as character format "x(8)"
   SS - 090701.1 - E */
/* SS - 090701.1 - B */
         define shared variable dev as character format "x(8)"
/* SS - 090701.1 - E */
          label "输出".
         define shared variable printdefault like prd_dev.
         define shared variable printdefaultlevel as integer.
         define variable chr_string as character format "X(64)".
         define variable chr_position as integer.
         define variable pagesize as integer.
         define variable path like prd_path.
         define variable spooler like prd_spooler.
         define variable printwidth as integer.
         define new shared variable batch_id like bcd_batch.
         define shared variable batch_user as character.
         define variable printype as character.
         define variable scrollonly like prd_scroll_only.



         printwidth = {2}.
         printype = "{1}".

         if dev = "" or dev = ? then do:
            if "{1}" = "terminal" then do:
               if printdefault = "" or printdefaultlevel <> 1 then
                  dev = "terminal".
               else
                  dev = printdefault.
            end.
            else do:
               if printdefault <> "" then dev = printdefault.
               else do:
                  if can-find(prd_det where prd_dev = "printer") then
                     dev = "printer".
                  else do:
                     find last prd_det where prd_path <> "terminal"
                     and prd_dev <> "terminal"
                     no-lock no-error.
                     if available prd_det then dev = prd_dev.
                     else dev = "printer".
                  end.
               end.
            end.
         end.

/* SS - 090701.1 - B 
display dev to 77 batch_id to 77 with frame a.

do on error undo , retry:
   set dev batch_id with frame a editing:
      if frame-field = "batch_id" then do:
         {mfnp05.i bc_mstr bc_batch "yes" bc_batch "input batch_id"}
         if recno <> ? then do:
            batch_id = bc_batch.
            display batch_id with frame a.
         end.
      end.
      else do:
         {mfnp05.i prd_det prd_dev "yes" prd_dev "input dev"}
         if recno <> ? then do:
            dev = prd_dev.
            display dev with frame a.
         end.
      end.
   end.
   SS - 090701.1 - E */
/* SS - 090701.1 - B */
do on error undo , retry:
/* SS - 090701.1 - E */

   if batch_id <> "" then do:
      find bc_mstr where bc_batch = batch_id no-lock no-error.
      if not available bc_mstr then do:
         {mfmsg.i 67 3}
         /* "Batch control record does not exist" */
         undo , retry.
      end.
   end.

   path = dev.
   scrollonly = no.                                            /*G058*/
   find prd_det where prd_dev = dev no-lock no-error.
   if available prd_det then do:

/*G1MR*/ /*V8-*/
/*G1MR*/ if path = "window" then do:
/*G1MR*/    /* Output to WINDOW is only available with MFG/PRO for Windows */
/*G1MR*/    {mfmsg.i 8005 3}
/*G1MR*/    undo, retry.
/*G1MR*/    end.
/*G1MR*/ /*V8+*/

      /*G361* following block added*/
      if prd_scroll_only and "{3}" <> "" then do:
         /*Maximum Page Limit Printing not allowed with no-page option */
         {mfmsg.i 89 3}
         undo, retry.
      end.
      if prd_path <> "" then path = prd_path.
      scrollonly = prd_scroll_only.                             /*G058*/
   end.
   else do:
      if not batchrun then do:
         {mfmsg.i 34 2}
         /* DEVICE ENTERED IS NOT A DEFINED PRINTER. */
         pause.
      end.
   end.

   if (path = "terminal" or path = "/dev/tty" or path = "tt:"
/*G1MR*/ /*V8! or path = "window" */
        or scrollonly)                                                /*G058*/
   and batch_id <> "" then do:
      {mfmsg.i 66 3}
      /* "Output to terminal not allowed for batch request" */
      undo , retry.
   end.

   /* Don't allow STREAMED reports to go to terminal, unless overridden */
   /*  these reports usually have another stream going to terminal */
   if (path = "terminal" or path = "/dev/tty" or path = "tt:"
      or scrollonly)                                                /*G058*/
      and "{4}" > ""
      and "{6}" <> "yes"                                        /*G0FB*/
   then do:
      {mfmsg.i 35 3} /* "Terminal not allowed" */
      undo , retry.
   end.

end.

status input.

if batch_id = "" then do:

   maxpage = 0.                                                 /*G058*/
   pagesize = 66.                                                /*G361*/
   spooler = no.
   if available prd_det then do:
      maxpage = prd_max_page.                                   /*G058*/
      pagesize = prd_length.
      spooler = prd_spooler.
   end.

   /* set spooler to no if not running under unix */              /*F556*/
   if path = "printer" or opsys <> "unix" or scrollonly           /*G058*/
   then spooler = no.                                            /*F556*/

   if scrollonly then do:                                         /*G361*/
      path = mfguser + ".out".                                    /*G058*/
      if search(path) <> ? then do:                               /*G361*/
           {gpfildel.i &filename=search(path)}                    /*G361*/
      end.                                                        /*G361*/
   end.
   else if not available prd_det and path <> "printer"
/*G1MR*/    /*V8! and path <> "window" */
    and path <> "terminal" then path = path + ".prn".

   if path <> "terminal" and path <> "/dev/tty" and path <> "tt:"
/*G1MR*/ /*V8! and path <> "window" */
   then do:
      if opsys = "unix" then do:
         {mfmsg.i 5019 1} /*Report now running. Press control-C to cancel*/
      end.
/*G1GW*/ else if opsys = "msdos" or opsys = "win32" then
      do:
         {mfmsg.i 5020 1} /*Report now running. Press control-BREAK ...*/
      end.
      else
      if opsys = "vms" then
      do:
         {mfmsg.i 5021 1} /*Report now running. Press control-Y or STOP ...*/
      end.
   end.

   if available prd_det and prd_init_pro <> "" then do:
      if opsys = "unix" then unix silent value(prd_init_pro).
      else
/*G1GW*/ if opsys = "msdos" or opsys = "win32" then
/*G1GW*/    dos silent value(prd_init_pro).
      else
      if opsys = "vms" then vms silent value(prd_init_pro).
   end.

   if path = "terminal" then do:

         if "{6}" = "yes" then
            output {4} to terminal.  /* Special case for fsescmgr.p */
         else if "{1}" = "printer" then
/*G0FB*/ do:
            if can-find (_field where _field-name = "_frozen") then
            do:
              {gprun.i ""gpseterm.p""}
            end.
/*G0FB*//*V8-*/
            output {4} to terminal paged.
/*G0FB*//*V8+*/
/*G0FB*//*V8!
            pause before-hide.
            create window terminal-window assign
                TITLE            = dtitle
                THREE-D          = yes
                FONT             = 0
                HEIGHT           = 23.29
                WIDTH            = 100
                MAX-HEIGHT       = 23.29
                MAX-WIDTH        = 100
                VIRTUAL-HEIGHT   = 24
                VIRTUAL-WIDTH    = {2}
                RESIZE           = yes
                SCROLL-BARS      = yes
                STATUS-AREA      = yes
                BGCOLOR          = ?
                FGCOLOR          = ?
                MESSAGE-AREA     = yes
                SENSITIVE        = yes
                PRIVATE-DATA     = "MFG/PRO Paged Term"
            .
            save-window = current-window.
            current-window = terminal-window.
            apply "ENTRY" to current-window.
            output {4} to terminal paged.
*/ /*G0FB*/
         end.
         else release prd_det.

   end.
/*G1MR*  else do:  */
/*G1MR*/ else /*V8! if path <> "window" then */ do:
      if "{3}" = "nopage" then do:
         if spooler then
            output {4} through value(path) page-size 0.
         else
            output {4} to value(path) {5} page-size 0.
      end.
      else do:
/*G058********************************************************************
* /*B241*/ if pagesize = 72 then do:   /* 72 lines/page */
*            if spooler then output {4} through value(path) paged page-size 66.
*            else output {4} to value(path) {5} paged page-size 66.
*         end.
*         else if pagesize = 48 then do:    /* 48 lines/page */
*            if spooler then output {4} through value(path) paged page-size 42.
*            else output {4} to value(path) {5} paged page-size 42.
*         end.
* /*B576*/ else if pagesize = 54 then do:
* /*B576*/   if spooler then output {4} through value(path) paged page-size 54.
* /*B576*/    else output {4} to value(path) {5} paged page-size 54.
* /*B576*/ end.
*         else do:     /* 66 lines/page */
*            if spooler then output {4} through value(path) paged page-size 60.
*            else output {4} to value(path) {5} paged page-size 60.
*         end.
*****************************************************************************/

            printlength = pagesize - 6.

            if spooler then
             output {4} through value(path) paged page-size value(printlength).
            else
             output {4} to value(path) {5} paged page-size value(printlength).
      end.
   end.

/*G1MR*/ /*V8!
/*G1MR*/ if path = "window" then do:
/*G1MR*/    run p-report-cancel-button in tools-hdl.
/*G1MR*/    output {4} to value("report.rpt") paged.
/*G1MR*/    report-to-window = true.
/*G1MR*/ end.
/*G1MR*/ */

/*G1MR* /*V8!    if path <> "terminal" then do: */ /*G0FB*/  */
/*G1MR*/ /*V8!   if path <> "terminal" and path <> "window" then do: */ /*G0FB*/
            if available prd_det then do:
               if {2} = 132 then put {4} control prd_init + prd_st_132.
               else if {2} = 80 then put {4} control prd_init + prd_st_80.
               else put {4} control prd_init.
            end.
/*V8!    end. */ /*G0FB*/

/*G0FB*/ /*V8-*/
         hide frame selprt no-pause.
         if "{1}" = "terminal" and path <> "terminal" then do:
            display {4} dtitle skip(1) with no-box no-labels frame selprt
             page-top.
            view {4} frame a.
         end.
/*G0FB*/ /*V8+*/ /*V8!
         if "{1}" = "terminal" and path <> "terminal"
/*G1MR*/ and path <> "window"
         then do:
/*G1C6*     output to terminal paged. */
/*G1C6*     display {4} dtitle skip(1) with no-box no-labels frame selprt */
/*G1C6*     page-top.                                                     */
/*G1C6*/    define variable ititle as character format "X(64)".
/*G1C6*/    ititle = execname
/*G1C6*/       + fill(" ", 15 - integer(length(execname)))
/*G1C6*/       + fill(" ", integer((48 - length(dtitle)) / 2))
/*G1C6*/       + dtitle.
/*G1C6*/    display {4} ititle today to 78 skip(1)
/*G1C6*/       with no-box no-labels frame selprt page-top.
            define variable criteria-prt as char.
            define variable criteria-prt-column as integer.
            local-handle = frame a:first-child. /* field group */
            local-handle = local-handle:first-child. /* first widget */
            repeat while local-handle <> ?:
              if local-handle:type = "fill-in" then do:
               if local-handle:labels then do:
                 criteria-prt = local-handle:label + ": " +
                   local-handle:screen-value.
                 criteria-prt-column =
                   max(1,(local-handle:column - length(local-handle:label))).
/*J225***        put unformatted ***/
/*J225*/         put {4} unformatted
                   criteria-prt
                 at criteria-prt-column.  /* Print widget's current value */
               end. /* if local-handle:labels */
              end.
              local-handle = local-handle:next-sibling.
            end.  /* repeat */
         end.
*/ /*G0FB*/
end.
else do:
   {gprun.i ""gpbcdadd.p""}
   next.
end.

/*end mfselbpr.i*/
