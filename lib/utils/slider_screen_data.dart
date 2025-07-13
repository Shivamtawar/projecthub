import 'package:projecthub/view/intro_slider_screen/model/slider_info_model.dart';

class Utils {
  // static List<User> getUser() {
  //   return [
  //     User(
  //         name: "Prasad",
  //         image: "assets/person.png",
  //         email: "prasadxyz@gmail.com",
  //         phoneNo: '1234567895'),
  //   ];
  // }

  static List<Sliders> getSliderPages() {
    return [
      Sliders(
        image: 'assets/images/onboarding1st.png',
        name: 'Looking for ready-made solutions?',
        title:
            'Explore a vast library of high-quality templates, designs, and media created by talented professionals.',
      ),
      Sliders(
        image: 'assets/images/onboarding2nd.png',
        name: 'Got a masterpiece to share?',
        title:
            'Easily upload and sell your digital creations to a global audience. Turn your creativity into income!',
      ),
      Sliders(
        image: 'assets/images/onboarding3rd.png',
        name: 'Enjoy safe and hassle-free transactions.',
        title: 'Join our creative marketplace today!',
      ),
      // Sliders(
      //   image: 'assets/onboarding4th.png',
      //   name: 'Explore new reasources !',
      //   title:
      //       'Find best course for your career that will help you to develop your skill.',
      // ),
    ];
  }
}
