{mfdeclre.i}
{gplabel.i}
DEF NEW SHARED TEMP-TABLE t_error
    FIELD t_er_code AS CHAR FORMAT "x(18)"
   FIELD t_er_mess AS CHAR FORMAT "x(30)".

    DEF INPUT PARAMETER cim_case AS CHAR.
    DEF INPUT PARAMETER bid LIKE b_bf_id.
   DEF SHARED TEMP-TABLE btrid_tmp
        FIELD btrid LIKE b_tr_id.
  
  
    CASE cim_case:
  
    WHEN 'poporc' THEN DO:
  
   {bcrun.i ""bcmgwrfl01.p"" "(input bid)"}
    
    
    
    END.


WHEN 'iclotr02' THEN DO:
  
    
    {bcrun.i ""bcmgwrfl02.p"" "(input bid)"}

    
    END.

WHEN 'icunis' THEN DO:
  
     {bcrun.i ""bcmgwrfl03.p"" "(input bid)"}
    
    
    
    END.


    WHEN 'icunrc'THEN DO:
  
     {bcrun.i ""bcmgwrfl04.p"" "(input bid)"}
    
    
    END.

        WHEN 'rcshmt'  THEN DO:

            {bcrun.i ""bcmgwrfl05.p"" "(input bid)"}



        END.
  END CASE.

   
