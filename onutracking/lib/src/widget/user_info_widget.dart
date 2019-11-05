import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:onutracking/src/screen/test.dart';
import '../theme.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget(
      {Key key, this.userProfile, this.accessToken, this.onSignOutPressed})
      : super(key: key);

  final UserProfile userProfile;
  final StoredAccessToken accessToken;
  final Function onSignOutPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        (userProfile.pictureUrl.isNotEmpty)
            ? Image.network(userProfile.pictureUrl, width: 200, height: 200)
            : Icon(Icons.person),
        Text(userProfile.displayName,
            style: Theme.of(context).textTheme.headline),
        Text(userProfile.statusMessage),
        Container(
          child: RaisedButton(
            textColor: textColor,
            color: accentColor,
            child: Text("Sign Out"),
            onPressed: onSignOutPressed,
          ),
        ),
        Container(
            child: RaisedButton(
                textColor: textColor,
                color: accentColor,
                child: Text("Use->App"),
                onPressed: () {

                  // var registerRoute = MaterialPageRoute(
                  //     builder: (BuildContext context) => Testfull(
                        
                  //     ));
                  // Navigator.of(context).push(registerRoute);

                  Navigator.push(
                  context,
                  // MaterialPageRoute(builder: (context) => Testfull(data: userProfile.userId)),
                  MaterialPageRoute(builder: (context) => Testfull(data: userProfile.displayName, uid: userProfile.userId)),
                  );

                })),
      ],
    ));
  }
}
