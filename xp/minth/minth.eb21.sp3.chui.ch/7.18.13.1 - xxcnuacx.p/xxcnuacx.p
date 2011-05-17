/* socnuac.p - Sales Order Consignment Usage AutoCreate                       */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.49.1.1 $                                                         */
/* Revision: 1.33      BY: Patrick Rowan          DATE: 04/04/02  ECO: *P00F* */
/* Revision: 1.37      BY: Dan Herman             DATE: 06/19/02  ECO: *P091* */
/* Revision: 1.38      BY: John Corda             DATE: 08/09/02  ECO: *N1QP* */
/* Revision: 1.42      BY: Paul Donnelly (SB)     DATE: 06/28/03  ECO: *Q00L* */
/* Revision: 1.43      BY: Ed van de Gevel        DATE: 12/24/03  ECO: *P0SV* */
/* Revision: 1.44      BY: Preeti Sattur          DATE: 02/20/04  ECO: *P1PZ* */
/* Revision: 1.45      BY: Preeti Sattur          DATE: 03/02/04  ECO: *P1N2* */
/* Revision: 1.46      BY: Laxmikant Bondre       DATE: 04/26/04  ECO: *P1TT* */
/* Revision: 1.47      BY: Robin McCarthy         DATE: 04/30/04  ECO: *P16X* */
/* Revision: 1.48      BY: Reena Ambavi           DATE: 06/23/04  ECO: *P27C* */
/* Revision: 1.49      BY: Vandna Rohira          DATE: 10/01/04  ECO: *P2ML* */
/* $Revision: 1.49.1.1 $  BY: Jignesh Rachh          DATE: 02/28/05  ECO: *P38N* */
/* $Revision: 1.49.1.1 $  BY: mage chen          DATE: 04/04/07  ECO: *minth* */

/*-Revision end---------------------------------------------------------------*/

/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */

/* MODIFICATIONS TO THIS PROGRAM MAY REQUIRE MODIFICATION TO socnuac3.p,      */
/* socnuac5.p and socnuac7.p                                                  */

/*V8:ConvertMode=Maintenance                                                  */





/*************************************************************����Ϊ�汾��ʷ */  
/*minth* 20070402 by Mage Chen  */
/* SS - 090401.1  By: Roger Xiao */

/*************************************************************����Ϊ����˵�� */

/* SS - 090401.1 - RNB
1.ԭ��ʽ����¼����ʱ��̫��,ԭ�����abs_mstrʱδ��domain,̫��, ���޸�xxsocncixx.p
xxcnuacx.p --> xxsocnuac2x.p --> xxsocnisx.p --> xxsocncixx.p
2.ȡ����������¼:ԭxxsocnisx.pֱ�ӵ���ictrans.i,�ָ�Ϊ: xxsocnisx.p  --> xxictransxp01.p --> xxictransxp01.i
  ��release ld_det & in_mstr 
  ע��: &slspsn3 &slspsn4 &trordrev ��xxictransxp01.i��ictrans.iʹ�÷�ʽ��ͬ

SS - 090401.1 - RNE */






/*SS - 090401.1 - B 
{mfdtitle.i "1+ "}

SS - 090401.1 - E */

/* SS - 090401.1 - B */
{mfdtitle.i "090401.1"}
/* SS - 090401.1 - E */


{cxcustom.i "SOCNUAC.P"}

/* VARIABLES */
{socnuac.i}
{pxsevcon.i}
{socnvars.i}
{gldydef.i new}
{gldynrm.i new}

define variable shipto            like cncix_shipto              no-undo.
define variable shipto_name       like ad_name                   no-undo.
define variable cust              like cncix_cust                no-undo.
define variable cust_name         like ad_name                   no-undo.
define variable shipfrom          like cncix_site                no-undo.
define variable shipfrom1         like cncix_site                no-undo.
define variable sopart            like cncix_custpart            no-undo.
define variable sopart1           like cncix_custpart            no-undo.
define variable po                like scx_po  label "PO Number" no-undo.
define variable po1               like scx_po                    no-undo.
{&SOCNUAC-P-TAG1}
define variable nbr               like cncix_so_nbr              no-undo.
define variable nbr1              like cncix_so_nbr              no-undo.
{&SOCNUAC-P-TAG2}
define variable part              like cncix_part label "Item"   no-undo.
define variable part1             like cncix_part                no-undo.
define variable sel_all           like mfc_logical               no-undo.
define variable usage_id          like cncu_batch                no-undo.
define variable cust_usage_ref    like cncu_cust_usage_ref
                                  label "Customer Usage Ref"     no-undo.
