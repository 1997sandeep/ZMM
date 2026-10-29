@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Union Fetch Rabill No for Adv&Rec'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_RABILL_PAY_ABSTRACT_RABIL2
  as select from ZMM_RABILL_PAY_ABSTRACT_RABILL
{
  key RabillNo,
      Ebeln,
      RaBillFrom,
      RaBillTo
      
}
group by
  RabillNo,
  Ebeln, 
    RaBillFrom,
    RaBillTo

union select from ZMM_RABILL_PAY_ABSTRACT_RABIL1
{
  key RaBillNo,
      Ebeln,
      RaBillFrom,
      RaBillTo

}
group by
  RaBillNo,
  Ebeln,
      RaBillFrom,
      RaBillTo
  
