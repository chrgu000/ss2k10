/*xxbcrp001.p ��ͼ�ź��кŴ�ӡ����,ͬʱָ������λ                                */
/* REVISION: 110316.1   Created On: 20110316   By: Softspeed Roger Xiao                               */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110316.1  By: Roger Xiao */  /*ȡ����ӡδ�ջ���,ͬʱָ������λ*/
/* SS - 110322.1  By: Roger Xiao */ /* ��ֿ�λ�͹�����λ,�����Ǽ�����SA����ת����PS */
/* SS - 110326.1  By: Roger Xiao */  /*�к�����ˮ��xxship_case2,����ԭ��Ʊ�к�xxship_case,���������볤�� */
/* SS - 110408.1  By: Roger Xiao */  /*xxinv_mstr ����һ����Ʊ�Ŷ�Ӧ�����Ӧ�̵���� */
/*-Revision end---------------------------------------------------------------*/


{mfdtitle.i "110408.1"} 
define var wsection      as char . /*for barcode print*/
define var ts9030        as char . /*for barcode print*/
define var av9030        as char . /*for barcode print*/
define var v_part        like pt_part.     
define var v_loc         like ld_loc.      
define var v_lot         like ld_lot.      
define var v_date        as date .         
define var v_nbr         like pt_part.     
define var v_qty         like wo_qty_ord.  



define var vend           like xxinv_nbr no-undo.
define var v_inv          like xxinv_nbr no-undo.
define var v_inv1         like xxinv_nbr no-undo.
define var v_vend         like xxinv_nbr no-undo.
define var v_vend1        like xxinv_nbr no-undo.
define var v_ln           like xxship_line no-undo .
define var v_ln1          like xxship_line no-undo .
define var v_tt           like xxship_case no-undo .
define var v_tt1          like xxship_case no-undo .
define var v_vendpart     like vp_vend_part no-undo .
define var v_vendpart1    like vp_vend_part no-undo .
define var v_yn1          as logical no-undo .

define new shared temp-table tempcase   /*��¼ÿ���е��ջ���λ*/
    field tc_ship_nbr like xxship_nbr
    field tc_vend     like xxship_vend
    field tc_case_nbr like xxship_case 
    field tc_loc      like pt_loc
    .


FORM 
    skip(1)
    vend              colon 20
    v_inv             colon 20
    skip(1)

    v_ln              colon 20
    v_ln1             colon 49 label {t001.i} 
    v_tt              colon 20
    v_tt1             colon 49 label {t001.i} 
    v_vendpart        colon 20 label "��Ӧ��ͼ��" format "x(22)"
    v_vendpart1       colon 49 label {t001.i}     format "x(22)"
    skip(1)
    /*v_yn1             colon 20 label "����δ�ջ����"*/


    skip(3)         
with frame a attr-space side-labels width 80.
setFrameLabels(frame a:handle).


