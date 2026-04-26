import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/local_db_service.dart';

final geminiServiceProvider = Provider((ref) => GeminiService());

class GeminiService {
  final LocalDbService _localDb = LocalDbService();

  // The Pool of API Keys (Multi-Model Provider)
  // Kept here for Load Balancing and Key Rotation
  final List<Map<String, String>> _pool = [
    {
      'provider': 'gemini',
      'key': '', // Masukkan API Key Anda di sini atau gunakan .env
    },
    {
      'provider': 'openrouter',
      'key': '', // Masukkan API Key Anda di sini atau gunakan .env
    },
    {
      'provider': 'grok',
      'key': '', // Masukkan API Key Anda di sini atau gunakan .env
    }
  ];

  int _currentIndex = 0;

  // Generate a simple cache key based on prompt
  String _generateCacheKey(String prompt) {
    int hash = 0;
    for (int i = 0; i < prompt.length; i++) {
      hash = 31 * hash + prompt.codeUnitAt(i);
    }
    return 'ai_cache_${hash.abs()}';
  }

  Future<String> summarizeNotes(List<String> notes) async {
    if (notes.isEmpty) return 'Belum ada catatan untuk dirangkum.';
    final prompt = 'Berikut adalah daftar catatan saya. Tolong buatkan rangkuman singkat dan berikan 3 saran produktivitas berdasarkan catatan ini:\n\n${notes.join('\n- ')}';
    return _getInsightWithRotation(prompt);
  }

  Future<String> getProductivityAdvice(String scheduleInfo) async {
    final prompt = 'Berdasarkan jadwal kuliah/kegiatan berikut, berikan saran manajemen waktu yang paling efektif untuk hari ini:\n\n$scheduleInfo';
    return _getInsightWithRotation(prompt);
  }

  Future<String> _getInsightWithRotation(String prompt) async {
    // 1. Caching Layer (Offline Persistence)
    final cacheKey = _generateCacheKey(prompt);
    final cachedResponse = _localDb.loadData(cacheKey, (json) => json as String);
    if (cachedResponse != null && cachedResponse.isNotEmpty) {
      return cachedResponse.first;
    }

    // 2. Logic Layer: Key Rotation & API Call
    int attempts = 0;
    while (attempts < _pool.length) {
      final currentConfig = _pool[_currentIndex];
      try {
        final result = await _callApi(currentConfig, prompt);
        
        // Save to Cache
        await _localDb.saveData(cacheKey, [result]);
        return result;
      } catch (e) {
        // If Rate Limited (429) or other errors, mark as Cooldown and rotate
        print('Error with provider ${currentConfig['provider']}: $e');
        _currentIndex = (_currentIndex + 1) % _pool.length;
        attempts++;
      }
    }

    return 'Gagal menghasilkan insight. Semua API Key di Pool sedang terkena Rate Limit atau terjadi gangguan jaringan. Silakan coba beberapa saat lagi.';
  }

  Future<String> _callApi(Map<String, String> config, String prompt) async {
    final client = HttpClient();
    try {
      final provider = config['provider'];
      final key = config['key']!;
      
      if (provider == 'gemini') {
        final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$key');
        final request = await client.postUrl(url);
        request.headers.contentType = ContentType.json;
        request.write(jsonEncode({
          "contents": [{"parts": [{"text": prompt}]}]
        }));
        
        final response = await request.close();
        final responseBody = await response.transform(utf8.decoder).join();
        
        if (response.statusCode == 429) throw Exception('Rate limit exceeded (429)');
        if (response.statusCode != 200) throw Exception('API Error: ${response.statusCode} - $responseBody');
        
        final data = jsonDecode(responseBody);
        return data['candidates'][0]['content']['parts'][0]['text'];
        
      } else if (provider == 'openrouter') {
        final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');
        final request = await client.postUrl(url);
        request.headers.set('Authorization', 'Bearer $key');
        request.headers.contentType = ContentType.json;
        request.write(jsonEncode({
          "model": "google/gemini-2.0-flash-lite-preview-02-05:free",
          "messages": [{"role": "user", "content": prompt}]
        }));
        
        final response = await request.close();
        final responseBody = await response.transform(utf8.decoder).join();
        
        if (response.statusCode == 429) throw Exception('Rate limit exceeded (429)');
        if (response.statusCode != 200) throw Exception('API Error: ${response.statusCode} - $responseBody');
        
        final data = jsonDecode(responseBody);
        return data['choices'][0]['message']['content'];
        
      } else if (provider == 'grok') {
        final url = Uri.parse('https://api.x.ai/v1/chat/completions');
        final request = await client.postUrl(url);
        request.headers.set('Authorization', 'Bearer $key');
        request.headers.contentType = ContentType.json;
        request.write(jsonEncode({
          "model": "grok-beta",
          "messages": [{"role": "user", "content": prompt}]
        }));
        
        final response = await request.close();
        final responseBody = await response.transform(utf8.decoder).join();
        
        if (response.statusCode == 429) throw Exception('Rate limit exceeded (429)');
        if (response.statusCode != 200) throw Exception('API Error: ${response.statusCode} - $responseBody');
        
        final data = jsonDecode(responseBody);
        return data['choices'][0]['message']['content'];
      }
      
      throw Exception('Unknown provider');
    } finally {
      client.close();
    }
  }
}
