/* xxpiptld.p - piptcr.p cim load                                            */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 140218.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no".
define {1} shared variable vtag like tag_mstr.tag_nbr.
define {1} shared temp-table b_tag no-undo
       fields tag_sn as integer column-label "Serial"
       fields tag_nbr like tag_mstr.tag_nbr
       fields tag_site like tag_mstr.tag_site
       fields tag_loc like tag_mstr.tag_loc
       fields tag_part like tag_mstr.tag_part
       fields tag_serial like tag_mstr.tag_serial
       fields tag_ref like tag_mstr.tag_ref
       fields tag_type like tag_mstr.tag_type initial "I"
       fields tag_crt_dt like tag_mstr.tag_crt_dt initial today
       fields tag_cnt_cnv like tag_mstr.tag_cnt_cnv initial 1
       fields tag_rcnt_cnv like tag_mstr.tag_rcnt_cnv initial 1
       fields tag_qty_loc like ld_qty_oh
       fields tag_qty_doc like ld_qty_oh
       fields tag_chk as character format "x(40)"
       index tag_index is unique primary
             tag_nbr tag_site tag_loc tag_part tag_serial tag_ref
       index tag_index1 is unique tag_site tag_loc tag_part tag_serial.

FUNCTION getMsg RETURNS character(inbr as integer):
 /* -----------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  find first msg_mstr no-lock where msg_lang = global_user_lang and msg_nbr = inbr no-error.
  if available msg_mstr then do:
      return msg_desc.
  end.
  else do:
      return "ERROR.".
  end.
END FUNCTION. /*FUNCTION getMsg*/
