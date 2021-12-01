import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/screens/login.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key, required this.formKey}) : super(key: key);
  final GlobalKey<FormState> formKey;

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  final _passconfigFocus = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _passWordConfirmCOntroller =
      TextEditingController();

  final auth = FirebaseAuth.instance;

  String? _userEmail;
  String? _userPass;
  String? _confirmPass;

  bool ifMatched = false;

  bool _isEmailValid(String email) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return regex.hasMatch(email);
  }

  bool _isPAsswordValid(String pass) {
    return pass.length >= 6;
  }

  bool _isPAsswordMatch(String pass, String confPass) {
    return pass == confPass;
  }

  Widget _textField(
    String title, {
    FocusNode? focusNode,
    TextEditingController? textEditingController,
    void Function(String)? onChaged,
    void Function(String)? onFieldSub,
    void Function()? ontap,
    TextInputType? textInputType,
    TextInputAction? textInputAction,
    bool? passWordForm,
    String? hintText,
    IconData? prefixIcon,
    String? Function(String?)? validate,
  }) {
    return Container(
      margin: const EdgeInsets.all(10),
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
            focusNode: focusNode,
            controller: textEditingController,
            onChanged: onChaged,
            textInputAction: textInputAction,
            keyboardType: textInputType,
            obscureText: passWordForm!,
            onFieldSubmitted: onFieldSub,
            onTap: ontap,
            validator: validate,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.black),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(prefixIcon),
            ),
          ),
        ],
      ),
    );
  }

  Widget _signUpBtn(void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        color: Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: const Text(
          'Sign Up',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }

  Widget _signUpForms() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _textField(
          'Email:',
          hintText: 'Please enter your email',
          focusNode: _emailFocus,
          textEditingController: _emailController,
          passWordForm: false,
          onFieldSub: (_) {
            FocusScope.of(context).requestFocus(_emailFocus);
          },
          onChaged: (value) {
            _userEmail = value;
          },
          prefixIcon: Icons.email_rounded,
          textInputType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validate: (email) {
            if (email!.isEmpty) {
              return 'Email required';
            }

            if (!_isEmailValid(email)) {
              return 'Email invalid';
            }

            return null;
          },
        ),
        const SizedBox(
          height: 5,
        ),
        _textField('Password:',
            hintText: 'Please enter your password',
            focusNode: _passFocus,
            textEditingController: _passWordController,
            textInputType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            passWordForm: true,
            onFieldSub: (_) {
              FocusScope.of(context).requestFocus(_passFocus);
            },
            onChaged: (value) {
              _userPass = value;
            },
            ontap: () {
              _passWordController.clear();
              _passWordConfirmCOntroller.clear();
            },
            prefixIcon: Icons.vpn_key_rounded,
            validate: (pass) {
              if (pass == null) return null;
              if (!_isPAsswordValid(pass)) {
                return 'Password too short';
              }
            }),
        const SizedBox(
          height: 5,
        ),
        _textField(
          'Confirm Password:',
          hintText: 'Confirm your password',
          focusNode: _passconfigFocus,
          textEditingController: _passWordConfirmCOntroller,
          textInputType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          passWordForm: true,
          onFieldSub: (_) {
            FocusScope.of(context).requestFocus(_passconfigFocus);
          },
          onChaged: (value) {
            _confirmPass = value;
          },
          prefixIcon: Icons.vpn_key_rounded,
          validate: (confPass) {
            if (confPass == null) return null;

            if (!_isPAsswordMatch(_passWordController.text, confPass)) {
              return 'Passwords don\'t match';
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          _signUpForms(),
          const SizedBox(
            height: 15,
          ),
          _signUpBtn(() async {
            if (widget.formKey.currentState!.validate()) {
              try {
                await auth.createUserWithEmailAndPassword(
                    email: _userEmail!, password: _userPass!);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Sucessfully registered User and Email!!"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.zero)),
                    duration: Duration(seconds: 5),
                  ),
                );
                Navigator.of(context).pop(context);
              } on FirebaseAuthException catch (e) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Registration failed'),
                    content: Text('${e.message}'),
                  ),
                );
              }
            }
          })
        ],
      ),
    );
  }
}
