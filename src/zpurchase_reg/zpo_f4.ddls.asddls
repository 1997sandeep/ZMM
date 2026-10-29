@AbapCatalog.sqlViewName: 'ZYPO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZPO_F4 as select from I_PurchaseOrderAPI01
{
    key PurchaseOrder
} group by PurchaseOrder
