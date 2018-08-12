import ballerina/io;

function main (string... args) {
    string path="sample.json";

    io:ByteChannel byteChannel = io:openFile(path, io:READ);
    io:CharacterChannel ch=new io:CharacterChannel(byteChannel,"UTF8");

    json|error result = ch.readJson();

    json bookStore;
    match result {
        json j => {
          bookStore=j;  
        }
        error => {
            io:println("Error occured while reading the file");
            return;
        }
    }

    io:println(bookStore.store.name);
    io:println(bookStore["store"]["name"]);

}
