import 'package:flutter/material.dart';
import 'validator.dart';
import 'provider.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:flutter_launch/flutter_launch.dart';
import 'image.dart';
import 'url.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: Auth(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData.dark(),
          home: MyHomePage(),
          routes: <String, WidgetBuilder> {
            "/BENEFICIO": (BuildContext context) => new Vacac(),
            "/WORK": (BuildContext context) => new WorkFlow(),
            "/REDAR": (BuildContext context) => new Radar(),
            "/TODOS": (BuildContext context) => new Todos (),
            "/ACCESOS": (BuildContext context) => new Accesos (),
            "/CONTACTOS": (BuildContext context) => new Contactos (),
            "/SUGERENCIAS": (BuildContext context) => new Sugerencia (),
            "/CARTA": (BuildContext context) => new CARTADE (),
            "/glasse": (BuildContext context) => new glass (),
            "/agenda": (BuildContext context) => new descuentos (),
            "/cumple": (BuildContext context) => new cumpleanos (),
            "/home": (BuildContext  context) => new HomePagese (),
            "/log": (BuildContext  context) => new LoginPage (),
            "/face": (BuildContext  context) => new facebook(),
          }
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool loggedIn = snapshot.hasData;
          if (loggedIn == true) {
            return HomePagese();
          } else {
            return LoginPage();
          }
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome Page'),
          actions: <Widget>[
            FlatButton(
              child: Text("Sign Out"),
              onPressed: () async {
                try {
                  Auth auth = Provider.of(context).auth;
                  await auth.signOut();
                } catch(e) {
                  print(e);
                }
              },
            )
          ],
        ),
        body: Container(
          child: Center(
            child: Text('Welcome'),
          ),
        )
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  String _email, _password;
  FormType _formType = FormType.login;

  bool validate() {
    final form = formKey.currentState;
    form.save();
    if(form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        if (_formType == FormType.login) {
          String userId = await auth.signInWithEmailAndPassword(
            _email, _password,);

          print('Signed in $userId');
        } else {
          String userId = await auth.createUserWithEmailAndPassword(
              _email, _password);

          print('Registered in $userId');
        }
      }catch (e) {
        print(e);
      }
    }
  }

  void switchFormState(String state) {
    formKey.currentState.reset();

    if(state == 'register') {
      setState(() {
        _formType = FormType.register;
      });
    } else {
      setState(() {
        _formType = FormType.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SEC LOGIN'),
        backgroundColor: Colors.teal,
      ),
      body: Center(

        child: Form(
          key: formKey,
          child: Column(
            children: buildInputs() + buildButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        validator: EmailValidator.validate,
        decoration: InputDecoration(labelText: 'Email'),
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        validator: PasswordValidator.validate,
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          child: Text('Login'),
          onPressed: submit,
        ),

        FlatButton(
          child: Text("Log In Anonymously"),
          onPressed: () {Navigator.of(context).pushNamed("/home");},
        ),
      ];
    }
  }
}

class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;
  CustomListTile(this.icon,this.text,this.onTap);
  @override
  Widget build (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black))
        ),
        child: InkWell(
          splashColor: Colors.tealAccent,
          onTap: onTap,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(text, style: TextStyle(
                          fontSize: 16.0
                      )),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_right)
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class BENEFICIO extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  BENEFICIO (this.icon,this.text,this.onTap);
  @override
  Widget build (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black))
        ),
        child: InkWell(
          splashColor: Colors.tealAccent,
          onTap: () {Navigator.of(context).pushNamed("/BENEFICIO");},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(text, style: TextStyle(
                          fontSize: 16.0
                      )),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_right)
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Work extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  Work (this.icon,this.text,this.onTap);
  @override
  Widget build (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black))
        ),
        child: InkWell(
          splashColor: Colors.tealAccent,
          onTap: () {Navigator.of(context).pushNamed("/WORK");},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(text, style: TextStyle(
                          fontSize: 16.0
                      )),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_right)
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Radars extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  Radars (this.icon,this.text,this.onTap);
  @override
  Widget build (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black))
        ),
        child: InkWell(
          splashColor: Colors.tealAccent,
          onTap: () {Navigator.of(context).pushNamed("/REDAR");},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(text, style: TextStyle(
                          fontSize: 16.0
                      )),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_right)
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Promotores extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  Promotores (this.icon,this.text,this.onTap);
  @override
  Widget build (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black))
        ),
        child: InkWell(
          splashColor: Colors.tealAccent,
          onTap: () {Navigator.of(context).pushNamed("/TODOS");},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(text, style: TextStyle(
                          fontSize: 16.0
                      )),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_right)
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Directos extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  Directos (this.icon,this.text,this.onTap);
  @override
  Widget build (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black))
        ),
        child: InkWell(
          splashColor: Colors.tealAccent,
          onTap: () {Navigator.of(context).pushNamed("/ACCESOS");},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(text, style: TextStyle(
                          fontSize: 16.0
                      )),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_right)
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Telnor extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  Telnor (this.icon,this.text,this.onTap);
  @override
  Widget build (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black))
        ),
        child: InkWell(
          splashColor: Colors.tealAccent,
          onTap: () {void whatsAppOpen(tel,mess) async {
            await FlutterLaunch.launchWathsApp(phone: tel, message: mess);
          }
          whatsAppOpen(numerodewhatsapp, "Hi");
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(text, style: TextStyle(
                          fontSize: 16.0
                      )),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_right)
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Sugerencias extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  Sugerencias (this.icon,this.text,this.onTap);
  @override
  Widget build (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black))
        ),
        child: InkWell(
          splashColor: Colors.tealAccent,
          onTap: () {Navigator.of(context).pushNamed("/SUGERENCIAS");},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(text, style: TextStyle(
                          fontSize: 16.0
                      )),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_right)
            ],
          ),
        ),
      ),
    );
  }
}

