module.exports = cds.service.impl(async function (req,res) {

    const {POs,EmployeSet}  = this.entities; 

//Generic Handlers

   this.before('UPDATE',EmployeSet,(req)=>
{   
    console.log("aa gaya data" , req.data.salaryAmount);
    if(parseFloat(req.data.salaryAmount) >= 100000){
        req.error(500,"Requested Salary is not allowed")
    }
})

this.on('getOrderDefaults',(req,res)=>{
        return {
            "OVERALL_STATUS" : "N",
        };
 } ) 


 this.on('setOrderProcessing',POs,async req => {
    const tx = cds.tx(req);
    await tx.update(POs,req.params[0].ID).set({OVERALL_STATUS : 'A'})
 })


    this.on('boost',async function (req,res) {
        try{
             const ID = req.params[0];
             console.log("Hey Mandar you gave me id",JSON.stringify(ID));
             const tx = cds.tx(req);
             await tx.update(POs).with({
                GROSS_AMOUNT : {'+=': 2000}
             }).where(ID);
        }
        catch(error)
        {
                return Error + error.toString();
        }
     
    })

    this.on('getLargestOrder',async function (req,res) {
        try
        {
            const tx = cds.tx(req);
            //SELECT * FROM db ORDER BY aount desc

            const reply = await tx.read(POs).orderBy(
                {GROSS_AMOUNT:'desc'}
            ).limit(1);

            return reply;
        }catch(error)
        {
            console.log(error);

        }
    })

    
})