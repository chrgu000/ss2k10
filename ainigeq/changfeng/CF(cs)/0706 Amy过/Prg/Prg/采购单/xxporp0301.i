/* porp0301.i - PURCHASE ORDER PRINT DETAIL INCLUDE FILE                      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.14.2.14 $                                                      */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 6.0     LAST MODIFIED: 08/14/91    BY: RAM *D828**/
/* REVISION: 6.0     LAST MODIFIED: 09/25/91    BY: RAM *D875**/
/* REVISION: 6.0     LAST MODIFIED: 11/05/91    BY: RAM *D913**/
/* REVISION: 7.3     LAST MODIFIED: 02/22/93    by: jms *G712**/
/* REVISION: 7.3     LAST MODIFIED: 04/09/93    BY: afs *G926**/
/* REVISION: 7.4     LAST MODIFIED: 07/26/94    BY: dpm *H459**/
/* REVISION: 7.4     LAST MODIFIED: 07/26/94    BY: dpm *FP50**/
/* REVISION: 7.4     LAST MODIFIED: 02/09/95    BY: jxz *F0HF**/
/* REVISION: 8.5     LAST MODIFIED: 11/07/95    BY: taf *J053**/
/* REVISION: 7.4     LAST MODIFIED: 10/05/95    BY: ais *H0G7**/
/* REVISION: 8.6     LAST MODIFIED: 11/21/96    BY: *K022* Tejas Modi         */
/* REVISION: 8.6     LAST MODIFIED: 04/06/97    BY: *K09P* Kieu Nguyen        */
/* REVISION: 8.6     LAST MODIFIED: 04/23/97    BY: *K0C8* Arul Victoria      */
/* REVISION: 8.6     LAST MODIFIED: 06/19/97    BY: *H19R* Suresh Nayak       */
/* REVISION: 8.6     LAST MODIFIED: 09/16/97    BY: *J20Y* Aruna Patil        */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED: 04/28/98    BY: *H1KW* A. Licha           */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan         */
/* REVISION: 8.6E    LAST MODIFIED: 03/31/99    BY: *K205* Kedar Deherkar     */
/* REVISION: 9.1     LAST MODIFIED: 09/27/99    BY: *N01B* John Corda         */
/* REVISION: 9.1     LAST MODIFIED: 10/25/99    BY: *N002* Bill Gates         */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 05/05/00    BY: *N09M* Peter Faherty      */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KQ* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.14.2.9       BY: Katie Hilbert     DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.14.2.10      BY: Jean Miller       DATE: 04/16/02  ECO: *P05H* */
/* Revision: 1.14.2.12      BY: Jean Miller       DATE: 04/26/02  ECO: *P05M* */
/* Revision: 1.14.2.13      BY: Ellen Borden      DATE: 05/24/02  ECO: *P018* */
/* $Revision: 1.14.2.14 $    BY: Mamata Samant     DATE: 07/25/02  ECO: *N1PQ* */
/* $Revision: 1.14.2.14 $    BY: Micho Yang        DATE: 03/20/06  ECO: *SS - 20060320* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* PARAMETER TO FACILITATE DISPLAY OF "SIMULATION" */
/* TEXT IN REPORT HEADER                           */

define input parameter update_yn like mfc_logical no-undo.

define shared variable rndmthd like rnd_rnd_mthd.
define shared frame c.
define shared frame phead1.
define shared variable pages as integer.
define shared variable po_recno as recid.
define shared variable addr as character format "x(38)" extent 6.
define shared variable billto as character format "x(38)" extent 6.
define shared variable vendor as character format "x(38)" extent 6.
define shared variable shipto as character format "x(38)" extent 6.
define shared variable poship like po_ship.
define shared variable duplicate as character format "x(11)" label "".
define shared variable vend_phone like ad_phone.

DEFINE SHARED VAR vship_phone LIKE ad_phone.
DEFINE SHARED VAR vship_attn  LIKE ad_attn.

define shared variable terms like ct_desc.
define variable dup-lbl as character format "x(10)".
define variable prepaid-lbl as character format "x(17)".
define variable signature-lbl as character format "x(34)".
define variable by-lbl as character format "x(3)".
define variable ext_cost like pod_pur_cost format "(z,zzz,zzz,zz9.99)".
define variable desc1 like pod_desc.
define variable desc2 like pt_desc2.
define variable qty_open like pod_qty_ord format "->>>>>>9.9<<<<<<".
define variable det_lines as integer.
define variable tax_flag as character format "x(1)".
define variable mfgr like vp_mfgr.
define variable mfgr_part like vp_mfgr_part.
define variable y-lbl as character format "x(1)".
define variable n-lbl as character format "x(1)".
define variable rev-lbl as character format "x(10)".
define variable vpart-lbl as character format "x(15)".
define variable manuf-lbl as character format "x(14)".
define variable part-lbl as character format "x(6)".
define variable site-lbl as character format "x(6)".
define variable disc-lbl as character format "x(5)".
define variable discdesc as character format "x(14)".
define variable type-lbl as character format "x(6)".
define variable typedesc as character format "x(11)".
define variable cont-lbl as character format "x(12)".
define variable vd-attn-lbl as character format "x(16)".
define shared variable vdattnlbl like vd-attn-lbl.
define shared variable vdattn like ad_attn.
define variable nullstring as character initial "" format "x(1)".
define variable i as integer.
define variable lot-lbl as  character format "X(43)".
define shared variable include_sched like mfc_logical.
define shared variable print_options like mfc_logical.
define variable doc_type as character initial "2".

