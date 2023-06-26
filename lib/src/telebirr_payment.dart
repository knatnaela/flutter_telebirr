import 'package:dio/dio.dart';
import 'package:flutter_telebirr/src/model/telebirr_pay_request.dart';
import 'package:flutter_telebirr/src/model/telebirr_pay_response.dart';
import 'package:flutter_telebirr/src/model/telebirr_request_params.dart';
import 'package:flutter_telebirr/src/constants/constants.dart';
import 'package:flutter_telebirr/src/utils/utils.dart';

enum Mode {
  live,
  test,
}

class TelebirrPayment {
  TelebirrPayment._();

  static final TelebirrPayment instance = TelebirrPayment._();

  /// publicKey given from telebirr
  String? _publicKey;

  /// appId given from telebirr
  String? _appId;

  /// appKey given from telebirr
  String? _appKey;

  /// short code given from telebirr
  String? _shortCode;

  /// notify url which is invoked after payment is done
  /// by telebirr server
  String? _notifyUrl;

  /// merchant displayName
  String? _merchantDisplayName;

  /// telebirr live baseurl
  String _baseUrl = Constants.teleBirrBaseUrl;

  /// Sets the public key
  static set setPublicKey(String value) {
    if (value == instance._publicKey) {
      return;
    }
    instance._publicKey = value;
  }

  /// Retrieves the public key.
  static String get getPublicKey {
    if (instance._publicKey == null) {
      throw Exception('Public key is not set');
    }
    return instance._publicKey!;
  }

  /// Sets the app Id
  static set setAppId(String value) {
    if (value == instance._appId) {
      return;
    }
    instance._appId = value;
  }

  /// Retrieves the public key.
  static String get getAppId {
    if (instance._appId == null) {
      throw Exception('App Id is not set');
    }
    return instance._appId!;
  }

  /// Sets the app key
  static set setAppKey(String value) {
    if (value == instance._appKey) {
      return;
    }
    instance._appKey = value;
  }

  /// Retrieves the app key.
  static String get getAppKey {
    if (instance._appKey == null) {
      throw Exception('App key is not set');
    }
    return instance._appKey!;
  }

  /// Sets the short code provided by telebirr
  static set setShortCode(String value) {
    if (value == instance._shortCode) {
      return;
    }
    instance._shortCode = value;
  }

  /// Retrieves the short code.
  static String get getShortCode {
    if (instance._shortCode == null) {
      throw Exception('Short code is not set');
    }
    return instance._shortCode!;
  }

  /// Sets the notify url
  static set setNotifyUrl(String value) {
    if (value == instance._notifyUrl) {
      return;
    }
    instance._notifyUrl = value;
  }

  /// Retrieves the notify url.
  static String get getNotifyUrl {
    if (instance._notifyUrl == null) {
      throw Exception('Notify url is not set');
    }
    return instance._notifyUrl!;
  }

  /// Sets the merchant name
  /// which is displayed in telebirr payment portal
  static set setMerchantDisplayName(String value) {
    if (value == instance._merchantDisplayName) {
      return;
    }
    instance._merchantDisplayName = value;
  }

  /// Retrieves the notify url.
  static String get getMerchantDisplayName {
    if (instance._merchantDisplayName == null) {
      throw Exception('Merchant Name is not set');
    }
    return instance._merchantDisplayName!;
  }

  void configure({
    required String publicKey,
    required String appId,
    required String appKey,
    required String notifyUrl,
    required String shortCode,
    required String merchantDisplayName,
    Mode mode = Mode.live,
    String? testUrl,
  }) {
    assert(
      !(mode == Mode.test && testUrl == null),
      'if you are in test mode you need to pass your test url provided by telebirr',
    );
    if (mode == Mode.test) {
      _baseUrl = testUrl!;
    }
    setPublicKey = publicKey;
    setAppId = appId;
    setAppKey = appKey;
    setNotifyUrl = notifyUrl;
    setShortCode = shortCode;
    setMerchantDisplayName = merchantDisplayName;
  }

  /// initialize payment
  Future<TeleBirrPayResponse?> startPayment({
    required String totalAmount,
    required String itemName,
  }) async {
    late TelebirrPayRequest telebirrPayRequest;

    /// sets null values of params
    TelebirrRequestParams params = _constructParams(itemName, totalAmount);

    final String stringA = _generateStringA(params.toMap());

    final String signedStringA = _signStringA(stringA);

    /// Generate ussdJson
    final String ussd = _generateUSSDJson(
      params.toJsonWithOutAppKey(),
      getPublicKey,
    );

    /// construct payment request
    telebirrPayRequest = TelebirrPayRequest(
      appId: params.appId, //appId
      sign: signedStringA, // signedStringA
      ussd: ussd, // ussd
    );

    try {
      /// do [POST] request to telebirr SDK API
      final response = await _doRequest(telebirrPayRequest);
      if (response.statusCode == 200) {
        final TeleBirrPayResponse teleBirrPayResponse =
            TeleBirrPayResponse.fromMap(response.data);
        return teleBirrPayResponse;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Performs http request
  Future<Response> _doRequest(TelebirrPayRequest request) async {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
      ),
    );
    dio.options.headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };

    try {
      final response = await dio.post(
        Constants.toTradeMobilePay,
        data: request.toMap(),
      );
      return response;
    } on DioException catch (_) {
      rethrow;
    }
  }

  ///StringA is the request message composed of nonempty parameters including
  ///appKey provided by telebirr engineer.
  ///The parameter should be sorted in ascending order based on the ASCII code of
  ///the parameter name, and the URL key-value par format.
  String _generateStringA(Map<String, dynamic> data) {
    final urlParams = Utils.getUrlParamsByMap(data);

    return urlParams;
  }

  ///Perform SHA-256 on stringA to obtain the signature value “sign”.
  String _signStringA(String stringA) {
    /// perform sha256 encryption
    final signedString = Utils.performSHA256Encryption(stringA: stringA);

    return signedString.toUpperCase();
  }

  /// Generate USSD Json
  String _generateUSSDJson(String data, String publicKey) {
    final ussdJson = Utils.performEncryptionByPublicKey(
      data,
      publicKey,
    );
    return ussdJson;
  }

  /// construct parameters
  TelebirrRequestParams _constructParams(String subject, String totalAmount) {
    TelebirrRequestParams params = TelebirrRequestParams(
      appId: getAppId,
      appKey: getAppKey,
      shortCode: getShortCode,
      notifyUrl: getNotifyUrl,
      subject: subject,
      totalAmount: totalAmount,
      receiveName: getMerchantDisplayName,
    );
    if (params.nonce == null || params.nonce!.isEmpty) {
      params = params.copyWith(nonce: Utils.getUniqueNonce);
    }
    if (params.outTradeNo == null || params.outTradeNo!.isEmpty) {
      params = params.copyWith(outTradeNo: Utils.getUniqueOutTradeNo);
    }

    if (params.timestamp == null || params.timestamp!.isEmpty) {
      params = params.copyWith(timestamp: Utils.getTimeStamp);
    }
    if (params.timeoutExpress == null || params.timeoutExpress!.isEmpty) {
      params = params.copyWith(timeoutExpress: Utils.getTimeOutExpress);
    }
    return params;
  }
}
