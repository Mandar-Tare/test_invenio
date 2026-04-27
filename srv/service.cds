using {anubhav.db.master} from '../db/datamodel';

service MyService @(path:'MyService')
{
    function hello(name : String)  returns String;
    //@readonly -:This will make the entity read only
    @Capabilities : { Insertable:false,Deletable:false,Updatable:false} // We can set Capabilities 
    entity ReadEmployeeSrv as projection on master.employees
}