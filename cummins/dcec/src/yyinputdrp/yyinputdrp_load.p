/* $Revision: eb21sp3 $ BY: Jordan Lin  DATE: 06/28/12 ECO: *ss - 20120628.1 */
/* $Revision: eB21SP3 $  BY: Jordan Lin       DATE: 07/16/12  ECO: *SS-20120716.1* */

{mfdeclre.i }

define   variable usection as char format "x(36)" .
define shared  variable errstr as char no-undo .
define   variable ciminputfile   as char .
define   variable cimoutputfile  as char .
define   variable c  as char .
define   variable c2  as char .

DEFINE shared TEMP-TABLE tmp_det no-undo
    FIELD tmp_req_nbr LIKE drp_req_nbr     /*�����*/
    FIELD tmp_nbr LIKE dss_nbr
    FIELD tmp_part LIKE ds_part            /*�����*/
    FIELD tmp_qty_ord LIKE ds_qty_ord      /*����*/
    FIELD tmp_req_date LIKE dss_due_date   /*������*/
    FIELD tmp_due_date LIKE dss_due_date   /*��ֹ��*/
    FIELD tmp_rec_site LIKE dss_rec_site   /*�����*/
    FIELD tmp_shipsite LIKE dss_shipsite   /*���˵�*/
    FIELD tmp_trloc LIKE pt_loc            /*��;��λ*/
    FIELD tmp_xls_line LIKE drp_req_nbr    /*excel�к�*/
    FIELD tmp_err as char                  /*���뱨��*/
     index tmp_index is primary tmp_req_nbr .

loadloop:
   do  on error undo, LEAVE :


  errstr = "".
  usection = TRIM ("upload.in") .
  output to value( trim(usection) ) .

       for each tmp_det no-lock BREAK by tmp_nbr by tmp_req_nbr :
           if FIRST(tmp_nbr) then do:
               put unformat '"' trim(tmp_nbr) + '" "' +  trim(tmp_shipsite) '"'skip.
               find first dss_mstr no-lock where dss_domain = global_domain
                      and dss_nbr = tmp_nbr and dss_shipsite = tmp_shipsite no-error.
               if not available dss_mstr then do:
                  put unformat '"' trim(tmp_rec_site) '"' skip.
               end.
               put unformat trim(string(tmp_req_date)) + ' ' +
                            trim(string(tmp_req_date)) + ' ' +
                            trim(string(tmp_due_date)) + " OK - N" skip.
           end.
           put unformat '"' string(tmp_req_nbr) '"' skip.
           find first ds_det no-lock where ds_domain = global_domain and
                      ds_req_nbr = string(tmp_req_nbr) no-error.
           if not available ds_det then do:
              put unformat '"' trim(tmp_part) '"' skip.
              put unformat string(tmp_qty_ord) skip.
              put unformat '-' skip.
           end.
           put unformat "- - N " + trim(tmp_trloc) " - - - - - N" skip.

          if last(tmp_nbr) then do:
                put "." skip.
                put "." skip.
          end.
    end.

  output close.

  input from value ( usection ) .
  output to  value ( usection + ".out") .
        batchrun = yes.
    {gprun.i ""dsdomt.p""}
        batchrun = no.
  input close.
  output close.

  ciminputfile = usection .
  cimoutputfile = usection + ".out".
  {yyinputdrp_err.i}

        if errstr <> "" then do:
            message  errstr .
            undo loadloop.
        end.
   end.
