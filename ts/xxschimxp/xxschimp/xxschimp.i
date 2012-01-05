/*V8:ConvertMode=Report                                                       */

define {1} shared variable file_name as character format "x(50)".

define {1} shared variable v_rlse_id like sch_rlse_id.
define {1} shared temp-table xsch_data
    fields xsd_nbr like scx_po
    fields xsd_part like scx_part
    fields xsd_line like scx_line
    fields xsd_pcr_qty like sch_pcr_qty
    fields xsd_pcs_date like sch_pcs_date
    fields xsd__dec01 like sch__dec01
    fields xsd__dec02 like sch__dec02
    fields xsd_date like schd_date
    fields xsd_time as character format "x(8)"
    fields xsd_upd_qty like schd_upd_qty
    fields xsd_fc_qual like schd_fc_qual
    fields xsd_fc_chk as character
    index xsd_001 is primary xsd_nbr xsd_line xsd_pcs_date
          xsd_date xsd_time.

