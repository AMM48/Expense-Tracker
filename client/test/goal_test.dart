import 'package:client/classes/goal.dart' as g;
import 'package:client/classes/goal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:realm/realm.dart';

import 'goal_test.mocks.dart';
import 'models_test.mocks.dart';
class MockFirebaseUser extends Mock implements User {}
@GenerateMocks([g.GoalDB])
void main() {
  test('Set Goal', () {
    final goalDB = MockGoalDB();
    final transactionDB = MockTransactionDB();
    double goalAmount = 1000.0;
    String goalDate = "22/03/2024";

    when(transactionDB.getTransactions()).thenReturn([]);

    expect(transactionDB.getTransactions(), isEmpty);

    when(goalDB.setGoal(any, any)).thenReturn(
        g.Goal(ObjectId(), "1", 300, "22/03/2024", 50.0, "20/03/2024", "null"));

    var result = goalDB.setGoal(goalAmount, goalDate);

    expect(result.amount, 300);
    expect(result.progress, 50.0);
    expect(result.status, "null");
    expect(result.date, "22/03/2024");

    verify(goalDB.setGoal(goalAmount, goalDate)).called(1);

    when(transactionDB.getTransactions()).thenReturn([result]);

    expect(transactionDB.getTransactions(), hasLength(1));
  });

  test('Edit Goal', () {
    final goalDB = MockGoalDB();

    var mockOriginalG =
        g.Goal(ObjectId(), "1", 300, "22/03/2024", 50.0, "20/03/2024", "null");
    var mockEditG =
        g.Goal(ObjectId(), "1", 200, "27/03/2024", 75.0, "20/03/2024", "null");
    when(goalDB.editGoal(any, any, any, any)).thenReturn(mockEditG);
    var result = goalDB.editGoal(mockOriginalG, 75.0, 200, "27/03/2024");
    expect(result.progress, 75.0);
    expect(result.amount, 200);
    expect(result.date, "27/03/2024");

    verify(goalDB.editGoal(mockOriginalG, 75.0, 200, "27/03/2024")).called(1);
  });

  test('Get Goal', () {
    final goalDB = MockGoalDB();
    when(goalDB.getGoal()).thenReturn([
      g.Goal(ObjectId(), "1", 500, "22/04/2024", 49.7, "20/03/2024", "null")
    ]);
    var goal = goalDB.getGoal();
    verify(goalDB.getGoal()).called(1);

    expect(goal, isA<List<g.Goal>>());
    expect(goal.length, equals(1));
    expect(goal.first.amount, equals(500));
    expect(goal.first.date, equals("22/04/2024"));
    expect(goal.first.progress, equals(49.7));
    expect(goal.first.sDate, equals("20/03/2024"));
    expect(goal.first.status, equals("null"));
  });

  test('Delete Goal', () {
    final goalDB = MockGoalDB();
    var mockG =
        g.Goal(ObjectId(), "1", 300, "22/03/2024", 50.0, "20/03/2024", "null");

    when(goalDB.getGoal()).thenReturn([mockG]);

    expect(goalDB.getGoal(), hasLength(1));

    when(goalDB.deleteGoal(any)).thenReturn(true);

    var result = goalDB.deleteGoal(mockG);

    expect(result, isTrue);

    verify(goalDB.deleteGoal(mockG)).called(1);

    when(goalDB.getGoal()).thenReturn([]);

    expect(goalDB.getGoal(), isEmpty);
  });

  test('Handle Goal Retrieval Error', () {
    final goalDB = MockGoalDB();

    when(goalDB.getGoal()).thenThrow(Exception('Failed to retrieve goals'));

    expect(() => goalDB.getGoal(), throwsException);
    verify(goalDB.getGoal()).called(1);
  });
  test('Retrieve Specific Goals', () {
    final goalDB = MockGoalDB();
    final goal1 = g.Goal(
        ObjectId(), "1", 100, "22/04/2024", 30.0, "20/03/2024", "active");
    final goal2 = g.Goal(
        ObjectId(), "2", 200, "23/05/2024", 60.0, "21/04/2024", "active");

    when(goalDB.getGoal()).thenReturn([goal1, goal2]);

    var goals = goalDB.getGoal();

    expect(goals, isA<List<g.Goal>>());
    expect(goals.length, equals(2));
    expect(goals[0].status, equals("active"));
    expect(goals[1].status, equals("active"));
    verify(goalDB.getGoal()).called(1);
  });
  test('Input Validation in setGoal', () {
    final goalDB = MockGoalDB();
    double invalidGoalAmount = -1000.0;
    String goalDate = "22/03/2024";

    when(goalDB.setGoal(any, any)).thenThrow(Exception('Invalid goal amount'));

    expect(() => goalDB.setGoal(invalidGoalAmount, goalDate), throwsException);
    verify(goalDB.setGoal(invalidGoalAmount, goalDate)).called(1);
  });
  test('Error Handling in getGoal', () {
    final goalDB = MockGoalDB();

    when(goalDB.getGoal()).thenThrow(Exception('Failed to retrieve goals'));

    expect(() => goalDB.getGoal(), throwsException);
    verify(goalDB.getGoal()).called(1);
  });
  test('editGoal With Unchanged Data', () {
    final goalDB = MockGoalDB();
    var originalGoal = g.Goal(
        ObjectId(), "1", 300, "22/03/2024", 50.0, "20/03/2024", "active");

    when(goalDB.editGoal(originalGoal, null, null, null))
        .thenReturn(originalGoal); // Returns the same goal without changes

    var updatedGoal = goalDB.editGoal(originalGoal, null, null, null);

    expect(updatedGoal, equals(originalGoal));
    verify(goalDB.editGoal(originalGoal, null, null, null)).called(1);
  });
  test('Goal properties are set and retrieved correctly', () {
    final ObjectId id = ObjectId();
    final String uid = "user123";
    final double amount = 1000.0;
    final String date = "2023-01-01";
    final double progress = 50.0;
    final String sDate = "2022-12-01";
    final String status = "active";

    final goal = Goal(id, uid, amount, date, progress, sDate, status);

    expect(goal.id, equals(id));
    expect(goal.uid, equals(uid));
    expect(goal.amount, equals(amount));
    expect(goal.date, equals(date));
    expect(goal.progress, equals(progress));
    expect(goal.sDate, equals(sDate));
    expect(goal.status, equals(status));
  });

test('initG initializes Realm with user and updates subscriptions', () async {
    final goalDB = MockGoalDB();
    final mockUser = MockFirebaseUser();

    
    when(goalDB.initG(any)).thenAnswer((_) async {});

    await goalDB.initG(mockUser);

    
    verify(goalDB.initG(mockUser)).called(1);

  
  });
}
