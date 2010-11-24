/*By: Neil Gao 08/12/03 ECO: *SS 20081203* */

{mfdeclre.i}
{pxmaint.i}


PROCEDURE validateItemStatus :

   define input parameter pItem as character no-undo.
   define input parameter pTransactionCode as character no-undo.
	 define output parameter optrst as logical init no.
   define variable statusValue as character no-undo.
   define buffer itemMasterBuffer for pt_mstr.
   define buffer itemStatusBuffer for isd_det.
   define buffer bomMasterBuffer for bom_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

     /* Lookup item status value for item */
     for first itemMasterBuffer no-lock  where itemMasterBuffer.pt_domain =
     global_domain and  pt_part = pItem:
        statusValue = pt_status.
        substring (statusValue,9,1) = "#".

        /* See if requested transaction is restricted for item status */
        if can-find (itemStatusBuffer  where itemStatusBuffer.isd_domain =
        global_domain and  isd_status = statusValue
        and isd_tr_type = pTransactionCode)
        then do:
           /* 358  - Restricted procedure for item status code */
           {pxmsg.i &MSGNUM=358 &ERRORLEVEL={&APP-ERROR-RESULT}
                    &FIELDNAME=""ps_comp""
           }
           optrst = yes .
        end.
     end.
  end.
  /*return {&SUCCESS-RESULT}.*/
END PROCEDURE. /* validateItemStatus */


