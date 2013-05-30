/* zzgtsoda.i -                                                           */
/*                                                                        */
/*  LAST MODIFIED   DATE: 2004-08-30 11:13  BY: *LB01*  LONG BO ATOS ORIGIN   */
/******************************************                             *513*
单位的逻辑变更
首先，判断发票中客户、零件在1.16中,是否维护有指定的单位，若有，则取1.16中CP_CUST_ECO的值；
否则，判断pt_type 是否为“58”，若为“58”，零件单位为“台”；
否则，零件单位为“件”。
 **********************************************/
/******************************************                              514*
 * 税率的取值由于版本升级不走vt_mstr 改到 tx2_mstr
 **********************************************/

{mfdeclre.i}

define TEMP-TABLE sodet like sod_det.  /*2004-09-01 13:18*/
define buffer sodet2 for sodet.
/* define variable gdinvmaxamt as decimal initial 11000000. /*一千一百万*/  */
define variable tmpqty  as decimal   format "->>>>>>>>>>>>>>9.9<<<<<".

define shared variable so_recno as recid.
define shared variable inv_date like ar_date.

define shared variable v_curr    like so_curr .

define shared variable v_sonbr1  like so_nbr .
define shared variable v_sonbr2  like so_nbr .
define shared variable v_cust1   like so_nbr.
define shared variable v_cust3   like so_cust .
define shared variable v_cust2   like so_cust .
define shared variable v_bill1   like so_bill .
define shared variable v_bill2   like so_bill .
define shared variable v_date1   like so_ship_date .
define shared variable v_date2   like so_ship_date .

define shared variable yn         as logical initial yes.


define shared variable v_outfile    as character format "x(50)" label "数据文件名".
define shared variable v_times      as   integer label "下载次数".
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
    where so_domain = global_domain and so_invoiced = no
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
  assign wkgtm_ref = "DC@" + string(so_nbr,"x(8)")
                   + string(month(v_dt),"99")
                   + string(day(v_dt),"99")
                   + string(v_times,"999")
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
  find first ad_mstr where ad_domain = global_domain and
             ad_addr = so_bill no-lock no-error.
  if not available ad_mstr then do:
    wkgtm_status = "X".
    wkgtm_msg    = "错误:未找到票据开往".
    next.
  end.
  /*check gold-tax info.*/
  find first ad_mstr where ad_domain = global_domain and
             ad_type = "c/s_bank" and ad__chr01 = so_bill no-lock no-error.
  if not available ad_mstr then do:
    wkgtm_status = "X".
    wkgtm_msg    = "错误:未找到金税信息".
    next.
  end.
  /*check ad_phone2*/
  if trim(ad_phone) = "" then do:
    wkgtm_status = "X".
    wkgtm_msg    = "ERROR:客户电话号码为空".
    next.
  end.
  if ad_user1 = "" then do:
        wkgtm_status = "X".
        wkgtm_msg    = "ERROR:客户银行名称为空".
        next.
  end.
  if ad_edi_tpid = "" then do:
    wkgtm_status = "X".
    wkgtm_msg    = "ERROR:客户银行帐号为空".
    next.
  end.
  wkgtm_bkacct = ad_user1 + ad_edi_tpid. /*开户行+账号*/

  wkgtm_name = substring(ad_name,1,length(ad_name))
           + substring(ad_line1,1,length(ad_line1)).
  wkgtm_addr = /*substring(ad_line1,1,length(ad_line1))+*/
             substring(ad_line2,1,length(ad_line2))
           + substring(ad_line3,1,length(ad_line3))
           + substring(ad_phone,1,length(ad_phone))
           + substring(ad_ext,1,length(ad_ext))
           .
  wkgtm_taxid = ad_gst_id.

    wkgtm_rmks = "订单号: " + so_nbr.
    /**/
  {zzgt001.i wkgtm_ref}
  {zzgt001.i wkgtm_name}
  {zzgt001.i wkgtm_taxid}
  {zzgt001.i wkgtm_addr}
  {zzgt001.i wkgtm_bkacct}
  {zzgt001.i wkgtm_rmks}

  if wkgtm_name = "" then do:
    wkgtm_status = "X".
    wkgtm_msg    = "错误:客户名称为空".
    next.
  end.
  if wkgtm_taxid = "" then do:
    wkgtm_status = "X".
    wkgtm_msg    = "错误:增值税号为空".
    next.
  end.

  if length(wkgtm_taxid) <> 15 then do:
    wkgtm_status = "X".
    wkgtm_msg    = "错误:增值税号应为15位".
    next.
  end.

  if wkgtm_addr = "" then do:
    wkgtm_status = "X".
    wkgtm_msg    = "错误:地址为空".
    next.
  end.
  if wkgtm_bkacct = "" then do:
    wkgtm_status = "X".
    wkgtm_msg    = "错误:银行数据为空".
    next.
  end.

  /*check sod_det*/
  find first sod_det where sod_domain = global_domain and
             sod_nbr = so_nbr and sod_qty_inv <> 0 no-lock no-error.
  if not available sod_det then do:
    wkgtm_status = "X".
    wkgtm_msg    = "错误:订单没有明细数据".
    next.
  end.
  /*check so_disc_pct*/
  if so_disc_pct <> 0 then do:
    wkgtm_status = "X".
    wkgtm_msg    = "错误:订单折扣应细至订单行".
    next.
  end.

  /*check trl*/
    if so_trl2_amt <> 0 then do:
      find first trl_mstr
           where trl_domain = global_domain and trl_code = so_trl2_cd
           no-lock no-error.
      if available trl_mstr then do:
