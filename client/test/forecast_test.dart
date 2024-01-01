import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:client/classes/forecast.dart' as f;
import 'package:realm/realm.dart';
import 'models_test.mocks.dart';
import 'forecast_test.mocks.dart';

@GenerateMocks([f.ForecastDB])
void main() {
  test("Get Forecast", () async {
    final transactionDB = MockTransactionDB();
    final forecastDB = MockForecastDB();
    when(forecastDB.getForecast()).thenAnswer((_) async => Future.value([
          f.Forecast(ObjectId(), '1', '30/10/2023', 4613.85, 349.86, 358.34,
              133.63, 384.02, 1084.63, 1630.24, 673.11)
        ]));
    when(transactionDB.initT()).thenAnswer((_) async => 'Stub');
    var list = await forecastDB.getForecast();
    verify(forecastDB.getForecast()).called(1);
    expect(list, isA<List<f.Forecast>>());
    expect(list.first.coffee, 349.86);
    expect(list.first.food, 358.34);
    expect(list.first.health, 133.63);
    expect(list.first.transit, 384.02);
    expect(list.first.grocery, 1084.63);
    expect(list.first.shopping, 1630.24);
    expect(list.first.bills, 673.11);
    expect(list.first.total, 4613.85);
  });

  test("Add Forecast", () async {
    final forecastDB = MockForecastDB();
    when(forecastDB.addForecast()).thenAnswer((_) async => {});
    var result = await forecastDB.addForecast();
    expect(result, isA<Map<dynamic, dynamic>>());
    verify(forecastDB.addForecast()).called(1);
  });

  test("Call Fetch Forecast", () async {
    final forecastDB = MockForecastDB();
    when(forecastDB.callFetchForecast())
        .thenAnswer((_) async => <String, dynamic>{
              'key1': 'value1',
              'key2': 2,
            });

    var result = await forecastDB.callFetchForecast();

    expect(result, isA<Map<String, dynamic>>());
    expect(result, contains('key1'));
    verify(forecastDB.callFetchForecast()).called(1);
  });

  test("Test Property Value", () {
    final forecastDB = MockForecastDB();
    var forecast = f.Forecast(ObjectId(), "1", "13/10/2020", 5000, 1000,
        2000.85, 20, 340, 10, 20, 40);
    when(forecastDB.getPropertyValue(any, any)).thenReturn(forecast.food);
    var result = forecastDB.getPropertyValue("Food", forecast);
    expect(result, 2000.85);
  });
}
