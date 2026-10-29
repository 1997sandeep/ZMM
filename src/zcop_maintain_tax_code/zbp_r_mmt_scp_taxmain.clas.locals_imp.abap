CLASS lhc_ZrMmtScpTaxmain DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR ZrMmtScpTaxmain RESULT result.

ENDCLASS.

CLASS lhc_ZrMmtScpTaxmain IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.