define variable cust_usage_date   like cncu_cust_usage_date
                                  label "Date"                   no-undo.
define variable sortby            like lngd_key2                 no-undo.
define variable sortby_num        like lngd_key1                 no-undo.
define variable sortby_label      like lngd_translation          no-undo.
define variable using_selfbilling as logical                     no-undo.
define variable selfbill_auth     like cncix_auth                no-undo
                                  label "Self-Bill Authorization".
define variable ctr               as integer                     no-undo.
define variable MANUAL            as character initial "01"      no-undo.
define variable lngd_recno        as recid                       no-undo.
define variable dummy_recno       as recid                       no-undo.
define variable continue-yn       as logical                     no-undo.
define variable lastkey_processed as logical                     no-undo.
define variable l_ar_open         as logical                     no-undo.
define variable tmp_global_ref    as character                   no-undo.
define variable l_effdate         like glt_effdate               no-undo.
/*minth*/  define new shared variable rtn               as  logical      initial   no  no-undo.

 /* SELECTION FORM */
 form
    shipto      colon 20
    shipto_name no-label
    cust        colon 20
    cust_name   no-label
    skip(1)
    shipfrom    colon 20
    shipfrom1   label "To" colon 47
    sopart      colon 20 view-as fill-in size 20 by 1
    sopart1     label "To" colon 47
                         view-as fill-in size 20 by 1
    po          colon 20
    po1         label "To" colon 47
    nbr         colon 20
    nbr1        label "To" colon 47
    part        colon 20
    part1       label "To" colon 47
    skip(1)
    l_effdate   label "Effective Date" colon 36
    sel_all     label "Consume All"    colon 36
    sortby      label "Sort By"        colon 36
    sortby_label    no-label            at 48
/*minth*/  rtn    label  "ί��Ӧ�ûس�"   colon 36     
 with frame a width 80 side-labels.

 /* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

 /* HEADER FORM */
 form
    shipto          colon 30
    shipto_name     no-label
    cust            colon 30
    cust_name       no-label
 with frame a1 width 80 side-labels.

 /* SET EXTERNAL LABELS */
setFrameLabels(frame a1:handle).

 /* CUSTOMER USAGE FORM */
 form
   cust_usage_ref  colon 30
   cust_usage_date colon 66
   selfbill_auth   colon 30
                   view-as fill-in size 20 by 1
 with frame aa width 80 side-labels
 title color normal (getFrameTitle("CUSTOMER_USAGE_DATA",78)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame aa:handle).

/* SAVE GLOBAL_REF */
tmp_global_ref = global_ref.

/* DETERMINE IF SELF-BILLING IS INSTALLED AND ACTIVE */
using_selfbilling =
   if can-find (first mfc_ctrl
      where mfc_domain = global_domain
      and   mfc_field  = "enable_self_bill"
      and   mfc_seq    = 2
      and   mfc_module = "ADG"
      and mfc_logical  = yes)
   then
      yes
   else
      no.

sortby_num = "3".


mainloop:
repeat with frame a:
   setFrameLabels(frame a:handle).

   if shipfrom1 = hi_char then shipfrom1 = "".
   if sopart1 = hi_char then sopart1 = "".
   if po1 = hi_char then po1 = "".
   if nbr1 = hi_char then nbr1 = "".
   if part1 = hi_char then part1 = "".

   /* Convert the numeric equivalent for sortby to mnemonic code */
   {gplngn2a.i &file  = ""consignment""
               &field = ""sortby""
               &code = "sortby_num"
               &mnemonic = sortby
               &label = sortby_label}

   display sortby sortby_label.

   update
      shipto
      cust
   with frame a.

   /* VALIDATION */
   if shipto  = ""
      and cust = ""
   then do:
      {pxmsg.i &MSGNUM=4922 &ERRORLEVEL=3}  /* MUST ENTER SHIP-TO OR SOLD-TO*/
      next-prompt shipto.
      undo mainloop, retry mainloop.
   end.

    /* DETERMINE SHIP-TO NAME */
   run getShipToName
      (input shipto,
       output shipto_name).
   display shipto_name.

   /* DETERMINE CUSTOMER NAME */
   run getShipToName
      (input cust,
       output cust_name).
   display cust_name.

   setloop:
   do on error undo, retry with frame a:

      if l_effdate = ?
      then
         l_effdate = today.

      update
         shipfrom  shipfrom1
         sopart    sopart1
         po        po1
         nbr       nbr1
         part      part1
         l_effdate
         sel_all
         sortby
