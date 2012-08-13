
/* GETS A SCHEDULED ORDER SCHEDULE RECORD (sch_mstr) */

find pod_det where pod_nbr = scx_order and pod_line = scx_line exclusive.
find po_mstr where po_nbr = pod_nbr no-lock.

global_schtype = schtype.

disp "" @ sch_rlse_id with frame a.	/*GA72*/

do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

   prompt-for sch_rlse_id with frame a no-validate editing:
      {mfnp05.i sch_mstr sch_tnlr
      "sch_type = schtype and sch_nbr = scx_order
      and sch_line = scx_line"
      sch_rlse_id "input sch_rlse_id"}

      if recno <> ? then do:
	 disp sch_rlse_id with frame a.
      end.
   end.

   if input sch_rlse_id = "" then do:
      if can-find(sch_mstr where sch_type = schtype
      and sch_nbr = scx_order 
      and sch_line = scx_line
      and sch_rlse_id = pod_curr_rlse_id[schtype - 3])
      then do:
	 disp pod_curr_rlse_id[schtype - 3] @ sch_rlse_id with frame a.
      end.
      else do:
         {mfmsg.i 8175 3}
	 bell.
	 undo, retry.
      end.
   end.

   find sch_mstr 
   where sch_type = schtype
   and sch_nbr = scx_order 
   and sch_line = scx_line
   and sch_rlse_id = input sch_rlse_id
   exclusive no-error.

   if available sch_mstr then do:
      if sch_rlse_id <> pod_curr_rlse_id[schtype - 3] then do:
	 if pod_curr_rlse_id[schtype - 3] <> "" then do:
	    {mfmsg02.i 6005 2 "pod_curr_rlse_id[schtype - 3]"}
	 end.
      end.
      else do:
	 {mfmsg.i 6006 1}
      end.
   end.
   else do:
      {mfmsg.i 1 1}

      create sch_mstr.

      assign
      sch_type = schtype
      sch_nbr = scx_order
      sch_line = scx_line
      sch_rlse_id.
/*GN88*/ if recid(sch_mstr) = -1 then .

      /* PICK UP SOME DATA ITEMS FROM PRIOR SCHEDULE */

      if pod_curr_rlse_id[schtype - 3] > "" then do:
         {mfmsg01.i 6007 1 yn}

         if yn then do for prev_sch_mstr:
            find prev_sch_mstr
            where sch_type = sch_mstr.sch_type
            and sch_nbr = sch_mstr.sch_nbr
            and sch_line = sch_mstr.sch_line
            and sch_rlse_id = pod_curr_rlse_id[schtype - 3]
            no-lock.
	    /*GC53 CORRECT SYNTAX OF FOLLOWING*/

            {gprun.i ""rcsinit.p""
            "(input recid(prev_sch_mstr), input recid(sch_mstr),
            input yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.
      end.

      assign
      sch_cr_date = today
      sch_cr_time = time
      sch_ship = po_ship
      sch_eff_start = today
      sch_eff_end = ?
      sch_sd_pat = pod_sd_pat.
   end.
end.
/*GUI*/ if global-beam-me-up then undo, leave.

