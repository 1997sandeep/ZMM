@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_MMT_SCP_PA_APPR
  provider contract transactional_query
  as projection on ZR_MMT_SCP_PA_APPR
{
  key Werks,
  key AppLevel,
  Username,
  EmailId,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt
  
}
