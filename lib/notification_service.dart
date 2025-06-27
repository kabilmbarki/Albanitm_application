import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart'; // Import for Navigator (if you intend to use it)

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Define a stream controller to handle notification responses if you need to
  // process them elsewhere in your app (e.g., for navigation).
  // This replaces the direct callback for onDidReceiveLocalNotification logic.
  static final onNotifications = FlutterLocalNotificationsPlugin()
    ..initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/launcher_icon'),
        iOS: DarwinInitializationSettings(),
        linux:
            LinuxInitializationSettings(defaultActionName: 'Open notification'),
      ),
      onDidReceiveNotificationResponse: (details) {
        // You can put your logic here that was previously in onDidReceiveLocalNotification
        // For example, if you were showing a dialog or navigating
        if (details.payload != null) {
          print(
              'Notification response received with payload: ${details.payload}');
          // Example of how you might handle it:
          // Navigator.of(someContext).push(MaterialPageRoute(builder: (_) => MyDetailPage(payload: details.payload)));
        }
      },
    );

  static Future<void> init() async {
    // Changed return type to Future<void>
    // initialise the plugin. app_icon needs to be added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    // For iOS, the onDidReceiveLocalNotification is no longer a parameter here.
    // Instead, the logic for handling foreground notifications on iOS
    // (which used to be handled by onDidReceiveLocalNotification)
    // is now part of the onDidReceiveNotificationResponse callback in the initialize method.
    // You might also want to request permissions here for iOS.
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true, // Request permissions if needed
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification is removed here.
    );

    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // This is the new consolidated callback for handling all notification responses
      // including those that used to be caught by onDidReceiveLocalNotification on iOS.
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        // This callback is triggered when a user taps on a notification or a notification action.
        // For iOS, this is also how you handle foreground notifications if you want
        // to respond to them when the app is active and the user taps them.

        // The 'payload' from your showSimpleNotification method will be available here.
        if (notificationResponse.payload != null &&
            notificationResponse.payload!.isNotEmpty) {
          print(
              'Notification tapped with payload: ${notificationResponse.payload}');
          // You can implement your desired functionality here, for example:
          // Navigator.push(
          //   context, // You'd need a BuildContext here or use a Navigator key
          //   MaterialPageRoute(
          //     builder: (context) => NotificationDetailPage(payload: notificationResponse.payload!),
          //   ),
          // );
        }

        // If you had specific UI logic for onDidReceiveLocalNotification that *didn't* involve a tap
        // (e.g., showing an in-app banner for a foreground iOS notification without user interaction),
        // that's typically handled by setting `presentAlert`, `presentBadge`, `presentSound`
        // in `DarwinNotificationDetails` when you *show* the notification,
        // and then reacting to `onDidReceiveNotificationResponse` if the user taps it.
        // For purely passive foreground display on iOS, you rely on the presentation options.
      },
      // You might also consider onDidReceiveBackgroundNotificationResponse for background processing
      // onDidReceiveBackgroundNotificationResponse: (NotificationResponse details) {
      //   // Handle background notification responses if your app supports it
      // },
    );
  }

  static Future<void> showSimpleNotification({
    // Changed return type to Future<void>
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'your channel id', // Make sure this is a unique channel ID
            'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    // For iOS, you need DarwinNotificationDetails.
    // Set presentAlert, presentBadge, presentSound to true if you want the
    // notification to show an alert, update badge, or play sound
    // when the app is in the foreground.
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true, // Show alert in foreground
      presentBadge: true, // Update badge in foreground
      presentSound: true, // Play sound in foreground
    );

    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails); // Include iOS details

    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }
}
