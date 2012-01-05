/* xxsoisd1112.p - cp from sosoisd.p SALES ORDER SHIPMENT SELECT LINE QUANITIES TO SHIP  */

/******************************************************************/
/*                                                                */
/*    Any for-each loops which go through every sod_det for a     */
/*    so_nbr (i.e. for each sod_det where sod_nbr = so_nbr )      */
/*    should have the following statments first in the loop.      */
/*                                                                */
/*       if (sorec = fsrmarec    and sod_fsm_type  <> "RMA-RCT")  */
/*       or (sorec = fsrmaship   and sod_fsm_type  <> "RMA-ISS")  */
/*       or (sorec = fssormaship and sod_fsm_type  =  "RMA-RCT")  */
/*       or (sorec = fssoship    and sod_fsm_type  <> "")         */
/*       then next.                                               */
/*                                                                */
/*    this is to prevent rma receipt line from being processed    */
/*    when issue lines are processed (sas).                       */
/*                                                                */
/******************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{cxcustom.i "SOSOISD.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{socnis.i}     /* CUSTOMER CONSIGNMENT SHIPMENT TEMP-TABLE DEFINITION */

define temp-table tt_sod_det no-undo
   field tt_sod_nbr  like sod_nbr
   field tt_sod_line like sod_line
   field tt_pr_found as logical
   index i_sodnbr tt_sod_nbr.

define input-output parameter table for tt_consign_shipment_detail.
define output       parameter table for tt_sod_det.

define new shared variable sod_recno as recid.
define new shared variable so_recno as recid.
define new shared variable picking_logic  as logical label "Use Pick Logic".

/* DEFINE SHARED VARIABLE RNDMTHD FOR GPFRLWT.P */
define shared variable rndmthd like rnd_rnd_mthd.
define shared variable issue_or_receipt as character.
define shared variable total_lotserial_qty like sod_qty_chg.
define shared variable multi_entry like mfc_logical label "Multi Entry".
define shared variable site like sr_site no-undo.
define shared variable location like sr_loc no-undo.
define shared variable loc like pt_loc.
define shared variable lotserial like sr_lotser no-undo.
define shared variable lotserial_qty like sr_qty no-undo.
define shared variable trans_um like pt_um.
define shared variable trans_conv like sod_um_conv.
define shared variable transtype as character initial "ISS-SO".
define shared variable change_db like mfc_logical.
define shared variable ship_site like sod_site.
define shared variable ship_db like dc_name.
define shared variable ship_so like so_nbr.
define shared variable ship_line like sod_line.
define shared variable lotref like sr_ref format "x(8)" no-undo.
define shared variable lotserial_control as character.
define shared variable eff_date like glt_effdate label "Effective".
define shared variable undo-all like mfc_logical no-undo.
define shared variable so_mstr_recid as recid.
define shared variable so_db like dc_name.
define shared variable cline as character.
define shared variable undo-select like mfc_logical no-undo.
define shared variable freight_ok like mfc_logical.
define shared variable calc_fr like mfc_logical.
define shared variable disp_fr like mfc_logical.
define shared variable exch_rate like exr_rate.
define shared variable exch_rate2 like exr_rate2.
define shared variable exch_ratetype like exr_ratetype.
define shared variable exch_exru_seq like exru_seq.

define variable line          like sod_line format ">>>" no-undo.
define variable yn            like mfc_logical no-undo.
define variable i             as integer no-undo.
define variable cancel_bo     like mfc_logical label "Cancel B/O" no-undo.
define variable mod_iss       like mfc_logical label "Issue Components" no-undo.
define variable err-flag        as integer no-undo.
define variable msgnbr          as integer no-undo.
define variable sav_global_type like cmt_type no-undo.
define variable detqty          like sod_qty_ord no-undo.
define variable original_db     like ship_db no-undo.
define variable new_db          like ship_db no-undo.
define variable lotnext         like wo_lot_next no-undo.
define variable lotprcpt        like wo_lot_rcpt no-undo.
define variable linked-line     like sod_line no-undo.
define variable done_entry      like mfc_logical no-undo.
define variable overissue_ok    like mfc_logical no-undo.
define variable lineid_list     as character no-undo.
define variable fr_title        as character no-undo.
define variable fac_bflush_comp as logical label "Automatic Backflush" no-undo.
define variable line_to_preissue   as logical no-undo.
define variable l_disc_pct1        as decimal no-undo.
define variable l_net_price        as decimal no-undo.
define variable l_list_price       as decimal no-undo.
define variable l_rec_no           as recid   no-undo.
define variable prev_lotserial_qty like sod_qty_chg no-undo.
define variable connect_db         like dc_name no-undo.
define variable db_undo            like mfc_logical no-undo.
define variable l_overship         as logical no-undo.
define variable l_remove_srwkfl    like mfc_logical no-undo.
define variable mc-error-number    like msg_nbr no-undo.
define variable disp_ord           as decimal no-undo.
define variable disp_ship          as decimal no-undo.
define variable ret-flag           as integer no-undo.
define variable l_sonbr            like sod_nbr no-undo.
define variable l_ship_one_line    like mfc_logical no-undo.
define variable l_sod_bo_chg       like sod_bo_chg  no-undo.
define variable l_sod_fr_chg       like sod_fr_chg  no-undo.
define variable l_wo_reject        like mfc_logical no-undo.
define variable l_rej              like mfc_logical initial no no-undo.
define variable key1               as character     no-undo.
define variable ok_to_ship         as logical       no-undo.

/* DEFINE VARIABLES USED IN GPGLEF1.P (GL CALENDAR VALIDATION) */
{gpglefv.i}

{socnvars.i}   /* CONSIGNMENT VARIABLES. */
/* COMMON API CONSTANTS AND VARIABLES */
{mfaimfg.i}

/* ASN API TEMP-TABLE */
{soshxt01.i}

define buffer soddet for sod_det.

define new shared temp-table work_ldd                    no-undo
   field work_ldd_id  like abs_id
   index work_ldd_id  work_ldd_id.

/* DEFINING A SHARED TEMP-TABLE TO COMPUTE THE QUANTITY IN rcinvchk.p */
/* TO CHECK AGAINST THE INVENTORY AVAILABLE FOR THAT ITEM  */
define new shared temp-table compute_ldd               no-undo
   field compute_site   like abs_site
   field compute_loc    like abs_loc
   field compute_lot    like abs_lotser
   field compute_item   like abs_item
   field compute_ref    like abs_ref
   field compute_qty    like abs_qty
   field compute_lineid like abs_id
   index compute_index compute_site compute_item
         compute_loc   compute_lot  compute_ref.

define temp-table tt_bo no-undo
   field tt_sod_line  like sod_line
   field tt_cancel_bo like mfc_logical
   index ttline is primary
      tt_sod_line.

empty temp-table compute_ldd no-error.

for each tt_bo exclusive-lock:
   delete tt_bo.
end. /* FOR EACH tt_cancel_bo */

assign issue_or_receipt = getTermLabel("ISSUE",8).
{sosois1.i}

for first mfc_ctrl
   fields (mfc_domain mfc_field mfc_logical)
   where   mfc_domain = global_domain
   and     mfc_field = "fac_bflush_comp"
no-lock: end.

if available mfc_ctrl then
   fac_bflush_comp = mfc_logical.
else
   fac_bflush_comp = false.

l_ship_one_line = no.

/* FINDING mfc_ctrl RECORD IN WAREHOUSE CONTROL FILE */
for first mfc_ctrl
   fields (mfc_domain mfc_field mfc_logical)
    where  mfc_domain = global_domain
    and    mfc_field = "wi_ship_oneline"
no-lock:
   l_ship_one_line = mfc_logical.
end. /* FOR FIRST mfc_ctrl */

picking_logic = true.

form
   fac_bflush_comp    colon 40 skip
   picking_logic      colon 40
with frame ship_comps width 80 side-labels
title color normal (getFrameTitle("CONFIRM_CONFIGURED_ITEM_BACKFLUSH",60)).

if c-application-mode <> "API" then
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame ship_comps:handle).

if c-application-mode = "API" then do:

   /*
   * GET HANDLE OF API CONTROLLER
   */
   {gprun.i ""gpaigh.p""
      "( output apiMethodHandle,
         output apiProgramName,
         output apiMethodName,
         output apiContextString)"}

   run getSoShipHdrRecord in apiMethodHandle
      (buffer ttSoShipHdr).

   /* GET SO SHIPMENT DETAIL TEMP-TABLE */
   run getSoShipDet in apiMethodHandle
      (output table ttSoShipDet).

   /* GET SO SHIPMENT LOT SERIAL TEMP-TABLE */
   run getSoShipLotSerial in apiMethodHandle
      (output table ttSoShipLotSerial).

