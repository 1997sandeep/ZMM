@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'company code f4'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCOMPANY_CODE_F4 as select from I_CompanyCode
{
  key CompanyCode  
}
