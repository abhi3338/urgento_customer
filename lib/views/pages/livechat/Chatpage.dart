import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';


launchWhatsApp() async {
  final link = WhatsAppUnilink(
    phoneNumber: '+917989678337',
    text: "Hi Urgento I Wound Like Enquiry/Order Your Services",
  );
  await launch('$link');
}