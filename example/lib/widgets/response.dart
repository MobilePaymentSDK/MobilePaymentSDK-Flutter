import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_payment_plugin/models/payment_response.dart';

class ResponseDialog extends StatelessWidget {
  const ResponseDialog({
    super.key,
    required this.result,
  });

  final PaymentResponse result;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Response'),
      titleTextStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (result.token != null) ...{
            Row(
              children: [
                _buildText(context,
                    title: 'TransactionID', data: result.transactionID.toString()),
                IconButton(
                  icon: const Icon(Icons.content_copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: result.transactionID.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied to clipboard'),
                      ),
                    );
                  },
                )
              ],
            ),
            if(result.originalTransactionID.toString().trim() != 'null')
            Row(
              children: [
                _buildText(context,
                    title: 'OriginalTransactionID', data: result.originalTransactionID.toString()),
                IconButton(
                  icon: const Icon(Icons.content_copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: result.originalTransactionID.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied to clipboard'),
                      ),
                    );
                  },
                )
              ],
            ),
            _buildText(context,
                title: 'StatusCode', data: result.statusCode.toString()),
            _buildText(context,
                title: 'MessageID', data: result.messageID.toString()),
            if(result.description !=null)
              _buildText(context,
                  title: 'description', data: result.description.toString()),
            _buildText(context,
                title: 'SaveCard', data: result.shouldStoreCard.toString()),
            _buildText(context, title: 'rrn', data: result.rrn.toString()),
            _buildText(context,
                title: 'ApprovalCode', data: result.approvalCode.toString()),
            _buildText(context,
                title: 'gatewayStatusCode',
                data: result.gatewayStatusCode.toString()),
            _buildText(context, title: 'Token', data: result.token.toString()),
            _buildText(context,
                title: 'PaymentMethod', data: result.paymentMethod.toString()),
            _buildText(context,
                title: 'StatusDescription',
                data: result.statusDescription.toString()),
            _buildText(context,
                title: 'SecureHash', data: result.secureHash.toString()),
            _buildText(context,
                title: 'Amount', data: result.amount.toString()),
            _buildText(context,
                title: 'CardNumber', data: result.cardNumber.toString()),
            _buildText(context,
                title: 'GatewayName', data: result.gatewayName.toString()),
            _buildText(context,
                title: 'CurrencyISOCode',
                data: result.currencyISOCode.toString()),
            _buildText(context,
                title: 'ResponseHashMatch',
                data: result.responseHashMatch.toString()),
          }
          else ...{
            Row(
              children: [
                _buildText(context,
                    title: 'TransactionID', data: result.transactionID.toString()),
                IconButton(
                  icon: const Icon(Icons.content_copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: result.transactionID.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied to clipboard'),
                      ),
                    );
                  },
                )
              ],
            ),
            if(result.originalTransactionID.toString().trim() != 'null')
              Row(
                children: [
                  _buildText(context,
                      title: 'OriginalTransactionID', data: result.originalTransactionID.toString()),
                  IconButton(
                    icon: const Icon(Icons.content_copy),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: result.originalTransactionID.toString()));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied to clipboard'),
                        ),
                      );
                    },
                  )
                ],
              ),
            _buildText(context,
                title: 'secureHash', data: result.secureHash.toString()),
            _buildText(context,
                title: 'statusDescription', data: result.statusDescription.toString()),
            _buildText(context,
                title: 'amount',
                data: result.amount?.toString() ?? ''),
            _buildText(context,
                title: 'messageID', data: result.messageID.toString()),
            if(result.description !=null)
              _buildText(context,
                  title: 'description', data: result.description.toString()),
            _buildText(context,
                title: 'statusCode',
                data: result.statusCode.toString()),
            _buildText(context,
                title: 'currencyISOCode',
                data: result.currencyISOCode.toString()),
            _buildText(context,
                title: 'merchantID',
                data: result.merchantID.toString()),
          },
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            foregroundColor:
                WidgetStateProperty.all(Theme.of(context).primaryColor),
          ),
          child: const Text('Ok'),
        ),
      ],
    );
  }

  Text _buildText(
    BuildContext context, {
    required String title,
    required String data,
  }) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$title: ',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          TextSpan(text: data),
        ],
      ),
    );
  }
}