/*514    find first vt_mstr where vt_class = trl_taxc                        */
/*514    no-lock no-error.                                                   */
/*514    if available vt_mstr then do:                                       */
/*514     if vt_tax_pct <> 0 then do:                                        */
/*514*/  find first tx2_mstr no-lock where tx2_domain = global_domain
/*514*/         and tx2_pt_taxc = trl_taxc no-error.
/*514*/ if available tx2_mstr then do:
/*514*/   if tx2_tax_pct <> 0 then do:
            wkgtm_status = "X".
            wkgtm_msg = "ERROR:trl2 have tax".
            next.
          end.
        end.
      end.
    end.
    if so_trl3_amt <> 0 then do:
      find first trl_mstr
           where trl_domain = global_domain and trl_code = so_trl3_cd
           no-lock no-error.
      if available trl_mstr then do:
/*514    find first vt_mstr where vt_class = trl_taxc                        */
/*514    no-lock no-error.                                                   */
/*514    if available vt_mstr then do:                                       */
/*514     if vt_tax_pct <> 0 then do:                                        */
/*514*/  find first tx2_mstr no-lock where tx2_domain = global_domain
/*514*/         and tx2_pt_taxc = trl_taxc no-error.
/*514*/ if available tx2_mstr then do:
/*514*/   if tx2_tax_pct <> 0 then do:
            wkgtm_status = "X".
            wkgtm_msg = "ERROR:trl3 have tax".
            next.
          end.
        end.
      end.
    end.

  /*CHECK END.*/

  /*将大于1000万的行撤分*/
  for each sodet:
    delete sodet.
  end.

  for each sod_det where sod_domain = global_domain and sod_nbr = so_nbr
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
  /*准备数据，如果大于1000万，则分开在多张单子上*/
  k = 0.
  if available wkgtm then delete wkgtm.

  for each sodet where sodet.sod_domain = global_domain and
       not sodet.sod__log01 break by sodet.sod_line:
    k = k + 1.
    create wkgtm.
    assign wkgtm_ref    = "DC@" + string(so_nbr,"x(8)")
              + string(month(v_dt),"99")
              + string(day(v_dt),"99")
                  + string(v_times,"999")
                  + string(k)
         wkgtm_line   = 0
         wkgtm_name   = substring(ad_name,1,length(ad_name))
                  + substring(ad_line1,1,length(ad_line1))
         wkgtm_taxid  = ad_gst_id
         wkgtm_addr   = substring(ad_line2,1,length(ad_line2))
              + substring(ad_line3,1,length(ad_line3))
              + substring(ad_phone,1,length(ad_phone))
              + substring(ad_ext,1,length(ad_ext))
         wkgtm_bkacct = ad_user1 + ad_edi_tpid /*开户行+账号*/
         wkgtm_rmks   = "订单号: " + so_nbr + ";" + so_po + ";" + so_rmks
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

      for each sodet2 where sodet2.sod_domain = global_domain and
               not sodet2.sod__log01 no-lock break by sodet2.sod_line:


      if wkgtm_totamt + (sodet2.sod_qty_inv * sodet2.sod_price) > gdinvmaxamt
        then next.


        sodet2.sod__log01 = yes.
        find pt_mstr where pt_domain = global_domain and
             pt_part = sodet2.sod_part no-lock no-error.
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
/*513        if pt_pm_code = "C" then                                        */
/*513          wkgtd_um = "套".                                              */
/*513        else                                                            */
        if pt_part_type = "58" then do:
           wkgtd_um = "台".
           wkgtd_item = "发动机".
        end.
        else
          wkgtd_um = "件".

          FIND cp_mstr WHERE cp_domain = global_domain and cp_part = pt_part
                         AND cp_cust = v_cust3 NO-LOCK NO-ERROR.
          IF AVAILABLE cp_mstr THEN do:
