@AbapCatalog.sqlViewName: 'ZMMRABILLRCOUNTN'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZMM_RABILL_RCOUNT'
define view ZMM_RABILL_RCOUNTN as select from ZMM_RABILL_RCOUNT
{
    key ebeln,
    cast(rcount as abap.int2) as rcount,
    del_flag
}
