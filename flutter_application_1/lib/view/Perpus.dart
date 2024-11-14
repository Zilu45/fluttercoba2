import 'package:flutter/material.dart';
import '../controllers/Perpus_controller.dart';
import '../models/BukuCtrl.dart';
import '../widget/Modal2.dart';

class Perpustakaan extends StatefulWidget {
  const Perpustakaan({super.key});

  @override
  State<Perpustakaan> createState() => _PerpustakaanState();
}

class _PerpustakaanState extends State<Perpustakaan> {
  final formKey = GlobalKey<FormState>();
  Bukuctrl bukudb = Bukuctrl();
  TextEditingController judul = TextEditingController();
  TextEditingController cover = TextEditingController();
  TextEditingController deskripsiPenulis = TextEditingController();
  TextEditingController penerbit = TextEditingController();
  TextEditingController stok = TextEditingController();
  TextEditingController id = TextEditingController();
  List buttonChoice = ["Update", "Hapus"];
  List? buku;
  int? buku_stok;
  int? buku_id;

  void BukuCtrl() {
    setState(() {
      buku = bukudb.Perpus;
    });
  }

  @override
  void initState() {
    super.initState();
    BukuCtrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perpustakaan"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                buku_stok = null;
              });
              judul.clear();
              cover.clear();
              deskripsiPenulis.clear();
              penerbit.clear();
              stok.clear();
              ModalWidget().showFullModal(context, addItem(null));
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: buku != null
          ? ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: buku!.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () => _showFullImage(context, buku![index].cover),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image(
                          image: AssetImage(buku![index].cover),
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ID: ${buku![index].id}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          buku![index].judul,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text("Penerbit: ${buku![index].penerbit}"),
                        Text("Penulis: ${buku![index].deskripsiPenulis}"),
                        SizedBox(height: 5),
                        Text(
                          "Stok: ${buku![index].stok}",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        return buttonChoice.map((r) {
                          return PopupMenuItem(
                            value: r,
                            child: Text(r),
                            onTap: () {
                              if (r == "Update") {
                                setState(() {
                                  buku_stok = buku![index].stok;
                                });
                                setState(() {
                                  buku_id = buku![index].id;
                                });
                                judul.text = buku![index].judul;
                                cover.text = buku![index].cover;
                                deskripsiPenulis.text =
                                    buku![index].deskripsiPenulis;
                                penerbit.text = buku![index].penerbit;
                                stok.text = buku![index].stok.toString();
                                ModalWidget().showFullModal(
                                  context,
                                  addItem(index),
                                );
                              } else if (r == "Hapus") {
                                setState(() {
                                  buku!.removeAt(index);
                                });
                                BukuCtrl();
                              }
                            },
                          );
                        }).toList();
                      },
                    ),
                  ),
                );
              },
            )
          : Center(child: Text('Tidak ada data buku tersedia')),
    );
  }

  Widget addItem(int? index) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _buildTextField(id, 'ID BUKU'),
            SizedBox(height: 10),
            _buildTextField(judul, 'Judul'),
            SizedBox(height: 10),
            _buildTextField(cover, 'Cover Buku'),
            SizedBox(height: 10),
            _buildTextField(deskripsiPenulis, 'Penulis'),
            SizedBox(height: 10),
            _buildTextField(penerbit, 'Penerbit'),
            SizedBox(height: 10),
            _buildTextField(stok, 'Stok', isNumeric: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (index != null) {
                    buku![index].id = int.parse(id.text);
                    buku![index].judul = judul.text;
                    buku![index].cover = cover.text;
                    buku![index].deskripsiPenulis = deskripsiPenulis.text;
                    buku![index].penerbit = penerbit.text;
                    buku![index].stok = int.parse(stok.text);
                    Bukuctrl();
                  } else {
                    buku!.add(BukuModel(
                      id: int.parse(id.text),
                      judul: judul.text,
                      cover: cover.text,
                      deskripsiPenulis: deskripsiPenulis.text,
                      penerbit: penerbit.text,
                      stok: int.parse(stok.text),
                    ));
                    Bukuctrl();
                  }
                  Navigator.pop(context);
                }
              },
              child: Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumeric = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        hintText: "Masukkan $label",
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      validator: (value) => value!.isEmpty ? '$label harus diisi' : null,
    );
  }

  void _showFullImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, fit: BoxFit.cover),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Tutup'),
            ),
          ],
        ),
      ),
    );
  }
}