{wbrp01.i}
mainloop:
repeat:
    if v_inv1         = hi_char then v_inv1       = "".
    if v_vendpart1    = hi_char then v_vendpart1  = "".
    if v_vend1        = hi_char then v_vend1      = "".
    
    for each tempcase : delete tempcase . end.

    update 
        vend 
        v_inv       

        v_ln        
        v_ln1       
        v_tt        
        v_tt1       
        v_vendpart  
        v_vendpart1    
        
    with frame a.

    find first xxinv_mstr
            where xxinv_vend = vend 
            and   xxinv_nbr  = v_inv 
    no-lock no-error.
    if not avail xxinv_mstr then do:
        message "����:��Ч��Ʊ��,����������".
        undo,retry.
    end.
    
    if v_vend1       = "" then v_vend1       = hi_char.
    if v_inv1        = "" then v_inv1        = hi_char.
    if v_vendpart1   = "" then v_vendpart1   = hi_char.
    if v_ln1         = 0  then v_ln1  = 999999 .
    if v_tt1         = 0  then v_tt1  = 999999 .

    {mfselbpr.i "printer" 80}
        
    printloop:
    do on error undo,retry :

    for each tempcase : delete tempcase . end.


    for each xxinv_mstr
            where  xxinv_vend = vend 
            and    xxinv_nbr  = v_inv 
            no-lock,
        each xxship_Det 
            where xxship_nbr  = xxinv_nbr
            and   xxship_vend = xxinv_vend
            and xxship_line >= v_ln and xxship_line <= v_ln1 
            and xxship_case >= v_tt and xxship_case <= v_tt1 
            and xxship_part >= v_vendpart and xxship_part <= v_vendpart1
            and (xxship_rcvd_effdate <> ? ) /*or v_yn1 )
        no-lock*/ :

        if xxship_rcvd_loc = "" then do:
                {gprun.i ""xxptlocf.p"" "(input xxship_nbr,input xxship_vend, input xxship_line , input xxship_case)"}

                find first tempcase 
                    where tc_ship_nbr = xxship_nbr
                    and   tc_vend     = xxship_vend
                    and   tc_case_nbr = xxship_case 
                no-lock no-error.
                if avail tempcase then xxship_rcvd_loc = tc_loc .
        end.


        v_nbr  = xxinv_nbr + " No." + trim(string(xxship_case)).
        v_date = xxship_rcvd_date .
        v_qty  = xxship_qty .
        v_part = xxship_part2 .
        v_loc  = xxship_rcvd_loc . 

        v_lot  = if xxship_rcvd_date <> ? then substring(string(year(xxship_rcvd_date),"9999"),3,2) + string(month(xxship_rcvd_date),"99") + string(day(xxship_rcvd_date),"99") else "Error".
        v_lot  = v_lot + ( if xxinv_con <> "" then trim(substring(xxinv_con,6)) else "Error" ) .
        v_lot  = v_lot + string(xxship_case2,"99") .

        if v_part <> "" then 
       /*ʵ�ʴ�ӡ*/ 
        run print (input v_part ,input v_loc ,input v_lot ,input v_date , input v_nbr ,input v_qty ).            

        
        {mfrpexit.i}
    end.  /*for each */
    


    end. /*printloop*/
   {mfreset.i}
end. /*mainloop:*/



