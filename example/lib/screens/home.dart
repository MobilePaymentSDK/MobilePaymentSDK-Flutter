
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_provider.dart';
import '../helper/dialogs.dart';
import '../widgets/payment_fields.dart';
import '../widgets/response.dart';
import 'other_api.dart';

class HomeMobilePaymentExample extends StatefulWidget {
  const HomeMobilePaymentExample({super.key});

  @override
  State<HomeMobilePaymentExample> createState() => _HomeMobilePaymentExampleState();
}


class _HomeMobilePaymentExampleState extends State<HomeMobilePaymentExample> {

  @override
  void initState() {
    Provider.of<MobilePaymentProvider>(context,listen: false).initializeSDK(
      onError: (code, error) {
      showCustomDialog(
        context,
        title: 'Code:$code',
        description: error,
      );
    },);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("MobilePaymentSDK"),
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/images/ic_launcher-playstore.png',
            height: 100,
          ),
          const Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 15),
              physics: ClampingScrollPhysics(),
              child: PaymentFields(),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 47,
              vertical: 27,
            ),
            child: Column(
              children: [
                Consumer<MobilePaymentProvider>(
                  builder: (context, provider, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          await provider.openPaymentPage(
                            onError: (code, error) {
                              showCustomDialog(
                                context,
                                title: 'Code:$code',
                                description: error,
                              );
                            },
                            onResponse: (result) async {
                              await showDialog(
                                context: context,
                                useSafeArea: true,
                                builder: (context) {
                                  return ResponseDialog(result: result);
                                },
                              );
                            },
                          );
                        },
                        child: const Text('Pay Now'),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return const OtherAPIMobilePaymentExample();
                          },
                        ),
                      );
                    },
                    child: const Text('Other API'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}