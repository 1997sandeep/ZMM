CLASS zcl_mm_migo_print DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    CLASS-METHODS read_posts
      IMPORTING VALUE(ponum)    TYPE c_purchaseorderdex-purchaseorder
      RETURNING VALUE(result12) TYPE string
      RAISING   cx_static_check .

    CLASS-DATA ev_pdf          TYPE xstring.
    CLASS-DATA ev_pages        TYPE int4.
    CLASS-DATA ev_trace_string TYPE string.
    CLASS-DATA iv_xml_data     TYPE xstring.
    CLASS-DATA iv_xdp_layout   TYPE xstring.
    CLASS-DATA iv_locale       TYPE string.
    CLASS-DATA is_options      TYPE cl_fp_ads_util=>ty_gs_options_pdf.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MM_MIGO_PRINT IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  ENDMETHOD.


  METHOD read_posts .

    SELECT * FROM zmigo_print
           WHERE materialdocument = @ponum
             INTO TABLE @DATA(it) .

    DELETE ADJACENT DUPLICATES FROM it COMPARING ALL FIELDS.

    READ TABLE it INTO DATA(witem)  INDEX 1 .
    DATA(lv_from_address) =   ''. "|{ witem-address01 } { witem-address02 } { witem-address03 } { witem-address04 } { witem-address05 } { witem-address06 } { witem-pincode } { witem-region }|.
    DATA(lv_to_address) = '' . " | { witem-to_address01 } { witem-to_address02 } { witem-to_address03 } { witem-to_address04 } { witem-to_address05 } { witem-to_address06 } { witem-to_pincode } { witem-to_region }|.
*    { witem-supp_303_Pincode } { witem-supp_303_Region }|.

    CONDENSE lv_from_address.
    CONDENSE lv_to_address.


*    SELECT SINGLE FROM i_materialdocumentitemtp
*    FIELDS
*    yy1_supplying_plant_mmi
*    WHERE materialdocument = @ponum
*    AND inventorystocktype = '01'
*    INTO  @DATA(toplant).

*    SELECT SINGLE FROM i_plant
*    FIELDS
*    plantname
*    WHERE plant = @toplant
*    INTO @DATA(pname) .

*    SELECT SINGLE plantname FROM zplant_tmg_new WHERE plant = @witem-issuingorreceivingplant INTO @DATA(plantnameto).
*     SELECT SINGLE plantname FROM zplant_tmg_new WHERE plant = @witem-to_plant INTO @DATA(plantnameto1).
*        SELECT SINGLE gmailid FROM zgmail_tmg_ne WHERE plant = @witem-issuingorreceivingplant INTO @DATA(gmailid1).
*             SELECT SINGLE mobilenumber FROM zgmail_tmg_ne WHERE plant = @witem-issuingorreceivingplant INTO @DATA(mobilenumber).
*
*        SELECT SINGLE gmailid FROM zgmail_tmg_ne WHERE plant =  @witem-to_plant INTO @DATA(gmailid111).
*             SELECT SINGLE mobilenumber FROM zgmail_tmg_ne WHERE plant =  @witem-to_plant INTO @DATA(mobilenumber111).





    SELECT SINGLE FROM i_supplier AS a
        LEFT OUTER JOIN I_AddressEmailAddress_2 AS b ON b~addressid = a~addressid
        FIELDS a~supplier,
               a~suppliername,
               a~bpaddrstreetname,
               a~postalcode,
               a~cityname,
               a~region,
               a~phonenumber2,
               a~taxnumber3,
               b~emailaddress
        WHERE  a~supplier = @witem-supplier
        INTO @DATA(supaddr).

    DATA sapdocdate TYPE char10 .
    "//GOODS RECEIPT
    IF ( witem-goodsmovementtype = '101' OR
        witem-goodsmovementtype = '501' OR
        witem-goodsmovementtype = '511' OR
        witem-goodsmovementtype = 'Z61' OR
        witem-goodsmovementtype = '561'
*                witem-goodsmovementtype = '303'

*        witem-goodsmovementtype = '305'
         )        AND witem-supplyingplant IS INITIAL.


      DATA(lv_supplier_address) = |{ supaddr-suppliername } { supaddr-bpaddrstreetname } { supaddr-cityname } { supaddr-postalcode } { supaddr-region }|.

      CONDENSE lv_supplier_address.




      DATA(lv_header) = 'GOODS RECEIPT'.
      DATA(lv_sup) = 'From Supplier :'.
      sapdocdate = witem-sapdocumentdate+6(2) && '/' &&
                    witem-sapdocumentdate+4(2) && '/' &&
                    witem-sapdocumentdate+0(4).
