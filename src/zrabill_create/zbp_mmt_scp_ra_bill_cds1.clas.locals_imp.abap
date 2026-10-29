CLASS lhc_scp_rabill DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zscp_rabill RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zscp_rabill.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zscp_rabill.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zscp_rabill.

    METHODS read FOR READ
      IMPORTING keys FOR READ zscp_rabill RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zscp_rabill.

ENDCLASS.

CLASS lhc_scp_rabill IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA : ls_rabill TYPE zmmt_scp_rabill1,
           msg       TYPE string,
           fromdate  TYPE zdats,
           todate    TYPE zdats,
           sydate    TYPE zdats,
           count     TYPE zrcount.

    DATA: lv_ebeln(10),
        lv_rabill(3),
        lv_ses TYPE string.

    TYPES: BEGIN OF ty_rabill_list,
             ra_bill_no TYPE string,
             gv_rabill  TYPE string,
             gv_adv     TYPE zchar1,
           END OF ty_rabill_list.

    DATA:        ist_rabill_list               TYPE STANDARD TABLE OF ty_rabill_list.

    DATA:year  TYPE n LENGTH 4,
         month TYPE n LENGTH 2,
         day   TYPE n LENGTH 2.

    DATA: w_date  TYPE c LENGTH 14,
          l_error TYPE zchar1.

    DATA:
      ls_header_data TYPE i_serviceentrysheettp_2,
      ls_item_data   TYPE i_serviceentrysheetitemtp_2,

      lt_header_crt  TYPE TABLE FOR CREATE i_serviceentrysheettp_2,
      lt_item_cba    TYPE TABLE FOR CREATE i_serviceentrysheettp_2\\serviceentrysheet\_serviceentrysheetitem.


    READ TABLE entities INTO DATA(ls_bill) INDEX 1.
    IF sy-subrc = 0.

      CONCATENATE ls_bill-RaBillFrom+6(4) ls_bill-RaBillFrom+0(2) ls_bill-RaBillFrom+3(2) INTO fromdate.
      CONCATENATE ls_bill-RaBillTo+6(4) ls_bill-RaBillTo+0(2) ls_bill-RaBillTo+3(2) INTO  todate.

      SELECT ra_bill_no, ebeln, ebelp, from_date, to_date
      FROM zmmt_scp_rabill1 WHERE ebeln = @ls_bill-ebeln
      INTO TABLE @DATA(lt_rabill).
      IF sy-subrc = 0.

        LOOP AT lt_rabill INTO DATA(wa_l).

          IF ( fromdate BETWEEN wa_l-from_date AND wa_l-to_date ) OR
                 ( todate BETWEEN wa_l-from_date AND wa_l-to_date ) .
            l_error = 'X'.
            CONCATENATE 'RaBill cannot be saved in the selected date range' '' INTO msg SEPARATED BY space.

            APPEND VALUE #( %key                = ls_bill-%key ) TO failed-zscp_rabill.
            APPEND VALUE #( %key               = ls_bill-%key
                            %state_area        = 'DATE'
                             %msg              = new_message_with_text(
                                                         text   = msg
                                                         severity = if_abap_behv_message=>severity-error )
                          %element-RaBillFrom = if_abap_behv=>mk-on ) TO reported-zscp_rabill.
          ENDIF.
        ENDLOOP.




      ENDIF.

    ENDIF.

    IF l_error IS INITIAL.
      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_ra_bill>).

        ls_rabill = CORRESPONDING #( <ls_ra_bill> MAPPING FROM ENTITY USING CONTROL ).
        CLEAR ls_rabill-ra_bill_no.
        SHIFT ls_rabill-rcount LEFT DELETING LEADING '0'.
        count = ls_rabill-rcount.
        ls_rabill-inv_date = <ls_ra_bill>-InvDate.
        ls_rabill-inv_num = <ls_ra_bill>-InvNum.
        CONCATENATE  ls_rabill-ebeln '/' count INTO ls_rabill-ra_bill_no.
        CONDENSE ls_rabill-ra_bill_no.

        sydate = xco_cp=>sy->date( xco_cp_time=>time_zone->user   )->as( xco_cp_time=>format->iso_8601_extended  )->value.


        CONCATENATE sydate+6(2) sydate+4(2) sydate+0(4) INTO ls_rabill-erdat SEPARATED BY '/'.

        CONCATENATE ls_rabill-ra_bill_from+6(4) ls_rabill-ra_bill_from+0(2) ls_rabill-ra_bill_from+3(2) INTO ls_rabill-from_date.
        CONCATENATE ls_rabill-ra_bill_to+6(4) ls_rabill-ra_bill_to+0(2) ls_rabill-ra_bill_to+3(2) INTO ls_rabill-to_date.


        MODIFY zmmt_scp_rabill1 FROM @ls_rabill.




      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD update.
    DATA : ls_rabill TYPE zmmt_scp_rabill1,
           msg       TYPE string.

    DATA:year  TYPE n LENGTH 4,
         month TYPE n LENGTH 2,
         day   TYPE n LENGTH 2.

    DATA: w_date TYPE c LENGTH 14.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_ra_bill>).
      ls_rabill = CORRESPONDING #( <ls_ra_bill> MAPPING FROM ENTITY USING CONTROL ).

      ls_rabill-ra_bill_no =  <ls_ra_bill>-rabillno.
      ls_rabill-ebeln =  <ls_ra_bill>-ebeln.
      ls_rabill-ebelp =  <ls_ra_bill>-ebelp.
      ls_rabill-inv_date = <ls_ra_bill>-InvDate.
      ls_rabill-inv_num = <ls_ra_bill>-InvNum.
*     CONCATENATE ls_rabill-ra_bill_from+6(4) ls_rabill-ra_bill_from+0(2) ls_rabill-ra_bill_from+3(2) INTO ls_rabill-from_date.
*      CONCATENATE ls_rabill-ra_bill_to+6(4) ls_rabill-ra_bill_to+0(2) ls_rabill-ra_bill_to+3(2) INTO ls_rabill-to_date.

*      day = ls_rabill-ra_bill_from+0(2).
*      month = ls_rabill-ra_bill_from+3(2).
*      year = ls_rabill-ra_bill_from+6(4).
*      w_date = |{ year }| && |{ month }| && |{ day }|.
*      CONDENSE w_date NO-GAPS.
*      ls_rabill-zdate = w_date.

      MODIFY zmmt_scp_rabill1 FROM @ls_rabill.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.

  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmmt_scp_ra_bill_cds1 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmmt_scp_ra_bill_cds1 IMPLEMENTATION.

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
