import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/services/local_storage.service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var userObject;
  @override
  void initState() {
    aaa();
    super.initState();
  }

  aaa() async{
    var data = await LocalStorageService.prefs.getString(AppStrings.userKey);
    setState(() {
      userObject = json.decode(data);
      print("data is===>>>${userObject}");
      print("data is===>>>${userObject["email"]}");
      print("data is===>>>${userObject["phone"]}");
      print("data is===>>>${userObject['name']}");
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Urgento Customer Support'),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: userObject == null ||  userObject.isEmpty ? SizedBox() : Tawk(
          directChatLink: 'https://tawk.to/chat/638304e6daff0e1306d9a0d2/1girsma17',
          visitor: TawkVisitor(
            name: userObject["name"],
            email: userObject["email"],
          ),
          onLoad: () {
            print('Hello urgentos');
          },
          onLinkTap: (String url) {
            print(url);
          },
          placeholder: const Center(
            child: Text('Loading...'),
          ),
        ),
      ),
    );
  }
}