/* gppclst.p - PRICE TABLE LIST PRICE LOOK-UP                           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*J34G*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 7.4      LAST MODIFIED: 09/22/93   BY: cdt *H086**/
/* REVISION: 7.4      LAST MODIFIED: 09/09/94   BY: afs *H510**/
/* REVISION: 7.4      LAST MODIFIED: 09/27/95   BY: ais *H0G1**/
/* REVISION: 7.4      LAST MODIFIED: 10/17/95   BY: ais *H0GH**/
/* REVISION: 7.4      LAST MODIFIED: 12/16/97   BY: *H1HH* Nirav Parikh */
/* REVISION: 8.5      LAST MODIFIED: 11/12/98   BY: *J34G* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *N0CD* Santosh Rao  */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb          */

/******************************************************************
*  This subroutine looks for a Price Table price list master
*  (pc_amt_type = 'L') based on the following passed input information:
*
*      price_list2     =    Price table to lookup.
*      part            =    Specific part to lookup.
*      um              =    UM to lookup.
*      eff_date        =    Effective date to lookup.
*      curr            =    Currency to lookup.
*
*  Successive finds are attempted to locate a matching price list:
*      1)  price list, type, currency, effective date, item, um;
*      2)  price list, type, currency, effective date, item;
*      3)  price list, type, currency, effective date, product line, um;
*      4)  price list, type, currency, effective date, product line;
*      5)  price list, type, currency, effective date, um;
*      6)  price list, type, currency, effective date.
*  The minimum quantities on the price list are in stocking unit
*  of measure, not price list unit of measure.
*
*  *H510* - An exact item/um price list match may be required.
*  If the shared variable match_pt_um is passed in as true, then it will
*  will be returned as a flag indicating whether a matching price list
*  was found.  This variable will normally be set based on control file
*  variables.
*
*  The following passed parameters are used in calculations and program
*  functionality in the following ways:
*
*      list_price      =    List price.
*      net_price       =    Net price.
*      new_line        =    Logical 'yes' signifies that pricing should
*                           be performed. 'no' signifies a min max lookup
*                           without plugging the prices.
*      umconv          =    Unit of measure conversion factor.
*      match_pt_um     =    Logical indicating whether an exact match of the
*                           item plus unit of measure is required.
*
*  The following output parameters are passed back to the calling program
*  for further testing and manipulation, so as only one call to this
*  routine is necessary:
*  *H510* - the recid of the price list will also be returned.
*
*      minprice        =    Price table minimum price.
*      maxprice        =    Price table maximum price.
*      pc_recno        =    Recid of the pc_mstr entry used.
*                           0 indicates no record was found.
*
*******************************************************************/
     {mfdeclre.i}

     define input        parameter price_list2 like pc_list.
     define input        parameter part        like pc_part.
     define input        parameter um          like pc_um.
     define input        parameter umconv      like sod_um_conv.
/*Y715*/ define input        parameter site        like si_site.
     define input        parameter eff_date    like pc_expire.
     define input        parameter curr        like pc_curr.
     define input        parameter newline     like mfc_logical.
/*H510*/ define input        parameter match_pt_um like mfc_logical.
     define input-output parameter list_price  like sod_list_pr.
     define input-output parameter net_price   like sod_price.
     define output       parameter minprice    like pc_min_price.
     define output       parameter maxprice    like pc_min_price.
/*H510*/ define output       parameter pc_recno    as recid.

     assign
/*H510*/    pc_recno   = 0
        minprice   = 0
        maxprice   = 0.

/*N0CD** find pt_mstr where pt_part = part no-lock no-error. */
/*N0CD*/ for first pt_mstr
/*N0CD*/    fields(pt_part pt_prod_line)
/*N0CD*/    where pt_part = part no-lock:
/*N0CD*/ end. /* FOR FIRST PT_MSTR */

     /* FIND PRICE LIST FOR PART AND UM */
/*N0CD* BEGIN DELETE **
 *     find last pc_mstr where pc_list = price_list2
 *                and pc_amt_type = "L"
 *                and pc_part = part
 *                and pc_um = um
 *                and (pc_start <= eff_date or pc_start = ?)
 *                and (pc_expire >= eff_date or pc_expire = ?)
 *                and pc_curr = curr
 *    no-lock no-error.
 *N0CD* END DELETE **/
/*N0CD*/ for last pc_mstr
/*N0CD*/    fields(pc_amt pc_amt_type pc_curr pc_expire pc_list
/*N0CD*/           pc_max_price pc_min_price pc_part pc_prod_line
/*N0CD*/           pc_start pc_um pc_user1)
/*N0CD*/    where pc_list     = price_list2                   and
/*N0CD*/          pc_amt_type = "L"                           and
/*N0CD*/          pc_part     = part                          and
/*N0CD*/          pc_um       = um                            and
/*Y715*/          pc_user1    = site                          and
/*N0CD*/          (pc_start <= eff_date or pc_start = ?)      and
/*N0CD*/          (pc_expire >= eff_date or pc_expire = ?)    and
/*N0CD*/          pc_curr    = curr no-lock
/*N0CD*/    query-tuning(no-index-hint hint "INDEX_DESC(T0 PC_MSTR##PC_PART)"):
/*N0CD*/ end. /* FOR LAST PC_MSTR */

