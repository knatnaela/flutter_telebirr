// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TeleBirrPayResponse {
  final int? code;
  final String? message;
  final TeleBirrPayData? data;

  bool get isSuccess =>
      code == 200 &&
      data != null &&
      data!.toPayUrl != null &&
      data!.toPayUrl!.isNotEmpty;

  TeleBirrPayResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'message': message,
      'data': data?.toMap(),
    };
  }

  factory TeleBirrPayResponse.fromMap(Map<String, dynamic> map) {
    return TeleBirrPayResponse(
      code: map['code'] != null ? map['code'] as int : null,
      message: map['message'] != null ? map['message'] as String : null,
      data: map['data'] != null
          ? TeleBirrPayData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TeleBirrPayResponse.fromJson(String source) =>
      TeleBirrPayResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class TeleBirrPayData {
  final String? toPayUrl;
  TeleBirrPayData({
    required this.toPayUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'toPayUrl': toPayUrl,
    };
  }

  factory TeleBirrPayData.fromMap(Map<String, dynamic> map) {
    return TeleBirrPayData(
      toPayUrl: map['toPayUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TeleBirrPayData.fromJson(String source) =>
      TeleBirrPayData.fromMap(json.decode(source) as Map<String, dynamic>);
}
