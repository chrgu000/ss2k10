/* sosoisc2.p - SALES ORDER SHIPMENT TRAILER                            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.4            CREATED: 09/21/93   BY: bcm *H127**/
/* REVISION: 7.4            CREATED: 09/10/94   BY: dpm *FQ97**/
/* REVISION: 7.4      LAST MODIFIED: 03/31/95   BY: jxz *G0K1**/
/* REVISION: 7.4      LAST MODIFIED: 06/06/95   BY: jym *G0ND**/
/* REVISION: 8.5      LAST MODIFIED: 10/05/95   BY: taf *J053**/
/* REVISION: 7.4      LAST MODIFIED: 12/27/95   BY: ais *G1HG**/
/* REVISION: 8.5      LAST MODIFIED: 09/26/97   BY: *J21S* Niranjan Ranka */
/* REVISION: 8.5      LAST MODIFIED: 12/30/97   BY: *J281* Manish K.      */
/* REVISION: 8.5      LAST MODIFIED: 10/02/97   BY: *J29S* Jim Williams   */


/* SS - 090707.1 By: Roger Xiao */



     /* DISPLAY TITLE */
/*F247*/ {mfdeclre.i}

     define shared variable so_mstr_recid as recid.
     define shared variable undo-all like mfc_logical no-undo.
     define shared variable eff_date like glt_effdate.
     define new shared variable so_recno as recid.
     define variable   shiplbl  as character   format "x(13)".   /*F379*/
     define buffer somstr for so_mstr.
     define shared frame f.
     define shared frame sotot.
     define shared variable undo_isc1 like mfc_logical.
/*J053*/ /* DEFINED IN MFSOTRLA.I */
/*J053*  define shared variable tax_edit like mfc_logical. */
/*J053*  define shared variable tax_edit_lbl like mfc_char.*/
/*G0K1*/ define shared variable so_db   like dc_name.
/*G0K1*/ define shared variable ship_db like dc_name.
/*G0K1*/ define variable sonbr     like so_nbr.
/*G0K1*/ define variable ship_via  like so_shipvia.
/*G0K1*/ define variable ship_date like so_ship_date.
/*G0K1*/ define variable bol       like so_bol.
/*G0K1*/ define variable rmks      like so_rmks.
/*G0K1*/ define variable inv_nbr   like so_inv_nbr.
/*G0K1*/ define variable to_inv    like so_to_inv.
/*G0K1*/ define variable invoiced  like so_invoiced.
/*G0K1*/ define variable undo_flag like mfc_logical no-undo.
/*G0K1*/ define variable err_flag as integer.
/*G0ND*/ define variable    w-accept       like mfc_logical no-undo.
/*J281*/ define variable  l_consolidate_ok like mfc_logical   no-undo.
/*J281*/ define variable  l_msg_text       as character no-undo.
/*G1HG*/ define buffer simstr for si_mstr.

     {sosois1.i}
     {mfsotrla.i}
/*J053*  {sototfrm.i} /* Define trailer form for Tax Management */ */

/*FQ97*/ find first soc_ctrl no-lock.
     find first gl_ctrl no-lock.
     maint = yes.

     undo-all = yes.

     find so_mstr where recid(so_mstr) = so_mstr_recid.
     so_recno = recid(so_mstr).

     form
         so_shipvia     colon 15
         so_inv_nbr     colon 55 skip
/*J21S** shiplbl        colon 3          no-label   /*F379*/ */
/*J21S** so_ship_date   colon 17         no-label   /*F379*/ */
/*J21S*/ so_ship_date   colon 15
         so_to_inv      colon 55 skip
         so_bol         colon 15
         so_invoiced    colon 55
         so_rmks        colon 15
     with frame f side-labels width 80.

/*G0K1*/ assign
         sonbr = ""
         ship_via = ""
         ship_date = ?
         bol = ""
         rmks = ""
         inv_nbr = ""
         to_inv = no
         invoiced = no.

     settrl:
     do on error undo, retry:
        set so_shipvia so_ship_date so_bol so_rmks
        so_inv_nbr so_to_inv so_invoiced
        with frame f.