class Sesion extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  Sesion (this.icon,this.text,this.onTap);
  @override
  Widget build (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black))
        ),
        child: InkWell(
          splashColor: Colors.tealAccent,
          onTap: () async {
            try {
              Auth auth = Provider.of(context).auth;
              await auth.signOut();
            } catch(e) {
              print(e);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(text, style: TextStyle(
                          fontSize: 16.0
                      )),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_right)
            ],
          ),
        ),
      ),
    );
  }
}

class fb extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  fb (this.icon,this.text,this.onTap);
  @override
  Widget build (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black))
        ),
        child: InkWell(
          splashColor: Colors.tealAccent,
          onTap: () {
            var url= urlconexionfacebook;
            launch(url);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(text, style: TextStyle(
                          fontSize: 16.0
                      )),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_right)
            ],
          ),
        ),
      ),
    );
  }
}

class HomePagese extends StatefulWidget {
  @override
  _HomePageseState createState() => _HomePageseState();
}

class _HomePageseState extends State<HomePagese> {
  Completer<WebViewController> _controller = Completer<WebViewController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conexión Telnor'),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              semanticLabel: 'home',
            ),
            onPressed: () {Navigator.of(context).pushNamed("/home");},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text('${user._email}'),
              accountEmail: new Text("Puesto del Empleado"),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                  )
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.lightGreenAccent,
                child: new Text("P"),
              ),
            ),
            BENEFICIO (Icons.calendar_today, 'Beneficios', ()=>{}),
            Radars (Icons.gps_fixed, 'Radar', ()=>{}),
            Work (Icons.portable_wifi_off, 'Mini AESI', ()=>{}),
            Promotores (Icons.record_voice_over, 'Todos_Promotores', ()=>{}),
            Directos (Icons.location_city, 'Directorio_Tiendas', ()=>{}),
            Telnor (Icons.chat_bubble, 'Whatsapp Conexión', ()=>{}),
            fb (Icons.chat_bubble, 'Facebook Conexión', ()=>{}),
            Sugerencias (Icons.chat, 'Sugerencias', ()=>{}),
            Sesion (Icons.power_settings_new, 'Cerrar Sesion', ()=>{}),
          ],
        ),
      ),

      body: WebView(
        initialUrl: urlhomepage,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}

class Vacac extends StatefulWidget {
  @override
  _VacacState createState() => _VacacState();
}

