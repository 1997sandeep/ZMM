@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lineitem wise tax calculation'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_RABILL_PAY_WO_TAX 
  as select distinct from zmmt_scp_rabill1               as a
    left outer join       I_PurchaseOrderItemAPI01       as b on a.ebeln = b.PurchaseOrder
    left outer join       I_PurOrdItmPricingElementAPI01 as c on  b.PurchaseOrder     = c.PurchaseOrder
                                                              and b.PurchaseOrderItem = c.PurchaseOrderItem
                                                              and c.ConditionType     = 'ZJEX'
    left outer join       zmmt_scp_taxmain               as d on c.TaxCode = d.tax_code

    left outer join       zmmt_scp_pa_mas1               as e on d.item_code = e.itm_code
    left outer join       zmmt_scp_rabill1               as f on  c.PurchaseOrder     = f.ebeln
                                                              and c.PurchaseOrderItem = f.ebelp
                                                              and a.rcount            = f.rcount
{
  key a.ra_bill_no                                                            as RaBillNo,
  key c.PurchaseOrder                                                         as Ebeln,
      c.PurchaseOrderItem                                                     as Ebelp,
      e.sr_no_n                                                               as SrNo,
      e.sr_no_c                                                               as SrNumber,
      e.itm_code                                                              as ItemCode,
      e.description                                                           as PaMasterDescription,
      c.TaxCode,
      e.gl_code                                                               as GLAcc,
      a.zcurr,
      @Semantics.amount.currencyCode : 'zcurr'
      d.tax_per                                                               as Rate,
      @Semantics.amount.currencyCode : 'zcurr'
      cast(0 as abap.curr( 13, 2 ))                                           as UpToDate,
      @Semantics.amount.currencyCode : 'zcurr'
      cast(0 as abap.curr( 13, 2 ))                                           as UpToPreviousBill,
      @Semantics.amount.currencyCode : 'zcurr'
      //     f.this_bill_amt               as ThisBill,
      cast( (cast(f.this_bill_amt as abap.dec( 13, 2 ))
      * (cast(d.tax_per as abap.dec( 6, 2 )) / 100  ) ) as abap.dec( 13, 2 )) as ThisBill,
      ''                                                                      as Remarks

}
where
  b.TaxCode <> ''
group by
  a.ra_bill_no,
  a.ebeln,
  a.ebelp,
  c.TaxCode,
  a.zcurr,
  c.PurchaseOrder,
  c.PurchaseOrderItem,
  d.tax_per,
  e.sr_no_n,
  e.sr_no_c,
  e.itm_code,
  e.description,
  f.this_bill_amt,
  e.gl_code
