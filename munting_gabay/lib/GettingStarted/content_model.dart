class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent({required this.image, required this.title, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'What is Munting Gabay?',
      image: 'assets/images/2.png',
      discription: "Munting Gabay is a mobile application designed to provide comprehensive support"
          " and resources for individuals with Autism Spectrum Disorder (ASD) and their families. "
          "Its primary goal is to enhance awareness, offer guidance, and foster inclusion for those affected by ASD."
  ),
  UnbordingContent(
      title: 'Welcome to Munting Gabay',
      image: 'assets/images/2.png',
      discription: "Thank you for choosing us to support you on your journey."
  ),
  UnbordingContent(
      title: 'Reward surprises',
      image: 'assets/images/2.png',
      discription: "simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the "
          "industry's standard dummy text ever since the 1500s, "
          "when an unknown printer took a galley of type and scrambled it "
  ),
];
