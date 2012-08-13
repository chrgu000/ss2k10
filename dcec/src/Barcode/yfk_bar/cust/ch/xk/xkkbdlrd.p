/* kbdlrpd.p - KANBAN DISPATCH LIST PO RELEASE                           */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */

/* Revision: 1.3     BY: Russ Witt     DATE: 06/03/02  ECO: *P07L*  */
/* $Revision: 1.4 $    BY: Julie Milligan     DATE: 01/23/03  ECO: *P0M4*  */
/*------------------------------------------------------------------------
  History
     2004-6-17, Yang Enping, 0003 
        1. Add window date and window time assignment:
            1.1 kanban control item:
            for urgency pick list, the window time is the release time 
            plus urgency lead time; for normal pick list, the window 
            time is the release time plus lead time.

            1.2 no-kanban control item:
            for internal pick list, the window time and the window date
            is read from the interface of create pick list;
            for external pick list, the window time is the contact field
            of P.O., window date is the PO order date.
     2004-6-24, Yang Enping, 0005
        1. Change the suplier field of internal P.L. to the area of target
           location.
-------------------------------------------------------------------------*/
/*V8:ConvertMode=NoConvert                                              */
/*Cai last modified by 05/20/2004*/

/* Last modfied : 12.26.2005      by hou for YFK FIFO                *H01* */


{mfdeclre.i}


