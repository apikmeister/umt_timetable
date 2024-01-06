import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:umt_timetable/constants/onboarding_data.dart';
import 'package:umt_timetable/model/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currPage = 0;
  late PageController _controller;
  List<OnboardingModel> items = OnboardingData.data;

  onPageChange(int page) {
    currPage = page;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 20),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text(
                'Skip',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: PageView.builder(
                onPageChanged: onPageChange,
                itemCount: items.length,
                controller: _controller,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Lottie.asset(
                              items[index].animUrl,
                              repeat: false,
                              reverse: false,
                              animate: false,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Text(
                                items[index].title,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  items[index].description,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Visibility(
                        //   visible: currPage == items.length - 1,
                        //   child: ElevatedButton(
                        //     onPressed: () {
                        //       Navigator.pushNamed(context, '/home');
                        //     },
                        //     child: Text('Get Started'),
                        //   ),
                        // ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.only(bottom: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildIndicator(),
              ),
            ),
            // Container(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       for (int i = 0; i < items.length; i++)
            //         if (i == currPage)
            //           const Padding(
            //             padding: EdgeInsets.all(5),
            //             child: CircleAvatar(
            //               radius: 5,
            //               backgroundColor: Colors.black,
            //             ),
            //           )
            //         else
            //           const Padding(
            //             padding: EdgeInsets.all(5),
            //             child: CircleAvatar(
            //               radius: 5,
            //               backgroundColor: Colors.grey,
            //             ),
            //           )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 30 : 6,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < 3; i++) {
      if (currPage == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }

    return indicators;
  }
}
