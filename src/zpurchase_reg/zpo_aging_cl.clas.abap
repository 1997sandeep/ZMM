CLASS zpo_aging_cl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZPO_AGING_CL IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA(lv_conditions) =  io_request->get_filter( )->get_as_sql_string( ).
*       DATA(lv_offset)  = lo_paging->get_offset( ).
    DATA(lv_top)     = io_request->get_paging( )->get_page_size( ).
    IF lv_top < 0.
      lv_top = 1.
    ENDIF.

    DATA:lt_current_output TYPE TABLE OF zpo_aging_entity.
    DATA:wa1 TYPE zpo_aging_entity.
    DATA(lt_clause) = io_request->get_filter( )->get_as_sql_string( ).

**      lv_top = 100.

    DATA(lv_skip)    = io_request->get_paging( )->get_offset( ).

    DATA(lt_sort)    = io_request->get_sort_elements( ).

    DATA : lv_orderby TYPE string.
    LOOP AT lt_sort INTO DATA(ls_sort).
      IF ls_sort-descending = abap_true.
        lv_orderby = |'{ lv_orderby } { ls_sort-element_name } DESCENDING '|.
      ELSE.
        lv_orderby = |'{ lv_orderby } { ls_sort-element_name } ASCENDING '|.
      ENDIF.
    ENDLOOP.
    IF lv_orderby IS INITIAL.
      lv_orderby = 'COMPANYCODE'.
    ENDIF.

*      DATA(lv_conditions) =  io_request->get_filter( )->get_as_sql_string( ).

    DATA(lo_paging)  = io_request->get_paging( ).
    DATA(lv_offset)  = lo_paging->get_offset( ).
    DATA(lv_rows)    = lo_paging->get_page_size( ).
    DATA(lv_max_rows) = COND #( WHEN lv_rows =
            if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_rows ).
    DATA : comp(4)   TYPE n,
           form_date TYPE c LENGTH 12,
           to_date   TYPE c LENGTH 12.
*
    DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
    READ TABLE lt_filter_cond INTO DATA(ls_cc) WITH KEY name = 'COMPANYCODE'.
    IF sy-subrc = 0.
      comp = ls_cc-range[ 1 ]-low.
    ENDIF.
    READ TABLE  lt_filter_cond INTO DATA(ls_date) WITH KEY name = 'PAYMENT_DATE'.
    IF ls_date-range[ 1 ]-option = 'GE'.
      form_date = ls_date-range[ 1 ]-low .
    ENDIF.
    IF ls_date-range[ 2 ]-option = 'LE'.
      to_date = ls_date-range[ 2 ]-low .
    ENDIF.


    TYPES : BEGIN OF st_final,
              companycode(4)        TYPE n,
              companyname(150)      TYPE c,
              pono(10)              TYPE n,
              podate(11)            TYPE c,
              suppliername(100)     TYPE c,
              basicvalue            TYPE p LENGTH 12 DECIMALS 2,
              gst                   TYPE p LENGTH 12 DECIMALS 2,
              totvalue              TYPE p LENGTH 12 DECIMALS 2,
              poapp_1_name(50)      TYPE c,
              poapp_1_date(11)      TYPE c,
              poapp_2_name(50)      TYPE c,
              poapp_2_date(11)      TYPE c,
              poapp_3_name(50)      TYPE c,
              poapp_3_date(11)      TYPE c,
              ses_grnno(10)         TYPE c,
              ses_grndate(11)       TYPE c,
              sesgrn_1_name(50)     TYPE c,
              sesgrn_1_date(11)     TYPE c,
              sesgrn_2_name(50)     TYPE c,
              sesgrn_2_date(11)     TYPE c,
              sesgrn_3_name(50)     TYPE c,
              sesgrn_3_date(11)     TYPE c,
              rabillno(15)          TYPE c,
              invno(10)             TYPE n,
              invdoc_date(11)       TYPE c,
              invref(30)            TYPE c,
              invdate(11)           TYPE c,
              invamt                TYPE p LENGTH 12 DECIMALS 2,
              inv_1_name(50)        TYPE c,
              inv_1_date(11)        TYPE c,
              inv_2_name(50)        TYPE c,
              inv_2_date(11)        TYPE c,
              inv_3_name(50)        TYPE c,
              inv_3_date(11)        TYPE c,
              paymentabs_date(11)   TYPE c,
              paymentabs_1_name(50) TYPE c,
              paymentabs_1_date(11) TYPE c,
              paymentabs_2_name(50) TYPE c,
              paymentabs_2_date(11) TYPE c,
              paymentabs_3_name(50) TYPE c,
              paymentabs_3_date(11) TYPE c,
              paymentamt            TYPE p LENGTH 12 DECIMALS 2,
              proposed_date(11)     TYPE c,
              payment_date(11)      TYPE c,
              utr(100)              TYPE c,
              payment_delay         TYPE i,
              final_app_pay_day     TYPE i,
              days_from_invdate     TYPE i,
              rec_date(11) TYPE c,
              rec_day             TYPE i,
              payment_ind(20)       TYPE c,
              gstin(20) type c,
              vendortype(100) type c,
              paymentduedate(11) type c,
              bankname(50) type c,
              bankacc(30) type c ,
              postatus(20) type c,
               taxablevalue  TYPE p LENGTH 12 DECIMALS 2,
*               gst     TYPE p LENGTH 12 DECIMALS 2,

            END OF st_final.
    DATA : it_final TYPE TABLE OF st_final,
           wa_final TYPE st_final.