{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{pxmaint.i}

/* Define Handles for the programs. */
{pxphdef.i kbtranxr}
/*0003*/ {pxphdef.i xkutlib}

/* End Define Handles for the programs. */

/* KANBAN CONSTANTS */
{kbconst.i}

/* KBKBFRM1.I CONTAIN VARIABLES USED FOR KANBAN FRAMES */
{kbkbfrm1.i}

/* DEFINE DISPATCH LIST TEMP-TABLE TO BE USED  */
{xkkbdltt.i}

define input        parameter pCopyEditedtax  like mfc_logical no-undo.
/*0003* define input-output parameter table          for ttDispList. */

/* NEW SHARED VARIABLES BELOW NEEDED FOR BLANKET PO RELEASE */
define new shared variable rndmthd       like rnd_rnd_mthd.
define new shared variable new_db        like si_db.
define new shared variable old_db        like si_db.
define new shared variable new_site      like si_site.
define new shared variable old_site      like si_site.
define new shared variable blanket       like mfc_logical initial true.
define new shared variable del-yn        like mfc_logical.


define variable poNbrToUse     like pod_nbr     no-undo.
define variable prevRelQty     like pod_qty_chg no-undo.
define variable totalKanbanAmt like pod_qty_chg no-undo.
define variable comment1       as character     no-undo.
define variable podRecid       as recid         no-undo.
define variable poRecid        as recid         no-undo.
define variable ponbr          like po_nbr      no-undo.
define variable ponbrline      like pod_line    no-undo.
define variable errorMsgFound  like msg_nbr     no-undo.
define variable xlotrid        as   rowid       no-undo.
define variable xqty           like ld_qty_oh.

/*0003*----*/
define buffer xkrodPod for pod_det .
/*----*0003*/
/*H01*/
define buffer xlotdet  for xkldlot_det.
/*H01*/

/*Cai*/ DEFINE TEMP-TABLE kbid
/*Cai*/     FIELD id AS INTEGER 
/*Cai*/     FIELD ord AS CHARACTER
/*Cai*/     INDEX id id    .

/*Cai*/ DEFINE TEMP-TABLE bpo
/*Cai*/    FIELD xpo LIKE po_nbr 
/*Cai*/    FIELD part1 AS CHARACTER
/*Cai*/    FIELD qty LIKE pod_qty_chg
/*Cai*/    FIELD pre LIKE pod_qty_chg
/*0003*/   field ttDispListRecordID as recid
           field podRecid as recid
/*Cai*/    INDEX popart xpo part1 .

/* FIRST MAKE A PASS THROUGH TEMP TABLE LOOKING FOR BLANKET PO          */
/* = "-TBD-".  THIS WAS SET AS 'TO BE DETERMINED' BY KBDLRP.P AS NO PO  */
/* WAS SPECIFIED. PO TO USE DETERMINED BY SEARCHING FOR A QUALIFYING    */
/* OPEN BLANKET PO.  IF FOUND UPDATE TEMP TABLE WITH BLANKET            */
/* PO TO USE.   
                                                        */

/*Cai*/ FOR EACH kbid :
/*Cai*/    DELETE kbid .
/*Cai*/ END.

/*Cai*/ FOR EACH bpo :
/*Cai*/    DELETE bpo .
/*Cai*/ END.


for each ttDispList
where ttSourceType = {&KB-SOURCETYPE-SUPPLIER}  and ttBlanketPO = "-TBD-"
use-index suppSource
break by ttSourceType
      by (ttSourceRef1 + ttPart):

   accumulate ttKanbanQuantity (SUB-TOTAL by (ttSourceRef1 + ttPart)).


   if last-of(ttSourceRef1 + ttPart)
   then do:
      totalKanbanAmt = accum SUB-TOTAL
                       by (ttSourceRef1 + ttPart) ttKanbanQuantity.

      if totalKanbanAmt > 0 then do:
         poNbrToUse = "".

         poMstrLoop:
         /* FIND OPEN BLANKET PO */
         for each po_mstr
         fields(po_nbr
                po_vend
                po_release
                po_type
                po_blanket
                po_stat)
         where po_vend = ttSourceRef1
         and   po_release = yes
         and   po_type = "B"
         and   po_stat = ""
         no-lock,
         /*  FIND OPEN POD DETAIL RECORD THAT IS ACTIVE, IN CURRENT DB */
         /*  AND HAS SUFFICIENT QTY TO MEET KANBAN REQUIREMENT */
         each pod_det
         fields(pod_nbr
                pod_status
                pod_po_db
                pod_qty_ord
                pod_rel_qty
                pod_qty_chg)
         where pod_nbr = po_nbr
         and   pod_part = ttPart
         and   pod_site = ttSiteSupermarket
         and   pod_status <> "c"
         and   pod_status <> "x"
         and   pod_po_db = global_db
         and   (pod_qty_ord - pod_rel_qty - pod_qty_chg) >= totalKanbanAmt
         no-lock
         by pod_part by pod_due_date:
            poNbrToUse = po_nbr.

            run postPONbrToTempTable
                (input ttSourceRef1,
                 input ttPart,
                 input poNbrToUse).

            leave poMstrLoop.
         end.  /* poMstrLoop (for each po_mstr...)  */
      end. /* accum sub-total > 0 */
   end.  /* if last-of(ttSuppSource + ttPart)  */
end. /* for each ttDispList */



/* NOW LOOP THROUGH TEMP TABLE AGAIN AND EDIT BLANKET PO NUMBER */
/* IF OK, CREATE ANOTHER RELEASE OF THE BLANKET PO              */

dispListLoop:
for each ttDispList
where ttSourceType = {&KB-SOURCETYPE-SUPPLIER}  and ttBlanketPO <> ""
use-index suppSource
break by ttSourceType
      by (ttSourceRef1 + ttPart):

/*Cai*/ FIND kbid WHERE id = ttid NO-ERROR .
/*Cai*/ IF NOT AVAILABLE kbid THEN DO:
/*Cai*/     CREATE kbid .
/*Cai*/     ASSIGN id = ttid 
/*Cai*/           ord = ttBlanketPO    .
/*Cai*/ END.


   accumulate ttKanbanQuantity (sub-total by (ttSourceRef1 + ttPart)).

   if  last-of(ttSourceRef1 + ttPart)
   then do:

      totalKanbanAmt = accum SUB-TOTAL
                       by (ttSourceRef1 + ttPart) ttKanbanQuantity.

      if totalKanbanAmt > 0 then do:

         /* VALIDATE BLANKET PO IS OK TO USE */
         poNbrToUse = "".

         /* IF STILL 'TO BE DETERMINED', BLANKET PO WASN'T FOUND */
         if ttBlanketPO <> "-TBD-" then do:
             /* FIND VALID OPEN BLANKET PO */
            for first po_mstr
            fields(po_nbr
                   po_vend
                   po_release
                   po_type
                   po_blanket
                   po_stat)
            where po_nbr  = ttBlanketPO
            and   po_vend = ttSourceRef1
            and   po_release = yes
            and   po_type = "B"
            and   po_stat = ""
            no-lock:  end.

            if available po_mstr then do:
               /*  FIND OPEN POD DETAIL RECORD THAT IS ACTIVE, IN CURRENT DB */
               /*  AND HAS SUFFICIENT QTY TO MEET KANBAN REQUIREMENT */
               podDetLoop:
               for each pod_det
               fields(pod_nbr
                      pod_status
                      pod_po_db
                      pod_qty_ord
                      pod_rel_qty
                      pod_qty_chg)
               where pod_nbr = po_nbr
               and   pod_part = ttPart
               and   pod_site = ttSiteSupermarket
               and   pod_status <> "c"
               and   pod_status <> "x"
               and   pod_po_db = global_db
               and   (pod_qty_ord - pod_rel_qty - pod_qty_chg) >= totalKanbanAmt
               no-lock
               by pod_nbr by pod_due_dat:
                  /* STORE RECID SO RECORD CAN EASILY BE REREAD IN EXCLUSIVE */
                  /* LOCK MODE  */
                  assign
                     poRecid = recid(po_mstr)
                     podRecid = recid(pod_det)
                     poNbrToUse = po_blanket .

                  leave podDetLoop.
               end.  /* podDetLoop (for each pod_det...)  */
            end.  /* if available po_mstr  */
         end. /* ttBlanketPO <> "TBD" */

         /* IF NOT FOUND, CREATE ERROR COMMENT          */
         if poNbrToUse = "" then do:
            if not available po_mstr then do:
               /* NO QUALIFYING BLANKET PO FOUND */
               {pxmsg.i &MSGNUM=5294 &ERRORLEVEL=1
                        &MSGBUFFER=comment1}
            end.
            else do:
               /* NO QUALIFYING BLANKET PO LINE FOUND */
               {pxmsg.i &MSGNUM=5553 &ERRORLEVEL=1
                        &MSGBUFFER=comment1}
            end.

            run postCommentToTempTable
                (input ttSourceRef1,
                 input ttPart,
                 input comment1).

            next dispListLoop.
         end.  /* if poNbrToUse = "" */

         /* CREATE BLANKET PO RELEASE NOW */
         /* FIRST, RETRIEVE THE POD_DET RECORD AND SAVE THE CURRENT     */
         /* QTY TO RELEASE.  SET QUANTITY TO RELEASE TO THE TOTAL       */
         /* KANBAN QUANTITY NEEDED, THEN RESET SAVED VALUE WHEN DONE    */
         for first pod_det 
         where recid(pod_det) = podRecid 
         exclusive-lock: 

/*Cai*/    FIND FIRST bpo WHERE xpo = pod_nbr AND part1 = pod_part NO-ERROR .
/*Cai*/    IF NOT AVAILABLE bpo THEN DO:
/*Cai*/       CREATE bpo .
/*Cai*/       xpo = pod_nbr .
/*Cai*/       part1 = pod_part .
/*Cai*/       pre =  pod_qty_chg .
/*Cai*/       qty = qty + totalKanbanAmt .
              /*0003*----*/
              bpo.ttDispListRecordID = recid(ttDispList) .
              bpo.podRecid = recid(pod_det) .
              /*----*0003*/
/*Cai*/    END.
/*Cai*/    ELSE qty = qty + totalKanbanAmt .


/*Cai*/    ponbr = pod_nbr .



            /* If no errors found, post new po number to temp table */
            /* else post error message found to temp table          */
            if errorMsgFound = 0 then do:
               comment1 = getTermLabel("RELEASE_TO_PO",20) + ": " + ponbr.
            end.
            else do:
               {pxmsg.i &MSGNUM=errorMsgFound &ERRORLEVEL=1
                        &MSGBUFFER=comment1}
            end.
            run postCommentToTempTable
                (input ttSourceRef1,
                 input ttPart,
                 input comment1).

         end. /* for first pod_det */
      end.  /* accum sub-total > 0 */
   end.  /* if last-of(ttSuppSource + ttPart)  */
end. /* for each ttDispList */



/*Cai -Add PO Release Logical Begin*/
FOR EACH bpo:
    FIND FIRST pod_det WHERE pod_nbr = xpo AND pod_part = part1 .
    pod_qty_chg = qty .

END.

FOR EACH bpo BREAK BY xpo:
    IF FIRST-OF(xpo) THEN DO:

        FIND po_mstr WHERE po_nbr = xpo .
        poRecid = recid(po_mstr).
        {gprun.i ""poblrel1.p""
                 "(input poRecid,
                   input pCopyEditedtax,
                   input no,
                   input today,
                   output ponbr,
                   output errorMsgFound)"}.
        FOR EACH kbid WHERE ord = xpo :
            FIND knbd_det WHERE knbd_id = id NO-ERROR .
            IF AVAILABLE knbd_det THEN knbd_user1 = ponbr .
            FIND ttDispList WHERE ttid = id .
            FIND po_mstr WHERE po_nbr = ponbr .
            po__log01 = tturgent .
            DELETE kbid .
        END.
        FIND po_mstr WHERE po_nbr = ponbr .
        CREATE xkro_mstr .
        ASSIGN xkro_nbr = ponbr 
            xkro_ord_date = TODAY
            xkro_ord_time = TIME
            xkro_user = global_userid
            xkro_supplier = po_vend 
            xkro_print = yes 
            xkro_urgent = po__log01
            xkro_type = "P" .
        FIND ad_mstr WHERE ad_addr = xkro_supplier NO-LOCK NO-ERROR .

        /*0003*----assign window time*/
        find first ttDispList no-lock
        where recid(ttDispList) = bpo.ttDispListRecordID .

        assign xkro_due_date = ttDispList.ttWindowDate
               xkro_due_time = ttDispList.ttWindowTime .

        if xkro_urgent then do:
           {pxrun.i &PROC ='createPLUrgentFlag'
                    &PROGRAM='xkutlib.p'
                    &HANDLE=ph_xkutlib
                    &PARAM="(
                             input xkro_nbr
                            )"
           }
        end .
        /*----*0003*/

        IF AVAILABLE ad_mstr THEN xkro_dsite = ad_coc_reg .

        /*0003*----
        FOR EACH pod_det WHERE pod_nbr = ponbr:
            CREATE xkrod_det .
            ASSIGN xkrod_nbr = ponbr 
                xkrod_line = pod_line
                xkrod_part = pod_part
                xkrod_qty_ord = pod_qty_ord
                xkrod_type = "P" .

        END.
        ----*0003*/
    END.

    /*0003*----*/
    find first ttDispList no-lock
    where recid(ttDispList) = bpo.ttDispListRecordID .

    find first xkrodPod no-lock
    where xkrodPod.pod_nbr = ponbr
    and xkrodPod.pod_part = bpo.part1
    no-error .
    
    FIND xkrod_det NO-LOCK 
    WHERE xkrod_nbr = ponbr 
    AND xkrod_line = ttLine NO-ERROR.

    IF NOT AVAILABLE xkrod_det THEN DO:
        CREATE xkrod_det .
        ASSIGN xkrod_nbr = ponbr 
            xkrod_line = if ttLine = 0 then 1 else ttLine
            xkrod_part = xkrodPod.pod_part
            xkrod_qty_ord = xkrodPod.pod_qty_ord
            xkrod_type = "P" .
    
        {pxrun.i &PROC ='getItemPackQty'
                 &PROGRAM='xkutlib.p'
                 &HANDLE=ph_xkutlib
                 &PARAM="(
                          true,
                          ttDispList.ttID,
                          """",
                          output xkrod_pack
                          )"
        }
    END.
    /*----*0003*/

END.

FOR EACH bpo:
    FIND FIRST pod_det WHERE pod_nbr = xpo AND pod_part = part1 .
    pod_qty_chg = pre  .
END.



/*Cai -Add PO Release Logical End*/

FOR EACH kbid :
    DELETE kbid .
END.



/*0005*----new logic for internal P.L. creating */

define variable xkrodLineAmt like xkrod_qty_ord .
define variable PLnbr like xkro_nbr .
define variable gotPLnbr as logical .

for each ttDispList
where ttSourceType <> {&KB-SOURCETYPE-SUPPLIER}
break by ttBlanketPO
by ttPart:

    if first-of(ttBlanketPO) then do:
       gotPLnbr = false .
       do while not gotPLnbr:
          FIND FIRST CODE_mstr WHERE CODE_fldname = "ronbr" NO-ERROR .
          IF NOT AVAILABLE CODE_mstr THEN DO:
             CREATE CODE_mstr .
             ASSIGN CODE_fldname = "ronbr"
                    CODE_value = "T"
                    CODE_cmmt = "1" .
          END.
          PLnbr = TRIM(CODE_value) + STRING(INTEGER(CODE_cmmt),"9999999") .

          find first xkro_mstr no-lock
          where xkro_nbr = PLnbr 
          no-error .

          if not available(xkro_mstr) then 
             assign gotPLnbr = true .
          CODE_cmmt = STRING(INTEGER(CODE_cmmt) + 1) .
       end .

       FIND knbsm_mstr no-lock
       WHERE knbsm_site = ttSourceRef1
       AND knbsm_supermarket_id = ttSourceRef2 
       USE-INDEX knbsm_site_id .

       CREATE xkro_mstr .
       
       ASSIGN xkro_nbr = PLnbr
              xkro_ord_date = TODAY
              xkro_ord_time = TIME
              xkro_user = global_userid
              xkro_site = ttSourceRef1
              xkro_loc = knbsm_inv_loc 
              xkro_supplier = ttSourceRef1
/*xwh060216 add source supermaket*/
              xkro__chr01 = ttSourceRef2
              xkro_print = yes 
              xkro_urgent = tturgent
              xkro_type = "T" 
              /*0003*----assign window time*/
              xkro_due_date = ttDispList.ttWindowDate
              xkro_due_time = ttDispList.ttWindowTime .
             /*----*0003*/

       FIND knbsm_mstr no-lock
       WHERE knbsm_site = ttSiteSupermarket 
       AND knbsm_supermarket_id = ttSupermarket_id 
       USE-INDEX knbsm_site_id .

       assign xkro_dsite = ttSiteSupermarket .
              xkro_dloc = knbsm_inv_loc. 
/*xwh060216 add destination supermaket*/
              xkro__chr02 = ttSupermarket_id.
       if xkro_urgent then do:
          {pxrun.i &PROC ='createPLUrgentFlag'
                   &PROGRAM='xkutlib.p'
                   &HANDLE=ph_xkutlib
                   &PARAM="(
                            input xkro_nbr
                           )"
            }
       end .



    end.
 
    accumulate ttKanbanQuantity (SUB-TOTAL by ttPart).

    find first knbd_det exclusive-lock
    where knbd_id = ttID no-error .
    
    if available(knbd_det) then
       assign knbd_user1 = xkro_nbr .

    if last-of(ttPart) then do:
       xkrodLineAmt = accum SUB-TOTAL by ttPart ttKanbanQuantity.

       if xkrodLineAmt > 0 then do:
          FIND knbi_mstr WHERE knbi_part = ttpart .
          FIND knbsm_mstr WHERE knbsm_site = ttSiteSupermarket AND knbsm_supermarket_id = ttSupermarket_id .
          FIND knbism_det WHERE knbism_knbi_keyid = knbi_keyid AND knbism_knbsm_keyid = knbsm_keyid . 

          CREATE xkrod_det .
          ASSIGN xkrod_nbr = xkro_nbr 
                 xkrod_line = if ttLine = 0 then 1 else ttLine
                 xkrod_part = ttpart
                 xkrod_qty_ord = xkrodLineAmt
                 xkrod_type = "T"
                 xkrod_pack = knbism_pack_qty  .

          /*0003*----assign pack quantity*/
          {pxrun.i &PROC ='getItemPackQty'
                   &PROGRAM='xkutlib.p'
                   &HANDLE=ph_xkutlib
                   &PARAM="(
                            true,
                            ttDispList.ttID,
                            """",
                            output xkrod_pack
                           )"
           }
           /*----*0003*/

