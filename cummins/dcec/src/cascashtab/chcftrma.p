/* GUI CONVERTED from chcftrma.p (converter v1.71) Sun Oct 21 21:39:26 2007 */
/* chcftrma.p -- GENERAL LEDGER CASH FLOW ENTRY TRANSACTION MAINT - CAS    */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.	                   */
/* All rights reserved worldwide.  This is an unpublished work.	           */
/*F0PN*/ /*V8:ConvertMode=Maintenance	                                   */
/*V8:RunMode=Character,Windows */
/* REVISION: 9.1     LAST MODIFIED:  07/15/02  by: XinChao Ma              */
/* REVISION: 9.3      LAST MODIFIED: 10/11/07   BY: LinYun   ECO: *XXLY*  */
/***************************************************************************/
    {mfdeclre.i}    
    {gplabel.i} /* EXTERNAL LABEL INCLUDE */

define variable xamt like glt_amt format "->,>>>,>>>,>>9.99".
define variable dr_cr as logical format "Dr/Cr" initial yes.
define        variable tot_amt like glt_amt.
define        variable linenum like glt_line.
define        variable del-yn as logical initial no.
define shared variable w-recid as recid.
define shared variable ctrl_rndmthd   like rnd_rnd_mthd no-undo.
define        variable xamt_old       as character no-undo.
define        variable xamt_base_fmt  as character no-undo.
define        variable xamt_gltc_fmt  as character no-undo.
define        variable gltcurr_rndmthd like rnd_rnd_mthd no-undo.
define        variable old_gltcurr    like glt_curr no-undo.
define        variable retval         as integer no-undo.
define        variable acc_rndmthd    like rnd_rnd_mthd no-undo.
define        variable old_acccurr    like ac_curr no-undo.
define        variable glt_curramt_fmt    as character no-undo.
define        variable rndmthd        like rnd_rnd_mthd no-undo.
define        variable fixed-rate like so_fix_rate no-undo.
define        variable mc-error-number like msg_nbr no-undo.

define buffer glt_b for glt_det.
define buffer glt_b1 for glt_det.

    FORM /*GUI*/ 
        xcft_line      
	xcft_acct
        xcft_desc         
        dr_cr        
	glt_curr
        xamt
    with frame b 4 down width 70 no-hide overlay 
    title color normal (getFrameTitle("CASH_FLOW_INFORMATION",28))
    row 1 column 6 THREE-D /*GUI*/.


    /* SET EXTERNAL LABELS */
    setFrameLabels(frame b:handle).
    find glt_det where recid(glt_det) = w-recid and glt_domain = global_domain no-lock no-error.
         find first gl_ctrl no-lock no-error.
   
/*CF*/    for first xcfp_ctrl where xcfp_domain = global_domain no-lock: end.
      if glt_tr_type = "AR" or glt_tr_type = "AP" then
      if (glt_tr_type = "AR" and execname = "arpamt.p") 
         or (glt_det.glt_tr_type = "AR" and execname = "ardrmt.p")
     
         or (glt_tr_type = "AP" and execname = "apmcmt.p") 
         or (glt_tr_type = "AP" and execname = "apvomt.p") 
         or (glt_det.glt_tr_type = "AP" and execname = "apcrmt.p")then do:   
        linenum = 0.
              
       find last glt_b1 where glt_b1.glt_ref = glt_det.glt_ref
                           and glt_b1.glt_domain = global_domain 
                            and can-find (first xcf1_mstr where
/*XXLY*COMMENT*                         glt_b1.glt_acct = xcf_ac_code and glt_b1.glt_sub = xcf_sub 
                                and glt_b1.glt_cc = xcf_cc and glt_b1.glt_project = xcf_pro
*XXLY*COMMENT END*/  
/*XXLY*ADD*/                  glt_b1.glt_acct = xcf1_mfgc_ac_code 
             	        and ( if xcf1_mfgc_sub <> "*" then glt_b1.glt_sub = xcf1_mfgc_sub  else true )
                      and ( if xcf1_mfgc_cc  <> "*" then glt_b1.glt_cc = xcf1_mfgc_cc else true )
                      and ( if xcf1_mfgc_pro <> "*" then glt_b1.glt_project = xcf1_mfgc_pro else true )
/*XXLY*ADD END*/
                                
                                and xcf1_domain = global_domain)
                      no-lock no-error.

        for each glt_b where glt_b.glt_ref = glt_det.glt_ref
                	               and glt_b.glt_domain = global_domain 
                                 and recid(glt_b) <> w-recid    
                              no-lock:                     
        
        find first xcf1_mstr where glt_b.glt_acct = xcf1_mfg_ac_code
                        and glt_b1.glt_acct = xcf1_mfgc_ac_code
