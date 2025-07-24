import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gomiq/apis/auth_apis.dart';
import 'package:gomiq/helper_functions/web_toasts.dart';
import 'package:gomiq/provider/user_provider.dart';
import 'package:gomiq/theme/colors.dart';
import 'package:gomiq/widgets/custom_button.dart';
import 'package:gomiq/widgets/custom_text_feild.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  late Size mq;
  bool isLogin = true;


  // for log in
  bool isLShow  = false;
  bool isLLoading = false;

  final TextEditingController _usernameLController = TextEditingController();
  final TextEditingController _emailLController = TextEditingController();
  final TextEditingController _passwordLController = TextEditingController();


   // sign up

  bool isShow  = false;
  bool isLoading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> initAppData() async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await userProvider.initUser();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.theme['backgroundColor'],
        body: Column(
          children: [
            // Sticky navbar
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: Container(
                height: 70,
                width: mq.width,
                decoration: BoxDecoration(
                  color: AppColors.theme['backgroundColor'],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rounded logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/logo/logo.png",
                          height: 50,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Toggle Button
                      Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                          color:
                              AppColors.theme['primaryColor']!.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            // Sliding background
                            AnimatedAlign(
                              duration: Duration(milliseconds: 300),
                              alignment: isLogin
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Container(
                                  height: 40,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: AppColors.theme['primaryColor'],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() => isLogin = true);
                                      },
                                      child: Center(
                                        child: Text(
                                          "Login",
                                          style: GoogleFonts.poppins(
                                            color: isLogin
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() => isLogin = false);
                                      },
                                      child: Center(
                                        child: Text(
                                          "Register",
                                          style: GoogleFonts.poppins(
                                            color: isLogin
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Forms
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: isLogin ? _buildLoginForm() : _buildRegisterForm(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> handleLogin()async{



    final email = _emailLController.text.trim();
    final password = _passwordLController.text.trim();


    if(email=="" || password==""){
      WebToasts.showToastification("Warning", "Don't leave any field, fill all the given field to register", Icon(Icons.warning,color: Colors.yellow,), context);
      return ;
    }

    setState(() => isLLoading = true);


    final result = await AuthApis.signIn(email, password);

    setState(() => isLLoading = false);

    if (result.containsKey('user_id')) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', result['user_id']);
      initAppData() ;
      WebToasts.showToastification("Confirmation", "Logged In Successfully!", Icon(Icons.check_circle,color: Colors.green,), context);
      context.go('/chat');
    } else {

      WebToasts.showToastification(
        "Failed",
        "Login failed",
        const Icon(Icons.error_outline, color: Colors.red),
        context,
      );

    }
  }

  // Login form
  Widget _buildLoginForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            "assets/images/tem.png",
            height: 400,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          key: ValueKey('login'),
          height: 400,
          width: 300,
          decoration: BoxDecoration(
            color: AppColors.theme['backgroundColor'],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "L O G I N",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.theme['primaryColor']),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextFeild(
                  hintText: 'Enter email',
                  controller: _emailLController,
                  isNumber: false,
                  prefixicon: Icon(Icons.email_outlined),
                  obsecuretext: false,
                  onFieldSubmitted: (_) => handleLogin(),
                  textInputAction: TextInputAction.done,
                ),
                CustomTextFeild(
                  controller: _passwordLController,
                  hintText: 'Enter password',
                  isNumber: false,
                  prefixicon: Icon(Icons.password),
                  obsecuretext : isLShow,
                  suffix: IconButton(
                    icon: Icon(
                      isLShow ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isLShow = !isLShow;
                      });
                    },
                  ),
                  onFieldSubmitted: (_) => handleLogin(),
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomButton(
                  loadWidth: 200,
                  isLoading: isLLoading,
                  height: 50,
                  width: 300,
                  textColor: Colors.white,
                  bgColor: AppColors.theme['primaryColor'],
                  onTap:handleLogin,
                  title: 'Login',
                ),

                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> handleRegister()async{

    setState(() => isLoading = true);

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if(username=="" || email=="" || password==""){
      WebToasts.showToastification("Warning", "Don't leave any field, fill all the given field to register", Icon(Icons.warning,color: Colors.yellow,), context);
      setState(() => isLoading = false);
      return ;
    }

    final result = await AuthApis.signUp(username, email, password);

    setState(() => isLoading = false);

    if (result.containsKey('user_id')) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', result['user_id']);
      initAppData() ;
      WebToasts.showToastification("Confirmation", "Registered Successfully!", Icon(Icons.check_circle,color: Colors.green,), context);
      context.go('/chat');
    } else {

      WebToasts.showToastification(
        "Failed",
        "Registration failed",
        const Icon(Icons.error_outline, color: Colors.red),
        context,
      );

    }
  }

  // Register form
  Widget _buildRegisterForm() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            "assets/images/tem.png",
            height: 400,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          key: ValueKey('register'),
          height: 400,
          width: 300,
          decoration: BoxDecoration(
            color: AppColors.theme['backgroundColor'],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "R E G I S T E R",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.theme['primaryColor']),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextFeild(
                  hintText: 'Enter username',
                  isNumber: false,
                  controller: _usernameController,
                  prefixicon: Icon(Icons.drive_file_rename_outline),
                  obsecuretext: false,
                  onFieldSubmitted: (_) => handleRegister(),
                  textInputAction: TextInputAction.done,
                ),
                CustomTextFeild(
                  hintText: 'Enter email',
                  isNumber: false,
                  controller: _emailController,
                  prefixicon: Icon(Icons.email_outlined),
                  obsecuretext: false,
                  onFieldSubmitted: (_) => handleRegister(),
                  textInputAction: TextInputAction.done,
                ),
                CustomTextFeild(
                  hintText: 'Enter password',
                  isNumber: false,
                  controller: _passwordController,
                  prefixicon: Icon(Icons.password),
                  obsecuretext : isShow,
                  suffix: IconButton(
                    icon: Icon(
                      isShow ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isShow = !isShow;
                      });
                    },
                  ),
                  onFieldSubmitted: (_) => handleRegister(),
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomButton(
                  loadWidth: 200,
                  isLoading: isLoading,
                  height: 50,
                  width: 300,
                  textColor: Colors.white,
                  bgColor: AppColors.theme['primaryColor'],
                  onTap: handleRegister,
                  title: 'Register',
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}
