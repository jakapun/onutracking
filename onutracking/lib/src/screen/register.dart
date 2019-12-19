import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:onutracking/src/screen/api_page.dart';

class Register extends StatefulWidget {
  final String lineid, deviceid;

  Register({
    Key key,
    @required this.lineid,
    this.deviceid,
  }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Explicit

  final formKey = GlobalKey<FormState>();
  String nameStringf,
      nameStringl,
      emailString,
      passwordString,
      _mySelection,
      getlineid,
      getdeviceid;
  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final String url =
      "http://8a7a08360daf.sn.mynetname.net:2528/api/getprovince";

  List data = List(); //edited line

  Future<String> getSWData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });

    print(resBody);

    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    getlineid = widget.lineid;
    getdeviceid = widget.deviceid;
    this.getSWData();
  }

  // Method
  Widget nameTextf() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'ชื่อ :',
        labelStyle: TextStyle(color: Colors.orange),
        helperText: 'Type Firstname',
        helperStyle: TextStyle(color: Colors.orange),
        icon: Icon(
          Icons.face,
          size: 36.0,
          color: Colors.orange,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Type Firstname';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        nameStringf = value;
      },
    );
  }

  Widget nameTextl() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'นามสกุล :',
        labelStyle: TextStyle(color: Colors.pink[400]),
        helperText: 'Type Lastname',
        helperStyle: TextStyle(color: Colors.pink[400]),
        icon: Icon(
          Icons.face,
          size: 36.0,
          color: Colors.pink[400],
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Type Lastname';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        nameStringl = value;
      },
    );
  }

  Widget emailText() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'รหัสพนักงาน/OS :',
        labelStyle: TextStyle(color: Colors.blue),
        helperText: 'TOT Employee Id',
        helperStyle: TextStyle(color: Colors.blue),
        icon: Icon(
          Icons.email,
          size: 36.0,
          color: Colors.blue,
        ),
      ),
      validator: (String value) {
        // if (!((value.contains('@')) && (value.contains('.')))) {
        if (value.length <= 5) {
          return 'Type Employee Id';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        emailString = value;
      },
    );
  }

  Widget passwordText() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'พาสเวิร์ด :',
        labelStyle: TextStyle(color: Colors.green),
        helperText: 'More 6 Charactor',
        helperStyle: TextStyle(color: Colors.green),
        icon: Icon(
          Icons.lock,
          size: 36.0,
          color: Colors.green,
        ),
      ),
      validator: (String value) {
        if (value.length <= 5) {
          return 'Password Much More 6 Charactor';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        passwordString = value;
      },
    );
  }

  Widget dropdownButton() {
    return DropdownButton(
      icon: Icon(Icons.arrow_downward),
      hint: Text('กรุณาเลือก จังหวัด'),
      iconSize: 36,
      elevation: 26,
      style: TextStyle(
        color: Colors.deepPurple,
        fontSize: 18.0,
      ),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: data.map((item) {
        return new DropdownMenuItem(
          child: new Text(item['province']),
          value: item['EN'],
        );
      }).toList(),
      onChanged: (newVal) {
        setState(() {
          _mySelection = newVal;
        });
      },
      value: _mySelection,
    );
  }

  // Widget uploadButton() {
  //   return IconButton(
  //     icon: Icon(Icons.cloud_upload),
  //     onPressed: () {
  //       print('Upload');
  //       if (formKey.currentState.validate()) {
  //         formKey.currentState.save();
  //         print(
  //             'Name = $nameString, Email = $emailString, Pass = $passwordString, Drop = $_mySelection');
  //         register();
  //       }
  //     },
  //   );
  // }

  Widget uploadValueButton() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // จัดตำแหน่ง FloatingActionButton
      children: <Widget>[
        FloatingActionButton(
          elevation: 15.0,
          // foregroundColor: Colors.green[900],
          tooltip: 'กดเพื่อ Register User',
          child: Icon(
            Icons.cloud_upload,
            size: 40.0,
          ),

          onPressed: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              if ((getdeviceid.isEmpty) || (getlineid.isEmpty)) {
                myAlert('มีข้อผิดพลาด',
                    'ไม่มี Line UserId  \r\n ไม่มี DeviceId \r\n ที่ต้องใช้งาน');
              } else {
                print(
                    'line User id = $getlineid, DeviceID = $getdeviceid, namef = $nameStringf, namel = $nameStringl, totid = $emailString');
                
              }
            }
          },
        ),
      ],
    );
  }

  Future<void> register() async {
    // await firebaseAuth
    //     .createUserWithEmailAndPassword(
    //   email: emailString,
    //   password: passwordString,
    // )
    //     .then((objResponse) {
    print('Register Success');
    setUpDisplayName();
    // }).catchError((objResponse) {
    //   print('${objResponse.toString()}');
    //   myAlert(objResponse.code.toString(), objResponse.message.toString());
    // });
  }

  Future<void> setUpDisplayName() async {
    // await firebaseAuth.currentUser().then((response) {
    //   UserUpdateInfo updateInfo = UserUpdateInfo();
    //   updateInfo.displayName = nameString;
    //   response.updateProfile(updateInfo);

    var serviceRoute =
        MaterialPageRoute(builder: (BuildContext context) => APIPage());
    Navigator.of(context)
        .pushAndRemoveUntil(serviceRoute, (Route<dynamic> route) => false);
    // });
  }

  void myAlert(String titleString, String messageString) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            titleString,
            style: TextStyle(color: Colors.red),
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text('ลงทะเบียน User'),
        // actions: <Widget>[uploadButton()],
      ),
      body: Form(
        key: formKey,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 60.0),
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.8),
            ),
            width: 300.0,
            height: 700.0,
            child: Column(
              children: <Widget>[
                nameTextf(),
                nameTextl(),
                emailText(),
                // passwordText(),
                dropdownButton(),
                uploadValueButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
