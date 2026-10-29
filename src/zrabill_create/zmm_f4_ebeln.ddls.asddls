@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 help for WO number'
//@Metadata.ignorePropagatedAnnotations: true
define root view entity zmm_f4_ebeln as select from    I_PurchaseOrderAPI01 as a
    left outer join I_Supplier           as b on a.Supplier = b.Supplier
{
  key a.PurchaseOrder,
      b.SupplierName as PurchaseOrderType,
      a.PurchaseOrderDate
}
where
     a.PurchaseOrderType = 'ZSER'


