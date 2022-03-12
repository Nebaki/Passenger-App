import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  static const routeName = "/feedback";
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _textStyle = const TextStyle(
      height: 2.0, color: Colors.black, fontWeight: FontWeight.bold);

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
                  key: _formkey,
                  child: ListView(
                    padding: const EdgeInsets.all(50),
                    children: [
                      const Text("Choose Tile"),
                      DropdownButton<String>(
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
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _chosenValue = value!;
                          });
                        },
                      ),
                      Container(

                        child: TextFormField(
                          maxLines: 8,minLines: 4,
                          controller: feedBackController,
                          decoration: const InputDecoration(
                              //contentPadding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0),
                              alignLabelWithHint: true,
                              hintText: "Write your feedback",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1))),
                          validator: (value){
                            if (value!.isEmpty) {
                              return 'Please write your feedback';
                            }
                            return null;
                          },
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            final FormState? form = _formkey.currentState;
                            if (form!.validate()) {
                              showMessage(context, _chosenValue+": "+feedBackController.text);
                            } else {
                              showMessage(context, 'Form is invalid');
                            }
                          },
                          child: const Text("Send Feedback"),
                        ),
                      )
                    ],
                  )
              )
          )
      ),
    );
  }

  final _formkey = GlobalKey<FormState>();

  void showMessage(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
        message
    )));
  }
}
