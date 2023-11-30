import 'package:cloud_firestore/cloud_firestore.dart';




class MenuService {
  Future<void> adicionarItem(String nome, double preco) async {
    await FirebaseFirestore.instance.collection('menu').add({
      'nome': nome,
      'preco': preco,
    });
  }

  Future<void> removerItem(String itemId) async {
    await FirebaseFirestore.instance.collection('menu').doc(itemId).delete();
  }

  Stream<QuerySnapshot> getMenuStream() {
    return FirebaseFirestore.instance.collection('menu').snapshots();
  }
}


