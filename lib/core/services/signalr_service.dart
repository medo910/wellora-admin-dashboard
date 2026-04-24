// core/services/signalr_service.dart
import 'dart:developer';

import 'package:signalr_netcore/signalr_client.dart';

// class SignalRService {
//   late HubConnection _hubConnection;
//   final String _baseUrl =
//       "https://wellora-healthcaremanagment.runasp.net/hubs/app"; //

//   Future<void> init(String token) async {
//     _hubConnection = HubConnectionBuilder()
//         .withUrl(
//           _baseUrl,
//           options: HttpConnectionOptions(
//             accessTokenFactory: () async => token, //
//           ),
//         )
//         .withAutomaticReconnect()
//         .build();

//     await _hubConnection.start();
//   }

//   // ميثود للاستماع لأي حدث (Event)
//   void on(String eventName, void Function(List<Object?>?) callback) {
//     _hubConnection.on(eventName, callback);
//   }

//   // ميثود لمناداة ميثود في السيرفر (مثل JoinTicket)
//   Future<void> invoke(String methodName, {List<Object>? args}) async {
//     await _hubConnection.invoke(methodName, args: args);
//   }

//   Future<void> stop() async => await _hubConnection.stop();
// }

// core/services/signalr_service.dart
class SignalRService {
  HubConnection? _hubConnection; // شيلنا late وخليناها nullable
  final String _url = "https://wellora-healthcaremanagment.runasp.net/hubs/app";

  // Future<void> init(String token) async {
  //   // لو الاتصال شغال أصلاً متبعيدش تشغيله
  //   if (_hubConnection?.state == HubConnectionState.Connected) return;

  //   _hubConnection = HubConnectionBuilder()
  //       .withUrl(
  //         _url,
  //         options: HttpConnectionOptions(accessTokenFactory: () async => token),
  //       )
  //       .withAutomaticReconnect()
  //       .build();

  //   await _hubConnection?.start();
  // }

  // core/services/signalr_service.dart

  Future<void> init(String token) async {
    try {
      // 1. لو الاتصال موجود وشغال أو بيحاول يربط، مابنعملش حاجة
      if (_hubConnection?.state == HubConnectionState.Connected ||
          _hubConnection?.state == HubConnectionState.Connecting ||
          _hubConnection?.state == HubConnectionState.Reconnecting) {
        log("ℹ️ SignalR is already active or connecting.");
        return;
      }

      // 2. بناء الاتصال مع الـ Named Argument "options"
      _hubConnection = HubConnectionBuilder()
          .withUrl(
            _url,
            options: HttpConnectionOptions(
              accessTokenFactory: () async => token,
            ),
          )
          .withAutomaticReconnect()
          .build();

      // 3. الاستماع لحدث القفل عشان ما يحصلش الـ LegacyJavaScriptObject error
      _hubConnection!.onclose(({error}) {
        log("⚠️ SignalR Connection Closed: $error");
      });

      // 4. تشغيل الاتصال
      await _hubConnection!.start();
      log("✅ SignalR Started Successfully");
    } catch (e) {
      // هنا بنمسك الخطأ عشان الـ App ما يقفلش
      log("❌ SignalR Init Error: $e");
    }
  }

  // ميثود للتأكد إن الاتصال جاهز
  bool get isConnected => _hubConnection?.state == HubConnectionState.Connected;

  void on(String eventName, void Function(List<Object?>?) callback) {
    _hubConnection?.on(eventName, callback);
  }

  Future<void> invoke(String methodName, {List<Object>? args}) async {
    // 🚀 فحص الأمان: لو مش متصل، استنى ثانية أو اخرج بهدوء
    if (isConnected) {
      await _hubConnection?.invoke(methodName, args: args);
    } else {
      log("⚠️ SignalR not connected. Action $methodName ignored.");
    }
  }
}
