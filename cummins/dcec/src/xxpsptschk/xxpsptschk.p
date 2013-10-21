/* xxpsptschk.p - dcec-b chkeck                                              */
/* 程序用于检查如果是有在B地点用到的物料(父件是ZZ结尾的所有子件)             */
/* 需要在ptp_det里建dcec-b的计划资料                                         */


{mfdeclre.i}

DEFINE TEMP-TABLE td2
    FIELDS td2_root      LIKE pt_part
    FIELDS td2_part      LIKE pt_part
    index td2_idx1 is primary td2_root td2_part .
DEFINE BUFFER psmstr FOR ps_mstr.

PROCEDURE getpar:
  define input parameter comp like pt_part.
  define input parameter root like pt_part.

  FOR EACH ps_mstr NO-LOCK use-index ps_comp
      WHERE ps_domain = global_domain and
            ps_comp = comp and
           (ps_mstr.ps_start <= today or ps_mstr.ps_start = ?) and
           (ps_mstr.ps_end>=today or ps_mstr.ps_end = ?):
      find first psmstr no-lock use-index ps_comp
                  where psmstr.ps_domain = global_domain
                   and psmstr.ps_comp = ps_mstr.ps_par
                   and  substring(psmstr.ps_par,length(psmstr.ps_par) - 1) = "ZZ"
                   and (psmstr.ps_start <= today or psmstr.ps_start = ?)
                   and (psmstr.ps_end>=today or psmstr.ps_end = ?) no-error.
        if available psmstr then do:
             find first td2 where td2_root = root and td2_part = psmstr.ps_par no-error.
             if not available td2 then do:
             create td2.
             assign td2_part = psmstr.ps_par
                    td2_root = root.
             end.
             leave.
         end.
         else do:
              run getpar(input ps_mstr.ps_par ,INPUT root).
         end.
  END.
END PROCEDURE.


for each td2 exclusive-lock: delete td2. end.
for each pt_mstr no-lock where pt_domain = global_domain
/* AND pt_part = "C3812092" */:
   RUN getpar(pt_part ,pt_part).
end.

output to value(execname + ".chk.txt").
for each td2 no-lock:
    find first ptp_det no-lock where ptp_site = "dcec-b"
           and ptp_part = td2_root no-error.
    if not available ptp_det then do:
       display td2.
    end.
end.
output close.
