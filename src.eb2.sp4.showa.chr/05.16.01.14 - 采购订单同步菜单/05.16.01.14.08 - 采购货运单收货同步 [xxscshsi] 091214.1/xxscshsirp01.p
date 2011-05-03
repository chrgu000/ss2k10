/* SS - 091103.1 By: Neil Gao */
/* SS - 091122.1 By: Neil Gao */

{mfdeclre.i}
{gplabel.i}

define input parameter vend like po_vend.
define input parameter vend1 like po_vend.
define input parameter shnbr like po_nbr.
define input parameter shnbr1 like po_nbr.

for each abs_mstr where abs_shipfrom >= vend and abs_shipfrom <= vend1
	and abs_id >= "S" + shnbr and abs_id <= "S" + shnbr1 
	and abs_type = "r" and substring(abs_status,2,1) = "Y"
/* SS 091122.1 - B */
/* 	and abs_user1 = "" */
/* SS 091122.1 - E */
	no-lock with frame c down width 120:
  
	disp 	abs_shipfrom column-label "��Ӧ��"
				substring(abs_id,2) column-label "���˵�" format "x(20)"
				abs_shp_date  column-label "��������"
				abs__chr01    column-label "��ע"
				abs_user1  column-label ""
	with frame c.
				
	down with frame c.

end. /* for each po_mstr */

