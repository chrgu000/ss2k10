/* yyactcost.p - ����Ʒʵ�ʳɱ�����                   */
/* Author: James Duan   *DATE:2009-09-21*           */
/*ss2012-8-15 ����*/

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "121028.1"}

DEFINE VARIABLE part    LIKE pt_part.
DEFINE VARIABLE part1   LIKE pt_part.
DEFINE VARIABLE line    LIKE pt_prod_line.
DEFINE VARIABLE line1   LIKE pt_prod_line.
DEFINE VARIABLE iyear   AS INT format "9999".
DEFINE VARIABLE iper    AS INT format "99".

define variable pcqty   like yyinvi_mfg_qty.
define variable v_version like yywobmspt_version.
define variable v_site    like yywobmspt_site.
define variable stdmtlcost  like yyactcs_act_mtl.
define variable stdmfgcost  like yyactcs_act_mtl.
define variable stdlbrcost  like yyactcs_act_mtl.
define variable mtlvar_amt  like yyactcs_act_mtl.
define variable labvar_amt  like yyactcs_act_mtl.
define variable mfgvar_amt  like yyactcs_act_mtl.
define variable icount    as int.
define buffer bptmstr for pt_mstr.

define temp-table ttvardet
  fields ttvardet_part like yycsvard_part
  fields ttvardet_comp like yycsvard_comp
  fields ttvardet_std_mtl like yyactcsd_act_mtl
  fields ttvardet_std_lbr like yyactcsd_act_lbr
  fields ttvardet_std_mfg like yyactcsd_act_mfg
  fields ttvardet_var_mtl like yyactcsd_act_mtl
  fields ttvardet_var_lbr like yyactcsd_act_lbr
  fields ttvardet_var_mfg like yyactcsd_act_mfg
index mainindex is primary ttvardet_part ttvardet_comp.

iyear = year(today).
iper = month(today).

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    part  COLON 20
    part1 COLON 45 LABEL "��"
    SKIP
    line  COLON 20
    line1 COLON 45 LABEL "��"
    SKIP
    iyear COLON 20 LABEL "���"
    iper  COLON 45 LABEL "�ڼ�"
    SKIP
    SKIP
    SKIP(.4)  /*GUI*/
    WITH FRAME a SIDE-LABELS WIDTH 80 NO-BOX THREE-D.

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = "ʵ�ʳɱ�����".
RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
                 FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
                 RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ",
                 RECT-FRAME-LABEL:FONT).
RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
REPEAT:
    IF part1 = hi_char THEN part1 = "".
    IF line1 = hi_char THEN line1 = "".

    UPDATE
        part part1
  line line1
        iyear iper

    WITH FRAME a.

    IF part1 = "" THEN part1 = hi_char.
    IF line1 = "" THEN line1 = hi_char.

    /* ȷ��������ϲ����ڼ� */
    find first glc_cal where /*ss2012-8-15 b*/ glc_cal.glc_domain = global_domain and /*ss2012-8-15 e*/ glc_year = iyear and glc_per = iper
            no-lock no-error.
    if not avail glc_cal then do:
  message "�����ڼ�δ����!" view-as alert-box.
  next.
    end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 80
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

    /*GUI*/
    {mfguichk.i } /*Replace mfrpchk*/

    put "���㿪ʼ:"  string(time, "HH:MM:SS") skip.
    for each yyinvi_mstr no-lock where  /*ss2012-8-15 b*/ yyinvi_mstr.yyinvi_domain = global_domain and /*ss2012-8-15 e*/  yyinvi_year = iyear
  and yyinvi_per = iper
  and yyinvi_part_pl >= line and yyinvi_part_pl <= line1
  and yyinvi_part >= part and yyinvi_part <= part1
  use-index yyinvi_year_pl :

  /* ֻ����,���Ʒ�����Ʒ��ϼ�������Ʒ */
  find first pt_mstr where /*ss2012-8-15 b*/ pt_mstr.pt_domain = global_domain and /*ss2012-8-15 e*/ pt_mstr.pt_part = yyinvi_part  no-lock no-error.
  if not avail pt_mstr or pt_mstr.pt_prod_line begins "1" then next.
  put "��ʼ����:" yyinvi_part string(time, "HH:MM:SS") format "x(100)" skip.
  assign
      pcqty = 0
      stdmtlcost = 0
      stdmfgcost = 0
      stdlbrcost = 0
      mtlvar_amt = 0
      labvar_amt = 0
      mfgvar_amt = 0.

  find first yyactcs_mstr where /*ss2012-8-15 b*/ yyactcs_mstr.yyactcs_domain = global_domain and /*ss2012-8-15 e*/ yyactcs_year = iyear
    and yyactcs_per = iper
    and yyactcs_part = pt_mstr.pt_part EXCLUSIVE-LOCK no-error.
  if not avail yyactcs_mstr then do:
    create yyactcs_mstr.
    assign
        yyactcs_part = pt_mstr.pt_part
        yyactcs_year = iyear
        yyactcs_per = iper.
  end. /* if not avail yyactcs_mstr */
  assign yyactcs_part_pl = pt_prod_line.

  /* ȡ��������� */
  if can-find(first code_mstr where /*ss2012-8-15 b*/ code_mstr.code_domain = global_domain  and /*ss2012-8-15 e*/
            code_fldname = "sub_line" and code_value = yyinvi_part_pl
          no-lock) then
  assign pcqty = min(yyinvi_mfg_qty,yyinvi_buy_qty) + yyinvi_upl_qty.
  else assign pcqty = yyinvi_mfg_qty + yyinvi_upl_qty + yyinvi_buy_qty.
  /*
  find first code_mstr where code_fldname = "so site" and pt_part begins code_value no-lock no-error.
  if avail code_mstr then v_site = code_cmmt.
  else assign v_site = "dcec-c".
  */
  find last tr_hist use-index tr_part_eff where /*ss 2012-8-15 b*/ tr_hist.tr_domain = global_domain and /*ss2012-8-15 e*/
      tr_part = pt_mstr.pt_part
    and tr_effdate >= glc_start
    and tr_effdate <= glc_end
    and tr_type = "RCT-WO" no-lock no-error.
  if avail tr_hist then assign v_site = tr_site.
  else assign v_site = "dcec-c".

  find last yywobmspt_mstr where /*ss 2012-8-15 b*/  yywobmspt_mstr.yywobmspt_domain = global_domain and /*ss2012-8-15 e*/
      yywobmspt_site = v_site
    and yywobmspt_part = yyactcs_part
    and ( year(yywobmspt_mod_date) < iyear
          or( year(yywobmspt_mod_date) = iyear
              and month(yywobmspt_mod_date)<= iper )) no-lock no-error.
  if not avail yywobmspt_mstr then do:
    find last yywobmspt_mstr where /*ss2012-8-15 b*/ yywobmspt_mstr.yywobmspt_domain = global_domain and /*ss2012-8-15 e*/
    yywobmspt_site = v_site
    and yywobmspt_part = yyactcs_part no-lock no-error.
    if not avail yywobmspt_mstr then do:
      find last yywobmspt_mstr where yywobmspt_domain = global_domain and yywobmspt_part = yyactcs_part no-lock no-error.
      if not avail yywobmspt_mstr then next.
    end.
  end.

  assign v_version = yywobmspt_version
    v_site = yywobmspt_site.

  /* ȡ��׼�ɱ� */
  for each yywobmspt_mstr no-lock where /*ss2012-8-15 b*/ yywobmspt_mstr.yywobmspt_domain = global_domain and /*ss2012-8-15 e*/
      yywobmspt_site = v_site
      and yywobmspt_part = yyactcs_part
      and yywobmspt_version = v_version :
    if yywobmspt_elem = "����" or yywobmspt_elem = "��˰�˷�" or yywobmspt_elem = "ת��" then
      assign stdmtlcost = stdmtlcost + yywobmspt_elem_cost.

    if yywobmspt_elem = "ֱ���˹�" then
      assign stdlbrcost = stdlbrcost + yywobmspt_elem_cost.

    if yywobmspt_elem = "�������" then
      assign stdmfgcost = stdmfgcost + yywobmspt_elem_cost.
  end. /* for each yywobmspt_mstr */

  /* ȡ�����ɱ�,ppv,���ư��Ʒ����,�˹���������ò��� */
  for first yycsvar_mstr no-lock where  /*ss2012-8-15 b*/ yycsvar_mstr.yycsvar_domain = global_domain and /*ss2012-8-15 e*/
    yycsvar_year = iyear
    and yycsvar_per = iper
    and yycsvar_part_pl = yyinvi_part_pl
    and yycsvar_part = yyactcs_part:
    /* �ϲ� */
    do icount = 1 to 15 :
      mtlvar_amt =  mtlvar_amt + yycsvar_variance[icount].
    end. /* do icount = 1 to 15 */
    mtlvar_amt =  mtlvar_amt + yycsvar_variance[20].

    /* �˹����� */
    labvar_amt = labvar_amt +  yycsvar_variance[16] +  yycsvar_variance[17].

    /* ������ò��� */
    mfgvar_amt = mfgvar_amt + yycsvar_variance[18] +  yycsvar_variance[19].

  end. /* for first yycsvar_mstr */

  /* ����ʵ�ʳɱ� */
  assign
      yyactcs_act_mtl = stdmtlcost * pcqty + mtlvar_amt
      yyactcs_act_mfg = stdmfgcost * pcqty + mfgvar_amt
      yyactcs_act_lbr = stdlbrcost * pcqty + labvar_amt.

  /* ����ʵ�ʳɱ���ϸ */

  /* ȡ��ϸ���� */
  for each yycsvard_det no-lock where /*ss2012-8-15 b*/ yycsvard_det.yycsvard_domain = global_domain and /*ss2012-8-15 e*/
    yycsvard_year = iyear
    and yycsvard_per = iper
    and yycsvard_part = yyactcs_part:

    find first ttvardet where ttvardet_part = yyactcs_part
      and ttvardet_comp = yycsvard_comp no-error.
    if not avail ttvardet then do:
      create ttvardet.
      assign
          ttvardet_part = yyactcs_part
          ttvardet_comp = yycsvard_comp.
    end. /* if not avail ttvardet */

    do icount = 1 to 15 :
      ttvardet_var_mtl =  ttvardet_var_mtl + yycsvard_variance[icount].
    end.


    ttvardet_var_lbr = ttvardet_var_lbr + yycsvard_variance[16] + yycsvard_variance[17].

    ttvardet_var_mfg = ttvardet_var_mfg + yycsvard_variance[18] + yycsvard_variance[19].

  end. /* for each yycsvard_det */

  /* ȡ��ϸ��׼�ɱ� */
  for each yywobmsptd_det no-lock where /*ss2012-8-15 b*/ yywobmsptd_det.yywobmsptd_domain = global_domain and /*ss2012-8-15 e*/
      yywobmsptd_site = v_site

      and yywobmsptd_part = yyactcs_part
      and yywobmsptd_version = v_version :
    find first ttvardet where ttvardet_part = yywobmsptd_part
      and ttvardet_comp = yywobmsptd_comp no-error.
    if not avail ttvardet then do:
      create ttvardet.
      assign
          ttvardet_part = yywobmsptd_part
          ttvardet_comp = yywobmsptd_comp.
    end. /* if not avail ttvardet */
    if yywobmsptd_elem = "����" or yywobmsptd_elem = "��˰�˷�" or yywobmsptd_elem = "ת��" then
      assign ttvardet_std_mtl = ttvardet_std_mtl + pcqty * yywobmsptd_unit_qty * yywobmsptd_elem_cost.

    if yywobmsptd_elem = "ֱ���˹�" then
      assign ttvardet_std_lbr = ttvardet_std_lbr + pcqty * yywobmsptd_unit_qty * yywobmsptd_elem_cost.

    if yywobmsptd_elem = "�������" then
      assign ttvardet_std_mfg = ttvardet_std_mfg + pcqty * yywobmsptd_unit_qty * yywobmsptd_elem_cost.
  end. /* for each yywobmsptd_det */

  for each ttvardet :

    find first yyactcsd_det where /*ss2012-8-15 b*/ yyactcsd_det.yyactcsd_domain = global_domain and /*ss2012-8-15 e*/ yyactcsd_year = iyear
      and yyactcsd_per = iper
      and  yyactcsd_part = ttvardet_part
      and yyactcsd_comp = ttvardet_comp EXCLUSIVE-LOCK no-error.
    if not avail yyactcsd_det then do:
      create yyactcsd_det.
      assign
          yyactcsd_part = ttvardet_part
          yyactcsd_comp = ttvardet_comp
          yyactcsd_year = iyear
          yyactcsd_per = iper.
    end. /* if not avail yyactcsd_det */
    yyactcsd_part_pl = yyactcs_part_pl.

    find first bptmstr where bptmstr.pt_domain = global_domain and
               bptmstr.pt_part = ttvardet_comp
         no-lock no-error.
    if avail bptmstr then assign yyactcsd_comp_pl = bptmstr.pt_prod_line.

    assign
        yyactcsd_act_mtl = ttvardet_std_mtl + ttvardet_var_mtl
        yyactcsd_act_lbr = ttvardet_std_lbr + ttvardet_var_lbr
        yyactcsd_act_mfg = ttvardet_std_mfg + ttvardet_var_mfg.

    /* �����¼ */
    delete ttvardet.
  end. /* for each ttvardet */


    end. /* for each yyinvi_mstr */

    put "�������:"  string(time, "HH:MM:SS") skip.
    {mfreset.i}
    {mfgrptrm.i} /*Report-to-Window*/
END.
{wbrp04.i &frame-spec = a}


