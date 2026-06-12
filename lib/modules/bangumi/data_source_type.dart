/// 数据源类型枚举
enum DataSourceType {
  /// Bangumi 数据源
  bangumi,

  /// TMDB 数据源
  tmdb,
}

/// 数据源显示名称扩展
extension DataSourceTypeExtension on DataSourceType {
  String get displayName {
    switch (this) {
      case DataSourceType.bangumi:
        return 'Bangumi';
      case DataSourceType.tmdb:
        return 'TMDB';
    }
  }
}
