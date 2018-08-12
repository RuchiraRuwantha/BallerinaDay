import ballerina/http;
import ballerina/log;
import ballerina/io; 

// By default, Ballerina exposes a service via HTTP/1.1.

endpoint http:Listener listener {
    port: 9090
};

endpoint http:Client clientListner {
   url: "http://b.content.wso2.com/"  
};

service<http:Service> hello bind listener {

    // Invoke all resources with arguments of server connector and request.
    sayHello(endpoint caller, http:Request req) {
        var queryParam = req.getQueryParams();
        int year =check <int>queryParam.year;

        io:print(year);

        var  backendResponse = clientListner->get("/sites/all/ballerina-day/sample.json");
        match backendResponse {
            http:Response response=> {
                json responseJson=check response.getJsonPayload();
                json filteredBooks=filterBooks(responseJson,year);
            _=caller->respond(untaint responseJson);
            }
            error responseError => {
                io:println(responseError.message);
            }
        }   
    }
}

function filterBooks (json bookStore, int yearParam) returns json{
    json books;
    int index;
    foreach book in bookStore.store.books {
        match book.year {
            int year => {
                if (year>1900) {
                    books[index] = book;
                    index++;
                }
            }
            any a =>{
                io:println("incorrect year:",a);
            }
        }
    }
      return books;  
}