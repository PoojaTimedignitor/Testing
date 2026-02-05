import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:payment_gateway/screen/razarpay_screen.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PhonepeScreen extends StatefulWidget {
  const PhonepeScreen({super.key});

  @override
  State<PhonepeScreen> createState() => _PhonepeScreenState();
}

class _PhonepeScreenState extends State<PhonepeScreen> {

  final environment = 'SANDBOX';
  final merchantId = 'TEST-M23740A4C2P3Z_25102';
  final flowId = 'DEFAULT';
  bool enableLogs = true;

  final appSchema = 'DEFAULT';

  Map<String, dynamic> payload = {
    "orderId": 'OMO2602051429097643630706',
    "merchantId": 'TEST-M23740A4C2P3Z_25102',
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcmVzT24iOjE3NzAzMDUzNDk3NjQsIm1lcmNoYW50SWQiOiJURVNULU0yMzc0MEE0QzJQM1oiLCJtZXJjaGFudE9yZGVySWQiOiJURVNULU0yMzc0MEE0QzJQM1pfMjUxMDIifQ.GpWy5gp0JrfiVlr0GzxIC0UZf1crB0n-UzmLpbgQFQ8",
    "paymentMode": {"type": "PAY_PAGE"}
  };

    late String request = jsonEncode(payload);

  @override
  void initState() {
    initSdk();
    super.initState();
  }


  void initSdk()async{
   PhonePePaymentSdk.init(environment, merchantId, flowId, enableLogs)
       .then((isInitialized){
       log('IsInitialized : $isInitialized');
   }).catchError((onError){
     log('Error Init Sdk : $onError');
     return <dynamic> {};
   });
  }


  void startTransaction()async{
    PhonePePaymentSdk.startTransaction(request, appSchema)
        .then((response){
         setState(() {
           if(response != null){
             final status = response['status'].toString();
             final error = response['error'].toString();

             if(status == 'SUCCESS'){
               log('Flow Completed - Status = success');
             }else{
               log("Flow Completed - Status: $status and Error: $error");
             }
           }else{
             log('Flow Uncompleted');
           }
         });
    }
    ).catchError((e){
      log('Error Start Transaction : $e');
      return <dynamic > {};
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                onPressed: initSdk,
                child: const Text('Init SDK')
            ),
             const SizedBox(height: 20,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                onPressed: startTransaction,
                child: const Text('Start Transaction')
            ),

            const SizedBox(height: 20,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RazarpayScreen()));
                },
                child: const Text('RazorPay')
            ),
          ],
        ),
      ),
    );
  }
}
