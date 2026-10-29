@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Profir center F4'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_PAYABS_PRCTR
  as select from I_ProfitCenterText

{

  key ProfitCenter,
      ProfitCenterName,
      
      substring(ProfitCenter,7,4) as CompCode
      
}
