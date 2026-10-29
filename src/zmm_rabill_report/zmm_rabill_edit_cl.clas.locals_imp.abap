CLASS lhc_rabill_edit DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR rabill_edit RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE rabill_edit.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE rabill_edit.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE rabill_edit.

    METHODS read FOR READ
      IMPORTING keys FOR READ rabill_edit RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK rabill_edit.

ENDCLASS.

CLASS lhc_rabill_edit IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA : ls_rabill TYPE zmmt_scp_rabill1,
           msg       TYPE string,
           count     TYPE zchar5.

    DATA: lv_ebeln(10),
        lv_rabill(3),
        lv_ses TYPE string.
    DATA:
      ls_header_data TYPE i_serviceentrysheettp_2,
      ls_item_data   TYPE i_serviceentrysheetitemtp_2,

      lt_header_crt  TYPE TABLE FOR CREATE i_serviceentrysheettp_2\\serviceentrysheet,
      lt_item_cba    TYPE TABLE FOR CREATE i_serviceentrysheettp_2\\serviceentrysheet\_serviceentrysheetitem.

    data(sydatum1) = xco_cp=>sy->date( xco_cp_time=>time_zone->user )->as( xco_cp_time=>format->iso_8601_extended  )->value.
    data(syuzeit1) = xco_cp=>sy->time( xco_cp_time=>time_zone->user )->as( xco_cp_time=>format->iso_8601_extended  )->value.

    data sydatum type c LENGTH 8.
    data syuzeit type c LENGTH 8.

    CONCATENATE sydatum1+0(4) sydatum1+5(2) sydatum1+8(2) INTO sydatum.
    CONCATENATE syuzeit1+0(2) syuzeit1+3(2) syuzeit1+6(2) INTO syuzeit.


    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_ra_bill>).
      ls_rabill = CORRESPONDING #( <ls_ra_bill> MAPPING FROM ENTITY USING CONTROL ).
      CLEAR ls_rabill-ra_bill_no.
      count = ls_rabill-rcount.

        CONCATENATE ls_rabill-ra_bill_from+6(4) ls_rabill-ra_bill_from+0(2) ls_rabill-ra_bill_from+3(2) INTO ls_rabill-from_date.
        CONCATENATE ls_rabill-ra_bill_to+6(4) ls_rabill-ra_bill_to+0(2) ls_rabill-ra_bill_to+3(2) INTO ls_rabill-to_date.

      SELECT SINGLE RaBillNo,ebeln FROM zmm_rabill_fetch
      WHERE ebeln = @ls_rabill-ebeln
      AND rcount = @ls_rabill-rcount
      AND ebelp = @ls_rabill-ebelp
      INTO  @DATA(l_rabill).

      CONCATENATE  ls_rabill-ebeln '/' count INTO ls_rabill-ra_bill_no.
      CONDENSE ls_rabill-ra_bill_no.

      ls_rabill-inv_date = <ls_ra_bill>-InvDate.
      ls_rabill-inv_num = <ls_ra_bill>-InvNum.
      ls_rabill-from_date = ls_rabill-from_date.
      ls_rabill-to_date = ls_rabill-to_date.

      CONCATENATE sydatum+6(2) sydatum+4(2) sydatum+0(4) INTO ls_rabill-erdat SEPARATED BY '/'.
      MODIFY zmmt_scp_rabill1 FROM @ls_rabill.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.

    DATA: ls_rabill      TYPE zmmt_scp_rabill1,
          ls_header_data TYPE i_serviceentrysheettp_2,
          ls_item_data   TYPE i_serviceentrysheetitemtp_2,

          lt_header_crt  TYPE TABLE FOR CREATE i_serviceentrysheettp_2\\serviceentrysheet,
          lt_item_cba    TYPE TABLE FOR CREATE i_serviceentrysheettp_2\\serviceentrysheet\_serviceentrysheetitem.


    DATA: lv_count    TYPE zchar5,
          msg         TYPE string,
          l_error     TYPE zchar1.
    DATA: lo_message TYPE REF TO if_message.


    data(sydatum1) = xco_cp=>sy->date( xco_cp_time=>time_zone->user )->as( xco_cp_time=>format->iso_8601_extended  )->value.
    data(syuzeit1) = xco_cp=>sy->time( xco_cp_time=>time_zone->user )->as( xco_cp_time=>format->iso_8601_extended  )->value.

    data sydatum type c LENGTH 8.
    data syuzeit type c LENGTH 8.

    CONCATENATE sydatum1+0(4) sydatum1+5(2) sydatum1+8(2) INTO sydatum.
    CONCATENATE syuzeit1+0(2) syuzeit1+3(2) syuzeit1+6(2) INTO syuzeit.

    LOOP AT entities INTO DATA(ls_ra_bill).
