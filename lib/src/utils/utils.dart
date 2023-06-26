import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_telebirr/src/constants/constants.dart';
import 'package:pointycastle/export.dart';

/// Utils class
class Utils {
  const Utils._();

  /// Perform Sha256 encryption
  ///
  /// Accepts stringA
  static String performSHA256Encryption({required String stringA}) {
    final hashedData = _hash256(stringA);

    return hashedData;
  }

  ///Generate url params by the given json object
  static String getUrlParamsByMap(Map<String, dynamic> data) {
    String param = "";

    /// sort map in lexicographic order
    final Map<String, dynamic> sortedByValueMap =
        Map<String, dynamic>.fromEntries(
            data.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));

    ///loop through json object
    sortedByValueMap.forEach((key, value) {
      param += '$key=$value&';
    });

    ///remove the last '&' value
    if (param.endsWith("&")) {
      param = param.substring(0, param.length - 1);
    }
    return param;
  }

  /// Hash given data to SHA256
  static String _hash256(String data) {
    /// data being hashed
    var bytes = utf8.encode(data);

    /// Start Hashing Process
    var digest = sha256.convert(bytes);

    return digest.toString();
  }

  static String performEncryptionByPublicKey(String data, String publicKey) {
    /// Generate public key
    final finalPublicKey = generatePublicKey(publicKey);

    /// define scheme
    final engine = scheme(scheme: PKCS1Encoding(RSAEngine()));

    /// initialize scheme
    initializeScheme(engine: engine, publicKey: finalPublicKey);

    /// Converting into [Unit8List] from List<int>
    /// Then Encoding into Base64
    Uint8List outPut = processInBlocks(
      engine,
      convertStringToUint8List(data),
    );
    final base64EncodedData = base64Encode(outPut);

    return base64EncodedData;
  }

  /// Convert String to Unit8List
  static Uint8List convertStringToUint8List(String data) {
    return Uint8List.fromList(utf8.encode(data));
  }

  static AsymmetricBlockCipher scheme({required AsymmetricBlockCipher scheme}) {
    return scheme;
  }

  /// init Scheme
  static void initializeScheme({
    required AsymmetricBlockCipher engine,
    required RSAPublicKey publicKey,
    bool encrypt = true,
  }) {
    //initialize Cipher
    engine.init(
      encrypt,
      PublicKeyParameter<RSAPublicKey>(publicKey),
    );
  }

  /// Generate publicKey
  static RSAPublicKey generatePublicKey(String publicKey) {
    /// Encode to base4
    var modulusBytes = base64.decode(publicKey);
    final key =
        CryptoUtils.rsaPublicKeyFromDERBytes(Uint8List.fromList(modulusBytes));
    final pem = CryptoUtils.encodeRSAPublicKeyToPemPkcs1(key);
    return RSAKeyParser().parse(pem) as RSAPublicKey;
  }

  /// Process In Blocks
  static Uint8List processInBlocks(
      AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = input.length ~/ engine.inputBlockSize +
        ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

    final output = Uint8List(numBlocks * engine.outputBlockSize);

    var inputOffset = 0;
    var outputOffset = 0;
    while (inputOffset < input.length) {
      final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
          ? engine.inputBlockSize
          : input.length - inputOffset;

      outputOffset += engine.processBlock(
          input, inputOffset, chunkSize, output, outputOffset);

      inputOffset += chunkSize;
    }

    return (output.length == outputOffset)
        ? output
        : output.sublist(0, outputOffset);
  }

  /// Generate random hex string
  /// with a given [length]
  static String _randomHexString(int length) {
    StringBuffer sb = StringBuffer();
    for (var i = 0; i < length; i++) {
      sb.write(Random().nextInt(16).toRadixString(16));
    }
    return sb.toString();
  }

  /// Get Unique Nonce
  static String get getUniqueNonce => _randomHexString(32);

  /// Get timestamp
  static String get getTimeStamp =>
      DateTime.now().millisecondsSinceEpoch.toString();

  /// Get default timeout express
  static String get getTimeOutExpress => Constants.defaultTimeoutExpress;

  /// Get Unique Out trade number
  static String get getUniqueOutTradeNo =>
      '${_randomNumber.toString()}$getTimeStamp';

  /// get random number
  static int get _randomNumber => Random().nextInt(9999) + 1000;
}
