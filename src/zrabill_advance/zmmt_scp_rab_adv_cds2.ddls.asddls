@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rabill advance'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMMT_SCP_RAB_ADV_CDS2 
  as select from zmmt_scp_tnc1 
{
    key ebeln,
    zwo_desc,
    cast(zwork_done as abap.dec( 13, 2 )) as zwork_done,
    cast(zmach_adv  as abap.dec( 13, 2 )) as zmach_adv,
    cast(zmat_adv   as abap.dec( 13, 2 )) as zmat_adv,
    cast(zmob_adv   as abap.dec( 13, 2 )) as zmob_adv,
    cast(zroylt     as abap.dec( 13, 2 )) as zroylt
}
