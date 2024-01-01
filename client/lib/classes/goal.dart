import 'package:client/classes/badges.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';
import 'package:client/classes/auth.dart';

import '../notifications.dart';

part 'goal.g.dart';

@RealmModel()
class _Goal {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;

  late String uid;
  late double amount;
  late String date;
  late double progress;
  late String sDate;
  late String status;
}

class GoalDB {
  static final GoalDB _singleton = GoalDB._internal();
  late Realm realm;
  var b = BadgesDB();
  factory GoalDB() {
    return _singleton;
  }

  GoalDB._internal();

  initG(User user) async {
    realm = Realm(Configuration.flexibleSync(user, [Goal.schema]));
    realm.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions
          .add(realm.query<Goal>("uid == '${Auth().currentUser!.uid}'"));
    });
    await realm.subscriptions.waitForSynchronization();
  }

  getGoal() {
    var g = realm.query<Goal>("uid == '${Auth().currentUser!.uid}'");
    return g;
  }

  getSuccessGoals() {
    var g = realm.query<Goal>(
        "uid == '${Auth().currentUser!.uid}' AND status == 'Success'");
    return g;
  }

  setGoal(double goalAmount, String goalDate) {
    DateTime now = DateTime.now();
    var date = "${now.day}/${now.month}/${now.year}";

    var g = Goal(ObjectId(), Auth().currentUser!.uid, goalAmount, goalDate, 0.0,
        date, "null");
    realm.write(() {
      realm.add(g);
    });
  }

  editGoal(Goal g, [double? progress, double? amount, String? date]) {
    DateFormat format = DateFormat("dd/M/yyyy");
    DateTime d = format.parse(g.date);
    realm.write(() async {
      if (g.progress < 100 && g.status == "null") {
        g.amount = amount ?? g.amount;
        g.date = date ?? g.date;
        g.progress = progress ?? g.progress;
        if (DateTime.now().isAfter(d) || DateTime.now().isAtSameMomentAs(d)) {
          g.progress = 0.0;
          g.status = "Success";
          List<String> token = [await Notifications.getToken()];
          Notifications.sendNotification(
              'Congratulations',
              'You did it! You\'ve successfully achieved your goal. Keep up the good work and set new heights for yourself.',
              token);
        }
      }
      if (g.progress >= 100) {
        if (DateTime.now().isBefore(d)) {
          g.status = "Failure";
          g.progress = 100.0;
          List<String> token = [await Notifications.getToken()];
          Notifications.sendNotification(
              'Don\'t Be Discouraged!',
              'Falling short of your goal is a chance to learn and grow. Keep going, and success will follow your efforts.',
              token);
        }
      }
    });
  }

  deleteGoal(Goal g) {
    realm.write(() {
      realm.delete(g);
    });
  }
}
