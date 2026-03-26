import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/testimonial_model.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  static const _col = 'testimonials';

  Future<List<TestimonialModel>> loadTestimonials() async {
    final snap = await _db
        .collection(_col)
        .where('approved', isEqualTo: true)
        .get();
    final list = snap.docs
        .map((d) => TestimonialModel.fromMap(d.data()))
        .toList();
    // Sort newest first in-memory
    list.sort((a, b) => b.id.compareTo(a.id));
    return list;
  }

  Future<void> submitTestimonial(TestimonialModel t) async {
    await _db.collection(_col).doc(t.id).set(t.toMap());
  }
}