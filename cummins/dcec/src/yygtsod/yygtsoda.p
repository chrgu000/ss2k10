/* zzgtsoda.i -                                                           */
/*                                                                        */
/*  LAST MODIFIED   DATE: 2004-08-30 11:13  BY: *LB01*  LONG BO ATOS ORIGIN */
/*  LAST MODIFIED   DATE: 2008-04-7         BY: *frk* Frank Sun ATOS ORIGIN */
{mfdeclre.i}
define TEMP-TABLE sodet like sod_det.  /*2004-09-01 13:18*/
define buffer sodet2 for sodet.
/* define variable gdinvmaxamt as decimal initial 11000000. һǧһ����*/
define variable tmpqty  as decimal   format "->>>>>>>>>>>>>>9.9<<<<<".
define shared variable so_recno as recid.
define shared variable inv_date like ar_date.

define shared variable v_curr    like so_curr .

define shared variable v_sonbr1  like so_nbr .
define shared variable v_sonbr2  like so_nbr .
define shared variable v_cust1   like so_cust .
define shared variable v_cust3   like so_cust .
define shared variable v_cust2   like so_cust .
define shared variable v_bill1   like so_bill .
define shared variable v_bill2   like so_bill .
define shared variable v_date1   like so_ship_date .
define shared variable v_date2   like so_ship_date .

define shared variable yn         as logical initial yes.


define shared variable v_outfile    as character format "x(50)" label "�����ļ���".
define shared variable v_times      as   integer label "���ش���".
define shared variable v_dt         as   date.
DEFINE shared VARIABLE v_flag1      AS LOGICAL INITIAL NO.
define shared variable i            as   integer.

define shared variable iCount   as integer. /*LB01*/
define shared variable sLnHeaderDesc as char.

define shared variable strOutMstr as char format "x(600)".   /*lb01*/
define shared variable strOutDet  as char format "x(400)".   /*lb01*/

define shared variable sonbr  like so_nbr.

define variable k as integer.

{zzgt002.i}
{zzgtsodc.i}

inv_date = today.

