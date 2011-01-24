/* xxgentig.p - generate trigger parameter.i file.                           */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 11YJ LAST MODIFIED: 01/19/11   BY: zy                           */
/* REVISION END                                                              */

{xxtcgen.i}
/*   RUN gentrig(INPUT "pow.i",                                           */
/*               INPUT "po_mstr",                                         */
/*               INPUT "w",                                               */
/*               INPUT "po_domain",                                       */
/*               input "po_part",                                         */
/*               input "po_site",                                         */
/*               input "po_nbr",                                          */
/*               input "po_due_date",                                     */
/*               input "po_vend",                                         */
/*               input "po_buyer",                                        */
/*               input "po_type",                                         */
/*               INPUT "po_ord_date",                                     */
/*               INPUT "po_stat",                                         */
/*               INPUT 'po_bill',                                         */
/*               INPUT '',                                                */
/*               INPUT '').                                               */

                                                                                      
RUN gentrig(INPUT "wod.i",
            INPUT "wo_mstr",
            INPUT "d",
            INPUT "wo_domain",
            INPUT "wo_part",
            INPUT "wo_site",
            INPUT "wo_nbr",
            INPUT "wo_lot",
            INPUT "wo_status",
            INPUT "wo_qty_ord",
            INPUT "wo_so_job",
            INPUT "wo_type",
            INPUT "",
            INPUT "",
            INPUT "",
            INPUT "",
            INPUT "")
