/* xxboxmt.p - box MAINT                                                      */
/*V8:ConvertMode=Maintenance                                                  */
/*-Revision end---------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "120329.1"}

define variable del-yn like mfc_logical initial no.

define variable v_number as character format "x(12)".
define variable errorst as logical.
define variable errornum as integer.
define variable boxparnbr as character initial "xxboxpar".

/* Variable added to perform delete during CIM.
* Record is deleted only when the value of this variable
* Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.
define buffer boxmst for xxbox_mst.
define variable newRec as logical initial "no".

/* DISPLAY SELECTION FORM */
form
   xxbox_par      colon 25 format "x(30)"

   xxbox_sonbr    colon 25
   xxbox_soline   colon 60 skip
   xxbox_comptype colon 25
   xxbox_qty_max  colon 60 skip(1)

   xxbox_comp     colon 25
   xxsovd_part    colon 25
   xxsovd_wonbr   colon 25
   xxsovd_wolot   colon 60
   xxsovd_id1     colon 25 skip(1)
   xxbox_site     colon 25
   xxbox_loc      colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:

   do on error undo, retry:

      /* Prompt for the delete variable in the key frame at the
       * End of the key field/s only when batchrun is set to yes */
      prompt-for xxbox_par
      editing:
     {mfnp.i xxbox_mst
             xxbox_par
           " xxbox_mst.xxbox_domain = global_domain and xxbox_par"
             xxbox_par
             xxbox_par
             xxbox_par_so}
         if recno <> ? then do:
            {xxboxdsp.i}
         end.
      end. /* editing: */ 
      
      assign errornum = 0.
      for each boxmst no-lock where boxmst.xxbox_domain = global_domain 
           and boxmst.xxbox_par = input xxbox_mst.xxbox_par:
           assign errornum = errornum + 1.
      end.
      if errornum >= input xxbox_mst.xxbox_qty_max and
         input xxbox_mst.xxbox_qty_max <> 0
      then
      do:
        /* 1009 Quantity exceeds maximum */
        {pxmsg.i &MSGNUM=1009 &ERRORLEVEL =3}
         next-prompt xxbox_mst.xxbox_comp.
         undo,retry.
      end.
      
      if input xxbox_mst.xxbox_par = "" or
           not can-find(first xxbox_mst where xxbox_domain = global_domain and
                        xxbox_par = input xxbox_mst.xxbox_par )
      then do:
