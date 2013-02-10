/* GUI CONVERTED from yyictrrp.p (converter v1.78) Wed Dec  5 15:51:01 2012 */
/* yyictrrp.p - 调仓单报表                                                  */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

/* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "121205.1"}
{yyictrrp.i new}
define variable nbr   like tr_nbr  no-undo.
define variable nbr1  like tr_nbr  no-undo.
define variable part  like pt_part no-undo.
define variable part1 like pt_part no-undo.
define variable site  like si_site no-undo.
define variable site1 like si_site no-undo.
define variable loc   like loc_loc no-undo.
define variable loc1  like loc_loc no-undo.
define variable effdate   like tr_effdate no-undo.
define variable effdate1  like tr_effdate no-undo.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/

 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   nbr   colon 25
   nbr1  label {t001.i} colon 44
   part  colon 25
   part1 label {t001.i} colon 44
   site  colon 25
   site1 label {t001.i}  colon 44
   loc   colon 25
   loc1  label {t001.i}  colon 44
   effdate   colon 25
   effdate1  label {t001.i}  colon 44 skip
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


{wbrp01.i}
repeat:
   empty temp-table xim no-error.
   if nbr1 = hi_char then nbr1 = "".
   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".
   if loc1 = hi_char then loc1 = "".
   if effdate = low_date then effdate = ?.
   if effdate1 = hi_date then effdate1 = ?.

   if c-application-mode <> 'web' then
      update nbr nbr1 part part1 site site1 loc loc1 effdate effdate1 with frame a.

   {wbrp06.i &command = update
             &fields = " nbr nbr1 part part1 site site1 loc loc1 effdate effdate1 "
             &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if nbr1 = "" then nbr1 = hi_char.
      if part1 = "" then part1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if loc1 = "" then loc1 = hi_char.
      if effdate = ? then effdate = low_date.
      if effdate1 = ? then effdate1 = hi_date.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 400
               &pagedFlag = "NOPAGE"
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


   {mfphead.i}

   for each tr_hist no-lock use-index tr_nbr_eff
       where tr_domain = global_domain
         and tr_nbr >= nbr and tr_nbr <= nbr1 and tr_nbr <> ""
         and tr_effdate >= effdate and tr_effdate <= effdate1
         and tr_part >= part and tr_part <= part1
         and tr_site >= site and tr_site <= site1
         and tr_loc >= loc and tr_loc <= loc1
         and (tr_type = "ISS-TR"):
        create xim.
        assign xim_nbr = tr_nbr
               xim_part = tr_part
               xim_qty_req = tr_qty_loc
               xim_fsite = tr_site
               xim_floc  = tr_loc
               xim_flot  = tr_serial
               xim_effdate = tr_effdate
               xim_sn = integer(tr_trnbr).
   end.

   for each xim exclusive-lock:
       find first pt_mstr no-lock where pt_domain = global_domain and
                  pt_part = xim_part no-error.
       if available pt_mstr then do:
          assign xim_desc = pt_desc1.
       end.
       find first tr_hist use-index tr_nbr_eff no-lock where
                  tr_domain = global_domain and
                  tr_effdate = xim_effdate and
                  integer(tr_trnbr) = xim_sn + 1 and
                  tr_nbr = xim_nbr and tr_part = xim_part and
                  tr_type = "RCT-TR" and tr_qty_loc = -1 * xim_qty_req
                  no-error.
       if available tr_hist then do:
          assign xim_tsite = tr_site
                 xim_tloc = tr_loc
                 xim_tlot = tr_serial.
       end.
       else do:

       end.
   end.

   for each xim with frame b width 400 no-attr-space:
       setFrameLabels(frame b:handle).
       display xim_nbr
               xim_part
               xim_desc
               xim_sn
               xim_qty_req
               xim_fsite
               xim_floc
               xim_flot
               xim_tsite
               xim_tloc
               xim_tlot
               xim_effdate
                WITH STREAM-IO /*GUI*/ .

   end.
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}