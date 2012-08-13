/* GUI CONVERTED from sosomtf4.p (converter v1.69) Tue Jul 23 14:26:49 1996 */
/* sosomtf4.p - SALES ORDER MAINTENANCE CONFIGURED PRODUCTS             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3      LAST MODIFIED: 06/15/94   BY: WUG *GK60*          */
/* REVISION: 7.3      LAST MODIFIED: 07/21/94   BY: WUG *GK86*          */
/* REVISION: 7.3      LAST MODIFIED: 01/04/95   BY: aep *F0CN*          */
/* REVISION: 8.5      LAST MODIFIED: 03/05/95   BY: DAH *J042*          */
/* REVISION: 8.5      LAST MODIFIED: 07/10/96   BY: DAH *J0XR*          */
/* REVISION: 8.5      LAST MODIFIED: 07/15/96   BY: ajw *J0Z6*          */
/* REVISION: 8.5      LAST MODIFIED: 07/16/96   BY: DAH *J0Z9*          */
/* REVISION: 8.5      LAST MODIFIED: 11/14/03   BY: *LB01* Long Bo         */

         /*DELETE SOB_DET RECORD'S CHILDREN*/

         define input parameter parent_id as character.
/*J042*/ define input parameter update_accum_qty like mfc_logical.
/*J042*/ define input parameter sodum like sod_um.
/*J0XR*/ define input parameter sodumconv like sod_um_conv.

         define shared variable cpex_prefix as character.
         define shared variable cpex_ordernbr as character.
         define shared variable cpex_orderline as integer.

         define shared variable global_user_lang_dir as character.

         define variable temp_id as character.
/*F0CN*/ define variable mrp_recno as recid.
/*F0CN*/ define variable recno as recid.
/*J0Z9*/ define variable doc_type like pih_doc_type.

/*J042*/ {pppiwkpi.i } /*SHARED WORKFILE FOR PRICING*/

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
            temp_id = substr(sob_serial,11,4).

/*J0Z9*/    doc_type = if cpex_prefix = "" then
/*J0Z9*/                  1                      /*sales order*/
/*J0Z9*/               else
/*J0Z9*/                  2.                     /*sales quote*/

/*J042**    {gprun.i ""sosomtf4.p"" "(input temp_id)"}*/

/*J0XR*/    /*Added sodumconv to parameters*/
/*LB01**J042*/{gprun.i ""zzsosomtf4.p"" "(input temp_id,
                                      input update_accum_qty,
                                      input sodum,
                                      input sodumconv)"}

/*F0CN*     DELETE MRP_DETAIL AS REQUIRED                          */
            {mfmrw.i "sob_det" sob_part sob_nbr
            "string(sob_line) + ""-"" + sob_feature" sob_parent
            ? sob_iss_date "0" "DEMAND"
            "客户订单零件" sob_site}

/*J042*/    /* UPDATE ACCUM QTY WORKFILES AND PRICING WORKFILE IF
               LINE PRICING OR REPRICING IS ACTIVE*/

/*J042*/    if update_accum_qty then do:

/*J042*/       /* UPDATE ACCUM QTY WORKFILE WITH REVERSAL */
/*J0XR*/       /*Qualified the qty (sob_qty_req) and extended list   */
/*J0XR*/       /*(sob_qty_req * sob_tot_std) parameters to divide by */
/*J0XR*/       /*u/m conversion ratio since these include this factor*/
/*J0XR*/       /*already.                                            */
/*LB01*/       {gprun.i ""zzgppiqty2.p"" "(input sob_line,
                                         input sob_part,
                                         input - (sob_qty_req / sodumconv),
                                         input - (sob_qty_req * sob_tot_std
                                                              / sodumconv),
                                         input sodum,
                                         input no,
/*J0Z6*/                                 input yes,
                                         input yes)"}

/*J042*/       /* DELETE RELATED PRICING WORKFILE ENTRIES */
               for each wkpi_wkfl where wkpi_parent  = sob_parent and
                                        wkpi_feature = sob_feature and
                                        wkpi_option  = sob_part
                                  exclusive-lock:
                  delete wkpi_wkfl.
               end.

/*J0Z9*/       /* DELETE RELATED PRICE LIST HISTORY */
/*J0Z9*/       for each pih_hist where pih_doc_type = doc_type
/*J0Z9*/                           and pih_nbr      = sob_nbr
/*J0Z9*/                           and pih_line     = sob_line
/*J0Z9*/                           and pih_parent   = sob_parent
/*J0Z9*/                           and pih_feature  = sob_feature
/*J0Z9*/                           and pih_option   = sob_part
/*J0Z9*/                         exclusive-lock:
/*J0Z9*/          delete pih_hist.
/*J0Z9*/       end.

/*J042*/    end.

            delete sob_det.
         end.
