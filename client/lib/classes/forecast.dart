import 'package:intl/intl.dart';
import 'package:realm/realm.dart';
import 'package:client/classes/auth.dart';
import 'package:http/http.dart' as http;

import '../model.dart';
import 'client_transaction.dart';

part 'forecast.g.dart';

@RealmModel()
class _Forecast {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;

  late String uid;

  late String date;
  late double total;
  late double coffee;
  late double food;
  late double health;
  late double transit;
  late double grocery;
  late double shopping;
  late double bills;
}

class ForecastDB {
  static final ForecastDB _singleton = ForecastDB._internal();
  late Realm realm;

  factory ForecastDB() {
    return _singleton;
  }

  ForecastDB._internal();

  initF(User user) async {
    realm = Realm(Configuration.flexibleSync(user, [Forecast.schema]));
    realm.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions
          .add(realm.query<Forecast>("uid == '${Auth().currentUser!.uid}'"));
    });
    await realm.subscriptions.waitForSynchronization();
  }

  getForecast() {
    DateTime now = DateTime.now();
    String yearMonth = DateFormat('yyyy-MM').format(now);

    var forecast = realm.query<Forecast>(
        "uid == '${Auth().currentUser!.uid}' AND date == '$yearMonth'");
    if (forecast.isNotEmpty) {
      return forecast[0];
    } else {
      return addForecast();
    }
  }

  addForecast() async {
    var forecast = await callFetchForecast();
    if (forecast.isNotEmpty) {
      var total = forecast.values.fold(0.0, (sum, item) => sum + (item ?? 0.0));
      DateTime now = DateTime.now();
      String yearMonth = DateFormat('yyyy-MM').format(now);
      var f = Forecast(
          ObjectId(),
          Auth().currentUser!.uid,
          yearMonth,
          total,
          forecast['Coffee'],
          forecast['Food'],
          forecast['Health'],
          forecast['Transit'],
          forecast['Grocery'],
          forecast['Shopping'],
          forecast['Bills']);
      realm.write(() => {realm.add(f)});
      return f;
    }
    return null;
  }

  Future<dynamic> callFetchForecast() async {
    var client = http.Client();
    final transactionDB = TransactionDB();

    return await fetchForecast(client, transactionDB);
  }

  double getPropertyValue(String propertyName, Forecast forecast) {
    switch (propertyName) {
      case 'Food':
        return forecast.food;
      case 'Coffee':
        return forecast.coffee;
      case 'Transit':
        return forecast.transit;
      case 'Shopping':
        return forecast.shopping;
      case 'Health':
        return forecast.health;
      case 'Grocery':
        return forecast.grocery;
      case 'Bills':
        return forecast.bills;
      default:
        return 0.0;
    }
  }
}
