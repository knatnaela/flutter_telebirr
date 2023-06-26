import 'package:flutter_telebirr/src/model/telebirr_pay_response.dart';
import 'package:flutter_telebirr/src/telebirr_payment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String publicKey = '<publicKey>';

  test('Get Payment URL', () async {
    TelebirrPayment.instance.configure(
      publicKey: publicKey,
      appId: '<appId>',
      appKey: "<appKey>",
      notifyUrl: "https://localhost/notifyUrl",
      shortCode: "<shortCode>",
      merchantDisplayName: "Organization name",
      mode: Mode.test,
      testUrl: 'http://<IP>:<port>/service-openup',
    );

    final TeleBirrPayResponse? response =
        await TelebirrPayment.instance.startPayment(
      itemName: "Item Name",
      totalAmount: "10",
    );

    expect(response?.isSuccess, true);
  });
}
