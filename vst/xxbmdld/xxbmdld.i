/* xxinvld.p - bom load                                                      */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120703.1 LAST MODIFIED: 07/03/12 BY:                            */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no".
define {1} shared temp-table tmpbom
	         fields tbm_comp like ps_comp.

define {1} shared temp-table tmpbomn
		   fields tbmn_par like ps_par
		   fields tbmn_comp like ps_comp
		   fields tbmn_qty_per like ps_qty_per
		   fields tbmn_ps_code like ps_ps_code
		   fields tbmn_start like ps_start
		   fields tbmn_end like ps_end
			 fields tbmn_scrp_pct as decimal
		   fields tbmn_chk as character format "x(40)".