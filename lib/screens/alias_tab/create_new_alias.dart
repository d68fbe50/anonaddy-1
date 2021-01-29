import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:anonaddy/state_management/main_account_state_manager.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/target_platform.dart';
import 'package:anonaddy/widgets/loading_indicator.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import 'alias_tab.dart';

class CreateNewAlias extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final domainOptions = watch(domainOptionsProvider);
    final size = MediaQuery.of(context).size;
    final isIOS = TargetedPlatform().isIOS();

    final aliasStateProvider = watch(aliasStateManagerProvider);
    final isLoading = aliasStateProvider.isLoading;
    final createNewAlias = aliasStateProvider.createNewAlias;
    final descFieldController = aliasStateProvider.descFieldController;
    final customFieldController = aliasStateProvider.customFieldController;
    final customFormKey = aliasStateProvider.customFormKey;
    final correctAliasString = aliasStateProvider.correctAliasString;
    final freeTierNoSharedDomain = aliasStateProvider.freeTierNoSharedDomain;
    final freeTierWithSharedDomain =
        aliasStateProvider.freeTierWithSharedDomain;
    final paidTierNoSharedDomain = aliasStateProvider.paidTierNoSharedDomain;
    final paidTierWithSharedDomain =
        aliasStateProvider.paidTierWithSharedDomain;

    final userModel = watch(mainAccountProvider).userModel;
    final subscription = userModel.subscription;
    final createAliasText =
        'Other aliases e.g. alias@${userModel.username ?? 'username'}.anonaddy.com or .me can also be created automatically when they receive their first email.';

    List<DropdownMenuItem<String>> dropdownMenuItems() {
      if (aliasStateProvider.aliasDomain == '4wrd.cc' ||
          aliasStateProvider.aliasDomain == 'anonaddy.me' ||
          aliasStateProvider.aliasDomain == 'mailer.me') {
        if (subscription == 'free') {
          return freeTierWithSharedDomain
              .map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
                value: value, child: Text(correctAliasString(value)));
          }).toList();
        } else {
          return paidTierWithSharedDomain
              .map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
                value: value, child: Text(correctAliasString(value)));
          }).toList();
        }
      } else {
        if (subscription == 'free') {
          return freeTierNoSharedDomain.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
                value: value, child: Text(correctAliasString(value)));
          }).toList();
        } else {
          return paidTierNoSharedDomain.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
                value: value, child: Text(correctAliasString(value)));
          }).toList();
        }
      }
    }

    Widget buildCustomInputField() {
      if (aliasStateProvider.aliasFormat == 'custom') {
        return Column(
          children: [
            SizedBox(height: size.height * 0.02),
            Form(
              key: customFormKey,
              child: TextFormField(
                controller: customFieldController,
                validator: (input) => FormValidator().validateLocalPart(input),
                textInputAction: TextInputAction.next,
                decoration: kTextFormFieldDecoration.copyWith(
                  labelText: kEnterLocalPart,
                ),
              ),
            ),
          ],
        );
      }
      return Container();
    }

    return domainOptions.when(
      loading: () => LoadingIndicator(),
      data: (data) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Divider(
                thickness: 3,
                indent: size.width * 0.4,
                endIndent: size.width * 0.4,
              ),
              SizedBox(height: size.height * 0.02),
              Column(
                children: [
                  Text(createAliasText),
                  SizedBox(height: size.height * 0.02),
                  TextFormField(
                    controller: descFieldController,
                    textInputAction: TextInputAction.next,
                    decoration: kTextFormFieldDecoration.copyWith(
                        labelText: kDescriptionInputText),
                  ),
                  buildCustomInputField(),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.03),
                  Text(
                    'Alias domain',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    isDense: true,
                    value: aliasStateProvider.aliasDomain,
                    hint: Text(
                      '${data.defaultAliasDomain ?? 'Choose Alias Domain'}',
                    ),
                    items: data.sharedDomainsList
                        .map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      aliasStateProvider.setAliasDomain = value;
                      aliasStateProvider.setAliasFormat =
                          data.defaultAliasFormat;
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.03),
                  Text(
                    'Alias format',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    isDense: true,
                    value: aliasStateProvider.aliasFormat,
                    hint: Text(
                      '${data.defaultAliasFormat ?? 'Choose Alias Format'}',
                    ),
                    items: dropdownMenuItems(),
                    onChanged: (String value) {
                      aliasStateProvider.setAliasFormat = value;
                    },
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.03),
              isLoading
                  ? isIOS
                      ? CupertinoActivityIndicator()
                      : CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kAccentColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      ),
                      child: Text(
                        'Submit',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.black, fontWeight: FontWeight.normal),
                      ),
                      onPressed: isLoading
                          ? () {}
                          : () {
                              if (aliasStateProvider.aliasDomain == null &&
                                      data.defaultAliasDomain == null ||
                                  aliasStateProvider.aliasFormat == null &&
                                      data.defaultAliasFormat == null) {
                              } else {
                                createNewAlias(
                                  context,
                                  descFieldController.text.trim(),
                                  aliasStateProvider.aliasDomain ??
                                      data.defaultAliasDomain,
                                  aliasStateProvider.aliasFormat ??
                                      data.defaultAliasFormat,
                                  customFieldController.text.trim(),
                                  // customFormKey,
                                );
                              }
                            },
                    ),
            ],
          ),
        );
      },
      error: (error, stackTrade) {
        return LottieWidget(
          lottie: 'assets/lottie/errorCone.json',
          label: error,
          lottieHeight: MediaQuery.of(context).size.height * 0.2,
        );
      },
    );
  }
}
