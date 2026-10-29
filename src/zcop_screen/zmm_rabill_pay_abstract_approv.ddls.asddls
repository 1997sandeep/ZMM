@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Abstract Approval View'
define root view entity ZMM_RABILL_PAY_ABSTRACT_APPROV
//  with parameters
//    p_werks : werks_d
  as select from zmmt_scp_pa_appr
{
  key werks     as Werks,
  key app_level as AppLevel,
      username  as Username
}
//where
//  werks = $parameters.p_werks
group by werks,app_level,username
