/* dsdomt2a.p - DISTRIBUTION ORDER MAINTENANCE                                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.39 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/*                                                                            */
/*! dsdomt2a.p IS CALLED FROM dsdomt.p AND dsdomt02.p                         */
/*                                                                            */
/* Revision: 1.24          BY: Samir Bavkar       DATE: 07/31/01  ECO: *P009* */
/* Revision: 1.25          BY: Saurabh Chaturvedi DATE: 09/19/01  ECO: *M1KP* */
/* Revision: 1.28          BY: Steve Nugent       DATE: 10/15/01  ECO: *P004* */
/* Revision: 1.33          BY: Manish Kulkarni    DATE: 01/05/02  ECO: *P042* */
/* Revision: 1.37          BY: Robin McCarthy     DATE: 06/16/02  ECO: *P08P* */
/* Revision: 1.38          BY: Samir Bavkar       DATE: 07/07/02  ECO: *P0B0* */
/* $Revision: 1.39 $       BY: Robin McCarthy     DATE: 07/15/02  ECO: *P0BJ* */

{mfdeclre.i}
{gplabel.i}   /* EXTERNAL LABEL INCLUDE */
{cxcustom.i "DSDOMT2A.P"}   /* USED FOR LOCALIZATIONS */

{&DSDOMT2A-P-TAG1}   /* USED FOR LOCALIZATIONS */
{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */

define input parameter auto_do_proc like mfc_logical no-undo.
define input parameter orderNbr  like dss_nbr       no-undo.
define input parameter shipSite  like dss_shipsite  no-undo.
define input parameter recSite   like dss_rec_site  no-undo.

define new shared variable del-yn like mfc_logical.
define new shared variable dss_recno as recid.
define new shared variable dsscmmts like drp_dcmmts
   label "Comments".
define new shared variable new_order like mfc_logical initial no.
define new shared variable cmtindx like dss_cmtindx.
define new shared variable ds_recno as recid.
define new shared variable ds_db like dc_name.
define new shared variable undo-all like mfc_logical.
define new shared variable go_back_to_main as logical.
define new shared variable qty_to_all like ds_qty_all.
define new shared variable totallqty like ds_qty_all.
define new shared variable totpkqty like ds_qty_pick.
define new shared variable order_date like dsr_ord_date no-undo.
define new shared variable sales_job like dsr_so_job no-undo.
define new shared variable rcpt_loc like dsr_loc no-undo.
define new shared variable del-req like mfc_logical no-undo.
define new shared variable qty_ord like ds_qty_ord no-undo.
define new shared variable calc_fr like mfc_logical no-undo.
define new shared variable disp_fr like mfc_logical no-undo.
define new shared variable freight_ok like mfc_logical no-undo.
define new shared variable rndmthd like rnd_rnd_mthd.

define variable err_nbr as integer no-undo.
define variable severity as integer no-undo.
define variable err_arg1 as character no-undo.
define variable err_arg2 as character no-undo.
define variable err_arg3 as character no-undo.
define variable last_dsline like ds_line no-undo.
define variable donbr like dss_nbr.
define variable yn like mfc_logical initial yes.
define variable i as integer.
define variable comment_type like dss_lang.
define variable open_qty like mrp_qty.
define variable l_prev_ds_status like ds_status no-undo.
define variable l_prev_ds_qty like ds_qty_conf no-undo.
define variable dss_recid as recid no-undo.
define variable got_dss_mstr like mfc_logical no-undo.
define variable l_shipsite like dss_shipsite no-undo.
define variable continue like mfc_logical no-undo.
define variable prev_qty_all like ds_qty_all no-undo.
define variable req_nbr like ds_req_nbr no-undo.
define variable change_db as logical no-undo.
define variable err-flag as integer no-undo.
define variable use-log-acctg as logical no-undo.

define buffer dsdet for ds_det.

{lafrttmp.i "new"}   /* FREIGHT ACCRUAL TEMP TABLE DEFINITION */

define new shared frame b.
define new shared frame d.

/* FRAME D DEFINITION */
{dsdofmd.i}

form
   order_date    colon 22
   ds_status     colon 22
   sales_job     colon 22
   rcpt_loc      colon 22   label "Receipt Location"
with frame e side-labels overlay width 34
   title color normal (getFrameTitle("INTERSITE_REQUEST",32)) attr-space
   row 11 column 24.

/* SET EXTERNAL LABELS */
setFrameLabels(frame e:handle).

mainloop:
repeat:

   do transaction on error undo, retry:

      /* DISPLAY SELECTION FORM */
      form
         space(1)
         dss_nbr
         dss_shipsite label "Ship-From"
         dss_rec_site
      with frame a side-labels width 80 attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame a:handle).

      /* FRAME B DEFINITION */
      {dsdofmb.i}

      {mfadform.i ship_from  1 SHIP-FROM}
      {mfadform.i ship_to   41 SHIP-TO}

      /* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
      {gprun.i ""lactrl.p"" "(output use-log-acctg)"}

      view frame dtitle.
      view frame a.
      view frame ship_from.
      view frame ship_to.
      view frame b.

      display
         global_site @ dss_shipsite
      with frame a.

      if auto_do_proc then do:
         display
            orderNbr @ dss_nbr
            shipSite @ dss_shipsite
         with frame a.
      end.
      else do:
         prompt-for
            dss_nbr
            dss_shipsite
         with frame a
         editing:

            if frame-field = "dss_nbr" then do:
               /* FIND NEXT/PREVIOUS  RECORD */
               {mfnp.i dss_mstr dss_nbr dss_nbr dss_nbr dss_nbr dss_nbr}

               if recno <> ? then do with frame b:

                  {mfaddisp.i dss_rec_site ship_to}
                  {mfaddisp.i dss_shipsite ship_from}

                  display
                     dss_nbr
                     dss_rec_site
                     dss_shipsite
                  with frame a.
                  {&DSDOMT2A-P-TAG4}   /* USED FOR LOCALIZATIONS */

                  display
                     dss_created
                     dss_shipdate
                     dss_due_date
                     dss_po_nbr
                     dss_fob
                     dss_shipvia
                     dss_rmks
                     dsscmmts
                     dss_lang
                     dss_bol
                     dss_status
                  with frame b.

                  if dss_cmtindx <> 0 then
                     display true @ dsscmmts.
               end.
            end.
            else
            /* PREVENT THE USER FROM EXITING THE ORDER NUMBER FIELD WHILE IT  */
            /* IS BLANK AND AUTO NUMBER IS NO IN THE DRP CONTROL FILE.        */
            if frame-field = "dss_shipsite" and input dss_nbr = "" then do:
               find first drp_ctrl no-lock no-error.
               if not available drp_ctrl or not drp_auto_nbr then do:
                  {pxmsg.i &MSGNUM = 40 &ERRORLEVEL = 3} /* BLANK NOT ALLOWED */
                  next-prompt dss_nbr with frame a.
                  undo, retry.
               end.

               {mfnctrl.i drp_ctrl drp_nbr dss_mstr dss_nbr donbr}
               display
                  donbr @ dss_nbr
               with frame a.
            end.
            else if frame-field = "dss_shipsite" then do:

               /* FIND NEXT/PREVIOUS  RECORD */
               {mfnp01.i dss_mstr dss_shipsite dss_shipsite dss_nbr donbr
                  dss_nbr}


               if recno <> ? then do:
                  display
                     dss_shipsite
                  with frame a.
                  {mfaddisp.i dss_shipsite ship_from}
               end.
            end.
            else do:
               readkey.
               apply lastkey.
            end.
         end. /* PROMPT-FOR EDITING BLOCK */

         l_shipsite  = input dss_shipsite.
      end.   /*ELSE DO (AUTO_DO_PROC) */

      if not auto_do_proc then do:
         if input dss_nbr = "" then do:
            find first drp_ctrl no-lock no-error.
            if not available drp_ctrl or not drp_auto_nbr then do:
               {pxmsg.i &MSGNUM = 40 &ERRORLEVEL = 3} /* BLANK NOT ALLOWED */
               undo, retry.
            end.

            run getNextDO (input-output donbr).
         end.
         else
            donbr = input dss_nbr.

         find si_mstr no-lock where si_site = input dss_shipsite no-error.
         if not available si_mstr then do:

            if input dss_shipsite = "" then
               display
                  global_site @ dss_shipsite
               with frame a.

            find si_mstr no-lock where si_site = global_site no-error.
            if not available si_mstr then do:
               {pxmsg.i &MSGNUM = 708 &ERRORLEVEL = 3} /* SITE DOES NOT EXIST */
               next-prompt dss_shipsite with frame a.
               undo, retry.
            end.
         end.

         /* CHECK SITE SECURITY */
         if available si_mstr then do:
            {gprun.i ""gpsiver.p""
               "(input si_site, input recid(si_mstr), output return_int)"}
         end.
         else do:
            {gprun.i ""gpsiver.p""
               "(input (input dss_shipsite), input ?, output return_int)"}
         end.

         if return_int = 0 then do:
            /*USER DOES NOT HAVE ACCESS TO THIS SITE */
            {pxmsg.i &MSGNUM = 725 &ERRORLEVEL = 3}
            next-prompt dss_shipsite with frame a.
            undo mainloop, retry.
         end.
      end. /* IF not auto_do_proc */

   end.  /* TRANSACTION */

   do transaction on error undo, retry:

      if auto_do_proc then
         run find_dss_mstr
            (input orderNbr,
             input shipSite,
             output got_dss_mstr).
      else
         run find_dss_mstr
            (input donbr,
             input l_shipsite,
             output got_dss_mstr).

      if not got_dss_mstr then do:

         clear frame ship_from no-pause.
         clear frame ship_to no-pause.
         clear frame b no-pause.

         {pxmsg.i &MSGNUM = 1 &ERRORLEVEL = 1}   /* ADDING NEW RECORD */

         find first drp_ctrl no-lock no-error.
         dsscmmts = drp_dcmmts.

         if auto_do_proc then
            run create_dss_mstr
               (input orderNbr,
                input shipSite).
         else
            run create_dss_mstr
               (input donbr,
                input l_shipsite).

         new_order = true.

         dss_recid = recid(dss_mstr).

         /* SHIP-TO SITE */
         if auto_do_proc then do:
            dss_rec_site = recSite.
            {&DSDOMT2A-P-TAG5}   /* USED FOR LOCALIZATIONS */
            display
               dss_rec_site
            with frame a.

            {mfaddisp.i dss_rec_site ship_to}
         end.
         else do:
            run get_rec_site.
            if not continue then
               undo mainloop, retry.
         end.

      end. /* IF got_dss_mstr */

      else do:
         new_order = false.

         clear frame ship_from no-pause.
         clear frame ship_to no-pause.
         clear frame b no-pause.

         find dss_mstr where recid(dss_mstr) = dss_recid
            exclusive-lock no-error.
         {mfaddisp.i dss_shipsite ship_from}
         {mfaddisp.i dss_rec_site ship_to}

         /* CHECK FOR COMMENTS*/
         if dss_cmtindx <> 0 then
            dsscmmts = yes.
         else
            dsscmmts = no.

      end.

      recno = recid(dss_mstr).

      display
         dss_nbr
         dss_shipsite
         dss_rec_site
      with frame a.

      {&DSDOMT2A-P-TAG6}   /* USED FOR LOCALIZATIONS */
      display
         dss_created
         dss_shipdate
         dss_due_date
         dss_po_nbr
         dss_fob
         dss_shipvia
         dss_rmks
         dsscmmts
         dss_lang
         dss_bol
         dss_status
      with frame b.

      {mfaddisp.i dss_shipsite ship_from}

      assign dss_shipsite.

      assign
         global_addr = dss_rec_site
         global_site = dss_shipsite
         go_back_to_main = false
         undo-all = true
         dss_recno = recid(dss_mstr).

      {gprun.i ""dsdomta.p"" }

      /* go_back_to_main IS SET to TRUE in dsdomta.p WHEN A D/O IS DELETED */

      /* WHEN A D/O IS DELETED OR undo-all IS TRUE, CONTROL SHOULD BE      */
      /* RETURNED TO THE D/O PROCESSING SCREEN IF THIS PROGRAM WAS CALLED  */
      /* FROM THE D/O PROCESSING SCREEN (auto_do_proc).                    */

      if go_back_to_main then
         if auto_do_proc then
            leave mainloop.
         else
            next mainloop.

      if undo-all then
         if auto_do_proc then
            undo mainloop, leave mainloop.
         else
            undo mainloop, next mainloop.

      /* COMMENTS */
      assign
         global_lang = dss_lang
         global_type = "".

      if dsscmmts then do:
         assign
            cmtindx = dss_cmtindx
            global_ref = dss_rec_site.
         {gprun.i ""gpcmmt01.p"" "(input ""dss_mstr"")"}
         dss_cmtindx = cmtindx.
      end.
   end.   /* TRANSACTION */

   hide frame b no-pause.
   hide frame ship_to no-pause.
   hide frame ship_from no-pause.

   /* LINE ITEMS */
   form
      space(1)
      ds_req_nbr attr-space
      ds_part
      pt_desc1
      ds_qty_ord
      pt_um
   with frame c width 80 no-attr-space.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame c:handle).

   view frame c.
   view frame d.

   loopc:
   repeat with frame c:

      hide frame e.

      do transaction on error undo, retry:
         last_dsline = 0.

         prompt-for ds_req_nbr with frame c
         editing:

            {mfnp05.i ds_det ds_nbr
               "ds_nbr = dss_nbr and ds_shipsite = dss_shipsite
                                 and ds_site = dss_rec_site"
                ds_req_nbr "input ds_req_nbr"}

            if recno <> ? then do:
               find pt_mstr no-lock where pt_part = ds_part no-error.
               display ds_req_nbr ds_part ds_qty_ord.

               if available pt_mstr then
                  display pt_desc1 pt_um.
               else
                  display "" @ pt_desc1 "" @ pt_um.

               detail_all = no.

               /* SEE IF ANY DETAIL ALLOCATIONS EXIST */
               if can-find (first lad_det where lad_dataset = "ds_det"
               and lad_nbr = ds_req_nbr
               and lad_line = ds_site
               and lad_part = ds_part
               and lad_site = ds_shipsite) then
                  detail_all = yes.

               display
                  ds_qty_conf
                  ds_qty_all
                  ds_qty_pick
                  ds_qty_ship
                  ds_trans_id
                  ds_shipdate
                  detail_all
                  ds_due_date
                  ds_git_site
                  ds_project
                  ds_order_category
                  ds_fr_list
                  true when (ds_cmtindx <> 0) @ ds-cmmts
                  false when (ds_cmtindx = 0) @ ds-cmmts
               with frame d.

            end.   /* IF RECNO <> ? */
         end.   /* PROMPT-FOR EDITING */

         if input ds_req_nbr = "" then do:
            for first drp_ctrl no-lock: end.
            if available drp_ctrl then do:
               if not drp_auto_req then do:
                  /* BLANK NOT ALLOWED */
                  {pxmsg.i &MSGNUM = 40 &ERRORLEVEL = 3}
                  undo, retry.
               end.

               /* GET NEXT REQ NBR FROM CTRL FILE */
               {mfnctrl.i drp_ctrl
                  drp_req_nbr ds_det ds_req_nbr req_nbr}
            end.

            if req_nbr = "" then do:
               /* BLANK NOT ALLOWED */
               {pxmsg.i &MSGNUM = 40 &ERRORLEVEL = 3}
               undo, retry.
            end.

            display req_nbr @ ds_req_nbr.
         end. /* IF INPUT DS_REQ_NBR..*/
      end. /* TRANSACTION  */

      do transaction on error undo loopc, retry loopc:
         find ds_det exclusive-lock using ds_req_nbr
            where ds_nbr = dss_nbr
            and ds_shipsite = dss_shipsite
            and ds_site = dss_rec_site
            use-index ds_req_nbr no-error.

         if not available ds_det then
            find ds_det exclusive-lock using ds_req_nbr
               where ds_nbr = ""
               and ds_shipsite = dss_shipsite
               and ds_site = dss_rec_site
               use-index ds_req_nbr no-error.

         if not available ds_det then do:
            find ds_det no-lock using ds_req_nbr
               where ds_site = dss_rec_site
               and ds_shipsite = dss_shipsite
               use-index ds_req_nbr no-error.

            if available ds_det then do:
               /* REQUISITION ALREADY ATTACHED TO DISTRIBUTION ORDER # */
               {pxmsg.i &MSGNUM = 1610 &ERRORLEVEL = 3
                        &MSGARG1 = ds_nbr
                        &MSGARG2 = """"
                        &MSGARG3 = """"}
               undo, retry.
            end.

            find first ds_det no-lock using ds_req_nbr
               use-index ds_req_nbr no-error.

            /* CREATE INTERSITE REQUEST */
            if not available ds_det then do:
               assign
                  err-flag = 0
                  detail_all = no
                  req_nbr = input ds_req_nbr.

               clear frame c no-pause.
               clear frame d no-pause.

               display req_nbr @ ds_req_nbr.

               /* CREATING INTERSITE REQUEST */
               {pxmsg.i &MSGNUM = 4557 &ERRORLEVEL = 1}
               create ds_det.
               assign
                  ds_req_nbr  = req_nbr
                  ds_site     = dss_rec_site
                  ds_shipsite = dss_shipsite
                  ds_due_date = today
                  ds_git_site = ds_site
                  ds_status   = "A"
                  ds_shipdate = today
                  ds_per_date = today
                  ds_fr_list  = dss_fr_list
                  ds_nbr      = dss_nbr.

               /* FIND THE LINE NUMBER (ds_line) FOR THE LAST REQ ATTACHED  */
               do for dsdet:
                  for last dsdet fields(ds_nbr ds_shipsite ds_line)
                      where dsdet.ds_nbr = dss_nbr
                      and dsdet.ds_shipsite = dss_shipsite
                  no-lock
                  use-index ds_nbr:
                     last_dsline = dsdet.ds_line + 1.
                  end.

                  if not available dsdet then
                     last_dsline = 1.
               end. /* DO FOR dsdet */

               ds_line = last_dsline.

               if recid(ds_det) = -1 then .

               update ds_part.

               for first pt_mstr
                  fields (pt_desc1 pt_um pt_loc pt_fr_class
                          pt_ship_wt pt_ship_wt_um)
                  where pt_part = ds_part no-lock:
               end.

               /* INITIALIZE FREIGHT VALUES */
               if available pt_mstr then do:
                  assign
                     ds_fr_class = pt_fr_class
                     ds_fr_wt_um = pt_ship_wt_um.

                  if calc_fr then
                     ds_fr_wt = pt_ship_wt.
               end. /* IF AVAILABLE pt_mstr */

               display
                  ds_part
                  pt_desc1
                  pt_um.

               update ds_qty_ord.
               display ds_qty_ord.

               assign
                  ds_qty_conf = ds_qty_ord
                  qty_ord     = ds_qty_ord
                  order_date  = today
                  ds_loc      = pt_loc
                  rcpt_loc    = ""
                  sales_job   = "".

               for first in_mstr fields (in_loc) where in_part = ds_part
                     and in_site = ds_shipsite no-lock:
                  if in_loc <> "" then
                     ds_loc   = in_loc.
               end.

               /* FIND OUT IF WE NEED TO CHANGE DATABASES FOR THE      */
               /* RECEIVING SITE                                       */
               ds_db = global_db.

               for first si_mstr fields(si_db) no-lock
                     where si_site = ds_site:
               end.

               change_db = (si_db <> ds_db).

               if change_db then do:
                  /* SWITCH TO THE RECEIVING SITE DB */
                  {gprun.i ""gpalias3.p"" "(input si_db, output err-flag)"}

                  /* IF THE RECEIVING SITE DB IS NOT AVAILABLE, UNDO AND*/
                  /* LEAVE THE DETAIL LOOP.                             */
                  if err-flag <> 0 then do:
                     /* DATABASE NOT AVAILABLE */
                     {pxmsg.i &MSGNUM = 2510 &ERRORLEVEL = 4
                              &MSGARG1 = si_db
                              &MSGARG2 = """"
                              &MSGARG3 = """"}
                     undo loopc, leave loopc.
                  end.
               end.

               /* GET DEFAULT RECEIPT LOCATION FROM THE RCV'ING SITE */
               {gprun.i ""dsdomt2b.p""
                        "(input  ds_part,
                          input  ds_site,
                          output rcpt_loc)"}

               if change_db then do:
                  /* SWITCH DATABASE ALIAS BACK TO ORIGINAL SITE DB  */
                  {gprun.i ""gpalias3.p"" "(input ds_db, output err-flag)"}

                  /* IF ORIGINAL SITE DB (SHIPPING SITE DB) IS NOT   */
                  /* AVAILABLE WHILE SWITCHING BACK THEN UNDO, LEAVE */
                  /* THE UPDATE LOOP.                                */
                  if err-flag <> 0 then do:
                     /* DATABASE NOT AVAILABLE */
                     {pxmsg.i &MSGNUM = 2510 &ERRORLEVEL = 4
                              &MSGARG1 = ds_db
                              &MSGARG2 = """"
                              &MSGARG3 = """"}
                     undo loopc, leave loopc.
                  end.
               end.

               do on error undo, retry with frame e
                  on endkey undo loopc, retry loopc:

                  display
                     ds_status
                  with frame e.

                  update
                     order_date
                     sales_job
                     rcpt_loc
                  with frame e.
               end.

               hide frame e.

               /* DETERMINE IF SUPPLIER PERFORMANCE IS INSTALLED */
               if can-find (mfc_ctrl where
                  mfc_field = "enable_supplier_perf" and mfc_logical) and
                  can-find (_File where _File-name = "vef_ctrl") then do:

                  /* IF SUPPLIER PERFORMANCE IS INSTALLED CALL A SUB- */
                  /* PROGRAM TO POP-UP SUPPLIER PERFORMANCE WINDOW TO */
                  /* GATHER PERFORMANCE DATE AND SUBCONTRACT TYPE     */
                  {gprunmo.i &program =""dsdmve.p"" &module = "ASP"
                             &param = """(input ?,
                                          input recid(ds_det))"""}
               end.
            end.   /* IF NOT AVAIL ds_det */
            else do:
               if dss_shipsite <> ds_shipsite then do:
                  /* REQUISITION SHIPPING SITE # */
                  {pxmsg.i &MSGNUM = 1611 &ERRORLEVEL = 3
                           &MSGARG1 = ds_shipsite
                           &MSGARG2 = """"
                           &MSGARG3 = """"}
                  undo, retry.
               end.

               /* REQUISITION DESTINATION SITE # */
               {pxmsg.i &MSGNUM = 1612 &ERRORLEVEL = 3
                        &MSGARG1 = ds_site
                        &MSGARG2 = """"
                        &MSGARG3 = """"}
               undo, retry.
            end.
         end.   /* IF NOT AVAIL ds_det */

         prev_qty_all = ds_qty_all + ds_qty_pick.

         find pt_mstr no-lock where pt_part = ds_part no-error.
         display
            ds_req_nbr
            ds_part
            ds_qty_ord.

         if available pt_mstr then
            display
               pt_desc1
               pt_um.

         if ds_nbr = "" then do:
            /* FIND THE LINE NUMBER (ds_line) FOR THE LAST REQ ATTACHED  */
            do for dsdet:
               for last dsdet fields(ds_nbr ds_shipsite ds_line)
                   where dsdet.ds_nbr = dss_nbr
                   and dsdet.ds_shipsite = dss_shipsite
               no-lock
               use-index ds_nbr:
                  last_dsline = dsdet.ds_line + 1.
               end.

               if not available dsdet then
                  last_dsline = 1.
            end. /* DO FOR dsdet */

            /* ATTACHING REQUISITION TO DIST ORDER */
            {pxmsg.i &MSGNUM = 1601 &ERRORLEVEL = 1}
            assign
               ds_fr_list = dss_fr_list
               ds_line = last_dsline
               ds_nbr = dss_nbr.

         end. /* IF ds_nbr = "" */

         assign
            ststatus = stline[2]
            detail_all = no.
         status input ststatus.

         /* SEE IF ANY DETAIL ALLOCATIONS EXIST */
         if can-find (first lad_det where lad_dataset = "ds_det"
         and lad_nbr  = ds_req_nbr
         and lad_line = ds_site
         and lad_part = ds_part
         and lad_site = ds_shipsite) then
            detail_all = yes.

         display
            ds_qty_conf
            ds_qty_all
            ds_qty_pick
            ds_qty_ship
            ds_trans_id
            ds_shipdate
            detail_all
            ds_due_date
            ds_git_site
            ds_project
            ds_order_category
            ds_fr_list
            true when  (ds_cmtindx <> 0) @ ds-cmmts
            false when (ds_cmtindx = 0)  @ ds-cmmts
         with frame d.

         do on error undo, retry with frame d:

            l_prev_ds_status = ds_status.
            run get_ds_open_qty (buffer ds_det,
                                 output l_prev_ds_qty).

            del-yn = no.

            set
               ds_qty_conf
               ds_qty_all
               detail_all
               ds_trans_id
               ds_shipdate
               ds_git_site
               ds_project
               ds_order_category
               ds_fr_list when (use-log-acctg)
               ds-cmmts
            go-on ("F5" "CTRL-D")
            with frame d.

            /* DELETE */
            if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
               del-yn = yes.

               /* PLEASE CONFIRM DELETE */
               {pxmsg.i &MSGNUM = 11 &ERRORLEVEL = 1
                        &CONFIRM = del-yn
                        &CONFIRM-TYPE = 'LOGICAL'}
               if not del-yn then
                  undo, retry.
            end.

            /* DELETING IN THIS PROGRAM AT THIS POINT MEANS TO DETACH, THE   */
            /* INTERSITE REQUEST FROM THE DISTRIBUTION ORDER.                */
            if del-yn then do:
               if ds_qty_pick <> 0 or ds_qty_ship <> 0 then do:
                  /* CANNOT DELETE NON-ZERO QTY PICKED OR SHIPPED*/
                  {pxmsg.i &MSGNUM = 978 &ERRORLEVEL = 3}
                  undo, retry.
               end.

               /* SET ds_line TO ZERO WHEN DELETING REQUISTION FROM THE ORDER */
               assign
                  ds_nbr = ""
                  ds_line = 0.

               /* REQUISITION DELETED FROM DIST ORDER */
               {pxmsg.i &MSGNUM = 1602 &ERRORLEVEL = 1}

               /* RESET REQUISITION STATUS BACK TO EXPLODED AFTER DETACHING */
               if ds_qty_all = 0 and ds_qty_pick = 0 then
                  ds_status = "E".

               clear frame d no-pause.
               clear frame c no-pause.

            end.
            else do:
               assign
                  global_lang = dss_lang
                  global_type = ""
                  ds_recno = recid(ds_det).

               /* VALIDATE ds_order_category AGAINST GENERALIZED CODES */
               if ds_order_category <> "" then do:
                  if not ({gpcode.v ds_order_category "line_category"})
                     then do:
                     {pxmsg.i &MSGNUM = 716 &ERRORLEVEL = 3}
                    /* VALUE MUST EXIST IN GENERALIZED CODES */
                     next-prompt ds_order_category with frame d.
                     undo, retry.
                  end. /* IF NOT gpcode.v ds_order_category */
               end. /* IF ds_order_category <> "" */

               /* VALIDATE FREIGHT PARAMETERS */
               if use-log-acctg and ds_fr_list <> "" then do:
                  {gprunmo.i  &module = "LA" &program = "dsdofrt.p"
                              &param = """(buffer dss_mstr,
                                           buffer ds_det,
                                           input pt_um,
                                           output err_nbr,
                                           output severity,
                                           output err_arg1,
                                           output err_arg2,
                                           output err_arg3)"""}

                  if err_nbr <> 0 then do:
                     {pxmsg.i &MSGNUM  = err_nbr &ERRORLEVEL = severity
                              &MSGARG1 = err_arg1
                              &MSGARG2 = err_arg2
                              &MSGARG3 = err_arg3}
                     next-prompt ds_fr_list with frame d.
                     if severity = 3 or severity = 4 then
                        undo, retry.
                     else if not (batchrun or {gpiswrap.i}) then pause.
                  end.
               end.  /* use-log-acctg */

               if not can-find(first tm_mstr where tm_code = ds_trans_id)
               and can-find(first tm_mstr where tm_code >= "")
               and ds_trans_id <> "" then do:
                  /* TRANSPORTATION MASTER DOES NOT EXIST */
                  {pxmsg.i &MSGNUM = 1503 &ERRORLEVEL = 3}
                  next-prompt ds_trans_id with frame d.
                  undo, retry.
               end.


               /* INVENTORY ALLOCATIONS */
               {gprun.i ""dsdoall.p""
                        "(input detail_all,
                          input (if ds_qty_conf entered then true
                                 else false),
                          input prev_qty_all)"}

               /* TO CHECK QTY CONFIRMED IS NOT LESS THAN ALLOCATED + */
               /* PICKED + SHIPPED FOR GENERAL AND DETAIL ALLOCATION */

               if ((ds_qty_all + ds_qty_pick + ds_qty_ship > ds_qty_conf )or
                  ((totpkqty + totallqty > ds_qty_conf) and
                  (totpkqty    <> 0 or
                   totallqty   <> 0 )))
               then do:
                  /* QTY CONFIRMED CANNOT BE < ALLOC + PICKED + SHIPPED */
                  {pxmsg.i &MSGNUM = 4576 &ERRORLEVEL = 3}
                  next-prompt ds_qty_conf.
                  undo, retry.
               end. /* IF ds_qty_conf < ds_qty_all */

               if ds-cmmts then do:
                  assign
                     cmtindx = ds_cmtindx
                     global_ref = ds_part.

                  /* ENTER COMMENTS */
                  {gprun.i ""gpcmmt01.p"" "(input ""ds_det"")"}
                  ds_cmtindx = cmtindx.

                  view frame a.
                  view frame c.
                  view frame d.
               end.

               if ds_qty_ord >= 0 then
                  open_qty = max(ds_qty_conf - max(ds_qty_ship, 0), 0).
               else
                  open_qty = min(ds_qty_conf - min(ds_qty_ship, 0), 0).

               if ds_status <> "C" then
                  ds_status = "A".
               else
                  open_qty = 0.

               /* MRP WORKFILE UPDATE */
               {mfmrw.i "ds_det"
                  ds_part
                  ds_req_nbr
                  ds_shipsite
                  ds_site
                  ?
                  ds_shipdate
                  open_qty
                  "DEMAND"
                  INTERSITE_DEMAND
                  ds_shipsite}

            end.   /* ELSE del-yn */

            /* UPDATE in_qty_req */
            if del-yn = no  and ds_status <> "C" then do:
               run update_in_qty_req
                  (input l_prev_ds_status,
                   input l_prev_ds_qty,
                   input ds_status,
                   input open_qty,
                   input ds_part,
                   input ds_shipsite).
            end. /* IF del-yn ... */

            assign
               ds_recno = recid(ds_det)
               ds_db    = global_db
               undo-all = true.

            run set_git_acct (input recid(ds_det)).

            /* UPDATE dsd_det RECORD FOR REQUESTING SITE */
            {gprun.i ""dsdmmtv1.p""}

            if undo-all then
               undo.

         end. /* DO ON ERROR ... */
      end. /* TRANSACTION  */
   end. /* REPEAT WITH FRAME C*/

   if use-log-acctg     and
      dss_fr_list <> "" and
      dss_fr_terms <> "" and
      can-find (first ds_det where ds_nbr = dss_nbr and ds_fr_list <> "" )
   then do transaction on error undo, retry:

      for first ft_mstr
         fields (ft_lc_charge ft_accrual_level)
         where ft_terms = dss_fr_terms
      no-lock:

         if (ft_accrual_level = {&LEVEL_Shipment} or
             ft_accrual_level = {&LEVEL_Line})
         then do:

            hide frame c.

            /* DISPLAY LOGISTICS CHARGE CODE DETAIL */
            {gprunmo.i  &module = "LA" &program = "laosupp.p"
                        &param = """(input 'ADD',
                                     input '{&TYPE_DO}',
                                     input dss_nbr,
                                     input dss_shipsite,
                                     input ft_lc_charge,
                                     input ft_accrual_level,
                                     input yes,
                                     input yes)"""}
         end. /* IF AVAILABLE ft_mstr */
      end. /* FOR FIRST ft_mstr */

      /* FREIGHT CALCULATION */
      {gprunmo.i  &module = "LA" &program = "dsfrcalc.p"
                  &param = """(input dss_recno)"""}

      /* CREATE TAX RECORDS FOR FREIGHT ACCRUAL */
      {gprunmo.i  &module = "LA" &program = "lafrtax.p"
                  &param  = """(input dss_shipsite,
                                input '{&TYPE_DO}',
                                input (if dss_due_date <> ? then
                                          dss_due_date
                                       else dss_created),
                                input (if dss_due_date <> ? then
                                          dss_due_date
                                       else dss_created),
                                input base_curr,
                                input 1,
                                input 1,
                                input ' ',  /* EX_RATE_TYPE */
                                input 0,    /* EXRU_SEQ */
                                input no)"""}

   end. /* IF use-log-acctg and  */

   {&DSDOMT2A-P-TAG7}
   hide frame c no-pause.

   if auto_do_proc then
      leave mainloop.
end. /* mainloop */

status input.

/***************** INTERNAL PROCEDURES *********************/

PROCEDURE set_git_acct:
   /* -------------------------------------------------------------
      Purpose: This internal procedure gets the GL Goods In Transit
      Account and Cost Center and assigns it to ds_git_acct
      and ds_git_cc.
      ----------------------------------------------------------------*/

   define input  parameter ds_recno  as   recid        no-undo.

   define variable git_acct  like si_git_acct  no-undo.
   define variable git_sub   like si_git_sub   no-undo.
   define variable git_cc    like si_git_cc    no-undo.

   find first ds_det where recid(ds_det) = ds_recno exclusive-lock.

   for first pt_mstr fields(pt_part pt_prod_line)
      where pt_part = ds_part no-lock:
   end.

   if available pt_mstr then do:
      for first pld_det fields(pld_prodline pld_site pld_loc
         pld_inv_acct
         pld_inv_sub
         pld_inv_cc)
         where pld_prodline = pt_prod_line
         and pld_site       = ds_site
         and pld_loc        = ds_trans_id no-lock:
      end.
      if available pld_det and pld_inv_acct <> "" then
         assign
            git_acct = pld_inv_acct
            git_sub  = pld_inv_sub
            git_cc   = pld_inv_cc.
      else do:
         for first pld_det fields(pld_prodline pld_site pld_loc
            pld_inv_acct
            pld_inv_sub
            pld_inv_cc)
            where pld_prodline = pt_prod_line
            and pld_site       = ds_site
            and pld_loc        = "" no-lock:
         end.
         if available pld_det and pld_inv_acct <> "" then
            assign
               git_acct = pld_inv_acct
               git_sub  = pld_inv_sub
               git_cc   = pld_inv_cc.
         else do:
            for first pl_mstr fields(pl_prod_line
               pl_inv_acct
               pl_inv_sub
               pl_inv_cc)
               where pl_prod_line = pt_prod_line no-lock:
            end.
            if available pl_mstr and pl_inv_acct <> "" then
               assign
                  git_acct = pl_inv_acct
                  git_sub  = pl_inv_sub
                  git_cc   = pl_inv_cc.
            else do:
               for first si_mstr fields(si_site
                  si_git_acct
                  si_git_sub
                  si_git_cc)
                  where si_site = ds_site no-lock:
               end.
               if available si_mstr and si_git_acct <> "" then
                  assign
                     git_acct = si_git_acct
                     git_sub  = si_git_sub
                     git_cc   = si_git_cc.
               else do:
                  for first gl_ctrl
                     fields(gl_inv_acct
                     gl_inv_sub
                     gl_inv_cc) no-lock:
                  end.
                  if available gl_ctrl then
                     assign
                        git_acct = gl_inv_acct
                        git_sub  = gl_inv_sub
                        git_cc   = gl_inv_cc.
               end. /* ELSE OF IF AVAILABLE SI_MSTR */

            end. /* ELSE OF IF AVAILABLE PL_MSTR */

         end. /* ELSE OF IF AVAILABLE PLD_DET */

      end. /* ELSE OF IF AVAILABLE PLD_DET */

   end. /* IF AVAILABLE PT_MSTR */

   assign
      ds_git_acct = git_acct
      ds_git_sub  = git_sub
      ds_git_cc   = git_cc.

END PROCEDURE. /* PROCEDURE SET_GIT_ACCT */

PROCEDURE getNextDO:
   /* -------------------------------------------------------------
      Purpose: This internal procedure gets the next Distribution
      Order number from  the control file.
      ----------------------------------------------------------------*/

   define input-output parameter donbr like dss_nbr no-undo.

   {mfnctrl.i drp_ctrl drp_nbr dss_mstr dss_nbr donbr}

   display
      donbr @ dss_nbr
   with frame a.

END PROCEDURE. /* PROCEDURE getNextDO */

PROCEDURE find_dss_mstr:
   /* -------------------------------------------------------------
      Purpose: This internal procedure finds dss_mstr record and
      returns the available status.
      ----------------------------------------------------------------*/

   define input parameter p_nbr like dss_nbr no-undo.
   define input parameter p_shipsite like dss_shipsite no-undo.
   define output parameter got_dss_mstr like mfc_logical no-undo.

   got_dss_mstr = false.

   for first dss_mstr
         where dss_nbr     = p_nbr
         and dss_shipsite  = p_shipsite
   no-lock:
      assign
         dss_recid = recid(dss_mstr)
         got_dss_mstr = true.
   end.

END PROCEDURE. /* PROCEDURE find_dss_mstr */

PROCEDURE create_dss_mstr:
   /* -------------------------------------------------------------
      Purpose: This internal procedure creates dss_mstr record.
      ----------------------------------------------------------------*/

   define input parameter p_nbr like dss_nbr no-undo.
   define input parameter p_shipsite like dss_shipsite no-undo.

   create dss_mstr.
   assign
      dss_nbr = p_nbr
      dss_shipsite = p_shipsite
      dss_created = today
      dss_due_date = today.

   if recid(dss_mstr) = -1 then .

END PROCEDURE. /* PROCEDURE create_dss_mstr */

PROCEDURE get_rec_site:
   /* -------------------------------------------------------------
      Purpose: This internal procedure accepts user input
      for Ship-To/Receiving Site.
      ----------------------------------------------------------------*/

   find dss_mstr where recid(dss_mstr) = dss_recid exclusive-lock.

   continue = false.

   do on error undo, retry:
      prompt-for dss_rec_site with frame a
      editing:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i si_mstr dss_rec_site si_site
            dss_rec_site si_site si_site}

         if recno <> ? then do:
            dss_rec_site = si_site.
            {&DSDOMT2A-P-TAG5}   /* USED FOR LOCALIZATIONS */
            display dss_rec_site with frame a.
            {mfaddisp.i dss_rec_site ship_to}
         end.
      end.

      assign dss_rec_site.

      /* CHECK SITE SECURITY */
      if not {gpsite.v &field = dss_rec_site &blank_ok = no} then do:
         {pxmsg.i &MSGNUM = 708 &ERRORLEVEL = 3} /* SITE DOES NOT EXIST */
         undo, retry.
      end.

      {mfaddisp.i dss_rec_site ship_to}

      continue = true.
   end.  /* ship-to input */
END PROCEDURE. /* PROCEDURE get_rec_site */

/* INCLUDE FILE CONTAINING COMMON PROCEDURES FOR DRP */
{dsopnqty.i}
