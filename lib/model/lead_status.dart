class LeadStatus {
  String id;
  String name;
  String description;

  LeadStatus({this.id, this.name, this.description});

  static LeadStatus fromJson(map) {
    return LeadStatus(
        id: map['id'], name: map['name'], description: map['description']);
  }

  static List<LeadStatus> fromJsonArray(List<Map<String, dynamic>> mapList) {
    List<LeadStatus> statuses = new List<LeadStatus>();
    mapList.forEach((map) {
      statuses.add(LeadStatus.fromJson(map));
    });
    return statuses;
  }

  bool operator ==(o) => o is LeadStatus && o.name == name;

  int get hashCode => name.hashCode;
}
