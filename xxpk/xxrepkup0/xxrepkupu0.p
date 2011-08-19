/* xxrepkupu0.p - REPETITIVE PICKLIST CALCULATION                            */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 0CYH LAST MODIFIED: 05/30/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

{mfdeclre.i}

/* {xxtimestr.i}  */

define shared variable site   like si_site.
define shared variable site1  like si_site.
define shared variable wkctr  like op_wkctr.
define shared variable wkctr1 like op_wkctr.
define shared variable issue  like wo_rel_date.
define shared variable nbrstart as   character format "x(10)".

define variable timedif as integer.
define variable rev  as character.
define variable vRate as decimal.     /*����(��/ÿ��)                      */
define variable itceTime as integer.  /*ʱ�����ڼ�¼����ʱÿ���ֽ�ʱ��     */
define variable itceTimeS as integer. /*ʱ�����ڼ�¼����ʱÿ���ֽ�ʱ�俪ʼ */
define variable itceTimeE as integer. /*ʱ�����ڼ�¼����ʱÿ���ֽ�ʱ����� */
define variable i as integer.
define variable rid as recid.
define variable vqty  as decimal.
define variable vqty1 as decimal.
define variable vqtya as decimal.
define variable vqtya1 as decimal.
define variable vtype as character.
define variable v_number as character format "x(12)".
define variable errorst as logical.
define variable errornum as integer.
define variable ladnbr like lad_nbr.

    /* clear pk data */
    for each xxlw_mst exclusive-lock where xxlw_date = issue and
            (xxlw_site >= site) and (xxlw_site <= site1 or site1 = "") and
             xxlw_line >= wkctr and (xxlw_line <= wkctr1 or wkctr1 = ""):
             for each xxwa_det exclusive-lock where
                      xxwa_date = xxlw_date and xxwa_site = xxlw_site and
                      xxwa_line = xxlw_line and xxwa_par = xxlw_part
                 break by xxwa_nbr:
                 if first-of(xxwa_nbr) then do:
                   for each xxwd_det exclusive-lock where xxwd_nbr = xxwa_nbr:
                       delete xxwd_det. /*������ϸ*/
                   end.
                 end.
                 delete xxwa_det.   /*��ϸ��*/
             end.
        delete xxlw_mst.  /*����*/
    end.

/*    if can-find(first rps_mstr no-lock  use-index rps_site_line             */
/*       where rps_due_date = issue                                           */
/*         and rps_site >= site and (rps_site <= site1 or site1 = "")         */
/*         and rps_line >= wkctr and (rps_line <= wkctr1 or wkctr1 = "")      */
/*         and rps_user1 = "") then do:                                       */
/*         return.                                                            */
/*    end.                                                                    */
    /* �и�ʱ��� */    

    for each rps_mstr no-lock use-index rps_site_line
       where rps_due_date = issue
         and rps_site >= site and (rps_site <= site1 or site1 = "")
         and rps_line >= wkctr and (rps_line <= wkctr1 or wkctr1 = "")
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
                  xxlw_qty_src = rps_qty_req.
/*                xxlw__dec01 = rps_qty_req  /*���Գ���ʹ��,����ɾ��*/       */
/*                xxlw__int01 = xxlnw_etime. /*���Գ���ʹ��,����ɾ��*/       */
           assign itcetimes = itcetimee.
           leave calcloop1.
        end.
        else do:
      		 if itcetimes < xxlnw_etime then do:
           find first xxlw_mst exclusive-lock where
           			  xxlw_date = rps_due_date and
                  xxlw_site = rps_site and
                  xxlw_line = rps_line and
                  xxlw_part = rps_part and
                  xxlw_sn   = xxlnw_sn no-error.
           if not available xxlw_mst then do:
           create xxlw_mst.
           assign xxlw_date = rps_due_date
                  xxlw_site = rps_site
                  xxlw_line = rps_line
                  xxlw_part = rps_part
                  xxlw_sn   = xxlnw_sn
                  xxlw_start = itcetimes
                  xxlw_end = xxlnw_etime.
           end.
           assign xxlw_qty_src = xxlw_qty_src + rps_qty_req.
/*                xxlw__dec01 = rps_qty_req   /*���Գ���ʹ��,����ɾ��*/      */
/*                xxlw__int01 = xxlnw_etime.  /*���Գ���ʹ��,����ɾ��*/      */
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
          end. /*if itcetimes < xxlnw_etime then do:*/
          else do:
          	leave.
          end.
        end.
      end.
        for each xxlw_mst exclusive-lock where xxlw_date = rps_due_date
             and xxlw_site = rps_site and xxlw_line = rps_line
             and xxlw_part = rps_part:
             assign xxlw_qty_req = ROUND(vrate * (xxlw_end - xxlw_start),0).
        end.
    end. /* for each rps_mstr no-lock user-index rps_site_line where */
    for each xxlw_mst no-lock where
           xxlw_date = issue and
           xxlw_site >= site and (xxlw_site <= site1 or site1 = "") and
           xxlw_line >= wkctr and (xxlw_line <= wkctr1 or wkctr1 = ""):
           for each xxwp_mst no-lock where
              xxwp_date = xxlw_date and xxwp_site = xxlw_site and
              xxwp_line = xxlw_line and xxwp_par = xxlw_part:
       create xxwa_det.
       assign xxwa_date = xxlw_date
              xxwa_site = xxlw_site
              xxwa_line = xxlw_line
              xxwa_par = xxwp_par
              xxwa_part = xxwp_part
              xxwa_sn = xxlw_sn
              xxwa_qty_req = xxwp_qty_req * (xxlw_qty_req / xxlw_qty_src)
              xxwa_qty_pln = xxwa_qty_req
              xxwa_rtime = xxlw_start.
            end.
      end.

  /*����ȡ��,����ʱ������*/
  for each xxwa_det exclusive-lock where
           xxwa_date = issue and
           xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
           xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "")
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
           xxwa_date = issue and
           xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
           xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "")
  break by xxwa_date by xxwa_site by xxwa_line by xxwa_sn by xxwa_part:
      if first-of(xxwa_sn) then do:
        assign v_number = "".
        {gprun.i ""gpnrmgv.p"" "(""xxwa_det"",input-output v_number
                                 ,output errorst,output errornum)" }
        i = 1.
      end.
      assign xxwa_nbr = v_number
             xxwa_recid = i.
      i = i + 1.
  end.

