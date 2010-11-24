/* By: Neil Gao Date: 07/11/24 ECO: * ss 20071124 * */

/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}
{mf1.i}

PROCEDURE getglsite:
    define output parameter optsite   as character.

	  find first icc_ctrl where icc_domain = global_domain no-lock no-error no-wait.
	  if avail icc_ctrl then optsite = icc_site.
	  else optsite = "".
		
END PROCEDURE.  /* ip-validate */


PROCEDURE getstring:
		define input  parameter iptstring as char.
		define input  parameter iptlength as int.
		define output parameter optstring as char.
		define var xxs as char.
		define var xxss as char.
		define var xxi as int.
		define var xxj as int.
		
		optstring = "".
		xxss = "".
		xxi = 1.
		
		if iptlength < 2 then return.
		
		repeat while xxi <= length(iptstring,"RAW") :
			xxs = substring(iptstring,xxi,1).
			if length( xxss + xxs , "RAW") > iptlength then do:
				optstring = optstring + xxss + "^".
				xxss = "".
				next.
			end.
			xxi = xxi + 1.
			xxss = xxss + xxs.
		end.
		optstring = optstring + xxss.

END PROCEDURE.