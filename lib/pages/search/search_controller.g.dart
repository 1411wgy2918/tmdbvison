// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_import, unnecessary_this, prefer_final_locals
// ignore_for_file: annotate_overrides, unnecessary_overrides, void_checks
// ignore_for_file: omit_local_variable_types, prefer_const_constructors

part of 'search_controller.dart';

mixin _$SearchPageController on _SearchPageController, Store {
  late final _$isLoadingAtom =
      Atom(name: '_SearchPageController.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isTimeOutAtom =
      Atom(name: '_SearchPageController.isTimeOut', context: context);

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

  late final _$currentDataSourceAtom =
      Atom(name: '_SearchPageController.currentDataSource', context: context);

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

  late final _$notShowWatchedBangumisAtom = Atom(
      name: '_SearchPageController.notShowWatchedBangumis', context: context);

  @override
  bool get notShowWatchedBangumis {
    _$notShowWatchedBangumisAtom.reportRead();
    return super.notShowWatchedBangumis;
  }

  bool _notShowWatchedBangumisIsInitialized = false;

  @override
  set notShowWatchedBangumis(bool value) {
    _$notShowWatchedBangumisAtom.reportWrite(
        value,
        _notShowWatchedBangumisIsInitialized
            ? super.notShowWatchedBangumis
            : null, () {
      super.notShowWatchedBangumis = value;
      _notShowWatchedBangumisIsInitialized = true;
    });
  }

  late final _$notShowAbandonedBangumisAtom = Atom(
      name: '_SearchPageController.notShowAbandonedBangumis', context: context);

  @override
  bool get notShowAbandonedBangumis {
    _$notShowAbandonedBangumisAtom.reportRead();
    return super.notShowAbandonedBangumis;
  }

  bool _notShowAbandonedBangumisIsInitialized = false;

  @override
  set notShowAbandonedBangumis(bool value) {
    _$notShowAbandonedBangumisAtom.reportWrite(
        value,
        _notShowAbandonedBangumisIsInitialized
            ? super.notShowAbandonedBangumis
            : null, () {
      super.notShowAbandonedBangumis = value;
      _notShowAbandonedBangumisIsInitialized = true;
    });
  }

  late final _$bangumiListAtom =
      Atom(name: '_SearchPageController.bangumiList', context: context);

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

  late final _$searchHistoriesAtom =
      Atom(name: '_SearchPageController.searchHistories', context: context);

  @override
  ObservableList<SearchHistory> get searchHistories {
    _$searchHistoriesAtom.reportRead();
    return super.searchHistories;
  }

  @override
  set searchHistories(ObservableList<SearchHistory> value) {
    _$searchHistoriesAtom.reportWrite(value, super.searchHistories, () {
      super.searchHistories = value;
    });
  }

  late final _$isImageSearchingAtom =
      Atom(name: '_SearchPageController.isImageSearching', context: context);

  @override
  bool get isImageSearching {
    _$isImageSearchingAtom.reportRead();
    return super.isImageSearching;
  }

  @override
  set isImageSearching(bool value) {
    _$isImageSearchingAtom.reportWrite(value, super.isImageSearching, () {
      super.isImageSearching = value;
    });
  }

  late final _$imageSearchErrorAtom =
      Atom(name: '_SearchPageController.imageSearchError', context: context);

  @override
  String get imageSearchError {
    _$imageSearchErrorAtom.reportRead();
    return super.imageSearchError;
  }

  @override
  set imageSearchError(String value) {
    _$imageSearchErrorAtom.reportWrite(value, super.imageSearchError, () {
      super.imageSearchError = value;
    });
  }

  late final _$imageSearchResultsAtom =
      Atom(name: '_SearchPageController.imageSearchResults', context: context);

  @override
  ObservableList<ResultItem> get imageSearchResults {
    _$imageSearchResultsAtom.reportRead();
    return super.imageSearchResults;
  }

  @override
  set imageSearchResults(ObservableList<ResultItem> value) {
    _$imageSearchResultsAtom.reportWrite(value, super.imageSearchResults, () {
      super.imageSearchResults = value;
    });
  }

  late final _$_SearchPageControllerActionController =
      ActionController(name: '_SearchPageController', context: context);

  @override
  void loadSearchHistories() {
    final _$actionInfo = _$_SearchPageControllerActionController.startAction(
        name: '_SearchPageController.loadSearchHistories');
    try {
      return super.loadSearchHistories();
    } finally {
      _$_SearchPageControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String attachSortParams(String input, String sort) {
    final _$actionInfo = _$_SearchPageControllerActionController.startAction(
        name: '_SearchPageController.attachSortParams');
    try {
      return super.attachSortParams(input, sort);
    } finally {
      _$_SearchPageControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> searchBangumi(String input, {String type = 'add'}) {
    final _$actionInfo = _$_SearchPageControllerActionController.startAction(
        name: '_SearchPageController.searchBangumi');
    try {
      return super.searchBangumi(input, type: type);
    } finally {
      _$_SearchPageControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> deleteSearchHistory(SearchHistory history) {
    final _$actionInfo = _$_SearchPageControllerActionController.startAction(
        name: '_SearchPageController.deleteSearchHistory');
    try {
      return super.deleteSearchHistory(history);
    } finally {
      _$_SearchPageControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> clearSearchHistory() {
    final _$actionInfo = _$_SearchPageControllerActionController.startAction(
        name: '_SearchPageController.clearSearchHistory');
    try {
      return super.clearSearchHistory();
    } finally {
      _$_SearchPageControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearImageSearchState() {
    final _$actionInfo = _$_SearchPageControllerActionController.startAction(
        name: '_SearchPageController.clearImageSearchState');
    try {
      return super.clearImageSearchState();
    } finally {
      _$_SearchPageControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> searchImageByFile(File imageFile) {
    final _$actionInfo = _$_SearchPageControllerActionController.startAction(
        name: '_SearchPageController.searchImageByFile');
    try {
      return super.searchImageByFile(imageFile);
    } finally {
      _$_SearchPageControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> searchImageByUrl(String imageUrl) {
    final _$actionInfo = _$_SearchPageControllerActionController.startAction(
        name: '_SearchPageController.searchImageByUrl');
    try {
      return super.searchImageByUrl(imageUrl);
    } finally {
      _$_SearchPageControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNotShowWatchedBangumis(bool value) {
    final _$actionInfo = _$_SearchPageControllerActionController.startAction(
        name: '_SearchPageController.setNotShowWatchedBangumis');
    try {
      return super.setNotShowWatchedBangumis(value);
    } finally {
      _$_SearchPageControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNotShowAbandonedBangumis(bool value) {
    final _$actionInfo = _$_SearchPageControllerActionController.startAction(
        name: '_SearchPageController.setNotShowAbandonedBangumis');
    try {
      return super.setNotShowAbandonedBangumis(value);
    } finally {
      _$_SearchPageControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDataSource(DataSourceType source) {
    final _$actionInfo = _$_SearchPageControllerActionController.startAction(
        name: '_SearchPageController.setDataSource');
    try {
      return super.setDataSource(source);
    } finally {
      _$_SearchPageControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isTimeOut: ${isTimeOut},
currentDataSource: ${currentDataSource},
notShowWatchedBangumis: ${notShowWatchedBangumis},
notShowAbandonedBangumis: ${notShowAbandonedBangumis},
bangumiList: ${bangumiList},
searchHistories: ${searchHistories},
isImageSearching: ${isImageSearching},
imageSearchError: ${imageSearchError},
imageSearchResults: ${imageSearchResults}
    ''';
  }
}
