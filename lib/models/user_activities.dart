// To parse this JSON data, do
//
//     final userActivities = userActivitiesFromJson(jsonString);

import 'dart:convert';

UserActivities userActivitiesFromJson(String str) =>
    UserActivities.fromJson(json.decode(str));

String userActivitiesToJson(UserActivities data) => json.encode(data.toJson());

class UserActivities {
  int? templatesCount;
  int? formsCount;
  int? enginesCount;
  List<Analytic>? templateAnalytics;
  List<Analytic>? formAnalytics;
  List<Analytic>? engineAnalytics;

  UserActivities({
    this.templatesCount,
    this.formsCount,
    this.enginesCount,
    this.templateAnalytics,
    this.formAnalytics,
    this.engineAnalytics,
  });

  factory UserActivities.fromJson(Map<String, dynamic> json) => UserActivities(
        templatesCount: json["templates_count"],
        formsCount: json["forms_count"],
        enginesCount: json["engines_count"],
        templateAnalytics: json["template_analytics"] == null
            ? []
            : List<Analytic>.from(
                json["template_analytics"]!.map((x) => Analytic.fromJson(x))),
        formAnalytics: json["form_analytics"] == null
            ? []
            : List<Analytic>.from(
                json["form_analytics"]!.map((x) => Analytic.fromJson(x))),
        engineAnalytics: json["engine_analytics"] == null
            ? []
            : List<Analytic>.from(
                json["engine_analytics"]!.map((x) => Analytic.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "templates_count": templatesCount,
        "forms_count": formsCount,
        "engines_count": enginesCount,
        "template_analytics": templateAnalytics == null
            ? []
            : List<dynamic>.from(templateAnalytics!.map((x) => x.toJson())),
        "form_analytics": formAnalytics == null
            ? []
            : List<dynamic>.from(formAnalytics!.map((x) => x.toJson())),
        "engine_analytics": engineAnalytics == null
            ? []
            : List<dynamic>.from(engineAnalytics!.map((x) => x.toJson())),
      };
}

class Analytic {
  int? count;
  int? week;
  String? day;

  Analytic({
    this.count,
    this.week,
    this.day,
  });

  factory Analytic.fromJson(Map<String, dynamic> json) => Analytic(
        count: json["count"],
        week: json["week"],
        day: json["day"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "week": week,
        "day": day,
      };
}