/*G0ND*/  w-accept = no.
/*G0ND*/  if can-find(mfc_ctrl where mfc_module = "SO" and
/*G0ND*/     mfc_seq = 170) then do while not w-accept:
/*G0ND*/      {mfmsg01.i 32 1 w-accept}   /* please accept */
/*G0ND*/      if w-accept then leave.
/*G0ND*/         set so_shipvia so_ship_date so_bol so_rmks
/*G0ND*/           so_inv_nbr so_to_inv so_invoiced
/*G0ND*/           with frame f.
/*G0ND*/  end. /* multiple bol set */

        if so_inv_nbr <> "" then do for somstr:
           /* CHECK FOR DUPLICATE INVOICE NUMBERS */
           find  first
           somstr where somstr.so_inv_nbr = so_mstr.so_inv_nbr
              and somstr.so_nbr <> so_mstr.so_nbr
            no-lock no-error.

           find ar_mstr where ar_mstr.ar_nbr = so_mstr.so_inv_nbr
           no-lock no-error.

/*G1HG***
* /*FQ97*/       if soc_ar = no then find first ih_hist
* /*FQ97*/          where ih_inv_nbr = so_mstr.so_inv_nbr no-lock no-error.
* /*FQ97*        if (available somstr) or (available ar_mstr) then do: */
* /*FQ97*/       if (available somstr) or (available ar_mstr)
*                or (available ih_hist) then do:
*                   next-prompt so_mstr.so_inv_nbr with frame f.
*                   {mfmsg.i 1165 3} /* Duplicate invoice number */
*                   undo settrl, retry.
*                end.
**G1HG**/

/*G1HG*/    find first ih_hist where ih_inv_nbr = so_mstr.so_inv_nbr
/*G1HG*/                         and ih_nbr = so_mstr.so_nbr no-lock no-error.
/*G1HG*/    if available somstr
/*G1HG*/    then do:
/*G1HG*/       find si_mstr where si_mstr.si_site = so_mstr.so_site
/*G1HG*/            no-lock no-error.
/*G1HG*/       find simstr  where simstr.si_site = somstr.so_site
/*G1HG*/            no-lock no-error.
/*G1HG*/    end.

/*G1HG*/    if (available ar_mstr)
/*G1HG*/    then do:
/*G1HG*/       next-prompt so_mstr.so_inv_nbr with frame d.
/*G1HG*/       /* duplicate invoice number */
/*G1HG*/       {mfmsg.i 1165 3}
/*G1HG*/       undo settrl, retry.
/*G1HG*/    end.
/*G1HG*/    else
/*G1HG*/    if (available ih_hist)
/*G1HG*/    then do:
/*G1HG*/       next-prompt so_mstr.so_inv_nbr with frame d.
/*G1HG*/       /* History for Sales Order/Invoice exists */
/*G1HG*/       {mfmsg.i 1045 3}
/*G1HG*/       undo settrl, retry.
/*G1HG*/    end.
/*G1HG*/    else do:
/*G1HG*/       if available somstr then do:

/*J281*/    /* PROCEDURE FOR CONSOLIDATION RULES */
/*J281*/    {gprun.i ""soconso.p"" "(input 1,
                     input somstr.so_nbr,
                     input so_mstr.so_nbr,
                         output l_consolidate_ok,
                         output l_msg_text)"}

/*J281*/ /* COSOLIDATION RULES NOW MOVED TO soconso.p */

