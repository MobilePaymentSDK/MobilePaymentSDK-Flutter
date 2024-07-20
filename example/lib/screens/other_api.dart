
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

import '../app_provider.dart';
import '../helper/dialogs.dart';
import '../widgets/other_api_fields.dart';
import '../widgets/response.dart';

class OtherAPIMobilePaymentExample extends StatelessWidget {
  const OtherAPIMobilePaymentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Other API'),
      ),
      body: Column(
        children: [
          const Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              physics: ClampingScrollPhysics(),
              child: OtherApiFields(),
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
                            }else if(provider.currency.text.isEmpty){
                              showCustomDialog(
                                context,
                                title: 'Code: 2007',
                                description: 'currency is empty',
                              );
                            }else if(provider.transactionId.isEmpty){
                              showCustomDialog(
                                context,
                                title: 'Code: 2000',
                                description: 'transactionId is empty',
                              );
                            }else if(provider.originalTransactionID.isEmpty){
                              showCustomDialog(
                                context,
                                title: 'Code: 2000',
                                description: 'original TransactionID is empty',
                              );
                            }else{
                              await provider.completion(
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
                            child: const Text('Completion'),
                          );
                        }
                      ),
                    ),
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
                            }else if(provider.currency.text.isEmpty){
                              showCustomDialog(
                                context,
                                title: 'Code: 2007',
                                description: 'currency is empty',
                              );
                            }else if(provider.transactionId.isEmpty){
                              showCustomDialog(
                                context,
                                title: 'Code: 2000',
                                description: 'transactionId is empty',
                              );
                            }else if(provider.originalTransactionID.isEmpty){
                              showCustomDialog(
                                context,
                                title: 'Code: 2000',
                                description: 'original TransactionID is empty',
                              );
                            }else{
                              await provider.refund(
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
                          return ElevatedButton(
                            onPressed: onTap,
                            child: const Text('Refund'),
                          );
                        }
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TapDebouncer(
                          cooldown: const Duration(seconds: 1),
                          onTap: () async {
                            if(provider.originalTransactionID.isEmpty){
                              showCustomDialog(
                                context,
                                title: 'Code: 2000',
                                description: 'original TransactionID is empty',
                              );
                            }else{
                              await provider.inquiry(
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
                          return ElevatedButton(
                            onPressed: onTap,
                            child: const Text('Inquiry'),
                          );
                        }
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