for each so_mstr
    where so_mstr.so_domain = global_domain
    and so_invoiced = no
    and so_to_inv = yes
    and so_curr = v_curr
    and lookup(so_site,v_sitestr) <> 0
    and (so_nbr >= v_sonbr1      and so_nbr <= v_sonbr2)
    and (so_ship_date >= v_date1 and so_ship_date <= v_date2)
    and (so_cust >= v_cust1      and so_cust <= v_cust2)
    and (so_bill >= v_bill1      and so_bill <= v_bill2)
    and (so_taxable = yes)
    with frame b width 200 down:

  create wkgtm.
  assign wkgtm_ref    = "DC@" + string(so_nbr,"x(8)")
            + string(month(v_dt),"99")
            + string(day(v_dt),"99")
            + string(v_times,"99")
            + string(i)
       wkgtm_line   = 0
       wkgtm_name   = ""
       wkgtm_taxid  = ""
       wkgtm_addr   = ""
       wkgtm_bkacct = ""
       wkgtm_rmks   = ""
       wkgtm_status = ""
       wkgtm_msg    = ""
       wkgtm_totamt = 0
       wkgtm_site   = so_site
       wkgtm_bill   = so_bill
       .

     v_cust3 = so_cust.


  /*check bill to*/
  find first ad_mstr where ad_domain = global_domain and ad_addr = so_bill
             no-lock no-error.
  if not available ad_mstr then do:
    wkgtm_status = "X".
    wkgtm_msg    = "����:δ�ҵ�Ʊ�ݿ���".
    next.
  end.
  /*check gold-tax info.*/
  find first ad_mstr where ad_domain = global_domain and ad_type = "c/s_bank"
            and ad__chr01 = so_bill no-lock no-error.
  if not available ad_mstr then do:
    wkgtm_status = "X".
    wkgtm_msg    = "����:δ�ҵ���˰��Ϣ".
    next.
  end.
  /*check ad_phone2*/
  if trim(ad_phone) = "" then do:
    wkgtm_status = "X".
    wkgtm_msg    = "ERROR:�ͻ��绰����Ϊ��".
    next.
  end.
  if ad_user1 = "" then do:
        wkgtm_status = "X".
        wkgtm_msg    = "ERROR:�ͻ���������Ϊ��".
        next.
  end.
  if ad_edi_tpid = "" then do:
    wkgtm_status = "X".
    wkgtm_msg    = "ERROR:�ͻ������ʺ�Ϊ��".
    next.
  end.
  wkgtm_bkacct = ad_user1 + ad_edi_tpid. /*������+�˺�*/

  wkgtm_name = substring(ad_name,1,length(ad_name))
           + substring(ad_line1,1,length(ad_line1)).
  wkgtm_addr = /*substring(ad_line1,1,length(ad_line1))+*/
             substring(ad_line2,1,length(ad_line2))
           + substring(ad_line3,1,length(ad_line3))
           + substring(ad_phone,1,length(ad_phone))
           + substring(ad_ext,1,length(ad_ext))
           .
  wkgtm_taxid = ad_gst_id.

    wkgtm_rmks = "������: " + so_nbr.
    /**/
  {zzgt001.i wkgtm_ref}
  {zzgt001.i wkgtm_name}
  {zzgt001.i wkgtm_taxid}
  {zzgt001.i wkgtm_addr}
  {zzgt001.i wkgtm_bkacct}
  {zzgt001.i wkgtm_rmks}

  if wkgtm_name = "" then do:
    wkgtm_status = "X".
    wkgtm_msg    = "����:�ͻ�����Ϊ��".
    next.
  end.
  if wkgtm_taxid = "" then do:
    wkgtm_status = "X".
    wkgtm_msg    = "����:��ֵ˰��Ϊ��".
    next.
  end.

  if length(wkgtm_taxid) <> 15 then do:
    wkgtm_status = "X".
    wkgtm_msg    = "����:��ֵ˰��ӦΪ15λ".
    next.
  end.

  if wkgtm_addr = "" then do:
    wkgtm_status = "X".
    wkgtm_msg    = "����:��ַΪ��".
    next.
  end.
  if wkgtm_bkacct = "" then do:
    wkgtm_status = "X".
    wkgtm_msg    = "����:��������Ϊ��".
    next.
  end.

  /*check sod_det*/
  find first sod_det where /*ss2012-8-16 b*/ sod_det.sod_domain = global_domain and /*ss2012-8-16 e*/ sod_nbr = so_nbr and sod_qty_inv <> 0
            no-lock no-error.
  if not available sod_det then do:
    wkgtm_status = "X".
    wkgtm_msg    = "����:����û����ϸ����".
    next.
  end.
  /*check so_disc_pct*/
  if so_disc_pct <> 0 then do:
    wkgtm_status = "X".
    wkgtm_msg    = "����:�����ۿ�Ӧϸ��������".
    next.
  end.

  /*check trl*/
    if so_trl2_amt <> 0 then do:
      find first trl_mstr
           where /*ss2012-8-16 b*/ trl_mstr.trl_domain = global_domain and /*ss2012-8-16 e*/ trl_code = so_trl2_cd
           no-lock no-error.
      if available trl_mstr then do:
        find first vt_mstr where vt_class = trl_taxc
        no-lock no-error.
        if available vt_mstr then do:
          if vt_tax_pct <> 0 then do:
            wkgtm_status = "X".
            wkgtm_msg = "ERROR:trl2 have tax".
            next.
          end.
        end.
      end.
    end.
    if so_trl3_amt <> 0 then do:
      find first trl_mstr
           where /*ss2012-8-16 b*/ trl_mstr.trl_domain = global_domain and /*ss2012-8-16 e*/ trl_code = so_trl3_cd
           no-lock no-error.
      if available trl_mstr then do:
        find first vt_mstr
             where vt_class = trl_taxc
        no-lock no-error.
        if available vt_mstr then do:
          if vt_tax_pct <> 0 then do:
            wkgtm_status = "X".
            wkgtm_msg = "ERROR:trl3 have tax".
            next.
          end.
        end.
      end.
    end.

  /*CHECK END.*/

  /*������1000����г���*/
  for each sodet:
    delete sodet.
  end.

  for each sod_det where /*ss2012-8-16 b*/ sod_det.sod_domain = global_domain and /*ss2012-8-16 e*/ sod_nbr = so_nbr
    and sod_qty_inv <> 0
    and (sod_qty_inv * sod_price) <> 0   /*suspend price as 0*/
    no-lock:
    i = 1000.
    tmpqty = sod_qty_inv.
    repeat:
      if tmpqty * sod_price
         <= gdinvmaxamt then do:
        create sodet.
        buffer-copy sod_det to sodet.
        assign
        sodet.sod_line = i + sodet.sod_line
        sodet.sod_qty_inv = tmpqty
        sodet.sod__log01 = no.
        leave.
      end.
      create sodet.
      buffer-copy sod_det to sodet.
      sodet.sod_qty_inv = round(gdinvmaxamt / sodet.sod_price, 0).
      if sodet.sod_qty_inv * sodet.sod_price > gdinvmaxamt then
        sodet.sod_qty_inv = sodet.sod_qty_inv - 1.
      assign
      sodet.sod_line = i + sodet.sod_line
      sodet.sod__log01 = no.
      tmpqty = tmpqty - sodet.sod_qty_inv.
      i = i + 1000.
    end.
  end.
