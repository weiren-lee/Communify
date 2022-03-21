import 'package:communify/services/auth.dart';
import 'package:communify/views/signin.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'change_password.dart';
import 'edit_profile.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  AuthService authService = AuthService();

  signOut() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: const Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
          actions: [
            GestureDetector(
                onTap: () {
                  signOut();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                    builder: (_) => const SignIn(),
                  ));
                },
                child: SizedBox(
                  width: 50.0,
                  height: 45.0,
                  child: Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.rectangle,
                      ),
                      child: const Icon(Icons.logout, color: Colors.white,)),)
            )
          ]
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Common'),
            tiles: [
              SettingsTile(
                title: const Text('Language'),
                description: const Text('English'),
                leading: const Icon(Icons.language),
                onPressed: (context) {},
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Account'),
            tiles: [
              SettingsTile(
                title: const Text('Edit Profile'),
                leading: const Icon(Icons.account_circle_rounded),
                onPressed: (context) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const EditProfile(),
                  ));
                },
              ),
              SettingsTile(
                title: const Text('Change Password'),
                leading: const Icon(Icons.lock_open),
                onPressed: (context) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const ChangePassword(),
                  ));
                },
              ),
              SettingsTile(
                title: const Text('Sign Out'),
                leading: const Icon(Icons.logout),
                onPressed: (context) {
                  signOut();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => const SignIn(),
                  ));
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Security'),
            tiles: [
              SettingsTile.switchTile(
                enabled: false,
                title: const Text('Use fingerprint'),
                description: const Text(
                    'Allow application to access stored fingerprint IDs.'),
                leading: const Icon(Icons.fingerprint),
                onToggle: (bool value) {},
                initialValue: false,
                // switchValue: false,
              ),
              SettingsTile.switchTile(
                enabled: false,
                title: const Text('Enable Notifications'),
                // enabled: notificationsEnabled,
                leading: const Icon(Icons.notifications_active),
                // switchValue: true,
                onToggle: (value) {},
                initialValue: false,
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Misc.'),
            tiles: [
              SettingsTile(
                title: const Text('Terms of Service'),
                leading: const Icon(Icons.description),
                enabled: false,
              ),
              SettingsTile(
                title: const Text('Open source licenses'),
                leading: const Icon(Icons.collections_bookmark),
                enabled: false,
              ),
            ],
          ),
          const CustomSettingsSection(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Version: 0.0.1',
                style: TextStyle(color: Color(0xFF777777)),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
