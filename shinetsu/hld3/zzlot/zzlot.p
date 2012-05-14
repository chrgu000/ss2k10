
/*V8:ConvertMode=Maintenance                                                  */
{mfdtitle.i "120420.1"}
define variable yn like mfc_logical no-undo.
define variable cnt as integer.
define variable itm as character.
define variable vret as character.
define variable v_weight as decimal format "->>>,>>>,>>>9.99".
define variable v_mult as integer.
{gpcdget.i "UT"}
{zzlot.i "new"}

Form 
    v_weight colon 40
    v_mult   colon 40
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

repeat with frame a:
update v_weight v_mult.
assign cnt = time.
empty temp-table tt_vodlot no-error.
for each ld_det where ld_qty_oh > 1:
    /* display ld_part ld_lot ld_ref ld_qty_oh. */
    if itm = ld_part then do:
       assign cnt = cnt + 1.
    end.
    assign itm = ld_part.
    create tt_vodlot.
    assign tt_vodlotno = ld_part + string(cnt)
           tt_weight = ld_qty_oh.
           .
end.
for each tt_vodlot:
display tt_vodlot.
end.
{gprun.i ""zzgetlist.p"" "(input v_weight,input v_mult,output vret)"}
message replace(vret,",",chr(10)) view-as alert-box.

end.