/*H510*/ /* If an item/um price list is required and we didn't find one, */
/*H510*/ /* then we can stop now and go home.                            */
/*H510*/ if match_pt_um then do:
/*H510*/    match_pt_um = (available pc_mstr).
/*H510*/    if not match_pt_um then leave.
/*H510*/ end.

     /* FIND PRICE LIST FOR PART REGARDLESS OF UM */
     if not available pc_mstr then
/*N0CD* BEGIN DELETE **
 *      find last pc_mstr where pc_list = price_list2
 *                 and pc_amt_type = "L"
 *                 and pc_part = part
 *                 and pc_um = ""
 *                 and (pc_start <= eff_date or pc_start = ?)
 *                 and (pc_expire >= eff_date or pc_expire = ?)
 *                 and pc_curr = curr
 *     no-lock no-error.
 *N0CD END DELETE **/

/*N0CD*/ for last pc_mstr
/*N0CD*/    fields(pc_amt pc_amt_type pc_curr pc_expire pc_list
/*N0CD*/           pc_max_price pc_min_price pc_part pc_prod_line
/*N0CD*/           pc_start pc_um pc_user1)
/*N0CD*/    where pc_list     = price_list2                   and
/*N0CD*/          pc_amt_type = "L"                           and
/*N0CD*/          pc_part     = part                          and
/*N0CD*/          pc_um       = ""                            and
/*Y715*/          pc_user1    = site                          and
/*N0CD*/          (pc_start <= eff_date or pc_start = ?)      and
/*N0CD*/          (pc_expire >= eff_date or pc_expire = ?)    and
/*N0CD*/          pc_curr     = curr no-lock
/*N0CD*/    query-tuning(no-index-hint hint "INDEX_DESC(T0 PC_MSTR##PC_PART)"):
/*N0CD*/ end. /* FOR LAST PC_MSTR */

     /* FIND PRICE LIST FOR PRODUCT LINE AND UM */
     if not available pc_mstr and available pt_mstr then
/*N0CD* BEGIN DELETE **
 *      find last pc_mstr where pc_list = price_list2
 *                 and pc_amt_type = "L"
 *                 and pc_part = ""
 *                 and pc_prod_line = pt_prod_line
 *                 and pc_um = um
 *                 and (pc_start <= eff_date or pc_start = ?)
 *                 and (pc_expire >= eff_date or pc_expire = ?)
 *                 and pc_curr = curr
 *       no-lock no-error.
 *N0CD END DELETE **/

/*N0CD*/ for last pc_mstr
/*N0CD*/    fields(pc_amt pc_amt_type pc_curr pc_expire pc_list
/*N0CD*/           pc_max_price pc_min_price pc_part pc_prod_line
/*N0CD*/           pc_start pc_um pc_user1)
/*N0CD*/    where pc_list      = price_list2                        and
/*N0CD*/          pc_amt_type  = "L"                                and
/*N0CD*/          pc_part      =  ""                                and
/*N0CD*/          pc_prod_line = pt_prod_line                       and
/*N0CD*/          pc_um        = um                                 and
/*Y715*/          pc_user1     = site                               and
/*N0CD*/          (pc_start <= eff_date or pc_start = ?)            and
/*N0CD*/          (pc_expire >= eff_date or pc_expire = ?)          and
/*N0CD*/          pc_curr     = curr no-lock
/*N0CD*/    query-tuning(no-index-hint hint "INDEX_DESC(T0 PC_MSTR##PC_LIST)"):
/*N0CD*/ end. /* FOR LAST PC_MSTR */

     /* FIND PRICE LIST FOR PRODUCT LINE REGARDLESS OF UM */
     if not available pc_mstr and available pt_mstr then
/*N0CD* BEGIN DELETE **
 *      find last pc_mstr where pc_list = price_list2
 *                 and pc_amt_type = "L"
 *                 and pc_prod_line = pt_prod_line
 *                 and pc_part = ""
 *                 and pc_um = ""
 *                 and (pc_start <= eff_date or pc_start = ?)
 *                 and (pc_expire >= eff_date or pc_expire = ?)
 *                 and pc_curr = curr
 *     no-lock no-error.
 *N0CD END DELETE **/

/*N0CD*/ for last pc_mstr
/*N0CD*/    fields(pc_amt pc_amt_type pc_curr pc_expire pc_list
/*N0CD*/           pc_max_price pc_min_price pc_part pc_prod_line
/*N0CD*/           pc_start pc_um)
/*N0CD*/    where pc_list      = price_list2                        and
/*N0CD*/          pc_amt_type  = "L"                                and
/*N0CD*/          pc_prod_line = pt_prod_line                       and
/*N0CD*/          pc_part      = ""                                 and
/*N0CD*/          pc_um        = ""                                 and
/*Y715*/          pc_user1     = site                               and
/*N0CD*/          (pc_start <= eff_date or pc_start = ?)            and
/*N0CD*/          (pc_expire >= eff_date or pc_expire = ?)          and
/*N0CD*/          pc_curr      = curr no-lock
/*N0CD*/    query-tuning(no-index-hint hint "INDEX_DESC(T0 PC_MSTR##PC_LIST)"):
/*N0CD*/ end. /* FOR LAST PC_MSTR */

