@AbapCatalog.sqlViewName: 'ZPODATA'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Relative data'
@Metadata.ignorePropagatedAnnotations: true
define view ZPO_DATAA
  as select from I_PurchaseOrderAPI01 as a
  association [0..1] to I_CompanyCode as _com  on a.CompanyCode = _com.CompanyCode
  association [0..1] to I_Supplier    as _SUPP on a.Supplier = _SUPP.Supplier

{
  key a.PurchaseOrder,
  key a.CompanyCode,
  key a.Supplier,
      a.CreationDate,
      _com.CompanyCodeName,
      _SUPP.SupplierName


}
