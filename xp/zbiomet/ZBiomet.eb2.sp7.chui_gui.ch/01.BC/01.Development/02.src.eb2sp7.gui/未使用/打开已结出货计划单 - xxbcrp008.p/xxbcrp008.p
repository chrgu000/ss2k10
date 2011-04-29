/* xxbcrp008.p ���ѽ�����ƻ���,�Գ���                                   */
/* REVISION: 1.0         Last Modified: 2008/10/27   By: Roger   NO ECO    */ 
/*-Revision end------------------------------------------------------------*/

/*����table&�߼�δ���ǲο���*/



{mfdtitle.i "2+ "}



define var nbr  as char format "x(8)" .
define var ship_to as char format "x(8)"  .

define var v_file as char format "x(30)" .
define var v_line as integer .
define var v_qty_lad like ld_qty_oh .
define var v_trnbr   like tr_trnbr .

define var v_update  like mfc_logical no-undo.               /*for updateall */
define var yn        like mfc_logical no-undo.               /*for dispall */
define var yn2       like mfc_logical no-undo.               /*for dispall */
define var aa_from_recno as recid format "->>>>>>9".   /*for dispall */       
define var first_sw_call as logical initial true.     /*for dispall */ 

define variable xapplication as com-handle. /*for excel*/  
define variable xworkbook as com-handle.    /*for excel*/  
define variable xworksheet as com-handle.   /*for excel*/  
define variable x_row as integer init 1.    /*for excel*/  
define variable x_col as integer init 1.    /*for excel*/  

define temp-table temp1 /*����������ϸ*/
    field t1_sonbr    like so_nbr
    field t1_soline   like sod_line
    field t1_part     like sod_part 
    field t1_lot      like ld_lot 
    field t1_loc      like ld_loc 
    field t1_qty_pk   like sod_qty_ord 
    field t1_select    as char format "x(1)"
    field t1_line      as integer 
    .


/*GUI preprocessor Frame A define A*/
&SCOPED-DEFINE PP_FRAME_NAME 

FORM  
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  

    nbr         colon 18 label "�ƻ�����" 
    ship_to     colon 18 label "���˵�"

    /*
    skip(2)
    "˵��: 1.ѡ�еı���������ı�,������β��� "     colon 15 
    "      2.ѡ�еı������״̬:���ѽ��Ϊ������"    colon 15
    "      3.ѡ�еı�����α�����:����"              colon 15
    */
    SKIP(4)  
with frame a side-labels width 80 NO-BOX THREE-D .

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = "".
RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
RECT-FRAME:HEIGHT-PIXELS in frame a =
FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. 

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


/*setFrameLabels(frame a:handle).*/

find last xpk_mstr no-lock no-error .
nbr = if avail xpk_mstr then xpk_nbr else "" .

{wbrp01.i}
mainloop:
repeat: 
    for each temp1 : delete temp1 .  end.

    clear frame a no-pause .
    disp nbr ship_to with frame a  .

    update nbr with frame a editing:
        {mfnp11.i xpk_mstr xpk_nbr2 xpk_nbr "input nbr" }
        IF recno <> ?  THEN DO:
            DISP xpk_nbr @ nbr xpk_shipto @ ship_to
            with frame a.
        END.  /*if recno<> ?*/
    end. 
    assign nbr .

    if nbr = "" then do:
        message "������ƻ�����" .
        undo,retry .
    end.
    else do: /*��鵥���Ƿ����,���Ѿ��ر� */
        find first xpk_mstr where xpk_nbr = nbr no-lock no-error .
        if not avail xpk_mstr then do:
            message "��Ч�ƻ�����" view-as alert-box.
            undo,retry .
        end.
        else do:
            find first xpk_mstr where xpk_nbr = nbr and xpk_stat = "C" no-lock no-error .
            if not avail xpk_mstr then do:
                message "�ƻ���δ�ر�,�����ٴ�" view-as alert-box.
                undo,retry .
            end.
        end.
        assign nbr = xpk_nbr ship_to = xpk_shipto .

        run selectall  .   /*Ѱ��δ���¼*/

        reopenloop:  /*excelԤ����,�����µĻ�,���������޸�*/
        do on error undo, return error on endkey undo, return error:
            run dispall.    /*�嵥ɸѡ*/
                hide message no-pause.
                if yn2 then yn = no.
                if yn = no then undo mainloop ,retry.   
            run updateall . /*����*/
                if v_update = no then undo reopenloop,retry reopenloop . 
        end. /*reopenloop*/
    end. /*if nbr <> "" */

