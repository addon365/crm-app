class LeadComment {
  final String type;
  final String comment;

  LeadComment({this.type, this.comment});

  Map<String, dynamic> toJson() {
    return {"type": type, "comment": comment};
  }

  static LeadComment fromJson(Map<String, dynamic> map) {
    return LeadComment(type: map["type"], comment: map["comment"]);
  }
}
