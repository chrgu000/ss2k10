/* xxswtbl - SCROLLING INQUIRY ON PROGRESS TABLE CP FROM swdb.p              */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 0CYH LAST MODIFIED: 12/17/10   BY: zy                           */
/* REVISION: 0CYH LAST MODIFIED: 13/26/11   BY: zy        Add EB common   *EB*/
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

define shared variable global_user_lang_dir like lng_mstr.lng_dir.
define shared variable global_userid as character.
/*eb define shared variable global_domain as character.                      */

{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define variable i as integer.
define variable sfile like qaddb._file._file-name column-label "File".
define variable v_desc like qaddb._file._desc column-label "Desc".
define variable frameval as character.
define variable framevalsave  as character no-undo.
define shared variable stline as character format "x(78)" extent 13.

form
   sfile  format "x(32)"
   v_desc format "x(45)"
with frame b 12 down centered overlay row 6
width 80 title color normal (getFrameTitle("table_detail",28)).

setFrameLabels(frame b:handle).

if frame-value <> ? then do:
   frameval = frame-value.
   framevalsave = frame-value.
end.

view frame b.

status input off.
status default stline[4].

find first qaddb.qad_wkfl no-lock where 
/*eb  		 qad_domain = global_domain and                                    */
           qad_key1 = "xxgettable" and qad_key2 = global_userid no-error.
if available qad_wkfl and qad_charfld[1] <> "" then do:
   create alias dictdb for database value(qad_charfld[1]).
end.
else do:
   create alias dictdb for database qaddb no-error.
end.
for each dictdb._File no-lock where (index(_file-name,qad_charfld[2])>0 or
    qad_charfld[2] = ""):
    display _FILE-NAME @ sfile _desc @ v_desc with frame b.
    down 1 with frame b.
end.

do on endkey undo, leave:
   choose row sfile keys frameval with frame b.
   if frame-value <> ? then
      frameval = frame-value.
   else
      frameval = framevalsave.
   if lastkey = keycode("GO") or lastkey = keycode("F1")
   or lastkey = keycode("RETURN") or lastkey = keycode("CTRL-X") and
      frame-value <> ?
   then
      frameval = frame-value.
   else
      frameval = framevalsave.
   frame-value = frameval.
end.
hide frame b.
