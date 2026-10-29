@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Rabill validation data'
define root view entity ZMM_RA_BILL_NO_VAL
  as select from    ZMM_RA_BILL_DET          as a1
    left outer join      ZMM_RABILL_DETS          as a2 on  a1.Ebeln  = a2.Ebeln
                                                   and a1.Rcount = a2.Rcount
    left outer join I_ServiceEntrySheetAPI01 as a3 on  a2.ra_bill_no =  a3.ServiceEntrySheetName
                                                   and a3.IsDeleted  <> 'X'
{
  key a1.Ebeln,
      a1.Rcount,
      a2.ra_bill_from,
      a2.ra_bill_to,
      a2.ra_bill_no,
      a3.ServiceEntrySheet as sesno

}
where
  a2.del_flag <> 'X'

group by
  a1.Ebeln,
  a1.Rcount,
  a2.ra_bill_from,
  a2.ra_bill_to,
  a2.ra_bill_no,
  a3.ServiceEntrySheet