/*minth*/ rtn 
      with frame a
      editing:

         lastkey_processed = no.

         if frame-field = "sortby" then do:
            {mfnp05.i lngd_det lngd_trans
             "     lngd_dataset = 'consignment'
               and lngd_field   = 'sortby'
               and lngd_lang    = global_user_lang"
               lngd_key2 "input sortby"}

            lastkey_processed = yes.

            if recno <> ? then
               display lngd_key2 @ sortby
                       lngd_translation @ sortby_label
               with frame a.
         end.

         if not lastkey_processed then do:
            status input.
            readkey.
            apply lastkey.
         end.

      end. /* update shipfrom ... editing */

      if l_effdate = ? then
         l_effdate = today.

      /* DETERMINE SORT OPTION */
      run getLanguageDetail
         (input sortby,
          output sortby_num,
          output lngd_recno).

      if lngd_recno = ? then do:
         next-prompt sortby.
         undo setloop, retry setloop.
      end.
   end.  /* setloop */

   if shipfrom1 = "" then shipfrom1 = hi_char.
   if sopart1 = "" then sopart1 = hi_char.
   if po1 = "" then po1 = hi_char.
   if nbr1 = "" then nbr1 = hi_char.
   if part1 = "" then part1 = hi_char.
   ctr = 0.

   /* HOUSEKEEPING - DELETE WORK TABLES */
   for each bAutoCreate
   exclusive-lock:
      delete bAutoCreate.
   end.

   /* DELETE SERIAL NUMBER WORK FILES */
   for each sr_wkfl
      where sr_domain = global_domain
      and   sr_userid = mfguser
   exclusive-lock:
      delete sr_wkfl.
   end.

    /* DELETE LOT WORK FILES */
   {gprun.i ""gplotwdl.p""}

    /* LOAD TEMPORARY TABLE */
   run loadAutoCreateTable
      (input shipto,
       input cust,
       input shipfrom,
       input shipfrom1,
       input sopart,
       input sopart1,
       input po,
       input po1,
       input nbr,
       input nbr1,
       input part,
       input part1,
       output ctr,
       buffer bAutoCreate).

   /* # RECORDS FOUND MATCHING SELECTION CRITERIA */
   {pxmsg.i &MSGNUM=1615 &ERRORLEVEL="(if ctr = 0 then 3 else 1)"
            &MSGARG1=string(ctr)}

   if ctr = 0 then
      undo mainloop, retry mainloop.

   assign
      global_ref = ""
      cust_usage_ref  = ""
      cust_usage_date = today
      selfbill_auth   = "".

   update
      cust_usage_ref
      cust_usage_date
      selfbill_auth   when (using_selfbilling)
   with frame aa.

   if cust_usage_date = ? then
      cust_usage_date = today.

    /* UPDATE TEMPORARY TABLE */
   run updateAutoCreateTable
      (input cust_usage_ref,
       input cust_usage_date,
       input selfbill_auth,
       buffer bAutoCreate).

   hide frame a.
   hide frame aa.

   display
      shipto
      shipto_name
      cust
      cust_name
   with frame a1.

    /* MULTILINE BROWSE FOR SELECTION OF RECORDS */
   {gprun.i ""socnuac1.p""
            "(input-output table tt_autocr,
              input sortby_num,
              input sel_all,
              input using_selfbilling,
              output continue-yn)"}.

   hide frame a1.
   view frame a.

   if continue-yn = no then
      undo mainloop, retry mainloop.
/*minth  add ��֤�������ݱ��������Ƿ�һ��*************
           for each tt_autocr no-lock where   tt_autocr.ac_tot_qty_consumed <> 0:
	   display tt_autocr.
	   end.

	       for each sr_wkfl
               where sr_domain = global_domain
               and   sr_userid = mfguser
               no-lock: 
	       display sr_wkfl.
	    end.

            

*minth  add ��֤�������ݱ��������Ƿ�һ��**************/

   /* PROCESS TEMPORARY TABLE */
/*minth*/    {gprun.i ""xxsocnuac2x.p""
            "(input-output table tt_autocr,
              input using_selfbilling,
              input MANUAL,
              input l_effdate,
              output usage_id,
              output continue-yn)"}.