end. /* IF c-application-mode = "API" */

/* CHECK TO SEE IF CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_CUSTOMER_CONSIGNMENT,
           input 10,
           input ADG,
           input CUST_CONSIGN_CTRL_TABLE,
           output using_cust_consignment)"}

for first so_mstr
   fields (so_domain so_bill so_curr so_cust so_ex_rate so_ex_rate2
           so_fr_list so_fr_min_wt so_fr_terms so_fsm_type
           so_nbr so_ship so_taxc)
   where recid(so_mstr) = so_mstr_recid
no-lock: end.

{&SOSOISD-P-TAG1}

/* SET FRAME TITLE TO CLEARLY INDICATE WHAT'S BEING SHIPPED */
if sorec = fsseoship then
   fr_title = getFrameTitle("MATERIAL_ORDER_LINE_ITEMS",35).
else if sorec = fsktship then
   fr_title = getFrameTitle("KIT_ASSEMBLY_LINE_ITEMS",35).
else
   fr_title = getFrameTitle("SALES_ORDER_LINE_ITEMS",35).

if change_db then do:
   {gprun.i ""gpalias3.p"" "(input ship_db, output err-flag)"}

   assign
      connect_db = ship_db
      db_undo = no.

   run check-db-connect
      (input connect_db, input-output db_undo).

   if db_undo then undo, return.

   /* RETRIEVE BACKFLUSH FLAG FROM REMOTE DOMAIN IF NECESSARY */
   {gprun.i ""sobflush.p"" "(output fac_bflush_comp)"}

   {gprun.i ""gpalias3.p"" "(input so_db, output err-flag)"}

   assign
      connect_db = so_db
      db_undo = no.

   run check-db-connect
      (input connect_db, input-output db_undo).

   if db_undo then undo, return.

end.

line_to_preissue = false.

if (can-find (first sob_det
              where sob_domain = global_domain
              and  (sob_nbr  = so_nbr
              and   sob_site = ship_site))
              or  ship_site = "")
then do:

   for each sod_det
      fields (sod_domain sod_bo_chg sod_cfg_type sod_confirm sod_cum_qty
              sod_desc sod_enduser sod_fa_nbr sod_fr_chg sod_fr_class
              sod_fr_list sod_fr_wt sod_fr_wt_um sod_fsm_type sod_line
              sod_list_pr sod_loc sod_lot sod_nbr sod_part sod_price
              sod_pr_list sod_qty_all sod_qty_chg sod_qty_ord sod_qty_pick
              sod_qty_ship sod_ref sod_rma_type sod_sched sod_sch_data
              sod_serial sod_site sod_std_cost sod_taxable sod_tax_env
              sod_tax_in sod_tax_usage sod_type sod_um sod_um_conv sod_upd_isb)
      where   sod_domain = global_domain
      and     sod_nbr = so_nbr
   no-lock:

      if sod_fa_nbr = ""
         and  sod_cfg_type <> "1"           /* Not "1" Assemble-to-Order */
         and (can-find (first sob_det
                        where sob_domain = global_domain
                        and  (sob_nbr = so_nbr
                        and   sob_line = sod_line
                        and   sob_site = ship_site))
                        or    ship_site = "")
      then do:
         /* There is at least one line we can do an automatic     */
         /* Backflush for.  That's all we wanted to know.         */
         line_to_preissue = true.
         leave.
      end.

   end.    /* for each sod_det */

end.   /* if can-find (first sob_det...) */

{&SOSOISD-P-TAG9}

if fac_bflush_comp and line_to_preissue then do:
   if c-application-mode <> "API" then
      update
         fac_bflush_comp
         picking_logic
      with frame ship_comps.
   else
      assign
         {mfaiset.i
            fac_bflush_comp ttSoShipHdr.ed_auto_backflush}
         {mfaiset.i
            picking_logic ttSoShipHdr.ed_pick_logic}.

end. /* IF FAC_BFLUSH_COMP AND LINE_TO_PREISSUE THEN */

if c-application-mode <> "API" then
   hide frame ship_comps no-pause.
{&SOSOISD-P-TAG10}

/* LINE ITEM DISPLAY FORM */
{&SOSOISD-P-TAG13}
form
with frame b title color normal fr_title
(if sorec = fsseoship or sorec = fsktship then 5 else 6) down width 80.
{&SOSOISD-P-TAG14}

if c-application-mode <> "API" then
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame b:handle).

/* RMA LINE ITEM DISPLAY FORM */
{&SOSOISD-P-TAG15}
form
   sod_line
   sod_part
   sod_type
   disp_ord    format "->>>>>>9.9<<<<<<" label "Expected"
   sod_qty_chg format "->>>>>>9.9<<<<<<" label "To Receive"
   disp_ship   format "->>>>>>9.9<<<<<<" label "Received"
   sod_site
with frame f title color normal (getFrameTitle("RETURNED_LINE_ITEMS",28))
6 down width 80.
{&SOSOISD-P-TAG16}

if c-application-mode <> "API" then
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame f:handle).

sod_qty_chg:label in frame f = getTermLabel("TO_RECEIVE",10).

/* LINE ITEM ENTRY FORM */
form
   line           colon 13
   cancel_bo
   site           colon 53
   location       colon 67  label "Loc"
   lotserial_qty  colon 13
   lotserial      colon 53
   sod_part       colon 13
   sod_um
   lotref         colon 53
   sod_desc       colon 13
   multi_entry    colon 53
with frame c side-labels attr-space width 80.

if c-application-mode <> "API" then
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame c:handle).

assign
   lotnext = ""
   lotprcpt = no
   line = 1.

