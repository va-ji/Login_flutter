import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.formKey}) : super(key: key);
  final GlobalKey<FormState> formKey;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool isPasswordText = false;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late String? userEmail;
  late String? userPassword;

  Widget _textField(
    String title, {
    String? hintText,
    bool? isPassWordForm,
    TextInputAction? textInputAction,
    TextInputType? keyBoardType,
    FocusNode? focusNode,
    void Function(String?)? onFieldSubmitted,
    void Function(String?)? onSaved,
    TextEditingController? controller,
    String? Function(String?)? validator,
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
            onSaved: onSaved,
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyBoardType,
            onFieldSubmitted: onFieldSubmitted,
            validator: validator,
            obscureText: !isPasswordText ? true : false,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.black),
              border: InputBorder.none,
              fillColor: Colors.white,
              filled: true,
              suffixIcon: isPassWordForm!
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
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_emailFocusNode);
          },
          textInputAction: TextInputAction.next,
          keyBoardType: TextInputType.text,
          onSaved: (value) {
            userEmail = value;
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
          onSaved: (value) {
            userPassword = value;
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

  Widget _loginButton(void Function()? onPressed) {
    return GestureDetector(
      onTap: _isLoading ? onPressed : null,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        color: Colors.white,
        child: _isLoading
            ? const CircularProgressIndicator.adaptive()
            : const Text(
                'Login',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
      ),
    );
  }

  @override
  // void dispose() {
  //   // TODO: implement dispose

  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _userCredentials(),
        ],
      ),
    );
  }
}
