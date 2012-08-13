/* xkyhdclo.p             要货单关闭                         */
/* Modify on 200609-05-09   禁止关闭日程单和协议单           */
       
       DEFINE VARIABLE pnbr AS CHARACTER LABEL "要货单号" .
       DEFINE VARIABLE s AS CHARACTER LABEL "状态x/c" .
       DEFINE VARIABLE yn AS LOGICAL .
       DEFINE VARIABLE xx AS CHARACTER .
       DEFINE NEW SHARED VARIABLE po_recno AS RECID .
       DEFINE NEW SHARED VARIABLE pod_recno AS RECID .
       DEFINE NEW SHARED VARIABLE qty_ord AS DECIMAL .
       DEFINE NEW SHARED VARIABLE del-yn AS LOGICAL.
       DEFINE VARIABLE tempkbid LIKE knbd_id .

         &SCOPED-DEFINE popomtf_p_2 "采购单"
         
{mfdtitle.i "ao "}

/* Kanban Constants */
{kbconst.i}

FORM 
    SKIP(1)
    pnbr COLON 20 
    s    COLON 40
    SKIP(1)
WITH FRAME a WIDTH 80 SIDE-LABELS.

REPEAT:
DO TRANSACTION ON ERROR UNDO, LEAVE : 

    UPDATE pnbr s WITH FRAME a  .

    IF TRIM(s) <> "x" AND TRIM(s) <> "c" THEN DO :
        MESSAGE "状态不符合要求。"  .
        UNDO, RETRY .
    END.

    FIND FIRST po_mstr WHERE po_nbr = pnbr AND po_type <> 'B' AND po_sched = NO NO-LOCK NO-ERROR .
    IF AVAILABLE po_mstr THEN xx = po_stat .
    ELSE DO:
        FIND FIRST xkro_mstr WHERE xkro_nbr = pnbr NO-LOCK NO-ERROR .
        IF AVAILABLE xkro_mstr THEN xx = xkro_status .
        ELSE DO:
            MESSAGE "单号不存在。" .
            UNDO, RETRY .
        END.
    END.
       
    yn = YES .
    MESSAGE "目前状态" xx "   要改变要货单状态为 " s  UPDATE yn .

    IF yn THEN DO:
     
       FOR EACH po_mstr WHERE po_nbr = pnbr AND po_stat = "" :
           po_stat = TRIM(s) .
           po_cls_date = TODAY .

           FOR EACH pod_det WHERE pod_nbr = pnbr AND pod_status = "" :
               pod_status = TRIM(s) .
               pod_recno = recid(pod_det).
               po_recno = recid(po_mstr).
               FIND prh_hist WHERE prh_nbr= pod_nbr AND prh_line = pod_line NO-LOCK NO-ERROR .
               IF AVAILABLE prh_hist THEN qty_ord = prh_rcvd .
               ELSE qty_ord = 0 .
               del-yn = NO.
               {gprun.i ""gppotr.p"" "(input ""DELETE"", input pod_nbr, input pod_line)"}
               IF pod_type = "" THEN DO:
                   {mfmrw.i "pod_det" pod_part pod_nbr string(pod_line)
                     """" ? pod_due_date "0" "SUPPLY" {&popomtf_p_2}
                     pod_site}
               END.
           END.
       END.

       FOR EACH xkro_mstr WHERE xkro_nbr = pnbr AND xkro_status = "" :
           xkro_status = TRIM(s) .
       END.

       FOR EACH xkrod_det WHERE xkrod_nbr = pnbr AND xkrod_status = "" :
           xkrod_status = TRIM(s) .
       END.

       FIND FIRST knbd_det WHERE knbd_user1 = pnbr NO-LOCK NO-ERROR .
       REPEAT:
          IF NOT AVAILABLE knbd_det THEN 
             LEAVE .
          ELSE DO :
             tempkbid = knbd_id .
          
             FIND knbd_det WHERE knbd_id = tempkbid EXCLUSIVE-LOCK .
             ASSIGN knbd_user1 = "" 
                    knbd_status = {&KB-CARDSTATE-EMPTYACC} .
          END.
          FIND NEXT knbd_det WHERE knbd_user1 = pnbr NO-LOCK NO-ERROR .
       END.
    END.

END.
END.