*           data :  lt_current_output TYPE TABLE OF zpo_aging_entity,
*           wa_transfer TYPE zpo_aging_entity.

    DATA : purchaseorder(10) TYPE n,
           companycode       TYPE string.
    DATA: lv_prop_d    TYPE d,
          lv_pay_d     TYPE d,
          lv_delay_int TYPE i.

    REPLACE ALL OCCURRENCES OF '-' IN form_date WITH ''.
    REPLACE ALL OCCURRENCES OF '-' IN to_date WITH ''.
    SELECT FROM zpo_aging_main AS a
    LEFT OUTER JOIN zmm_rabill_pay_abstract_head1 AS b ON b~Ebeln = a~PurchaseOrder  AND b~ServiceEntrySheet = a~PurchasingHistoryDocument       """"""""""""""""""""""""po data
    FIELDS
    a~PurchaseOrder,
    a~CompanyCode,
    a~Supplier,
    a~CreationDate,
    a~companyCodeName,
    a~SupplierName,
    a~DocumentCurrency,
    a~baseamt,
    a~gst,
    a~totval,
    b~Rabillno,
    a~PostingDate,
    a~PurchasingHistoryDocument
    WHERE   a~CompanyCode = @comp
    AND a~PurchasingHistoryDocument IS NOT  INITIAL
    AND a~PostingDate BETWEEN @form_date AND @to_date
    INTO TABLE @DATA(it_main).

    SORT it_main BY CompanyCode  PurchaseOrder Rabillno PurchasingHistoryDocument .
    DELETE ADJACENT DUPLICATES FROM it_main COMPARING CompanyCode PurchaseOrder Rabillno PurchasingHistoryDocument .

    SELECT FROM zpo_aging_main AS a
    LEFT OUTER JOIN zpo_rabill_advice AS b ON b~Ebeln = a~PurchaseOrder         """"""""""""""""""""""""   advance rabill po data
    FIELDS
    a~PurchaseOrder,
    a~CompanyCode,
    a~Supplier,
    a~CreationDate,
    a~companyCodeName,
    a~SupplierName,
    a~DocumentCurrency,
    a~baseamt,
    a~gst,
    a~totval,
    b~Rabillno
    WHERE   a~CompanyCode = @comp
    AND b~Rabillno IS NOT INITIAL
    AND a~PostingDate BETWEEN @form_date AND @to_date
    INTO TABLE @DATA(it_main1).

    SORT it_main1 BY CompanyCode  PurchaseOrder Rabillno .
    DELETE ADJACENT DUPLICATES FROM it_main1 COMPARING CompanyCode PurchaseOrder Rabillno  .

    APPEND LINES OF it_main1 TO it_main.


    SELECT FROM i_supplier AS a
    INNER JOIN I_SupplierAccountGroupText AS b ON b~SupplierAccountGroup = a~SupplierAccountGroup
     FIELDS
     a~Supplier,
     a~TaxNumber3,
     b~AccountGroupName
     FOR ALL ENTRIES IN @it_main
     WHERE  a~Supplier = @it_main-Supplier
     INTO TABLE @DATA(it_vend).



    SELECT FROM I_PurchaseOrderHistoryAPI01 AS a
    INNER JOIN zpo_aging_main AS b ON b~PurchaseOrder = a~PurchaseOrder
     FIELDS
     a~PurchaseOrder,
     a~PostingDate,
     b~CompanyCode,
     b~Supplier,
     b~CreationDate,
     b~companyCodeName,
     b~SupplierName,
     b~DocumentCurrency,
     b~baseamt,
     b~gst,
     b~totval
     WHERE PurchasingHistoryCategory = 'A'
     AND b~CompanyCode = @comp
     AND b~PostingDate BETWEEN @form_date AND @to_date
     INTO TABLE @DATA(it_adpo).

    SELECT FROM I_OperationalAcctgDocItem
    FIELDS
    PurchasingDocument,
    ClearingJournalEntry,
    CompanyCode,
    FiscalYear
    FOR ALL ENTRIES IN @it_adpo
    WHERE PurchasingDocument = @it_adpo-PurchaseOrder
    AND SpecialGLCode = 'F'
    AND ClearingJournalEntry IS NOT INITIAL
    AND AccountingDocumentType = 'KA'
    INTO TABLE @DATA(adpay).

    SELECT FROM I_OperationalAcctgDocItem AS a
    INNER JOIN I_CompanyCode AS b ON b~CompanyCode = a~CompanyCode
    FIELDS
    AccountingDocument,
    PostingDate,
    AmountInCompanyCodeCurrency,
    a~CompanyCode,
    FiscalYear,
    b~CompanyCodeName
    FOR ALL ENTRIES IN @adpay
    WHERE AccountingDocument = @adpay-ClearingJournalEntry
    AND a~CompanyCode = @adpay-CompanyCode
    AND FiscalYear = @adpay-FiscalYear
    AND GLAccount LIKE '00127%'
    AND AccountingDocumentType IN (  'KZ','ZP' )
    INTO TABLE @DATA(ad_paymentde).




    SORT it_adpo BY PurchaseOrder.
    DELETE ADJACENT DUPLICATES FROM it_adpo COMPARING PurchaseOrder.

    " IT_ADPO has a different structure, so map fields manually
    LOOP AT it_adpo INTO DATA(ls_adpo).
      APPEND INITIAL LINE TO it_main ASSIGNING FIELD-SYMBOL(<ls_main>).
      <ls_main>-PurchaseOrder = ls_adpo-PurchaseOrder.
      <ls_main>-PostingDate  = ls_adpo-PostingDate.
      <ls_main>-CreationDate  = ls_adpo-CreationDate.
      <ls_main>-CompanyCode  = ls_adpo-CompanyCode.
      <ls_main>-CompanyCodeName  = ls_adpo-CompanyCodeName.
      <ls_main>-Supplier  = ls_adpo-Supplier.
      <ls_main>-SupplierName  = ls_adpo-SupplierName.
      <ls_main>-baseamt  = ls_adpo-baseamt.
      <ls_main>-gst  = ls_adpo-gst.
      <ls_main>-totval  = ls_adpo-totval.
    ENDLOOP.


    IF it_main IS NOT INITIAL.
      SELECT FROM zpo_approval AS a
      INNER JOIN i_user WITH PRIVILEGED ACCESS AS b ON b~UserID = a~WorkflowTaskProcessor   """"""""""""""""""""""""po approvals
      FIELDS
      a~SAPBusinessObjectNodeKey1,
      a~WorkflowTaskProcessor,
      a~date1,
      a~time1,
      b~UserDescription
      FOR ALL ENTRIES IN @it_main
      WHERE a~SAPBusinessObjectNodeKey1 = @it_main-PurchaseOrder
      INTO TABLE @DATA(it_po_approvals).
      SORT it_po_approvals BY SAPBusinessObjectNodeKey1 WorkflowTaskProcessor ASCENDING.
      DELETE ADJACENT DUPLICATES FROM it_po_approvals COMPARING SAPBusinessObjectNodeKey1 WorkflowTaskProcessor.
      SORT it_po_approvals BY date1 time1 ASCENDING.
    ENDIF.

    IF it_main IS NOT INITIAL.
      SELECT FROM zpo_approval AS a
      INNER JOIN i_user WITH PRIVILEGED ACCESS  AS b ON b~UserID = a~WorkflowTaskProcessor   """"""""""""""""""""""""ses approvals
      FIELDS
      a~SAPBusinessObjectNodeKey1,
      a~WorkflowTaskProcessor,
      a~date1,
      a~time1,
      b~UserDescription
      FOR ALL ENTRIES IN @it_main
      WHERE a~SAPBusinessObjectNodeKey1 = @it_main-PurchasingHistoryDocument
      INTO TABLE @DATA(it_ses_approvals).
      SORT it_ses_approvals BY date1  time1 ASCENDING.

      SELECT  FROM I_PurchaseOrderHistoryAPI01               """""invoice data
      FIELDS
      purchaseorder,
      PurchasingHistoryDocument,
      PostingDate,ReferenceDocument
      FOR ALL ENTRIES IN @it_main
      WHERE PurchaseOrder = @it_main-purchaseorder
      AND ReferenceDocument = @it_main-PurchasingHistoryDocument
      AND PurchasingHistoryDocumentType = '2'
      INTO TABLE  @DATA(wa_inv).
    ENDIF.
    IF wa_inv IS NOT INITIAL.
      SELECT   FROM I_SupplierInvoiceAPI01                              """""invoice reference
      FIELDS
      SupplierInvoice,
      SupplierInvoiceIDByInvcgParty,
      PostingDate,
      DocumentDate,
      InvoiceGrossAmount
      FOR ALL ENTRIES IN @wa_inv
      WHERE SupplierInvoice = @wa_inv-PurchasingHistoryDocument
      INTO TABLE @DATA(wa_invref).

      SELECT  FROM zpo_approval AS a
      INNER JOIN i_user WITH PRIVILEGED ACCESS AS b ON b~UserID = a~WorkflowTaskProcessor   """"""""""""""""""""""""invoice approvals
      FIELDS
      a~SAPBusinessObjectNodeKey1,
      a~WorkflowTaskProcessor,
      a~date1,
       a~time1,
      b~UserDescription
      FOR ALL ENTRIES IN @wa_inv
      WHERE a~SAPBusinessObjectNodeKey1 = @wa_inv-PurchasingHistoryDocument
