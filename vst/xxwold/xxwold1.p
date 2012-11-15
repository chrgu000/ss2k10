	/* xxwold1.p - wowomt.p cim load                                             */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

{mfdeclre.i}
{xxwold.i}
{xxloaddata.i}          
define variable vfile as character.
define variable vrcptflg     like mfc_logical no-undo initial yes.
define variable vgrpflg      like mfc_logical no-undo initial yes.
define variable clearwkfl as logical initial yes no-undo.
DEFINE STREAM xp.

assign clearwkfl = deltmpfile().
for each xxwoload exclusive-lock where xxwo_chk = "".
  assign vfile = "xxwold.p." + string(today,"99999999") + '.' + string(time).
  output STREAM xp to value(vfile + ".bpi").
     find last wr_route
        where wr_lot = xxwo_lot no-lock no-error.
     if available wr_route
        and wr_qty_cummove <> 0
     then
        vrcptflg = no.

     find first wo_mstr no-lock where wo_lot = xxwo_lot no-error.
     if available wo_mstr then do:
     find pt_mstr
        where pt_part = wo_part no-lock no-error.

     if pt_auto_lot = yes
        and pt_lot_grp = ""
     then
        vgrpflg = no.
     end.

      put STREAM xp unformat '"" ' xxwo_lot skip.
      put STREAM xp unformat '- - ' xxwo_rel_date ' ' xxwo_due_date ' '.
     		  put STREAM xp unformat xxwo_stat ' - - - - - - - n' skip.

      if wo_qty_comp = 0 and pt_lot_ser <> "s"
                          and wo_type <> "R" and wo_type <> "E"
                          and wo_joint_type <> "5"
                          and vrcptflg and vgrpflg then do:
          put STREAM xp unformat '-' skip.
          put STREAM xp unformat '-' skip.
      end.
      put STREAM xp unformat '-' skip.
  output STREAM xp close.
  if cloadfile then do:
     batchrun = yes.
     input from value(vfile + ".bpi").
     output to value(vfile + ".bpo") keep-messages.
     hide message no-pause.
     cimrunprogramloop:
     do on stop undo cimrunprogramloop,leave cimrunprogramloop:
        {gprun.i ""wowomt.p""}
     end.
     hide message no-pause.
     output close.
     input close.
     batchrun = no.

     find first wo_mstr no-lock where wo_lot = xxwo_lot no-error.
     if available wo_mstr and wo_rel_date = xxwo_rel_date and
                  wo_due_date = xxwo_due_date and (wo_stat = xxwo_stat or xxwo_stat = "-")
     then do:
        assign xxwo_chk = "OK".
     end.
     else do:
        assign xxwo_chk = "FAIL".
     end.
     if clearwkfl then do:
        os-delete value(vfile + ".bpi").
        os-delete value(vfile + ".bpo").
     end.
  end.
end.
