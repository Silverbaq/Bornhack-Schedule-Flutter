import 'package:awesome_notifications/awesome_notifications.dart';

int createUniqueId() {
  return DateTime
      .now()
      .microsecondsSinceEpoch
      .remainder(9001);
}

Future<void> createNotification() async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'basic_channel',
          title: '${Emojis.money_money_bag + Emojis.plant_cactus} + need food!',
          notificationLayout: NotificationLayout.Default
      )
  );
}

Future<void> removeScheduledNotification(int id) async {
  await AwesomeNotifications().cancel(id);
}

Future<void> createScheduledNotification(
    NotificationData data) async {
  DateTime reminderDateTime = data.starting.subtract(Duration(minutes:15));

  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: data.id,
          channelKey: 'basic_channel',
          title: 'Event starts in 15 minutes ${Emojis.sound_bell}',
          body: data.title,
          notificationLayout: NotificationLayout.Default
      ),
    schedule: NotificationCalendar(
      day: reminderDateTime.day,
      month: reminderDateTime.month,
      year: reminderDateTime.year,
      hour: reminderDateTime.hour,
      minute: reminderDateTime.minute,
      second: reminderDateTime.second,
      millisecond: 0,
      repeats: false,
    )
  );
}

class NotificationData {
  NotificationData(this.id, this.title, this.body, this.starting);

  final int id;
  final String title;
  final String body;
  final DateTime starting;
}