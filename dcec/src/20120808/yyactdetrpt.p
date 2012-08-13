/* yyactdetrpt.p - ����Ʒʵ�ʳɱ���ϸ����           */
/* Author: James Duan   *DATE:2009-09-21*           */

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

DEFINE VARIABLE part		LIKE pt_part.

DEFINE VARIABLE iyear		AS INT format "9999".
DEFINE VARIABLE iper		AS INT format "99".

define variable v_version	like yywobmspt_version.
define variable v_site		like yywobmspt_site.
define variable pcqty		like yyinvi_mfg_qty.
DEF VAR h-tt AS HANDLE.
DEFINE VAR inp_where     AS CHAR.
DEFINE VAR inp_sortby    AS CHAR.
DEFINE VAR inp_bwstitle  AS CHAR.
DEF    VAR      v_list AS CHAR INITIAL "".

define temp-table tttt RCODE-INFORMATION
    fields tttt_part		like pt_part			label "�����"
    fields tttt_comp		like pt_part			label "�����"
    fields tttt_desc		like pt_desc1			label "�������"
    fields tttt_pl		like pt_prod_line		label "��Ʒ��"
    fields tttt_stdmtlcost	like yywobmspt_elem_cost	label "����"
    fields tttt_stdfrtcost	like yywobmspt_elem_cost	label "��˰&�˷�"
    fields tttt_stdsubcost	like yywobmspt_elem_cost	label "ת��"
    fields tttt_stdlbrcost	like yywobmspt_elem_cost	label "�˹�"
    fields tttt_stdmfgcost	like yywobmspt_elem_cost	label "�������"
  /*  fields tttt_bomchgvar	like yycsvar_variance[1]	label "1.BOM���" */
    fields tttt_routchgvar	like yycsvar_variance[1]	label "��������"
    fields tttt_mtdchgvar1	like yycsvar_variance[1]	label "��������-����"
    fields tttt_mtdchgvar2	like yycsvar_variance[1]	label "��������-�۲�"
    fields tttt_ptrepvar1	like yycsvar_variance[1]	label "��ʱ���"
    fields tttt_ptrepvar2	like yycsvar_variance[1]	label "������"
    fields tttt_ratevar		like yycsvar_variance[1]	label "�ʲ�"
    fields tttt_othervar	like yycsvar_variance[1]	label "����"
    fields tttt_ppvvar1		like yycsvar_variance[1]	label "PPV����"
    fields tttt_ppvvar2		like yycsvar_variance[1]	label "���ư��Ʒ���ϲ���"
    fields tttt_glmtlvar	like yycsvar_variance[1]	label "�������˲���(��QAD��)"
    fields tttt_lbrvar1		like yycsvar_variance[1]	label "�˹�����"
    fields tttt_lbrvar2		like yycsvar_variance[1]	label "�˹�����"
    fields tttt_mfgvar1		like yycsvar_variance[1]	label "������ò���"
    fields tttt_mfgvar2		like yycsvar_variance[1]	label "������ò���"
    fields tttt_actmtl		like yycsvar_variance[1]	label "����ʵ��"
    fields tttt_actlbr		like yycsvar_variance[1]	label "�˹�ʵ��"
    fields tttt_actmfg		like yycsvar_variance[1]	label "����ʵ��"
    fields tttt_totalcost	like yycsvar_variance[1]	label "�ϼ�(ʵ�ʳɱ�)"
index part is primary tttt_part tttt_comp.	

define buffer bptmstr for pt_mstr.

iyear = year(today).
iper = month(today).


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    part	COLON 20 
    SKIP
    iyear	COLON 20 LABEL "���"
    iper	COLON 45 LABEL "�ڼ�"
    SKIP
    SKIP
    SKIP(.4)  /*GUI*/
    WITH FRAME a SIDE-LABELS WIDTH 80 NO-BOX THREE-D.

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
            &THEN " Selection Criteria "
            &ELSE {&SELECTION_CRITERIA}
            &ENDIF .
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

REPEAT:

    UPDATE 
        part 
        iyear iper 

    WITH FRAME a.
    
