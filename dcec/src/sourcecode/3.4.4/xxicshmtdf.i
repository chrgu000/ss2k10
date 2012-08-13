/* icshmtdf.i - Shipper Maintenance Temp Table Definition                    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*V8:ConvertMode=NoConvert                                                   */
/*K1Q4*/ /*V8:WebEnabled=No                                                  */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */

         /* This table is used to store shipper line item information before */
         /* a shipper is actually created.  It is intended to be populated */
         /* at some point before calling procedure icshmt.p.  Icshmt.p */
         /* creates and allows maintenance of the shipper itself, and creates */
         /* a shipper detail for each record found in this temp table.  */

         /* Related procedures are icshmt1b.p (called by icshmt.p to build */
         /* the details from the temp table), icshmt1a.p (called by any */
         /* routine prior to the call to icshmt.p, to add a record to the */
         /* temp table), and icshmt1c.p (called wherever necessary to clear */
         /* all records from the temp table. */

         define {1} shared temp-table t_abs /* NOT no-undo */
            field t_abs_item    like abs_item
            field t_abs_lotser  like abs_lotser
            field t_abs_ref     like abs_ref
            field t_abs_site    like abs_site
            field t_abs_loc     like abs_loc
            field t_abs_qty     like abs_qty
            field t_abs_um      as   character
            field t_abs_um_conv as   decimal
            field t_abs_nwt     like abs_nwt
            field t_abs_wt_um   like abs_wt_um
            field t_abs_vol     like abs_vol
            field t_abs_vol_um  like abs_vol_um
            index t_part is primary /* NOT unique */
               t_abs_item
               t_abs_lotser
               t_abs_ref.
