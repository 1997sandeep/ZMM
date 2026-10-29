@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_MMT_SCP_BUSCODE
  provider contract transactional_query
  as projection on ZR_MMT_SCP_BUSCODE
{
  key Companycode,
  key Businessplace,
  Businessplacedesc,
  Localcreatedby,
  Localcreatedat,
  Locallastchangedby,
  Locallastchangedat,
  Lastchangedat
  
}
