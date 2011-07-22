/* xxrepkup.p - REPETITIVE PICKLIST CALCULATION                              */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 0CYH LAST MODIFIED: 05/30/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

{mfdtitle.i "110718.1"}
{xxrepkup1.i}
/* {xxtimestr.i}  */
define variable site   like si_site no-undo.
define variable site1  like si_site no-undo.
define variable line   like ln_line no-undo.
define variable line1  like ln_line no-undo.
define variable issue  as date no-undo.
define variable issue1 as date no-undo.
define variable update_data as logical no-undo initial no.
define variable timedif as integer.
define variable vRate as decimal. /* 产能(个/每秒) */
define variable itceTime as integer.  /*时间用于记录计算时每个分界时间*/
define variable itceTimeS as integer. /*时间用于记录计算时每个分界时间开始*/
define variable itceTimeE as integer. /*时间用于记录计算时每个分界时间结束*/
define variable rid as recid.
define variable vqty  as decimal.
define variable vtype as character.
/* SELECT FORM */
form
   site   colon 15
   site1  label {t001.i} colon 49 skip
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
    if site1 = hi_char then site1 = "".
    if line1 = hi_char then line1 = "".
    if issue = low_date then issue = ?.
    if issue1 = hi_date then issue1 = ?.

if c-application-mode <> 'web' then
update site site1 line line1 issue issue1 update_data with frame a.

{wbrp06.i &command = update
          &fields = " site site1 line line1 issue issue1 update_data"
          &frm = "a"}

if (c-application-mode <> 'web') or
(c-application-mode = 'web' and
(c-web-request begins 'data')) then do:

   bcdparm = "".
   {mfquoter.i site}
   {mfquoter.i site1}
   {mfquoter.i line  }
   {mfquoter.i line1 }
   {mfquoter.i issue }
   {mfquoter.i issue1}

   line1 = line1 + hi_char.
   site1 = site1 + hi_char.
   if issue = ? then issue = low_date.
   if issue1 = ? then issue1 = hi_date.