define variable cont_lbl as character format "x(10)".
define new shared variable pod_recno as recid.
define variable l_unit_cost like pod_pur_cost no-undo.
define variable l_print_price as logical no-undo.

define variable l_dummy1     like pod_pur_cost no-undo.
define variable l_dummy2     like pod_disc_pct no-undo.
define variable l_dummy_cost like pod_pur_cost no-undo.
define variable l_pc_recno    as recid no-undo.
define variable c-consigment-contract as character format "x(40)" no-undo.
{pocnvars.i} /* Consignment variables */

cont_lbl = "**" + (dynamic-function('getTermLabelFillCentered' in h-label,
   input "CONTINUE",
   input 06,
   input "*")) + "**".

{po03b01.i}
{po03d01.i} /* DEFINE FOR FRAME C */

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_SUPPLIER_CONSIGNMENT,
     input 11,
     input ADG,
     input SUPPLIER_CONSIGN_CTRL_TABLE,
     output using_supplier_consignment)"}

c-consigment-contract = getTermLabel("CONTRACT",15) + ": " +
                        getTermLabel("CONSIGNMENT_INVENTORY",33).

find po_mstr no-lock where recid(po_mstr) = po_recno.

/* DEFINE VARIABLED FOR DISPLAY OF VAT REG NO & COUNTRY CODE */
{gpvtepdf.i &var="shared"}

{xxpo03a01.i}

/* PRINT HEADER DETAILS FOR A PO WITH NO LINE DETAILS. */

if  available po_mstr
and not can-find(first pod_det
                 where pod_nbr  = po_nbr
                   and (not pod_sched or include_sched))
then do:
   for first ad_mstr
      fields (ad_addr ad_city ad_country ad_format ad_line1 ad_line2 ad_line3
              ad_name ad_pst_id ad_state ad_zip)
      where ad_addr = po_ship
   no-lock:
   end. /* FOR FIRST ad_mstr */
   if available ad_mstr
   then do:

      run ip_header_populate (buffer ad_mstr).

   end. /* IF AVAILABLE ad_mstr */

   run ip_header_print (input po_cmtindx).

