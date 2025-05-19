class ChatModel {
  final String msg;
  final int chatIndex;
  final List<Map<String, dynamic>>? segments;

  ChatModel({
    required this.msg,
    required this.chatIndex,
    this.segments,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      msg: json["msg"],
      chatIndex: json["chatIndex"],
      segments: json["segments"] == null
          ? null
          : List<Map<String, dynamic>>.from(json["segments"]),
    );
  }

}