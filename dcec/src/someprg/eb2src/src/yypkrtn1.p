/* xxpkrtn1.p   Retrun materiel to store	By: Sunny Zhou AtosOrigin 08/19/02 */
/* Read record from tr_hist						 */
/* REVISION: 8.5    LAST MODIFIED: 08/19/02 BY: *Sunny* AtosOrigin */

     /* DISPLAY TITLE */
/*GH52*/ {mfdtitle.i "e+ "}   /*GH52*/
 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

DEFINE VARIABLE xSite  like pt_site.
DEFINE VARIABLE xnbr   like tr_nbr label "原领料单号".
DEFINE VARIABLE xnbr1  like tr_nbr .
DEFINE VARIABLE xPart  like pt_part.
DEFINE VARIABLE xPart1 like pt_part.
DEFINE VARIABLE xdate  like tr_effdate.
DEFINE VARIABLE xdate1 like tr_effdate.
DEFINE VARIABLE i      as integer.
DEFINE VARIABLE xdisp  like mfc_logic format  "Y:可退/N:所有" initial no label "显示".
DEFINE VARIABLE xoldtrtype as character.
DEFINE VARIABLE xnewtrtype as character.

DEFINE BUFFER   xxpnrtn for xxpn_rtn.

/*F0FH*/ {gpglefdf.i}

FORM /*GUI*/    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
	skip(1)
	xSite          colon 20
        xnbr           colon 20
	xnbr1	       colon 50 label {t001.i}
        xpart          colon 20
        xPart1         colon 50 label {t001.i} 
	xdate	       colon 20
	xdate1	       colon 50 label {t001.i}  skip(1)
	xdisp	       colon 20
	skip(1)
	"注意:收料库位为 '*' 则不给回退"  colon 20 skip
	"       发料库位为 '*' 则退默认库位" colon 20 skip
      SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME
/*tfq*/ setframelabels(frame a:handle) .
FORM /*GUI*/    
	xxpn_trnbr	
	xxpn_site
	xxpn_nbr
	xxpn_part		
	xxpn_old_loc	
	xxpn_old_trtype
	xxpn_tg_loc
	xxpn_trtype
	xxpn_act_loc
	xxpn_tg_trnbr
	xxpn_del
	xxpn_qty		
	xxpn_old_qty		
	xxpn_lot		
	xxpn_ref		
	xxpn_serial		
	xxpn_sojob		
	xxpn_old_trdate 
	xxpn_old_effdate	
 with stream-io frame xd width 300 NO-BOX down /*GUI*/.

 xsite = global_site.
 if xsite = "" then do:
	for first icc_ctrl no-lock: END.
	if available icc_ctrl then xsite = icc_site.
 end.

FOR first rpc_ctrl no-lock: END.
IF available rpc_ctrl THEN  xnbr = rpc_nbr_pre + trim(string(rpc_nbr - 1)).
FIND last tr_hist where tr_nbr begins xnbr use-index tr_nbr_eff no-lock no-error.
i = 1 .
do while not available tr_hist:
	i = i + 1 .
	xnbr = rpc_nbr_pre + trim(string(rpc_nbr - i)).
	FIND last tr_hist where tr_nbr begins xnbr use-index tr_nbr_eff no-lock no-error.
	if rpc_nbr - i <= 0 then leave.
