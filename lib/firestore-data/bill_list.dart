import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_and_doctor_appointment/constants.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class MyBillList extends StatefulWidget {
  @override
  _MyBillListState createState() => _MyBillListState();
}

class _MyBillListState extends State<MyBillList> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String _documentID = "";
  String deviceID = "";

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  Future<void> deleteBill(String docID) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid.toString() ?? "")
        .collection('bills')
        .doc(docID)
        .delete();
  }

  Future<void> paidBill(String docID) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid ?? "")
        .collection('bills')
        .doc(docID)
        .update({
      "paid": true,
    });
  }

  String _getDeviceId() {
    StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid.toString() ?? "")
            .snapshots(),
        builder: (context, snapshot) {
          var data = snapshot.data?.data();
          String device = data!['deviceid'];
          setState(() {
            deviceID = device;
          });
          return SizedBox();
        });
    return deviceID;
  }

  String _dateFormatter(String _timestamp) {
    String formattedDate =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(_timestamp));
    return formattedDate;
  }

  String _timeFormatter(String _timestamp) {
    String formattedTime =
        DateFormat('kk:mm').format(DateTime.parse(_timestamp));
    return formattedTime;
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        deleteBill(_documentID);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm Delete"),
      content: Text("Are you sure you want to delete this Bill?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _checkDiff(DateTime _date) {
    var diff = DateTime.now().difference(_date).inHours;
    if (diff <= 24) {
      return true;
    } else {
      return false;
    }
  }

  _compareDate(String _date) {
    if (_dateFormatter(DateTime.now().toString())
            .compareTo(_dateFormatter(_date)) ==
        0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    _getDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid ?? "")
            .collection('bills')
            .where(
              "paid",
              isEqualTo: false,
            )
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return (snapshot.data?.size ?? "") == 0
              ? Center(
                  child: Text(
                    'No Bills Created',
                    style: GoogleFonts.lato(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data?.size ?? 0,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    // if (_checkDiff(document['duedate'].toDate())) {
                    //   NotificationSetUp().sendPushNotification(
                    //     deviceToken: deviceID,
                    //     body:
                    //         "Hello we remind you for the upcoming bill of ${document['name']} which is due tomorrow",
                    //     title: "Bill reminder",
                    //   );
                    // }

                    return Card(
                      elevation: 2,
                      child: ExpansionTile(
                        expandedAlignment: Alignment.centerLeft,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                document['name'],
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              _compareDate(
                                      document['duedate'].toDate().toString())
                                  ? "TODAY"
                                  : "",
                              style: GoogleFonts.lato(
                                  color: Colors.green,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 0,
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            _dateFormatter(
                                document['duedate'].toDate().toString()),
                            style: GoogleFonts.lato(),
                          ),
                        ),
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 20,
                                  right: 10,
                                  left: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                    ),
                                    Text(
                                      "Bill name: " + document['name'],
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        document['description'],
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Bill price: " + document['price'],
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Due time: " +
                                          _timeFormatter(
                                            document['duedate']
                                                .toDate()
                                                .toString(),
                                          ),
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final String? token =
                                            await FirebaseMessaging.instance
                                                .getToken();
                                        paidBill(document.id);
                                        await http
                                            .post(Uri.parse(apiUrl), body: {
                                          "key": token!,
                                          "body":
                                              "A reminder for payment to a bill for ${document['name']} due in 1 Day",
                                          "title": "Bills Reminder",
                                        });
                                      },
                                      child: SizedBox(
                                        width: 100,
                                        height: 48,
                                        child: Card(
                                          child: Center(
                                            child: Text(
                                              'Mark as paid',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          color: const Color.fromARGB(
                                            255,
                                            246,
                                            100,
                                            222,
                                          ),
                                          shadowColor: Colors.blueGrey[100],
                                          elevation: 5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: IconButton(
                                  tooltip: 'Delete Bill',
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.black87,
                                  ),
                                  onPressed: () {
                                    print(">>>>>>>>>" + document.id);
                                    _documentID = document.id;
                                    showAlertDialog(context);
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
