import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  //
  ThemeData lightTheme() {
    return ThemeData(
      // fontFamily: GoogleFonts.ibmPlexSerif().fontFamily,
      // fontFamily: GoogleFonts.krub().fontFamily,
      // fontFamily: GoogleFonts.montserrat().fontFamily,
      fontFamily: GoogleFonts.poppins().fontFamily,
      //fontFamily: GoogleFonts.lato().fontFamily,
      // backgroundColor: Colors.white,
      //fontFamily: GoogleFonts.roboto().fontFamily,
      primaryColor: AppColor.primaryColor,
      primaryColorDark: AppColor.primaryColorDark,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: Colors.grey,
        cursorColor: AppColor.cursorColor,
      ),
      cardColor: Colors.white,
      textTheme: TextTheme(
        displaySmall: TextStyle(
          color: Colors.black,
        ),
        bodyLarge: TextStyle(
          color: Colors.black,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
      ),
      // brightness: Brightness.light,
      // CUSTOMIZE showDatePicker Colors
      dialogBackgroundColor: Colors.white,
      buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
      highlightColor: Colors.grey[400],
      colorScheme: ColorScheme.light(
        primary: AppColor.primaryColor,
        secondary: AppColor.accentColor,
        brightness: Brightness.light,
      ).copyWith(
          primary: AppColor.primaryMaterialColor, background: Colors.white),
    );
  }

  ThemeData darkTheme() {
    return ThemeData(
      // fontFamily: GoogleFonts.ibmPlexSerif().fontFamily,
      // fontFamily: GoogleFonts.krub().fontFamily,
      // fontFamily: GoogleFonts.montserrat().fontFamily,
      fontFamily: GoogleFonts.poppins().fontFamily,
      //fontFamily: GoogleFonts.lato().fontFamily,
      // backgroundColor: Colors.white,
      //fontFamily: GoogleFonts.roboto().fontFamily,
      primaryColor: AppColor.primaryColor,
      primaryColorDark: AppColor.primaryColorDark,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: Colors.grey,
        cursorColor: AppColor.cursorColor,
      ),
      cardColor: Colors.white,
      textTheme: TextTheme(
        displaySmall: TextStyle(
          color: Colors.black,
        ),
        bodyLarge: TextStyle(
          color: Colors.black,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
      ),
      // brightness: Brightness.light,
      // CUSTOMIZE showDatePicker Colors
      dialogBackgroundColor: Colors.white,
      buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
      highlightColor: Colors.grey[400],
      colorScheme: ColorScheme.light(
        primary: AppColor.primaryColor,
        secondary: AppColor.accentColor,
        brightness: Brightness.light,
      ).copyWith(
          primary: AppColor.primaryMaterialColor, background: Colors.white),
    );
  }

  //
  // ThemeData darkTheme() {
  //   return ThemeData(
  //     // fontFamily: GoogleFonts.iBMPlexSerif().fontFamily,
  //     // fontFamily: GoogleFonts.krub().fontFamily,
  //     fontFamily: GoogleFonts.lato().fontFamily,
  //     primaryColor: AppColor.primaryColor,
  //     primaryColorDark: AppColor.primaryColorDark,
  //     textSelectionTheme: TextSelectionThemeData(
  //       selectionColor: Colors.grey,
  //       cursorColor: AppColor.cursorColor,
  //     ),
  //     // backgroundColor: Colors.grey[850],
  //     cardColor: Color(0xFF252733),
  //     textTheme: TextTheme(
  //       displaySmall: TextStyle(
  //         color: Colors.white,
  //       ),
  //       bodyLarge: TextStyle(
  //         color: Colors.white,
  //       ),
  //     ),
  //     bottomSheetTheme: BottomSheetThemeData(
  //       backgroundColor: Colors.black,
  //     ),
  //     colorScheme: ColorScheme.fromSwatch()
  //         .copyWith(
  //           primary: AppColor.primaryColor,
  //           secondary: AppColor.accentColor,
  //           brightness: Brightness.dark,
  //         )
  //         .copyWith(
  //           primary: AppColor.primaryMaterialColor,
  //           background: Colors.grey[850],
  //         ),
  //   );
  // }
}