*      ls_rabill = CORRESPONDING #( ls_ra_bill MAPPING FROM ENTITY USING CONTROL ).
      ls_rabill-ebeln = ls_ra_bill-ebeln.
      ls_rabill-ebelp = ls_ra_bill-ebelp.
      ls_rabill-ra_bill_no = ls_ra_bill-rabillno.
      ls_rabill-ra_bill_from = ls_ra_bill-rabillfrom.
      ls_rabill-ra_bill_to = ls_ra_bill-rabillto.
      ls_rabill-rcount = ls_ra_bill-rcount.
      ls_rabill-hold_qty = ls_ra_bill-holdqty.
      ls_rabill-amt_deduct = ls_ra_bill-amtdeduct.
      ls_rabill-prev_hold = ls_ra_bill-prevhold.
      ls_rabill-qty_deduct = ls_ra_bill-qtydeduct.
      ls_rabill-qty_deduct_utd = ls_ra_bill-qtydeductutd.
      ls_rabill-qty_reduced_reco = ls_ra_bill-qtyreducedreco.
      ls_rabill-rate = ls_ra_bill-rate.
      ls_rabill-rel_hold_qty = ls_ra_bill-relholdqty.
      ls_rabill-remarks = ls_ra_bill-remarks.
      ls_rabill-this_act = ls_ra_bill-thisact.
      ls_rabill-this_bill = ls_ra_bill-thisbill.
      ls_rabill-this_bill_amt = ls_ra_bill-thisbillamt.
      ls_rabill-this_bill_d = ls_ra_bill-thisbilld.
      ls_rabill-total_hold = ls_ra_bill-totalhold.
      ls_rabill-uom = ls_ra_bill-uom.
      ls_rabill-upto_date_amt = ls_ra_bill-uptodateamt.
      ls_rabill-upto_prev_amt = ls_ra_bill-uptoprevamt.
      ls_rabill-zcurr = 'INR'.
    ENDLOOP.


    """""""""""""""""add new   add 01.10.2026

*    DATA lv_from_date TYPE d.
*    DATA lv_to_date   TYPE d.
*    data : it_up type TABLE of zcopmaterial_ded,
*           wa_up type zcopmaterial_ded.
*
*lv_from_date =
*    |{ ls_ra_bill-rabillfrom+6(4) }|
*  && |{ ls_ra_bill-rabillfrom+0(2) }|
*  && |{ ls_ra_bill-rabillfrom+3(2) }|.
*
*lv_to_date =
*    |{ ls_ra_bill-RaBillTo+6(4) }|
*  && |{ ls_ra_bill-RaBillTo+0(2) }|
*  && |{ ls_ra_bill-RaBillTo+3(2) }|.
*    SELECT single from I_PurchaseOrderAPI01 as a
*    inner join I_PurchaseOrderItemAPI01 as b on b~PurchaseOrder = a~PurchaseOrder
*    FIELDS
*    a~PurchaseOrder,
*    a~Supplier,
*    b~Plant
*    WHERE a~PurchaseOrder = @ls_ra_bill-Ebeln
*    into @data(check_data).
*    SELECT  from ZMATERIAL_DED
*        FIELDS
*        mat_amount
*        WHERE Plant = @check_data-Plant
*        and  Supplier = @check_data-Supplier
*        and PostingDate BETWEEN @lv_from_date and @lv_to_date
*        into TABLE @data(mat_data).
*
*    loop at mat_data into data(wa_mat).
*        wa_up-amount = wa_up-amount + wa_mat-mat_amount.
*        endloop.
*        wa_up-ra_bill_no = ls_ra_bill-RaBillNo.
*        wa_up-des = 'Material Deduction'.
*        MODIFY zcopmaterial_ded FROM @wa_up.
*"""""""""""""""""END    add 01.10.2026






    IF  ls_rabill IS NOT INITIAL.

      SELECT * FROM zmm_rabill_fetch
      WHERE ebeln = @ls_rabill-ebeln
      AND rcount = @ls_rabill-rcount
      AND thisact <> ''
      INTO TABLE @DATA(lt_rabill).
      IF lt_rabill IS NOT INITIAL.

        READ TABLE lt_rabill INTO DATA(l_rbill) INDEX 1.
        IF sy-subrc = 0.
          CONCATENATE l_rbill-ebeln l_rbill-rcount INTO ls_header_data-serviceentrysheetname SEPARATED BY '/'.
          ls_header_data-purchaseorder          = l_rbill-ebeln.
          ls_header_data-sesoriginobjecttype    = `EX`.
          ls_header_data-postingdate    = sydatum.
          CONCATENATE l_rbill-inv_date+6(4) l_rbill-inv_date+0(2) l_rbill-inv_date+3(2)  INTO ls_header_data-postingdate.
        ENDIF.

        APPEND INITIAL LINE TO lt_header_crt ASSIGNING FIELD-SYMBOL(<ls_hdr_crt>).
        <ls_hdr_crt> = CORRESPONDING #( ls_header_data CHANGING CONTROL ).
        <ls_hdr_crt>-%cid     = `HEADER_1` .

        APPEND INITIAL LINE TO lt_item_cba ASSIGNING FIELD-SYMBOL(<ls_itm_cba>).
        <ls_itm_cba>-%cid_ref = 'HEADER_1'.

        CLEAR lv_count.
        LOOP AT lt_rabill INTO DATA(w_rbill).
