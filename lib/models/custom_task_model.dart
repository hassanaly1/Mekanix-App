class MyCustomTask {
  final String? id;
  final String name;
  String? customerName, customerEmail;
  bool isForm, isTemplate, isDefault;
  final List<MyPage> pages;

  MyCustomTask({
    this.id,
    required this.name,
    this.customerName,
    this.customerEmail,
    required this.isForm,
    required this.isTemplate,
    required this.isDefault,
    required this.pages,
  });

  Map<String, dynamic> toMap() {
    return {
      'is_template': isTemplate.toString(),
      'is_form': isForm.toString(),
      'name': name,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'pages': pages.map((e) => e.toMap()).toList(),
    };
  }

  static fromMap(Map<String, dynamic> map) {
    return MyCustomTask(
      id: map['_id'],
      name: map['name'],
      customerName: map['customer_name'],
      customerEmail: map['customer_email'],
      isForm: !map['is_template'],
      isTemplate: map['is_template'],
      isDefault: map['is_default'],
      pages: map["pages"] == null
          ? []
          : List<MyPage>.from(
              map["pages"]!.map((x) => MyPage.fromMap(x)),
            ),
    );
  }
}

class MyPage {
  final List<MySection> sections;

  MyPage({required this.sections});

  Map<String, dynamic> toMap() {
    return {
      'formSections':
          sections.map((MySection section) => section.toMap()).toList(),
    };
  }

  static fromMap(Map<String, dynamic> map) {
    return MyPage(
      sections: map["formSections"] == null
          ? []
          : List<MySection>.from(
              map["formSections"]!.map((x) => MySection.fromMap(x)),
            ),
    );
  }
}

class MySection {
  MySection({required this.heading, required this.elements});

  final String heading;
  final List<MyCustomElementModel> elements;

  Map<String, dynamic> toMap() {
    return {
      'heading': heading,
      'elements': elements.map((e) => e.toMap()).toList(),
    };
  }

  static fromMap(Map<String, dynamic> map) {
    return MySection(
      heading: map['heading'],
      elements: map["elements"] == null
          ? []
          : List<MyCustomElementModel>.from(
              map["elements"]!.map((x) => MyCustomElementModel.fromMap(x)),
            ),
    );
  }
}

enum MyCustomItemType { textfield, textarea, radiobutton, checkbox, attachment }

String? _typeInString(MyCustomItemType? type) => type?.name;

MyCustomItemType? _typeFromString(String? type) {
  switch (type) {
    case 'textfield':
      return MyCustomItemType.textfield;
    case 'textarea':
      return MyCustomItemType.textarea;
    case 'radiobutton':
      return MyCustomItemType.radiobutton;
    case 'checkbox':
      return MyCustomItemType.checkbox;
    case 'attachment':
      return MyCustomItemType.attachment;
    default:
      return null;
  }
}

class MyCustomElementModel {
  final String? label;
  final List<String>? options;
  final MyCustomItemType? type;
  dynamic value;

  MyCustomElementModel({this.label, this.options, this.type, this.value});

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'options': options,
      'type': _typeInString(type),
      'value': value,
    };
  }

  static fromMap(Map<String, dynamic> map) {
    return MyCustomElementModel(
      label: map['label'] ?? '',
      options: map['options'] == null ? [] : List<String>.from(map['options']),
      type: _typeFromString(map['type']),
      value: map['value'],
    );
  }
}
// 'value': type == MyCustomItemType.textfield ||
//         type == MyCustomItemType.textarea
//     ? value.text.trim()
//     : type == MyCustomItemType.radiobutton
//         ? value.value
//         : type == MyCustomItemType.checkbox
//             ? value.value
//             : type == MyCustomItemType.attachment
//                 ? (value is int ? value : null)
//                 : null