end.
if available tr_hist then xnbr = tr_nbr .
xnbr1 = xnbr.

     /* DISPLAY */
     mainloop:
     repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.

	if xPart1 = hi_char then xPart1 = "".
	if xdate  = low_date then xdate = ?.
	if xdate1 = hi_date  then xdate1 = ?.

	update
		xSite    
		xnbr 
		xnbr1 
		xpart    
		xPart1   
		xdate
		xdate1
		xdisp 
		with frame a .
	
        bcdparm = "".
        {mfquoter.i xsite    }
        {mfquoter.i xnbr     }
        {mfquoter.i xnbr1    }
        {mfquoter.i xpart    }
        {mfquoter.i xpart1   }
        {mfquoter.i xdate    }
        {mfquoter.i xdate1   }

        if xpart1 = "" then xpart1 = hi_char.
        if xdate1 = ?  then xdate1 = hi_date.
	if xdate  = ?  then xdate  = low_date.
	if xnbr1 = ""  then xnbr1 = hi_char.

	  find si_mstr where si_site = xSite no-lock no-error.
          if not available si_mstr then do:
       /*tfq*/   {pxmsg.i
               &MSGNUM=708
               &ERRORLEVEL=3
                          }
         /*tfq    {mfmsg.i 708 3}  /* SITE DOES NOT EXIST */ */
             next-prompt xSite with frame a.
             undo mainloop, retry mainloop.
          end.

          {gprun.i ""gpsiver.p""
	   "(input xSite, input recid(si_mstr), output return_int)"}
	if global-beam-me-up then undo, leave.

          if return_int = 0 then do:
  /*tfq*/         {pxmsg.i
               &MSGNUM=725
               &ERRORLEVEL=3
                        }

           /*tfq  {mfmsg.i 725 3} */   /* USER DOES NOT HAVE */
                                /* ACCESS TO THIS SITE*/
             next-prompt xSite with frame a.
             undo mainloop, retry mainloop.
          end.

	FIND first tr_hist where tr_nbr >= xnbr 
			   and   tr_nbr <= xnbr1
			   and   tr_effdate >= xdate
			   and   tr_effdate <= xdate1
			   use-index tr_nbr_eff no-lock no-error.
	IF not available tr_hist THEN
	DO:
		Message "没有找到可退料的领料单" VIEW-AS ALERT-BOX ERROR BUTTONS ok.
		next-prompt xnbr with frame a .
		undo mainloop, retry mainloop.
	END.


	/* SELECT PRINTER */
        {mfselbpr.i "printer" 132}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

        {mfphead.i}
	
	FOR EACH xxpn_rtn where xxpn__user = mfguser 
		and not xxpn_ok exclusive-lock:
		delete xxpn_rtn.
	END.

	FOR EACH tr_hist where tr_nbr >= xnbr
			 and   tr_nbr <= xnbr1
			 and   tr_site = xSite
			 and   tr_part >= xPart
			 and   tr_part <= xPart1
			 and   tr_effdate >= xdate
			 and   tr_effdate <= xdate1
			 and   (tr_type = "ISS-TR" or tr_type = "RCT-TR")
			 no-lock
			 use-index tr_nbr_eff 
			 WITH STREAM-IO frame xd :

	    	FIND first xxpn_rtn where xxpn_trnbr = tr_trnbr  use-index xxpn_trnbr
				    exclusive-lock NO-ERROR.

		  IF not available xxpn_rtn THEN
		  DO:
		  	create xxpn_rtn.
			ASSIGN
				xxpn_trnbr	= tr_trnbr
				xxpn_site	= xSite      
				xxpn_nbr	= "RE" + tr_nbr
				xxpn_old_nbr	= tr_nbr    
				xxpn_trtype	= if tr_type = "ISS-TR" then "RCT-TR" else "ISS-TR"
				xxpn_old_trtype = tr_type
				xxpn_trdate	= today
				xxpn_old_trdate = tr_date
				xxpn_old_effdate = tr_effdate
				xxpn_act_loc	= tr_loc
				xxpn_old_loc	= tr_loc
				xxpn_part	= tr_part   
				xxpn_lot	= tr_lot    
				xxpn_ref	= tr_ref    
				xxpn_serial	= tr_serial
				xxpn_qty	= tr_qty_chg
				xxpn_old_qty    = tr_qty_chg
				xxpn_sojob	= tr_so_job
				xxpn_userid	= global_userid
				xxpn__user	= mfguser
				xxpn_tg_loc	= "".

			IF tr_type = "ISS-TR" and substring(tr_loc,length(tr_loc),1) = "*"  THEN
				xxpn_wip = yes.
			IF tr_type = "RCT-TR" and substring(tr_loc,length(tr_loc),1) = "*" THEN
				xxpn_del = yes.
		  END. /* not xxpn_rtn */
		  ELSE DO:  /*available xxpn_rtn*/
			IF xxpn_ok THEN
			DO:
			   display tr_trnbr  @ xxpn_trnbr " 已经回调完毕!!"  @ xxpn_nbr 
				tr_site @ xxpn_site
				tr_part @ xxpn_part		
				tr_loc  @ xxpn_old_loc
				tr_type @ xxpn_old_trtype
				tr_qty_chg @ xxpn_qty		
				tr_lot  @ xxpn_lot		
				tr_ref  @ xxpn_ref		
				tr_serial @ xxpn_serial		
				tr_so_job @ xxpn_sojob		
				tr_date  @ xxpn_old_trdate 	
				tr_effdate @ xxpn_old_effdate	
			   WITH STREAM-IO frame xd .
			   down with frame xd.
			   next.
			END.
			ELSE DO: /*not tran */
					ASSIGN
