@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'max for Mb no'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMB_NO as select from zmeas_book_h_tbl
{
   key ebeln,
   max( mbno ) as mbno
}
group by ebeln
