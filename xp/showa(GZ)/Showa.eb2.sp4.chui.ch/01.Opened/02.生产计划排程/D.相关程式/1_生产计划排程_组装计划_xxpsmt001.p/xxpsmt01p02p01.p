/* xxpsmt01p02p01.p */
{mfdeclre.i}
{gplabel.i} 
{pxmaint.i}
{pxpgmmgr.i}


define input  parameter i_site      like lnd_site no-undo .
define input  parameter i_line      like lnd_line no-undo .
define input  parameter v_ii        as integer    no-undo .
define input  parameter v_seq_char  as char       no-undo .

{xxpsmt01var.i}

define var v_time_now as decimal .
define var v_part_prev   as char .
define var v_part_next   as char .
define var v_jj          as integer .

mainloop:
repeat:
    for each xln_det 
        where xln_site = i_site 
        and   xln_line = i_line
        and   xln_used = yes /*��:���ų̵Ļ���,*/
        no-lock :


        if index(v_seq_char,"," + xln_part) = 0 then do: 
            v_seq_char = v_seq_char + "," + xln_part .

            if num-entries(v_seq_char) > v_ii then do:  /*���OK*/
                /*�һ���ʱ��(������)v_time_now*/
                v_time_now  = 0 .
                v_part_prev = "" .
                v_part_next = "" .

                v_jj = 0 .
                do v_jj = 1 to v_ii :
                    assign
                        v_part_prev = entry(v_jj,v_seq_char)
                        v_part_next = entry(v_jj + 1,v_seq_char)
                        .
                    
                    if v_part_prev <> "" and v_part_next <> "" then do:
                        find first chg_mstr
                            where chg_site = i_site
                            and   chg_line = i_line
                            and   chg_from = v_part_prev
                            and   chg_to   = v_part_next
                        no-lock no-error.
                        if avail chg_mstr then do:
                            v_time_now = v_time_now + chg_time * 60 .
                        end.
                        else do:
                            find first xxpsc_ctrl 
                                where xxpsc_site = i_site
                            no-lock no-error.
                            if avail xxpsc_ctrl then 
                                 v_time_now = v_time_now + xxpsc_time_chg .
                            else v_time_now = v_time_now + 5 . /*ûά��,����ʽ�ᱨ��,Ĭ�������*/
                        end.
                    end. /*if v_part_prev <> "" and*/
                end. /*do v_jj = 1 to*/

                /*��¼����ʱ��*/
                find first ttemp1 
                    where tt1_site = i_site
                    and   tt1_line = i_line 
                no-error.
                if not avail ttemp1 then do:
                    create ttemp1  .
                    assign tt1_site     = i_site
                           tt1_line     = i_line
                           tt1_partlist = v_seq_char 
                           tt1_time     = v_time_now
                           .

                end.
                else if tt1_time > v_time_now then do:
                    assign tt1_partlist = v_seq_char 
                           tt1_time     = v_time_now
                           .
                end.
         
            end.  /*���OK*/
            else do: /*�������*/

                {gprun.i ""xxpsmt01p02p01.p""  
                         "(  input i_site, 
                             input i_line, 
                             input v_ii,
                             input v_seq_char )"}
                v_seq_char = substring(v_seq_char ,1,index(v_seq_char ,"," + xln_part) - 1).
            end. /*�������*/
        end. /*if index(v_seq_char,"," + xln_part) = 0*/
    end. /*for each xln_det*/

    leave .
end. /* mainloop */