*--- Prepare Item Data
          lv_count = lv_count + 1.

          ls_item_data-purchaseorderitem              = w_rbill-ebelp.
          ls_item_data-confirmedquantity              = w_rbill-thisact.
          ls_item_data-accountassignmentcategory      = w_rbill-accountassignmentcategory.
          CONCATENATE w_rbill-rabillfrom+6(4) w_rbill-rabillfrom+0(2) w_rbill-rabillfrom+3(2)  INTO ls_item_data-serviceperformancedate.
          CONCATENATE w_rbill-rabillfrom+6(4) w_rbill-rabillfrom+0(2) w_rbill-rabillfrom+3(2)  INTO ls_item_data-PerformancePeriodStartDate.
*          ls_item_data-serviceperformancedate         = w_rbill-rabillfrom.
          CONCATENATE w_rbill-rabillto+6(4)  w_rbill-rabillto+0(2) w_rbill-rabillto+3(2) INTO ls_item_data-serviceperformanceenddate.
          CONCATENATE w_rbill-rabillto+6(4)  w_rbill-rabillto+0(2) w_rbill-rabillto+3(2) INTO ls_item_data-PerformancePeriodEndDate.
*          ls_item_data-serviceperformanceenddate      = w_rbill-rabillto.
          ls_item_data-serviceentrysheetitemdesc      = w_rbill-purchaseorderitemtext.
          ls_item_data-quantityunit                   = w_rbill-purchaseorderquantityunit.
          ls_item_data-orderpriceunit                 = w_rbill-purchaseorderquantityunit.
          ls_item_data-orderpriceunittoorderunitnmrtr  = w_rbill-orderpriceunittoorderunitnmrtr.
          ls_item_data-ordpriceunittoorderunitdnmntr   = w_rbill-ordpriceunittoorderunitdnmntr.
          ls_item_data-netpricequantity                = w_rbill-netpricequantity.
          ls_item_data-qtyinpurchaseorderpriceunit     = w_rbill-thisact.
          ls_item_data-currency                        = 'INR'.
          ls_item_data-netpriceamount                  = w_rbill-netpriceamount.
          ls_item_data-materialgroup                   = w_rbill-materialgroup.

          ls_item_data-originobject = w_rbill-rcount.
*ls_item_data- = sy-datum.

          CONDENSE lv_count.
          APPEND INITIAL LINE TO <ls_itm_cba>-%target ASSIGNING FIELD-SYMBOL(<item_data>).
          <item_data>       = CORRESPONDING #( ls_item_data CHANGING CONTROL ).
          CONCATENATE 'Item_' lv_count INTO       <item_data>-%cid.

          CLEAR ls_item_data.

        ENDLOOP.

        MODIFY ENTITIES OF i_serviceentrysheettp_2
          ENTITY serviceentrysheet
            CREATE
              FROM lt_header_crt
             CREATE BY \_serviceentrysheetitem
              FROM  lt_item_cba
          FAILED DATA(ls_failed_crt)
          REPORTED DATA(ls_reported_crt)
          MAPPED DATA(ls_mapped_crt).

      "" Error handling --
       IF ls_reported_crt IS NOT INITIAL.
            lo_message = ls_reported_crt-serviceentrysheetitem[ 1 ]-%msg.
            "Error handling
          ENDIF.

"""" Error Handling -  added on 11.03.25 """"""""""""""""
        " Check for errors in reported structure
        IF ls_reported_crt IS NOT INITIAL.
          " Access messages for the root entity
          DATA(lt_serviceentrysheet) = ls_reported_crt-serviceentrysheet.

          " Loop through messages
          LOOP AT lt_serviceentrysheet ASSIGNING FIELD-SYMBOL(<fs_serviceentrysheet>).
            " Access individual message components
            DATA(lv_message_id) = <fs_serviceentrysheet>-%msg->if_t100_message~t100key-msgid.
            DATA(lv_message_number) = <fs_serviceentrysheet>-%msg->if_t100_message~t100key-msgno.
            DATA(lv_message_text)   = <fs_serviceentrysheet>-%msg->if_message~get_text( ).
            DATA(lv_message_type)   = <fs_serviceentrysheet>-%msg->if_t100_dyn_msg~msgty .


            " Handle different message types
            CASE lv_message_type.
              WHEN 'E'. " Error
                " Add to error log or raise exception
                CONCATENATE  lv_message_text lv_message_id lv_message_number
                INTO  DATA(msg_ses) SEPARATED BY ' ' .

