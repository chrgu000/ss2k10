/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110316.1  By: Roger Xiao */ /* 收货到指定库位,按托号和料号指定库位 */
/* SS - 110322.1  By: Roger Xiao */ /* 拆分库位和过道库位,区分是减震器SA还是转向器PS */
/*-Revision end---------------------------------------------------------------*/


define input  parameter v_nbr      as char .
define input  parameter v_vend     as char .
define input  parameter v_line     as integer .
define input  parameter v_case_nbr as integer .


define shared temp-table tempcase    /*记录每个托的收货库位*/
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
                            1-到固定库位
                            2-到拆分库位
                        */

/*-----------------------------------------------------------------------------*/

v_loc_error = "ERROR" . /*如果找不到设定,则出错,则使用此库位*/

find first tempcase
    where tc_ship_nbr  = v_nbr
    and   tc_vend      = v_vend
    and   tc_case_nbr  = v_case_nbr
no-error.
if not avail tempcase then do: /* not avail tempcase */

    v_loc_to    = "" .


    /*查找是否多种零件同托号*/
    find first xxship_det
        use-index xxship_case
        where xxship_nbr   = v_nbr
        and   xxship_vend  = v_vend
        and   xxship_case  = v_case_nbr
        and   xxship_line <> v_line
    no-lock no-error.
    v_loc_type = if not avail xxship_det then "1" else "2" .


    /*查找昭和图号*/
    find first xxship_det
        use-index xxship_line
        where xxship_nbr   = v_nbr
        and   xxship_vend  = v_vend
        and   xxship_line  = v_line
    no-lock no-error.
    v_part = if avail xxship_det then xxship_part2 else "" .


    /*图号是减震器SA还是转向器PS*/
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

    /*查找v_loc_to--------------------------------------begin*/
    if v_loc_type = "1" then do: /*固定库位*/
        for each xxloc_det
            where ( xxloc_part = v_part and xxloc_type = "1" )
            no-lock
            break by xxloc_type by xxloc_site by xxloc_loc :
            {xxptlocf.i}
        end.  /*for each xxloc_det*/
    end. /*固定库位*/
    else do: /*拆分库位*/
        for each xxloc_det
            where xxloc_type = "2"
            and   xxloc_part_type = v_part_type
            no-lock
            break by xxloc_type by xxloc_site by xxloc_loc :
            {xxptlocf.i}
        end.  /*for each xxloc_det*/
    end. /*拆分库位*/

    find first code_mstr
         where code_fldname = "xx-part-on-floor"
         and code_value     = v_part
    no-lock no-error . /*设定为仅可放在地板上的料号,前面不够放时,不可存放在临时库位,直接放在过道库位 */
    if v_loc_to = "" and (not avail code_mstr) then do: /*临时库位*/
        for each xxloc_det
            where xxloc_type = "3"
            no-lock
            break by xxloc_type by xxloc_site by xxloc_loc :
            {xxptlocf.i}
        end.  /*for each xxloc_det*/
    end. /*临时库位*/
/*ae  货架放不下时，需要放通道， 保税的放在PT                                */
/*ae  非保税的PS的零件就放在P-4RPS                                           */
/*ae  非保税的SA的就放在P-4RSA （P-4RSA，P-4RPS分别代表通道）                */
    if v_loc_to = "" then do:  /*过道库位*/
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
    end.  /*过道库位*/

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

    /*查找v_loc_to--------------------------------------end*/

    create  tempcase .
    assign  tc_ship_nbr  = v_nbr
            tc_vend      = v_vend
            tc_case_nbr  = v_case_nbr
            tc_loc       = v_loc_to
            .

end.  /*not avail tempcase*/