end. /* mainloop */
{wbrp04.i &frame-spec = a}




/*-----------------------------------------------------------------------------------------------------------------------------------*/
procedure selectall : 
do on error undo, return error on endkey undo, return error:
    for each xpkd_det 
        where xpkd_nbr = nbr 
        and xpkd_qty_pk <> 0 
        no-lock 
        break by xpkd_sonbr by xpkd_soline by xpkd_lot by xpkd_loc :
        if first-of(xpkd_loc) then do:
            v_qty_lad = 0 .
        end. /*if first-of(*/
        
        v_qty_lad = v_qty_lad + xpkd_qty_pk .

        if last-of(xpkd_loc) then do:
            find first temp1 where t1_sonbr = xpkd_sonbr and t1_soline = xpkd_soline and t1_part = xpkd_part and t1_lot = xpkd_lot and t1_loc = xpkd_loc no-error.
            if not avail temp1 then do:
                v_line = 0 .
                find first xpk_mstr 
                    where xpk_sonbr = xpkd_sonbr 
                    and xpk_soline  = xpkd_soline 
                    and xpk_part    = xpkd_part 
                    and xpk_lot     = xpkd_lot 
                    and xpk_loc     = xpkd_loc 
                no-lock no-error .
                if avail xpk_mstr then assign v_line = xpk__int01.
                else do:
                    find first xpk_mstr 
                        where xpk_sonbr = xpkd_sonbr 
                        and xpk_soline  = xpkd_soline 
                        and xpk_part    = xpkd_part  
                        and xpk_loc     = "**�޿��ÿ��**"
                    no-lock no-error .
                    if avail xpk_mstr then assign v_line = xpk__int01.
                end.
                create  temp1.
                assign  t1_sonbr    = xpkd_sonbr 
                        t1_soline   = xpkd_soline 
                        t1_part     = xpkd_part 
                        t1_lot      = xpkd_lot
                        t1_loc      = xpkd_loc
                        t1_qty_pk   = v_qty_lad
                        t1_line     = v_line
                        .
            end.
        end. /*if last-of(*/
    end.
end. 
end procedure. /*selectall*/





/*-----------------------------------------------------------------------------------------------------------------------------------*/

