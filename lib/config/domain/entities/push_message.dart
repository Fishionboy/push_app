class PushMessage {

final String messageId;
final String title;
final String body;
final DateTime sendDate;
final Map<String, dynamic> ? data ;
final String? imageUrl;

  PushMessage({
    required this.messageId,
    required this.title,
    required this.body,
    required this.sendDate,
    required this.data,
    required this.imageUrl,
  });

@override
  String toString() {
    
    return '''
  Pushmesagge: $messageId,
  title :$title
  body :$body
  sendDate :$sendDate
  data :$data
  imageUrl :$imageUrl


 ''';
  }
}
