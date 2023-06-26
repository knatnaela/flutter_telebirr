// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TelebirrPayRequest {
  final String appId;
  final String sign;
  final String ussd;
  TelebirrPayRequest({
    required this.appId,
    required this.sign,
    required this.ussd,
  });

  TelebirrPayRequest copyWith({
    String? appId,
    String? sign,
    String? ussd,
  }) {
    return TelebirrPayRequest(
      appId: appId ?? this.appId,
      sign: sign ?? this.sign,
      ussd: ussd ?? this.ussd,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appid': appId,
      'sign': sign,
      'ussd': ussd,
    };
  }

  factory TelebirrPayRequest.fromMap(Map<String, dynamic> map) {
    return TelebirrPayRequest(
      appId: map['appid'] as String,
      sign: map['sign'] as String,
      ussd: map['ussd'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TelebirrPayRequest.fromJson(String source) =>
      TelebirrPayRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TelebirrPayRequest(appId: $appId, sign: $sign, ussd: $ussd)';

  @override
  bool operator ==(covariant TelebirrPayRequest other) {
    if (identical(this, other)) return true;

    return other.appId == appId && other.sign == sign && other.ussd == ussd;
  }

  @override
  int get hashCode => appId.hashCode ^ sign.hashCode ^ ussd.hashCode;
}
