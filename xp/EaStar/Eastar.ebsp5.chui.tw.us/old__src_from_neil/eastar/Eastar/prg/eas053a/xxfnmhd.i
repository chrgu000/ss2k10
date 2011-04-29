/* Revision eB SP5 Linux  Last Modified: 01/01/06   By: Kaine  *eas053a* */

FORM HEADER
	"EASTAR (HK) LIMITED" AT 1
	"Unit G, 19/F.,World Tech Centre, 95 How Ming Street, Kwun Tong" AT 1
	"Hong Kong.   Tel.:(852)2342-7688,   Fax : (852)2343-8078" AT 1 SKIP
	SKIP(1)
	"I N V O I C E" AT 40
	SKIP(1)
	FILL("=", 100) FORMAT "x(100)" AT 1
	"DATE :" AT 1
	strDateInHead AT 8
	"INVOICE NO.:" AT 58
	pinbr#
	SKIP(1)
	"TERMS:" AT 1
	term_desc AT 8
	"OUR REF. NO." AT 58
	strRefNo
	FILL("=", 100) FORMAT "x(100)" AT 1
	SKIP(1)
	FILL("-", 100) FORMAT "x(100)" AT 1
	"BILL To :" AT 1
	bill-to[1] AT 11
	"SHIP To :" TO 70
	ship-to[1] AT 72
	bill-to[2] AT 11		ship-to[2] AT 72
	bill-to[3] AT 11		ship-to[3] AT 72
	bill-to[4] AT 11		ship-to[4] AT 72
	bill-to[5] AT 11		ship-to[5] AT 72
	bill-to[6] AT 11		ship-to[6] AT 72
	"ATTN    :" AT 1
	bill-attn AT 11
	"ATTN    :" TO 70
	ship-attn AT 72
	FILL("-", 100) FORMAT "x(100)" AT 1 SKIP
	"QTY" TO 72
	"UNIT" TO 87
	"EXTENDED" TO 101 SKIP
	"ITEM" AT 1
	"PO" AT 6
	"P/N" AT 19
	"Description" AT 38
	"(PCS)" TO 72
	"PRICE(" + curr1 + ")" FORMAT "x(10)" TO 87
	"AMOUNT(" + curr2 + ")" FORMAT "x(11)" TO 101
	"---- ------------ ------------------ ------------------------ ---------- -------------- -------------" AT 1
WITH FRAME phead1 PAGE-TOP WIDTH 132.

FORM
	intItem
	shad_ponbr
	shad_part
	strPtDesc	FORMAT "x(24)"
	ext_qty		FORMAT "->,>>>,>>9"
	price		FORMAT ">,>>>,>>9.9999"
	amount		FORMAT "->,>>>,>>9.99"
WITH FRAME c NO-BOX NO-LABELS WIDTH 132 DOWN.
