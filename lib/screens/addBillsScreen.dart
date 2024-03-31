import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_and_doctor_appointment/screens/myAppointments.dart';
import 'package:intl/intl.dart';

class AddBillsScreen extends StatefulWidget {
  const AddBillsScreen({super.key});
  @override
  _AddBillsScreenState createState() => _AddBillsScreenState();
}

class _AddBillsScreenState extends State<AddBillsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
  FocusNode f5 = FocusNode();
  FocusNode f6 = FocusNode();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  String timeText = 'Select Time';
  String dateUTC = "";
  String date_Time = "";

  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  Future<void> selectDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    ).then(
      (date) {
        setState(
          () {
            selectedDate = date!;
            String formattedDate =
                DateFormat('dd-MM-yyyy').format(selectedDate);
            _dateController.text = formattedDate;
            dateUTC = DateFormat('yyyy-MM-dd').format(selectedDate);
          },
        );
      },
    );
  }

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    String formattedTime = localizations.formatTimeOfDay(selectedTime!,
        alwaysUse24HourFormat: false);

    setState(() {
      timeText = formattedTime;
      _timeController.text = timeText;
    });
    date_Time = selectedTime.toString().substring(10, 15);
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: GoogleFonts.lato(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MyBills(),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Done!",
        style: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "Bill is registered.",
        style: GoogleFonts.lato(),
      ),
      actions: [
        okButton,
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

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Creating Bills',
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            return overscroll.leading;
          },
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                child: Image(
                  image: AssetImage('assets/appointment.jpg'),
                  height: 250,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'Enter Bills Details',
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: _nameController,
                        focusNode: f1,
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Please Enter the name of your bill';
                          return null;
                        },
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 20, top: 10, bottom: 10),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[350],
                          hintText: 'Bill Name e.g electricity ',
                          hintStyle: GoogleFonts.lato(
                            color: Colors.black26,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onFieldSubmitted: (String value) {
                          f1.unfocus();
                          FocusScope.of(context).requestFocus(f2);
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        focusNode: f2,
                        controller: _companyController,
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 20, top: 10, bottom: 10),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[350],
                          hintText: 'company e.g Kplc',
                          hintStyle: GoogleFonts.lato(
                            color: Colors.black26,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onFieldSubmitted: (String value) {
                          f2.unfocus();
                          FocusScope.of(context).requestFocus(f3);
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        focusNode: f3,
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 20, top: 10, bottom: 10, right: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[350],
                          hintText: 'Description',
                          hintStyle: GoogleFonts.lato(
                            color: Colors.black26,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onFieldSubmitted: (String value) {
                          f3.unfocus();
                          FocusScope.of(context).requestFocus(f4);
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        focusNode: f4,
                        controller: _priceController,
                        keyboardType: TextInputType.phone,
                        maxLines: null,
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 20, top: 10, bottom: 10),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[350],
                          hintText: 'Enter the price bill price',
                          hintStyle: GoogleFonts.lato(
                            color: Colors.black26,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onFieldSubmitted: (String value) {
                          f4.unfocus();
                          FocusScope.of(context).requestFocus(f4);
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            TextFormField(
                              focusNode: f5,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  left: 20,
                                  top: 10,
                                  bottom: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(90.0)),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[350],
                                hintText: 'Select Date',
                                hintStyle: GoogleFonts.lato(
                                  color: Colors.black26,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              controller: _dateController,
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Please Enter the Date';
                                return null;
                              },
                              onFieldSubmitted: (String value) {
                                f5.unfocus();
                                FocusScope.of(context).dispose();
                              },
                              textInputAction: TextInputAction.next,
                              style: GoogleFonts.lato(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: ClipOval(
                                child: Material(
                                  color: Colors.indigo, // button color
                                  child: InkWell(
                                    // inkwell color
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Icon(
                                        Icons.date_range_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      selectDate(context);
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            TextFormField(
                              focusNode: f5,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  left: 20,
                                  top: 10,
                                  bottom: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(90.0)),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[350],
                                hintText: 'Select Time',
                                hintStyle: GoogleFonts.lato(
                                  color: Colors.black26,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              controller: _timeController,
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Please Enter the Time';
                                return null;
                              },
                              onFieldSubmitted: (String value) {
                                f6.unfocus();
                              },
                              textInputAction: TextInputAction.next,
                              style: GoogleFonts.lato(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: ClipOval(
                                child: Material(
                                  color: Colors.indigo, // button color
                                  child: InkWell(
                                    // inkwell color
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Icon(
                                        Icons.timer_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      selectTime(context);
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 2,
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              showAlertDialog(context);

                              _createAppointment();
                            }
                          },
                          child: Text(
                            "Create Bill",
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createAppointment() async {
    print(dateUTC + ' ' + date_Time + ':00');
    FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid ?? "")
        .collection('bills')
        .doc()
        .set({
      'name': _nameController.text,
      'company': _companyController.text,
      'description': _descriptionController.text,
      'price': _priceController.text,
      'duedate': DateTime.parse(dateUTC + ' ' + date_Time + ':00'),
      'paid': false
    }, SetOptions(merge: true));
    _nameController.clear();
    _companyController.clear();
    _descriptionController.clear();
    _priceController.clear();
  }
}
