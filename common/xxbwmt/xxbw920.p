/*V8:ConvertMode=Maintenance                                                  */
{mfdtitle.i "120217.1"}
define variable yn like mfc_logical no-undo.
{gpcdget.i "UT"}

Form yn colon 40
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

repeat with frame a:
update yn.
if not yn then leave.

find first brw_mstr exclusive-lock where brw_mstr.brw_name = 'xx920' no-error.
if not available brw_mstr then do:
          create brw_mstr.
          assign brw_mstr.brw_name = 'xx920'.
end.
assign brw_mstr.brw_desc = 'BROWSE_COLLECTION'.
assign brw_mstr.brw_view = 'brw_mstr'
       brw_mstr.brw_filter    = ''
       brw_mstr.brw_userid    = 'mfg'
       brw_mstr.brw_mod_date  = today
       brw_mstr.brw_sort_col  = ''
       brw_mstr.brw_col_rtn   = ''
       brw_mstr.brw_pwr_brw   = yes
       brw_mstr.brw_lu_brw    = yes
       brw_mstr.brw_locked_col= 0
       brw_mstr.brw_upd_brw   = no.
find first brwt_det exclusive-lock where brwt_det.brw_name = 'xx920' no-error.
if not available brwt_det then do:
          create brwt_det.
          assign brwt_det.brw_name = 'xx920'.
end.
assign brwt_det.brwt_seq   = 1
       brwt_det.brwt_table = 'brw_mstr'
       brwt_det.brwt_userid   = 'mfg'
       brwt_det.brwt_mod_date = today.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx920' and
           brwf_det.brwf_seq = 1 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx920'
                 brwf_det.brwf_seq = 1.
end.
assign brwf_det.brwf_field    = 'brw_name'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(12)'
       brwf_det.brwf_label    = 'NAME'
       brwf_det.brwf_table    = 'brw_mstr'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = 'mfg'
       brwf_det.brwf_mod_date = today
       brwf_det.brwf_enable   = no.
find first brwf_det exclusive-lock where brwf_det.brw_name = 'xx920' and
           brwf_det.brwf_seq = 2 no-error.
if not available brwf_det then do:
          create brwf_det.
          assign brwf_det.brw_name = 'xx920'
                 brwf_det.brwf_seq = 2.
end.
assign brwf_det.brwf_field    = 'brw_desc'
       brwf_det.brwf_datatype = 'character'
       brwf_det.brwf_format   = 'x(35)'
       brwf_det.brwf_label    = 'COMMENTS'
       brwf_det.brwf_table    = 'brw_mstr'
       brwf_det.brwf_select   = yes
       brwf_det.brwf_sort     = yes
       brwf_det.brwf_userid   = 'mfg'
       brwf_det.brwf_mod_date = today
       brwf_det.brwf__qadc01  = '35'
       brwf_det.brwf_enable   = no.
      {mfmsg.i 4171 1}
       pause.
       return.
end.  /* repeat with frame a: */
status input.
