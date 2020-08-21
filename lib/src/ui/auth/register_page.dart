import 'package:beacontcc/src/resources/auth_resources.dart';
import 'package:beacontcc/src/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = 'register_page';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var maskFormatter = new MaskTextInputFormatter(mask: '###.###.###-##', filter: { "#": RegExp(r'[0-9]') });

  TextEditingController _emailController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  final authRes = AuthenticationResources();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          children: <Widget>[
            SizedBox(height: 80,),
            Column(
              children: <Widget>[

                Text(
                  "TCC Beacon",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                  ),
                )
                // logo
              ],
            ),

            SizedBox(height: 50,),
            AccentOverride(
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: "Email",
                    filled: true
                ),
              ),
            ),
            SizedBox(height: 12,),

            AccentOverride(
              child: TextField(
                controller: _cpfController,
                decoration: InputDecoration(
                    labelText: "CPF",
                    filled: true,
                ),
                inputFormatters: [maskFormatter],
                keyboardType: TextInputType.number,
              ),
            ),

            SizedBox(height: 12,),
            AccentOverride(
              child: TextField(
                controller: _senhaController,
                decoration: InputDecoration(
                  labelText: "Senha",
                  filled: true,
                ),
                obscureText: true,
              ),
            ),

            !_loading ? ButtonBar(
              children: <Widget>[
                Builder(
                  builder: (context) {
                    return RaisedButton(
                      child: Text('Cadastrar'),
                      color: ColorUtils.ORANGE_DARK,
                      onPressed: () async {
                        if(_emailController.text.length == 0 ||
                            _cpfController.text.length == 0 ||
                            _senhaController.text.length == 0) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Você precisa preencher todos os campos!",),
                            action: SnackBarAction(
                              label: 'OK',
                              onPressed: () {
                              },
                            ),
                          ));
                        } else {
                          if(_cpfController.text.length < 14) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("CPF deve ser preenchido corretamente!!",),
                              action: SnackBarAction(
                                label: 'OK',
                                onPressed: () {
                                },
                              ),
                            ));
                          } else {
                            if(_senhaController.text.length < 6) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Senha deve ser conter, no mínimo, 6 caracteres!!",),
                                action: SnackBarAction(
                                  label: 'OK',
                                  onPressed: () {
                                  },
                                ),
                              ));
                            } else {
                              Pattern emailPattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regex = new RegExp(emailPattern);
                              if (!regex.hasMatch(_emailController.text)) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text("Esse email não é válido!!",),
                                  action: SnackBarAction(
                                    label: 'OK',
                                    onPressed: () {
                                    },
                                  ),
                                ));
                              } else {
                                setState(() {
                                  _loading = true;
                                });
                                int res = await authRes.signUpWithEmailAndPassword(_emailController.text, _senhaController.text);
                                if(res != 1) {

                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text("Falha ao realizar Registro.",),
                                    action: SnackBarAction(
                                      label: 'OK',
                                      onPressed: () {
                                      },
                                    ),
                                  ));

                                  setState(() {
                                    _loading = false;
                                  });
                                }
                              }
                            }
                          }
                        }
                      },
                    );
                  },
                ),

                FlatButton(
                  child: Text('Logar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ) : Container(
              margin: EdgeInsets.only(top: 15, right: 15),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
