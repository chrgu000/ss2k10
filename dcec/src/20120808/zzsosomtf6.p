/* GUI CONVERTED from sosomtf6.p (converter v1.69) Wed Jul 17 15:47:18 1996 */
/* sosomtf6.p - SALES ORDER MAINTENANCE CONFIGURED PRODUCTS             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3      LAST MODIFIED: 06/15/94   BY: WUG *GK60*          */
/* REVISION: 7.3      LAST MODIFIED: 07/21/94   BY: WUG *GK86*          */
/* REVISION: 8.5      LAST MODIFIED: 03/05/95   BY: DAH *J042*          */
/* REVISION: 8.5      LAST MODIFIED: 07/10/96   BY: DAH *J0XR*          */
/* REVISION: 8.5      LAST MODIFIED: 07/15/96   BY: ajw *J0Z6*          */
/* REVISION: 8.5      LAST MODIFIED: 11/14/03   BY: *LB01* Long Bo         */

/*FACTORS SOB CHILDREN QTIES WHEN THE USER CHANGES A PARENT QTY*/

         define input parameter parent_id as character.
         define input parameter prior_parent_qty as decimal.
         define input parameter new_parent_qty as decimal.
/*J042*/ define input parameter update_accum_qty like mfc_logical.
/*J042*/ define input parameter sodum like sod_um.
/*J0XR*/ define input parameter sodumconv like sod_um_conv.

         define shared variable cpex_prefix as character.
         define shared variable cpex_ordernbr as character.
         define shared variable cpex_orderline as integer.

         define shared variable global_user_lang_dir as character.
         define variable temp_id as character.
         define variable req_qty as decimal.

         if prior_parent_qty = new_parent_qty then leave.

/*!      *******************************************
         sob_serial subfield positions:
         1-4     operation number (old - now 0's)
         5-10    scrap percent
         11-14   id number of this record
         15-15   structure code
         16-16   "y" (indicates "new" format sob_det record)
         17-34   original qty per parent
         35-35   original mandatory indicator (y/n)
         36-36   original default indicator (y/n)
         37-39   leadtime offset
         40-40   price manually updated (y/n)
         41-46   operation number (new - 6 digits)
         *******************************************/

         for each sob_det exclusive-lock
         where sob_nbr = cpex_prefix + cpex_ordernbr
         and sob_line = cpex_orderline
         and sob_parent = parent_id:

            req_qty = decimal(substring(sob_serial,17,18)).
            req_qty = (req_qty * new_parent_qty) / prior_parent_qty.

            assign
               substr(sob_serial,17,18) = string(req_qty,"-9999999.999999999")
               sob_qty_req = (sob_qty_req * new_parent_qty) / prior_parent_qty.

            temp_id = substr(sob_serial,11,4).

/*J042**    {gprun.i ""sosomtf6.p"" "(input temp_id, input prior_parent_qty,
**          input new_parent_qty)"}*/

/*J0XR*/    /*Added sodumconv to parameters*/
/*LB01**J042*/{gprun.i ""zzsosomtf6.p"" "(input temp_id,
                                      input prior_parent_qty,
                                      input new_parent_qty,
                                      input update_accum_qty,
                                      input sodum,
                                      input sodumconv)"}

/*J042*/    /*UPDATE ACCUM QTY WORKFILE WITH DIFFERENCE BETWEEN*/
            /*new_parent_qty AND prior_parent_qty.             */

            if update_accum_qty then do:

/*J0XR*/       /*Qualified the qty req'd (new parent qty - prior parent qty)*/
/*J0XR*/       /*and extended list (qty req'd * sob_tot_std) parameters to  */
/*J0XR*/       /*divide by u/m conversion ratio since these include this    */
/*J0XR*/       /*factor already.                                            */
/*LB01*/       {gprun.i ""zzgppiqty2.p"" "(input sob_line,
                                input sob_part,
                                input (new_parent_qty - prior_parent_qty)
                                                      / sodumconv,
                                input (new_parent_qty - prior_parent_qty) *
                                          sob_tot_std / sodumconv,
                                input sodum,
                                input no,
/*J0Z6*/                        input yes,
                                input yes)"}
            end.
         end.
