import 'dart:convert';

class OnboardingModel {
  String animUrl;
  String title;
  String description;

  OnboardingModel({
    required this.animUrl,
    required this.title,
    required this.description,
  });

  OnboardingModel copyWith({
    String? animUrl,
    String? title,
    String? description,
  }) {
    return OnboardingModel(
      animUrl: animUrl ?? this.animUrl,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'animUrl': animUrl,
      'title': title,
      'description': description,
    };
  }

  factory OnboardingModel.fromMap(Map<String, dynamic> map) {
    return OnboardingModel(
      animUrl: map['animUrl'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OnboardingModel.fromJson(String source) =>
      OnboardingModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'OnboardingModel(animUrl: $animUrl, title: $title, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OnboardingModel &&
        other.animUrl == animUrl &&
        other.title == title &&
        other.description == description;
  }

  @override
  int get hashCode => animUrl.hashCode ^ title.hashCode ^ description.hashCode;
}
