/* GUI CONVERTED from chvchrca.i (converter v1.71) Sun Oct 21 21:39:26 2007 */
/* chvchrca.i - INCLUDE FILE FOR VOUCHER CHECK AND APPROVE PROGRAMES      */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/*V8:ConvertMode=Maintenance                                            */
/*V8:RunMode=Character,Windows                                          */
/* REVISION: 9.1CH    LAST MODIFIED: 04/26/01   BY: *XXCH911 Charles Yen  */
/* REVISION: 9.1CH    LAST MODIFIED: 01/09/02   BY: SEMMI *XC910201*     */
/* REVISION: 9.3      LAST MODIFIED: 10/11/07   BY: LinYun   ECO: *XXLY*  */
/**************************************************************************/

          /* DISPLAY TITLE */
          {mfdtitle.i "b+ "}
          {gldydef.i "new"}
          {gldynrm.i "new"}

/* ********** Begin Translatable Strings Definitions ********* */

/* ********** End Translatable Strings Definitions ********* */

          define variable conf-yn      like mfc_logical initial no.
          define variable glname       like en_name.
	  define variable glref        like gltr_ref.
	  define variable coa_ref      like glt_ref.
	  define variable account      as character format "x(14)".
	  define variable xamt         like glt_amt format "->>>,>>>,>>9.99".
	  define variable descx        like glt_desc format "x(19)".
	  define variable dr_cr        as  logical format "Dr/Cr" init "Dr" label "D/C".
	  define variable tr_type      like glt_tr_type.
	  define variable per_yr       as char format "x(7)".
	  define variable ctrl_curr    like gltr_curr.
	  define variable ctrl_amt     like glt_amt.
	  define variable disp_curr    like glt_curr.
	  define variable tot_amt      like glt_amt.
	  define variable corr-flag    as logical format "Y/N".
	  define variable undo_flag    like mfc_logical no-undo. 
          define variable eff_dt_ch    as character format "x(8)".
	  define variable l_daybook_flag like mfc_logical.
	  define variable new_eff_date like glt_effdate.  
	  define variable msg_stat     as char format "x(8)". 
/*CF*/ define var tot_xamt as decimal format "->,>>>,>>>,>>9.99".

          /* DISPLAY SELECTION FORM */
          FORM /*GUI*/ 
	    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
glt_ref
                  view-as fill-in size 14 by 1   
            tr_type
	    eff_dt_ch colon 50
            per_yr colon 68
 	    skip
	    space(1)
	    ctrl_curr
	    ctrl_amt colon 23
	    disp_curr no-label
	    tot_amt  colon 55
	    skip  space(2) dft-daybook
	    nrm-seq-num
            skip coa_ref colon 23 conf-yn colon 60 corr-flag colon 73
	     SKIP(.4)  /*GUI*/
