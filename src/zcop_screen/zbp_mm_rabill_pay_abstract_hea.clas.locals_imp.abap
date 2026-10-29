CLASS lhc_buffer DEFINITION.
* 1) define the data buffer
  PUBLIC SECTION.

    TYPES: BEGIN OF ty_buffer,
             rabillno TYPE zmmt_scp_pa_h1-ra_bill_no,
             flag     TYPE c LENGTH 1,
           END OF ty_buffer.

    TYPES tt_posting TYPE TABLE OF ty_buffer.
    CLASS-DATA mt_buffer TYPE tt_posting.

ENDCLASS.

CLASS lhc_zmm_rabill_pay_abstract_he DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmm_payabstract RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zmm_payabstract.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zmm_payabstract.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zmm_payabstract.

    METHODS read FOR READ
      IMPORTING keys FOR READ zmm_payabstract RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zmm_payabstract.

ENDCLASS.

CLASS lhc_zmm_rabill_pay_abstract_he IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.

    DATA:ls_rabill_abst_h  TYPE zmmt_scp_pa_h1,
         ls_rabill_abst_h1 TYPE zmmt_scp_pa_h1,
         ls_rabill_abst_i  TYPE zmmt_scp_pa1,
         ls_rabillmas_i    TYPE zmmt_scp_ra_payi,
         msg               TYPE string.

    DATA:year  TYPE n LENGTH 4,
         month TYPE n LENGTH 2,
         day   TYPE n LENGTH 2.

    DATA:  lv_date TYPE c LENGTH 10.
    DATA:  w_date TYPE c LENGTH 14.

    DATA: lv_flag TYPE c LENGTH 1.

    DATA:it_aprl TYPE TABLE OF zmmt_scp_pa_aprl,
         wa_aprl TYPE zmmt_scp_pa_aprl.

    DATA: wa_syname TYPE sy-uname,
          lv_poval  TYPE zchar5,
          lv_ct     TYPE zmmt_scp_pa_aprl-app_level.

    DATA : lv_r     TYPE c LENGTH 1.

    DATA(sydatum1) = xco_cp=>sy->date( xco_cp_time=>time_zone->user )->as( xco_cp_time=>format->iso_8601_extended  )->value.
    DATA(syuzeit1) = xco_cp=>sy->time( xco_cp_time=>time_zone->user )->as( xco_cp_time=>format->iso_8601_extended  )->value.

    DATA sydatum TYPE c LENGTH 8.
    DATA syuzeit TYPE c LENGTH 8.

    CONCATENATE sydatum1+0(4) sydatum1+5(2) sydatum1+8(2) INTO sydatum.
    CONCATENATE syuzeit1+0(2) syuzeit1+3(2) syuzeit1+6(2) INTO syuzeit.


    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_rabill_abst_h>).

      lv_flag = <ls_rabill_abst_h>-flag.
      ls_rabill_abst_h-ra_bill_no = <ls_rabill_abst_h>-rabillno.
      lv_poval = ls_rabill_abst_h-ra_bill_no+0(5).

      IF  lv_poval CA '/'.
        lv_r = ls_rabill_abst_h-ra_bill_no+0(1).
        SPLIT ls_rabill_abst_h-ra_bill_no AT '/' INTO DATA(l_blnk) DATA(l_ponum).
      ELSE.
        lv_r = '0'.
      ENDIF.

      wa_syname = sy-uname.
      IF lv_flag = 'A' OR lv_flag = 'R'.
        SELECT SINGLE ra_bill_no,app_level FROM zmmt_scp_pa_aprl "#EC WARNOK
        WHERE user_name  = @wa_syname  "@sy-uname
        AND appr_status = 'INPROCESS'
        AND ra_bill_no = @ls_rabill_abst_h-ra_bill_no
        INTO  @DATA(wa_approver_d).                     "#EC CI_NOORDER
        IF lv_flag = 'A'.
          UPDATE zmmt_scp_pa_aprl SET appr_status = 'APPROVE',
                                      remark      = @<ls_rabill_abst_h>-remarks
          WHERE user_name  = @wa_syname "sy-uname
          AND appr_status = 'INPROCESS'
          AND ra_bill_no = @ls_rabill_abst_h-ra_bill_no.
          lv_ct = wa_approver_d-app_level + 1.
          CONDENSE lv_ct NO-GAPS.
          CONDENSE ls_rabill_abst_h-ra_bill_no NO-GAPS.
          .
          SELECT SINGLE ra_bill_no FROM zmmt_scp_pa_aprl
            WHERE  ra_bill_no = @ls_rabill_abst_h-ra_bill_no
            AND app_level = @lv_ct
            INTO  @DATA(wa_approver).
          IF sy-subrc EQ 0.
            UPDATE zmmt_scp_pa_aprl SET appr_status = 'INPROCESS',
                                        zdate = @sydatum,
                                        ztime = @syuzeit
            WHERE ra_bill_no = @ls_rabill_abst_h-ra_bill_no
            AND app_level EQ @lv_ct.

          ELSE.
            lv_flag = 'P'.

            SELECT SINGLE * FROM zmmt_scp_pa_h1             "#EC WARNOK
             WHERE  ra_bill_no = @ls_rabill_abst_h-ra_bill_no
             INTO @DATA(wa_finalapprover).
            IF wa_finalapprover IS NOT INITIAL.
              wa_finalapprover-appr5 = 'A'.
              MODIFY zmmt_scp_pa_h1 FROM @wa_finalapprover.
            ENDIF.

          ENDIF.
        ELSEIF lv_flag = 'R' .
          UPDATE zmmt_scp_pa_aprl SET appr_status = 'REJECT',
                                      remark      = @<ls_rabill_abst_h>-remarks
         WHERE user_name  = @wa_syname "sy-uname
         AND appr_status = 'INPROCESS'
         AND ra_bill_no = @ls_rabill_abst_h-ra_bill_no.
        ENDIF.
      ENDIF.

      IF lv_flag = 'C'.
        ls_rabill_abst_h-ra_bill_no = <ls_rabill_abst_h>-rabillno.
        IF lv_r = '0'.
          ls_rabill_abst_h-ebeln      = <ls_rabill_abst_h>-ebeln.
        ELSEIF lv_r NE '0'.
          ls_rabill_abst_h-ebeln  = l_ponum."<ls_rabill_abst_h>-rabillno.
        ENDIF.
        ls_rabill_abst_h-gl_acc     = <ls_rabill_abst_h>-glaccno.
        ls_rabill_abst_h-hbkid      = <ls_rabill_abst_h>-housebankid.
        ls_rabill_abst_h-hktid      = <ls_rabill_abst_h>-accountid.
        ls_rabill_abst_h-vendor_invoice = <ls_rabill_abst_h>-vendorinvoice.
        lv_date                    = <ls_rabill_abst_h>-billdate.
        day = lv_date+0(2).
        month = lv_date+3(2).
        year = lv_date+6(4).
        w_date = |{ year }| && |{ month }| && |{ day }|.
        CONDENSE w_date NO-GAPS.
        ls_rabill_abst_h-bill_date     = w_date.

        CLEAR:w_date,lv_date.

        lv_date = <ls_rabill_abst_h>-postingdate.
        day = lv_date+0(2).
        month = lv_date+3(2).
        year = lv_date+6(4).
        w_date = |{ year }| && |{ month }| && |{ day }|.
        CONDENSE w_date NO-GAPS.
        ls_rabill_abst_h-post_date  = w_date.

        CLEAR:w_date,lv_date.

        ls_rabill_abst_h-wekrs = <ls_rabill_abst_h>-plant.
        ls_rabill_abst_h-zplant_name = <ls_rabill_abst_h>-plantname.
        ls_rabill_abst_h-ra_bill_from = <ls_rabill_abst_h>-rabillfrom.
        ls_rabill_abst_h-ra_bill_to  = <ls_rabill_abst_h>-rabillto.
        ls_rabill_abst_h-lifnr      = <ls_rabill_abst_h>-supplier.
        ls_rabill_abst_h-zsupplier_name = <ls_rabill_abst_h>-suppliername.
        ls_rabill_abst_h-region   = <ls_rabill_abst_h>-region.
        ls_rabill_abst_h-state_name = <ls_rabill_abst_h>-state.
        ls_rabill_abst_h-gstin = <ls_rabill_abst_h>-gstin.
        ls_rabill_abst_h-pan = <ls_rabill_abst_h>-pan.
        ls_rabill_abst_h-prctr = <ls_rabill_abst_h>-ProfitCenter.
        ls_rabill_abst_h-narration = <ls_rabill_abst_h>-narration.   """""""""""""""add by sandeep


        ls_rabill_abst_h-created_by     = sy-uname.
        ls_rabill_abst_h-created_at     = | { syuzeit } | && | { sydatum  } |.
        ls_rabill_abst_h-last_changed_by = sy-uname.
        ls_rabill_abst_h-last_changed_at = | { syuzeit } | && | { sydatum  } |.


        SELECT SINGLE rcount FROM zmmt_scp_rabill1          "#EC WARNOK
        WHERE ra_bill_no = @ls_rabill_abst_h-ra_bill_no
        INTO @ls_rabill_abst_h-rcount.

        ls_rabill_abst_h-bupla = <ls_rabill_abst_h>-businessplace.

        SELECT SINGLE FROM ZMM_RABILL_PAY_ABSTRACT_BP FIELDS sectioncode WHERE businessplace = @ls_rabill_abst_h-bupla INTO @data(sc).


        ls_rabill_abst_h-sectioncode = sc.   """"""""""""add by sandeep


        ls_rabill_abst_i-zcurr = 'INR'.
        ls_rabill_abst_i-ra_bill_no = <ls_rabill_abst_h>-rabillno.
        ls_rabill_abst_i-itm_code = <ls_rabill_abst_h>-itemcode.
        ls_rabill_abst_i-thisbill = <ls_rabill_abst_h>-thisbill.
        ls_rabill_abst_i-uptodate = <ls_rabill_abst_h>-uptodate.
        ls_rabill_abst_i-uptolast = <ls_rabill_abst_h>-uptolast.
        ls_rabill_abst_i-remarks  = <ls_rabill_abst_h>-remarks.

        ls_rabill_abst_i-local_created_by     = sy-uname.
        ls_rabill_abst_i-local_created_at     = | { syuzeit } | && | { sydatum  } |.
        ls_rabill_abst_i-local_last_changed_by = sy-uname.
        ls_rabill_abst_i-local_last_changed_at = | { syuzeit } | && | { sydatum  } |.

        ls_rabillmas_i-sr_no_n = <ls_rabill_abst_h>-srno.
        ls_rabillmas_i-sr_no_c = <ls_rabill_abst_h>-srnumber.
        ls_rabillmas_i-ra_bill_no = <ls_rabill_abst_h>-rabillno.
        IF lv_r = '0'.
          ls_rabillmas_i-ebeln = <ls_rabill_abst_h>-ebeln.
        ELSEIF lv_r NE '0'.
          ls_rabillmas_i-ebeln = l_ponum."<ls_rabill_abst_h>-ebeln.
          ls_rabillmas_i-advind = 'B'.
        ENDIF.
        ls_rabillmas_i-itm_code = <ls_rabill_abst_h>-itemcode.
        ls_rabillmas_i-description = <ls_rabill_abst_h>-pamasterdescription.
        ls_rabillmas_i-gl_code = <ls_rabill_abst_h>-glacc.
        ls_rabillmas_i-thisbill = <ls_rabill_abst_h>-thisbill.
        ls_rabillmas_i-uptodate = <ls_rabill_abst_h>-uptodate.
        ls_rabillmas_i-uptolast = <ls_rabill_abst_h>-uptolast.
        ls_rabillmas_i-remarks  = <ls_rabill_abst_h>-remarks.
        ls_rabillmas_i-zcurr = 'INR'.
        ls_rabillmas_i-tax_per = <ls_rabill_abst_h>-tax.

        ls_rabillmas_i-local_created_by = sy-uname.
        ls_rabillmas_i-local_created_at = | { syuzeit } | && | { sydatum  } |.
        ls_rabillmas_i-local_last_changed_by = sy-uname.
        ls_rabillmas_i-local_last_changed_at = | { syuzeit } | && | { sydatum  } |.

        SELECT SINGLE rcount FROM zmmt_scp_rabill1          "#EC WARNOK
          WHERE ra_bill_no = @ls_rabill_abst_h-ra_bill_no
              INTO @ls_rabillmas_i-rcount.


        "for approval level

        SELECT app_level,werks,username FROM zmmt_scp_pa_appr
        WHERE werks = @ls_rabill_abst_h-wekrs
        INTO TABLE @DATA(it_approver).

        LOOP AT it_approver INTO DATA(wa_appr).
          IF wa_appr-app_level = '1'.
            wa_aprl-appr_status = 'INPROCESS'.
            wa_aprl-zdate = sydatum.
            wa_aprl-ztime = syuzeit.
          ENDIF.
          wa_aprl-ra_bill_no = ls_rabill_abst_h-ra_bill_no.
          wa_aprl-user_name = wa_appr-username.
          wa_aprl-app_level = wa_appr-app_level.
          APPEND:wa_aprl TO it_aprl.
          CLEAR:wa_aprl,wa_appr.
        ENDLOOP.

        MODIFY zmmt_scp_pa_aprl FROM TABLE @it_aprl.
        MODIFY zmmt_scp_pa_h1 FROM @ls_rabill_abst_h.
        MODIFY zmmt_scp_pa1 FROM @ls_rabill_abst_i.
        MODIFY zmmt_scp_ra_payi FROM @ls_rabillmas_i.

        CLEAR:ls_rabill_abst_h,ls_rabill_abst_i,ls_rabillmas_i.

      ELSEIF lv_flag IS NOT INITIAL AND lv_flag = 'P'.

        INSERT VALUE #( rabillno = ls_rabill_abst_h-ra_bill_no
        flag = lv_flag )
        INTO TABLE lhc_buffer=>mt_buffer.

      ELSEIF lv_flag = 'D'.

        DELETE FROM zmmt_scp_pa_aprl WHERE ra_bill_no =  @ls_rabill_abst_h-ra_bill_no.
        DELETE FROM zmmt_scp_pa_h1 WHERE ra_bill_no = @ls_rabill_abst_h-ra_bill_no.
        DELETE FROM zmmt_scp_pa1 WHERE ra_bill_no = @ls_rabill_abst_h-ra_bill_no.
        DELETE FROM zmmt_scp_ra_payi WHERE ra_bill_no = @ls_rabill_abst_h-ra_bill_no.

      ELSEIF lv_flag = 'U'. "added on 30.08.2023
        SELECT SINGLE * FROM zmmt_scp_pa_h1             "#EC CI_NOORDER
         WHERE ra_bill_no = @<ls_rabill_abst_h>-Rabillno
         INTO @ls_rabill_abst_h1.

        ls_rabill_abst_h1-gl_acc = <ls_rabill_abst_h>-GlAcc.
        ls_rabill_abst_h1-gl_acc = <ls_rabill_abst_h>-GlAccNo.

        ls_rabill_abst_h1-bupla = <ls_rabill_abst_h>-BusinessPlace.
        SELECT SINGLE FROM ztbl_companycode FIELDS sectioncode WHERE businessplace = @ls_rabill_abst_h-bupla INTO @data(sc1).
        ls_rabill_abst_h1-sectioncode = sc1.  """""""add by sandeep
        ls_rabill_abst_h1-hbkid = <ls_rabill_abst_h>-HouseBankId.
        ls_rabill_abst_h1-hktid = <ls_rabill_abst_h>-AccountId.
        ls_rabill_abst_h1-vendor_invoice = <ls_rabill_abst_h>-VendorInvoice.
        ls_rabill_abst_h1-wekrs = <ls_rabill_abst_h>-plant.
        ls_rabill_abst_h1-prctr = <ls_rabill_abst_h>-ProfitCenter.
        "        ls_rabill_abst_h1-bill_date = <ls_rabill_abst_h>-InvDate.

        CLEAR:w_date,lv_date.
        lv_date                    = <ls_rabill_abst_h>-InvDate.
        day = lv_date+0(2).
        month = lv_date+3(2).
        year = lv_date+6(4).
        w_date = |{ year }| && |{ month }| && |{ day }|.
        CONDENSE w_date NO-GAPS.
        ls_rabill_abst_h1-bill_date     = w_date.

        CLEAR:w_date,lv_date.

        lv_date = <ls_rabill_abst_h>-postingdate.
        day = lv_date+0(2).
        month = lv_date+3(2).
        year = lv_date+6(4).
        w_date = |{ year }| && |{ month }| && |{ day }|.
        CONDENSE w_date NO-GAPS.
        ls_rabill_abst_h1-post_date  = w_date.

        CLEAR:w_date,lv_date.
        ls_rabill_abst_h-wekrs = <ls_rabill_abst_h>-plant.
        ls_rabill_abst_i-zcurr = 'INR'.
        ls_rabill_abst_i-ra_bill_no = <ls_rabill_abst_h>-rabillno.
        ls_rabill_abst_i-itm_code = <ls_rabill_abst_h>-itemcode.
        ls_rabill_abst_i-thisbill = <ls_rabill_abst_h>-thisbill.
        ls_rabill_abst_i-uptodate = <ls_rabill_abst_h>-uptodate.
        ls_rabill_abst_i-uptolast = <ls_rabill_abst_h>-uptolast.
        ls_rabill_abst_i-remarks  = <ls_rabill_abst_h>-remarks.

        ls_rabill_abst_i-local_created_by     = sy-uname.
        ls_rabill_abst_i-local_created_at     = | { syuzeit } | && | { sydatum  } |.
        ls_rabill_abst_i-local_last_changed_by = sy-uname.
        ls_rabill_abst_i-local_last_changed_at = | { syuzeit } | && | { sydatum  } |.

        ls_rabillmas_i-sr_no_n = <ls_rabill_abst_h>-srno.
        ls_rabillmas_i-sr_no_c = <ls_rabill_abst_h>-srnumber.
        ls_rabillmas_i-ra_bill_no = <ls_rabill_abst_h>-rabillno.
*        ls_rabillmas_i-ebeln = <ls_rabill_abst_h>-ebeln.
        IF lv_r = '0'.
          ls_rabillmas_i-ebeln = <ls_rabill_abst_h>-ebeln.
        ELSEIF lv_r NE '0'.
          ls_rabillmas_i-ebeln = l_ponum."<ls_rabill_abst_h>-ebeln.
          ls_rabillmas_i-advind = 'B'.
        ENDIF.
        ls_rabillmas_i-itm_code = <ls_rabill_abst_h>-itemcode.
        ls_rabillmas_i-description = <ls_rabill_abst_h>-pamasterdescription.
        ls_rabillmas_i-gl_code = <ls_rabill_abst_h>-glacc.
        ls_rabillmas_i-tax_per = <ls_rabill_abst_h>-tax.

        IF ls_rabillmas_i-gl_code IS INITIAL.
          SELECT SINGLE gl_code  FROM zmmt_scp_ra_payi      "#EC WARNOK
          WHERE itm_code = @ls_rabillmas_i-itm_code
          INTO @ls_rabillmas_i-gl_code.
        ENDIF.

        IF ls_rabillmas_i-tax_per IS INITIAL.
          SELECT SINGLE tax_per  FROM zmmt_scp_ra_payi      "#EC WARNOK
          WHERE itm_code = @ls_rabillmas_i-itm_code
          INTO @ls_rabillmas_i-tax_per.
        ENDIF.

        ls_rabillmas_i-thisbill = <ls_rabill_abst_h>-thisbill.
        ls_rabillmas_i-uptodate = <ls_rabill_abst_h>-uptodate.
        ls_rabillmas_i-uptolast = <ls_rabill_abst_h>-uptolast.
        ls_rabillmas_i-remarks  = <ls_rabill_abst_h>-remarks.
        ls_rabillmas_i-zcurr = 'INR'.


        ls_rabillmas_i-local_created_by = sy-uname.
        ls_rabillmas_i-local_created_at = | { syuzeit } | && | { sydatum  } |.
        ls_rabillmas_i-local_last_changed_by = sy-uname.
        ls_rabillmas_i-local_last_changed_at = | { syuzeit } | && | { sydatum  } |.

        SELECT SINGLE rcount FROM zmmt_scp_rabill1          "#EC WARNOK
          WHERE ra_bill_no = @ls_rabill_abst_h-ra_bill_no
              INTO @ls_rabillmas_i-rcount.


        "for approval level

        SELECT app_level,werks,username FROM zmmt_scp_pa_appr
        WHERE werks = @ls_rabill_abst_h-wekrs
        INTO TABLE @it_approver.

        LOOP AT it_approver INTO wa_appr.
          IF wa_appr-app_level = '1'.
            wa_aprl-appr_status = 'INPROCESS'.
            wa_aprl-zdate = sydatum.
            wa_aprl-ztime = syuzeit.
          ENDIF.
          wa_aprl-ra_bill_no = ls_rabill_abst_h-ra_bill_no.
          wa_aprl-user_name = wa_appr-username.
          wa_aprl-app_level = wa_appr-app_level.
          APPEND:wa_aprl TO it_aprl.
          CLEAR:wa_aprl,wa_appr.
        ENDLOOP.

        MODIFY zmmt_scp_pa_aprl FROM TABLE @it_aprl.
        MODIFY zmmt_scp_pa_h1 FROM @ls_rabill_abst_h1.
        MODIFY zmmt_scp_pa1 FROM @ls_rabill_abst_i.
        MODIFY zmmt_scp_ra_payi FROM @ls_rabillmas_i.

        CLEAR:ls_rabill_abst_i,ls_rabillmas_i.
      ENDIF.
      CLEAR:lv_flag,lv_r.
    ENDLOOP.
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

CLASS lsc_zmm_rabill_pay_abstract_he DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmm_rabill_pay_abstract_he IMPLEMENTATION.

  METHOD finalize.

    TYPES: BEGIN OF ty_buffer,
             rabillno TYPE zmmt_scp_pa_h1-ra_bill_no,
             flag     TYPE c LENGTH 1,
           END OF ty_buffer.

    TYPES tt_posting TYPE STANDARD TABLE OF ty_buffer.

    DATA: lt_data TYPE TABLE OF ty_buffer.
    DATA: wa_buffer LIKE LINE OF lt_data.

    DATA: it_post TYPE TABLE OF zmm_rabill_pay_abstract_post,
          wa_post LIKE LINE OF it_post.

    DATA: it_glpost TYPE TABLE OF zmm_rabill_pay_abstract_glpost,
          wa_glpost LIKE LINE OF it_glpost.

    DATA: it_advpost TYPE TABLE OF zmm_rabill_pay_abstract_adpost,
          wa_advpost LIKE LINE OF it_advpost.

    DATA: it_recpost TYPE TABLE OF zmm_rabill_pay_abstract_recov,
          wa_recpost LIKE LINE OF it_recpost.

    DATA: it_matdslpost TYPE TABLE OF zmm_rabill_pay_mat_dsl_post,
          wa_matdslpost LIKE LINE OF it_matdslpost.

    DATA: it_advrecpost TYPE TABLE OF zmm_rabill_pay_abstract_adrecp,
          wa_advrecpost LIKE LINE OF it_advrecpost.

    DATA: it_matdslgstpost TYPE TABLE OF zmm_rabill_pay_mat_dsl_gstpost,
          wa_matdslgstpost LIKE LINE OF it_matdslgstpost.

*    DATA: lv_r     TYPE c LENGTH 1,
*          lv_poval TYPE zchar5.


    DATA: lv_r      TYPE c LENGTH 1,
          lv_poval  TYPE zchar5,
          l_wthamt  TYPE c LENGTH 25 VALUE 'WithHeld amount',
          l_retamt  TYPE c LENGTH 25 VALUE 'Retention amount',
          l_holdrel TYPE c LENGTH 25 VALUE 'Hold amount release',
          l_advrec  TYPE c LENGTH 25 VALUE 'Advance Recovery',
          l_tdspay  TYPE c LENGTH 25 VALUE 'TDS Payable'.

    lt_data = lhc_buffer=>mt_buffer.

    DATA(sydatum1) = xco_cp=>sy->date( xco_cp_time=>time_zone->user )->as( xco_cp_time=>format->iso_8601_extended  )->value.
    DATA(syuzeit1) = xco_cp=>sy->time( xco_cp_time=>time_zone->user )->as( xco_cp_time=>format->iso_8601_extended  )->value.

    DATA sydatum TYPE c LENGTH 8.
    DATA syuzeit TYPE c LENGTH 8.

    CONCATENATE sydatum1+0(4) sydatum1+5(2) sydatum1+8(2) INTO sydatum.
    CONCATENATE syuzeit1+0(2) syuzeit1+3(2) syuzeit1+6(2) INTO syuzeit.

    READ TABLE lt_data INTO DATA(wa_data) INDEX 1.
    IF sy-subrc EQ 0.
      wa_buffer-rabillno = wa_data-rabillno.
      wa_buffer-flag = wa_data-flag.
    ENDIF.
**************************************Miro Posting*********************************************************
    lv_poval = wa_buffer-rabillno+0(5).
    IF  lv_poval CA '/'.
      lv_r = wa_buffer-rabillno+0(1).
      SPLIT wa_buffer-rabillno AT '/' INTO DATA(l_blnk) DATA(l_ponum).
    ELSE.
      lv_r = '0'.
    ENDIF.

    IF sy-subrc IS INITIAL AND wa_buffer-flag IS NOT INITIAL AND wa_buffer-flag = 'P'.

      IF lv_r EQ '0'.

        DATA ls_invoice TYPE STRUCTURE FOR ACTION IMPORT i_supplierinvoicetp~create.
        DATA lt_invoice TYPE TABLE FOR ACTION IMPORT i_supplierinvoicetp~create.
        TRY.
            DATA(lv_cid) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
          CATCH cx_uuid_error.
            "Error handling
            ASSERT 1 = 0.
        ENDTRY.

        IF wa_buffer-rabillno IS NOT INITIAL AND wa_buffer-flag IS NOT INITIAL AND wa_buffer-flag = 'P'.
          SELECT * FROM zmm_rabill_pay_abstract_post
          WHERE rabillno = @wa_buffer-rabillno
          INTO TABLE @it_post.
        ENDIF.

        IF it_post IS NOT INITIAL.

          READ TABLE it_post INTO wa_post INDEX 1.
          CLEAR:wa_post-grossamount.
          DATA:counter TYPE n LENGTH 6,
               lv_baseamount          TYPE dmbtr,
               whldgtxbaseamtindoccry TYPE dmbtr.

          LOOP AT it_post INTO DATA(wa_amt) WHERE rabillno = wa_post-rabillno.
            counter = counter + 1.
            IF wa_amt-grossamount IS INITIAL.
              wa_amt-GrossAmount = wa_amt-SupplierInvoiceAmount.
            ENDIF.
            wa_post-grossamount = wa_amt-grossamount + wa_post-grossamount.
            wa_amt-counter = counter.
            MODIFY it_post FROM wa_amt TRANSPORTING counter.
            CLEAR:wa_amt.
          ENDLOOP.

          ls_invoice-%cid                                 = lv_cid.
          ls_invoice-%param-supplierinvoiceiscreditmemo   = abap_false.
          ls_invoice-%param-companycode                   = wa_post-companycode.
          ls_invoice-%param-invoicingparty                = wa_post-supplier.
          ls_invoice-%param-postingdate                   = wa_post-postingdate.
          ls_invoice-%param-documentdate                  = wa_post-billdate.
          ls_invoice-%param-documentcurrency              = wa_post-currency.
          ls_invoice-%param-invoicegrossamount            = wa_post-grossamount.
          ls_invoice-%param-taxiscalculatedautomatically  = abap_true.
          ls_invoice-%param-supplierinvoiceidbyinvcgparty = wa_post-vendorinvoice.
          ls_invoice-%param-SupplierPostingLineItemText = wa_post-narration.             """"""""""""""add by sandeep
          IF wa_post-vendorinvoice IS INITIAL.
            ls_invoice-%param-supplierinvoiceidbyinvcgparty = wa_post-rabillno.
          ENDIF.
          ls_invoice-%param-businesssectioncode = wa_post-sectioncode.
          ls_invoice-%param-businessplace = wa_post-businessplace.
          ls_invoice-%param-taxdeterminationdate =  sydatum.
          "          ls_invoice-%param-taxdeterminationdate = sy-datlo.
          ls_invoice-%param-paymentblockingreason = 'A'.
          ls_invoice-%param-_itemswithporeference = VALUE #( FOR wa_post1 IN it_post
          ( supplierinvoiceitem         = wa_post1-counter
            purchaseorder = wa_post1-ebeln
            purchaseorderitem = wa_post1-ebelp
            documentcurrency = wa_post1-currency
            supplierinvoiceitemamount   = wa_post1-supplierinvoiceamount
            purchaseorderquantityunit   = wa_post1-unit
            taxcode = wa_post1-taxcode
            serviceentrysheet = wa_post1-ses
            serviceentrysheetitem = wa_post1-sesitem
            quantityinpurchaseorderunit = wa_post1-qty
             ) ).

"""""""""""""""""""""""" Add Withholding Tax Logic by VijayM - 19.02.25 """"""""""""""""""""""""""
          SELECT withholdingtaxtype, withholdingtaxcode  FROM i_supplierwithholdingtax
          WHERE supplier = @wa_post-supplier  and CompanyCode = @wa_post-CompanyCode AND iswithholdingtaxsubject = 'X'
          INTO TABLE @DATA(lt_supplierwht) .
          SELECT single withholdingtaxtype, withholdingtaxcode  FROM i_supplierwithholdingtax
          WHERE supplier = @wa_post-supplier  and CompanyCode = @wa_post-CompanyCode AND iswithholdingtaxsubject = 'X'
          INTO  @DATA(widrh) .

*          SELECT SINGLE zwith, wtwithcd FROM zmm_scp_tnc_cds1 WHERE ebeln = @wa_post-ebeln
*          INTO @DATA(wa_tnc) .

          SELECT SINGLE
         SUM( CASE WHEN itm_code = 'GTBQ' THEN thisbill ELSE 0 END ) AS gtbq,
         SUM( CASE WHEN itm_code = 'REMB' THEN thisbill ELSE 0 END ) AS admo,
         SUM( CASE WHEN itm_code = 'REMT' THEN thisbill ELSE 0 END ) AS admt,
         SUM( CASE WHEN itm_code = 'REWD' THEN thisbill ELSE 0 END ) AS adwd,
         SUM( CASE WHEN itm_code = 'EWMC' THEN thisbill ELSE 0 END ) AS admc
         FROM zmmt_scp_pa1
         WHERE ra_bill_no = @wa_post-rabillno AND
         itm_code IN ('GTBQ' ,'REMB', 'REMT', 'REWD', 'EWMC')
         INTO @DATA(result).

          IF result IS NOT INITIAL.
*            lv_baseamount = result-gtbq - result-admo - result-admt - result-adwd - result-admc.
            lv_baseamount = result-gtbq - ( result-admo + result-admt + result-adwd + result-admc ).
          ENDIF.

    if   lv_baseamount > 0.
     SELECT SINGLE zwith, wtwithcd FROM zmm_scp_tnc_cds1 WHERE ebeln = @wa_post-ebeln
          INTO @DATA(wa_tnc) .
          endif.
          ls_invoice-%param-_withholdingtaxes = VALUE #( FOR wa_supplierwht IN lt_supplierwht
           (
              withholdingtaxtype = wa_supplierwht-withholdingtaxtype
              withholdingtaxcode = COND #(
                                   WHEN wa_supplierwht-withholdingtaxtype = widrh-WithholdingTaxType
                                   AND  wa_supplierwht-withholdingtaxcode = widrh-withholdingtaxcode
                                   THEN wa_supplierwht-withholdingtaxcode
                                   ELSE ''   )
              documentcurrency =  wa_post-currency
              whldgtxbaseamtindoccry = COND #(
                                       WHEN wa_supplierwht-withholdingtaxtype = widrh-WithholdingTaxType
                                       AND wa_supplierwht-withholdingtaxcode = widrh-withholdingtaxcode
                                       THEN lv_baseamount
                                       ELSE ''   )
*                                                mnllyenteredwhldgtxamtindoccry = ''
*                                              WhldgTaxBaseIsEnteredManually = abap_true
*                                              WhldgTaxIsEnteredManually = abap_true
                                       )
                                        ) .
*          ls_invoice-%param-_withholdingtaxes = VALUE #( FOR wa_supplierwht IN lt_supplierwht
*           (
*              withholdingtaxtype = wa_supplierwht-withholdingtaxtype
*              withholdingtaxcode = COND #(
*                                   WHEN wa_supplierwht-withholdingtaxtype = wa_tnc-zwith
*                                   AND  wa_supplierwht-withholdingtaxcode = wa_tnc-wtwithcd
*                                   THEN wa_supplierwht-withholdingtaxcode
*                                   ELSE ''   )
*              documentcurrency =  wa_post-currency
*              whldgtxbaseamtindoccry = COND #(
*                                       WHEN wa_supplierwht-withholdingtaxtype = wa_tnc-zwith
*                                       AND wa_supplierwht-withholdingtaxcode = wa_tnc-wtwithcd
*                                       THEN lv_baseamount
*                                       ELSE ''   )
**                                                mnllyenteredwhldgtxamtindoccry = ''
**                                              WhldgTaxBaseIsEnteredManually = abap_true
**                                              WhldgTaxIsEnteredManually = abap_true
*                                       )
*                                        ) .


"""""""""""""""""""""""" End Withholding Tax Logic by VijayM - 19.02.25 """"""""""""""""""""""""""

          INSERT ls_invoice INTO TABLE lt_invoice.
          CLEAR:wa_post,wa_tnc,result,lv_baseamount.
          "Register the action
          MODIFY ENTITIES OF i_supplierinvoicetp   ##NO_PRIVILEGED
          ENTITY supplierinvoice
          EXECUTE create FROM lt_invoice
          FAILED DATA(ls_failed)
          REPORTED DATA(ls_reported)
          MAPPED DATA(ls_mapped).
    LOOP AT ls_reported-supplierinvoice ASSIGNING FIELD-SYMBOL(<ls_reported_deepp>) WHERE %msg->if_t100_dyn_msg~msgty = 'E'..
      IF sy-tabix <> 1.
      DATA : flag TYPE abap_boolean.
        flag = abap_true.
        APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                text     = <ls_reported_deepp>-%msg->if_message~get_text( ) )
                                                                %element-rabillno = if_abap_behv=>mk-on ) TO reported-zmm_payabstract.
      ENDIF.
   endloop.
        ENDIF.
*      ENDIF.

***************************added on 28.08.2023 GL Posting******************************************************
        CLEAR: counter.
        DATA: lv_totalsuppamt TYPE zmm_rabill_pay_abstract_glpost-thisbill.
        DATA: lv_glcode TYPE c LENGTH 20.

        SELECT * FROM zmm_rabill_pay_abstract_glpost
        WHERE rabillno = @wa_buffer-rabillno
        AND   thisbill <> '0.00'
        INTO TABLE @it_glpost.

        IF it_glpost IS NOT INITIAL.

          READ TABLE it_glpost INTO wa_glpost INDEX 1.

          SELECT SINGLE ReconciliationAccount FROM zmm_supp_gl WHERE supplier = @wa_glpost-Supplier
                                                 INTO @DATA(Supplier_gl) .

          DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post.
          TRY.
              lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
            CATCH cx_uuid_error.
              ASSERT 1 = 0.
          ENDTRY.

          LOOP AT it_glpost INTO DATA(wa_glamt) WHERE rabillno = wa_glpost-rabillno.
            counter = counter + 1.
            lv_totalsuppamt = lv_totalsuppamt + wa_glamt-thisbill.
*            wa_glamt-thisbill = wa_glamt-thisbill.
*            wa_glamt-counter = counter.
*            if wa_glamt-thisbill > 0.
            wa_glamt-thisbill = wa_glamt-thisbill * ( -1 ).
*            else.
*            wa_glamt-thisbill = wa_glamt-thisbill.
*            endif.
            lv_glcode = | { '00' } | && | { wa_glamt-gl_code } |.
            CONDENSE lv_glcode NO-GAPS.
            wa_glamt-gl_code = lv_glcode.
            CONDENSE wa_glamt-gl_code NO-GAPS.
            MODIFY it_glpost FROM wa_glamt TRANSPORTING counter gl_code thisbill.
            CLEAR:wa_glamt,lv_glcode.
          ENDLOOP.
*
          counter = counter + 1.
*


          DATA(wa_glsupp) = wa_glpost.
          wa_glsupp-Counter = counter.
          wa_glsupp-gl_code = Supplier_gl.
          wa_glsupp-thisbill = lv_totalsuppamt.
          wa_glsupp-SpecialGL = ''.
          wa_glsupp-Remarks = l_wthamt."'With Held amount'.  ##NO_TEXT
          APPEND wa_glsupp TO it_glpost.
*      LOOP AT it_glpost INTO wa_glamt WHERE rabillno = wa_glpost-rabillno.
          APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
          <je_deep>-%cid = lv_cid.
          <je_deep>-%param = VALUE #(
           companycode = wa_glpost-companycode "'1000' " Success
           documentreferenceid = wa_glpost-vendorinvoice "'BKPFF'
           createdbyuser = sy-uname
           businesstransactiontype = 'RFBU'
           accountingdocumenttype = 'KA'
           documentdate = wa_glpost-BillDate "sy-datlo
           postingdate =  wa_glpost-PostingDate "sy-datlo
           TaxDeterminationDate = sydatum
           accountingdocumentheadertext = l_wthamt"'With Held amount'  ##NO_TEXT
          _apitems =  VALUE #( FOR wa_glpost1 IN it_glpost (
                                              glaccountlineitem  = wa_glpost1-counter
                                              glaccount          = wa_glpost1-gl_code
                                              documentitemtext   = wa_glpost1-Remarks
                                              supplier           = wa_glpost1-supplier
                                              businessplace      = wa_glpost1-businessplace
                                              profitcenter       = wa_glpost1-profitcenter
                                              SpecialGLCode      = wa_glpost1-SpecialGL
                                              BusinessSectionCode = wa_glpost1-SectionCode      ""Added on 6.11.2025
                                              TaxCode            =  'ID'
                                              _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = wa_glpost1-thisbill  currency = 'INR' ) )
                                              )
                                        )
                                ) .
          MODIFY ENTITIES OF i_journalentrytp    ##NO_PRIVILEGED
           ENTITY journalentry
           EXECUTE post FROM lt_je_deep
           FAILED DATA(ls_failed_deep)
           REPORTED DATA(ls_reported_deep)
           MAPPED DATA(ls_mapped_deep).
          IF ls_failed_deep IS NOT INITIAL.

      LOOP AT ls_reported_deep-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>) WHERE %msg->if_t100_dyn_msg~msgty = 'E'..
      IF sy-tabix <> 1.
        flag = abap_true.
        APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                text     = <ls_reported_deep>-%msg->if_message~get_text( ) )
                                                                %element-rabillno = if_abap_behv=>mk-on ) TO reported-zmm_payabstract.
      ENDIF.
    ENDLOOP.
          ELSE.
          ENDIF.
        ENDIF.
******************************end 28.08.2023************************************************************

***************************added on 03.01.2025 GL Posting - REWO - RT***********************************
        CLEAR: counter,lv_totalsuppamt,lv_glcode,lt_je_deep[].
        SELECT * FROM zmm_rabill_pay_abstract_gl_rt
        WHERE rabillno = @wa_buffer-rabillno
        AND   thisbill <> '0.00'
        INTO TABLE @it_glpost.

        IF it_glpost IS NOT INITIAL.

          READ TABLE it_glpost INTO wa_glpost INDEX 1.

          SELECT SINGLE ReconciliationAccount FROM zmm_supp_gl WHERE supplier = @wa_glpost-Supplier
          INTO @Supplier_gl .
          TRY.
              lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
            CATCH cx_uuid_error.
              ASSERT 1 = 0.
          ENDTRY.

          LOOP AT it_glpost INTO wa_glamt WHERE rabillno = wa_glpost-rabillno.
            counter = counter + 1.
            lv_totalsuppamt = lv_totalsuppamt + wa_glamt-thisbill.
            wa_glamt-counter = counter.
            wa_glamt-thisbill = wa_glamt-thisbill * ( -1 ).
            lv_glcode = | { '00' } | && | { wa_glamt-gl_code } |.
            CONDENSE lv_glcode NO-GAPS.
            wa_glamt-gl_code = lv_glcode.
            CONDENSE wa_glamt-gl_code NO-GAPS.
            MODIFY it_glpost FROM wa_glamt TRANSPORTING counter gl_code thisbill.
            CLEAR:wa_glamt,lv_glcode.
          ENDLOOP.

          counter = counter + 1.

          wa_glsupp = wa_glpost.
          wa_glsupp-Counter = counter.
          wa_glsupp-gl_code = Supplier_gl.
          wa_glsupp-thisbill = lv_totalsuppamt.
          wa_glsupp-SpecialGL = ''.
          wa_glsupp-Remarks = l_retamt."'With Held amount'.  ##NO_TEXT
          APPEND wa_glsupp TO it_glpost.

          APPEND INITIAL LINE TO lt_je_deep ASSIGNING <je_deep>.
          <je_deep>-%cid = lv_cid.
          <je_deep>-%param = VALUE #(
           companycode = wa_glpost-companycode "'1000' " Success
           documentreferenceid = wa_glpost-vendorinvoice "'BKPFF'
           createdbyuser = sy-uname
           businesstransactiontype = 'RFBU'
           accountingdocumenttype = 'RT'
           documentdate = wa_glpost-billdate "sy-datlo
           postingdate =    wa_glpost-postingdate "sy-datlo
           accountingdocumentheadertext = l_retamt"'With Held amount'  ##NO_TEXT
          _apitems =  VALUE #( FOR wa_glpost1 IN it_glpost (
                                              glaccountlineitem  = wa_glpost1-counter
                                              glaccount          = wa_glpost1-gl_code
                                              documentitemtext   = wa_glpost1-Remarks
                                              supplier           = wa_glpost1-supplier
                                              businessplace      = wa_glpost1-businessplace
                                              profitcenter       = wa_glpost1-profitcenter
                                              SpecialGLCode      = wa_glpost1-SpecialGL
                                              BusinessSectionCode = wa_glpost1-SectionCode       ""Added on 6.11.2025
**                                              TaxCode            = 'AC'
                                              _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = wa_glpost1-thisbill  currency = 'INR' ) )
                                              )
                                        )
                                ) .
          MODIFY ENTITIES OF i_journalentrytp    ##NO_PRIVILEGED
           ENTITY journalentry
           EXECUTE post FROM lt_je_deep
           FAILED DATA(ls_failed_deep11)
           REPORTED DATA(ls_reported_deep11)
           MAPPED DATA(ls_mapped_deep11).
          IF ls_failed_deep11 IS NOT INITIAL.
            LOOP AT ls_reported_deep11-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep11>).
              DATA(lv_result11) = <ls_reported_deep11>-%msg->if_message~get_text( ).
*              ...  APPEND VALUE #( %key                = wa_buffer-key ) TO failed-zmm_payabstract .
              APPEND VALUE #(
*                   %tky                = wa_buffer-key
                         %state_area        = 'Error'
                          %msg              = new_message_with_text(
                                                      text   = lv_result11
                                                      severity = if_abap_behv_message=>severity-error )
                       %element-rabillno = if_abap_behv=>mk-on ) TO reported-zmm_payabstract .



            ENDLOOP.
          ELSE.
          ENDIF.
        ENDIF.
******************************end  03.01.2025 GL Posting - REWO - RT************************************


*******************added on 22.09.2023 Material and DieselPosting***************************************
        CLEAR: counter.
        DATA: lv_totalsuppamt3 TYPE zmm_rabill_pay_mat_dsl_post-thisbill.
        DATA: lv_glcode3 TYPE c LENGTH 20.
        DATA: taxrate TYPE zmm_rabill_pay_mat_dsl_post-thisbill.

        SELECT * FROM zmm_rabill_pay_mat_dsl_post
        WHERE rabillno = @wa_buffer-rabillno
        AND   thisbill <> '0.00'
        INTO TABLE @it_matdslpost.

       SORT it_matdslpost BY rabillno thisbill itm_code.
        DELETE ADJACENT DUPLICATES FROM it_matdslpost COMPARING Rabillno thisbill itm_code .

        IF it_matdslpost IS NOT INITIAL.

          READ TABLE it_matdslpost INTO wa_matdslpost INDEX 1.

          SELECT SINGLE ReconciliationAccount FROM zmm_supp_gl WHERE supplier = @wa_matdslpost-Supplier INTO @DATA(Supplier_gl1) .

          DATA: lt_je_deep3 TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post.
          TRY.
              lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
            CATCH cx_uuid_error.
              ASSERT 1 = 0.
          ENDTRY.

          LOOP AT it_matdslpost INTO DATA(wa_matdslamt) WHERE rabillno = wa_matdslpost-rabillno.
            counter = counter + 1.
            lv_totalsuppamt3 = lv_totalsuppamt3 + wa_matdslamt-thisbill.
            wa_matdslamt-counter = counter.
            wa_matdslamt-thisbill = wa_matdslamt-thisbill * ( -1 ).
            lv_glcode3 = | { '00' } | && | { wa_matdslamt-gl_code } |.
            CONDENSE lv_glcode3 NO-GAPS.
            wa_matdslamt-gl_code = lv_glcode3.
            CONDENSE wa_matdslamt-gl_code NO-GAPS.
            MODIFY it_matdslpost FROM wa_matdslamt TRANSPORTING counter gl_code thisbill.
            CLEAR:wa_matdslamt,lv_glcode3.
          ENDLOOP.
          counter = counter + 1.

          APPEND INITIAL LINE TO lt_je_deep3 ASSIGNING FIELD-SYMBOL(<je_deep3>).
          <je_deep3>-%cid = lv_cid.
          <je_deep3>-%param = VALUE #(
           companycode = wa_matdslpost-companycode "'1000' " Success
           documentreferenceid = wa_matdslpost-vendorinvoice "'BKPFF'
           createdbyuser = sy-uname
           businesstransactiontype = 'RFBU'
           accountingdocumenttype = 'KA'
           documentdate = wa_matdslpost-billdate "sy-datlo
           postingdate = wa_matdslpost-postingdate "sy-datlo
           accountingdocumentheadertext = 'Deduction'  ##NO_TEXT


          _glitems = VALUE #( FOR wa_matdslpost1 IN it_matdslpost

                               (
                                               glaccountlineitem              = wa_matdslpost1-counter
                                              documentitemtext               = wa_matdslpost1-remarks
                                              glaccount                      = wa_matdslpost1-gl_code
                                              profitcenter                   = wa_matdslpost1-profitcenter
                                              businessplace                  = wa_matdslpost1-businessplace
                                              wbselement                     =     ''   "wa_matdslpost1-projectelement
*                                              taxcode                        = wa_matdslpost1-taxcode "added on 29.09.2023
                                             _currencyamount                  = VALUE #( ( currencyrole = '00' journalentryitemamount = wa_matdslpost1-thisbill currency = 'INR' ) )
                                              )
                                        )


          _apitems =  VALUE #(  (

                                              glaccountlineitem               = counter
                                              glaccount = Supplier_gl1"'0021100000'
                                              supplier = wa_matdslpost-supplier
                                              businessplace = wa_matdslpost-businessplace
                                              profitcenter = wa_matdslpost-profitcenter
                                              BusinessSectionCode = wa_matdslpost-SectionCode      ""Added on 6.11.2025
*                                              taxcode      = wa_matdslpost-taxcode
                                              _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = lv_totalsuppamt3  currency = 'INR' ) )
                                              )
                                        )
                                ) .

          MODIFY ENTITIES OF i_journalentrytp   ##NO_PRIVILEGED
           ENTITY journalentry
           EXECUTE post FROM lt_je_deep3
           FAILED DATA(ls_failed_deep3)
           REPORTED DATA(ls_reported_deep3)
           MAPPED DATA(ls_mapped_deep3).
          IF ls_failed_deep3 IS NOT INITIAL.
            LOOP AT ls_reported_deep3-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep3>) WHERE %msg->if_t100_dyn_msg~msgty = 'E'.
           IF sy-tabix <> 1.
        flag = abap_true.
        APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                text     = <ls_reported_deep>-%msg->if_message~get_text( ) )
                                                                %element-rabillno = if_abap_behv=>mk-on ) TO reported-zmm_payabstract.
      ENDIF.


            ENDLOOP.
          ELSE.
          ENDIF.
        ENDIF.

*************************added on 13.10.2023 Gst Posting For Material and Disel **************************************
****
****        CLEAR: counter.
****        DATA: lv_totalsuppamt4 TYPE zmm_rabill_pay_mat_dsl_gstpost-thisbill.
****        DATA: lv_glcode4 TYPE c LENGTH 20.
****
****
****        SELECT * FROM zmm_rabill_pay_mat_dsl_gstpost
****        WHERE rabillno = @wa_buffer-rabillno
****        AND   thisbill <> '0.00'
****        INTO TABLE @it_matdslgstpost.
****
****        IF it_matdslgstpost IS NOT INITIAL.
****
****          READ TABLE it_matdslgstpost INTO wa_matdslgstpost INDEX 1.
****          SELECT SINGLE ReconciliationAccount FROM I_SupplierCompany WHERE supplier = @wa_matdslgstpost-Supplier INTO @DATA(Supplier_gl2) .
****          DATA: lt_je_deep4 TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post.
****          TRY.
****              lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
****            CATCH cx_uuid_error.
****              ASSERT 1 = 0.
****          ENDTRY.
****
****          LOOP AT it_matdslgstpost INTO DATA(wa_matdslgstamt) WHERE rabillno = wa_matdslgstpost-rabillno.
****            counter = counter + 1.
****            lv_totalsuppamt4 = lv_totalsuppamt4 + wa_matdslgstamt-thisbill.
****            wa_matdslgstamt-counter = counter.
****            wa_matdslgstamt-thisbill = wa_matdslgstamt-thisbill * ( -1 ).
****            lv_glcode4 = | { '00' } | && | { wa_matdslgstamt-gl_code } |.
****            CONDENSE lv_glcode4 NO-GAPS.
****            wa_matdslgstamt-gl_code = lv_glcode4.
****            CONDENSE wa_matdslgstamt-gl_code NO-GAPS.
****            MODIFY it_matdslgstpost FROM wa_matdslgstamt TRANSPORTING counter gl_code thisbill.
****            CLEAR:wa_matdslgstamt,lv_glcode4.
****          ENDLOOP.
****
****          counter = counter + 1.
****
****          APPEND INITIAL LINE TO lt_je_deep4 ASSIGNING FIELD-SYMBOL(<je_deep4>).
****          <je_deep4>-%cid = lv_cid.
****          <je_deep4>-%param = VALUE #(
****           companycode = wa_matdslgstpost-companycode "'1000' " Success
****           documentreferenceid = wa_matdslgstpost-vendorinvoice "'BKPFF'
****           createdbyuser = sy-uname
****           businesstransactiontype = 'RFBU'
****           accountingdocumenttype = 'KA'
****           documentdate = wa_matdslgstpost-billdate "sy-datlo
****           postingdate = wa_matdslgstpost-postingdate "sy-datlo
*****           taxdeterminationdate  = sy-datlo
****           accountingdocumentheadertext = 'Mat/Diesel Recov GST'
****
****
****          _glitems = VALUE #( FOR wa_matdslgstpost1 IN it_matdslgstpost
****
****                               (
****                                               glaccountlineitem             = wa_matdslgstpost1-counter
****                                              documentitemtext               = wa_matdslgstpost1-remarks
****                                              glaccount                      = wa_matdslgstpost1-gl_code
****                                              profitcenter                   = wa_matdslgstpost1-profitcenter
****                                              businessplace                  = wa_matdslgstpost1-businessplace
****                                              wbselement                     = wa_matdslgstpost1-projectelement
*****                                              taxcode                        = 'ZN'
****                                             _currencyamount                  = VALUE #( ( currencyrole = '00' journalentryitemamount = wa_matdslgstpost1-thisbill currency = 'INR' ) )
****                                              )
****                                        )
****
****
****          _apitems =  VALUE #(  (
****
****                                              glaccountlineitem               = counter
****                                              glaccount = Supplier_gl2"'0021100000'
****                                              supplier = wa_matdslgstpost-supplier
****                                              businessplace = wa_matdslgstpost-businessplace
****                                              profitcenter = wa_matdslgstpost-profitcenter
*****                                              taxcode       = 'ZN'
****                                              _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = lv_totalsuppamt4  currency = 'INR' ) )
****                                              )
****                                        )
****                                ) .
****
****          MODIFY ENTITIES OF i_journalentrytp
****           ENTITY journalentry
****           EXECUTE post FROM lt_je_deep4
****           FAILED DATA(ls_failed_deep4)
****           REPORTED DATA(ls_reported_deep4)
****           MAPPED DATA(ls_mapped_deep4).
****          IF ls_failed_deep4 IS NOT INITIAL.
****            LOOP AT ls_reported_deep4-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep4>).
****              DATA(lv_result4) = <ls_reported_deep4>-%msg->if_message~get_text( ).
****              ...
****            ENDLOOP.
****          ELSE.
****          ENDIF.
****        ENDIF.
****
****
**********************************************************************************************************************


*********************added on 23.09.2023 Advance Recovery Posting*************************************************
        CLEAR: counter.
        DATA: lv_totalsuppamt2 TYPE zmm_rabill_pay_abstract_adrecp-thisbill.
        DATA: lv_totalamt TYPE zmm_rabill_pay_abstract_adrecp-thisbill.
        DATA: lv_glcode2 TYPE c LENGTH 20.

        SELECT * FROM zmm_rabill_pay_abstract_adrecp
        WHERE rabillno = @wa_buffer-rabillno
        AND   thisbill <> '0.00'
        INTO TABLE @it_advrecpost.

        IF it_advrecpost IS NOT INITIAL.

          READ TABLE it_advrecpost INTO wa_advrecpost INDEX 1.
          SELECT SINGLE ReconciliationAccount FROM zmm_supp_gl WHERE supplier = @wa_advrecpost-Supplier INTO @DATA(Supplier_gl3) .
          DATA: lt_je_deep2 TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post.
          TRY.
              lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
            CATCH cx_uuid_error.
              ASSERT 1 = 0.
          ENDTRY.

          LOOP AT it_advrecpost INTO DATA(wa_advrecamt) WHERE rabillno = wa_advrecpost-rabillno.
            counter = counter + 1.
            lv_totalsuppamt2 = lv_totalsuppamt2 + wa_advrecamt-thisbill.
            wa_advrecamt-counter = counter.
*            wa_advrecamt-thisbill = wa_advrecamt-thisbill * ( -1 ).
            lv_glcode2 = | { '00' } | && | { wa_advrecamt-gl_code } |.
            CONDENSE lv_glcode2 NO-GAPS.
            wa_advrecamt-gl_code = lv_glcode2.
            CONDENSE wa_advrecamt-gl_code NO-GAPS.
            CLEAR:lv_glcode2.
            lv_glcode2 = | { '00' } | && | { wa_advrecamt-headergl } |.
            CONDENSE lv_glcode2 NO-GAPS.
            wa_advrecamt-headergl = lv_glcode2.
            CONDENSE wa_advrecamt-headergl NO-GAPS.
            MODIFY it_advrecpost FROM wa_advrecamt TRANSPORTING counter gl_code headergl. "thisbill.
            CLEAR:wa_advrecamt,lv_glcode2.
          ENDLOOP.

          counter = counter + 1.
          lv_totalsuppamt2 = lv_totalsuppamt2 * ( -1 ).


          DATA(wa_glsupp1) = wa_advrecpost.
          wa_glsupp1-Counter = counter.
          wa_glsupp1-gl_code = Supplier_gl3.
          wa_glsupp1-thisbill = lv_totalsuppamt2.
          wa_glsupp1-SpecialGL = ''.
          wa_glsupp1-Remarks = l_holdrel."'Hold amount release'.    ##NO_TEXT
          APPEND wa_glsupp1 TO it_advrecpost.


          APPEND INITIAL LINE TO lt_je_deep2 ASSIGNING FIELD-SYMBOL(<je_deep2>).
          <je_deep2>-%cid = lv_cid.
          <je_deep2>-%param = VALUE #(
           companycode = wa_advrecpost-companycode "'1000' " Success
           documentreferenceid = wa_advrecpost-vendorinvoice "'BKPFF'
           createdbyuser = sy-uname
           businesstransactiontype = 'RFBU'
           accountingdocumenttype = 'KA'
           documentdate = wa_advrecpost-billdate "sy-datlo
           postingdate = wa_advrecpost-postingdate "sy-datlo
           taxdeterminationdate  = sydatum
           accountingdocumentheadertext = 'Hold amount releases'    ##NO_TEXT

          _apitems =  VALUE #(  FOR wa_advrecpost1 IN it_advrecpost (
                                              glaccountlineitem               = wa_advrecpost1-counter
                                              supplier = wa_advrecpost1-supplier
                                              businessplace = wa_advrecpost1-businessplace
                                              profitcenter = wa_advrecpost1-profitcenter
                                              glaccount                      = wa_advrecpost1-gl_code
                                              documentitemtext               = wa_advrecpost1-remarks
*                                              housebankaccount = wa_advrecpost-accountid
                                              specialglcode = wa_advrecpost1-SpecialGL
                                              BusinessSectionCode = wa_advrecpost1-SectionCode       ""Added on 6.11.2025
*                                              taxcode       = 'ZN'
                                              _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = wa_advrecpost1-thisbill  currency = 'INR' ) )
                                              )
                                        )

                                ) .
          MODIFY ENTITIES OF i_journalentrytp   ##NO_PRIVILEGED
           ENTITY journalentry
           EXECUTE post FROM lt_je_deep2
           FAILED DATA(ls_failed_deep2)
           REPORTED DATA(ls_reported_deep2)
           MAPPED DATA(ls_mapped_deep2).
          IF ls_failed_deep2 IS NOT INITIAL.
            LOOP AT ls_reported_deep2-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep2>).
              DATA(lv_result2) = <ls_reported_deep2>-%msg->if_message~get_text( ).

*              APPEND VALUE #( %key                = wa_buffer-key ) TO failed-zmm_payabstract .
              APPEND VALUE #(
*              %key                = wa_buffer-key
                              %state_area        = 'Error'
                               %msg              = new_message_with_text(
                                                           text   = lv_result2
                                                           severity = if_abap_behv_message=>severity-error )
                            %element-rabillno = if_abap_behv=>mk-on ) TO reported-zmm_payabstract .

              ...
            ENDLOOP.
          ELSE.
          ENDIF.
        ENDIF.
**********************************************************************************************
***************************************** Recovery Posting *************************************** 11.09.2024 by SJ
        CLEAR: counter.
        DATA: lv_totalsuppamt_n TYPE zmm_rabill_pay_abstract_adpost-thisbill.
        DATA: lv_glcode_n TYPE c LENGTH 20.
        DATA: count1 TYPE n LENGTH 6.

        SELECT * FROM zmm_rabill_pay_abstract_recov
        WHERE rabillno = @wa_buffer-rabillno
        AND   thisbill <> '0.00'
        AND itm_code NE 'TDSA'
        INTO TABLE @it_recpost.

        delete it_recpost WHERE TaxCode is INITIAL.
        IF it_recpost IS NOT INITIAL.

          READ TABLE it_recpost INTO wa_recpost INDEX 1.

          SELECT SINGLE * FROM  zmm_rabill_pay_abstract_recov  WHERE itm_code = 'TDSA' AND rabillno = @wa_buffer-rabillno INTO @DATA(wa_rectds).
          SELECT SINGLE ReconciliationAccount FROM zmm_supp_gl WHERE supplier = @wa_recpost-Supplier INTO @DATA(Supplier_gl4) .
          DATA: lt_je_deep_n TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post.
          TRY.
              lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
            CATCH cx_uuid_error.
              ASSERT 1 = 0.
          ENDTRY.

          LOOP AT it_recpost INTO DATA(wa_recamt) WHERE rabillno = wa_recpost-rabillno.
            counter = counter + 1.
            lv_totalsuppamt_n = lv_totalsuppamt_n + wa_recamt-thisbill.
            wa_recamt-counter = counter.
            wa_recamt-thisbill = wa_recamt-thisbill * ( -1 ).
            lv_glcode_n = | { '00' } | && | { wa_recamt-gl_code } |.
            CONDENSE lv_glcode_n NO-GAPS.
            wa_recamt-gl_code = lv_glcode_n.
            CONDENSE wa_recamt-gl_code NO-GAPS.
            CLEAR:lv_glcode_n.
            lv_glcode_n = | { '00' } | && | { wa_recpost-HeaderGl } |.
            CONDENSE lv_glcode_n NO-GAPS.
            wa_recamt-headergl = lv_glcode_n.
            wa_recamt-TaxCode = wa_recamt-TaxCode.
            CONDENSE wa_recamt-headergl NO-GAPS.
            MODIFY it_recpost FROM wa_recamt TRANSPORTING counter gl_code headergl thisbill taxcode.
            CLEAR:wa_recamt,lv_glcode_n.
          ENDLOOP.
          lv_totalsuppamt_n = lv_totalsuppamt_n - wa_rectds-thisbill.

          counter = counter + 1.
          count1 = counter + 1.

          DATA(wa_supp1) =  wa_recpost.
          wa_supp1-thisbill =  lv_totalsuppamt_n.
          wa_supp1-Counter =  counter  .
          wa_supp1-SpecialGL = ''  .
          wa_supp1-gl_code = supplier_gl4.
          wa_supp1-Remarks = l_advrec."'Advance Recovery'  .     ##NO_TEXT
          APPEND  wa_supp1 TO it_recpost .
          CONDENSE count1 NO-GAPS.
          APPEND INITIAL LINE TO lt_je_deep_n ASSIGNING FIELD-SYMBOL(<je_deep_n>).
          <je_deep_n>-%cid = lv_cid.
          <je_deep_n>-%param = VALUE #(
           companycode = wa_recpost-companycode "'1000' " Success
           documentreferenceid = wa_recpost-vendorinvoice "'BKPFF'
           createdbyuser = sy-uname
           businesstransactiontype = 'RFBU'
           accountingdocumenttype = 'KA'
           documentdate = wa_recpost-billdate "sy-datlo
           postingdate = wa_recpost-postingdate "sy-datlo
           taxdeterminationdate  = sydatum
           accountingdocumentheadertext = 'Advance Recovery'  ##NO_TEXT

          _glitems = VALUE #(

                               (              glaccountlineitem              = count1
                                              documentitemtext               = wa_rectds-Remarks
                                              glaccount                      = wa_rectds-gl_code
                                              profitcenter                   = wa_rectds-profitcenter
                                              businessplace                  = wa_rectds-businessplace
*                                              housebank                      = wa_rectds-housebankid
*                                              housebankaccount               = wa_rectds-accountid
                                             _currencyamount                  = VALUE #( ( currencyrole = '00' journalentryitemamount = wa_rectds-thisbill currency = 'INR' ) )
                                              )
                                        )

          _apitems =  VALUE #( FOR wa_recpost1 IN it_recpost  (
                                              glaccountlineitem  = wa_recpost1-counter
                                              supplier = wa_recpost1-supplier
                                              businessplace = wa_recpost1-businessplace
                                              profitcenter = wa_recpost1-profitcenter
***                                              housebank    = wa_recpost1-housebankid
***                                              housebankaccount = wa_recpost1-accountid
*                                              GLAccount = wa_recpost1-gl_code
                                              TaxCode = wa_recpost1-TaxCode       "" Added on 03.01.25
                                              BusinessSectionCode = wa_recpost1-SectionCode       ""Added on 6.11.2025
                                              DocumentItemText =  wa_recpost1-remarks
                                              SpecialGLCode = wa_recpost1-SpecialGL
                                              _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = wa_recpost1-thisbill
                                                                           TaxBaseAmount = wa_recpost1-thisbill currency = 'INR' ) )
                                              )
                                        )
                                ).
***********************"added on 03.01.2025 Advance recovery Posting with TDS********************************************************

*           _taxitems = VALUE #( FOR wa_recpost1 IN it_recpost (
*                                               glaccountlineitem  = wa_recpost1-counter
*                                               withholdingtaxtype = wa_advpost-withholdingtaxtype
*                                               withholdingtaxcode = wa_advpost-withholdingcode
*                                               _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = lv_totalsuppamt1  currency = 'INR' ) )
*                                               )
*                                         ).
****************************************************************************************************************************

          MODIFY ENTITIES OF i_journalentrytp    ##NO_PRIVILEGED
           ENTITY journalentry
           EXECUTE post FROM lt_je_deep_n
           FAILED DATA(ls_failed_deep_n)
           REPORTED DATA(ls_reported_deep_n)
           MAPPED DATA(ls_mapped_deep_n).
          IF ls_failed_deep_n IS NOT INITIAL.
            LOOP AT ls_reported_deep_n-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep_n>).
              DATA(lv_resultn) = <ls_reported_deep_n>-%msg->if_message~get_text( ).
              APPEND VALUE #(

                              %state_area        = 'Error'
                               %msg              = new_message_with_text(
                                                           text   = lv_resultn
                                                           severity = if_abap_behv_message=>severity-error )
                            %element-rabillno = if_abap_behv=>mk-on ) TO reported-zmm_payabstract .

              ...
            ENDLOOP.
          ELSE.
          ENDIF.
        ENDIF.


******************************added on 18.09.2023 Advance Posting***************************************
      ELSEIF lv_r NE '0'.

        CLEAR: counter.
        DATA: lv_totalsuppamt1 TYPE zmm_rabill_pay_abstract_adpost-thisbill.
        DATA: lv_tdsamt TYPE zmm_rabill_pay_abstract_adpost-thisbill.
        DATA: lv_glcode1 TYPE c LENGTH 20.
        DATA: count TYPE n LENGTH 6.

        SELECT * FROM zmm_rabill_pay_abstract_adpost
        WHERE rabillno = @wa_buffer-rabillno
        AND   thisbill <> '0.00'
        INTO TABLE @it_advpost.

        IF it_advpost IS NOT INITIAL.

          SELECT SINGLE * FROM zmm_payment_abstract_tds_adv WHERE ra_bill_no = @wa_buffer-rabillno INTO @DATA(lw_adv_tds).
          IF sy-subrc = 0.
            lv_tdsamt = ( lw_adv_tds-ztds / 100 ) * lw_adv_tds-Amount.
          ENDIF.

          READ TABLE it_advpost INTO wa_advpost INDEX 1.

          DATA: lt_je_deep1 TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post.
          TRY.
              lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
            CATCH cx_uuid_error.
              ASSERT 1 = 0.
          ENDTRY.
          counter = 1.
          LOOP AT it_advpost INTO DATA(wa_advamt) WHERE rabillno = wa_advpost-rabillno.
            counter = counter + 1.
            lv_totalsuppamt1 = lv_totalsuppamt1 + wa_advamt-thisbill.
            wa_advamt-counter = counter.
            wa_advamt-thisbill = wa_advamt-thisbill." * ( -1 ).
            lv_glcode1 = | { '00' } | && | { wa_advamt-gl_code } |.
            CONDENSE lv_glcode1 NO-GAPS.
            wa_advamt-gl_code = lv_glcode1.
            CONDENSE wa_advamt-gl_code NO-GAPS.
            CLEAR:lv_glcode1.
            lv_glcode1 = | { '00' } | && | { wa_advpost-HeaderGl } |.
            CONDENSE lv_glcode1 NO-GAPS.
            wa_advamt-headergl = lv_glcode1.
            CONDENSE wa_advamt-headergl NO-GAPS.
            MODIFY it_advpost FROM wa_advamt TRANSPORTING counter gl_code headergl thisbill.
            CLEAR:wa_advamt,lv_glcode1.
          ENDLOOP.
          counter = counter + 1.
          count = counter + 1.

          lv_totalsuppamt1 = lv_totalsuppamt1 - lv_tdsamt.
          lv_totalsuppamt1 = lv_totalsuppamt1 * ( -1 ).
          lv_tdsamt = lv_tdsamt * ( -1 ).
          DATA(wa_advtds) = wa_advpost.
          wa_advtds-thisbill = lv_tdsamt.
          wa_advtds-remarks = l_tdspay."'TDS Payable'.  ##NO_TEXT
          wa_advtds-Counter = counter.

          "" Added on 12.03.25 VijayM/KomalP """"
          data lv_hkont TYPE hkont.
          select SINGLE hkont from zfit_tax_gl WHERE taxcode = @wa_advtds-WithHoldingTaxType INTO @lv_hkont.
          if lv_hkont is NOT INITIAL.
          wa_advtds-gl_code = lv_hkont.
          ENDIF.
          wa_advtds-SpecialGL = ''.
          CONDENSE count NO-GAPS.
          APPEND INITIAL LINE TO lt_je_deep1 ASSIGNING FIELD-SYMBOL(<je_deep1>).
          <je_deep1>-%cid = lv_cid.
          <je_deep1>-%param = VALUE #(
           companycode = wa_advpost-companycode "'1000' " Success
           documentreferenceid = wa_advpost-vendorinvoice "'BKPFF'
           createdbyuser = sy-uname
           businesstransactiontype = 'RFBU'
           accountingdocumenttype = 'ZP'
           documentdate = wa_advpost-billdate "sy-datlo
           postingdate = wa_advpost-postingdate "sy-datlo
           taxdeterminationdate  = sydatum "sy-datlo
           accountingdocumentheadertext = 'Advance entry'  ##NO_TEXT

          _glitems = VALUE #(

                               (              glaccountlineitem              = 1
                                              documentitemtext               = 'Advance posting'  ##NO_TEXT
                                              glaccount                      = wa_advpost-headergl
                                              profitcenter                   = wa_advpost-profitcenter
                                              businessplace                  = wa_advpost-businessplace
                                              housebank                      = wa_advpost-housebankid
                                              housebankaccount               = wa_advpost-accountid
                                             _currencyamount                  = VALUE #( ( currencyrole = '00' journalentryitemamount = lv_totalsuppamt1 currency = 'INR' ) )
                                              )


                               (              glaccountlineitem              = 7
                                              documentitemtext               = wa_advtds-Remarks
                                              glaccount                      = wa_advtds-gl_code
                                              profitcenter                   = wa_advpost-profitcenter
                                              businessplace                  = wa_advpost-businessplace
                                              housebank                      = wa_advpost-housebankid
                                              housebankaccount               = wa_advpost-accountid
                                             _currencyamount                  = VALUE #( ( currencyrole = '00' journalentryitemamount = lv_tdsamt currency = 'INR' ) )
                                              )
                                        )

          _apitems =  VALUE #( FOR wa_advpost1 IN it_advpost  (
                                              glaccountlineitem               = wa_advpost1-counter
                                              supplier = wa_advpost1-supplier
                                              businessplace = wa_advpost1-businessplace
                                              profitcenter = wa_advpost1-profitcenter
                                              housebank    = wa_advpost1-housebankid
                                              housebankaccount = wa_advpost1-accountid
                                              GLAccount = wa_advpost1-gl_code
                                              specialglcode = wa_advpost1-SpecialGL
                                              DocumentItemText =  wa_advpost1-remarks
                                              BusinessSectionCode = wa_advpost1-SectionCode    ""Added on 6.11.2025
                                              taxcode       = 'AC'
                                              _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = wa_advpost1-thisbill  currency = 'INR' ) )
                                              )


                                        )

