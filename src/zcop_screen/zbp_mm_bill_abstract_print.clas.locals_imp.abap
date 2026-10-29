CLASS lhc_buffer DEFINITION.
* 1) define the data buffer
  PUBLIC SECTION.

    TYPES: BEGIN OF ty_buffer,
             rabillno     TYPE zmm_bill_abs_h-ra_bill_no,
             file_content TYPE zmm_bill_abs_h-file_contents,
           END OF ty_buffer.

    TYPES tt_posting TYPE TABLE OF ty_buffer.
    CLASS-DATA mt_buffer TYPE tt_posting.

ENDCLASS.


CLASS lhc_ZMM_BILL_ABSTRACT_PRINT DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR zmm_bill_abstract_print RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR zmm_bill_abstract_print RESULT result.

    METHODS create FOR MODIFY
       entities FOR CREATE zmm_bill_abstract_print.

    METHODS update FOR MODIFY
       entities FOR UPDATE zmm_bill_abstract_print.

    METHODS delete FOR MODIFY
       keys FOR DELETE zmm_bill_abstract_print.

    METHODS read FOR READ
       keys FOR READ zmm_bill_abstract_print RESULT result.

    METHODS lock FOR LOCK
       keys FOR LOCK zmm_bill_abstract_print.

ENDCLASS.

CLASS lhc_ZMM_BILL_ABSTRACT_PRINT IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.


   DATA: ls_rabill_abst_h TYPE zmmt_scp_pa_h1,"zmm_bill_abs_h,
          ls_rabillmas_i   TYPE zmmt_scp_ra_payi,
          msg              TYPE string,
          lv_xml           TYPE string,
          template         TYPE string,
          result12         TYPE xstring,
          result           TYPE string.

*           DATA it_data  TYPE  TABLE OF zmm_bill_abstract_print .
 loop at entities ASSIGNING FIELD-SYMBOL(<ls_entities>).
SELECT SINGLE zplant_name ,
              zsupplier_name , ebeln ,
              state_name , pan , gstin ,
              ra_bill_no , ra_bill_from ,
              ra_bill_to , vendor_invoice , bill_date from zmmt_scp_pa_h1 where ra_bill_no eq @<ls_entities>-Rabillno INTO @data(ls_bill_header).
 SELECT * from zmmt_scp_ra_payi WHERE  ra_bill_no eq @<ls_entities>-Rabillno INTO TABLE @data(it_item).
 endloop.
Select single COMPANYCODE from I_PURCHASEORDERAPI01 where PURCHASEORDER = @ls_bill_header-ebeln into @data(lv_ccode) .
select single COMPANYCODENAME from I_COMPANYCODE  where COMPANYCODE eq @lv_ccode  into @DATA(lv_ccadr).

lv_xml = |<form1>| &&
|<Table1>| &&
|<HeaderRow>| &&
|<Cell2>| && lv_ccadr   && |</Cell2>| &&
|</HeaderRow>| &&
|<Row1>| &&
|<Cell2>| && ls_bill_header-zplant_name  && |</Cell2>| &&
|</Row1>| &&
|<Row3>| &&
|<Cell2>| && ls_bill_header-zsupplier_name && |</Cell2>| &&
|</Row3>| &&
|</Table1>| &&
|<Table2>| &&
|<HeaderRow>| &&
|<Cell2>| && ls_bill_header-ebeln && |</Cell2>| &&
|<Cell4>| && ls_bill_header-state_name && |</Cell4>| &&
|</HeaderRow>| &&
|<Row1>| &&
|<Cell2>| && ls_bill_header-pan && |</Cell2>| &&
|<Cell4>| && ls_bill_header-gstin && |</Cell4>| &&
|</Row1>| &&
|<Row2>| &&
|<Cell2>| && ls_bill_header-ra_bill_no && |</Cell2>| &&
|<Cell4>| && ls_bill_header-ra_bill_from && ' ' && ls_bill_header-ra_bill_to &&  |</Cell4>| &&
|</Row2>| &&
|<Row3>| &&
*|<Cell2>| && wa_inv-inv_no && |</Cell2>| &&
*|<Cell4>| && wa_inv-inv_date && |</Cell4>| &&
|<Cell2>| && ls_bill_header-vendor_invoice && |</Cell2>| &&
|<Cell4>| && ls_bill_header-bill_date && |</Cell4>| &&
|</Row3>| &&
|</Table2>| &&
|<Table3>| &&
|<HeaderRow/>| .
data : uptodate type c LENGTH 20.
data : uptolast type c LENGTH 20.
data : thisbill type c LENGTH 20.
clear : uptodate, uptolast, thisbill.
loop at it_item INTO data(ls_item).
uptodate = ls_item-uptodate.
uptolast = ls_item-uptolast.
thisbill = ls_item-thisbill.

if ls_item-sr_no_c EQ 'A' OR ls_item-sr_no_c EQ 'B' OR ls_item-sr_no_c EQ 'C'
OR ls_item-sr_no_c EQ 'D' OR ls_item-sr_no_c EQ 'E' .
*OR ls_item-sr_no_c EQ ' ' .
uptodate = ''.
uptolast = ''.
thisbill = ''.
else.
endif.

*if ls_item-description EQ 'Total Deduction (D)                               ' OR
*ls_item-description EQ 'Amount Payable  (A+B-C-D)                         ' .
*uptodate = ls_item-uptodate.
*uptolast = ls_item-uptolast.
*thisbill = ls_item-thisbill.
*endif.

lv_xml =  lv_xml && |<Row1>| &&
|<Cell1>| && ls_item-sr_no_c && |</Cell1>| &&
|<Cell2>| && ls_item-description && |</Cell2>| &&
|<Cell3>| && ls_item-tax_per && |</Cell3>| &&
 |<Cell4>| && uptodate && |</Cell4>| &&
 |<Cell5>| && uptolast && |</Cell5>| &&
 |<Cell6>| && thisbill && |</Cell6>| &&
