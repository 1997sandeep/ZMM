@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Sum of prev values of rabill'
define root view entity ZMM_RABILL_PREV_SUM1
  as select from ZMM_RABILL_PREV_SUM
{
  key Ebeln,
  key Ebelp,
      @Semantics.quantity.unitOfMeasure: 'uom'
      sum(ThisAct) as ThisAct,
      uom,
      DelFlag
}
group by
  Ebeln,
  Ebelp,
  uom,
  DelFlag
