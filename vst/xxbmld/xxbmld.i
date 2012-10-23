/* xxinvld.p - bom load                                                      */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120703.1 LAST MODIFIED: 07/03/12 BY:                            */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no".
define {1} shared variable vpar like ps_par.
define {1} shared variable vold like ps_comp.
define {1} shared variable vnew like ps_comp.
define {1} shared temp-table tmpbom
       fields tbm_par like pt_part
       fields tbm_old like pt_part
       fields tbm_ostart as date
       fields tbm_oend as date
       fields tbm_new like pt_part
       fields tbm_nstart as date
       fields tbm_nend as date
       fields tbm_qty_per like ps_qty_per
       fields tbm_scrp as decimal
       fields tbm_chk as character format "x(40)".

define {1} shared temp-table tmpbomn
       fields tbmn_par like ps_par
       fields tbmn_comp like ps_comp
       fields tbmn_ref like ps_ref
       fields tbmn_start like ps_start
       fields tbmn_end like ps_end
       fields tbmn_qty_per like ps_qty_per
       fields tbmn_scrp as decimal
       fields tbmn_sn as integer
       fields tbmn_chk as character format "x(40)".

FUNCTION getMsg RETURNS character(inbr as integer):
 /* -----------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  find first msg_mstr no-lock where msg_lang = "TW" and msg_nbr = inbr no-error.
  if available msg_mstr then do:
      return msg_desc.
  end.
  else do:
      return "ERROR.".
  end.
END FUNCTION. /*FUNCTION getMsg*/
