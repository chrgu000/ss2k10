define shared variable global_userid as char format "x(30)".
define shared variable global_gblmgr_handle as handle no-undo.
define shared variable global_domain like dom_domain.
define variable WMESSAGE as char format "x(80)" init "".
define new shared variable prog as char format "x(60)" no-undo.
define new shared variable suser as char no-undo.

define variable quote as char initial '"' no-undo.
define variable outfile as char format "x(40)"  no-undo.
define variable outfile1 as char format "x(40)"  no-undo.
define shared variable batchrun like mfc_logical.

run pxgblmgr.p persistent set global_gblmgr_handle.
global_userid = trim ( userid(sdbname('qaddb')) ).

/*debug
      VUSER:
      REPEAT:
         hide all.
	 define variable domain   as char format "x(40)".
	 define variable ldomain   as char format "x(40)".
         define variable luser    as char format "x(40)".
         define variable puser    as char format "x(40)".
         define variable lpwd     as char format "x(40)".
         define variable ppwd     as char format "x(40)".
        
	 luser   = "用户 ?" .
         display luser         format "x(40)" skip with fram user1 no-box.
/*
         lpwd = "密码 ?" .
         display lpwd         format "x(40)" skip with fram user1 no-box.

         ldomain = "域 ?" .
         display ldomain         format "x(40)" skip with fram user1 no-box.
*/
	 display "输入或按E退出"       format "x(40)" skip
                skip with fram user1 no-box.

	 Update puser skip
/*	        ppwd blank  */
/*              domain skip */
         WITH  fram user1 NO-LABEL.

	 /* PRESS e EXIST CYCLE */
         IF trim(puser) = "e" THEN LEAVE VUSER.
	
         display  skip WMESSAGE NO-LABEL with fram user1.

	 find first xusr_mstr where xusr_domain = global_domain AND xusr_usr = puser no-lock no-error.
         IF NOT AVAILABLE xusr_mstr then do:
            display skip "错误:用户不存在." @ WMESSAGE NO-LABEL with fram user1.
	    next-prompt puser with fram user1.
            pause 0 before-hide.
            undo, retry.
         end.
	 else do:
/*	    
	    if ppwd <> xusr_pwd then do:
               display skip "错误:密码错误." @ WMESSAGE NO-LABEL with fram user1.
   	       next-prompt ppwd with fram user1.
               pause 0 before-hide.
               undo, retry.
	    end.
*/
	    prog = xusr_prog.
	 end.
	 suser = puser.
	 
	 find first DOM_MSTR where DOM_DOMAIN = domain no-lock no-error.
         
	 IF NOT AVAILABLE DOM_MSTR then do:
            display skip "错误:域不存在." @ WMESSAGE NO-LABEL with fram user1.
            pause 0 before-hide.
            undo, retry.
         end.

         display  "" @ WMESSAGE NO-LABEL with fram user1.
         pause 0.
         leave VUSER.
   end.

 global_domain = domain.

*debug*/

if lookup(global_domain, "008") > 0 then do:
   run xsmf001_a.p.
/* run xsmf001_a.p. */ 
end.
if lookup(global_domain, "01") > 0 then do:
   run xsmf001_a1.p.
/* run xsmf001_a.p. */ 
end.
/*if global_domain = "11" then do:
   run xsmf00111_a.p.
end.*/
if global_domain = "011" then do:
    run xsmf001_a.p.
end.
if global_domain = "99" then do:
   run xsmf002.p.
end.

if lookup(global_domain, "05,151,010,117,030,027,112,009") > 0 then do:
   run xsmf003.p.
end.



/*
     outfile = "/app/bc/tmp/domain"  + ".prn".	       

     OUTPUT TO VALUE(outfile).

     PUT UNFORMATTED 
         quote trim(domain) quote space skip
	 ".".          

     OUTPUT CLOSE.

     /** 数据开始更新处理 **/
     DO TRANSACTION ON ERROR UNDO,RETRY:
        batchrun = YES.
	outfile1  = outfile + ".o".

        INPUT FROM VALUE(outfile).
        output to  value (outfile1) .

	run /app/mfgpro/eb21/ch/mg/mgdomchg.r.

	INPUT CLOSE.
        output close.
     END.  /** do transaction ***/
*/

quit.