/*XXLY*COMMENT*                        
                        and glt_b1.glt_sub  = xcf1_mfgc_sub
                        and glt_b1.glt_cc   = xcf1_mfgc_cc
                        and glt_b1.glt_project  = xcf1_mfgc_pro
*XXLY*COMMENT END*/ 
/*XXLY*ADD*/            and ( if xcf1_mfg_sub <> "*" then  glt_b.glt_sub = xcf1_mfg_sub else true )
                        and ( if xcf1_mfg_cc <> "*" then  glt_b.glt_cc = xcf1_mfg_cc else true )
                        and ( if xcf1_mfg_pro <> "*" then  glt_b.glt_project = xcf1_mfg_pro else true )
             	          and ( if xcf1_mfgc_sub <> "*" then glt_b1.glt_sub = xcf1_mfgc_sub  else true )
                        and ( if xcf1_mfgc_cc  <> "*" then glt_b1.glt_cc = xcf1_mfgc_cc else true )
                        and ( if xcf1_mfgc_pro <> "*" then glt_b1.glt_project = xcf1_mfgc_pro else true )
/*XXLY*ADD END*/                       
                        and xcf1_active = yes 
                        and xcf1_domain = global_domain no-lock no-error.
        if not available xcf1_mstr then do:

                     find first xcf1_mstr where glt_b.glt_acct = xcf1_mfg_ac_code
/*XXLY*ADD*/            and ( if xcf1_mfg_sub <> "*" then  glt_b.glt_sub = xcf1_mfg_sub else true )
                        and ( if xcf1_mfg_cc <> "*" then  glt_b.glt_cc = xcf1_mfg_cc else true )
                        and ( if xcf1_mfg_pro <> "*" then  glt_b.glt_project = xcf1_mfg_pro else true )
/*XXLY*ADD END*/
                        and xcf1_cf_acc = yes 
                           and xcf1_active = yes
                        and xcf1_domain = global_domain no-lock no-error.
         end.
        if available xcf1_mstr then do:           
   
                      find  first xcft_det where xcft_ref = glt_det.glt_ref
                         and xcft_ac_code = glt_det.glt_acct
                         and xcft_sub     = glt_det.glt_sub
                         and xcft_cc      = glt_det.glt_cc
                         and xcft_pro     =glt_det.glt_project
                         and xcft_rflag   = glt_det.glt_rflag
                         and xcft_glt_line = glt_det.glt_line
                         and can-find(first xcf1_mstr where xcft_acct = xcf1_ac_code
                        and xcf1_cf_acc = yes 
                        and xcf1_active = yes 
                        and xcf1_domain = global_domain)
                         and xcft_domain = global_domain 
                        exclusive-lock no-error.
           if available xcft_det then do:
          
              assign xcft_amt = /*xcft_amt +  */ glt_det.glt_amt
                     xcft_curr_amt = /*xcft_curr_amt + */ glt_det.glt_curr_amt.
                   end.  
           else do:

               linenum = linenum + 1.
               create xcft_det.
               assign xcft_ref     = glt_det.glt_ref
                      xcft_rflag   = glt_det.glt_rflag
                      xcft_acct    = xcf1_ac_code
                      xcft_ac_code = glt_det.glt_acc
                      xcft_sub     = glt_det.glt_sub
                      xcft_cc      = glt_det.glt_cc
                      xcft_pro     =glt_det.glt_project
                      xcft_rflag   = glt_det.glt_rflag
                      xcft_glt_line = glt_det.glt_line
                      xcft_amt      = glt_det.glt_amt
                      xcft_curr_amt = glt_det.glt_curr_amt
                      xcft_line    = linenum
                      xcft_entity  = glt_det.glt_entity
                      xcft_domain = global_domain.

            find ac_mstr where ac_code = xcft_acct and ac_domain = global_domain
            no-lock no-error.
            if available ac_mstr then xcft_desc = ac_desc.
              end.            
            end. /* if available xcf1_mstr then do: */
                     
  
          end. /* for each glt_b where glt_b.glt_ref = glt_det.glt_ref */
          
         end. /* if glt_det.glt_tr_tyep = "AR" or "AP" */   

      if glt_det.glt_tr_type = "JL" and execname = "chgltrmt.p" then do:   
        
        linenum = 0.

