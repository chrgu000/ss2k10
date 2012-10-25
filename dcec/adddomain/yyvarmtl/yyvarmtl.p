/* yyvrmtl.p - ������Ʒ�����Ʒ��ϼ��ͳ�Ʒ���ϲ� */
/* Author: James Duan   *DATE:2009-09-21*           */
/* Author: Henri Zhu    *DATE:2012-08-14*           */

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "20120814"}

DEFINE VARIABLE part		LIKE pt_part.
DEFINE VARIABLE part1		LIKE pt_part.

DEFINE VARIABLE iyear		AS INT format "9999".
DEFINE VARIABLE iper		AS INT format "99".

DEFINE VARIABLE v_flag		AS CHAR.
DEFINE VARIABLE v_ok		AS LOGICAL.
DEFINE VARIABLE v_pmcode	LIKE pt_pm_code.
DEFINE VARIABLE theyear		AS INT.
DEFINE VARIABLE theper		AS INT.
DEFINE VARIABLE per_start	LIKE glc_start.
DEFINE VARIABLE per_end		LIKE glc_end.
DEFINE VARIABLE pbqty		LIKE yypbd_qty.
DEFINE VARIABLE pcqty		LIKE yyinvi_mfg_qty.
DEFINE VARIABLE pbamt		LIKE yypbd_mtl_var.
DEFINE VARIABLE icount		AS INT.

DEFINE TEMP-TABLE ttt1
    FIELDS ttt1_woid LIKE wo_lot
    FIELDS ttt1_part LIKE wo_part
    FIELDS ttt1_comp LIKE wod_part
    FIELDS ttt1_cmmt AS CHAR FORMAT "x(30)".

form 
 ttt1_woid column-label "������־"
 ttt1_part column-label "���"
 ttt1_comp column-label "�����"
 ttt1_cmmt column-label "��ʾ��Ϣ"
with frame c width 100 down.
DEFINE TEMP-TABLE ttvarmtl
	fields ttvarmtl_part like pt_part
	fields ttvarmtl_pline like pt_prod_line
	fields ttvarmtl_pbqty like yyinvi_mfg_qty  
	fields ttvarmtl_pcqty like yyinvi_mfg_qty  
	fields ttvarmtl_pbamt like yypbd_mtl_var 
	fields ttvarmtl_pcamt like yypbd_mtl_var 
	fields ttvarmtl_rate  like yyvarated_mtl_rate 
index main_index is primary unique ttvarmtl_part.

iyear = year(today).
iper = month(today).
form
  ttvarmtl_part  column-label "���"
  ttvarmtl_pline column-label "��Ʒ��"
  ttvarmtl_pbqty column-label "�ڳ����" format "->>>,>>>,>>>,>>9"
  ttvarmtl_pcqty column-label "�������" format "->>>,>>>,>>>,>>9"

  ttvarmtl_pbamt column-label "�ڳ��ϲ�" format "->>>,>>>,>>>,>>9.99"

  ttvarmtl_pcamt column-label "�����ϲ�" format "->>>,>>>,>>>,>>9.99"

  ttvarmtl_rate column-label "�ϲ���" format "->>>,>>>,>>>,>>9.99"
with frame d width 320 down.
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    part	COLON 20 
    part1	COLON 45 LABEL "��"
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

