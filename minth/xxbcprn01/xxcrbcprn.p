{mfdtitle.i "20120109.1"}
define var nbr like xbc1_bc.
define var prn as char.
define var xxbcprnparm as char.
def new shared var productioner  as character .
def new shared var companyname   as character  format "x(24)" .
def new shared var companyname1  as character  format "x(24)" .
  define var xxbcdatastr as char no-undo.
  define var xxthtype   as  char.
  define var xxthdesc1  as  char  format "x(24)".
  define var xxthdesc2  as  char  format "x(24)".

define var unfill_kb_idn as  logical.
define var unfill_kbidn  like xkb_kb_id .
define var unfill_kbid0_qty  as  decimal.
define var unfill_kbidn_qty  as  decimal .
define var startx  as  logical.
define var raimbc1  as  char format "x(24)" .
      def var ssbc1 as char format "x(24)" .
  define var prodline as  char no-undo.
  define var proddate as  date .
  define var prodpart as  char  format "x(24)".
  define var prodqty  as  decimal  format "->>>>,>>9.99"  .
  def var rflot1 as integer.
  define var xxprnflag as logic no-undo.
  xxprnflag = yes.
  define var total_qty  as  decimal  format "->>>>,>>9.99"  .
  define var bc_qty  as  decimal  format "->>>>,>>9.99"  .
  define var prodloc as  char no-undo.

form
  prodline colon 25 label "生产线"
  prodloc colon 25 label "生产线库位"
  proddate colon 25 label "生产日期"
  prodpart colon 25 label "生产产品"
  prodqty  colon 25 label "产量"
  productioner colon 25 label "生产员工"
/*  nbr  colon 25 label "条码编号"  */
  prn  colon 25 label "条码打印机"
with frame a side-label .

repeat :

  update prodline  prodloc
  proddate
  prodpart
  prodqty
  productioner  prn with frame a .


  find first pt_mstr no-lock where pt_domain = global_domain and pt_part = prodpart   no-error.
  if available pt_mstr then do:
                                assign  xxthdesc1 = pt_desc1
                                        xxthdesc2 = pt_desc2 .
  end.
  else do:
    message "零件号不存在".
    undo,retry.
  end.

find first ln_mstr no-lock where ln_domain = global_domain and ln_line = prodline    no-error.
  if available ln_mstr then do:

  end.
  else do:
    message "生产线不存在".
    undo,retry.
  end.


find first loc_mstr no-lock where loc_domain = global_domain and  loc_loc = prodloc   no-error.
  if not available loc_mstr then do:
    message "生产线不存在".
    undo,retry.
  end.

if proddate = ? then do:

    message "生产日期不能为空".
    undo,retry.
  end.

  if prodqty < 0 then do:

    message "生产数量不能小于等于0".
    undo,retry.
  end.


 find first code_mstr no-lock where code_domain = global_domain and code_fldname = "BarCodePrn" and code_value = prn no-error.
  if not avail code_mstr then do:
    message "不存在的打印机编码".
    undo,retry.
  end.
find first xmpt_mstr where xmpt_domain = global_domain and
    xmpt_part =  prodpart no-lock no-error.
    if not available xmpt_mstr then do:
             message "没有相关的看板信息".
             undo,retry.
    end.

/*ss - 120110.1 - b***********************/

      ssbc1 = "".
     find first rfpt_mstr  where rfpt_domain = global_domain
                                and rfpt_part = prodpart
        and rfpt_isbar  no-lock no-error.

     if available rfpt_mstr and prodqty > 0 then do:
        total_qty = prodqty .


     do while total_qty > 0 :

       bc_qty = min(total_qty, xmpt_kb_rolume).
       find last rflot_hist where   rflot_domain   = global_domain
                                 and rflot_part    = prodpart
         and rflot_site   = global_domain
         and rflot_prod_date >= proddate
         use-index rflot_box_seq
                                 no-lock no-error.

    if not available rflot_hist or rflot_prod_date < proddate then rflot1 = 1.
                                 else rflot1 = integer(substring(rflot_box_seq, length(rflot_box_seq) - 3, 4)) +  1 .
      /*   message  rflot_box_seq view-as alert-box. */
    ssbc1 = string(today, "999999") +  rfpt_shp_box  + string(rflot1, "9999") .
