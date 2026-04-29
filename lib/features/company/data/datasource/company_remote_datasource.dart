import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/company_model.dart';

class CompanyRemoteDataSource {
  final FirebaseFirestore firestore;

  CompanyRemoteDataSource(this.firestore);

  Future<List<CompanyModel>> getActiveCompanies() async {
    final snapshot =
        await firestore
            .collection('enterprises')
            .where('status', isEqualTo: 'active')
            .get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return CompanyModel.fromMap(data);
    }).toList();
  }

  Future<void> addCompany(CompanyModel company) async {
    await firestore.collection('enterprises').add(company.toMap());
  }
}
