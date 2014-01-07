/* xxapvold.i - apvomt.p cim load                                            */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 131115.1 LAST MODIFIED: 11/15/13 BY:Zy                          */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no".
define {1} shared temp-table xxapvotmp
       fields xxapt_ref like ap_ref
       fields xxapt_tot like ap_amt
       fields xxapt_vd like ap_vend
       fields xxapt_sort like vd_sort
       fields xxapt_invoice like vo_invoice
       fields xxapt_taxable like vod_tax_at
       fields xxapt_line like sod_line
       fields xxapt_acct like sod_acct
       fields xxapt_amt like vod_amt
       fields xxapt_cc like sod_cc
       fields xxapt_proj like sod_proj
       fields xxapt_cmmt like code_cmmt
       fields xxapt_eff like ap_effdate
       fields xxapt_sn as integer
       fields xxapt_chk as character format "x(30)".

/*  FUNCTION getMsg RETURNS character(inbr as integer):                   */
/*   /* -----------------------------------------------------------       */
/*      Purpose:                                                          */
/*      Parameters:  <none>                                               */
/*      Notes:                                                            */
/*    -------------------------------------------------------------*/     */
/*    find first msg_mstr no-lock where msg_lang = global_user_lang       */
/*           and msg_nbr = inbr no-error.                                 */
/*    if available msg_mstr then do:                                      */
/*        return msg_desc.                                                */
/*    end.                                                                */
/*    else do:                                                            */
/*        return "ERROR.".                                                */
/*    end.                                                                */
/*  END FUNCTION. /*FUNCTION getMsg*/                                     */
