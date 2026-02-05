import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazarpayScreen extends StatefulWidget {
  const RazarpayScreen({super.key});

  @override
  State<RazarpayScreen> createState() => _RazarpayScreenState();
}

class _RazarpayScreenState extends State<RazarpayScreen> {

  final _razorpay = Razorpay();

  String orderPaymentId = "";

  final TextEditingController amountController = TextEditingController();


   openCheckOut() {
        //double amt = amount * 100;
     if (amountController.text.isEmpty) return;
     int amt = int.parse(amountController.text) * 100;
     var options = {
       'key': 'rzp_test_XXp6pYrKU2MgRN',
       'amount': amt.toString(),
       'currency': 'INR',
       'name': 'Pooja Jadhav',
       // 'order_id': 'order_EMBFqjDHEEn80l',
       'description': "My Razorpay Payment",
       'timeout': 60,
       'prefill': {'contact': '+918999542692', 'email': 'pooja.jadhav@example.com'},
     };
         log("options : $options");
         try{
            _razorpay.open(options);
          }catch(e){
           log(e.toString());
         }
   }


 void handlePaymentSuccess(PaymentSuccessResponse response){
   ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text(response.paymentId!)
       ));
     orderPaymentId = response.paymentId.toString();

   print("orderPaymentId ${orderPaymentId} ");
   log("Payment Success: ${response.paymentId}");
 }

 void handlePaymentError(PaymentFailureResponse response){
   ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text(response.message!)
       ));
   log("Payment Error: ${response.error}");

 }

 void handleExternalWallet(ExternalWalletResponse response){
   log("EXTERNAL_WALLET: ${response.walletName!}");
 }


 @override
  void dispose() {
     _razorpay.clear();
    super.dispose();
  }


 @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                  )
                ),
              ),

              const SizedBox(height: 30,),

              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  onPressed: (){
                     openCheckOut();
                  },
                  // onPressed: openCheckOut(amountController.toString()),
                  child: const Text('Pay Amount')
              )
            ],
          ),
        ),
      ),
    );
  }
}
