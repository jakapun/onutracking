import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onutracking/src/app.dart';
import 'package:onutracking/src/screen/api_page.dart';
import 'package:onutracking/src/screen/clean_onu.dart';
import 'package:onutracking/src/screen/import_onu.dart';
import 'package:onutracking/src/screen/install_onu.dart';
import 'package:onutracking/src/screen/payed_onu.dart';
import 'package:onutracking/src/screen/pickup_onu.dart';
// import 'package:onutracking/src/screen/register.dart';
import 'package:onutracking/src/screen/reused_onu.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Testfull extends StatefulWidget {

  final String data;
  final String uid;
  // final Function fun;

  Testfull({
    Key key,
    @required this.data, this.uid,
  }) : super(key: key);

  @override
  _TestfullState createState() => _TestfullState();
}

class _TestfullState extends State<Testfull> {

  String nameString = '';
  Widget myWidget = APIPage();
  SharedPreferences prefs;
  // int idLoginInt;
  // String typeString;

  @override
  void initState() {
    super.initState();
    setState(() {
      nameString = widget.data;
    });
    preAuthen();
    getCredectial();
  }

  Future<void> preAuthen() async {

    prefs = await SharedPreferences.getInstance();

    setState(() {

    prefs.setString('sdata', widget.data);
    prefs.setString('suid', widget.uid);
    });
    
    // String sValue = prefs.getString('stoken');
    // print(sValue);

  }

  Future<void> getCredectial() async {
    // sharePreferances = await SharedPreferences.getInstance();
    // setState(() {
    //   rememberBool = sharePreferances.getBool('Remember');
    //   idLoginInt = sharePreferances.getInt('id');
    //   typeString = sharePreferances.getString('Type');
    //   print('idLoginInt ==> $idLoginInt, currentToken ==> $myToken');
    // });
  }

  Future<bool> _onBackPressed(){
    return showDialog(
      context: context,
      builder: (context)=>CupertinoAlertDialog(
        title: Text('คุณต้องการ ออกจากระบบ \r\n แต่ไม่ออกจาก login line \r\n หริอไม่ ?'),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: ()=>Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: ()=>Navigator.pop(context, true),
          )
        ],
      )
    );
  }

  Widget showLogo() {
    return Container(
      width: 160.0,
      height: 160.0,
      child: Image.asset('images/drawer1.png'),
    );
  }

  Widget showApp() {
    return Text(
      'ONU Life Cycle',
      style: TextStyle(
        fontSize: 20.0,
        color: Colors.brown,
      ),
    );
  }

  Widget showAbbr() {
    return Text(
      'Login by $nameString',
      style: TextStyle(
        fontSize: 15.0,
        color: Colors.black,
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
          // showLogo(),
          // showApp(),
          // showAbbr(),
        ],
      ),
    );
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
          myWidget = PayOnu();
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
        clearSharePreferance(context);
      },
    ); // https://material.io/resources/icons/?style=baseline
  }

  // clearSharePreferance(context);
  void clearSharePreferance(BuildContext context) async {
    
    prefs = await SharedPreferences.getInstance();
    setState(() {
      
      prefs.clear();
      var backHomeRoute =
          MaterialPageRoute(builder: (BuildContext context) => App());
      Navigator.of(context)
          .pushAndRemoveUntil(backHomeRoute, (Route<dynamic> route) => false);
      
    });
  }

  Widget showMenuFood() {
    return ListTile(
      leading: Icon(Icons.home),
      title: Text('Menu Food'),
      onTap: () {
        setState(() {
          // myWidget = FoodListView();
          // Navigator.of(context).pop();
        });
      },
    );
  }

  
  Widget showMenuInfo() {
    return ListTile(
      leading: Icon(Icons.info),
      title: Text('Information'),onTap: (){
        setState(() {
          // myWidget = Register();
          Navigator.of(context).pop();
        });
      },
    );
  }

  Widget showBack() {
    return ListTile(
      leading: Icon(Icons.info),
      title: Text('Logout'),
      onTap: (){
        Navigator.of(context).pop();
      },
    );
  }

  Widget myDrawer() {
    return Drawer(
      // child: file == null ? Image.asset('images/pic.png') : Image.file(file),
      child: nameString != null ? ListView(
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
      ) : ListView (
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
    // return MaterialApp(
    //   theme: ThemeData(
    //     primaryColor: Colors.green, 
    //     indicatorColor: Colors.white
    //   ),
    //   home: Scaffold(
    //     appBar: AppBar(
    //       title: Text('Login by $nameString'),
    //     ),
    //     body: Center(
    //       child: Text('Running on: $nameString\n'),
    //       // child: Text('Login by $nameString'),
    //     ),
    //   ),
    // );
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
    
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: showLogin(),
        actions: <Widget>[uploadButton()],
      ),
      body: myWidget,
      drawer: myDrawer(),
    ));
  }
}