import ballerina/io;
import ballerina/http;
import ballerina/test;

http:Client testClient = check new ("http://localhost:9090");

// Before Suite Function

@test:BeforeSuite
function beforeSuiteFunc() {
    io:println("I'm the before suite function!");
}

// Test function to get all notes
@test:Config {}
function testGetAllNotes() returns error? {
    http:Response response = check testClient->get("/notebook/notes");
    test:assertEquals(response.statusCode, 200);
    json payload = check response.getJsonPayload();
    test:assertTrue(payload is json[]);
}

/// Test function to get a note by ID
@test:Config {}
function testGetNoteById() returns error? {
    http:Response response = check testClient->get("/notebook/notes/1");
    test:assertEquals(response.statusCode, 200);
    json payload = check response.getJsonPayload();
    test:assertEquals(payload.id, "1");
}

// Negative test function to get a note with invalid ID
@test:Config {}
function testGetNoteByInvalidId() returns error? {
    http:Response response = check testClient->get("/notebook/notes/5");
    test:assertEquals(response.statusCode, 404);
    json payload = check response.getJsonPayload();
    test:assertEquals(payload, {"errmsg": "Invalid Id: 5"});

}

// Test function to add a new note
@test:Config {}
function testAddNewNote() returns error? {
    Note newNote = {id: "4", title: "New Note", content: "Content of the new note", createdDate: "2024-07-29", updatedDate: "2024-07-29"};
    http:Response response = check testClient->post("/notebook/notes", newNote);
    test:assertEquals(response.statusCode, 201);
    json payload = check response.getJsonPayload();
    test:assertEquals(payload.id, "4");
}

// Negative test function to add a note with an existing ID
@test:Config {}
function testAddNoteWithExistingId() returns error? {
    Note duplicateNote = {id: "1", title: "Duplicate Note", content: "Content of the duplicate note", createdDate: "2024-07-29", updatedDate: "2024-07-29"};
    http:Response response = check testClient->post("/notebook/notes", duplicateNote);
    test:assertEquals(response.statusCode, 409);
    json payload = check response.getJsonPayload();
    test:assertEquals(payload, {"errmsg": "Note with the id already exists"});
}

// Test function to update an existing note
@test:Config {}
function testUpdateNote() returns error? {
    Note updatedNote = {id: "1", title: "Updated Title", content: "Updated content", createdDate: "2023-07-25", updatedDate: "2024-07-29"};
    http:Response response = check testClient->put("/notebook/notes/1", updatedNote);
    test:assertEquals(response.statusCode, 200);
    json payload = check response.getJsonPayload();
    test:assertEquals(payload, updatedNote.toJson());
}

// Negative test function to update a note with an invalid ID
@test:Config {}
function testUpdateNoteWithInvalidId() returns error? {
    Note nonExistentNote = {id: "5", title: "Non-existent Note", content: "Content of the non-existent note", createdDate: "2024-07-29", updatedDate: "2024-07-29"};
    http:Response response = check testClient->put("/notebook/notes/5", nonExistentNote);
    test:assertEquals(response.statusCode, 404);
    json payload = check response.getJsonPayload();
    test:assertEquals(payload, {"errmsg": "Invalid Id: 5"});
}

// Test function to delete a note by ID
@test:Config {}
function testDeleteNoteById() returns error? {
    http:Response response = check testClient->delete("/notebook/notes/3");
    test:assertEquals(response.statusCode, 200);
    string payload = check response.getTextPayload();
    test:assertEquals(payload, "Note with id 3 deleted successfully");
}

// Negative test function to delete a note with an invalid ID
@test:Config {}
function testDeleteNoteByInvalidId() returns error? {
    http:Response response = check testClient->delete("/notebook/notes/invalid");
    test:assertEquals(response.statusCode, 404);
    json payload = check response.getJsonPayload();
    test:assertEquals(payload, {"errmsg": "Invalid Id: invalid"});
}

// After Suite Function

@test:AfterSuite
function afterSuiteFunc() {
    io:println("I'm the after suite function!");
}
