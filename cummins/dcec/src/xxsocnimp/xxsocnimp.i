define {1} shared temp-table xsa_r
		fields xsr_so like so_nbr
		fields xsr_line like sod_line
		fields xsr_site like sod_site
		fields xsr_loc  like ld_loc
		fields xsr_lot  like ld_lot
		fields xsr_ref like ld_ref
		fields xsr_eff   as date
		fields xsr_oh like ld_qty_oh
		fields xsr_um like um_um
		index xsr_1 is primary xsr_so xsr_line
		index xsr_2 xsr_so xsr_site xsr_loc xsr_lot xsr_ref.
	  .
/*
define {1} shared temp-table xsc_m
		fields xsm_ship like so_ship
		fields xsm_cust like so_cust
		fields xsm_so   like so_nbr
		fields xsm_part like pt_part
		fields xsm_qty  like sod_qty_ord
		fields xsm_oh   like ld_qty_oh
		fields xsm_eff_price as logical
		fields xsm_site like sod_site
		fields xsm_loc  like ld_loc
		fields xsm_ref  like ld_ref
		fields xsm_eff  like tr_effdate
		fields xsm_chk  as   character format "x(40)".
*/
define {1} shared temp-table xsc_d
	  fields xsd_ship like so_cust
	  fields xsd_cust like so_ship
	  fields xsd_so   like so_nbr
	  fields xsd_line like sod_line
	  fields xsd_serial as character
	  fields xsd_part like pt_part
	  fields xsd_desc1 like pt_desc1
	  fields xsd_desc2 like pt_desc2
	  fields xsd_qty_used as decimal format "->,>>>,>>9.9<<<<"  label "Usage Qty"
	  fields xsd_site like si_site
	  fields xsd_loc  like loc_loc
	  fields xsd_qty_keep as decimal format "->,>>>,>>9.9<<<<"  label "Keep Qty"
	  fields xsd_lot  like ld_lot
	  fields xsd_ref  like ld_ref
	  fields xsd_eff  as   date
	  fields xsd_curr like cu_curr
    fields xsd_um   like pt_um
	  fields xsd_price like sod_price
	  fields xsd_amt   as decimal format "->,>>>,>>>,>>9.9<"  label "EXTENDED_AMOUNT"
	  fields xsd_chk  as character format "x(40)"
	  fields xsd_qty_oh	as decimal format "->,>>>,>>9.9<<<<" label "Qty on Hand"
	  fields xsd_sn   as integer.


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
