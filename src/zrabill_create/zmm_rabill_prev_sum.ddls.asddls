@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Sum of prev values of rabill'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_RABILL_PREV_SUM
  as select from zmmt_scp_rabill1 as a
{
  key  a.ebeln         as Ebeln,
  key  a.ebelp         as Ebelp,
       @Semantics.quantity.unitOfMeasure: 'uom'
       sum(a.this_act) as ThisAct,
       a.uom,
       a.del_flag      as DelFlag
}
where
  ebeln <> ''
group by
  a.ebeln,
  a.ebelp,
  a.uom,
  a.del_flag

union select from ZMM_RABILL_DETAIL
{
  key Ebeln,
  key Ebelp,
      sum(ThisAct) as ThisAct,
      uom,
      DelFlag
}
where
  Ebeln <> ''
group by
  Ebeln,
  Ebelp,
  uom,
  DelFlag
