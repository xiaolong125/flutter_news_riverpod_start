import 'package:flutter_news_riverpod_start/features/news/models/news_article.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NewsArticle', () {
    test('maps Newsdata json fields', () {
      final article = NewsArticle.fromJson(const {
        'article_id': 'abc123',
        'title': 'AI 新闻',
        'description': '新闻摘要',
        'content': '新闻正文',
        'link': 'https://example.com/news',
        'image_url': 'https://example.com/image.png',
        'source_name': '课程新闻',
        'creator': ['课程组'],
        'pubDate': '2026-04-29 18:52:32',
        'category': ['technology'],
        'country': ['china'],
      });

      expect(article.articleId, 'abc123');
      expect(article.title, 'AI 新闻');
      expect(article.summaryText, '新闻摘要');
      expect(article.bodyText, '新闻正文');
      expect(article.imageUrl, 'https://example.com/image.png');
      expect(article.sourceName, '课程新闻');
      expect(article.authorText, '课程组');
      expect(article.category, ['technology']);
      expect(article.country, ['china']);
      expect(article.hasOriginalLink, isTrue);
    });

    test('parses valid pubDate and keeps invalid values null', () {
      final valid = NewsArticle.fromJson(const {
        'article_id': 'valid',
        'title': 'Valid',
        'pubDate': '2026-04-29 18:52:32',
      });
      final invalid = NewsArticle.fromJson(const {
        'article_id': 'invalid',
        'title': 'Invalid',
        'pubDate': 'not a date',
      });

      expect(valid.pubDate?.toUtc().year, 2026);
      expect(valid.pubDate?.toUtc().month, 4);
      expect(valid.pubDate?.toUtc().day, 29);
      expect(invalid.pubDate, isNull);
    });

    test('falls back to description when paid content is unavailable', () {
      final article = NewsArticle.fromJson(const {
        'article_id': 'paid',
        'title': 'Paid',
        'description': '可读摘要',
        'content': 'ONLY AVAILABLE IN PAID PLANS',
      });

      expect(article.bodyText, '可读摘要');
    });
  });
}
