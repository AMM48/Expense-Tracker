import 'package:flutter_test/flutter_test.dart';
import 'package:client/wordExtract.dart';

void main() {
  test('Test1', () {
    const message =
        'شراء-POS\nبـ3.50 SAR\nمن SULTANA S\nمدى-ابل*6342\nفي 07/09/23 08:55';
    final result = extractAlahli(message.toLowerCase());
    expect(result[0], 'sultana s');
    expect(result[1], 3.50);
  });

  test('Test2', () {
    const message =
        "شراء محلي عبر الانترنت\nبـ588 SAR\nمن Jarir boo\nمدى*4256\nفي 24/10/23 18:52";
    final result = extractAlahli(message.toLowerCase());
    expect(result[0], 'jarir boo');
    expect(result[1], 588);
  });

  test('Test3', () {
    const message =
        'شراء عبر الانترنت - دولي\nبطاقة مدى *2566\nحساب 201*796\nبمبلغ 20 USD\nمن AMAZON US\nفي الولايات المتحدة الامريكية\n29/10/23 15:29';
    final result = extractAlahli(message.toLowerCase());
    expect(result[0], 'amazon us');
    expect(result[1], 75.0);
  });
}
