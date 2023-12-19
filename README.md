# BUKOO

[![Build status](https://build.appcenter.ms/v0.1/apps/c3c347a9-50f5-4eb8-8f96-8454039d6028/branches/main/badge)](https://appcenter.ms)

## Daftar Isi

- [Pendahuluan](#Pendahuluan)
- [Cerita aplikasi serta manfaatnya](#Cerita-Aplikasi)
- [Daftar modul yang akan diimplementasikan](#Daftar-Modul)
- [Sumber dataset katalog buku](#Sumber-Dataset)
- [Role pengguna dan deskripsinya](#Role-Pengguna-dan-Deskripsinya)
- [Integrasi dengan _Web Service](#Alur-Integrasi-dengan-Web-Service)

## Pendahuluan

Proyek ini ditujukan sebagai tugas proyek akhir semester kelompok B03 pada mata kuliah PBP 2023/2024.

Nama Anggota Kelompok B03:
- [Muzaki Ahmad Ridho Azizy](https://github.com/muzakiahmdz) 		(2206824924)
- [Ilham Abdillah Alhamdi](https://github.com/ilhamelhamdi) 		(2206081194)
- [Asadilhaq Elqudsi Prabowo](https://github.com/FBK15) 	        (2206083041)
- [Wahyu Aji Aruma Sekar Puri](https://github.com/arumasekar) 	    (2206816115)
- [Fayya Salwa Azheva](https://github.com/fayyazheva) 			    (2206826192)

## Link Berita Acara

Berita acara : [Link](https://docs.google.com/spreadsheets/d/1Gc-QoVwXLlock9_Rs5x1RxzP-md5RMqY2XOWGP69Aj4/edit?usp=sharing)

## Cerita Aplikasi 

Aplikasi **Bukoo** merupakan platform yang dirancang untuk pecinta buku yang ingin menjelajahi lebih koleksi-koleksi buku yang ada di dunia. Meskipun pengguna tidak dapat membaca buku secara langsung di aplikasi ini, mereka dapat menemukan informasi rinci tentang berbagai koleksi buku, mencari koleksi buku berdasarkan judul, kategori, dan genre, membuat daftar favorit, dan membuat review mengenai suatu buku, dan melihat rekomendasi buku berdasarkan preferensi pengguna.

## Daftar Modul
### 1. Modul Koleksi Buku (oleh Ilham Abdillah Alhamdi)
 Dalam modul koleksi buku, pengguna dapat melihat berbagai data koleksi buku. Selain itu, user juga dapat melihat detail masing-masing buku yang berisi data       seperti judul, author, foto cover buku, sinopsis, dan review. User nantinya juga dapat mencari buku berdasarkan author, tahun buku rilis, judul, dan kategori     seperti genre. Pada modul ini, role author dapat mengajukan buku baru dan mengelola buku yang telah ditambahkan.

### 2. Modul Review (oleh Muzaki Ahmad Ridho Azizy)
Kami berencana untuk membuat sebuah kolom untuk user memberikan pendapat tentang sebuah buku yang sudah mereka baca dan ditampilkan dalam data bukunya.

### 3. Modul Profile User (oleh Asadilhaq Elqudsi Prabowo)
  - Profile
      Dalam modul ini, pengguna dapat melihat data dirinya dalam aplikasi ini dan dapat mengubahnya. 
  - Bookmark
      Selain itu, modul ini akan berfungsi untuk user ketika ada sebuah buku yang menarik untuk dibaca atau dibeli dari sumber lain nantinya. User dapat                 menandai buku yang menarik tersebut untuk dapat dilihat nanti jadi tidak perlu untuk mencarinya lagi.

### 4. Modul Dashboard Admin (oleh Fayya Salwa Azheva)
Pada modul ini Admin dapat melakukan verifikasi terhadap buku yang diajukan oleh Author. Admin dapat menyetujui atau menolak pengajuan buku tersebut.

### 5. Modul Forum Diskusi (oleh Wahyu Aji Aruma Sekar Puri)
Modul forum diskusi berfungsi sebagai tempat untuk pembaca dan penulis memberikan ruang bagi pembaca dan penulis untuk berbagi interaksi pendapat, pengalaman, dan saran tentang buku-buku yang mereka baca atau tulis. 

## Sumber Dataset

1. [Gramedia](https://www.gramedia.com/categories/buku) 
2. [Periplus](https://www.periplus.com/c/1/books)
3. [Goodreads](https://www.goodreads.com/) 

Modul koleksi buku kami datanya diambil dari tiga sumber yang telah dicantumkan di atas dan akan menjadi sebuah perpustakaan digital yang komprehensif. Melalui Gramedia, modul ini mempersembahkan visualisasi yang menggugah, dengan foto-foto menawan dari berbagai buku, disertai sinopsis yang menggoda imajinasi serta ulasan otentik dari pengguna yang mendorong pembaca ke dalam dunia cerita. Periplus menyempurnakan koleksi ini dengan menawarkan jendela ke literatur global, memperluas cakrawala dengan buku-buku impor dan karya-karya monumental dari penulis internasional, sembari menyajikan detail penting seperti nama penulis, tahun penerbitan, dan segmentasi fiksi serta non-fiksi. 

 Sementara itu, Goodreads memperkaya platform dengan insight mendalam, menampilkan ulasan tajam dan peringkat buku yang tercurah langsung dari hati komunitas pembaca global, memfasilitasi pengguna dalam menemukan karya yang resonan dengan jiwa dan selera mereka. Uniknya, ulasan ini bersifat murni dari pengguna, menjamin keaslian dan kejujuran setiap pendapat, sehingga menciptakan ruang dialog yang otentik dan terpercaya dalam website kami. Fitur pencarian yang terintegrasi memungkinkan eksplorasi yang mulus berdasarkan beragam kriteria—judul, penulis, tahun terbit, kategori, genre, dan lebih lagi—menjadikan pencarian buku bukan hanya proses, tetapi sebuah petualangan. Dengan menyatukan kekayaan informasi dari ketiga sumber ini, modul koleksi buku kami tidak hanya berfungsi sebagai repositori informasi, tetapi sebagai kompas personal bagi pembaca untuk menemukan, menggali, dan jatuh cinta pada dunia buku yang luas dan beragam.


  
## Role Pengguna dan Deskripsinya

### Author (Penulis)
 - Mengajukan karya buku
   Penulis mempromosikan karya ke dalam aplikasi Bukoo serta memberikan informasi lengkap mengenai buku, seperti judul, sinopsis, dan genre.
 - Mengelola karya buku
   Penulis dapat memperbarui dan mengelola informasi buku, termasuk sinopsis, sampul buku, atau detail lainnya.
 - Diskusi dengan pembaca
   Penulis dapat melakukan diskusi dengan pembaca buku
   
### Readers (Pembaca)
  - Memberikan penilaian 
      Pembaca dapat memberikan penilaian buku tersebut dapat direkomendasikan (Recommended) atau tidak (Not Recommended). 
  - Berpartisipasi dalam memberi ulasan
      Pembaca mampu untuk memberikan ulasan terhadap buku-buku yang mereka baca. Ulasan dapat membantu calon pembaca lainnya memutuskan apakah ingin membaca             buku tersebut atau tidak. Pembaca juga dapat melakukan diskusi terkait buku-buku tertentu dan dapat membahas tentang cerita, karakter, tema, atau aspek           lain dari buku tersebut secara satu arah.
  - Dapat melakukan berinteraksi dengan pembaca lain di forum diskusi 
      
### Guest (Pengguna Umum / _Logout User_)
  - Melihat koleksi buku
      Guest dapat menjelajahi koleksi buku dalam aplikasi Bukoo. Mereka dapat mecari buku berdasarkan judul, penulis, dan genre. Selain itu, mereka dapat               melihat detail buku seperti, sinopsis, penulis, dan tahun rilis. 
  - Melihat ulasan buku
      Guest dapat melihat ulasan yang telah diberikan oleh readers terhadap buku-buku dalam koleksi. Dengan ini, guest mendapatkan wawasan tambahan tentang buku         sebelum memutuskan apakah akan membacanya atau tidak. Namun, pengguna ini tidak dapat mem-bookmarks dan tidak bisa mengulas buku.
      
### Admin (Pengembang Aplikasi Bukoo)
  - Mengelola pengajuan buku
    Memiliki tanggung jawab untuk meninjau pengajuan buku yang diajukan oleh penulis. Selanjutnya melakukan pengecekan apakah sudah sesuai pedoman aplikasi.
  - Menjaga keamanan aplikasi
      Admin memastikan bahwa aplikasi tetap aman dan terhindar dari potensi masalah keamanan atau pelanggaran data.
      

## Alur Integrasi dengan _Web Service_
1. Menyelesaikan API _web service_ untuk masing-masing modul
2. Membuat _API Contract_ untuk _web service_ 




