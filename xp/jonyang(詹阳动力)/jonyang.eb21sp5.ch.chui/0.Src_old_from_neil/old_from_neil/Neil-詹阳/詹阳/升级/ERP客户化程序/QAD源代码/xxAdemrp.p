/* GUI CONVERTED from ademrp.p (converter v1.71) Tue Oct  6 14:15:35 1998 */
/* ademrp.p - EMPLOYEE REPORT                                           */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert ademrp.p (converter v1.00) Fri Oct 10 13:57:05 1997 */
/* web tag in ademrp.p (converter v1.00) Mon Oct 06 14:17:21 1997 */
/*F0PN*/ /*K0V5*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      LAST MODIFIED: 01/13/86   BY: PML */
/* REVISION: 5.0      LAST MODIFIED: 04/24/91   BY: WUG *D578**/
/* REVISION: 7.0      LAST MODIFIED: 08/28/91   BY: JJS *F011**/
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   BY: bvm *K0V5**/

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*K0V5*/ {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ademrp_p_1 "工作职务!社会保险号码"
/* MaxLen: Comment: */

&SCOPED-DEFINE ademrp_p_2 "部门!项目"
/* MaxLen: Comment: */

&SCOPED-DEFINE ademrp_p_3 "家庭电话!办公室电话"
/* MaxLen: Comment: */

&SCOPED-DEFINE ademrp_p_4 "雇用日期!终止日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE ademrp_p_5 "姓名!地址"
/* MaxLen: Comment: */

&SCOPED-DEFINE ademrp_p_6 "状态"
/* MaxLen: Comment: */

&SCOPED-DEFINE ademrp_p_7 "Work Loc"
/* MaxLen: Comment: */
&SCOPED-DEFINE ademrp_p_8 "出生日期"
/* MaxLen: Comment: */
&SCOPED-DEFINE ademrp_p_9 "工段"
/* MaxLen: Comment: */
&SCOPED-DEFINE ademrp_p_10 "班组"
/* MaxLen: Comment: */
&SCOPED-DEFINE ademrp_p_11 "分厂"
/* MaxLen: Comment: */





/* ********** End Translatable Strings Definitions ********* */


     define variable addr like emp_addr.
     define variable addr1 like emp_addr.
     define variable name like emp_lname.
     define variable name1 like emp_lname.
/*K0V5*
 *      define variable empname as char format "X(36)"
 *        column-label "Name!Address".
 *      define variable phone as char format "x(21)"
 *        column-label "Home Phone!Business Phone".
 *      define variable dept as char column-label "Department!Project".
 *K0V5*/
/*K0V5*/ define variable empname as character format "X(36)"
           column-label {&ademrp_p_5}.
/*K0V5*/ define variable phone as character format "x(21)"
           column-label {&ademrp_p_3}.
/*K0V5*/ define variable dept as character column-label {&ademrp_p_2}.
     define variable emp_date as date column-label {&ademrp_p_4}.
/*K0V5*
 *   define variable wk_loc as char column-label "Work Loc".
 *   define variable title1 as char format "x(24)"
 *      column-label "Job Title!Social Security Number".
 *K0V5*/
/*K0V5*/ define variable wk_loc as character column-label {&ademrp_p_7}.
/*K0V5*/ define variable title1 as character format "x(24)"
        column-label {&ademrp_p_1}.

/*K0V5* *moved up*
 * {mfdtitle.i "e+ "}
 *K0V5*/

     
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
        
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
addr           colon 15
        addr1          label {t001.i} colon 49 skip
        name           colon 15
        name1          label {t001.i} colon 49 skip (1)
      SKIP(.4)  /*GUI*/
with frame a side-labels
/*K0V5*/ width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " Selection Criteria "
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



/*K0V5*/ {wbrp01.i}

        
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

        if addr1 = hi_char then addr1 = "".
        if name1 = hi_char then name1 = "".


/*K0V5*/ if c-application-mode <> 'web':u then
         
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


/*K0V5*/ {wbrp06.i &command = update &fields = "  addr addr1 name name1" &frm = "a"}

/*K0V5*/ if (c-application-mode <> 'web':u) or
/*K0V5*/ (c-application-mode = 'web':u and
/*K0V5*/ (c-web-request begins 'data':u)) then do:


        bcdparm = "".
        {mfquoter.i addr   }
        {mfquoter.i addr1  }
        {mfquoter.i name   }
        {mfquoter.i name1  }

        if addr1 = "" then addr1 = hi_char.
        if name1 = "" then name1 = hi_char.

/*K0V5*/ end.

        /* SELECT PRINTER  */
           
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:



        {mfphead.i}

        for each emp_mstr where (emp_addr >= addr and emp_addr <= addr1)
        and (emp_lname >= name and emp_lname <= name1)
        no-lock with frame b down width 160:

           empname = substring(emp_lname,1,length (emp_lname)) + ", "
               + substring(emp_fname,1,length (emp_fname)).
           display emp_addr empname emp_phone @ phone emp_title @ title1
          emp_dept @ dept emp_emp_date @ emp_date
          emp_status column-label {&ademrp_p_6} 
          EMP_BIRTHDAY  label  "出生日期"
                   EMP_USER2 label {&ademrp_p_9} 
                   EMP_USER1 label {&ademrp_p_10} 
                    EMP__CHR01 label {&ademrp_p_11} WITH STREAM-IO /*GUI*/ .
           down 1.
           display emp_bs_phone + " " + emp_ext format "x(21)"
/*F011*/          @ phone emp_ssn /*format "999-99-9999" */ @ title1
          emp_project @ dept emp_trm_date @ emp_date WITH STREAM-IO /*GUI*/ .
           if emp_line1 <> "" then do:
          display emp_line1 @ empname WITH STREAM-IO /*GUI*/ .
          down 1.
           end.
           if emp_line2 <> "" then do:
          display emp_line2 @ empname WITH STREAM-IO /*GUI*/ .
          down 1.
           end.
           if emp_line3 <> "" then do:
          display emp_line3 @ empname WITH STREAM-IO /*GUI*/ .
          down 1.
           end.
           if emp_city <> "" then do:
          display emp_city + ", " + emp_state
             + " " + emp_zip format "X(36)" @ empname WITH STREAM-IO /*GUI*/ .
          down 1.
           end.
           if emp_country <> "" then do:
          display emp_country @ empname WITH STREAM-IO /*GUI*/ .
          down 1.
           end.

           
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

        end.

        /* REPORT TRAILER */

        
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

     end.

/*K0V5*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" addr addr1 name name1 "} /*Drive the Report*/
