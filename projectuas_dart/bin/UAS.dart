import 'dart:io';
import 'dart:collection';

// Kelas untuk merepresentasikan sampah
class Sampah {
  String jenis;
  double berat;
  double hargaPerKg;

  Sampah(this.jenis, this.berat, this.hargaPerKg);

  double hitungNilai() {
    return berat * hargaPerKg;
  }

  @override
  String toString() {
    return '- $jenis: $berat kg (Rp${hitungNilai().toStringAsFixed(2)})';
  }
}

// Kelas untuk merepresentasikan transaksi
class Transaksi {
  DateTime tanggal;
  List<Sampah> items;
  String id;

  Transaksi(this.tanggal, this.items) : id = DateTime.now().millisecondsSinceEpoch.toString();

  double hitungTotal() {
    return items.fold(0, (total, item) => total + item.hitungNilai());
  }

  @override
  String toString() {
    String itemList = items.map((item) => item.toString()).join('\n');
    return 'ID: $id\n'
           'Tanggal: ${tanggal.day}/${tanggal.month}/${tanggal.year}\n'
           'Items:\n$itemList\n'
           'Total: Rp${hitungTotal().toStringAsFixed(2)}\n'
           '----------------------------------';
  }
}

// Kelas Bank Sampah
class SistemSampah {
  final Queue<Transaksi> _antrian = Queue();
  final List<Transaksi> _riwayat = [];
  final Map<String, double> _hargaSampah = {
    'kertas': 2000,
    'plastik': 3000,
    'kaleng': 4000,
    'kaca': 2500,
  };

  // Method untuk menambahkan transaksi baru
  void tambahTransaksi() {
    print('\n=== TAMBAH TRANSAKSI BARU ===');
    List<Sampah> items = [];
    DateTime now = DateTime.now();

    while (true) {
      print('\nJenis sampah yang tersedia:');
      _hargaSampah.forEach((jenis, harga) => print('- $jenis (Rp$harga/kg)'));

      stdout.write('\nMasukkan jenis sampah (atau "selesai" untuk mengakhiri): ');
      String jenis = stdin.readLineSync()!.toLowerCase();

      if (jenis == 'selesai') {
        break;
      }

      if (!_hargaSampah.containsKey(jenis)) {
        print('Jenis sampah tidak valid!');
        continue;
      }

      double berat;
      while (true) {
        stdout.write('Masukkan berat $jenis (kg): ');
        try {
          berat = double.parse(stdin.readLineSync()!);
          if (berat <= 0) throw FormatException();
          break;
        } catch (e) {
          print('Masukkan angka yang valid (> 0)!');
        }
      }

      items.add(Sampah(jenis, berat, _hargaSampah[jenis]!));
      print('$jenis ${berat}kg ditambahkan');
    }

    if (items.isNotEmpty) {
      _antrian.add(Transaksi(now, items));
      print('\nTransaksi berhasil ditambahkan ke antrian!');
      print('Total item: ${items.length}');
      print('Menunggu diproses: ${_antrian.length} transaksi dalam antrian');
    } else {
      print('\nTidak ada sampah yang ditambahkan.');
    }
  }

  // memproses antrian
  void prosesAntrian() {
    if (_antrian.isEmpty) {
      print('\nTidak ada transaksi dalam antrian.');
      return;
    }

    Transaksi transaksi = _antrian.removeFirst();
    _riwayat.add(transaksi);

    print('\n=== TRANSAKSI DIPROSES ===');
    print(transaksi);
    print('Sisa antrian: ${_antrian.length} transaksi');
  }

  // menampilkan riwayat
  void tampilkanRiwayat() {
    print('\n=== RIWAYAT TRANSAKSI ===');
    if (_riwayat.isEmpty) {
      print('Belum ada riwayat transaksi.');
    } else {
      _riwayat.reversed.forEach(print); // Menampilkan dari yang terbaru
    }
  }

  // menampilkan antrian
  void tampilkanAntrian() {
    print('\n=== ANTRIAN TRANSAKSI ===');
    if (_antrian.isEmpty) {
      print('Tidak ada transaksi dalam antrian.');
    } else {
      print('Total antrian: ${_antrian.length} transaksi');
      _antrian.forEach((t) => print('• ID: ${t.id} (${t.items.length} items)'));
    }
  }

  // menampilkan deskripsi
  void tampilkanDeskripsi() {
    print('\n=== DESKRIPSI JENIS SAMPAH ===');
    _hargaSampah.forEach((jenis, harga) {
      print('\n$jenis (Rp$harga/kg)');
      switch (jenis) {
        case 'kertas':
          print('   Contoh: Koran, majalah, kardus');
          break;
        case 'plastik':
          print('   Contoh: Botol plastik, kantong plastik');
          break;
        case 'kaleng':
          print('   Contoh: Kaleng minuman, kaleng makanan');
          break;
        case 'kaca':
          print('   Contoh: Botol kaca, pecahan kaca');
          break;
      }
    });
  }
}