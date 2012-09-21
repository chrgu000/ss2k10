/* yyptmpmtdet.p - REASON CODE MAINTENANCE                                    */
/*V8:ConvertMode=Maintenance                                                  */
/*-Revision end---------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "120920.1"}

define variable del-yn like mfc_logical initial no.
define variable site like si_site.
define variable part like pt_part.
define variable sdesc like si_desc.
define variable desc1 like pt_desc1.
define variable desc2 like pt_desc2.
define variable desca like pt_desc1.
define variable descb like pt_desc2.
define variable vdesc like pt_desc2.
/* DISPLAY SELECTION FORM */
form
   site           colon 25 sdesc no-label colon 42
   part           colon 25 desc1 no-label colon 42
                           desc2 no-label colon 42
   xxptmp_comp    colon 25 desca no-label colon 42
                           descb no-label colon 42
   xxptmp_vend    colon 25 vdesc no-label colon 42
   xxptmp_qty_per colon 25
   xxptmp_cust    colon 25
   xxptmp_rmks    colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.
repeat with frame a:

   prompt-for site part editing:

      /* FIND NEXT/PREVIOUS RECORD */
      if frame-field = "site" then do:
         {mfnp.i si_mstr site " si_domain = global_domain and si_site "
                 site si_site si_site}
         if recno <> ? then do:
            assign site = si_site.
            display site
                    si_desc @ sdesc.
         end.
      end.
      else if frame-field = "part" then do:
         {mfnp01.i xxptmp_mstr part xxptmp_par site
                 " xxptmp_mstr.xxptmp_domain = global_domain and xxptmp_site "
                   xxptmp_index1}

         if recno <> ? then do:
           assign desc1 = ""
                  desc2 = ""
                  desca = ""
                  descb = ""
                  vdesc = "".
           find first pt_mstr no-lock where pt_domain = global_domain and
                      pt_part = input part no-error.
           if available pt_mstr then do:
              assign desc1 = pt_desc1
                     desc2 = pt_desc2.
           end.
           find first pt_mstr no-lock where pt_domain = global_domain and
                      pt_part = xxptmp_comp no-error.
           if available pt_mstr then do:
              assign desca = pt_desc1
                     descb = pt_desc2.
           end.
           find vd_mstr no-lock where vd_domain = global_domain and
                vd_addr = xxptmp_vend no-error.
           if available vd_mstr then do:
                assign vdesc = vd_sort.
           end.

           display xxptmp_par @ part
                   desc1 desc2
                   xxptmp_comp
                   desca descb
                   xxptmp_vend
                   vdesc
                   xxptmp_qty_per
                   xxptmp_cust
                   xxptmp_rmks.
         end.
      end. /*else if frame-field = "part" then do: */
      else do:
           readkey.
           apply lastkey.
      end.
   end.
   assign site part.
   /* ADD/MOD/DELETE  */
   if not can-find (first si_mstr no-lock where si_domain = global_domain and
      si_site = site) or site = "" then do:
      {mfmsg.i 708 3}
       next-prompt site.
       undo,retry.
   end.
    {gprun.i ""gpsiver.p""
      "(site, input ?, output return_int)"}
   if return_int = 0
   then do:
      /* USER DOES NOT HAVE ACCESS TO THIS SITE*/
      {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
       next-prompt site.
       undo,retry.
   end.
   if not can-find(first pt_mstr no-lock where pt_domain = global_domain and
           pt_part = part) or  part = "" then do:
      {mfmsg.i 16 3}
      next-prompt part.
      undo,retry.
   end.
   repeat with frame a:
      prompt-for xxptmp_comp editing:
          {mfnp01.i xxptmp_mstr xxptmp_comp  xxptmp_comp
                    part  " xxptmp_mstr.xxptmp_domain = global_domain and
                    xxptmp_site = site and xxptmp_par "
                    xxptmp_index1}
           if recno <> ? then do:
               assign desca = ""
                      descb = ""
                      vdesc = "".
               find first pt_mstr no-lock where pt_domain = global_domain and
                          pt_part = input xxptmp_comp no-error.
               if available pt_mstr then do:
                  assign desca = pt_desc1
                         descb = pt_desc2.
               end.
               find vd_mstr no-lock where vd_domain = global_domain and
                    vd_addr = xxptmp_vend no-error.
               if available vd_mstr then do:
                    assign vdesc = vd_sort.
               end.
               display xxptmp_comp
                       desca
                       descb
                       xxptmp_vend
                       vdesc
                       xxptmp_qty_per
                       xxptmp_cust
                       xxptmp_rmks
                       .
            end.
      end.   /*   prompt-for xxptmp_comp editing:  */
      if not can-find(first pt_mstr no-lock where pt_domain = global_domain and
             pt_part = input xxptmp_comp) or  input xxptmp_comp = "" then do:
        {mfmsg.i 16 3}
        next-prompt xxptmp_comp.
        undo,retry.
       end.
       find xxptmp_mstr use-index xxptmp_index1 exclusive-lock where
            xxptmp_domain = global_domain and xxptmp_site = site and
            xxptmp_par = part and xxptmp_comp = input xxptmp_comp no-error.
       if not available xxptmp_mstr then do:
          {mfmsg.i 1 1}
          create xxptmp_mstr. xxptmp_domain = global_domain.
          assign xxptmp_site = site
                 xxptmp_par = part
                 xxptmp_comp = input xxptmp_comp.
       end.
       recno = recid(rsn_ref).

       display xxptmp_site @ site
               xxptmp_par @ part
               xxptmp_comp
               xxptmp_vend
               xxptmp_qty_per
               xxptmp_cust
               xxptmp_rmks
               with frame a.

       ststatus = stline[2].
       status input ststatus.
       del-yn = no.

      set xxptmp_qty_per
          xxptmp_cust
          xxptmp_rmks
       go-on("F5" "CTRL-D" ).

      /* DELETE */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      then do:
         del-yn = yes.
         {mfmsg01.i 11 1 del-yn}
         if not del-yn then undo, retry.
         delete xxptmp_mstr.
         clear frame a.
         del-yn = no.
      end.
   leave.
  end.
end.
status input.