*   SELECT SINGLE plantname FROM zplant_tmg_new WHERE plant = @toplant INTO @DATA(plantnameto2).
*    SELECT SINGLE plantname FROM zplant_tmg_new WHERE plant = @witem-to_plant INTO @DATA(plantnameto22).
*               SELECT SINGLE gmailid FROM zgmail_tmg_ne WHERE plant =  @witem-to_plant INTO @DATA(gmailid22).
*             SELECT SINGLE mobilenumber FROM zgmail_tmg_ne WHERE plant =  @witem-to_plant INTO @DATA(mobilenumber22).
*           SELECT SINGLE gmailid FROM zgmail_tmg_ne WHERE plant =  @witem-to_plant INTO @DATA(gmailid2).
*             SELECT SINGLE mobilenumber FROM zgmail_tmg_ne WHERE plant =  @witem-to_plant INTO @DATA(mobilenumber2).

     DATA(lv_xml) =
     |<Form>| &&
     |<header>{ lv_header }</header>| &&
     |<Add>| &&
     |<frplant>| &&
     |<fromplant_name>{ lv_sup }</fromplant_name>| &&
    |<fromplant>{ supaddr-supplier }</fromplant>| &&
      |<fromplantadd>{ lv_supplier_address }</fromplantadd>| &&
     |</frplant>| &&
     |<trplant>| &&

     |<toplant_name1>To Plant :</toplant_name1>| &&
     |<toplant>{ witem-to_plant } { witem-to_plantnm }</toplant>| &&
     |<toplantadd>{ '' }</toplantadd>| &&
*     |<toplantadd>{ plantnameto22 }</toplantadd>| &&
     |</trplant>| &&
     |<Contactdet>{ supaddr-PhoneNumber2 }</Contactdet> | &&
*     |<Contactdet1>{ mobilenumber22 }</Contactdet1> | &&
     |<Contactdet1>{ '' }</Contactdet1> | &&
     |<email>{ supaddr-EmailAddress }</email> | &&
*       |<email1>{ gmailid22 }</email1> | &&
       |<email1>{ '' }</email1> | &&
 |<fromplantGSTIN>{ supaddr-taxnumber3 }</fromplantGSTIN>| &&
     |<toGSTIN>{ witem-to_plt_gstin }</toGSTIN>| &&
     |</Add>| &&
     |<MovementType>{ witem-goodsmovementtype }</MovementType>| &&
     |<DeliveryNote>{ witem-deliverynote }</DeliveryNote>| &&
     |<InvoiceNumber>{ witem-billoflading }</InvoiceNumber>| &&
     |<SAPDocumentNo>{ witem-sapdocumentnumber }</SAPDocumentNo>| &&
     |<SAPDocumentDate>{ sapdocdate }</SAPDocumentDate>| &&
     |<Subform6>| &&
     |<PRNo>{ witem-prnumber }</PRNo>| &&
     |<PONo>{ witem-purchaseorder }</PONo>| &&
     |</Subform6>| &&
     |<Table1>| .

    ELSEIF (  witem-goodsmovementtype = '303' ) .
      lv_header = 'GOODS ISSUE'.
      lv_sup = 'From Plant :'.

      sapdocdate = witem-sapdocumentdate+6(2) && '/' &&
                    witem-sapdocumentdate+4(2) && '/' &&
                    witem-sapdocumentdate+0(4).
      lv_xml =
      |<Form>| &&
       |<header>{ lv_header }</header>| &&
      |<Add>| .
      LOOP AT it INTO witem.


        SELECT SINGLE
         FROM  i_plant

          WITH PRIVILEGED ACCESS
        FIELDS
           plantname AS  to_address01,
           \_address-streetname        AS to_address02,

           \_address\_region\_regiontext-regionname    AS to_region,
            \_address-postalcode         AS to_pincode,
           \_address-phonenumber       AS to_storephone,
          ' '     AS to_storemail


        WHERE plant = @witem-issuingorreceivingplant
        INTO  @DATA(to_plant_addr) .


        " Build full address fields
        DATA(supp_303_address) =
           |{ to_plant_addr-to_address01 } { to_plant_addr-to_address02 } | &&
          |  | &&
          | { to_plant_addr-to_pincode }   { to_plant_addr-to_region }|.

        DATA(lv_supp_303_address) =  ''.
*      |{ witem-supp_303_address01 } { witem-supp_303_address02 } { witem-supp_303_address03 }| &&
*      | { witem-supp_303_address04 } { witem-supp_303_address05 } { witem-supp_303_address06 }| &&
*      | { witem-supp_303_pincode } { witem-supp_303_region }|.
* DATA(lv_supp_303_address) = |{ supaddr-suppliername } { supaddr-bpaddrstreetname } { supaddr-cityname } { supaddr-postalcode } { supaddr-region }|.
        CONDENSE supp_303_address.
        CONDENSE lv_supp_303_address.