/* message "xxcncuacx.p  call xxsocnuac2x.p"      view-as alert-box.  */ 
   if continue-yn = no then
      undo mainloop, retry mainloop.

   /* SAVE USAGE ID FOR OTHER PROGRAMS TO USE */
   {gprun.i ""rqidf.p""
            "(input 'put',
              input 'usageID',
              input-output usage_id)"}

   {pxmsg.i &MSGNUM=1107 &ERRORLEVEL=1}   /* PROCESS COMPLETE  */

   if global_ref = "" then do:
      /* BATCH CREATED:  */
      {pxmsg.i &MSGNUM=4924 &ERRORLEVEL=1 &MSGARG1=string(usage_id)}
   end.
   else do:
      /* BATCH CREATED: #,  INVOICE CREATED: # */
      {pxmsg.i &MSGNUM=5237 &ERRORLEVEL=1
               &MSGARG1=string(usage_id)
               &MSGARG2=global_ref}
   message "����������ִ�����!!"  view-as alert-box.

   end.
/*minth add ɾ������Ϊ��cncix_mstr   ***********************/

for each cncix_mstr
         where cncix_domain    = global_domain
         and ((cncix_shipto    = shipto
         or    shipto       = "")
         and  (cncix_cust      = cust       
         or    cust         = "")		
         and   cncix_site     >= shipfrom	
         and   cncix_site     <= shipfrom1	
         and   cncix_custpart >= sopart	    
         and   cncix_custpart <= sopart1	
         and   cncix_po       >= po		    
         and   cncix_po       <= po1		    
         and   cncix_so_nbr   >= nbr		    
         and   cncix_so_nbr   <= nbr1	       
         and   cncix_part     >= part	       
         and   cncix_part     <= part1	       
         and   cncix_auth      = ""
         and   cncix_cust_seq  = "")
	 and   cncix_qty_stock = 0
          break by cncix_site
               by cncix_shipto
               by cncix_so_nbr
               by cncix_sod_line
               by cncix_current_loc:
          if not last-of(cncix_current_loc) then do:

	     delete cncix_mstr .

	  end.
         

      end. /* for each cncix_ref */


/*minth add ɾ������Ϊ��cncix_mstr   ***********************/

end. /* mainloop */

/* CLEAN UP - DELETE WORK TABLES */
for each bAutoCreate
exclusive-lock:
   delete bAutoCreate.
end.

/* DELETE SERIAL NUMBER WORK FILES */
for each sr_wkfl
   where sr_domain = global_domain
   and   sr_userid = mfguser
exclusive-lock:
   delete sr_wkfl.
end.

/* DELETE LOT WORK FILES */
{gprun.i ""gplotwdl.p""}

/* RE-SET GLOABL_REF */
global_ref = tmp_global_ref.


/* ========================================================================== */
/* ************************* INTERNAL PROCEDURES **************************** */
/* ========================================================================== */

/* ========================================================================= */
PROCEDURE getShipToName:
/* --------------------------------------------------------------------------
 * Purpose:      This procedure gets the ship-to name.
 * -------------------------------------------------------------------------- */

   define input  parameter p_shipto           as character no-undo.
   define output parameter p_shipto_name      as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      p_shipto_name = "".

      for first ad_mstr
         fields (ad_domain ad_sort)
         where   ad_domain = global_domain
         and    (ad_addr = p_shipto
         and    (ad_type = "ship-to" or ad_type = "customer") )
      no-lock:
         p_shipto_name = ad_sort.
      end.

   end. /*Do on error undo..*/

   return {&SUCCESS-RESULT}.

END PROCEDURE. /*getShipToName*/

/* ========================================================================= */
PROCEDURE getPartDescription:
/* --------------------------------------------------------------------------
 * Purpose:      This procedure gets the part description field.
 * -------------------------------------------------------------------------- */

   define input  parameter p_part             as character no-undo.
   define output parameter p_part_desc        as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      p_part_desc = "".

      for first pt_mstr
         fields (pt_domain pt_desc1)
         where   pt_domain = global_domain
         and     pt_part = p_part
      no-lock:
         p_part_desc = pt_desc1.
      end.

   end. /*Do on error undo..*/

   return {&SUCCESS-RESULT}.

END PROCEDURE. /*getPartDescription*/

