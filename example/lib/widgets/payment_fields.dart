import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_payment_plugin/models/open_payment.dart';
import 'package:mobile_payment_plugin_example/screens/saved_cards.dart';
import 'package:provider/provider.dart';

import '../app_provider.dart';
import 'dropdown_button.dart';
import 'note_text.dart';
import 'text_field.dart';

class PaymentFields extends StatelessWidget {
  const PaymentFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MobilePaymentProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NoteText(text: 'Merchant ID'),
            CustomTextField(
              onChanged: (value) => provider.onChangeMerchantId(value),
              keyboardType:
              TextInputType.text,
              initialValue: '',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              hintText: '',
              textInputAction: TextInputAction.next,
            ),

            const NoteText(text: 'Secret Key'),
            CustomTextField(
              onChanged: (value) => provider.onChangeSecretKey(value),
              keyboardType:
              TextInputType.text,
              initialValue: '',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              hintText: '',
              textInputAction: TextInputAction.next,
            ),

            const NoteText(text: 'Apple Merchant ID'),
            CustomTextField(
              onChanged: (value) => provider.onChangeAppleMerchantId(value),
              keyboardType:
              TextInputType.text,
              initialValue: '',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              hintText: '',
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 18,),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  provider.clearData();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const SavedCard();
                      },
                    ),
                  );
                },
                child: const Text('Saved Cards'),
              ),
            ),
            const SizedBox(height: 18,),


            SwitchListTile.adaptive(
              value: provider.isThreeDSSecure,
              onChanged: (value) => provider.onChangeThreeDSSecure(value),
              title: Text(
                'Is 3DS Secure',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SwitchListTile.adaptive(
              value: provider.shouldTokenizeCard,
              onChanged: (value) {
                provider.onChangeShouldTokenizeCard(value);
              },
              title: Text(
                'Should Tokenize Card',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SwitchListTile.adaptive(
              value: provider.isCardScanEnable,
              onChanged: (value) => provider.onChangeCardScanEnable(value),
              title: Text(
                'Is Card scan enable',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            // SwitchListTile.adaptive(
            //   value: provider.shouldTokenizeCard,
            //   onChanged: (value) => provider.onChangeShouldTokenizeCard(value),
            //   title: Text(
            //     'Is Save Card Enabled',
            //     style: TextStyle(
            //       color: Theme.of(context).primaryColor,
            //     ),
            //   ),
            // ),
            CustomDropdownButton(
              selectedTextValue: provider.selectedLangVale,
              onChanged: (value) => provider.onChangeLang(value),
              items: const [
                DropdownMenuItem<Language>(
                  value: Language.ar,
                  child: Text('Arabic'),
                ),
                DropdownMenuItem<Language>(
                  value: Language.en,
                  child: Text('English'),
                ),
                DropdownMenuItem<Language>(
                  value: Language.tr,
                  child: Text('Turkish'),
                ),
              ],
            ),
            CustomDropdownButton(
              selectedTextValue: provider.selectedPaymentTypeTypeValue,
              onChanged: (value) {
                provider.onChangePaymentTypeType(value);
                log('value:');
                log(value.toString());
              },
              items: const [
                DropdownMenuItem<PaymentType>(
                  value: PaymentType.sale,
                  child: Text('Sale'),
                ),
                DropdownMenuItem<PaymentType>(
                  value: PaymentType.preAuth,
                  child: Text('PreAuth'),
                ),
              ],
            ),
            const NoteText(
              text: 'Cards Type',
            ),
            ListView.builder(
              itemCount: provider.cardsType.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var card = provider.cardsType[index];
                return CheckboxListTile.adaptive(
                  value: provider.cardsSelected.contains(card),
                  onChanged: (value) {
                    provider.onChangedCheckboxCardsType(
                      value: value!,
                      cardType: card,
                    );
                  },
                  title: Text(card.name.toUpperCase()),
                );
              },
            ),

            const SizedBox(height: 18,),
            const NoteText(text: 'agreement id'),
            CustomTextField(
              onChanged: (value) => provider.onChangeAgreementId(value),
              keyboardType:
              const TextInputType.numberWithOptions(decimal: false),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              hintText: 'agreement id',
              initialValue: provider.agreementId,
              textInputAction: TextInputAction.next,
            ),
            const NoteText(text: 'item id'),
            CustomTextField(
              onChanged: (value) => provider.onChangeItemId(value),
              keyboardType: TextInputType.text,
              hintText: 'item id',
              initialValue: provider.itemId,
              textInputAction: TextInputAction.next,
            ),
            const NoteText(text: 'Quantity '),
            CustomTextField(
              onChanged: (value) => provider.onChangeQuantity(value),
              keyboardType:
              const TextInputType.numberWithOptions(decimal: false),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              hintText: 'Quantity',
              initialValue: provider.quantity.toString(),
              textInputAction: TextInputAction.next,
            ),

            //
            const NoteText(text: 'Amount without dot'),
            CustomTextField(
              onChanged: (value) => provider.onChangeAmount(value),
              keyboardType:
              const TextInputType.numberWithOptions(decimal: false),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              hintText: 'Amount',
              controller: provider.amount,
              textInputAction: TextInputAction.next,
            ),

            const NoteText(text: 'Currency code (Only one currency)'),
            CustomTextField(
              onChanged: (value) => provider.onChangeCurrency(value),
              keyboardType:
              const TextInputType.numberWithOptions(decimal: false),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d{0,2}'),
                ),
              ],
              hintText: 'Currency',
              controller: provider.currency,
              textInputAction: TextInputAction.next,
            ),
            const NoteText(
              text: 'Transaction ID ',
            ),
            const CustomTextField(
              keyboardType:
               TextInputType.text,
              //controller: provider.transactionId,
              hintText: 'Transaction ID',
              textInputAction: TextInputAction.done,
            ),

          ],
        );
      },
    );
  }
}
