namespace com.reuse;
// reusable types across all allfiles of my project
type Guid : String(32);

//aspect is like a structure 

aspect address{
    city : String(30);
    country : String(2);
    street : String(80);
}

