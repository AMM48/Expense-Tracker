import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:realm/realm.dart';
import 'package:client/classes/auth.dart';

import '../notifications.dart';
import 'goal.dart';

part 'badges.g.dart';

@RealmModel()
class _Badges {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;

  late String uid;
  late String img;
  late String title;
  late String description;
  late int requiredGoals;
  late bool isUnlocked;
}

class BadgesDB {
  static final BadgesDB _singelton = BadgesDB._internal();
  late Realm realm;

  factory BadgesDB() {
    return _singelton;
  }

  BadgesDB._internal();

  initB(User user) async {
    realm = Realm(Configuration.flexibleSync(user, [Badges.schema]));
    realm.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions
          .add(realm.query<Badges>("uid == '${Auth().currentUser!.uid}'"));
    });
    await realm.subscriptions.waitForSynchronization();
    addBadges();
    listenToGoalChanges();
  }

  getBadges() {
    var badges = realm.query<Badges>("uid == '${Auth().currentUser!.uid}'");
    return badges;
  }

  getBadge(int num) {
    var badge = realm.query<Badges>(
        "uid == '${Auth().currentUser!.uid}' AND requiredGoals == '$num'");
    return badge[0];
  }

  addBadges() async {
    String content = await rootBundle.loadString('assets/badges.json');
    List<dynamic> badges = jsonDecode(content);
    var userBadges = getBadges();
    final g = GoalDB();
    final goals = g.getSuccessGoals();
    if (badges.length != userBadges.length) {
      for (Map<String, dynamic> badge in badges) {
        bool isUnlocked = goals.length >= badge["requiredGoals"];
        var b = Badges(
            ObjectId(),
            Auth().currentUser!.uid,
            badge["image"],
            badge["title"],
            badge["description"],
            badge["requiredGoals"],
            isUnlocked);
        realm.write(() {
          realm.add(b);
        });
      }
    }
  }

  unlockBadge(Badges badge) {
    realm.write(() {
      badge.isUnlocked = true;
    });
  }

  void listenToGoalChanges() {
    final g = GoalDB();
    final goals = g.getSuccessGoals();
    goals.changes.listen((changes) {
      if (goals.length.isOdd) {
        var badge = getBadge(goals.length);
        if (!badge.isUnlocked) {
          unlockBadge(badge);
        }
      }
    });
  }
}
