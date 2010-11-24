/*By: Neil Gao 08/09/08 ECO: *SS 20080908* */

{mfdeclre.i}
{gplabel.i}
define var fw_type as character.
define input parameter sod_nbr_input like sod_nbr.
define input parameter sod_line_input like sod_line.

fw_type = "check".

for each xxcffw_mstr where xxcffw_key1 = fw_type and xxcffw_key_nbr = sod_nbr_input
	and xxcffw_key_line = sod_line_input:
		delete xxcffw_mstr.
end.


for each xxfw_mstr where xxfw_key1 = fw_type no-lock by xxfw_nbr:
  if xxfw_nbr = "1" then do:
		create 	xxcff_mstr .
		assign 	xxcff_key1 = fw_type
				xxcff_nbr  = xxfw_cf_nbr
				xxcff_key_nbr = sod_nbr_input
				xxcff_key_line = sod_line_input.
  end.
   
    create 	xxcffw_mstr.
    assign 	xxcffw_key1 = fw_type
	   				xxcffw_key_nbr = sod_nbr_input
	   				xxcffw_key_line = sod_line_input
	   				xxcffw_nbr = xxfw_cf_nbr
	   				xxcffw_cf_nbr = xxfw_nbr
	   				xxcffw_on_id = xxfw_on_id
	   				xxcffw_parent = xxfw_parent
	   				xxcffw_user = global_userid
	   				xxcffw_date = today
	   				xxcffw_time = time.
end.
