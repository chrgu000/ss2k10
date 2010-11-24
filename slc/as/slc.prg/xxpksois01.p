/*By: Neil Gao 08/10/15 ECO: *SS 20081015* */

{mfdeclre.i}
{gplabel.i }

define var site like ld_site.
define var sonbr like so_nbr.
define var packno as char.
define var yn as logical.
DEFINE VARIABLE vchr_filename_in AS CHARACTER.
DEFINE VARIABLE vchr_filename_out AS CHARACTER.	
vchr_filename_in = "./ssi" + mfguser.
vchr_filename_out = "./sso" + mfguser.


DEFINE shared temp-table tmp_mstr
	field tmp_packno as char
	field tmp_vin as char format "x(18)"
	field tmp_nbr like sod_nbr
	field tmp_line like sod_line
	field tmp_part like pt_part
	field tmp_desc as char format "x(40)"
	field tmp_site like ld_site
	field tmp_loc	like ld_Loc
	field tmp_lot	like ld_Lot
	field tmp_ref like ld_ref
	field tmp_qty	like ld_qty_oh.


for each tmp_mstr break by tmp_nbr by tmp_line:
	if first-of(tmp_nbr) then do:
		OUTPUT TO value(vchr_filename_in).
		put unformatted tmp_nbr + " " + "-" + " N N "  skip .
	end.
	if first-of(tmp_line) then do:
		put unformat string(tmp_line) + " - " skip .
		put "- - - - - yes" skip.
	end.
	put unformat trim(tmp_site) + " " + trim(tmp_loc) + " " + """" + trim(tmp_lot) + """" + " " + trim(tmp_ref) skip.
	put unformat string(tmp_qty) skip.
	
	if last-of(tmp_line) then do:
		put "." skip.
	end.
	if last-of(tmp_nbr) then do:
		put unformatted "." skip .
		put unformatted "Y" skip .
		put unformatted "Y" skip .
		put unformatted "-" skip .
		put unformatted "- - - - " skip .
		put unformatted "." skip  .
		output close.
		
		INPUT FROM VALUE(vchr_filename_in).	
		OUTPUT TO VALUE(vchr_filename_out).
		batchrun = YES. 
		{gprun.i ""sosois.p""} 
		batchrun = NO.
		INPUT CLOSE.
		OUTPUT CLOSE.
	end.
end.	

/*
OS-DELETE VALUE("./ssi" + mfguser).
OS-DELETE VALUE("./sso" + mfguser). 
*/

