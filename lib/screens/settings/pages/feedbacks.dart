import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/send_feedback.dart';

import '../../../utils/waver.dart';

class FeedbackScreen extends StatefulWidget {
  static const routeName = "/feedback";

  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _appBar = GlobalKey<FormState>();

  var _isLoading = false;
  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }
  TextEditingController feedBackController = TextEditingController();
  String _chosenValue = "Thank You";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SafeAppBar(
          key: _appBar, title: "Contact us",
          appBar: AppBar(), widgets: []),
      body: Container(
          padding: const EdgeInsets.all(3),
          child: Card(
              margin: const EdgeInsets.all(4.0),
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(50),
                    children: [
                      Center(
                          child: Image.asset('assets/icons/logo.png',
                            height: 200.0,width:200.0,color: Theme.of(context).primaryColor,)
                      ),
                      const Text("Choose Tile",style: TextStyle(
                        fontSize: 18,fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),),
                      _dropDownItem(),
                      Container(
                        child: _feedBackBox(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              onPressed: () {
                                final FormState? form = _formKey.currentState;
                                if (form!.validate() && !_isLoading) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  prepareRequest(
                                      context,
                                      _chosenValue,feedBackController.text);
                                } else {
                                  if(!form.validate()){
                                    showMessage(context, 'Form is invalid');
                                  }else if(_isLoading){
                                    showMessage(context, 'Please wait...');
                                  }
                                }
                              },
                              child: Row(
                                children: [
                                  const Spacer(),
                                  const Text("Send Feedback"),
                                  const Spacer(),
                                  Align(
                                    alignment: Alignment.center,
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white
                                            ),
                                          )
                                        : Container(),
                                  )
                                ],
                              ),
                            ),
                        ),
                      )
                    ],
                  )))),
    );
  }

  final _formKey = GlobalKey<FormState>();

  void prepareRequest(BuildContext context, String title, String description) {
    var sender = SendFeedback(httpClient: http.Client());
    var res = sender.sendFeedback(title,description);
    res.then((value) => {
          setState(() {
            _isLoading = false;
          }),
          showMessage(context, value.message)
        });
  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _feedBackBox() {
    return TextFormField(
      maxLines: 8,
      minLines: 4,
      controller: feedBackController,
      decoration: const InputDecoration(
          //contentPadding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0),
          alignLabelWithHint: true,
          hintText: "Write your feedback",
          hintStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(borderSide: BorderSide(width: 1))),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please write your feedback';
        }
        return null;
      },
    );
  }
  var items = <String>['Driver Attitude', 'Item Lost', 'App Issue',
    'Complaint', 'Thank You', 'Advice', 'Other'];
  Widget _dropDownItem() {
    return DropdownButton<String>(
      dropdownColor: Colors.white,
      focusColor: Colors.white,
      value: _chosenValue,
      //elevation: 5,
      style: const TextStyle(color: Colors.white),
      iconEnabledColor: Colors.black,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      hint: const Text(
        "Please choose a type",
        style: TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
      ),
      onChanged: (String? value) {
        setState(() {
          _chosenValue = value!;
        });
      },
    );
  }
}
