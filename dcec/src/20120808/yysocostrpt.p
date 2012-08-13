/* yyactrpt.p - ����Ʒʵ�ʳɱ�����                  */
/* Author: James Duan   *DATE:2009-09-21*           */

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

DEFINE VARIABLE part		LIKE pt_part.
DEFINE VARIABLE part1		LIKE pt_part.
DEFINE VARIABLE line		LIKE pt_prod_line.
DEFINE VARIABLE line1		LIKE pt_prod_line.

DEFINE VARIABLE iyear		AS INT format "9999".
DEFINE VARIABLE iper		AS INT format "99".

define variable pcqty		like yyinvi_mfg_qty.

define variable nxtyear		as int.
define variable nxtper		as int.
define variable stdmtlcost	like yyactcs_act_mtl.
define variable stdmfgcost	like yyactcs_act_mtl.
define variable stdlbrcost	like yyactcs_act_mtl.
define variable actmtlcost	like yyactcs_act_mtl.
define variable actmfgcost	like yyactcs_act_mtl.
define variable actlbrcost	like yyactcs_act_mtl.
define variable v_version	like yywobmspt_version.
define variable v_site		like yywobmspt_site.
define variable i		as int.
define variable tot_out_qty	as int.

DEFINE VARIABLE h-tt		AS HANDLE.
DEFINE VARIABLE inp_where	AS CHAR.
DEFINE VARIABLE inp_sortby	AS CHAR.
DEFINE VARIABLE inp_bwstitle	AS CHAR.
DEFINE VARIABLE v_list		AS CHAR INITIAL "".

define temp-table tttt RCODE-INFORMATION
    fields tttt_part		like pt_part			label "�����"
    fields tttt_desc		like pt_desc1			label "�������"
    fields tttt_pl		like pt_prod_line		label "��Ʒ��"
    fields tttt_pbqty		like yyinvpbd_qty		label "�ڳ�����"
    fields tttt_pbmtl		like yywobmspt_elem_cost	label "�ڳ����-��"
    fields tttt_pblbr		like yywobmspt_elem_cost	label "�ڳ����-��"
    fields tttt_pbmfg		like yywobmspt_elem_cost	label "�ڳ����-��"
    fields tttt_pcqty		like yyinvi_buy_qty		label "���������"
    fields tttt_pcmtl		like yywobmspt_elem_cost	label "���������-��"
    fields tttt_pclbr		like yywobmspt_elem_cost	label "���������-��"
    fields tttt_pcmfg		like yywobmspt_elem_cost	label "���������-��"
    fields tttt_pbvarmtl	like yyvarpbd_mtl_var		label "�ڳ�������"
    fields tttt_pcvarmtl	like yycsvar_variance[1]	label "������������-��"
    fields tttt_pcvarlbr	like yycsvar_variance[1]	label "������������-��"
    fields tttt_pcvarmfg	like yycsvar_variance[1]	label "������������-��"
    fields tttt_soqty		like yyinvo_qty			label "���۳�����"
    fields tttt_somtl		like yyactcs_act_mtl		label "���۳�����-��"
    fields tttt_solbr		like yyactcs_act_lbr		label "���۳�����-��"
    fields tttt_somfg		like yyactcs_act_mfg		label "���۳�����-��"
    fields tttt_wocqty		like yyinvo_qty			label "װ����������"
    fields tttt_wocmtl		like yyactcs_act_mtl		label "װ��������-��"
    fields tttt_woclbr		like yyactcs_act_lbr		label "װ��������-��"
    fields tttt_wocmfg		like yyactcs_act_mfg		label "װ��������-��"
    fields tttt_woeqty		like yyinvo_qty			label "���Ƴ�������"
    fields tttt_woemtl		like yyactcs_act_mtl		label "���Ƴ�����-��"
    fields tttt_woelbr		like yyactcs_act_lbr		label "���Ƴ�����-��"
    fields tttt_woemfg		like yyactcs_act_mfg		label "���Ƴ�����-��"
    fields tttt_tgqty		like yyinvo_qty			label "������������"
    fields tttt_tgmtl		like yyactcs_act_mtl		label "����������-��"
    fields tttt_tglbr		like yyactcs_act_lbr		label "����������-��"
    fields tttt_tgmfg		like yyactcs_act_mfg		label "����������-��"
    fields tttt_testqty		like yyinvo_qty			label "�����������"
    fields tttt_testmtl		like yyactcs_act_mtl		label "���������-��"
    fields tttt_testlbr		like yyactcs_act_lbr		label "���������-��"
    fields tttt_testmfg		like yyactcs_act_mfg		label "���������-��"
    fields tttt_peqty		like yyinvpbd_qty		label "��ĩ����"
    fields tttt_pemtl		like yywobmspt_elem_cost	label "��ĩ���-��"
    fields tttt_pelbr		like yywobmspt_elem_cost	label "��ĩ���-��"
    fields tttt_pemfg		like yywobmspt_elem_cost	label "��ĩ���-��"
    fields tttt_pevar		like yyvarpbd_mtl_var		label "��ĩ������"

