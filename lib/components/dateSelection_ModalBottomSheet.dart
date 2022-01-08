import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:ndialog/ndialog.dart';
import 'package:unit/components/forms/rounded_button..dart';
import 'package:unit/components/modalBottomSheetheader.dart';
import 'package:unit/constants.dart';
import 'package:unit/models/compound.dart';
import 'package:unit/models/property.dart';
import 'package:unit/models/user.dart';
import 'package:unit/services/database.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:unit/translations/locale_keys.g.dart';

class DateSelectionForm extends StatefulWidget {
  const DateSelectionForm({
    Key key,
    @required this.dateSearch,
    // @required this.dateTextController,

    this.changeDateSearch,
    this.property,
    this.user,
    this.type,
    this.compound,
    this.sheetState,
  }) : super(key: key);

  final String dateSearch;
  // final TextEditingController dateTextController;
  final StateSetter sheetState;
  final Function changeDateSearch;
  final Property property;
  final UserData user;
  final String type;
  final Compound compound;

  @override
  _DateSelectionFormState createState() => _DateSelectionFormState();
}

class _DateSelectionFormState extends State<DateSelectionForm> {
  String myDate = tr(LocaleKeys.select_date);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return SingleChildScrollView(
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ModalBottomSheetHeader(
              title: '',
              sizedBoxWidth: 0.17,
            ),
            GestureDetector(
              onTap: () {
                DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime.now(),
                  maxTime: DateTime(2030),
                  onChanged: (date) {},
                  onConfirm: (date) {
                    if (date == null) {
                      setState(() {
                        widget.changeDateSearch('');
                      });

                      // showCancel =
                      //     false;
                    } else {
                      setState(() {
                        widget.changeDateSearch(
                            '${DateFormat("MMM").format(date)} ${DateFormat("d").format(date)} - ${DateFormat("jm").format(date)}');
                      });
                      widget.sheetState(() {
                        myDate =
                            ('${DateFormat("MMM").format(date)} ${DateFormat("d").format(date)} - ${DateFormat("jm").format(date)}');
                      });
                    }
                  },
                  currentTime: DateTime.now(),
                  locale: context.locale == Locale('en')
                      ? LocaleType.en
                      : LocaleType.ar,
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: myDate != tr(LocaleKeys.select_date)
                          ? kPrimaryColor
                          : Color(0xFFff2800),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          DatePicker.showDateTimePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            maxTime: DateTime(2030),
                            onChanged: (date) {},
                            onConfirm: (date) {
                              if (date == null) {
                                setState(() {
                                  widget.changeDateSearch('');
                                });

                                // showCancel =
                                //     false;
                              } else {
                                setState(() {
                                  widget.changeDateSearch(
                                      '${DateFormat("MMM").format(date)} ${DateFormat("d").format(date)} - ${DateFormat("jm").format(date)}');
                                });
                                widget.sheetState(() {
                                  myDate =
                                      ('${DateFormat("MMM").format(date)} ${DateFormat("d").format(date)} - ${DateFormat("jm").format(date)}');
                                });
                              }
                            },
                            currentTime: DateTime.now(),
                            locale: context.locale == Locale('en')
                                ? LocaleType.en
                                : LocaleType.ar,
                          );
                        },
                        icon: Icon(
                          Icons.calendar_today_rounded,
                          color: myDate != tr(LocaleKeys.select_date)
                              ? kPrimaryColor
                              : Color(0xFFff2800),
                        ),
                      ),
                      Text(
                        myDate,
                        style: TextStyle(
                          color: myDate != tr(LocaleKeys.select_date)
                              ? kPrimaryColor
                              : Color(0xFFff2800),
                          fontSize: size.width * 0.04,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            myDate != tr(LocaleKeys.select_date)
                ? RoundedButton(
                    color: Color(0xFFff2800),
                    text: tr(LocaleKeys.book_appointment),
                    press: () async {
                      // Navigator.pop(context);
                      await DatabaseService().updateRequestData(
                        property: widget.property,
                        compound: widget.compound,
                        date: widget.dateSearch,
                        user: widget.user,
                      );
                      await NDialog(
                        dialogStyle: DialogStyle(
                          backgroundColor: kPrimaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        content: Container(
                          height: size.height * 0.45,
                          width: size.width * 0.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                'assets/animations/check.json',
                                width: size.width * 0.4,
                                height: size.height * 0.2,
                                repeat: false,
                              ),
                              // SizedBox(
                              //   height: size.height * 0.05,
                              // ),
                              Text(
                                tr(LocaleKeys.booking_confirmed),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Text(
                                tr(LocaleKeys.will_contact_soon),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.04,
                              ),
                              RawMaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Container(
                                    height: height * 0.06,
                                    width: width * 0.3,
                                    color: kPrimaryLightColor,
                                    child: Center(
                                      child: Text(
                                        tr(LocaleKeys.close),
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: width * 0.05,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).show(context);

                      Navigator.pop(context);
                    },
                  )
                : Container(),
            SizedBox(
              height: height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
