using {demo as db} from '../db/schema';
 
service CatalogService @(requires: 'authenticated-user') {
    @(
        odata.draft.enabled: true,
        restrict           : [
            {
                grant: '*',
                to   : ['AdminRole']
            },
            {
                grant: '*',
                to   : ['ManagerRole']
            },
        ]
    )
 
 
    entity Vendors  as projection on db.Vendors;
 
    entity Products as projection on db.Products;
    entity Orders   as projection on db.Orders;
 
}