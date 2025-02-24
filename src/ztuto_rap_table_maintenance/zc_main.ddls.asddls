@EndUserText.label: 'Main - Maintain'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_Main
  as projection on ZI_Main
{
  key Id,
  Field1,
  Field2,
  @Consumption.hidden: true
  LastChangedAt,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _MainAll : redirected to parent ZC_Main_S,
  _MainText : redirected to composition child ZC_MainText,
  _Child1 : redirected to composition child ZC_Child1,
  _MainText.Description : localized
  
}
