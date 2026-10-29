@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Milestone Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_PAY_MLSTN_H 
  as select from I_PurchaseOrderAPI01         as a1
    inner join   I_PurchaseOrderItemAPI01     as a2 on a1.PurchaseOrder = a2.PurchaseOrder
    inner join   I_Supplier                   as a3 on a1.Supplier = a3.Supplier
    inner join   I_PlantStdVH                 as a4 on a2.Plant = a4.Plant
    inner join   I_PurchasingDocumentTypeText as a5 on a1.PurchaseOrderType = a5.PurchasingDocumentType
    left outer join I_PurOrdAccountAssignmentAPI01 as a9 on a1.PurchaseOrder = a9.PurchaseOrder
    left outer join I_EnterpriseProjectElement_2   as a6  on a9.WBSElementInternalID_2 = a6.WBSElementInternalID
    left outer join I_Businesspartnertaxnumber as a7  on  a1.Supplier = a7.BusinessPartner
                                                      and a7.BPTaxType = '9IN2' 
    left outer join I_Businesspartnertaxnumber as a8  on  a1.Supplier = a8.BusinessPartner
                                                      and a8.BPTaxType = '9IN3' 
    left outer join I_EnterpriseProject        as a10 on  a6.ProjectInternalID = a10.ProjectInternalID
    left outer join zmmt_scp_tnc1              as b   on  a1.PurchaseOrder = b.ebeln

{
  key a1.PurchaseOrder,
      @EndUserText.label: 'Vendor'
      a1.Supplier,
      a1.PurchaseOrderType,
      a2.Plant,
      a3.SupplierName,
      @EndUserText.label: 'Vendor Name'
      a3.SupplierFullName,
      a3.VATRegistration,
      a3.TaxNumber1,
      a3.BusinessPartnerPanNumber as TaxNumber2,
//      a7.BPTaxNumber as TaxNumber2,
      a3.TaxNumber3,
//      a8.BPTaxNumber as TaxNumber3,
      a3.Region,
      a3.OrganizationBPName1,
      a3.OrganizationBPName2,
      a3.CityName,
      a3.PostalCode,
      a3.StreetName,
      a3.Country,
      a4.PlantName,
      a5.PurchasingDocumentTypeName,
      a10.ProjectDescription,
      b.zwo_desc as ZwoDesc
      
}
where
    ( a1.PurchaseOrderType =  'ZP05')
  and 
      a2.Plant             <> ''
  and a5.Language          =  'E'
  and a5.PurchasingDocumentCategory = 'F'
group by
  a1.PurchaseOrder,
  a1.Supplier,
  a1.PurchaseOrderType,
  a2.Plant,
  a3.SupplierName,
  a3.SupplierFullName,
  a3.VATRegistration,
  a3.TaxNumber1,
  a3.TaxNumber2,
  a3.TaxNumber3,
  a3.Region,
  a3.OrganizationBPName1,
  a3.OrganizationBPName2,
  a3.CityName,
  a3.PostalCode,
  a3.StreetName,
  a3.Country,
  a4.PlantName,
  a5.PurchasingDocumentTypeName,
  a10.ProjectDescription,
  a7.BPTaxNumber,
  a8.BPTaxNumber,
    b.zwo_desc,
    a3.BusinessPartnerPanNumber
