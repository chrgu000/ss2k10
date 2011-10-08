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
define variable issue  as date no-undo initial today.
define variable issue1 as date no-undo initial today.
define variable nbr  as character format "x(10)" label "Picklist Number".
define variable nbr1 as character format "x(10)".
define variable update_data as logical no-undo initial yes.
define variable timedif as integer.
define variable rev  as character.
define variable vRate as decimal.     /*����(��/ÿ��)                      */
define variable itceTime as integer.  /*ʱ�����ڼ�¼����ʱÿ���ֽ�ʱ��     */
define variable itceTimeS as integer. /*ʱ�����ڼ�¼����ʱÿ���ֽ�ʱ�俪ʼ */
define variable itceTimeE as integer. /*ʱ�����ڼ�¼����ʱÿ���ֽ�ʱ����� */
define variable i as integer.
define variable rid as recid.
define variable vqty  as decimal.
define variable vtype as character.
define variable v_number as character format "x(12)".
define variable errorst as logical.
define variable errornum as integer.
/* SELECT FORM */
form
   site   colon 20
   site1  label {t001.i} colon 50 skip
   line   colon 20
   line1  label {t001.i} colon 50 skip
   issue  colon 20
   issue1 label {t001.i} colon 50 skip
   nbr    colon 20
   nbr1   label {t001.i} colon 50 skip
   update_data colon 25
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */
    find first qad_wkfl no-lock where qad_key1 = "xxrepkup0.p" and
               qad_key2 = "xxrepkup1.p" no-error.
    if available qad_wkfl then do:
        assign nbr = qad_key3.
    end.
    find first rpc_ctrl no-lock no-error.
    nbr1 = rpc_nbr_pre + string(rpc_nbr - 1).
{wbrp01.i}
repeat:
    if site1 = hi_char then site1 = "".
    if line1 = hi_char then line1 = "".
    if issue = low_date then issue = ?.
    if issue1 = hi_date then issue1 = ?.

if c-application-mode <> 'web' then
update site site1 line line1 issue issue1 nbr nbr1 update_data
       with frame a.

{wbrp06.i &command = update
          &fields = " site site1 line line1 issue issue1 nbr nbr1
                      update_data "
          &frm = "a"}

