import 'package:flutter/material.dart';

import '../helper/shared_preferences.dart';

class SavedCard extends StatefulWidget {
  const SavedCard({super.key});

  @override
  SavedCardState createState() => SavedCardState();
}

class SavedCardState extends State<SavedCard> {
  late List<String>? dataList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    List<String>? loadedData = SharedPreferencesApp.getArray(key: 'tokens');
    setState(() {
      dataList = loadedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Saved Card'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: dataList?.length ?? 0,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(dataList?[index] ?? ''),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              SharedPreferencesApp.deleteItem(
                                key: 'tokens',
                                index: index,
                              ).whenComplete(() => loadData());
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const SaveCardPopup();
                      },
                    ).whenComplete(() => loadData());
                  },
                  child: const Text('Add Card'),
                ),
              ),
            ],
          ),
        ));
  }
}

class SaveCardPopup extends StatefulWidget {
  const SaveCardPopup({super.key});

  @override
  SaveCardPopupState createState() => SaveCardPopupState();
}

class SaveCardPopupState extends State<SaveCardPopup> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Save Card'),
      content: TextField(
        controller: _textEditingController,
        decoration: const InputDecoration(labelText: 'Enter card data'),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            String cardData = _textEditingController.text.trim();
            if (cardData.isNotEmpty) {
              Navigator.of(context).pop();
              List<String> tokenInSharedPreferences =
                  SharedPreferencesApp.getArray(key: 'tokens') ?? [];
              tokenInSharedPreferences.add(cardData);
              await SharedPreferencesApp.setArray(
                  key: 'tokens', array: tokenInSharedPreferences);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter card data'),
                ),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

//  {response:
// {Response.GatewayName: ANBSaudiPaymentsGW,
// Response.StatusCode: 00000,
// Response.StatusDescription: Transaction was processed successfully,
// Response.Amount: 100, Response.PaymentMethod: 1,
// Response.CardNumber: 400000******0000,
// Response.GatewayStatusCode: 00,
// Response.CurrencyISOCode: 682,
// Response.Token: c52bdd6fa4266337c024cc738df1c59b6c4dc0088c863300d66025709219d6ea,
// Response.TransactionID: 1710303654050,
// Response.GatewayStatusDescription: APPROVED,
// Response.RRN: 240312005223,
// Response.MerchantID: AirrchipMerchant,
// Response.ApprovalCode: 123456,
// Response.MessageID: 18}}

//[resp] {Response.CardNumber: 400000******0000,
// Response.Token: c52bdd6fa4266337c024cc738df1c59b6c4dc0088c863300d66025709219d6ea,
// transactionId: 1710387453632,
// Response.StatusCode: 00000,
// Response.TransactionID: 1710387453632,
// Response.CurrencyISOCode: 682,
// Response.ApprovalCode: 123456,
// Response.StatusDescription: Transaction was processed successfully,
// Response.Amount: 100,
// Response.GatewayStatusCode: 00,
// tokenizedCard: c52bdd6fa4266337c024cc738df1c59b6c4dc0088c863300d66025709219d6ea,
// code: 200,
// Response.GatewayStatusDescription: APPROVED,
// shouldStoreCard: true,
// Response.MessageID: 18,
// Response.PaymentMethod: 1,
// Response.RRN: 240358005235,
// Response.GatewayName: ANBSaudiPaymentsGW,
// Response.MerchantID: AirrchipMerchant}
