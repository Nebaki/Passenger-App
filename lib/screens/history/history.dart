import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import '../../utils/session.dart';
import '../../utils/waver.dart';

class HistoryPage extends StatefulWidget {
  static const routeName = "/history";

  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _appBar = GlobalKey<FormState>();

  int _skip = 0;
  int _top = 15;
  final List<RideRequest?> _history = [];
  late ScrollController _scrollController;
  bool _loadMore = true;
  bool _isFirst = true;

  @override
  void initState() {
    BlocProvider.of<TripHistoryBloc>(context)
        .add(const TripHistoryLoad(skip: 0, top: 15));
    _scrollController = ScrollController()..addListener(_loadMoreHistories);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMoreHistories);
    super.dispose();
  }

  void _loadMoreHistories() {
    debugPrint(_scrollController.position.extentAfter.toString());
    if (_scrollController.position.extentAfter < 300 && _loadMore) {
      _loadMore = false;
      _skip = _top;
      _top += 15;

      BlocProvider.of<TripHistoryBloc>(context)
          .add(TripHistoryLoad(skip: _skip, top: _top));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SafeAppBar(
            key: _appBar, title: getTranslation(context, "history_detail_title"),
            appBar: AppBar(), widgets: []),
        body: Stack(
      children: [
        BlocConsumer<TripHistoryBloc, TripHistoryState>(
          listener: (context, state) {
            if (state is TripHstoriesLoadSuccess) {
              _isFirst = false;
              _loadMore = true;
              setState(() {
                state.requestes.isNotEmpty
                    ? _history.addAll(state.requestes)
                    : _loadMore = false;
              });
            }
            if (_history.isNotEmpty) {
              if (state is TripHistoryOperationFailure) {
                setState(() {
                  _loadMore = false;
                });
              }
            }
          },
          builder: (context, state) {
            if (state is TripHistoryOperationFailure) {
              return Center(
                child: Text(
                  getTranslation(context, "history_error_text"),
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              );
            }
            return !_isFirst
                ? Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _history.length,
                        itemBuilder: (context, index) {
                          return _history.isNotEmpty
                              ? _buildListItems(context,_history[index]!,Theme.of(context).primaryColor)
                              : Container();
                        },
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      ),
                    ),
                  )
                : //_buildShimmerEffect()
            const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 40),
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
        !_isFirst
            ? BlocBuilder<TripHistoryBloc, TripHistoryState>(
                builder: (context, state) {
                  if (state is TripHistoriesLoading) {
                    return const Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 40),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state is TripHistoryOperationFailure) {
                    return const Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 40),
                        child: Text("Unable to load History."),
                      ),
                    );
                  }
                  return Container();
                },
              )
            : Container(),
      ],
    ));
  }

  Widget _builHistoryCard(
      BuildContext context, String status, RideRequest? request) {
    String st = status.substring(0, 1);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, DetailHistoryScreen.routeName,
              arguments: DetailHistoryArgument(request: request!));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).backgroundColor,
              boxShadow: [
                BoxShadow(
                    blurStyle: BlurStyle.normal,
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    spreadRadius: 2)
              ]),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          color: status == "Completed"
                              ? Colors.green
                              : status == "Cancelled"
                                  ? Colors.red
                                  : status == "Accepted"
                                      ? Colors.indigo.shade900
                                      : status == "Searching"
                                          ? Colors.indigo
                                          : Colors.grey,
                          child: Text(st,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))),
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          request!.droppOffAddress!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          request.pickUpAddress!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  )
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        request.date!,
                        // style: const TextStyle(color: Colors.black38),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        request.time!,
                        // style: const TextStyle(color: Colors.black38),
                      ),
                      Text(status),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  Text(
                    "${request.price != 'null' ? double.parse(request.price!).truncate() : 0} ${getTranslation(context,"etb")}",
                    // style: const TextStyle(color: Colors.black),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: ListView(
        children: List.generate(
            10,
            (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Shimmer(
                    gradient: shimmerGradient,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black, width: 1)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 10,
                                    width: 80,
                                    decoration: const BoxDecoration(
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 10,
                                    width: 60,
                                    decoration: const BoxDecoration(
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                          const Divider(),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 10,
                                    width: 60,
                                    decoration: const BoxDecoration(
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: 10,
                                    width: 60,
                                    decoration: const BoxDecoration(
                                        color: Colors.black),
                                  ),
                                  Container(
                                    height: 10,
                                    width: 60,
                                    decoration: const BoxDecoration(
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              Container(
                                height: 10,
                                width: 60,
                                decoration:
                                    const BoxDecoration(color: Colors.black),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )),
      ),
    );
  }

  Widget _buildListItems(BuildContext context, RideRequest trip, theme) {
    if (trip.picture == null) {
      getImageBit(trip);
    } else {
      print("unit8: db-${trip.picture}");
      //trip.picture = trip.picture!.substring(0, trip.picture!.length - 3);
    }

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, TripDetail.routeName,
            arguments: DetailHistoryArgument(request: trip));
      },
      child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                trip.picture != null ? Image.memory(trip.picture!) : Container(),
                _listUi(theme, trip),
              ],
            ),
          )),
    );
  }

  _listUi(Color theme, RideRequest trip) {
    Session().logSession("tripData", trip.toString());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 3.0,top: 10,bottom: 10),
              child: Text(trip.status ?? "loading",
                style: TextStyle(color: trip.status != "Completed"
                    ? Colors.red : Colors.green),
              ),
            ),
            trip.status != "Cancelled" ? Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(trip.price!.split(",")[0] + " ETB"),
            ):Container()
          ],
        ),

        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text("Date:", style: TextStyle(
              color: theme//,fontWeight: FontWeight.bold
          ),),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(trip.date!),
          //child: Text(_formatedDate(trip.date!)),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text("Origin", style: TextStyle(color: theme)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(trip.pickUpAddress ?? "loading..."),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            "Destination",
            style: TextStyle(color: theme),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(trip.droppOffAddress ?? "loading..."),
        ),
      ],
    );
  }
  String _formatedDate(String utcDate){
    var str = "2019-04-05T14:00:51.000Z";
    if(utcDate != "null"){
      Session().logSession("date", utcDate);
      //var newStr = utcDate.substring(0,10) + ' ' + utcDate.substring(11,23);
      DateTime dt = DateTime.parse(utcDate);
      var date = DateFormat("EEE, d MMM yyyy HH:mm:ss").format(dt);
      return date;
    }else{
      return "Unavailable";
    }
  }
  void getImageBit(RideRequest trip) async {
    //downloadImage(trip);
    await ImageUtils.networkImageToBase64(imageUrl(trip)).then((value) => {
      //ImageUtils().saveImage(ImageUtils.base64ToUnit8list(value), "id-${trip.id}"),
      trip.picture = ImageUtils.base64ToUnit8list(value),
      print("unit8: net- ${imageUrl(trip)}"),
      //updateDB(trip)
    });
  }
  String imageUrl(RideRequest trip) {
    String googleAPiKey = "AIzaSyB8z8UeyROt2-ay24jiHrrcMXaEAlPUvdQ";
    return "https://maps.googleapis.com/maps/api/staticmap?"
        "size=600x250&"
        "zoom=15&"
        "maptype=roadmap&"
        "markers=color:green%7Clabel:S%7C${trip.pickupLocation?.latitude},${trip.pickupLocation?.longitude}&"
        "markers=color:red%7Clabel:E%7C${trip.dropOffLocation?.latitude},${trip.dropOffLocation?.longitude}&"
        "key=$googleAPiKey" /*"signature=YOUR_SIGNATURE"*/;
  }
}

