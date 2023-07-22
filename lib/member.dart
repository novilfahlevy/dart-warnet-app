import 'dart:io';
import 'utils.dart';
import 'package:uuid/uuid.dart';

typedef Member = Map<String, String>;

final Uuid uuid = Uuid();

final List<Member> members = [{
  'id': uuid.v4(),
  'name': 'Member 1',
  'email': 'member1@gmail.com'
}, {
  'id': uuid.v4(),
  'name': 'Member 2',
  'email': 'member2@gmail.com'
}, {
  'id': uuid.v4(),
  'name': 'Member 3',
  'email': 'member3@gmail.com'
}];

Member? findMemberByIndex(final int index) {
  final Member member = members[index];
  return member;
}

Member? findMemberById(final String id) {
  return members.firstWhere((member) => member['id'] == id);
}

void showMenu() {
  print('\n===== Manajemen member =====');
  print('1. Tampilkan member');
  print('2. Tambah member');
  print('3. Edit member');
  print('4. Hapus member');
  print('5. Kembali');
  print('========================');
}

int getSelectedMenu() {
  showMenu();

  stdout.write('> ');
  final int selectedMenu = int.parse(stdin.readLineSync() ?? '');

  return selectedMenu;
}

void showMember() {
  print('\n===== Daftar member =====');
  int i = 1;
  for (final Member member in members) {
    final String name = '${member['name']} (${member['email']})';
    print('${i++}. $name');
  }
  print('=====================');

  confirmNext();
}

bool isMemberExists(final String memberEmail) {
  return members
    .where((member) => member['email'] == memberEmail)
    .isNotEmpty;
}

bool isMemberExistsByIndex(final int memberIndex) {
  return memberIndex < members.length;
}

void addMember() {
  print('\n===== Tambah member =====');

  stdout.write('Nama member: ');
  String name = stdin.readLineSync() ?? '';
  
  stdout.write('Email member: ');
  final String email = stdin.readLineSync() ?? '';
  
  if (isMemberExists(email)) {
    print('$email sudah ada.');
    print('===========================');

    confirmNext();
    addMember();

    return; 
  }

  members.add({ 'id': uuid.v4(), 'name': name, 'email': email });

  name = '$name ($email)';
  print('Berhasil menambah member $name.');
  print('===========================');

  confirmNext();
  showMember();
}

void editMember() {
  print('\n===== Edit member =====');

  void failed(final String message) {
    print(message);
    print('=========================');
    confirmNext();
    editMember();
  }

  stdout.write('Nomor member: ');
  final int memberIndex = int.parse(stdin.readLineSync() ?? '');

  if (memberIndex > members.length) {
    failed('Nomor member tidak ditemukan.');
    return;
  }

  final Member member = members[memberIndex - 1];

  stdout.write('Nama member (${member['name']}): ');
  String name = stdin.readLineSync() ?? '';
  name = name.isNotEmpty ? name : member['name'].toString();

  stdout.write('Email member (${member['email']}): ');
  String email = stdin.readLineSync() ?? '';
  email = email.isNotEmpty ? email : member['email'].toString();

  if (member['email'] != email && isMemberExists(email)) {
    failed('Email member sudah ada.');
    return;
  }

  members.removeAt(memberIndex - 1);
  members.insert(memberIndex - 1, { 'name': name, 'email': email });

  print('Berhasil mengedit member $memberIndex.');
  print('=========================');

  confirmNext();
  showMember();
}

void deleteMember() {
  print('\n===== Hapus member =====');

  stdout.write('Nomor member: ');
  final int memberIndex = int.parse(stdin.readLineSync() ?? '');

  if (memberIndex > members.length) {
    print('Nomor member tidak ditemukan.');
    print('==========================');

    confirmNext();
    deleteMember();

    return;
  }

  stdout.write('Apakah anda yakin ingin menghapus member $memberIndex (Y/n): ');
  final String confirmDelete = stdin.readLineSync() ?? 'n';

  if (confirmDelete.toLowerCase() == 'y') {
    members.removeAt(memberIndex - 1);
    print('Berhasil menghapus member $memberIndex.');
  }

  print('==========================');

  confirmNext();
  showMember();
}

void memberModuleApp() {
  bool isAppContinue = true;
  while (isAppContinue) {
    final int selectedMenu = getSelectedMenu();
    switch (selectedMenu) {
      case 1: showMember(); break;
      case 2: addMember(); break;
      case 3: editMember(); break;
      case 4: deleteMember(); break;
      case 5: isAppContinue = false;
    }
  }
}