/* ========================================================================== */
PROCEDURE getLanguageDetail:
/* --------------------------------------------------------------------------
 * Purpose:      Get language detail for the string entered by user.
 * -------------------------------------------------------------------------- */

   define input parameter  sortby as character no-undo.
   define output parameter op_key1 as character no-undo.
   define output parameter op_recno as recid no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      op_recno = ?.
      if global_lngd_raw then
         for first lngd_det where
            lngd_dataset = "consignment" and
            lngd_key1    begins sortby   and
            lngd_key2    <> ""           and
            lngd_key3    =  ""           and
            lngd_key4    =  ""           and
            lngd_field   = "sortby"      and
            lngd_lang    = global_user_lang
            no-lock: end.
      else
         for first lngd_det where
            lngd_dataset = "consignment" and
            lngd_key1    <> ""           and
            lngd_key2    begins sortby   and
            lngd_key3    =  ""           and
            lngd_key4    =  ""           and
            lngd_field   = "sortby"      and
            lngd_lang    = global_user_lang
         no-lock: end.

      if not available lngd_det then do:
         {pxmsg.i &MSGNUM=712 &ERRORLEVEL=3} /* INVALID OPTION */
      end.
      else
         assign
            op_key1 = lngd_key1
            op_recno = recid(lngd_det).

   end. /*Do on error undo..*/

   return {&SUCCESS-RESULT}.

END PROCEDURE. /*getLanguageDetail*/