/*XXLY*/ 
        for each glt_b where glt_b.glt_ref = glt_det.glt_ref
        	               and glt_b.glt_domain = global_domain 
                         and recid(glt_b) <> w-recid
                          no-lock break by glt_det.glt_line :
                     
               find first xcf_mstr where 
                        glt_b.glt_acct =  xcf_mfg_code 
                        and glt_det.glt_acct = xcf_ac_code 
/*XXLY*ADD*/            and ( if xcf_mfg_sub <> "*" then  glt_b.glt_sub = xcf_mfg_sub else true )
                        and ( if xcf_mfg_cc <> "*" then  glt_b.glt_cc = xcf_mfg_cc else true )
                        and ( if xcf_mfg_pro <> "*" then  glt_b.glt_project = xcf_mfg_pro else true )
             	          and ( if xcf_sub <> "*" then glt_det.glt_sub = xcf_sub  else true )  
                        and ( if xcf_cc  <> "*" then glt_det.glt_cc = xcf_cc else true )
                        and ( if xcf_pro <> "*" then glt_det.glt_project = xcf_pro else true )
/*XXLY*ADD END*/                        
                        and xcf_active = yes 
                        and xcf_domain = global_domain no-lock no-error.
           if available xcf_mstr then do:  

             find first xcft_det where xcft_ref = glt_det.glt_ref
                         and xcft_ac_code = glt_det.glt_acct
                         and xcft_sub     = glt_det.glt_sub
                         and xcft_cc      = glt_det.glt_cc
                         and xcft_pro     =glt_det.glt_project
                         and xcft_rflag   = glt_det.glt_rflag
                         and xcft_glt_line = glt_det.glt_line
                         and xcft_line = (linenum + 1)
                         and can-find(first xcf_mstr where xcft_acct = xcf_mfg_ac_code
                        and xcf_active = yes 
                        and xcf_domain = global_domain)
                         and xcft_domain = global_domain 
                        exclusive-lock no-error.
              if available xcft_det  then do:

                  end.
               else do: 
              	                          
                        linenum = linenum + 1.
                         create xcft_det.
               assign xcft_ref     = glt_det.glt_ref
                      xcft_rflag   = glt_det.glt_rflag
                      xcft_acct    = xcf_mfg_ac_code
                      xcft_ac_code = glt_det.glt_acc
                      xcft_sub     = glt_det.glt_sub
                      xcft_cc      = glt_det.glt_cc
                      xcft_pro     =glt_det.glt_project
                      xcft_rflag   = glt_det.glt_rflag
                      xcft_glt_line = glt_det.glt_line
                      xcft_amt      = -(glt_b.glt_amt)
                      xcft_curr_amt = -(glt_b.glt_curr_amt)
                      xcft_line    = linenum
                      xcft_entity  = glt_det.glt_entity
                      xcft_domain = global_domain.
                   end.  /*aviable xcf_mstr*/   
            find ac_mstr where ac_code = xcft_acct and ac_domain = global_domain
            no-lock no-error.
            if available ac_mstr then xcft_desc = ac_desc.
              end.
          end.  /* available xcft_det */   
                   
        end. /* if glt_det.glt_tr_tyep =JL */   

/* when xcfp_dsp_mt = no, Cash Flow maintenance screen does not display */
  if (xcfp_dsp_mt = yes and execname = "chgltrmt.p") or 
     (xcfp_dsp_sub = yes and 
      (execname = "arpamt.p" or execname = "apmcmt.p" or execname = "apvomt.p" or execname = "ardrmt.p" 
       or execname = "apcrmt.p") )
     or execname = "chcftmaa.p" 
