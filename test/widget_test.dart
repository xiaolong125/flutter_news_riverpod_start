import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_riverpod_start/core/network/api_exception.dart';
import 'package:flutter_news_riverpod_start/features/news/api/news_api.dart';
import 'package:flutter_news_riverpod_start/features/news/models/news_article.dart';
import 'package:flutter_news_riverpod_start/features/news/models/news_page.dart';
import 'package:flutter_news_riverpod_start/features/news/providers/news_api_provider.dart';
import 'package:flutter_news_riverpod_start/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows loading state on app start', (tester) async {
    final completer = Completer<NewsPage>();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          newsApiProvider.overrideWith(
            (_) => _FakeNewsApi(latest: () => completer.future),
          ),
        ],
        child: const NewsApp(),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows empty state', (tester) async {
    await tester.pumpWidget(_appWithApi(_FakeNewsApi.empty()));
    await tester.pumpAndSettle();

    expect(find.text('暂无新闻'), findsOneWidget);
  });

  testWidgets('shows error state and retry action', (tester) async {
    await tester.pumpWidget(_appWithApi(_FakeNewsApi.error()));
    await tester.pumpAndSettle();

    expect(find.text('加载失败'), findsOneWidget);
    expect(find.text('重试'), findsOneWidget);
  });

  testWidgets('shows list data and opens detail route', (tester) async {
    final article = _article();

    await tester.pumpWidget(_appWithApi(_FakeNewsApi.article(article)));
    await tester.pumpAndSettle();

    expect(find.text('AI 新闻'), findsOneWidget);
    await tester.tap(find.text('AI 新闻'));
    await tester.pumpAndSettle();

    expect(find.text('新闻详情'), findsOneWidget);
    expect(find.text('新闻正文'), findsOneWidget);
  });
}

Widget _appWithApi(NewsApi api) {
  return ProviderScope(
    overrides: [newsApiProvider.overrideWith((_) => api)],
    child: const NewsApp(),
  );
}

NewsArticle _article() {
  return const NewsArticle(
    articleId: 'abc123',
    title: 'AI 新闻',
    description: '新闻摘要',
    content: '新闻正文',
    sourceName: '课程新闻',
    creator: ['课程组'],
    link: 'https://example.com/news',
  );
}

class _FakeNewsApi extends NewsApi {
  _FakeNewsApi({
    required Future<NewsPage> Function() latest,
    Future<NewsArticle> Function(String id)? detail,
  }) : _latest = latest,
       _detail = detail,
       super(Dio());

  factory _FakeNewsApi.empty() {
    return _FakeNewsApi(latest: () async => const NewsPage(articles: []));
  }

  factory _FakeNewsApi.error() {
    return _FakeNewsApi(latest: () async => throw const ApiException('加载失败'));
  }

  factory _FakeNewsApi.article(NewsArticle article) {
    return _FakeNewsApi(
      latest: () async => NewsPage(articles: [article]),
      detail: (_) async => article,
    );
  }

  final Future<NewsPage> Function() _latest;
  final Future<NewsArticle> Function(String id)? _detail;

  @override
  Future<NewsPage> fetchLatest({
    String query = 'ai',
    String category = 'technology',
    String? page,
  }) {
    return _latest();
  }

  @override
  Future<NewsArticle> fetchById(String id) {
    final detail = _detail;
    if (detail != null) {
      return detail(id);
    }
    throw const ApiException('没有找到这篇新闻');
  }
}