class _VacacState extends State<Vacac> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        title: Text('Conexión Telnor - Beneficios'),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              semanticLabel: 'home',
            ),
            onPressed: () {Navigator.of(context).pushNamed("/home");},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Nombre del Empleado"),
              accountEmail: new Text("Puesto del Empleado"),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                  )
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.lightGreenAccent,
                child: new Text("P"),
              ),
            ),

            BENEFICIO (Icons.calendar_today, 'Beneficios', ()=>{}),
            Radars (Icons.gps_fixed, 'Radar', ()=>{}),
            Work (Icons.portable_wifi_off, 'Mini AESI', ()=>{}),
            Promotores (Icons.record_voice_over, 'Todos_Promotores', ()=>{}),
            Directos (Icons.location_city, 'Directorio_Tiendas', ()=>{}),
            Telnor (Icons.chat_bubble, 'Whatsapp Conexión', ()=>{}),
            fb (Icons.chat_bubble, 'Facebook Conexión', ()=>{}),
            Sugerencias (Icons.chat, 'Sugerencias', ()=>{}),
            Sesion (Icons.power_settings_new, 'Cerrar Sesion', ()=>{}),
          ],
        ),
      ),
      body: Container(
        child: new Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new  FlatButton(
                  onPressed: null,
                  padding: EdgeInsets.all(0.0),
                  child: Image.asset(imagevacaciones),
                  color: Colors.white,
                ),

                new  FlatButton(
                  onPressed: () {Navigator.of(context).pushNamed("/agenda");},
                  padding: EdgeInsets.all(0.0),
                  child: Image.asset(imagenagendadedescuentos),
                  color: Colors.white,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new  FlatButton(
                  onPressed: null,
                  padding: EdgeInsets.all(0.0),
                  child: Image.asset(imagencreditos),
                  color: Colors.white,
                ), new  FlatButton(
                  onPressed: () {Navigator.of(context).pushNamed("/CARTA");},
                  padding: EdgeInsets.all(0.0),
                  child: Image.asset(imagencartadetrabajo),
                  color: Colors.white,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new  FlatButton(
                  onPressed: () {Navigator.of(context).pushNamed("/glasse");},
                  padding: EdgeInsets.all(0.0),
                  child: Image.asset(imagenlentes),
                  color: Colors.white,
                ), new  FlatButton(
                  onPressed: () {Navigator.of(context).pushNamed("/cumple");},
                  padding: EdgeInsets.all(0.0),
                  child: Image.asset(imagencumpeanos),
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WorkFlow extends StatefulWidget {
  @override
  _WorkFlowState createState() => _WorkFlowState();
}

class _WorkFlowState extends State<WorkFlow> {
  Completer<WebViewController> _controller = Completer<WebViewController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conexión Telnor - MINI AESI'),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              semanticLabel: 'home',
            ),
            onPressed: () {Navigator.of(context).pushNamed("/home");},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Nombre del Empleado"),
              accountEmail: new Text("Puesto del Empleado"),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                  )
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.lightGreenAccent,
                child: new Text("P"),
              ),
            ),
            BENEFICIO (Icons.calendar_today, 'Beneficios', ()=>{}),
            Radars (Icons.gps_fixed, 'Radar', ()=>{}),
            Work (Icons.portable_wifi_off, 'Mini AESI', ()=>{}),
            Promotores (Icons.record_voice_over, 'Todos_Promotores', ()=>{}),
            Directos (Icons.location_city, 'Directorio_Tiendas', ()=>{}),
            Telnor (Icons.chat_bubble, 'Whatsapp Conexión', ()=>{}),
            fb (Icons.chat_bubble, 'Facebook Conexión', ()=>{}),
            Sugerencias (Icons.chat, 'Sugerencias', ()=>{}),
            Sesion (Icons.power_settings_new, 'Cerrar Sesion', ()=>{}),
          ],
        ),
      ),

      body: WebView(
        initialUrl: urlminiaesi,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),

    );
  }
}

class Radar extends StatefulWidget {
  @override
  _RadarState createState() => _RadarState();
}

class _RadarState extends State<Radar> {
  Completer<WebViewController> _controller = Completer<WebViewController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conexión Telnor - RADAR'),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              semanticLabel: 'home',
            ),
            onPressed: () {Navigator.of(context).pushNamed("/home");},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Nombre del Empleado"),
              accountEmail: new Text("Puesto del Empleado"),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                  )
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.lightGreenAccent,
                child: new Text("P"),
              ),
            ),
            BENEFICIO (Icons.calendar_today, 'Beneficios', ()=>{}),
            Radars (Icons.gps_fixed, 'Radar', ()=>{}),
            Work (Icons.portable_wifi_off, 'Mini AESI', ()=>{}),
            Promotores (Icons.record_voice_over, 'Todos_Promotores', ()=>{}),
            Directos (Icons.location_city, 'Directorio_Tiendas', ()=>{}),
            Telnor (Icons.chat_bubble, 'Whatsapp Conexión', ()=>{}),
            fb (Icons.chat_bubble, 'Facebook Conexión', ()=>{}),
            Sugerencias (Icons.chat, 'Sugerencias', ()=>{}),
            Sesion (Icons.power_settings_new, 'Cerrar Sesion', ()=>{}),
          ],
        ),
      ),
      body: WebView(
        initialUrl: urlradar,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),

    );
  }
}

