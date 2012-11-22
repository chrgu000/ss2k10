/* GUI CONVERTED from yysscalc.p (converter v1.78) Fri Nov 16 17:01:22 2012 */
/* GUI CONVERTED from yysscalc.p (converter v1.78) Fri Nov 16 11:40:58 2012  */
/* yysscalc.p - Safety Stock Calc                                            */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 121116.1 LAST MODIFIED: 11/16/12 BY: zy                         */
/* REVISION END                                                              */

/* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "121116.1"}
{yysscalc.i "new"}
DEFINE VARIABLE h-tt AS HANDLE.
define variable abc    like in_abc       no-undo.
define variable abc1   like in_abc       no-undo.
define variable site   like ld_site      no-undo.
define variable site1  like ld_site      no-undo.
define variable part   like pt_part      no-undo.
define variable part1  like pt_part      no-undo.
define variable pline  like pt_prod_line no-undo.
define variable pline1 like pt_prod_line no-undo.
define variable dt     like ld_expire    no-undo.
define variable dt1    like ld_expire    no-undo.
define variable incl0  like mfc_logical  no-undo.
define variable i      as   integer      no-undo.
define variable qtyiss like tr_qty_loc   no-undo.  /*每月出货*/
define variable qtyisstot like tr_qty_loc no-undo. /*总出货*/
define variable stddev like tr_qty_loc   no-undo.
define variable qtyavg like tr_qty_loc   no-undo.

/* SELECT FORM */


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/

 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
pline           colon 18
   pline1          label {t001.i} colon 49 skip
   part           colon 18
   part1          label {t001.i} colon 49 skip
   abc            colon 18
   abc1           label {t001.i} colon 49
   site           colon 18
   site1          label {t001.i} colon 49
   dt             colon 18
   dt1            label {t001.i} colon 49
   incl0          colon 18 skip (1)
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

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


/* REPORT BLOCK */
run iniVar.
assign dt1 = date(month(today),1,year(today)) - 1.
assign dt = date(month(dt1),10,year(dt1)) - 31 * (vcyc - 1).
assign dt = date(month(dt),1,year(dt)).

