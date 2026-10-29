@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'max ra bill for sitc'
@Metadata.ignorePropagatedAnnotations: true
define  root view entity ZRABILL_SITC1 as select from ZMM_RABILL_EDIT
{
     
    key Ebeln,
    max( RaBillNo ) as RaBillNo, 
  'X'
    as maxbill 
}
group by
    Ebeln


