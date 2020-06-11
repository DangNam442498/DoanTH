import 'package:flutter/material.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:recipes_app/auth/auth.dart';

import 'login_page.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({this.auth, this.onSignIn});
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

enum AuthStatus { notSignIn, signIn }

class _IntroScreenState extends State<IntroScreen> {
  AuthStatus _authStatus = AuthStatus.notSignIn;

  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((onValue) {
      setState(() {
        print(onValue);
        _authStatus = onValue == 'Chưa Đăng nhập'
            ? AuthStatus.notSignIn
            : AuthStatus.signIn;
      });
    });

    //Trang Slide 1
    slides.add(
      new Slide(
        title: "Giới thiệu",
        maxLineTitle: 2,
        styleTitle: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description: "Nội dung 1",
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        marginDescription:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
        centerWidget: Text("Trượt để vượt qua màn hình tiếp theo",
            style: TextStyle(color: Colors.white)),
        backgroundImage: 'assets/images/huevos.gif',
        onCenterItemPress: () {},
      ),
    );
    //Trang Slide 2
    slides.add(
      new Slide(
        title: "Bí mật của thế giới",
        styleTitle: TextStyle(
            color: Colors.blueAccent,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
            "Bánh quế, món tráng miệng, bánh ngọt, thực phẩm Thái Lan, Ả Rập, Mexico, Peru, Ý, Argentina ...",
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        backgroundImage: "assets/images/azucar.gif",
      ),
    );
  }

  void onDonePress() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage(
                auth: widget.auth,
                onSignIn: widget.onSignIn,
              )),
    );
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Colors.white,
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Colors.white,
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // Danh sách Slide
      slides: this.slides,

      // Nút bỏ qua
      renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: Colors.orangeAccent,
      highlightColorSkipBtn: Color(0xff000000),

      // Nút tiếp tục
      renderNextBtn: this.renderNextBtn(),

      // Nút hoàn thành
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      colorDoneBtn: Colors.blueAccent,
      highlightColorDoneBtn: Color(0xfF69303),

      // Thanh tiến trình
      colorDot: Colors.white,
      colorActiveDot: Colors.orangeAccent[200],
      sizeDot: 13.0,

      // Ẩn hiện thanh trạng thái
      shouldHideStatusBar: true,
      backgroundColorAllSlides: Colors.grey,
    );
  }
}
