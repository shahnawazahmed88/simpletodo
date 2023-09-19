import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_tools/utils.dart';
import 'package:flutter/material.dart';

class FirebaseHelper{
  static Future<void> helloWorld() async {
    /*HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'us-central1').httpsCallable('addMessage');

    final response = await callable.call();

    if (response.data != null) {
      debugPrint(response.data);
      Utils.showSnackBar(response.data);
    }*/
    HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'us-central1').httpsCallable('addMessageV1');
    final response = await callable.call({"name": "Shahnawaz"});
    if (response.data != null) {
      debugPrint(response.data['name']);
      // Utils.showSnackBar(response.data['name']);
      }
  }

  static Future<void> luckyNumber() async{
    // Create a callable object for the luckyNumber function.
    try {
    HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'us-central1').httpsCallable('luckyNumber');
    // Call the function and get the result.
    Future<dynamic> result = callable.call({ 'name': 'Shahnawaz' });

    // Handle the result.
    result.then((data) {
      if (data != null) {
        debugPrint(data);
        Utils.showSnackBar(data['luckyNumber']);
        print('Lucky number: ${data['luckyNumber']}');
      }
      print('Lucky number: ${data['luckyNumber']}');
    });

    } on FirebaseFunctionsException catch (error) {
      print(error.code);
      print(error.details);
      print(error.message);
    }
  }

}