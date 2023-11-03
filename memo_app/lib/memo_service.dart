import 'dart:convert';

import 'package:flutter/material.dart';

import 'dart:core';

import 'package:intl/intl.dart';

import 'main.dart';

class Memo {
  Memo(
      {required this.id,
      required this.title,
      required this.content,
      required this.date,
      this.fin = false,
      this.finNumber = 99999});

  int id;
  String title;
  String content;
  String date;
  bool fin;
  int finNumber;

  Map toJson() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "date": date,
      "fin": fin,
      "finNumber": finNumber
    };
  }

  factory Memo.fromJson(json) {
    return Memo(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      date: json['date'],
      fin: json['fin'],
      finNumber: json['finNumber'],
    );
  }
}

class MemoService extends ChangeNotifier {
  MemoService() {
    loadMemoList();
  }

  // 더미 데이터
  List<Memo> memoList = [
    Memo(
      id: 1,
      title: "인생이란",
      content: "하루살이",
      date: '2022-03-05 15:22:11',
    ),
    Memo(
      id: 2,
      title: "호호호",
      content: "히히히",
      date: '2022-12-05 11:22:11',
    ),
  ];

  void createMemo() {
    int idValue = memoList[memoList.length - 1].id + 1;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    Memo memo = Memo(id: idValue, date: formattedDate, title: '', content: '');
    memoList.add(memo);
    notifyListeners();
    saveMemoList();
  }

  void updateMemoTitle(index, value) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    memoList[index].title = value;
    memoList[index].date = formattedDate;
    notifyListeners();
    saveMemoList();
  }

  void updateMemoContent(index, value) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    memoList[index].content = value;
    memoList[index].date = formattedDate;
    notifyListeners();
    saveMemoList();
  }

  deleteMemo(index) {
    memoList.removeAt(index);
    notifyListeners();
    saveMemoList();
  }

  setPin(index) {
    if (memoList[index].fin == true) {
      memoList[index].fin = false;
      memoList[index].finNumber = 99999;
    } else {
      memoList.forEach((item) {
        if (item.fin) {
          item.finNumber++;
        }
      });
      memoList[index].fin = true;
      memoList[index].finNumber = 0;
      memoList[index].finNumber++;
    }

    notifyListeners();
    saveMemoList();
  }

  saveMemoList() {
    List memoJsonList = memoList.map((memo) => memo.toJson()).toList();
    // [{"content": "1"}, {"content": "2"}]

    String jsonString = jsonEncode(memoJsonList);
    // '[{"content": "1"}, {"content": "2"}]'

    prefs.setString('memoList', jsonString);
  }

  loadMemoList() {
    String? jsonString = prefs.getString('memoList');
    // '[{"content": "1"}, {"content": "2"}]'

    if (jsonString == null) return; // null 이면 로드하지 않음

    List memoJsonList = jsonDecode(jsonString);
    // [{"content": "1"}, {"content": "2"}]

    memoList = memoJsonList.map((json) => Memo.fromJson(json)).toList();
  }
}
