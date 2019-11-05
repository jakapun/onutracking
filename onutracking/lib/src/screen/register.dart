import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:onutracking/src/screen/api_page.dart';

class Register extends StatefulWidget {

  // final String uid;
  // // final Function fun;

  // Register({
  //   Key key,
  //   @required this.uid,
  // }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Explicit
  final formKey = GlobalKey<FormState>();
  String nameString, emailString, passwordString, _mySelection;
  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final String url = "http://webmyls.com/php/getdata.php";

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
    this.getSWData();
  }

  // Method
  Widget nameText() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'ชื่อ นามสกุล :',
        labelStyle: TextStyle(color: Colors.pink[400]),
        helperText: 'Type Firstname Lastname',
        helperStyle: TextStyle(color: Colors.pink[400]),
        icon: Icon(
          Icons.face,
          size: 36.0,
          color: Colors.pink[400],
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Type Firstname,Lastname';
        } else {
            return null;
        }
      },
      onSaved: (String value) {
        nameString = value;
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

  Widget dropdownButton(){
    return DropdownButton(
        icon: Icon(Icons.arrow_downward),
        hint: Text('กรุณาเลือก ส่วน/ศูนย์'),
        iconSize: 36,
        elevation: 26,
        style: TextStyle(
          color: Colors.deepPurple
        ),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
          items: data.map((item) {
            return new DropdownMenuItem(
              child: new Text(item['item_name']),
              value: item['id'].toString(),
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

  Widget uploadButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        print('Upload');
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print(
              'Name = $nameString, Email = $emailString, Pass = $passwordString, Drop = $_mySelection');
          register();
        }
      },
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
          Navigator.of(context).pushAndRemoveUntil(serviceRoute, (Route<dynamic> route) => false);
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
      // appBar: AppBar(
      //   backgroundColor: Colors.green[800],
      //   title: Text('ลงทะเบียน User'),
      //   actions: <Widget>[uploadButton()],
      // ),
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
                nameText(),
                emailText(),
                passwordText(),
                dropdownButton(),
                uploadButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
