class AISource {
  final String title;
  final String url;

  AISource({
    required this.title,
    required this.url,
  });

  factory AISource.fromJson(Map<String, dynamic> json) {
    return AISource(
      title: json['title'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
    };
  }
}

class AIResponse {
  final String text;
  final List<AISource> sources;

  AIResponse({
    required this.text,
    required this.sources,
  });

  factory AIResponse.fromJson(Map<String, dynamic> json) {
    return AIResponse(
      text: json['text'] as String,
      sources: (json['sources'] as List)
          .map((e) => AISource.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'sources': sources.map((e) => e.toJson()).toList(),
    };
  }
}
