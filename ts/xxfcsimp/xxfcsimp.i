/*V8:ConvertMode=Report                                                       */

define {1} shared variable file_name as character format "x(50)".

define {1} shared temp-table xfcs_det
  fields xfd_part like fcs_part
  fields xfd_site like fcs_site
  fields xfd_year like fcs_year
  fields xfd_fcs_qty like fcs_fcst_qty
  fields xfd_chk like mph_rsult.