***********************"added on 27.09.2023 Advance Posting with TDS********************************************************
*
*           _withholdingtaxitems = VALUE #( (
*                                               glaccountlineitem = 1
*                                               withholdingtaxtype = wa_advpost-withholdingtaxtype
*                                               withholdingtaxcode = wa_advpost-withholdingcode
*                                               _currencyamount = VALUE #( ( currencyrole = '00'  journalentryitemamount = lv_totalsuppamt1  currency = 'INR' ) )
*                                               )
*                                         )


*            _withholdingtaxitems = VALUE #( FOR wa_advpost1 IN it_advpost (
*                                             glaccountlineitem   = wa_advpost1-counter   " <-- MUST MATCH AP ITEM
*                                             withholdingtaxtype = wa_advpost1-withholdingtaxtype
*                                             withholdingtaxcode = wa_advpost1-withholdingcode
*                                             _currencyamount    = VALUE #(
*                                                ( currencyrole = '00'
*                                                  journalentryitemamount = wa_advpost1-thisbill * -1
*                                                  currency = 'INR' )
*                                             )
*                                           )
*                                          )

****************************************************************************************************************************
) .

          MODIFY ENTITIES OF i_journalentrytp   ##NO_PRIVILEGED
           ENTITY journalentry
           EXECUTE post FROM lt_je_deep1
           FAILED DATA(ls_failed_deep1)
           REPORTED DATA(ls_reported_deep1)
           MAPPED DATA(ls_mapped_deep1).
          IF ls_failed_deep1 IS NOT INITIAL.


            LOOP AT ls_reported_deep1-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep1>).
              DATA(lv_result1) = <ls_reported_deep1>-%msg->if_message~get_text( ).

*              APPEND VALUE #( %key                =  wa_buffer-key ) TO failed-zmm_payabstract .
              APPEND VALUE #(
*               %key                =  wa_buffer-key
                              %state_area        = 'VALIDATE'
                              %msg              = new_message_with_text(
                                                           text   = lv_result1

                                                           severity = if_abap_behv_message=>severity-error )
                              ) TO reported-zmm_payabstract .


            ENDLOOP.

            DATA(lv_failed_count) = lines( failed-zmm_payabstract ).
            DATA(lv_reported_count) = lines( reported-zmm_payabstract ).

          ELSE.
          ENDIF.
        ENDIF.
      ENDIF.
************************************************************************************************************
    ENDIF.
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
