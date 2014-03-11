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
   rflot1   colon 25 label "标签"

with frame a side-label .

repeat :

  update   ssbc1 with frame a .

/*
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
*/

/*ss - 120110.1 - b***********************/



       find last rflot_hist where   rflot_domain   = global_domain
                                 and rflot_box_seq    =  ssbc1
         and rflot_site   = global_domain
         use-index rflot_box_seq
                                 no-lock no-error.
       if not available rflot_hist then do:
             message "没有相关的标签信息".
             undo,retry.
    end.
    else do:
    ssbc1 = rflot_box_seq .

    find first xmpt_mstr where xmpt_domain = global_domain and
    xmpt_part =  rflot_part no-lock no-error.
    if not available xmpt_mstr then do:
             message "没有相关的看板信息".
             undo,retry.
    end.
  find first xbc1_mstr  where xbc1_domain = global_domain and xbc1_bc = ssbc1 no-error.
  if not available xbc1_mstr then do:
    {gprun.i ""xxbccreatex.p"" "(
        INPUT rflot_part,
  input ssbc1,
  output xxbcdatastr,
  output xxthtype,
  output xxthdesc1,
  output xxthdesc2 )"}
   end.

   find first xbc1_mstr  where xbc1_domain = global_domain and xbc1_bc = ssbc1 no-error.
   if available xbc1_mstr then do:
/*    xbc1_kb_raim = xkb_kb_raim_qty.*/
if rflot_mult_qty  = 0 then   assign  xbc1_kb_qty = rflot_scatter_qty  xbc1_kb_raim  = rflot_scatter_qty.
    else assign  xbc1_kb_qty = rflot_mult_qty  xbc1_kb_raim  = rflot_mult_qty.
    xbc1_site  =   global_domain.
    xbc1_loc   =  prodloc  .
    xbc1_crt_date = rflot_prod_date .
    xbc1_status = "W".
    if bc_qty <>  xmpt_kb_rolume then  xbc1_type = "R".
    xbc1_print = yes.
    xbc1_fldusr[1] =  rflot_worker .
   end.
   message "初始化OK" .
end. /*else do: */
  end.