/*513*/      assign wkgtd.wkgtd_um = cp_cust_eco when(cp_cust_eco <> "").
             assign wkgtd.wkgtd_spec = cp_cust_part.
             assign wkgtd.wkgtd_item = cp_comment when(cp_comment <> "").
          end .
      end.

      /*TAXPCT*/
      /*
      message "sodet2.sod_taxable=" + string(sodet2.sod_taxable).
      pause.
      message "sodet2.sod_taxc=" + string(sodet2.sod_taxc).
      pause.
      */
      if sodet2.sod_taxable then do:
/*514    find first vt_mstr                                                  */
/*514       where vt_class = sodet2.sod_taxc                                 */
/*514    no-lock no-error.                                                   */
/*514    if available vt_mstr then wkgtd_taxpct = vt_tax_pct / 100.          */
/*514*/  find first tx2_mstr no-lock where tx2_domain = global_domain
/*514*/         and tx2_pt_taxc = sodet2.sod_taxc no-error.
/*514*/  if available tx2_mstr then do:
/*514*/     assign wkgtd_taxpct = tx2_tax_pct / 100.
/*514*/  end.
      end.
      else do:
        wkgtd_status = "X".
        wkgtm_status = "X".
        wkgtm_msg    = wkgtm_msg + "/订单行计税为NO".
        next.
      end.
    /*
      message "vt_tax_pct=" + string(vt_tax_pct) view-as alert-box.
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
        wkgtm_msg    = "错误:商品名称为空".
        next.
        end.

        if not v_outtaxin then do:
          if sodet2.sod_tax_in then do:
            /* ss - 130219.1 -b
            wkgtd_netamt  = round((sodet2.sod_qty_inv * sodet2.sod_price / (1 + wkgtd_taxpct)),2).
            wkgtd_discamt = round((sodet2.sod_qty_inv * sodet2.sod_list_pr / (1 + wkgtd_taxpct)  * sodet2.sod_disc_pct / 100),2).
            ss - 130219.1 -e */
            /* ss - 130219.1 -b */
            wkgtd_netamt  = round((sodet2.sod_qty_inv * ( sodet2.sod_price / (1 + wkgtd_taxpct) )),2).
            wkgtd_discamt = round((sodet2.sod_qty_inv * ( ( sodet2.sod_list_pr / (1 + wkgtd_taxpct) )  * sodet2.sod_disc_pct / 100 ) ),2).
           /* ss - 130219.1 -e */

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
            /* ss - 130219.1 -b
            wkgtd_netamt  = round(round((sodet2.sod_qty_inv * sodet2.sod_price),2) * (1 + wkgtd_taxpct) , 2).
            wkgtd_discamt = round(round(sodet2.sod_qty_inv * sodet2.sod_list_pr * sodet2.sod_disc_pct / 100 ,2) * (1 + wkgtd_taxpct) ,2).
           ss - 130219.1 -e */
           /* ss - 130219.1 -b */
            wkgtd_netamt  = round(sodet2.sod_qty_inv *  ( sodet2.sod_price * (1 + wkgtd_taxpct) ) , 2).
            wkgtd_discamt = round(sodet2.sod_qty_inv *  ( ( sodet2.sod_list_pr * sodet2.sod_disc_pct / 100 )  * (1 + wkgtd_taxpct) ) ,2).
          /* ss - 130219.1 -e */

            wkgtd_totamt  = round((wkgtd_netamt + wkgtd_discamt),2).
          end.
        end. /*taxin*/

        wkgtm_totamt = wkgtm_totamt + wkgtd_totamt - wkgtd_discamt.
        wkgtm_line   = wkgtm_line + 1.

    end.
                        /* Add by Robin 20050912*/
      find first usrw_wkfl exclusive-lock
      where usrw_domain = global_domain and usrw_key1 = "GOLD-TAX-SO"
        and usrw_key2 = wkgtm_ref no-error.
      if not available usrw_wkfl then
        create usrw_wkfl.
      assign
        usrw_key1  = "GOLD-TAX-SO"
        usrw_key2 = wkgtm_ref
        usrw_key3 = usrw_key3 + string(so_nbr, "x(8)")
        usrw_datefld[1] = today.
      /* Add by Robin 20050912*/
    /*check total*/
    if wkgtm_totamt = 0 then do:
      wkgtm_status = "X".
      wkgtm_msg    = wkgtm_msg + "/发票总金额为0".
      next.
    end.

  end.


end. /*each so_mstr*/