index part is primary tttt_part.	

iyear = year(today).
iper = month(today).	


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    part	COLON 20 
    part1	COLON 45 LABEL "��"
    SKIP
    line	COLON 20 
    line1	COLON 45 LABEL "��"
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
    find first glc_cal where glc_year = iyear and glc_per = iper no-lock no-error.
    if not avail glc_cal then do:
	message "�����ڼ�δ����!" view-as alert-box.
	next.
    end.
/***********************************************************************
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
*************************************************************************/
    

    for each pt_mstr no-lock where pt_part >= part and pt_part <= part1
		and pt_prod_line >= line and pt_prod_line <= line1:

	find first tttt where tttt_part = pt_part no-error.
	if not avail tttt then do:
		create tttt.
		assign 
		   tttt_part = pt_part
		   tttt_desc = pt_desc1 + " " + pt_desc2
		   tttt_pl = pt_prod_line.
	end. /* if not avail tttt */
	/* ȡ��׼�ɱ� */
	find last yywobmspt_mstr where yywobmspt_part = pt_part 
		and year(yywobmspt_mod_date) <= iyear
		and month(yywobmspt_mod_date)<= iper  no-lock no-error.
	if not avail yywobmspt_mstr then next.
	assign 
	   v_version = yywobmspt_version
	   v_site = yywobmspt_site
	   stdmtlcost = 0
	   stdlbrcost = 0
	   stdmfgcost = 0.
	
	for each yywobmspt_mstr no-lock where yywobmspt_site = v_site
			and yywobmspt_part = pt_part 
			and yywobmspt_version = v_version :
		if yywobmspt_elem = "����" or yywobmspt_elem = "��˰�˷�" or yywobmspt_elem = "ת��" then 
			assign stdmtlcost = stdmtlcost + yywobmspt_elem_cost.

		if yywobmspt_elem = "ֱ���˹�" then 
			assign stdlbrcost = stdlbrcost + yywobmspt_elem_cost.

		if yywobmspt_elem = "�������" then 
			assign stdmfgcost = stdmfgcost + yywobmspt_elem_cost. 
	end. /* for each yywobmspt_mstr */

	/* ȡ�ڳ����� */
	find first yyinvpbd_det where yyinvpbd_year = iyear
		and yyinvpbd_per = iper 
		and yyinvpbd_part = pt_part no-lock no-error.
	if avail yyinvpbd_det then 
		assign 
		   tttt_pbqty = yyinvpbd_qty
		   tttt_pbmtl = tttt_pbqty * stdmtlcost
		   tttt_pblbr = tttt_pbqty * stdlbrcost
		   tttt_pbmfg = tttt_pbqty * stdmfgcost.

	/* ȡ����������� */
	find first yyinvi_mstr where yyinvi_year = iyear
		and yyinvi_per = iper 
		and yyinvi_part = pt_part no-lock no-error.
	if avail yyinvi_mstr then 
		assign 
		   tttt_pcqty = yyinvi_mfg_qty + yyinvi_upl_qty + yyinvi_buy_qty
	           tttt_pcmtl = tttt_pcqty * stdmtlcost
		   tttt_pclbr = tttt_pcqty * stdlbrcost
		   tttt_pcmfg = tttt_pcqty * stdmfgcost.
	
	/* ȡ�ڳ����� */
	find first yyvarpbd_det where yyvarpbd_year = iyear
		and yyvarpbd_per = iper 
		and yyvarpbd_part = pt_part no-lock no-error.
	if avail yyvarpbd_det then
		assign tttt_pbvarmtl = yyvarpbd_mtl_var.

	/* ȥ���ڲ�����*/
	find first yycsvar_mstr where yycsvar_year = iyear
		and yycsvar_per = iper 
		and yycsvar_part = pt_part no-lock no-error.
	if avail yycsvar_mstr then do:
		do i = 1 to 15 :
			tttt_pcvarmtl = tttt_pcvarmtl + yycsvar_variance[i].
		end.
		tttt_pcvarlbr = +  yycsvar_variance[16] +  yycsvar_variance[17].
		tttt_pcvarmfg = +  yycsvar_variance[18] +  yycsvar_variance[19].
	end. /* if avail yycsvar_mstr */

	/* ȡʵ�ʳɱ� */
	assign
	   actmtlcost = 0
	   actlbrcost = 0
	   actmfgcost = 0.
	find first yyactcs_mstr where yyactcs_year = iyear
		and yyactcs_per = iper
		and yyactcs_part = pt_part no-lock no-error.
	if avail yyactcs_mstr then do:
		assign 
		    actmtlcost = yyactcs_act_mtl
		    actlbrcost = yyactcs_act_lbr
		    actmfgcost = yyactcs_act_mfg.		
	end. /* if avail yyactcs_mstr */ 

	/* ȡ���� */
	assign tot_out_qty = 0.
	for each yyinvo_mstr no-lock where yyinvo_year = iyear
		and yyinvo_per = iper
		and yyinvo_part = pt_part 
		use-index yyinvo_perd_part:
		if yyinvo_out_type = "����" then 
			assign tttt_soqty = tttt_soqty + yyinvo_qty.
		else if yyinvo_out_type = "װ��" then
			assign tttt_wocqty = tttt_wocqty + yyinvo_qty.
		else if yyinvo_out_type = "����" then 
			assign tttt_woeqty = tttt_woeqty + yyinvo_qty.
		else if yyinvo_out_type = "�ƻ�������" then
			assign tttt_tgqty = tttt_tgqty + yyinvo_qty.
		else if yyinvo_out_type = "�ƻ�������" then
			assign tttt_testqty = tttt_testqty + yyinvo_qty.
		tot_out_qty = tot_out_qty + yyinvo_qty.
	end. /* for each yyinvo_mstr */
	assign
	    tttt_somtl = tttt_soqty * actmtlcost
	    tttt_solbr = tttt_soqty * actlbrcost
	    tttt_somfg = tttt_soqty * actmfgcost
	    tttt_wocmtl = tttt_wocqty * actmtlcost
	    tttt_woclbr = tttt_wocqty * actlbrcost
	    tttt_wocmfg = tttt_wocqty * actmfgcost
	    tttt_woemtl = tttt_woeqty * actmtlcost
	    tttt_woelbr = tttt_woeqty * actlbrcost
	    tttt_woemfg = tttt_woeqty * actmfgcost
	    tttt_tgmtl = tttt_tgqty * actmtlcost
	    tttt_tglbr = tttt_tgqty * actlbrcost
	    tttt_tgmfg = tttt_tgqty * actmfgcost
	    tttt_testmtl = tttt_testqty * actmtlcost
	    tttt_testlbr = tttt_testqty * actlbrcost
	    tttt_testmfg = tttt_testqty * actmfgcost.

	/* ������ĩ���� */
	nxtper = (if iper = 12 then 1 else (iper + 1)).
	nxtyear = (if iper = 12 then iyear + 1 else iyear).
	/* �����ڳ���� */
	find first yyinvpbd_det where  yyinvpbd_year = nxtyear
		and yyinvpbd_per = nxtper
		and yyinvpbd_part = pt_part no-error.
	if not avail yyinvpbd_det then do:
		create yyinvpbd_det.
		assign 
		    yyinvpbd_part = pt_part
		    yyinvpbd_year = nxtyear
		    yyinvpbd_per = nxtper
		    yyinvpbd_part_pl = pt_prod_line 
	            yyinvpbd_qty = tttt_pbqty + tttt_pcqty - tot_out_qty.
		/* ȡ��ǰbom�汾 */
		find last xxwobmfm_mstr where xxwobmfm_part = pt_part
			and year(xxwobmfm_date_mod) <= iyear
			and month(xxwobmfm_date_mod) <= iper
			use-index xxwobmfm_idx1 no-lock no-error.
		if avail xxwobmfm_mstr then assign yyinvpbd_std_bom = xxwobmfm_version.
	end. /* if not avail yyinvpbd_det */
	assign
	   tttt_peqty = yyinvpbd_qty
	   tttt_pemtl = tttt_peqty * actmtlcost
	   tttt_pelbr = tttt_peqty * actlbrcost
	   tttt_pemfg = tttt_peqty * actmfgcost.

	/* �����ڳ����� */
	find first yyvarpbd_det where yyvarpbd_year = nxtyear
		and yyvarpbd_per = nxtper
		and yyvarpbd_part = pt_part no-error.
	if not avail yyvarpbd_det then do:
		create yyvarpbd_det.
		assign
		    yyvarpbd_part = pt_part
		    yyvarpbd_year = nxtyear
		    yyvarpbd_per = nxtper
		    yyvarpbd_part_pl = pt_prod_line.
		find first yyvarated_det where yyvarated_part = pt_part
			and yyvarated_year = iyear
			and yyvarated_per = iper no-lock no-error.
		if avail yyvarated_det then 
			assign yyvarpbd_mtl_var = yyinvpbd_qty * yyvarated_mtl_rate.
		else put pt_part "�ϲ�����δ����" skip.
	end. /* if not avail yyvarpbd_det */
	assign 
	   tttt_pevar = yyvarpbd_mtl_var.


    end. /* for each pt_mstr */

    h-tt = TEMP-TABLE tttt:HANDLE.
    RUN value(lc(global_user_lang) + "\yy\yytoexcel.p") (INPUT TABLE-HANDLE h-tt, INPUT inp_where, INPUT inp_sortby, INPUT v_list, INPUT inp_bwstitle).        
    empty temp-table tttt.
END.