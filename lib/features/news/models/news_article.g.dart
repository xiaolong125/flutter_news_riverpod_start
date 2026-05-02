// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NewsArticle _$NewsArticleFromJson(Map<String, dynamic> json) => _NewsArticle(
  articleId: json['article_id'] as String? ?? '',
  title: json['title'] as String? ?? 'Untitled',
  description: json['description'] as String?,
  content: json['content'] as String?,
  link: json['link'] as String?,
  imageUrl: json['image_url'] as String?,
  sourceName: json['source_name'] as String? ?? 'Unknown Source',
  creator:
      (json['creator'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  pubDate: _dateTimeFromJson(json['pubDate']),
  category:
      (json['category'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  country:
      (json['country'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$NewsArticleToJson(_NewsArticle instance) =>
    <String, dynamic>{
      'article_id': instance.articleId,
      'title': instance.title,
      'description': instance.description,
      'content': instance.content,
      'link': instance.link,
      'image_url': instance.imageUrl,
      'source_name': instance.sourceName,
      'creator': instance.creator,
      'pubDate': instance.pubDate?.toIso8601String(),
      'category': instance.category,
      'country': instance.country,
    };
