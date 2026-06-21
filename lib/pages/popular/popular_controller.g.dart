// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_import, unnecessary_this, prefer_final_locals
// ignore_for_file: annotate_overrides, unnecessary_overrides, void_checks
// ignore_for_file: omit_local_variable_types, prefer_const_constructors

part of 'popular_controller.dart';

mixin _$PopularController on _PopularController {
  late final _$currentTagAtom =
      Atom(name: '_PopularController.currentTag', context: context);

  @override
  String get currentTag {
    _$currentTagAtom.reportRead();
    return super.currentTag;
  }

  @override
  set currentTag(String value) {
    _$currentTagAtom.reportWrite(value, super.currentTag, () {
      super.currentTag = value;
    });
  }

  late final _$currentDataSourceAtom =
      Atom(name: '_PopularController.currentDataSource', context: context);

  @override
  DataSourceType get currentDataSource {
    _$currentDataSourceAtom.reportRead();
    return super.currentDataSource;
  }

  @override
  set currentDataSource(DataSourceType value) {
    _$currentDataSourceAtom.reportWrite(value, super.currentDataSource, () {
      super.currentDataSource = value;
    });
  }

  late final _$availableTagsAtom =
      Atom(name: '_PopularController.availableTags', context: context);

  @override
  ObservableList<String> get availableTags {
    _$availableTagsAtom.reportRead();
    return super.availableTags;
  }

  @override
  set availableTags(ObservableList<String> value) {
    _$availableTagsAtom.reportWrite(value, super.availableTags, () {
      super.availableTags = value;
    });
  }

  late final _$bangumiListAtom =
      Atom(name: '_PopularController.bangumiList', context: context);

  @override
  ObservableList<BangumiItem> get bangumiList {
    _$bangumiListAtom.reportRead();
    return super.bangumiList;
  }

  @override
  set bangumiList(ObservableList<BangumiItem> value) {
    _$bangumiListAtom.reportWrite(value, super.bangumiList, () {
      super.bangumiList = value;
    });
  }

  late final _$trendListAtom =
      Atom(name: '_PopularController.trendList', context: context);

  @override
  ObservableList<BangumiItem> get trendList {
    _$trendListAtom.reportRead();
    return super.trendList;
  }

  @override
  set trendList(ObservableList<BangumiItem> value) {
    _$trendListAtom.reportWrite(value, super.trendList, () {
      super.trendList = value;
    });
  }

  late final _$isLoadingMoreAtom =
      Atom(name: '_PopularController.isLoadingMore', context: context);

  @override
  bool get isLoadingMore {
    _$isLoadingMoreAtom.reportRead();
    return super.isLoadingMore;
  }

  @override
  set isLoadingMore(bool value) {
    _$isLoadingMoreAtom.reportWrite(value, super.isLoadingMore, () {
      super.isLoadingMore = value;
    });
  }

  late final _$isTimeOutAtom =
      Atom(name: '_PopularController.isTimeOut', context: context);

  @override
  bool get isTimeOut {
    _$isTimeOutAtom.reportRead();
    return super.isTimeOut;
  }

  @override
  set isTimeOut(bool value) {
    _$isTimeOutAtom.reportWrite(value, super.isTimeOut, () {
      super.isTimeOut = value;
    });
  }

  late final _$isMovieModeAtom =
      Atom(name: '_PopularController.isMovieMode', context: context);

  @override
  bool get isMovieMode {
    _$isMovieModeAtom.reportRead();
    return super.isMovieMode;
  }

  @override
  set isMovieMode(bool value) {
    _$isMovieModeAtom.reportWrite(value, super.isMovieMode, () {
      super.isMovieMode = value;
    });
  }

  late final _$_PopularControllerActionController =
      ActionController(name: '_PopularController', context: context);

  @override
  void setCurrentTag(String s) {
    final _$actionInfo = _$_PopularControllerActionController.startAction(
        name: '_PopularController.setCurrentTag');
    try {
      return super.setCurrentTag(s);
    } finally {
      _$_PopularControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDataSource(DataSourceType source) {
    final _$actionInfo = _$_PopularControllerActionController.startAction(
        name: '_PopularController.setDataSource');
    try {
      return super.setDataSource(source);
    } finally {
      _$_PopularControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearBangumiList() {
    final _$actionInfo = _$_PopularControllerActionController.startAction(
        name: '_PopularController.clearBangumiList');
    try {
      return super.clearBangumiList();
    } finally {
      _$_PopularControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearTrendList() {
    final _$actionInfo = _$_PopularControllerActionController.startAction(
        name: '_PopularController.clearTrendList');
    try {
      return super.clearTrendList();
    } finally {
      _$_PopularControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> queryContentByType({String type = 'add'}) {
    final _$actionInfo = _$_PopularControllerActionController.startAction(
        name: '_PopularController.queryContentByType');
    try {
      return super.queryContentByType(type: type);
    } finally {
      _$_PopularControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> queryBangumiByTrend({String type = 'add'}) {
    final _$actionInfo = _$_PopularControllerActionController.startAction(
        name: '_PopularController.queryBangumiByTrend');
    try {
      return super.queryBangumiByTrend(type: type);
    } finally {
      _$_PopularControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> queryBangumiByTag({String type = 'add'}) {
    final _$actionInfo = _$_PopularControllerActionController.startAction(
        name: '_PopularController.queryBangumiByTag');
    try {
      return super.queryBangumiByTag(type: type);
    } finally {
      _$_PopularControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMovieMode(bool v) {
    final _$actionInfo = _$_PopularControllerActionController.startAction(
        name: '_PopularController.setMovieMode');
    try {
      return super.setMovieMode(v);
    } finally {
      _$_PopularControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentTag: ${currentTag},
currentDataSource: ${currentDataSource},
isMovieMode: ${isMovieMode},
availableTags: ${availableTags},
bangumiList: ${bangumiList},
trendList: ${trendList},
isLoadingMore: ${isLoadingMore},
isTimeOut: ${isTimeOut}
    ''';
  }
}
