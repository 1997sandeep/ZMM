@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Max no for mb'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMB_NO_M as select from I_PurchaseOrderAPI01 as a
 left outer join zmeas_book_tbl as b on a.PurchaseOrder = b.ebeln 
{
 key a.PurchaseOrder as ebeln,
 max(b.mbno) as mbno   
}
group by a.PurchaseOrder
