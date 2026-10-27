import 'data.dart';
import 'input.dart';

// ============================================================
// Fungsi bantu
// ============================================================

/// Mencari mahasiswa berdasarkan NIM. Mengembalikan null jika tidak ada.
Map<String, dynamic>? cariByNim(String nim) {
  for (final mhs in daftarMahasiswa) {
    if (mhs['nim'] == nim) return mhs;
  }
  return null;
}

/// Mencetak satu baris data mahasiswa.
void cetakMahasiswa(Map<String, dynamic> mhs) {
  print('${mhs['nim']} | ${mhs['nama']}');
}

/// Meminta pengguna memilih status kehadiran.
StatusHadir bacaStatus(String label) {
  final pilihan = bacaInt(
    '$label (1=hadir, 2=izin, 3=sakit, 4=alpa)',
    min: 1,
    max: 4,
  );
  return switch (pilihan) {
    1 => StatusHadir.hadir,
    2 => StatusHadir.izin,
    3 => StatusHadir.sakit,
    _ => StatusHadir.alpa,
  };
}

// ============================================================
// Fitur yang sudah jadi
// ============================================================

/// Menu 1: menampilkan semua mahasiswa.
void tampilkanDaftar() {
  print('\n=== Daftar Mahasiswa ===');
  if (daftarMahasiswa.isEmpty) {
    print('Belum ada data mahasiswa.');
    return;
  }
  for (final mhs in daftarMahasiswa) {
    cetakMahasiswa(mhs);
  }
}

/// Menu 2: mencatat absensi untuk pertemuan berikutnya.
void catatAbsensi() {
  final nomor = absensi.length + 1;
  print('\n=== Catat Absensi Pertemuan $nomor ===');
  final Map<String, StatusHadir> data = {};
  for (final mhs in daftarMahasiswa) {
    data[mhs['nim'] as String] = bacaStatus('Status ${mhs['nama']}');
  }
  absensi[nomor] = data;
  print('Absensi pertemuan $nomor tersimpan.');
}

/// Menu 3: menampilkan absensi pada satu pertemuan.
void tampilkanAbsensiPertemuan() {
  print('\n=== Absensi per Pertemuan ===');
  if (absensi.isEmpty) {
    print('Belum ada absensi.');
    return;
  }
  final nomor = bacaInt('Nomor pertemuan', min: 1, max: absensi.length);
  final data = absensi[nomor]!;
  print('Pertemuan $nomor:');
  for (final mhs in daftarMahasiswa) {
    final status = data[mhs['nim']];
    print('${mhs['nim']} | ${mhs['nama']} | ${status?.name ?? '-'}');
  }
}

// ============================================================
// Fitur pilihan (pilih minimal 3, lihat README.md)
// ============================================================

/// Menu 4 [Mudah]: menambah mahasiswa baru.
void tambahMahasiswa() {
  // TODO: minta NIM dan nama. Tolak jika NIM sudah terdaftar (pakai cariByNim).
  // Tambahkan ke daftarMahasiswa.
  print('Fitur belum tersedia.');
}

/// Menu 5 [Mudah]: mencari mahasiswa berdasarkan sebagian nama.
void cariMahasiswa() {
  String keyword = bacaTeks('Nama: ').toLowerCase();

  print('=== Cari Mahasiswa ===');
  for (var mhs in daftarMahasiswa) {
    if (mhs['nama']!.toLowerCase().contains(keyword)) {
      print('${mhs['nim']} | ${mhs['nama']}');
    }
  }
}

/// Menu 6 [Sedang]: mengubah status absensi seorang mahasiswa.
void ubahStatus() {
  print('=== Ubah Status Absensi ===');
  int pertemuan = bacaInt('Nomor pertemuan: ');
  String nim = bacaTeks('NIM: ');

  // bacaStatus mengembalikan tipe StatusHadir
  StatusHadir statusBaru = bacaStatus('Status baru (1=hadir, 2=izin, 3=sakit, 4=alpa): ');

  // Mengakses map absensi untuk pertemuan tertentu
  var dataPertemuan = absensi[pertemuan];

  if (dataPertemuan != null) {
    if (dataPertemuan.containsKey(nim)) {
      dataPertemuan[nim] = statusBaru;

      String namaMhs = '';
      for (var mhs in daftarMahasiswa) {
        if (mhs['nim'] == nim) {
          namaMhs = mhs['nama']!;
          break;
        }
      }
      print('Status $namaMhs pada pertemuan $pertemuan diubah menjadi ${_formatStatus(statusBaru)}.');
    } else {
      print('NIM tidak ditemukan pada pertemuan tersebut.');
    }
  } else {
    print('Nomor pertemuan tidak ditemukan.');
  }
}

// Fungsi bantu konversi Enum StatusHadir ke Teks
String _formatStatus(StatusHadir status) {
  switch (status) {
    case StatusHadir.hadir:
      return 'hadir';
    case StatusHadir.izin:
      return 'izin';
    case StatusHadir.sakit:
      return 'sakit';
    case StatusHadir.alpa:
      return 'alpa';
  }
}

/// Menu 7 [Sedang]: menampilkan jumlah setiap status per mahasiswa.
void tampilkanRekap() {
  int totalPertemuan = absensi.length;
  print('=== Rekap Absensi ($totalPertemuan pertemuan) ===');

  for (var mhs in daftarMahasiswa) {
    String nim = mhs['nim']!;
    String nama = mhs['nama']!;

    int hadir = 0, izin = 0, sakit = 0, alpa = 0;

    // Iterasi pada nilai Map absensi (absensi.values)
    for (var p in absensi.values) {
      if (p.containsKey(nim)) {
        var status = p[nim];
        if (status == StatusHadir.hadir) hadir++;
        else if (status == StatusHadir.izin) izin++;
        else if (status == StatusHadir.sakit) sakit++;
        else if (status == StatusHadir.alpa) alpa++;
      }
    }

    print('$nama | hadir $hadir | izin $izin | sakit $sakit | alpa $alpa');
  }
}

/// Menu 8 [Sulit]: menampilkan persentase kehadiran setiap mahasiswa.
void tampilkanPersentase() {
  // TODO: persentase = jumlah hadir / jumlah pertemuan x 100.
  // Tampilkan 1 angka di belakang koma.
  print('Fitur belum tersedia.');
}

/// Menu 9 [Sulit]: menampilkan mahasiswa dengan kehadiran di bawah batas.
void tampilkanDiBawahBatas() {
  // TODO: tampilkan mahasiswa yang persentase kehadirannya < batasKehadiran
  // (lihat data.dart) beserta persentasenya.
  print('Fitur belum tersedia.');
}
