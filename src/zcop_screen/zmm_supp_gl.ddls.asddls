@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier GL'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_SUPP_GL
  as select from I_SupplierCompany
{
  key Supplier,
      ReconciliationAccount
}
group by
  Supplier,
  ReconciliationAccount
