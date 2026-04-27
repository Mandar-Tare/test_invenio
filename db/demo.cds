namespace com.invenio; // defining namespace to make your project artifcats unique
using {com.reuse} from './reuse';
using {cuid,managed,temporal} from '@sap/cds/common';




context master{

    entity student : reuse.address {
        key id : reuse.Guid;
        name : String(80);
        // foreign key relation 
        class : Association to semester; // column name will be class_id
        backlog : Boolean;
        age : Int16;

    }
     entity semester {
        key id : String(32);
        semester : String(40);
        specialization :String(40);
        hod : String(80);

     }

     entity book {
        key id : reuse.Guid;
        name : String(80);
        author : String(90);
     }
}

//Creating another context
// temporal aspect tell when the book subscription validfrom or validto
// managed aspect will tell the data  Creation aspect
context trans{
    entity subs: cuid,temporal,managed{
        student : Association to master.student;
        book : Association to master.book;


    }
}
