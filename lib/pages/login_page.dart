import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fire2/screens/BooksList.dart';
import 'package:flutter_fire2/utils/google.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fire2/utils/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Color colors = Color(0xfffe9721);

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: () async {
        await signInWithGoogle();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ShowBooks()));
      },
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () {
              print('Login with Facebook');
            },
            AssetImage(
              'images/facebook.jpg',
            ),
          ),
          _buildSocialBtn(
            () async {
              await signInWithGoogle();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ShowBooks()));
            },
            AssetImage(
              'images/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      // Color(0xFF73AEF5),
                      // Color(0xFF61A4F1),
                      // Color(0xFF478DE0),
                      // Color(0xFF398AE5),

                      Color(0xFFA1887F),
                      Color(0xFF795548),
                      Color(0xFF5D4037),
                      Color(0xFF4E342E),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 60.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'LeonSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      EmailUi(),
                      SizedBox(
                        height: 30.0,
                      ),
                      PasswordUi(),
                      ForgotPasswordBtn(),
                      RememberMe(),
                      LoginBtn(),
                      SigninBtn(),
                      _buildSocialBtnRow(),
                      SignUp(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