with side-labels frame chvchk-ca width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-chvchk-ca-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame chvchk-ca = F-chvchk-ca-title.
 RECT-FRAME-LABEL:HIDDEN in frame chvchk-ca = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame chvchk-ca =
  FRAME chvchk-ca:HEIGHT-PIXELS - RECT-FRAME:Y in frame chvchk-ca - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME chvchk-ca = FRAME chvchk-ca:WIDTH-CHARS - .5.  /*GUI*/


          FORM /*GUI*/ 
            glt_line            space(.5)   
	    account             view-as text size 14 by 1 space(.5)   
                          /*V8+*/
	    glt_project         space(.5)   
	    glt_entity          space(.5)   
	    descx               space(.5)   
	    dr_cr               space(.5)   
 	    glt_curr            space(.5)   
	    xamt
	    with frame chcoamt-b down width 80 no-hide THREE-D /*GUI*/.


          /* SET EXTERNAL LABELS */
          setFrameLabels(frame chvchk-ca:handle).
          setFrameLabels(frame chcoamt-b:handle).

          view frame chvchk-ca.

          ststatus = stline[3].
          status input ststatus.
          loopa:
          repeat:
	    
	     nrm-seq-num = "".

	     run get_glt_ref.
	     if keyfunc(lastkey) = "ENDKEY" then undo_flag = true.
	     if undo_flag = true then do:
		undo loopa, leave loopa.
             end.

             assign corr-flag = no
		    coa_ref = "".
             clear frame chcoamt-b all no-pause.
	     for first glt_det  where glt_det.glt_domain = global_domain and  glt_ref 
      = glref no-lock: end.
	     if not available glt_det then do:
                {mfmsg.i 3157 3}
	        undo, next loopa. 
	     end.
	     find xglt_det  where xglt_det.xglt_domain = global_domain and  xglt_ref = 
      glt_ref and xglt_rflag = glt_rflag exclusive-lock no-error.
	     if not available xglt_det then do:
                {chxgltcr.i &entity=glt_entity
		            &ref=glt_ref
			    &rflag=glt_rflag
		            &trtype=glt_tr_type
		            &userid=glt_userid
			    &refresh=no}
	     end.
	     if xglt_vchr_status <> "{&currstat}" then do:
		if "{&currstat}" = "CREATED" then do:
                {pxmsg.i &MSGNUM=9836}   
		end.
                else if "{&currstat}"="CHECKED" then do:
                {pxmsg.i &MSGNUM=9844}   
		end.
		undo, next loopa.
	     end.
             {glper1.i glt_effdate per_yr} /*GET PERIOD/YEAR*/
	     assign new_eff_date = glt_effdate. 
             display glt_ref
                     glt_tr_type @ tr_type
                     string(glt_effdate) @ eff_dt_ch
                     per_yr
                     base_curr @ ctrl_curr
                     disp_curr
                     glt_correction @ corr-flag
                     glt_dy_code @ dft-daybook
                     glt_dy_num @ nrm-seq-num
                     with frame chvchk-ca.
                  recno = ?.
	     for each glt_det  where glt_det.glt_domain = global_domain and  glt_ref = 
      glref no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

	         {glacct.i &acc=glt_acc &sub=glt_sub &cc=glt_cc &acct=account}	
		 corr-flag = glt_correction.
                 {chtramt1.i &glamt=glt_amt
		             &glcurramt=glt_curr_amt
		             &coa=glt_correction
		             &glcurr=glt_curr
		             &basecurr=base_curr
		             &usecurramt=yes
		             &drcr=dr_cr
		             &dispamt=xamt}
                 if xglt_coa_ref <> "" then coa_ref = xglt_coa_ref.
		 display glt_line
			 account
			 glt_project
			 glt_entity 
			 glt_desc @ descx
			 dr_cr
			 glt_curr 
			 xamt 
	   	         with frame chcoamt-b.
                 down 1 with frame chcoamt-b.

/*CF*/      /* DISPLAY UNPOSTED CASH FLOW TRANSACTION */
/*CF* Add Begin */

         find xcf_mstr where xcf_ac_code = glt_det.glt_acct
  /*       and xcf_sub      = glt_det.glt_sub
         and xcf_cc       = glt_det.glt_cc
         and xcf_pro      = glt_det.glt_project
   */
/*XXLY*/                and glt_det.glt_ref begins "JL"          
                        and ( if xcf_sub <> "*" then glt_det.glt_sub = xcf_sub  else true )  
                        and ( if xcf_cc  <> "*" then glt_det.glt_cc = xcf_cc else true )
                        and ( if xcf_pro <> "*" then glt_det.glt_project = xcf_pro else true )        
         and xcf_domain = global_domain
                         and xcf_active = yes
                             no-lock no-error.
/*XXLY*/         find first xcf1_mstr where xcf1_mfgc_ac_code =  glt_det.glt_acct   
                      and (glt_det.glt_ref begins "AP" or glt_det.glt_ref begins "AR")
             	        and ( if xcf1_mfgc_sub <> "*" then glt_det.glt_sub = xcf1_mfgc_sub  else true )
                      and ( if xcf1_mfgc_cc  <> "*" then glt_det.glt_cc = xcf1_mfgc_cc else true )
                      and ( if xcf1_mfgc_pro <> "*" then glt_det.glt_project = xcf1_mfgc_pro else true )   
                      and xcf1_cf_acc = yes
                      and xcf1_active = yes
                      and xcf1_domain = global_domain    
                          no-lock no-error. 
/*XXLY*/     if ( (available xcf_mstr) or (available xcf1_mstr) )  then do: 
  /*       if available xcf_mstr then do:  */
     /*       down 1 with fram f-a.*/
          display getTermLabelRtColon("CASHFLOW", 9)  @ account 
                    with frame chcoamt-b.
              down 1 with frame chcoamt-b.  
            tot_xamt = 0.
            for each xcft_det where xcft_entity   = glt_det.glt_entity 
                                and xcft_ref      = glt_det.glt_ref
                                and xcft_rflag    = glt_det.glt_rflag
                                and xcft_ac_code  = glt_det.glt_acct
                                and xcft_sub      = glt_det.glt_sub
                                and xcft_cc       = glt_det.glt_cc
                                and xcft_pro      = glt_det.glt_project
                    and xcft_domain = global_domain
                                and xcft_glt_line = glt_det.glt_line
                                   no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