end.
        /* SELECT PRINTER  */

        {mfselbpr.i "printer" 162}
        {mfphead.i}

    if update_data then do:
       for each xxlw_mst exclusive-lock where xxlw_date >= issue and
               (xxlw_date <= issue1 or issue1 = ?) and
               (xxlw_site >= site) and (xxlw_site <= site1 or site1 = "") and
                xxlw_line >= line and (xxlw_line <= line1 or line1 = ""):
                for each xxwa_det exclusive-lock where
                         xxwa_date = xxlw_date and
                         xxwa_site = xxlw_site and
                         xxwa_line = xxlw_line and
                         xxwa_par = xxlw_part:
                    delete xxwa_det.
                end.
           delete xxlw_mst.
       end.


    FOR EACH xxwk_det NO-LOCK where xxwk_date >= issue and
            (xxwk_date <= issue1 or issue1 = ?) and
             xxwk_site >= site and (xxwk_site <= site1 or site1 = "") and
             xxwk_line >= line and (xxwk_line <= line1 or line1 = "")
             break by xxwk_site by xxwk_line by xxwk_sn:

        /* 初始化itceTime */
        if first-of(xxwk_line) then do:
            FIND FIRST xxlnw_det use-index xxlnw_siteline
                 WHERE xxlnw_site = xxwk_site AND
                       xxlnw_line = xxwk_line AND xxlnw_on
                       NO-LOCK NO-ERROR.
            IF AVAILABLE xxlnw_det THEN DO:
                 assign itceTime = xxlnw_stime
                        itceTimeS = xxlnw_stime
                        itceTimeE = xxlnw_stime.
                 recno = recid(xxlnw_det).
            END.
        end.    /* if first-of(xxwk_line) then do: */
        else do:
          if recno <> ? then do:
             find first xxlnw_det where recid(xxlnw_det) = recno
                  no-lock no-error.
          end.
        end.
        /*每个物料产能 (个/秒) */
        find first lnd_det no-lock where lnd_site = xxwk_site and
                   lnd_line = xxwk_line and lnd_part = xxwk_part no-error.
        if available lnd_det then do:
           vrate = lnd_rate / 3600.
        end.

        itcetimee = itcetimes + xxwk_qty_req / vrate.
        if itcetimee <= xxlnw_etime then do:
           if (xxlnw_etime - xxlnw_stime) * vrate >= xxwk_qty_req then do:
              create xxlw_mst.
              assign xxlw_date = xxwk_date
                     xxlw_site = xxwk_site
                     xxlw_line = xxwk_line
                     xxlw_part = xxwk_part
                     xxlw_sn   = xxlnw_sn
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
                 xxlw_sn   = xxlnw_sn
                 xxlw_qty_req = xxwk_qty_req
                 xxlw_start = itcetimes
                 xxlw_end = xxlnw_etime
                 xxlw__int01 = xxlnw_etime.
          assign timedif = itcetimee - xxlnw_etime.
          FIND NEXT xxlnw_det use-index xxlnw_siteline
              WHERE xxlnw_site = xxwk_site AND
                    xxlnw_line = xxwk_line AND xxlnw_on NO-LOCK NO-ERROR.
          IF AVAILABLE xxlnw_det THEN DO:
             create xxlw_mst.
             assign xxlw_date = xxwk_date
                    xxlw_site = xxwk_site
                    xxlw_line = xxwk_line
                    xxlw_part = xxwk_part
                    xxlw_sn   = xxlnw_sn
                    xxlw_qty_req = xxwk_qty_req
                    xxlw_start = xxlnw_stime
                    xxlw_end = xxlnw_stime + timedif
                    xxlw__int01 = xxlnw_etime.
             recno = recid(xxlnw_det).
          END.
            assign itcetimee = xxlnw_stime + timedif.
            assign itcetimes = itcetimee.

        end.
        for each xxlw_mst exclusive-lock where xxlw_date = xxwk_date
             and xxlw_site = xxwk_site and xxlw_line = xxwk_line
             and xxlw_part = xxwk_part:
             assign xxlw_qty_req = vrate * (xxlw_end - xxlw_start).
        end.

    END.  /*  FOR EACH xxwk_det NO-LOCK */
    empty temp-table levx no-error.
    for each xxlw_mst no-lock where
        xxlw_date >= issue and (xxlw_date <= issue1 or issue1 = ?) and
        xxlw_site >= site and (xxlw_site <= site1 or site1 = "") and
        xxlw_line >= line and (xxlw_line <= line1 or line1 = "")
        break by xxlw_part:
        if first-of(xxlw_part) then do:
           assign vqty = 1.
           run getPhList(input xxlw_part,input xxlw_part,input-output vqty).
        end.
    end.

    for each xxlw_mst no-lock where
        xxlw_date >= issue and (xxlw_date <= issue1 or issue1 = ?) and
        xxlw_site >= site and (xxlw_site <= site1 or site1 = "") and
        xxlw_line >= line and (xxlw_line <= line1 or line1 = "")
        by xxlw_date by xxlw_site by xxlw_line by xxlw_sn by xxlw_start:

             for each levx no-lock where levx_par = xxlw_par:
             create xxwa_det.
             assign xxwa_date = xxlw_date
                    xxwa_site = xxlw_site
                    xxwa_line = xxlw_line
                    xxwa_par = xxlw_part
                    xxwa_part = levx_part
                    xxwa_sn = xxlw_sn
                    xxwa_qty_req = levx_qty * xxlw_qty_req
                    xxwa_rtime = xxlw_start.
             end.

    end.

    for each xxwa_det exclusive-lock where
             xxwa_date >= issue and (xxwa_date <= issue1 or issue1 = ?) and
             xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
             xxwa_line >= line and (xxwa_line <= line1 or line1 = "")
    break by xxwa_date by
     xxwa_site by xxwa_line by xxwa_part by xxwa_sn:
          assign vtype = "*".
          if first-of(xxwa_part) then do:
             find first pt_mstr where pt_part = xxwa_part no-lock no-error.
             if available pt_mstr then do:
             		assign vtype = pt__chr10.
             end.
          end.
          find last xxlnm_det where xxlnm_line = xxwa_line
                 and xxlnm_site = xxwa_site
                 and (xxlnm_type = vtype or xxlnm_type = "*")
                 no-lock no-error.
          if not available xxlnm_det then do:
             find first xxlnm_det no-lock no-error.
          end.
          if available xxlnm_det then do:
          	 find first xxlnw_det where xxlnw_site = xxwa_site
          	        and xxlnw_line = xxwa_line
          	        and xxlnw_sn = xxwa_sn no-lock no-error.
          	 if available xxlnw_det then do:
          	 assign xxwa_pstime = xxlnw_stime - xxlnm_pkstart * 60
          	        xxwa_petime = xxlnw_stime - xxlnm_pkend * 60
          	        xxwa_sstime = xxlnw_stime - xxlnm_sdstart * 60
          	        xxwa_setime = xxlnw_stime - xxlnm_sdend * 60.
          	 end.
          end.
          else do:
          		message xxwa_line " " xxwa_site view-as alert-box.
          		assign xxwa_pstime = -1.
          end.
    end.
    end.  /*   if update_data then do:  */

    for each xxwa_det no-lock
         with frame x width 300
         break by xxwa_date by xxwa_site by xxwa_line by xxwa_sn by xxwa_rtime:
        display xxwa_date xxwa_site xxwa_line xxwa_part xxwa_sn
                string(xxwa_rtime,"hh:mm:ss") @ xxwa_rtime xxwa_qty_req
                xxwa_qty_pln xxwa_qty_piss xxwa_qty_siss
                string(xxwa_pstime,"hh:mm:ss") @ xxwa_pstime
                string(xxwa_petime,"hh:mm:ss") @ xxwa_petime
                xxwa_pouser xxwa_podate
                string(xxwa_potime,"hh:mm:ss") @ xxwa_potime
                string(xxwa_sstime,"hh:mm:ss") @ xxwa_sstime
                string(xxwa_setime,"hh:mm:ss") @ xxwa_setime
                xxwa_souser xxwa_sodate
                string(xxwa_sotime,"hh:mm:ss") @  xxwa_sotime
                .
        setFrameLabels(frame x:handle).
   end.

   /* REPORT TRAILER  */
   {mfrtrail.i}

end.  /* repeat: */

{wbrp04.i &frame-spec = a}
