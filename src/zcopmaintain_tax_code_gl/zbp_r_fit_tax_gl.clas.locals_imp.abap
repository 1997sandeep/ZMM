CLASS lhc_ZR_FIT_TAX_GL DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.


    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR zr_fit_tax_gl RESULT result.

ENDCLASS.

CLASS lhc_ZR_FIT_TAX_GL IMPLEMENTATION.


  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.