class Todos extends StatefulWidget {
  @override
  _TodosState createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  Completer<WebViewController> _controller = Completer<WebViewController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conexión Telnor - Todos Promotores'),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              semanticLabel: 'home',
            ),
            onPressed: () {Navigator.of(context).pushNamed("/home");},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Nombre del Empleado"),
              accountEmail: new Text("Puesto del Empleado"),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                  )
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.lightGreenAccent,
                child: new Text("P"),
              ),
            ),

            BENEFICIO (Icons.calendar_today, 'Beneficios', ()=>{}),
            Radars (Icons.gps_fixed, 'Radar', ()=>{}),
            Work (Icons.portable_wifi_off, 'Mini AESI', ()=>{}),
            Promotores (Icons.record_voice_over, 'Todos_Promotores', ()=>{}),
            Directos (Icons.location_city, 'Directorio_Tiendas', ()=>{}),
            Telnor (Icons.chat_bubble, 'Whatsapp Conexión', ()=>{}),
            fb (Icons.chat_bubble, 'Facebook Conexión', ()=>{}),
            Sugerencias (Icons.chat, 'Sugerencias', ()=>{}),
            Sesion (Icons.power_settings_new, 'Cerrar Sesion', ()=>{}),
          ],
        ),
      ),
      body: WebView(
        initialUrl: urltodospromotores,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),

    );
  }
}

class Accesos extends StatefulWidget {
  @override
  _AccesosState createState() => _AccesosState();
}

class _AccesosState extends State<Accesos> {
  Completer<WebViewController> _controller = Completer<WebViewController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conexión Telnor - Directorio Telnor'),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              semanticLabel: 'home',
            ),
            onPressed: () {Navigator.of(context).pushNamed("/home");},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Nombre del Empleado"),
              accountEmail: new Text("Puesto del Empleado"),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                  )
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.lightGreenAccent,
                child: new Text("P"),
              ),
            ),

            BENEFICIO (Icons.calendar_today, 'Beneficios', ()=>{}),
            Radars (Icons.gps_fixed, 'Radar', ()=>{}),
            Work (Icons.portable_wifi_off, 'Mini AESI', ()=>{}),
            Promotores (Icons.record_voice_over, 'Todos_Promotores', ()=>{}),
            Directos (Icons.location_city, 'Directorio_Tiendas', ()=>{}),
            Telnor (Icons.chat_bubble, 'Whatsapp Conexión', ()=>{}),
            fb (Icons.chat_bubble, 'Facebook Conexión', ()=>{}),
            Sugerencias (Icons.chat, 'Sugerencias', ()=>{}),
            Sesion (Icons.power_settings_new, 'Cerrar Sesion', ()=>{}),
          ],
        ),
      ),
      body: WebView(
        initialUrl: urldirectoriotelnor,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),

    );
  }
}

class Contactos extends StatefulWidget {
  @override
  _ContactosState createState() => _ContactosState();
}

class _ContactosState extends State<Contactos> {
  Completer<WebViewController> _controller = Completer<WebViewController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conexión Telnor - Whatsapp Conexion'),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              semanticLabel: 'home',
            ),
            onPressed: () {Navigator.of(context).pushNamed("/home");},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Nombre del Empleado"),
              accountEmail: new Text("Puesto del Empleado"),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                  )
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.lightGreenAccent,
                child: new Text("P"),
              ),
            ),

            BENEFICIO (Icons.calendar_today, 'Beneficios', ()=>{}),
            Radars (Icons.gps_fixed, 'Radar', ()=>{}),
            Work (Icons.portable_wifi_off, 'Mini AESI', ()=>{}),
            Promotores (Icons.record_voice_over, 'Todos_Promotores', ()=>{}),
            Directos (Icons.location_city, 'Directorio_Tiendas', ()=>{}),
            Telnor (Icons.chat_bubble, 'Whatsapp Conexión', ()=>{}),
            fb (Icons.chat_bubble, 'Facebook Conexión', ()=>{}),
            Sugerencias (Icons.chat, 'Sugerencias', ()=>{}),
            Sesion (Icons.power_settings_new, 'Cerrar Sesion', ()=>{}),
          ],
        ),
      ),
      body: WebView(
        initialUrl: 'https://wa.me/526643316894',
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}