end. /* IF AVAILABLE po_mstr AND ..*/
else do:

   /* Print Order Detail */
   for each pod_det where (pod_nbr = po_nbr)
      and (not pod_sched or include_sched)
   no-lock
   use-index pod_nbrln break by {&sort1} by {&sort2}
   with frame c width 80:

      if ("{&sort1}" = "pod_site" and first-of(pod_site))
      or ("{&sort1}" = "pod_line" and first(pod_line))
      then do:

         update shipto = "".

         if  "{&sort1}" = "pod_site" and pod_site <> ""
         then do:
            poship = pod_site.
            find ad_mstr where ad_addr = pod_site no-lock no-error.
         end.

         if "{&sort1}" = "pod_line"
         or pod_site = ""
         or po_is_btb
         or ("{&sort1}" = "pod_site" and pod_site <> ""
         and not available ad_mstr)
         then do:
            poship = po_ship.
            find ad_mstr where ad_addr = po_ship no-lock no-error.
         end.

         if available ad_mstr
         then do:

            run ip_header_populate (buffer ad_mstr).

         end. /* IF AVAILABLE ad_mstr */

         run ip_header_print (input po_cmtindx).

      end. /* IF ("{&sort1}" = "pod_site" AND ... */

      desc1 = "".
      desc2 = "".

      /* PRINT ORDER DETAIL */
      tax_flag = n-lbl.

      if pod_taxable = yes then
         tax_flag = y-lbl.

      if pod_status = "c" or pod_status = "x" then
         qty_open = 0.

      if pod_status <> "c" and pod_status <> "x" then do:
         if pod_qty_ord >= 0 then
            qty_open = max(pod_qty_ord - pod_qty_rcvd,0).
         if pod_qty_ord < 0 then
            qty_open = min(pod_qty_ord - pod_qty_rcvd,0).
      end.

      /* FOLLOWING SECTION MODIFIED SO THAT THE ACTUAL PURCHASE PRICE OF THE */
      /* ITEM WILL BE PRINTED WHEN THE DISCOUNT TABLE IN THE PO HAS A PRICE  */
      /* LIST OF TYPE P AND  THE PRICE TABLE IS BLANK.                       */
      for first poc_ctrl
         fields ( poc_pl_req )
      no-lock:
      end.

      {gprun.i ""gppccal.p""
         "(input        pod_part,
           input        qty_open,
           input        pod_um,
           input        pod_um_conv,
           input        po_curr,
           input        po_pr_list,
           input        if poc_pc_line then pod_due_date
                        else po_ord_date,
           input        pod_pur_cost,
           input        poc_pl_req,
           input        pod_disc_pct,
           input-output l_dummy1,
           output       l_dummy2,
           input-output l_dummy_cost,
           output       l_pc_recno)" }

      if po_pr_list2 = "" and po_pr_list <> "" then do:
         find pc_mstr where recid (pc_mstr) = l_pc_recno no-lock no-error.
         if available pc_mstr and pc_amt_type = "P" then
            l_print_price = yes.
         else
            l_print_price = no.
      end. /* IF PO_PR_LIST2 = "" */

      l_unit_cost = pod_pur_cost.

      if ((pod__qad02 = 0 or pod__qad02 = ?) and
          (pod__qad09 = 0 or pod__qad09 = ?))
      then do:
         ext_cost = pod_pur_cost * qty_open * (1 - (pod_disc_pct / 100)).
         if l_print_price then
            assign
               l_unit_cost = pod_pur_cost * (1 - (pod_disc_pct / 100)).
      end.

      else do:
         ext_cost = (pod__qad09 + pod__qad02 / 100000) * qty_open.
         if l_print_price then
            assign
               l_unit_cost = (pod__qad09 + pod__qad02 / 100000).
      end.

      /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
      {gprun.i ""gpcurrnd.p""
         "(input-output ext_cost,
           input        rndmthd)"}

      accumulate ext_cost (total).

      discdesc = "".

      if pod_disc_pct <> 0 and not(l_print_price) then
         discdesc = disc-lbl + string(pod_disc_pct,"->>9.9<%").

      desc1 = pod_desc.
      if can-find(first pt_mstr where pt_part = pod_part) then do:
         find pt_mstr where pt_part = pod_part no-lock no-wait no-error.
         if (pod_desc = "" or pod_desc = pt_desc1) and available pt_mstr then
            desc1 = pt_desc1 + " " + pt_desc2.
         else
            desc2 = pt_desc2.
      end.

      mfgr = "".
      mfgr_part = "".

      if pod_vpart <> "" then do:
         find first vp_mstr
            where vp_vend = po_vend and
                  vp_vend_part = pod_vpart and
                  vp_part = pod_part
         no-lock no-error.
         if available vp_mstr then
            assign
               mfgr = vp_mfgr
               mfgr_part = vp_mfgr_part.
      end.

      /* DETERMINE NUMBER OF LINES NEEDED FOR DETAIL */
      det_lines = 1.
      if pod_rev <> "" then
         det_lines = det_lines + 1.
      if pod_site <> "" and poship = po_ship then
         det_lines = det_lines + 1.
      if pod_vpart <> "" then
         det_lines = det_lines + 1.
      if pod_type <> "" then
         det_lines = det_lines + 1.
      if mfgr <> "" or mfgr_part <> "" then
         det_lines = det_lines + 1.
      if desc1 <> "" then
         det_lines = det_lines + 1.
      if desc2 <> "" then
         det_lines = det_lines + 1.
      if pod_wip_lotser > "" then
         det_lines = det_lines + 1.

      if page-size - det_lines - line-counter < 3 then do:
         page.
         put skip(1).
      end.

      /*DISPLAY LINE ITEM*/
      display
         pod_line
         pod_part
         tax_flag
         pod_due_date
         qty_open
         pod_um
         l_unit_cost @ pod_pur_cost
         ext_cost
      with frame c.
      down 1 with frame c.

      /*
      if po_is_btb and po_so_nbr <> "" then
         put
            (getTermLabel("EMT_SALES_ORDER",06) + ":") format "x(07)" at 5
            po_so_nbr
            (getTermLabel("EMT_SALES_ORDER_LINE",09) + ":") format "x(10)" at 21
            pod_sod_line skip.

      if pod_rev <> "" then do:
         put
            rev-lbl at 5
            pod_rev
            discdesc at 50
            skip.
         discdesc = "".
      end.

      if pod_site <> "" and poship = po_ship then do:
         put
            site-lbl at 5
            pod_site
            discdesc at 50
            skip.
         discdesc = "".
      end.

      if pod_vpart <> "" then do:
         put
            vpart-lbl at 5
            pod_vpart
            discdesc at 50
            skip.
         discdesc = "".
      end.

      if pod_type <> "" then do:
         if pod_type = "M" then
            typedesc = getTermLabel("MEMO",8).
         else
            if pod_type = "S" then
               typedesc = getTermLabel("SUBCONTRACT",14).
            else
               typedesc = pod_type.
         put
            type-lbl at 5
            typedesc
            discdesc at 50
            skip.
         discdesc = "".
      end.

      if discdesc <> "" then
         put
            discdesc at 50 skip.
         if mfgr <> "" or mfgr_part <> "" then
            put
               manuf-lbl at 5
               mfgr space(2)
               part-lbl
               mfgr_part
               skip.
      */

      if desc1 <> "" then put desc1 at 5 format "x(49)" skip.
      if desc2 <> "" then put desc2 at 5 format "x(49)" skip.

      /*
      if pod_wip_lotser > '' then do:
         put
            (getTermLabel("LOT/SERIAL",10) + ":") format "x(11)" at 5 space
            pod_wip_lotser format 'x(18)'
            skip.
      end.
      */

      /* IF LINE IS CONSIGNED, THEN DISPLAY */
      /* A CONSIGNMENT BANNER.              */
      /*
      if using_supplier_consignment and pod_consignment then
         put c-consigment-contract at 5 skip.
      */

      /************************************************
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
       ****************************************************/

      /* AVOIDING FULL TABLE SCAN OF SOD_DET BY UTILISING SOD_PART INDEX */
      find sod_det
         where sod_part         = pod_part
           and sod_btb_po       = pod_nbr
           and sod_btb_pod_line = pod_line
      no-lock no-error.

      if available sod_det then do:

         if print_options and
            can-find(first sob_det
                     where sob_nbr = sod_nbr and sob_line = sod_line)
         then do:

            find first sob_det
               where sob_nbr  = sod_nbr
                 and sob_line = sod_line
            no-lock no-error.

            /* NEW STYLE sob_det RECORDS CONTAIN A
               SYMBOLIC REFERENCE IDENTIFIED BY BYTES 11-14 IN sob_serial.
               NEW STYLE sob_det RECORDS ARE FOR SALES ORDERS CREATED
               SINCE PATCH GK60. */

            pod_recno = recid(pod_det).
            {gprun.i ""porp3a02.p""
               "(input """", input 0,
                 input sod_nbr, input sod_line)"}

         end.  /* IF print_options */

      end.  /* IF AVAILABLE sod_det */

      /*
      /* REPLACED frame d WITH frame c IN THE COMMAND PARAMETER */
      {gpcmtprt.i &type=PO &id=pod_cmtindx &pos=5
         &command="display pod_line pod_part nullstring @ tax_flag
                   nullstring @ pod_due_date nullstring @ qty_open
                   nullstring @ pod_um
                   cont-lbl @ pod_pur_cost
                   nullstring @ ext_cost with frame c."}
      */

      {mfrpchk.i}

   end.
end. /* IF AVAILABLE po_mstr AND NOT... ELSE DO */

PROCEDURE ip_header_populate:
/*******************************************************************
 * Purpose    - POPULATES THE ADDRESS FIELDS                       *
 * Parameters - admstr       - BUFFER                              *
 * Comments   - INTRODUCED BY N1PQ                                 *
 *******************************************************************/

   define parameter buffer ad_mstr for ad_mstr.

   assign
      addr[1] = ad_name
      addr[2] = ad_line1 + ad_line2 + ad_line3
      addr[3] = ad_city
      addr[4] = ad_state
      addr[5] = ad_zip
      addr[6] = ad_country
      .
      vship_phone = ad_phone.
      vship_attn  = ad_attn.
    /*
   {mfcsz.i addr[5]
      ad_city
      ad_state
      ad_zip}

   {gprun.i ""gpaddr.p"" }  */

   assign
      shipto[1] = addr[1]
      shipto[2] = addr[2]
      shipto[3] = addr[3]
      shipto[4] = addr[4]
      shipto[5] = addr[5]
      shipto[6] = addr[6].

   /*
   /* FIND VAT REG NO & COUNTRY CODE */
   {povteprg.i}
   */
END PROCEDURE. /* PROCEDURE ip_header_populate */

PROCEDURE ip_header_print:
/*******************************************************************
 * Purpose    - PRINTS THE HEADER                                  *
 * Parameters - p_po_cmtindx - INTEGER                             *
 * Comments   - INTRODUCED BY N1PQ                                 *
 *******************************************************************/

   define input parameter p_po_cmtindx as integer no-undo.

   /*
   define frame dummy-1.
   */

   view frame phead1.
   page.

   /*
   {gpcmtprt.i &type=PO &id=p_po_cmtindx &pos=3}

   down 1 with frame dummy-1.
   */

END PROCEDURE. /* PROCEDURE ip_header_print */
