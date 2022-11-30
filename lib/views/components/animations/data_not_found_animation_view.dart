import 'package:flutter/material.dart';

import 'package:instatgram/views/components/animations/lottie_animation_view.dart';
import 'models/lottie_animation.dart';

class DataNotFoundAnimationView extends LottieAnimationView {
  const DataNotFoundAnimationView({super.key})
      : super(animation: LottieAnimation.dataNotFound);
}
