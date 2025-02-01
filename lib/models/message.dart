class Message {
  final String? img;
  final String text;
  final bool isMe;

  Message({
    required this.img,
    required this.text,
    required this.isMe,
  });

  // Factory constructor to create an instance from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      isMe: json['isMe'],
      img: json['img'],
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isMe': isMe,
      'img': img
    };
  }
}
