/* xxbwmta.p - convert browse to procedure file                              */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 1.0      LAST MODIFIED: 09/20/10   BY: zy                       */
/* 此程序用于将Browse转换为.p的程序以免多次重复做browse.                     */

DEFINE INPUT PARAMETER Vbrowse AS CHARACTER.
DEFINE INPUT PARAMETER Vfname  AS CHARACTER.
/*
define variable vbrowse as character initial "xx110".
define variable vfile   as character.
assign vfile = vbrowse + ".p".
*/

if vfname = "" then do:
OUTPUT TO value(substring(vbrowse,1,2) + "bw" + substring(vbrowse,3,3) + ".p").
end.
else do:
output to value(vfname) append.
end.
IF NOT CAN-FIND(FIRST brw_mstr NO-LOCK WHERE brw_name = Vbrowse) THEN DO:
    RETURN.
END.
if vfname = "" then do:
put unformat "~/*V8:ConvertMode=Maintenance" fill(" ",50) "*~/" skip.
put unformat "~{mfdtitle.i """ substring(string(year(today),"9999"),3,2)
             string(month(today),"99")
             string(day(today),"99") ".1" """~}" skip.
put unformat "define variable yn like mfc_logical no-undo." skip.
put unformat "~{gpcdget.i ""UT""~}" skip(1).
put unformat "Form yn colon 40" skip.
put unformat "with frame a side-labels width 80 attr-space." skip.
put unformat "setFrameLabels(frame a:handle)." skip(1).
put unformat "repeat with frame a:" skip.
put unformat "update yn." skip.
put unformat "if not yn then leave." skip(1).
end.
FOR EACH brw_mstr NO-LOCK WHERE brw_mstr.brw_name = Vbrowse:
    put unformat "find first brw_mstr exclusive-lock where ".
    put unformat "brw_mstr.brw_name = '" Vbrowse "' no-error." SKIP.
    put unformat "if not available brw_mstr then do:" skip.
    put unformat "          create brw_mstr." SKIP.
    put unformat "          assign brw_mstr.brw_name = '".
    put unformat brw_name "'."  skip.
    put unformat "end." SKIP.
    IF brw_mstr.brw_desc <> "" THEN
    put unformat "assign brw_mstr.brw_desc = '" brw_desc "'." skip.
    put unformat "assign brw_mstr.brw_view = '" brw_view "'" skip.
    IF brw_mstr.brw_cansee <> "" THEN
    put unformat "       brw_mstr.brw_cansee    = '" brw_cansee "'" skip.
    put unformat "       brw_mstr.brw_filter    = '" brw_filter "'" skip.
    put unformat "       brw_mstr.brw_userid    = '" brw_userid "'" skip.
    put unformat "       brw_mstr.brw_mod_date  = today" skip.
    IF brw_mstr.brw_user1 <> "" THEN
    put unformat "       brw_mstr.brw_user1     = '" brw_user1 "'" skip.
    IF brw_mstr.brw_user2 <> "" THEN
    put unformat "       brw_mstr.brw_user2     = '" brw_user2 "'" skip.
    put unformat "       brw_mstr.brw_sort_col  = '" brw_sort_col "'" skip.
    put unformat "       brw_mstr.brw_col_rtn   = '" brw_col_rtn "'"  skip.
    put unformat "       brw_mstr.brw_pwr_brw   = " brw_pwr_brw skip.
    put unformat "       brw_mstr.brw_lu_brw    = " brw_lu_brw skip.
    put unformat "       brw_mstr.brw_locked_col= " brw_locked_col skip.
    put unformat "       brw_mstr.brw_upd_brw   = " brw_upd_brw.
    IF brw_mstr.brw_include <> "" THEN
    put unformat skip "       brw_mstr.brw_include   = '" brw_include "'" .
    IF brw_mstr.brw__qadc01 <> "" THEN
    put unformat skip "       brw_mstr.brw__qadc01   = '" brw__qadc01 "'" .
    IF brw_mstr.brw__qadc02 <> "" THEN
    put unformat skip "       brw_mstr.brw__qadc02   = '" brw__qadc02 "'" .
    PUT UNFORMAT "." SKIP.
    FOR EACH brwt_det NO-LOCK WHERE brwt_det.brw_name = brw_mstr.brw_name:
        PUT UNFORMAT "find first brwt_det exclusive-lock where ".
        put unformat "brwt_det.brw_name = '" Vbrowse "' no-error." SKIP.
        put unformat "if not available brwt_det then do:" skip.
        PUT UNFORMAT "          create brwt_det." SKIP.
        put unformat "          assign brwt_det.brw_name = '".
        put unformat brwt.brw_name "'." skip.
        put unformat "end." skip.
        put unformat "assign brwt_det.brwt_seq   = " brwt_seq skip.
        put unformat "       brwt_det.brwt_table = '" brwt_table "'".
        IF brwt_det.brwt_join <> "" THEN
        put unformat skip "       brwt_det.brwt_join     = '" brwt_join "'".
        IF brwt_det.brwt_where <> "" THEN
        put unformat skip "       brwt_det.brwt_where    = '" brwt_where "'".
        IF brwt_det.brwt_userid <> "" THEN
        put unformat skip "       brwt_det.brwt_userid   = '" brwt_userid "'".
        put unformat skip "       brwt_det.brwt_mod_date = today".
        IF brwt_det.brwt_user1 <> "" THEN
        put unformat skip "       brwt_det.brwt_user1    = '" brwt_user1 "'".
        IF brwt_det.brwt_user2 <> "" THEN
        put unformat skip "       brwt_det.brwt_user2    = '" brwt_user2 "'".
        IF brwt_det.brwt__qadc01 <> "" THEN
        put unformat skip "       brwt_det.brwt__qadc01  = '" brwt__qadc01 "'".
        IF brwt_det.brwt__qadc02 <> "" THEN
        put unformat skip "       brwt_det.brwt__qadc02  = '" brwt__qadc02 "'".
        PUT UNFORMAT "."SKIP.
    END.
    FOR EACH brwf_det NO-LOCK WHERE brwf_det.brw_name = brw_mstr.brw_name:
        PUT UNFORMAT "find first brwf_det exclusive-lock where ".
        put unformat "brwf_det.brw_name = '" Vbrowse "' and" skip fill(" ",11).
        put unformat "brwf_det.brwf_seq = " brwf_det.brwf_seq " no-error." skip.
        put unformat "if not available brwf_det then do:" skip.
        PUT UNFORMAT "          create brwf_det." SKIP.
        put unformat "          assign brwf_det.brw_name = '".
        put unformat brw_name "'" skip.
        put unformat "                 brwf_det.brwf_seq = ".
        put unformat brwf_seq "."skip.
        put unformat "end." skip.
        put unformat "assign brwf_det.brwf_field    = '" brwf_field "'" .
        put skip.
        put unformat "       brwf_det.brwf_datatype = '" brwf_datatype "'".
        put skip.
        put unformat "       brwf_det.brwf_format   = '" brwf_format  "'".
        put skip.
        IF brwf_det.brwf_label <> "" THEN
        put unformat "       brwf_det.brwf_label    = '" brwf_label "'".
        put skip.
        IF brwf_det.brwf_col_label <> "" THEN
        put unformat "       brwf_det.brwf_col_label  = '" brwf_col_label "'".
        put skip.
        IF brwf_det.brwf_expression <> "" THEN
        put unformat "       brwf_det.brwf_expression = '" brwf_expression "'".
        put skip.
        IF brwf_det.brwf_table <> "" THEN
        put unformat "       brwf_det.brwf_table    = '" brwf_table "'".
        put skip.
        put unformat "       brwf_det.brwf_select   = "  brwf_select skip.
        put unformat "       brwf_det.brwf_sort     = "  brwf_sort   skip.
        IF brwf_det.brwf_userid <> "" THEN
        put unformat "       brwf_det.brwf_userid   = '" brwf_userid "'".
        put skip.
        put unformat "       brwf_det.brwf_mod_date = today".
        put skip.
        IF brwf_det.brwf_user1 <> "" THEN
        put unformat "       brwf_det.brwf_user1    = '" brwf_user1 "'" skip.
        IF brwf_det.brwf_user2 <> "" THEN
        put unformat "       brwf_det.brwf_user2    = '" brwf_user2 "'" skip.
        IF brwf_det.brwf__qadc01 <> "" THEN
        put unformat "       brwf_det.brwf__qadc01  = '" brwf__qadc01 "'".
        put skip.
        IF brwf_det.brwf__qadc02 <> "" THEN
        put unformat "       brwf_det.brwf__qadc02  = '" brwf__qadc02 "'".
        put skip.
        put unformat "       brwf_det.brwf_enable   = " brwf_enable "." skip.
    END.
END.
if vfname = "" then do:
put unformat "end.  ~/* repeat with frame a: *~/" skip.
put unformat "status input." skip.
end.
output close.
