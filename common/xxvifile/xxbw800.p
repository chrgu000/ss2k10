/*V8:ConvertMode=Maintenance                                                  */
{mfdtitle.i "110714.1"}
define variable yn like mfc_logical no-undo.
{gpcdget.i "UT"}

Form yn colon 40
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

repeat with frame a:
update yn.
if not yn then leave.

find first brw_mstr exclusive-lock where brw_mstr.brw_name = 'xx800' no-error.
if not available brw_mstr then do:
          create brw_mstr.
          assign brw_mstr.brw_name = 'xx800'.
end.
assign brw_mstr.brw_desc = 'FILE_NAME'.
assign brw_mstr.brw_view = 'usrw_wkfl'
       brw_mstr.brw_filter    = 'usrw_key1 = "xxvifile.p" and usrw_key3 = global_userid'
       brw_mstr.brw_userid    = 'mfg'
       brw_mstr.brw_mod_date  = today
       brw_mstr.brw_sort_col  = '1'
       brw_mstr.brw_col_rtn   = '1'
       brw_mstr.brw_pwr_brw   = yes
       brw_mstr.brw_lu_brw    = yes
       brw_mstr.brw_locked_col= 0
       brw_mstr.brw_upd_brw   = no.
find first brwt_det exclusive-lock where brwt_det.brw_name = 'xx800' no-error.
if not available brwt_det then do:
          create brwt_det.
          assign brwt_det.brw_name = 'xx800'.
end.
assign brwt_det.brwt_seq   = 1
       brwt_det.brwt_table = 'usrw_wkfl'
       brwt_det.brwt_userid   = 'mfg'
       brwt_det.brwt_mod_date = today.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx800' and
           brwf_det.brwf_seq = 1 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx800'
                 brwf_det.brwf_seq = 1.
end.
assign brwf_det.brwf_field    = 'usrw_key4'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(24)'
       brwf_det.brwf_label    = 'FILE_NAME'
       brwf_det.brwf_table    = 'usrw_wkfl'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = 'mfg'
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '24'
       brwf_det.brwf_enable   = no.
      {mfmsg.i 4171 1}
       pause.
       return.
end.  /* repeat with frame a: */
status input.
