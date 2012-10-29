/* GUI CONVERTED from chcfrp.p (converter v1.71) Sun Oct 21 21:39:25 2007 */
/* chcfrp.p - CAS CASH FLOW REPORT                                      */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*K1BV*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 9.1CH   LAST MODIFIED: 09/09/02   BY: XinChao Ma          */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "f+ "}

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
          define new shared variable peryr     as character format "x(8)".
          define new shared variable yr        as integer format "9999".
          define new shared variable per1      as integer.
          define new shared variable yr_end    as date.
          define new shared variable yr_beg    as date.
          define new shared variable begdt0    as date.
          define new shared variable begdt1    as date.
          define new shared variable enddt1    as date.
          define new shared variable per       as integer.

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
          entity = current_entity.
          entity1 = entity.
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
          
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
             
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
entity    colon 20  /*entity1  colon 50 label {t001.i} */
             begdt     colon 20  enddt    colon 50 label {t001.i} skip(1)
             skip(1)
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


          {wbrp01.i}

          mainloop:
          repeat:
/*             if entity1 = hi_char then entity1 = "".*/

             /* REPORT BLOCK */
             loopaa:
             do on error undo, retry:
                if c-application-mode <> 'web':u then
                   update
                      entity
                      begdt
                      enddt    
                   with frame a. 

                {wbrp06.i &command = update &fields = " entity  begdt enddt " &frm = "a"}

                if (c-application-mode <> 'web':u) or
                (c-application-mode = 'web':u and
                (c-web-request begins 'data':u)) then do:

                 /* VALIDATE DATA INPUT */
                 if enddt = ? then assign enddt = today.
                 display enddt with frame a.
                 {glper1.i enddt peryr}
                 if peryr = "" then do:
                   {mfmsg.i 3018 3}
                   /* don't define the fiscal year and 
                      fiscal period for the date given  */
                   if c-application-mode = 'web':u then return.
                    else next-prompt enddt with frame a.
                    undo, retry.
                 end.
                 yr = glc_year.
                 per1 = glc_per.
                 for first glc_cal fields (glc_end glc_per glc_start glc_year glc_domain)
		     no-lock where glc_year = yr and glc_domain = global_domain and glc_per = 1: end.
                 if not available glc_cal then do:
                   {mfmsg.i 3033 3}  /* no first period defined for thid fiscal year.*/
                   if c-application-mode = 'web':u then return.
                    undo,retry.
                      end.
                   if begdt = ? then assign begdt = glc_start.
                   display begdt with frame a.
                   if begdt < glc_start then do:
                     {mfmsg.i 27 3}  /* report cannot span fiscal year  */
                     if c-application-mode = 'web':u then return.
                       undo,retry.
                   end.
                   if begdt > enddt then do:
                     {mfmsg.i 27 3}  /* invalid date   */
                     if c-application-mode = 'web':u then return.
                       undo,retry.
                     end.
                          
                                      
                   /*VALIDATE YEAR*/
                   yr = year(begdt).
                   find first glc_cal where glc_year = yr and glc_domain = global_domain no-lock no-error.
                   if not available glc_cal then do:
                      {mfmsg.i 3033 3} /* NO FIRST PERIOD DEFINED FOR THIS
                                          FISCAL YEAR. */
                      if c-application-mode = 'web':u then return.
                      else next-prompt begdt with frame a.
                      undo mainloop, retry.
                   end.
                   assign
                      yr_beg = glc_start
                      begdt0 = begdt - 1
                      per    = glc_per.

                   /* GET DATE OF END OF YEAR */
                   find last glc_cal where glc_year = yr and glc_domain = global_domain no-lock.
                   assign
                      yr_end = glc_end
                      per1   = glc_per.
          
                end.  /* if (c-application-mode <> 'web':u) ... */
             end.  /* loopaa:  do on error undo, retry */
             entity1 = entity.

             /* SELECT PRINTER */
             {mfselprt.i "printer" 132}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


             hide frame a.

             /* CALCULATE AND DISPLAY CASH FLOW */
	     {gprun.i ""chcfrpa.p""}

 
             /*APPLY LAST KEY PRESSED TO TRAP <END>*/
             if c-application-mode <> 'web':u then do:
                apply lastkey.
                if lastkey = keycode("F4") then leave. 
             end.

             {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
  /*CLOSE OUTPUT*/
             view frame a.
          end.  /* repeat */

          {wbrp04.i &frame-spec = a}
