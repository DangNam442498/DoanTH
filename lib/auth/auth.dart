import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes_app/model/user_model.dart';

abstract class BaseAuth {
  Future<String> signInEmailPassword(String email, String password);
  Future<String> signUpEmailPassword(User user); //model/usuarios.dart
  Future<void> signOut();
  Future<String> currentUser();
  Future<FirebaseUser> infoUser();
}

class Auth implements BaseAuth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signInEmailPassword(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.uid;
  }

  Future<String> signUpEmailPassword(User userModel) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: userModel.email, password: userModel.password))
        .user;

    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = userModel.name;
    await user.updateProfile(userUpdateInfo);
    await user
        .sendEmailVerification()
        .then((onValue) => print('Gửi Email xác thực Thành công'))
        .catchError((onError) => print('Lỗi gửi Email xác thử: $onError'));

    await Firestore.instance
        .collection('user')
        .document('${user.uid}')
        .setData({
          'name': userModel.name,
          'phone': userModel.phone,
          'email': userModel.email,
          'address': userModel.address,
          'direction': userModel.direction
        })
        .then((value) => print('Đăng ký tài khoản Thành công'))
        .catchError((onError) => print('Đăng ký tài khoản Thất bại'));
    return user.uid;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    String userId = user != null ? user.uid : 'Chưa Đăng nhập';
    return userId;
  }

  Future<FirebaseUser> infoUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    String userId = user != null ? user.uid : 'Không thể Truy xuất Người dùng';
    print('Người dùng là: + $userId');
    return user;
  }
}