*                lo_message = <fs_serviceentrysheet>-%msg .

                APPEND VALUE #( %key                = ls_ra_bill-%key ) TO failed-rabill_edit .
                APPEND VALUE #( %key                = ls_ra_bill-%key
                                %state_area        = 'Error'
                                 %msg              = new_message_with_text(
                                                             text   = msg_ses
                                                             severity = if_abap_behv_message=>severity-error )
                              %element-rabillno = if_abap_behv=>mk-on ) TO reported-rabill_edit .


                EXIT .

*          WHEN 'W'. " Warning
*            " Log warning message
*            MESSAGE <fs_message>-%msg TYPE 'W'.
*
*          WHEN 'I'. " Information
*            " Log info message
*            MESSAGE <fs_message>-%msg TYPE 'I'.
            ENDCASE.
          ENDLOOP.

          IF lo_message IS INITIAL .

            " Check for messages in child entities if needed
            IF ls_reported_crt-serviceentrysheetitem IS NOT INITIAL.

              " Handle item-level messages similarly
              LOOP AT ls_reported_crt-serviceentrysheetitem ASSIGNING FIELD-SYMBOL(<fs_serviceentrysheetitem>).

                DATA(lv_message_id2) = <fs_serviceentrysheetitem>-%msg->if_t100_message~t100key-msgid.
                DATA(lv_message_number2) = <fs_serviceentrysheetitem>-%msg->if_t100_message~t100key-msgno.
                DATA(lv_message_text2)   = <fs_serviceentrysheetitem>-%msg->if_message~get_text( ).
                DATA(lv_message_type2)   = <fs_serviceentrysheetitem>-%msg->if_t100_dyn_msg~msgty .


                " Handle different message types
                CASE lv_message_type2.
                  WHEN 'E'. " Error

                    " Process item-level messages
*                    lo_message = <fs_serviceentrysheetitem>-%msg .
                    CONCATENATE  lv_message_text2 lv_message_id2 lv_message_number2
              INTO  DATA(msg_ses2) SEPARATED BY ' ' .

*                    lo_message = <fs_serviceentrysheet>-%msg .

                    APPEND VALUE #( %key                = ls_ra_bill-%key ) TO failed-rabill_edit .
                    APPEND VALUE #( %key                = ls_ra_bill-%key
                                    %state_area        = 'Error'
                                     %msg              = new_message_with_text(
                                                                 text   = msg_ses2
                                                                 severity = if_abap_behv_message=>severity-error )
                                  %element-rabillno = if_abap_behv=>mk-on ) TO reported-rabill_edit .


                    EXIT.
*          DATA(lv_item_message) = <fs_item_message>-%msg->if_message~get_text( ).

                ENDCASE. .
              ENDLOOP.
            ENDIF.
          ENDIF.
        ENDIF.

"""" End:Error Handling -  added on 11.03.25 """"""""""""""""



**        IF   lo_message is NOT INITIAL .
**          CLEAR msg.
**  ""        CONCATENATE lo_message '' INTO msg SEPARATED BY space.
**          msg = lo_message.
**          APPEND VALUE #( %key               = <ls_logbook>-%key ) TO failed-zsd_logbook_un.
**          APPEND VALUE #( %key               = <ls_logbook>-%key
**                          %state_area        = 'END_HRS'
**                           %msg              = new_message_with_text(
**                                                       text   = msg
**                                                       severity = if_abap_behv_message=>severity-error )
**                        %element-breakhr = if_abap_behv=>mk-on ) TO reported-zsd_logbook_un.
**          l_error = 'X'.
**        ENDIF.


        "-- Commit and get the SES number
*    COMMIT ENTITIES
*      BEGIN RESPONSE OF I_ServiceEntrySheetTP_2
*      REPORTED DATA(reported_late)
*      FAILED DATA(failed_late).

*    LOOP AT ls_mapped_crt-serviceentrysheet ASSIGNING FIELD-SYMBOL(<mapped>).
*      CONVERT KEY OF I_ServiceEntrySheetTP_2 FROM <mapped>-%pid TO DATA(lv_ses).
*      <mapped>-ServiceEntrySheet = lv_ses.
*    ENDLOOP.

*    COMMIT ENTITIES END.

      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmm_rabill_edit DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmm_rabill_edit IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
