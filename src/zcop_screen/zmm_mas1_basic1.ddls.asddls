@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Advance Data'
define root view entity ZMM_MAS1_BASIC1
  as select from    ZMM_RABILL_PAY_MAS1       as a
    left outer join ZMM_RABILL_PAY_RABILLNO_B as b on a.Blank = b.Blank //added on 25.09.2023
{
      //  key cast('' as abap.char( 14 ))  as RaBillNo,
      //  key cast('' as abap.char( 10 ))  as Ebeln,
  key b.RaBillNo                   as RaBillNo,
  key b.Ebeln                      as Ebeln,
  key a.SrNoN                      as SrNo,
      a.SrNoC                      as SrNumber,
      a.ItmCode                    as ItemCode,
      a.Description                as PaMasterDescription,
      cast(0 as abap.dec( 6, 2 ))  as Tax,
      a.GlCode                     as GlAcc,
      cast('' as abap.cuky( 5 ))   as zcurr,
      cast(0 as abap.dec( 15, 2))  as UpToDate,
      cast(0 as abap.dec( 15, 2 )) as UpToPreviousBill,
      cast(0 as abap.dec( 15, 2 )) as ThisBill,
      ''                           as Remarks,
      a.Umskz                      as Umskz
}
//where
//  Umskz = 'B'
group by
  a.SrNoN,
  a.SrNoC,
  a.Description,
  a.GlCode,
  a.ItmCode,
  b.RaBillNo,
  b.Ebeln,
  a.Umskz
