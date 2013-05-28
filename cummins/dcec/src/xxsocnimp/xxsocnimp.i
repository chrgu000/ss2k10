define {1} shared temp-table xst_t
    fields xst_type like tr_type
    fields xst_id   as integer
    fields xst_so   like tr_nbr
    fields xst_line like tr_line
    fields xst_lot  like tr_lot
    fields xst_ref  like tr_ref
    fields xst_qty  like tr_qty_loc.

define {1} shared temp-table xsa_r
    fields xsr_ship like so_ship column-label "xsr_ship"
    fields xsr_so like so_nbr column-label "xsr_so"
    fields xsr_line like sod_line column-label "xsr_line"
    fields xsr_part like sod_part column-label "xsr_part"
    fields xsr_site like sod_site column-label "xsr_site"
    fields xsr_loc  like ld_loc column-label "xsr_loc"
    fields xsr_lot  like ld_lot column-label "xsr_lot"
    fields xsr_ref like ld_ref column-label "xsr_ref"
    fields xsr_eff   as date column-label "xsr_eff"
    fields xsr_oh like ld_qty_oh column-label "xsr_oh"
    fields xsr_um like um_um column-label "xsr_um"
    index xsr_1 is primary xsr_so xsr_part
    index xsr_2 xsr_so xsr_part xsr_site xsr_loc xsr_lot xsr_ref.
    .
define {1} shared temp-table xsa_r1
    fields xsr1_ship like so_ship column-label "xsr_ship"
    fields xsr1_so like so_nbr column-label "xsr_so"
    fields xsr1_line like sod_line column-label "xsr_line"
    fields xsr1_part like sod_part column-label "xsr_part"
    fields xsr1_site like sod_site column-label "xsr_site"
    fields xsr1_loc  like ld_loc column-label "xsr_loc"
    fields xsr1_lot  like ld_lot column-label "xsr_lot"
    fields xsr1_ref like ld_ref column-label "xsr_ref"
    fields xsr1_eff   as date column-label "xsr_eff"
    fields xsr1_oh like ld_qty_oh column-label "xsr_oh"
    fields xsr1_um like um_um column-label "xsr_um"
    index xsr_1 is primary xsr1_so xsr1_part
    index xsr_2 xsr1_so xsr1_part xsr1_site xsr1_loc xsr1_lot xsr1_ref.
    .
define {1} shared temp-table xsc_m
    fields xsm_ship like so_ship column-label "xsm_ship"
    fields xsm_cust like so_cust column-label "xsm_cust"
    fields xsm_so   like so_nbr  column-label "xsm_so"
    fields xsm_serial as character column-label "xsm_serial"
    fields xsm_part like pt_part column-label "xsm_part"
    fields xsm_qty_used  like sod_qty_ord column-label "xsm_qty_used"
    fields xsm_site like sod_site column-label "xsm_site"
    fields xsm_loc  like ld_loc column-label "xsm_loc"
    fields xsm_lot  like ld_lot column-label "xsm_lot"
    fields xsm_ref  like ld_ref column-label "xsm_ref"
    fields xsm_eff  like tr_effdate column-label "xsm_eff"
    fields xsm_stat as   character column-label "xsm_stat".

