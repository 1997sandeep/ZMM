@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_MAIN_Rabill_APP_CDS
  provider contract transactional_query
  as projection on ZR_MAIN_Rabill_APP_CDS
{
  key Werks,
  key AppLevel,
  Userid,
  Username,
  EmailId,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt
  
}
