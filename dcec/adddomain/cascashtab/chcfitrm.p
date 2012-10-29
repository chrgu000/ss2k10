/* GUI CONVERTED from chcfitrm.p (converter v1.71) Sun Oct 21 21:39:25 2007 */
/* chcfitrm.p - CAS CASH FLOW initial transaction maintenance           */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*V8:ConvertMode=Maintenance                                            */
/*V8:RunMode=Character,Windows */
/* REVISION: 9.2     LAST MODIFIED:  03/20/03  by: XinChao Ma              */

{mfdtitle.i "1+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE chpbalsl_p_1 "期间"
/* MaxLen: Comment: */

&SCOPED-DEFINE chpbalsl_p_2 "日期"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

          define new shared variable entity    like gltr_entity.
          define new shared variable entity1   like gltr_entity.
          define new shared variable begdt     like gltr_eff_dt.
          define new shared variable enddt     like gltr_eff_dt.
          define variable glname             like en_name.
/*XXLY*/          define variable per_year like xcftr__qadc04 label "Period" no-undo.
          define new shared variable peryr     as character format "x(8)".
          define new shared variable yr        as integer format "9999".
          define new shared variable per1      as integer.
          define new shared variable yr_end    as date.
          define new shared variable yr_beg    as date.
          define new shared variable begdt0    as date.
          define new shared variable begdt1    as date.
          define new shared variable enddt1    as date.
          define new shared variable per       as integer.
          define variable xamt like glt_amt format "->,>>>,>>>,>>9.99".
          define variable dr_cr as logical format "Dr/Cr" initial yes.
          define        variable linenum like glt_line.
          define        variable del-yn as logical initial no.

    FORM /*GUI*/ 
      /*  xcftr_line   */   
	xcftr_acct
        xcftr_desc         
        dr_cr        
	base_curr
        xamt
    with frame b 10 down width 80 no-hide 
    title color normal (getFrameTitle("CASH_FLOW_INFORMATION",28)) THREE-D /*GUI*/.


    /* SET EXTERNAL LABELS */
    setFrameLabels(frame b:handle).

          find en_mstr where en_entity = current_entity and en_domain = global_domain 
          no-lock no-error.
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
          entity = current_entity.
/*
          /* GET RETAINED EARNINGS CODE FROM CONTROL FILE */
          find first co_ctrl where co_domain = global_domain no-lock no-error.
          if not available co_ctrl then do:
             {mfmsg.i 3032 3} /* CONTROL FILE MUST BE DEFINED BEFORE
                                 RUNNING REPORT */
             if c-application-mode <> 'web':u then
                pause.
             leave.
          end.
          assign
             ret = co_ret
             use_sub = co_use_sub
             use_cc = co_use_cc.
          release co_ctrl.
          curr = base_curr.
*/
          /* SELECT FORM */
/*XXLY*/          
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
             
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
entity    colon 35 per_year colon 50 label "period"
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



	     /* SET EXTERNAL LABELS */
	     setFrameLabels(frame a:handle).

          mainloop:
          repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


             /* REPORT BLOCK */
             loopaa:
             do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                if c-application-mode <> 'web':u then
                   update
/*XXLY*/                      entity per_year
                   with frame a. 

                  /* VERIFY ENTITY */
              find en_mstr where en_entity = input entity and en_domain = global_domain
              no-lock no-error.
                  if not available en_mstr then do:
                    {mfmsg.i 3061 3} /* INVALID ENTITY */
                    undo.
                  end.
           
 
    loopc:
    repeat with frame b:
/*GUI*/ if global-beam-me-up then undo, leave.

     loopa:      do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

     
/*
     linenum = 1.
         find last xcftr_hist where xcftr_ref = "cashflowinitial"
                         no-lock no-error.
    if available xcftr_hist then linenum = xcftr_line + 1.
       display linenum @ xcftr_line.

      prompt-for xcftr_line editing:
*/
      assign xcftr_acct:screen-value = ""
             xcftr_desc:screen-value = ""
             xamt:screen-value = "".

      prompt-for xcftr_acct /*go-on("F5" "CTRL-D")*/ editing:
      /* FIND NEXT/PREVIOUS RECORD */
      /*{mfnp01.i xcftr_hist xcftr_line xcftr_line xcftr_ref ""cashflowinitial"" xcftr_ref}  */
/*XXLY*/      {mfnp01.i xcftr_hist xcftr_acct "xcftr__qadc04 = per_year and xcftr_hist.xcftr_domain = global_domain and xcftr_acct"
      xcftr_ref ""cashflowinitial""
     xcftr_acct}
     
	 if recno <> ? then do:
	    display /*xcftr_line*/
		    xcftr_acct
		    xcftr_desc
		    base_curr.

                   if xcftr_amt >= 0 then assign dr_cr = yes
                                                  xamt = xcftr_amt.
                   else assign dr_cr = no
                                xamt = (-1) * xcftr_amt.

                   display dr_cr xamt.
               end.  /* if recno <> ? */
            end.  /* prompt-for glt_line editing */

            find xcftr_hist where xcftr_ref     = "cashflowinitial"
                              and xcftr_entity  = current_entity
                              /*and xcftr_line    = input xcftr_line */
                              and xcftr_acct    = input xcftr_acct
/*XXLY*/                      and xcftr__qadc04 = per_year
                              and xcftr_domain = global_domain
/*XXLY*/                             and xcftr__qadc04 = per_year
                                exclusive-lock no-error.
            if not available xcftr_hist then do:
               xamt = 0.
               linenum = 1.

               find last xcftr_hist where xcftr_ref = "cashflowinitial"
                         and xcftr_domain = global_domain
/*XXLY*/                 and xcftr__qadc04 = per_year 
                         no-lock no-error.
               if available xcftr_hist then do:
               linenum = xcftr_line + 1.
              end.
               create xcftr_hist.
               assign xcftr_ref    = "cashflowinitial"
                      xcftr_line   = linenum
                      xcftr_acct
                      xcftr_entity  = entity
/*XXLY*/              xcftr__qadc04 = per_year
                      xcftr_domain = global_domain.
            end.
            else do:
                   if xcftr_amt >= 0 then assign dr_cr = yes
                                                  xamt = xcftr_amt.
                   else assign dr_cr = no
                                xamt = (-1) * xcftr_amt.
                   display xcftr_acct xcftr_desc dr_cr xamt.


            end.

            /* Validation Account code */
            find ac_mstr where ac_code = xcftr_acct and ac_domain = global_domain 
            no-lock no-error.
            if not available ac_mstr then do:
               {mfmsg.i 3052 3}
               undo loopa, retry.
            end.

             /* Validation Cash Flow Account Code */
            find first xcf2_mstr where xcf2_ac_code = xcftr_acct 
                            and xcf2_active = yes
                            and xcf2_domain = global_domain
                                 no-lock no-error.
            if not available xcf2_mstr then do:
               {mfmsg.i 9945 3}
               undo loopa, retry.
            end.
            
            if available ac_mstr then xcftr_desc = ac_desc.
            /*xamt = 0.*/

            update xcftr_desc         
                   dr_cr        
                   xamt
                   go-on("F5" "CTRL-D").

            if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
                     then do:
                     del-yn = no.
                      { mfmsg01.i 11 1 del-yn }
                  end.

            if del-yn then do:
               delete xcftr_hist.
               next.
               end.

           /* GENERATE INTERNAL TRANS AMOUNT */
             {chtramt2.i &dispamt=xamt
                         &drcr=dr_cr
                         &glamt=xamt}

            /* assign glt_amt or glt_curr_amt */
               assign xcftr_desc
                      xcftr_amt = xamt
                      xcftr_curr_amt = 0.
 
        end.
/*GUI*/ if global-beam-me-up then undo, leave.


        down 1 with frame b.

     end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* repeat */

     hide frame b.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* loopaa:  do on error undo, retry */

end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* repeat */

