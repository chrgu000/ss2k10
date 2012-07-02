/* xxinvld.p - bom load                                                      */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy expand xrc length to 120    */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no".
define {1} shared temp-table tmpbom
			 fields tbm_par like pt_part
			 fields tbm_old like pt_part
			 fields tbm_ostart as date
			 fields tbm_oend as date
			 fields tbm_new like pt_part
			 fields tbm_nstart as date
			 fields tbm_nend as date
			 fields tbm_qty_per like ps_qty_per
			 fields tbm_chk as character format "x(40)".
