/* SS - 111020.1 BY KEN */
/*V8:ConvertMode=Report                                                       */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{xxmpsim2.i}

define variable vppt like seq_priority.

  FOR EACH xxmps,
      EACH usrw_wkfl no-lock where
           usrw_wkfl.usrw_domain = global_domain and
           usrw_wkfl.usrw_key1 = key1 and
           usrw_wkfl.usrw_key3 = xxmps_dept and
           usrw_wkfl.usrw_key4 = xxmps_cx
     BREAK BY usrw_key6 BY xxmps_date:
     if first-of(xxmps_date) then do:
         for each seq_mstr use-index seq_sequence exclusive-lock where
                  seq_mstr.seq_domain = global_domain and
                  seq_mstr.seq_site = "TS" and
                  seq_mstr.seq_line = usrw_key6 and
                  seq_due_date = xxmps_date:
           delete seq_mstr.
         end.
     end.
  end.
  
  /*cimload */
  FOR EACH xxmps,
      EACH usrw_wkfl no-lock where
           usrw_wkfl.usrw_domain = global_domain and
           usrw_wkfl.usrw_key1 = key1 and
           usrw_wkfl.usrw_key3 = xxmps_dept and
           usrw_wkfl.usrw_key4 = xxmps_cx
     BREAK BY usrw_key5 BY xxmps_date:
/*          find last seq_mstr where                                       */
/*                    seq_mstr.seq_domain = global_domain and              */
/*                    seq_mstr.seq_site = "TS" and                         */
/*                    seq_mstr.seq_line = usrw_wkfl.usrw_key6 and          */
/*                    seq_mstr.seq_part = usrw_wkfl.usrw_key5 and          */
/*                    seq_mstr.seq_due_date = xxmps_date no-error.         */
/*          if available seq_mstr then do:                                 */
/*              assign seq_mstr.seq_qty_req = xxmps_qty.                   */
/*          end.                                                           */
/*          else do:                                                       */
/*             release seq_mstr.                                           */
/*           assign vppt = 0.                                              */

             for each seq_mstr use-index seq_site no-lock where
                       seq_mstr.seq_domain = global_domain and
                       seq_mstr.seq_site = "TS" and
                       seq_mstr.seq_line = usrw_wkfl.usrw_key6
                  break by seq_mstr.seq_line
                        by seq_mstr.seq_priority:
                  if last-of(seq_mstr.seq_line)
                       then assign vppt = seq_priority + 1.
             end.
             create seq_mstr.
             assign seq_mstr.seq_domain = global_domain
                    seq_mstr.seq_site = "TS"
                    seq_mstr.seq_line = usrw_wkfl.usrw_key6
                    seq_mstr.seq_priority = vppt
                    seq_mstr.seq__chr01 = xxmps_bc
                    seq_mstr.seq_part = usrw_wkfl.usrw_key5
                    seq_mstr.seq_qty_req = xxmps_qty
                    seq_mstr.seq_due_date = xxmps_date
                    xxmps_error = "导入成功".
 /*        END.             */
  END.