/*C����������С��װ������*/
    for each xxwa_det exclusive-lock where
             xxwa_date = issue and
             xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
             xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = ""),
        each pt_mstr fields(pt_part pt_ord_mult pt__chr10) no-lock WHERE
             pt_mstr.pt_part = xxwa_part and
             pt_mstr.pt__chr10 = "C" and pt_mstr.pt_ord_mult <> 0
    break by xxwa_date by xxwa_site by xxwa_line by xxwa_part by xxwa_sn:
       if first-of(xxwa_line) then do:
          find first lad_det where lad_dataset = "rps_det" and
                     lad_site = xxwa_site and lad_line = xxwa_line
               no-lock no-error.
          if available(lad_det) then do:
             assign ladnbr = lad_nbr.
          end.
       end.
       assign xxwa_ladnbr = ladnbr.
       if first-of(xxwa_part) then do:
          assign vqty = xxwa_qty_req.
       end.
       else do:
          assign vqty = xxwa_qty_req - vqty.
       end.
       assign xxwa_qty_pln = (truncate(vqty / pt_ord_mult,0) + 1) * pt_ord_mult.
       assign vqty = (truncate(vqty / pt_ord_mult,0) + 1) * pt_ord_mult - vqty.
    end.



  /*��Ӧ���Ͽ�λ������*/
  for each xxwa_det no-lock where xxwa_date = issue and
           xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
           xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "")
      break by xxwa_date by xxwa_site by xxwa_line 
      			by xxwa_par by xxwa_sn by xxwa_part:
      assign vqty = xxwa_qty_pln
             vqty1 = 0.
      if first-of(xxwa_sn) then do:
         assign i = 1.
      end.
      if first-of(xxwa_part) then do:
          assign vqtya = 0
                 vqtya1 = 0.
          find first lad_det where lad_dataset = "rps_det" and
                     lad_site = xxwa_site and lad_line = xxwa_line and
                     SUBSTRING(lad_nbr,9 ,10 ) >= nbrstart and
                     lad_part = xxwa_part no-lock no-error.
          if availabl(lad_det) then do:
             assign recno = recid(lad_det).
          end.
      end.

      repeat:
         find first lad_det where recid(lad_det) = recno no-lock no-error.
         assign vqtya = lad_qty_all - vqtya1
                vqty = vqty - vqty1.
         if vqty <= vqtya then do:
         	 message xxwa_nbr xxwa_recid i view-as alert-box.
           create xxwd_det.
           assign xxwd_nbr = xxwa_nbr
                  xxwd_ladnbr = lad_nbr
                  xxwd_recid = xxwa_recid
                  xxwd_sn = i
                  xxwd_part = lad_part
                  xxwd_site = lad_site
                  xxwd_line = lad_line
                  xxwd_loc = lad_loc
                  xxwd_lot = lad_lot
                  xxwd_ref = lad_ref
                  xxwd_qty_plan = vqty.
            assign i = i + 1.
            assign vqtya1 = vqtya1 + vqty.
            leave.
         end.
         else do:
         	 message xxwa_nbr xxwa_recid i view-as alert-box.
           create xxwd_det.
           assign xxwd_nbr = xxwa_nbr
                  xxwd_ladnbr = lad_nbr
                  xxwd_recid = xxwa_recid
                  xxwd_sn = i
                  xxwd_part = lad_part
                  xxwd_site = lad_site
                  xxwd_line = lad_line
                  xxwd_loc = lad_loc
                  xxwd_lot = lad_lot
                  xxwd_ref = lad_ref
                  xxwd_qty_plan = vqtya.
           assign i = i + 1.
           assign vqty = vqty - vqtya
                  vqtya1 = vqtya1 + vqty.
           find next lad_det where lad_dataset = "rps_det" and
                 lad_site = xxwa_site and lad_line = xxwa_line and
                 SUBSTRING(lad_nbr,9 ,10 ) >= nbrstart and
                 lad_part = xxwa_part no-lock no-error.
           if availabl(lad_det) then do:
               assign recno = recid(lad_det).
           end.
           else do:
              leave.
           end.
         end.  /*else do:*/
      end.   /* repeat */
  end.
