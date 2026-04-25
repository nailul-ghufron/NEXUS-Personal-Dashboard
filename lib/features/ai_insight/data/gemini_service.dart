import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final geminiServiceProvider = Provider((ref) => GeminiService());

class GeminiService {
  static const _apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );
  
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
  }

  Future<String> summarizeNotes(List<String> notes) async {
    if (notes.isEmpty) return 'Belum ada catatan untuk dirangkum.';

    final prompt = 'Berikut adalah daftar catatan saya. Tolong buatkan rangkuman singkat dan berikan 3 saran produktivitas berdasarkan catatan ini:\n\n${notes.join('\n- ')}';
    
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Gagal menghasilkan rangkuman.';
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> getProductivityAdvice(String scheduleInfo) async {
    final prompt = 'Berdasarkan jadwal kuliah/kegiatan berikut, berikan saran manajemen waktu yang paling efektif untuk hari ini:\n\n$scheduleInfo';
    
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Gagal menghasilkan saran.';
    } catch (e) {
      return 'Error: $e';
    }
  }
}
