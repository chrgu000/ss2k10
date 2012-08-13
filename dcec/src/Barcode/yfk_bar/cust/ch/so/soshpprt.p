
/*************************************************
** Subprogram: xgtrprt3.p,Repint for shipper
** Author : Xiang Wenhui , AtosOrigin
** Date   : 2005-9-26
** Description: tshipper reprint
*************************************************/

DEFINE VAR trshipper LIKE b_trs_shipper.
define var i2 as integer.
DEFINE VAR i1 AS INTEGER.
DEFINE VAR loc LIKE b_trs_t_loc.
DEFINE VAR locdesc LIKE loc_desc.
define var temp_string as character.
define var temp_string1 as character.
DEFINE VARIABLE desc1 LIKE pt_desc1.
DEFINE VARIABLE temp_1 AS INTEGER.
DEFINE VARIABLE temp_2 AS INTEGER.
DEFINE VARIABLE temp_3 AS INTEGER.
DEFINE VARIABLE temp_4 AS CHARACTER.
DEFINE VARIABLE temp_5 AS INTEGER.
DEFINE VARIABLE temp_6 AS INTEGER.
DEFINE VARIABLE temp_7 AS CHARACTER INITIAL "移库".
DEFINE VARIABLE temp_num AS INTEGER . /*total page*/
define variable temp_8 as character.
define variable temp_9 as character.
define variable temp_10 as decimal.
define variable temp_12 as character.
DEFINE VARIABLE head_1  AS CHARACTER INITIAL "共".
DEFINE VARIABLE head_2  AS CHARACTER INITIAL "页 第".
DEFINE VARIABLE head_3  AS CHARACTER INITIAL "页".
DEFINE VARIABLE head_4  AS INTEGER INITIAL 1.
define variable temp_cust_part as character.
DEFINE BUFFER bf_b_trs_det FOR b_trs_det. 
{mfdtitle.i}


FORM 
    SKIP(1)
    trshipper COLON 20 LABEL "货运单号码" SKIP 
    SKIP(2)
WITH FRAM a SIDE-LABEL WIDTH 80 THREE-D.
mainloop:
 REPEAT:
        UPDATE trshipper WITH FRAM a.
       
        {gprun.i ""soshpprt01.p"" " (INPUT trshipper)"}.
END.