loop0:
repeat transaction:

   if c-application-mode = "API" and retry
      then return error return-value.

   if fac_bflush_comp and line_to_preissue
   then do:
      if change_db then do:
         {gprun.i ""gpalias3.p"" "(input ship_db, output err-flag)"}

         assign
            connect_db = ship_db
            db_undo = no.

         run check-db-connect
            (input connect_db, input-output db_undo).

         if db_undo then do:
            if c-application-mode <> "API" then do:
               hide frame b.
               hide frame f.
               hide frame c.
            end. /* IF C-APPLICATION-MODE <> "API" THEN */
            undo loop0, leave loop0.
         end.
      end.
      else
         so_recno = recid(so_mstr).

      {gprun.i ""soise05.p"" "(input so_nbr)"}

      if change_db then do:
         {gprun.i ""gpalias3.p"" "(input so_db, output err-flag)"}

         assign
            connect_db = so_db
            db_undo = no.

         run check-db-connect
            (input connect_db, input-output db_undo).

         if db_undo then do:
            if c-application-mode <> "API" then do:
               hide frame b.
               hide frame f.
               hide frame c.
            end. /* IF C-APPLICATION-MODE <> "API" THEN */
            undo loop0, leave loop0.
         end.
      end.
   end.

   /* DISPLAY DETAIL */
   repeat:

      if c-application-mode = "API" and retry
         then return error return-value.

      if c-application-mode = "API" then do:

         find next ttSoShipDet no-lock no-error.
         if not available ttSoShipDet then leave.
      end.

      if c-application-mode <> "API" then do:
         clear frame b all no-pause.
         clear frame c no-pause.
         clear frame f all no-pause.

         if sorec = fsrmarec then
            view frame f.
         else
            view frame b.

         view frame c.
      end. /* IF C-APPLICATION-MODE <> "API" THEN */

      if not can-find(first sod_det
         where sod_domain = global_domain
         and   sod_nbr = so_nbr)
      then do:
         {pxmsg.i &MSGNUM=611 &ERRORLEVEL=2}  /* Order has no line items */
         if batchrun
         then
            undo loop0, leave loop0.
         else
            leave.
      end.

      /* Display order detail */
      /* FACILITATES ONE LINE SHIPMENT DURING CIM PROCESS */
      if execname = "sosois.p"
         and batchrun
         and l_ship_one_line
      then do:
         for first sod_det
            fields (sod_domain sod_bo_chg sod_cfg_type sod_confirm sod_cum_qty
                    sod_desc sod_enduser sod_fa_nbr sod_fr_chg
                    sod_fr_class sod_fr_list sod_fr_wt sod_fr_wt_um
                    sod_fsm_type sod_line sod_list_pr sod_loc sod_lot
                    sod_nbr sod_part sod_price sod_pr_list sod_qty_all
                    sod_qty_chg sod_qty_ord sod_qty_pick sod_qty_ship
                    sod_ref sod_rma_type sod_sched sod_sch_data sod_serial
                    sod_site sod_std_cost sod_taxable sod_tax_env sod_tax_in
                    sod_tax_usage sod_type sod_um sod_um_conv sod_upd_isb)
            where   sod_domain = global_domain
            and    (sod_nbr  = so_nbr
            and     sod_line = line
            and    (sod_site = ship_site or ship_site = "") )
         no-lock: end.
      end. /* IF execname = "sosois.p" ... */
      else do:
         for each sod_det no-lock
            where sod_domain = global_domain
            and  (sod_nbr = so_nbr
            and   sod_line >= line
            and  (sod_site = ship_site
            or    ship_site = "") )
         by sod_line:

            /* Consider skipping this record based on something */
            if (sorec = fsrmarec and sod_rma_type  <> "I")
               or (sorec = fsrmaship and sod_rma_type  <> "O")
               or (sorec = fssormaship and sod_rma_type  =  "I")
               or (sorec = fssoship    and sod_fsm_type  <> "")
            then next.

            /* Use different display if receiving against an RMA */
            if  sorec = fsrmarec then do:

               assign
                  disp_ord  = sod_qty_ord * -1.0
                  disp_ship = sod_qty_ship * -1.0.

               if c-application-mode <> "API" then do:

                  display
                     sod_line
                     sod_part
                     sod_type
                     disp_ord     format "->>>>>>9.9<<<<<<" label "Expected"
                     sod_qty_chg  format "->>>>>>9.9<<<<<<" label "To Receive"
                     disp_ship    format "->>>>>>9.9<<<<<<" label "Received"
                     sod_site
                  with frame f.

                  if frame-line(f) = frame-down(f) then leave.
                  down 1 with frame f.
               end. /* IF C-APPLICATION-MODE <> "API" THEN */

            end. /* if fsrmarec */

            else do:

               for first tt_bo where tt_bo.tt_sod_line = sod_line
               no-lock: end.

               if not available tt_bo
               then do:
                  create tt_bo.
                  assign
                     tt_bo.tt_sod_line  = sod_line
                     tt_bo.tt_cancel_bo = cancel_bo.
               end. /* IF NOT AVAILABLE tt_bo */

               /* THE BACKORDER QUANTITY SHOULD BE DISPLAYED AS ZERO */
               /* FOR OVERISSUES WHEN CANCEL B/O IS YES              */
               if  tt_bo.tt_cancel_bo and sod_bo_chg < 0
               then
                  l_sod_bo_chg = 0.
               else
                  l_sod_bo_chg = sod_bo_chg.

               if c-application-mode <> "API" then do:
                  display
                     sod_line
                     sod_part
                     sod_type
                     sod_qty_all   format "->>>>>>9.9<<<<<<" label "Allocated"
                     sod_qty_pick  format "->>>>>>9.9<<<<<<" label "Picked"
                     sod_qty_chg   format "->>>>>>9.9<<<<<<" label "To Ship"
                     l_sod_bo_chg  format "->>>>>>9.9<<<<<<" label "Backorder"
                     sod_site
                  with frame b.

                  if frame-line(b) = frame-down(b) then leave.
                  down 1 with frame b.
               end. /* IF-C-APPLICATION-MODE <> "API" THEN */

            end. /* if not fsrmarec */

         end.  /* Display order detail */

      end. /* ELSE DO */

      line = 0.

      do on error undo, retry:

         if c-application-mode = "API" and retry
            then return error return-value.

         /* gpiswrap.i QUERIES THE SESSION PARAMETER FOR */
         /* THE MFGWRAPPER TAG                           */
         if not {gpiswrap.i}
         then
            input clear.

         cancel_bo = no.
         if c-application-mode <> "API" then do:
            update line cancel_bo with frame c width 80
            editing:

               /* TO SHOW SO LINES FOR SELECTED SO IN CHAR AND GUI */
               /* USING LOOK-UP OR DRILL DOWN BROWSE ON LINE FIELD.  */
               {gpbrparm.i &browse=gpbr241.p &parm=c-brparm1 &val="so_nbr"}
               {gpbrparm.i &browse=gplu241.p &parm=c-brparm1 &val="so_nbr"}

               l_sonbr = so_nbr.

               on leave of line in frame c do:
                  /*V8!
                  do on error undo, leave:
                     {gpbrparm.i &browse=gpbr241.p &parm=c-brparm1 &val="l_sonbr"}
                     {gpbrparm.i &browse=gplu241.p &parm=c-brparm1 &val="l_sonbr"}
                     run q-leave in global-drop-down-utilities.
                  end. /* DO ON ERROR ... */

                  run q-set-window-recid in global-drop-down-utilities.
                  if return-value = "error"
                     then return no-apply.  */
               end. /* ON LEAVE ... */

               if frame-field = "line" then do:

                  {mfnp01.i sod_det line sod_line sod_nbr
                          " sod_domain = global_domain and so_nbr " sod_nbrln}

                  if recno <> ? then do:

                     line = sod_line.

                     for first pt_mstr
                        fields (pt_domain pt_desc1 pt_lot_ser pt_part pt_price)
                        where   pt_domain = global_domain
                        and     pt_part = sod_part
                     no-lock: end.

                     display
                        line
                        sod_part
                        sod_desc
                        sod_um
                     with frame c.

                     if available pt_mstr then
                        display pt_desc1 @ sod_desc with frame c.
                  end.

               end.
               else do:
                  status input.
                  readkey.
                  apply lastkey.
               end.

            end.
            status input.
         end. /* IF C-APPLICATION-MODE <> "API" THEN */
         else
            assign
               {mfaiset.i line integer(ttSoShipDet.line)}
               {mfaiset.i cancel_bo ttSoShipDet.ed_cncl_backord}.

         if line = 0 then leave.

         find sod_det
            where sod_domain = global_domain
            and   sod_nbr = so_nbr and sod_line = line
         exclusive-lock no-error.

         {&SOSOISD-P-TAG7}

         if not available sod_det then do:
            /* Line item does not exist */
            {pxmsg.i &MSGNUM=45 &ERRORLEVEL=3}
            if batchrun then
               undo loop0, leave loop0.
            else
               undo, retry.
         end.
         if not sod_confirm then do:
            /* Sales order line has not been confirmed */
            {pxmsg.i &MSGNUM=646 &ERRORLEVEL=3}
            if batchrun then
               undo loop0, leave loop0.
            else
               undo, retry.
         end.

         /* CHECK IF WORK ORDER IS RELEASED OR ALLOCATED */
         /* FOR ATO CONFIGURED ITEMS                     */
         l_wo_reject = no.
         if sod_lot <> "" then do:

            for first wo_mstr
               fields (wo_domain wo_lot wo_status)
               where   wo_domain = global_domain
               and     wo_lot    = sod_lot
            no-lock:

               if lookup(wo_status, "A,R,C") = 0 then
                  l_wo_reject = yes.
            end. /* FOR FIRST wo_mstr */
         end. /* IF sod_lot <> "" */
         else do:

            if sod_fa_nbr <> "" then do:

               for first wo_mstr
                  fields (wo_domain wo_nbr wo_status)
                  where   wo_domain = global_domain
                    and wo_nbr = sod_fa_nbr
                    and lookup(wo_status, "A,R,C") = 0
               no-lock:
                  l_wo_reject = yes.
               end. /* FOR FIRST wo_mstr */

            end. /* IF sod_fa_nbr <> "" */
         end. /* ELSE */

         if l_wo_reject = yes then do:

            /* WORK ORDER ID IS CLOSED, PLANNED OR */
            /* FIRM PLANNED                        */
            run DisplayMessage(input 523,
                               input 3,
                               input '').

            /* CURRENT WORK ORDER STATUS: */
            run DisplayMessage(input 525,
                               input 1,
                               input wo_status).

            undo, retry.

         end. /* IF l_wo_reject = yes */

         msgnbr = 0.
         if  sorec = fsrmarec and sod_rma_type <> "I"
         then
            msgnbr = 7228.  /* CANNOT PROCESS ISSUES */

         if (sorec = fsrmaship     or
             sorec = fssoship      or
             sorec = fssormaship) and
             sod_rma_type = "I"
         then
            msgnbr = 7227.  /* CANNOT PROCESS RETURNS */

         if  msgnbr <> 0 then do:
            {pxmsg.i &MSGNUM=msgnbr &ERRORLEVEL=3}
            if batchrun
            then
               undo loop0, leave loop0.
            else
               undo, retry.
         end.

         if ship_site <> "" and sod_site  <> ship_site
         then do:
            /* SITE OF THE LINE DOES NOT MATCH ... */
            {pxmsg.i &MSGNUM=4573 &ERRORLEVEL=3}
            if batchrun then
               undo loop0, leave loop0.
            else
               undo, retry.
         end. /* IF ship_site <> "" */

         if c-application-mode <> "API" then do:
            {&SOSOISD-P-TAG8}
            display line sod_part sod_desc sod_um with frame c.
         end. /* IF C-APPLICATION-MODE <> "API" THEN */

         for first pt_mstr
            fields (pt_domain pt_desc1 pt_lot_ser pt_part pt_price)
             where  pt_domain = global_domain
             and    pt_part = sod_part
         no-lock:
            if c-application-mode <> "API" then
               display pt_desc1 @ sod_desc with frame c.
         end.

         lotserial_control = "".

         /* Don't bother with Item Master for Memo items */
         if sod_type = "" then do:
            if not available pt_mstr then do:
               /* WARNING - ITEM NOT IN INVENTORY */
               {pxmsg.i &MSGNUM=16 &ERRORLEVEL=2}
            end.
         end.
         {&SOSOISD-P-TAG2}
      end.

      if available pt_mstr then
         lotserial_control = pt_lot_ser.
      else
         lotserial_control = "".

      assign
         site                = ""
         location            = ""
         lotserial           = ""
         lotref              = ""
         lotserial_qty       = sod_qty_chg
         prev_lotserial_qty  = sod_qty_chg
         cline               = string(line)
         global_part         = sod_part
         trans_um            = sod_um
         trans_conv          = sod_um_conv
         multi_entry         = no
         sod_qty_chg         = 0
         total_lotserial_qty = 0.

      /* Fill lotserial data for MO-line */
      if sod_fsm_type = "SEO" then
      assign
         lotserial     = sod_serial
         site          = sod_site
         location      = sod_loc.

      /* Total previously entered ship qtys for this line */
      {gprun.i ""gpalias3.p"" "(input ship_db, output err-flag)"}

      assign
         connect_db = ship_db
         db_undo = no.

      run check-db-connect
         (input connect_db, input-output db_undo).

      if db_undo then do:
         if c-application-mode <> "API" then do:
            hide frame b.
            hide frame f.
            hide frame c.
         end. /* IF C-APPLICATION-MODE <> "API" THEN */
         undo loop0, leave loop0.
      end.

      {gprun.i ""sosoiss5.p""}
      {gprun.i ""gpalias3.p"" "(input so_db, output err-flag)"}

      assign
         connect_db = so_db
         db_undo = no.

      run check-db-connect
         (input connect_db, input-output db_undo).

      if db_undo then do:
         if c-application-mode <> "API" then do:
            hide frame b.
            hide frame f.
            hide frame c.
         end. /* IF C-APPLICATION-MODE <> "API" THEN */
         undo loop0, leave loop0.
      end.

      /* Default to SO site if no shipments exist */
      if site = "" then
         assign
            site     = sod_site
            location = sod_loc.

      /* RMA receipt's for serialized item's are typically */
      /* for a single item. Therefore default the serial   */
      /* number, ref, and quantity for this item.          */
      if sod_serial    <> ""       and
         sod_fsm_type  = "RMA-RCT" and
         sod_rma_type  = "I"       and
         sod_qty_ord   = -1
      then
         assign
            lotserial = sod_serial
            lotserial_qty = sod_qty_ord * -1.

      {gprun.i ""gpsiver.p"" "(input site,
                               input ?,
                               output return_int)"}
      if return_int = 0 then do:
         /* USER DOES NOT HAVE ACCESS TO THIS SITE */
         {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
         undo, retry.
      end.

      /* UPDATE INVENTORY LOCATION INFORMATION */
      setlot:
      do on error undo, retry:
         if c-application-mode = "API" and retry
            then return error return-value.

         /* FOR MO'S WITH KITS TO SHIP, WE DO NOT (!!!) WANT   */
         /* THE USER TO GO INTO MULTI-ENTRY MODE.  HE MUST BE  */
         /* DEALING WITH A QUANTITY OF 1, AND, IF HE HAPPENS   */
         /* TO HAVE PICKED AN INCOMPLETE KIT, WE'VE GOT AN     */
         /* EXTRA SR_WKFL HANGING AROUND (WITH SR_REV =        */
         /* SEO-DEL) TO SUPPORT THE BACKORDER REPORT THAT      */
         /* PRINTS AUTOMATICALLY FOLLOWING MO SHIPMENT TIME.   */
         if (sod_fsm_type = "SEO" and sod_type = "K") then
            multi_entry = no.

         if c-application-mode <> "API" then
            display
               site
               location
               lotserial
               multi_entry
            with frame c.

         if change_db then do:
            {gprun.i ""gpalias3.p"" "(input ship_db, output err-flag)"}

            assign
               connect_db = ship_db
               db_undo = no.

            run check-db-connect
               (input connect_db, input-output db_undo).

            if db_undo then do:
               if c-application-mode <> "API" then do:
                  hide frame b.
                  hide frame f.
                  hide frame c.
               end. /* IF C-APPLICATION-MODE <> "API" THEN */
               undo loop0, leave loop0.
            end.
         end.

         {gprun.i ""sosoiss6.p"" "(input sod_nbr, input sod_line)"}

         if change_db then do:
            {gprun.i ""gpalias3.p"" "(input so_db, output err-flag)"}

            assign
               connect_db = so_db
               db_undo = no.

            run check-db-connect
               (input connect_db, input-output db_undo).

            if db_undo then do:
               if c-application-mode <> "API" then do:
                  hide frame b.
                  hide frame f.
                  hide frame c.
               end. /* IF C-APPLICATION-MODE <> "API" THEN */
               undo loop0, leave loop0.
            end.
         end.

         for first tt_bo
            where tt_bo.tt_sod_line = sod_line
         no-lock: end.

         if available tt_bo then
            tt_bo.tt_cancel_bo = cancel_bo.

         /* SIMILARLY, FOR KITS/MO'S, DO NOT LET THE USER      */
         /* UPDATE THE MULTI-ENTRY FIELD.                      */
         {&SOSOISD-P-TAG3}
         if c-application-mode <> "API" then
            update
               lotserial_qty
               site      when (sod_fsm_type <> "SEO" or sod_type <> "K")
               location  when (sod_fsm_type <> "SEO" or sod_type <> "K")
               lotserial when (sod_fsm_type <> "SEO" or sod_type <> "K")
               lotref    when (sod_fsm_type <> "SEO" or sod_type <> "K")
               multi_entry when (sod_type = "" and not multi_entry)
            with frame c
            editing:
               {&SOSOISD-P-TAG4}
               assign
                  global_site = input site
                  global_loc  = input location
                  global_lot  = input lotserial.
               readkey.
               apply lastkey.
            end.
         else do: /* C-APPLICATION-MODE = "API" */
            assign
               {mfaiset.i
                  lotserial_qty ttSoShipDet.ed_sod_qty}.

            if sod_fsm_type <> "SEO" or sod_type <> "K" then do:
               assign
                  {mfaiset.i
                     site ttSoShipDet.ed_sod_site}
                  {mfaiset.i
                     location ttSoShipDet.ed_sod_loc}
                  {mfaiset.i
                     lotserial ttSoShipDet.ed_sod_lotser}
                  {mfaiset.i
                     lotref ttSoShipDet.ed_sod_ref}.

            end. /* IF SOD_FSM_TYPE <> "SEO" OR SOD_TYPE <> "K" THEN */

            if sod_type = "" and not multi_entry then
               {mfaiset.i
                  multi_entry ttSoShipDet.ed_multi_entry}.

            assign
               {mfaiset.i
                  global_site site}
               {mfaiset.i
                  global_loc location}
               {mfaiset.i
                  global_lot lotserial}.

         end. /* C-APPLICATION-MODE = "API" */
         /* CHECK FOR VALID SITE */
         if not can-find(si_mstr
            where si_domain = global_domain
            and   si_site = site)
         then do:
            {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}  /* SITE DOES NOT EXIST */
            next-prompt site with frame c.
            undo setlot, retry.
         end.

         /* CHECK SITE FOR USER GROUP AUTHORIZATION */
         {gprun.i ""gpsiver.p"" "(input (input site),
                                  input ?,
                                  output return_int)"}
         if return_int = 0 then do:
            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
            /* USER DOES NOT HAVE ACCESS TO SITE */
            undo setlot, retry.
         end.

         /* If ship site doesn't match original site, make sure   */
         /* Domain isn't changing at the same time (this change */
         /* Should be made in SO Maintenance so we don't have to  */
         /* Include the code here to copy the line into the       */
         /* Remote domain).                                     */
         if global_db <> "" and site <> sod_site then do:

            if sod_site <> ship_site then do:
               for first si_mstr
                  fields (si_domain si_db si_entity si_site)
                  where   si_domain = global_domain
                  and     si_site = sod_site
               no-lock: end.
               original_db = si_db.
            end.
            else
               original_db = ship_db.

            if site <> ship_site then do:
               for first si_mstr
                  fields (si_domain si_db si_entity si_site)
                  where   si_domain = global_domain
                  and     si_site = site
               no-lock: end.
               new_db = si_db.
            end.
            else
               new_db = ship_db.

            if new_db <> original_db then do:
               /* Order line is for domain #*/
               {pxmsg.i &MSGNUM=6254 &ERRORLEVEL=3 &MSGARG1=original_db}
               next-prompt site with frame c.
               undo setlot, retry.
            end.
         end.

         /* If specified site is not defined ship-from site, */
         /* Make sure it's in the same domain              */
         if global_db <> "" and site <> ship_site then do:

            for first si_mstr
               fields (si_domain si_db si_entity si_site)
                where  si_domain = global_domain
                and    si_site = site
            no-lock: end.

            if si_db <> ship_db then do:
               {pxmsg.i &MSGNUM=6253 &ERRORLEVEL=3}
               /* All ship-from sites must be in same domain */
               next-prompt site with frame c.
               undo, retry.
            end.
         end.

         /* CHECK TO SEE IF RESERVED LOCATION EXISTS */
         /* FOR OTHER CUSTOMERS--                    */
         run check-reserved-location.

         if ret-flag = 0 then do:
            /* THIS LOCATION RESERVED FOR ANOTHER CUSTOMER */
            {pxmsg.i &MSGNUM=3346 &ERRORLEVEL=3}
            next-prompt location with frame c.
            undo setlot, retry.
         end.

         for first si_mstr
            fields (si_domain si_db si_entity si_site)
            where   si_domain = global_domain
            and     si_site = site
         no-lock: end.

         /* VALIDATE OPEN GL PERIOD FOR ENTITY AND DOMAIN */
         /* SPECIFIED ON THE SHIPMENT LINE. WE NEED TO DO   */
         /* DO THIS HERE BECAUSE THE SITE AND ENTITY CAN BE */
         /* DIFFERENT THAN WHAT WAS ENTERED IN FIRST FRAME. */
         {gpglef3.i &from_db = so_db
                    &to_db   = ship_db
                    &module  = ""IC""
                    &entity  = si_entity
                    &date    = eff_date
                    &prompt  = "site"
                    &frame   = "c"
                    &loop    = "setlot"}

         /* GET TAX MANAGEMENT DATA ONLY IF */
         /* THE SITE HAS BEEN CHANGED       */
         if site <> sod_site and sod_taxable then do:
            undo-all = true.
            {gprun.i ""sosoistx.p""
                     "(input so_mstr_recid,
                       input site,
                       input sod_site,
                       input sod_fsm_type,
                       input-output sod_taxable,
                       input-output so_taxc,
                       input-output sod_tax_usage,
                       input-output sod_tax_env,
                       input-output sod_tax_in,
                       input-output undo-all)"}

            if undo-all then undo setlot, retry.
         end.

         /*  IF THIS IS SOME TYPE OF RETURN THAT WOULD LIKE TO UPDATE
          *  THE INSTALLED BASE, BUT THE PART/SERIAL/REF DOESN'T
          *  EXIST IN THE ISB, OR THE QUANTITY DOESN'T MATCH THE
          *  ISB QUANTITY, WARN THE USER */
         if not available soc_ctrl then do:
            for first soc_ctrl
               fields (soc_domain soc_pl_req soc_returns_isb)
               where   soc_domain = global_domain
            no-lock: end.
         end.

         if multi_entry  = no
            and (sod_rma_type = "I" or soc_returns_isb)
            and sod_qty_ord < 0
            and sod_upd_isb  = yes
         then do:

            for first isb_mstr
               fields (isb_domain isb_eu_nbr isb_part
                       isb_qty    isb_ref    isb_serial)
               where   isb_domain = global_domain
               and     isb_eu_nbr = sod_enduser
               and     isb_part   = sod_part
               and     isb_serial = lotserial
               and     isb_ref    = sod_ref
            no-lock:
            end. /* FOR FIRST isb_mstr */

            if  not available isb_mstr then do:
               {pxmsg.i &MSGNUM=7123 &ERRORLEVEL=2}
               /* ITEM DOES NOT EXIST IN INSTALLED BASE */
            end.
            else do:
               /* LOT_SERIAL_QTY NOTES:  IF YOU'RE DOING AN
                * RMA RETURN, LOTSERIAL_QTY IS POSITIVE.
                * BUT, IF YOU'RE DOING A S.O. RETURN,
                * THIS QTY IS NEGATIVE.
                *
                * WE NEED TO WARN THE USER IF THE QTY BEING
                * RETURNED IS OTHER THAN THE QTY IN THE ISB.
                * WITH THE CONDITIONS NOTED ABOVE, THIS TAKES
                * A SPECIAL CHECK, DEPENDING ON THE TYPE OF
                * RETURN BEING DONE - AN RMA OR S.O. */

               if (sorec = fsrmarec and isb_qty <> lotserial_qty)
                  or (sorec = fssoship and - (isb_qty) <> lotserial_qty)
               then do:
                  /* INSTALLED BASE QTY (#) DOESN'T MATCH ITEM QTY */
                  {pxmsg.i &MSGNUM=1275 &ERRORLEVEL=2
                           &MSGARG1=trim(string(isb_qty,"">,>>>,>>>,>>9.9<<""))}
               end.    /* if sorec = fsrmarec... */

            end.    /* else, available isb_mstr, do */
         end. /* if multi_entry = no and ... */

         if change_db then do:
            {gprun.i ""gpalias3.p"" "(input ship_db, output err-flag)"}

            assign
               connect_db = ship_db
               db_undo = no.

            run check-db-connect
               (input connect_db, input-output db_undo).

            if db_undo then do:
               if c-application-mode <> "API" then do:
                  hide frame b.
                  hide frame f.
                  hide frame c.
               end. /* IF C-APPLICATION-MODE <> "API" THEN */
               undo loop0, leave loop0.
            end.
         end.

         assign
            ship_line = line
            sod_recno = recid(sod_det).

         if sod_rma_type = "O" then do:
            /* FOR RMA SHIPMENT LINES, ENSURE "SHIP BEFORE RECEIPT"
             * CONDITIONS (WHICH CAN BE SPECIFIED ON THE SERVICE TYPE)
             * WILL NOT BE VIOLATED BY SHIPPING THIS QUANTITY. */
            {gprun.i ""fsshb4r.p""
                     "(input sod_nbr,
                       input sod_line,
                       input (lotserial_qty * trans_conv),
                       output msgnbr,
                       output linked-line)"}

            if msgnbr <> 0 then do:
               {pxmsg.i &MSGNUM=msgnbr &ERRORLEVEL=3 &MSGARG1=linked-line}
               lotserial_qty = prev_lotserial_qty.
               undo setlot, retry.
            end.
         end.  /* if sod_rma_type = "O" */

         /* Build sr_wkfl, which holds shipped-from locations */
         undo-all = yes.

         if multi_entry then do:
            if c-application-mode = "API" then do:
               {gpttcp.i
                  ttSoShipLotSerial
                  ttInventoryTransDet
                     " ttSoShipLotSerial.nbr = ttSoShipDet.nbr and
                       ttSoShipLotSerial.line = ttSoShipDet.line
                     "
               }

               run setInventoryTransDet in apiMethodHandle(
                  input table ttInventoryTransDet).

            end. /* IF C-APPLICATION-MODE = "API" THEN */
            /* Prompt for multiple locations */
            sav_global_type = global_type.
            global_type = "shipundo".

            /* IF DOING RMA RECEIPT, WHICH IS TREATED AS A       */
            /* NEGATIVE SO ISSUE, CALL A DIFFERENT MULTI-ENTRY   */
            /* ROUTINE THAT SWITCHES THE SIGN ON THE QUANTITY    */
            /* SO THAT NO INCORRECT ERROR MESSAGES ARE RECEIVED  */
            if sorec = fsrmarec
               and sod_rma_type = "I"
            then do:
               {gprun.i ""icsrup3.p""
                        "(input sod_site,
                          input-output lotnext,
                          input lotprcpt)"}
            end.
            else do:
               assign
                  done_entry = true
                  lineid_list = "".

               for each soddet
                  fields (sod_domain sod_bo_chg sod_cfg_type sod_confirm
                          sod_cum_qty sod_desc sod_enduser sod_fa_nbr
                          sod_fr_chg sod_fr_class sod_fr_list sod_fr_wt
                          sod_fr_wt_um sod_fsm_type sod_line sod_list_pr
                          sod_loc sod_lot sod_nbr sod_part sod_price
                          sod_pr_list sod_qty_all sod_qty_chg sod_qty_ord
                          sod_qty_pick sod_qty_ship sod_ref sod_rma_type
                          sod_sched sod_sch_data sod_serial sod_site
                          sod_std_cost sod_taxable sod_tax_env sod_tax_in
                          sod_tax_usage sod_type sod_um sod_um_conv sod_upd_isb)
                  where soddet.sod_domain = global_domain
                  and   soddet.sod_nbr = sod_det.sod_nbr
                  and   soddet.sod_part = sod_det.sod_part
               no-lock:
                  lineid_list = lineid_list
                              + trim(string(soddet.sod_line)) + ",".
               end.

               lineid_list =
                  substring(lineid_list,1, ((r-index(lineid_list,",") - 1 )) ).

               do while done_entry:

                  /* Identify context for QXtend */
                  {gpcontxt.i
                     &STACKFRAG = 'icsrup,sosoisd,sosoism,sosoism,sosois'
                     &FRAME = 'a,c' &CONTEXT = 'SOSOISD'}

                  {gprun.i ""icsrup.p""
                           "(input sod_site,
                             input sod_nbr,
                             input string(sod_line),
                             input-output lotnext,
                             input lotprcpt,
                             input no)"}

                  /* Clear context for QXtend */
                  {gpcontxt.i
                     &STACKFRAG = 'icsrup,sosoisd,sosoism,sosoism,sosois'
                     &FRAME = 'a,c'}

                  {gprun.i ""icoviss.p""
                           "(input sod_det.sod_part,
                             input ship_so,
                             input lineid_list,
                             input sod_line,
                             output overissue_ok)"}

                  if overissue_ok then done_entry = false.

               end.

               if using_cust_consignment
                  and sod_consignment
               then do:

                  key1 = mfguser + "CONS".

                  /* TRANSFER qad_wkfl TO CONSIGNMENT TEMP-TABLE */
                  {gprunmo.i &program = "socntmp.p" &module  = "ACN"
                             &param   = """(input 1,
                                            input key1,
                                            input-output table
                                               tt_consign_shipment_detail)"""}

                  if can-find(first tt_consign_shipment_detail
                              where sales_order = sod_nbr
                              and   order_line  = sod_line
                              and   consigned_return_material)
                  then
                     transtype = "ISS-TR".

               end.   /* using_cust_consignment */
            end.  /* else do (sorec = fsrmarec) */

            if global_type = "shipok" then undo-all = no.
            global_type = sav_global_type.

         end.   /* if multi_entry */
         else do:
            ship_line = sod_line.
            /* Validate location */
            {gprun.i ""sosoisu2.p""}

            /* VALIDATIONS FOR TRANSFER OF ITEM FROM CONSIGNED LOCATION    */
            /* TO REGULAR INVENTORY LOCATION ARE DONE BEFORE VALIDATIONS   */
            /* FOR NORMAL RETURN OF ITEM FROM CUSTOMER BACK INTO INVENTORY */
            if using_cust_consignment
               and execname = "sosois.p"
               and sod_consignment
               and not undo-all
            then do:

               /* CREATE CONSIGNMENT TEMP-TABLE RECORD */
               {gprunmo.i &program = "socnship.p" &module = "ACN"
                          &param   = """(input  sod_nbr,
                                         input  sod_line,
                                         input  site,
                                         input  location,
                                         input  sod_part,
                                         input  lotserial,
                                         input  lotref,
                                         input  lotserial_qty,
                                         output ok_to_ship,
                                         input-output table
                                            tt_consign_shipment_detail)"""}

               if can-find(first tt_consign_shipment_detail
                           where sales_order = sod_nbr
                           and   order_line  = sod_line
                           and   consigned_return_material)
               then
                  transtype = "ISS-TR".

               if not ok_to_ship then
                  undo-all = yes.

            end.  /* IF using_cust_consignment */
         end.

         /* Make sure alias points to SO db in case the of F4 exit */
         {gprun.i ""gpalias3.p"" "(input so_db, output err-flag)"}

         assign
            connect_db = so_db
            db_undo = no.

         run check-db-connect
            (input connect_db, input-output db_undo).

         if db_undo then do:
            if c-application-mode <> "API" then do:
               hide frame b.
               hide frame f.
               hide frame c.
            end. /* IF C-APPLICATION-MODE <> "API" THEN */
            undo loop0, leave loop0.
         end.

         if undo-all then undo setlot, retry.

         /* WARN USER IF SHIPMENT ADJUSTMENT */
         /* EXCEEDS ORIGINAL SHIPMENT */
         if (sod_qty_ord > 0 and total_lotserial_qty < 0 and
             sod_qty_ship < (total_lotserial_qty * -1))
         or (sod_qty_ord < 0 and total_lotserial_qty > 0 and
            (sod_qty_ship * -1) < total_lotserial_qty)
         then do:
            if sod_fsm_type <> "RMA-RCT" then do:
               /* Reversal qty exceeds original qty shipped */
               {pxmsg.i &MSGNUM=812 &ERRORLEVEL=2 &MSGARG1=sod_qty_ship}
            end.
         end.

         if  sod_sched and sod_cum_qty[3] > 0 and
            sod_cum_qty[1] + total_lotserial_qty >= sod_cum_qty[3]
         then do:
            /* CUM SHIPPED QTY >= MAX ORDER QTY FOR ORDER SELECTED*/
            {pxmsg.i &MSGNUM=8220 &ERRORLEVEL=2}
         end.

         /* WARN USER IF OVERSHIPPING/OVER-RECEIVING (FOR RMA'S)  */
         if (sod_qty_ord < 0 and
            (sod_qty_ship - total_lotserial_qty) < sod_qty_ord)
         then do:
            /* QTY TO RECEIVE + QTY RECEIVED > QTY EXPECTED */
            {pxmsg.i &MSGNUM=7201 &ERRORLEVEL=2}
         end.
         else do:
            if sod_qty_ord * ( sod_qty_ord -
               (sod_qty_ship + total_lotserial_qty) ) < 0
            then do:
               l_overship = yes.
               /* Qty shiped > Qty Ordered */
               {pxmsg.i &MSGNUM=622 &ERRORLEVEL=2}
            end.
         end.

      end.  /* SETLOT */

      sod_qty_chg = total_lotserial_qty.
      if cancel_bo and not l_overship then
         sod_bo_chg = 0.
      else
      /***********************************************/
      /*  RMA quantites in sod_qty_chg are stored as */
      /*  Positive even though it is negative. Why?  */
      /*  Because I would have to do many + - +      */
      /*  Conversions throughout the code to handle  */
      /*  RMA receipts because receipts are dislayed */
      /*  As positive.  This will have to do for now */
      /***********************************************/
      if sod_fsm_type = "RMA-RCT" then
         sod_bo_chg = sod_qty_ord - sod_qty_ship + sod_qty_chg.
      else
         sod_bo_chg = if sod_qty_ord > 0
                      then
                         sod_qty_ord - sod_qty_ship - sod_qty_chg
                      else
                         0.

      l_overship = no.

      if can-find (first sob_det
         where sob_domain = global_domain
         and   sob_nbr    = sod_nbr
         and   sob_line   = sod_line)
         and   sod_fa_nbr = ""
         and   sod_cfg_type <> "1"    /* Not "1" Assemble-to-Order */
         and   not undo-all
         and   sod_type = ""
         and   sod_lot    = ""
      then do:
         repeat:
            if c-application-mode = "API" and retry
               then return error return-value.
            undo-all = no.
            mod_iss = ?.
            form
               space(1)
               mod_iss
               space(2)
            with frame e row 16 column 21 side-labels 1 down overlay.

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame e:handle).

            repeat with frame e:
               if c-application-mode = "API" and retry
                  then return error return-value.
               if c-application-mode <> "API" then do:
                  display yes @ mod_iss.
                  set mod_iss.
               end.
               else
                  {mfaiset.i mod_iss ttSoShipDet.ed_mod_iss}.
               leave.
            end.
            if c-application-mode <> "API" then
               hide frame e.

            if mod_iss <> yes then leave.
            if c-application-mode <> "API" then do:
               hide frame c.
               hide frame f.
               hide frame b.
            end. /* IF C-APPLICATION-MODE <> "API" THEN */

            if change_db then do:
               {gprun.i ""gpalias3.p"" "(input ship_db, output err-flag)"}

               assign
                  connect_db = ship_db
                  db_undo = no.

               run check-db-connect
                  (input connect_db, input-output db_undo).

               if db_undo then do:
                  if c-application-mode <> "API" then
                     hide frame e.
                  undo loop0, leave loop0.
               end.
            end.
            else do:
               sod_recno = recid(sod_det).
            end.

            /* PASSING THE CENTRAL DB sod_qty_chg TO CORRECTLY  */
            /* INITIALIZE BACKFLUSH QTY (back_qty) IN SOISE01.P */
            {gprun.i ""soise01.p""
                     "(input sod_nbr,
                       input sod_line,
                       input sod_qty_chg,
                       output l_rej)"}

            if l_rej = yes then
               assign
                  sod_bo_chg  = if sod_qty_ord > 0
                                then
                                   sod_bo_chg + sod_qty_chg
                                else
                                   sod_bo_chg
                  sod_qty_chg = 0
                        l_rej = no.

            if change_db then do:
               {gprun.i ""gpalias3.p"" "(input so_db, output err-flag)"}

               assign
                  connect_db = so_db
                  db_undo = no.

               run check-db-connect
                  (input connect_db, input-output db_undo).

               if db_undo then do:
                  if c-application-mode <> "API" then
                     hide frame e.
                  undo loop0, leave loop0.
               end.
            end.

            if c-application-mode <> "API" then do:
               if sorec = fsrmarec then
                  view frame f.
               else
                  view frame b.

               view frame c.
               pause 0.
            end. /* IF C-APPLICATION-MODE <> "API" THEN */
            if undo-all = no then leave.
         end.

         if mod_iss <> yes then do:
            for each sr_wkfl
               where sr_domain = global_domain
               and   sr_userid = mfguser
               and sr_lineid begins string(sod_line) + "ISS"
            exclusive-lock:
               delete sr_wkfl.
            end.

            for each lotw_wkfl
               where lotw_domain = global_domain
               and   lotw_mfguser = mfguser
            exclusive-lock:
               delete lotw_wkfl.
            end.
         end.
      end. /* IF CAN-FIND */

      /* SWITCHING TO INVENTORY DOMAIN */
      if change_db then do:
         {gprun.i ""gpalias3.p"" "(input ship_db, output err-flag)"}

         assign
            connect_db = ship_db
            db_undo    = no.

         run check-db-connect (input connect_db,
            input-output db_undo).

         if db_undo then do:
            if c-application-mode <> "API" then do:
               hide frame b.
               hide frame f.
               hide frame c.
            end. /* IF C-APPLICATION-MODE <> "API" THEN */
            undo loop0, leave loop0.
         end. /* IF DB_UNDO THEN */
      end. /* IF CHANGE_DB */

      /* SET STANDARD COST FROM INVENTORY DOMAIN */
      {gprun.i ""gpsct05.p""
               "(input sod_part,
                 input sod_site,
                 input 1,
                 output glxcst,
                 output curcst)"}

      if sod_type <> "M" then
         sod_std_cost = glxcst * sod_um_conv.

      /* SWITCHING BACK TO CENTRAL DOMAIN */
      if change_db then do:
         {gprun.i ""gpalias3.p"" "(input so_db, output err-flag)"}

         assign
            connect_db = so_db
            db_undo    = no.

         run check-db-connect (input connect_db,
            input-output db_undo).

         if db_undo then do:
            if c-application-mode <> "API" then do:
               hide frame b.
               hide frame f.
               hide frame c.
            end. /* IF C-APPLICATION-MODE <> "API" THEN */
            undo loop0, leave loop0.
         end. /* IF DB_UNDO THEN */
      end. /* IF CHANGE_DB */

      if sod_sched then do:
         /* SET CURRENT PRICE */

         /* FOLLOWING SECTION IS ADDED TO REPLACE rcpccal.p WITH gppccal.p  */
         /* TO TAKE CARE OF PRICE LIST TYPES "M" AND "D" IN ADDITION TO "P" */

         for first soc_ctrl
            fields (soc_domain soc_pl_req soc_returns_isb)
            where   soc_domain = global_domain
         no-lock: end.

         assign
            l_disc_pct1  = 0
            l_net_price  = ?
            l_rec_no     = ?
            l_list_price = 0.

         /* SCHEDULED ORDERS CAN BE CREATED ONLY IN STOCKING UM */
         /* MULTIPLYING BY sod_um_conv JUST FOR SAFETY          */
         if available pt_mstr then do:

            {gprunp.i "mcpl" "p" "mc-curr-conv"
                      "(input base_curr,
                        input so_curr,
                        input exch_rate2,
                        input exch_rate,
                        input (pt_price * sod_um_conv),
                        input false,
                        output l_list_price,
                        output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end. /* if available pt_mstr */

         {gprun.i ""gppccal.p""
                  "(input  sod_part,
                    input sod_qty_chg,
                    input sod_um,
                    input sod_um_conv,
                    input so_curr,
                    input sod_pr_list,
                    input eff_date,
                    input sod_std_cost,
                    input soc_pl_req,
                    0.0,
                    input-output  l_list_price,
                    output l_disc_pct1,
                    input-output  l_net_price,
                    output l_rec_no)"}

         create tt_sod_det.
         assign
            tt_sod_det.tt_sod_nbr  = sod_nbr
            tt_sod_det.tt_sod_line = sod_line
            tt_sod_det.tt_pr_found = if l_rec_no = 0 then false
                                     else true.

         if recid(tt_sod_det) = -1 then .

         if l_net_price <> ? then
            sod_price = l_net_price.

         /* SWITCHING TO INVENTORY DOMAIN */
         if change_db then do:
            {gprun.i ""gpalias3.p"" "(input ship_db, output err-flag)"}

            assign
               connect_db = ship_db
               db_undo    = no.

            run check-db-connect (input connect_db,
               input-output db_undo).

            if db_undo then do:
               if c-application-mode <> "API" then do:
                  hide frame b.
                  hide frame f.
                  hide frame c.
               end. /* IF C-APPLICATION-MODE <> "API" THEN */
               undo loop0, leave loop0.
            end. /* IF DB_UNDO THEN */
         end. /* IF CHANGE_DB */

         /* UPDATE NET PRICE, LIST PRICE, CUMULATIVE QTY IN */
         /* INVENTORY DOMAIN                              */
         {gprun.i ""sosoisu6.p""
                  "(input sod_nbr,
                    input sod_line,
                    input sod_price,
                    input l_list_price,
                    input sod_cum_qty[1],
                    input sod_cum_qty[2],
                    input sod_cum_qty[3])"}

         /* SWITCHING BACK TO CENTRAL DOMAIN */
         if change_db then do:
            {gprun.i ""gpalias3.p"" "(input so_db, output err-flag)"}

            assign
               connect_db = so_db
               db_undo    = no.

            run check-db-connect (input connect_db,
               input-output db_undo).

            if db_undo then do:
               if c-application-mode <> "API" then do:
                  hide frame b.
                  hide frame f.
                  hide frame c.
               end. /* IF C-APPLICATION-MODE <> "API" THEN */
               undo loop0, leave loop0.
            end. /* IF DB_UNDO THEN */
         end. /* IF CHANGE_DB */

         /* UPDATE SOD_LIST_PRICE FOR SCHEDULE ORDER WHEN   */
         /* SOD_LIST_PRICE IS ZERO OR                       */
         /* LIST PRICE IN ITEM MASTER IS ZERO SO THAT SALES */
         /* AMOUNT SHOULD BE POSTED TO PROPER ACCOUNT       */

         if pt_price = 0
            or sod_list_pr = 0
         then
            sod_list_pr = sod_price.
      end. /* IF SOD_SCHED */

      /* FREIGHT WEIGHTS */
      if sod_fr_list <> "" then do:
         set_wt:
         do on error undo, retry:
            freight_ok = yes.
            if calc_fr or disp_fr then do:
               detqty = sod_qty_chg.

               {gprun.i ""gpfrlwt.p""
                        "(input so_curr,
                          input so_ex_rate,
                          input so_ex_rate2,
                          input so_fr_min_wt,
                          input so_fr_terms,
                          input so_ship, input eff_date,
                          input sod_fr_list, input sod_part,
                          input detqty, input sod_site,
                          input sod_type, input sod_um,
                          input calc_fr,
                          input disp_fr,
                          input sod_nbr,
                          input sod_line,
                          input sod_sob_std,
                          input-output sod_fr_wt,
                          input-output sod_fr_wt_um,
                          input-output sod_fr_class,
                          input-output l_sod_fr_chg,
                          input-output freight_ok)"}
            end.

            if sod_fr_wt <> 0
            then do:
               find first ied_det
                  where ied_domain = global_domain
                  and   ied_type   = "1"
                  and   ied_nbr    = sod_nbr
                  and   ied_line   = sod_line
               exclusive-lock no-error.

               if available ied_det
               then
                  assign
                     ied__dec01 = sod_fr_wt
                     ied__chr01 = sod_fr_wt_um.

               release ied_det.
            end. /* IF sod_fr_wt <> 0 */

            if not freight_ok then
               undo set_wt, retry.
         end.
      end.
   end. /* REPEAT (NOT TRANSACTION) */

   if sorec = fsrmarec  then
      msgnbr = 7229.  /* DISPLAY RMA LINES BEING RECEIVED? */
   else
   if so_fsm_type = "SEO" then
      msgnbr = 3353.  /* DISPLAY MATERIAL ORDER LINES BEING SHIPPED? */
   else
   if so_fsm_type  = "KITASS" then
      msgnbr = 817.   /* DISPLAY KIT ITEMS BEING ASSEMBLED? */
   else
      msgnbr = 618.   /* DISPLAY SALES ORDER LINES BEING SHIPPED? */

   /* Display Shipment information for user review */
   do on endkey undo loop0,leave loop0:

      if c-application-mode = "API" and retry
         then return error return-value.

      l_remove_srwkfl = yes.

      yn = yes.
      /* Display sales order lines being shipped? */

      /* Identify context for QXtend
      {gpcontxt.i
         &STACKFRAG = 'sosoisd,sosoism,sosoism,sosois'
         &FRAME = 'yn' &CONTEXT = 'SOSOISD_1'}

      /*V8-*/
      {pxmsg.i &MSGNUM=msgnbr &ERRORLEVEL=1 &CONFIRM=yn}
      /*V8+*/

      /*V8!*/
      {pxmsg.i &MSGNUM=msgnbr &ERRORLEVEL=1 &CONFIRM=yn}
      if yn = ?
      then
         undo loop0, leave loop0.

      /* Clear context for QXtend */
      {gpcontxt.i
         &STACKFRAG = 'sosoisd,sosoism,sosoism,sosois'
         &FRAME = 'yn'}
 */
      l_remove_srwkfl = no.

      if c-application-mode <> "API" then do:
         if yn = yes then do:

            hide frame b no-pause.
            hide frame f no-pause.
            hide frame c no-pause.

            /* Switch to the shipping db to display the shipment file */
            if ship_db <> global_db then do:
               {gprun.i ""gpalias3.p"" "(input ship_db, output err-flag)"}

               assign
                  connect_db = ship_db
                  db_undo = no.

               run check-db-connect
                  (input connect_db, input-output db_undo).

               if db_undo then do:
                  hide frame b.
                  hide frame f.
                  hide frame c.
                  undo loop0, leave loop0.
               end.
            end.

            {gprun.i ""sosoiss1.p""}

            {gprun.i ""gpalias3.p"" "(input so_db, output err-flag)"}

            assign
               connect_db = so_db
               db_undo = no.

            run check-db-connect
               (input connect_db, input-output db_undo).

            if db_undo then do:
               hide frame b.
               hide frame f.
               hide frame c.
               undo loop0, leave loop0.
            end.

         end.
      end. /* IF C-APPLICATION-MODE <> "API" THEN */
   end. /* DO ON ENDKEY */

   do on endkey undo loop0, leave loop0:
      if c-application-mode = "API" and retry
         then return error return-value.
      {&SOSOISD-P-TAG5}
      yn = yes.

      l_remove_srwkfl = yes.

      /* Identify context for QXtend */
      {gpcontxt.i
         &STACKFRAG = 'sosoisd,sosoism,sosoism,sosois'
         &FRAME = 'yn' &CONTEXT = 'SOSOISD_2'}

      /* Is all info correct? */
      /*V8-
      {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn}
       V8+*/

      /*V8!
      {mfgmsg10.i 12 1 yn}
      if yn = ? then
      undo loop0, leave loop0. */

      /* Clear context for QXtend */
      {gpcontxt.i
         &STACKFRAG = 'sosoisd,sosoism,sosoism,sosois'
         &FRAME = 'yn'}

      l_remove_srwkfl = no.

      if yn then do:
         if c-application-mode <> "API" then do:
            hide frame b.
            hide frame f.
            hide frame c.
         end. /* IF C-APPLICATION-MODE <> "API" THEN */
         undo-select = false.
         leave loop0.
      end.
   end.
end.  /* LOOP0: REPEAT TRANSACTION */

/* Clear context for QXtend */
{gpcontxt.i
   &STACKFRAG = 'sosoisd,sosoism,sosoism,sosois'
   &FRAME = 'yn'}

empty temp-table compute_ldd no-error.

/* IN GUI THE RETURN KEY IN THE QUESTION ALERT BOX IS NOT RECOGNIZED,*/
/* CONSEQUENTLY THE KEYFUNCTION(LASTKEY)WRONGLY RETURNS F4 OR ESC    */
/* KEY FROM THE PREVIOUS KEYSTROKE CAUSING ERRONEOUS DELETION OF     */
/* SR_WKFL. SO INSTEAD OF RELYING ON LASTKEY WE WILL USE LOGICAL     */
/* VARIABLE TO DETECT IF USER HAS PRESSED END-ERROR OR END-KEY.      */

{&SOSOISD-P-TAG11}

if l_remove_srwkfl then do:
   for each sr_wkfl
      where sr_domain = global_domain
      and   sr_userid = mfguser
   exclusive-lock:
      delete sr_wkfl.
   end.

   for each lotw_wkfl
      where lotw_domain = global_domain
      and   lotw_mfguser = mfguser
   exclusive-lock:
      delete lotw_wkfl.
   end.

end.

{&SOSOISD-P-TAG12}

PROCEDURE check-db-connect:
   define input parameter connect_db like dc_name.
   define input-output parameter db_undo like mfc_logical.

   if err-flag = 2 or err-flag = 3 then do:
      /* DOMAIN # IS NOT AVAILABLE */
      {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4 &MSGARG1=connect_db}
      db_undo = yes.
   end.

END PROCEDURE.

PROCEDURE check-reserved-location:
/*  DETERMINE IF LOC TO BE USED IS VALID                                */

   ret-flag = 2.

   /* bypass checking SSM orders */
   if so_mstr.so_fsm_type = "" then do:
     {gprun.i ""sorlchk.p""
              "(input so_mstr.so_ship,
                input so_mstr.so_bill,
                input so_mstr.so_cust,
                input site,
                input location,
                output ret-flag)"}
   end.

END PROCEDURE.

PROCEDURE DisplayMessage:

   define input parameter ipMsgNum as integer   no-undo.
   define input parameter ipLevel  as integer   no-undo.
   define input parameter ipMsg1   as character no-undo.

   {pxmsg.i &MSGNUM = ipMsgNum
            &ERRORLEVEL = ipLevel
            &MSGARG1    = ipMsg1}

END PROCEDURE.
