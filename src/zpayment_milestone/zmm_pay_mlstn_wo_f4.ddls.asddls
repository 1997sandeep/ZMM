@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Milestone WO F4'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_PAY_MLSTN_WO_F4 
as select distinct from zmmt_scp_tnc1
{
    key ebeln as PurchaseOrder    
}
