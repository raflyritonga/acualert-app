import 'dart:math';

import 'package:flutter/widgets.dart';

class BanjirInfoModel {
  late String namaPengguna;
  late String jenisKendaraan;
  late num ketinggianAir;
  late num ketinggianCasis;
  List<String> lokasiList;

  List<String> textPenyertaList = [
    "Jalanan terendam banjir di sekitar",
    "Ada banjir parah di sekitar",
    "Terjadi banjir di",
  ];

  List<String> textPenyertaKalimat2 = [
    "karena ketinggian air mencapai",
    "ketinggian air di lokasi mencapai",
    "ketinggian air sudah berada di",
  ];

  List<String> textHimbauanList = [
    "Lebih baik sabar dan nungguin air surut",
    "Harap bersabar dan tunggu sampai air surut",
    "Jangan memaksaka untuk melewati area banjir",
  ];

  List<String> statusList = [
    "tidak bisa lewat",
    "tidak dapat melewati",
    "berbahaya jika lewat",
  ];

  BanjirInfoModel(this.namaPengguna, this.jenisKendaraan, this.ketinggianAir,
      this.ketinggianCasis, this.lokasiList);

  String randomChoice(List<String> arr) {
    return arr[Random().nextInt(arr.length)];
  }

  String generateKalimat1() {
    final namaPengguna = this.namaPengguna;
    final textPenyerta = randomChoice(textPenyertaList);
    final lokasi = randomChoice(lokasiList);

    final templateChoices = [
      '$textPenyerta $lokasi nih, $namaPengguna!',
      '$namaPengguna, $textPenyerta $lokasi!',
    ];

    final randomTemplate = randomChoice(templateChoices);

    return randomTemplate;
  }

  String generateKalimat2() {
    final jenisKendaraan = this.jenisKendaraan;
    final ketinggianAir = this.ketinggianAir.toString();
    final status = randomChoice(statusList);
    final penyerta = randomChoice(textPenyertaKalimat2);

    final templateChoices = [
      '$jenisKendaraan kamu $status, karena $penyerta $ketinggianAir cm.',
      '$penyerta $ketinggianAir cm, jadi $jenisKendaraan $status.',
      '$jenisKendaraan $status, $penyerta $ketinggianAir cm.',
    ];

    final randomTemplate = randomChoice(templateChoices);

    return randomTemplate[0].toUpperCase() + randomTemplate.substring(1);
  }

  String generateKalimat3() {
    final ruteAlternatif = randomChoice([
      "Klik notifikasi untuk membuka rute alternatif",
      "Kamu dapat mencoba rute alternatif dengan klik notifikasi",
      "Klik notifikasi untuk ikuti rute alternatif"
    ]);

    return '$ruteAlternatif!';
  }

  String generateBanjirInfo() {
    final ketinggianAir = this.ketinggianAir;
    final ketinggianCasis = this.ketinggianCasis;

    if (ketinggianAir > ketinggianCasis) {
      final kalimatUtuh =
          '${generateKalimat1()} ${generateKalimat2()} ${generateKalimat3()}';
      return kalimatUtuh;
    }

    return 'Kendaraan aman untuk melintas.';
  }
}

// void main() {
//   final banjirModel = BanjirInfoModel('Budi Santoso', 'Scoopy', 7, 3, [
//     "Jl. Selayang",
//     "Jl. Kapten Muslim",
//     "Jl. Ahmad Yani",
//     "Jl. M.T. Haryono",
//     "Jl. Universitas"
//   ]);

//   print(banjirModel.generateBanjirInfo());
// }
