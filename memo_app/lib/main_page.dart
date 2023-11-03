import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memo_app/memo_service.dart';
import 'package:provider/provider.dart';

class mainPage extends StatelessWidget {
  mainPage({super.key});
//  MemoService memoService = MemoService();

  @override
  Widget build(BuildContext context) {
    return Consumer<MemoService>(
      builder: (context, memoService, child) {
        List<Memo> memoList = memoService.memoList;
        memoList.sort((a, b) => a.finNumber.compareTo(b.finNumber));
        return Scaffold(
          appBar: AppBar(
            title: Text("MY Memo"),
          ),
          body: ListView.builder(
            itemCount: memoList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: IconButton(
                  onPressed: () {
                    //pin logic
                    print("pin 클릭됨");
                    memoService.setPin(index);
                  },
                  icon: memoList[index].fin
                      ? Icon(CupertinoIcons.pin_fill)
                      : Icon(CupertinoIcons.pin),
                ),
                title: Text(
                  memoList[index].title.toString(),
                ),
                trailing: Text(memoList[index].date.toString()),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(index: index),
                    ),
                  );

                  if (memoList[index].title.isEmpty ||
                      memoList[index].content.isEmpty) {
                    memoService.deleteMemo(index);
                  }
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              memoService.createMemo();

              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    index: memoList.length - 1,
                  ),
                ),
              );

              var lastMemo = memoList[memoList.length - 1];

              if (lastMemo.title.isEmpty || lastMemo.content.isEmpty) {
                memoService.deleteMemo(memoList.length - 1);
              }
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class DetailPage extends StatelessWidget {
  DetailPage({super.key, this.index});

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final index;

  @override
  Widget build(BuildContext context) {
    MemoService memoService = context.read<MemoService>();
    List<Memo> memoList = memoService.memoList;

    titleController.text = memoList[index].title;
    contentController.text = memoList[index].content;

    return Scaffold(
      appBar: AppBar(
        title: Text("글쓰기"),
        actions: [
          IconButton(
              onPressed: () {
                showDeleteDialog(context, memoService);
              },
              icon: Icon(Icons.delete_outline))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "제목",
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 30,
              ),
              onChanged: (value) {
                memoService.updateMemoTitle(index, value);
              },
            ),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                hintText: "설명",
                border: InputBorder.none,
              ),
              autofocus: true,
              maxLines: null,
              // expands: true,
              keyboardType: TextInputType.multiline,
              style: TextStyle(
                fontSize: 18,
              ),
              onChanged: (value) {
                memoService.updateMemoContent(index, value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showDeleteDialog(
      BuildContext context, MemoService memoService) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("삭제할거냐?"),
            actions: [
              TextButton(
                onPressed: () {
                  memoService.deleteMemo(index);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                  "삭제",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "취소",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        });
  }
}
