class Status {
  String id;
  String name;

  Status({this.id, this.name});

  static Status fromJson(map) {
    return Status(id: map['id'], name: map['statusName']);
  }

  static List<Status> fromJsonArray(List<Map<String, dynamic>> mapList) {
    List<Status> statuses = new List<Status>();
    mapList.forEach((map) {
      statuses.add(Status.fromJson(map));
    });
    return statuses;
  }
  bool operator ==(o) => o is Status && o.name == name;
  int get hashCode => name.hashCode;
}
