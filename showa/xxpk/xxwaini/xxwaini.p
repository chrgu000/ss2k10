/*V8:ConvertMode=Maintenance                                                  */
{mfdtitle.i "110819.1"}
define variable yn like mfc_logical no-undo.
{gpcdget.i "UT"}

Form yn colon 40
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

repeat with frame a:
update yn.
if not yn then leave.

if can-find(first nr_mstr no-lock where nr_seqid = 'xxwa_det') or
   can-find(first nrh_hist no-lock where nrh_seqid = 'xxwa_det') then do:
  {mfmsg.i 2041 3}
pause.
end.
else do:
     create nr_mstr.
     assign nr_seqid = 'xxwa_det'
            nr_desc = 'xxwa_det'
            nr_dataset = 'xxwa_det'
            nr_allow_discard = yes
            nr_allow_void = yes
            nr_next_set = no
            nr_seg_type = '4,2,1,'
            nr_seg_nbr = ''
            nr_segcount = 3
            nr_seg_rank = '3,1,2,'
            nr_seg_ini = ',,0000,'
            nr_seg_min = ',,0000,'
            nr_seg_max = ',,9999,'
            nr_seg_reset = ',,0001,'
            nr_seg_value = 'pa,1108,0001,'
            nr_seg_format = ',YM,9999,'
            nr_archived = no
            nr_internal = yes
            nr_effdate = today - 1
            nr_exp_date = ?
            nr_user1 = ''
            nr_user2 = ''
            nr__qadc01 = ''
            nr_curr_effdate = today - 1
            nr_valuemask = 'ppaa0909010909090909'
            .
     {mfmsg.i 4171 1}
end.
end.  /* repeat with frame a: */
status input.
