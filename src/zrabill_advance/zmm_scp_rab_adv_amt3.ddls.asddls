@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MM - Advance Max amount'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zmm_scp_rab_adv_amt3 
as select from zmm_scp_rab_adv_amt2
{
    key Ebeln,
    zmob_adv * amt as zmob_adv,
    zmach_adv * amt as zmach_adv,
    zmat_adv * amt as zmat_adv,
    zwork_done * amt as zwork_done,
    zroylt * amt as zroylt,
    amt
}
