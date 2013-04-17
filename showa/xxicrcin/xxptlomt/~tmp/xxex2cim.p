 output to cim.cim.
 for each xxpl_ref no-lock , each pt_mstr no-lock where pt_part = xxpl_part,
 each loc_mstr no-lock where loc_loc = xxpl_loc and loc_site = xxpl_site,
 each si_mstr no-lock where si_site = xxpl_site:
      put unformat "@@batchload xxptlomt.p" skip.
      put unformat xxpl_part skip.
      export delimiter " " xxpl_site xxpl_loc.
      export delimiter " " xxpl_type xxpl_rank xxpl_panel xxpl_cap.
      put unformat "@@end" skip.
 end.
 output close.
