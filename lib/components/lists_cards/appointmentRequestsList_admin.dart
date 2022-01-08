import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/lists_cards/appointmentCard.dart';
import 'package:unit/models/request.dart';
import 'package:sliding_card/sliding_card.dart';

import '../../sizeConfig.dart';

class AppointmentRequestsListAdmin extends StatefulWidget {
  @override
  _AppointmentRequestsListAdminState createState() =>
      _AppointmentRequestsListAdminState();
}

class _AppointmentRequestsListAdminState
    extends State<AppointmentRequestsListAdmin> {
   SlidingCardController controller;
  @override
  void initState() {
    super.initState();
    controller = SlidingCardController();
  }

  @override
  Widget build(BuildContext context) {
    List<Request> requests = Provider.of<List<Request>>(context) ?? [];
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    requests.sort((a, b) {
      var aTitle = b.dateTime; //before -> var adate = a.expiry;
      var bTitle = a.dateTime; //before -> var bdate = b.expiry;
      return aTitle.compareTo(
          bTitle); //to get the order other way just switch `adate & bdate`
    });
    return Column(
      children: [
        Text(
          'Number of requests: ${requests.where((element) => element.status != 'confirmed').length}',
          style: TextStyle(
            fontSize: size.width * 0.04,
          ),
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              return AppointmentCard(
                request: requests[index],
              );
            },
          ),
        ),
      ],
    );
  }
}
