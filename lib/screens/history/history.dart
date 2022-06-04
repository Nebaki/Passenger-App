import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passengerapp/bloc/bloc.dart';
import 'package:passengerapp/models/models.dart';
import 'package:passengerapp/rout.dart';
import 'package:passengerapp/screens/screens.dart';
import 'package:passengerapp/widgets/widgets.dart';

class HistoryPage extends StatefulWidget {
  static const routeName = "/history";

  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // final _textStyle = TextStyle(fontSize: 20);
  int _skip = 0;
  int _top = 15;
  final List<RideRequest?> _history = [];
  late ScrollController _scrollController;
  bool _loadMore = true;
  bool _isFirst = true;

  @override
  void initState() {
    BlocProvider.of<TripHistoryBloc>(context)
        .add(TripHistoryLoad(skip: 0, top: 15));
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
      _skip = _top + 1;
      _top += 15;
      print(
          "Hereeeeeeeeeeeeeeeeee Called ::::::::::::::::::::::::::::::::::::::::::::::: skip$_skip,Top:$_top");
      BlocProvider.of<TripHistoryBloc>(context)
          .add(TripHistoryLoad(skip: _skip, top: _top));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          builder: (context, state) => !_isFirst
              ? Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        return _history.isNotEmpty
                            ? _builHistoryCard(context,
                                _history[index]!.status!, _history[index])
                            : Container();
                      },
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    ),
                  ),
                )
              : const Center(
                  child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      )),
                ),
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
                        child: Text("You have riched the limit."),
                      ),
                    );
                  }
                  return Container();
                },
              )
            : Container(),
        CustomeBackArrow(),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                "History",
                style: Theme.of(context).textTheme.titleLarge,
              )),
        )
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
                  ClipRRect(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        request!.droppOffAddress!,
                      ),
                      Text(
                        request.pickUpAddress!,
                      )
                    ],
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
                    "${request.price != 'null' ? double.parse(request.price!).truncate() : 0} ETB",
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
}
