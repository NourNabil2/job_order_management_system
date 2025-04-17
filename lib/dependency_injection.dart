import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:quality_management_system/Features/auth/data/auth_data_source/auth_remote_data_source.dart';
import 'package:quality_management_system/Features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:quality_management_system/Features/auth/domain/repo/auth_repo.dart';
import 'package:quality_management_system/Features/auth/view/cubits/add_member_cubit/add_member_cubit.dart';
import 'package:quality_management_system/Features/auth/view/cubits/signin_cubit/signin_cubit.dart';
import 'package:quality_management_system/Features/auth/view/cubits/signup_cubit/signup_cubit.dart';

final sl = GetIt.instance;
void init() {
  // Firebase
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Data source
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()));

// Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Cubit
  sl.registerFactory(() => SigninCubit(sl()));
  sl.registerFactory(() => SignupCubit(sl()));
  sl.registerFactory(() => AddMemberCubit(sl()));
  
}
