import 'package:currency_formatter/currency_formatter.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:supercharged/supercharged.dart';

extension NumberParsing on dynamic {
  //
  String currencyFormat([String currencySymbol]) {
    final uiConfig = AppStrings.uiConfig;
    if (uiConfig != null && uiConfig["currency"] != null) {
      //
      final thousandSeparator = uiConfig["currency"]["format"] ?? ",";
      final decimalSeparator = uiConfig["currency"]["decimal_format"] ?? ".";
      final decimals = uiConfig["currency"]["decimals"];
      final currencylOCATION = uiConfig["currency"]["location"] ?? 'left';
      final decimalsValue = "".padLeft(decimals.toString().toInt(), "0");

      //
      //
      final values =
          this.toString().split(" ").join("").split(currencySymbol ??AppStrings.currencySymbol);

      //
      CurrencyFormatterSettings currencySettings = CurrencyFormatterSettings(
        symbol: currencySymbol ?? AppStrings.currencySymbol,
        symbolSide: currencylOCATION.toLowerCase() == "left"
            ? SymbolSide.left
            : SymbolSide.right,
        thousandSeparator: thousandSeparator,
        decimalSeparator: decimalSeparator,
      );

      CurrencyFormatter cf = CurrencyFormatter();
      return cf.format(
        values[1],
        currencySettings,
        decimal: decimalsValue.length ?? 2,
        enforceDecimals: true,
      );
    } else {
      return this.toString();
    }
  }

  //
  String currencyValueFormat() {
    final uiConfig = AppStrings.uiConfig;
    if (uiConfig != null && uiConfig["currency"] != null) {
      final thousandSeparator = uiConfig["currency"]["format"] ?? ",";
      final decimalSeparator = uiConfig["currency"]["decimal_format"] ?? ".";
      final decimals = uiConfig["currency"]["decimals"];
      final decimalsValue = "".padLeft(decimals.toString().toInt(), "0");
      final values = this.toString().split(" ").join("");

      //
      CurrencyFormatterSettings currencySettings = CurrencyFormatterSettings(
        symbol: "",
        symbolSide: SymbolSide.right,
        thousandSeparator: thousandSeparator,
        decimalSeparator: decimalSeparator,
      );
      CurrencyFormatter cf = CurrencyFormatter();
      return cf.format(
        values,
        currencySettings,
        decimal: decimalsValue.length ?? 2,
        enforceDecimals: true,
      );
    } else {
      return this.toString();
    }
  }

  bool get isNotDefaultImage {
    return !this.toString().contains("default");
  }
}
