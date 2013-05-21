/*yysorp01.p 销售分析报表                   */
/* 8.5 F03 LAST MODIFIED BY LONG BO 2004/07/01        */
/*cj* 08/26/05 add customer type field*/

{mfdtitle.i "120816.1"}

define variable nbr      like so_nbr.
define variable nbr1     like so_nbr.
define variable region   like cm_region.
define variable region1  like cm_region.
define variable cust     like cm_addr.
define variable cust1    like cm_addr.
define variable slspsn   like cm_slspsn[1].
define variable cumdate  like sod_cum_date[1].
define variable cumdate1 like sod_cum_date[1].
define variable part     like pt_part.
define variable part1    like pt_part.
define variable sorttype as logical format "A-区域/C-客户".
define variable amt      as decimal label "总价" format ">>>>,>>>,>>9.99".
define variable site     like si_site initial "DCEC-SV".
define variable site1    like si_site initial "DCEC-SV".
define variable allamt   as decimal.
DEFine VARiable cmtype   LIKE cm_type .
define variable incso    like mfc_logical initial NO.
define variable vcons    like sod_consignment initial no no-undo.
define variable vconloc  like sod_consign_loc no-undo.

def temp-table zzwkso
  field sonbr   like so_nbr
  field sopart  like sod_part
  field invqty  like idh_qty_inv
  field soprice like idh_price
  field soregion  like cm_region
/*cj*/ FIELD socmtype LIKE cm_type
  field socust  like so_cust
  field socon   like so_consignment
  field soconloc like so_consign_loc
  field ptline  like pt_prod_line
  field soslspsn  like so_slspsn[1]
  field shipdate  like sod_cum_date[2]
  field invnbr  like idh_inv_nbr
  field zzsite  like si_site.


FORM /*GUI*/

  RECT-FRAME       AT ROW 1.4 COLUMN 1.25
  RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
  SKIP(.1)  /*GUI*/
    nbr   colon 20
    nbr1  colon 50
    region  colon 20
    region1   colon 50
    cust    colon 20
    cust1 colon 50
    slspsn    colon 20
    cumdate   colon 20 label "发货日期"
    cumdate1 colon 50 LABEL {t001.i}
    part    colon 20
    part1 colon 50
    site  colon 20
    site1 colon 50
    sorttype  colon 20 label "排序选项" "A-区域/C-客户"
    cmtype COLON 50
    incso  colon 20

  SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space THREE-D /*GUI*/.

/*cj*/ setFrameLabels(frame a:handle).

/*
form
  so_cust label "客户"
  cm_sort label "客户名"
  idh_part
  pt_group
  pt_prod_line
  so_slspsn[1]
  so_nbr
  idh_cum_date[2] label "开始日期"
  idh_qty_inv
  amt
  idh_inv_nbr
  idh_site
with frame d down width 200 no-box.*/

/* define Excel object handle */
DEFINE NEW SHARED VARIABLE chExcelApplication AS COM-HANDLE.
/*DEFINE VARIABLE chExcelWorksheet AS COM-HANDLE.*/
DEFINE NEW SHARED VARIABLE chExcelWorkbook AS COM-HANDLE.
/*Define Sheet Variavble*/
DEFINE VARIABLE iLine AS INTEGER.
DEFINE VARIABLE iTotalLine AS INTEGER.
  repeat:

    if nbr1     = hi_char   then nbr1   = "".
    if region1    = hi_char   then region1  = "".
    if cust1    = hi_char   then cust1    = "".
    if cumdate    = low_date  then cumdate  = ?.
    if cumdate1   = hi_date   then cumdate1   = ?.
    if part1    = hi_char   then part1    = "".
    if site1    = hi_char   then site1    = "".

    hide message no-pause.
    message "输入选择条件，按F2等待运行结果。".

    update
      nbr
      nbr1
      region
      region1
      cust
      cust1
      slspsn
      cumdate
      cumdate1
      part
      part1
      site
      site1
      sorttype
      cmtype
      incso
    with frame a.

        {mfquoter.i  nbr     }
        {mfquoter.i  nbr1    }
        {mfquoter.i  region  }
        {mfquoter.i  region1 }
        {mfquoter.i  cust    }
        {mfquoter.i  cust1   }
        {mfquoter.i  slspsn  }
        {mfquoter.i  cumdate }
        {mfquoter.i  cumdate1}
        {mfquoter.i  part    }
        {mfquoter.i  part1   }
        {mfquoter.i  site    }
        {mfquoter.i  site1   }
        {mfquoter.i  sorttype}
        {mfquoter.i  cmtype  }
        {mfquoter.i  incso   }
    if nbr1     = "" then nbr1     = hi_char.
    if region1  = "" then region1  = hi_char.
    if cust1    = "" then cust1    = hi_char.
    if cumdate  = ?  then cumdate  = low_date.
    if cumdate1 = ?  then cumdate1 = hi_date.
    if part1    = "" then part1    = hi_char.
    if site1    = "" then site1    = hi_char.

/*
    {mfselprt.i "printer" 132}
      {mfphead.i}
  */

    {yysorp01.i}

    /* Create a New chExcel Application object */
    CREATE "Excel.Application" chExcelApplication.

      chExcelWorkbook = chExcelApplication:Workbooks:ADD.

      /*ADD DATA INTO EXCEL FILE */
    chExcelWorkbook:Worksheets(1):Cells(1,1) = "销售分析报表".

    iLine = 2.
    chExcelWorkbook:Worksheets(1):Cells(iLine,1) = "客户".
    chExcelWorkbook:Worksheets(1):Cells(iLine,2) = "客户名".
    chExcelWorkbook:Worksheets(1):Cells(iLine,3) = "区域-客户类型".
    chExcelWorkbook:Worksheets(1):Cells(iLine,4) = "零件号".
    chExcelWorkbook:Worksheets(1):Cells(iLine,5) = "零件名".
    chExcelWorkbook:Worksheets(1):Cells(iLine,6) = "产品类库位".
    chExcelWorkbook:Worksheets(1):Cells(iLine,7) = "销售员".
    chExcelWorkbook:Worksheets(1):Cells(iLine,8) = "订单".
    chExcelWorkbook:Worksheets(1):Cells(iLine,9) = "寄售".
    chExcelWorkbook:Worksheets(1):Cells(iLine,10) = "寄售库位".
    chExcelWorkbook:Worksheets(1):Cells(iLine,11) = "发货日期".
    chExcelWorkbook:Worksheets(1):Cells(iLine,12) = "数量".
    chExcelWorkbook:Worksheets(1):Cells(iLine,13) = "金额".
    chExcelWorkbook:Worksheets(1):Cells(iLine,14) = "发票号".
    chExcelWorkbook:Worksheets(1):Cells(iLine,15) = "地点".

    if sorttype then
      {yysorps.i "soregion"}
    else
      {yysorps.i "socust"}

    hide message no-pause.

    chExcelApplication:Visible = True.

    /* release com - handles */
    RELEASE OBJECT chExcelWorkbook.
    /*release object chexcelworkbooktemp .*/
    RELEASE OBJECT chExcelApplication.

/*
    {mfreset.i}
  /*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
*/
  end. /*repeat*/