if (c-application-mode <> 'web') or
(c-application-mode = 'web' and
(c-web-request begins 'data')) then do:

   bcdparm = "".
   {mfquoter.i site}
   {mfquoter.i site1}
   {mfquoter.i line}
   {mfquoter.i line1}
   {mfquoter.i issue}
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

    /* clear pk data */
    for each xxlw_mst exclusive-lock where xxlw_date >= issue and
            (xxlw_date <= issue1 or issue1 = ?) and
            (xxlw_site >= site) and (xxlw_site <= site1 or site1 = "") and
             xxlw_line >= line and (xxlw_line <= line1 or line1 = ""):
             for each xxwa_det exclusive-lock where
                      xxwa_date = xxlw_date and
                      xxwa_site = xxlw_site and
                      xxwa_line = xxlw_line and
                      xxwa_par = xxlw_part:
                 delete xxwa_det.   /*��ϸ��*/
             end.
        delete xxlw_mst.  /*����*/
    end.

    /* �и�ʱ��� */
    for each rps_mstr no-lock use-index rps_site_line
       where rps_due_date >= issue and (rps_due_date <= issue1 or issue1 = ?)
         and rps_site >= site and (rps_site <= site1 or site1 = "")
         and rps_line >= line and (rps_line <= line1 or line1 = "")
       break by rps_due_date by rps_site by rps_line by rps_user1:
        if first-of(rps_line) then do:
           find first xxlnw_det no-lock use-index xxlnw_siteline where
                      xxlnw_site = rps_site and xxlnw_line = rps_line and
                      xxlnw_on no-error.
           if available xxlnw_det then do:
              assign itcetimes = xxlnw_stime.
              assign recno = recid(xxlnw_det).
           end.
        end.
        /*ÿ�����ϲ��� (��/��) */
        find first lnd_det no-lock where lnd_site = rps_site and
                   lnd_line = rps_line and lnd_part = rps_part no-error.
        if available lnd_det then do:
           vrate = lnd_rate / 3600.
        end.
        itcetimee = itcetimes + rps_qty_req / vrate. /*����ʲôʱ�����*/

    calcloop1:
    repeat:
        find first xxlnw_det no-lock where recid(xxlnw_det) = recno no-error.
        if xxlnw_etime >= itcetimee then do:
           create xxlw_mst.
           assign xxlw_date = rps_due_date
                  xxlw_site = rps_site
                  xxlw_line = rps_line
                  xxlw_part = rps_part
                  xxlw_sn   = xxlnw_sn
                  xxlw_start = itcetimes
                  xxlw_end = itcetimee
                  xxlw_qty_src = rps_qty_req
                  xxlw__dec01 = rps_qty_req  /*���Գ���ʹ��,����ɾ��*/
                  xxlw__int01 = xxlnw_etime. /*���Գ���ʹ��,����ɾ��*/
           assign itcetimes = itcetimee.
           leave calcloop1.
        end.
        else do:
           create xxlw_mst.
           assign xxlw_date = rps_due_date
                  xxlw_site = rps_site
                  xxlw_line = rps_line
                  xxlw_part = rps_part
                  xxlw_sn   = xxlnw_sn
                  xxlw_start = itcetimes
                  xxlw_end = xxlnw_etime
                  xxlw_qty_src = rps_qty_req
                  xxlw__dec01 = rps_qty_req   /*���Գ���ʹ��,����ɾ��*/
                  xxlw__int01 = xxlnw_etime.  /*���Գ���ʹ��,����ɾ��*/
          assign timedif = xxlnw_etime
                 itcetimes = xxlnw_etime.
          find next xxlnw_det no-lock where xxlnw_site = rps_site and
                    xxlnw_line = rps_line and xxlnw_on no-error.
          IF AVAILABLE xxlnw_det THEN DO:
             assign recno = recid(xxlnw_det).
             assign timedif = xxlnw_stime - timedif.
             assign itcetimee = itcetimee + timedif
                    itcetimes = itcetimes + timedif.
          END.
        end.
      end.
        for each xxlw_mst exclusive-lock where xxlw_date = rps_due_date
             and xxlw_site = rps_site and xxlw_line = rps_line
             and xxlw_part = rps_part:
             assign xxlw_qty_req = ROUND(vrate * (xxlw_end - xxlw_start),0).
        end.
    end. /* for each rps_mstr no-lock user-index rps_site_line where */

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
           xxlw_line >= line and (xxlw_line <= line1 or line1 = ""),
      each levx no-lock where levx_par = xxlw_part
      by xxlw_date by xxlw_site by xxlw_line by xxlw_sn by xxlw_start:
           find first xxwa_det exclusive-lock where
                      xxwa_date = xxlw_date and
                      xxwa_site = xxlw_site and
                      xxwa_line = xxlw_line and
                      xxwa_par = levx_par and
                      xxwa_part = levx_part and
                      xxwa_sn = xxlw_sn and
                      xxwa_rtime = xxlw_start no-error.
           if not available xxwa_det then do:
                  create xxwa_det.
                  assign
                         xxwa_date = xxlw_date
                         xxwa_site = xxlw_site
                         xxwa_line = xxlw_line
                         xxwa_par = levx_par
                         xxwa_part = levx_part
                         xxwa_sn = xxlw_sn
                         xxwa_qty_req = xxlw_qty_req
                         xxwa_rtime = xxlw_start
                          .
           end.
           else do:
              assign xxwa_qty_req = xxwa_qty_req + xxlw_qty_req.
           end.

  end.
 /*****
  for each xxlw_mst no-lock where
       xxlw_date >= issue and (xxlw_date <= issue1 or issue1 = ?) and
       xxlw_site >= site and (xxlw_site <= site1 or site1 = "") and
       xxlw_line >= line and (xxlw_line <= line1 or line1 = "")
       BREAK BY xxlw_date BY xxlw_site BY xxlw_line BY xxlw_start:
       display xxlw_date
               xxlw_site
               xxlw_line
               xxlw_part
               xxlw_sn
               string(xxlw_start,"hh:mm:ss") column-label "xxlnw_start
               string(xxlw_end  ,"hh:mm:ss") column-label "xxlnw_end"
               xxlw_qty_req
               xxlw__dec01
               string(xxlw__int01,"hh:mm:ss") column-label "xxlw__int01"
                with width 300.
  end.
*****/
  /*����ȡ��,����ʱ������*/
  for each xxwa_det exclusive-lock where
           xxwa_date >= issue and (xxwa_date <= issue1 or issue1 = ?) and
           xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
           xxwa_line >= line and (xxwa_line <= line1 or line1 = "")
  break by xxwa_date by xxwa_site by xxwa_line by xxwa_part by xxwa_sn:
        assign vtype = "*".
        if first-of(xxwa_part) then do:
           find first pt_mstr where pt_mstr.pt_part = xxwa_part
                no-lock no-error.
           if available pt_mstr then do:
              assign vtype = pt_mstr.pt__chr10.
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
            assign xxwa_pstime = -1.
        end.
  end. /* for each xxwa_det exclusive-lock where  */

  /*���㵥��,���*/

  for each xxwa_det exclusive-lock where
           xxwa_date >= issue and (xxwa_date <= issue1 or issue1 = ?) and
           xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
           xxwa_line >= line and (xxwa_line <= line1 or line1 = "")
  break by xxwa_date by xxwa_site by xxwa_line:
      if first-of(xxwa_line) then do:
        {gprun.i ""gpnrmgv.p"" "(""xxwa_det"",input-output v_number
                                 ,output errorst,output errornum)" }
        i = 1.
      end.
      assign xxwa_nbr = v_number
             xxwa_recid = i.
      i = i + 1.
  end.
