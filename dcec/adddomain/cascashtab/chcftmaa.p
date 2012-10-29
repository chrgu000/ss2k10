/* GUI CONVERTED from chcftmaa.p (converter v1.71) Sun Oct 21 21:39:25 2007 */
/* chcftmaa.p - Cash Flow Transaction Maintenance                         */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/*V8:ConvertMode=Maintenance                                              */
/*V8:RunMode=Character,Windows                                            */
/* REVISION: 9.2CH    LAST MODIFIED: 02/26/03   BY: XinChao Ma            */
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
/*CF*/ define new shared variable w-recid as recid.

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
            corr-flag colon 73 
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
/*21*/	  
   for first glt_det where glt_ref = glref and glt_domain = global_domain no-lock: end.
	     if not available glt_det then do:
                {mfmsg.i 3157 3}
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
	     for each glt_det where glt_ref = glref and glt_domain = global_domain no-lock:
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
      if glt_det.glt_tr_type = "JL" then do:  
         find first xcf_mstr where xcf_ac_code = glt_det.glt_acct
/*XXLY*/                 and (if xcf_sub <> "*" then xcf_sub = glt_det.glt_sub else true)
                         and (if xcf_cc <> "*"  then xcf_cc = glt_det.glt_cc else true)
                         and (if xcf_pro <> "*"  then xcf_pro = glt_det.glt_project else true)
                         and xcf_active = yes
                         and xcf_domain = global_domain 
                             no-lock no-error.
         if available xcf_mstr then do:
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
                                and xcft_glt_line = glt_det.glt_line
                                and xcft_domain = global_domain 
                                   no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


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
          end. /* if available xcf_mstr */
/*CF* Add End */
        end.  /*Using JL*/
       if (glt_det.glt_tr_type = "AP" or glt_det.glt_tr_type = "AR") then do:
        find first xcf1_mstr where xcf1_mfgc_ac_code = glt_det.glt_acct
/*XXLY*/                          and (if xcf1_mfgc_sub <> "*" then xcf1_mfgc_sub = glt_det.glt_sub else true)
                         and (if xcf1_mfgc_cc <> "*" then xcf1_mfgc_cc = glt_det.glt_cc else true)
                         and (if xcf1_mfgc_pro <> "*" then xcf1_mfgc_pro = glt_det.glt_project else true)
                         and xcf1_active = yes
                         and xcf1_domain = global_domain 
                             no-lock no-error.
         if available xcf1_mstr then do:
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
                                and xcft_glt_line = glt_det.glt_line
                                and xcft_domain = global_domain 
                                   no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


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
          end. /* if available xcf_mstr */
       end.            
      end.
/*GUI*/ if global-beam-me-up then undo, leave.

         for each glt_det where glt_ref = glref and glt_domain = global_domain no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


             	if glt_det.glt_tr_type = "JL" then do:              	 
/*XXLY*/        find first xcf_mstr where xcf_ac_code = glt_acct 
                            and (if xcf_sub <> "*" then xcf_sub = glt_sub else true)
                            and (if xcf_cc <> "*" then xcf_cc = glt_cc else true)
                            and (if xcf_pro <> "*" then xcf_pro = glt_project else true)
                            and xcf_domain = global_domain      
/*CF*/                      and xcf_active = yes
/*CF*/                          no-lock no-error.
/*CF*/         if available xcf_mstr then do:
/*CF*/            w-recid = recid(glt_det).          
                     {gprun.i ""chcftrmb.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*CF*/         end.
            end.   /* Using JL ref */
/*XXLY*/    if (glt_det.glt_tr_type = "AP" or glt_det.glt_tr_type = "AR") then do:
             find first xcf1_mstr where xcf1_mfgc_ac_code = glt_acct 
                            and (if xcf1_mfgc_sub <> "*" then xcf1_mfgc_sub = glt_sub else true)
                            and (if xcf1_mfgc_cc <> "*" then xcf1_mfgc_cc = glt_cc else true)
                            and (if xcf1_mfgc_pro <> "*" then xcf1_mfgc_pro = glt_project else true)
                            and xcf1_domain = global_domain      
/*CF*/                      and xcf1_active = yes
/*CF*/                          no-lock no-error.
/*CF*/         if available xcf1_mstr then do:
/*CF*/            w-recid = recid(glt_det).
                     {gprun.i ""chcftrmb.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*CF*/         end.
          end.   /* Using AP & AR*/
             end.
/*GUI*/ if global-beam-me-up then undo, leave.
   /* End Glt_det */

	  end. /* loopa */

/*N00D*/ PROCEDURE get_glt_ref:

/*N00D*/    assign undo_flag = true.
            do on endkey undo, leave:
            prompt-for glt_ref with frame chvchk-ca editing:
   /* FIND NEXT/PREVIOUS RECORD */
{mfnp.i xcft_det glt_ref xcft_ref glt_ref "xcft_det.xcft_domain = global_domain and xcft_ref" xcft_ref} 

               if recno <> ? then do:
		  for first glt_det where glt_ref = xcft_ref and glt_rflag = xcft_rflag 
/*21*/		  	and glt_domain = global_domain no-lock: end. 
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
/*L0XS*/             can-find (nr_mstr where
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
 
   