import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/utils/session.dart';

import '../../utils/waver.dart';
import '../theme/theme_provider.dart';
import 'package:provider/provider.dart';

class DetailHistoryScreen extends StatelessWidget {
  static const routeName = "/detailhistory";
  final DetailHistoryArgument args;

  const DetailHistoryScreen({Key? key, required this.args}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(getTranslation(context, "history_title")),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {},
              child: const Text(
                "Help",
                style: TextStyle(color: Colors.orange),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                color: Theme.of(context).backgroundColor,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.blue,
                        ),
                        Flexible(
                          child: Text(
                            args.request.pickUpAddress!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            color: Colors.green),
                        Flexible(
                            child: Text(
                          args.request.droppOffAddress!,
                          overflow: TextOverflow.ellipsis,
                        ))
                      ],
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          '${double.parse(args.request.price!).toStringAsFixed(2)} ${getTranslation(context,"etb")}',
                          style: const TextStyle(
                              color: Colors.green, fontSize: 26),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                          args.request.status == "Completed"
                              ? getTranslation(context, "payment_made")
                              : getTranslation(context, "not_paid_yet"),
                          style: Theme.of(context).textTheme.overline),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text("${args.request.duration} min"),
                            Text(
                              getTranslation(context, "duration"),
                              style: Theme.of(context).textTheme.overline,
                            )
                          ],
                        ),
                        const VerticalDivider(),
                        Column(
                          children: [
                            Text('${args.request.distance} Km'),
                            Text(getTranslation(context, "distance"),
                                style: Theme.of(context).textTheme.overline)
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(getTranslation(
                            context, "history_detail_date_and_time")),
                        Text('${args.request.date!} at ${args.request.time!}')
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(getTranslation(context, "history_detail_status")),
                        Text('${args.request.status}')
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(getTranslation(context, "distance")),
                        Text('${args.request.distance} Km')
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10, bottom: 0),
              child: Text(getTranslation(
                  context, "history_detail_date_driver_and_vehicle")),
            ),
            args.request.status != 'Cancelled' &&
                    args.request.status != 'Pending' &&
                    args.request.status != 'Time Out'
                ? Card(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                      color: Theme.of(context).backgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildReciept(
                              title: getTranslation(
                                  context, "history_detail_driver"),
                              value: args.request.driver!.firstName),
                          const SizedBox(
                            height: 15,
                          ),
                          _buildReciept(
                              title: getTranslation(
                                  context, "history_detail_driver_phone"),
                              value: args.request.driver!.phoneNumber),
                          const SizedBox(
                            height: 15,
                          ),
                          _buildReciept(
                              title: getTranslation(
                                  context, "history_detail_vehicle"),
                              value: args.request.driver!.vehicle!['model']),
                          const SizedBox(
                            height: 15,
                          ),
                          _buildReciept(
                              title: getTranslation(
                                  context, "history_detail_color"),
                              value: args.request.driver!.vehicle!['color']),
                          const SizedBox(
                            height: 15,
                          ),
                          _buildReciept(
                              title: getTranslation(
                                  context, "history_detail_plate_number"),
                              value: args
                                  .request.driver!.vehicle!['plate_number']),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                getTranslation(
                                    context, "history_detail_your_payment"),
                                style: _greenTextStyle,
                              ),
                              Text(
                                  "${double.parse(args.request.price!).toStringAsFixed(2)} ${getTranslation(context,"etb")}",
                                  style: _greenTextStyle)
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // const Text(
                          //   "This trip was towards your destination you recieved Guaranted fare",
                          //   style: TextStyle(
                          //       fontSize: 9,
                          //       color: Colors.black26,
                          //       fontWeight: FontWeight.bold),
                          //   textAlign: TextAlign.start,
                          // )
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                    child: Text(getTranslation(
                        context, "history_detail_not_accepted_yet")),
                  )
          ],
        ),
      ),
    );
  }

  final _greenTextStyle = const TextStyle(
    color: Colors.green,
    fontWeight: FontWeight.bold,
  );

  Widget _buildReciept({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
        ),
        Text(
          value,
        )
      ],
    );
  }
}

class TripDetail extends StatefulWidget {
  static const routeName = "/history_detail";
  DetailHistoryArgument args;
  TripDetail({Key? key, required this.args}) : super(key: key);
  @override
  State<TripDetail> createState() => _TripDetailState(args);
}
class _TripDetailState extends State<TripDetail>{
  DetailHistoryArgument args;
  final _appBar = GlobalKey<FormState>();

  _TripDetailState(this.args);
  @override
  void initState() {
    super.initState();
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  }
  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SafeAppBar(
          key: _appBar, title: getTranslation(context, "history_title"), appBar: AppBar(), widgets: []),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 250,
                color: themeProvider.getColor,
              ),
            ),
          ),
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 160,
              color: themeProvider.getColor,
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 150,
                color: themeProvider.getColor,
                child: ClipPath(
                  clipper: WaveClipperBottom(),
                  child: Container(
                    height: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Card(elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        args.request.picture != null ? Image.memory(args.request.picture!) : Container(),
                        _listUi(Theme.of(context).primaryColor,args.request),
                      ],
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
  _listUi(Color theme,RideRequest trip){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text("Status:", style: TextStyle(
                        color: theme
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(trip.status ?? "loading"),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /*Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text("Estimated fee: ${trip.price!.split(",")[0]+" ETB"}"),
                  ),*/
                  trip.status != "Cancelled" ? Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text("Net fee: ${trip.price!.split(",")[0]+" ETB"}"),
                  ): Container(),
                ],
              )
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text("Origin:", style: TextStyle(
                color: theme
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(trip.pickUpAddress ?? "Loading"),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text("Destination:", style: TextStyle(
                color: theme
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(trip.droppOffAddress ?? "Loading"),
          ),

          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text("Distance:", style: TextStyle(
                color: theme//,fontWeight: FontWeight.bold
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${trip.distance} KM"),
          ),

          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text("Date:", style: TextStyle(
                color: theme//,fontWeight: FontWeight.bold
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_formatedDate(trip.date!)),
          ),
          /*Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text("Trip Ended Time:", style: TextStyle(
                color: theme//,fontWeight: FontWeight.bold
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_formatedDate(trip.date!)),
          ),
          */
        ],
      ),
    );
  }
  String _formatedDate(String utcDate){
    var str = "2019-04-05T14:00:51.000Z";
    if(utcDate != "null"){
      Session().logSession("date", utcDate);
      //var newStr = utcDate.substring(0,10) + ' ' + utcDate.substring(11,23);
      DateTime dt = DateTime.parse(str);
      var date = DateFormat("EEE, d MMM yyyy HH:mm:ss").format(dt);
      return date;
    }else{
      return "Unavailable";
    }
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