/*H1HH*/ /* FIND PRICE LIST FOR UM REGARDLESS OF PRODUCT LINE AND PART */
/*H1HH*/ if not available pc_mstr then

/*N0CD* BEGIN DELETE **
 * /*H1HH*/    find last pc_mstr where pc_list = price_list2
 * /*H1HH*/                and pc_amt_type = "L"
 * /*H1HH*/                and pc_prod_line = ""
 * /*H1HH*/                and pc_part = ""
 * /*H1HH*/                and pc_um = um
 * /*H1HH*/                and (pc_start <= eff_date or pc_start = ?)
 * /*H1HH*/                and (pc_expire >= eff_date or pc_expire = ?)
 * /*H1HH*/                and pc_curr = curr
 * /*H1HH*/    no-lock no-error.
 *N0CD* END DELETE **/

/*N0CD*/ for last pc_mstr
/*N0CD*/    fields(pc_amt pc_amt_type pc_curr pc_expire pc_list
/*N0CD*/           pc_max_price pc_min_price pc_part pc_prod_line
/*N0CD*/           pc_start pc_um)
/*N0CD*/    where pc_list      = price_list2                       and
/*N0CD*/          pc_amt_type  = "L"                               and
/*N0CD*/          pc_prod_line = ""                                and
/*N0CD*/          pc_part      = ""                                and
/*N0CD*/          pc_um        = um                                and
/*Y715*/          pc_user1     = site                              and
/*N0CD*/          (pc_start <= eff_date or pc_start = ?)           and
/*N0CD*/          (pc_expire >= eff_date or pc_expire = ?)         and
/*N0CD*/          pc_curr      = curr no-lock
/*N0CD*/    query-tuning(no-index-hint hint "INDEX_DESC(T0 PC_MSTR##PC_LIST)"):
/*N0CD*/ end. /* FOR LAST PC_MSTR */

     /* FIND MATCH ON PRICE LIST */
     if not available pc_mstr then

/*N0CD* BEGIN DELETE **
 *      find last pc_mstr where pc_list = price_list2
 *                 and pc_amt_type = "L"
 *                 and pc_prod_line = ""
 *                 and pc_part = ""
 *                 and pc_um = ""
 *                 and (pc_start <= eff_date or pc_start = ?)
 *                 and (pc_expire >= eff_date or pc_expire = ?)
 *                 and pc_curr = curr
 *     no-lock no-error.
 *N0CD* END DELETE **/

/*N0CD*/ for last pc_mstr
/*N0CD*/    fields(pc_amt pc_amt_type pc_curr pc_expire pc_list
/*N0CD*/           pc_max_price pc_min_price pc_part pc_prod_line
/*N0CD*/           pc_start pc_um)
/*N0CD*/    where pc_list      = price_list2                       and
/*N0CD*/          pc_amt_type  = "L"                               and
/*N0CD*/          pc_prod_line = ""                                and
/*N0CD*/          pc_part      = ""                                and
/*N0CD*/          pc_um        = ""                                and
/*Y715*/          pc_user1     = site                              and
/*N0CD*/          (pc_start <= eff_date or pc_start = ?)           and
/*N0CD*/          (pc_expire >= eff_date or pc_expire = ?)         and
/*N0CD*/          pc_curr      = curr no-lock
/*N0CD*/    query-tuning(no-index-hint hint "INDEX_DESC(T0 PC_MSTR##PC_LIST)"):
/*N0CD*/ end. /* FOR LAST PC_MSTR */

     if available pc_mstr then do:

/*H510*/    if pc_um = um then assign
/*H510*/       minprice   = pc_min_price
/*H0GH /*H510*/maxprice   = pc_max_price[1].      */
/*H0GH*/       maxprice   = pc_max_price[1] + (pc_max_price[2] / 100000).
/*H510*/    else assign
           minprice   = pc_min_price    * umconv
/*H0GH*/       maxprice   = (pc_max_price[1] + (pc_max_price[2] / 100000))
              * umconv.
/*H0GH         maxprice   = pc_max_price[1] * umconv.              */

        /* PLUG PRICE FROM PRICE TABLE */
        if newline and pc_amt[1] > 0 then do:
/*H510*/       if pc_um = um then
/*H510*/          list_price = pc_amt[1].
/*H510*/       else
          list_price = pc_amt[1] * umconv.
           net_price  = list_price.
/*H0G1 /*H510*/pc_recno   = recid(pc_mstr).*/
        end.
/*H0G1*/    pc_recno   = recid(pc_mstr).

     end.
