/*yymerp.p user menu report. */

/*V8:ConvertMode=FullGUIReport                                                */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "121105.1"}
{cxcustom.i "yymerp.p"}

define new shared variable lang  like lng_lang.
define new shared variable nbr   as integer format ">>>" label "Menu Number".
define new shared variable nbr1  as integer format ">>>".
define new shared variable menunbr as character.
define new shared variable usr like usr_userid.
define new shared variable usr1 like usr_userid.
   

lang = global_user_lang.

/* SELECT FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/

 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
   lang            colon 20
   skip(1)
   nbr             colon 20
   nbr1 label      {t001.i} colon 35
   skip(1)
   usr             colon 20
   usr1 label      {t001.i} colon 35
 SKIP(.4)  /*GUI*/
with frame a side-labels attr-space
   width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF DEFINED(GPLABEL_I)=0 &THEN
   &IF (DEFINED(SELECTION_CRITERIA) = 0)
   &THEN " Selection Criteria "
   &ELSE {&SELECTION_CRITERIA}
   &ENDIF
&ELSE
   getTermLabel("SELECTION_CRITERIA", 25).
&ENDIF.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
{&MGMERP-P-TAG1}

/* REPORT BLOCK */

/*GUI*/ {mfguirpa.i true "printer" 132 " " " " " "  }

/*GUI repeat  with frame a: */
/*GUI*/ procedure p-enable-ui:


   menunbr = "0".
   if nbr1 = 99 then nbr1 = 0.
   IF usr1 = hi_char THEN usr1 = "".

   /* ENTER MENU NUMBER AS BLANK/ZERO TO DISPLAY UI MENUS */
   {pxmsg.i &MSGNUM=20008 &ERRORLEVEL=1}

   if c-application-mode <> 'web' then

run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   {wbrp06.i &command = update &fields = "  lang nbr nbr1 usr usr1"
      &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i lang   }
      {mfquoter.i nbr    }
      {mfquoter.i nbr1   }
      {mfquoter.i usr    }
      {mfquoter.i usr1   }

      if (nbr = 0 and nbr1 = 0)
      then
         menunbr = "".
      else
         menunbr = "0".

      if nbr1 = 0 then nbr1 = 999.
      IF usr1 = "" THEN usr1 = hi_char.

   end.

   /* OUTPUT DESTINATION SELECTION */

/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 "nopage" " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:




   {mfphead.i}

  for each usr_mstr NO-LOCK WHERE usr_userid >= usr AND usr_userid <= usr1,
          EACH mnd_det NO-LOCK WHERE mnd_exec >= "AA" AND mnd_exec <= "ZZZZZ" 
            AND (mnd_canrun = "*" OR INDEX(mnd_canrun,usr_userid) > 0),
          EACH mnt_det NO-LOCK WHERE mnt_nbr = mnd_nbr 
            AND mnt_select = mnd_select
            AND mnt_lang = lang WITH frame b WIDTH 500 :
				            
				/* SET EXTERNAL LABELS */
				setFrameLabels(frame b:handle).

       DISPLAY usr_userid usr_name 
       				 mnd_nbr + "." + trim(STRING(mnd_select,">>9")) @ mnd_nbr
       				 mnt_label mnd_exec mnd_canrun WITH STREAM-IO.
    
  end.

   /* REPORT TRAILER */

/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

end.

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" lang nbr nbr1 usr usr1 "} /*Drive the Report*/
