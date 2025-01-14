import 'package:anonaddy/models/failed_delivery/failed_delivery.dart';
import 'package:flutter/material.dart';

class FailedDeliveryListTile extends StatelessWidget {
  const FailedDeliveryListTile({
    Key? key,
    required this.delivery,
    required this.onPress,
  }) : super(key: key);
  final FailedDelivery delivery;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      expandedAlignment: Alignment.centerLeft,
      tilePadding: const EdgeInsets.all(0),
      iconColor: Colors.red,
      title: Text(
        delivery.aliasEmail ?? 'Unknown alias',
        style: Theme.of(context).textTheme.bodyText2,
      ),
      subtitle: Text(
        'Tap to expand',
        style: Theme.of(context).textTheme.caption,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: onPress,
      ),
      children: [
        ListTile(
          dense: true,
          title: Text(delivery.aliasEmail ?? 'Unknown alias'),
          subtitle: const Text('Alias'),
        ),
        ListTile(
          dense: true,
          title: Text(delivery.recipientEmail ?? 'Unknown recipient'),
          subtitle: const Text('Recipient'),
        ),
        ListTile(
          dense: true,
          title: Text(delivery.bounceType),
          subtitle: const Text('Type'),
        ),
        ListTile(
          dense: true,
          title: Text(delivery.code),
          subtitle: const Text('Code'),
        ),
        ListTile(
          dense: true,
          title: Text(
            delivery.remoteMta.isEmpty ? 'Not available' : delivery.remoteMta,
          ),
          subtitle: const Text('Remote MTA'),
        ),
        ListTile(
          dense: true,
          title: Text(delivery.createdAt.toString()),
          subtitle: const Text('Created'),
        ),
      ],
    );
  }
}
