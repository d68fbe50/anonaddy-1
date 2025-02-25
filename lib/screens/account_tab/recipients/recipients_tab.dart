import 'package:anonaddy/notifiers/account/account_notifier.dart';
import 'package:anonaddy/notifiers/account/account_state.dart';
import 'package:anonaddy/notifiers/recipient/recipient_tab_notifier.dart';
import 'package:anonaddy/notifiers/recipient/recipient_tab_state.dart';
import 'package:anonaddy/screens/account_tab/components/add_new_recipient.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/lottie_images.dart';
import 'package:anonaddy/shared_components/list_tiles/recipient_list_tile.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/shimmer_effects/recipients_shimmer_loading.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipientsTab extends ConsumerStatefulWidget {
  const RecipientsTab({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _RecipientTabState();
}

class _RecipientTabState extends ConsumerState<RecipientsTab> {
  void addNewRecipient(BuildContext context) {
    final accountState = ref.read(accountStateNotifier);

    /// Draws UI for adding new recipient
    Future buildAddNewRecipient(BuildContext context) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.kBottomSheetBorderRadius),
          ),
        ),
        builder: (context) => const AddNewRecipient(),
      );
    }

    if (accountState.isSelfHosted) {
      buildAddNewRecipient(context);
    } else {
      accountState.hasRecipientsReachedLimit
          ? Utilities.showToast(AnonAddyString.reachedRecipientLimit)
          : buildAddNewRecipient(context);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      /// Initially, load offline data.
      ref.read(recipientTabStateNotifier.notifier).loadOfflineState();

      /// Then, load API data.
      ref.read(recipientTabStateNotifier.notifier).fetchRecipients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipientTabState = ref.watch(recipientTabStateNotifier);
    final size = MediaQuery.of(context).size;

    switch (recipientTabState.status) {
      case RecipientTabStatus.loading:
        return const RecipientsShimmerLoading();

      case RecipientTabStatus.loaded:
        final recipients = recipientTabState.recipients;

        return ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            recipients.isEmpty
                ? ListTile(
                    title: Center(
                      child: Text(
                        AppStrings.noRecipientsFound,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    padding:
                        EdgeInsets.symmetric(horizontal: size.height * 0.004),
                    itemCount: recipients.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final recipient = recipients[index];
                      return RecipientListTile(recipient: recipient);
                    },
                  ),
            TextButton(
              child: const Text(AppStrings.addNewRecipient),
              onPressed: () => addNewRecipient(context),
            ),
          ],
        );

      case RecipientTabStatus.failed:
        final error = recipientTabState.errorMessage;
        return LottieWidget(
          showLoading: true,
          lottie: LottieImages.errorCone,
          lottieHeight: size.height * 0.1,
          label: error.toString(),
        );
    }
  }
}
