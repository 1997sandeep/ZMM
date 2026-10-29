@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'purchase order f4'
@Metadata.ignorePropagatedAnnotations: true
define view entity zpo_no as select from I_PurchaseOrderAPI01 as a
    left outer join I_Supplier           as b on a.Supplier = b.Supplier
{
  key a.PurchaseOrder,
      b.SupplierName as PurchaseOrderType 
}
where  a.PurchaseOrderType = 'ZSER' or a.PurchaseOrderType = 'ZHRA' 