/* ========================================================================== */
PROCEDURE loadAutoCreateTable:
/* --------------------------------------------------------------------------
 * Purpose:    Read the shipment cross-reference table based on the selection
 *             criteria and fill the temp table buffer.
 * -------------------------------------------------------------------------- */

   define input parameter  ip_shipto as character no-undo.
   define input parameter  ip_cust as character no-undo.
   define input parameter  ip_shipfrom as character no-undo.
   define input parameter  ip_shipfrom1 as character no-undo.
   define input parameter  ip_sopart as character no-undo.
   define input parameter  ip_sopart1 as character no-undo.
   define input parameter  ip_po as character no-undo.
   define input parameter  ip_po1 as character no-undo.
   define input parameter  ip_nbr as character no-undo.
   define input parameter  ip_nbr1 as character no-undo.
   define input parameter  ip_part as character no-undo.
   define input parameter  ip_part1 as character no-undo.
   define output parameter op_cntr as integer no-undo.
   define parameter buffer bAutoCreate for tt_autocr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* INITIALIZE op_cntr OUTSIDE LOOP FOR cncix_mstr SO THAT CORRECT */
      /* RECORD COUNT IS DISPLAYED IN THE MESSAGE                       */
      op_cntr = 0.

      /* ADDED VALIDATION TO EXCLUDE SCHEDULED ORDERS WITH       */
      /* AUTHORIZATION NUMBERS AND PRO/PLUS SEQUENCED SCHEDULES. */
      for each cncix_mstr
         where cncix_domain    = global_domain
         and ((cncix_shipto    = ip_shipto
         or    ip_shipto       = "")
         and  (cncix_cust      = ip_cust
         or    ip_cust         = "")
         and   cncix_site     >= ip_shipfrom
         and   cncix_site     <= ip_shipfrom1
         and   cncix_custpart >= ip_sopart
         and   cncix_custpart <= ip_sopart1
         and   cncix_po       >= ip_po
         and   cncix_po       <= ip_po1
         and   cncix_so_nbr   >= ip_nbr
         and   cncix_so_nbr   <= ip_nbr1
         and   cncix_part     >= ip_part
         and   cncix_part     <= ip_part1
         and   cncix_auth      = ""
         and   cncix_cust_seq  = "")
      no-lock
         break by cncix_site
               by cncix_shipto
               by cncix_so_nbr
               by cncix_sod_line
               by cncix_current_loc:
         if cncix_lotser <> ""
            or cncix_ref <> ""
         then do:
            /* FIND sr_wkfl */
            for first sr_wkfl
               where sr_domain = global_domain
               and   sr_userid = mfguser
               and   sr_lineid = string(op_cntr)
               and   sr_site   = cncix_site
               and   sr_loc    = cncix_current_loc
               and   sr_lotser = cncix_lotser
               and   sr_ref    = cncix_ref
            exclusive-lock: end.

            if available (sr_wkfl) then
               sr_qty = if sel_all then sr_qty + cncix_qty_stock else 0.
            else do:
               /* CREATE sr_wkfl */
               create sr_wkfl.
               assign
                  sr_domain = global_domain
                  sr_userid = mfguser
                  sr_lineid = string(op_cntr)
                  sr_site   = cncix_site
                  sr_loc    = cncix_current_loc
                  sr_lotser = cncix_lotser
                  sr_ref    = cncix_ref
                  sr_qty    = if sel_all then cncix_qty_stock else 0.

               /*ORACLE STD */
               if recid(sr_wkfl) = -1 then .

            end.  /* else do */

         end.  /* if cncix_lotser <> "" or cncix_ref <> "" */

         accumulate cncix_qty_stock (total by cncix_current_loc).

 /*minth*        if last-of(cncix_current_loc)
            and (accum total by cncix_current_loc cncix_qty_stock) <> 0
         then do:  **/
 /*minth*/        if last-of(cncix_current_loc)
            and ((accum total by cncix_current_loc cncix_qty_stock) <> 0 
	          or (accum total by cncix_current_loc cncix_qty_stock) = 0 and rtn )
         then do: 
            create bAutoCreate.
            assign
               bAutoCreate.ac_cncixrecid    = recid(cncix_mstr)
               bAutoCreate.ac_sopart        = cncix_custpart
               bAutoCreate.ac_part          = cncix_part
               bAutoCreate.ac_loc           = cncix_current_loc
               bAutoCreate.ac_po            = cncix_po
               bAutoCreate.ac_order         = cncix_so_nbr
               bAutoCreate.ac_line          = cncix_sod_line
               bAutoCreate.ac_site          = cncix_site
               bAutoCreate.ac_ship          = cncix_shipto
               bAutoCreate.ac_cust          = cncix_cust
               bAutoCreate.ac_selfbill      = cncix_selfbill
               bAutoCreate.ac_stock_um      = cncix_stock_um
               bAutoCreate.ac_consumed_um   = cncix_stock_um
               bAutoCreate.ac_consumed_um_conv   = 1
               bAutoCreate.ac_tot_qty_oh    =
                     (accum total by cncix_current_loc cncix_qty_stock)
               bAutoCreate.ac_tot_qty_consumed  =
                     if sel_all
                        then (accum total by cncix_current_loc cncix_qty_stock)
                        else 0
               bAutoCreate.ac_count         = op_cntr
               bAutoCreate.ac_eff_date      = l_effdate.

            /* DETERMINE SORT FIELDS */
            case sortby_num:
               when "1" then
                  assign
                     bAutoCreate.ac_sortfld1 = cncix_po
                     bAutoCreate.ac_sortfld2 = cncix_custpart.
               when "2" then
                  assign
                     bAutoCreate.ac_sortfld1 = cncix_custpart
                     bAutoCreate.ac_sortfld2 = cncix_po.
               when "3" then
                  assign
                     bAutoCreate.ac_sortfld1 = cncix_so_nbr
                     bAutoCreate.ac_sortfld2 = cncix_part.
               when "4" then
                  assign
                     bAutoCreate.ac_sortfld1 = cncix_part
                     bAutoCreate.ac_sortfld2 = cncix_so_nbr.
            end case. /* sortby */

            /*ORACLE STD */
            if recid(tt_autocr) = -1 then .

            op_cntr = op_cntr + 1.

         end.  /* if last-of(cncix_current_loc) */
         else
            if last-of(cncix_current_loc)
               and (accum total by cncix_current_loc cncix_qty_stock) = 0
            then do:

               for each sr_wkfl
                  where sr_domain = global_domain
                  and   sr_userid = mfguser
                  and   sr_lineid = string(op_cntr)
               exclusive-lock:

                  delete sr_wkfl.

               end. /* FOR EACH sr_wkfl */

            end. /* ELSE IF LAST-OF(cncix_current_loc) */

      end. /* for each cncix_ref */

   end. /*Do on error undo..*/

   return {&SUCCESS-RESULT}.

END PROCEDURE. /*loadAutoCreateTable*/

/* ========================================================================== */
PROCEDURE updateAutoCreateTable:
/* --------------------------------------------------------------------------
 * Purpose:      Read the temp-table buffer and update each record with the
 *               customer usage ID and self-bill payment authorization.
 * -------------------------------------------------------------------------- */

   define input parameter  ip_cust_usage_ref as character no-undo.
   define input parameter  ip_cust_usage_date as date no-undo.
   define input parameter  ip_selfbill_auth as character no-undo.
   define parameter buffer bAutoCreate for tt_autocr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* READ THE AUTOCREATE TEMP-TABLE BUFFER */
      for each bAutoCreate
      exclusive-lock:
         assign
            bAutoCreate.ac_cust_usage_ref = ip_cust_usage_ref
            bAutoCreate.ac_cust_usage_date = ip_cust_usage_date
            bAutoCreate.ac_selfbill_auth = ip_selfbill_auth.
      end.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE. /*updateAutoCreateTable*/