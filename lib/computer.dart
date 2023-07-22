import 'dart:io';
import 'utils.dart';
import 'package:uuid/uuid.dart';

final Uuid uuid = Uuid();

final List<Map<String, String>> computers = [{
  'id': uuid.v4(),
  'name': 'PC 1',
}, {
  'id': uuid.v4(),
  'name': 'PC 2',
}, {
  'id': uuid.v4(),
  'name': 'PC 3',
}];

Map<String, String>? findComputerByIndex(final int index) {
  Map<String, String>? computer = computers[index];
  return computer;
}

Map<String, String>? findComputerById(final String id) {
  return computers.firstWhere((computer) => computer['id'] == id);
}

void showMenu() {
  print('\n===== Manajemen PC =====');
  print('1. Tampilkan PC');
  print('2. Tambah PC');
  print('3. Edit PC');
  print('4. Hapus PC');
  print('5. Kembali');
  print('========================');
}

int getSelectedMenu() {
  showMenu();

  stdout.write('> ');
  final int selectedMenu = int.parse(stdin.readLineSync() ?? '');

  return selectedMenu;
}

void showComputer() {
  print('\n===== Daftar PC =====');
  int i = 1;
  for (final Map<String, String> computer in computers) {
    print('${i++}. ${computer['name']}');
  }
  print('=====================');

  confirmNext();
}

bool isComputerExists(final String computerName) {
  return computers
    .where((computer) => computer['name'] == computerName)
    .isNotEmpty;
}

bool isComputerExistsByIndex(final int computerIndex) {
  return computerIndex < computers.length;
}

void addComputer() {
  print('\n===== Tambah komputer =====');

  stdout.write('Nama komputer: ');
  final String computerName = stdin.readLineSync() ?? '';
  
  if (isComputerExists(computerName)) {
    print('$computerName sudah ada.');
    print('===========================');

    confirmNext();
    addComputer();

    return; 
  }

  computers.add({ 'name': computerName });

  print('Berhasil menambah komputer $computerName.');
  print('===========================');

  confirmNext();
  showComputer();
}

void editComputer() {
  print('\n===== Edit komputer =====');

  void failed(String message) {
    print(message);
    print('=========================');
    confirmNext();
    editComputer();
  }

  stdout.write('Nomor komputer: ');
  final int computerIndex = int.parse(stdin.readLineSync() ?? '');

  if (computerIndex > computers.length) {
    failed('Nomor komputer tidak ditemukan.');
    return;
  }

  stdout.write('Nama komputer: ');
  final String computerName = stdin.readLineSync() ?? '';

  if (isComputerExists(computerName)) {
    failed('Komputer sudah ada.');
    return;
  }

  computers.removeAt(computerIndex - 1);
  computers.insert(computerIndex - 1, { 'id': uuid.v4(), 'name': computerName });

  print('Berhasil mengedit komputer $computerIndex.');
  print('=========================');

  confirmNext();
  showComputer();
}

void deleteComputer() {
  print('\n===== Hapus komputer =====');

  stdout.write('Nomor komputer: ');
  final int computerIndex = int.parse(stdin.readLineSync() ?? '');

  if (computerIndex > computers.length) {
    print('Nomor komputer tidak ditemukan.');
    print('==========================');

    confirmNext();
    deleteComputer();

    return;
  }

  stdout.write('Apakah anda yakin ingin menghapus komputer $computerIndex (Y/n): ');
  final String confirmDelete = stdin.readLineSync() ?? 'n';

  if (confirmDelete.toLowerCase() == 'y') {
    computers.removeAt(computerIndex - 1);
    print('Berhasil menghapus komputer $computerIndex.');
  }

  print('==========================');

  confirmNext();
  showComputer();
}

void computerModuleApp() {
  bool isAppContinue = true;
  while (isAppContinue) {
    final int selectedMenu = getSelectedMenu();
    switch (selectedMenu) {
      case 1: showComputer(); break;
      case 2: addComputer(); break;
      case 3: editComputer(); break;
      case 4: deleteComputer(); break;
      case 5: isAppContinue = false;
    }
  }
}