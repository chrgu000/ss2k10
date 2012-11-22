/* GUI CONVERTED from chglviq.p (converter v1.71) Sun Oct 21 21:39:26 2007 */
/* chglviq.p - GENERAL LEDGER TRANSACTION BY REFERENCE INQUIRY - CAS          */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 9.1CH    LAST MODIFIED: 05/08/01 BY: *XXCH911* Charles Yen       */
/* REVISION: 9.1CH    LAST MODIFIED: 01/09/02   BY: SEMMI *XC910201*     */
/* REVISION: 9.3      LAST MODIFIED: 10/11/07   BY: LinYun   ECO: *XXLY*  */
/******************************************************************************/

/*V8:DontRefreshTitle=b */
/*V8:DontRefreshTitle=c */
/*V8:DontRefreshTitle=d */
/*V8:DontRefreshTitle=e */
/*V8:DontRefreshTitle=f */

         /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         {mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE gltriq_p_1 "ÕÊ»§"
/* MaxLen: 22 Comment: */

/* ********** End Translatable Strings Definitions ********* */


         define variable glname like en_name.
         define variable ref like gltr_ref.
         define variable entity like gltr_entity.
         define variable desc1 like gltr_desc format "x(16)".
         define variable xamt as decimal format "->,>>>,>>>,>>9.99".
         define variable account as character format "x(14)"
                                      label {&gltriq_p_1}.

         define variable corr-flag like gltr_hist.gltr_correction no-undo.
         define variable eff-dt    like gltr_hist.gltr_eff_dt     no-undo.

         define variable line_status as character format "x(16)".

         define variable vchr_num like xglh_vchr_num no-undo.
         define variable vchr_yr as char format "x(4)". 
         define variable vchr_period as char format "x(2)".
         define variable begdt like glc_start no-undo.
         define variable enddt like glc_start no-undo.
	 define variable dr_cr as logical format "Dr/Cr".
	 define variable drcrtxt as char format "x(2)".

         assign line_status = getTermLabel("VOID_TRANSACTION",16).
         /* GET NAME OF CURRENT ENTITY */
/*21*/ 
         find en_mstr where en_entity = current_entity and en_domain = global_domain no-lock no-error.
         if not available en_mstr then do:
            {mfmsg.i 3059 3} /* NO PRIMARY ENTITY DEFINED */
            if c-application-mode <> 'web':u then
               pause.
            leave.
         end.
         else do:
            glname = en_name.
            release en_mstr.
         end.

         /* DISPLAY SELECTION FORM*/
         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            space(1)
            entity       view-as fill-in size 14 by 1   
            vchr_num
            vchr_yr 
            vchr_period
            ref       view-as fill-in size 14 by 1   
            with frame a width 80 no-attr-space 
         title color normal glname THREE-D /*GUI*/.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         {wbrp01.i}

         assign vchr_yr = string(year(today), "9999")
                vchr_period =  string(month(today), "99").
         display vchr_yr vchr_period with frame a.

         mainloop: repeat:
            if c-application-mode <> 'web':u then
            set entity with frame a editing:

               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp.i en_mstr entity  " en_mstr.en_domain = global_domain and 
               en_entity "  entity en_entity en_entity}
               if recno <> ? then do:
                  entity = en_entity.
                  display entity with frame a.
               end.
            end.

           {wbrp06.i &command = set &fields = "entity vchr_num vchr_yr vchr_period ref " &frm = "a"}

            if (c-application-mode <> 'web':u) or
               (c-application-mode = 'web':u
                and (c-web-request begins 'data':u)) then do:

               /* VALIDATE ENTITY */
               if entity <> ""
               and not can-find(en_mstr  where en_mstr.en_domain = 
               global_domain and  en_entity = entity)
               then do:
                  {mfmsg.i 3014 3} /* INVALID ENTITY */
                  if c-application-mode = 'web':u then return.
                  undo mainloop, retry.
               end.
            end.
            if c-application-mode <> 'web':u then
            set vchr_num vchr_yr vchr_period ref with frame a editing: 
               if frame-field = "vchr_num" then do:
                    {mfnp01.i xglh_hist vchr_num xglh_vchr_num entity  " 
                  xglh_hist.xglh_domain = global_domain and xglh_entity "  key0}
                  if recno <> ? then do:
                     vchr_num = xglh_vchr_num.
		     for first gltr_hist  where gltr_hist.gltr_domain = global_domain and  
       gltr_ref = xglh_ref and gltr_rflag = xglh_rflag no-lock: end. 
                     if available gltr_hist then
		        assign ref = gltr_ref
		               vchr_yr = string(year(gltr_eff_dt), "9999")
			       vchr_period = string(month(gltr_eff_dt), "99").
		     display vchr_num 
		             vchr_yr
			     vchr_period
			     ref
			     with frame a.
                     recno = ?.
                  end.
               end.
	       else if frame-field = "ref" then do:
   /*                 {mfnp01.i gltr_hist ref "gltr_ref and gltr_domain = global_domain" entity gltr_entity gltr_ind2} */
   {mfnp01.i gltr_hist ref gltr_ref entity  " 
                    gltr_hist.gltr_domain = global_domain and gltr_entity "  
                    gltr_ind2}
		    if recno <> ? then do:
		       assign ref = gltr_ref
			      vchr_yr = string(year(gltr_eff_dt), "9999")
			      vchr_period = string(month(gltr_eff_dt), "99").
		       find xglh_hist  where xglh_hist.xglh_domain = global_domain and  
         xglh_ref = ref and xglh_rflag = gltr_rflag no-lock no-error.
		       if available xglh_hist then 
			  assign vchr_num = xglh_vchr_num. 
		       display vchr_num 
			       vchr_yr
			       vchr_period
			       ref
			       with frame a.
		       recno = ?.
		    end.
	       end.
               else do:
                  status input.
                  readkey.
                  apply lastkey.
               end.
            end.

            if (c-application-mode <> 'web':u) or
               (c-application-mode = 'web':u
                and (c-web-request begins 'data':u)) then do:

               for first glc_cal  where glc_cal.glc_domain = global_domain and  
               glc_year = int(vchr_yr) 
                   and glc_per = int(vchr_period) no-lock: end. 
               if not available glc_cal then do:
                  {mfmsg.i 3008 3}  /* INVALID PERIOD/YEAR */
                  next-prompt vchr_yr with frame a.
                  if c-application-mode = 'web':u then return.
                  undo mainloop, retry.
               end.

               /* CLEAR FRAMES */
               hide frame b.
               hide frame c.
               hide frame d.
               hide frame e.
               hide frame f.
            end.
            /* SELECT PRINTER */
            {mfselprt.i "terminal" 80}

            /* DISPLAY INFORMATION */
            FORM /*GUI*/  xglh_vchr_num
                 gltr_ref
                 eff-dt
                 gltr_ent_dt
                 gltr_user
		 /*
                 corr-flag format "x(2)"
		 */
                 corr-flag format "Y/N"
                 /* line_status no-label */
            with STREAM-IO /*GUI*/  frame b 1 down width 80 no-attr-space.

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame b:handle).

            for each xglh_hist  where xglh_hist.xglh_domain = global_domain and 
		     xglh_entity = entity 
/*XXCH03021801*/     and (if vchr_num <> "" then xglh_vchr_num = vchr_num else true)
/*XXCH03021801*/     and (if ref <> "" then xglh_ref = ref else true)
/*XXCH03021801*
		     and (if vchr_num <> "" then xglh_vchr_num >= vchr_num else true)
		     and (if ref <> "" then xglh_ref >= ref else true)
		     and (if vchr_yr <> "" then xglh_yr = vchr_yr else true)
		     and (if vchr_period <> "" then xglh_period = vchr_period else true) 
*XXCH03021801*/
		     no-lock,
		     each gltr_hist  where gltr_hist.gltr_domain = global_domain and  
       gltr_ref = xglh_ref and
/*XXCH03021801*/     gltr_eff_dt >= glc_start and
/*XXCH03021801*/     gltr_eff_dt <= glc_end and
                     gltr_rflag = xglh_rflag no-lock
/*XXCH03021801*      use-index gltr_ind2 */
/*XXCH03021801*/      use-index gltr_ref
                     break by xglh_vchr_num 
			   by gltr_ref
                     with frame d width 80
                     no-attr-space:

                     FORM /*GUI*/  gltr_line
                          account
                          gltr_project
                          gltr_entity
                          desc1
			  dr_cr
                          xamt
                          gltr_curr
                          with STREAM-IO /*GUI*/  frame d.
                     /* SET EXTERNAL LABELS */
                     setFrameLabels(frame d:handle).
                     
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
 

                     if first-of(gltr_ref)
                     then do:
                        if gltr_tr_type = "RV"
                        then
                           /* ADDED OUTPUT PARAMETER eff-dt */
                           /* GET VALUE OF CORRECTION FLAG  */
                           run get-corr-flag (input  gltr_ref,
                                              output eff-dt,
                                              output corr-flag).
                        else
                           assign
                              eff-dt    = gltr_hist.gltr_eff_dt
                              corr-flag = gltr_hist.gltr_correction.
                        clear frame b.
			display xglh_vchr_num
                                gltr_ref
                                gltr_hist.gltr_eff_dt @ eff-dt
                                gltr_ent_dt
                                gltr_user
                                corr-flag
                        with frame b STREAM-IO /*GUI*/ .

                        clear frame d all no-pause.
                        hide frame d.
                     end.

                     corr-flag = gltr_hist.gltr_correction.
                     desc1 = gltr_desc.
                     if gltr_curr <> base_curr then xamt = gltr_curramt.
                                               else xamt = gltr_amt.
                     {glacct.i &acc=gltr_acc
			       &sub=gltr_sub
			       &cc=gltr_ctr
                               &acct=account}

                     {chtramt3.i &glamt=xamt
			         &coa=corr-flag
				 &drcr=dr_cr
				 &dispamt=xamt}
                     drcrtxt = getTermLabel(string(dr_cr, "Dr/Cr"), 2).
                     display gltr_line
                             account
                             gltr_project
                             gltr_entity
                             desc1
		             drcrtxt @ dr_cr
                             xamt
                             gltr_curr
                             with frame d STREAM-IO /*GUI*/ .

/*CF*/      /* DISPLAY UNPOSTED CASH FLOW TRANSACTION */
/*CF* Add Begin */

/*XXLY*/         find xcf_mstr where xcf_ac_code = gltr_hist.gltr_acc
        /*                 and xcf_sub      = gltr_hist.gltr_sub
                                and xcf_cc       = gltr_hist.gltr_ctr
                                and xcf_pro      = gltr_hist.gltr_project
         */                       
                        and gltr_hist.gltr_ref begins "JL"          
                        and ( if xcf_sub <> "*" then gltr_hist.gltr_sub = xcf_sub  else true )  
                        and ( if xcf_cc  <> "*" then gltr_hist.gltr_ctr = xcf_cc else true )
                        and ( if xcf_pro <> "*" then gltr_hist.gltr_project = xcf_pro else true )       
                        and xcf_active = yes       
                         and xcf_active = yes
                         and xcf_domain = global_domain
                             no-lock no-error.
/*XXLY*/         find first xcf1_mstr where xcf1_mfgc_ac_code =  gltr_hist.gltr_acc   
                      and (gltr_hist.gltr_ref begins "AP" or gltr_hist.gltr_ref begins "AR")
             	        and ( if xcf1_mfgc_sub <> "*" then gltr_hist.gltr_sub = xcf1_mfgc_sub  else true )
                      and ( if xcf1_mfgc_cc  <> "*" then gltr_hist.gltr_ctr = xcf1_mfgc_cc else true )
                      and ( if xcf1_mfgc_pro <> "*" then gltr_hist.gltr_project = xcf1_mfgc_pro else true )   
                      and xcf1_cf_acc = yes
                      and xcf1_active = yes
                      and xcf1_domain = global_domain    
                          no-lock no-error. 
/*XXLY*/     if ( (available xcf_mstr) or (available xcf1_mstr) )  then do:                      
   /*      if available xcf_mstr then do:   */
            down 1 with fram d.
            for each xcftr_hist where xcftr_entity   = gltr_hist.gltr_entity
                                and xcftr_ref      = gltr_hist.gltr_ref
                                and xcftr_rflag    = gltr_hist.gltr_rflag
                                and xcftr_ac_code  = gltr_hist.gltr_acc
                                and xcftr_sub      = gltr_hist.gltr_sub
                                and xcftr_cc       = gltr_hist.gltr_ctr
                                and xcftr_pro      = gltr_hist.gltr_project
                                and xcftr_glt_line = gltr_hist.gltr_line
                 and xcftr_domain = global_domain
                                   no-lock:

                   /* GENERATE DR_CR FLAG AND XAMT */
                   {chtramt1.i &glamt=xcftr_amt
                               &glcurramt=xcftr_curr_amt
                               &coa=gltr_hist.gltr_correction
                               &glcurr=gltr_hist.gltr_curr
                               &basecurr=base_curr
                               &usecurramt=yes
                               &drcr=dr_cr
                               &dispamt=xamt}
/*XXCH911*/        drcrtxt = getTermLabel(string(dr_cr, "Dr/Cr"), 2).

                   display /*xcftr_line @ gltr_hist.gltr_line*/
                     getTermLabelRtColon("CASHFLOW", 9) + xcftr_acct @ account
                           xcftr_desc @ desc1
                           gltr_hist.gltr_curr
                           drcrtxt @ dr_cr
                           xamt with frame d STREAM-IO /*GUI*/ .
             end. /* for each xcftr_det */

          end. /* if available xcf_mstr */
/*CF* Add End */
                     if last-of(gltr_ref) then
                        if c-application-mode <> 'web':u  and
                           dev = "terminal" then

                              pause.
                  end. /* FOR EACH GLTR_HIST */

            /* END OF LIST MESSAGE */
            {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

            {mfmsg.i 8 1}
         end. /* MAINLOOP: REPEAT */
/*K14H*/ {wbrp04.i &frame-spec = a}

/*K22V*/ PROCEDURE get-corr-flag:
/*K22V*/ /* GET THE VALUE OF CORRECTION FLAG           */

/*K22V*/    define input  parameter ref       like gltr_ref        no-undo.
/*N041*/    define output parameter eff-date  like gltr_eff_dt     no-undo.
/*K22V*/    define output parameter corr-flag like gltr_correction no-undo.
/*K22V*/    define buffer hist for gltr_hist.

/*K22V*/    for last hist
/*K22V*/       fields( gltr_domain gltr_ref gltr_correction)
/*K22V*/        where hist.gltr_domain = global_domain and  hist.gltr_ref = ref
/*K22V*/       no-lock:
/*K22V*/    end. /* FOR LAST HIST ... */
/*K22V*/    if available hist
/*K22V*/    then
/*K22V*/       assign
/*K22V*/          corr-flag = hist.gltr_correction.

/*N041*/    /* ADDED LOGIC TO GET EFF DATE FOR RV TYPE OF          */
/*N041*/    /* TRANSACTION FROM NON-REVERSING PART OF TRANSACTION  */

/*N041*/    for first hist
/*N041*/       fields( gltr_domain gltr_ref gltr_eff_dt)
/*N041*/        where hist.gltr_domain = global_domain and  hist.gltr_ref = ref
/*N041*/       no-lock:
/*N041*/    end. /* FOR FIRST HIST ... */
/*N041*/    if available hist
/*N041*/    then
/*N041*/       assign
/*N041*/          eff-date = hist.gltr_eff_dt.

/*K22V*/ END PROCEDURE. /* get-corr-flag */
