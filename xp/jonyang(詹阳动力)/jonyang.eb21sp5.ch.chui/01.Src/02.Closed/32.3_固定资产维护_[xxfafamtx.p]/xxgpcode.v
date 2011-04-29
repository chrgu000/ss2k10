/* gpcode.v - VALIDATE GENERALIZED CODES                                */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 10/10/90   BY: PML        */
/* REVISION: 6.0      LAST MODIFIED: 07/16/91   BY: PML D775   */
/* REVISION: 7.0      LAST MODIFIED: 12/06/91   BY: afs *Fafs* */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown   */
/* $Revision: 1.5 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00F* */

/* SS - 100419.1  By: Roger Xiao */  /*{1} ----> input {1} */
/*-Revision end---------------------------------------------------------------*/


/* {1} "field-name"                                            */
/* {2} validation field (defaults to {1})                      */

/* The current field is valid if no general codes exist for    */
/* the validation field or if it matches one of the codes      */
/* defined for this field.                                     */

( "{2}" = ""  and (not can-find (first code_mstr  where code_mstr.code_domain =
global_domain and (  code_fldname = "{1}"))
           or  can-find (code_mstr  where code_mstr.code_domain = global_domain
           and (  code_fldname = "{1}"
                         and code_value   = input {1}))) )
or
( "{2}" <> "" and (not can-find (first code_mstr  where code_mstr.code_domain =
global_domain and (  code_fldname = "{2}"))
           or  can-find (code_mstr  where code_mstr.code_domain = global_domain
           and (  code_fldname = "{2}"
                         and code_value   = input {1}))) )
