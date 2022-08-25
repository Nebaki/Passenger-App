import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:passengerapp/cubit/favorite_location.dart';
import 'package:passengerapp/cubit/favorite_location_state.dart';
import 'package:passengerapp/helper/constants.dart';
import 'package:passengerapp/helper/localization.dart';
import 'package:passengerapp/rout.dart';
import '../../bloc/bloc.dart';
import '../../models/models.dart';
import '../../utils/waver.dart';

class AddAddressScreen extends StatefulWidget {
  static const routeName = 'addaddress';
  final AddAdressScreenArgument args;

  const AddAddressScreen({required this.args, Key? key}) : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  String? placeId;
  String? name;
  String? address;
  PickResult? selectedPlace;
  bool _isLoading = false;
  final locationController = TextEditingController();
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  @override
  void initState() {
    widget.args.edit ? placeId = widget.args.savedLocation!.placeId : null;
    widget.args.edit ? address = widget.args.savedLocation!.address : null;
    widget.args.edit
        ? locationController.text = widget.args.savedLocation!.address
        : null;

    super.initState();
  }
  final _appBar = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // _isLoading = false;

    return Scaffold(
        appBar: SafeAppBar(
            key: _appBar, title: "Add Address",
            appBar: AppBar(), widgets: []),
        body: BlocConsumer<FavoriteLocationCubit, FavoriteLocationState>(
            builder: (context, state) => _buildScreen(),
            listener: (context, state) {
              if (state is FavoriteLocationLoadSuccess) {
                _isLoading = false;

                Navigator.pop(context);
              }
              if (state is FavoriteLocationOperationSuccess) {
                _isLoading = false;

                context.read<FavoriteLocationCubit>().getFavoriteLocations();
              }
              if (state is FavoriteLocationOperationFailure) {
                _isLoading = false;

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red.shade900,
                    content:
                        Text(getTranslation(context, "operation_failure"))));
              }
            }));
  }

  void findPlace(String placeName) {
    if (placeName.length>=2) {
      LocationPredictionEvent event =
          LocationPredictionLoad(placeName: placeName);
      BlocProvider.of<LocationPredictionBloc>(context).add(event);
    }
  }

  void getPlaceDetail(String placeId) {
    PlaceDetailEvent event = PlaceDetailLoad(placeId: placeId);
    BlocProvider.of<PlaceDetailBloc>(context).add(event);
  }

  Widget _buildScreen() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 30, right: 30),
          child: ListView(
            children: [
              Form(
                key: _formState,
                child: TextFormField(
                  initialValue:
                      widget.args.edit ? widget.args.savedLocation!.name : null,
                  decoration: InputDecoration(
                    label: Text(getTranslation(context, "name")),
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                    fillColor: Colors.white,
                    // filled: true,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(style: BorderStyle.solid)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return getTranslation(context, "please_enter_name");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    name = value;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (value) {
                  findPlace(value);
                },
                controller: locationController,
                decoration: InputDecoration(
                  label: Text(getTranslation(context, "search_location")),
                  suffixIcon: IconButton(
                      onPressed: () {
                        locationController.clear();
                      },
                      icon: const Icon(
                        Icons.clear,
                        size: 15,
                      )),
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.solid)),
                ),
                validator: (value) {
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PlacePicker(
                          apiKey: apiKey,
                          initialPosition: initialPosition,
                          useCurrentLocation: true,
                          selectInitialPosition: true,
                          onPlacePicked: (result) {
                            placeId = result.placeId;
                            address = result.formattedAddress;
                            selectedPlace = result;
                            locationController.text = result.formattedAddress!;
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                        );
                      },
                    ),
                  );
                },
                dense: true,
                horizontalTitleGap: 0,
                leading: const Icon(
                  Icons.location_on,
                ),
                title: Text(getTranslation(context, "pick_location_from_map")),
              ),
              const Divider(),
              BlocBuilder<LocationPredictionBloc, LocationPredictionState>(
                  builder: (context, state) {
                if (state is LocationPredictionLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is LocationPredictionLoadSuccess) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      constraints:
                          const BoxConstraints(maxHeight: 400, minHeight: 30),
                      width: double.infinity,
                      child: ListView.separated(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (cont, index) {
                            return _buildPredictedItem(
                                state.placeList[index], context);
                          },
                          separatorBuilder: (context, index) => const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(color: Colors.black38),
                              ),
                          itemCount: state.placeList.length),
                    ),
                  );
                }

                if (state is LocationPredictionOperationFailure) {}

                return const Center(
                  child: Text("Enter The location"),
                );
              }),
              BlocConsumer<PlaceDetailBloc, PlaceDetailState>(
                listener: (_, state) {
                  if (state is PlaceDetailLoadSuccess) {
                    setState(() {
                      placeId = state.placeDetail.placeId;
                      address = state.placeDetail.placeName;
                    });
                  }
                },
                builder: (_, state) {
                  return Container();
                },
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: placeId != null
                      ? () {
                          final form = _formState.currentState;
                          if (form!.validate()) {
                            form.save();
                            _isLoading = true;

                            widget.args.edit
                                ? context
                                    .read<FavoriteLocationCubit>()
                                    .updateFavoriteLocation(SavedLocation(
                                        id: widget.args.savedLocation!.id,
                                        name: name!,
                                        address: address!,
                                        placeId: placeId!))
                                : context
                                    .read<FavoriteLocationCubit>()
                                    .addToFavoriteLocation(SavedLocation(
                                        name: name!,
                                        address: address!,
                                        placeId: placeId!));
                          }
                        }
                      : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Text(
                        getTranslation(context, "save"),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Container(),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        //const CustomeBackArrow(),
      ],
    );
  }

  Widget _buildPredictedItem(LocationPrediction prediction, con) {
    return GestureDetector(
      onTap: () {
        locationController.text = prediction.mainText;
        getPlaceDetail(prediction.placeId);
      },
      child: Container(
        color: Colors.black.withOpacity(0),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            const Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Icon(
                Icons.arrow_forward_ios,
                // color: Colors.black,
                size: 12,
              ),
            ),
          
            Flexible(
                fit: FlexFit.tight, flex: 5, child: Text(prediction.mainText)),
          ],
        ),
      ),
    );
  }
}
