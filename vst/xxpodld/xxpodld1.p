/* xxpodld1.p - popomt.p cim load                                            */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxpgmmgr.i}
{xxpodld.i}
define variable old_pod_status like pod_status.
define variable old_type like pod_type.
if cloadfile then do:
   FOR EACH xxpod_det exclusive-lock where xxpod_chk = "":
         find first pod_det exclusive-lock where pod_nbr = xxpod_nbr
                AND pod_line = xxpod_line NO-ERROR.
         if available pod_det then do:
            assign old_pod_status = pod_status.
            assign old_type = pod_type.
            assign pod_due_date = xxpod_due_date.
            assign pod_status = xxpod_stat.
            if ((pod_status = "c" or pod_status = "x" ) and
                old_pod_status <> "c" and old_pod_status <> "x"
                and old_type = "" )
                or ((old_pod_status <> "c" and old_pod_status <> "x" ) and
                old_type = "" and pod_type <> "" ) then do:
                /* MRP WORKFILE */
                {mfmrw.i "pod_det" pod_part pod_nbr string(pod_line) """" ?
                   pod_due_date "0" "SUPPLY" PURCHASE_ORDER pod_site}

             end.
         end.
   END.
end.
