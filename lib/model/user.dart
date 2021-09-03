class User {
  String id;
  String firstName;
  String lastName;
  String email;
  String phoneNr;
  String imageAsset;
  DateTime birthDate;
  DateTime joinDate;
  double rating;
  int finishedOrders;
  double monthlyEarnings;
  double monthlyGoal;
  List<String> openRequestId;
  List<String> watchlist;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNr,
    this.imageAsset,
    this.birthDate,
    this.joinDate,
    this.rating,
    this.finishedOrders,
    this.monthlyEarnings,
    this.monthlyGoal,
    this.openRequestId,
    this.watchlist,
  });
}

List<User> user = <User>[
  User(
    id: 'AGxrlGybnE',
    firstName: 'Luce',
    lastName: 'Fiduccia',
    email: 'luce.fiduccia@gmail.com',
    phoneNr: '06641865358',
    imageAsset: 'assets/1.png',
    birthDate: DateTime.utc(2001, 6, 6),
    joinDate: DateTime.now(),
    rating: 2.3,
    finishedOrders: 21,
    monthlyEarnings: 323.2,
    monthlyGoal: 400,
    openRequestId: <String>['mAoDaAwiCr'],
    watchlist: <String>[],
  ),
  User(
    id: 'QxtOsjFoJp',
    firstName: 'Rene',
    lastName: 'Simon',
    email: 'matthias.mischa@gmail.com',
    phoneNr: '06641865358',
    imageAsset: 'assets/2.png',
    birthDate: DateTime.utc(1997, 6, 6),
    joinDate: DateTime.now(),
    rating: 3.4,
    finishedOrders: 18,
    monthlyEarnings: 232.2,
    monthlyGoal: 300,
    openRequestId: <String>['DgKpDwELdd'],
    watchlist: <String>[],
  ),
  User(
    id: 'NXGiuSwnqK',
    firstName: 'Fabian',
    lastName: 'Simon',
    email: 'fabian.simon@gmail.com',
    phoneNr: '06641865358',
    imageAsset: 'assets/3.png',
    birthDate: DateTime.utc(1998, 6, 6),
    joinDate: DateTime.now(),
    rating: 5.0,
    finishedOrders: 30,
    monthlyEarnings: 523.24,
    monthlyGoal: 500,
    openRequestId: <String>['XokoOMXmbC'],
    watchlist: <String>['DgKpDwELdd', 'mAoDaAwiCr'],
  ),
];
User mainUser = User(
  id: 'NXGiuSwnqK',
  firstName: 'Fabian',
  lastName: 'Simon',
  email: 'fabian.simon@gmail.com',
  phoneNr: '06641865358',
  imageAsset: 'assets/3.png',
  birthDate: DateTime.utc(1998, 6, 6),
  joinDate: DateTime.now(),
  rating: 5.0,
  finishedOrders: 30,
  monthlyEarnings: 300.24,
  monthlyGoal: 500,
  openRequestId: <String>['XokoOMXmbC'],
  watchlist: <String>['DgKpDwELdd', 'mAoDaAwiCr'],
  // watchlist: [""],
);
