//@AbapCatalog.sqlViewName: 'ZMM_SCP_RABILL_I'
@AccessControl.authorizationCheck: #NOT_REQUIRED
//@AbapCatalog.compiler.compareFilter: true
@EndUserText.label: 'RA BILL Item table'
define view entity ZMM_SCP_RABILL_I
  as select distinct from zmmt_scp_pa_h1   as a
    left outer join       zmmt_scp_pa_aprl as c on  a.ra_bill_no  = c.ra_bill_no
                                                and c.appr_status = 'REJECT'
    left outer join       zmmt_scp_rab_rec as b on a.ra_bill_no = b.ra_bill_no
{
  key a.ra_bill_no            as RaBillNo,
      a.ebeln                 as Ebeln,
      //      b.PostedDocument as PostedDocument,
      a.zplant_name           as ZplantName,
      upper(a.zsupplier_name) as ZsupplierName,
      a.pan                   as Pan,
      a.gstin                 as Gstin,
      case c.appr_status
      when 'REJECT'
      then 'true'
      when 'APPROVE'
      then 'false'
      else 'true'
      end                     as flag,
      a.vendor_invoice                as InvNo,
      a.bill_date              as invdate

}
group by
  a.ra_bill_no,
  a.ebeln,
  //  b.PostedDocument,
  a.zplant_name,
  a.zsupplier_name,
  a.pan,
  a.gstin,
  c.appr_status,
  a.vendor_invoice,
  a.bill_date
