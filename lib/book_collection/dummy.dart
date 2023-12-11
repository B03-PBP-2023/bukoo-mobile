import 'package:bukoo/book_collection/models/book.dart';
import 'package:bukoo/book_collection/models/genre.dart';

final dummyBook = Book(
  id: 1,
  title: "Laskar Pelangi",
  imageUrl:
      "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1489732961i/1362193.jpg",
  authors: ["Andrea Hirata"],
  description:
      "Begitu banyak hal menakjubkan yang terjadi dalam masa kecil para anggota Laskar Pelangi. Sebelas orang anak Melayu Belitong yang luar biasa ini tak menyerah walau keadaan tak bersimpati pada mereka. Tengoklah Lintang, seorang kuli kopra cilik yang genius dan dengan senang hati bersepeda 80 kilometer pulang pergi untuk memuaskan dahaganya akan ilmu—bahkan terkadang hanya untuk menyanyikan Padamu Negeri di akhir jam sekolah. Atau Mahar, seorang pesuruh tukang parut kelapa sekaligus seniman dadakan yang imajinatif, tak logis, kreatif, dan sering diremehkan sahabat-sahabatnya, namun berhasil mengangkat derajat sekolah kampung mereka dalam karnaval 17 Agustus. Dan juga sembilan orang Laskar Pelangi lain yang begitu bersemangat dalam menjalani hidup dan berjuang meraih cita-cita. Selami ironisnya kehidupan mereka, kejujuran pemikiran mereka, indahnya petualangan mereka, dan temukan diri Anda tertawa, menangis, dan tersentuh saat membaca setiap lembarnya. Buku ini dipersembahkan buat mereka yang meyakini the magic of childhood memories, dan khususnya juga buat siapa saja yang masih meyakini adanya pintu keajaiban lain untuk mengubah dunia: pendidikan.",
  genres: [
    Genre(id: 1, name: "Fantasy"),
    Genre(id: 2, name: "Adventure"),
    Genre(id: 3, name: "Fiction"),
    Genre(id: 4, name: "Young Adult"),
    Genre(id: 5, name: "Children"),
    Genre(id: 6, name: "Novel"),
    Genre(id: 7, name: "Romance"),
    Genre(id: 8, name: "Historical"),
    Genre(id: 9, name: "Cultural"),
  ],
  publisher: "Bentang Pustaka",
  publishDate: "2008-01-01",
  numPages: 534,
  language: "Indonesian",
  isbn: "9789793062792",
);
