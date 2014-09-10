/* GUI CONVERTED from txdetrpa.i (converter v1.75) Sat Aug 12 16:22:55 2000 */
/* txdetrpa.i - ACCUMULATE TAX DETAIL AMOUNTS FOR A TRANSACTION               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*V8:ConvertMode=Report                                                       */
/*  This program accumulates the tax details                                  */
/*                                                                            */
/* REVISION: 8.6            CREATED: 11/13/96   BY: *H0N8* Ajit Deodhar       */
/* REVISION: 9.0       LAST MODIFIED: 10/01/98  BY: *J2CZ* Reetu Kapoor      */
/* REVISION: 9.0       LAST MODIFIED: 03/13/99  BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1       LAST MODIFIED: 10/29/99  BY: *N049* Robert Jensen      */
/* REVISION: 9.1       LAST MODIFIED: 08/12/00  BY: *N0KC* myb                */


                /* TAX DETAILS ACCUMULATION */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

                for each tx2d_det where tx2d_domain = global_domain and
                         tx2d_ref = ref and
                        (tx2d_nbr = nbr or nbr = "*") and
                         tx2d_tr_type = tr_type:

/*J2CZ** BEGIN DELETE
 *                    find tx2_mstr where tx2_domain = global_domain and
 *                         tx2_tax_code = tx2d_tax_code
 *                     no-lock no-error.
 *J2CZ** END DELETE **/
/*J2CZ*/            for first tx2_mstr fields(tx2_domain tx2_by_line
/*J2CZ*/           tx2_desc tx2_pt_taxc tx2_tax_code tx2_tax_pct
/*J2CZ*/           tx2_tax_type tx2_tax_usage tx2_method)
/*J2CZ*/         where tx2_domain = global_domain and tx2_tax_code = tx2d_tax_code no-lock : end.
                    if tx2_tax_code = "00000000" then next.

                    /* get corresponding master info,
                      otherwise print progress hard error-no mstr */
                    if available tx2_mstr then do:
/*J2CZ** BEGIN DELETE
 *                        find code_mstr where code_domain = global_domain and code_fldname = "txt_tax_type" and
 *                         code_value = tx2_tax_type no-lock no-error.
 *J2CZ** END DELETE **/
/*J2CZ*/               for first code_mstr
/*J2CZ*/                   fields(code_domain code_desc code_fldname code_value)
/*J2CZ*/                    where code_domain = global_domain and
                                  code_fldname = "txt_tax_type" and
/*J2CZ*/                          code_value = tx2_tax_type no-lock : end.


                        /* IF TAXED BY LINE: USE TAX DETAIL INFO */
                        if (tx2_by_line or tr_type = "22") and
                        tr_type <> "18" then
/*J2CZ** BEGIN DELETE
 *                            find first taxdetail where
 *                             taxtype  = tx2_tax_type    and
 *                             taxclass = tx2d_taxc       and
 *                             taxusage = tx2d_tax_usage  no-lock no-error.
 *J2CZ** END DELETE **/

/*J2CZ*/                for first taxdetail where
/*J2CZ*/                    taxtype  = tx2_tax_type    and
/*J2CZ*/                    taxclass = tx2d_taxc       and
/*J2CZ*/                    taxusage = tx2d_tax_usage   no-lock : end.

                        else
                        /* IF TAXED BY TOTAL: USE TAX RATE INFO */
/*J2CZ** BEGIN DELETE
 *                            find first taxdetail where
 *                             taxtype  = tx2_tax_type    and
 *                             taxclass = tx2_pt_taxc     and
 *                             taxusage = tx2_tax_usage   no-lock no-error.
 *J2CZ** END DELETE **/

/*J2CZ*/                for first taxdetail where
/*J2CZ*/                    taxtype  = tx2_tax_type    and
/*J2CZ*/                    taxclass = tx2_pt_taxc     and
/*J2CZ*/                    taxusage = tx2_tax_usage   no-lock : end.

                        if not available taxdetail then do:
                            /* first occurance */
                            create taxdetail.
                            taxtype   = tx2_tax_type.
                            if available code_mstr then
                                typedesc = code_desc.
                            if (tx2_by_line or tr_type = "22") and
                            tr_type <> "18" then do:
                              assign
                                taxclass  = tx2d_taxc
                                taxusage  = tx2d_tax_usage.
                            end.
                            else do:
                              assign
                                taxclass  = tx2_pt_taxc
                                taxusage  = tx2_tax_usage.
                            end.
                          assign
                            taxdesc   = tx2_desc
                            taxtotal  = tx2d_cur_tax_amt
                            taxbase   = tx2d_tottax
                            nontax    = tx2d_cur_nontax_amt
                            taxadj    = tx2d_cur_abs_ret_amt
                            taxedit   = tx2d_edited.
/*N049*/                    /* Tax Method 3 always computes the rate. */
/*N049*/                    /* Display 0 for 0/0 */
/*N049*                     taxpercnt = if not taxedit then tx2_tax_pct else */
/*N049*/                    taxpercnt = if not taxedit
/*N049*/                    and tx2_method <> "03"
/*N049*/                    then tx2_tax_pct
/*N049*/                    else if taxbase = 0 then 0 else
                                        ((taxtotal / taxbase) * 100).
                        end.
                        else do:
                          assign
                            taxtotal = taxtotal + tx2d_cur_tax_amt
                            taxbase  = taxbase + tx2d_tottax
                            nontax   = nontax + tx2d_cur_nontax_amt
                            taxadj   = taxadj + tx2d_cur_abs_ret_amt
                            taxedit  = taxedit or tx2d_edited
/*N049*/                    /* Tax Method 3 always computes the rate. */
/*N049*/                    /* Display 0 for 0/0 */
/*N049*                     taxpercnt = if not taxedit then tx2_tax_pct else */
/*N049*/                    taxpercnt = if not taxedit
/*N049*/                    and tx2_method <> "03"
/*N049*/                    then tx2_tax_pct
/*N049*/                    else if taxbase = 0 then 0 else
                                        ((taxtotal / taxbase) * 100).
                        end.
                    end.
                end. /* for each tx2d_det */
