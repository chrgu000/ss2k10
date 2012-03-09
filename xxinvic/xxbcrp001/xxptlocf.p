/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110316.1  By: Roger Xiao */ /* �ջ���ָ����λ,���кź��Ϻ�ָ����λ */
/* SS - 110322.1  By: Roger Xiao */ /* ��ֿ�λ�͹�����λ,�����Ǽ�����SA����ת����PS */
/*-Revision end---------------------------------------------------------------*/


define input  parameter v_nbr      as char .
define input  parameter v_vend     as char .
define input  parameter v_line     as integer .
define input  parameter v_case_nbr as integer .


define shared temp-table tempcase    /*��¼ÿ���е��ջ���λ*/
    field tc_ship_nbr like xxship_nbr
    field tc_vend     like xxship_vend
    field tc_case_nbr like xxship_case
    field tc_loc      like pt_loc
    .

define var v_ii         as   integer .
define var v_loc_to     like ld_loc .
define var v_loc_error  like ld_loc .
define var v_part       like pt_part .
define var v_part_type  as char .
define var v_loc_type   as char init "0" .
                        /*  v_loc_type =
                            1-���̶���λ
                            2-����ֿ�λ
                        */

/*-----------------------------------------------------------------------------*/

v_loc_error = "ERROR" . /*����Ҳ����趨,�����,��ʹ�ô˿�λ*/

find first tempcase
    where tc_ship_nbr  = v_nbr
    and   tc_vend      = v_vend
    and   tc_case_nbr  = v_case_nbr
no-error.
if not avail tempcase then do: /* not avail tempcase */

    v_loc_to    = "" .


    /*�����Ƿ�������ͬ�к�*/
    find first xxship_det
        use-index xxship_case
        where xxship_nbr   = v_nbr
        and   xxship_vend  = v_vend
        and   xxship_case  = v_case_nbr
        and   xxship_line <> v_line
    no-lock no-error.
    v_loc_type = if not avail xxship_det then "1" else "2" .


    /*�����Ѻ�ͼ��*/
    find first xxship_det
        use-index xxship_line
        where xxship_nbr   = v_nbr
        and   xxship_vend  = v_vend
        and   xxship_line  = v_line
    no-lock no-error.
    v_part = if avail xxship_det then xxship_part2 else "" .


    /*ͼ���Ǽ�����SA����ת����PS*/
    v_part_type = "" .
    find first pt_mstr
        where pt_part = v_part
    no-lock no-error.
    if avail pt_mstr then do:
        if     pt_buyer = "4RPS"
            or pt_buyer = "4RPS-CHA"
            or pt_buyer = "4RPS-SSM"
        then do:
            v_part_type = "PS" .
        end.
        else if pt_buyer = "4RSA"
        then do:
            v_part_type = "SA" .
        end.
    end.

    /*����v_loc_to--------------------------------------begin*/
    if v_loc_type = "1" then do: /*�̶���λ*/
        for each xxloc_det
            where ( xxloc_part = v_part and xxloc_type = "1" )
            no-lock
            break by xxloc_type by xxloc_site by xxloc_loc :
            {xxptlocf.i}
        end.  /*for each xxloc_det*/
    end. /*�̶���λ*/
    else do: /*��ֿ�λ*/
        for each xxloc_det
            where xxloc_type = "2"
            and   xxloc_part_type = v_part_type
            no-lock
            break by xxloc_type by xxloc_site by xxloc_loc :
            {xxptlocf.i}
        end.  /*for each xxloc_det*/
    end. /*��ֿ�λ*/

    find first code_mstr
         where code_fldname = "xx-part-on-floor"
         and code_value     = v_part
    no-lock no-error . /*�趨Ϊ���ɷ��ڵذ��ϵ��Ϻ�,ǰ�治����ʱ,���ɴ������ʱ��λ,ֱ�ӷ��ڹ�����λ */
    if v_loc_to = "" and (not avail code_mstr) then do: /*��ʱ��λ*/
        for each xxloc_det
            where xxloc_type = "3"
            no-lock
            break by xxloc_type by xxloc_site by xxloc_loc :
            {xxptlocf.i}
        end.  /*for each xxloc_det*/
    end. /*��ʱ��λ*/
/*ae  ���ܷŲ���ʱ����Ҫ��ͨ���� ��˰�ķ���PT                                */
/*ae  �Ǳ�˰��PS������ͷ���P-4RPS                                           */
/*ae  �Ǳ�˰��SA�ľͷ���P-4RSA ��P-4RSA��P-4RPS�ֱ����ͨ����                */
    if v_loc_to = "" then do:  /*������λ*/
        for each xxloc_det
            where xxloc_type = "4"
            and   xxloc_part_type = v_part_type
            no-lock
            break by xxloc_type by xxloc_site by xxloc_loc :
            v_loc_to = xxloc_loc .
        end.

        if v_loc_to = "" then do:
            for each xxloc_det
                where xxloc_type = "4"
                no-lock
                break by xxloc_type by xxloc_site by xxloc_loc :
                v_loc_to = xxloc_loc.
            end.
        end.
    end.  /*������λ*/

     if v_loc_to = "" then do:
       if substring(v_part,1,1) = "P" then do:
       		assign v_loc_to = "PT".
       end.
       else do:
            if v_part_type = "PS" then do:
               assign v_loc_to = "P-4RPS".
            end.
            else if v_part_type = "SA" then do:
               assign v_loc_to = "P-4RSA".
             end.
            else do:
               assign v_loc_to = v_loc_error .
            end.
       end.
     end.

    /*����v_loc_to--------------------------------------end*/

    create  tempcase .
    assign  tc_ship_nbr  = v_nbr
            tc_vend      = v_vend
            tc_case_nbr  = v_case_nbr
            tc_loc       = v_loc_to
            .

end.  /*not avail tempcase*/

