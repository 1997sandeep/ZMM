CLASS lhc_MeasurementBook_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR MeasurementBook_head RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR MeasurementBook_head RESULT result.

    METHODS create FOR MODIFY
       entities FOR CREATE MeasurementBook_head.

    METHODS update FOR MODIFY
       entities FOR UPDATE MeasurementBook_head.

    METHODS delete FOR MODIFY
       keys FOR DELETE MeasurementBook_head.

    METHODS read FOR READ
       keys FOR READ MeasurementBook_head RESULT result.

    METHODS lock FOR LOCK
       keys FOR LOCK MeasurementBook_head.

    METHODS rba_Item FOR READ
       keys_rba FOR READ MeasurementBook_head\_Item FULL result_requested RESULT result LINK association_links.

    METHODS cba_Item FOR MODIFY
       entities_cba FOR CREATE MeasurementBook_head\_Item.

ENDCLASS.

CLASS lhc_MeasurementBook_head IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

METHOD create.

LOOP AT entities ASSIGNING FIELD-SYMBOL(<FS>).

   DATA:it_aprl TYPE TABLE OF zmb_approval_t,
         wa_aprl TYPE zmb_approval_t.

    DATA: wa_syname TYPE sy-uname,
          lv_poval  TYPE zchar5,
          lv_ct     TYPE zmb_approval_t-app_level.
     DATA: lv_flag TYPE c LENGTH 1.

    DATA : lv_r     TYPE c LENGTH 1.

  data(sydatum1) = xco_cp=>sy->date( xco_cp_time=>time_zone->user )->as( xco_cp_time=>format->iso_8601_extended  )->value.
    data(syuzeit1) = xco_cp=>sy->time( xco_cp_time=>time_zone->user )->as( xco_cp_time=>format->iso_8601_extended  )->value.

    data sydatum type c LENGTH 8.
    data syuzeit type c LENGTH 8.

    CONCATENATE sydatum1+0(4) sydatum1+5(2) sydatum1+8(2) INTO sydatum.
    CONCATENATE syuzeit1+0(2) syuzeit1+3(2) syuzeit1+6(2) INTO syuzeit.

    CONCATENATE sydatum1+0(4) sydatum1+5(2) sydatum1+8(2) INTO sydatum.
      lv_flag = <FS>-flag.
*      ls_rabill_abst_h-ra_bill_no = <FS>-Mbno.
*      lv_poval = ls_rabill_abst_h-ra_bill_no+0(5).
*
*      IF  lv_poval CA '/'.
*        lv_r = ls_rabill_abst_h-ra_bill_no+0(1).
*        SPLIT ls_rabill_abst_h-ra_bill_no AT '/' INTO DATA(l_blnk) DATA(l_ponum).
*      ELSE.
*        lv_r = '0'.
*      ENDIF.

         wa_syname = sy-uname.
      IF lv_flag = 'A' OR lv_flag = 'R'.
        SELECT SINGLE FROM zmb_approval_t "#EC WARNOK
        FIELDS
        mbno,app_level
        WHERE user_name  = @wa_syname  "@sy-uname
        AND appr_status = 'INPROCESS'
        AND mbno = @<FS>-Mbno
        INTO  @DATA(wa_approver_d).                     "#EC CI_NOORDER
        IF lv_flag = 'A'.
         UPDATE zmb_approval_t SET appr_status = 'APPROVE',
                                      remark      = @<FS>-remark
          WHERE user_name  = @wa_syname "sy-uname
          AND appr_status = 'INPROCESS'
          AND  mbno = @<FS>-Mbno.
          lv_ct = wa_approver_d-app_level + 1.
          CONDENSE lv_ct NO-GAPS.
*          CONDENSE ls_rabill_abst_h-ra_bill_no NO-GAPS.
          .
          SELECT SINGLE mbno FROM zmb_approval_t
            WHERE  mbno = @<FS>-Mbno
            AND app_level = @lv_ct
            INTO  @DATA(wa_approver).
          IF sy-subrc EQ 0.
            UPDATE zmb_approval_t SET appr_status = 'INPROCESS',
                                        zdate = @sydatum,
                                        ztime = @syuzeit
            WHERE mbno = @<FS>-Mbno
            AND app_level EQ @lv_ct.