/*    message "ssbc1"  ssbc1 view-as alert-box. */
    create rflot_hist.

    rflot_seq = next-value(s_fglbl_seq).

    assign  rflot_domain      = global_domain
            rflot_part        = prodpart
            rflot_part_desc   =  ""
            rflot_wkctr       =   prodloc
            rflot_shift       =          ""
            rflot_lot         =      string(today, "999999")
 /*         rflot_box_qty     =        xkb_kb_qty
            rflot_mult_qty    =        xkb_kb_qty  */
            rflot_scatter_qty =        0
            rflot_status      =         ""
            rflot_printed     =         yes
            rflot_prod_date   =         today
            rflot_crt_date    =         today
            rflot_crt_time    =         time
            rflot_prod_dt     =         ""
            rflot_part_group  =         ""      .

 assign     rflot_site        =         global_domain
            rflot_prod_time   =         ""
            rflot_num_lbl     =         rflot1
            rflot_part_rev    =         ""
            rflot_crt_userid  =         ""
            rflot_um          =       pt_um
            rflot_cust        =         ""
            rflot_box_seq     =         ssbc1
            rflot_box_type    =        rfpt_shp_box
            rflot_line        =        prodline
            rflot_mach        =         ""
            rflot_worker      =          ""
            rflot_cust_part   =         ""
            rflot_exp_date    =         proddate
            rflot_part_desc1  =         ""
            rflot_part_desc2  =         ""
            rflot_type        =         ""
            rflot_output      =         no
            rflot_trnbr       =         0
            rflot_direction   =         ""   .


    {gprun.i ""xxbccreatex.p"" "(
        INPUT prodpart,
  input ssbc1,
  output xxbcdatastr,
  output xxthtype,
  output xxthdesc1,
  output xxthdesc2 )"}

    find first xbc1_mstr  where xbc1_domain = global_domain and xbc1_bc = xxbcdatastr.
    xbc1_kb_raim = bc_qty.
    xbc1_kb_qty = xmpt_kb_rolume.
    xbc1_site  =   global_domain.
    xbc1_loc   =  prodloc  .
    xbc1_crt_date = today .
    xbc1_status = "W".
 if bc_qty <>  xmpt_kb_rolume then  xbc1_type = "R".
    xbc1_print = yes.
    xbc1_fldusr[1] = productioner .

    assign
             rflot_scatter_qty =      bc_qty.



      if rfpt_title <> "" then  do:
          find first ad_mstr no-lock  where ad_mstr.ad_domain = global_domain and  ad_addr =
                    rfpt_title   no-error.
          if available ad_mstr then
                           companyname1 = ad_name  .
         else companyname1 = companyname .
       end. /* if rfpt_title <> "" then  do: */
                           else companyname1 = companyname .
          assign
            rflot_mult_qty    =      xmpt_kb_rolume
            rflot_part_group = ""
            rflot_part_rev = ""
            rflot_part_desc        = ""
            rflot_part_desc1 = xxthdesc1
            rflot_part_desc2 = xxthdesc2
            rflot_direction =  rfpt_chrfld[2]
            rflot_type = "FG"            /* 类型 成品*/
            rflot_um = ""                      /*单位*/
            rflot_crt_user = global_userid  /*创建用户*/
            rflot_crt_time =  time   /*创建时间*/
            rflot_num_lbl = 1               /*标签数*/
            rflot_box_qty = 1               /*箱数*/
            rflot__chrfld[1] = companyname1 /*标题*/
            rflot_worker =  productioner  /*生产者*/
            rflot__chrfld[2] = prodline  /*生产线*/
            .

       if bc_qty  = xmpt_kb_rolume  then Assign  xxbcprnparm = "02@" + prn + "@" + companyname1 + "@" + xxthdesc1 + "@" +
                         xxthdesc2 + "@" + prodpart + "@" + string(proddate, "999999") +  rfpt_shp_box  + string(rflot1, "9999") + "@" + string(bc_qty) + "@" +
       STRING(proddate, "9999-99-99") + "@" + productioner + "@" + rfpt_chrfld[2]
        xbc1_kb_raim = bc_qty
        xbc1_type = ""
         .


                         else
        assign  xxbcprnparm = "03@" + prn + "@" + companyname1 + "@" + xxthdesc1 + "@" +
                         xxthdesc2 + "@" + prodpart + "@" + string(proddate, "999999") +  rfpt_shp_box  + string(rflot1, "9999") + "@" + string(bc_qty) + "@" +
       STRING(proddate, "9999-99-99") + "@" + productioner + "@" + rfpt_chrfld[2]
        xbc1_kb_raim = bc_qty
        xbc1_type = "R"
                          rflot_scatter_qty =    bc_qty .

     {gprun.i ""xxbcprnall.p"" "(
        INPUT xxbcprnparm )"}


       total_qty = total_qty - bc_qty .
     end. /*do while .... */
   end. /* if available rfpt_mstr and prodqty > 0 then do:*/
 end.

