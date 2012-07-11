/* xxcstld.i - ppcsbtld.p cim load                                           */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no".
define {1} shared temp-table xxsptdet no-undo
       fields xxspt_part like spt_part
       fields xxspt_site like spt_site
       fields xxspt_sim like spt_sim
       fields xxspt_element like spt_element
       fields xxspt_ocst like spt_cst_tl
       fields xxspt_cst like spt_cst_tl
       fields xxspt_chk as character format "x(40)"
       index index1 xxspt_site xxspt_sim xxspt_part xxspt_element.

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
