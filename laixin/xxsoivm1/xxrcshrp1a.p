/* rcshrp1a.p - PRE-SHIPPERSHIPPER REPORT                               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* REVISION: 8.6    LAST MODIFIED: 10/17/96   BY: *K003* Kieu Nguyen    */
/* REVISION: 8.6    LAST MODIFIED: 07/30/97   BY: *K0H7* Taek-Soo Chang    */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00   BY: *N0KP* myb               */
/* REVISION: 9.1    LAST MODIFIED: 03/31/06   BY: *SS - 20060331* Bill Jiang               */
/* By: Neil Gao Date: *ss 20070227.1 ECO: *ss 20070227.1* */

/* SHIPPER REPORT SUBPROGRAM */


     {mfdeclre.i}


/*K0H7*  define input param abs_recid as recid.  */
/*K0H7*/ define input param i_recid as recid no-undo.
     /* SS - 20060331 - B */
     /*
/*K0H7*/ define input param part like pt_part no-undo.
/*K0H7*/ define input param part1 like pt_part no-undo.
/*K0H7*/ define input param sonbr like so_nbr no-undo.
/*K0H7*/ define input param sonbr1 like so_nbr no-undo.
/*K0H7*/ define output param v_items as logical no-undo.
*/
/* SS - 20060331 - E */

/*K0H7*/ define temp-table t_done no-undo
/*K0H7*/    field t_recid as recid
/*K0H7*/    index t_recid is primary unique t_recid.


/*K0H7*  define variable par_shipfrom as character.
 *   define variable par_id as character.
 *
 *K0H7*/

    /* TEMP-TABLE */
        define shared TEMP-TABLE tab_abs
        field tab_id              like abs_id
        field tab_item            like abs_item
        field tab_shipto          like abs_shipto
        field tab_shipfrom        like abs_shipfrom
        field tab_order           like abs_order
        field tab_line            like sod_line
        field tab_qty             like abs_qty
        field tab_recid           as recid
        /* SS - 20060401 - B */
        FIELD TAB_par_id LIKE ABS_par_id
        FIELD TAB_ship_qty LIKE ABS_ship_qty
        FIELD TAB__dec04 LIKE ABS__dec04
        FIELD TAB__qad02 LIKE ABS__qad02
        /* SS - 20060401 - E */
        .

        /* SS - 20060331 - B */
        /*
/*K0H7*/ for each tab_abs exclusive-lock:
/*K0H7*/     delete tab_abs.
/*K0H7*/ end.

/*K0H7*/ run ip_abs_item (input i_recid, input-out v_items).
*/
/*K0H7*/ run ip_abs_item (input i_recid).
/* SS - 20060331 - E */

/*K0H7*
 *   find abs_mstr where recid(abs_mstr) = abs_recid no-lock.
 *
 *       if abs_id begins "i"  then do for tab_abs:
 *      create tab_abs.
 *      assign
 *             tab_id            = abs_mstr.abs_id
 *         tab_item          = abs_mstr.abs_item
 *             tab_shipto        = abs_mstr.abs_shipto
 *             tab_shipfrom      = abs_mstr.abs_shipfrom
 *         tab_order         = abs_mstr.abs_order
 *         tab_line          = integer(abs_mstr.abs_line)
 *             tab_qty           = abs_mstr.abs_qty .
 *   end.

 *        if abs_id begins "i" then return.

 *   par_shipfrom = abs_shipfrom.
 *   par_id = abs_id.
 *
 *   for each abs_mstr no-lock
 *   where abs_shipfrom = par_shipfrom
 *   and abs_par_id = par_id:
 *          {gprun.i ""rcshrp1a.p"" "(input recid(abs_mstr))"}
 *   end.
*K0H7*/

procedure ip_abs_item:
/*This replaces the  body of orginal rcshrp1a.p as part of ECO K0H7 */


/*K0H7*/ define input param i_recid as recid no-undo.
/* SS - 20060331 - B */
/*
/*K0H7*/ define input-output param v_items as logical no-undo.
*/
/* SS - 20060331 - E */


/*K0H7*/ define variable par_shipfrom as character.
/*K0H7*/ define variable par_id as character.


/*K0H7*/ if can-find(t_done where t_recid eq i_recid) then return.

/*K0H7*/ create t_done.
/*K0H7*/ t_recid = i_recid.
/*K0H7*/ if recid(t_done) eq -1 then .

/*K0H7*/ find abs_mstr where recid(abs_mstr) = i_recid no-lock.

/* SS - 20060331 - B */
/*
/*K0H7*/ if abs_id begins "i"  and abs_item >= part and
/*K0H7*/               abs_item <= part1 and
/*K0H7*/               abs_order >= sonbr and
/*K0H7*/               abs_order <= sonbr1
/*K0H7*/               then do transaction:
   */
/*K0H7*/ if abs_id begins "i"  and abs__chr01 = ""
/*K0H7*/               then do transaction:
   /* SS - 20060401 - E */
/*K0H7*/    create tab_abs.
/*K0H7*/    assign
/*K0H7*/       tab_id       = abs_mstr.abs_id
/*K0H7*/       tab_item     = abs_mstr.abs_item
/*K0H7*/       tab_shipto   = abs_mstr.abs_shipto
/*K0H7*/       tab_shipfrom = abs_mstr.abs_shipfrom
/*K0H7*/       tab_order    = abs_mstr.abs_order
/*K0H7*/       tab_line     = integer(abs_mstr.abs_line)
/*K0H7*/       tab_qty      = abs_mstr.abs_qty 
               tab_par_id   = abs_mstr.abs_par_id
               tab_ship_qty = abs_mstr.abs_ship_qty
               tab__dec04   = abs_mstr.abs__dec04
               tab__qad02   = abs_mstr.abs__qad02
               .
/* SS - 20060401 - B */
/*
/*K0H7*/       v_items = yes.
               */
               /* SS - 20060331 - E */
/*K0H7*/ end.

/*K0H7*/ if abs_id begins "i" then return.

/*K0H7*/ assign  par_shipfrom = abs_shipfrom
/*K0H7*/         par_id = abs_id.

/*K0H7*/ for each abs_mstr no-lock
/*K0H7*/     where abs_shipfrom = par_shipfrom
/* ss 20070227.1 */ and abs_domain = global_domain
/*K0H7*/     and abs_par_id = par_id:

   /* SS - 20060331 - B */
   /*
/*K0H7*/    run ip_abs_item (input recid(abs_mstr),
                 input-output v_items).
*/
/*K0H7*/    run ip_abs_item (input recid(abs_mstr)).
/* SS - 20060331 - E */
/*K0H7*/ end.
/*K0H7*/end procedure.  /* ip_abs_item */
