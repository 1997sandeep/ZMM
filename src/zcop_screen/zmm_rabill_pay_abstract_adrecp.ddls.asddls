@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fetch for Advance Recovery Posting'
define root view entity ZMM_RABILL_PAY_ABSTRACT_ADRECP
  as select from    zmmt_scp_pa_h1           as a
    left outer join zmmt_scp_ra_payi         as b on a.ra_bill_no = b.ra_bill_no
                                                  and(
                                                    b.itm_code    = 'RERT'
                                                    or b.itm_code = 'GSTP'
                                                    or b.itm_code = 'GSTG'
                                                    or b.itm_code = 'SDRE'
                                                    or b.itm_code = 'GSTR'
                                                    or b.itm_code = 'TSDR'
                                                    or b.itm_code = 'CTDR'
                                                    or b.itm_code = 'HTDR'
                                                    or b.itm_code = 'OTR1'
                                                    or b.itm_code = 'OTR2'
                                                    or b.itm_code = 'OTR3'
                                                    or b.itm_code = 'OTR4'
                                                    or b.itm_code = 'EXRR'
                                                    or b.itm_code = 'PEHO'
                                                    or b.itm_code = 'PEHR'
                                                  )
    left outer join I_PurchaseOrderItemAPI01 as e on a.ebeln = e.PurchaseOrder
    left outer join zmmt_scp_pa_mas1 as f on b.itm_code = f.itm_code

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
//      b.gl_code,
      f.gl_code,
      case  b.itm_code
      when 'ADMO'  then 'A'
      when 'ADMT'  then 'A'
      when 'ADMC'  then 'A'
      when 'ADWD'  then 'A'
      when 'RERT'  then 'B'
      when 'EXRR'  then 'O'
      when 'GSTP'  then 'G'
      when 'GSTG'  then 'O'
      when 'GSTR'  then 'O'
      when 'TSDR'  then 'O'
      when 'OTR1'  then 'G'
      when 'REMB'  then 'A'
      when 'REMT'  then 'A'
      when 'REWD'  then 'A'
      when 'EWMC'  then 'A'
      when 'REWO'  then 'B'
      when 'EXRH'  then 'O'
      when 'GSTH'  then 'G'
      when 'GSTS'  then 'O'
      when 'GSTD'  then 'O'
      when 'TSDH'  then 'O'
      when 'OTH1'  then 'O'
      when 'PEHO'  then 'C'
      when 'PEHR'  then 'B'
      end                        as SpecialGL,
////      case  b.gl_code
////      when '22000018'  then 'B'
////      when '21400003'  then 'G'
////      when '22500012'  then 'C'
////      end                        as SpecialGL,
      b.description              as Remarks,
      @Semantics.amount.currencyCode : 'zcurr'
      b.thisbill                 as thisbill,
      a.gl_acc                   as HeaderGl,
      a.hbkid                    as HouseBankID,
      a.hktid                    as AccountID,
      a.sectioncode as SectionCode
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
//  b.gl_code,
  b.zcurr,
  b.thisbill,
  a.gl_acc,
  a.hbkid,
  a.prctr,
  a.hktid,
    f.gl_code,
    a.sectioncode
