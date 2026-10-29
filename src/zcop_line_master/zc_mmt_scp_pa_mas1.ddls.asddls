@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_MMT_SCP_PA_MAS1
  provider contract transactional_query
  as projection on ZR_MMT_SCP_PA_MAS1
{
  key SrNoN,
  SrNoC,
  ItmCode,
  Description,
  GlCode,
  Shkzg,
  Umskz,
  Deduction,
  Manual,
  Addition,
  @Semantics.currencyCode: true
  CukyField,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt
  
}
