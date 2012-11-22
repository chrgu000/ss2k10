/* GUI CONVERTED from yybw200.p (converter v1.78) Mon Nov 19 19:17:03 2012 */

{mfdtitle.i "121119.1"}
define variable yn like mfc_logical no-undo.
{gpcdget.i "UT"}


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/  
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
yn colon 40
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


setFrameLabels(frame a:handle).

repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.

update yn.
if not yn then leave.

find first brw_mstr exclusive-lock where brw_mstr.brw_name = 'yy200' no-error.
if not available brw_mstr then do:
          create brw_mstr.
          assign brw_mstr.brw_name = 'yy200'.
end.
assign brw_mstr.brw_desc = 'TYPE'.
assign brw_mstr.brw_view = 'code_mstr'
       brw_mstr.brw_filter    = 'code_domain = global_domain and code_fldname = "vo_type"'
       brw_mstr.brw_userid    = global_userid
       brw_mstr.brw_mod_date  = today
       brw_mstr.brw_sort_col  = '1'
       brw_mstr.brw_col_rtn   = '1'
       brw_mstr.brw_pwr_brw   = yes
       brw_mstr.brw_lu_brw    = yes
       brw_mstr.brw_locked_col= 0
       brw_mstr.brw_upd_brw   = no.
find first brwt_det exclusive-lock where brwt_det.brw_name = 'yy200' no-error.
if not available brwt_det then do:
          create brwt_det.
          assign brwt_det.brw_name = 'yy200'.
end.
assign brwt_det.brwt_seq   = 1
       brwt_det.brwt_table = 'code_mstr'
       brwt_det.brwt_userid   = global_userid
       brwt_det.brwt_mod_date = today.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'yy200' and
           brwf_det.brwf_seq = 1 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'yy200'
                 brwf_det.brwf_seq = 1.
end.
assign brwf_det.brwf_field    = 'code_value'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(4)'
       brwf_det.brwf_label    = 'TYPE'
       brwf_det.brwf_table    = 'code_mstr'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '4'
       brwf_det.brwf_enable   = no.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'yy200' and
           brwf_det.brwf_seq = 2 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'yy200'
                 brwf_det.brwf_seq = 2.
end.
assign brwf_det.brwf_field    = 'code_cmmt'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(20)'
       brwf_det.brwf_label    = 'DESCRIPTION'
       brwf_det.brwf_table    = 'code_mstr'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '20'
       brwf_det.brwf_enable   = no.
      {mfmsg.i 4171 1}
       pause.
       return.
end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* repeat with frame a: */
status input.
