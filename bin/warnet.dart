import 'dart:io';
import 'package:warnet/billing.dart';
import 'package:warnet/computer.dart';
import 'package:warnet/member.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

List<Map<String, String>> users = [{
  'id': uuid.v4(),
  'username': 'novilfahlevy',
  'password': 'password'
}, {
  'id': uuid.v4(),
  'username': 'albygael',
  'password': '123'
}];

bool login() {
  stdout.write('Username: ');
  String? username = stdin.readLineSync();
  stdout.write('Password: ');
  String? password = stdin.readLineSync();

  return users
    .where((user) => user['username'] == username && user['password'] == password)
    .isNotEmpty;
}

void showMenu() {
  print('\n===== Dashboard =====');
  print('1. Manajemen PC');
  print('2. Manajemen Member');
  print('3. Manajemen Billing');
  print('4. Keluar');
  print('=====================');
}

int getSelectedMenu() {
  showMenu();

  stdout.write('> ');
  int selectedMenu = int.parse(stdin.readLineSync() ?? '');

  return selectedMenu;
}

void app() {
  bool isLogin = login();
  if (isLogin) {
    bool isAppContinue = true;
    while (isAppContinue) {
      int selectedMenu = getSelectedMenu();
      switch (selectedMenu) {
        case 1: computerModuleApp(); break;
        case 2: memberModuleApp(); break;
        case 3: billingModuleApp(); break;
        case 4: isAppContinue = false;
      }
    }
  } else {
    print('Akun tidak ditemukan.');
  }
}

void main() {
  app();
}