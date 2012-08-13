/* yyglcim.p  Generate GL transcation via CIM */
/* Modified by James Duan *GYD1* 2009-11-24   */
{mfdeclre.i }
{yyglcim.i  }

def output parameter v_msg	as char	format "x(70)" init "".

def var	v_cimfile	as char format "x(70)".
def var v_crt_ship	as log init no.
def var v_output	as char.
def var v_haserror	as log.
def stream scim.

/* Define put function */
function put2fld return logical ( input fld_value as character,input over_flg as logical):
	define variable temp_value as character no-undo.
	assign temp_value = right-trim(trim(fld_value)) no-error.

	case fld_value:
	when "F1" then
		put stream scim unformatted " " skip.
	when "F4" then
		put stream scim unformatted "." skip.
	when "skip" then
		put stream scim unformatted " " skip(1).
	otherwise do:
		if over_flg = yes then do:
			put stream scim unformatted '"' + temp_value + '" '.
		end.
		else do:
			if fld_value = "0" or fld_value = ? or fld_value = "" then
				put stream scim unformatted "- ".
			else
				put stream scim unformatted '"' + temp_value + '" '.
		end.
	end. /* otherwise */
	end case.

	return true.

end. /* function put2fld*/

v_cimfile = mfguser + "_GL.cim".
v_output  = mfguser + "_GL.log".
find first ttglt_mstr no-lock no-error.

output stream scim to value(v_cimfile).
for each ttglt_mstr no-lock:
	put stream scim "@@batchload gltrmt.p" skip.

	/* Get the right referance */
	put2fld(ttglt_ref,no). /* GL referance */
	put2fld("F1", no).

	/* Check the effective date */
	put2fld(string(ttglt_eff_date),no).
	put2fld(ttglt_curr,no).
	put2fld(string(ttglt_corr),no).
	put2fld("F1", no).
	put2fld(string(abs(ttglt_ctrl_amt)), no). /* ctrl amt ÎªÕıÖµ*/
	put2fld("F1", no).
	
	for each ttgltd_det no-lock where ttgltd_id = ttglt_id:
		put2fld(string(ttgltd_line),no).
		put2fld("F1", no).

		/* check the acct information */
		put2fld(ttgltd_acct,yes).
		put2fld(ttgltd_sub,yes).
		put2fld(ttgltd_cc,yes).
		put2fld(ttgltd_project,yes).
		put2fld("F1", no).

		put2fld(ttgltd_entity,no).
		put2fld("F1", no).
		put2fld(ttgltd_desc,no).
		put2fld("F1", no).
		put2fld(ttgltd_curr1,no).
		put2fld("F1", no).
		put2fld(string(ttgltd_amt),no).
		put2fld("F1", no).
	end. /* for each ttgltd_det */
	put2fld("F4",no).
	put stream scim '@@end' skip.
end. /* for each ttglt_mstr */
output stream scim close.

{gprun.i ""yyscim.p"" "(input v_cimfile, 
                        input v_output,
			output v_haserror, 
			output v_msg)"}


