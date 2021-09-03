class PersonalInfo {
  String userId;
  String firstName;
  String lastName;
  String email;
  String phoneNr;
  String profilePic;
  DateTime birthdate;
  double monthlyEarnings;
  double rating;
  int finishedOrders;
  double monthlyGoal;
  List<String> openRequestId;
  List<String> openChatId;
  List<String> watchlistIds;

  PersonalInfo({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNr,
    this.profilePic,
    this.birthdate,
    this.monthlyEarnings,
    this.rating,
    this.finishedOrders,
    this.monthlyGoal,
    this.openRequestId,
    this.openChatId,
    this.watchlistIds,
  });
}
