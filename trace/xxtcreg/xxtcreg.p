/* xxtcreg.p - tracer regester                                               */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 11YK LAST MODIFIED: 01/20/11   BY: zy check xrcpath exists      */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "11YK"}

define variable del-yn like mfc_logical initial no.
define variable typedesc as character format "x(20)".
define variable bfldname as handle.
define variable bfld as handle.
define variable tcrtabfld like tcr_field.
define variable tcrtype like tcr_type.
define variable tcrmemo like tcr_memo.
define variable titlet0 as character format "x(16)".
define variable titlea0 as character format "x(16)".

assign titlet0 = getTermLabel("TRACE_DETAIL",20)
       titlea0 = getTermLabel("MAINTENANCE",20)
               + getTermLabel("TRACE_DETAIL",20).
form
     titlet0 colon 26 no-labels
with frame t0 side-labels width 80 attr-space.
setFrameLabels(frame t0:handle).
display titlet0 with frame t0.

form
    titlea0 colon 4 no-labels
with frame a0 side-labels width 34 attr-space.
setFrameLabels(frame t0:handle).
display titlea0 with frame a0.

form
  tcrtabfld tcrtype tcrmemo format "x(18)"
with overlay frame b 13 down with width 46 column 35 title color
       normal(getFrameTitle("TRACE_DETAIL",25))   attr-space.
setFrameLabels(Frame b:handle).
/* DISPLAY SELECTION FORM */
form
   tcr_table  colon 10 format "x(16)"
   tcr_field  colon 10 skip(1)
   tcr_type   colon 10
   typedesc   colon 10 no-label skip(1)
   tcr_memo   colon 8 format "x(22)" skip(2)
   tcr_date   colon 10
   tcr_userid colon 10
   usr_name   colon 6 format "x(22)" no-label
with frame a side-labels width 34 attr-space.
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame t0.
view frame a0.
view frame a.
view frame b.
repeat with frame a:

   prompt-for tcr_table tcr_field editing:
      /* FIND NEXT/PREVIOUS RECORD */
      if frame-field = "tcr_table" then do:
         {mfnp01.i tcr_reg tcr_table " tcr_table "
                 tcr_table tcr_table tcr_table}
         if recno <> ? then do:
            display tcr_table tcr_field tcr_type tcr_memo tcr_date tcr_userid.
            run dispTypeDesc(input tcr_field).
            find first usr_mstr no-lock where usr_userid = tcr_userid no-error.
            if available usr_mstr then do:
               display usr_name.
            end.
            else do:
               display "" @ usr_name.
            end.
            run dispFrameb(input tcr_table:screen-value,
                           input tcr_field:screen-value).
         end.
         if input tcr_table = "" then do:
            {mfmsg.i 40 3}
            undo, retry.
         end.
      end.
      else do:
         {mfnp01.i tcr_reg tcr_field tcr_field tcr_table
              " tcr_table:screen-value " tcr_table}
         if recno <> ? then do:
            display tcr_table tcr_field tcr_type tcr_memo tcr_userid tcr_date.
            run dispTypeDesc(input tcr_type).
         end.
         else do:
            display "" @ tcr_memo
                    global_userid @ tcr_userid
                    today @ tcr_date with frame a.
         end.
      end.
   end.  /* prompt-for tcr_table tcr_field editing: */

  if not can-find(first qaddb._file no-lock where _file-name =
         tcr_table:screen-value)
      then do:
      {mfmsg.i 6098 3}
      undo,retry.
  end.
  if tcr_field:screen-value <> "" then do:
     tcr_type:screen-value = "W".
     create buffer bfldname for table input tcr_table.
     bfld = bfldname:buffer-field(input tcr_field) no-error.
     if bfld=? then do:
        {pxmsg.i &MSGNUM=2275 &ERRORLEVEL=3}
         undo, retry.
     end.
  end.
  run dispFrameb(input tcr_table:screen-value,
                 input tcr_field:screen-value).
   /* ADD/MOD/DELETE  */
   find tcr_reg using tcr_table where tcr_table = input tcr_table and
   tcr_field = input tcr_field no-error.
   if not available tcr_reg then do:
      {mfmsg.i 1 1}
      create tcr_reg.
      assign tcr_table tcr_field tcr_memo
             tcr_userid = global_userid
             tcr_date = today.
      if tcr_field:screen-value = "" then assign tcr_type = "D".
                                     else assign tcr_type = "W".
      run dispTypeDesc(input tcr_type).
      display tcr_type "" @ tcr_memo.
   end.
   else do:
       display tcr_table tcr_field tcr_type tcr_memo tcr_userid tcr_date.
   end.
   recno = recid(tcr_reg).

   find first tcr_reg exclusive-lock where recid(tcr_reg) = recno no-error.

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   do on error undo, retry:
      set tcr_memo go-on("F5" "CTRL-D" ).

      /* DELETE */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      then do:
         del-yn = yes.
         {mfmsg01.i 11 1 del-yn}
         if not del-yn then undo, retry.
         delete tcr_reg.
         clear frame a.
         del-yn = no.
      end.
   end.
end.
status input.

procedure dispFrameb:
   define input parameter itable as character.
   define input parameter ifield as character.
   clear frame b no-pause.
   hide frame b.
   for each tcr_reg no-lock where tcr_table = itable and tcr_field >= ifield:
       if tcr_type = "W" then do:
          display tcr_field @ tcrtabfld
                  tcr_type @ tcrtype
                  tcr_memo @ tcrmemo with frame b.
       end.
       else do:
          display tcr_table @ tcrtabfld
                  tcr_type @ tcrtype
                  tcr_memo @ tcrmemo with frame b.
       end.
       down with frame b.
   end.
   view frame b.
end procedure.

procedure dispTypeDesc:
    define input parameter itype as character.
    display "" @ typedesc with frame a.
    if itype = "D" then do:
       display getTermLabel("Delete",10) @ typedesc with frame a.
    end.
    else if itype = "C" then do:
       display getTermLabel("Create",10) @ typedesc with frame a.
    end.
    else if itype = "W" then do:
       display getTermLabel("Write",10) @ typedesc with frame a.
    end.
end procedure.
