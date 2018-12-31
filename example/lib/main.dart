import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart'; // Just for theme example

main() async {
  await PrefService.init(prefix: 'pref_');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) =>
            new ThemeData(brightness: brightness, accentColor: Colors.green),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            title: 'Preferences Demo',
            theme: theme,
            home: new MyHomePage(title: 'Preferences Demo'),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PreferencePage([
        PreferenceTitle('General'),
        DropdownPreference(
          'Start Page',
          'start_page',
          defaultVal: 'Timeline',
          values: ['Posts', 'Timeline', 'Private Messages'],
        ),
        PreferenceTitle('Personalization'),
        RadioPreference(
          'Light Theme',
          'light',
          'ui_theme',
          isDefault: true,
          onSelect: () {
            DynamicTheme.of(context).setBrightness(Brightness.light);
          },
        ),
        RadioPreference(
          'Dark Theme',
          'dark',
          'ui_theme',
          onSelect: () {
            DynamicTheme.of(context).setBrightness(Brightness.dark);
          },
        ),
        PreferenceTitle('Messaging'),
        PreferencePageLink(
          'Notifications',
          leading: Icon(Icons.message),
          page: PreferencePage([
            PreferenceTitle('New Posts'),
            SwitchPreference(
              'New Posts from Friends',
              'notification_newpost_friend',
              defaultVal: true,
            ),
            PreferenceTitle('Private Messages'),
            SwitchPreference(
              'Private Messages from Friends',
              'notification_pm_friend',
              defaultVal: true,
            ),
            SwitchPreference(
              'Private Messages from Strangers',
              'notification_pm_stranger',
              onEnable: () async {
                // Write something in Firestore or send a request
                await Future.delayed(Duration(seconds: 1));

                print('Enabled Notifications for PMs from Strangers!');
              },
              onDisable: () async {
                // Write something in Firestore or send a request
                await Future.delayed(Duration(seconds: 1));

                // No Connection? No Problem! Just throw an Exception with your custom message...
                throw Exception('No Connection');

                print('Disabled Notifications for PMs from Strangers!');
              },
            ),
          ]),
        ),
        PreferenceHider([
          PreferenceTitle('Experimental'),
          SwitchPreference(
            'Show Operating System',
            'exp_showos',
            desc: 'This option shows the users operating system in his profile',
          )
        ], '!advanced_enabled'), // Use ! to get reversed boolean values
        PreferenceTitle('Advanced'),
        CheckboxPreference(
          'Enable Advanced Features',
          'advanced_enabled',
          onChange: () {
            setState(() {});
          },
          onDisable: () {
            PrefService.setBool('exp_showos', false);
          },
        )
      ]),
    );
  }
}
