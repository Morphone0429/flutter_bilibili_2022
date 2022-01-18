//barrage_model.dart
import 'dart:convert';

class BarrageModel {
  late String content; // 弹幕内容
  late String vid; //  弹幕对应视频id
  late int priority; // 弹幕优先级
  late int type; // 弹幕类型

  BarrageModel(
      {required this.content,
      required this.vid,
      required this.priority,
      required this.type});

  BarrageModel.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    vid = json['vid'];
    priority = json['priority'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['vid'] = this.vid;
    data['priority'] = this.priority;
    data['type'] = this.type;
    return data;
  }

  static List<BarrageModel> fromJsonString(json) {
    List<BarrageModel> list = [];
    if (!(json is String) || !json.startsWith('[')) {
      print('json is not invalid');
      return [];
    }

    var jsonArray = jsonDecode(json);
    jsonArray.forEach((v) {
      list.add(new BarrageModel.fromJson(v));
    });
    return list;
  }
}
