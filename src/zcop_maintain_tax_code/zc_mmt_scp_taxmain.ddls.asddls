@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_MMT_SCP_TAXMAIN
  provider contract transactional_query
  as projection on ZR_MMT_SCP_TAXMAIN
{
  key TaxCode,
  key ItemCode,
  @Semantics.currencyCode: true
  CukyField,
  TaxPer,
  Description,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt
  
}