{wbrp01.i}
REPEAT:
    IF part1 = hi_char THEN part1 = "".   

    UPDATE 
        part part1
        iyear iper 

    WITH FRAME a.
    
    IF part1 = "" THEN part1 = hi_char.


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

    /* ȷ��������ϲ����ڼ� */
    find first glc_cal where glc_domain = global_domain and glc_year = iyear and glc_per = iper no-lock no-error.
    if not avail glc_cal then do:
	message "�����ڼ�δ����!" view-as alert-box.
    end.
    assign
	theyear = glc_year
	theper = glc_per
	per_start = glc_start
	per_end = glc_end.
    /* ��ʼ��������Ϣ */
    put "���㿪ʼ:"  string(time, "HH:MM:SS") skip.
 
    for each yycsvar_mstr where yycsvar_domain = global_domain 
         and yycsvar_year = theyear and yycsvar_per = theper
	       and (yycsvar_part >= part and yycsvar_part <= part1)
	       and (yycsvar_pm_code <> "P" or 
	     can-find(first code_mstr where code_domain = global_domain and code_fldname = "sub_line" and code_value = yycsvar_part_pl no-lock)) :

	for each yycsvard_det where yycsvard_domain = global_domain 
	  and yycsvard_year = theyear
		and yycsvard_per = theper
		and yycsvard_part = yycsvar_part :
		assign  yycsvard_variance[13] = 0
			yycsvard_variance[14] = 0.
	end. 
	assign yycsvar_variance[13] = 0
		yycsvar_variance[14] = 0.
	if can-find(first code_mstr where code_domain = global_domain and code_fldname = "sub_line" and code_value = yycsvar_part_pl no-lock) then
		assign 
		  yycsvar_variance[13] = yycsvar_variance[21]
		  yycsvar_variance[14] = yycsvar_variance[22].
    end. /* for each yycsvar_mstr */
    for each yyvarated_det where yyvarated_domain = global_domain 
       and yyvarated_year = theyear
	     and yyvarated_per = theper
	     and (yycsvar_part >= part and yycsvar_part <= part1)
	     and (yycsvar_pm_code <> "P" or 
	     can-find(first code_mstr where code_domain = global_domain and code_fldname = "sub_line" and code_value = yycsvar_part_pl no-lock)) :
	assign yyvarated_mtl_rate = 0.    
    end. /* for each yyvarated_det */	
    /* ���μ���prod line: 6xxx,5xxx,7xxx��8xxx�ĳ�Ʒ�����Ʒ */
    for each code_mstr where code_domain = global_domain and code_fldname = "sub_line" no-lock:
	v_flag = code_value.
	run yypro-cal-var(input v_flag,output v_ok). 
    end. 
    v_flag = "6".
    run yypro-cal-var(input v_flag,output v_ok). 
    v_flag = "5".
    run yypro-cal-var(input v_flag,output v_ok). 
    v_flag = "7".
    run yypro-cal-var(input v_flag,output v_ok). 
    v_flag = "8".
    run yypro-cal-var(input v_flag,output v_ok). 

    put "�������:"  string(time, "HH:MM:SS") skip.

    {mfreset.i}
    {mfgrptrm.i} /*Report-to-Window*/
END.
{wbrp04.i &frame-spec = a}


/**********************************/
PROCEDURE xxpro-chk-bom:
    DEFINE INPUT PARAMETER p_part AS CHAR.
    DEFINE INPUT PARAMETER p_site AS CHAR.
    DEFINE INPUT PARAMETER p_woid AS CHAR.
    DEFINE INPUT PARAMETER p_date AS DATE.
    DEFINE OUTPUT PARAMETER p_results AS CHAR.

    p_results = "".
    FIND LAST xxwobmfm_mstr 
        WHERE xxwobmfm_domain = global_domain 
        and xxwobmfm_part = p_part 
        AND xxwobmfm_site = p_site 
        USE-INDEX xxwobmfm_idx2
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE xxwobmfm_mstr THEN DO:
        p_results = "��BOMδ����,���ܼ���".
    END.
END PROCEDURE.

