import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TelebirrRequestParams {
  final String appId;
  final String appKey;
  final String shortCode;
  final String notifyUrl;
  final String subject;
  final String? outTradeNo;
  final String? timeoutExpress;
  final String totalAmount;
  final String receiveName;
  final String? nonce;
  final String? timestamp;
  TelebirrRequestParams({
    required this.appId,
    required this.appKey,
    required this.shortCode,
    required this.notifyUrl,
    required this.subject,
    this.outTradeNo,
    this.timeoutExpress,
    required this.totalAmount,
    required this.receiveName,
    this.nonce,
    this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appId': appId,
      'appKey': appKey,
      'nonce': nonce,
      'notifyUrl': notifyUrl,
      'outTradeNo': outTradeNo,
      'receiveName': receiveName,
      'shortCode': shortCode,
      'subject': subject,
      'timeoutExpress': timeoutExpress,
      'timestamp': timestamp,
      'totalAmount': totalAmount,
    };
  }

  Map<String, dynamic> toMapWithOutAppKey() {
    return <String, dynamic>{
      'appId': appId,
      'nonce': nonce,
      'notifyUrl': notifyUrl,
      'outTradeNo': outTradeNo,
      'receiveName': receiveName,
      'shortCode': shortCode,
      'subject': subject,
      'timeoutExpress': timeoutExpress,
      'timestamp': timestamp,
      'totalAmount': totalAmount,
    };
  }

  factory TelebirrRequestParams.fromMap(Map<String, dynamic> map) {
    return TelebirrRequestParams(
      appId: map['appId'] as String,
      appKey: map['appKey'] as String,
      shortCode: map['shortCode'] as String,
      notifyUrl: map['notifyUrl'] as String,
      subject: map['subject'] as String,
      outTradeNo: map['outTradeNo'] as String,
      timeoutExpress: map['timeoutExpress'] as String,
      totalAmount: map['totalAmount'] as String,
      receiveName: map['receiveName'] as String,
      nonce: map['nonce'] as String,
      timestamp: map['timestamp'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  String toJsonWithOutAppKey() => json.encode(toMapWithOutAppKey());

  factory TelebirrRequestParams.fromJson(String source) =>
      TelebirrRequestParams.fromMap(
          json.decode(source) as Map<String, dynamic>);

  TelebirrRequestParams copyWith({
    String? appId,
    String? appKey,
    String? shortCode,
    String? notifyUrl,
    String? subject,
    String? outTradeNo,
    String? timeoutExpress,
    String? totalAmount,
    String? receiveName,
    String? nonce,
    String? timestamp,
  }) {
    return TelebirrRequestParams(
      appId: appId ?? this.appId,
      appKey: appKey ?? this.appKey,
      shortCode: shortCode ?? this.shortCode,
      notifyUrl: notifyUrl ?? this.notifyUrl,
      subject: subject ?? this.subject,
      outTradeNo: outTradeNo ?? this.outTradeNo,
      timeoutExpress: timeoutExpress ?? this.timeoutExpress,
      totalAmount: totalAmount ?? this.totalAmount,
      receiveName: receiveName ?? this.receiveName,
      nonce: nonce ?? this.nonce,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