class Sugerencia extends StatefulWidget {
  @override
  _SugerenciaState createState() => _SugerenciaState();
}

class _SugerenciaState extends State<Sugerencia> {
  Completer<WebViewController> _controller = Completer<WebViewController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conexión Telnor - Sugerencias'),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              semanticLabel: 'home',
            ),
            onPressed: () {Navigator.of(context).pushNamed("/home");},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Nombre del Empleado"),
              accountEmail: new Text("Puesto del Empleado"),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                  )
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.lightGreenAccent,
                child: new Text("P"),
              ),
            ),

            BENEFICIO (Icons.calendar_today, 'Beneficios', ()=>{}),
            Radars (Icons.gps_fixed, 'Radar', ()=>{}),
            Work (Icons.portable_wifi_off, 'Mini AESI', ()=>{}),
            Promotores (Icons.record_voice_over, 'Todos_Promotores', ()=>{}),
            Directos (Icons.location_city, 'Directorio_Tiendas', ()=>{}),
            Telnor (Icons.chat_bubble, 'Whatsapp Conexión', ()=>{}),
            fb (Icons.chat_bubble, 'Facebook Conexión', ()=>{}),
            Sugerencias (Icons.chat, 'Sugerencias', ()=>{}),
            Sesion (Icons.power_settings_new, 'Cerrar Sesion', ()=>{}),
          ],
        ),
      ),
      body: WebView(
        initialUrl: urlsugerencias,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),

    );
  }
}

class CARTADE extends StatefulWidget {
  @override
  _CARTADEState createState() => _CARTADEState();
}

class _CARTADEState extends State<CARTADE> {
  Completer<WebViewController> _controller = Completer<WebViewController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conexión Telnor - Carta de  Trabajo'),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              semanticLabel: 'home',
            ),
            onPressed: () {Navigator.of(context).pushNamed("/home");},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Nombre del Empleado"),
              accountEmail: new Text("Puesto del Empleado"),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                  )
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.lightGreenAccent,
                child: new Text("P"),
              ),
            ),

            BENEFICIO (Icons.calendar_today, 'Beneficios', ()=>{}),
            Radars (Icons.gps_fixed, 'Radar', ()=>{}),
            Work (Icons.portable_wifi_off, 'Mini AESI', ()=>{}),
            Promotores (Icons.record_voice_over, 'Todos_Promotores', ()=>{}),
            Directos (Icons.location_city, 'Directorio_Tiendas', ()=>{}),
            Telnor (Icons.chat_bubble, 'Whatsapp Conexión', ()=>{}),
            fb (Icons.chat_bubble, 'Facebook Conexión', ()=>{}),
            Sugerencias (Icons.chat, 'Sugerencias', ()=>{}),
            Sesion (Icons.power_settings_new, 'Cerrar Sesion', ()=>{}),
          ],
        ),
      ),
      body: WebView(
        initialUrl: urlcartadetrabajo,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),

    );
  }
}

class glass extends StatefulWidget {
  @override
  _glassState createState() => _glassState();
}

class _glassState extends State<glass> {
  Completer<WebViewController> _controller = Completer<WebViewController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conexión Telnor - Solicitud de Lentes'),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              semanticLabel: 'home',
            ),
            onPressed: () {Navigator.of(context).pushNamed("/home");},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Nombre del Empleado"),
              accountEmail: new Text("Puesto del Empleado"),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                  )
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.lightGreenAccent,
                child: new Text("P"),
              ),
            ),

            BENEFICIO (Icons.calendar_today, 'Beneficios', ()=>{}),
            Radars (Icons.gps_fixed, 'Radar', ()=>{}),
            Work (Icons.portable_wifi_off, 'Mini AESI', ()=>{}),
            Promotores (Icons.record_voice_over, 'Todos_Promotores', ()=>{}),
            Directos (Icons.location_city, 'Directorio_Tiendas', ()=>{}),
            Telnor (Icons.chat_bubble, 'Whatsapp Conexión', ()=>{}),
            fb (Icons.chat_bubble, 'Facebook Conexión', ()=>{}),
            Sugerencias (Icons.chat, 'Sugerencias', ()=>{}),
            Sesion (Icons.power_settings_new, 'Cerrar Sesion', ()=>{}),
          ],
        ),
      ),
      body: WebView(
        initialUrl: urlsolicituddelentes,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),

    );
  }
}

