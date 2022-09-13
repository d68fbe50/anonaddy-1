import 'dart:developer';

import 'package:anonaddy/models/rules/rules.dart';
import 'package:anonaddy/services/dio_client/dio_interceptors.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rulesService = Provider<RulesService>((ref) {
  return RulesService(dio: ref.read(dioProvider));
});

class RulesService {
  const RulesService({required this.dio});
  final Dio dio;

  Future<List<Rules>> getAllRules() async {
    try {
      const path = '$kUnEncodedBaseURL/rules';
      final response = await dio.get(path);
      log('getAllRules: ${response.statusCode}');

      final rules = response.data['data'] as List;
      return rules.map((rule) => Rules.fromJson(rule)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
