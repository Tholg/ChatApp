import 'package:chat_app/Group_chat/create_group.dart/create_group.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddMemberInGroup extends StatefulWidget {
  const AddMemberInGroup({super.key});

  @override
  State<AddMemberInGroup> createState() => _AddMemberInGroupState();
}

class _AddMemberInGroupState extends State<AddMemberInGroup> {
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> memberList = [];
  bool isLoading = false;
  Map<String, dynamic>? userMap;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserDetail();
  }

  void getCurrentUserDetail() async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((map) {
      setState(() {
        memberList.add({
          "name": map['name'],
          "email": map['email'],
          "uid": map['uid'],
          "isAdmin": true,
        });
      });
    });
  }

  void onRemoveMember(int index) {
    if (memberList[index]['uid'] != _auth.currentUser!.uid) {
      setState(() {
        memberList.removeAt(index);
      });
    }
  }

  void onResultTap() {
    bool isAllreadyExits = false;
    for (int i = 0; i < memberList.length; i++) {
      if (memberList[i]['uid'] == userMap!['uid']) {
        isAllreadyExits = true;
      }
    }
    if (!isAllreadyExits) {
      setState(() {
        memberList.add({
          "name": userMap!['name'],
          "email": userMap!['email'],
          "uid": userMap!['uid'],
          "isAdmin": false,
        });
        userMap == null;
        print("$memberList day la tholggggggggggggggggg");
      });
    }
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection("users")
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      // print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Add Member")),
      body: isLoading
          ? Container(
              width: size.width,
              height: size.height,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    child: ListView.builder(
                        itemCount: memberList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () => onRemoveMember(index),
                            leading: Icon(Icons.account_circle),
                            title: Text(memberList[index]['name']),
                            subtitle: Text(memberList[index]['email']),
                            trailing: Icon(Icons.close),
                          );
                        })),
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.2,
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                          hintText: "Search",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                isLoading
                    ? Container(
                        height: size.height / 20,
                        width: size.width / 20,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: onSearch,
                        child: Text("Search"),
                      ),
                userMap != null
                    ? ListTile(
                        onTap: onResultTap,
                        leading: Icon(Icons.account_box),
                        title: Text(userMap!['name']),
                        subtitle: Text(userMap!['email']),
                        trailing: Icon(Icons.add),
                      )
                    : SizedBox()
              ],
            )),
      floatingActionButton: memberList.length >= 2
          ? FloatingActionButton(
              child: Icon(Icons.forward),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => CreateGroup(
                        memberList: memberList,
                      ))),
            )
          : SizedBox(),
    );
  }
}
