import 'UAS.dart';
import 'dart:io';
void main() {
  final bankSampah = SistemSampah();

  while (true) {
    print('\n=== BANK SAMPAH DAUR ULANG ===');
    print('1. Tambah Transaksi');
    print('2. Proses Antrian');
    print('3. Lihat Antrian');
    print('4. Lihat Riwayat');
    print('5. Deskripsi Jenis Sampah');
    print('6. Keluar');

    stdout.write('\nPilih menu (1-6): ');
    final pilihan = stdin.readLineSync();

    switch (pilihan) {
      case '1':
        bankSampah.tambahTransaksi();
        break;
      case '2':
        bankSampah.prosesAntrian();
        break;
      case '3':
        bankSampah.tampilkanAntrian();
        break;
      case '4':
        bankSampah.tampilkanRiwayat();
        break;
      case '5':
        bankSampah.tampilkanDeskripsi();
        break;
      case '6':
        print('\nTerima kasih telah menggunakan Bank Sampah!');
        exit(0);
      default:
        print('\nPilihan tidak valid!');
    }
  }
}