*   ORDER BY date1 ASCENDING
      INTO TABLE @DATA(it_inv_approvals).
      SORT it_inv_approvals BY date1 time1 ASCENDING.
    ENDIF.
    IF it_main IS NOT INITIAL.
      SELECT FROM zmmt_scp_pa_aprl AS a                           """""""""""""""""""""""Payment abstract
      INNER JOIN I_user WITH PRIVILEGED ACCESS AS b  ON b~UserID = a~user_name
      FIELDS
      a~ra_bill_no,
      a~app_level,
      a~appr_status,
      a~user_name,
      a~zdate,
      a~ztime,
      b~UserDescription
      FOR ALL ENTRIES IN @it_main
      WHERE a~ra_bill_no = @it_main-Rabillno
      INTO TABLE @DATA(it_rabill_app).
    ENDIF.

    IF it_rabill_app IS NOT INITIAL.
      SELECT  FROM zmm_rabill_payabst_display
      FIELDS
      Rabillno,
      PostingDate
      FOR ALL ENTRIES IN @it_rabill_app
      WHERE Rabillno = @it_rabill_app-ra_bill_no
      INTO  TABLE @DATA(rabill_date).
    ENDIF.
    IF wa_inv IS NOT INITIAL.
      SELECT  FROM zpaydetail_po
      FIELDS
      ClearingJournalEntry,
      ClearingDocFiscalYear,
      CompanyCode,
      FiscalYear,OriginalReferenceDocument
      FOR ALL ENTRIES IN @wa_inv
      WHERE OriginalReferenceDocument = @wa_inv-PurchasingHistoryDocument
      INTO  TABLE @DATA(paydetail).

    ENDIF.
    IF paydetail IS NOT INITIAL.
      SELECT  FROM I_OperationalAcctgDocItem
      FIELDS
      AccountingDocument,
      CompanyCode,
      FiscalYear,
      PostingDate,
      AmountInCompanyCodeCurrency,
      AssignmentReference
      FOR ALL ENTRIES IN @paydetail
      WHERE AccountingDocument = @paydetail-ClearingJournalEntry
      AND CompanyCode = @paydetail-CompanyCode
      AND FiscalYear = @paydetail-ClearingDocFiscalYear
*      and FinancialAccountType = 'K'
*      AND DebitCreditCode = 'S'
    AND GLAccount LIKE '00127%'
      INTO  TABLE @DATA(paydetails).

*      SORT paydetails BY AccountingDocument PurchasingDocument ReferenceDocument.
*      DELETE ADJACENT DUPLICATES FROM paydetails COMPARING AccountingDocument PurchasingDocument ReferenceDocument.
    ENDIF.


   """""""""rABILL ADVANCE PAYAMT


   SELECT FROM ZMM_RABILL_PAYABST_DISPLAYITEM
   FIELDS
   Rabillno,
   thisbill
   FOR ALL ENTRIES IN @it_main1
   WHERE Rabillno = @it_main1-Rabillno
   AND SrNo = '042'
   INTO TABLE @DATA(RABILL_ADV_PAYAMT).



    """"""""""""""""""""RABill Adavce case""""""""""""""""""""""""""""""""""""

    SELECT  FROM ZADVANCE_SES
    FIELDS
    ebeln,
    ra_bill_no,
    prinvoice,
    prinvoice_date,
    last_changed_date
    FOR ALL ENTRIES IN @it_main
    WHERE ebeln = @it_main-PurchaseOrder
    AND ra_bill_no = @it_main-Rabillno
    and last_changed_date BETWEEN @form_date AND @to_date
    INTO TABLE @DATA(adrabill_data).


    """""""""""""""""Reco date
  if wa_inv is not INITIAL.
    SELECT from ZPO_RECDATE
    FIELDS
    AccountingDocument,
    CompanyCode,
    FiscalYear,
    OriginalReferenceDocument,
    ClearingDocFiscalYear,
    ClearingJournalEntry
    FOR ALL ENTRIES IN @wa_inv
    WHERE OriginalReferenceDocument = @wa_inv-PurchasingHistoryDocument
    into TABLE @data(it_po_reco).
  endif.
   if it_po_reco is not INITIAL.
    SELECT  FROM ZPO_RECDATE1
    FIELDS
    ClearingJournalEntry,
    ClearingDocFiscalYear,
    FiscalYear,
    CompanyCode,
    AccountingDocument
    FOR ALL ENTRIES IN @it_po_reco
    WHERE AccountingDocument = @it_po_reco-ClearingJournalEntry AND FiscalYear = @it_po_reco-ClearingDocFiscalYear
    AND CompanyCode = @it_po_reco-CompanyCode
    INTO TABLE @DATA(it_po_rec_dat).
endif.
if it_po_rec_dat is not INITIAL.
    SELECT  FROM I_OperationalAcctgDocItem
    FIELDS
    AccountingDocument,
    CompanyCode,
    FiscalYear,
    PostingDate,
    ClearingJournalEntry
    FOR ALL ENTRIES IN @it_po_rec_dat
    WHERE CompanyCode = @comp
    AND FiscalYear = @it_po_rec_dat-ClearingDocFiscalYear
    AND ClearingJournalEntry = @it_po_rec_dat-ClearingJournalEntry
    AND AccountingDocumentType in ( 'ZR' , 'SA' )
    AND GLAccount LIKE '00127%'
    and HouseBank is not INITIAL
    INTO TABLE  @DATA(it_po_rec_dat1).
endif.


    LOOP AT it_main INTO DATA(wa_main).
      wa_final-companycode = wa_main-CompanyCode.
      wa_final-companyname = wa_main-CompanyCodeName.
      wa_final-pono = wa_main-PurchaseOrder.
      wa_final-podate =  | { wa_main-CreationDate+6(2) }-{ wa_main-CreationDate+4(2) }-{ wa_main-CreationDate+0(4) }| .
      wa_final-suppliername = wa_main-SupplierName.
      wa_final-basicvalue = wa_main-baseamt.
      wa_final-gst = wa_main-gst.
      wa_final-totvalue = wa_main-totval.
      wa_final-rabillno = wa_main-Rabillno.
      wa_final-ses_grnno = |{ wa_main-PurchasingHistoryDocument ALPHA = OUT }|.

       READ TABLE it_vend ASSIGNING FIELD-SYMBOL(<fs_vend>)
       WITH KEY Supplier = wa_main-Supplier.
       if sy-subrc = 0.
       wa_final-gstin = <fs_vend>-TaxNumber3.
       wa_final-vendortype = <fs_vend>-AccountGroupName.
       endif.

*      read TABLE wa_ses into data(wa_ss) with KEY PurchaseOrder = wa_main-PurchaseOrder.
      wa_final-ses_grndate =  | { wa_main-PostingDate+6(2) }-{ wa_main-PostingDate+4(2) }-{ wa_main-PostingDate+0(4) }|.
      READ TABLE adrabill_data INTO DATA(wa_adra) WITH KEY ebeln = wa_main-PurchaseOrder
                                                            ra_bill_no = wa_main-Rabillno.
      IF sy-subrc = 0.
        DATA dat TYPE string.
        dat = wa_adra-last_changed_date.
        wa_final-ses_grndate =  | { dat+6(2) }-{ dat+4(2)  }-{ dat+0(4) }|.
      ENDIF.
      READ TABLE wa_inv INTO DATA(waa_inv) WITH KEY PurchaseOrder = wa_main-PurchaseOrder  ReferenceDocument = wa_main-PurchasingHistoryDocument.
      wa_final-invno = waa_inv-PurchasingHistoryDocument.
*      wa_final-invdate = waa_inv-PostingDate.

      READ TABLE wa_invref INTO DATA(wa_invr) WITH KEY SupplierInvoice = waa_inv-PurchasingHistoryDocument  .
      wa_final-invref = wa_invr-SupplierInvoiceIDByInvcgParty.
      wa_final-invdate =  | { wa_invr-PostingDate+6(2) }-{ wa_invr-PostingDate+4(2) }-{ wa_invr-PostingDate+0(4) }|.
      wa_final-invdoc_date =  | { wa_invr-DocumentDate+6(2) }-{ wa_invr-DocumentDate+4(2) }-{ wa_invr-DocumentDate+0(4) }|.
      wa_final-invamt = wa_invr-InvoiceGrossAmount.


      READ TABLE adrabill_data INTO wa_adra WITH KEY ebeln = wa_main-PurchaseOrder
                                                            ra_bill_no = wa_main-Rabillno.
      IF sy-subrc = 0.
        wa_final-invref = wa_adra-prinvoice.
        wa_final-invdoc_date =  | { wa_adra-prinvoice_date+0(2) }-{ wa_adra-prinvoice_date+2(2)  }-{ wa_adra-prinvoice_date+4(4) }|.
      ENDIF.

      READ TABLE rabill_date INTO DATA(wa_radate) WITH KEY Rabillno = wa_main-Rabillno. .
      wa_final-paymentabs_date = | { wa_radate-PostingDate+6(2) }-{ wa_radate-PostingDate+4(2) }-{ wa_radate-PostingDate+0(4) }|.



      DATA: lv_count TYPE i.
      lv_count = 0.
      LOOP AT it_po_approvals INTO DATA(wa_poapp) WHERE SAPBusinessObjectNodeKey1 = wa_main-PurchaseOrder.
        lv_count = lv_count + 1.
        CASE lv_count.
          WHEN 1.
            wa_final-poapp_1_name = wa_poapp-UserDescription.
            wa_final-poapp_1_date = | { wa_poapp-date1+6(2) }-{ wa_poapp-date1+4(2) }-{ wa_poapp-date1+0(4) }| .
          WHEN 2.
            wa_final-poapp_2_name = wa_poapp-UserDescription.
            wa_final-poapp_2_date = | { wa_poapp-date1+6(2) }-{ wa_poapp-date1+4(2) }-{ wa_poapp-date1+0(4) }|.
          WHEN 3.
            wa_final-poapp_3_name = wa_poapp-UserDescription.
            wa_final-poapp_3_date = | { wa_poapp-date1+6(2) }-{ wa_poapp-date1+4(2) }-{ wa_poapp-date1+0(4) }|.
        ENDCASE.
        CLEAR :wa_poapp.
      ENDLOOP.

      CLEAR : lv_count.
      lv_count = 0.
      LOOP AT it_ses_approvals INTO DATA(wa_s)  WHERE SAPBusinessObjectNodeKey1 = wa_main-PurchasingHistoryDocument.
        lv_count = lv_count + 1.
        CASE lv_count.
          WHEN 1.
            wa_final-sesgrn_1_name = wa_s-UserDescription.
            wa_final-sesgrn_1_date = | { wa_s-date1+6(2) }-{ wa_s-date1+4(2) }-{ wa_s-date1+0(4) }|.
          WHEN 2.
            wa_final-sesgrn_2_name = wa_s-UserDescription.
            wa_final-sesgrn_2_date = | { wa_s-date1+6(2) }-{ wa_s-date1+4(2) }-{ wa_s-date1+0(4) }|.
          WHEN 3.
            wa_final-sesgrn_3_name = wa_s-UserDescription.
            wa_final-sesgrn_3_date = | { wa_s-date1+6(2) }-{ wa_s-date1+4(2) }-{ wa_s-date1+0(4) }|.
        ENDCASE.
        CLEAR :wa_s.
      ENDLOOP.


      CLEAR : lv_count.
      lv_count = 0.
      LOOP AT it_inv_approvals INTO DATA(wa_in) WHERE SAPBusinessObjectNodeKey1 = waa_inv-PurchasingHistoryDocument.
        lv_count = lv_count + 1.
        CASE lv_count.
          WHEN 1.
            wa_final-inv_1_name = wa_in-UserDescription.
            wa_final-inv_1_date = | { wa_in-date1+6(2) }-{ wa_in-date1+4(2) }-{ wa_in-date1+0(4) }|.
          WHEN 2.
            wa_final-inv_2_name = wa_in-UserDescription.
            wa_final-inv_2_date = | { wa_in-date1+6(2) }-{ wa_in-date1+4(2) }-{ wa_in-date1+0(4) }|.
          WHEN 3.
            wa_final-inv_3_name = wa_in-UserDescription.
            wa_final-inv_3_date = | { wa_in-date1+6(2) }-{ wa_in-date1+4(2) }-{ wa_in-date1+0(4) }|.
        ENDCASE.
        CLEAR :wa_in.
      ENDLOOP.


      LOOP AT it_rabill_app INTO DATA(wa_payab) WHERE ra_bill_no = wa_final-rabillno.
        CASE wa_payab-app_level .
          WHEN 1.
            wa_final-paymentabs_1_name = wa_payab-UserDescription.
            wa_final-paymentabs_1_date = | { wa_payab-zdate+6(2) }-{ wa_payab-zdate+4(2) }-{ wa_payab-zdate+0(4) }|.
          WHEN 2.
            wa_final-paymentabs_2_name = wa_payab-UserDescription.
            wa_final-paymentabs_2_date = | { wa_payab-zdate+6(2) }-{ wa_payab-zdate+4(2) }-{ wa_payab-zdate+0(4) }|.
          WHEN 3.
            wa_final-paymentabs_3_name = wa_payab-UserDescription.
            wa_final-paymentabs_3_date = | { wa_payab-zdate+6(2) }-{ wa_payab-zdate+4(2) }-{ wa_payab-zdate+0(4) }|.
*           lv_prop_d =  wa_payab-zdate.
        ENDCASE.
        CLEAR :wa_payab.
      ENDLOOP.

      READ TABLE adpay INTO DATA(wa_adpay) WITH KEY PurchasingDocument = wa_main-PurchaseOrder.
      READ TABLE ad_paymentde INTO DATA(wa_adpayy) WITH KEY AccountingDocument = wa_adpay-ClearingJournalEntry
                                                            CompanyCode = wa_adpay-CompanyCode
                                                            FiscalYear = wa_adpay-FiscalYear.
      IF sy-subrc = 0.
        wa_final-payment_date = | { wa_adpayy-PostingDate+6(2) }-{ wa_adpayy-PostingDate+4(2) }-{ wa_adpayy-PostingDate+0(4) }|.
        wa_final-paymentamt = wa_adpayy-AmountInCompanyCodeCurrency.
      ENDIF.
*      wa_final-payment_date = '00000000'.


      READ TABLE  paydetail INTO DATA(wa_payddd) WITH KEY   OriginalReferenceDocument = waa_inv-PurchasingHistoryDocument.
      READ TABLE  paydetails INTO DATA(wa_payd) WITH KEY  AccountingDocument   = wa_payddd-ClearingJournalEntry
                                                           CompanyCode = wa_payddd-CompanyCode
                                                           FiscalYear = wa_payddd-ClearingDocFiscalYear.
      IF sy-subrc = 0.
        wa_final-payment_date = | { wa_payd-PostingDate+6(2) }-{ wa_payd-PostingDate+4(2) }-{ wa_payd-PostingDate+0(4) }|.
        wa_final-utr = wa_payd-AssignmentReference.
        wa_final-paymentamt = wa_payd-AmountInCompanyCodeCurrency.
       else.
       read TABLE it_main1 into data(wa_adpaydate) WITH KEY Rabillno = wa_main-Rabillno.
       SELECT SINGLE FROM zmmt_scp_pa_aprl FIELDS zdate WHERE  ra_bill_no = @wa_adpaydate-Rabillno
       and app_level = '3' into @data(adddatte).

       if sy-subrc = 0.
        wa_final-payment_date = | { adddatte+6(2) }-{ adddatte+4(2) }-{ adddatte+0(4) }|.
        endif.
      ENDIF.

      """"""""""Rabilladvance payment amt

      READ TABLE RABILL_ADV_PAYAMT into data(raad_paymat) WITH KEY Rabillno = wa_main-Rabillno.
      if sy-subrc = 0.
      wa_final-paymentamt = raad_paymat-thisbill.
      endif.

      DATA(datt) =  wa_final-payment_date.

      REPLACE ALL OCCURRENCES OF '00-00-0000' IN datt WITH ''.

      IF datt IS INITIAL.   " CO = "contains only" these chars (0 and space)
        wa_final-payment_ind = 'Open'.
      ELSE.
        wa_final-payment_ind = 'Closed'.
      ENDIF.
      SELECT SINGLE FROM zdays_po_ageing
      FIELDS
      CalendarDate,
      CalendarDay,
      DayName,
      CalendarYear
      WHERE CalendarDate = @wa_main-PostingDate
      INTO  @DATA(wa_pro_date).
      DATA lv_proposed TYPE d.
      IF wa_pro_date IS NOT INITIAL.

        IF wa_pro_date-DayName = 'Monday'.
          lv_proposed = wa_main-PostingDate + 15.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ELSEIF wa_pro_date-DayName = 'Tuesday'.
          lv_proposed = wa_main-PostingDate + 21.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ELSEIF wa_pro_date-DayName = 'Wednesday'.
          lv_proposed = wa_main-PostingDate + 20.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ELSEIF wa_pro_date-DayName = 'Thursday'.
          lv_proposed = wa_main-PostingDate + 19.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ELSEIF wa_pro_date-DayName = 'Friday'.
          lv_proposed = wa_main-PostingDate + 18.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ELSEIF wa_pro_date-DayName = 'Saturday'.
          lv_proposed = wa_main-PostingDate + 17.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ELSEIF wa_pro_date-DayName = 'Sunday'.
          lv_proposed = wa_main-PostingDate + 16.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ENDIF.
      ENDIF.

      """"""""""""""""""""""""""""""""""'advance case
      READ TABLE adrabill_data INTO wa_adra WITH KEY ebeln = wa_main-PurchaseOrder
                                                                  ra_bill_no = wa_main-Rabillno.

      DATA: lv_date_str TYPE string,
            datts       TYPE d.

      lv_date_str = wa_adra-last_changed_date.

      datts = lv_date_str+0(8).
      SELECT SINGLE FROM zdays_po_ageing
      FIELDS
      CalendarDate,       """""ssss
      CalendarDay,
      DayName,
      CalendarYear
      WHERE CalendarDate = @datts
      INTO  @wa_pro_date.
      IF wa_pro_date IS NOT INITIAL.

        IF sy-subrc = 0.
          IF wa_pro_date-DayName = 'Monday'.
            lv_proposed = datts + 15.
            wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
          ELSEIF wa_pro_date-DayName = 'Tuesday'.
            lv_proposed = datts + 21.
            wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
          ELSEIF wa_pro_date-DayName = 'Wednesday'.
            lv_proposed = datts + 20.
            wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
          ELSEIF wa_pro_date-DayName = 'Thursday'.
            lv_proposed = datts + 19.
            wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
          ELSEIF wa_pro_date-DayName = 'Friday'.
            lv_proposed = datts + 18.
            wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
          ELSEIF wa_pro_date-DayName = 'Saturday'.
            lv_proposed = datts + 17.
            wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
          ELSEIF wa_pro_date-DayName = 'Sunday'.
            lv_proposed = datts + 16.
            wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
          ENDIF.
        ENDIF.
      ENDIF.



      IF wa_final-proposed_date IS NOT INITIAL AND wa_final-proposed_date <> '  -  -    '.  """"Payment Delay
        CONCATENATE wa_final-proposed_date+7(4)   " YYYY
                    wa_final-proposed_date+4(2)   " MM
                    wa_final-proposed_date+1(2)   " DD
        INTO lv_prop_d.
      ENDIF.

      IF wa_final-payment_date IS NOT INITIAL AND wa_final-payment_date <> '  -  -    '.
        CONCATENATE wa_final-payment_date+7(4)    " YYYY
                    wa_final-payment_date+4(2)    " MM
                    wa_final-payment_date+1(2)    " DD
        INTO lv_pay_d.
      ENDIF.

      IF lv_prop_d IS NOT INITIAL AND lv_pay_d IS NOT INITIAL.
        lv_delay_int = lv_prop_d - lv_pay_d.
        wa_final-Payment_Delay = lv_delay_int.
      ENDIF.

      CLEAR : lv_delay_int,lv_prop_d,lv_pay_d.

      IF wa_final-payment_date IS NOT INITIAL AND wa_final-payment_date <> '  -  -    '.   """""""""""days from invoice date
        CONCATENATE wa_final-payment_date+7(4)    " YYYY
                    wa_final-payment_date+4(2)    " MM
                    wa_final-payment_date+1(2)    " DD
        INTO lv_pay_d.
      ENDIF.
      IF wa_final-invdate IS NOT INITIAL AND wa_final-invdate <> '  -  -    '.
        CONCATENATE wa_final-invdate+7(4)   " YYYY
                    wa_final-invdate+4(2)   " MM
                    wa_final-invdate+1(2)   " DD
        INTO lv_prop_d.
      ENDIF.


      IF lv_prop_d IS NOT INITIAL AND lv_pay_d IS NOT INITIAL.
        lv_delay_int =  lv_pay_d - lv_prop_d .
        wa_final-days_from_invdate = lv_delay_int.
      ENDIF.
      CLEAR : lv_delay_int,lv_prop_d,lv_pay_d.


      IF wa_final-payment_date IS NOT INITIAL AND wa_final-payment_date <> '  -  -    '.    """""final approval payment days
        CONCATENATE wa_final-payment_date+7(4)    " YYYY
                    wa_final-payment_date+4(2)    " MM
                    wa_final-payment_date+1(2)    " DD
        INTO lv_pay_d.
      ENDIF.
      IF wa_final-paymentabs_2_date IS NOT INITIAL AND wa_final-paymentabs_2_date <> '  -  -    '.
        CONCATENATE wa_final-paymentabs_2_date+7(4)   " YYYY
                    wa_final-paymentabs_2_date+4(2)   " MM
                    wa_final-paymentabs_2_date+1(2)   " DD
        INTO lv_prop_d.
      elseif   wa_final-inv_1_date IS NOT INITIAL AND wa_final-inv_1_date <> '  -  -    '.
        CONCATENATE wa_final-inv_1_date+7(4)   " YYYY
                    wa_final-inv_1_date+4(2)   " MM
                    wa_final-inv_1_date+1(2)   " DD
        INTO lv_prop_d.
      ENDIF.

      IF lv_prop_d IS NOT INITIAL AND lv_pay_d IS NOT INITIAL.
        lv_delay_int =  lv_pay_d - lv_prop_d .
        wa_final-final_app_pay_day = lv_delay_int.
      ENDIF.

      IF wa_final-payment_date IS INITIAL.
        wa_final-payment_date = '00-00-0000'.
      ENDIF.


      READ TABLE it_po_reco into data(wa_po_reco) WITH KEY OriginalReferenceDocument = wa_invr-SupplierInvoice.
      READ TABLE it_po_rec_dat into data(wa_po_rec_dat) WITH KEY AccountingDocument = wa_po_reco-ClearingJournalEntry
                                                                 CompanyCode = wa_po_reco-CompanyCode
                                                                 FiscalYear = wa_po_reco-ClearingDocFiscalYear.
      READ TABLE it_po_rec_dat1 into data(wa_po_rec_dat1) WITH KEY ClearingJournalEntry = wa_po_rec_dat-ClearingJournalEntry
                                                                 CompanyCode = wa_po_rec_dat-CompanyCode
                                                                 FiscalYear = wa_po_rec_dat-ClearingDocFiscalYear.


        IF wa_final-proposed_date IS NOT INITIAL AND wa_final-proposed_date <> '  -  -    '.   """"Payment Delay
        CONCATENATE wa_final-proposed_date+7(4)   " YYYY
                    wa_final-proposed_date+4(2)   " MM
                    wa_final-proposed_date+1(2)   " DD
        INTO lv_pay_d.
      ENDIF.

    IF wa_po_rec_dat1-PostingDate IS NOT INITIAL .
      lv_prop_d = wa_po_rec_dat1-PostingDate.
      wa_final-rec_date = | { wa_po_rec_dat1-PostingDate+6(2) }-{ wa_po_rec_dat1-PostingDate+4(2) }-{ wa_po_rec_dat1-PostingDate+0(4) }|.

    ENDIF.
    IF lv_prop_d IS NOT INITIAL AND lv_pay_d IS NOT INITIAL.
      lv_delay_int =  lv_pay_d - lv_prop_d .
      wa_final-rec_day = lv_delay_int.
    ENDIF.

