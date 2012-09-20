/* yyedtgmt.p -                                                  */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120713.1 LAST MODIFIED: 07/13/12 BY: zy                         */
/* REVISION END                                                              */

{mfdtitle.i "120920.1"}

define variable del-yn          like mfc_logical.
define variable new_method      like mfc_logical.
define variable chg_ok          like mfc_logical.
define variable old_edtg_dest_dir    like edtg_dest_dir.
define variable old_edtg_dest_prefix like edtg_dest_prefix.

/* DISPLAY SELECTION FORM */
form
   edtg_dtg_name    colon 20
   skip(1)
   edtg_dtg_desc    colon 20
   edtg_dtg_ctrl    colon 20
   edtg_dest_dir    colon 20
   edtg_dest_prefix colon 20 format "x(30)"
   edtg_proc_scr    colon 20 format "x(40)"
   edtg__qadc01     colon 20 format "x(30)"
   edtg_http_id     colon 20 format "x(30)"
   edtg__qadi01     colon 20
   edtg_subsys      colon 20 format "x(30)"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

mainloop:
repeat with frame a:
    prompt-for edtg_dtg_name with frame a editing:
       {mfnp.i edtg_mstr edtg_dtg_name  " edtg_dtg_name "
       edtg_dtg_name edtg_dtg_name edtg_dtg_name}

       if recno <> ? then do:
          display
              edtg_dtg_name
              edtg_dtg_ctrl
              edtg_dtg_desc
              edtg_dest_dir
              edtg_dest_prefix
              edtg_proc_scr
              edtg_http_id
              edtg__qadi01
              edtg_subsys
          with frame a.
       end.
    end. /* PROMPT-FOR...EDITING */

    /* VALIDATE CODE NOT BLANK */
    if not input edtg_dtg_name > "" then do:
       {mfmsg.i 40 3}     /* BLANK ROUNDING METHOD NOT ALLOWED */
       undo mainloop, retry mainloop.
    end.

    find edtg_mstr  where edtg_dtg_name = input edtg_dtg_name
    exclusive-lock no-error.

    if not available edtg_mstr then do:
       {mfmsg.i 1 1}      /*ADDING NEW RECORD*/
       create edtg_mstr.

       assign edtg_dtg_name.
       assign new_method = true.
    end.
    else
       assign new_method = false.

    display edtg_dtg_name
            edtg_dtg_ctrl
            edtg_dtg_desc
            edtg_dest_dir
            edtg_dest_prefix
            edtg_proc_scr
            edtg__qadc01
            edtg_http_id
            edtg__qadi01
            edtg_subsys
    with frame a.

    assign .

    ststatus  =  stline[2].
    status input ststatus.

    setflds:
    do on error undo, retry:
       set edtg_dtg_desc
           edtg_dest_dir
           edtg_dest_prefix
           edtg_proc_scr
           edtg__qadc01
           edtg_http_id
           edtg__qadi01
           edtg_subsys
       go-on (F5 CTRL-D) with frame a.

       if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
       then do:
          del-yn = no.
          {mfmsg01.i 11 1 del-yn}    /*PLEASE CONFIRM DELETE*/

          if del-yn = no then undo setflds, retry setflds.

          delete edtg_mstr.
          clear frame a.
          next mainloop.
      end.  /* (IF LASTKEY = F5 OR CTRL-D) */
    end.
 end. /* MAINLOOP */
