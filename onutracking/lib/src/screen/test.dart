import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onutracking/src/screen/api_page.dart';
import 'package:onutracking/src/screen/register.dart';


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

  @override
  void initState() {
    super.initState();
    setState(() {
      nameString = widget.data;
    });
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
      child: Image.asset('images/odn_0.jpg'),
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
              'images/odn_0.jpg'), // https://pixabay.com/th/photos/phuket-unseen-unseen-phuket-plant-3664495/
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
          myWidget = Register();
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
      child: ListView(
        children: <Widget>[
          myDrawerHeader(),
          showMenuFood(),
          (widget.uid.isEmpty) ? showMenuInfo() : showBack(),
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
          '-> ONU Tracking',
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