*        IF witem-debitcreditcode = 'H'.
        " ---- FROM PLANT ----
        lv_xml = lv_xml &&
         |<frplant>| &&
         |<fromplant_name>From Plant :</fromplant_name>| &&
         |<fromplant>{ witem-supp_303 } { witem-supp_303_plantnm }</fromplant>| &&
         |<toplant_name1>To Plant:</toplant_name1>| &&
         |<fromplantadd>{ '' }</fromplantadd>| &&
*         |<fromplantadd>{ plantnameto1 }</fromplantadd>| &&
         |</frplant>| &&
         |<Contactdet>{ '' }</Contactdet>| &&
*         |<Contactdet>{ mobilenumber111 }</Contactdet>| &&
*         |<email>{ gmailid111 }</email>| &&
         |<email>{ '' }</email>| &&
*        |<email1>{ witem-to_storemail }</email1>| &&
*|<email1>{ gmailid1 }</email1> | &&
|<email1>{ '' }</email1> | &&
         |<fromplantGSTIN>{ witem-supp_303_supplt }</fromplantGSTIN>| .
*        |<toGSTIN>{ witem-to_plt_gstin }</toGSTIN>| .

*        ELSEIF witem-debitcreditcode = 'S'.
        " ---- TO PLANT ----
        lv_xml = lv_xml &&
         |<trplant>| &&
         |<toplant_name>To Plant :</toplant_name>| &&
         |<toplant>{ witem-issuingorreceivingplant } {  to_plant_addr-to_address01 }</toplant>| &&
*        |<toplantadd>{ '' }</toplantadd>| &&
|<toplant_name1>To Plant:</toplant_name1>| &&
*         |<toplantadd>{ plantnameto }</toplantadd>| &&
         |<toplantadd>{ '' }</toplantadd>| &&
         |</trplant>| &&
*        |<Contactdet>{ witem-supp_303_StorePhone }</Contactdet>| &&
*         |<Contactdet1>{ witem-to_storephone }</Contactdet1>| &&
              |<Contactdet1>{ '' }</Contactdet1> | &&
*              |<Contactdet1>{ mobilenumber }</Contactdet1> | &&
*        |<email>{ witem-supp_303_StoreMail }</email>| &&
*         |<email1>{ witem-to_storemail }</email1>| &&
         |<email1>{ '' }</email1> | &&
*         |<email1>{ gmailid1 }</email1> | &&
*        |<fromplantGSTIN>{ witem-supp_303_supplt }</fromplantGSTIN>| &&
         |<toGSTIN>{ witem-to_plt_gstin }</toGSTIN>| .

*        ENDIF.

      ENDLOOP.

      " Close only once
      lv_xml = lv_xml &&
     |</Add>| &&
     |<MovementType>{ witem-goodsmovementtype }</MovementType>| &&
     |<DeliveryNote>{ witem-deliverynote }</DeliveryNote>| &&
     |<InvoiceNumber>{ witem-billoflading }</InvoiceNumber>| &&
     |<SAPDocumentNo>{ witem-sapdocumentnumber }</SAPDocumentNo>| &&
     |<SAPDocumentDate>{ sapdocdate }</SAPDocumentDate>| &&
     |<Subform6>| &&
     |<PRNo>{ witem-prnumber }</PRNo>| &&
     |<PONo>{ witem-purchaseorder }</PONo>| &&
     |</Subform6>| &&
     |<Table1>| .


      "//GOODS ISSUE
    ELSEIF ( witem-goodsmovementtype = '281' OR
        witem-goodsmovementtype = '221' OR
        witem-goodsmovementtype = '261' OR
*         witem-goodsmovementtype = 'Z21' OR
        witem-goodsmovementtype = '601' ) AND witem-supplyingplant IS INITIAL .

      lv_supplier_address = |{ supaddr-suppliername } { supaddr-bpaddrstreetname } { supaddr-cityname } { supaddr-postalcode } { supaddr-region }|.

      CONDENSE lv_supplier_address.




      lv_header = 'GOODS ISSUE'.
      lv_sup = 'From Supplier :'.
      sapdocdate = witem-sapdocumentdate+6(2) && '/' &&
                      witem-sapdocumentdate+4(2) && '/' &&
                      witem-sapdocumentdate+0(4).


