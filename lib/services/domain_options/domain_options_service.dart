import 'dart:async';
import 'dart:developer';

import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/services/dio_client/dio_interceptors.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final domainOptionsService = Provider<DomainOptionsService>((ref) {
  return DomainOptionsService(dio: ref.read(dioProvider));
});

class DomainOptionsService {
  const DomainOptionsService({required this.dio});
  final Dio dio;

  Future<DomainOptions> getDomainOptions() async {
    try {
      const path = '$kUnEncodedBaseURL/domain-options';
      final response = await dio.get(path);
      log('getDomainOptions: ${response.statusCode}');
      return DomainOptions.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
