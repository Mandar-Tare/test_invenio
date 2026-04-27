const cds = require('@sap/cds');
const { employees } = cds.entities('anubhav.db.master');

module.exports= function(srv){
    srv.on('hello',function(req,res)
{   
    return "Hello" + req.data.name;
});

//Skipping the complete implementation generic handler topic returning hard coded data 

srv.on('READ','ReadEmployeeSrv',async (req,res) =>
{  //Example 1
    let results = [];
   results.push({"name" : "Mandar","Role" :"Consultant"});
    
    //Example 2 extracting top2 records
      //Get top 10 Records
    results = cds.tx(req).run(SELECT.from(employees).limit(10));

    //Get Records by Where condition
   results = await cds.tx(req).run(SELECT.from(employees).limit(10).where(
   {salaryAmount : {'>=' : 90000}})
);  

let totalsum =0;
   for( i =0;i<results.length;i++)
   {  
        
            totalsum += parseInt(results[i].salaryAmount);
   }

     results.splice(0,0,{"ID":"total" , "salaryAmount": totalsum});
    return totalsum;

})



}