*        SELECT SINGLE plantname FROM zplant_tmg_new WHERE plant = @witem-to_plant INTO @DATA(plantnameto3).
*
*        SELECT SINGLE gmailid FROM zgmail_tmg_ne WHERE plant =  @witem-to_plant INTO @DATA(gmail3).
*        SELECT SINGLE mobilenumber FROM zgmail_tmg_ne WHERE plant =  @witem-to_plant INTO @DATA(mobilenumber3).


      lv_xml =
     |<Form>| &&
     |<header>{ lv_header }</header>| &&
     |<Add>| &&
     |<frplant>| &&
     |<fromplant_name>{ lv_sup }</fromplant_name>| &&
     |<fromplant>{ supaddr-supplier }</fromplant>| &&
*     |<fromplantadd>{ lv_supplier_address }</fromplantadd>| &&
       |<fromplantadd>{ lv_supplier_address }</fromplantadd>| &&
     |</frplant>| &&
     |<trplant>| &&
     |<toplant_name>From Plant :</toplant_name>| &&
     |<toplant>{ witem-to_plant } { witem-to_plantnm }</toplant>| &&
         |<toplant_name1>To Plant:</toplant_name1>| &&
*|<toplantadd>{ plantnameto1 }</toplantadd>| &&
|<toplantadd>{ '' }</toplantadd>| &&
     |</trplant>| &&
     |<Contactdet>{ supaddr-phonenumber2 }</Contactdet> | &&
*     |<Contactdet1>{ witem-to_storephone }</Contactdet1> | &&
     |<Contactdet1>{ '' }</Contactdet1> | &&
*     |<Contactdet1>{ mobilenumber3 }</Contactdet1> | &&
     |<email>{ supaddr-emailaddress }</email> | &&
*     |<email1>{ witem-to_storemail }</email1> | &&
*|<email1>{ gmail3 }</email1> | &&
|<email1>{ '' }</email1> | &&
     |<fromplantGSTIN>{ supaddr-taxnumber3 }</fromplantGSTIN>| &&
     |<toGSTIN>{ witem-to_plt_gstin }</toGSTIN>| &&
     |</Add>| &&
     |<MovementType>{ witem-goodsmovementtype }</MovementType>| &&
     |<DeliveryNote>{ witem-deliverynote }</DeliveryNote>| &&
     |<InvoiceNumber>{ witem-billoflading }</InvoiceNumber>| &&
     |<SAPDocumentNo>{ witem-sapdocumentnumber }</SAPDocumentNo>| &&
     |<SAPDocumentDate>{ sapdocdate }</SAPDocumentDate>| &&
     |<Subform6>| &&
     |<PRNo>{ witem-prnumber }</PRNo>| &&
     |<PONo>{ witem-purchaseorder }</PONo>| &&
     |</Subform6>| &&
     |<Table1>| .






    ELSEIF (
      witem-goodsmovementtype = 'Z21' ) AND witem-supplyingplant IS INITIAL .

      lv_supplier_address = |{ supaddr-suppliername } { supaddr-bpaddrstreetname } { supaddr-cityname } { supaddr-postalcode } { supaddr-region }|.

      CONDENSE lv_supplier_address.

      lv_header = 'GOODS ISSUE'.
*      lv_sup = 'From Supplier :'.
      lv_sup = 'From PLant :'.
      sapdocdate = witem-sapdocumentdate+6(2) && '/' &&
                      witem-sapdocumentdate+4(2) && '/' &&
                      witem-sapdocumentdate+0(4).

*     SELECT SINGLE plantname FROM zplant_tmg_new WHERE plant = @witem-to_plant INTO @DATA(plantnameto09).
*        SELECT SINGLE gmailid FROM zgmail_tmg_ne WHERE plant = @witem-to_plant INTO @DATA(gmailid09).
*             SELECT SINGLE mobilenumber FROM zgmail_tmg_ne WHERE plant = @witem-to_plant INTO @DATA(mobilenumber09).

      lv_xml =
     |<Form>| &&
     |<header>{ lv_header }</header>| &&
     |<Add>| &&
     |<frplant>| &&
     |<fromplant_name>{ lv_sup }</fromplant_name>| &&
     |<fromplant>{ witem-to_plant } { witem-to_plantnm }</fromplant>| &&
*|<fromplant>{ supaddr-supplier }</fromplant>| &&
*     |<fromplantadd>{ lv_to_address }</fromplantadd>| &&
*      |<fromplantadd>{ plantnameto1 }</fromplantadd>| &&
      |<fromplantadd>{ '' }</fromplantadd>| &&
     |</frplant>| &&
     |<trplant>| &&
      |<toplant_name>To Supplier:</toplant_name>| &&
*     |<toplant>{ witem-to_plant } { witem-to_plantnm }</toplant>| &&
     |<toplant>{ supaddr-supplier }</toplant>| &&
    |<toplant_name1>To Supplier:</toplant_name1>| &&
     |<toplantadd>{ lv_supplier_address }</toplantadd>| &&
     |</trplant>| &&
