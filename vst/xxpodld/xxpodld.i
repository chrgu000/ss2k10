/* xxpodld.p - popomt.p cim load                                             */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no".
DEFINE {1} SHARED VARIABLE v_qty_oh LIKE IN_qty_oh.
DEFINE {1} SHARED VARIABLE fn_i AS CHARACTER.
DEFINE {1} SHARED VARIABLE v_tr_trnbr LIKE tr_trnbr.
DEFINE {1} SHARED VARIABLE v_flag AS CHARACTER.

DEFINE {1} SHARED TEMP-TABLE xxpod_det
   FIELD xxpod_nbr LIKE po_nbr
   FIELD xxpod_line LIKE pod_line
   FIELD xxpod_due_date LIKE pod_due_date
   FIELD xxpod_per_date LIKE pod_per_date
   FIELD xxpod_need LIKE pod_need
   FIELD xxpod_status LIKE pod_status
   FIELD xxpod_error AS CHARACTER FORMAT "x(48)"
   INDEX index1 xxpod_nbr xxpod_line.

FUNCTION getMsg RETURNS character(inbr as integer):
 /* -----------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  find first msg_mstr no-lock where msg_lang = "TW" and msg_nbr = inbr no-error.
  if available msg_mstr then do:
      return msg_desc.
  end.
  else do:
      return "ERROR.".
  end.
END FUNCTION. /*FUNCTION getMsg*/
