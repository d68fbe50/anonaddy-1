import 'package:anonaddy/screens/account_tab/components/account_tab_header.dart';
import 'package:anonaddy/screens/account_tab/domains/domains_tab.dart';
import 'package:anonaddy/screens/account_tab/recipients/recipients_tab.dart';
import 'package:anonaddy/screens/account_tab/rules/rules_tab.dart';
import 'package:anonaddy/screens/account_tab/usernames/usernames_tab.dart';
import 'package:anonaddy/shared_components/constants/lottie_images.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/state_management/account/account_notifier.dart';
import 'package:anonaddy/state_management/account/account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountTab extends ConsumerWidget {
  const AccountTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: size.height * 0.3,
                elevation: 0,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Consumer(
                    builder: (_, watch, __) {
                      final accountState = ref.watch(accountStateNotifier);
                      switch (accountState.status) {
                        case AccountStatus.loading:
                          return const PlatformLoadingIndicator();

                        case AccountStatus.loaded:
                          final account = accountState.account;
                          return AccountTabHeader(
                            account: account!,
                            isSelfHosted: account.subscription == null,
                          );

                        case AccountStatus.failed:
                          final error = accountState.errorMessage;
                          return LottieWidget(
                            showLoading: true,
                            lottie: LottieImages.errorCone,
                            lottieHeight: size.height * 0.2,
                            label: error.toString(),
                          );
                      }
                    },
                  ),
                ),
                bottom: const TabBar(
                  isScrollable: true,
                  indicatorColor: kAccentColor,
                  tabs: [
                    Tab(child: Text('Recipients')),
                    Tab(child: Text('Usernames')),
                    Tab(child: Text('Domains')),
                    Tab(child: Text('Rules')),
                  ],
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: [
              RecipientsTab(),
              UsernamesTab(),
              DomainsTab(),
              RulesTab()
            ],
          ),
        ),
      ),
    );
  }
}
