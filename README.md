Repositori ini berisi aplikasi MATLAB yang dirancang untuk meningkatkan kualitas gambar dan video yang diambil dalam kondisi minim cahaya. Aplikasi ini menyediakan antarmuka pengguna grafis (GUI) yang sederhana bagi pengguna untuk memuat gambar atau video, menerapkan filter peningkatan, dan kemudian mengunduh media yang telah diproses.

Fitur
1. Peningkatan Gambar: Memperbaiki kecerahan dan kontras gambar di kondisi minim cahaya.

2. Peningkatan Video: Memproses dan meningkatkan setiap frame video untuk visibilitas keseluruhan yang lebih baik.

3. Antarmuka yang Mudah Digunakan: GUI sederhana memungkinkan interaksi yang mudah.

4. Pemilihan Berkas: Muat format gambar umum (JPG, JPEG, PNG, BMP) dan format video (MP4, AVI, MOV).

5. Opsi Unduh: Simpan gambar yang ditingkatkan sebagai PNG atau JPEG, dan video yang ditingkatkan sebagai MP4.

6. Indikator Progres: Untuk pemrosesan video, label progres menampilkan frame yang sedang diproses.

Untuk menjalankan aplikasi ini, Anda harus memiliki MATLAB terinstal di sistem Anda. Kode ini dikembangkan dan diuji dengan MATLAB R2023a, tetapi seharusnya kompatibel dengan versi terbaru yang mendukung uifigure dan komponen App Designer terkait.

Cara instalasi : 
1. Kloning repositori: git clone https://github.com/Bailana/simple-low-light-enhancer.git

2. Masuk ke direktori proyek: cd simple-low-light-enhancer

Cara Menjalankan :
1. Buka MATLAB.

2. Arahkan ke direktori tempat Anda mengkloning repositori.

3. Di Jendela Perintah MATLAB, ketik: simple_light_enhancer

4. Tekan Enter. Jendela GUI akan muncul.

Cara Penggunaan : 
1. Muat Gambar: Klik tombol "Pilih Gambar" untuk memilih berkas gambar dari komputer Anda. Gambar yang dipilih akan muncul di tampilan "Gambar Asli / Frame Awal".

2. Muat Video: Klik tombol "Pilih Video" untuk memilih berkas video. Frame pertama video akan ditampilkan di tampilan "Gambar Asli / Frame Awal".

3. Tingkatkan Media: Setelah memuat gambar atau video, klik tombol "Perbaiki Gambar/Video Gelap". Untuk gambar, gambar yang ditingkatkan akan muncul di tampilan "Setelah Filter". Untuk video, aplikasi akan memproses setiap frame. Sebuah indikator progres akan menunjukkan frame yang sedang diproses, dan tampilan "Setelah Filter" akan diperbarui secara berkala untuk menampilkan frame yang ditingkatkan.

4. Unduh Gambar yang Ditingkatkan: Jika Anda memproses gambar, tombol "Unduh Gambar" akan menjadi aktif. Klik untuk menyimpan gambar yang ditingkatkan.

5. Unduh Video yang Ditingkatkan: Jika Anda memproses video, tombol "Unduh Video" akan menjadi aktif setelah selesai. Klik untuk menyimpan video yang ditingkatkan.
