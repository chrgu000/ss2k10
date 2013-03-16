/*V8:ConvertMode=Maintenance                                                  */
{mfdtitle.i "120602.1"}
define variable yn like mfc_logical no-undo.
{gpcdget.i "UT"}

Form yn colon 40
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

repeat with frame a:
update yn.
if not yn then leave.

find first brw_mstr exclusive-lock where brw_mstr.brw_name = 'xx801' no-error.
if not available brw_mstr then do:
          create brw_mstr.
          assign brw_mstr.brw_name = 'xx801'.
end.
assign brw_mstr.brw_desc = 'SRC/XRC_DIRECTORY'.
assign brw_mstr.brw_view = 'usrw_wkfl'
       brw_mstr.brw_filter    = 'usrw_domain = global_domain and usrw_key1 = "xxcomp.p.xrcdir" and usrw_key3 = opsys'
       brw_mstr.brw_userid    = global_userid
       brw_mstr.brw_mod_date  = today
       brw_mstr.brw_sort_col  = '1'
       brw_mstr.brw_col_rtn   = '1'
       brw_mstr.brw_pwr_brw   = yes
       brw_mstr.brw_lu_brw    = yes
       brw_mstr.brw_locked_col= 0
       brw_mstr.brw_upd_brw   = no.
find first brwt_det exclusive-lock where brwt_det.brw_name = 'xx801' no-error.
if not available brwt_det then do:
          create brwt_det.
          assign brwt_det.brw_name = 'xx801'.
end.
assign brwt_det.brwt_seq   = 1
       brwt_det.brwt_table = 'usrw_wkfl'
       brwt_det.brwt_userid   = global_userid
       brwt_det.brwt_mod_date = today.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx801' and
           brwf_det.brwf_seq = 1 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx801'
                 brwf_det.brwf_seq = 1.
end.
assign brwf_det.brwf_field    = 'usrw_key2'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(50)'
       brwf_det.brwf_label    = 'DIRECTORY'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '50'
       brwf_det.brwf_enable   = no.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx801' and
           brwf_det.brwf_seq = 2 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx801'
                 brwf_det.brwf_seq = 2.
end.
assign brwf_det.brwf_field    = 'usrw_key5'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(19)'
       brwf_det.brwf_label    = 'TIME'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = global_userid
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '19'
       brwf_det.brwf_enable   = no.
find first flh_mstr exclusive-lock where flh_mstr.flh_field = 'xrcdir' and
           flh_mstr.flh_call_pgm = '' no-error.
if not available flh_mstr then do:
          create flh_mstr.
          assign flh_mstr.flh_field = 'xrcdir'
                 flh_call_pgm = ''.
end.
assign flh_mstr.flh_desc = ""
       flh_mstr.flh_exec = "xxlu801.p"
       flh_mstr.flh_x = 0
       flh_mstr.flh_y = 7
       flh_mstr.flh_down = 6
       flh_mstr.flh_user1 = ""
       flh_mstr.flh_user2 = ""
       flh_mstr.flh__qadc01 = ""
       flh_mstr.flh_mod_userid = global_userid
       flh_mstr.flh_mod_date = today.
      {mfmsg.i 4171 1}
       pause.
       return.
end.  /* repeat with frame a: */
status input.