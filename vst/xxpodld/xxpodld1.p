/* xxpodld1.p - popomt.p cim load                                            */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxpgmmgr.i}
{xxpodld.i}
if cloadfile then do:
   FOR EACH xxpod_det exclusive-lock where xxpod_chk = "":
         find first pod_det exclusive-lock where pod_nbr = xxpod_nbr
                AND pod_line = xxpod_line NO-ERROR.
         if available pod_det then do:
            assign pod_due_date = xxpod_due_date.
            assign pod_status = xxpod_stat.
         end.
   END.
end.
