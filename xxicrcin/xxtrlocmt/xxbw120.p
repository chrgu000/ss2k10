/* xxbw120.p - brwose xx120.p                                                */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 26Y1 LAST MODIFIED: 05/31/12 BY: zy expand xrc length to 120    */
/* REVISION END                                                              */

{mfdtitle.i "120531.1"}
define variable yn like mfc_logical no-undo.
{gpcdget.i "UT"}

Form yn colon 40
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

repeat with frame a:
update yn.
if not yn then leave.

find first brw_mstr exclusive-lock where brw_mstr.brw_name = 'xx120' no-error.
if not available brw_mstr then do:
          create brw_mstr.
          assign brw_mstr.brw_name = 'xx120'.
end.
assign brw_mstr.brw_desc = 'LOCATION_TYPE'.
assign brw_mstr.brw_view = 'code_mstr'
       brw_mstr.brw_filter    = 'code_fldname = "TRANSLATE-LOCATION-TYPE"'
       brw_mstr.brw_userid    = 'admin'
       brw_mstr.brw_mod_date  = today
       brw_mstr.brw_sort_col  = '1'
       brw_mstr.brw_col_rtn   = '1'
       brw_mstr.brw_pwr_brw   = yes
       brw_mstr.brw_lu_brw    = yes
       brw_mstr.brw_locked_col= 0
       brw_mstr.brw_upd_brw   = no.
find first brwt_det exclusive-lock where brwt_det.brw_name = 'xx120' no-error.
if not available brwt_det then do:
          create brwt_det.
          assign brwt_det.brw_name = 'xx120'.
end.
assign brwt_det.brwt_seq   = 1
       brwt_det.brwt_table = 'code_mstr'
       brwt_det.brwt_userid   = 'admin'
       brwt_det.brwt_mod_date = today.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx120' and
           brwf_det.brwf_seq = 1 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx120'
                 brwf_det.brwf_seq = 1.
end.
assign brwf_det.brwf_field    = 'code_value'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(4)'
       brwf_det.brwf_label    = 'CODE'
       brwf_det.brwf_table    = 'code_mstr'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = 'admin'
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '4'
       brwf_det.brwf_enable   = no.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx120' and
           brwf_det.brwf_seq = 2 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx120'
                 brwf_det.brwf_seq = 2.
end.
assign brwf_det.brwf_field    = 'code_cmmt'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(20)'
       brwf_det.brwf_label    = 'COMMENT'
       brwf_det.brwf_table    = 'code_mstr'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = 'admin'
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '20'
       brwf_det.brwf_enable   = no.
find first flh_mstr exclusive-lock where flh_mstr.flh_field = 'usrw_key3' and
           flh_mstr.flh_call_pgm = 'xxtrlocmt' no-error.
if not available flh_mstr then do:
          create flh_mstr.
          assign flh_mstr.flh_field = 'usrw_key3'
                 flh_call_pgm = 'xxtrlocmt'.
end.
assign flh_mstr.flh_desc = "LOCATION_TYPE"
       flh_mstr.flh_exec = "xxlu120.p"
       flh_mstr.flh_x = 0
       flh_mstr.flh_y = 7
       flh_mstr.flh_down = 6
       flh_mstr.flh_user1 = ""
       flh_mstr.flh_user2 = ""
       flh_mstr.flh__qadc01 = ""
       flh_mstr.flh_mod_userid = "admin"
       flh_mstr.flh_mod_date = today.
      {mfmsg.i 4171 1}
       pause.
       return.
end.  /* DO ON ERROR UNDO, RETRY */
status input.
