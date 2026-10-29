@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Max RabillNo Date wise'
define root view entity ZMM_RABILL_PAY_ABSTRACT_MAX
  //    as select from zmmt_scp_ra_payi               as a
  as select from    ZMM_RABILL_PAY_ABSTRACT_MAXDAT as b
    left outer join zmmt_scp_ra_payi               as a on  b.Ebeln    = a.ebeln
                                                        and b.RaBillNo = a.ra_bill_no
  //                                                        and b.DateCreated = right(
  //      a.local_created_at, 8
  //    )

{
  key a.ra_bill_no                     as RaBillNo,
      //  key b.RaBillNo    as RaBillNo,
      a.ebeln                          as Ebeln,
      //      b.Ebeln       as Ebeln,
      a.sr_no_n                        as SrNo,
      a.sr_no_c                        as SrNumber,
      a.itm_code                       as ItemCode,
      @Semantics.amount.currencyCode: 'Currency'
      a.tax_per                        as Tax,
      a.zcurr                          as Currency,
      @Semantics.amount.currencyCode: 'Currency'
      a.uptodate                       as UpToDate,
      @Semantics.amount.currencyCode: 'Currency'
      a.uptolast                       as UpToPrevious,
      @Semantics.amount.currencyCode: 'Currency'
      a.thisbill                       as ThisBill,
      max(right(a.local_created_at,8)) as DateCreated,
      //      max(b.DateCreated) as DateCreated,
      a.advind                         as AdvInd
}
group by
  a.ra_bill_no,
  a.ebeln,
  a.sr_no_n,
  a.sr_no_c,
  a.itm_code,
  a.tax_per,
  a.zcurr,
  a.uptodate,
  a.uptolast,
  a.thisbill,
  a.advind
////  b.RaBillNo,
////  b.Ebeln
