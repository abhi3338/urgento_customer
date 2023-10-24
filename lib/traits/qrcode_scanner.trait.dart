import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:velocity_x/velocity_x.dart';

class QrcodeScannerTrait {
  //scanning
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;
  bool flashEnabled = false;

  //
  Future<String> openScanner(BuildContext viewContext) async {
    final result = await showDialog(
      context: viewContext,
      builder: (context) {
        return Dialog(
          child: VStack(
            [
              //qr code preview
              QRView(
                key: qrKey,
                onQRViewCreated: (QRViewController controller) {
                  this.controller = controller;
                  // controller.toggleFlash();
                  controller.scannedDataStream.listen((scanData) {
                    //close dialog
                    viewContext.pop(scanData.code);
                  });
                },
              ).h48(context),
              //
              HStack(
                [
                  "Toggle Flash".tr().text.make().expand(),
                  Switch(
                    value: flashEnabled,
                    onChanged: (value) {
                      flashEnabled = value;
                      controller.toggleFlash();
                    },
                  ),
                ],
              ).px20(),
            ],
          ),
        );
      },

      //
    );

    //
    print("Results ==> $result");
    if (controller != null) {
      controller?.stopCamera();
    }
    //
    FocusScope.of(viewContext).requestFocus(FocusNode());
    return result;
  }
}