*     |<Contactdet>{ mobilenumber09 }</Contactdet> | &&
     |<Contactdet>{ '' }</Contactdet> | &&
     |<Contactdet1>{ '' }</Contactdet1> | &&
*     |<Contactdet1>{ mobilenumber }</Contactdet1> | &&
*     |<email>{ gmailid09 }</email> | &&
     |<email>{ '' }</email> | &&
*|<email1>{ gmailid1 }</email1> | &&
|<email1>{ '' }</email1> | &&
     |<fromplantGSTIN>{ witem-to_plt_gstin }</fromplantGSTIN>| &&
     |<toGSTIN>{ witem-to_plt_gstin }</toGSTIN>| &&
     |</Add>| &&
     |<MovementType>{ witem-goodsmovementtype }</MovementType>| &&
     |<DeliveryNote>{ witem-deliverynote }</DeliveryNote>| &&
     |<InvoiceNumber>{ witem-billoflading }</InvoiceNumber>| &&
     |<SAPDocumentNo>{ witem-sapdocumentnumber }</SAPDocumentNo>| &&
     |<SAPDocumentDate>{ sapdocdate }</SAPDocumentDate>| &&
     |<Subform6>| &&
     |<PRNo>{ witem-prnumber }</PRNo>| &&
     |<PONo>{ witem-purchaseorder }</PONo>| &&
     |</Subform6>| &&
     |<Table1>| .







""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""new code"
    ELSEIF (  witem-goodsmovementtype = '305' ) .
      lv_header = 'GOODS ISSUE'.
      lv_sup = 'From Plant :'.

      sapdocdate = witem-sapdocumentdate+6(2) && '/' &&
                    witem-sapdocumentdate+4(2) && '/' &&
                    witem-sapdocumentdate+0(4).
      lv_xml =
      |<Form>| &&
       |<header>{ lv_header }</header>| &&
      |<Add>| .
*          SELECT SINGLE PLANT FROM zmigo_print_305
*           WHERE MaterialDocument = @ponum
*             INTO  @DATA(it12).
      LOOP AT it INTO witem.


*        SELECT SINGLE
*         FROM  i_plant
*
*          WITH PRIVILEGED ACCESS
*        FIELDS
*           plantname AS  to_address01,
*           \_address-streetname        AS to_address02,
*
*           \_address\_region\_regiontext-regionname    AS to_region,
*            \_address-postalcode         AS to_pincode,
*           \_address-phonenumber       AS to_storephone,
*          ' '     AS to_storemail
*
*
**        WHERE plant = @witem-issuingorreceivingplant
*         WHERE plant = @it12
*        INTO  @DATA(to_plant_addr11) .
*
*
*    SELECT SINGLE mobilenumber  FROM zgmail_tmg_ne WHERE plant = @it12 INTO @DATA(phoen3051).
*               SELECT SINGLE gmailid FROM zgmail_tmg_ne WHERE plant =  @it12 INTO @DATA(gmail3051).
*SELECT SINGLE plantname FROM zplant_tmg_new WHERE plant = @it12 INTO @DATA(plantadd3051).


        " Build full address fields
*        DATA(supp_303_address1) =
*           |{ to_plant_addr11-to_address01 } { to_plant_addr11-to_address02 } | &&
*          |  | &&
*          | { to_plant_addr11-to_pincode }   { to_plant_addr11-to_region }|.

*        DATA(lv_supp_303_address1) =
*      |{ witem-supp_303_address01 } { witem-supp_303_address02 } { witem-supp_303_address03 }| &&
*      | { witem-supp_303_address04 } { witem-supp_303_address05 } { witem-supp_303_address06 }| &&
*      | { witem-supp_303_pincode } { witem-supp_303_region }|.

        CONDENSE supp_303_address.
        CONDENSE lv_supp_303_address.


*           SELECT SINGLE plantname FROM zplant_tmg_new WHERE plant = @toplant INTO @DATA(plantadd305).
*    SELECT SINGLE mobilenumber  FROM zgmail_tmg_ne WHERE plant = @toplant INTO @DATA(phoen305).
*               SELECT SINGLE gmailid FROM zgmail_tmg_ne WHERE plant =  @toplant INTO @DATA(gmail305).

*        IF witem-debitcreditcode = 'H'.
        " ---- FROM PLANT ----
        lv_xml = lv_xml &&
         |<frplant>| &&
         |<fromplant_name>From Plant :</fromplant_name>| &&
*         |<fromplant>{ toplant } { pname }</fromplant>| &&
         |<fromplant>{ '' } { '' }</fromplant>| &&
*         |<fromplantadd>{ plantadd305 }</fromplantadd>| &&
         |<fromplantadd>{ '' }</fromplantadd>| &&
         |</frplant>| &&
         |<Contactdet>{ '' }</Contactdet>| &&
