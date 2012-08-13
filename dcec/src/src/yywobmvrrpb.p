{mfdeclre.i} /*GUI moved to top.*/
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


DEF INPUT PARAMETER inp_value AS CHAR.

DEFINE SHARED TEMP-TABLE ttx1 RCODE-INFORMATION
    FIELDS ttx1_i        AS INTEGER          LABEL "���"
    FIELDS ttx1_j        AS INTEGER          LABEL "�����"
    FIELDS ttx1_par      LIKE wo_part        LABEL "��Ʒ"
    FIELDS ttx1_desc_p   LIKE pt_desc1       LABEL "����"
    FIELDS ttx1_pline_p  LIKE pt_prod_line   LABEL "��Ʒ��"
    FIELDS ttx1_woid     LIKE wo_lot         LABEL "���"
    FIELDS ttx1_date     LIKE wo_due_date    LABEL "����"
    FIELDS ttx1_line     LIKE wo_line        LABEL "������"
    FIELDS ttx1_rct_qty  LIKE xxwobmvm_rct_qty LABEL "����"
    FIELDS ttx1_comp     LIKE wo_part        LABEL "���"
    FIELDS ttx1_desc_c   LIKE pt_desc1       LABEL "����"
    FIELDS ttx1_pline_c  LIKE pt_prod_line   LABEL "��Ʒ��"
    FIELDS ttx1_op       LIKE wod_op            LABEL "����"
    FIELDS ttx1_bom_unit LIKE xxwobmvd_bom_unit LABEL "����λ����"
    FIELDS ttx1_bom_cost LIKE xxwobmvd_bom_cost LABEL "���ɱ�"
    FIELDS ttx1_bom_qty  LIKE xxwobmvd_bom_qty  LABEL "��������"
    FIELDS ttx1_bom_amt  LIKE xxwobmvd_bom_amt  LABEL "���ܳɱ�"
    FIELDS ttx1_cwo_unit LIKE xxwobmvd_cwo_unit LABEL "�������ᵥλ����"
    FIELDS ttx1_cwo_cost LIKE xxwobmvd_cwo_cost LABEL "��������ɱ�"
    FIELDS ttx1_cwo_qty  LIKE xxwobmvd_cwo_qty  LABEL "��������������"
    FIELDS ttx1_cwo_amt  LIKE xxwobmvd_cwo_amt  LABEL "���������ܳɱ�"
    FIELDS ttx1_act_unit LIKE xxwobmvd_act_unit LABEL "ʵ�ʵ�λ����"
    FIELDS ttx1_act_cost LIKE xxwobmvd_act_cost LABEL "ʵ�ʳɱ�"
    FIELDS ttx1_act_qty  LIKE xxwobmvd_act_qty  LABEL "ʵ��������"
    FIELDS ttx1_act_amt  LIKE xxwobmvd_act_amt  LABEL "ʵ���ܳɱ�"
    FIELDS ttx1_var_tot  LIKE xxwobmvd_act_amt  LABEL "�ܲ���"
    FIELDS ttx1_var_muv  LIKE xxwobmvd_act_amt    LABEL "����"
    FIELDS ttx1_var_mrv  LIKE xxwobmvd_act_amt  LABEL "�ʲ�"
    FIELDS ttx1_var_mmv1 LIKE xxwobmvd_act_amt  LABEL "��������-����"
    FIELDS ttx1_var_mmv2 LIKE xxwobmvd_act_amt  LABEL "��������-�ʲ�"
    FIELDS ttx1_var_mmv3 LIKE xxwobmvd_act_amt LABEL "��������-����"
    FIELDS ttx1_varflag  AS   LOGICAL INITIAL NO LABEL "���ڲ���"
    INDEX  ttx1_idx1     ttx1_i ttx1_j
    INDEX  ttx1_idx2     ttx1_woid
    .

DEFINE TEMP-TABLE ttt1 LIKE ttx1 RCODE-INFORMATION.


DEF VAR v-key AS CHAR EXTENT 5.
DEF VAR h-a AS HANDLE.

v-key = "".
ASSIGN v-key[1] = inp_value.


FOR EACH ttt1: DELETE ttt1. end.

FOR EACH ttx1 WHERE ttx1_i = INTEGER(v-key[1]) /*AND ttx1_j > 0*/ :
    CREATE ttt1.
    BUFFER-COPY ttx1 TO ttt1.
END.


{yywobmvrrpbw3.i}

