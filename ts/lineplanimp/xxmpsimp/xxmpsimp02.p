/* SS - 111020.1 BY KEN */
/*V8:ConvertMode=Report                                                       */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{xxmpsimp.i}
define variable vppt like seq_priority.

  for each xxmps no-lock break by xxmps_line by xxmps_date:
      if first-of(xxmps_date) then do:
         for each seq_mstr use-index seq_sequence exclusive-lock where
                       seq_mstr.seq_domain = global_domain and
                       seq_mstr.seq_site = "TS" and
                       seq_mstr.seq_line = xxmps_line and
                       seq_due_date = xxmps_date:
                delete seq_mstr.
         end.
      end.
  end.

   /*cimload 18.22.1.14*/
  FOR EACH xxmps:
/*         find last seq_mstr where                                         */
/*                   seq_mstr.seq_domain = global_domain and                */
/*                   seq_mstr.seq_site = "TS" and                           */
/*                   seq_mstr.seq_line = xxmps_line and                     */
/*                   seq_mstr.seq_part = xxmps_part and                     */
/*                   seq_mstr.seq_due_date = xxmps_date and                 */
/*                   seq__chr01 = xxmps_bc no-error.                        */
/*         if available seq_mstr then do:                                   */
/*             assign seq_mstr.seq_qty_req = xxmps_qty.                     */
/*         end.                                                             */
/*         else do:                                                         */
/*            release seq_mstr.                                             */
/*             assign vppt = 0.                                            */
             for each seq_mstr use-index seq_sequence no-lock where
                       seq_mstr.seq_domain = global_domain and
                       seq_mstr.seq_site = "TS" and
                       seq_mstr.seq_line = xxmps_line
                  break by seq_mstr.seq_domain
                        by seq_mstr.seq_site
                        by seq_mstr.seq_line
                        by seq_mstr.seq_priority:
                  if last-of(seq_mstr.seq_line)
                       then assign vppt = seq_priority + 1.
             end.
               create seq_mstr.
               assign
                  seq_domain = global_domain
                  seq_site = "TS"
                  seq_line = xxmps_line
                  seq_priority = vppt
                  seq__chr01 = xxmps_bc
                  seq_part = xxmps_part
                  seq_qty_req = xxmps_qty
                  seq_due_date = xxmps_date.
                  xxmps_error = "导入成功".
/*        end.                                                              */
  END.
