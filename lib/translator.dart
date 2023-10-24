import 'dart:convert';
import 'dart:io';
import 'package:translator/translator.dart';

import 'constants/app_languages.dart';

void main() async {
  final dir = Directory('assets/lang');
  final translator = GoogleTranslator();
  //
  final List<FileSystemEntity> entities = await dir.list().toList();
  //get the new-lang values
  print("Loadding New Lang Strings");
  final fullLanguageStringsEntity = entities.firstWhere(
    (e) => e.path.endsWith("full-lang.txt"),
  );
  final newLanguageStringsEntity = entities.firstWhere(
    (e) => e.path.endsWith("new-lang.txt"),
  );

//
  print("Loadding New Lang Strings");
  File file = File(newLanguageStringsEntity.path);
  List<String> newLangStrings = (await file.readAsString()).split("\n");
  //
  for (var code in AppLanguages.codes) {
    //loop through new-lang and use api to translate it
    print("Translating ==> ${code}");
    try {
      Map<String, String> newTranslatedData = new Map<String, String>();
      int count = 1;
      //
      for (var newLangString in newLangStrings) {
        //
        if (code != "en") {
          final translation =
              await translator.translate(newLangString, to: code);
          newTranslatedData[newLangString] = translation.text;
        } else {
          newTranslatedData[newLangString] = newLangString;
        }
        //
        print("Done:: $count/${newLangStrings.length}");
        count++;
      }

      //
      final langFileEntity = entities.firstWhere(
        (e) => e.path.toLowerCase().contains(code.toLowerCase()),
        orElse: () => null,
      );

      //
      File langFile;

      //if the code file doest exist the create one
      if (langFileEntity == null) {
        langFile = await File("assets/lang/$code.json").create();
        await langFile.writeAsString("{}");
      } else {
        langFile = File(langFileEntity.path);
      }

      //
      final oldLangJson = jsonDecode(await langFile.readAsString());
      final newMergedLangJson = {...newTranslatedData, ...oldLangJson};
      await langFile.writeAsString(jsonEncode(newMergedLangJson));
    } catch (error) {
      print("Error with:: $error");
    }
    print("-----------------------");
    // print("New Json ==> ${jsonEncode(newTranslatedData)}");
    // print("Old Json ==> ${jsonEncode(oldLangJson)}");
    // print("Merged Json ==> ${jsonEncode(newMergedLangJson)}");
    // print("-----------------------");
  }

  final newLangString = newLangStrings.join("\n");
  final oldLangFile = File(fullLanguageStringsEntity.path);
  String oldLangString = await oldLangFile.readAsString();
  await oldLangFile.writeAsString("$oldLangString\n$newLangString");
  //when all is done without error, clear the content of the
  await File(newLanguageStringsEntity.path).writeAsString("");
}
