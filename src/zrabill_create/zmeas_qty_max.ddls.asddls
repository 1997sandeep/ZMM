@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'max for Mb qty'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMEAS_QTY_MAX as select from zmeas_book_tbl
{
    key ebeln,
    key ebelp,
    max( mbno ) as mbno
       
}
group by
ebeln,
ebelp
