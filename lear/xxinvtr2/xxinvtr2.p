/*xxictrcfcrp01.p for report the transaction of the items during a period    */
/*V8:ConvertMode=FullGUIReport                                               */
/* 貌似没有考虑 周期盘点和标签盘点 */
/* DISPLAY TITLE */
{mfdtitle.i "828"}

def var site like si_site.
def var prodline1 like pt_prod_line.
def var prodline2 like pt_prod_line.
def var part like pt_part.
def var part1 like pt_part.
def var abc  like pt_abc.
def var abc1 like pt_abc.
def var group1 like pt_group.
def var group2 like pt_group.
def var stat   like pt_status.
def var stat1  like pt_status.
def var loc    like loc_loc.
def var loc1   like loc_loc.
def var yn_eff like mfc_logical.
def var effdate like tr_effdate.
def var effdate1 like tr_effdate.

def var edqty like tr_qty_loc.
def var bgqty like tr_qty_loc.
def var inqty like tr_qty_loc.
def var outqty like tr_qty_loc.
def var tot_edqty like tr_qty_loc.
def var tot_bgqty like tr_qty_loc.
def var tot_inqty like tr_qty_loc.
def var tot_outqty like tr_qty_loc.

def var cst like tr_qty_loc.
def var edqty_amt like tr_qty_loc.

def var msg-nbr as inte.

DEF VAR I AS INTE.
DEF VAR LINECOUNT AS INTE.
DEF VAR trnbr LIKE tr_trnbr .

/* SELECT FORM */
form
 site colon 22
 prodline1 colon 22 prodline2 colon 49 label {t001.i}
 part colon 22      part1 colon 49 label {t001.i}
 abc  colon 22      abc1 colon 49 label {t001.i}
 group1 colon 22    group2 colon 49 label {t001.i}
 loc    colon 22    loc1   colon 49 label {t001.i}
 stat colon 22      stat1  colon 49 label {t001.i}
 effdate colon 22   effdate1 colon 49 label {t001.i}
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */

{wbrp01.i}
MainLoop:
repeat:
    if prodline2 = hi_char then prodline2 = "".
    if part1 = hi_char then part1 = "".
    if abc1 = hi_char then abc1 = "".
    if group2 = hi_char then group2 = "".
    if loc1 = hi_char then loc1 = "".
    if stat1 = hi_char then stat1 = "".
    if effdate = low_date then effdate = ?.
    if effdate1 = hi_date then effdate1 = ?.

   if c-application-mode <> 'web' then
      update site prodline1 prodline2 part part1 abc abc1 group1 group2
             loc loc1 stat stat1 effdate effdate1 with frame a.

   {wbrp06.i &command = update
      &fields = " site prodline1 prodline2 part part1 abc abc1 group1 group2
                  loc loc1 stat stat1 effdate effdate1 " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i site}
      {mfquoter.i prodline1}
      {mfquoter.i prodline2}
      {mfquoter.i part}
      {mfquoter.i part1}
      {mfquoter.i abc}
      {mfquoter.i abc1}
      {mfquoter.i group1}
      {mfquoter.i group2}
      {mfquoter.i loc}
      {mfquoter.i loc1}
      {mfquoter.i stat}
      {mfquoter.i stat1}
      {mfquoter.i effdate}
      {mfquoter.i effdate1}

    if prodline2 = "" then prodline2 = hi_char.
    if abc1 = "" then abc1 = hi_char.
    if group2 = "" then group2 = hi_char.
    if loc1 = "" then loc1 = hi_char.
    if part1 = "" then part1 = hi_char.
    if stat1 = "" then stat1 = hi_char.
    if effdate = ? then effdate = low_date.
    if effdate1 = ? then effdate1 = hi_date.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
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
   {mfphead.i}
    trnbr = 0 .
    FIND FIRST tr_hist NO-LOCK WHERE tr_domain = global_domain
          and tr_effdate >= effdate NO-ERROR .
    IF AVAIL tr_hist THEN trnbr = tr_trnbr .
                 find si_mstr no-lock where si_domain = global_domain
                  and si_site = site no-error.
                 if not available si_mstr or (si_db <> global_db) then do:
                     if not available si_mstr then msg-nbr = 708.
                     else msg-nbr = 5421.
                     {mfmsg.i msg-nbr 3}
                     undo, retry MainLoop.
                 end.

                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
     if return_int = 0 then do:
        {mfmsg.i 725 3}    /* USER DOES NOT HAVE ACCESS TO THIS SITE */
        undo,retry MainLoop.
     end.


    disp effdate column-label "起始日期" format "9999/99/99"
         effdate1 column-label "截止日期" format "9999/99/99" with frame b.
    for each in_mstr where in_domain = global_domain and
             in_site = site and in_loc >= loc and in_loc <= loc1 and
             (in_part >= part and in_part <= part1) no-lock,
        each pt_mstr where pt_domain = global_domain and pt_part = in_part and
            (pt_prod_line >= prodline1 and pt_prod_line <= prodline2) and
            (pt_ABC >= abc and pt_abc <= abc1) and
            (pt_status >= stat and pt_status <= stat1) and
            (pt_group >= group1 and pt_group <= group2) no-lock:
       edqty = in_qty_oh + in_qty_nonet.
       edqty = in_qty_oh.
       bgqty = 0.
       inqty = 0.
       outqty =0.
        for each tr_hist no-lock where tr_domain = global_domain
                 and tr_part = pt_part
                 and tr_site = in_site and tr_effdate >= effdate
                 and tr_ship_type = "" AND tr_trnbr >= trnbr
                 and (tr_qty_loc <> 0 or tr_type = "cst-adj")
                 /*and (tr_loc >= loc and tr_loc <= loc1)*/:
            if tr_effdate <= effdate1 then do:
                if tr_type begins "ISS" or tr_type = "CN-ISS" then
                    outqty = outqty - tr_qty_loc.
                if tr_type begins "RCT"  or tr_type = "CN-RCT" then
                    inqty = inqty + tr_qty_loc.
                if (tr_type = "CYC-RCNT" or tr_type = "CYC-CNT" or
                    tr_type = "TAG-CNT") then do:
                      if tr_qty_loc >= 0 then do:
                         assign inqty = inqty + tr_qty_loc.
                      end.
                      else do:
                         assign outqty = outqty - tr_qty_loc.
                      end.
                end.
            end. /* if tr_effdate */
            else if tr_qty_loc <> 0 then
                edqty = edqty - tr_qty_loc.
        end. /* for each tr_hist */

        /*bgqty = max(0, edqty - inqty + outqty ).*/
       bgqty = edqty - inqty + outqty.

           {gpsct03.i &cost=sct_cst_tot}

           edqty_amt = edqty * glxcst.

           disp pt_part pt_desc1 pt_desc2 pt_um pt_abc pt_prod_line pt_group
                in_loc pt_status bgqty label "期初库存"
                inqty label "入库" outqty label "出库"
                edqty label "期末库存" glxcst
                edqty_amt label "期末库存金额" with width 300.

      {mfrpchk.i}

   end. /*for each in_mstr,each pt_mstr*/

   /* REPORT TRAILER  */
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