*endif.
          ELSE.
            lv_flag = 'P'.

            SELECT SINGLE * FROM zmeas_book_h_tbl             "#EC WARNOK
             WHERE  mbno = @<FS>-Mbno
             INTO @DATA(wa_finalapprover).
            IF wa_finalapprover IS NOT INITIAL.
              wa_finalapprover-appr = 'A'.
              MODIFY zmeas_book_h_tbl FROM @wa_finalapprover.
            ENDIF.

          ENDIF.
        ELSEIF lv_flag = 'R' .
          UPDATE zmb_approval_t SET appr_status = 'REJECT'
*                                      remark      = @<ls_rabill_abst_h>-remarks
         WHERE user_name  = @wa_syname "sy-uname
         AND appr_status = 'INPROCESS'
         AND mbno = @<FS>-Mbno.
        ENDIF.
      ENDIF.



IF lv_flag = ''.

  SELECT SINGLE
  FROM
  zmeas_book_h_tbl
  FIELDS
  ebeln,
  MAX( mbno ) as mbno
  WHERE ebeln = @<FS>-Ebeln
  GROUP BY ebeln
  into @data(chk_mb).

  SELECT SINGLE
  FROM
  zmmt_scp_rabill1
  FIELDS
  ebeln,
  MAX( ra_bill_no ) as rabillno
  WHERE ebeln = @<FS>-Ebeln
  GROUP BY ebeln
  into @data(chk_rabill).

  DATA(lv_result) = substring_after( val = chk_mb-mbno sub = 'MB0' ).
  DATA(lv_result1) = substring_after( val = chk_rabill-rabillno sub = '/' ).

  if lv_result NE lv_result1  .



  APPEND VALUE #( %tky = <fs>-%key  ) TO failed-measurementbook_head .
  APPEND VALUE #( %tky = <fs>-%key
                                   %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text = | PLease first Create RABill | )
                                                               %element-ebeln = if_abap_behv=>mk-on )  TO reported-measurementbook_head.
 RETURN.
ENDIF.


data : it_tbl type TABLE of zmeas_book_h_tbl,
        wa_t  type zmeas_book_h_tbl.


        wa_t-ebeln = <FS>-Ebeln.
        wa_t-companycode = <FS>-Companycode.
        wa_t-plant = <FS>-Plant.
        wa_t-mbno = <FS>-Mbno.
        wa_t-headertext = <FS>-Headertext.
        wa_t-datesform = <FS>-Datesform.
        wa_t-datesto = <FS>-Datesto.
        wa_t-supplier = <FS>-Supplier.
        wa_t-woamt = <FS>-Woamt.
        WA_T-zrcount  = <fs>-Mbno+13(1).
         WA_T-zdms               = <fs>-dms.
         WA_T-zfile               = <fs>-FileNo.
      WA_T-zmimetype           = <fs>-MimeType.
      WA_T-zfilename           = <fs>-FileName.

        cONCATENATE sydatum+6(2) sydatum+4(2) sydatum+0(4) INTO wa_t-zdate SEPARATED BY '/'.

     MODIFY zmeas_book_h_tbl FROM @wa_t.
   "for approval level

        SELECT app_level,werks,username,userid FROM zmm_main_ra_t
        WHERE werks = @<fs>-Plant
        INTO TABLE @DATA(it_approver).

        LOOP AT it_approver INTO DATA(wa_appr).
          IF wa_appr-app_level = '1'.
            wa_aprl-appr_status = 'INPROCESS'.
            wa_aprl-zdate = sydatum.
            wa_aprl-ztime = syuzeit.
          ENDIF.

         wa_aprl-mbno = <fs>-Mbno.
          wa_aprl-user_name = wa_appr-userid.
          wa_aprl-app_level = wa_appr-app_level.
*          APPEND:wa_aprl TO it_aprl.
          MODIFY zmb_approval_t from @wa_aprl.
          CLEAR:wa_aprl,wa_appr.
ENDLOOP.
endif.
ENDLOOP.

  ENDMETHOD.

  METHOD update.
   if 1 = 1.
  endif.
  ENDMETHOD.

  METHOD delete.
  if 1 = 1.
  endif.
  ENDMETHOD.

  METHOD read.
   if 1 = 1.
  endif.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Item.

