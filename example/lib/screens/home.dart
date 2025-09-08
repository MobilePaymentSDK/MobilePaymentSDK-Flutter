
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MobilePaymentProvider>(context,listen: false).generateTransactionId();
    });
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
          const Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
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
            child: Consumer<MobilePaymentProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: TapDebouncer(
                          cooldown: const Duration(seconds: 1),
                          onTap: () async {
                            if(provider.amount.text.isEmpty){
                              showCustomDialog(
                                context,
                                title: 'Code: 2000',
                                description: 'Amount is empty',
                              );
                            }
                            else if(provider.currency.text.isEmpty){
                              showCustomDialog(
                                context,
                                title: 'Code: 2007',
                                description: 'currency is empty',
                              );
                            }
                            else if(provider.transactionId.isEmpty){
                              showCustomDialog(
                                context,
                                title: 'Code: 2000',
                                description: 'transactionId is empty',
                              );
                            // }else if(provider.merchantId.isEmpty){
                            //   showCustomDialog(
                            //     context,
                            //     title: 'Code: 2000',
                            //     description: 'merchantId is empty',
                            //   );
                            // }else if(provider.secretKey.isEmpty){
                            //   showCustomDialog(
                            //     context,
                            //     title: 'Code: 2000',
                            //     description: 'secretKey is empty',
                            //   );
                            // }else if(provider.appleMerchantId.isEmpty){
                            //   showCustomDialog(
                            //     context,
                            //     title: 'Code: 2000',
                            //     description: 'appleMerchantId is empty',
                            //   );
                            // }else{
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
                            }

                          }, // your tap handler moved here
                          builder: (BuildContext context, TapDebouncerFunc? onTap) {
                          return OutlinedButton(
                            onPressed: onTap,
                            child: const Text('Pay Now'),
                          );
                        }
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          provider.clearData();
                          provider.generateTransactionId();
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