*    IF wa_final-payment_date  IS INITIAL.
*      wa_final-payment_date = '00-00-0000'.
*    ENDIF.
   CLEAR : lv_delay_int,lv_prop_d,lv_pay_d.


      APPEND wa_final TO it_final.
      CLEAR : wa_main,wa_final,wa_poapp,wa_s,wa_in,wa_payab,wa_radate,waa_inv,wa_invr,wa_payd,wa_pro_date,lv_delay_int,lv_pay_d,lv_prop_d,
      wa_adpay,wa_adpayy,adddatte,wa_payddd,wa_po_reco,wa_po_rec_dat,wa_po_rec_dat1,raad_paymat,
      wa_adra,dat.
    ENDLOOP.

    """""""""""""""""""""""""""Non-PO""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    SELECT FROM I_OperationalAcctgDocItem AS a
    INNER JOIN I_JournalEntry AS det ON det~AccountingDocument = a~AccountingDocument
                                    AND det~CompanyCode = a~CompanyCode
                                    AND det~FiscalYear = a~FiscalYear
    INNER JOIN I_CompanyCode AS b ON b~CompanyCode = a~CompanyCode
    INNER JOIN I_Supplier AS c ON c~Supplier = a~Supplier
    FIELDS
    a~AccountingDocument,
    a~CompanyCode,
    a~FiscalYear,
    a~Supplier,
    b~CompanyCodeName,
    c~SupplierName,
    a~DocumentDate,
    a~PostingDate,
    a~AmountInCompanyCodeCurrency,
    det~IsReversal,
    det~IsReversed,
    c~SupplierAccountGroup
    WHERE a~AccountingDocumentType = 'KR'
    AND a~CompanyCode = @comp
    AND a~Supplier IS NOT INITIAL
    AND a~DocumentDate BETWEEN @form_date AND @to_date
    INTO TABLE @DATA(it_nonpo).

    SORT it_nonpo BY AccountingDocument FiscalYear CompanyCode.
    DELETE  it_nonpo WHERE  IsReversal = 'X' OR IsReversed = 'X'.

   if it_nonpo is not INITIAL.
    SELECT FROM I_JournalEntry AS a
    FIELDS
    a~AccountingDocument,
    a~CompanyCode,
    a~FiscalYear,
    a~DocumentDate,
    DocumentReferenceID
    FOR ALL ENTRIES IN @it_nonpo
    WHERE a~CompanyCode = @comp
    AND a~FiscalYear = @it_nonpo-FiscalYear
    AND a~AccountingDocument = @it_nonpo-AccountingDocument
    INTO TABLE @DATA(it_invref).
endif.

    SORT it_nonpo BY AccountingDocument CompanyCode FiscalYear Supplier .
    DELETE ADJACENT DUPLICATES FROM it_nonpo COMPARING AccountingDocument CompanyCode FiscalYear Supplier.
   if it_nonpo is not INITIAL.
    SELECT FROM I_OperationalAcctgDocItem AS a
    FIELDS
    a~AccountingDocument,
    a~CompanyCode,
    a~FiscalYear,
    a~AmountInCompanyCodeCurrency
    FOR ALL ENTRIES IN @it_nonpo
    WHERE a~AccountingDocumentType = 'KR'
    AND a~CompanyCode = @comp
    AND a~FiscalYear = @it_nonpo-FiscalYear
    AND a~AccountingDocument = @it_nonpo-AccountingDocument
    AND a~AccountingDocumentItem = '002'
    INTO TABLE @DATA(it_basic).

    SELECT FROM I_OperationalAcctgDocItem AS a
    FIELDS
    a~AccountingDocument,
    a~AccountingDocumentItem,
    a~CompanyCode,
    a~FiscalYear,
    a~AmountInCompanyCodeCurrency
    FOR ALL ENTRIES IN @it_nonpo
    WHERE a~CompanyCode = @comp
    AND a~FiscalYear = @it_nonpo-FiscalYear
    AND a~AccountingDocument = @it_nonpo-AccountingDocument
    AND a~TransactionTypeDetermination IN ( 'JII' , 'JIC', 'JIS' )
    INTO TABLE @DATA(it_GST).

    SELECT FROM I_OperationalAcctgDocItem AS a
    FIELDS
    a~AccountingDocument,
    a~CompanyCode,
    a~FiscalYear,
    a~ClearingJournalEntry,
    a~ClearingJournalEntryFiscalYear
    FOR ALL ENTRIES IN @it_nonpo
    WHERE a~CompanyCode = @comp
    AND a~FiscalYear = @it_nonpo-FiscalYear
    AND a~AccountingDocument = @it_nonpo-AccountingDocument
    AND a~ClearingJournalEntry IS NOT INITIAL
    INTO TABLE @DATA(it_pay).
    endif.

    if it_pay is not INITIAL.
    SELECT FROM I_OperationalAcctgDocItem AS a
    FIELDS
    a~AccountingDocument,
    a~CompanyCode,
    a~FiscalYear,
    a~AmountInCompanyCodeCurrency,
    a~DocumentDate
    FOR ALL ENTRIES IN @it_pay
    WHERE a~CompanyCode = @comp
    AND a~FiscalYear = @it_pay-ClearingJournalEntryFiscalYear
    AND a~AccountingDocument = @it_pay-ClearingJournalEntry
    AND a~GLAccount LIKE '00127%'
    INTO TABLE @DATA(it_payamt).
    SELECT FROM I_OperationalAcctgDocItem AS a
    FIELDS
    a~AccountingDocument,
    a~CompanyCode,
    a~FiscalYear,
    a~AssignmentReference
    FOR ALL ENTRIES IN @it_pay
    WHERE a~CompanyCode = @comp
    AND a~FiscalYear = @it_pay-FiscalYear
    AND a~AccountingDocument = @it_pay-ClearingJournalEntry
    AND a~AssignmentReference IS NOT INITIAL
    INTO TABLE @DATA(it_payass).
    endif.

if it_nonpo is not INITIAL.
    SELECT  FROM I_OperationalAcctgDocItem
    FIELDS
    AccountingDocument,
    CompanyCode,
    FiscalYear,
    Reference1IDByBusinessPartner
    FOR ALL ENTRIES IN @it_nonpo
    WHERE CompanyCode = @comp
    AND FiscalYear = @it_nonpo-FiscalYear
    AND AccountingDocument = @it_nonpo-AccountingDocument
    AND Reference1IDByBusinessPartner IS NOT INITIAL
    INTO TABLE  @DATA(it_prodate).

*    SELECT  FROM zpayment_reco_date1
*    FIELDS
*    PostingDate,
*    ClearingJournalEntry,
*    FiscalYear,
*    AccountingDocument,
*    CompanyCode
*    FOR ALL ENTRIES IN @it_nonpo
*    WHERE AccountingDocument = @it_nonpo-AccountingDocument AND FiscalYear = @it_nonpo-FiscalYear
*    AND CompanyCode = @it_nonpo-CompanyCode
*    INTO TABLE @DATA(rec_dat).
endif.
*if rec_dat is not INITIAL.
*    SELECT  FROM I_OperationalAcctgDocItem
*    FIELDS
*    AccountingDocument,
*    CompanyCode,
*    FiscalYear,
*    PostingDate,
*    ClearingJournalEntry
*    FOR ALL ENTRIES IN @rec_dat
*    WHERE CompanyCode = @comp
*    AND FiscalYear = @rec_dat-FiscalYear
*    AND ClearingJournalEntry = @rec_dat-ClearingJournalEntry
*    AND AccountingDocumentType in ( 'ZR' , 'SA' )
*    AND GLAccount LIKE '00127%'
*    INTO TABLE  @DATA(it_rec_dat).
*endif.
    LOOP AT it_nonpo INTO DATA(wa_nonpo).
      wa_final-companycode = wa_nonpo-CompanyCode.
      wa_final-companyname = wa_nonpo-CompanyCodeName.
      wa_final-suppliername = wa_nonpo-SupplierName.
      wa_final-invno = wa_nonpo-AccountingDocument.
      wa_final-invdate = | { wa_nonpo-DocumentDate+6(2) }-{ wa_nonpo-DocumentDate+4(2) }-{ wa_nonpo-DocumentDate+0(4) }|.


      if wa_nonpo-SupplierAccountGroup <> 'Y003'.
       READ TABLE it_prodate INTO DATA(wa_pro2) WITH KEY  AccountingDocument = wa_nonpo-AccountingDocument
                                               FiscalYear = wa_nonpo-FiscalYear
                                               CompanyCode = wa_nonpo-CompanyCode.
       if sy-subrc = 0.
      wa_final-ses_grndate = | { wa_pro2-Reference1IDByBusinessPartner+0(2) }-{ wa_pro2-Reference1IDByBusinessPartner+2(2) }-{ wa_pro2-Reference1IDByBusinessPartner+4(4) }|.
*      wa_final-ses_grndate = wa_pro2-Reference1IDByBusinessPartner.
endif.
      ELSE.
      SELECT SINGLE from I_JournalEntryItem
      FIELDS
      CreationDate,
      AccountingDocument
      WHERE AccountingDocument = @wa_nonpo-AccountingDocument
      and CompanyCode = @wa_nonpo-CompanyCode
      and FiscalYear = @wa_nonpo-FiscalYear
      into @data(sfdc_sesdate).
      wa_final-ses_grndate = | { sfdc_sesdate-CreationDate+6(2) }-{ sfdc_sesdate-CreationDate+4(2) }-{ sfdc_sesdate-CreationDate+0(4) }|.
      ENDIF.
      wa_final-invamt = wa_nonpo-AmountInCompanyCodeCurrency.
      wa_final-ses_grnno = 'NA'.


      READ TABLE it_basic INTO DATA(wa_basic) WITH KEY AccountingDocument = wa_nonpo-AccountingDocument
                                                 FiscalYear = wa_nonpo-FiscalYear
                                                 CompanyCode = wa_nonpo-CompanyCode.
      wa_final-basicvalue = wa_basic-AmountInCompanyCodeCurrency.
      READ TABLE it_invref INTO DATA(wa_invreff) WITH KEY AccountingDocument = wa_nonpo-AccountingDocument
                                                 FiscalYear = wa_nonpo-FiscalYear
                                                 CompanyCode = wa_nonpo-CompanyCode.
      wa_final-invref = wa_invreff-DocumentReferenceID.
      wa_final-invdoc_date = | { wa_invreff-DocumentDate+6(2) }-{ wa_invreff-DocumentDate+4(2) }-{ wa_invreff-DocumentDate+0(4) }|.

      LOOP AT it_gst INTO DATA(wa_gst) WHERE AccountingDocument = wa_nonpo-AccountingDocument
                                               AND FiscalYear = wa_nonpo-FiscalYear
                                               AND CompanyCode = wa_nonpo-CompanyCode.
        wa_final-gst +=  wa_gst-AmountInCompanyCodeCurrency .
        CLEAR :wa_gst.
      ENDLOOP.
      wa_final-totvalue = wa_final-gst + wa_final-basicvalue.

      READ TABLE it_pay INTO DATA(wa_pay) WITH KEY AccountingDocument = wa_nonpo-AccountingDocument
                                                FiscalYear = wa_nonpo-FiscalYear
                                                CompanyCode = wa_nonpo-CompanyCode.
      READ TABLE it_payamt INTO DATA(wa_payamt) WITH KEY AccountingDocument = wa_pay-ClearingJournalEntry
                                                FiscalYear = wa_pay-ClearingJournalEntryFiscalYear
                                                CompanyCode = wa_pay-CompanyCode.
      wa_final-paymentamt =  wa_payamt-AmountInCompanyCodeCurrency.
      wa_final-payment_date = | { wa_payamt-DocumentDate+6(2) }-{ wa_payamt-DocumentDate+4(2) }-{ wa_payamt-DocumentDate+0(4) }|.
      IF wa_final-payment_date IS NOT INITIAL.
        wa_final-payment_ind = 'Open'.
      ENDIF.

      READ TABLE it_payass INTO DATA(wa_payass) WITH KEY AccountingDocument = wa_pay-ClearingJournalEntry
                                                FiscalYear = wa_pay-FiscalYear
                                                CompanyCode = wa_pay-CompanyCode.
      wa_final-utr =  wa_payass-AssignmentReference.
      CLEAR : lv_proposed,wa_pro_date.




      DATA: lv_ref  TYPE string,
            lv_dd   TYPE string,
            lv_mm   TYPE string,
            lv_yyyy TYPE string.
      DATA dd TYPE d.
      READ TABLE it_prodate INTO DATA(wa_pro) WITH KEY  AccountingDocument = wa_nonpo-AccountingDocument
                                               FiscalYear = wa_nonpo-FiscalYear
                                               CompanyCode = wa_nonpo-CompanyCode.
      IF sy-subrc = 0.

        lv_ref  = wa_pro-Reference1IDByBusinessPartner.
        REPLACE ALL OCCURRENCES OF '.' IN lv_ref WITH ''.



        " Input format: DDMMYYYY  e.g. 17052026
        lv_dd   = lv_ref+0(2).   " 17
        lv_mm   = lv_ref+2(2).   " 05
        lv_yyyy = lv_ref+4(4).   " 2026

        " Rearrange to YYYYMMDD → assign to TYPE d
        CONCATENATE lv_yyyy lv_mm lv_dd INTO dd.

      ENDIF.


      SELECT SINGLE FROM zdays_po_ageing
     FIELDS
     CalendarDate,
     CalendarDay,
     DayName,
     CalendarYear
     WHERE CalendarDate =    @dd  " @wa_pro-Reference1IDByBusinessPartner
     INTO  @wa_pro_date.


      IF wa_pro_date IS NOT INITIAL.

        IF wa_pro_date-DayName = 'Monday'.
          lv_proposed = dd + 15.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ELSEIF wa_pro_date-DayName = 'Tuesday'.
          lv_proposed = dd + 21.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ELSEIF wa_pro_date-DayName = 'Wednesday'.
          lv_proposed = dd + 20.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ELSEIF wa_pro_date-DayName = 'Thursday'.
          lv_proposed = dd + 19.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ELSEIF wa_pro_date-DayName = 'Friday'.
          lv_proposed = dd + 18.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ELSEIF wa_pro_date-DayName = 'Saturday'.
          lv_proposed = dd + 17.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ELSEIF wa_pro_date-DayName = 'Sunday'.
          lv_proposed = dd + 16.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ENDIF.
      ENDIF.

if wa_nonpo-SupplierAccountGroup =  'Y003'.
      SELECT SINGLE FROM zdays_po_ageing
     FIELDS
     CalendarDate,
     CalendarDay,
     DayName,
     CalendarYear
     WHERE CalendarDate =    @sfdc_sesdate-CreationDate  " @wa_pro-Reference1IDByBusinessPartner
     INTO  @wa_pro_date.


      IF wa_pro_date IS NOT INITIAL.

        IF wa_pro_date-DayName = 'Monday'.
          lv_proposed = sfdc_sesdate-CreationDate + 15.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ELSEIF wa_pro_date-DayName = 'Tuesday'.
          lv_proposed = sfdc_sesdate-CreationDate + 21.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ELSEIF wa_pro_date-DayName = 'Wednesday'.
          lv_proposed = sfdc_sesdate-CreationDate + 20.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ELSEIF wa_pro_date-DayName = 'Thursday'.
          lv_proposed = sfdc_sesdate-CreationDate + 19.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ELSEIF wa_pro_date-DayName = 'Friday'.
          lv_proposed = sfdc_sesdate-CreationDate + 18.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ELSEIF wa_pro_date-DayName = 'Saturday'.
          lv_proposed = sfdc_sesdate-CreationDate + 17.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ELSEIF wa_pro_date-DayName = 'Sunday'.
          lv_proposed = sfdc_sesdate-CreationDate + 16.
          wa_final-proposed_date = | { lv_proposed+6(2) }-{ lv_proposed+4(2) }-{ lv_proposed+0(4) }|.
        ENDIF.
      ENDIF.
      ENDIF.



      IF wa_final-proposed_date IS NOT INITIAL AND wa_final-proposed_date <> '  -  -    '.   """"Payment Delay
        CONCATENATE wa_final-proposed_date+7(4)   " YYYY
                    wa_final-proposed_date+4(2)   " MM
                    wa_final-proposed_date+1(2)   " DD
        INTO lv_prop_d.
      ENDIF.

      " Convert payment_date (DD-MM-YYYY) back to TYPE d
      IF wa_final-payment_date IS NOT INITIAL AND wa_final-payment_date <> '  -  -    '.
        CONCATENATE wa_final-payment_date+7(4)    " YYYY
                    wa_final-payment_date+4(2)    " MM
                    wa_final-payment_date+1(2)    " DD
        INTO lv_pay_d.
      ENDIF.

      """  days from invoice date
      IF lv_prop_d IS NOT INITIAL AND lv_pay_d IS NOT INITIAL.
        lv_delay_int = lv_prop_d - lv_pay_d.
        wa_final-Payment_Delay = lv_delay_int.
      ENDIF.

      CLEAR : lv_delay_int,lv_prop_d,lv_pay_d.



      IF wa_final-payment_date IS NOT INITIAL AND wa_final-payment_date <> '  -  -    '.    "  days from invoice date"""""
        CONCATENATE wa_final-payment_date+7(4)    " YYYY
                    wa_final-payment_date+4(2)    " MM
                    wa_final-payment_date+1(2)    " DD
        INTO lv_pay_d.
      ENDIF.
      IF wa_final-invdoc_date IS NOT INITIAL AND wa_final-invdoc_date <> '  -  -    '.
        CONCATENATE wa_final-invdoc_date+7(4)   " YYYY
                    wa_final-invdoc_date+4(2)   " MM
                    wa_final-invdoc_date+1(2)   " DD
        INTO lv_prop_d.
      ENDIF.

      IF lv_prop_d IS NOT INITIAL AND lv_pay_d IS NOT INITIAL.
        lv_delay_int =  lv_pay_d - lv_prop_d .
        wa_final-days_from_invdate = lv_delay_int.
      ENDIF.

      CLEAR : lv_delay_int,lv_prop_d,lv_pay_d.
