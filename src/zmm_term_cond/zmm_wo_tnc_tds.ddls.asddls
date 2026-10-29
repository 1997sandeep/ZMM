@AbapCatalog.sqlViewName: 'ZMM_TNC_TDS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for fetching tds value'
define view ZMM_WO_TNC_TDS  with parameters
    pwt : zwithtype,
    pwc : zwithcode
  as select from I_Extendedwhldgtaxcode
{
  key WithholdingTaxType ,
      WithholdingTaxCode,
      WithholdingTaxPercent
}
where
      WithholdingTaxCode = $parameters.pwc
  and WithholdingTaxType = $parameters.pwt