procedure dispall : 
disploop:
repeat :

    form
       t1_select       column-label "*"
       t1_line         column-label "�ƻ�����"
       t1_sonbr        column-label "���۶���"
       t1_soline       column-label "SO��" format ">>>"
       t1_part         column-label "��Ŀ��"
       t1_lot          column-label "����"
       t1_loc          column-label "��λ" 
       t1_qty_pk       column-label "������"
    with frame y 
    row 4 centered overlay three-d  .

    yn = no.
    yn2 = no. 
    view frame y .
    sw:
    do on endkey undo, leave: /*xp001*/  
        message "�밴 'enter'��'space' ��ѡ�� Ҫ�ٴδ򿪵�װ���¼ .".         
        {xxswxp002.i
            &detfile      = temp1
            &scroll-field = temp1.t1_select
            &framename    = "y"
            &framesize    = 10
            &framewidth   = 75
            &sel_on       = ""*""
            &sel_off      = """"
            &display1     = temp1.t1_select
            &display2     = t1_line  
            &display3     = t1_sonbr   
            &display4     = t1_soline
            &display5     = t1_part  
            &display6     = t1_lot   
            &display7     = t1_loc   
            &display8     = t1_qty_pk
            &exitlabel    = sw
            &exit-flag    = first_sw_call 
            &record-id    = aa_from_recno

        }
        if keyfunction(lastkey) = "end-error"
            or lastkey = keycode("f4")
            or keyfunction(lastkey) = "."
            or lastkey = keycode("ctrl-e") then do:
            yn2 = no.
            {pxmsg.i &msgnum=36 &errorlevel=1 &confirm=yn2 } /* ��ȷ���˳� */
            if yn2  then do:
                undo disploop, leave .
            end.
                
        end.        
        else do:
            yn = no.
            {pxmsg.i &msgnum=12 &errorlevel=1 &confirm=yn } /* ������Ϣ�Ƿ���ȷ */
            if yn = no then do:
                yn2 = no.
                {pxmsg.i &msgnum=36 &errorlevel=1 &confirm=yn2 } /* ��ȷ���˳� */
                if yn2  then do:
                    undo disploop, leave .
                end.
                else undo sw, retry.
            end.
            if yn = yes then leave disploop.
        end.
    end. /*sw*/

    hide message no-pause.
    hide frame y no-pause.   

end. 
end procedure. /*dispall*/





/*-----------------------------------------------------------------------------------------------------------------------------------*/

procedure updateall : 
do on error undo, return error on endkey undo, return error:
    v_update = no.
    {pxmsg.i &msgnum=32 &errorlevel=1 &confirm=v_update } /* ��ȷ�ϸ��� */
    if v_update then do:
        find first temp1 where t1_select = "*" no-error.
        if not avail temp1 then do:
            message "δѡ���κ����." view-as alert-box.
            undo,leave .
        end.
        else do:
            v_file = "C:\so_recall_" + string(year(today),"9999") + string(month(today),"99") + string(day(today),"99") + ".txt" .
            output to value(v_file) append.
                put "/*----------------So_Recall_History_Record ---------------------*/" skip .
                put skip(1).
                put "��ʼʱ��:" string(string(year(today),"9999") + "/" + string(month(today),"99") + "/" + string(day(today),"99") + " " + string(time,"HH:MM") ) format "x(50)" skip .

                for each temp1 where t1_select = "*" :

                        /*ʵ��װ����������Ϊ��*/
                        for each xpkd_det 
                            where xpkd_sonbr = t1_sonbr 
                            and xpkd_soline  = t1_soline 
                            and xpkd_part    = t1_part 
                            and xpkd_lot     = t1_lot 
                            and xpkd_loc     = t1_loc :

                            assign xpkd_qty_pk = 0 .
                        end. /*for each xpkd_det*/
                        
                        /*�ƻ�������״̬��ΪA*/
                        find first xpk_mstr 
                            where xpk_sonbr = t1_sonbr 
                            and xpk_soline  = t1_soline 
                            and xpk_part    = t1_part 
                            and xpk_lot     = t1_lot 
                            and xpk_loc     = t1_loc 
                        no-error .
                        if avail xpk_mstr then assign xpk_stat = "A" .
                        else do:
                            find first xpk_mstr 
                                where xpk_sonbr = t1_sonbr 
                                and xpk_soline  = t1_soline 
                                and xpk_part    = t1_part  
                                and xpk_loc     = "**�޿��ÿ��**"
                            no-error .
                            if avail xpk_mstr then assign xpk_stat = "A" .
                        end.

                        /*֮ǰ���ĳ�����¼,ɾ���ƻ�����:tr__chr15 */
                        for each tr_hist 
                            where tr_nbr   = t1_sonbr 
                            and tr_line    = t1_soline 
                            and tr_part    = t1_part 
                            and tr_type    = "ISS-SO" 
                            and tr__chr15  = nbr 
                            and tr_qty_loc = - t1_qty_pk
                            :
                            assign tr__chr15 = "" v_trnbr = tr_trnbr .
                        end.


                        disp nbr         column-label "�ƻ���"
                             t1_line     column-label "�ƻ�����" 
                             t1_sonbr    column-label "���۶���" 
                             t1_soline   column-label "������"
                             t1_part     column-label "��Ŀ��"
                             t1_lot      column-label "����"
                             t1_loc      column-label "��λ"
                             t1_qty_pk   column-label "������"
                             v_trnbr     column-label "ԭ�����"
                        with stream-io width 200 .



                end. /*for each temp1*/

                put skip(1) .
                put "����ʱ��:" string(string(year(today),"9999") + "/" + string(month(today),"99") + "/" + string(day(today),"99") + " " + string(time,"HH:MM") )  format "x(50)" skip .
                put skip(3) .
            output close.
            message "ѡ��ļƻ�������Ѵ�,����ļ�" v_file view-as alert-box title "" .
        end. /*else do:*/
    end.  /*if v_update then*/  
end. 
end procedure. /*updateall*/





