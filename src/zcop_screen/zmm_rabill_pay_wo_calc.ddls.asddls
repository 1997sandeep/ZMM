@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for GTBQ MTRE'
define root view entity ZMM_RABILL_PAY_WO_CALC
  as select from ZMM_RABILL_PAY_WO_LINK_MTRE
{
  key RaBillNo,
  key Ebeln,
  key SrNo,
      SrNumber,
      zcurr,
      @Semantics.amount.currencyCode: 'zcurr'
      sum(GTBQ) as GTBQ,
      @Semantics.amount.currencyCode: 'zcurr'
      sum(MTRE) as MTRE,
      @Semantics.amount.currencyCode: 'zcurr'
      case
      when  ( MTRE is initial or MTRE is null )
      then GTBQ
      else
      (GTBQ) - (MTRE)
      end       as ThisBill
}
group by
  RaBillNo,
  Ebeln,
  SrNo,
  SrNumber,
  zcurr,
  MTRE,
  GTBQ
