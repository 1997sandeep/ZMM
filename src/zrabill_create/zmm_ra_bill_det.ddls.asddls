@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rabill no details'
define root view entity ZMM_RA_BILL_DET
  as select from ZMM_RAB_RCOUNT_MAX
{
  key ebeln        as Ebeln,
      max (rcount) as Rcount
}
where
  del_flag <> 'X'
group by
  ebeln
// rcount
