CLASS lhc_ZrMmtScpPaMas1 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR ZrMmtScpPaMas1 RESULT result.

ENDCLASS.

CLASS lhc_ZrMmtScpPaMas1 IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.
