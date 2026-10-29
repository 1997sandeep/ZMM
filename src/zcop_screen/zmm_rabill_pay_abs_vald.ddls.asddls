@AbapCatalog.sqlViewName: 'ZMMRABILLVALD'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RaBill No Validation'
define view ZMM_RABILL_PAY_ABS_VALD
//    with parameters parameter_name : parameter_type
as select distinct from zmmt_scp_pa_h1 as a
{
    key a.ra_bill_no as RaBillNo
} where a.ra_bill_no <> ''
group by a.ra_bill_no
