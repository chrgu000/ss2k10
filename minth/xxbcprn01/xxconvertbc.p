
DEFINE INPUT PARAMETER mypart AS CHAR.
DEFINE INPUT PARAMETER mydesc AS CHAR.
DEFINE OUTPUT PARAMETER myreslut AS CHAR.

{mfdeclre.i}
/*
DEFINE VAR  mypart AS CHAR.
DEFINE VAR  mydesc AS CHAR.
DEFINE VAR  myreslut AS CHAR.
mypart = "°¡°¡°¡".
mydesc = "001.grf".
*/

DEFINE VAR  myptr AS memptr.
DEFINE VAR  mystr1 AS CHAR.
DEFINE VAR j AS INT.
set-size(myptr) = length(mypart,"RAW") + 1.
put-string(myptr,1) = mypart.
j = 1.
mystr1 = "".
DO WHILE j <= GET-SIZE(myptr) - 1 :
    mystr1 = mystr1 + string(get-byte(myptr,j)) + ";".
    j = j + 1.
END.
mypart = mystr1.
define var ss as char.
define var ss1 as char.
define var ss2 as char.
define var ss3 as char.
DEFINE var thpurl AS CHARACTER NO-UNDO.
DEFINE var thptr AS MEMPTR NO-UNDO.
DEFINE var thrtptr AS MEMPTR NO-UNDO.
thpurl = "http://192.168.33.16:80/zplcon.asmx".


ss1 = "POST /zplcon.asmx HTTP/1.1" + "~n" +
      "Host: 192.168.33.16" + "~n" +
      "Content-Type: application/soap+xml; charset=utf-8" + "~n" +
      "Connection: close" + "~n" +
      "Content-Length: "
      .
ss3 = "<?xml version=""1.0"" encoding=""utf-8""?>" +
         "<soap12:Envelope xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" xmlns:soap12=""http://www.w3.org/2003/05/soap-envelope"">" +
   "<soap12:Body>" +
   "<mystrtozpl xmlns=""http://192.168.3.4:80/"">" +
   "<thstr>" + mypart + "</thstr>" +
   "<thname>" + mydesc + "</thname>" +
   "<thfont></thfont>" +
   "<height></height>" +
   "<width></width>" +
   "<isbold></isbold>" +
   "<isita></isita>" +
   "</mystrtozpl>" +
   "</soap12:Body>" +
   "</soap12:Envelope>"
   .
ss2 = string(length(ss3,"RAW")) + " " .

ss = ss1 + ss2 + "~n" + "~n" + ss3 .

set-size(thptr) = length(ss,"RAW") + 1.
put-string(thptr,1) = ss.
do on error undo ,leave:
/* xxhttppost.p */
RUN /app/mfgpro/eb21/ch/xx/xxhttppost.r   (
    INPUT thpurl,
    INPUT thptr,
    INPUT "123.xml",
    OUTPUT thrtptr
    ).
RUN mygetrecvstr(INPUT thrtptr , INPUT get-size(thrtptr),OUTPUT myreslut).

end.



PROCEDURE mygetrecvstr:
    DEFINE INPUT PARAMETER thPtr AS MEMPTR NO-UNDO.
    DEFINE INPUT PARAMETER thPos AS INT NO-UNDO.
    DEFINE OUTPUT PARAMETER returnStr AS CHAR NO-UNDO.
    DEFINE VARIABLE thStr AS CHAR NO-UNDO.
    DEFINE VARIABLE thpp AS INT NO-UNDO.
    returnStr = "".
    thStr = get-string(thPtr,1,thPos - 1).
    thpp = INDEX(thStr,"<?xml version=").
    if thpp < 1 then return.
    thStr = SUBSTRING(thStr,thpp).
    thpp = INDEX(thStr,"</").
    if thpp < 1 then return.
    thStr = SUBSTRING(thStr,1,thpp - 1).
    thpp = R-INDEX(thStr,">").
    if thpp < 1 then return.
    thStr = SUBSTRING(thStr,thpp + 1).
    returnStr = thStr.
    /*
    SET-SIZE(returnPtr) = LENGTH(thStr,"RAW") + 1.
    PUT-STRING(returnPtr,1)=thStr.
    */
end.
