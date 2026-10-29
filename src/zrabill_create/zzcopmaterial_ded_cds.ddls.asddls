@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Deduction'
@Metadata.ignorePropagatedAnnotations: true
define view entity Zzcopmaterial_ded_CDS as select from zmmt_scp_rabill1
{
     key ra_bill_no,
         ebeln,
         deduction1,
         remark1
} //where Deduction1 <> 0.00