/*J281** BEGIN DELETE **
 * /*G1HG*/       if  (somstr.so_bill     <> so_mstr.so_bill
 * /*G1HG*/       or  somstr.so_cust      <> so_mstr.so_cust
 * /*G1HG*/       or  somstr.so_curr      <> so_mstr.so_curr
 * /*G1HG*/       or  somstr.so_cr_terms  <> so_mstr.so_cr_terms
 * /*G1HG*/       or  somstr.so_trl1_cd   <> so_mstr.so_trl1_cd
 * /*G1HG*/       or  somstr.so_trl2_cd   <> so_mstr.so_trl2_cd
 * /*G1HG*/       or  somstr.so_trl3_cd   <> so_mstr.so_trl3_cd
 * /*G1HG*/       or  somstr.so_slspsn[1] <> so_mstr.so_slspsn[1]
 * /*G1HG*/       or  somstr.so_slspsn[2] <> so_mstr.so_slspsn[2]
 * /*G1HG*/       or  somstr.so_slspsn[3] <> so_mstr.so_slspsn[3]
 * /*G1HG*/       or  somstr.so_slspsn[4] <> so_mstr.so_slspsn[4]
 * /*G1HG*/       or  (available si_mstr and available simstr and
 * /*G1HG*/            simstr.si_entity   <> si_mstr.si_entity))
 * /*G1HG*/        then do:
 *J281** END DELETE ** */

/*J281*/          if not l_consolidate_ok then do:
/*G1HG*/             next-prompt so_mstr.so_inv_nbr with frame d.
/*G1HG*/             /* mismatch with open invoice - can't consolidate */
/*G1HG*/             {mfmsg.i 1046 3}
/*G1HG*/             undo settrl, retry.
/*G1HG*/          end.
/*G1HG*/          else do:
/*G1HG*/             /* Invoice already open.  Consolidation will be done */
/*G1HG*/             {mfmsg.i 1047 2}
/*G1HG*/             hide message.
/*G1HG*/          end.
/*G1HG*/       end.   /* avail somstr */
/*G1HG*/    end.  /* no ih_hist */
        end.

        if so_mstr.so_inv_nbr = "" and so_mstr.so_invoiced = yes then do:
           next-prompt so_mstr.so_inv_nbr with frame f.
           {mfmsg.i 40 3} /* Blank not allowed */
           undo settrl, retry.
        end.

/*G0K1*/  /* copy these value into remote database if necessary */
/*G0K1*/  if ship_db <> so_db then do:
/*G0K1*/     {gprun.i ""gpalias3.p"" "(ship_db, output err_flag)" }
/*J29S*/     if err_flag = 2 or err_flag = 3 then do:
/*J29S*/        {mfmsg03.i 2510 4 "ship_db" """" """"}
/*J29S*/        /* DB NOT CONNECTED*/
/*J29S*/        pause.
/*J29S*/        undo settrl, retry.
/*J29S*/     end.
/*G0K1*/  end.

/*G0K1*/  assign
         sonbr = so_nbr
         ship_via = so_shipvia
         ship_date = so_ship_date
         bol = so_bol
         rmks = so_rmks
         inv_nbr = so_inv_nbr
         to_inv = so_to_inv
         invoiced = so_invoiced.

/*G0K1*/  /* updating SO trailer info at remote site */
/*G0K1*/  {gprun.i ""sosoisc3.p"" "(input sonbr,
                    input ship_via,
                    input ship_date,
                    input bol,
                    input rmks,
                    input inv_nbr,
                    input to_inv,
                    input invoiced)"
                    }

/*G0K1*/  if ship_db <> so_db then do:
/*G0K1*/     {gprun.i ""gpalias3.p"" "(so_db, output err_flag)" }
/*J29S*/     if err_flag = 2 or err_flag = 3 then do:
/*J29S*/        {mfmsg03.i 2510 4 "so_db" """" """"}
/*J29S*/        /* DB NOT CONNECTED*/
/*J29S*/        pause.
/*J29S*/        undo settrl, retry.
/*J29S*/     end.
/*G0K1*/  end.

        /* SET PICK LIST REQUIRED TO YES */
        undo-all = no.

        undo_isc1 = false.

        /* SS - 090707.1 - B */
        define var v_yn as logical Format "Y/N".
        v_yn = yes.
        message "·¢³öInvoice? :" update v_yn .
        if v_yn = no then do :
            undo ,retry .
        end.
        /* SS - 090707.1 - E */

     end.




