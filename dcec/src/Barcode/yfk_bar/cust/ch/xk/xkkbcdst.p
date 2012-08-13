/* GUI CONVERTED from kbcdstrp.p (converter v1.76) Thu May  8 16:03:37 2003 */
/* kbcdstrp.p - KANBAN CARD STATUS REPORT                                     */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */

/* $Revision: 1.12 $    BY: Julie Milligan DATE: 11/22/02 ECO: *P0M4*   */

/*V8:ConvertMode=Report                                                       */
/*Cai last modified by 06/16/2004*/
/*------------------------------------------------------------
  File         xkkbcdst.p
  Description  手工选择生成要货单(看板零件)
  Author       Cai Jing
  Created      ?
  History
      2004-6-20, Yang Enping, 0004
         1. the file base the GUI version: xkkbcdst.p

      2004-6-26, Yang Enping, 0006
         1. notify the created P.L. numbers
  -----------------------------------------------------------*/
/* Copy For YFK                     2005.12.21               */
          
          
          {mfdtitle.i "AO"}
          
          {pxmaint.i}
          
          /* Define handles for ROP programs */
          {pxphdef.i gplngxr}
          
          /* Kanban Constants */
          {kbconst.i}
          
          /* Local Variables */
          define variable activeCode        like lngd_mnemonic     no-undo.
          define variable cardType          like lngd_mnemonic     no-undo.
          define variable dummyDesc         like lngd_translation  no-undo.
          define variable card-active       like mfc_logical     no-undo initial yes.
          define variable card-printed      like mfc_logical     no-undo initial yes.
          define variable card-status       as   character format "x(22)" no-undo.
          define variable card-status-desc  as   character   no-undo.
          define variable card-type         as   character   format "x(15)" no-undo.
          define variable kb-source         as   character  LABEL "源" no-undo.
          define variable kb-source1        as   character   no-undo.
          define variable kanban-source     as   character   no-undo.
          define variable prev-site         like si_site   no-undo.
          define variable prev-part         like knbi_part no-undo.
          define variable prev-step         like knbi_step no-undo.
          define variable prev-supermarket  like knbsm_supermarket_id no-undo.
          define variable part              like knbi_part   no-undo.
          define variable part1             like knbi_part   no-undo.
          define variable site              like si_site no-undo.
          define variable site1             like si_site no-undo.
          define variable supermarket       like knbsm_supermarket_id no-undo.
          define variable supermarket1      like knbsm_supermarket_id no-undo.
          define variable ssite             like si_site no-undo label "源地点" .
          define variable ssite1            like si_site no-undo.
          define variable approve           AS   LOGICAL label "确认" initial yes .
          DEFINE VARIABLE bpo               LIKE po_nbr .
          DEFINE VARIABLE bpo1              LIKE po_nbr .

          define variable preTime as int .
          define variable plnbrs as char .

          DEFINE variable xwusrwkfl_recno   AS   RECID.
          DEFINE VARIABLE p                 AS   LOGICAL LABEL "包括已生成要货单" .

          DEFINE NEW SHARED VARIABLE yn     AS   LOGICAL INITIAL YES .

          DEFINE BUFFER  xwusrwwkfl  FOR usrw_wkfl.
          
          define query card-select
             for knbsm_mstr,
                 knb_mstr,
                 knbi_mstr,
                 knbs_det,
                 knbl_det,
                 knbd_det.
          
          define query card-select-part
             for knbi_mstr,
                 knb_mstr,
                 knbsm_mstr,
                 knbs_det,
                 knbl_det,
                 knbd_det.
          
          define query card-select-source
             for knbs_det,
                 knb_mstr,
                 knbsm_mstr,
                 knbi_mstr,
                 knbl_det,
                 knbd_det.
          
          
          
          FORM   
             site           LABEL "地点"        colon 20 
             site1          label {t001.i}      colon 50
             ssite          LABEL "源地点"      colon 20
             ssite1         label {t001.i}      colon 50  skip
             part           LABEL "零件号"      colon 20
             part1          label {t001.i}      colon 50  skip
             supermarket    LABEL "超市代码"    colon 20
             supermarket1   label {t001.i}      colon 50  skip
             kb-source      label "来源"        colon 20
             kb-source1     label {t001.i}      colon 50
             bpo            label "总括订单/组" colon 20
             bpo1           label {t001.i}      colon 50  skip
             approve        LABEL "确认"        colon 20  SKIP
             p COLON 20
             SKIP(0.3)
          with frame a side-labels width 80 attr-space  .
          
          
          /* SET EXTERNAL LABELS */
          setFrameLabels(frame a:handle).
          
          FORM   
             knbsm_site           label "Site"
             knbi_part            label "Item Number"
          with STREAM-IO    frame reportHeader side-labels width 132.
          
          /* SET EXTERNAL LABELS */
          setFrameLabels(frame reportHeader:handle).
          
          FORM   
             knbi_step            column-label "Step"    at 3
             knbsm_supermarket_id column-label "Supermarket"
             kanban-source        column-label "Source"
             knbd_id              column-label "Card Number"
             cardType             column-label "Card Type"
             card-status          column-label "Status"
             kbtr_curr_process_id column-label "From Process"
             knbd_next_process_id column-label "To FIFO"
             knbd_active          column-label "Active"
             activeCode           column-label "Active Code"
             card-printed         column-label "Printed"
          with   frame reportDetail down width 132.
          
          /* SET EXTERNAL LABELS */
          setFrameLabels(frame reportDetail:handle).
          
          {wbrp01.i}    /* General web report setup */ 
          
          mainloop:
          repeat:         /* WITH phrase not allowed here */
          
             VIEW FRAME a .
              
             if site1          = hi_char  then site1  = "".
             if ssite1         = hi_char  then ssite1  = "".
             if part1          = hi_char  then part1  = "".
             if supermarket1   = hi_char  then supermarket1 = "".
             if kb-source1     = hi_char  then kb-source1 = "".
             if bpo1           = hi_char  then bpo1  = "".
          
             /* Begin data entry statement */
          
             if c-application-mode <> 'web' then
                update
                   site
                   site1
                   ssite
                   ssite1
                   part
                   part1
                   supermarket
                   supermarket1
                   kb-source
                   kb-source1
                   bpo
                   bpo1
                   approve
                   p
                with frame a.
          
             {wbrp06.i  &command = update
                               &fields = " site site1 ssite ssite1 part part1 supermarket supermarket1
                                           kb-source kb-source1 approve p"
                        &frm = "a" }
          
             /* Begin batch quoting for batchable reports and postprocessing           */
             /* Of data entry values                                                   */
             if (c-application-mode <> 'web') or
                (c-web-request begins 'data')
             then do:
          
                bcdparm = "".                  /* if batch can be run */
                   {mfquoter.i site}
                   {mfquoter.i site1}
                   {mfquoter.i ssite}
                   {mfquoter.i ssite1}
                   {mfquoter.i part}
                   {mfquoter.i part1}
                   {mfquoter.i supermarket}
                   {mfquoter.i supermarket1}
                   {mfquoter.i kb-source}
                   {mfquoter.i kb-source1}
                   {mfquoter.i bpo}
                   {mfquoter.i bpo1}
                   {mfquoter.i approve}
          
          
             end.  /* if data mode or not web */
          
             /* Assign hi and low criteria ranges */
             if site1          = "" then site1          = hi_char.
             if ssite1         = "" then ssite1         = hi_char.
             if part1          = "" then part1          = hi_char.
             if supermarket1   = "" then supermarket1   = hi_char.
             if kb-source1     = "" then kb-source1     = hi_char.
             if bpo1           = "" then bpo1           = hi_char.
          
             /* VALIDATE SITE SECURITY */
             if not batchrun
             then do:
                {gprun.i ""gpsirvr.p""
                         "(input site, input site1, output return_int)"}
                if return_int = 0
                then do:
                   next-prompt site with frame a.
                   undo, retry.
                end. /* IF return_int = 0 ... */
             end. /* IF NOT batchrun ... */
                    
             for each usrw_wkfl where usrw_key1 = ("emptykb" + mfguser) NO-LOCK:
                xwusrwkfl_recno = RECID(usrw_wkfl).
                FIND xwusrwwkfl WHERE RECID(xwusrwwkfl) =  xwusrwkfl_recno EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE xwusrwwkfl THEN  DELETE xwusrwwkfl.
                RELEASE xwusrwwkfl.
             end .
           
             if site > ""
                or
                site1 < hi_char
                or
                (part = "" and
                 part1 = hi_char and
                 supermarket = "" and
                 supermarket1 = hi_char and
                 kb-source = "" and
                 kb-source1 = hi_char)
             then do:
          
                open query card-select
                   for each knbsm_mstr no-lock where
                      knbsm_site >= site and
                      knbsm_site <= site1 and
                      knbsm_supermarket_id >= supermarket and
                      knbsm_supermarket_id <= supermarket1,
                   each knb_mstr no-lock where
                      knb_knbsm_keyid = knbsm_keyid,
                   each knbi_mstr no-lock where
                      knbi_keyid = knb_knbi_keyid and
                      knbi_part >= part and
                      knbi_part <= part1,
                   each knbs_det no-lock where
                      knbs_keyid = knb_knbs_keyid and
                     ((knbs_source_type = {&KB-SOURCETYPE-SUPPLIER} and
                       knbs_ref1 >= kb-source and
                       knbs_ref1 <= kb-source1)
                           or
                      (knbs_source_type <> {&KB-SOURCETYPE-SUPPLIER} and
                       knbs_ref2 >= kb-source and
                       knbs_ref2 <= kb-source1))
                         and 
                     ((knbs_source_type = {&KB-SOURCETYPE-INVENTORY} and
                       knbs_ref1 >= ssite and
                       knbs_ref1 <= ssite1)
                           or
                      (knbs_source_type <> {&KB-SOURCETYPE-INVENTORY})),
                   each knbl_det no-lock where
                      knbl_knb_keyid = knb_keyid,
                   each knbd_det no-lock where
                      knbd_knbl_keyid = knbl_keyid and
                     (knbd_status = {&KB-CARDSTATE-EMPTYACC} OR knbd_status = {&KB-CARDSTATE-EMPTYAUTH}) and        
                     (knbd_active = if card-active then card-active else knbd_active)
                      AND knbd_active_code = "1"
                   by knbsm_site
                   by knbi_part
                   by knbi_step
                   by knbd_id.
          
                get first card-select.
                assign prev-part = ""
                       prev-site = "".
          
                do while available(knbsm_mstr):
          
                   {gprun.i ""xkplpre.p"" "(knbd_id,approve,no,p)"}
                   
                   {mfrpchk.i}
          
                   get next card-select.
          
                end.  /* do while available(knbsm_mstr) */
          
                /*End report logic*/
                close query card-select.
                
             end. /* site range query */
          
             else if part > ""
                or
                part1 < hi_char
             then do:
          
                open query card-select-part
                   for each knbi_mstr no-lock where
                      knbi_part >= part and
                      knbi_part <= part1,
                   each knb_mstr no-lock where
                      knb_knbi_keyid = knbi_keyid,
                   each knbsm_mstr no-lock where
                      knbsm_keyid = knb_knbsm_keyid and
                      knbsm_site >= site and
                      knbsm_site <= site1 and
                      knbsm_supermarket_id >= supermarket and
                      knbsm_supermarket_id <= supermarket1,
                   each knbs_det no-lock where
                      knbs_keyid = knb_knbs_keyid and
                     ((knbs_source_type = {&KB-SOURCETYPE-SUPPLIER} and
                       knbs_ref1 >= kb-source and
                       knbs_ref1 <= kb-source1)
                           or
                      (knbs_source_type <> {&KB-SOURCETYPE-SUPPLIER} and
                       knbs_ref2 >= kb-source and
                       knbs_ref2 <= kb-source1)) 
                         and                      
                     ((knbs_source_type = {&KB-SOURCETYPE-INVENTORY} and
                       knbs_ref1 >= ssite and
                       knbs_ref1 <= ssite1)
                           or
                       (knbs_source_type <> {&KB-SOURCETYPE-INVENTORY})),
                   each knbl_det no-lock where
                      knbl_knb_keyid = knb_keyid,
                   each knbd_det no-lock where
                      knbd_knbl_keyid = knbl_keyid and
                     (knbd_status = {&KB-CARDSTATE-EMPTYACC} OR knbd_status = {&KB-CARDSTATE-EMPTYAUTH}) and  
                     (knbd_active = if card-active then card-active else knbd_active)
                      AND knbd_active_code = "1"
                   by knbsm_site
                   by knbi_part
                   by knbi_step
                   by knbd_id.
          
                get first card-select-part.
                assign prev-part = ""
                       prev-site = "".
          
                do while available(knbi_mstr):
          
           	       {gprun.i ""xkplpre.p"" "(knbd_id,approve,no,p)"}
          
                   {mfrpchk.i}
          
                   get next card-select-part.
          
                end.  /* do while available(knbi_mstr) */
          
                /*End report logic*/
                close query card-select-part.
                
             end. /* part range query */
          
             else do:
          
                open query card-select-source
                   for each knbs_det no-lock where
                     ((knbs_source_type = {&KB-SOURCETYPE-SUPPLIER} and
                       knbs_ref1 >= kb-source and
                       knbs_ref1 <= kb-source1)
                           or
                      (knbs_source_type <> {&KB-SOURCETYPE-SUPPLIER} and
                       knbs_ref2 >= kb-source and
                       knbs_ref2 <= kb-source1))
                          and 
                     ((knbs_source_type = {&KB-SOURCETYPE-INVENTORY} and
                       knbs_ref1 >= ssite and
                       knbs_ref1 <= ssite1)
                           or
                      (knbs_source_type <> {&KB-SOURCETYPE-INVENTORY})),
                   each knb_mstr no-lock where
                      knb_knbs_keyid = knbs_keyid,
                   each knbsm_mstr no-lock where
                      knbsm_keyid = knb_knbsm_keyid and
                      knbsm_site >= site and
                      knbsm_site <= site1 and
                      knbsm_supermarket_id >= supermarket and
                      knbsm_supermarket_id <= supermarket1,
                   each knbi_mstr no-lock where
                      knbi_keyid = knb_knbi_keyid and
                      knbi_part >= part and
                      knbi_part <= part1,
                   each knbl_det no-lock where
                      knbl_knb_keyid = knb_keyid,
                   each knbd_det no-lock where
                      knbd_knbl_keyid = knbl_keyid and
                     (knbd_status = {&KB-CARDSTATE-EMPTYACC} OR knbd_status = {&KB-CARDSTATE-EMPTYAUTH}) and  
                     (knbd_active = if card-active then card-active else knbd_active)
                      AND knbd_active_code = "1"
                   by knbsm_site
                   by knbi_part
                   by knbi_step
                   by knbd_id.
          
                get first card-select-source.
                assign prev-part = ""
                       prev-site = "".
          
                do while available(knbs_det):
          
           	       {gprun.i ""xkplpre.p"" "(knbd_id,approve,no,p)"}
          
                   {mfrpchk.i}
          
                   get next card-select-source.
          
                end.  /* do while available(knbs_det) */
          
                /*End report logic*/
                close query card-select.
                
             end. /* site range query */
          
             FOR EACH usrw_wkfl WHERE usrw_key1 = ("emptykb" + mfguser) AND 
                 (usrw_charfld[11] < bpo OR usrw_charfld[11] > bpo1) NO-LOCK:
    
                 xwusrwkfl_recno = RECID(usrw_wkfl).
                 FIND xwusrwwkfl WHERE RECID(xwusrwwkfl) =  xwusrwkfl_recno EXCLUSIVE-LOCK NO-ERROR.
                 IF AVAILABLE xwusrwwkfl THEN  DELETE xwusrwwkfl.
                 RELEASE xwusrwwkfl.
    
             END.
          
             {gprun.i ""xkyhd1.p""}
             
             IF yn = ? THEN UNDO mainloop, RETRY mainloop .
             
             {gprun.i ""xkkbauth.p""}
             
             PAUSE 0 .
             
             pretime = time .
             
             {gprun.i ""xkkbdlrp.p"" "(yes)"} 
          
             plnbrs = "" .
             
             for each xkro_mstr no-lock	where xkro_ord_date = today
          	     and xkro_ord_time >= pretime and xkro_ord_time <= time:

                 if plnbrs = "" then plnbrs = xkro_nbr .
          	     else plnbrs = plnbrs + "," + xkro_nbr .

             end .
          	   
             message "生成的要货单: " + plnbrs view-as alert-box information .
          
          end.  /* repeat */
          
          {wbrp04.i &frame-spec = a}
          
