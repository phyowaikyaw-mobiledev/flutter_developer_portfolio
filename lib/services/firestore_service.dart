import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contact_message.dart';
import '../models/testimonial_model.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  static const _testimonialsCol = 'testimonials';
  static const _contactCol = 'contact_messages';

  Future<List<TestimonialModel>> loadTestimonials() async {
    final snap = await _db
        .collection(_testimonialsCol)
        .where('approved', isEqualTo: true)
        .get();
    final list = snap.docs
        .map((d) => TestimonialModel.fromMap(d.data()))
        .toList();
    list.sort((a, b) => b.id.compareTo(a.id));
    return list;
  }

  Future<void> submitTestimonial(TestimonialModel t) async {
    await _db.collection(_testimonialsCol).doc(t.id).set(t.toMap());
  }

  Future<void> submitContactMessage(ContactMessage message) async {
    await _db.collection(_contactCol).doc(message.id).set(message.toMap());
  }
}