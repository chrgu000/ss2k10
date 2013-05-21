define temp-table tmpbom1
       fields tb1_root like ps_par
       fields tb1_part like ps_par
       fields tb1_comp like ps_comp
       fields tb1_qty  like ps_qty_per
       fields tb1_rmks like ps_rmks.
define buffer psmstr for ps_mstr.

PROCEDURE process_report:
    DEFINE INPUT PARAMETER part LIKE pt_part.
    DEFINE INPUT PARAMETER root LIKE pt_part.
    DEFINE INPUT PARAMETER eff  like ps_start.
    DEFINE INPUT PARAMETER qty  like ps_qty_per.
    DEFINE INPUT PARAMETER lay  as   logical.
    
    define variable vsite like si_site initial "dcec-c".
    if length(part) >= 3 then do:
       if substring(part,length(part) - 1) = "ZZ" then assign vsite = "dcec-b".
    end.
    FOR EACH ps_mstr NO-LOCK WHERE ps_domain = global_domain and
             ps_par = part and
            (ps_mstr.ps_start <= eff or ps_mstr.ps_start = ?) and
            (ps_mstr.ps_end>= eff or ps_mstr.ps_end = ?):
        
        if can-find(first psmstr no-lock where psmstr.ps_domain = global_domain
                     and psmstr.ps_par = ps_mstr.ps_comp
                     and (psmstr.ps_start <= eff or psmstr.ps_start = ?)
                     and (psmstr.ps_end>=eff or psmstr.ps_end = ?)) then do:

                IF NOT CAN-FIND (FIRST tmpbom1 WHERE tb1_comp = ps_mstr.ps_comp
                                                 AND tb1_part = ps_mstr.ps_par
                                                 AND tb1_root = root ) THEN DO:
                    create tmpbom1.
                    assign tb1_comp = ps_mstr.ps_comp
                           tb1_part = ps_mstr.ps_par
                           tb1_root = root
                           tb1_rmks = ps_mstr.ps_rmks.
                END.
                tb1_qty = tb1_qty + ps_mstr.ps_qty_per * qty * (100 / (100 - ps_mstr.ps_scrp_pct)).
                find first ptp_det no-lock where ptp_domain = global_domain and
                           ptp_site = vsite and ptp_part = ps_mstr.ps_comp no-error.
                if lay then do:
                   if available ptp_det and ptp_pm_code = "P" then do:
                      .
                   end.
                   else do:
                      run process_report(input ps_mstr.ps_comp ,INPUT root ,input eff ,input tb1_qty,input lay).                 
                   end.
                end.
                else do:
                   if available ptp_det and ptp_phantom = no then do:
                      .
                   end.
                   else do:
                      run process_report(input ps_mstr.ps_comp ,INPUT root ,input eff ,input tb1_qty,input lay).  
                   end.
                end.
  
        end.
        else do:
             IF NOT CAN-FIND(FIRST tmpbom1 WHERE tb1_comp = ps_mstr.ps_comp
                                             AND tb1_part = ps_mstr.ps_par
                                             AND tb1_root = root) THEN do:
                create tmpbom1.
                assign tb1_comp = ps_mstr.ps_comp
                       tb1_part = ps_mstr.ps_par
                       tb1_root = root
                       tb1_rmks = ps_mstr.ps_rmks.
             end.
                       tb1_qty  = tb1_qty + ps_mstr.ps_qty_per * qty * (100 / (100 - ps_mstr.ps_scrp_pct)).
        end.
    END.
END PROCEDURE.


/* procedure process_report:                                                             */
/*  /* -----------------------------------------------------------                       */
/*     Purpose: 计算BOM用量到table tmpbom1                                               */
/*     Parameters: vv_par:父零件,vv_eff_date:生效日                                      */
/*     Notes:                                                                            */
/*   -------------------------------------------------------------*/                     */
/*                                                                                       */
/*     define input  parameter vv_part     as character .                                */
/*     define input  parameter vv_eff_date as date format "99/99/99" .                   */
/*     define var  vv_comp     like ps_comp no-undo.                                     */
/*     define var  vv_level    as integer   no-undo.                                     */
/*     define var  vv_record   as integer extent 500.                                    */
/*     define var  vv_qty      as decimal initial 1  no-undo.                            */
/*     define var  vv_save_qty as decimal extent 500 no-undo.                            */
/*                                                                                       */
/*     assign vv_level = 1                                                               */
/*            vv_comp  = vv_part                                                         */
/*            vv_save_qty = 0                                                            */
/*            vv_qty      = 1 .                                                          */
/*                                                                                       */
/* find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and           */
/*            ps_par = vv_comp  no-lock no-error .                                       */
/* repeat:                                                                               */
/*        if not avail ps_mstr then do:                                                  */
/*              repeat:                                                                  */
/*                 vv_level = vv_level - 1.                                              */
/*                 if vv_level < 1 then leave .                                          */
/*                 find ps_mstr where recid(ps_mstr) = vv_record[vv_level]               */
/*                              no-lock no-error.                                        */
/*                 vv_comp  = ps_par.                                                    */
/*                 vv_qty = vv_save_qty[vv_level].                                       */
/*                 find next ps_mstr use-index ps_parcomp where                          */
/*                           ps_domain = global_domain and                               */
/*                           ps_par = vv_comp  no-lock no-error.                         */
/*                 if avail ps_mstr then leave .                                         */
/*             end.                                                                      */
/*         end.  /*if not avail ps_mstr*/                                                */
/*                                                                                       */
/*         if vv_level < 1 then leave .                                                  */
/*         vv_record[vv_level] = recid(ps_mstr).                                         */
/*                                                                                       */
/*                                                                                       */
/*         if (ps_end = ? or vv_eff_date <= ps_end) then do :                            */
/*                 vv_save_qty[vv_level] = vv_qty.                                       */
/*                                                                                       */
/*                 vv_comp  = ps_comp .                                                  */
/*                 vv_qty = vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct)).           */
/*                 vv_level = vv_level + 1.                                              */
/*                 find first tmpbom1 where tb1_par = vv_part and                        */
/*                            tb1_comp = ps_mstr.ps_comp no-error.                       */
/*                 if not available tmpbom1 then do:                                     */
/*                     create tmpbom1.                                                   */
/*                     assign                                                            */
/*                         tb1_par  = caps(vv_part)                                      */
/*                         tb1_comp = caps(ps_mstr.ps_comp)                              */
/*                         tb1_qty  = vv_qty                                             */
/*                         .                                                             */
/*                 end.                                                                  */
/*                 else tb1_qty   = tb1_qty + vv_qty  .                                  */
/*                 tb1_rmks = ps_mstr.ps_rmks.                                           */
/*                 find first ps_mstr use-index ps_parcomp where                         */
/*                            ps_domain = global_domain and                              */
/*                            ps_par = vv_comp  no-lock no-error.                        */
/*         end.   /*if (ps_end = ? or vv_eff_date <= ps_end)*/                           */
/*         else do:                                                                      */
/*               find next ps_mstr use-index ps_parcomp where                            */
/*                         ps_domain = global_domain and                                 */
/*                         ps_par = vv_comp  no-lock no-error.                           */
/*         end.  /* not (ps_end = ? or vv_eff_date <= ps_end)  */                        */
/* end. /*repeat:*/                                                                      */
/*                                                                                       */
/* end procedure. /*bom_down*/                                                           */
