import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/screens/login_screen.dart';
import 'package:did_you_buy_it/screens/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatefulWidget {
  final bool isLogin;

  const AuthHeader({Key? key, required this.isLogin}) : super(key: key);

  @override
  _AuthHeaderState createState() => _AuthHeaderState();
}

class _AuthHeaderState extends State<AuthHeader> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/images/header_background.png"),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/app_logo.png"),
                        height: 120,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: widget.isLogin ? underlineBoxDecoration : null,
                          child: Text(
                            "LOGIN",
                            style: widget.isLogin ? primaryElementStyle : secondaryElementStyle,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if(widget.isLogin) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RegisterScreen()),
                              );
                            }
                          },
                          child: Container(
                            decoration: !widget.isLogin ? underlineBoxDecoration : null,
                            child: Text(
                              "REGISTER",
                              style: !widget.isLogin ? primaryElementStyle : secondaryElementStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(flex: 1),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