/*CF*/      or lastkey = keycode("F12") or lastkey = keycode("CTRL-A")
  then do:  
         assign
            /* CURRENCY DEPENDENT ROUNDING NEEDS TO RETAIN GL_CTRL.  SET    */
            /* XAMT_BASE_FMT FOR BASE_CURR USAGE (WHEN XAMT IS GLT_AMT) ONE */
            /* TIME.  CAPTURE ORIGINAL FORMAT OF XAMT INTO XAMT_OLD.        */
            xamt_old = xamt:format
            xamt_base_fmt = xamt_old.
         {gprun.i ""gpcurfmt.p"" "(input-output xamt_base_fmt,
                                   input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.


    loopc:
    repeat with frame b:
/*GUI*/ if global-beam-me-up then undo, leave.

loopa:      do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

    linenum = 1.
       
    find last xcft_det where xcft_ref = glt_det.glt_ref
                         and xcft_ac_code = glt_det.glt_acc
                         and xcft_sub     = glt_det.glt_sub
                         and xcft_cc      = glt_det.glt_cc
                         and xcft_pro     = glt_det.glt_project
                         and xcft_rflag   = glt_det.glt_rflag
                         and xcft_glt_line = glt_det.glt_line
                         and xcft_domain = glt_det.glt_domain 
                         no-lock no-error.
    if available xcft_det then linenum = xcft_line + 1.
       display linenum @ xcft_line.
      
      prompt-for xcft_line editing:
      /* FIND NEXT/PREVIOUS RECORD */
/*      {mfnp.i xcft_det xcft_line xcft_line xcft_line xcft_line xcft_ref}*/
/*      {mfnp01.i xcft_det xcft_line xcft_line glt_ref xcft_ref xcft_ref} */
        {mfnp07.i xcft_det xcft_line xcft_line glt_det.glt_ref xcft_ref glt_det.glt_acct xcft_ac_code glt_det.glt_line xcft_glt_line  xcft_ref} 
	 if recno <> ? then do:
	    display xcft_line
		    xcft_acct
		    xcft_desc
		    glt_det.glt_curr.
	    
                  if glt_det.glt_curr = base_curr then do:
                     xamt:format = xamt_base_fmt.
                     display glt_det.glt_amt @ xamt.
                  end.
                  else do:
                     if glt_det.glt_curr <> old_gltcurr or (old_gltcurr ="")
                     then do:

                        /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                        {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                           "(input glt_det.glt_curr,
                             output gltcurr_rndmthd,
                             output mc-error-number)"}
                        if mc-error-number <> 0 then do:
                           {mfmsg.i mc-error-number 3}
                           pause 0.
                           next.
                        end.

                        assign
                           old_gltcurr = glt_det.glt_curr
                            /* SET XAMT FORMAT BASED ON GLTCURR_RNDMTHD */
                            xamt_gltc_fmt = xamt_old.

                         {gprun.i ""gpcurfmt.p"" "(input-output xamt_gltc_fmt,
                                                   input gltcurr_rndmthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     end.
                     xamt:format = xamt_gltc_fmt.
                     display
                        xcft_curr_amt @ xamt.
                  end.  /* else do */
                   /* GENERATE DR_CR FLAG AND XAMT */
                   {chtramt1.i &glamt=xcft_amt
			       &glcurramt=xcft_curr_amt
			       &coa=glt_det.glt_correction
		               &glcurr=glt_det.glt_curr
			       &basecurr=base_curr
			       &usecurramt=yes
			       &drcr=dr_cr
			       &dispamt=xamt}
                   display dr_cr xamt.
               end.  /* if recno <> ? and glt_tr_type <> "**" */
  
            end.  /* prompt-for glt_line editing */
        
 
            find xcft_det where xcft_ref     = glt_det.glt_ref
                            and xcft_rflag   = glt_det.glt_rflag
                            and xcft_ac_code = glt_det.glt_acc
                            and xcft_sub     = glt_det.glt_sub
                            and xcft_cc      = glt_det.glt_cc
                            and xcft_pro     = glt_det.glt_pro
                            and xcft_glt_line = glt_det.glt_line
                            and xcft_line    = input xcft_line 
                            and xcft_domain = global_domain 
                                exclusive-lock no-error.
            if not available xcft_det then do:
               xamt = 0.
               create xcft_det.
               assign xcft_ref     = glt_det.glt_ref
                      xcft_rflag   = glt_det.glt_rflag
                      xcft_ac_code = glt_det.glt_acc
                      xcft_sub     = glt_det.glt_sub
                      xcft_cc      = glt_det.glt_cc
                      xcft_pro     = glt_det.glt_pro
                      xcft_glt_line = glt_det.glt_line
                      xcft_line    = linenum
                      xcft_entity  = glt_det.glt_entity
                      xcft_domain = global_domain .
            end.

            loopd: do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

	    update xcft_acct
                   go-on("F5" "CTRL-D").

            if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
                     then do:
                     del-yn = no.
                      { mfmsg01.i 11 1 del-yn }
                  end.

            if del-yn then do:
               delete xcft_det.
               next.
               end.
         
            /* Validation Account code */
            find ac_mstr where ac_code = xcft_acct and ac_domain = global_domain
            no-lock no-error.
            if not available ac_mstr then do:
               {mfmsg.i 3052 3}
               undo loopd, retry.
            end.

              /* Validation Cash Flow Account Code */
            find first xcf2_mstr where xcf2_ac_code = xcft_acct 
                            and xcf2_active = yes
                            and xcf2_domain = global_domain
                                 no-lock no-error.
            if not available xcf2_mstr then do:
               {mfmsg.i 9845 3}
               undo loopd, retry.
            end.
            
            end.
/*GUI*/ if global-beam-me-up then undo, leave.

            
            if available ac_mstr then xcft_desc = ac_desc.
            /*xamt = 0.*/

            update xcft_desc         
                   dr_cr        
	           glt_det.glt_curr
                   xamt.

           /* GENERATE INTERNAL TRANS AMOUNT */
             {chtramt2.i &dispamt=xamt
                         &drcr=dr_cr
                         &glamt=xamt}

            /* assign glt_amt or glt_curr_amt */
            if glt_det.glt_curr = base_curr then
               assign xcft_amt = xamt
                      xcft_curr_amt = 0.
            else do:
                 xcft_curr_amt = xamt.
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input glt_det.glt_curr,
                       input base_curr,
                       input glt_det.glt_ex_rate,
                       input glt_det.glt_ex_rate2,
                       input xamt,
                       input true, /* ROUND */
                       output xcft_amt,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.
            end. /* else do: */
 
        end.
/*GUI*/ if global-beam-me-up then undo, leave.


        down 1 with frame b.

     end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* repeat */
     find first xcft_det where xcft_entity = glt_det.glt_entity
                         and xcft_ref      = glt_det.glt_ref
                         and xcft_rflag    = glt_det.glt_rflag
                         and xcft_ac_code  = glt_det.glt_acc
                         and xcft_sub     = glt_det.glt_sub
                         and xcft_cc      = glt_det.glt_cc
                         and xcft_pro     = glt_det.glt_pro
                         and xcft_glt_line = glt_det.glt_line
                         and xcft_domain = global_domain
                         no-lock no-error.
     if available xcft_det then do:
        tot_amt = 0.

     if glt_det.glt_curr = base_curr then do:
     for each xcft_det where xcft_entity   = glt_det.glt_entity
                         and xcft_ref      = glt_det.glt_ref
                         and xcft_rflag    = glt_det.glt_rflag
                         and xcft_ac_code  = glt_det.glt_acc
                         and xcft_sub     = glt_det.glt_sub
                         and xcft_cc      = glt_det.glt_cc
                         and xcft_pro     = glt_det.glt_pro
                         and xcft_glt_line = glt_det.glt_line
                         and xcft_domain = global_domain
                         no-lock:
         tot_amt = tot_amt + xcft_amt.
     end.
     if tot_amt <> glt_det.glt_amt then do:
        message "  Cash flow amt does not equal Cash Accout amout! ". pause.
    
     end.
     end.
     else do:
     for each xcft_det where xcft_entity   = glt_det.glt_entity
                         and xcft_ref      = glt_det.glt_ref
                         and xcft_rflag    = glt_det.glt_rflag
                         and xcft_ac_code  = glt_det.glt_acc
                         and xcft_sub     = glt_det.glt_sub
                         and xcft_cc      = glt_det.glt_cc
                         and xcft_pro     = glt_det.glt_pro
                         and xcft_glt_line = glt_det.glt_line
                         and xcft_domain = global_domain
                         no-lock:
         tot_amt = tot_amt + xcft_curr_amt.
     end.
     if tot_amt <> glt_det.glt_curr_amt then do:
/*XXLY*/   /*     {mfmsg.i 9846 2}   */
           message "  Cash flow amt does not equal Cash Accout amout! ". pause.
        pause.
     end.
     end.
     end. /* if available xcft_det */

     hide frame b.

end. /* if xcfp_dsp_mt = yes */




                                                                                                                                                                                                                       