*         |<Contactdet>{ phoen305 }</Contactdet>| &&
*        |<Contactdet1>{ witem-to_storephone }</Contactdet1>| &&
         |<email>{ '' }</email>| &&
*         |<email>{ gmail305 }</email>| &&
*        |<email1>{ witem-to_storemail }</email1>| &&
*|<email1>{ gmail3051 }</email1> | &&
|<email1>{ '' }</email1> | &&
         |<fromplantGSTIN>{ witem-supp_303_supplt }</fromplantGSTIN>| .
*        |<toGSTIN>{ witem-to_plt_gstin }</toGSTIN>| .

*        ELSEIF witem-debitcreditcode = 'S'.
        " ---- TO PLANT ----
        lv_xml = lv_xml &&
         |<trplant>| &&
         |<toplant_name1>To Plant :</toplant_name1>| &&
*         |<toplant>{ it12 } {  to_plant_addr11-to_address01 }</toplant>| &&
         |<toplant>{ '' } {  '' }</toplant>| &&
*        |<toplantadd>{ supp_303_address1 }</toplantadd>| &&
*         |<toplantadd>{ plantadd3051 }</toplantadd>| &&
         |<toplantadd>{ '' }</toplantadd>| &&
         |</trplant>| &&
*        |<Contactdet>{ witem-supp_303_StorePhone }</Contactdet>| &&
*         |<Contactdet1>{ witem-to_storephone }</Contactdet1>| &&
*     |<Contactdet1>{ phoen3051 }</Contactdet1> | &&
     |<Contactdet1>{ '' }</Contactdet1> | &&
*        |<email>{ witem-supp_303_StoreMail }</email>| &&
*         |<email1>{ witem-to_storemail }</email1>| &&
*|<email1>{ gmail3051 }</email1> | &&
|<email1>{ '' }</email1> | &&
*        |<fromplantGSTIN>{ witem-supp_303_supplt }</fromplantGSTIN>| &&
         |<toGSTIN>{ witem-to_plt_gstin }</toGSTIN>| .

*        ENDIF.

      ENDLOOP.

      " Close only once
      lv_xml = lv_xml &&
     |</Add>| &&
     |<MovementType>{ witem-goodsmovementtype }</MovementType>| &&
     |<DeliveryNote>{ witem-deliverynote }</DeliveryNote>| &&
     |<InvoiceNumber>{ witem-billoflading }</InvoiceNumber>| &&
     |<SAPDocumentNo>{ witem-sapdocumentnumber }</SAPDocumentNo>| &&
     |<SAPDocumentDate>{ sapdocdate }</SAPDocumentDate>| &&
     |<Subform6>| &&
     |<PRNo>{ witem-prnumber }</PRNo>| &&
     |<PONo>{ witem-purchaseorder }</PONo>| &&
     |</Subform6>| &&
     |<Table1>| .


    ELSEIF (  witem-goodsmovementtype = '641' ) .
      lv_header = 'GOODS ISSUE'.
      lv_sup = 'From Plant :'.

      sapdocdate = witem-sapdocumentdate+6(2) && '/' &&
                    witem-sapdocumentdate+4(2) && '/' &&
                    witem-sapdocumentdate+0(4).
      lv_xml =
      |<Form>| &&
       |<header>{ lv_header }</header>| &&
      |<Add>| .
      LOOP AT it INTO witem.


        SELECT SINGLE
         FROM  i_plant

          WITH PRIVILEGED ACCESS
        FIELDS
           plantname AS  to_address01,
           \_address-streetname        AS to_address02,

           \_address\_region\_regiontext-regionname    AS to_region,
            \_address-postalcode         AS to_pincode,
           \_address-phonenumber       AS to_storephone,
          ' '     AS to_storemail


        WHERE plant = @witem-issuingorreceivingplant
        INTO  @DATA(to_plant_addr1) .


        " Build full address fields
        DATA(supp_303_address1) =
           |{ to_plant_addr1-to_address01 } { to_plant_addr1-to_address02 } | &&
          |  | &&
          | { to_plant_addr1-to_pincode }   { to_plant_addr1-to_region }|.

        DATA(lv_supp_303_address1) =  ''.
*      |{ witem-supp_303_address01 } { witem-supp_303_address02 } { witem-supp_303_address03 }| &&
*      | { witem-supp_303_address04 } { witem-supp_303_address05 } { witem-supp_303_address06 }| &&
*      | { witem-supp_303_pincode } { witem-supp_303_region }|.

        CONDENSE supp_303_address.
        CONDENSE lv_supp_303_address.