/*GN*/ {gprun.i ""gpnrmgv.p"" "(boxparnbr,
                                input-output v_number,
                                output errorst,
                                output errornum)" }
        display v_number @ xxbox_par
                "" @ xxbox_comp
                "" @ xxsovd_part
                "" @ xxsovd_wonbr
                "" @ xxsovd_wolot
                "" @ xxsovd_id1
                "" @ xxbox_site
                "" @ xxbox_loc.
        do on error undo, retry:
        prompt-for xxbox_sonbr xxbox_solin xxbox_comptype xxbox_qty_max
        editing:
              if frame-field = "xxbox_sonbr" then do:
               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp05.i xxbox_mst xxbox_par_so
                       " xxbox_mst.xxbox_domain = global_domain and
                                   xxbox_par = input xxbox_par "
                         xxbox_sonbr
                       " input xxbox_sonbr"}
                   if recno <> ? then do:
                       {xxboxdsp.i}
                   end.
              end.
              else if frame-field = "xxbox_soline" then do:
               {mfnp05.i xxbox_mst  xxbox_par_so
                       " xxbox_mst.xxbox_domain = global_domain and
                                   xxbox_par = input xxbox_par and
                                   xxbox_sonbr = input xxbox_sonbr "
                         xxbox_soline
                       " input xxbox_soline"}
                if recno <> ? then do:
                    {xxboxdsp.i}
                end.
              end.
              else do:
                     status input.
                     readkey.
                     apply lastkey.
              end.
        end. /* editing: */
           if not can-find(first sod_det no-lock where
                                 sod_domain = global_domain and
                                 sod_nbr = input xxbox_sonbr and
                                 sod_line = input xxbox_soline)
           then do:
                 {pxmsg.i &MSGNUM=4888 &ERRORLEVEL=3
                          &MSGARG1="input xxbox_sonbr"
                          &MSGARG2="input xxbox_soline"}
                next-prompt xxbox_sonbr.
                undo,retry.
           end.
        end. /* do on error undo, retry: prompt-for xxbox_sonbr  */
      end. /* do on error undo, retry: prompt-for xxbox_par*/

   do on error undo, retry:

      /* Prompt for the delete variable in the key frame at the
       * End of the key field/s only when batchrun is set to yes */
      prompt-for
         xxbox_comp
      editing:

      {mfnp05.i xxbox_mst
                xxbox_so
              " xxbox_mst.xxbox_domain = global_domain and
                          xxbox_sonbr = input xxbox_sonbr and
                          xxbox_soline = input xxbox_soline and
                          xxbox_par = input xxbox_par"
                xxbox_comp
                " input xxbox_comp"}
         if recno <> ? then do:
            display xxbox_sonbr xxbox_soline xxbox_par xxbox_comp.
         end.
      end. /* editing: */
      find first xxsovd_det no-lock where xxsovd_domain = global_domain and
                 xxsovd_id = input xxbox_comp no-error.
      if available xxsovd_det then do:
         if (xxsovd_nbr <> input xxbox_mst.xxbox_sonbr or
             xxsovd_line <> input xxbox_mst.xxbox_soline) then do:
           display xxsovd_part xxsovd_wonbr xxsovd_wolot xxsovd_id1.
         end.
      end.
      else do:
            /*VIN CODE NOT EXISTS*/
           {pxmsg.i &MSGNUM=4136 &ERRORLEVEL=3}
           next-prompt xxbox_comp.
           undo,retry.
      end.
      if can-find(first boxmst no-lock where
         boxmst.xxbox_domain = global_domain and
         boxmst.xxbox_par <> input xxbox_mst.xxbox_par and
         boxmst.xxbox_comp = input xxbox_mst.xxbox_comp) then do:
         /*VIN CODE in OTHER BOX*/
         {pxmsg.i &MSGTEXT=""VIN已经在其他包装箱内"" &ERRORLEVEL =3}
         next-prompt xxbox_mst.xxbox_comp.
         undo,retry.
      end.
   end. /* do on error undo, retry: prompt-for xxbox_comp*/

   end. /* do on error undo, retry: prompt-for xxbox_par */
   /* ADD/MOD/DELETE  */

   find xxbox_mst exclusive-lock where
        xxbox_mst.xxbox_domain = global_domain and
        xxbox_sonbr = input xxbox_sonbr and
        xxbox_soline = input xxbox_soline and
        xxbox_par = input xxbox_par and
        xxbox_comp = input xxbox_comp
        no-error.
   if not available xxbox_mst then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create xxbox_mst. xxbox_mst.xxbox_domain = global_domain.
      assign xxbox_sonbr xxbox_soline xxbox_par xxbox_comp xxbox_comptype
             xxbox_qty_max xxbox_site xxbox_loc.
   end. /* if not available code_mstr then do: */
   else do:
        assign xxbox_comptype = input xxbox_comptype
               xxbox_qty_max = input xxbox_qty_max
               xxbox_site = input xxbox_site
               xxbox_loc = input xxbox_loc.
   end.

   ststatus = stline[2].
   status input ststatus.

   do on error undo, retry:
         update xxbox_site xxbox_loc
         go-on(F5 CTRL-D).
         if  (input xxbox_site <> "" and
             not can-find(si_mstr no-lock where si_domain = global_domain and
                         si_site = input xxbox_site)) then do:
               {pxmsg.i &MSGNUM=708 &ERRORLEVEL =3}
                next-prompt xxbox_mst.xxbox_comp.
                undo,retry.
         end.
         else if (input xxbox_loc <> "" and
                not can-find(first loc_mstr no-lock where
                loc_domain = global_domain and loc_site = input xxbox_site and
                loc_loc = input xxbox_loc)) then do:
               {pxmsg.i &MSGNUM=709 &ERRORLEVEL =3}
                next-prompt xxbox_mst.xxbox_comp.
                undo,retry.
         end.
         /* Delete to be executed if batchdelete is set or
          * F5 or CTRL-D pressed */
         if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
         then do:

            del-yn = yes.

            /* Please confirm delete */
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

            if del-yn then do:
               delete xxbox_mst.
               clear frame a.
            end. /* if del-yn then do: */

         end. /* then do: */
   end.  /* do on error undo, retry: update xxbox_site */

end.  /*repeat with frame a */

status input.

