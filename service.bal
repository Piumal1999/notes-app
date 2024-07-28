import ballerina/http;

service /notebook on new http:Listener(9090) {

    resource function get notes() returns Note[]|error {
        return notesTable.toArray();
    }

    resource function post notes(@http:Payload Note note)
                                    returns Note|ConflictingIdError {

        if (notesTable.hasKey(note.id)) {
            return {
                body: {
                    errmsg: "Note with the id already exists"
                }
            };
        } else {
            notesTable.add(note);
            return note;
        }
    }

    resource function get notes/[string id]() returns Note|InvalidIdError {
        Note? note = notesTable[id];
        if note is () {
            return {
                body: {
                    errmsg: string `Invalid Id: ${id}`
                }
            };
        }
        return note;
    }

    resource function put notes/[string id](@http:Payload Note note) returns Note|InvalidIdError {
        Note? existingNote = notesTable[id];
        if existingNote is () {
            return {
                body: {
                    errmsg: string `Invalid Id: ${id}`
                }
            };
        }

        existingNote.title = note.title;
        existingNote.content = note.content;
        existingNote.updatedDate = note.updatedDate;

        return existingNote;
    }

    resource function delete notes/[string id]() returns string|InvalidIdError {
        if (notesTable.hasKey(id)) {
            _ = notesTable.remove(id);
            return string `Note with id ${id} deleted successfully`;
        } else {
            return {
                body: {
                    errmsg: string `Invalid Id: ${id}`
                }
            };
        }
    }

}

public type Note record {|
    readonly string id;
    string title;
    string content;
    string createdDate;
    string updatedDate;
|};

public final table<Note> key(id) notesTable = table [
    {id: "1", title: "Hello World", content: "This is a quick note taken by me", createdDate: "2023-07-25", updatedDate: "2023-07-25"},
    {id: "2", title: "Shopping list", content: "Bread, Milk, Eggs, Butter", createdDate: "2023-07-25", updatedDate: "2023-07-25"},
    {id: "3", title: "Meeting Agenda", content: "Discuss the upcoming project, Ask for PR review", createdDate: "2023-07-24", updatedDate: "2023-07-25"}
];

public type ConflictingIdError record {|
    *http:Conflict;
    ErrorMsg body;
|};

public type InvalidIdError record {|
    *http:NotFound;
    ErrorMsg body;
|};

public type ErrorMsg record {|
    string errmsg;
|};
