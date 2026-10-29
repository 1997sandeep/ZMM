@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Withholding Tax Type F4 help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_SCP_TNC_WTT     as select from I_SupplierWithHoldingTax as a1
    inner join   I_ExtendedWhldgTaxCodeText as a2 on a1.WithholdingTaxCode = a2.WithholdingTaxCode
{
   key a1.Supplier,
   key a1.WithholdingTaxType,
       a1.WithholdingTaxCode,
       a2.WhldgTaxCodeName
}
where a2.Language = 'E'