procedure print:
    define input parameter vv_part  like pt_part.
    define input parameter vv_loc   like ld_loc.
    define input parameter vv_lot   like ld_lot.
    define input parameter vv_date  as date .
    define input parameter vv_nbr   like pt_part.
    define input parameter vv_qty   like wo_qty_ord.


    define variable labelspath as character format "x(100)" init "/app/bc/labels/".

    find first code_mstr where code_fldname = "barcode" and code_value ="labelspath" no-lock no-error.
    if available(code_mstr) then labelspath = trim ( code_cmmt ).
    if substring(labelspath, length(labelspath), 1) <> "/" then labelspath = labelspath + "/".

    wsection    = "lap03" + trim ( string(year(today)) + string(month(today),'99') + string(day(today),'99'))  + trim(string(time)) + trim(string(random(1,100))) .

    input from value(labelspath + "lap03" ).
    output to value(trim(wsection) + ".l") .
       repeat:
          import unformatted ts9030.
          
          /*���������������*/
          if index(ts9030, "&B") <> 0 then do:
             av9030 = trim(vv_part) + "@" + trim(vv_lot) .
             ts9030 = substring(ts9030, 1, index(ts9030 , "&B") - 1) + av9030 
                    + substring( ts9030 , index(ts9030 ,"&B") 
                    + length("&B"), length(ts9030) - ( index(ts9030 , "&B") + length("&B") - 1 ) ).
          end.

          /*����*/
          if index(ts9030, "$D") <> 0 then do:
             av9030 = string(vv_date) .
             ts9030 = substring(ts9030, 1, index(ts9030 , "$D") - 1) + av9030 
                    + substring( ts9030 , index(ts9030 ,"$D") 
                    + length("$D"), length(ts9030) - ( index(ts9030 , "$D") + length("$D") - 1 ) ).
          end.

          /*����*/
          if index(ts9030, "$Q") <> 0 then do:
             av9030 = string(vv_qty).
             ts9030 = substring(ts9030, 1, index(ts9030 , "$Q") - 1) + av9030 
                    + substring( ts9030 , index(ts9030 ,"$Q") 
                    + length("$Q"), length(ts9030) - ( index(ts9030 , "$Q") + length("$Q") - 1 ) ).
          end.
          
          /*�����*/
          if index(ts9030, "$L") <> 0 then do:
             av9030 = substring(vv_lot,1,6) + "/" + substring(vv_lot,7,4).
             ts9030 = substring(ts9030, 1, index(ts9030 , "$L") - 1) + av9030 
                    + substring( ts9030 , index(ts9030 ,"$L") 
                    + length("$L"), length(ts9030) - ( index(ts9030 , "$L") + length("$L") - 1 ) ).
          end.

          /*��λ*/
          if index(ts9030, "$C") <> 0 then do:
             av9030 = string(vv_loc).
             ts9030 = substring(ts9030, 1, index(ts9030 , "$C") - 1) + av9030 
                    + substring( ts9030 , index(ts9030 ,"$C") 
                    + length("$C"), length(ts9030) - ( index(ts9030 , "$C") + length("$C") - 1 ) ).
          end.

          /*���ݺ�*/
          if index(ts9030, "$O") <> 0 then do:
             av9030 = vv_nbr.
             ts9030 = substring(ts9030, 1, index(ts9030 , "$O") - 1) + av9030 
                    + substring( ts9030 , index(ts9030 ,"$O") 
                    + length("$O"), length(ts9030) - ( index(ts9030 , "$O") + length("$O") - 1 ) ).
          end.
          /*�Ϻ�*/
          if index(ts9030, "$P") <> 0 then do:
             av9030 = vv_part.
             ts9030 = substring(ts9030, 1, index(ts9030 , "$P") - 1) + av9030 
                    + substring( ts9030 , index(ts9030 ,"$P") 
                    + length("$P"), length(ts9030) - ( index(ts9030 , "$P") + length("$P") - 1 ) ).
          end.
          /*�Ϻ�˵��1*/
          if index(ts9030, "$F") <> 0 then do:
            find first pt_mstr where pt_part = vv_part  no-lock no-error.
            If AVAILABLE ( pt_mstr )  then
            av9030 = trim(pt_desc1).

             ts9030 = substring(ts9030, 1, index(ts9030 , "$F") - 1) + av9030 
                    + substring( ts9030 , index(ts9030 ,"$F") 
                    + length("$F"), length(ts9030) - ( index(ts9030 , "$F") + length("$F") - 1 ) ).
          end.
          /*�Ϻ�˵��2*/
          if index(ts9030, "$E") <> 0 then do:
            find first pt_mstr where pt_part = vv_part  no-lock no-error.
            If AVAILABLE ( pt_mstr )  then
            av9030 = trim(pt_desc2).

             ts9030 = substring(ts9030, 1, index(ts9030 , "$E") - 1) + av9030 
                    + substring( ts9030 , index(ts9030 ,"$E") 
                    + length("$E"), length(ts9030) - ( index(ts9030 , "$E") + length("$E") - 1 ) ).
          end.
          /*�Ϻŵ�λ*/
          if index(ts9030, "$U") <> 0 then do:
            find first pt_mstr where pt_part = vv_part  no-lock no-error.
            If AVAILABLE ( pt_mstr )  then
            av9030 = pt_um .

             ts9030 = substring(ts9030, 1, index(ts9030 , "$U") - 1) + av9030 
                    + substring( ts9030 , index(ts9030 ,"$U") 
                    + length("$U"), length(ts9030) - ( index(ts9030 , "$U") + length("$U") - 1 ) ).
          end.
          /*����OK*/
          if index(ts9030, "&R") <> 0 then do:
             av9030 = /*if trim ( V1520 ) = "Y" then "�ܼ���" else*/ "����OK" .
             ts9030 = substring(ts9030, 1, index(ts9030 , "&R") - 1) + av9030 
                    + substring( ts9030 , index(ts9030 ,"&R") 
                    + length("&R"), length(ts9030) - ( index(ts9030 , "&R") + length("&R") - 1 ) ).
          end.

          put unformatted ts9030 skip.
       end.

    input close.
    output close.

    unix silent value ("chmod 777  " + trim(wsection) + ".l").

    find first prd_det where prd_dev = trim(dev) no-lock no-error.
    if available prd_det then do:
        unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
        unix silent value ("rm " + trim(wsection) + ".l").
    end.
end. /*procedure*/




