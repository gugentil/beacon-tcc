import 'package:beacontcc/src/resources/auth_resources.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final authRes = AuthenticationResources();

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Configurações",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),

          SizedBox(height: 45,),

          Container(
            width: 200,
            child: RaisedButton(
              child: Text("Deslogar"),
              color: Colors.red,
              onPressed: () {
                authRes.signOut;
              },
            ),
          ),
        ],
      ),
    );
  }
}
