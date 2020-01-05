import 'package:coffee_crew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:coffee_crew/services/database.dart';
import 'package:provider/provider.dart';
import 'package:coffee_crew/screens/home/coffee_list.dart';
import 'package:coffee_crew/models/coffee.dart';
import 'package:coffee_crew/screens/home/settings_form.dart';

class Home extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Coffee>>.value(
      value: DatabaseService().coffees,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Coffee Crew'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Logout'),
              onPressed: () async {
                await _authService.signOut();
              },
            ),
            FlatButton.icon(
              icon: Icon(Icons.settings),
              label: Text('Settings'),
              onPressed: () {
                _showSettingsPanel();
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/coffee_bg.png'),
              fit: BoxFit.cover
            )
          ),
          child: CoffeeList()
        ),
      ),
    );
  }
}