/*
  for each sodet:
    disp sodet.sod_line format "9999" sodet.sod_part sodet.sod_qty_inv sodet.sod_price sodet.sod__log01 with stream-io.
  end.
*/
  /*׼�����ݣ��������1000����ֿ��ڶ��ŵ�����*/
  k = 0.
  if available wkgtm then delete wkgtm.

  for each sodet where not sodet.sod__log01 break by sodet.sod_line:
    k = k + 1.
    create wkgtm.
    assign wkgtm_ref    = "DC@" + string(so_nbr,"x(8)")
              + string(month(v_dt),"99")
              + string(day(v_dt),"99")
                  + string(v_times,"99")
                  + string(k)
         wkgtm_line   = 0
         wkgtm_name   = substring(ad_name,1,length(ad_name))
                  + substring(ad_line1,1,length(ad_line1))
         wkgtm_taxid  = ad_gst_id
         wkgtm_addr   = substring(ad_line2,1,length(ad_line2))
              + substring(ad_line3,1,length(ad_line3))
              + substring(ad_phone,1,length(ad_phone))
              + substring(ad_ext,1,length(ad_ext))
         wkgtm_bkacct = ad_user1 + ad_edi_tpid /*������+�˺�*/
         wkgtm_rmks   = "������: " + so_nbr + ";" + so_po + ";" + so_rmks
         wkgtm_status = ""
         wkgtm_msg    = ""
         wkgtm_totamt = 0
         wkgtm_site   = so_site
         wkgtm_bill   = so_bill
         .
    {zzgt001.i wkgtm_ref}
    {zzgt001.i wkgtm_name}
    {zzgt001.i wkgtm_taxid}
    {zzgt001.i wkgtm_addr}
    {zzgt001.i wkgtm_bkacct}
    {zzgt001.i wkgtm_rmks}

      for each sodet2 where not sodet2.sod__log01 no-lock break by sodet2.sod_line:


      if wkgtm_totamt + (sodet2.sod_qty_inv * sodet2.sod_price) > gdinvmaxamt
        then next.

        sodet2.sod__log01 = yes.


        find pt_mstr where /*ss2012-8-16 b*/ pt_mstr.pt_domain = global_domain and /*ss2012-8-16 e*/ pt_part = sodet2.sod_part
            no-lock no-error.
        create wkgtd.
        assign wkgtd_ref  = wkgtm_ref
               wkgtd_item = sodet2.sod_part
               wkgtd_line = sodet2.sod_line
               wkgtd_spec = sodet2.sod_part
               wkgtd_um   = sodet2.sod_um
               wkgtd_qty  = sodet2.sod_qty_inv
               wkgtd_kind = v_itemkind.
      if available pt_mstr then do:
        wkgtd_item = pt_desc2.
        if pt_pm_code = "C" then
          wkgtd_um = "��".
        else if pt_part_type = "58" then do:
          wkgtd_um = "̨".
          wkgtd_item = "������".
        end.
        else
          wkgtd_um = "��".

 /*frk*     remove the following code
            FIND cp_mstr WHERE cp_part =pt_part AND cp_cust = v_cust3 NO-LOCK NO-ERROR.
               IF AVAILABLE cp_mstr THEN
                   wkgtd.wkgtd_item= cp_cust_part.
            END.
  */

      end.



      /*TAXPCT*/
      /*
      message "sodet2.sod_taxable=" + string(sodet2.sod_taxable).
      pause.
      message "sodet2.sod_taxc=" + string(sodet2.sod_taxc).
      pause.
      */
      if sodet2.sod_taxable then do:
        find first vt_mstr
           where vt_class = sodet2.sod_taxc
        no-lock no-error.
        if available vt_mstr then wkgtd_taxpct = vt_tax_pct / 100.
      end.
      else do:
        wkgtd_status = "X".
        wkgtm_status = "X".
        wkgtm_msg    = wkgtm_msg + "/�����м�˰ΪNO".
        next.
      end.
      /*
      message "vt_tax_pct=" + string(vt_tax_pct).
      pause.
      */
      /*check*/
        {zzgt001.i wkgtd_item}
        {zzgt001.i wkgtd_spec}
        {zzgt001.i wkgtd_um}
        {zzgt001.i wkgtd_kind}

        if wkgtd_item = "" then do:
        wkgtd_status = "X".
        wkgtm_status = "X".
        wkgtm_msg    = "����:��Ʒ����Ϊ��".
        next.
        end.

        if not v_outtaxin then do:
          if sodet2.sod_tax_in then do:
            wkgtd_netamt  = round((sodet2.sod_qty_inv * sodet2.sod_price / (1 + wkgtd_taxpct)),2).
            wkgtd_discamt = round((sodet2.sod_qty_inv * sodet2.sod_list_pr / (1 + wkgtd_taxpct)  * sodet2.sod_disc_pct / 100),2).
            wkgtd_totamt  = round((wkgtd_netamt + wkgtd_discamt),2).
          end.
          else do:
            wkgtd_netamt  = round((sodet2.sod_qty_inv * sodet2.sod_price ),2).
            wkgtd_discamt = round((sodet2.sod_qty_inv * sodet2.sod_list_pr * sodet2.sod_disc_pct / 100),2).
            wkgtd_totamt  = round((wkgtd_netamt + wkgtd_discamt),2).
          end.
        end. /* not taxin*/
        else do: /*taxin*/
          if sodet2.sod_tax_in then do:
            wkgtd_netamt  = round((sodet2.sod_qty_inv * sodet2.sod_price),2).
            wkgtd_discamt = round((sodet2.sod_qty_inv * sodet2.sod_list_pr * sodet2.sod_disc_pct / 100),2).
            wkgtd_totamt  = round((wkgtd_netamt + wkgtd_discamt),2).
          end.
          else do:
            wkgtd_netamt  = round(round((sodet2.sod_qty_inv * sodet2.sod_price),2) * (1 + wkgtd_taxpct) , 2).
            wkgtd_discamt = round(round(sodet2.sod_qty_inv * sodet2.sod_list_pr * sodet2.sod_disc_pct / 100 ,2) * (1 + wkgtd_taxpct) ,2).
            wkgtd_totamt  = round((wkgtd_netamt + wkgtd_discamt),2).
          end.
        end. /*taxin*/

        wkgtm_totamt = wkgtm_totamt + wkgtd_totamt - wkgtd_discamt.
        wkgtm_line   = wkgtm_line + 1.

    end.
                        /* Add by Robin 20050912*/
      find first usrw_wkfl exclusive-lock
      where /*ss2012-8-16 b*/ usrw_wkfl.usrw_domain = global_domain and /*ss2012-8-16 e*/ usrw_key1 = "GOLD-TAX-SO"
      and usrw_key2 = wkgtm_ref no-error.
      if not available usrw_wkfl then
        create usrw_wkfl. usrw_wkfl.usrw_domain = global_domain.
      assign
        usrw_key1  = "GOLD-TAX-SO"
        usrw_key2 = wkgtm_ref
        usrw_key3 = usrw_key3 + string(so_nbr, "x(8)")
        usrw_datefld[1] = today.
      /* Add by Robin 20050912*/
    /*check total*/
    if wkgtm_totamt = 0 then do:
      wkgtm_status = "X".
      wkgtm_msg    = wkgtm_msg + "/��Ʊ�ܽ��Ϊ0".
      next.
    end.

  end.


end. /*each so_mstr*/

