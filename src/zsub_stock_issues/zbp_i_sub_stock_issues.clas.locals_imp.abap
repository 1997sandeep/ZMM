CLASS lhc_ZI_SUB_STOCK_ISSUES DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR zi_sub_stock_issues RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR zi_sub_stock_issues RESULT result.

    METHODS create FOR MODIFY
       entities FOR CREATE zi_sub_stock_issues.

    METHODS update FOR MODIFY
       entities FOR UPDATE zi_sub_stock_issues.

    METHODS delete FOR MODIFY
       keys FOR DELETE zi_sub_stock_issues.

    METHODS read FOR READ
       keys FOR READ zi_sub_stock_issues RESULT result.

    METHODS lock FOR LOCK
       keys FOR LOCK zi_sub_stock_issues.

ENDCLASS.

CLASS lhc_ZI_SUB_STOCK_ISSUES IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.

  loop at entities ASSIGNING FIELD-SYMBOL(<fs>).
  data : wa_header type zsub_stock_hea_t,
         wa_item type zsu_stock_item_t.

         wa_header-wo = <fs>-Wo.
         wa_header-plant = <fs>-Plant.
         wa_header-vendor = <fs>-Vendor.
         wa_header-sino = <fs>-Sino.
         wa_header-sidate = <fs>-Sidate.
         wa_header-remark = <fs>-Remark.


         wa_item-wo = <fs>-Wo.
         wa_item-sino = <fs>-Sino.
         wa_item-woitem = <fs>-Woitem.
         wa_item-material = <fs>-Material.
         wa_item-matdes = <fs>-Matdes.
         wa_item-issueqty = <fs>-Issueqty.
         wa_item-issuevalue = <fs>-Issuevalue.
         wa_item-movinggprice = <fs>-Movinggprice.
         wa_item-uom = <fs>-Uom.

      MODIFY zsub_stock_hea_t FROM @wa_header.
      MODIFY zsu_stock_item_t FROM @wa_item.



  ENDLOOP.

  ENDMETHOD.

  METHOD update.

   loop at entities ASSIGNING FIELD-SYMBOL(<fs>).
  data : wa_header type zsub_stock_hea_t,
         wa_item type zsu_stock_item_t.

         wa_header-wo = <fs>-Wo.
         wa_header-plant = <fs>-Plant.
         wa_header-vendor = <fs>-Vendor.
         wa_header-sino = <fs>-Sino.
         wa_header-sidate = <fs>-Sidate.
         wa_header-remark = <fs>-Remark.


         wa_item-wo = <fs>-Wo.
         wa_item-sino = <fs>-Sino.
         wa_item-woitem = <fs>-Woitem.
         wa_item-material = <fs>-Material.
         wa_item-matdes = <fs>-Matdes.
         wa_item-issueqty = <fs>-Issueqty.
         wa_item-issuevalue = <fs>-Issuevalue.
         wa_item-movinggprice = <fs>-Movinggprice.
         wa_item-uom = <fs>-Uom.

      MODIFY zsub_stock_hea_t FROM @wa_header.
      MODIFY zsu_stock_item_t FROM @wa_item.



  ENDLOOP.
  ENDMETHOD.

  METHOD delete.
  IF 1 = 1.
  ENDIF.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_SUB_STOCK_ISSUES DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_SUB_STOCK_ISSUES IMPLEMENTATION.

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
