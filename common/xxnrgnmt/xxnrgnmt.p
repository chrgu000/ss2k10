/* xxnrgnmt.p - Utility to Create nr_mstr recordset Source Files              */
/*V8:ConvertMode=Maintenance                                                  */
/************************* REVISION HISTORY ***********************************/
/* REVISION:111520.1 Create: 05/20/11 BY: zy                                  */
/* REVISION: 14YP LAST MODIFIED: 01/04/11 BY: zy Add EB common             *EB*/
/* Environment: Progress:10.1B   QAD:eb21sp5    Interface:                    */
/******************************************************************************/
/*-Revision:[15YJ]-------------------------------------------------------------
  Purpose:export nr_mstr record to source code for install to custmer
  Notes:
------------------------------------------------------------------------------*/
{mfdtitle.i "15YJ" }

define variable seqid  like nr_seqid no-undo format "x(16)".
define variable seqid1 like nr_seqid no-undo format "x(16)".
define variable PREFIX like pct_prefix no-undo.
define variable vFile  as   character no-undo.

/* DISPLAY TEXT FRAME*/
{gpcdget.i "UT"}

/* INPUT SELECTION FRAME */
form
   skip(1)
   seqid  colon 15
   seqid1 colon 45 label {t001.i}
   PREFIX colon 15 validate(PREFIX <> "",
                            "ERROR: BLANK NOT ALLOWED. Please re-enter.")
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* GET SELECTION CRITERIA */
repeat:

   if seqid1 = hi_char then seqid1 = "".

   update
      seqid
      seqid1
      prefix
   with frame a.
   if seqid1 = seqid then assign seqid1 = seqid1 + hi_char.
   bcdparm = "".
   {mfquoter.i seqid}
   {mfquoter.i seqid1}
   {mfquoter.i prefix}

   if seqid1 = "" then seqid1 = hi_char.

   hide message no-pause.
   /* PROCESSING ... PLEASE WAIT */
   {pxmsg.i &MSGNUM=832 &ERRORLEVEL=1}

  for each nr_mstr no-lock where nr_seqid <> ""
       and nr_seqid >= seqid and nr_seqid <= seqid1:
      assign vfile = prefix + lower(replace(nr_seqid,"/",".")) + ".p".
      output to value(vfile).
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
        put unformat "if can-find(first nr_mstr no-lock where nr_seqid = '".
        put unformat nr_seqid "') or" skip "   ".
        put unformat "can-find(first nrh_hist no-lock where nrh_seqid = '".
        put unformat nr_seqid "') then do:" skip.
        put unformat fill (" ",2) "~{mfmsg.i 2041 3~}" skip.
        put unformat "pause." skip.
        put unformat "end." skip.
        put unformat "else do:" skip.
        put unformat fill(" ",5) "create nr_mstr." skip.
        put unformat fill(" ",5) "assign nr_seqid = '" nr_seqid "'" skip.
        put unformat fill(" ",12) "nr_desc = '".
        put unformat      replace(nr_desc,"'","''") "'" skip.
        put unformat fill(" ",12) "nr_dataset = '" .
        put unformat      replace(nr_dataset,"'",'"''"') "'"  skip.
        put unformat fill(" ",12) "nr_allow_discard = " nr_allow_discard skip.
        put unformat fill(" ",12) "nr_allow_void = " nr_allow_void skip.
        put unformat fill(" ",12) "nr_next_set = " nr_next_set skip.
        put unformat fill(" ",12) "nr_seg_type = '" nr_seg_type "'" skip.
        put unformat fill(" ",12) "nr_seg_nbr = '" nr_seg_nbr "'" skip.
        put unformat fill(" ",12) "nr_segcount = " nr_segcount skip.
        put unformat fill(" ",12) "nr_seg_rank = '" nr_seg_rank "'" skip.
        put unformat fill(" ",12) "nr_seg_ini = '" nr_seg_ini "'" skip.
        put unformat fill(" ",12) "nr_seg_min = '" nr_seg_min "'" skip.
        put unformat fill(" ",12) "nr_seg_max = '" nr_seg_max "'" skip.
        put unformat fill(" ",12) "nr_seg_reset = '" nr_seg_reset "'" skip.
        put unformat fill(" ",12) "nr_seg_value = '" nr_seg_value "'" skip.
        put unformat fill(" ",12) "nr_seg_format = '" nr_seg_format "'" skip.
        put unformat fill(" ",12) "nr_archived = " nr_archived skip.
        put unformat fill(" ",12) "nr_internal = " nr_internal skip.
        put unformat fill(" ",12) "nr_effdate = today - 1" skip.
        put unformat fill(" ",12) "nr_exp_date = ?" skip.
        put unformat fill(" ",12) "nr_user1 = '" nr_user1 "'" skip.
        put unformat fill(" ",12) "nr_user2 = '" nr_user2 "'" skip.
        put unformat fill(" ",12) "nr__qadc01 = '" nr__qadc01 "'" skip.
        put unformat fill(" ",12) "nr_curr_effdate = today - 1" skip.
        put unformat fill(" ",12) "nr_valuemask = '" nr_valuemask "'" skip.
/*EB*/  put unformat fill(" ",12) "nr_domain = global_domain" skip.
        put unformat fill(" ",12) "." skip.
        put unformat fill(" ",5) "~{mfmsg.i 1107 1~}" skip.
        put unformat "end." skip.
        put unformat "end.  ~/* repeat with frame a: *~/" skip.
        put unformat "status input." skip.
      output close.
  end.
   hide message no-pause.
   /* PROCESS COMPLETE */
   {pxmsg.i &MSGNUM=1107 &ERRORLEVEL=1}
end. /* repeat */
