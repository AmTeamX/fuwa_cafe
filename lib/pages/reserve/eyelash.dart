// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:fuwa_cafe/api/storage_services.dart';
import 'package:fuwa_cafe/pages/homepage/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Eyelash extends StatefulWidget {
  const Eyelash({super.key});

  @override
  State<Eyelash> createState() => _EyelashState();
}

class _EyelashState extends State<Eyelash> {
  static const List<String> ra = <String>['1', '2', '3', '4', '5'];
  var strDate = "<-select date";
  var strTime = "<-select time";
  bool _loading = false;
  User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController detail = TextEditingController();

  bool isNewly = false;
  bool isFill = false;
  String dropdownValue = ra.first;
  String? selectedPromotionName;
  String? selectedPromotionId;

  DateTime? selectDate;
  DateTime? selectTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF6F0),
        title: Text("Reservation",
            style: GoogleFonts.chewy(
                textStyle: const TextStyle(
                    color: Color(0xFF000000),
                    decoration: TextDecoration.none,
                    fontSize: 22))),
      ),
      backgroundColor: const Color(0xFFFBF6F0),
      body: Container(
        margin: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Receiving services",
                        style: GoogleFonts.chewy(
                            textStyle: const TextStyle(
                                color: Color(0xFF000000),
                                decoration: TextDecoration.none,
                                fontSize: 18))),
                    DropdownMenu<String>(
                      initialSelection: ra.first,
                      onSelected: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      dropdownMenuEntries:
                          ra.map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                            value: value, label: value);
                      }).toList(),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("services date",
                        style: GoogleFonts.chewy(
                            textStyle: const TextStyle(
                                color: Color(0xFF000000),
                                decoration: TextDecoration.none,
                                fontSize: 18))),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(2024, 1, 1),
                                  maxTime: DateTime(2026, 1, 1),
                                  onConfirm: (date) {
                                setState(() {
                                  selectDate = date;
                                  strDate =
                                      DateFormat('dd-MM-yyyy').format(date);
                                });
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            icon: const Icon(Icons.add_alarm)),
                        Text(strDate,
                            style: GoogleFonts.chewy(
                                textStyle: const TextStyle(
                                    color: Color(0xFF000000),
                                    decoration: TextDecoration.none,
                                    fontSize: 18))),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("services time",
                        style: GoogleFonts.chewy(
                            textStyle: const TextStyle(
                                color: Color(0xFF000000),
                                decoration: TextDecoration.none,
                                fontSize: 18))),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              DatePicker.showTimePicker(context,
                                  showTitleActions: true, onConfirm: (time) {
                                setState(() {
                                  selectTime = time;
                                  strTime = DateFormat('HH:mm').format(time);
                                });
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            icon: const Icon(Icons.add_alarm)),
                        Text(strTime,
                            style: GoogleFonts.chewy(
                                textStyle: const TextStyle(
                                    color: Color(0xFF000000),
                                    decoration: TextDecoration.none,
                                    fontSize: 18))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      value: isNewly,
                      onChanged: (bool? value) {
                        setState(() {
                          isNewly = value!;
                        });
                      },
                    ),
                    Text("Newly created",
                        style: GoogleFonts.chewy(
                            textStyle: const TextStyle(
                                color: Color(0xFF000000),
                                decoration: TextDecoration.none,
                                fontSize: 18))),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      value: isFill,
                      onChanged: (bool? value) {
                        setState(() {
                          isFill = value!;
                        });
                      },
                    ),
                    Text("Fill in eyelash",
                        style: GoogleFonts.chewy(
                            textStyle: const TextStyle(
                                color: Color(0xFF000000),
                                decoration: TextDecoration.none,
                                fontSize: 18))),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  children: [
                    Text("Select Promotion",
                        style: GoogleFonts.chewy(
                            textStyle: const TextStyle(
                                color: Color(0xFF000000),
                                decoration: TextDecoration.none,
                                fontSize: 24))),
                  ],
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: StorageServices().getPromotions(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No promotions available.');
                    }

                    List<Map<String, dynamic>> promotionsList = snapshot.data!;

                    return DropdownButtonFormField<String>(
                      value: selectedPromotionId,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPromotionId = newValue;
                          selectedPromotionName = promotionsList.firstWhere(
                              (element) => element['id'] == newValue)['name'];
                        });
                      },
                      items: promotionsList
                          .map<DropdownMenuItem<String>>((promotion) {
                        return DropdownMenuItem<String>(
                          value: promotion['id'],
                          child: Text(promotion['name']),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    );
                  },
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  decoration: const BoxDecoration(
                      color: Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: TextFormField(
                    maxLength: 300,
                    maxLines: 5,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: "More details"),
                    controller: detail,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter more detial';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCAAF9F)),
                  onPressed: () async {
                    _loading = true;

                    if (selectDate != null && selectTime != null) {
                      String allDetait =
                          "NewlyCreate: $isNewly | Fill in eyelash: $isFill ";
                      bool isSuccess = await StorageServices().booking(
                          user!.uid,
                          selectDate!,
                          selectTime!,
                          allDetait,
                          selectedPromotionId == null
                              ? "not have promotion"
                              : selectedPromotionId!,
                          "PE6327CrRVXO08wkXALs",
                          dropdownValue,
                          detail.text);

                      if (isSuccess) {
                        await showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: const Text('Booking success'),
                                content: const Text("Please come on time"),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  const HomePage()),
                                          ModalRoute.withName('/'));
                                    },
                                  ),
                                ],
                              );
                            });
                      } else {
                        await showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: const Text('Booking Failed'),
                                content: const Text("Please try again"),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      }
                      _loading = false;
                    } else {
                      _loading = false;
                      BuildContext dialogContext = context;
                      if (selectTime == null) {
                        await showDialog(
                            context: dialogContext,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: const Text('Select time plz'),
                                content: const Text("Please select time"),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      } else if (selectDate == null) {
                        await showDialog(
                            context: dialogContext,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: const Text('Select date plz'),
                                content: const Text("Please select date"),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      }
                    }
                  },
                  child: _loading
                      ? const CircularProgressIndicator()
                      : Text('Book now!',
                          style: GoogleFonts.chewy(
                              textStyle: const TextStyle(
                                  color: Color(0xFF000000),
                                  decoration: TextDecoration.none,
                                  fontSize: 22))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
