/* Creation: eB2SP11.Chui   Modified: ??    By: Davild??    *????* */
/* Revision: eB2SP11.Chui   Modified: 08/15/06      By: Kaine Zhang     *ss-20060815.1* */
/* Revision: eB2SP11.Chui   Modified: 08/23/06      By: Kaine Zhang     *ss-20060823.1* */

  FORM
    invcode COLON 22 label "invcode"
    invno   COLON 55
    WITH SIDE-LABEL fRAME a WIDTH 80 title (getFrameTitle("XXSHMT",24)).
setFrameLabels(FRAME a:HANDLE).
form 
  xxshm_date 		colon 17
  xxshm_terms 		colon 55 label "SO Terms"

  xxshm_forwarder	colon 17 format "x(18)"
  xxshm_refno		colon 55 format "x(18)"
  
  xxshm_method		colon 17 format "x(18)"
  xxshm_fc		colon 55 format "x(18)"

  xxshm_vessels		colon 17 format "x(38)"
  

  xxshm_from		colon 17 format "x(18)"
  /*xxshm_seal		colon 55--delete*/
  xxshm_container	colon 55 format "x(18)"

  xxshm_port		colon 17 format "x(18)"
  xxshm_final		colon 55 format "x(18)"

  xxshm_orderno		colon 17 label "So NBR"
  xxshm_qitagang	colon 55 label "中轉港口" format "x(18)"

  xxshm_notes		colon 17 format "x(33)"
    /*ss-20060815.1*/  xxshm_dec[1] LABEL "shp amt" COLON 62
  xxshm_notes2		colon 17 format "x(33)" no-label
  xxshm_notes3		colon 17 format "x(33)" no-label

  xxshm_billto		colon 17
  v_billtoadd		colon 17 label "Address"
  xxshm_shipto		colon 17  
  v_shiptoadd		colon 17 label "Address"
 
  
  with side-label frame finv width 80 title (getFrameTitle("XXSHMTINV",24)).
setFrameLabels(FRAME finv:HANDLE).

/*form
  
 
  xxshm_name_ch  colon 17
  with side-label frame fcdz width 80 title (getFrameTitle("XXSHMTCDZ",24)) .
setFrameLabels(FRAME fcdz:HANDLE).*/

form 
  v_so_nbr colon 17    /*SO NBR 號碼*/
  v_continue colon 55 /*是否繼續添加*/   label "Continue"
  /*sonbrstr colon 17 label "Order List" */
  with side-label frame fdet width 80 title (getFrameTitle("XXSHDDET",24)) .
setFrameLabels(FRAME fdet:HANDLE).


/* ***********************ss-20060823.1 B Add********************** */
FORM
    xxshm_chr[1] LABEL "shp cost" FORMAT "x(34)"
    xxshm_chr[2] LABEL "shp cost" FORMAT "x(34)"
    xxshm_chr[3] LABEL "shp cost" FORMAT "x(34)"
    xxshm_chr[4] LABEL "shp cost" FORMAT "x(34)"
    xxshm_chr[5] LABEL "shp cost" FORMAT "x(34)"
WITH FRAME frmKarby CENTERED OVERLAY SIDE-LABELS.
setFrameLabels(FRAME frmKarby:HANDLE).
/* ***********************ss-20060823.1 E Add********************** */