*
*      READ TABLE rec_dat into data(wa_rec)  WITH KEY  AccountingDocument = wa_nonpo-AccountingDocument
*                                               FiscalYear = wa_nonpo-FiscalYear
*                                               CompanyCode = wa_nonpo-CompanyCode.
*      READ TABLE it_rec_dat into data(wa_rec1)  WITH KEY  ClearingJournalEntry = wa_rec-ClearingJournalEntry
*                                               FiscalYear = wa_rec-FiscalYear
*                                               CompanyCode = wa_rec-CompanyCode.

*      if wa_final-payment_date IS NOT INITIAL AND wa_final-payment_date <> '  -  -    '.  "  days from invoice date"""""
*      CONCATENATE wa_final-payment_date+7(4)    " YYYY
*                  wa_final-payment_date+4(2)    " MM
*                  wa_final-payment_date+1(2)    " DD
*      INTO lv_pay_d.
*    ENDIF.

        IF wa_final-proposed_date IS NOT INITIAL AND wa_final-proposed_date <> '  -  -    '.   """"Payment Delay
        CONCATENATE wa_final-proposed_date+7(4)   " YYYY
                    wa_final-proposed_date+4(2)   " MM
                    wa_final-proposed_date+1(2)   " DD
        INTO lv_pay_d.
      ENDIF.

