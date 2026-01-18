import 'dart:async';
import 'dart:io';
import 'package:evently/data/network/results.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<Results<T>> safeCall<T>(Future<Results<T>> Function() call) async {
  try{
    return call();
  }
  on FirebaseAuthException catch(e, stackTrace){
    return Failure(exception: e,message: stackTrace.toString());
  }on FirebaseException catch(e, stackTrace){
    return Failure(exception: e,message: stackTrace.toString());
  }on SocketException catch(e, stackTrace){
    return Failure(exception: e,message: stackTrace.toString());
  }on IOException catch(e, stackTrace){
    return Failure(exception: e,message: stackTrace.toString());
  }on TimeoutException catch(e, stackTrace){
    return Failure(exception: e,message: stackTrace.toString());
  }on FormatException catch(e, stackTrace){
    return Failure(exception: e,message: stackTrace.toString());
  } catch(e,stackTrace){
    return Failure(exception: e as Exception, message: stackTrace.toString());
  }

}