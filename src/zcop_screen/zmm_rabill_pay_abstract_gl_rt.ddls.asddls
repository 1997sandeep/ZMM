@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fetch for GL posting REWO - RT'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_RABILL_PAY_ABSTRACT_GL_RT
  as select from    zmmt_scp_pa_h1           as a
    left outer join zmmt_scp_ra_payi         as b on a.ra_bill_no = b.ra_bill_no
                                                  and(
                                                    b.itm_code    = 'REWO'
//                                                                                                        or b.itm_code = 'GSTH'
                                                    //                                                    or b.itm_code = 'GSTS'
                                                    //                                                    or b.itm_code = 'SDHO'
                                                    //                                                    or b.itm_code = 'GSTD'
                                                    //                                                    or b.itm_code = 'TSDH'
                                                    //                                                    or b.itm_code = 'CTDH'
                                                    //                                                    or b.itm_code = 'HTDH'
//                                                                                                        or b.itm_code = 'MTRE'
//                                                                                                        or b.itm_code = 'OTH2'
//                                                                                                       or b.itm_code = 'DSEL'
//                                                                                                        or b.itm_code = 'OTDD'
                                                    //                                                    or b.itm_code = 'EXRH'
                                                  )
    left outer join I_PurchaseOrderItemAPI01 as e on a.ebeln = e.PurchaseOrder

{
  key a.ra_bill_no               as Rabillno,
      a.ebeln                    as Ebeln,
      a.lifnr                    as Supplier,
      upper(a.vendor_invoice)    as VendorInvoice,
      a.bill_date                as BillDate,
      a.post_date                as PostingDate,
      a.prctr                    as ProfitCenter,
      a.bupla                    as BusinessPlace,
      e.CompanyCode              as CompanyCode,
      cast('' as abap.numc( 6 )) as Counter,
      b.zcurr,
      b.itm_code,
      b.gl_code,
      case  b.gl_code
      when '60800010'  then 'B'
      when '61400020'  then 'G'
      when '61400030'  then 'C'
      end                        as SpecialGL,
      b.description              as Remarks,
      @Semantics.amount.currencyCode : 'zcurr'
      b.thisbill                 as thisbill,
      a.sectioncode              as SectionCode
}
where
  b.gl_code <> ''
group by
  a.ra_bill_no,
  a.ebeln,
  a.lifnr,
  a.vendor_invoice,
  a.bill_date,
  a.post_date,
  a.wekrs,
  a.bupla,
  e.CompanyCode,
  b.itm_code,
  b.description,
  b.gl_code,
  b.zcurr,
  a.prctr,
  b.thisbill,
  a.sectioncode