*    IF wa_rec1-PostingDate IS NOT INITIAL .
*      lv_prop_d = wa_rec1-PostingDate.
*      wa_final-rec_date = | { wa_rec1-PostingDate+6(2) }-{ wa_rec1-PostingDate+4(2) }-{ wa_rec1-PostingDate+0(4) }|.
*
*    ENDIF.
    IF lv_prop_d IS NOT INITIAL AND lv_pay_d IS NOT INITIAL.
      lv_delay_int =  lv_pay_d - lv_prop_d .
      wa_final-rec_day = lv_delay_int.
    ENDIF.

    IF wa_final-payment_date  IS INITIAL.
      wa_final-payment_date = '00-00-0000'.
    ENDIF.
   CLEAR : lv_delay_int,lv_prop_d,lv_pay_d . ",wa_rec,wa_rec1.



    APPEND wa_final TO it_final.
    CLEAR : wa_final,wa_nonpo,wa_basic,wa_pay,wa_payamt,wa_payass,wa_pro_date,wa_pro,dd,lv_delay_int,lv_pay_d,lv_prop_d,sfdc_sesdate.
  ENDLOOP.









  io_response->set_total_number_of_records( lines( it_final ) ).
  io_response->set_data( it_final ).


ENDMETHOD.
ENDCLASS.
