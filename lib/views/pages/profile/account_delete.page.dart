import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fuodz/services/custom_form_builder_validator.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/account_delete.vm.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class AccountDeletePage extends StatelessWidget {
  const AccountDeletePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountDeleteViewModel>.reactive(
      viewModelBuilder: () => AccountDeleteViewModel(context),
      disposeViewModel: false,
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          elevation: 0,
          title: "Delete Account".tr(),
          appBarItemColor: Utils.textColorByTheme(),
          backgroundColor: context.theme.colorScheme.background,
          body: FormBuilder(
            key: vm.formBuilderKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: VStack(
              [
                UiSpacer.vSpace(5),
                //description
                "You are about to delete your profile, please select an option below on why you are deleting your profile/account"
                    .tr()
                    .text
                    .light
                    .make(),
                UiSpacer.vSpace(12),
                /*
                UiSpacer.divider(),
                UiSpacer.vSpace(12),

                //
                "Reasons:".tr().text.make(),
                UiSpacer.vSpace(5),
                FormBuilderRadioGroup(
                  wrapDirection: Axis.vertical,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  name: "reason",
                  validator: FormBuilderValidators.required(context),
                  options: vm.reasons.map(
                    (e) {
                      return FormBuilderFieldOption<String>(
                        value: e,
                        child: "$e".tr().text.make().wFull(context),
                      );
                    },
                  ).toList(),
                  onChanged: vm.onReasonChange,
                ),
                CustomVisibilty(
                  visible: vm.otherReason,
                  child: VStack(
                    [
                      UiSpacer.vSpace(5),
                      FormBuilderTextField(
                        name: "reason",
                        decoration: InputDecoration(
                          hintText: "Other reason".tr(),
                        ),
                      ),
                      UiSpacer.vSpace(10),
                    ],
                  ),
                ),
                */
                UiSpacer.divider(),
                UiSpacer.vSpace(),
                //verification section
                "Enter you account password to confirm account deletion"
                    .tr()
                    .text
                    .light
                    .make(),

                //verification coe input
                UiSpacer.vSpace(10),
                FormBuilderTextField(
                  name: "password",
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password".tr(),
                    border: OutlineInputBorder(),
                  ),
                  validator: CustomFormBuilderValidator.required,
                ),
                //submit btn
                UiSpacer.vSpace(10),
                CustomButton(
                  title: "Submit".tr(),
                  loading: vm.isBusy,
                  onPressed: vm.processAccountDeletion,
                ).wFull(context)
              ],
            ),
          ).scrollVertical(
            padding: EdgeInsets.fromLTRB(
              Vx.dp20,
              Vx.dp20,
              Vx.dp20,
              context.mq.viewInsets.bottom + Vx.dp20,
            ),
          ),
        );
      },
    );
  }
}