/*H01**************************************************************          
/*H01* *Add Begin* ************************/ 
          /*Note: Any change made to following code */
          /*      should also made to xkkbrct.p     */
          for each xkldlot_det no-lock where xkldlot_det.xkldlot_part = ttpart
             and xkldlot_det.xkldlot_site = xkro_site and xkldlot_det.xkldlot_loc = xkro_loc
             and (xkldlot_det.xkldlot_qty_oh - xkldlot_det.xkldlot_qty_pick) > 0 by xkldlot_det.xkldlot_lot:
             
             xlotrid = rowid(xkldlot_det).
             xqty = xkldlot_det.xkldlot_qty_oh - xkldlot_det.xkldlot_qty_pick.
             
             if xqty >= xkrodLineAmt then do:
                find xlotdet exclusive-lock where rowid(xlotdet) = xlotrid no-error.
                if avail xlotdet then do:
                   xlotdet.xkldlot_qty_pick = xlotdet.xkldlot_qty_pick + xkrodLineAmt.
                   xkrod_pt_lot = xkrod_pt_lot + xlotdet.xkldlot_lot + "=" + string(xkrodLineAmt).
                   leave.
                end.   
             end.
             else do:
                xkrodLineAmt = xkrodLineAmt - xqty.
                find xlotdet exclusive-lock where rowid(xlotdet) = xlotrid no-error.
                if avail xlotdet then do:
                   xlotdet.xkldlot_qty_pick = xlotdet.xkldlot_qty_oh.
                   xkrod_pt_lot = xkrod_pt_lot + xlotdet.xkldlot_lot + "=" 
                                + string(xlotdet.xkldlot_qty_oh - xlotdet.xkldlot_qty_pick) + "," .
                end.   
             end.
          end.
