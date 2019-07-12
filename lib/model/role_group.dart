class RoleGroup {
  String id;
  String name;
  String description;

  RoleGroup({this.id, this.name, this.description});

  factory RoleGroup.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return RoleGroup(
        id: json['id'], name: json['name'], description: json['description']);
  }
}
