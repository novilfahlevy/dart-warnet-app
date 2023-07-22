import 'dart:io';
import 'package:warnet/computer.dart';
import 'package:warnet/member.dart';

import 'utils.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

List<Map<String, dynamic>> billings = [];

Map<String, dynamic>? findBillingByIndex(final int index) {
  Map<String, dynamic>? billing = billings[index];
  return billing;
}

void showMenu() {
  print('\n===== Manajemen Billing =====');
  print('1. Tampilkan Billing');
  print('2. Tambah Billing');
  print('3. Edit Billing');
  print('4. Hapus Billing');
  print('5. Kembali');
  print('=============================');
}

int getSelectedMenu() {
  showMenu();

  stdout.write('> ');
  int selectedMenu = int.parse(stdin.readLineSync() ?? '');

  return selectedMenu;
}

void showBilling() {
  print('\n===== Daftar Billing =====');
  int i = 1;
  for (final Map<String, dynamic> billing in billings) {
    Map<String, String>? computer = findComputerById(billing['computerId'] ?? '');
    Map<String, String>? member = findMemberById(billing['memberId'] ?? '');
    print('${i++}. ${member?['name']} (${member?['email']}) | ${computer?['name']} | ${billing['hours']} jam | ${billing['createdAtUtc']}');
  }
  print('==========================');

  confirmNext();
}

void addBilling() {
  print('\n===== Tambah billing =====');

  stdout.write('Nomor member: ');
  String? memberIndex = stdin.readLineSync() ?? '';

  stdout.write('Nomor PC: ');
  String? computerIndex = stdin.readLineSync() ?? '';

  stdout.write('Waktu (perjam): ');
  int hours = int.parse(stdin.readLineSync() ?? '');
  
  // check computer exists
  if (!isComputerExistsByIndex(int.parse(computerIndex))) {
    print('PC dengan nomor $computerIndex tidak ditemukan.');
    print('===========================');

    confirmNext();
    return; 
  }

  // check member exists
  if (!isMemberExistsByIndex(int.parse(memberIndex))) {
    print('Member dengan nomor $memberIndex tidak ditemukan.');
    print('===========================');

    confirmNext();
    return; 
  }

  // check hours is valid
  if (hours <= 0) {
    print('Waktu perjam tidak valid.');
    print('===========================');

    confirmNext();
    return;
  }

  final Map<String, String>? computer = findComputerByIndex(int.parse(computerIndex) - 1);
  final Map<String, String>? member = findMemberByIndex(int.parse(memberIndex) - 1);

  billings.add({
    'id': uuid.v4(),
    'memberId': member?['id'] ?? '',
    'computerId': computer?['id'] ?? '',
    'hours': hours,
    'createdAtUtc': DateTime.now().toUtc().toString(),
  });

  print('Berhasil membuat billing untuk ${member?['name']} (${member?['email']}) ke ${computer?['name']}.');
  print('===========================');

  confirmNext();
  showBilling();
}

void editBilling() {
  print('\n===== Tambah billing =====');

  stdout.write('Nomor billing: ');
  String billingIndex = stdin.readLineSync() ?? '';

  final Map<String, dynamic>? billing = findBillingByIndex(int.parse(billingIndex) - 1);
  final Map<String, String>? computer = findComputerById(billing?['computerId']);
  final Map<String, String>? member = findMemberById(billing?['memberId']);

  stdout.write('Waktu (perjam) (${billing?['hours']}): ');
  int hours = int.parse(stdin.readLineSync() ?? billing?['hours']);

  // check hours is valid
  if (hours <= 0) {
    print('Waktu perjam tidak valid.');
    print('===========================');

    confirmNext();
    return;
  }

  final String billingId = billing?['id'];
  final String billingComputerId = billing?['computerId'];
  final String billingMemberId = billing?['memberId'];
  final String billingCreatedAtUtc = billing?['createdAtUtc'];
  
  billings.removeAt(int.parse(billingIndex) - 1);
  billings.insert(int.parse(billingIndex) - 1, {
    'id': billingId,
    'memberId': billingMemberId,
    'computerId': billingComputerId,
    'hours': hours,
    'createdAtUtc': billingCreatedAtUtc,
  });

  print('Berhasil mengedit billing dari ${member?['name']} (${member?['email']}) ke ${computer?['name']}.');
  print('===========================');

  confirmNext();
  showBilling();
}

void deleteBilling() {
  print('\n===== Hapus billing =====');

  stdout.write('Nomor billing: ');
  final int billingIndex = int.parse(stdin.readLineSync() ?? '');

  if (billingIndex > billings.length) {
    print('Nomor billing tidak ditemukan.');
    print('==========================');

    confirmNext();
    deleteBilling();

    return;
  }

  stdout.write('Apakah anda yakin ingin menghapus billing $billingIndex (Y/n): ');
  final String confirmDelete = stdin.readLineSync() ?? 'n';

  if (confirmDelete.toLowerCase() == 'y') {
    billings.removeAt(billingIndex - 1);
    print('Berhasil menghapus billing $billingIndex.');
  }

  print('==========================');

  confirmNext();
  showBilling();
}

void billingModuleApp() {
  bool isAppContinue = true;
  while (isAppContinue) {
    int selectedMenu = getSelectedMenu();
    switch (selectedMenu) {
      case 1: showBilling(); break;
      case 2: addBilling(); break;
      case 3: editBilling(); break;
      case 4: deleteBilling(); break;
      case 5: isAppContinue = false;
    }
  }
}