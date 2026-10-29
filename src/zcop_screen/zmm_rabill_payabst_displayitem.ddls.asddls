@AbapCatalog.sqlViewName: 'ZMMRABILLPAYDSPI'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Display Item Level Payment Abstract'
define view ZMM_RABILL_PAYABST_DISPLAYITEM
  //    with parameters parameter_name : parameter_type
  as select distinct from zmmt_scp_pa_h1   as h
    inner join            zmmt_scp_ra_payi as i on h.ra_bill_no = i.ra_bill_no
    inner join            zmmt_scp_pa_mas1 as b on i.sr_no_n = b.sr_no_n //added on 30.08.2023
{
  key h.ra_bill_no  as Rabillno,
      h.ebeln       as Ebeln,
      i.sr_no_n     as SrNo,
      i.sr_no_c     as SrNumber,
      i.description as PaMasterDescription,
      i.gl_code     as GlAcc,
      i.tax_per     as Tax,
      i.itm_code    as ItemCode,
      i.zcurr       as zcurr,
      @Semantics.amount.currencyCode : 'zcurr'
      i.thisbill    as thisbill,
      @Semantics.amount.currencyCode : 'zcurr'
      i.uptodate    as uptodate,
      @Semantics.amount.currencyCode : 'zcurr'
      i.uptolast    as uptolast,
      i.remarks     as remarks,
      b.umskz       as Calc, //added on 30.08.2023
      case b.manual
      when 'M'
      then 'true'
      when ''
      then case i.itm_code //b.itm_code
      when 'MTRE'
      then 'true'
      when 'REWO'
      then 'true'
      else 'false' end
      else
      'false'  end  as Edit
}
group by
  h.ra_bill_no,
  h.ebeln,
  i.itm_code,
  i.zcurr,
  i.thisbill,
  i.uptodate,
  i.uptolast,
  i.remarks,
  i.sr_no_n,
  i.sr_no_c,
  i.description,
  i.gl_code,
  i.tax_per,
  b.umskz,
  b.manual
