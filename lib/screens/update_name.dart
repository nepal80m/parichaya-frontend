import 'package:flutter/material.dart';
import 'package:parichaya_frontend/screens/buttom_navigation_base.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../utils/name_provider.dart';

class UpdateName extends StatefulWidget {
  const UpdateName({Key? key}) : super(key: key);

  @override
  _UpdateNameState createState() => _UpdateNameState();
}

class _UpdateNameState extends State<UpdateName> {
  //editing controller
  final nameController = TextEditingController();
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    // name field
    isSwitched =
        Provider.of<ThemeProvider>(context, listen: false).isDarkModeOn;
    final nameField = TextFormField(
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.name,
      maxLength: 30,
      onSaved: (value) {
        nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Enter your name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

//update Button

    final updateButton = Material(
      borderRadius: BorderRadius.circular(10),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        onPressed: () async {
          if (nameController.text.isNotEmpty) {
            NameProvider.instance
                .setStringValue('nameKey', nameController.text);
            Navigator.of(context).pushNamedAndRemoveUntil(
                ButtomNavigationBase.routeName, (route) => false);
          } else {
            final snackBar = SnackBar(
                backgroundColor: Theme.of(context).errorColor,
                content: const Text('Please enter a name.'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: const Text(
          "Proceed",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
      ),
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color:
                  !isSwitched ? Theme.of(context).primaryColor : Colors.white,
            ),
            onPressed: () {
              //passing this to our root
              Navigator.of(context)
                  .popAndPushNamed(ButtomNavigationBase.routeName);
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          Text(
                            'Update your name',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: !isSwitched
                                  ? Theme.of(context).primaryColor
                                  : const Color.fromARGB(255, 189, 187, 187),
                            ),
                          ),
                          const Text(
                            'Type in your Name',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 45),
                    nameField,
                    const SizedBox(height: 20),
                    updateButton,
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