class ImageUtils {
  static MemoryImage base64ToImage(String base64String) {
    return MemoryImage(
      base64Decode(base64String),
    );
  }

  static Uint8List base64ToUnit8list(String base64String) {
    return base64.decode(base64String);
    //return base64Decode(base64String);
  }

  static String fileToBase64(File imgFile) {
    return base64Encode(imgFile.readAsBytesSync());
  }

  static Future networkImageToBase64(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    return base64.encode(response.bodyBytes);
  }

  Future assetImageToBase64(String path) async {
    ByteData bytes = await rootBundle.load(path);
    return base64.encode(Uint8List.view(bytes.buffer));
  }

  Future<void> saveImage(Uint8List uint8list, String name) async {
    listDirs();
    final tempDir = await getExternalStorageDirectory();
    print("imgp: ${tempDir?.path}");
    Directory('${tempDir?.path}/historyIMG/').exists().then((value) => {
      if (value)
        {print("img: dir exist"), writeImage(tempDir!, uint8list, name)}
      else
        {print("img: dir not exist"), createDir(tempDir!, uint8list, name)}
    });
  }

  Future<File> getImage(String filename) async {
    final dir = await getExternalStorageDirectory();
    File f = File('${dir?.path}/historyIMG/$filename.png');
    f.exists().then((value) => {if (value) {} else {}});
    return f;
  }

  Future<void> writeImage(
      Directory directory, Uint8List uint8list, String filename) async {
    print("img-w: ${directory.path}");
    File file = await File('${directory.path}/historyIMG/$filename.png')
        .create(recursive: true);
    file.writeAsBytesSync(uint8list);
    await file.exists().then((value) => {print("img-w: $value")});
  }

  Future<void> createDir(
      Directory directory, Uint8List uint8list, String name) async {
    await Directory('${directory.path}/historyIMG/')
        .create(recursive: true)
        .then((value) => {
      print("img-c: ${value.path} created"),
      writeImage(directory, uint8list, name)
    });
  }

  void listDirs() {
    var systemTempDir = getExternalStorageDirectory();
    systemTempDir.then((value) => {
      value?.list(recursive: true, followLinks: false).listen((event) {
        print("img-d: ${value.path}");
      })
    });
  }
}
