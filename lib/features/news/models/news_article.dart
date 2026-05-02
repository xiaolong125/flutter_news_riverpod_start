// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_article.freezed.dart';
part 'news_article.g.dart';

@freezed
/// 新闻实体模型：承载 Newsdata 返回字段，并提供 UI 友好的派生属性。
abstract class NewsArticle with _$NewsArticle {
  const NewsArticle._();

  const factory NewsArticle({
    // 接口字段是 article_id，Dart 字段使用 articleId。
    @JsonKey(name: 'article_id') @Default('') String articleId,
    @Default('Untitled') String title,
    String? description,
    String? content,
    String? link,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'source_name') @Default('Unknown Source') String sourceName,
    @Default(<String>[]) List<String> creator,
    @JsonKey(name: 'pubDate', fromJson: _dateTimeFromJson) DateTime? pubDate,
    @Default(<String>[]) List<String> category,
    @Default(<String>[]) List<String> country,
  }) = _NewsArticle;

  factory NewsArticle.fromJson(Map<String, dynamic> json) =>
      _$NewsArticleFromJson(json);

  /// 作者展示文本：没有作者时给出兜底文案，避免页面出现空白。
  String get authorText {
    if (creator.isEmpty) {
      return '未知作者';
    }
    return creator.join('、');
  }

  /// 摘要展示文本：优先 description，空值时返回默认提示。
  String get summaryText {
    final summary = description?.trim();
    if (summary == null || summary.isEmpty) {
      return '暂无摘要';
    }
    return summary;
  }

  /// 正文展示文本：过滤 Newsdata 免费计划中的占位正文。
  String get bodyText {
    final text = content?.trim();
    if (text != null &&
        text.isNotEmpty &&
        text != 'ONLY AVAILABLE IN PAID PLANS') {
      return text;
    }
    return summaryText;
  }

  /// 是否可跳转原文：要求 URL 可被解析且包含协议头。
  bool get hasOriginalLink {
    final value = link;
    if (value == null) {
      return false;
    }
    final uri = Uri.tryParse(value);
    return uri != null && uri.hasScheme;
  }
}

DateTime? _dateTimeFromJson(Object? value) {
  // 接口时间字段可能为空串或非字符串，统一转成 null。
  if (value is! String || value.trim().isEmpty) {
    return null;
  }

  // Newsdata 常见格式是 "yyyy-MM-dd HH:mm:ss"，先转成 ISO 风格再解析。
  final normalized = value.trim().replaceFirst(' ', 'T');
  return DateTime.tryParse('${normalized}Z') ?? DateTime.tryParse(value);
}
