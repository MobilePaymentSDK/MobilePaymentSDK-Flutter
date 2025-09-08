import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../app_provider.dart';
import 'note_text.dart';
import 'text_field.dart';

class OtherApiFields extends StatelessWidget {
  const OtherApiFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MobilePaymentProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              onChanged: (value) => provider.onChangeOriginalTransactionID(value),
              hintText: 'Original TransactionID',
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            const CustomTextField(
              keyboardType:  TextInputType.text,
              //controller: provider.transactionId,
              hintText: 'Transaction ID',
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              onChanged: (value) => provider.onChangeAmount(value),
              keyboardType: const TextInputType.numberWithOptions(decimal: false),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              hintText: 'Amount',
              controller: provider.amount,
              textInputAction: TextInputAction.next,
            ),
            const NoteText(text: '* Amount without dot'),
            CustomTextField(
              onChanged: (value) => provider.onChangeCurrency(value),
              keyboardType: const TextInputType.numberWithOptions(decimal: false),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              hintText: 'Currency',
              controller: provider.currency,
              textInputAction: TextInputAction.done,
            ),
            const NoteText(text: 'Currency code (Only one currency)'),
          ],
        );
      },
    );
  }
}
