/*By: Neil Gao 08/06/09 ECO: *SS 20080609* */
{mfdeclre.i}

define input parameter sonbr like so_nbr.
define output parameter presult as char.
define var iallowuser as char .
iallowuser = "mfg".
presult = "0".

find first so_mstr where so_domain = global_domain and so_nbr = sonbr   no-lock no-error.
if avail so_mstr and lookup(global_userid,iallowuser) = 0 then do:
	if so_userid <> global_userid then do:
  	message "无权限修改".
		presult = "1".
		return.
  end.
  if so__chr06 <>  "" then do:
   	message("审批通过").
		presult = "2".
		return.
  end.
  if  so__log01  then do:
    message("审核中").
		presult = "3".
		return.
  end.
end.