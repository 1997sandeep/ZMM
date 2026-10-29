@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Secrion code'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_SECTION_CODE as select from zmmt_scp_buscode
{
  key companycode,
  key businessplace,
 case
    when companycode = '1000' and businessplace = 'DL01' then 'DLS1'
    when companycode = '1000' and businessplace = 'MH02' then 'MHS2'
    when companycode = '1000' and businessplace = 'RJ01' then 'ZRS1'
    when companycode = '1000' and businessplace = 'DL02' then 'DLS2'
    when companycode = '1000' and businessplace = 'RJ02' then 'ZRS2'
    when companycode = '1000' and businessplace = 'JK01' then 'JKS1'
    when companycode = '1000' and businessplace = 'GJ01' then 'GJS1'
    when companycode = '1000' and businessplace = 'TN01' then 'TNS1'
    when companycode = '1000' and businessplace = 'MN01' then 'MNS1'
    when companycode = '1000' and businessplace = 'UK01' then 'UKS1'
    when companycode = '1000'  and businessplace = 'AS01' then 'ASS1'
    when companycode = '1000' and businessplace = 'JH01' then 'JHS1'
    when companycode = '1000' and businessplace = 'PB01' then 'ZPS1'
    when companycode = '1000' and businessplace = 'RJ03' then 'ZRS3'
    when companycode = '1000' and businessplace = 'RJ04' then 'ZRS4'
    when companycode = '1000' and businessplace = 'RJ05' then 'ZRS5'
    when companycode = '1000' and businessplace = 'UP01' then 'UPS1'
    when companycode = '1000' and businessplace = 'UP02' then 'UPS2'
    when companycode = '1000' and businessplace = 'UP03' then 'UPS3'
    when companycode = '1000' and businessplace = 'UP04' then 'UPS4'
    when companycode = '1000' and businessplace = 'UP05' then 'UPS5'
    when companycode = '1000' and businessplace = 'UP06' then 'UPS6'
    when companycode = '1000' and businessplace = 'UP07' then 'UPS7'
    when companycode = '1000' and businessplace = 'MH01' then 'MHS1'
    when companycode = '1000' and businessplace = 'RJ12' then 'ZR12'
    when companycode = '1000' and businessplace = 'HR01' then 'HRS1'
    when companycode = '7002' and businessplace = 'PB02' then 'ZPS2'
    when companycode = '7003' and businessplace = 'RJ07' then 'ZRS7'
    when companycode = '7006' and businessplace = 'RJ13' then 'ZR13'
    when companycode = '7007' and businessplace = 'RJ09' then 'ZR09'
    when companycode = '8000' and businessplace = 'MH03' then 'MHS3'
    when companycode = '8002' and businessplace = 'RJ11' then 'ZRS11'
    else ''
  end as Sectioncode
}


