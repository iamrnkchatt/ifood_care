import 'package:donationapp/screens/signin_screen.dart';
import 'package:donationapp/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UnbordingContent {
  String image;
  String title;
  String description;

  UnbordingContent(
      {required this.image, required this.title, required this.description});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'FOOD IS ESSENTIAL',
      image: 'assets/images/ev1.png',
      description:
          "Food is essentail for every human being and Food can save others’ life."),
  UnbordingContent(
      title: 'DON’T WASTE - SHARE',
      image: 'assets/images/ev2.png',
      description:
          "Whenever it’s possible we all have to share it with other’s before wasting it."),
  UnbordingContent(
      title: 'SAVE THE ENVIRONMENT',
      image: 'assets/images/ev3.png',
      description:
          "So we can write the benefit of the app and how we are also helping to save the environment."),
  UnbordingContent(
      title: 'DONATE',
      image: 'assets/images/ev4.png',
      description:
          "We are here like a bridge to connect donators with people who need it."),
  UnbordingContent(
      title: 'DONATE',
      image: 'assets/images/ev5.png',
      description:
          "We are here like a bridge to connect donators with people who need it."),
  UnbordingContent(
      title: 'DONATE',
      image: 'assets/images/ev6.png',
      description:
          "We are here like a bridge to connect donators with people who need it."),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;

  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignInScreen()));
                  },
                  child: (currentIndex == contents.length - 1)
                      ? const Text(
                          'Skip',
                          style: TextStyle(color: Colors.black),
                        )
                      : const Text(''))),
        ],
      ),
      body: Container(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Expanded(
                flex: 6,
                child: PageView.builder(
                    controller: _controller,
                    itemCount: 6,
                    onPageChanged: (int index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    itemBuilder: (_, i) {
                      return Container(
                        margin: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(contents[i].image)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                    }),
              ),
            ),
            Expanded(
              child: Container(
                child: (currentIndex == contents.length - 1)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 30,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const SignInScreen()));
                              },
                              child: const Text("Login"),
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromRGBO(
                                    5, 25, 55, 1), // background
                                onPrimary: Colors.white,
                                minimumSize: Size(100, 40),
                                //maximumSize: Size(width, height * 0.06),
                                // foreground
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 30),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                              },
                              child: const Text("Sign Up"),
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromRGBO(
                                    5, 25, 55, 1), // background
                                onPrimary: Colors.white,
                                minimumSize: Size(100, 40),
                                //maximumSize: Size(width, height * 0.06),
                                // foreground
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(contents.length,
                            (index) => buildDot(index, context)),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: currentIndex == index
                ? Color.fromRGBO(5, 25, 55, 1)
                : Colors.black),
        color:
            currentIndex == index ? Color.fromRGBO(5, 25, 55, 1) : Colors.white,
      ),
    );
  }
}
