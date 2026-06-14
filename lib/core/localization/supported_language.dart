enum SupportedLanguage {
  english('en-IN', 'English'),
  hindi('hi-IN', 'Hindi'),
  tamil('ta-IN', 'Tamil'),
  telugu('te-IN', 'Telugu'),
  bengali('bn-IN', 'Bengali'),
  marathi('mr-IN', 'Marathi'),
  kannada('kn-IN', 'Kannada'),
  malayalam('ml-IN', 'Malayalam'),
  punjabi('pa-IN', 'Punjabi'),
  gujarati('gu-IN', 'Gujarati'),
  hinglish('hi-IN', 'Hinglish');

  const SupportedLanguage(this.speechLocale, this.label);

  final String speechLocale;
  final String label;
}