/*H01* *Add End* ***********************/
*****************************************************************/

       END.  /* if totalKanbanAmt > 0 */
    END.   /* if last of ttPart */
 END. /* for each ttDisplist */

/*----*0005*/

/*0005*---- to remove? */
for each ttDispList use-index suppSource :
        find knbd_det where knbd_id = ttid and knbd_user1 <> "" no-error .
        if available knbd_det then ttComment[1] = getTermLabel("RELEASE_TO",20) + ": " + knbd_user1 .
end.

/* --------------------------------------------------------------------- */
/* ---   I N T E R N A L   P R O C E D U R E S   ----------------------- */
/* --------------------------------------------------------------------- */

/* --------------------------------------------------------------------- */
/* UPDATE PO NBR TO ALL RECORDS IN TEMP TABLE FOR SUPP SOURCE AND PART   */
/* --------------------------------------------------------------------- */
PROCEDURE postPONbrToTempTable:

   define input parameter pSourceRef1   like kbtr_source_ref1 no-undo.
   define input parameter pPart         like pt_part          no-undo.
   define input parameter pPONbrToUse   like po_nbr           no-undo.

   define variable x              as integer       no-undo.

   define buffer ttDispList2 for ttDispList.

   for each ttDispList2
   where ttSourceType = {&KB-SOURCETYPE-SUPPLIER}
   and   ttSourceRef1 = pSourceRef1
   and   ttpart       = pPart
   exclusive-lock:
      ttBlanketPO = pPONbrToUse.
   end.  /* for each ttDispList2 */
END PROCEDURE.   /* postPONbrToTempTable */



/* --------------------------------------------------------------------- */
/* UPDATE COMMENT TO ALL RECORDS IN TEMP TABLE FOR SUPP SOURCE AND PART   */
/* --------------------------------------------------------------------- */
PROCEDURE postCommentToTempTable:

   define input parameter pSourceRef1   like kbtr_source_ref1 no-undo.
   define input parameter pPart         like pt_part          no-undo.
   define input parameter pComment      like Comment1         no-undo.

   define variable x              as integer       no-undo.

   define buffer ttDispList2 for ttDispList.

   for each ttDispList2
   where ttSourceType = {&KB-SOURCETYPE-SUPPLIER}
   and   ttSourceRef1 = pSourceRef1
   and   ttpart       = pPart
   exclusive-lock:
      /* FIND NEXT AVAILABLE COMMENT TO USE */
      if pComment <> "" then do:
         do x = 1 to 10:
            if ttDispList2.ttComment[x] = "" then do:
               ttComment[x] = pComment.
               leave.
            end.
         end.
      end.
   end.  /* for each ttDispList2 */
END PROCEDURE.   /* postCommentToTempTable */