class descuentos extends StatefulWidget {
  @override
  _descuentosState createState() => _descuentosState();
}

class _descuentosState extends State<descuentos> {
  Completer<WebViewController> _controller = Completer<WebViewController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conexión Telnor - Agenda de Descuentos'),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              semanticLabel: 'home',
            ),
            onPressed: () {Navigator.of(context).pushNamed("/home");},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Nombre del Empleado"),
              accountEmail: new Text("Puesto del Empleado"),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                  )
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.lightGreenAccent,
                child: new Text("P"),
              ),
            ),

            BENEFICIO (Icons.calendar_today, 'Beneficios', ()=>{}),
            Radars (Icons.gps_fixed, 'Radar', ()=>{}),
            Work (Icons.portable_wifi_off, 'Mini AESI', ()=>{}),
            Promotores (Icons.record_voice_over, 'Todos_Promotores', ()=>{}),
            Directos (Icons.location_city, 'Directorio_Tiendas', ()=>{}),
            Telnor (Icons.chat_bubble, 'Whatsapp Conexión', ()=>{}),
            fb (Icons.chat_bubble, 'Facebook Conexión', ()=>{}),
            Sugerencias (Icons.chat, 'Sugerencias', ()=>{}),
            Sesion (Icons.power_settings_new, 'Cerrar Sesion', ()=>{}),
          ],
        ),
      ),
      body: WebView(
        initialUrl: urlagendadedescuentos,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),

    );
  }
}

class cumpleanos extends StatefulWidget {
  @override
  _cumpleanosState createState() => _cumpleanosState();
}

class _cumpleanosState extends State<cumpleanos> {
  Completer<WebViewController> _controller = Completer<WebViewController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conexión Telnor - Cumpleaños'),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              semanticLabel: 'home',
            ),
            onPressed: () {Navigator.of(context).pushNamed("/home");},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Nombre del Empleado"),
              accountEmail: new Text("Puesto del Empleado"),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                  )
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.lightGreenAccent,
                child: new Text("P"),
              ),
            ),

            BENEFICIO (Icons.calendar_today, 'Beneficios', ()=>{}),
            Radars (Icons.gps_fixed, 'Radar', ()=>{}),
            Work (Icons.portable_wifi_off, 'Mini AESI', ()=>{}),
            Promotores (Icons.record_voice_over, 'Todos_Promotores', ()=>{}),
            Directos (Icons.location_city, 'Directorio_Tiendas', ()=>{}),
            Telnor (Icons.chat_bubble, 'Whatsapp Conexión', ()=>{}),
            fb (Icons.chat_bubble, 'Facebook Conexión', ()=>{}),
            Sugerencias (Icons.chat, 'Sugerencias', ()=>{}),
            Sesion (Icons.power_settings_new, 'Cerrar Sesion', ()=>{}),
          ],
        ),
      ),
      body: WebView(
        initialUrl: urlcumpleanos,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),

    );
  }
}

class facebook extends StatefulWidget {
  @override
  _facebookState createState() => _facebookState();
}

class _facebookState extends State<facebook> {
  Completer<WebViewController> _controller = Completer<WebViewController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conexión Telnor - Facebook Conexión'),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              semanticLabel: 'home',
            ),
            onPressed: () {
              Navigator.of(context).pushNamed("/home");
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Nombre del Empleado"),
              accountEmail: new Text("Puesto del Empleado"),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fondo.jpg"),
                  )
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.lightGreenAccent,
                child: new Text("P"),
              ),
            ),

            BENEFICIO(Icons.calendar_today, 'Beneficios', () => {}),
            Radars(Icons.gps_fixed, 'Radar', () => {}),
            Work(Icons.portable_wifi_off, 'Mini AESI', () => {}),
            Promotores(Icons.record_voice_over, 'Todos_Promotores', () => {}),
            Directos(Icons.location_city, 'Directorio_Tiendas', () => {}),
            Telnor(Icons.chat_bubble, 'Whatsapp Conexión', () => {}),
            fb(Icons.chat_bubble, 'Facebook Conexión', () => {}),
            Sugerencias(Icons.chat, 'Sugerencias', () => {}),
            Sesion(Icons.power_settings_new, 'Cerrar Sesion', () => {}),
          ],
        ),
      ),
      body: WebView(
        initialUrl: 'https://m.me/morenozatarain',
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),

    );
  }
}

