
/* xxrepkup.p - REPETITIVE PICKLIST CALCULATION                              */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 0CYH LAST MODIFIED: 05/30/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

{mfdtitle.i "110609.1"}
/* {xxrepkup1.i} */
/* {xxtimestr.i} */

define variable line   like ln_line no-undo.
define variable line1  like ln_line no-undo.
define variable issue  as date no-undo.
define variable issue1 as date no-undo.
define variable update_data as logical no-undo initial yes.
define variable timedif as integer.
define variable vRate as decimal. /* 产能(个/每秒) */
define variable itceTime as integer. /*时间用于记录计算时每个分界时间*/
define variable itceTimeS as integer. /*时间用于记录计算时每个分界时间开始*/
define variable itceTimeE as integer. /*时间用于记录计算时每个分界时间结束*/
/* SELECT FORM */
form
   line   colon 15
   line1  label {t001.i} colon 49 skip
   issue  colon 15
   issue1 label {t001.i} colon 49 skip(1)
   update_data colon 25
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */

{wbrp01.i}
repeat:
    if line1 = hi_char then line1 = "".
    if issue = low_date then issue = ?.
    if issue1 = hi_date then issue1 = ?.

if c-application-mode <> 'web' then
update line line1 issue issue1 update_data with frame a.

{wbrp06.i &command = update
          &fields = " line line1 issue issue1 update_data"
          &frm = "a"}

if (c-application-mode <> 'web') or
(c-application-mode = 'web' and
(c-web-request begins 'data')) then do:

   bcdparm = "".
   {mfquoter.i line  }
   {mfquoter.i line1 }
   {mfquoter.i issue }
   {mfquoter.i issue1}

   line1 = line1 + hi_char.
   if issue = ? then issue = low_date.
   if issue1 = ? then issue1 = hi_date.
end.
        /* SELECT PRINTER  */

        {mfselbpr.i "printer" 162}
        {mfphead.i}

    if update_data then do:
       for each xxlw_mst exclusive-lock:
           delete xxlw_mst.
       end.
    end.

    FOR EACH xxwk_det NO-LOCK  where xxwk_date >= issue and
           /*  (xxwk_date <= issue1 or issue1 = ?) and */
             xxwk_line >= line and (xxwk_line <= line1 or line1 = "")
             break by xxwk_site by xxwk_line by xxwk_sn:
        /*每个物料产能 (个/秒) */
        find first lnd_det no-lock where lnd_site = xxwk_site and
                   lnd_line = xxwk_line and lnd_part = xxwk_part no-error.
        if available lnd_det then do:
           vrate = lnd_rate / 3600.
        end.

        /* 初始化itceTime */
        if first-of(xxwk_line) then do:
            FIND FIRST xxlnw_det WHERE xxlnw_site = xxwk_site AND
                       xxlnw_line = xxwk_line AND xxlnw_on
                       NO-LOCK NO-ERROR.
              IF AVAILABLE xxlnw_det THEN DO:
                   assign itceTime = xxlnw_stime
                          itceTimeS = xxlnw_stime
                          itceTimeE = xxlnw_stime.
              END.

        end.    /* if first-of(xxwk_line) then do: */

            itcetimee = itcetimes + xxwk_qty_req / vrate.
            if itcetimee <= xxlnw_etime then do:
               if (xxlnw_etime - xxlnw_stime) * vrate >= xxwk_qty_req then do:
                  create xxlw_mst.
                  assign xxlw_date = xxwk_date
                         xxlw_site = xxwk_site
                         xxlw_line = xxwk_line
                         xxlw_part = xxwk_part
                         xxlw_sn = xxlnw_sn
                         xxlw_qty_req = xxwk_qty_req
                         xxlw_start = itcetimes
                         xxlw_end = itcetimee
                         xxlw__int01 = xxlnw_etime.
                  assign itcetimes = itcetimee.
               end.
            end.
            else do:

              create xxlw_mst.
              assign xxlw_date = xxwk_date
                     xxlw_site = xxwk_site
                     xxlw_line = xxwk_line
                     xxlw_part = xxwk_part
                     xxlw_sn = xxlnw_sn
                     xxlw_qty_req = xxwk_qty_req
                     xxlw_start = itcetimes
                     xxlw_end = xxlnw_etime
                     xxlw__int01 = xxlnw_etime.
              assign timedif = itcetimee - xxlnw_etime.
              FIND NEXT xxlnw_det WHERE xxlnw_site = xxwk_site AND
                       xxlnw_line = xxwk_line AND xxlnw_on
                       NO-LOCK NO-ERROR.
              IF AVAILABLE xxlnw_det THEN DO:
                 create xxlw_mst.
                 assign xxlw_date = xxwk_date
                        xxlw_site = xxwk_site
                        xxlw_line = xxwk_line
                        xxlw_part = xxwk_part
                        xxlw_sn = xxlnw_sn
                        xxlw_qty_req = xxwk_qty_req
                        xxlw_start = xxlnw_stime
                        xxlw_end = xxlnw_stime + timedif
                        xxlw__int01 = xxlnw_etime.
              END.
                assign itcetimee = xxlnw_stime + timedif.
                assign itcetimes = itcetimee.
            end.
        for each xxlw_mst exclusive-lock where xxlw_date = xxwk_date
             and xxlw_site = xxwk_site and xxlw_line = xxwk_line
             and xxlw_part = xxwk_part:
             assign xxlw_qty_req = vrate * (xxlw_end - xxlw_start).
        end.
    END.

    for each xxlw_mst no-lock with frame w:
        DISP xxlw_sn xxlw_date xxlw_site xxlw_line xxlw_part xxlw_qty
             string(xxlw_start,"HH:MM:SS") column-label "Start At"
             string(xxlw_end,"HH:MM:SS") column-label "End At"
             string(xxlw__int01,"HH:MM:SS") column-label "End At"
             with width 300.
    end.

    for each xxlnw_det no-lock where xxlnw_line = "2rdc"
    break by xxlnw_line by xxlnw_sn with frame s:
        disp xxlnw_sn xxlnw_site xxlnw_line xxlnw_sn xxlnw_on
             xxlnw_start xxlnw_end xxlnw_rstmin with width 300.
    end.

/*        for each si_mstr                                                   */
/*            no-lock break by si_site with frame b width 132 no-box.        */
/*                                                                           */
/*           /* SET EXTERNAL LABELS */                                       */
/*           setFrameLabels(frame b:handle).                                 */
/*                                                                           */
/*           display  si_site si_desc.                                       */
/*           {mfrpexit.i}                                                    */
/*        end.                                                               */

        /* REPORT TRAILER  */
        {mfrtrail.i}

end.  /* repeat: */

{wbrp04.i &frame-spec = a}
