import 'package:kazumi_tmdb/modules/bangumi/bangumi_item.dart';
import 'package:kazumi_tmdb/modules/bangumi/bangumi_tag.dart';

/// TMDB 数据模型
class TMDBItem {
  /// TMDB ID
  final int id;

  /// 原始名称
  final String name;

  /// 中文名称（如果有）
  final String nameCn;

  /// 简介
  final String overview;

  /// 首播/上映日期
  final String airDate;

  /// 评分 (0-10)
  final double voteAverage;

  /// 投票数
  final int voteCount;

  /// 图片 URLs
  final Map<String, String> images;

  /// 原产国
  final String originCountry;

  /// 类型标签
  final List<String> genres;

  /// 集数（剧集）或时长（电影，分钟）
  final int episodeCount;

  /// 状态（Ended, Returning 等）
  final String status;

  /// 媒体类型: tv / movie
  final String mediaType;

  const TMDBItem({
    required this.id,
    required this.name,
    required this.nameCn,
    required this.overview,
    required this.airDate,
    required this.voteAverage,
    required this.voteCount,
    required this.images,
    required this.originCountry,
    required this.genres,
    required this.episodeCount,
    required this.status,
    required this.mediaType,
  });

  /// 从 TMDB API 响应 JSON 创建实例
  factory TMDBItem.fromJson(Map<String, dynamic> json) {
    final String mt = (json['media_type'] as String?) ?? '';
    // 有 name/first_air_date 的是 TV，有 title/release_date 的是 Movie
    final bool isMovie = mt == 'movie' || json.containsKey('title');

    // 解析图片 URLs
    Map<String, String> parseImages(Map<String, dynamic> data) {
      final String? posterPath = data['poster_path'] as String?;
      final String? backdropPath = data['backdrop_path'] as String?;

      return {
        'large': posterPath != null && posterPath.isNotEmpty
            ? 'https://image.tmdb.org/t/p/w500$posterPath'
            : '',
        'common': backdropPath != null && backdropPath.isNotEmpty
            ? 'https://image.tmdb.org/t/p/w500$backdropPath'
            : '',
        'medium': posterPath != null && posterPath.isNotEmpty
            ? 'https://image.tmdb.org/t/p/w342$posterPath'
            : '',
        'small': posterPath != null && posterPath.isNotEmpty
            ? 'https://image.tmdb.org/t/p/w185$posterPath'
            : '',
        'grid': posterPath != null && posterPath.isNotEmpty
            ? 'https://image.tmdb.org/t/p/w342$posterPath'
            : '',
      };
    }

    // 解析类型标签
    List<String> parseGenres(dynamic genresData) {
      if (genresData == null || genresData is! List) {
        return [];
      }
      return genresData
          .whereType<Map<String, dynamic>>()
          .map((genre) => genre['name'] as String)
          .where((name) => name.isNotEmpty)
          .toList();
    }

    // 解析原产国
    String parseOriginCountry(dynamic originCountries) {
      if (originCountries == null ||
          originCountries is! List ||
          originCountries.isEmpty) {
        return '';
      }
      return (originCountries.first as String).toUpperCase();
    }

    // 解析中文名称（优先使用中文翻译）
    String parseNameCn(dynamic translations) {
      if (translations == null || translations is! Map) {
        return '';
      }
      final results = translations['results'] as List?;
      if (results == null || results.isEmpty) {
        return '';
      }

      for (var result in results) {
        if (result is Map && result['iso_3166_1'] == 'CN') {
          final data = result['data'] as Map?;
          final title = data?['title'] as String?;
          if (title != null && title.isNotEmpty) {
            return title;
          }
        }
      }
      return '';
    }

    final String nameStr = (json['name'] ?? json['title'] ?? '') as String;
    final String airDateStr =
        (json['first_air_date'] ?? json['release_date'] ?? '') as String;
    final List<String> genreList = parseGenres(json['genres']);
    final Map<String, String> imageMap = parseImages(json);
    final String originCountryStr =
        parseOriginCountry(json['origin_countries'] ?? json['origin_country']);
    final String nameCnStr = parseNameCn(json['translations']);

    return TMDBItem(
      id: json['id'] as int,
      name: nameStr,
      nameCn: nameCnStr,
      overview: json['overview'] as String? ?? '',
      airDate: airDateStr,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,
      images: imageMap,
      originCountry: originCountryStr,
      genres: genreList,
      episodeCount: isMovie
          ? (json['runtime'] as int? ?? 0)
          : (json['number_of_seasons'] as int? ?? 0),
      status: json['status'] as String? ?? '',
      mediaType: mt.isNotEmpty ? mt : (isMovie ? 'movie' : 'tv'),
    );
  }

  /// 转换为 BangumiItem 格式（兼容现有 UI）
  BangumiItem toBangumiItem() {
    final tmdbType = mediaType == 'movie' ? 98 : 99; // 98=TMDB电影 99=TMDB剧集
    return BangumiItem(
      id: id,
      type: tmdbType, // TMDB 类型标识，区分于 Bangumi 的 type=2
      name: name,
      nameCn: nameCn.isEmpty ? name : nameCn,
      summary: overview,
      airDate: airDate,
      airWeekday: _parseAirWeekday(airDate),
      rank: (voteAverage * 10).toInt(), // TMDB 评分 0-10 转换为 0-100
      images: images,
      tags: genres
          .map((genre) => BangumiTag(name: genre, count: 0, totalCount: 0))
          .toList(),
      alias: [],
      ratingScore: voteAverage,
      votes: voteCount,
      votesCount: [],
      info: status.isEmpty ? '' : '状态：$status',
    );
  }

  /// 解析空气日期为星期几
  int _parseAirWeekday(String airDate) {
    if (airDate.isEmpty) {
      return 0;
    }
    try {
      final date = DateTime.parse(airDate);
      // Dart 的 weekday: 1=Monday, 7=Sunday
      // Bangumi: 1=Monday, 7=Sunday
      return date.weekday;
    } catch (e) {
      return 0;
    }
  }
}
