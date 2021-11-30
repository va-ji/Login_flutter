import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../screens/screens.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  double getFormWidth(context) {
    if (MediaQuery.of(context).size.width > 1200) {
      return MediaQuery.of(context).size.width / 4;
    }
    if (MediaQuery.of(context).size.width > 786) {
      return MediaQuery.of(context).size.width / 3;
    }
    if (MediaQuery.of(context).size.width > 600) {
      return MediaQuery.of(context).size.width / 2;
    }
    return MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          ),
        ),
      ),
      body: Container(
        height: height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.purpleAccent,
              offset: Offset(2, 4),
              blurRadius: 2.2,
              spreadRadius: 1.2,
            )
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purpleAccent,
              Colors.blueAccent,
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: getFormWidth(context),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 60.0, bottom: 40),
                      child: Text(
                        'Sign Up ',
                        style: TextStyle(fontSize: 60, color: Colors.white),
                      ),
                    ),
                    SignUpWidget(
                      formKey: _key,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