/*					xxpn_trnbr	= tr_trnbr */
					xxpn_site	= xSite      
					xxpn_nbr	= "RE" + tr_nbr
					xxpn_old_nbr	= tr_nbr    
					xxpn_trtype	= if tr_type = "ISS-TR" then "RCT-TR" else "ISS-TR"
					xxpn_old_trtype = tr_type
					xxpn_trdate	= today
					xxpn_old_trdate = tr_date
					xxpn_old_effdate = tr_effdate
					xxpn_act_loc	= tr_loc 
					xxpn_old_loc	= tr_loc
					xxpn_part	= tr_part   
					xxpn_lot	= tr_lot    
					xxpn_ref	= tr_ref    
					xxpn_serial	= tr_serial
					xxpn_qty	= tr_qty_chg  
					xxpn_old_qty	= tr_qty_chg
					xxpn_sojob	= tr_so_job
					xxpn_del	= no
					xxpn_userid	= global_userid
					xxpn__user	= mfguser
					xxpn_tg_loc	= "".
			   IF tr_type = "ISS-TR" and substring(tr_loc,length(tr_loc),1) = "*"  THEN
				xxpn_wip = yes.

			   IF tr_type = "RCT-TR" and substring(tr_loc,length(tr_loc),1) = "*" THEN
				xxpn_del = yes.
			END. /* not tran*/
		  END. /*not xxpn_rtn*/
      	END. /*for each tr_hist*/
	FOR EACH xxpn_rtn where xxpn__user = mfguser
			and xxpn_trdate = today
			and xxpn_old_nbr >= xnbr
			and xxpn_old_nbr <= xnbr1
  			and xxpn_old_trtype = "RCT-TR"
			WITH STREAM-IO frame xd:

	    FIND first xxpnrtn where xxpnrtn.xxpn_old_nbr    = xxpn_rtn.xxpn_old_nbr
				and  xxpnrtn.xxpn_site       = xxpn_rtn.xxpn_site
				and  xxpnrtn.xxpn_old_trdate = xxpn_rtn.xxpn_old_trdate
				and  xxpnrtn.xxpn_old_trtype = "ISS-TR"
				and  xxpnrtn.xxpn_part       = xxpn_rtn.xxpn_part
				and  xxpnrtn.xxpn_lot        = xxpn_rtn.xxpn_lot
				and  xxpnrtn.xxpn_serial     = xxpn_rtn.xxpn_serial
				and  xxpnrtn.xxpn_ref        = xxpn_rtn.xxpn_ref
				and  xxpnrtn.xxpn_trnbr     <> xxpn_rtn.xxpn_trnbr
				and  xxpnrtn.xxpn_old_qty  = - xxpn_rtn.xxpn_old_qty
				and  not xxpnrtn.xxpn_del  
				and  xxpnrtn.xxpn_tg_loc = ""
				and  xxpnrtn.xxpn__user = mfguser
				and  xxpnrtn.xxpn_trdate = today 
				use-index xxpn_old
				exclusive-lock no-error.
		IF not available xxpnrtn THEN
		DO:
		display
			xxpn_rtn.xxpn_trnbr	
			"找不到发料仓" @ xxpn_rtn.xxpn_nbr		
			xxpn_rtn.xxpn_old_trtype 	
			xxpn_rtn.xxpn_old_trdate 	
			xxpn_rtn.xxpn_old_effdate	
			xxpn_rtn.xxpn_old_loc		
			xxpn_rtn.xxpn_part		
			xxpn_rtn.xxpn_lot		
			xxpn_rtn.xxpn_ref		
			xxpn_rtn.xxpn_serial		
			xxpn_rtn.xxpn_qty		
			xxpn_rtn.xxpn_old_qty		
			xxpn_rtn.xxpn_sojob WITH STREAM-IO with frame xd.
			down with frame xd.
			xxpn_rtn.xxpn_del = yes.
		END.	
		ELSE DO: /*can find ISS-TR*/

			xxpn_rtn.xxpn_tg_loc = xxpnrtn.xxpn_old_loc. /*收料仓退回目的仓为原发料仓*/
			xxpnrtn.xxpn_tg_loc = xxpn_rtn.xxpn_old_loc. 
  	                xxpnrtn.xxpn_act_loc  = xxpnrtn.xxpn_old_loc.
			xxpn_rtn.xxpn_act_loc = xxpn_rtn.xxpn_old_loc.

			xxpn_rtn.xxpn_tg_trnbr = xxpnrtn.xxpn_trnbr.
			xxpnrtn.xxpn_tg_trnbr = xxpn_rtn.xxpn_trnbr.

			IF substring(xxpn_rtn.xxpn_old_loc,length(xxpn_rtn.xxpn_old_loc),1) = "*" THEN
			DO: /* 收料库位为 '*' 则不给回退*/
				xxpnrtn.xxpn_del = yes.		
			END.

			IF substring(xxpnrtn.xxpn_old_loc,length(xxpnrtn.xxpn_old_loc),1) = "*" THEN
			DO: /*  发料库位为'*' 则退默认库位*/
				FIND pt_mstr where pt_part = xxpnrtn.xxpn_part no-lock no-error.
				IF available pt_mstr and pt_loc <> "" THEN
				DO:
				    xxpnrtn.xxpn_act_loc = pt_loc.
				END.
				ELSE DO:
				    display 
					xxpnrtn.xxpn_trnbr       @  xxpn_rtn.xxpn_trnbr	
					"找不到回退默认库位"     @  xxpn_rtn.xxpn_nbr		
					xxpnrtn.xxpn_old_trtype  @  xxpn_rtn.xxpn_old_trtype	
					xxpnrtn.xxpn_old_trdate  @  xxpn_rtn.xxpn_old_trdate 	
					xxpnrtn.xxpn_old_effdate @  xxpn_rtn.xxpn_old_effdate
					xxpnrtn.xxpn_old_loc	 @  xxpn_rtn.xxpn_old_loc	
					xxpnrtn.xxpn_part	 @  xxpn_rtn.xxpn_part	
					xxpnrtn.xxpn_lot	 @  xxpn_rtn.xxpn_lot	
					xxpnrtn.xxpn_ref	 @  xxpn_rtn.xxpn_ref	
					xxpnrtn.xxpn_serial	 @  xxpn_rtn.xxpn_serial	
					xxpnrtn.xxpn_qty	 @  xxpn_rtn.xxpn_qty	
					xxpnrtn.xxpn_old_qty	 @  xxpn_rtn.xxpn_old_qty	
					xxpnrtn.xxpn_sojob       @  xxpn_rtn.xxpn_sojob
					WITH STREAM-IO with frame xd.
					down with frame xd.
				END. /* not available pt_mstr */
			END. /*  收料库位为'*' 则退默认库位*/
		END. /*can find ISS-TR*/
	END. /*for each xxpn_rtn*/

	FOR EACH xxpn_rtn   where xxpn__user = mfguser
			     and  xxpn_trdate = today
			     and xxpn_old_nbr >= xnbr
			     and xxpn_old_nbr <= xnbr1
		use-index xxpn_trnbr 
		WITH STREAM-IO frame xd:

		IF xxpn_site = "" 
		or xxpn_nbr = "" 
		or xxpn_part = ""
		or xxpn_old_loc = "" 
		or xxpn_tg_loc = "" 
		or xxpn_act_loc = "" 
		or xxpn_qty = 0      
		THEN DO:
			xxpn_del = yes .
			xxpn_nbr = "错:不符合回调要求！".
		END.

	     if xxpn_old_trtype = "ISS-TR" then xoldtrtype  = " ---->"  .
					   else xoldtrtype  = "<---- " .
	     if xxpn_trtype = "ISS-TR" then do:
		 if xxpn_del then xnewtrtype = "<--X--" .
			     else xnewtrtype = "<-----".
	         end.
		 else do:
		 if xxpn_del then xnewtrtype = "--X-->" .
			     else xnewtrtype = "----->".
		 end.
	    if not xdisp or not xxpn_del then do:
		display
			xxpn_trnbr	
			xxpn_site
			xxpn_nbr
			xxpn_part		
			xxpn_old_loc
			xoldtrtype @ xxpn_old_trtype
			xxpn_tg_trnbr
			xxpn_tg_loc
			xnewtrtype @ xxpn_trtype
			xxpn_act_loc
			xxpn_del
			xxpn_qty		
			xxpn_old_qty		
			xxpn_lot		
			xxpn_ref		
			xxpn_serial		
			xxpn_sojob		
			xxpn_old_trdate 	
			xxpn_old_effdate	
			WITH STREAM-IO with frame xd.
			down with frame xd.
	    end.
 /*GUI*/ {mfguichk.i } /*Replace mfrpchk*/ 
		
	END.
	{mfrtrail.i}

     end. /*repeat*/
