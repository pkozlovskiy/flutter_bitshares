class UserAccount {
  final String id;
  final String name;
  final bool isLtm;

  UserAccount(this.id, this.name, this.isLtm);

  UserAccount.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        isLtm = json['isLtm'];

  String getObjectId() {
    // return String.format(Locale.US, "%d.%d.%d", space, type, instance);
  }
}
