import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:passengerapp/dataprovider/send_feedback.dart';
import 'package:passengerapp/utils/service.dart';

class FeedbackScreen extends StatefulWidget {
  static const routeName = "/feedback";

  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _textStyle = const TextStyle(
      height: 2.0, color: Colors.black, fontWeight: FontWeight.bold);

  var _isLoading = false;
  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }
  TextEditingController feedBackController = TextEditingController();
  String _chosenValue = "Android";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: const Text(
          "Feedbacks",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          padding: const EdgeInsets.all(10),
          child: Card(
              margin: const EdgeInsets.all(4.0),
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(50),
                    children: [
                      Center(
                          child: Image.asset('assets/icons/familyCarIcon.png',
                            height: 100.0,width:100.0,)
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                  const Text("Send Feedback"),
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
          showMessage(context, value)
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

  Widget _dropDownItem() {
    return DropdownButton<String>(
      dropdownColor: Colors.white,
      focusColor: Colors.white,
      value: _chosenValue,
      //elevation: 5,
      style: const TextStyle(color: Colors.white),
      iconEnabledColor: Colors.black,
      items: <String>[
        'Android',
        'IOS',
        'Flutter',
        'Node',
        'Java',
        'Python',
        'PHP',
      ].map<DropdownMenuItem<String>>((String value) {
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
