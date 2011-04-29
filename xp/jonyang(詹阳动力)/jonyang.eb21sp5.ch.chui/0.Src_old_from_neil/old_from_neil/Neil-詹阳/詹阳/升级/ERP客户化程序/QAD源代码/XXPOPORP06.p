/* GUI CONVERTED from poporp06.p (converter v1.71) Tue Oct  6 14:37:31 1998 */
/* poporp06.p - PURCHASE ORDER RECEIPTS REPORT                          */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert poporp06.p (converter v1.00) Tue Sep 30 11:59:58 1997 */
/* web tag in poporp06.p (converter v1.00) Mon Sep 29 14:35:30 1997 */
/*F0PN*/ /*K0KK*/ /*V8#ConvertMode=WebReport                               */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 4.0     LAST MODIFIED: 03/15/88    BY: FLM       */
/* REVISION: 4.0     LAST MODIFIED: 02/12/88    BY: FLM *A175**/
/* REVISION: 4.0     LAST MODIFIED: 11/01/88    BY: FLM *A508**/
/* REVISION: 5.0     LAST MODIFIED: 02/23/89    BY: RL  *B047**/
/* REVISION: 6.0     LAST MODIFIED: 05/24/90    BY: WUG *D002**/
/* REVISION: 6.0     LAST MODIFIED: 08/14/90    BY: RAM *D030**/
/* REVISION: 6.0     LAST MODIFIED: 11/06/90    BY: MLB *B815**/
/* REVISION: 5.0     LAST MODIFIED: 02/12/91    BY: RAM *B892**/
/* REVISION: 6.0     LAST MODIFIED: 06/26/91    BY: RAM *D676**/
/* REVISION: 7.0     LAST MODIFIED: 07/29/91    BY: MLV *F001**/
/* REVISION: 7.0     LAST MODIFIED: 03/18/92    BY: TMD *F261**/
/* REVISION: 7.3     LAST MODIFIED: 10/13/92    BY: tjs *G183**/
/* REVISION: 7.3     LAST MODIFIED: 01/05/93    BY: MPP *G481**/
/* REVISION: 7.3     LAST MODIFIED: 12/02/92    BY: tjs *G386**/
/* REVISION: 7.4     LAST MODIFIED: 12/17/93    BY: dpm *H074**/
/* REVISION: 7.3     LAST MODIFIED: 10/18/94    BY: jzs *GN91**/
/* REVISION: 8.5     LAST MODIFIED: 11/15/95    BY: taf *J053**/
/* REVISION: 8.5     LAST MODIFIED: 02/12/96    BY: *J0CV* Robert Wachowicz*/
/* REVISION: 8.6     LAST MODIFIED: 10/03/97    BY: mur *K0KK**/

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan      */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*GN91*/ {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE poporp06_p_1 "仅收据估价结算项"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp06_p_2 "排序方法"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


/*J0CV*/ define variable ers-only like mfc_logical no-undo.

/*H074*/ {poporp06.i new}

/*H074*/ /* PICK UP DEFAULTS FROM THE LNGD_DET FILED */
/*H074*/ /* DEFAULT FOR sort_by IS EFFECTIVE */
/*H074*/ {gplngn2a.i &file     = ""poporp06.p""
                     &field    = ""sort_by""
                     &code     = sort_by_code
                     &mnemonic = sort_by
                     &label    = sort_by_desc}

         /* DISPLAY TITLE */

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
                
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
rdate          colon 15
                rdate1         label {t001.i} colon 49 skip
                vendor         colon 15
                vendor1        label {t001.i} colon 49 skip
                part           colon 15
                part1          label {t001.i} colon 49 skip
                site           colon 15
                site1          label {t001.i} colon 49
/**J0CV**       skip (1) **/

/*H074*/        fr_ps_nbr      colon 15
/*H074*/        to_ps_nbr      label {t001.i} colon 49 skip (1)
                sel_inv        colon 20
                sel_sub        colon 20
/*J0CV*/        ers-only       colon 20 label {&poporp06_p_1}
                sel_mem        colon 20 skip (1)
                uninv_only     colon 20
                use_tot        colon 20
                show_sub       colon 20
                base_rpt       colon 20
/*H074*         sortbypo       colon 20 skip */
/*H074*/        sort_by        colon 20  label {&poporp06_p_2}
/*H074*/        sort_by_desc  colon 49 no-label
/**J0CV**       skip **/
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " 选择条件 "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*H074*/ display sort_by_desc
         with frame a.

/*K0KK*/ {wbrp01.i}
         
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

/*GN91     do:*/
               if rdate = low_date then rdate = ?.
               if rdate1 = hi_date then rdate1 = today.
               if vendor1 = hi_char then vendor1 = "".
               if part1 = hi_char then part1 = "".
               if site1 = hi_char then site1 = "".
/*H074*/       if to_ps_nbr = hi_char then to_ps_nbr = "".



/*K0KK*/ if c-application-mode <> 'web':u then

run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


/*K0KK*/ {wbrp06.i &command = update &fields = "  rdate rdate1 vendor vendor1
part part1 site site1  fr_ps_nbr to_ps_nbr sel_inv sel_sub  ers-only sel_mem uninv_only
use_tot show_sub base_rpt  sort_by" &frm = "a"}

/*K0KK*/ if (c-application-mode <> 'web':u) or
/*K0KK*/ (c-application-mode = 'web':u and
/*K0KK*/ (c-web-request begins 'data':u)) then do:

/*H074*/       /* VALIDATE SORT_BY MNEMONIC AGAINST lngd_det */
/*H074*/       {gplngv.i &file     = ""poporp06.p""
                         &field    = ""sort_by""
                         &mnemonic = sort_by
                         &isvalid  = valid_mnemonic}
/*H074*/       if not valid_mnemonic then do:
/*H074*/          {mfmsg02.i 3169 3 sort_by} /* INVALID MNEMONIC sort_by */
/*H074*/
/*K0KK*/ if c-application-mode = 'web':u then return.
else /*GUI NEXT-PROMPT removed */
/*H074*/          /*GUI UNDO removed */ RETURN ERROR.
/*H074*/       end.

/*H074*/       /* GET CODES FROM lngd_det FOR MNEMONICS */
/*H074*/       {gplnga2n.i &file  = ""poporp06.p""
                           &field = ""sort_by""
                           &mnemonic = sort_by
                           &code = sort_by_code
                           &label = sort_by_desc}
/*H074*/       display sort_by_desc with frame a.

               bcdparm = "".
               {mfquoter.i rdate     }
               {mfquoter.i rdate1    }
               {mfquoter.i vendor    }
               {mfquoter.i vendor1   }
               {mfquoter.i part      }
               {mfquoter.i part1     }
               {mfquoter.i site      }
               {mfquoter.i site1     }
/*H074*/       {mfquoter.i fr_ps_nbr }
/*H074*/       {mfquoter.i to_ps_nbr }
               {mfquoter.i sel_inv   }
               {mfquoter.i sel_sub   }
/*J0CV*/       {mfquoter.i ers-only }
               {mfquoter.i sel_mem   }
               {mfquoter.i uninv_only}
               {mfquoter.i use_tot   }
               {mfquoter.i show_sub  }
               {mfquoter.i base_rpt  }
               {mfquoter.i sort_by   }

               if rdate = ? then rdate = low_date.
               if rdate1 = ? then rdate1 = today.
               if vendor1 = "" then vendor1 = hi_char.
               if part1 = "" then part1 = hi_char.
               if site1 = "" then site1 = hi_char.
/*H074*/       if to_ps_nbr = ""  then to_ps_nbr = hi_char.


/*K0KK*/ end.

/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:



               {mfphead.i}
/*GN91      end. */

/*J053*/    oldcurr = "".
            loopb:
            do on error undo , leave:
/*H074*/       if sort_by_code = "1" then do on error undo , leave loopb:

/**J0CV** /*H074*/          {gprun.i ""xxpoporp6a.p""} **/
/*J0CV*/          {gprun.i ""xxpoporp6a.p"" "(input ers-only)" }

/*H074*/       end.
/*H074*/       if sort_by_code = "2" then do on error undo , leave loopb:

/**J0CV** /*H074*/          {gprun.i ""xxpoporp6b.p""} **/
/*J0CV*/          {gprun.i ""xxpoporp6b.p"" "(input ers-only)" }

/*H074*/       end.
/*H074*/       if sort_by_code = "3" then do on error undo , leave loopb:

/**J0CV** /*H074*/          {gprun.i ""xxpoporp6c.p""} **/
/*J0CV*/          {gprun.i ""xxpoporp6c.p"" "(input ers-only)" }

/*H074*/       end.
            end.
            
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

            hide message no-pause.
            {mfmsg.i 9 1}
         end.

/*K0KK*/ /*V8+*/

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" rdate rdate1 vendor vendor1 part part1 site site1  fr_ps_nbr to_ps_nbr sel_inv sel_sub  ers-only sel_mem uninv_only use_tot show_sub base_rpt  sort_by "} /*Drive the Report*/