/***************************************************
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
********************************************************/

    
    /* ȷ��������ϲ����ڼ� */
    find first glc_cal where glc_year = iyear and glc_per = iper no-lock no-error.
    if not avail glc_cal then do:
	find first glc_cal where today >= glc_start and today <= glc_end no-lock no-error.
	if not avail glc_cal then do:
		message "�����ڼ�δ����!" view-as alert-box.
	end.
    end.
    
    find first pt_mstr where pt_mstr.pt_part = part no-lock no-error.
    if not avail pt_mstr then return.
     
    /* ȡ������� */
    find first yyinvi_mstr where yyinvi_part = part
	and yyinvi_year = iyear
	and yyinvi_per = iper no-lock no-error.
    if avail yyinvi_mstr then assign pcqty = yyinvi_mfg_qty + yyinvi_upl_qty + yyinvi_buy_qty.

    /* ȡ��׼�ɱ� */
    find last yywobmspt_mstr where yywobmspt_part = part 
	and year(yywobmspt_mod_date) <= iyear
	and month(yywobmspt_mod_date)<= iper  no-lock no-error.
    if not avail yywobmspt_mstr then next.
	assign v_version = yywobmspt_version
               v_site = yywobmspt_site.

    for each yywobmspt_mstr no-lock where yywobmspt_site = v_site
	and yywobmspt_part = part 
	and yywobmspt_version = v_version:
		
		find first tttt where tttt_part = "" and tttt_comp = yywobmspt_part no-error.
		if not avail tttt then do:
			create tttt.
			assign 
			    tttt_part = ""
			    tttt_comp = yywobmspt_part 
			    tttt_desc = pt_desc1 + " " + pt_desc2
			    tttt_pl = pt_prod_line.
		end. /* if not avail tttt */
		if yywobmspt_elem = "����" then assign tttt_stdmtlcost = pcqty * yywobmspt_elem_cost.
		else if yywobmspt_elem = "��˰�˷�" then assign tttt_stdfrtcost = pcqty * yywobmspt_elem_cost.
		else if yywobmspt_elem = "ת��" then assign tttt_stdsubcost = pcqty * yywobmspt_elem_cost.
		else if yywobmspt_elem = "ֱ���˹�" then assign tttt_stdlbrcost = pcqty * yywobmspt_elem_cost.
		else if yywobmspt_elem = "�������" then assign tttt_stdmfgcost = pcqty * yywobmspt_elem_cost.

    end. /* for each yywobmspt_mstr */
	
    for first yycsvar_mstr no-lock where yycsvar_part = part
	and yycsvar_year = iyear
	and yycsvar_per = iper:

		find first tttt where tttt_part = "" and tttt_comp = yycsvar_part no-error.
		if not avail tttt then do:
			create tttt.
			assign 
			    tttt_part = ""
			    tttt_comp = yycsvar_part 
			    tttt_desc = pt_desc1 + " " + pt_desc2
			    tttt_pl = pt_prod_line.
		end. /* if not avail tttt */
		/*IC-WO BOM���
		tttt_bomchgvar = yycsvar_variance[1]. */
		/*IC-WO ·�߱��*/
		tttt_routchgvar = yycsvar_variance[2].
		/*IC-WO ������������*/
		tttt_mtdchgvar1 = yycsvar_variance[3].
		/*IC-WO ��������۲�*/
		tttt_mtdchgvar2 = yycsvar_variance[4].
		/*IC-WO ��ʱ���*/
		tttt_ptrepvar1 = yycsvar_variance[5].
		/*IC-WO ������*/
		tttt_ptrepvar2 = yycsvar_variance[6].
		/*IC-WO �ʲ�*/
		tttt_ratevar = yycsvar_variance[7].
		/*IC-WO ����*/
		tttt_othervar = yycsvar_variance[8].
		/*����ƷPPV����*/
		tttt_ppvvar1 = yycsvar_variance[13].
		/*���ư��Ʒ���ϲ���*/
		tttt_ppvvar2 = yycsvar_variance[14].
		/*���˲���*/
		tttt_glmtlvar = yycsvar_variance[15].
		/*����Ʒ - �˹�����*/
		tttt_lbrvar1 = yycsvar_variance[16].
		/*���ư��Ʒ - �˹�����*/
		tttt_lbrvar2 = yycsvar_variance[17].
		/*����Ʒ - ������ò���*/
		tttt_mfgvar1 = yycsvar_variance[18].
		/*���ư��Ʒ - ������ò���*/
		tttt_mfgvar2 = yycsvar_variance[19].
    end.

    /* ȡʵ�ʳɱ� */
    find first yyactcs_mstr where yyactcs_part = part
	and yyactcs_year = iyear
	and yyactcs_per = iper no-lock no-error.
    if avail yyactcs_mstr then do:
	find first tttt where tttt_part = "" and tttt_comp = yyactcs_part no-error.
	if not avail tttt then do:
		create tttt.
		assign 
		    tttt_part = ""
		    tttt_comp = yyactcs_part 
		    tttt_desc = pt_desc1 + " " + pt_desc2
		    tttt_pl = pt_prod_line.
	end. /* if not avail tttt */
	assign 
	    tttt_actmtl = yyactcs_act_mtl
	    tttt_actlbr = yyactcs_act_lbr
	    tttt_actmfg = yyactcs_act_mfg
	    tttt_totalcost = tttt_actmtl + tttt_actlbr + tttt_actmfg.
		
    end. /* if avail yyactcs_mstr */ 

    /* ȡ��ϸ��׼�ɱ� */
    for each yywobmsptd_det no-lock where yywobmsptd_site = v_site
	and yywobmsptd_part = part 
	and yywobmsptd_version = v_version:
	find first tttt where tttt_part = part and tttt_comp = yywobmsptd_comp no-error.
	if not avail tttt then do:
		find first bptmstr where bptmstr.pt_part = yywobmsptd_comp no-lock no-error.
		create tttt.
		assign tttt_part = part
		       tttt_comp = yywobmsptd_comp
		       tttt_desc = bptmstr.pt_desc1 + "" + bptmstr.pt_desc2
		       tttt_pl	 = bptmstr.pt_prod_line.
	end.
	if yywobmsptd_elem = "����" then 
		assign tttt_stdmtlcost = pcqty * yywobmsptd_unit_qty * yywobmsptd_elem_cost.
	else if yywobmsptd_elem = "��˰�˷�" then 
		assign tttt_stdfrtcost = pcqty * yywobmsptd_unit_qty * yywobmsptd_elem_cost.
	else if yywobmsptd_elem = "ת��" then 
		assign tttt_stdsubcost = pcqty * yywobmsptd_unit_qty * yywobmsptd_elem_cost.
	else if yywobmsptd_elem = "ֱ���˹�" then 
		assign tttt_stdlbrcost = pcqty * yywobmsptd_unit_qty * yywobmsptd_elem_cost.
	else if yywobmsptd_elem = "�������" then 
		assign tttt_stdmfgcost = pcqty * yywobmsptd_unit_qty * yywobmsptd_elem_cost.

    end. /* for each yywobmsptd_det */


    /* ICWO ���� */
    for each yycsvard_det no-lock where yycsvard_part = part
	and yycsvard_year = iyear
	and yycsvard_per = iper:
	find first tttt where tttt_part = part and tttt_comp = yycsvard_comp no-error.
	if not avail tttt then do:
		find first bptmstr where bptmstr.pt_part = yycsvard_comp no-lock no-error.
		create tttt.
		assign tttt_part = part
		       tttt_comp = yycsvard_comp
		       tttt_desc = bptmstr.pt_desc1 + "" + bptmstr.pt_desc2
		       tttt_pl	 = bptmstr.pt_prod_line.
	end.
	/*IC-WO BOM���
	tttt_bomchgvar = yycsvard_variance[1]. */
	/*IC-WO ·�߱��*/ 
	tttt_routchgvar = yycsvard_variance[2].
	/*IC-WO ������������*/ 
	tttt_mtdchgvar1 = yycsvard_variance[3].
	/*IC-WO ��������۲�*/ 
	tttt_mtdchgvar2 = yycsvard_variance[4].
	/*IC-WO ��ʱ���*/ 
	tttt_ptrepvar1 = yycsvard_variance[5].
	/*IC-WO ������*/ 
	tttt_ptrepvar2 = yycsvard_variance[6].
	/*IC-WO �ʲ�*/ 
	tttt_ratevar = yycsvard_variance[7].
	/*IC-WO ����*/ 
	tttt_othervar = yycsvard_variance[8].
	/*����ƷPPV����*/ 
	tttt_ppvvar1 = yycsvard_variance[13].
	/*���ư��Ʒ���ϲ���*/ 
	tttt_ppvvar2 = yycsvard_variance[14].
	/*���˲���*/ 
	tttt_glmtlvar = yycsvard_variance[15].
	/*����Ʒ - �˹�����*/ 
	tttt_lbrvar1 = yycsvard_variance[16].
	/*���ư��Ʒ - �˹�����*/ 
	tttt_lbrvar2 = yycsvard_variance[17].
	/*����Ʒ - ������ò���*/ 
	tttt_mfgvar1 = yycsvard_variance[18].
	/*���ư��Ʒ - ������ò���*/ 
	tttt_mfgvar2 = yycsvard_variance[19].
    end. /* for each yycsvard_det */

    /* ȡʵ�ʳɱ� */
    for each yyactcsd_det no-lock where yyactcsd_part = part
	and yyactcsd_year = iyear
	and yyactcsd_per = iper:
	
	find first tttt where tttt_part = part and tttt_comp = yyactcsd_comp no-error.
	if not avail tttt then do:
		find first bptmstr where bptmstr.pt_part = yyactcsd_comp no-lock no-error.
		create tttt.
		assign tttt_part = part
		       tttt_comp = yyactcsd_comp
		       tttt_desc = bptmstr.pt_desc1 + "" + bptmstr.pt_desc2
		       tttt_pl	 = bptmstr.pt_prod_line.
	end.
	assign 
	    tttt_actmtl = yyactcsd_act_mtl
	    tttt_actlbr = yyactcsd_act_lbr
	    tttt_actmfg = yyactcsd_act_mfg
	    tttt_totalcost = tttt_actmtl + tttt_actlbr + tttt_actmfg.

    end. /* if avail yyactcs_mstr */

    h-tt = TEMP-TABLE tttt:HANDLE.
    RUN value(lc(global_user_lang) + "\yy\yytoexcel.p") (INPUT TABLE-HANDLE h-tt, INPUT inp_where, INPUT inp_sortby, INPUT v_list, INPUT inp_bwstitle).        
    empty temp-table tttt.

END.

