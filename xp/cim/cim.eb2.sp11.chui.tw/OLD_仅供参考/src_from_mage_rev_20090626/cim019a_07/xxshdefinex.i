DEF {1} SHARED VAR invcode AS CHAR FORMAT "x(2)" .
DEF {1} SHARED VAR invno AS CHAR .
DEF {1} SHARED VAR tmpinvno AS CHAR .    /**/
def {1} SHARED var v_billtoadd like ad_line1 .
def {1} SHARED var v_shiptoadd like ad_line1 .
def {1} SHARED var v_so_nbr like so_nbr .
def {1} SHARED var v_continue as logi .
def {1} shared var sonbrstr as char.
/*mage add*/  def {1} shared  var tmpvar_dec as dec .  

DEF {1} SHARED TEMP-TABLE tmp
    field tmp_flag as char format "x(1)"
    field tmp_sele as char format "x(1)"
    field tmp_so_nbr like so_nbr
    field tmp_so_line like sod_line
    field tmp_sort as inte format ">9" init 10
    field tmp_so_part like sod_part
    field tmp_so_qty like sod_qty_ord
    field tmp_so_price like sod_price
    field tmp_carton like xxshd_carton
    field tmp_pallet like xxshd_pallet
    field tmp_blance_qty like xxshd_blance_qty
    field tmp_carton_no  like xxshd_carton_no
    field tmp_pallet_no  like xxshd_pallet_No
    field tmp_ser_no	 like xxshd_ser_no2
    field tmp_ser_no2	 like xxshd_ser_no2
    field tmp_yiyin_date like xxshd_yiyin_date
    field tmp_seat_part  like xxshd_seat_part format "x(18)"
    field tmp_chrx      as character         format "x(18)"
    field tmp_dec	like xxshd_dec[1] extent 5		/*保存原始卡板數量值來源於xxshd_dec[1]*/
    index idtmpsortnbrline tmp_sort tmp_so_nbr tmp_so_line .