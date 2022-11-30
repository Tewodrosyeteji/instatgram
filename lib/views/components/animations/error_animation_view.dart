import 'package:instatgram/views/components/animations/lottie_animation_view.dart';
import 'package:instatgram/views/components/animations/models/lottie_animation.dart';

class ErrorAnimationView extends LottieAnimationView {
  const ErrorAnimationView({super.key})
      : super(animation: LottieAnimation.error);
}
