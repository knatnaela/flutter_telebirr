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
  flutter_telebirr: ^0.0.1+1
```

### :point_right: Android

To allow your application to access telebirr api on the Internet, add the following permission to your `AndroidManifest.xml` file:

```xml
    <uses-permission android:name="android.permission.INTERNET"/>

```

telebirr test urls are HTTP so you need to add the following attribute to the `application` element:

```xml
    <application ... android:usesCleartextTraffic="true">
```

### :point_right: IOS

To allow your application to access telebirr api on the Internet, add the following permission to your `AndroidManifest.xml` file:

```xml
    <uses-permission android:name="android.permission.INTERNET"/>

```

telebirr test urls are HTTP so you need to add the following to your `Info.plist` file:

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
      appId: '829c8596f5664aaf9e221b275b46eec0',
      appKey: "e5e6ea0ce63a4e7da0d3d41c163d1eb8",
      notifyUrl: "https://localhost/notifyUrl",
      shortCode: "500279",
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
