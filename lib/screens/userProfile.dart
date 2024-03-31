import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_and_doctor_appointment/firestore-data/appointmentHistoryList.dart';
import 'package:health_and_doctor_appointment/screens/userSettings.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String DocumentID = '';
  Future<void> _getUser() async {
    _user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  String _timeFormatter(String _timestamp) {
    String formattedTime =
        DateFormat('kk:mm').format(DateTime.parse(_timestamp));
    return formattedTime;
  }

  String _dateFormatter(String _timestamp) {
    String formattedDate =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(_timestamp));
    return formattedDate;
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            return overscroll.leading;
          },
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_user?.uid ?? "")
                  .snapshots(),
              builder: (context, snapshot) {
                var user = snapshot.data;
                print(user?['name']);
                return ListView(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.1, 0.5],
                                  colors: [
                                    Colors.indigo,
                                    Colors.indigoAccent,
                                  ],
                                ),
                              ),
                              height: MediaQuery.of(context).size.height / 5,
                              child: Container(
                                padding: EdgeInsets.only(top: 10, right: 7),
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: Icon(
                                    Bootstrap.gear,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserSettings(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height / 5,
                              padding: EdgeInsets.only(top: 75),
                              child: Text(
                                user?['name'] ?? "Update user name",
                                style: GoogleFonts.lato(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage('assets/person.jpg'),
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.teal,
                                width: 5,
                              ),
                              shape: BoxShape.circle),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      padding: EdgeInsets.only(left: 20),
                      height: MediaQuery.of(context).size.height / 7,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey[50],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  height: 27,
                                  width: 27,
                                  color: Colors.red[900],
                                  child: Icon(
                                    Icons.mail_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                user?['email'] ?? "No email",
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  height: 27,
                                  width: 27,
                                  color: Colors.blue[800],
                                  child: Icon(
                                    Icons.phone,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                user?['phone'] ?? "Update phone number",
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                      padding: EdgeInsets.only(left: 20, top: 20),
                      height: MediaQuery.of(context).size.height / 7,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey[50],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  height: 27,
                                  width: 27,
                                  color: Colors.indigo[600],
                                  child: Icon(
                                    Bootstrap.pencil,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Bio',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            child: getBio(),
                          )
                        ],
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                    //   padding: EdgeInsets.only(left: 20, top: 20),
                    //   height: MediaQuery.of(context).size.height / 5,
                    //   width: MediaQuery.of(context).size.width,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     color: Colors.blueGrey[50],
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       Row(
                    //         children: [
                    //           ClipRRect(
                    //             borderRadius: BorderRadius.circular(30),
                    //             child: Container(
                    //               height: 27,
                    //               width: 27,
                    //               color: Colors.green[900],
                    //               child: Icon(
                    //                 Icons.history,
                    //                 color: Colors.white,
                    //                 size: 16,
                    //               ),
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             width: 10,
                    //           ),
                    //           Text(
                    //             "Bills History",
                    //             style: GoogleFonts.lato(
                    //               fontSize: 16,
                    //               fontWeight: FontWeight.bold,
                    //               color: Colors.black,
                    //             ),
                    //           ),
                    //         //   Expanded(
                    //         //     child: Container(
                    //         //       padding: EdgeInsets.only(right: 10),
                    //         //       alignment: Alignment.centerRight,
                    //         //       child: SizedBox(
                    //         //         height: 30,
                    //         //         child: TextButton(
                    //         //           onPressed: () {},
                    //         //           child: Text('View all'),
                    //         //         ),
                    //         //       ),
                    //         //     ),
                    //         //   )
                    //         ],
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              height: 27,
                              width: 27,
                              color: Colors.green[900],
                              child: Icon(
                                Icons.history,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Bills History",
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          //   Expanded(
                          //     child: Container(
                          //       padding: EdgeInsets.only(right: 10),
                          //       alignment: Alignment.centerRight,
                          //       child: SizedBox(
                          //         height: 30,
                          //         child: TextButton(
                          //           onPressed: () {},
                          //           child: Text('View all'),
                          //         ),
                          //       ),
                          //     ),
                          //   )
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Expanded(
                      child: Scrollbar(
                        child: Container(
                          padding: EdgeInsets.only(left: 35, right: 15),
                          child: SingleChildScrollView(
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(_user?.uid ?? "")
                                    .collection('bills')
                                    .where('paid', isEqualTo: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data?.size ?? 0,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot document =
                                          snapshot.data!.docs[index];
                                      return Card(
                                        elevation: 2,
                                        child: ExpansionTile(
                                          expandedAlignment:
                                              Alignment.centerLeft,
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  document['name'],
                                                  style: GoogleFonts.lato(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 0,
                                              ),
                                            ],
                                          ),
                                          subtitle: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              _dateFormatter(document['duedate']
                                                  .toDate()
                                                  .toString()),
                                              style: GoogleFonts.lato(),
                                            ),
                                          ),
                                          children: [
                                            Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    bottom: 20,
                                                    right: 10,
                                                    left: 16,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      SizedBox(
                                                        width: double.infinity,
                                                      ),
                                                      Text(
                                                        "Bill name: " +
                                                            document['name'],
                                                        style: GoogleFonts.lato(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        child: Text(
                                                          document[
                                                              'description'],
                                                          style:
                                                              GoogleFonts.lato(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "Bill price: " +
                                                            document['price'],
                                                        style: GoogleFonts.lato(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "time: " +
                                                            _timeFormatter(
                                                              document[
                                                                      'duedate']
                                                                  .toDate()
                                                                  .toString(),
                                                            ),
                                                        style: GoogleFonts.lato(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget getBio() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_user?.uid ?? '')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        var userData = snapshot.data;

        return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10, left: 40),
          child: Text(
            userData?['bio'] ?? "No Bio",
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black38,
            ),
          ),
        );
      },
    );
  }
}
