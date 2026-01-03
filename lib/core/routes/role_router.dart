import '../../data/models/user_model.dart';
import 'app_router.dart';

String getDashboardRoute(UserRole role) {
  switch (role) {
    case UserRole.student:
      return AppRouter.home;

    case UserRole.teacher:
      return AppRouter.teacherDashboard;

    case UserRole.tutor:
      return AppRouter.tutorMarketplace;

    case UserRole.parent:
      return AppRouter.parentDashboard;
  }
}