/*
                if glt_det.glt_curr = base_curr then
                   tot_xamt = tot_xamt + xcft_amt.
                else tot_xamt = tot_xamt + xcft_curr_amt.
*/
                   /* GENERATE DR_CR FLAG AND XAMT */
                   {chtramt1.i &glamt=xcft_amt
                               &glcurramt=xcft_curr_amt
                               &coa=glt_det.glt_correction
                               &glcurr=glt_det.glt_curr
                               &basecurr=base_curr
                               &usecurramt=yes
                               &drcr=dr_cr
                               &dispamt=xamt}

                   display /*xcft_line @ glt_det.glt_line*/
                           xcft_acct @ account
                           xcft_desc @ descx
                           glt_det.glt_curr
                           dr_cr
                           xamt with frame chcoamt-b.
                      down 1 with frame chcoamt-b.
             end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* for each xcft_det */
/*
             if glt_det.glt_curr = base_curr then
                if glt_det.glt_amt <> tot_xamt then cfunpost = yes.
             if glt_det.glt_curr <> base_curr then
                if glt_det.glt_curr_amt <> tot_xamt then cfunpost = yes.
*/
          end. /* if available xcf_mstr */
/*CF* Add End */
             end.
/*GUI*/ if global-beam-me-up then undo, leave.


	     assign conf-yn = no.
	     display coa_ref conf-yn with frame chvchk-ca.
	     loopb:
	     repeat on endkey undo, leave loopb:
/*GUI*/ if global-beam-me-up then undo, leave.

	       update conf-yn with frame chvchk-ca.  
	       if conf-yn then do:
                  assign xglt_det.xglt_vchr_status = "{&newstat}". 
                  if "{&newstat}" = "CHECKED" then do:
		     assign xglt_det.xglt_chk_id = global_userid 
		            xglt_det.xglt_chk_date = today
		            xglt_det.xglt_chk_time = string(TIME, "HH:MM:SS").
                  end.
                  if "{&newstat}" = "APPROVED" then do:
		     assign xglt_det.xglt_apprv_id = global_userid 
		            xglt_det.xglt_apprv_date = today
		            xglt_det.xglt_apprv_time = string(TIME, "HH:MM:SS").
                  end.
	       end.
	       leave loopb.
             end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* loopb */
	  end. /* loopa */

/*N00D*/ PROCEDURE get_glt_ref:

/*N00D*/    assign undo_flag = true.
            do on endkey undo, leave:
            prompt-for glt_ref with frame chvchk-ca editing:
               /* FIND NEXT/PREVIOUS RECORD */
	       {mfnp05.i xglt_det key0 " xglt_det.xglt_domain = global_domain and 
        xglt_vchr_status  =""{&currstat}""" xglt_ref "input glt_ref"}
               if recno <> ? then do:
		  for first glt_det  where glt_det.glt_domain = global_domain and  glt_ref = 
    xglt_ref and glt_rflag = xglt_rflag no-lock: end. 
               if available glt_det then do:

                  {glper1.i glt_effdate per_yr} /*GET PERIOD/YEAR*/
                  display glt_ref
                          glt_tr_type @ tr_type
                          string(glt_effdate) @ eff_dt_ch
                          per_yr
                          base_curr @ ctrl_curr
                          disp_curr
                          glt_correction @ corr-flag
                          glt_dy_code @ dft-daybook
                          glt_dy_num @ nrm-seq-num
                  with frame chvchk-ca.
                  recno = ?.

/*L0XS*/          if glt_dy_code <> "" and
/*L0XS*/             can-find (nr_mstr  where nr_mstr.nr_domain = global_domain 
and 
/*L0XS*/                       nr_seqid = glt_dy_code)
/*L0XS*/          then
/*L0XS*/             assign
/*L0XS*/                l_daybook_flag = yes.
/*L0XS*/          else
/*L0XS*/             assign
/*L0XS*/                l_daybook_flag = no.

                  end. /* if available glt_det */

               end.
/* /*N00D*/       assign undo_flag = false.*/
               glref = input glt_ref.
            end.  /* prompt-for glt_ref editing */
                  assign undo_flag = false.
          end. /* do on endkey undo */

/*N00D*/ END PROCEDURE.
 