LOOP AT association_links ASSIGNING FIELD-SYMBOL(<fs>).

  ENDLOOP.
  ENDMETHOD.

METHOD cba_Item.

LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<FS>).


LOOP AT <fs>-%target ASSIGNING FIELD-SYMBOL(<fs1>).



data : it_tbl type TABLE of zmeas_book_tbl,
        wa_item  type zmeas_book_tbl.
CLEAR wa_item.

if <fs1>-WoQty < <fs1>-MeasQty  .

DATA(lv_ebelp) = |{ <fs1>-ebelp  ALPHA = OUT }|.

APPEND VALUE #( %tky = <fs>-%tky  ) TO failed-measurementbook_item .
APPEND VALUE #( %tky = <fs>-%tky
                                   %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text = |{ <fs1>-ebelp  }-measured qty must not exceed WO qty. | )
                                                               %element-ebeln = if_abap_behv=>mk-on )  TO reported-measurementbook_item.
 RETURN.
ENDIF.

if <fs1>-WoQty < <fs1>-UptoDateBillQty  .

lv_ebelp = |{ <fs1>-ebelp  ALPHA = OUT }|.

APPEND VALUE #( %tky = <fs>-%tky  ) TO failed-measurementbook_item .
APPEND VALUE #( %tky = <fs>-%tky
                                   %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text = |{ <fs1>-ebelp  }-uptodate qty must not exceed WO qty. | )
                                                               %element-ebeln = if_abap_behv=>mk-on )  TO reported-measurementbook_item.
 RETURN.
ENDIF.



      "Key fields
      wa_item-ebeln = <fs1>-ebeln.
      wa_item-mbno  = <fs1>-mbno.
      wa_item-ebelp = <fs1>-ebelp.

      "Item fields
      wa_item-material            = <fs1>-material.
      wa_item-materialdes         = <fs1>-materialdes.
      wa_item-uom                 = <fs1>-uom.
      wa_item-wo_qty              = <fs1>-WoQty.
      wa_item-nos                 = <fs1>-nos.
      wa_item-length              = <fs1>-length.
      wa_item-width               = <fs1>-width.
      wa_item-hight               = <fs1>-hight.

   SELECT SINGLE from zmeas_book_tbl
   FIELDS
   ebeln,
   ebelp,
   sum( meas_qty )  as pre
   WHERE ebeln = @wa_item-ebeln
   and ebelp = @wa_item-ebelp
   GROUP BY ebelp , ebeln

    INTO @data(it_pre).
      wa_item-prev_bill_qty       = <fs1>-uptodatebillqty .
*      wa_item-prev_bill_qty       =   <FS1>-PrevBillQty .
*      wa_item-meas_qty            =  <fs1>-MeasQty.
      wa_item-meas_qty            =  <FS1>-MeasQty.
      wa_item-upto_date_bill_qty = <fs1>-uptodatebillqty.
*      wa_item-upto_date_bill_qty =  wa_item-prev_bill_qty  .
      wa_item-zcurr               = <fs1>-zcurr.
      wa_item-junction_no         = <fs1>-junctionno.
      wa_item-attchment           = <fs1>-attchment.
      wa_item-remarks             = <fs1>-remarks.
      wa_item-rcount  = <fs1>-Mbno+13(1).

      "Insert into database table
      INSERT zmeas_book_tbl FROM @wa_item.
      clear :it_pre.
ENDLOOP.
ENDLOOP.

ENDMETHOD.

ENDCLASS.

CLASS lhc_MeasurementBook_Item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
       entities FOR UPDATE MeasurementBook_Item.

    METHODS delete FOR MODIFY
       keys FOR DELETE MeasurementBook_Item.

    METHODS read FOR READ
       keys FOR READ MeasurementBook_Item RESULT result.

    METHODS rba_Head FOR READ
       keys_rba FOR READ MeasurementBook_Item\_Head FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_MeasurementBook_Item IMPLEMENTATION.

  METHOD update.
if 1 = 1.
ENDIF.

  ENDMETHOD.

  METHOD delete.
   if 1 = 1.
  endif.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Head.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_MEAS_BOOK_HEAD DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_MEAS_BOOK_HEAD IMPLEMENTATION.

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
