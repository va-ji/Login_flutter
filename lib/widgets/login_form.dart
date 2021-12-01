import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_page/screens/sign_up.dart';

import '../screens/screens.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
    required this.formKey,
  }) : super(key: key);
  final GlobalKey<FormState> formKey;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool isPasswordText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _userEmail;
  String? _userPassword;

  Widget _textField(
    String title, {
    String? hintText,
    bool? isPassWordForm,
    TextInputAction? textInputAction,
    TextInputType? keyBoardType,
    FocusNode? focusNode,
    void Function(String?)? onFieldSubmitted,
    void Function(String?)? onChanged,
    TextEditingController? controller,
    String? Function(String?)? validator,
    IconButton? prefixButton,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            onChanged: onChanged,
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyBoardType,
            onFieldSubmitted: onFieldSubmitted,
            validator: validator,
            obscureText: isPassWordForm! ? isPasswordText : false,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.black),
              border: InputBorder.none,
              fillColor: Colors.white,
              filled: true,
              prefixIcon: prefixButton,
              suffixIcon: isPassWordForm
                  ? IconButton(
                      icon: Icon(
                        isPasswordText
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordText = !isPasswordText;
                        });
                      },
                    )
                  : null,
            ),
          )
        ],
      ),
    );
  }

  Widget _userCredentials() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _textField(
          "Email:",
          hintText: 'Please enter your email',
          controller: _emailController,
          focusNode: _emailFocusNode,
          prefixButton: IconButton(
              onPressed: () {}, icon: const Icon(Icons.email_rounded)),
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_emailFocusNode);
          },
          textInputAction: TextInputAction.next,
          keyBoardType: TextInputType.emailAddress,
          onChanged: (value) {
            _userEmail = value;
          },
          isPassWordForm: false,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter Email';
            }
            return null;
          },
        ),
        _textField(
          'Password:',
          hintText: 'Please enter your password',
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          textInputAction: TextInputAction.done,
          keyBoardType: TextInputType.visiblePassword,
          prefixButton: IconButton(
              onPressed: () {}, icon: const Icon(Icons.vpn_key_rounded)),
          onChanged: (value) {
            _userPassword = value;
          },
          isPassWordForm: true,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter the password';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _loginButton(Function()? navigate) {
    return GestureDetector(
      onTap: navigate,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        color: Colors.green,
        child: _isLoading
            ? const CircularProgressIndicator.adaptive()
            : const Text(
                'Sign in',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
      ),
    );
  }

  Widget _signUpButton(Function()? signNav) {
    return GestureDetector(
      onTap: signNav,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        color: Colors.blue,
        child: _isLoading
            ? const CircularProgressIndicator.adaptive()
            : const Text(
                'Sign Up',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _userCredentials(),
          const Padding(padding: EdgeInsets.all(10)),
          _loginButton(() async {
            try {
              User user = (await auth.signInWithEmailAndPassword(
                      email: _userEmail!, password: _userPassword!))
                  .user!;
              if (user != null) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Welcome()));
              }
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                AlertDialog(
                  title: const Text('No user found for that email.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Back'),
                    )
                  ],
                );
              }
            }

            // Navigator.of(context).pushReplacement(
            //     MaterialPageRoute(builder: (context) => Welcome()));
          }),
          const Padding(padding: EdgeInsets.all(10)),
          _signUpButton(() {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SignUp()));
          })
        ],
      ),
    );
  }
}
