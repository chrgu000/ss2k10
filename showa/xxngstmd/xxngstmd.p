/* xxngstmd.p - 将NG库位非N-N-N状态的物料改为N-N-N状态                       */
/* $Revision: 1.6.1.3 $                                                      */
/*V8:ConvertMode=Maintenance                                                 */
/* DISPLAY TITLE */
{mfdtitle.i "1311.5"}

define variable fname as character format "x(40)" label " Backup file".
define variable cimfile as character.
define variable yn like mfc_logical.
define variable offset  as integer.
define stream b1.
define stream b2.
define buffer lddet for ld_det.
{gpcdget.i "UT"}
form
   space(1)
   fname
with frame a width 80 attr-space side-labels no-underline.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/*V8-*/

repeat:

   update fname with frame a.
   output to value(fname).
       for each ld_det no-lock where ld_site = "GSA01" and ld_loc = "NG"
         and ld_status <> "N-N-N" with frame b width 320:
         setFrameLabels(frame b:handle).
          display ld_site ld_loc ld_part ld_lot ld_ref ld_qty_oh ld_status.
     end.
   output close.
   {mfmsg01.i 12 2 yn to update}
   if not yn then do:
      undo,retry.
   end.
      offset = 1.
     for each lddet no-lock where lddet.ld_site = "GSA01"
          and (lddet.ld_loc = "NG" or lddet.ld_loc = "NGSP")
          and lddet.ld_status <> "N-N-N":
        assign cimfile = execname + "." + string(offset,"9999999999").
        output stream b1 to value(cimfile + ".bpi").
        put stream b1 unformat '"' lddet.ld_site '" "' lddet.ld_loc '" "' lddet.ld_part '" "'  lddet.ld_lot '" "' lddet.ld_ref '"' skip.
        put stream b1 unformat '- - - "N-N-N"' skip.
        output stream b1 close.

        batchrun = yes.
        input from value(cimfile + ".bpi").
        output to value(cimfile +  ".bpo") keep-messages.
        hide message no-pause.
        cimrunprogramloop:
        do transaction on stop undo cimrunprogramloop,leave cimrunprogramloop:
         {gprun.i ""icldmt.p""}
        end.
        hide message no-pause.
        output close.
        input close.
        batchrun = no.
        offset = offset + 1.
        os-delete value(cimfile + ".bpi").
        os-delete value(cimfile + ".bpo").
    end.

    for each ld_det no-lock where ld_site = "GSA01" and ld_loc = "NG"
         and ld_status <> "N-N-N" with frame c:
         setFrameLabels(frame c:handle).
          display ld_site ld_loc ld_part ld_lot ld_ref ld_qty_oh ld_status.
     end.
end.