/*  /*C����������С��װ������*/                                             */
/*  for each xxwa_det exclusive-lock where                                  */
/*           xxwa_date >= issue and (xxwa_date <= issue1 or issue1 = ?) and */
/*           xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and    */
/*           xxwa_line >= line and (xxwa_line <= line1 or line1 = ""),      */
/*      each pt_mstr no-lock where pt_mstr.pt_part = xxwa_part and          */
/*           pt_mstr.pt__chr10 = "C"                                        */
/*  break by xxwa_date by xxwa_site by xxwa_line by xxwa_part by xxwa_sn:   */
/*                                                                          */
/*  end.                                                                    */

    end.  /*   if update_data then do:  */

   /*����xxwa__dec01��¼�ڴ�֮ǰ��������*/
   for each xxwa_det exclusive-lock break by xxwa_part by xxwa_date
         by xxwa_site by xxwa_line by xxwa_rtime:
         if first-of (xxwa_part) then do:
            assign vqty = xxwa_qty_req.
         end.
         if not first-of(xxwa_part) then do:
            assign xxwa__dec01 = vqty.
            assign vqty = vqty + xxwa_qty_req.
         end.
   end.

   assign vqty = 0.
   for each xxwa_det no-lock where
            xxwa_date >= issue and (xxwa_date <= issue1 or issue1 = ?) and
            xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
            xxwa_line >= line and (xxwa_line <= line1 or line1 = "")
        with frame x width 320
        break by xxwa_date by xxwa_site by xxwa_line by xxwa_sn by xxwa_rtime:
       find first pt_mstr no-lock where pt_mstr.pt_part = xxwa_part no-error.

       display xxwa_nbr xxwa_recid xxwa_date xxwa_site xxwa_line
              /* xxwa_par  xxwa_sn */ xxwa_part
               string(xxwa_rtime,"hh:mm:ss") @ xxwa_rtime xxwa_qty_req
              /* xxwa_qty_pln */
               pt_mstr.pt_ord_min pt_mstr.pt__chr10
           /*    xxwa_qty_piss xxwa_qty_siss                        */
                 string(xxwa_pstime,"hh:mm:ss") @ xxwa_pstime
                 string(xxwa_petime,"hh:mm:ss") @ xxwa_petime
           /*    xxwa_pouser xxwa_podate                            */
           /*    string(xxwa_potime,"hh:mm:ss") @ xxwa_potime       */
               string(xxwa_sstime,"hh:mm:ss") @ xxwa_sstime
               string(xxwa_setime,"hh:mm:ss") @ xxwa_setime
           /*  xxwa_souser xxwa_sodate                              */
           /*  string(xxwa_sotime,"hh:mm:ss") @  xxwa_sotime        */
               with frame x down.

       for each lad_det WHERE lad_dataset = "rps_det"
                          and SUBSTRING(lad_nbr,9,10) >= nbr
                          and SUBSTRING(lad_nbr,9,10) <= nbr1
                          and lad_site = xxwa_site
                          and lad_line = xxwa_line
                          and lad_part = xxwa_part:
           down 1 with frame x.
           display SUBSTRING(lad_nbr,9,10) @ xxwa_line
                   lad_loc @ xxwa_part
                   lad_lot @ xxwa_rtime
                   lad_qty_all @ xxwa_qty_req
                   with frame x.
       end.  /*   for each lad_det   */


       setFrameLabels(frame x:handle).
  end.

  /*  REPORT TRAILER  */
   {mfrtrail.i}

end.  /* repeat: */

{wbrp04.i &frame-spec = a}