* |<Cell4>| && ls_item-uptodate && |</Cell4>| &&
* |<Cell5>| && ls_item-uptolast && |</Cell5>| &&
* |<Cell6>| && ls_item-thisbill && |</Cell6>| &&
|</Row1>| .
ENDLOOP.
lv_xml =  lv_xml &&
|</Table3>| &&
|</form1>| .

* template = 'BILLABSTRACT/BILLABSTRACT'.
*    CALL METHOD zmm_adobe_print1=>getpdf(
*      EXPORTING
*        xmldata  = lv_xml
*        template = template
*      RECEIVING
*        result   = result12 ).
*
*    IF  result12 IS NOT INITIAL.
*      result = result12.
*
*      INSERT VALUE #( rabillno = ls_bill_header-ra_bill_no
*      file_content = result ) "ls_bill_header-file_contents )
*      INTO TABLE lhc_buffer=>mt_buffer.

*    ENDIF.
  REPLACE ALL OCCURRENCES OF '&' IN lv_xml WITH '&amp;'.

REPLACE ALL OCCURRENCES OF 'Ø' IN lv_xml WITH ' '.
*&---------------------------------------------------------------------*
*&  10. Render
*&---------------------------------------------------------------------*
    DATA pdf TYPE xstring.


*     template = 'BILLABSTRACT/BILLABSTRACT'.
*    CALL METHOD zmm_adobe_print1=>getpdf(
*      EXPORTING
*        xmldata  = lv_xml
*        template = template
*      RECEIVING
*        result   = result12 ).
*
*    IF  result12 IS NOT INITIAL.
*      result = result12.
*
*      INSERT VALUE #( rabillno = ls_bill_header-ra_bill_no
*      file_content = result ) "ls_bill_header-file_contents )
*      INTO TABLE lhc_buffer=>mt_buffer.
*
*    ENDIF.


    TRY.
        DATA(form) = cl_fp_form_reader=>create_form_reader( CONV #( |ZCOP| ) ).

        cl_fp_ads_util=>render_pdf(
          EXPORTING
            iv_locale     = 'en_US'
            iv_xdp_layout = form->get_layout( )
            iv_xml_data   = xco_cp=>string( cl_web_http_utility=>encode_base64( lv_xml )
                            )->as_xstring( xco_cp_binary=>text_encoding->base64 )->value
            is_options    = VALUE #(
*                             0 - errors only, for production
*                             4 - full trace, for development
                              trace_level = 0
                              embed_fonts = form->get_font_embed( ) )
          IMPORTING
            ev_pdf          = pdf
            ev_trace_string = DATA(logs) ).

      CATCH cx_fp_ads_util cx_fp_form_reader.
*       returning a row with an empty PDF would let the app offer it
*       as a valid download
        CLEAR pdf.
    ENDTRY.

*   DATA it_data  TYPE  TABLE OF zmm_bill_abstract_print .
*    IF pdf IS NOT INITIAL.
*      it_data = VALUE #( ( Rabillno = <ls_entities>-Rabillno
*                           ebeln      = <ls_entities>-Ebeln
*                           Plant  = <ls_entities>-Plant
*                           PostingDate     = <ls_entities>-PostingDate
**                           file_contents       = |DFR_{ lv_contract ALPHA = OUT }.PDF|
*                           Mimetype       = 'application/pdf'
*                           AdobeString           = pdf ) ).
*    ENDIF.

    IF  pdf IS NOT INITIAL.
      result = result12.

      INSERT VALUE #( rabillno = ls_bill_header-ra_bill_no
      file_content = pdf ) "ls_bill_header-file_contents )
      INTO TABLE lhc_buffer=>mt_buffer.

    ENDIF.


  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZMM_BILL_ABSTRACT_PRINT DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZMM_BILL_ABSTRACT_PRINT IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.


  tYPES: BEGIN OF ty_buffer,
             rabillno     TYPE zmm_bill_abs_h-ra_bill_no,
             file_content TYPE zmm_bill_abs_h-file_contents,
           END OF ty_buffer.

    TYPES tt_posting TYPE STANDARD TABLE OF ty_buffer.

    DATA: lt_data TYPE TABLE OF ty_buffer.
    DATA: wa_buffer LIKE LINE OF lt_data,
          ls_header TYPE zmm_bill_abs_h.

          lt_data = lhc_buffer=>mt_buffer.

    READ TABLE lt_data INTO DATA(wa_data) INDEX 1.
    IF sy-subrc EQ 0.
      wa_buffer-rabillno = wa_data-rabillno.
      wa_buffer-file_content = wa_data-file_content.
    ENDIF.

*     SELECT SINGLE ra_bill_no, ebeln, gl_acc, hbkid, hktid, vendor_invoice, bill_date, post_date, wekrs, zplant_name, ra_bill_from,
*      ra_bill_to, lifnr, zsupplier_name, region, state_name, pan, gstin, bupla, rcount, hd_text, billtype, bukrs, appr5, file_contents,
*      created_by, created_at, last_changed_by, last_changed_at FROM zmm_bill_abs_h WHERE ra_bill_no = @wa_buffer-rabillno
*    INTO @DATA(ls_bill_header).
SELECT SINGLE * from zmmt_scp_pa_h1 WHERE ra_bill_no = @wa_buffer-rabillno INTO @data(WA_bill_header) .
    MOVE-CORRESPONDING WA_bill_header TO ls_header.
    ls_header-file_contents = wa_buffer-file_content.
    MODIFY zmm_bill_abs_h FROM @ls_header.

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
