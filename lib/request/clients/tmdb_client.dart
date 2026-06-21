import 'package:dio/dio.dart';
import 'package:kazumi_tmdb/services/storage/storage.dart';
import 'package:kazumi_tmdb/services/logging/logger.dart';

/// TMDB API 客户端异常
class TMDBApiException implements Exception {
  final String message;
  final int? statusCode;

  TMDBApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'TMDBApiException: $message (status: $statusCode)';
}

/// TMDB API Key 未配置异常
class TMDBNotConfiguredException implements Exception {
  @override
  String toString() => 'TMDB API Key 未配置，请在设置中添加';
}

/// TMDB API 客户端
class TMDBClient {
  static TMDBClient? _instance;
  final Dio _dio;
  final String _apiKey;

  TMDBClient._internal({required String apiKey})
      : _apiKey = apiKey,
        _dio = Dio() {
    _dio.options.baseUrl = 'https://api.themoviedb.org/3';
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    
    // 添加拦截器处理 API Key 和错误
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.queryParameters['api_key'] = _apiKey;
        options.queryParameters['language'] = 'zh-CN';
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          error = error.copyWith(
            response: error.response,
          );
          KazumiLogger().e('TMDB API Key 无效或过期');
        } else if (error.response?.statusCode == 429) {
          KazumiLogger().e('TMDB API 请求过于频繁');
        }
        return handler.next(error);
      },
    ));
  }

  /// 获取单例实例
  factory TMDBClient() {
    final apiKey = GStorage.getSetting(SettingsKeys.tmdbApiKey);
    if (apiKey == '' || apiKey.isEmpty) {
      throw TMDBNotConfiguredException();
    }
    
    _instance ??= TMDBClient._internal(apiKey: apiKey);
    return _instance!;
  }

  /// 重新创建客户端（用于 API Key 更新后）
  static void reset() {
    _instance = null;
  }

  /// GET 请求
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      KazumiLogger().e('TMDB API 请求失败：$path', error: e);
      if (e.response?.statusCode == 401) {
        throw TMDBApiException('TMDB API Key 无效或过期', 401);
      } else if (e.response?.statusCode == 429) {
        throw TMDBApiException('API 请求过于频繁，请稍后再试', 429);
      }
      rethrow;
    }
  }

  /// POST 请求
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      KazumiLogger().e('TMDB API 请求失败：$path', error: e);
      rethrow;
    }
  }
}