/***********************************/
PROCEDURE yypro-cal-var:    
    define input parameter p_line_flag as char.
    define output parameter p_ok as logical.
    put skip(1) "��ʼ������"  p_line_flag  "��ͷ�Ĳ�Ʒ��" skip.
    wo_loop:
    for each wo_mstr no-lock where wo_domain = global_domain 
        and wo_status = "C"
      	and ( wo_type = "C" or wo_type = "E" or wo_type = "")
        and  (wo_part >= part and wo_part <= part1)
       /* and  (wo_site >= site and wo_site <= site1) */
        and  (wo_due_date >= per_start and wo_due_date <= per_end):

        find first pt_mstr where pt_domain = global_domain and pt_part = wo_part no-lock no-error.
	if not avail pt_mstr or not (pt_prod_line begins p_line_flag) then next wo_loop.
	/*
	�Ƿ������ί���
	find first code_mstr where code_fldname = "sub_line" and code_value = pt_prod_line no-lock no-error.
	if avail code_mstr then next.
	*/
	find first ttvarmtl where ttvarmtl_part = wo_part no-lock no-error.
	if not avail ttvarmtl then do:
		create ttvarmtl.
		assign 
		    ttvarmtl_part = wo_part
		    ttvarmtl_pline = pt_prod_line.
	end. /* if not avail ttvarmtl */

	/* ���㱾��ppv + ���Ʒ���ϲ��� */
	wod_loop:
	for each wod_det no-lock where wod_domain = global_domain 
	  and wod_lot = wo_lot and wod_qty_iss <> 0:
		find first pt_mstr where pt_domain = global_domain and pt_part = wod_part no-lock no-error.
		if not avail pt_mstr then next wod_loop.
		/* ���ظ������Լ������Լ� */





		if wo_type = "E" and wo_part = wod_part then next.
		/****
		find first yycsvar_mstr where yycsvar_year = theyear
			and yycsvar_per = theper 
			and yycsvar_part = wod_part no-lock no-error.
		if not avail yycsvar_mstr then next.
		*****/
		find first ptp_det where ptp_domain = global_domain and ptp_part = pt_part and ptp_site = wod_site no-lock no-error.
		if avail ptp_det then assign v_pmcode = ptp_pm_code.
		else assign v_pmcode = pt_pm_code.
		find first yyvarated_det where yyvarated_domain = global_domain 
		  and yyvarated_year = theyear and yyvarated_per = theper
			and yyvarated_part = wod_part no-lock no-error.
		if avail yyvarated_det then do:
			find first yycsvard_det where yycsvard_domain = global_domain 
			  and yycsvard_year = theyear
				and yycsvard_per = theper
				and yycsvard_part = ttvarmtl_part
				and yycsvard_comp = wod_part no-error.
			if not avail yycsvard_det then do:
				create yycsvard_det.
				assign 
                                    yycsvard_domain = global_domain
				    yycsvard_part = ttvarmtl_part   
				    yycsvard_comp = wod_part 
				    yycsvard_year = theyear
				    yycsvard_per = theper.	    					
			end. 
			assign 
			    yycsvard_part_pl = ttvarmtl_pline
			    yycsvard_comp_pl = pt_prod_line.

			/* ���ܲ��ϲ�����ϸ������ */
			find first yycsvar_mstr where yycsvar_domain = global_domain 
			  and yycsvar_year = theyear
				and yycsvar_per = theper
				and yycsvar_part = ttvarmtl_part no-error.
			if not avail yycsvar_mstr then do:
				create yycsvar_mstr.
				assign yycsvar_domain = global_domain
				    yycsvar_part = ttvarmtl_part
				    yycsvar_year = theyear
				    yycsvar_per = theper
				    yycsvar_pm_code = "M".
			end. /* if not avail yycsvar_mstr */
			assign 
			    yycsvar_part_pl = ttvarmtl_pline.

			/* ע�������ȡ����Ӧ���� ptp_pm_code */
			/* ����ƷPPV���� */
			if v_pmcode = "P" then 
				assign yycsvard_variance[13] = yycsvard_variance[13] + wod_qty_iss * yyvarated_mtl_rate 
				       yycsvar_variance[13] = yycsvar_variance[13] + wod_qty_iss * yyvarated_mtl_rate.
			/* ���ư��Ʒ���ϲ��� */
			else if v_pmcode = "M" then 
				assign yycsvard_variance[14] = yycsvard_variance[14] + wod_qty_iss * yyvarated_mtl_rate
				       yycsvar_variance[14] = yycsvar_variance[14] + wod_qty_iss * yyvarated_mtl_rate. 
			
			release yycsvar_mstr.
			release yycsvard_det.
		end. /* if avail yyvarated_det */
		else do:
			find first ttt1 where  ttt1_woid = wo_lot
				and ttt1_part = wo_part 
				and ttt1_comp = wod_part no-error.
			if not avail ttt1 then do:
				create ttt1.
				assign
				    ttt1_woid = wo_lot
				    ttt1_part = wo_part
				    ttt1_comp = wod_part
				    ttt1_cmmt = "����δ����".
			end. /* if not avail ttt1 */
			next wod_loop.
		end. /* if not avail yyvarated_det */
	end. /* for each wod_det */

    end. /* for each wo_mstr */

    for each yypbd_det no-lock where yypbd_domain = global_domain 
        and yypbd_year = theyear and yypbd_per = theper
	      and yypbd_part >= part and yypbd_part <= part1:
	      if not( yypbd_part_pl begins p_line_flag ) then next.
   	find first ttvarmtl where ttvarmtl_part = yypbd_part no-error.
	if avail ttvarmtl then next.
	create ttvarmtl.
	assign
	   ttvarmtl_part = yypbd_part
	   ttvarmtl_pline = yypbd_part_pl.
    end. /* for each yypbd_det */

    for each yycsvar_mstr no-lock where yycsvar_domain = global_domain 
       and yycsvar_year = theyear and yycsvar_per = theper
	     and yycsvar_part >= part and yycsvar_part <= part1:

	if not (yycsvar_part_pl begins p_line_flag ) then next.
	find first ttvarmtl where ttvarmtl_part = yycsvar_part no-error.
	if avail ttvarmtl then next.
	create ttvarmtl.
	assign
	   ttvarmtl_part = yycsvar_part
	   ttvarmtl_pline = yycsvar_part_pl.	
    end. /* for each yycsvar_mstr */

    for each ttvarmtl no-lock:
	
	/* �ڳ���棬�ϲ� */
	find first yypbd_det where yypbd_domain = global_domain 
	  and yypbd_year = theyear and yypbd_per = theper
		and yypbd_part = ttvarmtl_part no-lock no-error.
	if available yypbd_det then 
		assign ttvarmtl_pbqty = yypbd_qty
		       ttvarmtl_pbamt = yypbd_mtl_var.

	/* ������� */
	find first yyinvi_mstr where yyinvi_domain = global_domain 
	  and yyinvi_year = theyear and yyinvi_per = theper
		and yyinvi_part = ttvarmtl_part no-lock no-error.
	if available yyinvi_mstr then do:
		if can-find(first code_mstr where code_domain = global_domain and code_fldname = "sub_line" and code_value = yyinvi_part_pl no-lock) then
			assign ttvarmtl_pcqty = min(yyinvi_mfg_qty,yyinvi_buy_qty) + yyinvi_upl_qty .
		else
			assign ttvarmtl_pcqty = yyinvi_mfg_qty + yyinvi_upl_qty + yyinvi_buy_qty.
	end.
	
	/* ���ڲ��� */
	for first yycsvar_mstr no-lock where yycsvar_domain = global_domain 
	  and yycsvar_year = theyear
		and yycsvar_per = theper
		and yycsvar_part = ttvarmtl_part:

		/* ic-wo , ppv, ����,�ع� */
		
		do icount = 1 to 15 :
			assign ttvarmtl_pcamt = ttvarmtl_pcamt + yycsvar_variance[icount].
		end.
		ttvarmtl_pcamt = ttvarmtl_pcamt + yycsvar_variance[20].

	end. /* for each yycsvar_mstr */


	/*�ϲ���*/
	find first yyvarated_det where yyvarated_domain = global_domain 
	  and yyvarated_year = theyear
		and yyvarated_per = theper
		and yyvarated_part = ttvarmtl_part no-error.
	if not avail yyvarated_det then do:
		create yyvarated_det.
		assign   
                    yyvarated_domain = global_domain 
		    yyvarated_part = ttvarmtl_part
		    yyvarated_year = theyear
		    yyvarated_per = theper.
	end. /* if not avail yyvarated_det */
	assign
	    yyvarated_part_pl = ttvarmtl_pline.
	if ttvarmtl_pbqty + ttvarmtl_pcqty = 0 then 
		assign yyvarated_mtl_rate = ttvarmtl_pbamt + ttvarmtl_pcamt.
	else 
		assign yyvarated_mtl_rate = (ttvarmtl_pbamt + ttvarmtl_pcamt) / (ttvarmtl_pbqty + ttvarmtl_pcqty).
	assign ttvarmtl_rate = yyvarated_mtl_rate.
	disp ttvarmtl with frame d stream-io.
	down with frame d.
    end. /* for each ttvarmtl */
    
    for each ttt1 no-lock:
        disp ttt1 with frame c stream-io.
	down with frame c.
    end.

    empty temp-table ttt1.
    empty temp-table ttvarmtl.
    p_ok = true.
END PROCEDURE.