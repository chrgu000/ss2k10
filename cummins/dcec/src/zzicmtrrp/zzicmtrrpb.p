/*zzicmtrtrt.p  CREATE BY LONG BO 2004 JUN 21         */
/*  ITEM TRANSFER ORDER TRANSFER    DISPLAY LINE      */
/*  �ƿⵥ��ӡ ����ʾ                     */

   {mfdeclre.i}

  def shared var tmpnbr like lad_nbr.
  def shared var keeper as char.
  def shared var keeper1 as char.
  def shared var site_from like lad_site.
  def var tmp_   as char initial "------------------------".

  def var prn_date as date initial today.
  def shared var pageno as integer initial 1. /*2004-09-07 15:03*/

/*GL93*/ FORM /*GUI*/
      space(17)
      lad_nbr   label "�ƿⵥ"
      lad_site    label "�����ص�"
      lad_ord_site  label "����ص�"
      lad_user1   label "����/����Ʒ"
      lad_ref   label "��ע"
  /*    lad_user2   label "�����û�"
      lad_line    label "��������"*/
      prn_date   column-label "��ӡ����"
/*GL93*/ with STREAM-IO /*GUI*/  down  frame b
/*GL93*/ width 132 attr-space.

    put
    /*  skip(page-size - LINE-COUNTER - 2) */
      skip(1)
      "���� ________" at 10
      "����Ա________" at 50
      "������________" at 90.

    pageno = pageno + 1.

    page.

    find first lad_det no-lock where lad_domain = global_domain
           and lad_dataset = "itm_mstr"
           and lad_nbr = tmpnbr no-error.
    if available lad_det then do:
      find usr_mstr no-lock where usr_userid = lad_user2 no-error.
      display
        lad_nbr
        lad_site
        lad_ord_site
        lad_user1
        lad_ref
        prn_date
      with frame b.
      down 1 with frame b.
    end.
