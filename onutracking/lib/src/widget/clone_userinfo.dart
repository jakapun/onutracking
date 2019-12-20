// import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:onutracking/src/app.dart';
import 'package:onutracking/src/default_home.dart';
import 'package:onutracking/src/screen/clean_onu.dart';
import 'package:onutracking/src/screen/import_onu.dart';
import 'package:onutracking/src/screen/install_onu.dart';
// import 'package:onutracking/src/screen/payed_onu.dart';
import 'package:onutracking/src/screen/pickup_onu.dart';
import 'package:onutracking/src/screen/register.dart';
import 'package:onutracking/src/screen/reused_onu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imei_plugin/imei_plugin.dart';

class CloneUser extends StatefulWidget {
  const CloneUser(
      {Key key, this.userProfile, this.accessToken, this.onSignOutPressed})
      : super(key: key);

  final UserProfile userProfile;
  final StoredAccessToken accessToken;
  final Function onSignOutPressed;

  @override
  _CloneUserState createState() => _CloneUserState();
}

class _CloneUserState extends State<CloneUser> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var uid = '';
  var picurl = '';
  String nameString = '', getlineid = '';
  Widget myWidget = DefaultHome();
  int privilege = 0;
  String _platformImei = '';
  SharedPreferences prefs;

  // File file;
  // String name = 'Ebiwayo'; // ข้อความ
  // int age = 25; // เลขจำนวนเต็ม หรือเลขฐานอื่นๆ
  // double weight = 48.5;  // เลขทศนิยม ใน dart จะไม่มีข้อมูลรูปแบบ float
  // bool graduated = true;  // ข้อมูล Boolean

  @override
  void initState() {
    super.initState();
    nameString = widget.userProfile.displayName;
    picurl = widget.userProfile.pictureUrl;
    getlineid = widget.userProfile.userId;
    initPlatformState();
    //checkAuthen();
  }

  Future<void> initPlatformState() async {
    String platformImei;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei = await ImeiPlugin.getImei( shouldShowRequestPermissionRationale: false );
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformImei = platformImei;
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text('$nameString \r\n ต้องการ ออกจากระบบ หริอไม่?',
                  style: TextStyle(fontSize: 17.0, color: Colors.blue[700])),
              actions: <Widget>[
                FlatButton(
                  child: Text('No',
                  style: TextStyle(fontSize: 17.0, color: Colors.black)),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                    child: Text('Yes',
                    style: TextStyle(fontSize: 17.0, color: Colors.red[800])),
                    onPressed: () {
                      clearSharePreferance(context);
                      // widget.onSignOutPressed();
                      // Navigator.pop(context, true);
                    })
              ],
            ));
  }

  void myShowSnackBar(String messageString) {
    SnackBar snackBar = SnackBar(
      content: Text(messageString),
      backgroundColor: Colors.green[700],
      duration: Duration(seconds: 15),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
        textColor: Colors.orange,
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<void> checkAuthen() async {
    if ((_platformImei.length <= 5) || ( getlineid.length <= 5)) {
      print('user = $getlineid, password = $_platformImei');
      myShowSnackBar('$getlineid $_platformImei');
    } else {
      
      /*
    str1.toLowerCase(); // lorem
    str1.toUpperCase(); // LOREM
    "   $str2  ".trim(); // 'Lorem ipsum'
    str3.split('\n'); // ['Multi', 'Line', 'Lorem Lorem ipsum'];
    str2.replaceAll('e', 'é'); // Lorém

    101.109.115.27:2500/api/flutterget/User=123456
    */
      // uid: user.fname, prv: user.province, priv: user.privilege
      String urlString = 'http://8a7a08360daf.sn.mynetname.net:2528/api/signin';

      var body = {
        "username": getlineid,
        "password": _platformImei.trim(),
        "deviceid": _platformImei.trim()
      };

      // var response = await get(urlString);
      var response = await post(urlString, body: body);

      if (response.statusCode == 200) {
        print(response.statusCode);
        var result = json.decode(response.body);
        // print('result = $result');

        if (result.toString() == 'null') {
          myAlert('User False', 'No Username in my Database');
        } else {
        
            if (result['status']) {
            String token = result['token'];
            token = token.split(' ').last;
            // print(token);
            if (token.isNotEmpty) {
              prefs = await SharedPreferences.getInstance();
              await prefs.setString('stoken', token);
              //  read value from store_preference
              //  uid: user.fname, prv: user.province, priv: user.privilege
              await prefs.setString('suid', result['uid']);
              await prefs.setString('sprv', result['prv']);
              await prefs.setInt(
                  'spriv', result['priv']); //store preference Integer
              await prefs.setString('srelate', result['relate']);
              await prefs.setString('sfulln', result['fullname']);
              // String sValue = prefs.getString('stoken');
              // print(sValue);
              // print(prefs.getInt('spriv').toString());
              
              // String urlString2 =
              //     'http://8a7a08360daf.sn.mynetname.net:2528/api/flutterget/123456';
              // var response2 = await get(urlString2,
              //     headers: {HttpHeaders.authorizationHeader: "JWT $sValue"});
              // if (response2.statusCode == 200) {
              //   print(response2.statusCode);
              //   var result2 = json.decode(response2.body);
              //   if (result2['status']) {
              //     String getmessage = result2['message'];
              //     print(getmessage);
              //     myAlert('OK', response2.statusCode.toString());
              //   } else {
              //     print('message = Null');
              //   }
              // } else {
              //   myAlert('Error', response2.statusCode.toString());
              // }

              setState(() {
                privilege = 1;
              });
            } else {
              myAlert('Respond Fail', 'Backend Not Reply,Session empty');
            }
          } else {
            // print(result['error']);
            myAlert('Error', response.statusCode.toString());
          }
        } // End else result.toString() != 'null'
      } else {
        //check respond = 200
        myAlert('Error->Backend error', response.statusCode.toString());
      }
    } // End If check emailstring.length
  }

  void myAlert(String titleString, String messageString) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: showTitleAlert(titleString),
          content: Text(messageString),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Widget showTitleAlert(String title) {
    return ListTile(
      leading: Icon(
        Icons.add_alert,
        size: 36.0,
        color: Colors.red,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 24.0, color: Colors.red.shade800),
      ),
    );
  }

  Widget showText() {
    return Text(
      'ตรวจสอบสิทธิ Line User\r\n นี้กดปุ่ม Check ถ้าไม่มี\r\n สิทธิ ให้ปัดขอบจอซ้าย \r\n เลือกลงทะเบียน',
      style: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          color: Colors.brown[800],
          fontFamily: 'PermanentMarker'),
    );
  }

  Widget mySizeBox() {
    return SizedBox(
      width: 8.0,
    );
  }

  //height: 200

  Widget mySizeBoxH() {
    return SizedBox(
      height: 20.0,
    );
  }

  Widget myButton() {
    return Container(
      width: 220.0,
      child: Row(
        children: <Widget>[
          Expanded(
            child: signInButton(),
          ),
          mySizeBox(),
          Expanded(
            child: signOutButton(),
          ),
        ],
      ),
    );
  }

  Widget signInButton() {
    return OutlineButton(
        borderSide: BorderSide(color: Colors.green.shade900),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          'check',
          style: TextStyle(color: Colors.green.shade900),
        ),
        onPressed: () {
          checkAuthen();
        });
  }

  Widget signOutButton() {
    return OutlineButton(
      borderSide: BorderSide(color: Colors.green.shade900),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Text(
        '',
        style: TextStyle(color: Colors.green.shade900),
      ),
      // onPressed: widget.onSignOutPressed,
      onPressed: () {
        print('You Click SignOut');
        //print(widget.userProfile.displayName.toString());
        // widget.onSignOutPressed();

        // var backHomeRoute = MaterialPageRoute(
        //     builder: (BuildContext context) =>
        //         Register(lineid: widget.userProfile.userId));
        // Navigator.of(context)
        //     .pushAndRemoveUntil(backHomeRoute, (Route<dynamic> route) => false);
        // var registerRoute =
        //     MaterialPageRoute(builder: (BuildContext context) => Register(lineid: widget.userProfile.userId, deviceid: _platformImei));
        // Navigator.of(context).push(registerRoute);
      },
    );
  }

  Widget myHome() {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login by $nameString'),
      // ),
      body: Center(
        child: (widget.userProfile.pictureUrl.isNotEmpty)
            ? Image.network(widget.userProfile.pictureUrl,
                width: 200, height: 200)
            : Icon(Icons.person),
        // child: Text('Login by $nameString'),
      ),
    );
  }

  Widget myHome2() {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: true,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.white, Colors.green.shade900],
              radius: 1.2,
            ),
          ),
          alignment: Alignment.center,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // showLogo(),
                showText(),
                mySizeBoxH(),
                myButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'images/drawer1.png'), // https://pixabay.com/th/photos/phuket-unseen-unseen-phuket-plant-3664495/
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Login: $nameString',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.brown[800],
            ),
          ),
        ],
      ),
    );
  }

  // widget.userProfile.displayName
  Widget listShowUser() {
    return ListTile(
      leading: Icon(
        Icons.group_add,
        size: 36.0,
        color: Colors.green[400],
      ),
      title: Text(
        'ลงทะเบียน User',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        // Navigator.of(context).pop();
        var registerRoute =
            MaterialPageRoute(builder: (BuildContext context) => Register(lineid: widget.userProfile.userId, deviceid: _platformImei));
        Navigator.of(context).push(registerRoute);
        setState(() {
          // myWidget = Register();
          // Navigator.of(context).pop();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget menuFormPage() {
    return ListTile(
      leading: Icon(
        Icons.filter_1,
        size: 36.0,
        color: Colors.green[400],
      ),
      title: Text(
        'นำเข้า ONU',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          // myWidget = Register();
          // Navigator.of(context).pop();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget menuListViewPage() {
    return ListTile(
      leading: Icon(
        Icons.filter_2,
        size: 36.0,
        color: Colors.red,
      ),
      title: Text(
        'จ่าย ONU',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          myWidget = ImportOnu();
          // Navigator.of(context).pop();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget menuInstallOnu() {
    return ListTile(
      leading: Icon(
        Icons.filter_3,
        size: 36.0,
        color: Colors.brown[400],
      ),
      title: Text(
        'ติดตั้ง ONU (New)',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          myWidget = InstallOnu();
          // Navigator.of(context).pop();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget menuPickupOnu() {
    return ListTile(
      leading: Icon(
        Icons.filter_4,
        size: 36.0,
        color: Colors.blue,
      ),
      title: Text(
        'เก็บคืน ONU',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          myWidget = PickupOnu();
          // Navigator.of(context).pop();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget menuCleanOnu() {
    return ListTile(
      leading: Icon(
        Icons.filter_5,
        size: 36.0,
        color: Colors.cyan,
      ),
      title: Text(
        'ตรวจสอบ/ทำความสะอาด ONU',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          myWidget = CleanOnu();
          // Navigator.of(context).pop();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget menuReuseOnu() {
    return ListTile(
      leading: Icon(
        Icons.filter_6,
        size: 36.0,
        color: Colors.deepPurple,
      ),
      title: Text(
        'นำ ONU ที่ผ่านขั้นตอนที่5 มาใช้ใหม่',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          myWidget = ReusedOnu();
          // Navigator.of(context).pop();
        });
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  Widget menuLogout() {
    return ListTile(
      leading: Icon(
        Icons.filter_7,
        size: 36.0,
        color: Colors.deepOrangeAccent,
      ),
      title: Text(
        'ออกจาก App',
        style: TextStyle(fontSize: 18.0),
      ),
      // on tap == on click
      onTap: () {
        // widget.onSignOutPressed();
        clearSharePreferance(context);
        // Navigator.of(context).pop();
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  // clearSharePreferance(context);
  void clearSharePreferance(BuildContext context) async {
    widget.onSignOutPressed();
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.clear();
      var backHomeRoute =
          MaterialPageRoute(builder: (BuildContext context) => App());
      Navigator.of(context)
          .pushAndRemoveUntil(backHomeRoute, (Route<dynamic> route) => false);
    });
  }

  Widget myDrawer() {
    return Drawer(
      // child: file == null ? Image.asset('images/pic.png') : Image.file(file),
      child: privilege == 1
          ? ListView(
              children: <Widget>[
                myDrawerHeader(),
                // showMenuFood(),
                // (widget.uid.isEmpty) ? showMenuInfo() : showBack(),
                // Divider(),
                menuFormPage(),
                Divider(),
                menuListViewPage(),
                Divider(),
                menuInstallOnu(),
                Divider(),
                menuPickupOnu(),
                Divider(),
                menuCleanOnu(),
                Divider(),
                menuReuseOnu(),
                Divider(),
                menuLogout(),
                Divider(),
                // showBack(),
              ],
            )
          : ListView(
              children: <Widget>[
                myDrawerHeader(),
                listShowUser(),
                Divider(),
                // menuLogout(),
                // Divider(),
                // showBack(),
              ],
            ),
    );
  }

  Widget showLogin() {
    return Container(
      alignment: Alignment.topLeft,
      child: ListTile(
        title: Text(
          '-> ONU Storage',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'Login by $nameString',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget uploadButton() {
    return IconButton(
      icon: Icon(Icons.exit_to_app),
      onPressed: () {
        print('test exit press');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: privilege == 0
            ? new Scaffold(
                body: myHome2(), // call widget = myhome() in this page
                drawer: myDrawer(),
              )
            : new Scaffold(
                body: myWidget,
                drawer: myDrawer(),
              ));
  }
}
