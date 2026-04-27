using { anubhav.db.master,anubhav.db.transaction } from '../db/datamodel';
using {cappo.cds} from '../db/CDSViews';
service CatalogService @(path:'CatalogService')   
{
    entity EmployeSet as projection on master.employees;
    // entity AddressSet as projection on master.address;
    // entity BusinessPartnerSet as projection on master.businesspartner;
    // entity ProductSet as projection on master.product;
    entity POs  @(odata.draft.enabled: true) as projection on transaction.purchaseorder{
         *,
        Items,
        case OVERALL_STATUS
        when 'P' then 'Paid' 
        when 'A'  then 'Approved'
        when 'X'  then 'Rejected'
        when 'N'  then  'New'
        end as OVERALLSATUS : String(10),
        // @UI.Hidden : true annotation to hide columns on page 
      case OVERALL_STATUS
        when 'P' then 3
        when 'A'  then 3
        when 'X'  then 1
        when 'N' then  2
        end as ColorCode : Integer,
       }
    actions{  //Instance bound action  
     @Common.SideEffects: {
        TargetProperties: ['GROSS_AMOUNT','OVERALLSATUS']
    }
    // @Common.SideEffects #side:
    // {
    //     TargetProperties :['OVERALL_STATUS']
    // }
    
              
// Side effects are used to bring an update in the filed on UI While calling action. 
        
        action boost();
        action setOrderProcessing();
    };
    // non instance boud function 
    function getLargestOrder() returns POs;
    function getOrderDefaults()  returns POs;  // Set Status to Default N While Creating new record 
     
    entity POItems  as projection on transaction.poitems;

    entity BusinessPartnerSet as projection on master.businesspartner;
    entity ProductSet as projection on master.product;
    entity AddressSet as projection on master.address;
    // entity ProductCDS as projection on cds.CDSViews.ProductView
    // {
    //     *,
    //     To_Items
    // };
    // entity ItemView as projection on cds.CDSViews.ItemView;


}

