class TranscriptionRecord{
    final int? id;               //Unique Id(primary key).Null before it is saved.
    final String fileName;       //Name of the file eg. "meeting_notes.m4a".
    final String filePath;       //where the audio file lives on the phone.
    final String transcription;  //The transcribed text from gemini is stored here.
    final DateTime dateCreated;   //When was the file created?
    final bool isAccidental;     //Did we flag it as a [GARBAGE_AUDIO]

    TranscriptionRecord({
        this.id,
        required this.fileName,
        required this.filePath,
        required this.transcription,
        required this.dateCreated,
        this.isAccidental = false,
    }); //This is a constructor.

    //The translator: Dart -> database
    Map<String,dynamic> toMap(){
        return{
            'id':id,
            'fileName':fileName,
            'filePath':filePath,
            'transcription':transcription,
            'dateCreated':dateCreated.toIso8601String(),//Since SQLite doesn't have a Date type we store it as a standard string(ISO 8601). For that the functioned is called from the DateTime class in Dart.
            'isAccidental':isAccidental ? 1:0,// SQLite has no Boolean type, so we store 1 for true, 0 for false
        };
    }//Here Map is a class in dart which has a key value pair like we have in python.<Key,Value>

    //The translator: database -> Dart
    factory TranscriptionRecord.fromMap(Map<String,dynamic> map){
        return TranscriptionRecord(
            id:map['id'],
            fileName:map['fileName'],
            filePath:map['filePath'],
            transcription:map['transcription'],
            dateCreated:DateTime.parse(map['dateCreated']),
            isAccidental:map['isAccidental'] == 1,//Converts 1 back to true.
        );
    }
}