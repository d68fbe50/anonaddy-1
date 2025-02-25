import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/notifiers/domains/domains_screen_notifier.dart';
import 'package:anonaddy/notifiers/domains/domains_screen_state.dart';
import 'package:anonaddy/screens/account_tab/domains/domain_default_recipient.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/lottie_images.dart';
import 'package:anonaddy/shared_components/created_at_widget.dart';
import 'package:anonaddy/shared_components/custom_app_bar.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_detail_list_tile.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/list_tiles/recipient_list_tile.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_switch.dart';
import 'package:anonaddy/shared_components/update_description_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DomainsScreen extends ConsumerStatefulWidget {
  const DomainsScreen({Key? key, required this.domain}) : super(key: key);
  final Domain domain;

  static const routeName = 'domainDetailedScreen';

  @override
  ConsumerState createState() => _DomainsScreenState();
}

class _DomainsScreenState extends ConsumerState<DomainsScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(domainsScreenStateNotifier.notifier).fetchDomain(widget.domain);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Consumer(
        builder: (context, watch, _) {
          final domainProvider = ref.watch(domainsScreenStateNotifier);

          switch (domainProvider.status!) {
            case DomainsScreenStatus.loading:
              return const Center(child: PlatformLoadingIndicator());

            case DomainsScreenStatus.loaded:
              return buildListView(context, domainProvider);

            case DomainsScreenStatus.failed:
              final error = domainProvider.errorMessage;
              return LottieWidget(
                lottie: LottieImages.errorCone,
                label: error,
              );
          }
        },
      ),
    );
  }

  ListView buildListView(
      BuildContext context, DomainsScreenState domainProvider) {
    final size = MediaQuery.of(context).size;

    final domain = domainProvider.domain;
    final domainNotifier = ref.read(domainsScreenStateNotifier.notifier);

    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.all(size.height * 0.01),
          child: Row(
            children: [
              Icon(
                Icons.account_circle_outlined,
                size: size.height * 0.035,
              ),
              SizedBox(width: size.width * 0.02),
              Text(
                domain.domain,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Divider(height: size.height * 0.02),
        AliasDetailListTile(
          title: domain.description.isEmpty
              ? AppStrings.noDescription
              : domain.description,
          titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
          subtitle: 'Domain description',
          leadingIconData: Icons.comment_outlined,
          trailing: IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {},
          ),
          trailingIconOnPress: () =>
              buildEditDescriptionDialog(context, domain),
        ),
        AliasDetailListTile(
          title: domain.active ? 'Domain is active' : 'Domain is inactive',
          titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
          subtitle: 'Activity',
          leadingIconData: Icons.toggle_off_outlined,
          trailing:
              buildSwitch(domainProvider.activeSwitchLoading, domain.active),
          trailingIconOnPress: () {
            domain.active
                ? domainNotifier.deactivateDomain(domain.id)
                : domainNotifier.activateDomain(domain.id);
          },
        ),
        AliasDetailListTile(
          title: domain.catchAll ? 'Enabled' : 'Disabled',
          titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
          subtitle: 'Catch All',
          leadingIconData: Icons.repeat,
          trailing: buildSwitch(
              domainProvider.catchAllSwitchLoading, domain.catchAll),
          trailingIconOnPress: () {
            domain.catchAll
                ? domainNotifier.deactivateCatchAll(domain.id)
                : domainNotifier.activateCatchAll(domain.id);
          },
        ),
        if (domain.domainVerifiedAt.isEmpty)
          buildUnverifiedEmailWarning(size, AppStrings.unverifiedDomainWarning),
        // Divider(height: size.height * 0.02),
        if (domain.domainMxValidatedAt.isEmpty)
          buildUnverifiedEmailWarning(size, AppStrings.invalidDomainMXWarning),
        Divider(height: size.height * 0.02),
        // if (domain.domainSendingVerifiedAt == null)
        //   buildUnverifiedEmailWarning(size, kUnverifiedDomainNote),
        // Divider(height: size.height * 0.02),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Default Recipient',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () =>
                        buildUpdateDefaultRecipient(context, domain),
                  ),
                ],
              ),
            ),
            if (domain.defaultRecipient == null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text('No default recipient found'),
              )
            else
              RecipientListTile(
                recipient: domain.defaultRecipient!,
              ),
          ],
        ),
        Divider(height: size.height * 0.02),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
              child: Row(
                children: [
                  Text(
                    'Associated Aliases',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Container(height: 36),
                ],
              ),
            ),
            if (domain.aliases.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text('No aliases found'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: domain.aliases.length,
                itemBuilder: (context, index) {
                  return AliasListTile(
                    alias: domain.aliases[index],
                  );
                },
              ),
          ],
        ),
        Divider(height: size.height * 0.03),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CreatedAtWidget(
              label: 'Created at',
              dateTime: domain.createdAt.toString(),
            ),
            CreatedAtWidget(
              label: 'Updated at',
              dateTime: domain.updatedAt.toString(),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.05),
      ],
    );
  }

  Widget buildSwitch(bool switchLoading, switchValue) {
    return Row(
      children: [
        switchLoading ? const PlatformLoadingIndicator(size: 20) : Container(),
        PlatformSwitch(
          value: switchValue,
          onChanged: (toggle) {},
        ),
      ],
    );
  }

  Future buildEditDescriptionDialog(BuildContext context, Domain domain) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.kBottomSheetBorderRadius)),
      ),
      builder: (context) {
        return UpdateDescriptionWidget(
          description: domain.description,
          updateDescription: (description) async {
            await ref
                .read(domainsScreenStateNotifier.notifier)
                .editDescription(domain.id, description);
          },
          removeDescription: () async {
            await ref
                .read(domainsScreenStateNotifier.notifier)
                .editDescription(domain.id, '');
          },
        );
      },
    );
  }

  Future buildUpdateDefaultRecipient(BuildContext context, Domain domain) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.kBottomSheetBorderRadius),
        ),
      ),
      builder: (context) {
        return DomainDefaultRecipient(domain: domain);
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    Future<void> deleteDomain() async {
      PlatformAware.platformDialog(
        context: context,
        child: PlatformAlertDialog(
          title: 'Delete Domain',
          content: AnonAddyString.deleteDomainConfirmation,
          method: () async {
            await ref
                .read(domainsScreenStateNotifier.notifier)
                .deleteDomain(widget.domain.id);
            if (mounted) {
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
        ),
      );
    }

    return CustomAppBar(
      title: 'Domain',
      leadingOnPress: () => Navigator.pop(context),
      showTrailing: true,
      trailingLabel: 'Delete Domain',
      trailingOnPress: (choice) => deleteDomain(),
    );
  }

  Widget buildUnverifiedEmailWarning(Size size, String label) {
    return Container(
      height: size.height * 0.05,
      width: double.infinity,
      color: Colors.amber,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_outlined, color: Colors.black),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}