{wbrp01.i}
repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


   if pline1 = hi_char
   then
      pline1 = "".
   if part1 = hi_char
   then
      part1 = "".
   if abc1  = hi_char
   then
      abc1  = "".
   if site1 = hi_char
   then
      site1 = "".
   if dt = low_date
   then
      dt = ?.
   if dt1 = hi_date
   then
      dt1 = ?.

   if c-application-mode <> 'web'
   then
      update
         pline pline1
         part part1
         abc  abc1
         site site1
         dt   dt1
         incl0
      with frame a.

      {wbrp06.i &command = update
                &fields = " pline pline1 part part1 abc abc1 site site1 dt dt1"
                &frm = "a"}

   if (c-application-mode <> 'web')
   or (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".

      {mfquoter.i pline }
      {mfquoter.i pline1}
      {mfquoter.i part }
      {mfquoter.i part1}
      {mfquoter.i abc  }
      {mfquoter.i abc1 }
      {mfquoter.i site }
      {mfquoter.i site1}
      {mfquoter.i dt   }
      {mfquoter.i dt1  }

      if pline1 = ""
      then
         pline1 = hi_char.
      if part1 = ""
      then
         part1 = hi_char.
      if abc1  = ""
      then
         abc1  = hi_char.
      if site1 = ""
      then
         site1 = hi_char.
      if dt = ?
      then
         dt = low_date.
      if dt1 = ?
      then
         dt1 = hi_date.

   end. /* IF (c-application-mode <> 'web') OR .. */
   if dt = low_date or dt1 = hi_date or dt1 < dt then do:
       {mfmsg.i 27 3}
       undo,retry.
   end.
   if day(dt) <> 1 then do:
      {mfmsg.i 27 3}
      undo,retry.
   end.
   if month(dt1 + 1) = month(dt1) then do:
      {mfmsg.i 27 3}
      undo,retry.
   end.
   vcyc = getMonths(dt,dt1).
   run iniSSwkfl(input vcyc,input dt).
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "window"
               &printWidth = 162
               &pagedFlag = "nopage"
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

/*   {mfphead.i} */

for each xss_mstr exclusive-lock: delete xss_mstr. end.
   for each in_mstr
   fields(in_domain in_abc in_part in_qty_oh in_site in_abc)
    where in_mstr.in_domain = global_domain
     and in_part >= part and in_part <= part1
     and in_site >= site and in_site <= site1
     and in_abc >= abc
     and in_abc <= abc1
    no-lock,
       each pt_mstr
   fields(pt_domain pt_desc1 pt_part pt_prod_line pt_sfty_stk)
    where pt_mstr.pt_domain = global_domain and  pt_part = in_part
     and (pt_prod_line >= pline
     and pt_prod_line  <= pline1)
   no-lock
   break by pt_prod_line
         by pt_part
         by in_site:
      assign qtyisstot = 0
             stddev = 0
             qtyavg = 0.
      for each xssd_det exclusive-lock: delete xssd_det. end.
      for each usrw_wkfl no-lock where usrw_domain = global_domain
           and usrw_key1 = v_key1 break by usrw_key1 by usrw_key2:
               assign qtyiss = 0.
         for each tr_hist
            fields(tr_domain tr_part tr_effdate tr_type tr_qty_loc tr_site)
            no-lock use-index tr_part_eff
              where tr_domain = global_domain
                and tr_part = in_part
                and tr_effdate >= usrw_datefld[1]
                and tr_effdate <= usrw_datefld[2]
                and tr_site = in_site
                and tr_type = "ISS-SO":
             assign qtyiss = qtyiss + (-1 * tr_qty_loc).
          end.
          find first xssd_det exclusive-lock where xssd_part = in_part
                 and xssd_site = in_site and xssd_i = usrw_intfld[1] no-error.
          if not available xssd_det then do:
             create xssd_det.
             assign xssd_part = in_part
                    xssd_site = in_site
                    xssd_i = usrw_intfld[1].
          end.
          assign xssd_qty_iss = qtyiss.
          qtyisstot = qtyisstot + qtyiss.
      end.

      find first xss_mstr exclusive-lock where xss_part = in_part
             and xss_site = in_site no-error.
      if not available xss_mstr then do:
         create xss_mstr.
         assign xss_part = in_part
                xss_site = in_site.
      end.
          assign xss_abc = in_abc
                 xss_desc = pt_desc1.
          if in_abc = "A" then do:
             assign xss_k = vka.
          end.
          else if in_abc = "B" then do:
             assign xss_k = vkb.
          end.
          else do:
             assign xss_k = vkc.
          end.
          find first ptp_det no-lock where ptp_domain = global_domain and
                     ptp_part = in_part and ptp_site = in_site no-error.
          if available ptp_det then do:
             assign xss_sfty_stk = ptp_sfty_stk.
          end.
          else do:
             assign xss_sfty_stk = pt_sfty_stk.
          end.
          assign qtyavg = qtyisstot / vcyc when vcyc <> 0.
          assign xss_qty_loc = in_qty_oh
                 xss_qty_iss = qtyisstot
                 xss_qty_avg = qtyavg.
          assign stddev = 0.
          for each xssd_det no-lock where xssd_part = in_part
               and xssd_site = in_site:
               assign stddev = stddev + (xssd_qty_iss - qtyavg) * (xssd_qty_iss - qtyavg) .
          end.
          assign xss_std_dev = sqrt(stddev / vcyc) when vcyc <> 0.
          assign xss_sfty_stkn = xss_qty_avg + 1.25 * xss_k * xss_std_dev.

   end. /* FOR EACH in_mstr ... */

   for each xss_mstr no-lock where (xss_sfty_stkn <> 0 or not incl0)
   with frame c down width 162:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).

      display xss_part
              xss_site
              xss_sfty_stkn / vtat @ xss_sfty_stkn
              xss_sfty_stk
              xss_qty_loc
              xss_abc
              xss_k
              vtat
              xss_desc
              xss_qty_iss
              xss_qty_avg
              xss_std_dev WITH STREAM-IO /*GUI*/ .
   end.
  {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end. /* REPEAT */
{wbrp04.i &frame-spec = a}
