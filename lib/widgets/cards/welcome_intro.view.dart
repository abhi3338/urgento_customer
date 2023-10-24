import 'package:flutter/material.dart';
import 'package:fuodz/models/user.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class WelcomeIntroView extends StatelessWidget {
  const WelcomeIntroView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  VStack(
          [
            //welcome intro and loggedin account name
            StreamBuilder(
              stream: AuthServices.listenToAuthState(),
              builder: (ctx, snapshot) {
                //
                String introText = "Welcome".tr();
                String fullIntroText = introText;
                //
                if (snapshot.hasData) {
                  return FutureBuilder<User>(
                    future: AuthServices.getCurrentUser(),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        String fullIntroText = "${snapshot.data.name}".toLowerCase();
                        String FinalIntroText ="$introText $fullIntroText";



                        final user = snapshot.data;
                        return HStack(
                          [
                            VStack(
                              [  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(

                                    child:

                                    Text(
                                      "${FinalIntroText}",
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          height: 1.0,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: GoogleFonts.rubik().fontFamily,
                                          color: Utils.textColorByBrightness(context),
                                          fontSize: 18.0,
                                          letterSpacing: 0.025),
                                    ),
                                  ),
                                ],
                              ),
                                //name
                                UiSpacer.verticalSpace(space: 5),
                                Text(
                                  "How can I help you today?🤔",
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      height: 1.0,
                                      fontWeight: FontWeight.w200,
                                      fontFamily: GoogleFonts.rubik().fontFamily,
                                      color: Utils.textColorByBrightness(context),
                                      fontSize: 18.0,
                                      letterSpacing: 0.025),
                                ),

                              ],
                            ),
                          ],
                        );
                      } else {
                        //auth but not data received
                        return fullIntroText.text.black.xl3.semiBold.make();
                      }
                    },
                  );
                }
                return fullIntroText.text.black.xl3.semiBold.make();
              },


            ),
            //

            UiSpacer.verticalSpace(space: 5),



          ],
        );

  }
}
