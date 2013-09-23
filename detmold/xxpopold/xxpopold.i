
 def {1} shared temp-table xxwk
        field xxwk_ponbr like po_nbr
        field xxwk_vend like po_vend
        field xxwk_due_date as character
        field xxwk_curr as character
        field xxwk_buyer as character
        field xxwk_contract as character
        field xxwk_site as character
        field xxwk_part as character
        field xxwk_qty as character
        field xxwk_prlist as character
        field xxwk_line as inte
        field xxwk_acct like pod_acct
        field xxwk_sub  like pod_sub
        field xxwk_cc like pod_cc
        field xxwk_proj like pod_project
        field xxwk_err as character format "x(40)" .

  def {1} shared temp-table xxwk1
        field xxwk1_ponbr like po_nbr
        field xxwk1_vend like po_vend
        field xxwk1_due_date like po_due_date
        field xxwk1_curr like po_curr
        field xxwk1_buyer like po_buyer
        field xxwk1_contract like po_contract
        field xxwk1_site like pod_site
        field xxwk1_part like pod_part
        field xxwk1_prlist as character
        field xxwk1_line as inte
        field xxwk1_newpo as logical
        field xxwk1_modline as logical
        field xxwk1_qty like pod_qty_ord
        field xxwk1_acct like pod_acct
        field xxwk1_sub  like pod_sub
        field xxwk1_cc like pod_cc
        field xxwk1_proj like pod_project.
