import 'package:anonaddy/screens/alert_center/failed_deliveries_widget.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/lottie_images.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:flutter/material.dart';

class AlertCenterScreen extends StatefulWidget {
  const AlertCenterScreen({Key? key}) : super(key: key);

  static const routeName = 'alertCenterScreen';

  @override
  _AlertCenterScreenState createState() => _AlertCenterScreenState();
}

class _AlertCenterScreenState extends State<AlertCenterScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Alert Center')),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeadline('Notifications'),
              Text(
                'One central location for your account alerts and notifications.',
                style: Theme.of(context).textTheme.caption,
              ),
              Container(
                color: Colors.white,
                margin: const EdgeInsets.all(20),
                child: const LottieWidget(
                  lottie: LottieImages.comingSoon,
                  repeat: true,
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeadline('Failed deliveries'),
              Text(
                AppStrings.failedDeliveriesNote,
                style: Theme.of(context).textTheme.caption,
              ),
              const SizedBox(height: 10),
              const FailedDeliveriesWidget(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeadline(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.headline6,
        ),
        const Divider(),
      ],
    );
  }
}
