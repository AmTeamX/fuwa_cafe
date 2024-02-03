import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:fuwa_cafe/api/storage_services.dart';
import 'package:fuwa_cafe/pages/promotion/promotion.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EditPromotion extends StatefulWidget {
  const EditPromotion({super.key, required this.promoId});

  final String promoId;

  @override
  State<EditPromotion> createState() => _EditPromotionState();
}

class _EditPromotionState extends State<EditPromotion> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController detail = TextEditingController();

  var strStartTime = "please select time";
  var strEndTime = "please select time";

  DateTime? startTime;
  DateTime? endTime;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Promotion",
            style: GoogleFonts.chewy(
                textStyle: const TextStyle(
                    color: Color(0xFF6C5F57),
                    decoration: TextDecoration.none,
                    fontSize: 22))),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 30),
          width: screen.width,
          height: screen.height,
          child: Column(
            children: [
              SizedBox(
                  width: screen.width * 0.8,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Promotion name",
                            style: GoogleFonts.chewy(
                                textStyle: const TextStyle(
                                    color: Color(0xFF6C5F57),
                                    decoration: TextDecoration.none,
                                    fontSize: 22))),
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          width: screen.width * 0.8,
                          decoration: const BoxDecoration(
                              color: Color(0xFFCEB09D),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            controller: name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Promotion name';
                              }
                              return null;
                            },
                          ),
                        ),
                        Text("discription",
                            style: GoogleFonts.chewy(
                                textStyle: const TextStyle(
                                    color: Color(0xFF6C5F57),
                                    decoration: TextDecoration.none,
                                    fontSize: 22))),
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          width: screen.width * 0.8,
                          decoration: const BoxDecoration(
                              color: Color(0xFFCEB09D),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: TextFormField(
                            maxLength: 300,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            controller: detail,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'please enter more detial';
                              }
                              return null;
                            },
                          ),
                        ),
                        Text("From",
                            style: GoogleFonts.chewy(
                                textStyle: const TextStyle(
                                    color: Color(0xFF6C5F57),
                                    decoration: TextDecoration.none,
                                    fontSize: 22))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(strStartTime),
                            IconButton(
                                onPressed: () {
                                  DatePicker.showDateTimePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(2024, 1, 1),
                                      maxTime: DateTime(2026, 1, 1),
                                      onConfirm: (date) {
                                    setState(() {
                                      startTime = date;
                                      strStartTime =
                                          DateFormat('yyyy-MM-dd – kk:mm')
                                              .format(startTime!);
                                    });
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                },
                                icon: const Icon(Icons.add_alarm))
                          ],
                        ),
                        Text("To",
                            style: GoogleFonts.chewy(
                                textStyle: const TextStyle(
                                    color: Color(0xFF6C5F57),
                                    decoration: TextDecoration.none,
                                    fontSize: 22))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(strEndTime),
                            IconButton(
                                onPressed: () {
                                  DatePicker.showDateTimePicker(context,
                                      showTitleActions: true,
                                      minTime: startTime,
                                      maxTime: DateTime(2026, 1, 1),
                                      onConfirm: (date) {
                                    setState(() {
                                      endTime = date;
                                      strEndTime =
                                          DateFormat('yyyy-MM-dd – kk:mm')
                                              .format(endTime!);
                                    });
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                },
                                icon: const Icon(Icons.add_alarm))
                          ],
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFCAAF9F)),
                            onPressed: () async {
                              if (startTime != null && endTime != null) {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _loading = true;
                                  });
                                  BuildContext dialogContext = context;

                                  bool isLogin = await StorageServices()
                                      .editPromotion(widget.promoId, startTime!,
                                          endTime!, name.text, detail.text);
                                  setState(() {
                                    _loading = false;
                                  });
                                  if (isLogin == true) {
                                    // ignore: use_build_context_synchronously
                                    await showDialog(
                                        context: dialogContext,
                                        builder: (BuildContext dialogContext) {
                                          return AlertDialog(
                                            title: const Text('Edit successes'),
                                            content: const Text(
                                                "Go to Promotion page"),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Ok'),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute<
                                                                  void>(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  const PromotionPage()),
                                                          ModalRoute.withName(
                                                              '/'));
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    await showDialog(
                                        context: dialogContext,
                                        builder: (BuildContext dialogContext) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Error Something was wrong'),
                                            content:
                                                const Text("please try again"),
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
                              } else {
                                BuildContext dialogContext = context;
                                if (startTime == null) {
                                  await showDialog(
                                      context: dialogContext,
                                      builder: (BuildContext dialogContext) {
                                        return AlertDialog(
                                          title: const Text(
                                              'When is your start time'),
                                          content: const Text(
                                              "Please select start time"),
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
                                } else if (endTime == null) {
                                  await showDialog(
                                      context: dialogContext,
                                      builder: (BuildContext dialogContext) {
                                        return AlertDialog(
                                          title: const Text(
                                              'When is your end time'),
                                          content: const Text(
                                              "Please select end time"),
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
                                : Text('Add Promotions',
                                    style: GoogleFonts.chewy(
                                        textStyle: const TextStyle(
                                            color: Color(0xFF6C5F57),
                                            decoration: TextDecoration.none,
                                            fontSize: 22))),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
