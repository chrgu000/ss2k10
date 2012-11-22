/* xxlsmt.p - Logistics Vender And Ship to Reference Maintenance             */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120713.1 LAST MODIFIED: 07/13/12 BY: zy                         */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "120802.1"}
{xxusrwkey1202.i}
define variable del-yn like mfc_logical initial no.
define variable vlgvddesc as character format "x(20)".
define variable disp_abs_id like abs_mstr.abs_id no-undo.
define variable real_abs_id like abs_mstr.abs_id no-undo.
define variable vsptodesc as character format "x(20)".
/* DISPLAY SELECTION FORM */

form
    xxsh_site   colon 25 si_desc no-label
    xxsh_abs_id colon 25
    xxsh_nbr    colon 25 skip(1)

    xxsh_lgvd   colon 25 vlgvddesc no-label
    xxsh_shipto colon 25 vsptodesc no-label skip(1)

    xxsh_price  colon 25
    xxsh_pc     colon 25
    xxsh_dc     colon 25
    xxsh_uc     colon 25
    xxsh_lc     colon 25
    xxsh_gen_date colon 25
    xxsh_stat colon 25
    xxsh_rmks colon 25
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).
run getDefSite.

repeat:
    do with frame a:
         prompt-for
            xxsh_site
            xxsh_abs_id
            xxsh_nbr
         editing:
            global_site = input xxsh_site.
            if frame-field = "xxsh_site"
            then do:
               {mfnp05.i abs_mstr abs_id
                  " abs_mstr.abs_domain = global_domain
                  and (abs_id  begins 'S' and abs_type = 'S')"
                  abs_shipfrom
                  " input xxsh_site "}
               if recno <> ?
               then do:
                  for first si_mstr
                     fields( si_domain si_db si_desc si_entity si_site)
                      where si_mstr.si_domain = global_domain
                       and si_site = abs_shipfrom
                  no-lock:
                  end.

                  assign
                     global_site = abs_shipfrom
                     global_lot  = abs_id
                     disp_abs_id = substring(abs_id,2,50).
                  display
                     abs_shipfrom @ xxsh_site
                     si_desc  when (available si_mstr)
                     ""       when (not available si_mstr) @ si_desc
                     disp_abs_id @ xxsh_abs_id.
                  run getFirstSH(abs_shipfrom ,abs_id).
               end. /* if recno <> ? */

            end. /* if frame-field "abs_shipfrom" */
            else if frame-field = "xxsh_abs_id" then do:
                  {mfnp05.i abs_mstr abs_id
                     "abs_mstr.abs_domain = global_domain
                      and abs_shipfrom  = input xxsh_site
                      and abs_id begins ""s""
                      and abs_type    = ""s"""
                          abs_id " ""s"" + input xxsh_abs_id"}
               if recno <> ?  then do:
                  for first si_mstr
                     fields( si_domain si_db si_desc si_entity si_site)
                      where si_mstr.si_domain = global_domain
                       and  si_site = abs_shipfrom
                  no-lock:
                  end.

                  assign
                     global_site = abs_shipfrom
                     global_lot  = abs_id
                     disp_abs_id = substring(abs_id,2,50).
                  clear frame a.
                  display
                     abs_shipfrom @ xxsh_site
                     si_desc  when (available si_mstr)
                     ""       when (not available si_mstr) @ si_desc
                     disp_abs_id @ xxsh_abs_id.
                  run getFirstSH(abs_shipfrom ,abs_id).
                 end. /* if recno <> ? */
            end. /* if frame-field = "abs_id" */
            else if frame-field = "xxsh_nbr" then do:
              {mfnp01.i xxsh_mst xxsh_nbr " input xxsh_nbr "
                        xxsh_abs_id
                 " xxsh_domain = global_domain and xxsh_site = input xxsh_site
                  and 'S' + input xxsh_abs_id "
                  xxsh_abs_nbr}
               if recno <> ? then do:
                 assign vsptodesc = ""
                        vlgvddesc = "".
                 display xxsh_nbr xxsh_lgvd xxsh_shipto
                         xxsh_price xxsh_pc xxsh_dc xxsh_uc xxsh_lc
                         xxsh_gen_date xxsh_rmks
                         xxsh_stat vlgvddesc vsptodesc.
                 find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
                            usrw_key1 = vlgvdkey and usrw_key2 = xxsh_lgvd
                 no-error.
                 if available usrw_wkfl then do:
                    assign vlgvddesc = usrw_key3.
                 end.
                 else do:
                      {mfmsg.i 99800 3}
                      undo,retry.
                 end.
                 find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
                            usrw_key1 = vsptokey and usrw_key2 = xxsh_shipto
                 no-error.
                 if available usrw_wkfl then do:
                    assign vsptodesc = usrw_key3.
                 end.
                 else do:
                      {mfmsg.i 99801 3}
                      undo,retry.
                 end.
                 display vlgvddesc vsptodesc with frame a.
              end. /* if recno <> ? then do: */
            end. /* else if frame-field = "xxsh_nbr" then do: */
            else do:
               status input.
               readkey.
               apply lastkey.
            end.
         end. /* prompt-for */
       if input xxsh_nbr = "" then do:
          {mfmsg.i 40 3}
          next-prompt xxsh_nbr.
          undo,retry  .
      end.
      for first si_mstr
         fields( si_domain si_db si_desc si_entity si_site)
          where si_mstr.si_domain = global_domain
           and  si_site = input xxsh_site
      no-lock:
      end.
      if not available si_mstr
      then do:
         /* Site does not exist */
         {mfmsg.i 708 3}
         next-prompt xxsh_site with frame a.
         undo, retry.
      end.
      display
         si_desc
      with frame a.
      find first abs_mstr no-lock where abs_domain = global_domain
             and abs_shipfrom  = input xxsh_site
             and abs_id = "S" + input xxsh_abs_id
             and abs_type    = "S" no-error.
      if not available abs_mstr then do:
         {mfmsg.i 8119 3}
         next-prompt xxsh_abs_id with frame a.
         undo, retry.
      end.

     find first xxsh_mst use-index xxsh_abs_nbr
          where xxsh_domain = global_domain
            and xxsh_site = input xxsh_site
            and xxsh_abs_id = "S" + input xxsh_abs_id
            and xxsh_nbr = input xxsh_nbr no-error.
     if not available xxsh_mst then do:
        {mfmsg.i 1 1}
        create xxsh_mst. xxsh_mst.xxsh_domain = global_domain.
        assign xxsh_site = input xxsh_site
               xxsh_abs_id = "S" + input xxsh_abs_id
               xxsh_nbr = input xxsh_nbr
               xxsh_gen_date = today
               xxsh_userid = global_userid.
     end.
     recno = recid(xxsh_mst).

     if xxsh_stat = "C" then do:
        {mfmsg.i 99804 3}
        undo,retry.
     end.
     display xxsh_lgvd xxsh_shipto xxsh_price xxsh_pc xxsh_dc xxsh_uc xxsh_lc
             xxsh_gen_date xxsh_stat xxsh_rmks with frame a.
     repeat with frame a:
            update xxsh_lgvd xxsh_shipto with frame a.
            if input xxsh_lgvd = "" then do:
               {mfmsg.i 40 3}
               next-prompt xxsh_lgvd with frame a.
               undo,retry.
            end.
            if input xxsh_shipto = "" then do:
               {mfmsg.i 40 3}
               next-prompt xxsh_shipto with frame a.
               undo,retry.
            end.
            assign vsptodesc = ""
                   vlgvddesc = "".
            find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
                       usrw_key1 = vlgvdkey and usrw_key2 = input xxsh_lgvd no-error.
            if available usrw_wkfl then do:
               assign vlgvddesc = usrw_key3.
            end.
            else do:
                 {mfmsg.i 99800 3}
                 undo,retry.
            end.
            find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
                       usrw_key1 = vsptokey and usrw_key2 = input xxsh_shipto no-error.
            if available usrw_wkfl then do:
               assign vsptodesc = usrw_key3.
            end.
            else do:
                 {mfmsg.i 99801 3}
                 undo,retry.
            end.
            display vlgvddesc vsptodesc with frame a.
              assign xxsh_lgvd xxsh_shipto.
            leave.
     end.   /* repeat with frame a */
       find first qad_wkfl no-lock where {xxqaddom.i} {xxand.i}
                  qad_key1 = vdefcstkey and qad_key3 = xxsh_lgvd and
                  qad_key4 =  xxsh_shipto no-error.
       if available qad_wkfl and new xxsh_mst then do:
          display qad_decfld[1] @ xxsh_price
                  qad_decfld[2] @ xxsh_pc
                  qad_decfld[3] @ xxsh_dc
                  qad_decfld[4] @ xxsh_uc
                  qad_decfld[5] @ xxsh_lc with frame a.
       end.
       if xxsh_gen_date = ? then display today @ xxsh_gen_date.
       ststatus = stline[2].
       status input ststatus.
       del-yn = no.
       do on error undo, retry:
          set xxsh_price xxsh_pc xxsh_dc xxsh_uc xxsh_lc xxsh_rmks
          go-on("F5" "CTRL-D" ) with frame a.
          assign xxsh_mod_date = today
                 xxsh_mod_usr = global_userid.
          /* DELETE */
          if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
          then do:
             del-yn = yes.
             {mfmsg01.i 11 1 del-yn}
             if not del-yn then undo, retry.
             delete xxsh_mst.
             clear frame a.
             del-yn = no.
          end.
       end.  /* do on error undo, retry: */
   end.
end.

status input.

procedure getFirstSH:
  define input parameter isite like si_site.
  define input parameter iid like abs_id.
  display "" @ xxsh_nbr
          "" @ xxsh_lgvd
          "" @ xxsh_shipto
          "" @ xxsh_price
          "" @ xxsh_pc
          "" @ xxsh_dc
          "" @ xxsh_uc
          "" @ xxsh_lc
          "" @ xxsh_stat
          "" @ xxsh_gen_date
          "" @ xxsh_rmks
          "" @ vsptodesc
          "" @ vlgvddesc with frame a.
  find first xxsh_mst use-index xxsh_abs_nbr no-lock where
             xxsh_domain = global_domain  and
             xxsh_site = isite and xxsh_abs_id = iid no-error.
  if available xxsh_mst then do:
     display xxsh_nbr xxsh_lgvd xxsh_shipto xxsh_price xxsh_pc xxsh_dc xxsh_uc
             xxsh_lc xxsh_gen_date xxsh_stat xxsh_rmks with frame a.
     find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
                usrw_key1 = vlgvdkey and usrw_key2 = xxsh_lgvd no-error.
     if available usrw_wkfl then do:
        display usrw_key3 @ vlgvddesc with frame a.
     end.
     find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
                usrw_key1 = vsptokey and usrw_key2 = input xxsh_shipto no-error.
     if available usrw_wkfl then do:
        display usrw_key3 @ vsptodesc with frame a.
     end.
  end.
end.   /*   procedure getFirstSH:   */
