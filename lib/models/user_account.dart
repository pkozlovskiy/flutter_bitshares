class UserAccount {
  final String id;
  final String name;

  UserAccount(this.id, this.name);

  UserAccount.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];
}
