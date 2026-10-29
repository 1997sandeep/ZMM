@AbapCatalog.sqlViewName: 'ZMMRABILLPAYFS'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Display Rabill PayMent Abstract'
define view ZMM_RABILL_PAYABST_FRTSCR
  as select distinct from zmmt_scp_pa_h1   as a
    left outer join       zmmt_scp_rab_rec as c on a.ra_bill_no = c.ra_bill_no
{
  key a.ra_bill_no     as RaBillNo,
      a.ebeln          as Ebeln,
      a.zplant_name    as ZplantName,
      a.zsupplier_name as ZsupplierName,
      a.pan            as Pan,
      a.gstin          as Gstin,
      c.inv_no         as InvNo,
      c.inv_date       as invdate

}
group by
  a.ra_bill_no,
  a.ebeln,
  a.zplant_name,
  a.zsupplier_name,
  a.pan,
  a.gstin,
  c.inv_no,
  c.inv_date
