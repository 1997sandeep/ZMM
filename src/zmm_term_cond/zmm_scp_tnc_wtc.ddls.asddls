@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Withholding Tax Code F4 help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_SCP_TNC_WTC
  as select from I_SupplierWithHoldingTax   as a1
    inner join   I_ExtendedWhldgTaxCodeText as a2 on a1.WithholdingTaxCode = a2.WithholdingTaxCode
{
  key a1.Supplier,
  key a1.WithholdingTaxCode,
      a1.WithholdingTaxType,
      a2.WhldgTaxCodeName
}
where
  a2.Language = 'E'
