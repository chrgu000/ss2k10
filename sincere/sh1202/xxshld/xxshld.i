
/* xxptld.p - ppptmt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no".
define {1} shared temp-table tmpsh
					 fields tsh_site like si_site
					 fields tsh_abs_id like xxsh_abs_id
					 fields tsh_nbr like xxsh_nbr
					 fields tsh_lgvd like xxsh_lgvd
					 fields tsh_shipto like xxsh_shipto
					 fields tsh_price as character 
					 fields tsh_pc as character
					 fields tsh_dc as character  
					 fields tsh_uc as character
					 fields tsh_lc as character
					 fields tsh_rmks like xxsh_rmks
					 fields tsh_chk as character format "x(30)".

FUNCTION getMsg RETURNS character(inbr as integer):
 /* -----------------------------------------------------------
    Purpose:
    Parameters:  <none>
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