import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kazumi_tmdb/request/apis/bangumi_api.dart';
import 'package:kazumi_tmdb/modules/bangumi/bangumi_item.dart';
import 'package:kazumi_tmdb/modules/bangumi/data_source_type.dart';
import 'package:kazumi_tmdb/services/data_source/data_source_resolver_pool.dart';
import 'package:kazumi_tmdb/services/storage/storage.dart';
import 'package:kazumi_tmdb/utils/constants.dart';
import 'package:mobx/mobx.dart';

part 'popular_controller.g.dart';

class PopularController = _PopularController with _$PopularController;

abstract class _PopularController with Store {
  final ScrollController scrollController = ScrollController();

  @observable
  String currentTag = '';

  @observable
  DataSourceType currentDataSource = DataSourceType.bangumi;

  @observable
  bool isMovieMode = false;

  @observable
  ObservableList<String> availableTags = ObservableList.of(defaultAnimeTags);

  @observable
  ObservableList<BangumiItem> bangumiList = ObservableList.of([]);

  @observable
  ObservableList<BangumiItem> trendList = ObservableList.of([]);

  double scrollOffset = 0.0;

  @observable
  bool isLoadingMore = false;

  @observable
  bool isTimeOut = false;

  bool get _bangumiMirrorEnabled =>
      GStorage.getSetting(SettingsKeys.enableBangumiProxy);

  @action
  void setCurrentTag(String s) {
    currentTag = s;
  }

  @action
  void setDataSource(DataSourceType source) {
    currentDataSource = source;
    DataSourceResolverPool.setDataSource(source);
    if (source == DataSourceType.bangumi) {
      isMovieMode = false;
    }
    updateTagsForDataSource(source);
    clearBangumiList();
    clearTrendList();
    queryContentByType(type: 'init');
  }

  @action
  void setMovieMode(bool v) {
    isMovieMode = v;
    updateTagsForDataSource(currentDataSource);
    clearBangumiList();
    clearTrendList();
    queryContentByType(type: 'init');
  }

  void updateTagsForDataSource(DataSourceType source) {
    availableTags.clear();
    switch (source) {
      case DataSourceType.bangumi:
        availableTags.addAll(defaultAnimeTags);
        break;
      case DataSourceType.tmdb:
        if (isMovieMode) {
          availableTags.addAll(tmdbMovieTags);
        } else {
          availableTags.addAll(tmdbAnimeTags);
        }
        break;
    }
  }

  void clearBangumiList() {
    bangumiList.clear();
  }

  void clearTrendList() {
    trendList.clear();
  }

  @action
  Future<void> queryContentByType({String type = 'add'}) async {
    if (type == 'init') {
      clearBangumiList();
      clearTrendList();
    }
    isLoadingMore = true;
    try {
      var result = await DataSourceResolverPool.getContent(
        tag: currentTag.isEmpty ? null : currentTag,
        offset: currentDataSource == DataSourceType.bangumi
            ? (currentTag.isEmpty ? trendList.length : bangumiList.length)
            : trendList.length,
        type: type,
        useMirror: _bangumiMirrorEnabled,
        isMovie: isMovieMode,
      );

      if (currentDataSource == DataSourceType.bangumi) {
        if (currentTag.isEmpty) {
          trendList.addAll(result);
        } else {
          bangumiList.addAll(result);
        }
      } else {
        trendList.addAll(result);
      }
    } catch (e) {
      isTimeOut = true;
    }
    isLoadingMore = false;
    if (currentDataSource == DataSourceType.bangumi) {
      isTimeOut = currentTag.isEmpty ? trendList.isEmpty : bangumiList.isEmpty;
    } else {
      isTimeOut = trendList.isEmpty;
    }
  }

  @action
  Future<void> queryBangumiByTrend({String type = 'add'}) async {
    if (type == 'init') {
      trendList.clear();
    }
    isLoadingMore = true;
    var result = _bangumiMirrorEnabled
        ? await BangumiApi.getBangumiMirrorPopularSubjects(
            offset: trendList.length)
        : await BangumiApi.getBangumiTrendsList(offset: trendList.length);
    trendList.addAll(result);
    isLoadingMore = false;
    isTimeOut = trendList.isEmpty;
  }

  @action
  Future<void> queryBangumiByTag({String type = 'add'}) async {
    if (type == 'init') {
      bangumiList.clear();
    }
    isLoadingMore = true;
    var tag = currentTag;
    var result = _bangumiMirrorEnabled
        ? await BangumiApi.getBangumiMirrorPopularSubjects(
            tag: tag,
            offset: bangumiList.length,
          )
        : await BangumiApi.getBangumiList(
            rank: Random().nextInt(8000) + 1,
            tag: tag,
          );
    bangumiList.addAll(result);
    isLoadingMore = false;
    isTimeOut = bangumiList.isEmpty;
  }
}
