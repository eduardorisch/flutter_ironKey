import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ironkey/app_theme.dart';
import 'package:ironkey/password_generator.dart';
import 'package:ironkey/password_type_enum.dart';
import 'package:ironkey/pin_password_generator.dart';
import 'package:ironkey/standart_password_generator.dart';

void main() {
  runApp(IronKeyApp());
}

class IronKeyApp extends StatelessWidget {
  const IronKeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: app_theme.lightTheme,
      darkTheme: app_theme.darkTheme,
      themeMode: ThemeMode.system,
      home: IronKeyScreen(),
    );
  }
}

class IronKeyScreen extends StatefulWidget {
  const IronKeyScreen({super.key});

  @override
  State<IronKeyScreen> createState() => __IronKeyScreenStateState();
}

class __IronKeyScreenStateState extends State<IronKeyScreen> {
  final TextEditingController _passwordController = TextEditingController();

  bool isEditable = true;

  PasswordTypeEnum passwordTypeSelected = PasswordTypeEnum.pin;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void copyPassword(String password) {
    Clipboard.setData(ClipboardData(text: password));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Senha copiada!')));
  }

  void generatePassword() {
    final PasswordGenerator generator;
    switch(passwordTypeSelected) {
    case PasswordTypeEnum.pin:
      generator = PinPasswordGenerator();
      break;
    case PasswordTypeEnum.standard:
      generator = StandardPasswordGenerator();
      break;
    }

    setState(() {
      _passwordController.text = generator.generate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.asset(
                          "images/ferro.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Sua senha segura",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      enabled: isEditable,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Omen Fero",
                        border: OutlineInputBorder(),
                        prefix: Icon(Icons.lock),
                        suffix: _passwordController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  copyPassword(_passwordController.text);
                                },
                                icon: Icon(Icons.copy),
                              )
                            : null,
                      ),
                      maxLength: 12,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Tipo senha"),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            value: PasswordTypeEnum.pin,
                            groupValue: passwordTypeSelected,
                            title: Text("PIN"),
                            onChanged: (value) {
                              setState(() {
                                passwordTypeSelected = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            value: PasswordTypeEnum.standard,
                            groupValue: passwordTypeSelected,
                            title: Text("Padrão"),
                            onChanged: (value) {
                              setState(() {
                                passwordTypeSelected = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Divider(color: colorScheme.outline,),

                    Row(children: [
                      Icon(isEditable ? Icons.lock_open : Icons.lock),
                      SizedBox(width: 8,),
                      Expanded(child: Text("Permite editar a senha:")),
                      Switch(value: isEditable, onChanged: (value){
                        setState(() {
                          isEditable = value;
                        });
                      })
                    ],),
                    Divider(color: colorScheme.outline,),
                    SizedBox(height: 20,),
                    if(isEditable) Text("aaaaaaaaaaaaaaaaaaaaaaaaaa"),
                    Text(_passwordController.text),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          generatePassword();
                        },
                        child: Text("Gerar senha"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
