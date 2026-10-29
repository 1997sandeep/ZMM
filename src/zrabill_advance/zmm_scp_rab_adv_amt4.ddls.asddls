@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MM - Advance Max amount'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zmm_scp_rab_adv_amt4 
as select from zmm_scp_rab_adv_amt3
{
    key Ebeln,
    cast( zmob_adv as abap.dec( 13,2 )) as zmob_adv,
    cast( zmach_adv as abap.dec( 13,2 )) as zmach_adv,
    cast( zmat_adv as abap.dec( 13,2 )) as zmat_adv,
    cast( zwork_done as abap.dec( 13,2 )) as zwork_done,
    cast( zroylt as abap.dec( 13,2 )) as zroylt,
    amt
}
