/* GUI CONVERTED from ettotfrm.i (converter v1.71) Fri Jun 12 13:32:18 1998 */
/* ettotfrm.i - DEFINE FORM GTM SALES ORDER TRAILER INCLUDE FILE        */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*G0XY*/ /*V8:ConvertMode=ReportAndMaintenance                          */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* REVISION: 7.4            CREATED: 06/01/93   BY: bcm *H002* */
/*                    DATE MODIFIED: 09/03/94   BY: wug *GB74* */
/*                    DATE MODIFIED: 09/03/94   BY: srk *FQ79* */
/* REVISION: 8.5           MODIFIED: 07/14/95   BY: taf *J053* */
/* Old patch markers are for reference only, file created from sototfrm.i */
/* REVISION: 8.6E           CREATED: 05/05/98   BY: *L00L* evdg         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 06/04/98   BY: *L01M* Jean Miller  */

/*L01M*/ /*Fixes various standards violations, abbreviation, and
           indentation problems, many of these fixes were done without
           patch markers, please use RCS if you want to see prior
           version of the file */

           FORM /*GUI*/ 
              

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
nontaxable_amt           colon 12
              so_curr LABEL "货币"
              line_total               colon 60 no-attr-space
              taxable_amt              colon 12
              so_disc_pct              to 49 no-label
              disc_amt                 colon 60 no-attr-space
              tax_date       LABEL "纳税日期"            colon 12
              user_desc[1]             to 53 no-label
              so_trl1_cd format "x(2)" to 58 no-label
              ":"                      at 60
              so_trl1_amt                    no-label
              user_desc[2]             to 53 no-label
              so_trl2_cd format "x(2)" to 58 no-label
              ":"                      at 60
              so_trl2_amt                    no-label
              invcrdt                  at 3  no-label
              user_desc[3]             to 53 no-label
              so_trl3_cd format "x(2)" to 58 no-label
              ":"                      at 60
              so_trl3_amt                    no-label
              tax_amt                  colon 60 skip
              tax_edit_lbl format "x(28)"    no-label no-attr-space to 30
              tax_edit                 at 32 no-label
              ord_amt                  colon 60 skip
           

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame sotot side-labels width 80 attr-space
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-sotot-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame sotot = F-sotot-title.
 RECT-FRAME-LABEL:HIDDEN in frame sotot = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame sotot =
  FRAME sotot:HEIGHT-PIXELS - RECT-FRAME:Y in frame sotot - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME sotot = FRAME sotot:WIDTH-CHARS - .5.  /*GUI*/
&ENDIF /*GUI*/


           FORM /*GUI*/ 
              

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
nontaxable_amt           colon 12
              so_curr
              line_total               colon 60 no-attr-space
              et_line_total            at 80    no-attr-space no-label
              taxable_amt              colon 12
              so_disc_pct              to 49    no-label
              disc_amt                 colon 60 no-attr-space
              et_disc_amt              at 80    no-attr-space no-label
              tax_date                 colon 12
              user_desc[1]             to 53    no-label
              so_trl1_cd format "x(2)" to 58    no-label
              ":"                      at 60
              so_trl1_amt                       no-label
              et_trl1_amt                       no-label
              user_desc[2]             to 53    no-label
              so_trl2_cd format "x(2)" to 58    no-label
              ":"                      at 60
              so_trl2_amt                       no-label
              et_trl2_amt                       no-label
              invcrdt                  at 3     no-label
              user_desc[3]             to 53    no-label
              so_trl3_cd format "x(2)" to 58    no-label
              ":"                      at 60
              so_trl3_amt                       no-label
              et_trl3_amt                       no-label
              tax_amt                  colon 60
              et_tax_amt               at 80    no-label
              skip
              tax_edit_lbl format "x(28)"       no-label no-attr-space to 30
              tax_edit                 at 32    no-label
              ord_amt                  colon 60
              et_ord_amt               at 80    no-label
              skip
           

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame sototeuro side-labels width 132 attr-space
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-sototeuro-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame sototeuro = F-sototeuro-title.
 RECT-FRAME-LABEL:HIDDEN in frame sototeuro = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame sototeuro =
  FRAME sototeuro:HEIGHT-PIXELS - RECT-FRAME:Y in frame sototeuro - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME sototeuro = FRAME sototeuro:WIDTH-CHARS - .5.  /*GUI*/
&ENDIF /*GUI*/


           /* ASSIGN CURRENCY DEPENDENT FORMATS */
           assign
              nontaxable_amt:format in frame sotot = nontax_fmt
              taxable_amt:format    in frame sotot = taxable_fmt
              line_total:format     in frame sotot = line_tot_fmt
              disc_amt:format       in frame sotot = disc_fmt
              so_trl1_amt:format    in frame sotot = trl_amt_fmt
              so_trl2_amt:format    in frame sotot = trl_amt_fmt
              so_trl3_amt:format    in frame sotot = trl_amt_fmt
              tax_amt:format        in frame sotot = tax_amt_fmt
              ord_amt:format        in frame sotot = ord_amt_fmt.