*        IF witem-debitcreditcode = 'H'.
        " ---- FROM PLANT ----
        lv_xml = lv_xml &&
         |<frplant>| &&
         |<fromplant_name>From Plant :</fromplant_name>| &&
         |<fromplant>{ witem-supp_303 } { witem-supp_303_plantnm }</fromplant>| &&
         |<fromplantadd>{ lv_supp_303_address1 }</fromplantadd>| &&
         |</frplant>| &&
*         |<Contactdet>{ witem-supp_303_storephone }</Contactdet>| &&
         |<Contactdet>{ '' }</Contactdet>| &&
*        |<Contactdet1>{ witem-to_storephone }</Contactdet1>| &&
*         |<email>{ witem-supp_303_storemail }</email>| &&
         |<email>{ '' }</email>| &&
*        |<email1>{ witem-to_storemail }</email1>| &&
*|<email1>{ gmailid1 }</email1> | &&
|<email1>{ '' }</email1> | &&
         |<fromplantGSTIN>{ witem-supp_303_supplt }</fromplantGSTIN>| .
*        |<toGSTIN>{ witem-to_plt_gstin }</toGSTIN>| .

*        ELSEIF witem-debitcreditcode = 'S'.
        " ---- TO PLANT ----
        lv_xml = lv_xml &&
         |<trplant>| &&
         |<toplant_name1>To Plant :</toplant_name1>| &&
         |<toplant>{ witem-issuingorreceivingplant } {  to_plant_addr1-to_address01 }</toplant>| &&
*        |<toplantadd>{ supp_303_address1 }</toplantadd>| &&
*         |<toplantadd>{ plantnameto }</toplantadd>| &&
         |<toplantadd>{ '' }</toplantadd>| &&
         |</trplant>| &&
*        |<Contactdet>{ witem-supp_303_StorePhone }</Contactdet>| &&
*         |<Contactdet1>{ witem-to_storephone }</Contactdet1>| &&
     |<Contactdet1>{ '' }</Contactdet1> | &&
*     |<Contactdet1>{ mobilenumber }</Contactdet1> | &&
*        |<email>{ witem-supp_303_StoreMail }</email>| &&
*         |<email1>{ witem-to_storemail }</email1>| &&
*|<email1>{ gmailid1 }</email1> | &&
|<email1>{ '' }</email1> | &&
*        |<fromplantGSTIN>{ witem-supp_303_supplt }</fromplantGSTIN>| &&
         |<toGSTIN>{ witem-to_plt_gstin }</toGSTIN>| .

*        ENDIF.

      ENDLOOP.

      " Close only once
      lv_xml = lv_xml &&
     |</Add>| &&
     |<MovementType>{ witem-goodsmovementtype }</MovementType>| &&
     |<DeliveryNote>{ witem-deliverynote }</DeliveryNote>| &&
     |<InvoiceNumber>{ witem-billoflading }</InvoiceNumber>| &&
     |<SAPDocumentNo>{ witem-sapdocumentnumber }</SAPDocumentNo>| &&
     |<SAPDocumentDate>{ sapdocdate }</SAPDocumentDate>| &&
     |<Subform6>| &&
     |<PRNo>{ witem-prnumber }</PRNo>| &&
     |<PONo>{ witem-purchaseorder }</PONo>| &&
     |</Subform6>| &&
     |<Table1>| .









    ELSE.                        "witem-SupplyingPlant is not INITIAL

      lv_header = 'STOCK TRANSFER'.
      lv_sup = 'From Plant :'.
      sapdocdate = witem-sapdocumentdate+6(2) && '/' &&
                  witem-sapdocumentdate+4(2) && '/' &&
                  witem-sapdocumentdate+0(4).
      lv_xml =
     |<Form>| &&
     |<header>{ lv_header }</header>| &&
     |<Add>| &&
     |<frplant>| &&
     |<fromplant_name>{ lv_sup }</fromplant_name>| &&
     |<fromplant>{ witem-supplyingplant } { witem-supp_plantnm }</fromplant>| &&
*       |<fromplantadd>{ plantnameto1 }</fromplantadd>| &&
       |<fromplantadd>{ '' }</fromplantadd>| &&
     |</frplant>| &&
     |<trplant>| &&
     |<toplant_name>From Plant :</toplant_name>| &&
     |<toplant>{ witem-to_plant } { witem-to_plantnm }</toplant>| &&
     |<toplantadd>{ '' }</toplantadd>| &&
*     |<toplantadd>{ plantnameto }</toplantadd>| &&
     |</trplant>| &&
*     |<Contactdet>{ witem-storephone }</Contactdet>| &&
     |<Contactdet>{ '' }</Contactdet>| &&
*     |<Contactdet1>{ witem-to_storephone }</Contactdet1>| &&
*     |<Contactdet1>{ mobilenumber }</Contactdet1> | &&
     |<Contactdet1>{ '' }</Contactdet1> | &&
