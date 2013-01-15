define variable v_key_book01 like usrw_key1 no-undo initial "XXBK_BOOKTYPE".
define variable v_key_book02 like usrw_key1 no-undo initial "XXBK_BOOKSTAT".
define variable v_key_book03 like usrw_key1 no-undo initial "XXBK_BCRDTYPE".
define variable v_key_book04 like usrw_key1 no-undo initial "XXBK_BCRDSTAT".

FUNCTION getPlanReturnDay RETURNS date(ibookId as character,idate as date):
  define variable odate as date.
  assign odate  = idate.
  
  find first xxbk_lst no-lock where xxbk_id = ibookId no-error.
  if available xxbk_lst then do:
  	 find first usrw_wkfl no-lock where usrw_key1 = v_key_book01
  	 			  and usrw_key2 = xxbk_type no-error.
  	 if available usrw_wkfl then do:
  	 		assign odate = idate + usrw_intfld[1].
  	 end.
  end.
  repeat:
  	find first hd_mstr no-lock where hd_site <> "" and hd_date = odate no-error.
  	if not avail hd_mstr then do:
  		 leave.
    end.
    else do:
    	 assign odate = odate + 1.
    end.
  end.
  return odate.
END FUNCTION. /*FUNCTION getPlanReturnDay*/


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
