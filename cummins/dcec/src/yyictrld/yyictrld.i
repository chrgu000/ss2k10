DEFINE {1} SHARED TEMP-TABLE xim
    FIELDS xim_nbr LIKE tr_nbr
    FIELDS xim_part LIKE pt_part
    FIELDS xim_desc like pt_desc1
    FIELDS xim_qty_req LIKE ld_qty_oh
    FIELDS xim_fsite LIKE si_site
    FIELDS xim_floc LIKE ld_loc
    FIELDS xim_flot LIKE ld_lot
    FIELDS xim_tsite LIKE si_site
    FIELDS xim_tloc LIKE ld_loc
    FIELDS xim_tlot LIKE ld_lot.
 
define {1} shared temp-table xic
    fields xic_nbr     like tr_nbr label "�Ʋֵ���"
    fields xic_part    like pt_part label "�����"
    fields xic_desc    like pt_desc1 label "����"
    fields xic_qty_req like ld_qty_oh label "������"
    fields xic_qty_ld  like ld_qty_oh label "�����"
    fields xic_qty_tr  like ld_qty_oh label "������"
    fields xic_fsite   like si_site label "�Ƴ��ص�"
    fields xic_floc    like ld_loc label "�Ƴ���λ"
    fields xic_flot    like ld_lot  label "�Ƴ�����"
    fields xic_tsite   like si_site  label "����ص�"
    fields xic_tloc    like ld_loc label "�����λ"
    fields xic_tlot    like ld_lot label "��������"
    FIELDS xic_sn      AS   INTEGER label "���"
    fields xic_chk     as character format "x(40)" label "���"
    .