define {1} shared temp-table xsc_d
    fields xsd_ship like so_cust column-label "xsd_ship"
    fields xsd_cust like so_ship column-label "xsd_cust"
    fields xsd_so   like so_nbr column-label "xsd_so"
    fields xsd_line like sod_line column-label "xsd_line"
    fields xsd_serial as character format "x(24)" column-label "xsd_serial"
    fields xsd_part like pt_part column-label "xsd_part"
    fields xsd_desc1 like pt_desc1 column-label "xsd_desc1"
    fields xsd_desc2 like pt_desc2 column-label "xsd_desc2"
    fields xsd_sched like sod_sched column-label "xsd_sched"
    fields xsd_qty_used as decimal format "->,>>>,>>9.9<<<<"  label "Usage Qty" column-label "xsd_qty_used"
    fields xsd_site like si_site column-label "xsd_site"
    fields xsd_loc  like loc_loc column-label "xsd_loc"
    fields xsd_qty_keep as decimal format "->,>>>,>>9.9<<<<"  label "Keep Qty" column-label "xsd_loc"
    fields xsd_lot  like ld_lot column-label "xsd_lot"
    fields xsd_ref  like ld_ref column-label "xsd_ref"
    fields xsd_eff  as   date column-label "xsd_eff"
    fields xsd_curr like cu_curr column-label "xsd_curr"
    fields xsd_um   like pt_um column-label "xsd_um"
    fields xsd_price like sod_price column-label "xsd_price"
    fields xsd_amt   as decimal format "->,>>>,>>>,>>9.9<"  label "EXTENDED_AMOUNT"
    fields xsd_qty_oh as decimal format "->,>>>,>>9.9<<<<" label "Qty on Hand"
    fields xsd_chk  as character format "x(120)" column-label "xsd_chk"
    fields xsd_sn   as integer column-label "xsd_sn"
    fields xsd_diffpi as logical column-label "xsd_diffpi" /*已更新报价*/
    fields xsd_mid  as integer column-label "xsd_mid_recid(xsc_m)".


FUNCTION getMsg RETURNS character(inbr as integer):
 /* -----------------------------------------------------------
    Purpose: getMsg content
    Parameters: inbr message number
    Notes:
  -------------------------------------------------------------*/
  find first msg_mstr no-lock where msg_lang = global_user_lang
         and msg_nbr = inbr no-error.
  if available msg_mstr then do:
      return msg_desc.
  end.
  else do:
      return string(inbr).
  end.
END FUNCTION. /*FUNCTION getMsg*/

/* 日期YYYY-MM-DD转换为QAD日期格式 */
FUNCTION str2Date RETURNS DATE(INPUT datestr AS CHARACTER
                              ,INPUT fmt AS CHARACTER):
    DEFINE VARIABLE sstr AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iY   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iM   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE id   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE od   AS DATE      NO-UNDO.
    define variable spchar as character no-undo.
    define variable i as integer.
    if datestr = "" then do:
        assign od = ?.
    end.
    else do:
        ASSIGN sstr = datestr.
        do i = 1 to length(sstr).
           if index("0123456789",substring(sstr,i,1)) = 0 then do:
              assign spchar = substring(sstr,i,1).
              leave.
           end.
        end.
        if lower(fmt) = "ymd" then do:
           ASSIGN iY = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,spchar) - 1)).
           ASSIGN sstr = SUBSTRING(sstr,INDEX(sstr,spchar) + 1).
           ASSIGN iM = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,spchar) - 1)).
           ASSIGN iD = INTEGER(SUBSTRING(sstr,INDEX(sstr,spchar) + 1)).
        end.
        else if lower(fmt) = "mdy" then do:
           ASSIGN iM = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,spchar) - 1)).
           ASSIGN sstr = SUBSTRING(sstr,INDEX(sstr,spchar) + 1).
           ASSIGN iD = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,spchar) - 1)).
           ASSIGN iY = INTEGER(SUBSTRING(sstr,INDEX(sstr,spchar) + 1)).
        end.
        else if lower(fmt) = "dmy" then do:
           ASSIGN iD = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,spchar) - 1)).
           ASSIGN sstr = SUBSTRING(sstr,INDEX(sstr,spchar) + 1).
           ASSIGN iM = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,spchar) - 1)).
           ASSIGN iY = INTEGER(SUBSTRING(sstr,INDEX(sstr,spchar) + 1)).
        end.
        if iY <= 1000 then iY = iY + 2000.
        ASSIGN od = DATE(im,id,iy).
    end.
    RETURN od.

END FUNCTION.
