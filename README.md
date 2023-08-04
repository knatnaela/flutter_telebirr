# telebirr Flutter SDK

telebirr Flutter sdk for telebirr payment API.

[![pub package](https://img.shields.io/pub/v/flutter_telebirr.svg)](https://pub.dev/packages/flutter_telebirr)

# Features

- Get toPayUrl from telebirr using telebirr sdk api

## Getting Started

### In order to use this plugin you need these keys from telebirr

- appId
- appKey
- publicKey
- test url //for test mode

To use this plugin add 'flutter_telebirr' as [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/). For example:

```yaml
dependencies:
  flutter_telebirr: ^0.0.4
```

To allow your application to access telebirr api on the Internet,

### :point_right: Android

add the following permission to your `AndroidManifest.xml` file:

```xml
    <uses-permission android:name="android.permission.INTERNET"/>

```

In order to use telebirr test urls

### :point_right: Android

add the following attribute to the `application` element:

```xml
    <application ... android:usesCleartextTraffic="true">
```

### :point_right: IOS

add the following to your `Info.plist` file:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## How to use

1. Configure

If you set test mode you need to pass testUrl provided by telebirr

Ps. Don't include `/toTradeSDKPay` at the end of test url,
instead use this format '`http://<IP>:<PORT>/service-openup`'

```dart
    TelebirrPayment.instance.configure(
      publicKey: publicKey,
      appId: '<appId>',
      appKey: "<appKey>",
      notifyUrl: "https://localhost/notifyUrl",
      shortCode: "<shortCode>",
      merchantDisplayName: "Organization name",
      // mode: Mode.test,
      // testUrl: 'http://<IP>:<PORT>/service-openup',
    );
```

2. call `startPayment` and pass `itemName` and `totalAmount`

```dart
...
    final response = await TelebirrPayment.instance.startPayment(
      itemName: "Goods name",
      totalAmount: "10",
    );
```

3. If you get successful response you can load `toPayUrl` with any url loader package.

```dart
...
    var toPayUrl = '';
    if(response !=null && response!.isSuccess){
      toPayUrl = response.data?.toPayUrl ?? '';
    }
```
