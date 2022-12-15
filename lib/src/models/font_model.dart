class FontModel {
  final String source, fontFamily;

  final int weight;

  /// Model containing typeface information<br><br>
  ///
  /// [source] - The source of the font file (URL or Asset)<br>
  /// [fontFamily] - The name of the font family (used for lookup later)<br>
  /// [weight] - The font weight
  FontModel({
    required this.source,
    required this.fontFamily,
    this.weight = 400,
  });

  factory FontModel.fromJson(Map json) => FontModel(
        source: json['source'] as String,
        fontFamily: json['fontFamily'] as String,
        weight: json['weight'] as int,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'url': source,
        'fontFamily': fontFamily,
        'weight': weight,
      };
}
