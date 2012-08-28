/* xxunrcld.p - icunrc.p cim load                                            */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120704.1 LAST MODIFIED: 07/04/12 BY:                            */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no".
define {1} shared temp-table tmpic
       fields tic_site like si_site
       fields tic_nbr as character format "x(18)"
       fields tic_loc like ld_loc
       fields tic_part like ld_part
       fields tic_qty like ld_qty_oh
       fields tic_acct like trgl_dr_acct
       fields tic_sub  as character /* like trgl_dr_sub */
       fields tic_cc   like trgl_dr_cc
       fields tic_proj like wo_proj
       fields tic_sn as integer
       fields tic_chk as character format "x(30)".

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