*     |<email>{ witem-storemail }</email>| &&
     |<email>{ '' }</email>| &&
*|<email1>{ gmailid1 }</email1> | &&
|<email1>{ '' }</email1> | &&
     |<fromplantGSTIN>{ witem-suppltgst }</fromplantGSTIN>| &&
     |<toGSTIN>{ witem-to_plt_gstin }</toGSTIN>| &&
     |</Add>| &&
     |<MovementType>{ witem-goodsmovementtype }</MovementType>| &&
     |<DeliveryNote>{ witem-deliverynote }</DeliveryNote>| &&
     |<InvoiceNumber>{ witem-billoflading }</InvoiceNumber>| &&
     |<SAPDocumentNo>{ witem-sapdocumentnumber }</SAPDocumentNo>| &&
     |<SAPDocumentDate>{ sapdocdate }</SAPDocumentDate>| &&
     |<Subform6>| &&
     |<PRNo>{ witem-prnumber }</PRNo>| &&
     |<PONo>{ witem-purchaseorder }</PONo>| &&
     |</Subform6>| &&
     |<Table1>| .

    ENDIF.


    DATA: lv_rate(16) TYPE p DECIMALS 2.
    DATA xsml TYPE string .
*    // 8.10.2025
    DATA(it1) =   it.
    DELETE ADJACENT DUPLICATES FROM it1 COMPARING material materialbaseunit quantity value.
    LOOP AT it1 INTO DATA(iv) .


      DATA: lv_new_unit TYPE string.

      CASE iv-materialbaseunit.

        WHEN 'ZBO'.
          lv_new_unit = 'BOX'.

        WHEN 'ZBU'.
          lv_new_unit = 'BDL'.

        WHEN 'ZLS'.
          lv_new_unit = 'LS'.

        WHEN 'ZNO'.
          lv_new_unit = 'NOS'.

        WHEN 'ZSE'.
          lv_new_unit = 'SET'.

                  WHEN 'ZMT'.
          lv_new_unit = 'MTR'.

        WHEN OTHERS.
          lv_new_unit = iv-materialbaseunit.

      ENDCASE.


      lv_rate = iv-value / iv-quantity.
      SHIFT iv-material LEFT DELETING LEADING '0'.
      DATA(lv_xml2) =
    |<Row1> | &&
        |<Cell1>{ sy-tabix }</Cell1>| &&
        |<descwithcode>{ iv-productdescription } ( { iv-material } ) </descwithcode>| &&
        |<uom>{ lv_new_unit }</uom>| &&
        |<qty>{ iv-quantity }</qty>| &&
        |<rate>{ lv_rate }</rate>| &&
        |<Value>{ iv-value }</Value>| &&
        |<Remark></Remark> | &&
    |</Row1> | .

      CONCATENATE xsml lv_xml2 INTO  xsml .
    ENDLOOP.
*    // 8.10.2025
*    LOOP AT it INTO DATA(iv) .
*      lv_rate = iv-quantity * iv-value.
*        SHIFT iv-material LEFT DELETING LEADING '0'.
*      DATA(lv_xml2) =
*    |<Row1> | &&
*        |<Cell1>{ sy-tabix }</Cell1>| &&
*        |<descwithcode>{ iv-productdescription } ( { iv-material } ) </descwithcode>| &&
*        |<uom>{ iv-materialbaseunit }</uom>| &&
*        |<qty>{ iv-quantity }</qty>| &&
*        |<rate>{ lv_rate }</rate>| &&
*        |<Value>{ iv-value }</Value>| &&
*        |<Remark></Remark> | &&
*    |</Row1> | .
*
*      CONCATENATE xsml lv_xml2 INTO  xsml .
*    ENDLOOP.

    DATA(lv_xml3) =
    |<Cell8></Cell8>| &&
    |<Cell9></Cell9>| &&
    |</Table1>| &&
    |<footertext>| &&
    |<PreparedBy>| &&
    |<UserName>{ witem-sitestoreuser }</UserName>  | &&
    |</PreparedBy>| &&
    |</footertext>| &&
    |</Form>|.

    CONCATENATE lv_xml xsml lv_xml3 INTO lv_xml .

    DATA tete TYPE xstring .
*
*    CALL METHOD zmm_adobe_print=>getpdf(
*      EXPORTING
*        xmldata  = lv_xml
*        template = 'MIGO_FORM/MIGO_FORM'
*      RECEIVING
*        result   = tete ).
*
*    result12 = xco_cp=>xstring( tete
*          )->as_string( xco_cp_binary=>text_encoding->base64
*          )->value .

  ENDMETHOD.
ENDCLASS.
